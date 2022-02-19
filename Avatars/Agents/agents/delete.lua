accessory = false
network.registerPing("skinSwitch")

word1 = "Enable"
item1 = "minecraft:gray_dye"
action_wheel.SLOT_1.setTitle(word1.." Vanilla Skin")
action_wheel.SLOT_1.setItem(item_stack.createItem(item1))

action_wheel.SLOT_1.setFunction(
function() 
	accessory = not accessory
	sound.playSound("minecraft:ui.button.click", {playerPos.x,playerPos.y,playerPos.z, 0.125, 1})
	if accessory then
		word1 = "Disable"
		item1 = "minecraft:lime_dye"
	else
		word1 = "Enable"
		item1 = "minecraft:gray_dye"
	end
	action_wheel.SLOT_1.setTitle(word1.." Vanilla Skin")
	action_wheel.SLOT_1.setItem(item_stack.createItem(item1))
	network.ping("skinSwitch", accessory)
end)

function skinSwitch(val)
	accessory = val
	for key, value in pairs(vanilla_model) do 
		value.setEnabled(val)
	end
	model.Player.setEnabled(not val)
end

network.registerPing("mute")

item2 = item_stack.createItem("minecraft:note_block")
word2 = "Mute"
action_wheel.SLOT_2.setItem(item2)
action_wheel.SLOT_2.setTitle(word2.." Flap Sounds")
action_wheel.SLOT_2.setFunction(function() 
	muted = not muted
	sound.playSound("minecraft:ui.button.click", {playerPos.x,playerPos.y,playerPos.z, 0.125, 1})
	if muted then
		word2 = "Unmute"
	else
		word2 = "Mute"
	end
	action_wheel.SLOT_2.setTitle(word2.." Flap Sounds")
	network.ping("mute",muted)
end)

muted = false
function mute(val) 
	muted = val
end

function player_init()
	pressed = false
	for key, value in pairs(vanilla_model) do 
		value.setEnabled(accessory)
	end
	model.Player.setEnabled(not accessory)
end
SMOOTHNESS = 0.25 -- <-- the proportion that the wings move towards the "target position" every frame
velocity = vectors.of{0,0,0} -- <-- defining variables to use in the rest of the code.
lastpos = vectors.of{0,0,0} 
speed = 0
lastSpeed = 0

wingRot = vectors.of{0,0,90}
lastWingRot = vectors.of{0,0,0}
joint1Rot = vectors.of{0,0,0}
lastJoint1Rot = vectors.of{0,0,0}
joint2Rot = vectors.of{0,0,0}
lastJoint2Rot = vectors.of{0,0,0}

spread = false -- <-- used to determine whether the wings should be in spread mode or folded mode
speedFactor = 0.7 -- <-- multiplier so that the max speed it registers is about the speed of rocket boost
chestplateRot = 0

function clamp(value,low,high) -- <-- if the variable is lower than the lower limit or higher than the higher limit, sets it to the limit.
    return math.min(math.max(value, low), high)
end

function lerp(a, b, x) -- <-- linear interpolation, gives a number between a and b, if x is close to 0 it is closer to a, if x is close to 1 it is closer to b
  return a + (b - a) * x
end

--this disables the elytra
elytra_model.LEFT_WING.setEnabled(false) 
elytra_model.RIGHT_WING.setEnabled(false)

cooldown = 10
counter = cooldown
pressed = false
flapkey = keybind.newKey("Wing Flap", "R")
network.registerPing("FlapKey")
function FlapKey()
    pressed = true
end


hurtTicker = 0
function healthcheck(health)
	if (health == 0 and not dead) then
		dead = true
	else
		if health < lastHealth then
			hurtTicker = 5
		else
			if health == player.getMaxHealth() then
				dead = false
			end
		end
	end
	if hurtTicker ~= 0 then
		hurtTicker = hurtTicker-1
	end
	lastHealth = health
end
function wingFlap()
	nbt = player.getNbtValue("cardinal_components.apoli:powers.Powers")
	if nbt ~= nil then
		for i, v in pairs(nbt) do
			if v["type"] == "origins:launch_into_air" then
				tag = v["data"]
				used = (tag ~= lastTag)
				lastTag = tag
			end
		end
	end
	if (pressed or hurtTicker ~= 0 or used) and not flapping then
		flapping = true
		if not muted then
			sound.playSound('entity.ender_dragon.flap',{playerPos.x,playerPos.y,playerPos.z,0.75,1})
		end
	end
	if flapping and counter < cooldown then
		counter = counter + 1
		if counter > 0 and counter < 6 then
			flap = 60
		else
			flap = 0
		end
	else
		if counter == cooldown then
			counter = 0
			pressed = false
			flapping = false
		end
	end
end
flap = 0
ticker = 0
tailRot = -10
lastHealth = 0
--tick stuff happens every tick, it's much more efficient to do stuff here than in render
function tick()
	playerPos = player.getPos()
	if flapkey.wasPressed() and not pressed then
		network.ping("FlapKey")
	end
	
	healthcheck(player.getHealth())
	
	-- calculates velocity by seeing the difference between where the player was a tick ago and where they are now. getVelocity does not work in multiplayer
	velocity = vectors.of{player.getPos()[1] - lastpos[1], player.getPos()[2] - lastpos[2], player.getPos()[3] - lastpos[3]}
	lastpos = player.getPos()
	-- velocity is x speed, y speed, z speed. this makes it into a single number.
	speed = math.abs(math.sqrt(math.pow(velocity[1],2) + math.pow(velocity[2],2) + math.pow(velocity[3],2)))*speedFactor

	-- clamping speed prevents wacky rotations if the player goes REALLY fast
	speed = clamp(speed,0,1)
  -- asks if should spread be on?
	if ((speed >= 0.45 and player.getAnimation() == "STANDING") or player.isSneaky()) or (player.getAnimation() == "FALL_FLYING") or flapping then
		spread = true
		if not opened and not muted then
			opened = true
		end
	else
		spread = false
		opened = false
	end
	wingFlap()
	if player.getEquipmentItem(4) == "minecraft:air" then
		chestplateRot = 1
	else
		chestplateRot = 0
	end
	if pressed then
		speed = 0.75
	end
	lastWingRot = wingRot
	lastJoint1Rot = joint1Rot
	lastJoint2Rot = joint2Rot
	if spread then
		-- designates two sets of rotations - one for the semi-folded crouch for dramatic effect, one for the fully spread wings
		-- interpolates between them depending on speed
		if player.getAnimation() == "FALL_FLYING" and player.getLookDir().y < 0 then
			wingRot = vectors.of{-3+flap/2,9,lerp(52,0,speed)}
			joint1Rot = vectors.of{0+flap/2,lerp(20,5,speed)-flap*1.125,lerp(-104,0,speed)}
			joint2Rot = vectors.of{lerp(-20,0,speed)+flap/2,lerp(-60,-5,speed)-flap*1.125,lerp(46,0,speed)}
		else
			wingRot = vectors.of{-3+flap/10,9,lerp(52,0,speed)}
			joint1Rot = vectors.of{0-flap/2,lerp(20,5,speed)-flap*2,lerp(-104,0,speed)}
			joint2Rot = vectors.of{lerp(-20,0,speed),lerp(-60,-5,speed)-flap,lerp(46,0,speed)}
		end
		targetTailRot = -flap/2-5
	else
		-- designates target so that wings move in for folding animation. lerping so that the folded wings move back a bit when sprinting on the ground.
		-- the folded wings use the same rotations as the shoulder joints.
		wingRot = vectors.of{lerp(10 - 10*chestplateRot,150,speed),5,lerp(90,45,speed)}
		joint1Rot = vectors.of{0,-5,-180}
		joint2Rot = vectors.of{0,75,140}
		targetTailRot = clamp(-wingRot[1],-100,-10)
	end
	
	-- this bit moves the actual position of the wing a bit from the last position to the target position. the amount it moves is determined by SMOOTHNESS>
	wingRot = vectors.lerp(lastWingRot, wingRot, SMOOTHNESS)
	joint1Rot = vectors.lerp(lastJoint1Rot, joint1Rot, SMOOTHNESS)
	joint2Rot = vectors.lerp(lastJoint2Rot, joint2Rot, SMOOTHNESS)
	tailRot = lerp(tailRot,targetTailRot,SMOOTHNESS)
	-- determines whether the wings should display folded depending on one of the rotations.
	-- IMPORTANT: if you change the rotations, you might need to change this as well! 
    if wingRot.y < 6 then
        model.TORSO.LW.setEnabled(false)
        model.TORSO.RW.setEnabled(false)
        model.TORSO.foldedL.setEnabled(true)
        model.TORSO.foldedR.setEnabled(true)
		model.TORSO.Tail.setUV({15/128,0})
    else
        model.TORSO.LW.setEnabled(true)
        model.TORSO.RW.setEnabled(true)
        model.TORSO.foldedL.setEnabled(false)
        model.TORSO.foldedR.setEnabled(false)
        model.TORSO.Tail.setUV({0,0})
    end
	lastTailRot = tailRot
end
lastTailRot = 0
function render(delta)
    model.TORSO.LW.setRot(vectors.lerp(lastWingRot,wingRot,delta))
    model.TORSO.LW.joint1L.setRot(vectors.lerp(lastJoint1Rot,joint1Rot,delta))
    if joint2Rot ~= nil then
        model.TORSO.LW.joint1L.joint2L.setRot(vectors.lerp(lastJoint2Rot,joint2Rot,delta))
    end

    model.TORSO.RW.setRot({lerp(lastWingRot[1],wingRot[1],delta), -lerp(lastWingRot[2],wingRot[2],delta), -lerp(lastWingRot[3],wingRot[3],delta)})
    model.TORSO.RW.joint1R.setRot({lerp(lastJoint1Rot[1],joint1Rot[1],delta), -lerp(lastJoint1Rot[2],joint1Rot[2],delta), -lerp(lastJoint1Rot[3],joint1Rot[3],delta)})
    model.TORSO.RW.joint1R.joint2R.setRot({lerp(lastJoint2Rot[1],joint2Rot[1],delta), -lerp(lastJoint2Rot[2],joint2Rot[2],delta), -lerp(lastJoint2Rot[3],joint2Rot[3],delta)})

    model.TORSO.foldedL.setRot({-lerp(lastWingRot[1],wingRot[1],delta), lerp(lastWingRot[2],wingRot[2],delta), clamp((lerp(lastWingRot[3],wingRot[3],delta)-90),-5,0)})
    model.TORSO.foldedR.setRot({-lerp(lastWingRot[1],wingRot[1],delta), -lerp(lastWingRot[2],wingRot[2],delta), clamp((-(lerp(lastWingRot[3],wingRot[3],delta)-90)),0,5)})
    
    model.TORSO.Tail.setRot({lerp(lastTailRot,tailRot,delta)-15,0,0})
end