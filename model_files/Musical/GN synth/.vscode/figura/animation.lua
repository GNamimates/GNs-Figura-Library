--================================================================================================--
--=====  CLASSES  ================================================================================--
--================================================================================================--

---Animation loop mode
---@alias LoopMode
---|'"ONCE"'
---|'"HOLD"'
---|'"LOOP"'

---Animation play state
---@alias PlayState
---|'"PLAYING"'
---|'"STOPPED"'
---|'"PAUSED"'
---|'"ENDED"'
---|'"STOPPING"'
---|'"START"'

---A BlockBench animation
---@class Animation
local Animation = {}

---Stops the animation (without blending).
function Animation.cease() end

---Returns the blend time of the animation.
---@return number
function Animation.getBlendTime() end

---Returns the blend weight of the animation.
---@return number
function Animation.getBlendWeight() end

---Returns the length of the animation.
---@return number
function Animation.getLength() end

---Returns the loop delay of the animation.
---@return number
function Animation.getLoopDelay() end

---Returns the loop mode fo the animation.
---@return LoopMode
function Animation.getLoopMode() end

---Returns the name of the animation.
---@return string
function Animation.getName() end

---Returns if vanilla rotations are locked.
---@return boolean
function Animation.getReplace() end

---Returns the current state of the animation.
---@return PlayState
function Animation.getPlayState() end

---Returns the priority of the animation.
---@return number
function Animation.getPriority() end

---Returns whether the animation overrides in blockbench or not.
---@return boolean
function Animation.getOverride() end

---Returns the current speed of the animation.
---@return number
function Animation.getSpeed() end

---Returns the start delay of the animation
---@return number
function Animation.getStartDelay() end

---Returns the start offset of the animation.
---@return number
function Animation.getStartOffset() end

---Returns if the animation is playing.
---@return boolean
function Animation.isPlaying() end

---Pauses the animation. You can resume by using play()/start().
function Animation.pause() end

---Starts/restarts the animation.
function Animation.play() end

---A function that sets the blend time of the animation, (The blending time is in seconds), for starting/ending animations, 
---for example, if I put "2" as the value, the animation will spend 2 seconds blending into the next animation, you must put this value yourself.
---@param number number
function Animation.setBlendTime(number) end

---Sets the blend weight of the animation.
---@param number number
function Animation.setBlendWeight(number) end

---Sets the length of the animation.
---@param length number
function Animation.setLength(length) end

---Sets the delay between each animation loop.
---@param delay number
function Animation.setLoopDelay(delay) end

---Sets the loop mode of the animation.
---@param loopMode LoopMode
function Animation.setLoopMode(loopMode) end

---With replace enabled, vanilla animations will no longer be able to rotate. They will still be able to move.
---Similar to how mimic parts work, but instead of only rotations, it is only for positions
---@param boolean boolean
function Animation.setReplace(boolean) end

---Sets the playstate of the animation.
---@param playstate PlayState
function Animation.setPlayState(playstate) end

---With override enabled, the animation will use the pivots defined in the animation editor instead of the ones defined in the default editor.
---@param bool boolean
function Animation.setOverride(bool) end

---A function that sets the priority of an animation over the others, you must put this value yourself.
---
---The priority of an animation can determine whether the animations are blended (if the priorities are equal), or if the animation is ignored over another animation (lower priority).
---@param int number
function Animation.setPriority(int) end

---Sets the speed of the animation (1 = 100%).
---@param speed number
function Animation.setSpeed(speed) end

---After calling play() or start(), delay playing the animation for the given amount of time.
---@param delay number
function Animation.setStartDelay(delay) end

---Offset the start of the animation by the given amount of time.
---@param offset number
function Animation.setStartOffset(offset) end

---Starts the animation if it isn't already playing.
function Animation.start() end

---Stops the animation (with blending).
function Animation.stop() end

--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---A `table` containing functions relating to animations and the avatars animations
animation = {}

---A function that stops ALL animations (without blending).
function animation.ceaseAll() end

---A function that returns a table with each animation you have.
---@return string[]
function animation.listAnimations() end

---A function that stops ALL animations (with blending).
function animation.stopAll() end