
InteractKey = keybind.getRegisteredKeybind("key.use")

--CONFIG
BRUSH = "minecraft:spectral_arrow"
SIZE = 3

state = 0
mode = {
    INSERT = 0,
    PAINT = 1,
}

filters = {"minecraft:water_bucket","minecraft:lava_bucket","minecraft:flint_and_steel","minecraft:fire_charge"}
filterReplacements = {"water","lava","fire","fire"}

action_wheel.setRightSize(2)
action_wheel.SLOT_1.setItem(item_stack.createItem("minecraft:lime_terracotta"))
action_wheel.SLOT_1.setTitle("Increase Radius")
action_wheel.SLOT_1.setFunction(function ()
    SIZE =math.max(SIZE + 1,1)
    log("Brush Size Increased to "..SIZE)
    bakeSphereMaskingArea()
end)

action_wheel.SLOT_2.setItem(item_stack.createItem("minecraft:red_terracotta"))
action_wheel.SLOT_2.setTitle("Decrease Radius")
action_wheel.SLOT_2.setFunction(function ()
    SIZE = math.max(SIZE - 1,1)
    log("Brush Size Decreased to "..SIZE)
    bakeSphereMaskingArea()
end)

action_wheel.SLOT_8.setItem(item_stack.createItem("minecraft:dispenser"))
action_wheel.SLOT_8.setTitle("Insert mode")
action_wheel.SLOT_8.setFunction(function ()
    state = mode.INSERT
    log("Brush set to Insert Mode")
end)

action_wheel.SLOT_7.setItem(item_stack.createItem("minecraft:water_bucket"))
action_wheel.SLOT_7.setTitle("Paint mode")
action_wheel.SLOT_7.setFunction(function ()
    state = mode.PAINT
    log("Brush set to Paint Mode")
end)

--no touchies
mask = {}

function player_init()
    bakeSphereMaskingArea()
end

forceStop = false

function tick()
    
    if player.getHeldItem(2) ~= nil and player.getTargetedBlockPos(false) ~= nil then
        log("a")
        if player.getHeldItem(1) ~= nil then
            if player.getHeldItem(2).getType() == BRUSH then
            
                    filteredHolding = player.getHeldItem(1).getType()
                    for I, GN in pairs(filters) do
                        if filteredHolding == filters[I] then
                            filteredHolding = filterReplacements[I]
                        end
                    end 
                
                
                if state == mode.INSERT then--INSERT MODE
                    if InteractKey.isPressed() then
                        if not forceStop then
                            local place = player.getTargetedBlockPos(false)
                            --GN is weird :/
                            for key, current in pairs(mask) do
                                if player.getHeldItem(2) ~= nil then
                                    if world.getBlockState(current+place).name ~= filteredHolding then
                                        chat.sendMessage("/setblock "..(current.x+place.x).." "..(current.y+place.y).." "..(current.z+place.z).." "..filteredHolding)
                                    end
                                end
                            end
                        end
                        forceStop = true
                    else
                        forceStop = false
                    end
                end
                if state == mode.PAINT then--INSERT MODE
                    if InteractKey.isPressed() then
                        local place = player.getTargetedBlockPos(false)
                        for key, current in pairs(mask) do
                            if player.getHeldItem(2) ~= nil then
                                if world.getBlockState(current+place).name ~= filteredHolding and world.getBlockState(current+place).name ~= "minecraft:air" then
                                    chat.sendMessage("/setblock "..(current.x+place.x).." "..(current.y+place.y).." "..(current.z+place.z).." "..filteredHolding)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function bakeSphereMaskingArea()
    mask = {}
    for X = -SIZE, SIZE do
        for Y = -SIZE, SIZE do
            for Z = -SIZE, SIZE do
                local current = vectors.of({X,Y,Z})
                if TableDistance({X,Y,Z}) < SIZE-0.5 then
                    table.insert(mask,current)
                end
                
            end
        end
    end
end

function TableDistance(table)
    local val = 0
    for _,current in pairs(table) do
        val = val+ math.pow(current,2)
    end
    val = math.sqrt(val)
    return val
end