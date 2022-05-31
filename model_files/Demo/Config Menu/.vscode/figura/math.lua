--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---Contains functions added to the math library by figura.
---Functions contained in the base mathlib are not included here.
math = {}

---Interpolates values/vectors between a and b.
---Will not accept a raw table as input.
---Use vectors.of() to convert from raw table to vector table.
---@param a number | Vector
---@param b number | Vector
---@param delta number
---@return number | Vector
function math.lerp(a,b,delta) end

---Returns a value that never goes below min or above max.
---@param val number
---@param min number
---@param max number
---@return number
function math.clamp(val, min, max) end