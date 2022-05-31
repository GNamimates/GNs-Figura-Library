--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---Contains functions relating to the chat.
chat = {}

---Retrieves a message from chat.  
---Messages are ordered from bottom to top, starting at 1.
---@param num number
---@return string
function chat.getMessage(num) end

---Sends a message as yourself.
---@param str string
function chat.sendMessage(str) end

---Sets the command prefix to the given string.
---
---Create a function `onCommand(cmd)` to catch commands typed by you into chat.
---@param str string
function chat.setFiguraCommandPrefix(str) end
