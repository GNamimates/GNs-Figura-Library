---## How to use:
---1. insert the function into your script(duh XD)  
---1. simply call this function every tick and give it the values it needs
---> **position** - the position of the object.(Vector3)  
---> **velocity** - the velocity of the object.(Vector3)  
---> **gravity** - the gravity gets added to the velocity, .(Vector3)  
---> **friction** - the velocity gets multiplied to this value if its touching a surface, ex: 1 = super smooth surface, 0.1 = super rough surface.  
---1. it will return a table with these values:
---> **position** - the position with the physics applied.  
---> **lastPosition** - the position before the physics was applied.  
---> **velocity** - the position with the physics applied.  
---> **isColliding** - if the object is colliding with a surface.  
---> **SurfaceNormal** - the normal of the surface touching, will return nil if no surface was touched.  
---1. here is a basic script for using this function:  
---`position = vectors.of{0,0,0}`  
---`velocity = vectors.of{0,0,0}`  
---`function tick()`  
---`    local result = simulate(position,velocity,vectors.of{0,0.05,0},0.8)`  
---`    position = result.position`  
---`    velocity = result.velocity`  
---`end`  
function simulate(position,velocity,gravity,friction)
    lastPosition = position
    local isColliding = false
    local SurfaceNormal = nil
    local margin = 0.001 -- the lower the value, the more unstable the physics is, the higher the value, the more janky this is
    -- AXIS X
    local ray = renderer.raycastBlocks(position, position+velocity*vectors.of({1,0,0}), "COLLIDER", "NONE")
    if ray then--IF ON A WALL
        position = ray.pos + vectors.of({dotp(velocity.x)*-margin,0,0})
        velocity = velocity*vectors.of({-bouncyness,friction,friction})
        isColliding = true
        SurfaceNormal = vectors.of{-dotp(velocity.x),0,0}
    else
        velocity = velocity + vectors.of{gravity.x,0,0}
        position = position+velocity*vectors.of({1,0,0})
    end
    --AXIS Y
    
    ray = renderer.raycastBlocks(position, position+velocity*vectors.of({0,1,0}), "COLLIDER", "NONE")
    if ray then--IF ON A WALL
        position = ray.pos + vectors.of({0,dotp(velocity.y)*-margin,0})
        velocity = velocity*vectors.of({friction,-bouncyness,friction})
        isColliding = true
        SurfaceNormal = vectors.of{0,-dotp(velocity.y),0}
    else
        velocity = velocity + vectors.of{0,gravity.y,0}
        position = position+velocity*vectors.of({0,1,0})
    end
    --AXIS Z
    ray = renderer.raycastBlocks(position, position+velocity*vectors.of({0,0,1}), "COLLIDER", "NONE")
    if ray then--IF ON A WALL
        position = ray.pos + vectors.of({0,0,dotp(velocity.z)*-margin})
        velocity = velocity*vectors.of({friction,friction,-bouncyness})
        isColliding = true
        SurfaceNormal = vectors.of{0,0,-dotp(velocity.z)}
    else
        velocity = velocity + vectors.of{0,0,gravity.z}
        position = position+velocity*vectors.of({0,0,1})
    end
    return {position=position,velocity=velocity,lastPosition=lastPosition,isColliding=isColliding,SurfaceNormal=SurfaceNormal}
end

function dotp(x)
    return x/math.abs(x)
end