-- UP IS Y
function math.toAngle(pos)
    if type(pos) == "table" then pos = vectors.of(pos) end
    local y = math.atan2(pos.x,pos.z)
    local result = vectors.of({math.atan2((math.sin(y)*pos.x)+(math.cos(y)*pos.z),pos.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end