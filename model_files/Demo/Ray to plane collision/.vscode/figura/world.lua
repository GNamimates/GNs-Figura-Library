--================================================================================================--
--=====  CLASSES  ================================================================================--
--================================================================================================--

---A 4-bit int.
---@alias NibbleInt "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"10"|"11"|"12"|"13"|"14"|"15"

---A light level.
---@alias LightLevel NibbleInt

---A redstone power level.
---@alias RedstonePower NibbleInt

---A phase of the moon.
---@alias MoonPhase
---| "0" #Full Moon
---| "1" #Waning Gibbous
---| "2" #Third Quarter
---| "3" #Waning Crescent
---| "4" #New Moon
---| "5" #Waxing Crescent
---| "6" #First Quarter
---| "7" #Waxing Gibbous

---A Minecraft world.
---@class World
local World = {}

---Returns a biome table of the biome at the specified world position.
---@param pos VectorPos
---@return Biome
function World.getBiome(pos) end

---Returns the block-light level at the given block position.
---
---Note: Returns `15` if the block position is not loaded.
---@param pos VectorPos
---@return LightLevel number
function World.getBlockLightLevel(pos) end

---Returns the block state at the given block position.
---
---Note: Always returns a valid block state, even if the block position is unloaded.
---@param pos VectorPos
---@return BlockState
function World.getBlockState(pos) end

---Returns the block tags containing the block at the given block position.
---
---Note: Returns the block tags for `"minecraft:void_air"` if the block position is unloaded.
---@param pos VectorPos
---@return string[]
function World.getBlockTags(pos) end

---Returns all other players on the server using Figura.
---@return Player[]
function World.getPlayers() end

---Returns the combined light level at the given block position.
---
---Note: Returns `15` if the block position is not loaded.
---@param pos VectorPos
---@return LightLevel number
function World.getLightLevel(pos) end

---See `.getTimeOfDay`.
---@deprecated
---@return number
function World.getLunarTime() end

---Returns the current moon phase.
---@return MoonPhase number
function World.getMoonPhase() end

---Returns how heavy rain is falling in this world.  
---`0` is no rain, `1` is full rain.
---@param delta number
---@return number
function World.getRainGradient(delta) end

---Returns the redstone power the given block position is receiving.  
---This does *not* return the redstone power the block is sending.
---
---Note: Returns `0` if the block position is not loaded.
---@param pos VectorPos
---@return RedstonePower number
function World.getRedstonePower(pos) end

---Returns the sky-light level of the given block position.
---
---Note: Returns `15` if the block position is not loaded.
---@param pos VectorPos
---@return LightLevel number
function World.getSkyLightLevel(pos) end

---Returns the strong redstone power of the block position is receiving.  
---This does *not* return the redstone power the block is sending.  
---This *only* checks for direct connections, redstone power sent through non-redstone blocks are
---ignored.
---@param pos VectorPos
---@return RedstonePower number
function World.getStrongRedstonePower(pos) end

---Returns the total amount of ticks the server has run for.
---@return number
function World.getTime() end

---Returns the total amount of ticks that have passed since the start of day 0.  
---This will not always sync up with `getTime` if the world's time is modified.
---@return number
function World.getTimeOfDay() end

---Returns if the world has a world. What?
---Probably an old function from functionality long lost.
---Should return true. If it ever returns false, something maybe be horribly wrong.
---@return boolean
function World.hasWorld() end

---Returns if the current weather is thunder.
---@return boolean
function World.isLightning() end

---Returns if the given position has sky access.
---@param pos Vector3
---@return boolean
function World.isOpenSky(pos) end

--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---The world that this script is running in currently.
---@type World
towrld = {}
