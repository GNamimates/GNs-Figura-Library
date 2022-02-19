--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---Logs a value to Minecraft's chat and log output.
---@param value any
function log(value) end

---Logs a value to Minecraft's chat and log output.
---
---Alias of `log`.
---@param value any
function print(value) end

---Logs the contents of the given `table` to Minecraft's chat and log output.
---Attempting to log anything other than a pure `table` will log nothing.
---
---Note: A `Vector` will only log if they are a pure `table`.
---@param tbl table
function logTableContent(tbl) end


---**THIS FUNCTION DOES NOT EXIST UNTIL YOU CREATE IT!**  
---You should not run this function, Figura will run it for you.
---
---Use the below code to create this function:
---```
---function tick()
---  --code here
---end
---```
---***
---This function runs its contents every Minecraft tick.
---
---Since almost all Minecraft data changes every tick, you should check that data in this function
---if you want it to change every tick.  
---Some examples of code that could be placed here are:
---* Getting the health of the player,
---* Getting what the player is holding,
---* Checking the player's animation,
---* Checking a block in the world,
---* Updating tick timers,
---* Sending pings.
---
---Some things will appear too choppy if they are placed in this function, see the `render` function
---if you want your code to run more often than the `tick` function.
---
---Notes:
---* This function *can* be defined multiple times. This is unlike vanilla Lua where redefining
---a function will overwrite it.
---* Figura will run the contents of every instance of this function.
---* Try to define this function as few times as possible, this feature only exists to make combining
---different scripts easier.
function tick() end

---`delta`:  
---&emsp; The distance between the last tick and next tick this frame sits on.  
---&emsp; This is a value `0..1`.
---***
---**THIS FUNCTION DOES NOT EXIST UNTIL YOU CREATE IT!**  
---You should not run this function, Figura will run it for you.
---
---Use the below code to create this function:
---```
---function render(delta)
---  --code here
---end
---```
---***
---This function runs its contents every frame that this script's avatar is visible.  
---This will only run on the player if they are in third person or can see any part of their
---avatar that is connected to them (Not `NO_PARENT`) in first person.
---
---It is very ineffecient to run code here. Only run code that should change every frame.  
---A few simple examples of code that could be placed here are:
---* Moving/rotating/scaling parts smoothly,
---* Getting the positions of parts.
---
---You should not get Minecraft data every frame as it only changes every tick.
---
---
---Notes:
---* This function *can* be defined multiple times. This is unlike vanilla Lua where redefining
---a function will overwrite it.
---* Figura will run the contents of every instance of this function.
---* Try to define this function as few times as possible, this feature only exists to make combining
---different scripts easier.
---@param delta number
function render(delta) end

---**THIS FUNCTION DOES NOT EXIST UNTIL YOU CREATE IT!**  
---You should not run this function, Figura will run it for you.
---
---Use the below code to create this function:
---```
---function player_init()
---  --code here
---end
---```
---***
---This function runs its contents *once* when `player` becomes available.
---
---Notes:
---* This function *can* be defined multiple times. This is unlike vanilla Lua where redefining
---a function will overwrite it.
---* Figura will run the contents of every instance of this function.
---* Try to define this function as few times as possible, this feature only exists to make combining
---different scripts easier.
function player_init() end

---`delta`:  
---&emsp; Contains the *full* message (including the prefix) used to trigger this function.  
---***
---**THIS FUNCTION DOES NOT EXIST UNTIL YOU CREATE IT!**  
---You should not run this function, Figura will run it for you.
---
---Use the below code to create this function:
---```
---function onCommand(cmd)
---  --code here
---end
---```
---***
---This function runs its contents *once* when the player enters a message starting with the command
---prefix as defined by `chat.setFiguraCommandPrefix`.
---
---Notes:
---* This function *can* be defined multiple times. This is unlike vanilla Lua where redefining
---a function will overwrite it.
---* Figura will run the contents of every instance of this function.
---* Try to define this function as few times as possible, this feature only exists to make combining
---different scripts easier.
---@param cmd string
function onCommand(cmd) end
