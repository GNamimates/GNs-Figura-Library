--================================================================================================--
--=====  CLASSES  ================================================================================--
--================================================================================================--

---A button on the keyboard or mouse.
---@alias Key
---| '"0"'
---| '"1"'
---| '"2"'
---| '"3"'
---| '"4"'
---| '"5"'
---| '"6"'
---| '"7"'
---| '"8"'
---| '"9"'
---| '"A"'
---| '"B"'
---| '"C"'
---| '"D"'
---| '"E"'
---| '"F"'
---| '"G"'
---| '"H"'
---| '"I"'
---| '"J"'
---| '"K"'
---| '"L"'
---| '"M"'
---| '"N"'
---| '"O"'
---| '"P"'
---| '"Q"'
---| '"R"'
---| '"S"'
---| '"T"'
---| '"U"'
---| '"V"'
---| '"W"'
---| '"X"'
---| '"Y"'
---| '"Z"'
---| '"NONE"'
---| '"SPACE"'
---| '"APOSTROPHE"'
---| '"COMMA"'
---| '"MINUS"'
---| '"PERIOD"'
---| '"SLASH"'
---| '"SEMICOLON"'
---| '"EQUAL"'
---| '"LEFT_BRACKET"'
---| '"BACKSLASH"'
---| '"RIGHT_BRACKET"'
---| '"ESCAPE"'
---| '"ENTER"'
---| '"TAB"'
---| '"BACKSPACE"'
---| '"INSERT"'
---| '"DELETE"'
---| '"RIGHT"'
---| '"LEFT"'
---| '"DOWN"'
---| '"UP"'
---| '"PAGE_UP"'
---| '"PAGE_DOWN"'
---| '"HOME"'
---| '"END"'
---| '"CAPS_LOCK"'
---| '"SCROLL_LOCK"'
---| '"NUM_LOCK"'
---| '"PAUSE"'
---| '"F1"'
---| '"F2"'
---| '"F3"'
---| '"F4"'
---| '"F5"'
---| '"F6"'
---| '"F7"'
---| '"F8"'
---| '"F9"'
---| '"F10"'
---| '"F11"'
---| '"F12"'
---| '"F13"'
---| '"F14"'
---| '"F15"'
---| '"F16"'
---| '"F17"'
---| '"F18"'
---| '"F19"'
---| '"F20"'
---| '"F21"'
---| '"F22"'
---| '"F23"'
---| '"F24"'
---| '"F25"'
---| '"NP_0"'
---| '"NP_1"'
---| '"NP_2"'
---| '"NP_3"'
---| '"NP_4"'
---| '"NP_5"'
---| '"NP_6"'
---| '"NP_7"'
---| '"NP_8"'
---| '"NP_9"'
---| '"NP_DECIMAL"'
---| '"NP_DIVIDE"'
---| '"NP_MULTIPLY"'
---| '"NP_SUBTRACT"'
---| '"NP_ADD"'
---| '"NP_ENTER"'
---| '"NP_EQUAL"'
---| '"LEFT_SHIFT"'
---| '"LEFT_CONTROL"'
---| '"LEFT_ALT"'
---| '"RIGHT_SHIFT"'
---| '"RIGHT_CONTROL"'
---| '"RIGHT_ALT"'
---| '"MENU"'
---| '"MOUSE_1"'
---| '"MOUSE_2"'
---| '"MOUSE_3"'
---| '"MOUSE_4"'
---| '"MOUSE_5"'
---| '"MOUSE_6"'
---| '"MOUSE_7"'
---| '"MOUSE_8"'

---A keybind registered by Minecraft or a mod.  
---This value is not limited to keybinds registered by Minecraft, any keybind registered by a mod
---will also work (but will not be auto-completed here.)
---@alias MinecraftKeybind
---| '"key.jump"' #Movement: Jump
---| '"key.sneak"' #Movement: Sneak
---| '"key.sprint"' #Movement: Sprint
---| '"key.left"' #Movement: Strafe Left
---| '"key.right"' #Movement: Strafe Right
---| '"key.back"' #Movement: Walk Backwards
---| '"key.forward"' #Movement: Walk Forwards
---| '"key.attack"' #Gameplay: Attack/Destroy
---| '"key.pickItem"' #Gameplay: Pick Block
---| '"key.use"' #Gameplay: Use Item/Place Block
---| '"key.drop"' #Inventory: Drop Selected Item
---| '"key.hotbar.1"' #Inventory: Hotbar Slot 1
---| '"key.hotbar.2"' #Inventory: Hotbar Slot 2
---| '"key.hotbar.3"' #Inventory: Hotbar Slot 3
---| '"key.hotbar.4"' #Inventory: Hotbar Slot 4
---| '"key.hotbar.5"' #Inventory: Hotbar Slot 5
---| '"key.hotbar.6"' #Inventory: Hotbar Slot 6
---| '"key.hotbar.7"' #Inventory: Hotbar Slot 7
---| '"key.hotbar.8"' #Inventory: Hotbar Slot 8
---| '"key.hotbat.9"' #Inventory: Hotbar Slot 9
---| '"key.inventory"' #Inventory: Open/Close Inventory
---| '"key.swapOffHand"' #Inventory: Swap Item With Offhand
---| '"key.loadToolbarActivator"' #Creative Mode: Load Hotbar Activator
---| '"key.saveToolbarActivator"' #Creative Mode: Save Hotbar Activator
---| '"key.playerlist"' #Multiplayer: List Players
---| '"key.chat"' #Multiplayer: Open Chat
---| '"key.command"' #Multiplayer: Open Command
---| '"key.socialInteractions"' #Multiplayer: Social Interactions Screen
---| '"key.advancements"' #Miscellaneous: advancements
---| '"key.spectatorOutlines"' #Miscellaneous: Highlight Players (Spectators)
---| '"key.screenshot"' #Miscellaneous: Take Screenshot
---| '"key.smoothCamera"' #Miscellaneous: Toggle Cinematic Camera
---| '"key.fullscreen"' #Miscellaneous: Toggle Fullscreen
---| '"key.togglePerspective"' #Miscellaneous: Toggle Perspective

---A keybind that is bound to a key.  
---You can use this to determine when you are pressing a key or registered control.
---@class Keybind
local Keybind = {}

---Returns if the key was pressed. Handled as if the key was being typed into a text box.  
---When holding, `.wasPressed()` returns `true` for 1 tick, then returns `false` for 9 ticks, then
---returns `true` until the button is released (plus some undefined extra ticks based on how long
---the key was held.)
---@return boolean
function Keybind.wasPressed() end

---Rebinds the keybind to the given key.
---@param str Key
function Keybind.setKey(str) end

---Returns if the key is pressed this tick.
---@return boolean
function Keybind.isPressed() end

---Returns the current key bound to this keybind.
---@return Key
function Keybind.getKey() end

---Returns the name of the keybind.
---@return string
function Keybind.getName() end

---FiguraKeybind ⇐ Keybind
---***
---A custom keybind created by the script.  
---These binds can be changed by the player later in Figura's keybind menu.
---@class FiguraKeybind : Keybind

---RegisteredKeybind ⇐ Keybind
---***
---A keybind registered by Minecraft or another mod.  
---These binds are changed Minecraft's controls menu.
---@class RegisteredKeybind : Keybind


--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---Contains functions for working with keybinds.
keybind = {}

---Returns a value that represents a registered keybind.
---
---Any registered keybind by both Minecraft and mods can be used.
---@param bind string|MinecraftKeybind
---@return RegisteredKeybind
function keybind.getRegisteredKeybind(bind) end

---Returns a new named keybind that can be tracked.
---@param name string
---@param key Key
---@return FiguraKeybind
function keybind.newKey(name, key) end
