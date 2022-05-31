--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---Contains functions relating to sounds.
sound = {}

---Returns a list of all sounds the player can hear.
---@return string[]
function sound.getSounds() end

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

---`pos_vol: number[]`  
---&emsp;Three numbers that represent a position in the world followed by two numbers that represent
---the volume and pitch of the sound.
---***
---Plays a sound event for this client.  
---Sounds are played on the `player` channel.
---
---This version of the function is deprecated and should not be used when possible.
---
---Note: This function does not support vectors.
---@param name string
---@param pos_vol number[]
---@deprecated
function sound.playSound(name, pos_vol) end

---`pos: VectorPos`  
---&emsp;Three numbers that represent a position in the world.
---
---`vol: number[]`  
---&emsp;Two numbers that represent the volume and pitch of the sound.
---***
---Plays a custom sound event for this client.  
---Sounds are played on the `player` channel.
---
---Note: This function does not support vector `vol`s
---***
--->## How to add Custom sounds
---> 1.Create a new Folder named `Sounds` into your avatar folder  
---> 2.Put the custom sounds into the new Sounds Folder.  
---> note: custom sounds have to be an .ogg file for it to be valid.  
---> 3.Create a new file called `sounds.json` and type `["your custom sound name without .ogg"]`  
---> example: I have a custom sounds called Greet.ogg and talk.ogg inside the Sounds folder, what I write in the sounds.json file is ["Greet","talk"]
---@param name string
---@param pos VectorPos
---@param vol number[]
function sound.playCustomSound(name, pos, vol) end