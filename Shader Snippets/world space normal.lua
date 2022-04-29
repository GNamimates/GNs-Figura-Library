--[[
    ORIGINAL IDEA & LAYOUT BY: Maya/devnull#0759
]]

function render()--calculates the Camera Matrix
    local zero = vectors.worldToCameraPos({0, 0, 0})
    local x = vectors.worldToCameraPos({-1, 0, 0})-zero
    local y = vectors.worldToCameraPos({0, -1, 0})-zero
    local z = vectors.worldToCameraPos({0, 0, -1})-zero
    local matrix = {-x[1], -y[1], -z[1], -x[2], -y[2], -z[2], x[3], y[3], z[3]}
    renderlayers.setUniform("Shader","CameraMatrix",matrix)
end

--[=[ FRAGMENT SHADER ]]
    vec3 WorldNormal = MayaMatrix * normal;
]=]