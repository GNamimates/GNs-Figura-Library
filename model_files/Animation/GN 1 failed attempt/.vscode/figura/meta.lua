--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---Contains functions involving Figura's more technical parts such as limits, the version, and the
---current count of certain things.
meta = {}

---Returns if the nameplate can be modified in this client's instance of the script.
---
---This is affected by the "Nameplate/Chat Name Changes" trust setting.
---@return boolean
function meta.getCanModifyNameplate() end

---Returns if the vanilla playermodel can be edited in this client's instance of the script.
---
---This is affected by the "Vanilla Avatar Changes" trust setting.
---@return boolean
function meta.getCanModifyVanilla() end

---Returns the complexity limit in this client's instance of the script.
---
---This is affected by the "Max Complexity" trust setting.
---@return number
function meta.getComplexityLimit() end

---Returns the current complexity of the avatar in this client's instance of the script.
---
---The complexity is the amount of faces being rendered on the client's screen.
---@return number
function meta.getCurrentComplexity() end

---Returns the amount of particles the avatar is creating per second in this client's instance of
---the script.
---@return number
function meta.getCurrentParticleCount() end

---Returns the amount of render instructions the avatar is running in this client's instance of the
---script at this frame.
---
---The amount of render instructions is affected by whatever is running in the `render()` function.
---@return number
function meta.getCurrentRenderCount() end

---Returns the amount of sounds the avatar is emitting per second in this client's instance of the
---script.
---@return number
function meta.getCurrentSoundCount() end

---Returns the amount of tick instruction the avatar is running in this client's instance of the
---script at this tick.
---
---The amount of tick instructions is affected by whatever is running in the `tick()` function.
---@return number
function meta.getCurrentTickCount() end

---Returns if the avatar is allowed to render offscreen in this client's instance of the script.
---
---This is affected by the "Offscreen Rendering" trust setting.
---@return boolean
function meta.getDoesRenderOffscreen() end

---Returns the current version of Figura in this client's instance of the script.
---@return string
function meta.getFiguraVersion() end

---Returns the init instruction limit in this client's instance of the script.
---
---This is affected by the "Max Init Instructions" trust setting.
---@return number
function meta.getInitLimit() end

---Returns the particles-per-second limit in this client's instance of the script.
---
---This is affected by the "Maximum Particles Per Second" trust setting.
---@return number
function meta.getParticleLimit() end

---Returns the render instruction limit in this client's instance of the script.
---
---This is affected by the "Max Render Instructions" trust setting.
---@return number
function meta.getRenderLimit() end

---Returns the sounds-per-second limit in this client's instance of the script.
---
---This is affected by the "Maximum Sounds Per Second" trust setting.
---@return number
function meta.getSoundLimit() end

---Returns the tick instruction limit in this client's instance of the script.
---
---This is affected by the "Max Tick Instructions" trust setting.
---@return number
function meta.getTickLimit() end
