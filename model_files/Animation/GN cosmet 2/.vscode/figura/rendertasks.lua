--================================================================================================--
--=====  CLASSES  ================================================================================--
--================================================================================================--

---Render task types
---@alias RenderTaskType
---|'"ITEM"'
---|'"BLOCK"'
---|'"TEXT"'

---Render task modes for items
---@alias RenderMode
---|'"NONE"'
---|'"THIRD_PERSON_LEFT_HAND"'
---|'"THIRD_PERSON_RIGHT_HAND"'
---|'"FIRST_PERSON_LEFT_HAND"'
---|'"FIRST_PERSON_RIGHT_HAND"'
---|'"HEAD"'
---|'"GUI"'
---|'"GROUND"'
---|'"FIXED"

---@class RenderTaskTable
local RenderTaskTable = {}

---Returns if the renderTask uses emissive textures
---@return boolean
function RenderTaskTable.getEmissive() end

---Returns if the renderTask is currently enabled
---@return boolean
function RenderTaskTable.getEnabled() end

---Returns the relative position of the renderTask
---@return VectorPos
function RenderTaskTable.getPos() end

---Returns the relative rotation of the renderTask
---@return VectorAng
function RenderTaskTable.getRot() end

---Returns the relative scale of the renderTask
---@return Vector3
function RenderTaskTable.getScale() end

---Sets whether the renderTask uses emissive textures
---@param bool boolean
function RenderTaskTable.setEmissive(bool) end

---Sets whether the renderTask is enabled
---@param bool boolean
function RenderTaskTable.setEnabled(bool) end

---Sets the renderTask's position relative to the attatched model part
---@param pos VectorPos
function RenderTaskTable.setPos(pos) end

---Sets the renderTask's rotation relative to the attatched model part
---@param rot VectorAng
function RenderTaskTable.setRot(rot) end

---Sets the renderTask's scale relative to the attatched model part
---@param scale Vector3
function RenderTaskTable.setScale(scale) end

---@class ShaderAllowedTaskTable:RenderTaskTable
local ShaderAllowedTaskTable = {}

---Sets the renderlayer this rendertask will use
---@param renderlayerName string
function ShaderAllowedTaskTable.setRenderLayer(renderlayerName) end

---@class BlockTaskTable:ShaderAllowedTaskTable
local BlockTaskTable = {}

---Change the block the task is rendering
---@param block BlockState|string
function BlockTaskTable.setBlock(block) end

---@class ItemTaskTable:ShaderAllowedTaskTable
local ItemTaskTable = {}

---Change the item the task is rendering
---@param item ItemStack|string
function ItemTaskTable.setItem(item) end

---Change how the item will be rendered
---@param itemMode RenderMode
function ItemTaskTable.setItemMode(itemMode) end

---@class TextTaskTable:RenderTaskTable
local TextTaskTable = {}

---Sets the vertical space between newlines
---@param number number
function TextTaskTable.setLineSpacing(number) end

---Change the text the task is rendering
---@param text string
function TextTaskTable.setText(text) end
