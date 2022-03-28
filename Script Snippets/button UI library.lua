--GN UI Lib v0.5, the text update?
GNUI = {}
GNUI.Config = {
    -- will highlight all areas that can be selected.
    showButtonAreas = false,
    
    -- the area would be behind the button instead of in front,
    -- only works if `showButtonAreas`
    buttonAreaBehind = false, 
    
    
    layout = {
        button = {-- the layout of all buttons
            idle = "idle",--name of the idle# children on all buttons
            pressed = "pressed", -- name of the pressed# children on all buttons
        }
    }
}


GNUI.anchored = {}
---comment
---@param part CustomModelPart
---@param screen_coord Vector2
---@param offset Vector2
function GNUI.set_anchor(part,screen_coord,offset)
    if type(part) ~= "table" then
        error("given group dosent exist")
    end
    GNUI.anchored[part.getName()] = {
        part=part,
        screen_coord=screen_coord,
        offset=offset
    }
end

function GNUI.isMouseInsideRect(x,y,width,height,anchorX,anchorY)
    if type(anchorX) ~= "number" or type(anchorY) ~= "number" then
        error("anchor must be a number")
    end
    local mousePos = ((client.getMousePos()+client.getWindowSize()*vectors.of{-anchorX*0.5-0.5,-anchorY*0.5-0.5})/client.getScaleFactor())
    --model.HUD.clearAllRenderTasks()
    --model.HUD.addRenderTask("BLOCK","area","minecraft:red_stained_glass",true,mousePos/2.5,{},{1,1})
    if x < mousePos.x and x+width >= mousePos.x and y < mousePos.y and y+height >= mousePos.y then
        return true
    end
    return false
end
GNUI.primary = keybind.newKey("Primary","MOUSE_BUTTON_1",true)
GNUI.lastPrimary = false
GNUI.secondary = keybind.newKey("Secondary","MOUSE_BUTTON_2",true)
GNUI.lastSecondary = false

GNUI.UI = {button={}}
GNUI.buttonElements = {}

windowSize = vectors.of{}
lastWindowSize = vectors.of{}
windowSizeChanged = false

function GNUI.UI.button.new(button_name,model_path)
    if not GNUI.buttonElements[button_name] then
        GNUI.buttonElements[button_name] = {
            model=model_path,
            groupRoot=nil, --if this object is disabled, so will the button
            area=nil,
            wasPressed=false,
            isPressed=false,
            justPressed=false,
            justReleased=false,
            hovering=false,
            disabled=false,
            pressed_function=nil,--function
            released_function=nil,--function
            dynamicValues={id=0,lastArea=nil,lastText="",labelDeclared=false,groupRootDisabled=false},
            
            label = {
                text = button_name,
                size = 1,
                pressed = {
                    format = [[{"text":"LABEL","color":"white"}]],--the word "LABEL" will be replaced with text(variable)
                    offset = {0,0},
                },
                idle = {
                    format = [[{"text":"LABEL","color":"dark_gray"}]],--the word "LABEL" will be replaced with text(variable)
                    offset = {0,0}
                }
            }

        }
        if GNUI.buttonElements[button_name].model then
            local nameLen = string.len(tostring(GNUI.buttonElements[button_name].model.getName()))
            local currentButton = GNUI.buttonElements[button_name]
            currentButton.dynamicValues.id = string.sub((tostring(currentButton.model.getName())),nameLen,nameLen)
            if not currentButton.model[GNUI.Config.layout.button.pressed..currentButton.dynamicValues.id] then
                error('button: "'..button_name..'" dosent have :"'..GNUI.Config.layout.button.pressed..'#" as a children')
            end
            if not currentButton.model[GNUI.Config.layout.button.idle..currentButton.dynamicValues.id] then
                error('button: "'..button_name..'" dosent have :"'..GNUI.Config.layout.button.idle..'#" as a children')
            end
            currentButton.model[GNUI.Config.layout.button.pressed..currentButton.dynamicValues.id].setEnabled(false)
            currentButton.model[GNUI.Config.layout.button.idle..currentButton.dynamicValues.id].setEnabled(true)

            return GNUI.buttonElements[button_name]
        else
            error(''..button_name..[['s group(model) dosent exist!]],2)
        end
        
    else
        error('button"'..button_name..'" already exists!',2)
    end
    return false
end

function tick()
    windowSize = client.getWindowSize()
    windowSizeChanged = (lastWindowSize.x ~= windowSize.x or lastWindowSize.y ~= windowSize.y)
    lastWindowSize = vectors.of{windowSize.x*1,windowSize.y*1}
    if windowSizeChanged then
        for _, value in pairs(GNUI.anchored) do
            value.part.setPos(((client.getWindowSize()*vectors.of{value.screen_coord[1],value.screen_coord[2]})/5)/client.getScaleFactor()+vectors.of{value.offset[1],value.offset[2]})
        end
    end
    for _, element in pairs(GNUI.buttonElements) do
        element.wasPressed = element.isPressed
        element.isPressed = element.hovering and GNUI.primary.isPressed()
        if element.wasPressed ~= element.isPressed then
            if element.isPressed then
                element.justPressed = true
            else
                element.justReleased = true
            end 
        else
            element.justPressed = false
            element.justReleased = false
        end
        
        if not element.disabled then
            --LABEL
            if element.dynamicValues.labelDeclared == false then
                if element.area ~= nil then
                    model.HUD_DEBUG.addRenderTask("TEXT",tostring('idle'..element.dynamicValues.id),tostring(string.gsub(element.label.idle.format,"LABEL",element.label.text)),true,{
                        0,
                        -0,
                        -5},{},{element.label.size,element.label.size,1})
                    element.dynamicValues.labelDeclared = true
                    windowSizeChanged = true
                end
            else
                local forceUpdateButton = ""
                if element.groupRoot then
                    forceUpdateButton = element.groupRoot.getEnabled() ~= element.dynamicValues.groupRootEnabled
                end
                if windowSizeChanged or element.dynamicValues.lastText ~= element.label.text or element.justPressed or element.justReleased or forceUpdateButton then
                    local resulta = ""
                    local labelPos = nil
                    if element.isPressed then
                        resulta = string.gsub(element.label.pressed.format,"LABEL",element.label.text)
                        labelPos = ((vectors.of{element.label.pressed.offset}+
                        vectors.of{math.lerp(element.area[1],element.area[1]+element.area[3],0.5)-renderer.getTextWidth(element.label.text)*0.5+element.label.idle.offset[1],math.lerp(element.area[2],element.area[2]-element.area[4],0.5)-4+element.label.idle.offset[2]}*(client.getScaleFactor()*2)-vectors.of{0,element.area[4]*-(client.getScaleFactor()*2)}+client.getWindowSize()*vectors.of{element.area[5],element.area[6]})/client.getScaleFactor())
                    else
                        resulta = string.gsub(element.label.idle.format,"LABEL",element.label.text)
                        labelPos = ((vectors.of{element.label.idle.offset}+vectors.of{math.lerp(element.area[1],element.area[1]+element.area[3],0.5)-renderer.getTextWidth(element.label.text)*0.5+element.label.idle.offset[1],math.lerp(element.area[2],element.area[2]-element.area[4],0.5)-4+element.label.idle.offset[2]}*(client.getScaleFactor()*2)-vectors.of{0,element.area[4]*-(client.getScaleFactor()*2)}+client.getWindowSize()*vectors.of{element.area[5],element.area[6]})/client.getScaleFactor())
                    end
                    element.dynamicValues.lastText = element.label.text
                    
                    
                    if element.groupRoot then
                        if element.groupRoot.getEnabled() then
                            model.HUD_DEBUG.getRenderTask(tostring('idle'..element.dynamicValues.id)).setText(resulta)
                        else
                            model.HUD_DEBUG.getRenderTask(tostring('idle'..element.dynamicValues.id)).setText("")
                        end
                    end
                    labelPos = labelPos / 5
                    
                    model.HUD_DEBUG.getRenderTask(tostring('idle'..element.dynamicValues.id)).setPos({labelPos.x,labelPos.y,-255})
                end
                if element.groupRoot then
                    element.dynamicValues.groupRootEnabled = element.groupRoot.getEnabled()
                end
            end
            local skip = false
            if element.groupRoot then
                if not element.groupRoot.getEnabled() then
                else
                    GNUI.buttonTick(element)
                    skip = true
                end
            else
                if not skip then
                    GNUI.buttonTick(element)
                end
            end
        end
    end
end
function GNUI.buttonTick(elmnt)
    if elmnt.area then
        elmnt.hovering = GNUI.isMouseInsideRect(elmnt.area[1],elmnt.area[2],elmnt.area[3],elmnt.area[4],elmnt.area[5],elmnt.area[6])
    end
    
    if  elmnt.isPressed and not elmnt.wasPressed then
        if elmnt.pressed_function ~= nil then
            elmnt.pressed_function()
        end
        elmnt.model[GNUI.Config.layout.button.pressed..elmnt.dynamicValues.id].setEnabled(true)
        elmnt.model[GNUI.Config.layout.button.idle..elmnt.dynamicValues.id].setEnabled(false)
    end
    if not elmnt.isPressed and elmnt.wasPressed then
        if elmnt.released_function ~= nil  then
            elmnt.released_function()
        end
        elmnt.model[GNUI.Config.layout.button.pressed..elmnt.dynamicValues.id].setEnabled(false)
        elmnt.model[GNUI.Config.layout.button.idle..elmnt.dynamicValues.id].setEnabled(true)
    end
    
    if GNUI.Config.showButtonAreas and type(elmnt.area) ~= "nil" then
        if windowSizeChanged then
                local result = ((vectors.of{elmnt.area[1],elmnt.area[2]}*(client.getScaleFactor()*2)-vectors.of{0,elmnt.area[4]*-(client.getScaleFactor()*2)}+client.getWindowSize()*vectors.of{elmnt.area[5],elmnt.area[6]})/client.getScaleFactor())
            result = result / 5
            if not model["HUD_DEBUG"] then
                error([[Group "HUD_DEBUG" not found]])
            end
            local zDepth = 0
            if GNUI.Config.buttonAreaBehind then
                zDepth = 250
            end
            if not model.HUD_DEBUG.getRenderTask(name) then
               
                
                model.HUD_DEBUG.addRenderTask("BLOCK",name,"minecraft:red_stained_glass",true,{
                    result.x,
                    result.y,zDepth
                },{},
                {elmnt.area[3]/40,elmnt.area[4]/40,1})
            else
                model.HUD_DEBUG.getRenderTask(name).setPos{
                    result.x,
                    result.y,zDepth
                }
            end
        end
        elmnt.dynamicValues.lastArea = elmnt.area
    end
end
