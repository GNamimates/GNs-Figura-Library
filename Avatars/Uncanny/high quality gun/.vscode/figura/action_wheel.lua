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

---Returns the current title of the slot.
---
---Note: Causes a VM Error if the title has not been set by `.setTitle()`.
function ActionWheelSlot.getTitle() end

---Sets the color that the slot should be when idle.
---@param col VectorColor
function ActionWheelSlot.setColor(col) end

---Sets the function to run when the slot is clicked.
---@param func function
function ActionWheelSlot.setFunction(func) end

---Sets the color that the slot should be when hovered over.
---@param col VectorColor
function ActionWheelSlot.setHoverColor(col) end

---Sets the item that should appear when the slot is hovered over.
---@param item ItemStack
function ActionWheelSlot.setHoverItem(item) end

---Sets the item that should appear when the slot is idle.
---@param item ItemStack
function ActionWheelSlot.setItem(item) end

---Sets the title of the slot.
---@param str string
function ActionWheelSlot.setTitle(str) end


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

---Sets the amount of slots on the left side of the action wheel.
---@param size SlotSideNumber
function action_wheel.setLeftSize(size) end

---Sets the amount of slots on the right side of the action wheel.
---@param size SlotSideNumber
function action_wheel.setRightSize(size) end
