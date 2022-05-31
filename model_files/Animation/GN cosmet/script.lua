---@diagnostic disable: undefined-global, undefined-field
----= GN =[ CONFIG ]= GN =--

LDM = false
LDMDistance = 256

debugMode = true

hideItems = {"sword","shield"}
-->==========[ ANIMATION TAGS ]==========<--
snappedToBlockAnimations = {"sitDown","sitSwing"}
animalSitType = {"minecart","horse","llama","pig","dragon","chicken"}
-->==========[ GENERIC ]==========<--
rotation = nil
lastRotation = vectors.of({})
velocity = nil
lastVelocity = nil
distanceVelociy = 0
distanceTraveled = 0
snapToBlocks = false
tiltMovementStrength = 0

-->==========[ VEHICLE ]==========<--
isAnimalSitting = false
lastVehicleType = ""

timeSinceLastUpdate = 0
timeSinceElytra = 0

isSwingingArm = false
wasSwingingArm = false

wasWearingElytra = false
wasUsingShield = false
isSwordOpen = false
wasActionWheelOpen = false
wasChatOpen = true
isChatOpen = false
p = false
debugActionRow = {}

boomBoxPos = nil

keybind.attack = keybind.getRegisteredKeybind("key.attack")
keybind.use = keybind.getRegisteredKeybind("key.use")

lastAnimation = {}
currentAnimation = {}

queuedAnimations = {}



hair = {
    backL = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair.LHL,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backM= {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair.LHM,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backR = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair.LHR,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backBoffset = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair.HBoffset,
        restForce = 0.1,
        waveMult = 0.1,
        friction = 0.9,
    },
    backB = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair.HBoffset.HairBackBottom,
        restForce = 0.07,
        waveMult = 0.1,
        friction = 0.9,
    },
    frontL1 = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.hairline1,
        restForce = 0.1,
        waveMult = vectors.of({0.2,1,-0.1}),
        friction = 0.9,
    },
    frontL2 = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.hairline1.hairline2,
        restForce = 0.07,
        waveMult = vectors.of({0.2,1,-0.12}),
        friction = 0.9,
    },
    hairlineRight = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.hairlineRight,
        restForce = 0.1,
        waveMult = vectors.of({0.11,1,-0.05}),
        friction = 0.6,
    },
    hairlineLeft = {
        physics = true,
        velocity = vectors.of({0,0,0}),
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.hairlineLeft,
        restForce = 0.09,
        waveMult = vectors.of({0.1,1,-0.05}),
        friction = 0.6,
    },
    longHair = {
        physics = false,
        rotation = vectors.of({0,0,0}),
        lastRotation = vectors.of({0,0,0}),
        model = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.longHair,
    },
}
---==== ACCESSORIES ====---
accessories = {
    topHat = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_topHat,
    glasses = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_glasses,
    catEars = model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_catEars,
    wings = model.NO_PARENT_BASE.SCALE.ORIGIN.B.WINGS,
    shield = model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.SHIELD_BASE,
    particle = {
        Z1 = model.NO_PARENT_BASE.SCALE.ORIGIN.sleepingIcons1,
        Z2 = model.NO_PARENT_BASE.SCALE.ORIGIN.sleepingIcons2,
    }
}

function applyColor(table)
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_glasses.setColor(table[3])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_ringmaster.setColor(table[1])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.HAIR.setColor(table[2])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.B_JACKET.setColor(table[4])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.AL_JACKET.setColor(table[4])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.AR_JACKET.setColor(table[4])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.B_SHIRT.setColor(table[5])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.AL_SHIRT.setColor(table[5])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.AR_SHIRT.setColor(table[5])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.ALL_SHIRT.setColor(table[5])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.ARL_SHIRT.setColor(table[5])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.B_accessory.B_ringmaster.setColor(table[4])
    model.NO_PARENT_BASE.SCALE.ORIGIN.LL.setColor(table[6])
    model.NO_PARENT_BASE.SCALE.ORIGIN.LR.setColor(table[6])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.ALL_accessory.setColor(table[8])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.ARL_accessory.setColor(table[8])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.AR_accessory.setColor(table[8])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.AL_accessory.setColor(table[8])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.ARL_GLOVES.setColor(table[9])
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.ALL_GLOVES.setColor(table[9])

end
--[[
1. HAT
2. HAIR
3. GLASSES
4. JACKET
5. SHIRT
6. PANTS
7. SHOES
8. RING/SHOULDERS
9.GLOVES
]]--
---=====================-=--

function player_init()
    nameplate.ENTITY.setEnabled(true)
    localSwitchTo("shield_hidden","SHIELD")
    currentAnimation["SHIELD"] = "shield_hidden"
    localSwitchTo("wings_hidden","WINGS")
    model.DEBUG_MENU_NO_PARENT.setEnabled(debugMode)
    if debugMode then
        reloadDebugMenu()
    end
    elytra_model.LEFT_WING.setEnabled(false)
    elytra_model.RIGHT_WING.setEnabled(false)
    lastRotation = player.getRot()
    rotation = player.getRot()

    for _, v in pairs(vanilla_model) do
        v.setEnabled(false)
    end

    for key, value in pairs(armor_model) do
        value.setEnabled(false)
    end
    for key, value in pairs(animation) do
        if type(value) == "table" then
            value.setBlendTime(0.05)
        end
    end
--    animation.attack2.setBlendTime(0.001)
--    animation.attack3.setBlendTime(0.001)

--    animation.eating.setBlendTime(0.3)
    animation["speechBubble_outro"].setBlendTime(0)
    animation["speechBubble_intro"].setBlendTime(0)

    animation.swordIdle.setPriority(1)
    animation.swordIdle.setBlendTime(0.01)

    animation.swordAttack.setPriority(2)
--    animation.swordAttack.setBlendTime(0.01)
    animation.swordAttack.setSpeed(2)
    animation.swordSlam.setPriority(2)
    animation.swordSlam.setBlendTime(0.01)
    animation.swordSlam.setSpeed(2)
    animation.swordSlam.setSpeed(2)
    animation.Carmalledansen.setSpeed(1.4)

    animation.VehicleSit.setPriority(2)
    animation.AnimalVehicleSit.setPriority(2)
--    animation.wings_intro.setBlendTime(0)
--    animation.wings_outro.setBlendTime(0)
--    animation.wings_idle.setBlendTime(0)
--    animation.wings_hidden.setBlendTime(0)
end
-->========================================[ ACTION WHEEL ]=========================================<--
do
    action_wheel_pages = {}

    local location = nil
    local page = 1

    local toggle_ping_id = 0

    local function renderSlot(slot, element)
        slot.setTitle(element.title)
        slot.setItem(element.item)
        slot.setHoverItem(element.hoverItem)
        slot.setColor(element.color)
        slot.setHoverColor(element.hoverColor)
        slot.setFunction(element.func) -- can be nil for folders
    end

    local function update()
        if location == nil then return end

        local requireMultiplePages = (#location.contents > 8) or
                                         (location.back ~= nil)
        local pageSize = 8

        if requireMultiplePages then
            pageSize = 6

            action_wheel.SLOT_4.setFunction(function()
                page = page + 1
                if page > math.ceil(#location.contents / 6) then
                    page = math.ceil(#location.contents / 6)
                end
                if #location.contents == 0 then page = 1 end
                update()
            end)
            action_wheel.SLOT_5.setFunction(function()
                page = page - 1
                if page < 1 then page = 1 end
                update()
            end)

            if page == math.ceil(#location.contents / 6) or #location.contents ==
                0 then
                action_wheel.SLOT_4.setItem("minecraft:air")
                action_wheel.SLOT_4.setTitle("")
            else
                action_wheel.SLOT_4.setItem("minecraft:arrow")
                action_wheel.SLOT_4.setTitle("Next")
            end

            if page == 1 then
                if location.back == nil then
                    action_wheel.SLOT_5.setItem("minecraft:air")
                    action_wheel.SLOT_5.setTitle("")
                else
                    action_wheel.SLOT_5.setItem("minecraft:dark_oak_door")
                    action_wheel.SLOT_5.setTitle("Exit")
                    action_wheel.SLOT_5.setFunction(function()
                        location = location.back
                        page = 1
                        update()
                    end)
                end
            else
                action_wheel.SLOT_5.setItem("minecraft:arrow")
                action_wheel.SLOT_5.setTitle("Previous")
            end
        end

        local slotid = 1
        for i = page * pageSize - (pageSize - 1), page * pageSize, 1 do
            if i <= #location.contents then
                renderSlot(action_wheel["SLOT_" .. slotid], location.contents[i])
                if location.contents[i].type == "folder" then
                    action_wheel["SLOT_" .. slotid].setFunction(function()
                        location = location.contents[i]
                        page = 1
                        update()
                    end)
                end
            else
                renderSlot(action_wheel["SLOT_" .. slotid], {})
            end
            slotid = slotid + 1
            if slotid == 4 and requireMultiplePages then
                slotid = slotid + 2
            end
            if slotid > 8 then slotid = 1 end
        end
    end

    function action_wheel_pages.createFolder(title, item)
        local ret = {
            type = "folder",
            contents = {},
            back = nil,

            title = title,
            item = item,
            hoverItem = nil,
            color = nil,
            hoverColor = nil
        }
        ret.add = function(element)
            if element.type == "folder" then element.back = ret end
            table.insert(ret.contents, element)
        end
        ret.remove = function(element)
            for k, v in pairs(ret.contents) do
                if v == element then ret.contents[k] = nil end
            end
        end
        ret.setTitle = function(title) ret.title = title end
        ret.getTitle = function() return ret.title end
        ret.setItem = function(item) ret.item = item end
        ret.getItem = function() return ret.item end
        ret.setHoverItem = function(hoverItem) ret.hoverItem = hoverItem end
        ret.getHoverItem = function() return ret.hoverItem end
        ret.setColor = function(color) ret.color = color end
        ret.getColor = function() return ret.color end
        ret.setHoverColor = function(color) ret.hoverColor = color end
        ret.getHoverColor = function() return ret.hoverColor end
        ret.clear = function()
            ret = {
                type = "folder",
                contents = {},
                back = nil,

                title = nil,
                item = nil,
                hoverItem = nil,
                color = nil,
                hoverColor = nil
            }
        end
        return ret
    end

    function action_wheel_pages.createItem(title, item)
        local ret = {
            type = "item",
            func = nil,

            title = title,
            item = item,
            hoverItem = nil,
            color = nil,
            hoverColor = nil
        }
        ret.setFunction = function(func) ret.func = func end
        ret.getFunction = function(func) ret.func = func end
        ret.setTitle = function(title) ret.title = title end
        ret.getTitle = function() return ret.title end
        ret.setItem = function(item) ret.item = item end
        ret.getItem = function() return ret.item end
        ret.setHoverItem = function(hoverItem) ret.hoverItem = hoverItem end
        ret.getHoverItem = function() return ret.hoverItem end
        ret.setColor = function(color) ret.color = color end
        ret.getColor = function() return ret.color end
        ret.setHoverColor = function(color) ret.hoverColor = color end
        ret.getHoverColor = function() return ret.hoverColor end
        ret.clear = function()
            ret = {
                type = "item",
                func = nil,

                title = nil,
                item = nil,
                hoverItem = nil,
                color = nil,
                hoverColor = nil
            }
        end
        ret.toggleVar = function(variable, on_text, on_icon, off_text, off_icon)
            local _toggle_ping_id = toggle_ping_id
            network.registerPing("action_wheel_toggleVar_ping_" ..
                                     _toggle_ping_id)
            ret.setFunction(function()
                network.ping("action_wheel_toggleVar_ping_" .. _toggle_ping_id,
                             not _G[variable])
            end)
            _G["action_wheel_toggleVar_ping_" .. _toggle_ping_id] = function(x)
                _G[variable] = x
                if _G[variable] then
                    ret.setTitle(off_text)
                    ret.setItem(off_icon)
                else
                    ret.setTitle(on_text)
                    ret.setItem(on_icon)
                end
                update()
            end
            _G["action_wheel_toggleVar_ping_" .. _toggle_ping_id](_G[variable])
            toggle_ping_id = toggle_ping_id + 1
        end
        return ret
    end

    function action_wheel_pages.setLocation(folder)
        location = folder
        update()
    end
end

-->========================================[ ACTION WHEEL STRUCTURE ]=========================================<--
trueCameraPos = false
do
    root = action_wheel_pages.createFolder("root",nil)
    
    local dances = action_wheel_pages.createFolder("Dances","minecraft:redstone_lamp")
    
    do
        local stopDance = action_wheel_pages.createItem("Stop Dance","minecraft:barrier")
        stopDance.setFunction(function ()animation.switchTo("stop","DANCE")end)
        dances.add(stopDance)
        
        local SquareDance = action_wheel_pages.createItem("Square Dance","minecraft:item_frame")
        SquareDance.setFunction(function ()animation.switchTo("SquareDance","DANCE")end)
        dances.add(SquareDance)
        
        local DefaultDance = action_wheel_pages.createItem("Default Dance","minecraft:apple")
        DefaultDance.setFunction(function ()animation.switchTo("DefaultDance","DANCE")end)
        dances.add(DefaultDance)

        local sitSwing = action_wheel_pages.createItem("Sit Down","minecraft:oak_stairs")
        sitSwing.setFunction(function ()animation.switchTo("sitSwing","DANCE")end)
        dances.add(sitSwing)

        local Carmalledansen = action_wheel_pages.createItem("Carmalledansen","minecraft:glowstone")
        Carmalledansen.setFunction(function ()animation.switchTo("Carmalledansen","DANCE")end)
        dances.add(Carmalledansen)

        local sleeping = action_wheel_pages.createItem("sleeping","minecraft:red_bed")
        sleeping.setFunction(function ()animation.switchTo("sleeping","DANCE")end)
        dances.add(sleeping)

    end

    local taunt = action_wheel_pages.createFolder("Actions","minecraft:redstone_lamp")

    do
        local stopTaunt = action_wheel_pages.createItem("Stop Taunt","minecraft:barrier")
        stopTaunt.setFunction(function ()animation.switchTo("stop","TAUNT")end)
        taunt.add(stopTaunt)

        local popcorn = action_wheel_pages.createItem("Eat Popcorn","minecraft:raw_iron_block")
        popcorn.setFunction(function ()animation.switchTo("popcornLoop","TAUNT")end)
        taunt.add(popcorn)

        local laugh = action_wheel_pages.createItem("Laugh","minecraft:note_block")
        laugh.setFunction(function ()animation.switchTo("laugh","TAUNT")end)
        taunt.add(laugh)

        local salute = action_wheel_pages.createItem("Salute","minecraft:anvil")
        salute.setFunction(function ()animation.switchTo("salute","TAUNT")end)
        taunt.add(salute)
    end

    local resize = action_wheel_pages.createFolder("Resize","minecraft:tnt")
    do
        local Xbigger = action_wheel_pages.createItem("X x2","minecraft:red_concrete")
        local Ybigger = action_wheel_pages.createItem("Y x2","minecraft:lime_concrete")
        local Zbigger = action_wheel_pages.createItem("Z x2","minecraft:blue_concrete")
        local Abigger = action_wheel_pages.createItem("Z x2","minecraft:white_concrete")
        Xbigger.setFunction(function ()ping.scale(targetSize*vectors.of{2,1,1})end)
        Ybigger.setFunction(function ()ping.scale(targetSize*vectors.of{1,2,1})end)
        Zbigger.setFunction(function ()ping.scale(targetSize*vectors.of{1,1,2})end)
        Abigger.setFunction(function ()ping.scale(vectors.of{targetSize.x,targetSize.x,targetSize.x}*2)end)
        Abigger.setFunction(function ()ping.scale(vectors.of{targetSize.x,targetSize.x,targetSize.x}*2)end)
        
        local Xsmaller = action_wheel_pages.createItem("X x0.5","minecraft:red_concrete")
        local Ysmaller = action_wheel_pages.createItem("Y x0.5","minecraft:lime_concrete")
        local Zsmaller = action_wheel_pages.createItem("Z x0.5","minecraft:blue_concrete")
        local Asmaller = action_wheel_pages.createItem("Z x0.5","minecraft:white_concrete")
        Xsmaller.setFunction(function ()ping.scale(targetSize*vectors.of{0.5,1,1})end)
        Ysmaller.setFunction(function ()ping.scale(targetSize*vectors.of{1,0.5,1})end)
        Zsmaller.setFunction(function ()ping.scale(targetSize*vectors.of{1,1,0.5})end)
        Asmaller.setFunction(function ()ping.scale(vectors.of{targetSize.x,targetSize.x,targetSize.x}*0.5)end)

        local toggleCamPos = action_wheel_pages.createItem("Toggle Camera Pos","minecraft:observer")
        toggleCamPos.setFunction(function ()trueCameraPos = not trueCameraPos end)
        
        resize.add(Xbigger)
        resize.add(Xsmaller)
        resize.add(Ybigger)
        resize.add(Ysmaller)
        resize.add(Zbigger)
        resize.add(Zsmaller)
        resize.add(Abigger)
        resize.add(Asmaller)
        resize.add(toggleCamPos)
    end

    root.add(dances)
    root.add(taunt)
    root.add(resize)
    
    action_wheel_pages.setLocation(root)
end

-->========================================[ PLAYER SCALING ]=========================================<--


function ping.scale(scale)
    targetSize = scale
end

function tick()
    local isXDiff = math.abs(targetSize.x-finalScale.x) > 0.01
    local isYDiff = math.abs(targetSize.y-finalScale.y) > 0.01
    local isZDiff = math.abs(targetSize.z-finalScale.z) > 0.01
    if isXDiff then
        finalScale.x = finalScale.x + (targetSize.x-finalScale.x)*0.5
    else
        finalScale.x = targetSize.x
    end
    if isYDiff then
        finalScale.y = finalScale.y + (targetSize.y-finalScale.y)*0.5
    else
        finalScale.y = targetSize.y
    end
    if isZDiff then
        finalScale.z = finalScale.z + (targetSize.z-finalScale.z)*0.5
    else
        finalScale.z = targetSize.z
    end

    if isXDiff or isYDiff or isZDiff then
        --model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.setScale({1/finalScale,1/finalScale,1/finalScale})
        model.NO_PARENT_BASE.SCALE.ORIGIN.setScale(finalScale)
        model.DEBUG_MENU_NO_PARENT.setScale(finalScale)
        local scaleRatio = 1/finalScale.y
        animation.DefaultDance.setSpeed((scaleRatio)*1.1)
        animation.sprint.setSpeed((scaleRatio))
        animation.Carmalledansen.setSpeed((scaleRatio)*1.2)
        animation.SquareDance.setSpeed((scaleRatio)*1.1)
        animation.walk_forward.setSpeed((scaleRatio)*0.6)
        animation.crawling_idle.setSpeed((scaleRatio)*0.6)
        animation.WM_walk_forward.setSpeed((scaleRatio)*0.6)
        animation.WM_walk_backward.setSpeed((scaleRatio)*0.6)
        animation.crawling_forward.setSpeed((scaleRatio)*0.6)
        animation.mining.setSpeed((scaleRatio)*1.5)
        animation.digging.setSpeed((scaleRatio)*1.5)
        --nameplate.ENTITY.setScale({finalScale,finalScale,finalScale})
        --nameplate.ENTITY.setScale({0,2*(size-1),0})
        if client.isHost() then
            if trueCameraPos then
                camera.FIRST_PERSON.setPos({0,(finalScale.y-1)*player.getEyeHeight(),0})
                camera.THIRD_PERSON.setPos({0,(finalScale.y-1)*player.getEyeHeight(),-4+(finalScale.z)*4})
            else
                camera.FIRST_PERSON.setPos({0,0,0})
                camera.THIRD_PERSON.setPos({0,0,0})
            end
        end
        for _, value in pairs(animation.listAnimations()) do
            animation[value].setSpeed(scaleRatio)
        end
    end

    model.NO_PARENT_BASE.SCALE.setPos(model.NO_PARENT_BASE.SCALE.getPivot() * (finalScale*-1+1)- (model.NO_PARENT_BASE.SCALE.ORIGIN.getAnimPos()*(finalScale*-1+1)))
end

sizeTrainsitionTime = 0
finalScale = vectors.of{1,1,1}
targetSize = vectors.of{1,1,1}
ping.scale(targetSize)

-->========================================[ Animation ]=========================================<--

model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.popcorn.setEnabled(false)
model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.PopcornBag.setEnabled(false)

function ping.forceSwitchTo(data)
    localSwitchTo(data[1],data[2])
end

function localSwitchTo(anim,type)
    if type == "TAUNT" then
        model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.popcorn.setEnabled(anim == "popcornLoop")
        model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.PopcornBag.setEnabled(anim == "popcornLoop")
    end
    currentAnimation[type] = anim
    if lastAnimation[type] ~= "stop" and lastAnimation[type] ~= nil then
        animation[lastAnimation[type]].stop()
    end
    if anim ~= "stop" then
        animation[anim].start()
    end
    lastAnimation[type] = currentAnimation[type]
    timeSinceLastUpdate = 1
end

function animation.switchTo(targetAnim,type)
    local doItAnyways = false
    if targetAnim ~= "stop" then
        if not animation[targetAnim].isPlaying() then
            doItAnyways = true
        end
    end
    if lastAnimation[type] ~= targetAnim or doItAnyways then
        ping.forceSwitchTo({targetAnim,type})
        model.NO_PARENT_BASE.SCALE.ORIGIN.sleepingIcons1.setEnabled(targetAnim == "sleeping" and type == "DANCE")
        model.NO_PARENT_BASE.SCALE.ORIGIN.sleepingIcons2.setEnabled(targetAnim == "sleeping" and type == "DANCE")
        if type == "DANCE" then
            snapToBlocks = false
            for _, value in pairs(snappedToBlockAnimations) do
                if targetAnim == value then
                    snapToBlocks = true
                end
            end
        end
    end
end
-->========================================[ DEBUG MENU ]=========================================<--
lastRecordedCount = 0
function reloadDebugMenu()
    model.DEBUG_MENU_NO_PARENT.clearAllRenderTasks()
    local offset = 4
    for key, _ in pairs(currentAnimation) do
        offset = offset + 1
        model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","st"..tostring(offset),"...",true,{10,offset*-4,0})
        model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","sts"..tostring(offset),"...",true,{9.5,offset*-4+0.5,0.1})
        table.insert(debugActionRow,{index=offset,value=key})
    end
end

function toggleChat(toggle)
    isChatOpen = toggle
    if isChatOpen then
        animation.switchTo("speechBubble_intro","THINKING")
    else
        animation.switchTo("speechBubble_outro","THINKING")
    end
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_speechBubble.setEnabled(isChatOpen or animation["speechBubble_outro"].isPlaying() or animation["speechBubble_intro"].isPlaying())
end

function ping.swingArm(toggle)
    isSwingingArm = toggle
end

function tick()
        timeSinceLastUpdate = timeSinceLastUpdate + 1
        LDM = renderer.getCameraPos().distanceTo(player.getPos()) > LDMDistance
        
        if not LDM then
            if chat.isOpen() ~= wasChatOpen then
                toggleChat(chat.isOpen())
                wasChatOpen = isChatOpen
            end
            
            wasActionWheelOpen = action_wheel.isOpen()
            
            lastRotation = rotation
            rotation = player.getRot()
            lastVelocity = velocity
            velocity = player.getVelocity()

            localVel = {
                x=(math.sin(math.rad(-rotation.y))*velocity.x)+(math.cos(math.rad(-rotation.y))*velocity.z),
                0,
                z=(math.sin(math.rad(-rotation.y+90))*velocity.x)+(math.cos(math.rad(-rotation.y+90))*velocity.z)
            }
            if debugMode then
                model.DEBUG_MENU_NO_PARENT.MG.MG_point.setPos({localVel.z*-11,-localVel.x*11,0})
                --debugActionRow[1].setText("Movement: "..tostring(currentAnimation["MOVEMENT"]))
                local count = countTable(currentAnimation)
                if count ~= lastRecordedCount then
                    lastRecordedCount = count
                    reloadDebugMenu()
                end
                for key, value in pairs(debugActionRow) do
                        model.DEBUG_MENU_NO_PARENT.getRenderTask("st"..tostring(value.index)).setText(value.value..": "..tostring(_G.currentAnimation[value.value]))
                        model.DEBUG_MENU_NO_PARENT.getRenderTask("sts"..tostring(value.index)).setText("§0"..value.value..": "..tostring(_G.currentAnimation[value.value]))
                end
                model.DEBUG_MENU_NO_PARENT.MG.TimeSinceLastUpdate.setScale({1.0/timeSinceLastUpdate,1,1})
            end

            model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.LEFT_HELD_ITEM.setPos({0,0,0})
            if player.getEquipmentItem(2) then--hideItems
                for _, current in pairs(hideItems) do
                    if string.find(player.getEquipmentItem(2).getType(),current) then
                        model.NO_PARENT_BASE.SCALE.ORIGIN.B.AL.ALL.LEFT_HELD_ITEM.setPos({0,0,9999999999999})
                    end
                end
            end

            model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.RIGHT_HELD_ITEM.setPos({0,0,0})
            if player.getEquipmentItem(1) then--hideItems
                for _, current in pairs(hideItems) do
                    if string.find(player.getEquipmentItem(1).getType(),current) then
                        model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.RIGHT_HELD_ITEM.setPos({0,0,99999999999})
                    end
                end
            end

            if string.find(player.getEquipmentItem(1).getType(),"sword") then
                isSwordOpen = true
                model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.GNs_Blade.setEnabled(true)
            else
                isSwordOpen = false
                model.NO_PARENT_BASE.SCALE.ORIGIN.B.AR.ARL.GNs_Blade.setEnabled(false)
            end
            

            if client.isHost() then--HOST ONLY FUNCTIONS
                distanceVelociy = (velocity*vectors.of({1,0,1})).distanceTo(vectors.of({}))
                distanceTraveled = distanceTraveled + distanceVelociy
                local vehicle = player.getVehicle()
                if vehicle then
                    local vehicleType = vehicle.getType()
                    if lastVehicleType ~= vehicleType then
                        isAnimalSitting = false
                        for _, value in pairs(animalSitType) do
                            if string.find(vehicleType,value) then
                                isAnimalSitting = true
                                break
                            end
                        end
                        lastVehicleType = tostring(vehicleType)
                    end
                    if isAnimalSitting then
                        animation.switchTo("AnimalVehicleSit","MOVEMENT")
                    else
                        animation.switchTo("VehicleSit","MOVEMENT")
                    end
                else
                    if player.isUnderwater() then
                        if player.getAnimation() == "SWIMMING" then
                            animation.switchTo("swimSprint","MOVEMENT")
                        else
                            animation.switchTo("swimFloat","MOVEMENT")
                        end
                        tiltMovementStrength = 90
                        
                    else
                        tiltMovementStrength = 0
                        if player.isOnGround() then
                            if distanceVelociy > 0.05 then
                                if player.getAnimation() == "SWIMMING" and not player.isWet() then
                                    animation.switchTo("crawling_forward","MOVEMENT")
                                else
                                    if player.isSprinting() then
                                        animation.switchTo("sprint","MOVEMENT")
                                    else
                                        if localVel.x > 0 then
                                            animation.switchTo("walk_forward","MOVEMENT")
                                        else
                                            animation.switchTo("walk_backward","MOVEMENT")
                                        end
                                    end
                                end
                                
                            else
                                if player.getAnimation() == "SWIMMING" and not player.isWet() then
                                    animation.switchTo("crawling_idle","MOVEMENT")
                                else
                                    animation.switchTo("stop","MOVEMENT")
                                end
                            end
                        else
                            if velocity.y > 0 then
                                animation.switchTo("jump","MOVEMENT")
                            else
                                animation.switchTo("fall","MOVEMENT")
                            end
                        end
                    end
                end

                local isWearingElytra = (player.getEquipmentItem(5).getType() == "minecraft:elytra" and player.getEquipmentItem(1).getType() == "minecraft:firework_rocket" or player.getAnimation() == "FALL_FLYING")
                if wasWearingElytra ~= isWearingElytra or ForceUpdate then
                    ForceUpdate = false
                    if isWearingElytra then
                        timeSinceElytra = 0
                        animation.switchTo("wings_intro","WINGS")
                    else
                        animation.switchTo("wings_outro","WINGS")
                    end
                else
                    if animation.wings_outro.getPlayState() == "ENDED" and not isWearingElytra then
                        animation.switchTo("wings_hidden","WINGS")
                    end
                    if isWearingElytra then
                        timeSinceElytra = timeSinceElytra + 1
                        if timeSinceElytra > (targetSize.y/1)*20 then
                            if velocity.distanceTo(vectors.of({})) > 0.5 then
                                animation.switchTo("wings_throttle","WINGS")
                            else
                                animation.switchTo("wings_idle","WINGS")
                            end
                        end

                    end
                end
                wasWearingElytra = isWearingElytra
                end
                local currentHeldItem = player.getHeldItem(1)
                if currentHeldItem then
                    if lastHeldItem ~= currentHeldItem then
                        if currentHeldItem then
                            heldItemTags = player.getHeldItem(1).getItemTags()
                        end
                        if heldItemTags then
                            if string.find(player.getHeldItem(1).getType(),"sword") then
                                animation.swordIdle.play()
                            else
                                animation.swordIdle.stop()
                            end
                        end
                    end
                end
                lastHeldItem = player.getHeldItem(1)
                --logTableContent(currentItemTags[1])
                isSwingingArm = keybind.attack.isPressed() or keybind.use.isPressed()
                if isSwingingArm ~= wasSwingingArm then
                    ping.swingArm(isSwingingArm)
                    if isSwingingArm then
                        if player.getActiveItem() then
                            if player.getActiveItem().getUseAction() == "EAT" then
                                animation.switchTo("eating","interact")
                            end
                            if player.getActiveItem().getUseAction() == "BLOCK" then
                                if isSwingingArm then
                                    animation.switchTo("shield_intro","SHIELD")
                                end
                                wasUsingShield = true
                            end
                        else
                            local currentItemTags = nil
                            if player.getHeldItem(1) then
                                currentItemTags = player.getHeldItem(1).getType()
                                if currentItemTags then
                                    if string.find(currentItemTags,"pickaxe") then
                                        animation.switchTo("mining","interact")
                                    end
                                    if string.find(currentItemTags,"shovel") then
                                        animation.switchTo("digging","interact")
                                    end
                                    if string.find(currentItemTags,"sword") then
                                        if velocity.y < -0.04 then
                                            animation.swordSlam.play()
                                        else
                                            animation.swordAttack.play()
                                        end
                                    end
                                else
                                    animation.switchTo("stop","interact")
                                end

                            end
                        end

                    else
                        if wasUsingShield then
                            wasUsingShield = false
                            animation.switchTo("shield_outro","SHIELD")
                        end
                        animation.switchTo("stop","interact")
                    end
                end
                wasSwingingArm = keybind.attack.isPressed() or keybind.use.isPressed()
            end

            for name, h in pairs(hair) do
                h.lastRotation = h.rotation
                if h.physics then
                    h.rotation = h.rotation + h.velocity
                    h.velocity = h.velocity * h.friction - h.rotation * h.restForce
                    h.velocity = h.velocity + vectors.of({localVel.x*-50 + (velocity.y-math.abs(velocity.y))*90,0,(rotation.y-lastRotation.y)}) * h.waveMult
                end

                if name == "longHair" then 
                    if rotation.x < 0 then
                        h.rotation = vectors.of({rotation.x})
                    else
                        h.rotation = vectors.of({0})
                    end
                end
                if name == "backB" then
                    if rotation.x > 0 then
                        h.rotation = vectors.of({rotation.x,h.rotation.y,h.rotation.z})
                    else
                        h.rotation = vectors.of({0})
                        h.velocity = h.velocity * vectors.of({0,1,1})
                    end
            end
        end
end

function world_render(delta)
    if not LDM then
            if snapToBlocks then
                model.NO_PARENT_BASE.SCALE.ORIGIN.setPos(vectors.of({math.floor(player.getPos(delta).x)+0.5,player.getPos(delta).y,math.floor(player.getPos(delta).z)+0.5})*vectors.of({-16,-16,16}))
            else
                model.NO_PARENT_BASE.SCALE.ORIGIN.setPos(player.getPos(delta)*vectors.of({-16,-16,16}))
            end
            model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.setRot(player.getRot()*vectors.of({-1,-1,1})+vectors.of({0,player.getBodyYaw()}))
            if player.getPos(delta) then
                model.DEBUG_MENU_NO_PARENT.setPos(player.getPos(delta)*vectors.of({-16,-16,16}))
                model.DEBUG_MENU_NO_PARENT.setRot(renderer.getCameraRot()*vectors.of({1,1,1}))
            end

        --model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.setRot(player.getRot(0)*vectors.of({-1,-1,1})+vectors.of({0,player.getBodyYaw()}))

        if player.getAnimation() == "FALL_FLYING" or player.getAnimation() ==  "SWIMMING" then
            model.NO_PARENT_BASE.SCALE.ORIGIN.setRot(Ylookat(player.getPos(),player.getPos()+vectors.lerp(lastVelocity,velocity,delta))* vectors.of({-1,1,1}) + vectors.of({0,180,0}))
        else
            local playerVel = player.getVelocity()
            model.NO_PARENT_BASE.SCALE.ORIGIN.setRot({playerVel.z*tiltMovementStrength,180-player.getBodyYaw(),playerVel.x*-tiltMovementStrength}) 
        end
        --applyColor({
        --    vectors.hsvToRGB({0,1,1}),--HAT
        --    vectors.hsvToRGB({0,1,1}),--HAIR
        --    vectors.hsvToRGB({0,1,1}),--GLASSES
        --    vectors.hsvToRGB({0,1,1}),--JACKET
        --    vectors.hsvToRGB({0,1,1}),--SHIRT
        --    vectors.hsvToRGB({0,1,1}),--PANTS
        --    vectors.hsvToRGB({0,1,1}),--SHOES
        --    vectors.hsvToRGB({0,1,1}),--RING/SHOULDERS
        --    vectors.hsvToRGB({0,1,1}),--GLOVES
        --})
        for name, h in pairs(hair) do
            h.model.setRot(vectors.lerp(h.lastRotation,h.rotation,delta))
        end
    end
    if client.isHost() then
        model.NO_PARENT_BASE.SCALE.ORIGIN.setEnabled(not LDM and (player.getPos(delta)+vectors.of({0,player.getEyeHeight()*targetSize.y})).distanceTo(renderer.getCameraPos()) > finalScale.y*0.5)
    end
    
end

function Ylookat(from,to)-- simple look at function, Y axis as up
    local offset = to-from
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end

function angleToDir(direction)
    return vectors.of({
        math.cos(math.rad(direction.y+90))*math.cos(math.rad(direction.x)),
        math.sin(math.rad(-direction.x)),
        math.sin(math.rad(direction.y+90))*math.cos(math.rad(direction.x))
    })
end

function countTable(table)
    local c = 0
    for _, _ in pairs(table) do
        c = c + 1
    end
    return c
end

function getFranColor()
    return vectors.of({255,114,183})
end