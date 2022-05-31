
---access your client variables only accessible with the host script (local player) using it on non-host will always return nil for everything (except isHost)
client = {}

---note: this will return nil on remote view.
function client.getOpenScreen() end

---note: this will return nil on remote view.
---@return integer
function client.getFPS() end

---note: this will return nil on remote view.
---@return boolean
function client.isPaused() end

---note: this will return nil on remote view.
function client.getVersion() end

---note: this will return nil on remote view.
---@return string
function client.getVersionType() end

---note: this will return nil on remote view.
---@return string
function client.getServerBrand() end

---note: this will return nil on remote view.
---@return integer
function client.getChunksCount() end

---note: this will return nil on remote view.
---@return integer
function client.getEntityCount() end

---note: this will return nil on remote view.
---@return integer
function client.getParticleCount() end

---note: this will return nil on remote view.  
---@return integer
function client.getSoundCount() end

---note: this will return nil on remote view.  
function client.getActiveShader() end

---note: this will return nil on remote view.  
function client.getJavaVersion() end

---Returns the amount of Memory in use.  
---note: this will return nil on remote view.
---@return integer
function client.getMemoryInUse() end

---Returns the Memory capacity.  
---note: this will return nil on remote view.
---@return integer
function client.getMaxMemory() end

---Returns the Allocated memory for the game.  
---note: this will return nil on remote view.
---@return integer
function client.getAllocatedMemory() end

---Returns true if the window is Focused
---note: this will return nil on remote view.
---@return boolean
function client.isWindowFocused() end

---Returns true if the Hud is Enabled.  
---note: this will return nil on remote view.
---@return boolean
function client.isHudEnabled() end

---Returns the window size.  
---note: this will return nil on remote view.
---@return Vector2
function client.getWindowSize() end

---Returns the GUI scale setted in the settings
---Note that GUI scale set to auto wont return the auto GUI scale.  
---another note: this will return nil on remote view.
---@return integer
function client.getGUIScale() end

---Returns the Field of View of the host.  
---note: this will return nil on remote view.
---@return integer
function client.getFov() end

---Returns true if the client is the host of the avatar.
---@return boolean
function client.isHost() end

---Toggles the crosshair.
---@param toggle boolean
function setCrosshairEnabled(toggle) end

---Returns true if the crosshair is enabled.
---@return boolean
function getCrosshairEnabled() end

---Offsets the chrosshair.
---@param pos Vector2
function setCrosshairPos(pos) end

---Returns the crosshair offset.
---@return Vector2
function setCrosshairPos() end

