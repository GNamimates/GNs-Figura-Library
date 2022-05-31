--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---Contains functions allowing access to client variables.
---Only accessable with the host script.
---For all other players running your script, it will return nil. (except for isHost())
client={}

---Returns whether the first given version is ahead or behind the second given version. 
--- -1 if ver1<ver2
---  0 if ver1==ver2
---  1 if ver1>ver2
---@param ver1 string
---@param ver2 string
---@return number
function client.checkVersion(ver1,ver2) end

---Clears the title and subtitle text.
function client.clearTitle() end

---Returns the most recently shown actionbar text. These persist through worlds. Crashes lua if the action bar was never shown.
---@return string
function client.getActionBar() end

---Returns the namespace of the currently active shader. Returns nil none are applied. ex: "minecraft:shaders/post/creeper.json"
---@return string
function client.getActiveShader() end

---Returns the currently allocated memory in bytes
---@return number
function client.getAllocatedMemory() end

---Returns 5th line of the left side debug screen (in singleplayer world). ex: "C: 497/15000 (s) D: 12, pC: 000, pU: 00, aB: 12"
---@return string
function client.getChunksCount() end

---Returns if the crosshair is enabled or not.
---@return boolean
function client.getCrosshairEnabled() end

---Returns the offset of the crosshair. Returns nil if it hasn't been set yet.
---@return Vector2
function client.getCrosshairPos() end

---Returns 5th line of the left side debug screen (in singleplayer world). ex: "E: 17/83, B: 0, SD: 12"
---@return string
function client.getEntityCount() end

---Returns the current FOV.
---@return number
function client.getFOV() end

---Returns 2nd line of the left side debug screen (in singleplayer world). ex: "67 fps T: 120 vsyncfancy fancy-clouds B: 2"
---@return string
function client.getFPS() end

---Like getScaleFactor but always returns what is stated in settings. Auto is 0.
---@return number
function client.getGUIScale() end

---Returns if there are any Iris Shaders active. Spectator mob shaders do not count.
---@return boolean
function client.getIrisShadersEnabled() end

---Returns the version of Java currently running
---@return string
function client.getJavaVersion() end

---Returns the maximum allowed allocated memory in bytes.
---@return number
function client.getMaxMemory() end

---Returns the currently used memory in bytes.
---@return number
function client.getMemoryInUse() end

---Returns the position of the mouse from the top left corner in pixels.
---@return Vector2
function client.getMousePos() end

---Returns the amount of notches the mousewheel has scrolled this tick. Scroll up is positive, scroll down is negative.
---@return number
function client.getMouseScroll() end

---Returns the name of the currently open GUI. This is not the GUI ID, but the name which with certain containers can be changed.
---@return string
function client.getOpenScreen() end

---Returns the number of particles as a string.
---@return string
function client.getParticleCount() end

---Returns the GUI scale.
---@return number
function client.getScaleFactor() end

---Returns... something. Its a Vector2, thats all I know.
---@return Vector2
function client.getScaledWindowSize() end

---Returns the brand of the server. ex: "Integrated","vanilla","Fabric","Paper"
---@return string
function client.getServerBrand() end

---Returns the 23rd line of the left side debug screen (in singleplayer world) without Mood. ex: "Sounds: 1/247 + 0/8"
---@return string
function client.getSoundCount() end

---Returns the most recently shown subtitle. If no subtitle has been previously set, the script will crash when trying to execute this.
---@return string
function client.getSubtitle() end

---Returns the amount of miliseconds since the Unix Epoch.
---@return number
function client.getSystemTime() end

---Returns the last shown title overlay message.
---@return string
function client.getTitle() end

---Returns the version number of Minecraft as a string.
---@return string
function client.getVersion() end

---Returns the "type" of Minecraft currently running. Figura only runs on Fabric atm so "Fabric" will be the only output.
---@return string
function client.getVersionType() end

---Returns the size of the Minecraft window in pixels
---@return Vector2
function client.getWindowSize() end

---Returns if the game instance running the script is the player with the avatar.
---@return boolean
function client.isHost() end

---Returns if the hud is visible or not using the F1 key.
---@return boolean
function client.isHudEnabled() end

---Returns if the singleplayer world is paused. Always returns false in multiplayer.
---@return boolean
function client.isPaused() end

---Returns if the Minecraft window is focused.
---@return boolean
function client.isWindowFocused() end

---Sets the text of the actionbar and shows it.
---@param text string
function client.setActionbar(text) end

---Setting to false will force the crosshair to stop rendering, similar to spectator mode.
---@param bool boolean
function client.setCrosshairEnabled(bool) end

---Moves the crosshair by the given offset. Change is only visual, does not effect place/break location.
---@param offset Vector2
function client.setCrosshairPos(offset) end

---Setting to true will force the mouse to be unlocked in the normal game camera. Has no effect on GUIs.
---@param bool boolean
function client.setMouseUnlocked(bool) end

---Sets the subtitle of the title. Does not show the title or subtitle.
---@param text string
function client.setSubtitle(text) end

---Set the text of the title, and then show the title and subtitle.
---@param text string
function client.setTitle(text) end

---Sets the fade durations for the title/subtitle.
---@param fadeInDur number
---@param holdDur number
---@param fadeOutDur number
function client.setTitleTimes(fadeInDur,holdDur,fadeOutDur) end