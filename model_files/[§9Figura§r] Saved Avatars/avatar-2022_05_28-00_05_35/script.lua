---@diagnostic disable: undefined-global, undefined-field
----= GN =[ CONFIG ]= GN =--

LDM = false
LDMDistance = 256

debugMode = false

hideItems = {"sword","shield"}
snappedToBlockAnimations = {"sitDown","sitSwing"}
---
rotation = nil
lastRotation = vectors.of({})
velocity = nil
lastVelocity = nil
distanceVelociy = 0
distanceTraveled = 0
snapToBlocks = false

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
    animation.switchTo("shield_hidden","SHIELD")
    currentAnimation["SHIELD"] = "shield_hidden"
    animation.switchTo("wings_hidden","WINGS")
    model.DEBUG_MENU_NO_PARENT.setEnabled(debugMode)
    if debugMode then
        initiateDebugMode()
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
    animation.attack2.setBlendTime(0.001)
    animation.attack3.setBlendTime(0.001)

    animation.eating.setBlendTime(0.3)
    animation["speechBubble_outro"].setBlendTime(0)
    animation["speechBubble_intro"].setBlendTime(0)

    animation.swordIdle.setPriority(1)
    animation.swordIdle.setBlendTime(0.01)

    animation.swordAttack.setPriority(2)
    animation.swordAttack.setBlendTime(0.01)
    animation.swordAttack.setSpeed(2)
    animation.swordSlam.setPriority(2)
    animation.swordSlam.setBlendTime(0.01)
    animation.swordSlam.setSpeed(2)
    animation.swordSlam.setSpeed(2)
    animation.Carmalledansen.setSpeed(1.4)
    animation.wings_intro.setBlendTime(0)
    animation.wings_outro.setBlendTime(0)
    animation.wings_idle.setBlendTime(0)
    animation.wings_hidden.setBlendTime(0)
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
                action_wheel.SLOT_4.setTitle("/")
            else
                action_wheel.SLOT_4.setItem("minecraft:arrow")
                action_wheel.SLOT_4.setTitle("Next")
            end

            if page == 1 then
                if location.back == nil then
                    action_wheel.SLOT_5.setItem("minecraft:air")
                    action_wheel.SLOT_5.setTitle("/")
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
do
    root = action_wheel_pages.createFolder("root",nil)
    
    local dances = action_wheel_pages.createFolder("Dances","minecraft:redstone_lamp")
    
    do
        local stopDance = action_wheel_pages.createItem("Stopimage.png","minecraft:barrier")
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
        root.add(dances)
    end

    local resize = action_wheel_pages.createFolder("Resize","minecraft:tnt")
    do
        local bigger = action_wheel_pages.createItem("Scale x2","minecraft:lime_concrete")
        bigger.setFunction(function ()ping.scale(targetSize*2)end)
        resize.add(bigger)

        local smaller = action_wheel_pages.createItem("Scale x0.5","minecraft:red_concrete")
        smaller.setFunction(function ()ping.scale(targetSize*0.5)end)
        resize.add(smaller)
    end
    root.add(resize)
    
    action_wheel_pages.setLocation(root)
end
----==========================================================--

function ping.scale(scale)
    targetSize = scale
end

function tick()
    model.NO_PARENT_BASE.SCALE.setPos(model.NO_PARENT_BASE.SCALE.getPivot() * -(finalScale-1) - (model.NO_PARENT_BASE.SCALE.ORIGIN.getAnimPos()*(finalScale-1)))
    if math.abs(targetSize-finalScale) > 0.01 then
        finalScale = finalScale + (targetSize-finalScale)*0.5
        size = finalScale
        --model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.setScale({1/finalScale,1/finalScale,1/finalScale})
        model.NO_PARENT_BASE.SCALE.ORIGIN.setScale({finalScale,finalScale,finalScale})
        if client.isHost() then
            camera.FIRST_PERSON.setPos({0,(size-1)*player.getEyeHeight(),0})
            camera.THIRD_PERSON.setPos({0,(size-1)*player.getEyeHeight(),-4+(size)*4})
        end
        for _, value in pairs(animation.listAnimations()) do
            animation[value].setSpeed(1/finalScale)
        end
        animation.DefaultDance.setSpeed((1/finalScale)*1.1)
        animation.sprint.setSpeed((1/finalScale))
        animation.Carmalledansen.setSpeed((1/finalScale)*1.1)
        animation.SquareDance.setSpeed((1/finalScale)*1.1)
        animation.walk_forward.setSpeed((1/finalScale)*0.6)
        animation.crawling_idle.setSpeed((1/finalScale)*0.6)
        animation.WM_walk_forward.setSpeed((1/finalScale)*0.6)
        animation.WM_walk_backward.setSpeed((1/finalScale)*0.6)
        animation.crawling_forward.setSpeed((1/finalScale)*0.6)
        animation.mining.setSpeed((1/finalScale)*1.5)
        animation.digging.setSpeed((1/finalScale)*1.5)
        nameplate.ENTITY.setScale({finalScale,finalScale,finalScale})
        nameplate.ENTITY.setScale({0,2*(size-1),0})
    else
        finalScale = targetSize
    end
end

sizeTrainsitionTime = 0
finalScale = 1
targetSize = 1
ping.scale(targetSize)

-->========================================[ Animation ]=========================================<--

function ping.forceSwitchTo(data)
    local anim = data[1]
    local type = data[2]
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

function animation.switchTo(animation,type)
    if lastAnimation[type] ~= animation then
        ping.forceSwitchTo({animation,type})
        model.NO_PARENT_BASE.SCALE.ORIGIN.sleepingIcons1.setEnabled(animation == "sleeping" and type == "DANCE")
        model.NO_PARENT_BASE.SCALE.ORIGIN.sleepingIcons2.setEnabled(animation == "sleeping" and type == "DANCE")
        if type == "DANCE" then
            snapToBlocks = false
            for _, value in pairs(snappedToBlockAnimations) do
                if animation == value then
                    snapToBlocks = true
                end
            end
        end
    end
end

function initiateDebugMode()
    local offset = 64
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","TITLE","ERROR",true,{10,-offset,0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","STATEMACHINE","ERROR",true,{10,-offset + (2*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","MOVEMENT","ERROR",true,{10,-offset + (3*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","INTERACTION","ERROR",true,{10,-offset + (4*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","DANCE","ERROR",true,{10,-offset + (5*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","IMPULSEMOVEMENT","NEVER GONNA GIVE YOU UP",true,{10,-offset + (6*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","WINGS","NEVER GONNA GIVE YOU UP",true,{10,-offset + (7*4),0})
    model.DEBUG_MENU_NO_PARENT.addRenderTask("TEXT","SHIELD","NEVER GONNA GIVE YOU UP",true,{10,-offset + (8*4),0})
    debugActionRow[1] = model.DEBUG_MENU_NO_PARENT.getRenderTask("TITLE")
    debugActionRow[2] = model.DEBUG_MENU_NO_PARENT.getRenderTask("STATEMACHINE")
    debugActionRow[3] = model.DEBUG_MENU_NO_PARENT.getRenderTask("MOVEMENT")
    debugActionRow[4] = model.DEBUG_MENU_NO_PARENT.getRenderTask("INTERACTION")
    debugActionRow[5] = model.DEBUG_MENU_NO_PARENT.getRenderTask("DANCE")
    debugActionRow[6] = model.DEBUG_MENU_NO_PARENT.getRenderTask("IMPULSEMOVEMENT")
    debugActionRow[7] = model.DEBUG_MENU_NO_PARENT.getRenderTask("WINGS")
    debugActionRow[8] = model.DEBUG_MENU_NO_PARENT.getRenderTask("SHIELD")
end

function ping.toggleChat(toggle)
    isChatOpen = toggle
    if isChatOpen then
        animation["speechBubble_intro"].play()
        animation["speechBubble_outro"].stop()
    else
        animation["speechBubble_outro"].play()
        animation["speechBubble_intro"].stop()
    end
    model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.H_accessory.H_speechBubble.setEnabled(isChatOpen or animation["speechBubble_outro"].isPlaying() or animation["speechBubble_intro"].isPlaying())
end

function ping.swingArm(toggle)
    isSwingingArm = toggle
end

function tick()
    if not p then
        
        timeSinceLastUpdate = timeSinceLastUpdate + 1
        LDM = renderer.getCameraPos().distanceTo(player.getPos()) > LDMDistance
        
        if not LDM then
            if chat.isOpen() ~= wasChatOpen then
                ping.toggleChat(chat.isOpen())
                wasChatOpen = isChatOpen
            end
            
            wasActionWheelOpen = action_wheel.isOpen()
            
            lastRotation = rotation
            rotation = player.getRot()
            lastVelocity = velocity
            velocity = player.getVelocity()

            local localVel = {
                x=(math.sin(math.rad(-player.getRot().y))*velocity.x)+(math.cos(math.rad(-player.getRot().y))*velocity.z),
                0,
                z=(math.sin(math.rad(-player.getRot().y+90))*velocity.x)+(math.cos(math.rad(-player.getRot().y+90))*velocity.z)
            }
            if debugMode then
                model.DEBUG_MENU_NO_PARENT.MG.MG_point.setPos({localVel.z*-11,-localVel.x*11,0})
                debugActionRow[1].setText("GNamimates Silver")
                debugActionRow[2].setText("--== States ==--")
                debugActionRow[3].setText("Movement: "..tostring(currentAnimation["MOVEMENT"]))
                debugActionRow[4].setText("Interaction: "..tostring(currentAnimation["INTERACTION"]))
                debugActionRow[5].setText("Entertainment: "..tostring(currentAnimation["DANCE"]))
                debugActionRow[6].setText("Impulse Movement: "..tostring(currentAnimation["impuseMovement"]))
                debugActionRow[7].setText("Wings: "..tostring(currentAnimation["WINGS"]))
                debugActionRow[8].setText("Shield: "..tostring(currentAnimation["SHIELD"]))
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
                    if isWearingElytra then
                        timeSinceElytra = timeSinceElytra + 1
                        if timeSinceElytra > (targetSize/1)*20 then
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



            local localVel = {
                x=(math.sin(math.rad(-player.getRot().y))*velocity.x)+(math.cos(math.rad(-player.getRot().y))*velocity.z),
                0,
                z=(math.sin(math.rad(-player.getRot().y+90))*velocity.x)+(math.cos(math.rad(-player.getRot().y+90))*velocity.z)
            }

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
    
end

function world_render(delta)
    if not LDM then
            if snapToBlocks then
                model.NO_PARENT_BASE.SCALE.ORIGIN.setPos(vectors.of({math.floor(player.getPos(delta).x)+0.5,player.getPos().y,math.floor(player.getPos(delta).z)+0.5})*vectors.of({-16,-16,16}))
            else
                model.NO_PARENT_BASE.SCALE.ORIGIN.setPos(player.getPos(delta)*vectors.of({-16,-16,16}))
            end
            model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.setRot(player.getRot()*vectors.of({-1,-1,1})+vectors.of({0,player.getBodyYaw(delta)}))
            model.DEBUG_MENU_NO_PARENT.setPos(player.getPos(delta)*vectors.of({-16,-16,16}))
            model.DEBUG_MENU_NO_PARENT.setRot(renderer.getCameraRot()*vectors.of({1,1,1}))

        --model.NO_PARENT_BASE.SCALE.ORIGIN.B.H.setRot(player.getRot(0)*vectors.of({-1,-1,1})+vectors.of({0,player.getBodyYaw()}))
        
        if player.getAnimation() == "FALL_FLYING" then
            model.NO_PARENT_BASE.SCALE.ORIGIN.setRot(Ylookat(player.getPos(),player.getPos()+vectors.lerp(lastVelocity,velocity,delta))* vectors.of({-1,1,1}) + vectors.of({0,180,0}))
        else
            model.NO_PARENT_BASE.SCALE.ORIGIN.setRot({0,180-player.getBodyYaw(delta)}) 
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
        model.NO_PARENT_BASE.SCALE.ORIGIN.setEnabled(not LDM and (player.getPos(delta)+vectors.of({0,player.getEyeHeight()*targetSize})).distanceTo(renderer.getCameraPos()) > finalScale*0.5)
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

function getFranColor()
    return vectors.of({255,114,183})
end