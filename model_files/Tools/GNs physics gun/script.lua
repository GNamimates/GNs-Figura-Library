lastPosition = vectors.of{}
position = vectors.of{}

model.NO_PARENTCHARACTER.gravityGun.gravityGunOffset.thicc.setTexture("Skin")
model.NO_PARENTCHARACTER.gravityGun.gravityGunOffset.thicc.setExtraTexEnabled(false)
model.NO_PARENTCHARACTER.gravityGun.gravityGunOffset.slim.setTexture("Skin")
model.NO_PARENTCHARACTER.gravityGun.gravityGunOffset.slim.setExtraTexEnabled(false)

model.NO_PARENTCHARACTER.toolGun.toolGunOffset.thicc2.setTexture("Skin")
model.NO_PARENTCHARACTER.toolGun.toolGunOffset.thicc2.setExtraTexEnabled(false)
model.NO_PARENTCHARACTER.toolGun.toolGunOffset.slim2.setTexture("Skin")
model.NO_PARENTCHARACTER.toolGun.toolGunOffset.slim2.setExtraTexEnabled(false)


workspaceHystoryBefore = {}
workspaceHystoryAfter = {}

count = 3
workspace = {}

mode = 0
selectedID = 1

grabDistance = 3
blockToPlaceName = "minecraft:glass"

modeNames = {
    [0]="Insert Mode",
    [1]="Move Mode",
    [2]="Scale Mode",
    [3]="Clone Mode"
}

toolDisplayed = 0

lastScale = nil
offsetSelection = vectors.of{}
dynamicSyncTime = 0
dynamicSyncWaitTime = 2

lastSelectedPos = vectors.of{}

lastScroll = 0
scroll = 0

timeSinceStart = 0


function player_init()
    switchDisplayedTool(1)

    model.HUD_TL.addRenderTask("TEXT","title",'{"text":"GNs Physics Gun v0.0.5","color":"dark_gray"}',true,{2,2})
    
    model.HUD.blockPreview.addRenderTask("BLOCK","preview",blockToPlaceName,false,{-24,29,8})
    local isSlim = player.getModelType() == "slim"
    model.NO_PARENTCHARACTER.gravityGun.gravityGunOffset.thicc.setEnabled(not isSlim)
    model.NO_PARENTCHARACTER.gravityGun.gravityGunOffset.slim.setEnabled(isSlim)
    model.NO_PARENTCHARACTER.toolGun.toolGunOffset.thicc2.setEnabled(not isSlim)
    model.NO_PARENTCHARACTER.toolGun.toolGunOffset.slim2.setEnabled(isSlim)
    switchMode(0)
    refreashRenderTasks()
    local modeToggleButton = button.new("ModeToggleButton",model.HUD.button1)
    modeToggleButton.area = {-83,106,83,16,1,0}
    modeToggleButton.groupRoot = model.HUD
    modeToggleButton.released_function = function ()
        mode = (mode + 1)% 4
        switchMode(mode)
    end

    local changeBlockButton = button.new("changeBlockButton",model.HUD.button2)
    changeBlockButton.area = {-87,74,87,16,1,0}
    changeBlockButton.groupRoot = model.HUD
end

chat.setFiguraCommandPrefix("!")
function onCommand(cmd)
    local given = string.sub(cmd,2,999)
    if pcall(item_stack.createItem,given) then
        if item_stack.createItem(given).isBlockItem() then
            blockToPlaceName = given
            changeBlock(given)
            log('§asetted insert block to: "'..given..'"')
            return
        end
        log('§c"'..given..'" isnt a block')
    else
        log('§cInvalid type block: "'..given..'"')
    end
    
end

swapMode = keybind.newKey("Swap Mode","TAB")
alt = keybind.newKey("altKey","LEFT_ALT")
ctrl = keybind.newKey("altKey","LEFT_CONTROL")
D = keybind.newKey("D","D")
insert = keybind.newKey("Insert","INSERT")
delete = keybind.newKey("Delete","DELETE")

function tick()

    timeSinceStart = timeSinceStart + 1
    if client.isHost() then
        model.HUD.setEnabled(chat.isOpen())
        lastScroll = scroll
        scroll = scroll + client.getMouseScroll()

        model.HUD.setPos(anchor({1,-1},{}))
        model.HUD_TL.setPos(anchor({-1,-1},{}))


        local cursorOrigin = (player.getPos()+vectors.of{0,player.getEyeHeight()})
        local cursorPos = (cursorOrigin+player.getLookDir()*grabDistance)
        
        if workspace[selectedID] and selectedID ~= 0 then
            lastSelectedPos = workspace[selectedID].pos
        end

        if secondary.isPressed() ~= lastSecondary then
            if secondary.isPressed() then--================================================================================= IMPULSE
                if mode == 1 then--=================================================================================MOVE MODE
                    local selected = findSelected(renderer.getCameraPos(),player.getLookDir()*0.5)
                    if selected then
                        selectedID = selected.index
                        lastSelectedPos = workspace[selectedID].pos
                        grabDistance = workspace[selected.index].pos.distanceTo(cursorOrigin)
                        cursorPos = (cursorOrigin+player.getLookDir()*grabDistance)
                        offsetSelection = (workspace[selected.index].pos-cursorPos)
                    else
                        selectedID = 0
                    end
                    refreashRenderTasks()
                end
                if mode == 2 then
                    if workspace[selectedID] then
                        lastScale = workspace[selectedID].scl
                        offsetSelection = cursorPos
                    end
                end
            end
        end
        if secondary.isPressed() then
            if workspace[selectedID] and selectedID ~= 0 then
                if mode == 1 then
                    workspace[selectedID].pos = (cursorPos-offsetSelection*-1)
                    model.NO_PARENT_WORKSPACE.getRenderTask(selectedID).setPos((workspace[selectedID].pos)*vectors.of{-16,-16,16})
                    dynamicSyncTime = dynamicSyncTime + 1
                    
                    if dynamicSyncTime > dynamicSyncWaitTime then
                        dynamicSyncTime = 0
                        ping.syncPos({selectedID,{workspace[selectedID].pos.x,workspace[selectedID].pos.y,workspace[selectedID].pos.z}})
                        
                    end
                end
                if mode == 2 then
                    workspace[selectedID].scl = lastScale+(cursorPos-offsetSelection)*vectors.of{-1,1,-1}
                    model.NO_PARENT_WORKSPACE.getRenderTask(selectedID).setScale((workspace[selectedID].scl))

                    if dynamicSyncTime > dynamicSyncWaitTime then
                        dynamicSyncTime = 0
                        ping.syncScl({selectedID,{workspace[selectedID].scl.x,workspace[selectedID].scl.y,workspace[selectedID].scl.z}})
                    end
                end
            end
        end

        if ctrl.isPressed() then
            if D.wasPressed() then
                if selectedID ~= 0 and workspace[selectedID] then
                    log("duplicated")
                    table.insert(workspace,{
                        pos=workspace[selectedID].pos,
                        scl=workspace[selectedID].scl,
                        type=workspace[selectedID].type
                    }) 
                end
            end
        end

        if delete.wasPressed() then
            if count ~= 0 then
                table.remove(workspace,selectedID)
                count = count - 1
                if count == 0 then
                    workspace = {}
                end
                log("§cdeleted: "..selectedID)
                
                selectedID = math.clamp(selectedID,1,count)
                timeSinceLastSync = syncTime*20
                refreashRenderTasks()
            end
        end
        if insert.wasPressed() then
            log("§aInserted: "..blockToPlaceName)
            timeSinceLastSync = syncTime*20
            count = count + 1
            table.insert(workspace,{
                type=blockToPlaceName,
                pos=cursorPos+vectors.of{0.5,-0.5,0.5},
                scl=vectors.of{1,1,1},
            })
            refreashRenderTasks()
        end

        --lastPosition = position
        --position = (player.getLookDir()*5)+player.getPos()+vectors.of{0,player.getEyeHeight(),0}
        if lastScroll ~= scroll then
            switchMode(scroll % 4)
        end
        --model.NO_PARENTCHARACTER.setEnabled(client.isHudEnabled())

        --================================[ UI ]
        
        if lastPrimary ~= primary.isPressed() then
            if primary.isPressed() then
                if isMouseInsideRect(-128,32,128,16,1,0) then

                end
            end
        end

        if lastSecondary ~= secondary.isPressed() then
            if secondary.isPressed() then
               animation.interact.play() 
            end
        end
        lastPrimary = primary.isPressed()
        lastSecondary = secondary.isPressed()
    end
end

function world_render(delta)
    local deltaTime = timeSinceStart+delta
    if client.isHost() then
        model.HUD.blockPreview.setRot{0,deltaTime,0}
        if workspace[selectedID] and selectedID ~= 0 then
            if mode == 1 then
                model.NO_PARENT_WORKSPACE.getRenderTask(selectedID).setPos(vectors.lerp(lastSelectedPos,(workspace[selectedID].pos),delta)*vectors.of{-16,-16,16})
            end
            model.NO_PARENT_WORKSPACE.SELECTION.setEnabled(true)
            model.NO_PARENT_WORKSPACE.SELECTION.setPos(vectors.lerp(lastSelectedPos,(workspace[selectedID].pos),delta)*vectors.of{-16,-16,16})
            model.NO_PARENT_WORKSPACE.SELECTION.setScale(workspace[selectedID].scl)
        else
            model.NO_PARENT_WORKSPACE.SELECTION.setEnabled(false)
        end
    end
    
    model.NO_PARENTCHARACTER.setPos((player.getPos(delta)+vectors.of{0,player.getEyeHeight()})*vectors.of{-16,-16,16})
    model.NO_PARENTCHARACTER.setRot({-player.getRot().x,-player.getRot().y+180})
    model.NO_PARENT_WORKSPACE.setPos(vectors.lerp(lastPosition,position,delta)*vectors.of{-16,-16,16})
end
--============================================================ [ GENERAL ] =========---
function changeBlock(block)
    blockToPlaceName = block
    model.HUD.blockPreview.getRenderTask("preview").setBlock(block)
end

function findSelected(pos,vel)
    local rayPos = pos
    for step = 1, 30, 1 do
        rayPos = rayPos + vel
        for key, c in pairs(workspace) do
            local lowest = vectors.of{lowest(c.pos.x,c.pos.x-c.scl.x),lowest(c.pos.y,c.pos.y+c.scl.y),lowest(c.pos.z,c.pos.z-c.scl.z)}
            local highest = vectors.of{highest(c.pos.x,c.pos.x-c.scl.x),highest(c.pos.y,c.pos.y+c.scl.y),highest(c.pos.z,c.pos.z-c.scl.z)}
            if 
            rayPos.x < highest.x and rayPos.x > lowest.x and
            rayPos.y > lowest.y and rayPos.y < highest.y and
            rayPos.z < highest.z and rayPos.z > lowest.z then
                return {index=key,pos=rayPos}
            end
        end
    end
end

function refreashRenderTasks()
    model.NO_PARENT_WORKSPACE.clearAllRenderTasks()
    for index, current in pairs(workspace) do
        model.NO_PARENT_WORKSPACE.addRenderTask(
            "BLOCK",index,current.type,false,
            current.pos*vectors.of{-16,-16,16},
            vectors.of{0,0,0},
            current.scl)
    end
end
animation.toolintro.setBlendTime(0)
function switchDisplayedTool(tool)
    toolDisplayed = tool
    animation.toolintro.play()
    local left = false
    local right = false
    if tool == 0 then
        left = false
        right = false
        model.NO_PARENTCHARACTER.gravityGun.gravityGunOffset.setEnabled(true)
        model.NO_PARENTCHARACTER.toolGun.toolGunOffset.setEnabled(false)
    else
        left = true
        right = false
        model.NO_PARENTCHARACTER.gravityGun.gravityGunOffset.setEnabled(false)
        model.NO_PARENTCHARACTER.toolGun.toolGunOffset.setEnabled(true)
    end
    vanilla_model.LEFT_ARM.setEnabled(left)
    vanilla_model.LEFT_SLEEVE.setEnabled(left)
    vanilla_model.RIGHT_ARM.setEnabled(right)
    vanilla_model.RIGHT_SLEEVE.setEnabled(right)
end
--==================================================== [ OTHER ] ===========--
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

function switchMode(type)
    mode = type
    if mode == 1 then
       switchDisplayedTool(0)
    else 
       switchDisplayedTool(1) 
    end
    if buttonElements["ModeToggleButton"] then
        buttonElements["ModeToggleButton"].label.text = modeNames[type]
    end
    
end
--========================================================= [ NETWORKING ] ================--
syncCount = 0
syncTime = 3
batchTime = 0.3
timeSinceLastSync = syncTime*20
batch = {}
isSyncing = false
batchID = 0

function tick()
    if not isSyncing then
        timeSinceLastSync = timeSinceLastSync + 1
        if timeSinceLastSync > syncTime*20 then
            timeSinceLastSync = 0
            isSyncing = true
            ping.newBatch(count)
            batchID = 0
        end
    else
        timeSinceLastSync = timeSinceLastSync + 1
        if timeSinceLastSync > batchTime*20 then
            timeSinceLastSync = 0
            batchID = batchID + 1
            if batchID > count then
                ping.applyBatch()
                isSyncing = false
                return
            end
            ping.batch({batchID,workspace[batchID]})
        end
    end
end

ping.newBatch = function (howMany)
    batch = {}
end

ping.batch = function (data)
    if not client.isHost() then
        table.insert(batch,data[2])
    end
end

ping.applyBatch = function ()
    syncCount = syncCount + 1
    if not client.isHost() then
        workspace = batch
    end
    refreashRenderTasks()
    if client.isHost() then
        sound.playSound("entity.item.pickup",player.getPos(),{0.01,0.1})
    end
end

ping.syncPos = function (data)
    if workspace[data[1]] then
        workspace[data[1]].pos = vectors.of{data[2]}
    end
end

ping.syncScl = function (data)
    if workspace[data[1]] then
        workspace[data[1]].scl = vectors.of{data[2]}
    end
end

function lowest(x,y)
    if x > y then
        return y
    else
        return x
    end
end

function highest(x,y)
    if x > y then
        return x
    else
        return y
    end
end

function anchor(screen_coord,offset)
    return ((client.getWindowSize()*vectors.of{screen_coord[1],screen_coord[2]})/5)/client.getScaleFactor()+vectors.of{offset[1],offset[2]}
end


--========================================================= [ UI ] 

settings = {
    showButtonAreas = true
}

function isMouseInsideRect(x,y,width,height,anchorX,anchorY)
    if type(anchorX) ~= "number" or type(anchorY) ~= "number" then
        error("anchor must be a number")
    end
    local mousePos = ((client.getMousePos()+client.getWindowSize()*vectors.of{-anchorX,-anchorY})/client.getScaleFactor())
    --model.HUD.clearAllRenderTasks()
    --model.HUD.addRenderTask("BLOCK","area","minecraft:red_stained_glass",true,mousePos/2.5,{},{1,1})
    if x < mousePos.x and x+width >= mousePos.x and y < mousePos.y and y+height >= mousePos.y then
        return true
    end
    return false
end
primary = keybind.newKey("Primary","MOUSE_BUTTON_1",true)
lastPrimary = false
secondary = keybind.newKey("Secondary","MOUSE_BUTTON_2",true)
lastSecondary = false

button = {}
buttonElements = {}

windowSize = vectors.of{}
lastWindowSize = vectors.of{}
windowSizeChanged = false

button_layout = {
    idle = "idle",
    pressed = "pressed",
}

function button.new(button_name,model_path)
    if not buttonElements[button_name] then
        buttonElements[button_name] = {
            model=model_path,
            groupRoot=nil, --if this object is disabled, so will the button
            area=nil,
            wasPressed=false,
            isPressed=false,
            hovering=false,
            disabled=false,
            pressed_function=nil,--function
            released_function=nil,--function
            dynamicValues={id=0,lastArea=nil,lastText="",labelDeclared=false,groupRootDisabled=false},
            
            label = {
                text = "amazing",
                size = 1, 
                pressed = {
                    format = [[{"text":"LABEL","color":"white"}]],--the word "LABEL" will be replaced with text(variable)
                    offset = {0,0}
                },
                idle = {
                    format = [[{"text":"LABEL","color":"dark_gray"}]],--the word "LABEL" will be replaced with text(variable)
                    offset = {0,0}
                }
            }

        }

        local nameLen = string.len(tostring(buttonElements[button_name].model.getName()))
        local currentButton = buttonElements[button_name]
        currentButton.dynamicValues.id = string.sub((tostring(currentButton.model.getName())),nameLen,nameLen)
        if not currentButton.model[button_layout.pressed..currentButton.dynamicValues.id] then
            error('button: "'..button_name..'" dosent have :"'..button_layout.pressed..'#" as a children')
        end
        if not currentButton.model[button_layout.idle..currentButton.dynamicValues.id] then
            error('button: "'..button_name..'" dosent have :"'..button_layout.idle..'#" as a children')
        end
        currentButton.model[button_layout.pressed..currentButton.dynamicValues.id].setEnabled(false)
        currentButton.model[button_layout.idle..currentButton.dynamicValues.id].setEnabled(true)

        return buttonElements[button_name]
    else
        error('button"'..button_name..'" already exists!')
    end
    return false
end

function button.remove(button_name)
    if buttonElements[button] then
        table.remove(button,button_name)
        return true
    end
    return false
end

function tick()
    lastWindowSize = vectors.of{windowSize.x*1,windowSize.y*1}
    windowSize = client.getWindowSize()
    windowSizeChanged = (lastWindowSize.x ~= windowSize.x or lastWindowSize.y ~= windowSize.y)
    for name, element in pairs(buttonElements) do
        if not element.disabled then
            --LABEL
            if element.dynamicValues.labelDeclared == false then
                if element.area ~= nil then
                    model.HUD_DEBUG.addRenderTask("TEXT",tostring('idle'..element.dynamicValues.id),tostring(string.gsub(element.label.idle.format,"LABEL",element.label.text)),true,{
                        0,
                        999,
                        -5},{},{element.label.size,element.label.size,1})
                    element.dynamicValues.labelDeclared = true
                end
                log(name)
            else
                --log(name.." | "..tostring(element.groupRoot.getEnabled()))
                if windowSizeChanged or element.dynamicValues.lastText ~= element.label.text or element.dynamicValues.groupRootDisabled ~= element.groupRoot.getEnabled() then
                    element.dynamicValues.lastText = element.label.text
                    element.dynamicValues.groupRootDisabled = element.groupRoot.getEnabled()
                    local labelPos = ((vectors.of{math.lerp(element.area[1],element.area[1]+element.area[3],0.5)-renderer.getTextWidth(element.label.text)*0.5+element.label.idle.offset[1],math.lerp(element.area[2],element.area[2]-element.area[4],0.5)-4+element.label.idle.offset[2]}*(client.getScaleFactor()*2)-vectors.of{0,element.area[4]*-(client.getScaleFactor()*2)}+client.getWindowSize()*vectors.of{element.area[5]*2-1,element.area[6]*2-1})/client.getScaleFactor())
                    labelPos = labelPos / 5
                    model.HUD_DEBUG.getRenderTask(tostring('idle'..element.dynamicValues.id)).setPos({labelPos.x,labelPos.y,-5})
                    if element.groupRoot.getEnabled() then
                        model.HUD_DEBUG.getRenderTask(tostring('idle'..element.dynamicValues.id)).setText(element.label.text)
                    else
                        
                        model.HUD_DEBUG.getRenderTask(tostring('idle'..element.dynamicValues.id)).setText("")
                    end
                    
                end
            end

            if type(element.groupRoot) ~= "nil" then
                if not element.groupRoot.getEnabled() then
                    return
                end
            end
            element.hovering = isMouseInsideRect(element.area[1],element.area[2],element.area[3],element.area[4],element.area[5],element.area[6])
            element.isPressed = element.hovering and primary.isPressed()
            if  element.isPressed and not element.wasPressed then
                if element.pressed_function ~= nil then
                    element.pressed_function()
                end
                element.model[button_layout.pressed..element.dynamicValues.id].setEnabled(true)
                element.model[button_layout.idle..element.dynamicValues.id].setEnabled(false)
            end
            if not element.isPressed and element.wasPressed then
                if element.released_function ~= nil  then
                    element.released_function()
                end
                element.model[button_layout.pressed..element.dynamicValues.id].setEnabled(false)
                element.model[button_layout.idle..element.dynamicValues.id].setEnabled(true)
            end
            element.wasPressed = element.isPressed
            if settings.showButtonAreas and type(element.area) ~= "nil" then
                if windowSizeChanged then
                        local result = ((vectors.of{element.area[1],element.area[2]}*(client.getScaleFactor()*2)-vectors.of{0,element.area[4]*-(client.getScaleFactor()*2)}+client.getWindowSize()*vectors.of{element.area[5]*2-1,element.area[6]*2-1})/client.getScaleFactor())
                    result = result / 5
                    if not model["HUD_DEBUG"] then
                        error([[Group "HUD_DEBUG" not found]])
                    end
                    if not model.HUD_DEBUG.getRenderTask(name) then
                        model.HUD_DEBUG.addRenderTask("BLOCK",name,"minecraft:red_stained_glass",true,{
                            result.x,
                            result.y,0
                        },{},
                        {element.area[3]/40,element.area[4]/40,1})
                    else
                        model.HUD_DEBUG.getRenderTask(name).setPos{
                            result.x,
                            result.y,0
                        }
                    end
                end
                element.dynamicValues.lastArea = element.area
            end
        end
    end
end