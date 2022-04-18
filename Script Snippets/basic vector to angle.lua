-- UP IS Y
function lookat(a,b)
    if type(a) == "table" then a = vectors.of(a) end
    if type(b) == "table" then b = vectors.of(b) end
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end
