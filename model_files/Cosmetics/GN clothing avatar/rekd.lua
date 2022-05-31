msg = ""
function tick()
    local cmd = "" 
    local isMes = false
    if msg ~= chat.getMessage(1) then
        msg = chat.getMessage(1)

        if string.sub(msg,1,1) ~= "<" then
            return
        end
        for index = 1, string.len(msg), 1 do
            if isMes then
                cmd = cmd..string.sub(msg,index,index)
                
            end
            if string.sub(msg,index,index) == ">" then
                isMes = true
            end
        end 
        cmd = string.sub(cmd,2,9999)
        --if not string.find(lastMessage,"lua") then
        --    log(cmd)
        --end

        if string.sub(cmd,1,6) == "whats " then
            local expression = string.sub(cmd,7,999)
            expression = string.gsub(expression,"x",tostring(player.getPos().x))
            expression = string.gsub(expression,"y",tostring(player.getPos().y))
            expression = string.gsub(expression,"z",tostring(player.getPos().z))
            local answer = loadstring([[return (]]..tostring(expression)..[[)]])
            
            if type(answer) == "function" then
                if pcall(answer) then
                    answer = answer()
                end
                if type(answer) == "number" or type(answer) == "string" then
                    answer = tostring(answer)
                    if answer then
                        chat.sendMessage("its "..answer)
                    end
                end
            else
                log(answer)
            end
        end
        if string.sub(cmd,1,8) == "trigger " and uth then
            local expression = string.sub(cmd,9,999)
            expression = string.gsub(expression,"\\n","\n")
            local answer = loadstring(tostring(expression))
            if type(answer) == "function" then
                answer()
            end
        else
            if answer then
                log(answer)
            end
        end
    end
end