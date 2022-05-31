--================================================================================================--
--=====  CLASSES  ================================================================================--
--================================================================================================--

---A `table` with formatting keys.  
---The values in this table control what formatting effects are applied to the text.
---@class FormatTable
---@field BOLD? boolean
---@field ITALIC? boolean
---@field UNDERLINE? boolean
---@field OBFUSCATED? boolean
---@field STRIKETHROUGH? boolean

---A space with the player's name visible in it.
---@class Nameplate
local Nameplate = {}

---Returns the color of the nameplate.
---
---Note: Causes a VM Error if the color has not been set by `.setColor()`.
---@return VectorColor
function Nameplate.getColor() end

---Returns if the nameplate is visible.
---
---Note: Causes a VM Error if the state has not been set by `.setEnabled()`.
---@return boolean
function Nameplate.getEnabled() end

---Returns the formatting of the nameplate.
---@return FormatTable
function Nameplate.getFormatting() end

---Returns the position offset of the nameplate in blocks.  
---Returns `nil` if the position offset has not been set by `.setPos()`.
---
---Note: This value is not accurate if the player's entity is scaled.
---@return VectorPos|nil
function Nameplate.getPos() end

---Returns the scale of the nameplate.  
---Returns nil if the scale has not been set by `.setScale()`.
---@return VectorPos|nil
function Nameplate.getScale() end

---Returns the text in the nameplate.
---
---Note: Causes a VM Error if the text has not been set by `.setText()`.
function Nameplate.getText() end

---Sets the color of the nameplate.
---@param vec3 VectorColor
function Nameplate.setColor(vec3) end

---Does nothing...  
---For a version that does something, check the ENTITY nameplate.
---@param bool boolean
function Nameplate.setEnabled(bool) end

---Sets the formatting of the nameplate.
---@param format FormatTable
function Nameplate.setFormatting(format) end

---Does nothing...  
---For a version that does something, check the ENTITY nameplate.
---@param vec3 VectorPos
function Nameplate.setPos(vec3) end

---Does nothing...  
---For a version that does something, check the ENTITY nameplate.
---@param vec3 VectorPos
function Nameplate.setScale(vec3) end

---Sets the text of the nameplate.  
---All text is placed to the left of the Figura mark.
---@param str string
function Nameplate.setText(str) end

---EntityNameplate ⇐ Nameplate
---***
---Contains nameplate functions specific to the ENTITY nameplate.
---@class EntityNameplate : Nameplate
local EntityNameplate = {}

---*This function uses the `EntityNameplate` definition.*
---***
---Sets if the nameplate is visible.
---@param bool boolean
function EntityNameplate.setEnabled(bool) end

---*This function uses the `EntityNameplate` definition.*
---***
---Sets the position offset of the nameplate in blocks.
---
---Note: This value is not accurate if the player's entity is scaled.
---@param vec3 VectorPos
function EntityNameplate.setPos(vec3) end

---*This function uses the `EntityNameplate` definition.*
---***
---Sets the scale of the nameplate.
---@param vec3 VectorPos
function EntityNameplate.setScale(vec3) end

--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---Contains the player's nameplates.
---
---`CHAT` is the player's name in chat.  
---`ENTITY` is the nameplate above their head.  
---`LIST` is the player's name in the player list.
nameplate = {
  ---@type Nameplate
  CHAT = {},

  ---@type EntityNameplate
  ENTITY = {},

  ---@type Nameplate
  LIST = {}
}
