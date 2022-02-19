pointA = vectors.of({0,0,0})
pointB = vectors.of({0,0,0})

Dimensions = vectors.of{0,0,0}

itemsAsBlocks = {"minecraft:water_bucket","water","minecraft:lava_bucket","lava","minecraft:flint_and_steel","fire","minecraft:fire_charge","fire"}

--CONFIG
Selection_Wand = "minecraft:golden_shovel"

actionWheelPage = 0
--0 = default menu (only area stuff)
--1 = pointA selection
--2 = pointB selection
--3 = GNamimates is poggers

function player_init()
    changeActionWheelPage(0)
end

function tick()
	
    if actionWheelPage == 1 or actionWheelPage == 2 then
        
        if player.getTargetedBlockPos(false) ~= nil then
            model.NO_PARENT.selection.setPos({player.getTargetedBlockPos(false).x*-16,player.getTargetedBlockPos(false).y*-16,player.getTargetedBlockPos(false).z*16})
            model.NO_PARENT.selection.setEnabled(true)
        else
            model.NO_PARENT.selection.setEnabled(false)
        end
    else
        model.NO_PARENT.selection.setEnabled(false)
    end
end

function changeActionWheelPage(page)
    actionWheelPage = page
    action_wheel.SLOT_1.clear()
    action_wheel.SLOT_2.clear()
    action_wheel.SLOT_3.clear()
    action_wheel.SLOT_4.clear()
    action_wheel.SLOT_5.clear()
    action_wheel.SLOT_6.clear()
    action_wheel.SLOT_3.clear()
    action_wheel.SLOT_8.clear()

    if page == 0 then
        action_wheel.setLeftSize(2)
        action_wheel.setRightSize(2)
        
        action_wheel.SLOT_1.setItem(item_stack.createItem("minecraft:yellow_terracotta"))
        action_wheel.SLOT_1.setTitle("Select First Position")
        action_wheel.SLOT_1.setFunction(function ()
            changeActionWheelPage(1)
            log("Select First Position..")
        end)

        action_wheel.SLOT_4.setItem(item_stack.createItem("minecraft:black_terracotta"))
        action_wheel.SLOT_4.setTitle("Select Second Position")
        action_wheel.SLOT_4.setFunction(function ()
            changeActionWheelPage(2)
            log("Select Second Position..")
        end)

		action_wheel.SLOT_2.setItem(item_stack.createItem("minecraft:bucket"))
        action_wheel.SLOT_2.setTitle("Fill area with held Item")
        action_wheel.SLOT_2.setFunction(function ()
        if player.getHeldItem(1) ~= nil then
            local with = player.getHeldItem(1).getType()
                --filter
                local length = 0
                for _ in pairs(itemsAsBlocks) do length = length + 1 end
                
                for I = 1, length, 2 do
                    if with == itemsAsBlocks[I] then
                        with = itemsAsBlocks[I+1]
                    end
                end
                
                chat.sendMessage("/fill "..pointA.x.." "..pointA.y.." "..pointA.z.." "..pointB.x.." "..pointB.y.." "..pointB.z.." "..with)
			else
				chat.sendMessage("/fill "..pointA.x.." "..pointA.y.." "..pointA.z.." "..pointB.x.." "..pointB.y.." "..pointB.z.." minecraft:air")
			end
        end)
    end

	if page == 3 then
        action_wheel.setLeftSize(2)
        action_wheel.setRightSize(2)
        
        action_wheel.SLOT_1.setItem(item_stack.createItem("minecraft:yellow_terracotta"))
        action_wheel.SLOT_1.setTitle("Select First Position")
        action_wheel.SLOT_1.setFunction(function ()
            changeActionWheelPage(1)
            log("Select First Position..")
        end)

        action_wheel.SLOT_4.setItem(item_stack.createItem("minecraft:black_terracotta"))
        action_wheel.SLOT_4.setTitle("Select Second Position")
        action_wheel.SLOT_4.setFunction(function ()
            changeActionWheelPage(2)
            log("Select Second Position..")
        end)
    end

    if page == 1 or page == 2 then
        action_wheel.SLOT_1.setItem(item_stack.createItem("minecraft:lime_terracotta"))
        action_wheel.SLOT_1.setTitle("Accept")
        action_wheel.SLOT_1.setFunction(function ()
            if player.getTargetedBlockPos(false) ~= nil then
                if page == 1 then pointA = player.getTargetedBlockPos(false) end
                if page == 2 then pointB = player.getTargetedBlockPos(false) end
            else
                if page == 1 then pointA = vectors.of({math.floor(player.getPos().x),math.floor(player.getPos().y),math.floor(player.getPos().z)}) end
                if page == 2 then pointB = vectors.of({math.floor(player.getPos().x),math.floor(player.getPos().y),math.floor(player.getPos().z)}) end
            end
            if page == 1 then log("First Position Set to: "..pointA.x.." "..pointA.y.." "..pointA.z) end
            if page == 2 then log("Second Position Set to: "..pointB.x.." "..pointB.y.." "..pointB.z) end
            updateArea()
            changeActionWheelPage(0)
            
        end)
        
        action_wheel.SLOT_4.setItem(item_stack.createItem("minecraft:red_concrete"))
        action_wheel.SLOT_4.setTitle("Cancel")
        action_wheel.SLOT_4.setFunction(function ()
            changeActionWheelPage(0)
            log("Canceled")
        end)

    end
end

function updateArea()
	model.NO_PARENT.pointA.setPos({pointA.x*-16,pointA.y*-16,pointA.z*16})
	model.NO_PARENT.pointB.setPos({pointB.x*-16,pointB.y*-16,pointB.z*16})
	Dimensions = {math.abs(pointA.x-pointB.x)+1,math.abs(pointA.y-pointB.y)+1,math.abs(pointA.z-pointB.z)+1}
	model.NO_PARENT.Area.setPos({0,0,0})
	if pointA.x < pointB.x then
		model.NO_PARENT.Area.setPos(model.NO_PARENT.Area.getPos()+vectors.of({pointA.x,0,0}))
	else
		model.NO_PARENT.Area.setPos(model.NO_PARENT.Area.getPos()+vectors.of({pointB.x,0,0}))
	end
	if pointA.y < pointB.y then
		model.NO_PARENT.Area.setPos(model.NO_PARENT.Area.getPos()+vectors.of({0,pointA.y,0}))
	else
		model.NO_PARENT.Area.setPos(model.NO_PARENT.Area.getPos()+vectors.of({0,pointB.y,0}))
	end
	if pointA.z < pointB.z then
		model.NO_PARENT.Area.setPos(model.NO_PARENT.Area.getPos()+vectors.of({0,0,pointA.z}))
	else
		model.NO_PARENT.Area.setPos(model.NO_PARENT.Area.getPos()+vectors.of({0,0,pointB.z}))
	end
	model.NO_PARENT.Area.setPos({model.NO_PARENT.Area.getPos().x*-16,model.NO_PARENT.Area.getPos().y*-16,model.NO_PARENT.Area.getPos().z*16})
	model.NO_PARENT.Area.setScale(Dimensions)
end