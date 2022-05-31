--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
--=================================================================================--]]

openMenuKeybind = keybind.newKey("Toggle Config Menu", "F9")

GNconfig = {
    menuPath = model.HUD_CONFIG
}

config = {
    toggle = false,
    number = 0,
    text_edit = "hello world",
    vector = {0,0.5,1},
    toggle_group = {
        toggle1 = false,
        toggle2 = true,
        amogus = false,
    },
}

menu = {
    currentMenu = config,
    isMenuOpen = true,
    selected = 0,
}

function player_init()
    reloadMenu()
end

function tick()
    if client.getOpenScreen() then
        menu.isMenuOpen = false
    else
        if openMenuKeybind.wasPressed() then
            menu.isMenuOpen = not menu.isMenuOpen
        end
    end
    --model.HUD_CONFIG.setEnabled(menu.isMenuOpen)
    GNconfig.menuPath.setPos(((client.getWindowSize()*vectors.of{-1,-1})/5)/client.getScaleFactor())
end

function reloadMenu()
    local m = GNconfig.menuPath
    m.clearAllRenderTasks()
    local index = 0
    for name, value in pairs(menu.currentMenu) do
        index = index + 1
        m.addRenderTask("TEXT",index,string.gsub(name,"_"," "),true,{0,(index-1)*3,0})
    end
    --m.addRenderTask("BLOCK","WORKAROUND","stone")
end