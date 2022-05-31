--[[--============================================================================--
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
]] -- ============================================================================--[[
scale = 0.6

nameplate.ENTITY.setPos {0, 0, 0}

action_wheel.SLOT_1.setTitle("Hello")
action_wheel.SLOT_1.setFunction(function ()
    ping.hello(math.floor(math.random()+1.5))
end)

action_wheel.SLOT_2.setTitle("Random Thought")
action_wheel.SLOT_2.setFunction(function ()
    ping.randomThought(math.random(math.lerp(1,3,math.random())+0.5))
end)

action_wheel.SLOT_3.setTitle("dont just stand there")
action_wheel.SLOT_3.setFunction(function ()
    ping.accident()
end)

action_wheel.SLOT_4.setTitle("Scream")
action_wheel.SLOT_4.setFunction(function ()
    ping.hurt(4)
end)

animation.flying.setBlendTime(0.2)
animation.falling.setBlendTime(0.2)

ping.randomThought = function (id)
    sound.playCustomSound("random"..tostring(id),player.getPos(),{2,1})
end

ping.hello = function (id)
    sound.playCustomSound("hello"..tostring(id),player.getPos(),{2,1})
end

ping.accident = function ()
    sound.playCustomSound("accident",player.getPos(),{2,1})
end

ping.hurt = function (id)
    sound.playCustomSound("pain"..tostring(id),player.getPos(),{1,1})
end


for _, v in pairs(vanilla_model) do v.setEnabled(false) end

for _, v in pairs(armor_model) do v.setEnabled(false) end
SMTimer = 0

lastHealth = 0
lastHeldItem = nil
currentHeldItem = nil
delay = 50
finishedDelay = false

function tick()
    if delay > 0 then
        delay = delay - 1
    else
        finishedDelay = true
    end
    currentHeldItem = player.getEquipmentItem("1").getType()
    if currentHeldItem ~= lastHeldItem then
        if finishedDelay then
            sound.playCustomSound("equip",player.getPos(),{1,1})
        end
        animation.equip.play()
        lastHeldItem = currentHeldItem
    end
    local Health = player.getHealth()
    if lastHealth > Health then
        sound.playCustomSound("pain"..tostring(math.floor(math.lerp(3,8,math.random())+0.5)),player.getPos(),{1,1})
    end
    lastHealth = Health

    if vanilla_model.LEFT_ARM.getOriginRot().y ~= 0 and player.getAnimation() == "STANDING" then
        setState("interact", "interact")
    else
        setState("interact", nil)
    end
    if player.getVehicle() ~= nil then
        setState("animation", "sit")
    else
        if player.isOnGround() then
            if (player.getVelocity() * vectors.of {1, 0, 1}).distanceTo(
                vectors.of {0, 0, 0}) > 0.03 then
                setState("animation", "walk_forward")
            else
                setState("animation", "idle")
            end
        else
            if player.getVelocity().y > 0 then
                setState("animation", "flying")
            else
                setState("animation", "falling")
            end
        end
    end

    SMTimer = SMTimer + 1
    if SMTimer > 0 then
        stateChanged("animation")
        stateChanged("interact")
        SMTimer = 0
    end
end

function world_render(delta)
    model.WalterHimself.Torso.Hed.setRot((player.getRot(delta)-vectors.of{0,player.getBodyYaw(delta),0})*vectors.of{-1,-1,1})
end

SM_states = {current = {}, last = {}}

---Declares the state machine and sets the state machine
function setState(state_machine_name, state_value)
    if SM_states.last[state_machine_name] ~= state_value or
        SM_states.last[state_machine_name] == nil then
        SM_states.current[state_machine_name] = state_value
    end
end

queued = {}

---Returns the curent and last state in the selected state machine, in a table:  
---`{current,last}`
function getState(state_machine_name)
    return {
        current = SM_states.current[state_machine_name],
        last = SM_states.last[state_machine_name]
    }
end

---Returns true if the state was changed.
function stateChanged(state_machine_name)
    local currentState = SM_states.current[state_machine_name]
    local lastState = SM_states.last[state_machine_name]

    local stateChanged = (lastState ~= currentState)
    -- [If you want to trigger something when the state changed, un comment the code bellow] --
    if stateChanged then
        if SM_states.last[state_machine_name] ~= nil then
            if animation[SM_states.last[state_machine_name]] then
                animation[SM_states.last[state_machine_name]].stop()
            end
        end
        if SM_states.current[state_machine_name] ~= nil then
            if animation[SM_states.current[state_machine_name]] then
                animation[SM_states.current[state_machine_name]].play()
            end
        end

        if not queued[state_machine_name] then
            queued[state_machine_name] = {}
        end
        SM_states.last[state_machine_name] =
            SM_states.current[state_machine_name]
        table.insert(queued[state_machine_name],
                     SM_states.current[state_machine_name])
    end
    return stateChanged
end

