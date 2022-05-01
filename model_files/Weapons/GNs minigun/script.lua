--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
]]--======================================================================---------

OP_MODE = false

break_blocks = {"glass","bedrock"}

--========================================================================----------
model.NO_PARENT.leftArm.Ldef.setTexture("Skin")
model.NO_PARENT.leftArm.Lslim.setTexture("Skin")
model.NO_PARENT.rightArm.Rdef.setTexture("Skin")
model.NO_PARENT.rightArm.Rslim.setTexture("Skin")
model.NO_PARENT.leftArm.setExtraTexEnabled(false)
model.NO_PARENT.rightArm.Rdef.setExtraTexEnabled(false)
model.NO_PARENT.rightArm.Rslim.setExtraTexEnabled(false)
model.NO_PARENT.rightArm.minigun.setTexture("Custom")

for i = 1, 10, 1 do
    model.NO_PARENT["bullet"..i].setPos{6,-6,-4}
    animation["bullet"..i].setBlendTime(0)
end



shoot = keybind.newKey("Shoot","MOUSE_BUTTON_2")
wasShooting = false
shooting = false

network.registerPing("toggleShoot")

barrelLastRotation = 0
barrelRotation = 0
barrelVelocity = 0

shootCooldown = 0
shootDelay = 1

bullet = 0

lastGunRotation = vectors.of{}
GunRotation = vectors.of{}

isHoldingGun = false
wasHoldingNothing = false

function toggle(x)
    model.NO_PARENT.setEnabled(x)
    vanilla_model.LEFT_ARM.setEnabled(not x)
    vanilla_model.RIGHT_ARM.setEnabled(not x)
    vanilla_model.LEFT_SLEEVE.setEnabled(not x)
    vanilla_model.RIGHT_SLEEVE.setEnabled(not x)
end

function toggleShoot(x)
    shooting = x
end

function player_init()
    toggle(true)
    local slim = player.getModelType() == "slim"
        model.NO_PARENT.leftArm.Ldef.setEnabled(not slim)
        model.NO_PARENT.leftArm.Lslim.setEnabled(slim)
        model.NO_PARENT.rightArm.Rdef.setEnabled(not slim)
        model.NO_PARENT.rightArm.Rslim.setEnabled(slim)
end

function tick()
    model.NO_PARENT.setEnabled(player.getEquipmentItem(1).getType() == "minecraft:air")
    if player.getEquipmentItem(1).getType() == "minecraft:air" ~= wasHoldingNothing then
        if not wasHoldingNothing then
            toggle(true)
            animation.intro.play()
            isHoldingGun = true
            if player.getName() == "GNamimates" then
                nameplate.ENTITY.setText("GUNamimates")
                nameplate.CHAT.setText("GUNamimates")
                nameplate.LIST.setText("GUNamimates")
            end
        else
            toggle(false)
            isHoldingGun = false
            if player.getName() == "GNamimates" then
                nameplate.ENTITY.setText("GNamimates")
                nameplate.CHAT.setText("GNamimates")
                nameplate.LIST.setText("GNamimates")
            end
        end
        
    end

    wasHoldingNothing = player.getEquipmentItem(1).getType() == "minecraft:air"
    
    if isHoldingGun then
        lastGunRotation = GunRotation
        GunRotation = vectors.lerp(GunRotation,player.getRot()*vectors.of{-1,-1,1}+vectors.of{0,180,0},0.5)
        if client.isHost() then
            if shoot.isPressed() ~= wasShooting then
                network.ping("toggleShoot",not wasShooting)
            end
            wasShooting = shoot.isPressed()
        end
        barrelLastRotation = barrelRotation
        if shooting then
            barrelVelocity = math.lerp(barrelVelocity,60,0.1)
        else
            barrelVelocity = math.lerp(barrelVelocity,0,0.1)
            if barrelVelocity == 0 then
                barrelRotation = 0
                barrelLastRotation = 0
            end
        end
    
        barrelRotation = (barrelRotation + barrelVelocity)
        model.NO_PARENT.rightArm.minigun.piewPiewHole.bullet.setEnabled(false)
    
        if barrelVelocity > 55 then
            shootCooldown = shootCooldown + 1
            if shootCooldown > shootDelay then
                shootCooldown = 0
                local ray = renderer.raycastBlocks(player.getPos()+vectors.of{0,player.getEyeHeight()-0.5}, player.getPos()+vectors.of{0,player.getEyeHeight()-0.5}+player.getLookDir()*100, "COLLIDER", "NONE")
                local rayEntity = renderer.raycastEntities(player.getPos()+vectors.of{0,player.getEyeHeight()-0.5}+player.getLookDir()*2, player.getPos()+vectors.of{0,player.getEyeHeight()-0.5}+player.getLookDir()*100)
                if rayEntity and OP_MODE then
                    chat.sendMessage("/kill "..rayEntity.entity.getUUID())
                end
                
                model.NO_PARENT.rightArm.minigun.piewPiewHole.bullet.setEnabled(true)
                sound.playSound("minecraft:block.stone.break",player.getPos(),{1,2})
                animation.shoot.play()
                bullet = (bullet + 1)%9
                animation["bullet"..tostring(bullet+1)].play()
                if ray then
                    model.NO_PARENT.rightArm.minigun.piewPiewHole.bullet.setScale({1,1,(ray.pos.distanceTo(player.getPos()+vectors.of{0,player.getEyeHeight()})-1.7)*16})
                    
                    if OP_MODE then
                        local destroy = false
                        for key, value in pairs(break_blocks) do
                            if string.find(world.getBlockState(ray.pos+player.getLookDir()).name,value) then
                                destroy = true
                            end
                        end
                        if destroy then
                            chat.sendMessage("/setblock "..math.floor(ray.pos.x+player.getLookDir().x).." "..math.floor(ray.pos.y+player.getLookDir().y).." "..math.floor(ray.pos.z+player.getLookDir().z).." air destroy")
                        end
                    end
                else
                    model.NO_PARENT.rightArm.minigun.piewPiewHole.bullet.setScale({1,1,10000})
                end
            end
        end
    end    
end

function world_render(delta)
    model.NO_PARENT.setPos((player.getPos(delta)+vectors.of{0,player.getEyeHeight()})*vectors.of{-16,-16,16})
    model.NO_PARENT.setRot(vectors.lerp(lastGunRotation,GunRotation,delta))
    model.NO_PARENT.rightArm.minigun.barrel.setRot(vectors.of{0,0,math.lerp(barrelLastRotation,barrelRotation,delta)})
    model.NO_PARENT.rightArm.minigun.piewPiewHole.muzzleFlash.setEnabled(animation.shoot.isPlaying())
end