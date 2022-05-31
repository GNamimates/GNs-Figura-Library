--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---Contains functions relating to sounds.
sound = {}

---Returns a table of all currently playing custom sounds.
---If second parameter is true, also returns the UUIDs of the players creating the sounds.
---Table will alternate name and player UUIDs
---@param boolean?boolean
---@return string[]
function sound.getCustomSounds(boolean) end

---Returns a table of each custom sound your avatar has
---@return table
function sound.getRegisteredCustomSounds() end

---Returns a list of all sounds the player can hear.
---@return string[]
function sound.getSounds() end

---Returns if a custom sound with the given name is registered.
---@param name string
---@return boolean
function sound.isCustomSoundRegistered(name) end

---Plays a sound event using a custom sound for this client.
---@param name string
---@param pos VectorPos
---@param volPitch Vector2
function sound.playCustomSound(name, pos, volPitch) end

---`pos: VectorPos`  
---&emsp;Three numbers that represent a position in the world.
---
---`vol: number[]`  
---&emsp;Two numbers that represent the volume and pitch of the sound.
---***
---Plays a sound event for this client.  
---Sounds are played on the `player` channel.
---
---Note: This function does not support vector `vol`s.
---@param name string
---@param pos VectorPos
---@param vol number[]
function sound.playSound(name, pos, vol) end

---Adds a new custom sound to your model, using data from either a table of bytes, OR a base64-encoded string
---@param name string
---@param data string|table
function sound.registerCustomSound(name, data) end

---Stops the custom sound with the given name.
---@param name string
function sound.stopCustomSound(name) end
