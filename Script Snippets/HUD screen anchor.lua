--[[
parameters:
screen_coord -- value = TABLE
you give it a value ranging from -1 to 1 like screen coordinates, 
example: {-1,-1} = top left, {1,0} = right center
(note that you give it a table with 2 values, not a vector)

offset -- value = TABLE
note that you give it a table like this: {x,y} and not a vector
]]

function anchor(screen_coord,offset)
    return ((client.getWindowSize()*vectors.of{screen_coord[1],screen_coord[2]})/5)/client.getScaleFactor()+vectors.of{offset[1],offset[2]}
end