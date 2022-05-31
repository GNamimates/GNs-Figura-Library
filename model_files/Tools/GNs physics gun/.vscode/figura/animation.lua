---@class AnimationTrack
local AnimationTrack = {}

---@type table<string, AnimationTrack>
animation = {}

---@class animationTrack
animationTrack = {}

---@alias playbackMode
---|"HOLD" Pauses on last frame
---|"LOOP" Loops animation
---|"ONCE" Holds still on last frame.

---Stops all playing animations.
function animation.stopAll() end

---Returns the animation track.
---@param name string
function animation.get(name) end

---Starts the animation.
function AnimationTrack.play() end

---Stops the animation
function AnimationTrack.stop() end

---Stops the animation without blending.
function AnimationTrack.cease() end

---Returns the animation length (in seconds).
---@return number
function AnimationTrack.getLength() end

---Sets the speed of the animation  
---note: default is 1
---@param speed number
function AnimationTrack.setSpeed(speed) end

---Returns the speed of the animation  
---note: default is 1
---@return number
function AnimationTrack.getSpeed() end

---Sets the playback.
---@param mode playbackMode
function AnimationTrack.setLoopMode(mode) end

---Returns the loop mode.
---@return string
function AnimationTrack.getLoopMode() end

---Sets the animation Track length (in seconds).  
---note: setting this to a value below the original length will cause the animation to terminate before it completes
---@param len number
function AnimationTrack.setLength(len) end

---Returns if the animation is playing.  
---note that this will return false if the animation loop mode is set to `ONCE` and the track stops at the end.
---@return boolean
function AnimationTrack.isPlaying() end