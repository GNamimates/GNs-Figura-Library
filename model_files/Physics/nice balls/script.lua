
instance = {}
chunk = {}

throw = keybind.newKey("R","R")

sphereCount = 60

function instanceNewObject(id)
    table.insert(instance,{
        position = vectors.of({-29+math.random()*0.1,29,-6+math.random()*0.1}),
        velocity = vectors.of({0,0,0}),
        lastPosition = vectors.of({}),
        id = id,
    })
    --model["NO_PARENT"..tostring(id)]["CAMERA"..tostring(id)].addRenderTask("TEXT", "id", tostring(id))
    model["NO_PARENT"..tostring(id)].setColor(vectors.hsvToRGB({id*1.1111111,1,1}))
end

function player_init()
    for index = 1, sphereCount, 1 do
        instanceNewObject(index)
    end
end

c = 0
function tick()
    if throw.wasPressed() then
        c = (c+1) % sphereCount
        instance[c+1].position = player.getPos()+vectors.of({0,player.getEyeHeight()})
        instance[c+1].velocity = player.getLookDir()
    end
    for index, p in pairs(instance) do
        p.lastPosition = p.position
        p.position = p.position + p.velocity
        p.velocity = p.velocity + vectors.of({0,-0.05,0})

        local lastP = p.position
        

        p.velocity = p.velocity * vectors.of({0.9,1,0.9})
        for _ = 1, 1, 1 do
            for indx = 1, sphereCount, 1 do
                if indx ~= p.id then
                    if p.position.distanceTo(instance[indx].position) < 1 then
                        local b = instance[indx]
                        local normal = (p.position-b.position).normalized()
                        local deepness = (1+(b.position-p.position).getLength()*-1)
                        p.velocity = p.velocity + normal*deepness
                        p.position = p.position + normal.normalized()*deepness
        
                        b.velocity = b.velocity - normal*deepness
                        b.position = b.position - normal*deepness
                        
                    end
                end
            end
            p.position = vectors.of({clamp(p.position.x,-29.5,-24.5),clamp(p.position.y,24.5,34),clamp(p.position.z,-5.5,-1.5)})
            
            if p.position.distanceTo(player.getPos()) < 2 then
                local pPos = player.getPos()+vectors.of({0,0.5,0})
                local normal = (pPos-p.position).normalized()*(2+(pPos-p.position).getLength()*-1)
                p.velocity = p.velocity - normal
                p.position = p.position - normal
            end
            if (lastP-p.position).getLength() > 0 then
                p.velocity = (p.velocity*0.8) + vectors.of({lerp(-0.001,0.001,math.random()),lerp(-0.001,0.001,math.random()),lerp(-0.001,0.001,math.random())})
            end
        end
    end
end

function world_render(delta)
    for index, p in pairs(instance) do
        model["NO_PARENT"..tostring(index)].setPos(vectors.lerp(p.lastPosition,p.position,delta)*vectors.of({-16,-16,16}))
    end
end

function lerp(a, b, x)
    return a + (b - a) * x
end


function clamp(value,low,high)
    return math.min(math.max(value, low), high)
end