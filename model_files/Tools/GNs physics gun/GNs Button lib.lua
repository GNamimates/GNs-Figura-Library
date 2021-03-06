--UI button library by GNamimates
--green is good
--v0.3
function isMouseInsideRect(x,y,width,height,anchorX,anchorY)
    local mousePos = ((client.getMousePos()+client.getWindowSize()*vectors.of{-anchorX,-anchorY})/client.getScaleFactor())
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

buttonConfig = {
    button_layout = {
        idle = "idle",
        pressed = "pressed",
    }
}

function button.new(button_name,model_path,x,y,width,height,anchorX,anchorY)
    if not buttonElements[button_name] then
        buttonElements[button_name] = {
            model=model_path,
            area={x,y,width,height,anchorX,anchorY},
            wasPressed=false,
            isPressed=false,
            hovering=false,
            pressed_function=nil,--function
            released_function=nil,--function
            metadata={
                id=0
            }
        }
        local nameLen = string.len(tostring(buttonElements[button_name].model.getName()))
        buttonElements[button_name].metadata.id = string.sub((tostring(buttonElements[button_name].model.getName())),nameLen,nameLen)
        buttonElements[button_name].model[buttonConfig.button_layout.pressed..buttonElements[button_name].metadata.id].setEnabled(false)
        buttonElements[button_name].model[buttonConfig.button_layout.idle..buttonElements[button_name].metadata.id].setEnabled(true)
        return buttonElements[button_name]
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
    for name, c in pairs(buttonElements) do
        if c.model.getEnabled() then
            c.hovering = isMouseInsideRect(c.area[1],c.area[2],c.area[3],c.area[4],c.area[5],c.area[6])
            c.isPressed = c.hovering and primary.isPressed()
            if  c.isPressed and not c.wasPressed then
                if c.pressed_function ~= nil then
                    c.pressed_function()
                end
                c.model[buttonConfig.button_layout.pressed..c.metadata.id].setEnabled(true)
                c.model[buttonConfig.button_layout.idle..c.metadata.id].setEnabled(false)
            end
            if not c.isPressed and c.wasPressed then
                if c.released_function ~= nil  then
                    c.released_function()
                end
                c.model[buttonConfig.button_layout.pressed..c.metadata.id].setEnabled(false)
                c.model[buttonConfig.button_layout.idle..c.metadata.id].setEnabled(true)
            end
            c.wasPressed = c.isPressed
        end
    end
end