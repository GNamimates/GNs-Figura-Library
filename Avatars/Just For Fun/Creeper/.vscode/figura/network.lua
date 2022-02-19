--================================================================================================--
--=====  FUNCTIONS  ==============================================================================--
--================================================================================================--

---@alias PingSupported boolean|number|string|table

---Contains functions that handle pings.
network = {}

---Registers a ping that allows you to send information to all clients running this script.  
---This is mainly used to sync variables that do not sync normally. (`Keybind`s, `action_wheel`
---functions, NBT, etc.)  
---You may register up to *65535* pings in one script.
---
---All examples in this description will assume that the ping is called *"pingname"*.
---```
---network.registerPing("pingname")
---```
---The ping is linked to a function of the same name, this function is not defined by default
---and it will need to defined so it can be used:
---```
---function pingname(param) --(Param is optional!)
---    --code here
---end
---```
---You can call this function by using:
---```
---network.ping("pingname", param) --(Param is optional!)
---```
---
---Note: Pings are also sent to yourself and will run their function on your script as well.
---@param ping string
function network.registerPing(ping) end


---Sends a ping out to all clients running this script.  
---Pings are 4 bytes big without a value.
---
---A ping may also contain a value to send with the ping. This adds 1 byte to the ping along with
---the following based on the type of value:
---* Nil: 0 bytes (`nil`)
---* Boolean: 1 byte (`true/false`)
---* Integer: 4 bytes (`-2147483648`..`2147483647`)
---* Float: 4 bytes (`-3.4028236692094e+38`..`3.4028236692094e+38`)
---* String: 2 bytes + (1000 characters) bytes
---* Table: 2 bytes + (Table contents) bytes
---
---You may only send up to 1024 bytes of pings a second, and only up to 32 pings a tick.
---
---Note: Pings are also sent to yourself.
---@param ping string
---@param value? PingSupported
function network.ping(ping, value) end
