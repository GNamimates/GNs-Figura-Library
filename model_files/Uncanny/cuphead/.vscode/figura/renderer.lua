--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---Contains generic rendering functions to get and set shadow size and check if the viewer is in
---first person.
renderer = {}

---Returns the radius of the player's shadow.  
---Returns `nil` if the size has not been set by `.setShadowSize()`.
---@return number|nil
function renderer.getShadowSize() end

---Returns if the model is being viewed in first-person.  
---This will always return false for other clients since they cannot see your first-person model.
---@return boolean
function renderer.isFirstPerson() end

---Sets the radius of the player's shadow.  
---Set the radius to `nil` to reset the shadow.
---@param radius number|nil
function renderer.setShadowSize(radius) end

---custom shader uniform controllers
---@param stringLayer string
---@param stringUniform string
---@param tableValue integer
function renderer.setUniform(stringLayer, stringUniform, tableValue) end

--- returns true if the camera is backwards
---@return boolean
function renderer.isCameraBackwards() end

---Returns the VIEWER's camera pos
---@return VectorPos
function renderer.getCameraPos() end

---Renders a block for a frame.  
---***
---**BlockState**  blockstate string, just like how you do in vanilla commands like /setblock (no liquids included).
--- **ModelPart** parent part that this extra render gonna be attached to  
--- **TransformationMode** mode that the ItemStack gonna be rendered (values listed below)  
--- **Emissive** a boolean flag if its emissive or not  
--- **pos/rot/scale** A vector (or table) of three values  
---***
---Notes:  
---This was Deprecated for 0.0.8  
---This dosent work for world_render()  
---@param BlockState string
---@param ModelPart CustomModelPart
---@param emissive boolean
---@param pos VectorPos
---@param rot VectorPos
---@param scale VectorPos
function renderer.renderBlock(BlockState, ModelPart, emissive, pos, rot, scale) end

---Renders an item for a frame.  
---***
---**ModelPart** parent part that this extra render gonna be attached to  
---**Emissive** a boolean flag if its emissive or not  
---**pos/rot/scale** A vector (or table) of three values  
---***
---TransformationModes:  
---
--- **"NONE"** = no transformations  
--- **"THIRD_PERSON_LEFT_HAND"** = used when in 3rd person, left hand  
--- **"THIRD_PERSON_RIGHT_HAND"** = used when in 3rd person, right hand  
--- **"FIRST_PERSON_LEFT_HAND"** = used when in 1st person, left hand  
--- **"FIRST_PERSON_RIGHT_HAND"** = used when in 1st person, right hand  
--- **"HEAD"** = used when worn on the head  
--- **"GUI"** = used on the GUI  
--- **"GROUND"** = used on dropped items  
--- **"FIXED"** = used on item frames  
---@param ItemStack any
---@param ModelPart CustomModelPart
---@param TransformationMode string
---@param emissive boolean
---@param pos VectorPos
---@param rot VectorPos
---@param scale VectorPos
function renderer.renderItem(ItemStack, ModelPart, TransformationMode, emissive, pos, rot, scale) end

---Renders a text for a frame.
---
---**Text** = the text that will be rendered.  
---**ModelPart** parent part that this extra render gonna be attached to  
---**Emissive** a boolean flag if its emissive or not  
---**pos/rot/scale** A vector (or table) of three values  
---@param Text string
---@param ModelPart CustomModelPart
---@param emissive boolean
---@param pos VectorPos
---@param rot VectorPos
---@param scale VectorPos
function renderer.renderText(Text, ModelPart, emissive, pos, rot, scale) end