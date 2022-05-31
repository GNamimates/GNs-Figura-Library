--================================================================================================--
--=====  CLASSES  ================================================================================--
--================================================================================================--

---A parent type that the part will rotate with.
---@alias ParentType
---| '"None"' #Rotate with the origin of the player.
---| '"WORLD"' #Rotate with the world.
---| '"Model"' #Rotate with the entire model.
---| '"Head"' #Rotate with the player's head.
---| '"Torso"' #Rotate with the player's body.
---| '"LeftArm"' #Rotate with the player's left arm.
---| '"RightArm"' #Rotate with the player's right arm.
---| '"LeftLeg"' #Rotate with the player's left leg.
---| '"RightLeg"' #Rotate with the player's right leg.
---| '"LeftItemOrigin"' #Rotate with the player's left held item.
---| '"RightItemOrigin"' #Rotate with the player's right held item.
---| '"LeftElytraOrigin"' #Rotate with the player's left elytra wing's origin.
---| '"RightElytraOrigin"' #Rotate with the player's right elytra wing's origin.
---| '"LeftParrotOrigin"' #Rotate with the player's left parrot spot.
---| '"RightParrotOrigin"' #Rotate with the player's right parrot spot.
---| '"LeftElytra"' #Rotate with the player's left elytra wing.
---| '"RightElytra"' #Rotate with the player's right elytra wing.

---@alias Shader
---| '"None"' #Do not use a shader.
---| '"EndPortal"' #Use the end portal shader.
---| '"Glint"' #Use the enchantment glint.

---A basic model part with very few options for modifying it.
---@class BasicModelPart
local BasicModelPart = {}

---Returns if the part is enabled or not.  
---Returns `nil` if the part has not been toggled with `.setEnabled()` yet.
---
---If the function returns `nil` assume the part is enabled.
---@return boolean|nil
function BasicModelPart.getEnabled() end

---Returns the position offset of the part.  
---Returns `nil` if the part has not been moved with `.setPos()` yet.
---
---If the function returns `nil` assume the part is at `0,0,0`
---@return VectorPos|nil
function BasicModelPart.getPos() end

---Returns the rotation offset of the part.  
---Returns `nil` if the part has not been moved with `.setRot()` yet.
---@return VectorAng|nil
function BasicModelPart.getRot() end

---Sets the visibility of the part.
---@param state boolean
function BasicModelPart.setEnabled(state) end

---Sets the position offset of the part.
---@param pos VectorPos
function BasicModelPart.setPos(pos) end

---Sets the rotation offset of the part.
---@param ang VectorAng
function BasicModelPart.setRot(ang) end


---VanillaModelPart ⇐ BasicModelPart
---***
---A vanilla model part, has more options than a basic part.
---@class VanillaModelPart : BasicModelPart
local VanillaModelPart = {}

---Returns if the part is enabled before any `.setEnabled()` operations are applied.  
---Always seems to return `false`.
---@return boolean
function VanillaModelPart.getOriginEnabled() end

---Returns the part's original position before any `.setPos()` operations are applied.
---@return VectorPos
function VanillaModelPart.getOriginPos() end

---Returns the part's original angle *in radians*.  
---If you want the angle in degrees, use `math.deg()`.
---@return VectorAng
function VanillaModelPart.getOriginRot() end

---Returns if the part's skin customization setting is enabled.  
---Returns `nil` if the part does not have a setting.
---@return boolean|nil
function VanillaModelPart.isOptionEnabled() end

---The proxy for the `CustomModelPartConatiner` class.  
---This only exists to fix inheritance of `CustomModelPart`s inside `CustomModelPartContainer`s.
---@class CustomModelPartContainerProxy
---@type table<string, CustomModelPart>|CustomModelPart[]
local CustomModelPartContainerProxy = {}

---The `table` containing the parts and folders from your blockbench model.
---
---If you want to get the Top hat on your model's head in this example...
---```
---Player
---├ Head
---│ └ TopHat
---└ Body
---  └ Belt
---```
---...then you need to use `CustomModelPartContainer.Player.Head.TopHat` to access it.  
---(Where `CustomModelPartContainer` is the name of this variable.)
---
---Note: Auto-completion does not know what folders and parts you have in your model at first, but
---will learn based on what folders and parts you access yourself.  
---If you want autocompletion for model paths, use
---[*Manuel-Underscore*'s Figura VSCode extension](https://marketplace.visualstudio.com/items?itemName=Manuel-Underscore.figura).  
---If you use the above extension, guessed parts will have a different icon from parts found in the
---model.
---@class CustomModelPartContainer : CustomModelPartContainerProxy
local CustomModelPartContainer = {}

---The proxy for the `CustomModelPart` class.  
---This only exists to fix inheritance of `CustomModelPart`s inside `CustomModelPart`s.
---@type table<string, CustomModelPart>|CustomModelPart[]
---@class CustomModelPartProxy : BasicModelPart
local CustomModelPartProxy = {}

---@class CustomModelPart : CustomModelPartProxy
---CustomModelPart ⇐ BasicModelPart
---***
---A custom model part. These are the parts from the bbmodel file.
---`CustomModelPart`s can contain other `CustomModelPart`s.
---
---Note: Despite the list saying so, a `function` cannot be a `CustomModelPart`! It simply looks
---like that to allow any key to become a `CustomModelPart` if needed.
local CustomModelPart = {}

---Returns the current color of the part.
---The default color is `0,0,0`.
---@return VectorColor
function CustomModelPart.getColor() end

---Returns if the part is hidden in blockbench.  
---A part that is hidden in blockbench cannot be unhidden.
---@return boolean
function CustomModelPart.getHidden() end

---Returns if the part is only mimicing its parent part instead of having its origin connected to
---the parent part's origin.
---@return boolean
function CustomModelPart.getMimicMode() end

---Returns the opacity of a part.
---
---Note: Opacity is a value from 0 to 1.
---@return number
function CustomModelPart.getOpacity() end

---Returns the parent type of the part.
---@return ParentType ParentType
function CustomModelPart.getParentType() end

---Returns the position offset of the part's pivot point.
---@return VectorPos
function CustomModelPart.getPivot() end

---*This function uses the `CustomModelPart` definition.*
---***
---Returns the *absolute* rotation of the part.
---
---Note: This does *not* return the rotation offset.
---@return VectorAng
function CustomModelPart.getRot() end

---Returns the scale of the part set by `.setScale()`.
---@return VectorPos
function CustomModelPart.getScale() end

---Returns the shader of the part.
---@return Shader Shader
function CustomModelPart.getShader() end

---Returns the UV offset of the part.
---
---Note: This does *not* return the actual UV of the part.
---@return VectorUV
function CustomModelPart.getUV() end

---Returns true culling is enabled on the custom part.
---@return boolean
function CustomModelPart.getCullEnabled(bool) end

---Returns a string, either "CUBE", "GROUP" or "MESH", of the part type.
---@return string
function CustomModelPart.getType() end

---returns a string, of the part name (the name as in blockbench for this cube/bone)
---@return string
function CustomModelPart.getName() end

---Takes a `Vector` with a direction relative to the part and returns a `Vector` with the direction
---in world-space.
---@param dir VectorPos
---@return VectorPos
function CustomModelPart.partToWorldDir(dir) end

---*Just a word of caution, this function is very complicated. Do not expect to get how it works
---right from the start.*
---
---Takes a `Vector` with a blockbench position, then:  
---* Makes a pivot `x` (which is *not* this part's pivot) at the center of the player's neck.
---* Offsets pivot `x` by this part's Lua position offset,
---* Rotates pivot `x`'s position around this part's (Lua position offset + Lua pivot offset),
---* Adds the given blockbench position to the position of pivot `x`,
---* Rotates the new blockbench position around pivot `x` by the absolute rotation of this part.
---* Converts to an absolute world position and returns that position.
---@param pos VectorPos
---@return VectorPos
function CustomModelPart.partToWorldPos(pos) end

---Sets the color of the model.
---
---Note: The color is set by *tinting* the model, use grayscale textures for best results.
---@param col VectorColor
function CustomModelPart.setColor(col) end

---Sets the mimic mode of the model.  
---If true, the model will *mimic* its parent as set by `.setParentType()` instead of having its
---origin connected to the parent part's origin.
---@param state boolean
function CustomModelPart.setMimicMode(state) end

---Sets the opacity of the part.
---
---Note: Opacity is a value from 0 to 1.
---@param num number
function CustomModelPart.setOpacity(num) end

---Sets the parent type of the part.
---@param parent ParentType
function CustomModelPart.setParentType(parent) end

---*This function uses the `CustomModelPart` definition.*
---***
---Sets the *absolute* rotation of the part.
---
---Note: This does *not* set the rotation offset.
---@param ang VectorAng
function CustomModelPart.setRot(ang) end

---Sets the scale of the part.
---@param pos VectorPos
function CustomModelPart.setScale(pos) end

---Sets the shader of the part.
---@param shader Shader
function CustomModelPart.setShader(shader) end

---Sets the UV offset of the part.
---
---Note: This does *not* set the actual UV of the part.
---@param uv VectorUV
function CustomModelPart.setUV(uv) end

---Toggles culling on the custom part.
---@param bool boolean
function CustomModelPart.setCullEnabled(bool) end

---Takes a `Vector` with a direction in world-space and
---returns a `Vector` with the direction relative to the part.
---
---Seems to act similar to `.partToWorldDir()`.
---@param dir VectorPos
---@return VectorPos
function CustomModelPart.worldToPartDir(dir) end

---Takes a `Vector` with a a blockbench position and returns a `Vector` with the world position
---relative to the player rotated by the part's rotation.
---@param pos VectorPos
---@return VectorPos
function CustomModelPart.worldToPartPos(pos) end

---@alias renderType
---|"BLOCK"
---|"ITEM"
---|"TEXT"

---@alias renderMode
---|"THIRD_PERSON_LEFT_HAND"
---|"THIRD_PERSON_RIGHT_HAND"
---|"FIRST_PERSON_LEFT_HAND"
---|"FIRST_PERSON_RIGHT_HAND"
---|"HEAD"
---|"GUI"
---|"GROUND"
---|"FIXED"

---renders an item, block or text
---***
---examples:  
---`model.part.addRenderTask("ITEM", "My Item", "iron_axe", "THIRD_PERSON_LEFT_HAND")`  
---`model.part.addRenderTask("BLOCK", "Awesome block", "minecraft:light_gray_stained_glass_pane", "FIXED")`  
---`model.part.addRenderTask("TEXT", "quote", "I am amazing")`  
---@param type renderType
---@param taskName string
---@param modes renderMode
function CustomModelPart.addRenderTask(type,taskName,modes) end

--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---The `table` containing the parts and folders from your blockbench model.
---
---If you want to get the Top hat on your model's head in this example...
---```
---Player
---├ Head
---│ └ TopHat
---└ Body
---  └ Belt
---```
---...then you need to use `model.Player.Head.TopHat` to access it.
---
---Note: Auto-completion does not know what folders and parts you have in your model at first, but
---will learn based on what folders and parts you access yourself.  
---If you want autocompletion for model paths, use
---[*Manuel-Underscore*'s Figura VSCode extension](https://marketplace.visualstudio.com/items?itemName=Manuel-Underscore.figura).  
---If you use the above extension, guessed parts will have a different icon from parts found in the
---model.
---@type CustomModelPartContainer
---model file.
model = {}

---A `table` containing the vanilla playermodel.
vanilla_model = {
  ---@type VanillaModelPart
  HEAD = {},

  ---@type VanillaModelPart
  HAT = {},

  ---@type VanillaModelPart
  TORSO = {},

  ---@type VanillaModelPart
  JACKET = {},

  ---@type VanillaModelPart
  LEFT_ARM = {},

  ---@type VanillaModelPart
  LEFT_SLEEVE = {},

  ---@type VanillaModelPart
  RIGHT_ARM = {},

  ---@type VanillaModelPart
  RIGHT_SLEEVE = {},

  ---@type VanillaModelPart
  LEFT_LEG = {},

  ---@type VanillaModelPart
  LEFT_PANTS_LEG = {},

  ---@type VanillaModelPart
  RIGHT_LEG = {},

  ---@type VanillaModelPart
  RIGHT_PANTS_LEG = {}
}

---A `table` containing the armor model.
armor_model = {
  ---@type BasicModelPart
  HELMET = {},

  ---@type BasicModelPart
  HEAD_ITEM = {},

  ---@type BasicModelPart
  CHESTPLATE = {},

  ---@type BasicModelPart
  LEGGINGS = {},

  ---@type BasicModelPart
  BOOTS = {}
}

---A `table` containing the elytra model.
elytra_model = {
  ---@type BasicModelPart
  LEFT_WING = {},

  ---@type BasicModelPart
  RIGHT_WING = {}
}

---A `table` containing the held item models.
held_item_model = {
  ---@type BasicModelPart
  LEFT_HAND = {},

  ---@type BasicModelPart
  RIGHT_HAND = {}
}

---A `table` containing the parrot models.
parrot_model = {
  ---@type BasicModelPart
  LEFT_PARROT = {},

  ---@type BasicModelPart
  RIGHT_PARROT = {}
}

---Scales the part.
---@param scale VectorPos
function VanillaModelPart.setScale(scale) end

---Scales the part.
---@param scale VectorPos
function BasicModelPart.setScale(scale) end

---@class texture
---@alias texture
---| '"Custom"'
---| '"Skin"'
---| '"Cape"'
---| '"Elytra"'
---| '"Resource"'
texture = {}


--- Textures:  
--- **Custom** = your custom texture, if any (default)  
--- **Skin** = your vanilla minecraft skin  
--- **Cape** = your cape, or Steve if you dont have a cape  
--- **Elytra** = your elytra texture (NOT the cape-provided elytra!) (vanilla probably dont even use it at all)  
--- **Resource** = any loaded vanilla texture! or missing texture if nor found (supports resource packs) (does NOT supports .mcmeta!)  
---@param type texture
function CustomModelPart.setTexture(type) end
