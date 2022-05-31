--================================================================================================--
--=====  CLASSES  ================================================================================--
--================================================================================================--

---A side slot number.
---@alias SlotSideNumber
---| "1"
---| "2"
---| "3"
---| "4"

---A wheel slot number.
---@alias SlotNumber
---| "1"
---| "2"
---| "3"
---| "4"
---| "5"
---| "6"
---| "7"
---| "8"

---@alias ActionWheelTextureType TextureType
---| '"None"' #Nothing, uses an item instead.

---A slot on the action wheel.
---@class ActionWheelSlot
local ActionWheelSlot = {}

---Clears the slot of all of its changes.
function ActionWheelSlot.clear() end

---Returns the current color of the slot.  
---Returns `nil` if the color has not been set by `.setColor()`.
---@return VectorColor|nil
function ActionWheelSlot.getColor() end

---Returns the current function of the slot.  
---Returns `nil` if the function has not been set by `.setFunction()`.
---@return function|nil
function ActionWheelSlot.getFunction() end

---Returns the current hover color of the slot.  
---Returns `nil` if the hover color has not been set by `.setHoverColor()`.
---@return VectorColor|nil
function ActionWheelSlot.getHoverColor() end

---Returns the current hover item of the slot.  
---Returns `nil` if the hover item has not been set by `.setHoverItem()`.
---@return ItemStack|nil
function ActionWheelSlot.getHoverItem() end

---Returns the current item icon of the slot.  
---Returns `nil` if the item has not been set by `.setItem()`.
---@return ItemStack|nil
function ActionWheelSlot.getItem() end

---Returns the type of texture used.
---@return ActionWheelTextureType
function ActionWheelSlot.getTexture() end

---Returns the scale of the texture set by setTextureScale
---@return Vector2
function ActionWheelSlot.getTextureScale() end

---Returns the current title of the slot.
---
---Note: Causes a VM Error if the title has not been set by `.setTitle()`.
function ActionWheelSlot.getTitle() end

---Returns the UV used for rendering the texture as well as the texture size.
---First two numbers are the offset
---Next two numbers are the size of the UV
---Last two numbers are the size of the texture itself
---@return Vector6
function ActionWheelSlot.getUV() end

---Sets the color that the slot should be when idle.
---@param col VectorColor
function ActionWheelSlot.setColor(col) end

---Sets the function to run when the slot is clicked.
---Second parameter gets fed into the given function.
---@param func function
---@param parameter? any
function ActionWheelSlot.setFunction(func,parameter) end

---Sets the color that the slot should be when hovered over.
---@param col VectorColor
function ActionWheelSlot.setHoverColor(col) end

---Sets the item that should appear when the slot is hovered over.
---@param item ItemStack|string
function ActionWheelSlot.setHoverItem(item) end

---Sets the item that should appear when the slot is idle.
---@param item ItemStack|string
function ActionWheelSlot.setItem(item) end

---Sets the action wheel custom texture.
---ID is only needed if type or "Resource"
---@param type ActionWheelTextureType
---@param ID string
function ActionWheelSlot.setTexture(type, ID) end

---Sets the scale of the texture.
---@param vector Vector2
function ActionWheelSlot.setTextureScale(vector) end

---Sets the title of the slot.
---@param str string
function ActionWheelSlot.setTitle(str) end

---Sets the UV and the texture size
---@param uvOffset Vector2
---@param uvSize Vector2
---@param textureSize Vector2
function ActionWheelSlot.setUV(uvOffset, uvSize, textureSize) end


--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---The action wheel. This has up to 8 slots that can be customized to do whatever you want.  
---Hold the `Miscellaneous: Figura Action Wheel` keybind to use the action wheel.
action_wheel = {
  SLOT_1 = ActionWheelSlot,
  SLOT_2 = ActionWheelSlot,
  SLOT_3 = ActionWheelSlot,
  SLOT_4 = ActionWheelSlot,
  SLOT_5 = ActionWheelSlot,
  SLOT_6 = ActionWheelSlot,
  SLOT_7 = ActionWheelSlot,
  SLOT_8 = ActionWheelSlot
}

---Returns the amount of slots on the left side of the action wheel.
---@return SlotSideNumber number
function action_wheel.getLeftSize() end

---Returns the amount of slots on the right side of the action wheel.
---@return SlotSideNumber number
function action_wheel.getRightSize() end

---Returns the slot that is currently being hovered over.
---@return SlotNumber number
function action_wheel.getSelectedSlot() end

---Executes the function of the hovered over actionwheel
function action_wheel.runAction() end

---Sets the amount of slots on the left side of the action wheel.
---@param size SlotSideNumber
function action_wheel.setLeftSize(size) end

---Sets the amount of slots on the right side of the action wheel.
---@param size SlotSideNumber
function action_wheel.setRightSize(size) end

---Returns if the action wheel is currently open or not
---@return boolean
function action_wheel.isOpen() end
