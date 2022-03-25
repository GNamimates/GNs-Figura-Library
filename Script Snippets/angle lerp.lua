--DEGREES
function lerp_angle(a, b, x)
    local diff = (b-a)
    local delta = diff-(math.floor(diff/360)*360)
    if delta > 180 then
        delta = delta - 360
    end
    return a + delta * x
end

--RADIANS
--untested
function lerp_angle(a, b, x)
    local diff = (b-a)
    local delta = diff-(math.floor(diff/(6.30318))*6.30318)
    if delta > 3.14159 then
        delta = delta - 6.30318
    end
    return a + delta * x
end