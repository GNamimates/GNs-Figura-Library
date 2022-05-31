
config = {
    world = {
        width = 5,
        height = 5,
        scale = 0.1,

        offsetX = 0,
        offsetY = 1,
        offsetZ = 0,
    },
    
}

world = {

}

model = model.NO_PARENT
config.world.offsetX = config.world.offsetX * -16
config.world.offsetY = config.world.offsetY * -16
config.world.offsetZ = config.world.offsetZ * 16


function player_init()
    createWorld()
    entity = createEntity(5,5)
    for x = 1, config.world.height, 1 do
        for y = 1, config.world.width, 1 do
            for key, value in pairs(world[x][y]) do
                logTable(value.brain.layers[value.brain.HiddenLayerCount+1])
            end
        end
    end
end

function createWorld()
    for x = 1, config.world.height, 1 do
        world[x] = {}
        for y = 1, config.world.width, 1 do
            world[x][y] = {}
            if math.random() < 0.1 then
                createTile(x,y,1)
            else
                createTile(x,y,0)
            end
        end
    end
end

function createTile(x,y,type)
    local block = "grass_block"
    if type == 1 then
        block = "oak_leaves"
    end
    model.addRenderTask("BLOCK",stringCoords2D(x,y),block,false,{
        x*-16*config.world.scale+config.world.offsetX,
        config.world.offsetY,
        y*16*config.world.scale+config.world.offsetZ,
    },{0,0,0},{
        config.world.scale,
        config.world.scale,
        config.world.scale
    })
end

function stringCoords2D(x,y)
    return "x"..tostring(x).."y"..tostring(y)
end

entityCount = 0

function createEntity(x,y)
    for i = 1, 10, 1 do
        if not world[x][y][i] then
            entityCount = entityCount + 1
            world[x][y][i] = {
                x = x,
                y = y,
                chunkID = i,
                worldID = entityCount,
                brain = neural.ConnectNeurals(neural.createBrain(config.world.width*config.world.height,4,3)),
            }
            model.addRenderTask("BLOCK",tostring(entityCount),"red_terracotta",false,{
                x*-16*config.world.scale+config.world.offsetX,
                config.world.offsetY-16*config.world.scale,
                y*16*config.world.scale+config.world.offsetZ,
            },{0,0,0},{
                config.world.scale,
                config.world.scale,
                config.world.scale
            })
            return world[x][y][i]
        end
    end
end

function moveEntity(entity,x,y)
    entity.x = math.clamp(entity.x + x,1,config.world.width)
    entity.y = math.clamp(entity.y + y,1,config.world.height)
    model.getRenderTask(tostring(entity.worldID)).setPos({
        entity.x*-16*config.world.scale+config.world.offsetX,
        config.world.offsetY-16*config.world.scale,
        entity.y*16*config.world.scale+config.world.offsetZ,
    })
    local movingEntity = table.remove(world[entity.x][entity.y],entity.id)
    for i = 1, 10, 1 do
        if not getWorldPos(entity.x+x,entity.y+y)[i] then
            getWorldPos(entity.x+x,entity.y+y)[i] = movingEntity
            return
        end
    end
end

function getWorldPos(x,y)
    return world[math.clamp(x,1,config.world.width)][math.clamp(y,1,config.world.height)]
end

neural = {}

function neural.new()
    return {
        inputs = {},

        weight = 0,
        bias = 0,
        
        mutationFreq = 0.1,
        mutationPower = 0.3,
        
        output = 0,
    }
end

function neural.createBrain(inputCount,outputCount,HiddenLayerCount)
    local brain = {
        layers = {},
        inputCount = inputCount,
        outputCount = outputCount,
        HiddenLayerCount = HiddenLayerCount,
    }
    for i = 1, HiddenLayerCount, 1 do
        brain.layers[i] = {}
        for j = 1, inputCount, 1 do
            brain.layers[i][j] = neural.new()
        end
    end
    brain.layers[HiddenLayerCount+1] = {}
    for i = 1, outputCount, 1 do
        brain.layers[HiddenLayerCount+1][i] = neural.new()
    end
    return brain
end

function neural.ConnectNeural(n1,n2)
    n1.inputs[#n1.inputs+1] = n2
end

function neural.tickBrain(brian)
    for i = 1, brian.HiddenLayerCount, 1 do
        for j = 1, brian.inputCount, 1 do
            brian.layers[i][j].output = brian.layers[i][j].inputs[j]
        end
        for j = 1, brian.inputCount, 1 do
            brian.layers[i][j].output = brian.layers[i][j].output * brian.layers[i][j].weight + brian.layers[i][j].bias
        end
        for j = 1, brian.inputCount, 1 do
            brian.layers[i][j].output = math.sigmoid(brian.layers[i][j].output)
        end
    end
    for i = 1, brian.outputCount, 1 do
        brian.layers[brian.HiddenLayerCount+1][i].output = brian.layers[brian.HiddenLayerCount+1][i].inputs[i]
        brian.layers[brian.HiddenLayerCount+1][i].output = brian.layers[brian.HiddenLayerCount+1][i].output * brian.layers[brian.HiddenLayerCount+1][i].weight + brian.layers[brian.HiddenLayerCount+1][i].bias
        brian.layers[brian.HiddenLayerCount+1][i].output = math.sigmoid(brian.layers[brian.HiddenLayerCount+1][i].output)
    end
end

function neural.mutateBrain(brain)
    for i = 1, brain.HiddenLayerCount, 1 do
        for j = 1, brain.inputCount, 1 do
            if math.random() < brain.layers[i][j].mutationFreq then
                brain.layers[i][j].weight = brain.layers[i][j].weight + math.random() * brain.layers[i][j].mutationPower * 2 - brain.layers[i][j].mutationPower
            end
            if math.random() < brain.layers[i][j].mutationFreq then
                brain.layers[i][j].bias = brain.layers[i][j].bias + math.random() * brain.layers[i][j].mutationPower * 2 - brain.layers[i][j].mutationPower
            end
        end
    end
    for i = 1, brain.outputCount, 1 do
        if math.random() < brain.layers[brain.HiddenLayerCount+1][i].mutationFreq then
            brain.layers[brain.HiddenLayerCount+1][i].weight = brain.layers[brain.HiddenLayerCount+1][i].weight + math.random() * brain.layers[brain.HiddenLayerCount+1][i].mutationPower * 2 - brain.layers[brain.HiddenLayerCount+1][i].mutationPower
        end
        if math.random() < brain.layers[brain.HiddenLayerCount+1][i].mutationFreq then
            brain.layers[brain.HiddenLayerCount+1][i].bias = brain.layers[brain.HiddenLayerCount+1][i].bias + math.random() * brain.layers[brain.HiddenLayerCount+1][i].mutationPower * 2 - brain.layers[brain.HiddenLayerCount+1][i].mutationPower
        end
    end
end

function math.sigmoid(x)
    return 1/(1+math.exp(-x))
end