--==========================
--RAGDOLL PHYSICS
--a collaboration of SUwUperJ0w0llyGNyamimates#9366 aka GNamimates and LimeNewon aka 緑のネオン, what ever that means lol
--thanks to Fran for the armor code <3 (purple)
--==BETA STAGES LOL

--===========CONFIG BITCHES=============-------

splatTimeDuration = 20 -- in ticks | second * 20 = ticks
hurtSplatDuration = 10 -- splat time when getting hurt
--the amount of time the ragdoll will deattach to the player when getting 

friction = vectors.of({0.8,-1,0.8})--setting the Y to negative makes the player bouncy
waterFriction = vectors.of({0.8,0.8,0.8})
trueGravity = vectors.of({0,-0.1,0})
hurtSoundTolerance = 0.5 -- the lower, the more hurt sound plays

--the distance before the ragdoll simulation stops for the remote viewer
distanceBeforeStopSimulation = 64

--==================GN==================-------

--NOT CONFIG ZONE
points = {}
lines = {}

pointsCount = 12
linesCount = 6

gravity = vectors.of({0,-0.1})

for _, v in pairs(vanilla_model) do
    v.setEnabled(false)
end

for _, v in pairs(armor_model) do
    v.setEnabled(false)
end

pos = nil
_pos = nil
velocity = nil
lastVelocity = velocity
momentum = 0
lastMomentum = momentum

function player_init()
    pos = player.getPos()
    _pos = pos
    lastVelocity = velocity
    velocity = vectors.of({0})
end
    

tookDamageDelay = 0
didTookDamage = false
function onDamage(dmg)
    splatTime = hurtSplatDuration
    tookDamageDelay = 2
    didTookDamage = true
end

distVel = 0

splatTime = 0

attack = keybind.getRegisteredKeybind("key.attack")
interact = keybind.getRegisteredKeybind("key.use")
deattach = keybind.newKey("de-attach","H")
wasDeattach = false


function player_init()
    --points data declaration
    for i = 1, pointsCount, 1 do
        table.insert(points,{
            model=nil,
            actualPrevPos = player.getPos(),
            position=player.getPos(),
            prevPos=vectors.of({}),
            locked=false,
            isInWater = false
        })
    end
    --lines data declaration
    for i = 1, linesCount, 1 do
        table.insert(lines,{
            model=nil,
            pointA=0,
            pointB=0,
            length=0.5,
        })
    end
    --controls
    lines[1].model = model.NO_PARENT_BODY
    lines[1].pointA = 1
    lines[1].pointB = 2

    lines[2].model = model.NO_PARENT_LARM
    lines[2].pointA = 3
    lines[2].pointB = 4
    points[3].locked = true

    lines[3].model = model.NO_PARENT_RARM
    lines[3].pointA = 6
    lines[3].pointB = 5
    points[6].locked = true

    lines[4].model = model.NO_PARENT_LLEG
    lines[4].pointA = 8
    lines[4].pointB = 7
    points[8].locked = true

    lines[5].model = model.NO_PARENT_RLEG
    lines[5].pointA = 10
    lines[5].pointB = 9
    points[10].locked = true

    lines[6].model = model.NO_PARENT_HED
    lines[6].pointA = 12
    lines[6].pointB = 11
    points[12].locked = true
end

network.registerPing("deatt")

function deatt(a)
	wasDeattach = a
end

function tick()
	if deattach.wasPressed() then
		network.ping("deatt", not wasDeattach)
	end
    _pos = pos
    pos = player.getPos()
    lastVelocity = velocity
    velocity = pos - _pos
    lastMomentum = momentum
    momentum = lastVelocity.distanceTo(velocity)
    if math.abs(lastMomentum-momentum) > 0.5 then
        splatTime = splatTime+splatTimeDuration
    end

    if didTookDamage then
        tookDamageDelay = tookDamageDelay - 1
        if tookDamageDelay <= 0 then
            didTookDamage = false
            points[1].position = points[1].position+velocity*5
        end
    end
    splatTime = splatTime - 1

    if renderer.getCameraPos().distanceTo(points[1].position) < distanceBeforeStopSimulation then
        armor()
        simulate()
        distVel = distVel + (velocity*vectors.of({1,0,1})).distanceTo(vectors.of({}))
        if client.isHost() then
            for key, value in pairs(model) do
                value.setEnabled((not renderer.isFirstPerson()))
            end
        end
    else
        for key, value in pairs(points) do
            value.position = player.getPos()
            value.prevPos = player.getPos()
        end
    end
end

function world_render(delta)
    if renderer.getCameraPos().distanceTo(points[1].position) < distanceBeforeStopSimulation then
        for _, p in pairs(points) do
            if p.model ~= nil then
                p.model.setPos(vectors.lerp(p.actualPrevPos,p.position,delta)*vectors.of({-16,-16,16}))
            end
        end
        for _, l in pairs(lines) do
            l.model.setPos(vectors.lerp(getPoint(l.pointA).actualPrevPos,getPoint(l.pointA).position,delta)*vectors.of({-16,-16,16}))
            l.model.setRot(lookat(
               vectors.lerp(getPoint(l.pointA).actualPrevPos,getPoint(l.pointA).position,delta),
                vectors.lerp(getPoint(l.pointB).actualPrevPos,getPoint(l.pointB).position,delta)
            ))
        end
    end
end

function simulate()
  if not wasDeattach and splatTime < 0 then
    gravity = vectors.of({math.sin(math.rad(player.getRot().y))*0.03,0,-math.cos(math.rad(player.getRot().y))*0.03})+trueGravity
  else
    gravity = trueGravity
  end
    for _, p in pairs(points) do
        local pastPos = p.position
        if not p.locked then
            
            p.position = p.position + (p.position-p.prevPos)
            p.position = p.position + gravity
            local col = collision(p.position+vectors.of({0,0.001,0}))
            p.prevPos = pastPos
            if col.isColliding then
                if p.position.distanceTo(col.result) > hurtSoundTolerance then
                    sound.playSound("entity.player.hurt",points[1].position,{0.2,1})
                end
                p.position = col.result
                p.prevPos = ((p.prevPos-p.position)*friction+p.position)--FRICTION BOUNCYNESS
                 
            end
            local dens = getwaterDensity(p.position) -- the deeper the player is, the faster the player floats
            if dens ~= 0 then--WATER FLOAT
                if not p.isInWater then
                    sound.playSound("minecraft:entity.generic.splash",p.position)
                end
                p.prevPos = ((p.prevPos-p.position)*waterFriction)+p.position
                p.prevPos = ((p.prevPos-p.position)+p.position+vectors.of({0,(dens*-0.05)-0.051,0}))
            end
            p.isInWater = (dens ~= 0)
        end
        p.actualPrevPos = pastPos
    end
    for _, l in pairs(lines) do
        local stickCenter = (getPoint(l.pointA).position + getPoint(l.pointB).position)/2
        local stickDir = (getPoint(l.pointA).position - getPoint(l.pointB).position).normalized()
        getPoint(l.pointA).position = stickCenter + stickDir * l.length / 2
        getPoint(l.pointB).position = stickCenter - stickDir * l.length / 2
    end
    --==========================CONSTRAINTS==========================================-
    if not wasDeattach and splatTime < 0 then
      points[1].position = player.getPos()+vectors.of({0,1.4+math.sin(distVel*5)*0.1,0})
    end
    
    points[3].position = model.NO_PARENT_BODY.partToWorldPos({6,4,0})*vectors.of({-1,-1,1})+(points[1].position-points[1].prevPos)
    points[6].position = model.NO_PARENT_BODY.partToWorldPos({-6,4,0})*vectors.of({-1,-1,1})+(points[1].position-points[1].prevPos)
    points[8].position = model.NO_PARENT_BODY.partToWorldPos({2,14,0})*vectors.of({-1,-1,1})+(points[1].position-points[1].prevPos)
    points[10].position = model.NO_PARENT_BODY.partToWorldPos({-2,14,0})*vectors.of({-1,-1,1})+(points[1].position-points[1].prevPos)
    points[12].position = model.NO_PARENT_BODY.partToWorldPos({0,2,0})*vectors.of({-1,-1,1})+(points[1].position-points[1].prevPos)
end

function getPoint(id)
    return points[id]
end

function lookat(a,b)
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end

-- function for tables
function tableFunction(tbl, func, args)
    if type(tbl) == "table" and tbl[func] == nil then
      for key, value in pairs(tbl) do
        tableFunction(value, func, args)
      end
    else
      tbl[func](args)
    end
  end
  
  function player_init()
    -- armor
    armorEnum = {
      ["turtle"]    = "turtle",
      ["netherite"] = "netherite",
      ["diamond"]   = "diamond",
      ["golden"]    = "gold",
      ["iron"]      = "iron",
      ["chainmail"] = "chainmail",
      ["leather"]   = "leather"
    }
    
    armorParts = {
      ["helmet"] = {model.NO_PARENT_HED.armor},
      ["chest"]  = {
        model.NO_PARENT_BODY.armor,
        model.NO_PARENT_LARM.armor,
        model.NO_PARENT_RARM.armor
      },
      ["pants"]  = {
        model.NO_PARENT_BODY.pants,
        model.NO_PARENT_LLEG.armor,
        model.NO_PARENT_RLEG.armor
      },
      ["boots"]  = {
        model.NO_PARENT_RLEG.boot,
        model.NO_PARENT_LLEG.boot
      }
    }
  end
  ----------------
  
  -- armor
  function armor()
    -- hide armor
    tableFunction(armorParts, "setEnabled", false)
    
    -- get armor names
    local helmeti = player.getEquipmentItem(6)
    local chesti = player.getEquipmentItem(5)
    local pantsi = player.getEquipmentItem(4)
    local bootsi = player.getEquipmentItem(3)
    
    local helmet = string.sub(helmeti.getType(), 11, -8)
    local chest  = string.sub(chesti.getType(),  11, -12)
    local pants  = string.sub(pantsi.getType(),  11, -10)
    local boots  = string.sub(bootsi.getType(),  11, -7)
    
    -- set armor
    if armorEnum[helmet] then
      setArmorProperties(armorParts.helmet, armorEnum[helmet].."_layer_1", helmeti)
    end
    
    if armorEnum[chest] then
      setArmorProperties(armorParts.chest, armorEnum[chest].."_layer_1", chesti)
    end
    
    if armorEnum[pants] then
      setArmorProperties(armorParts.pants, armorEnum[pants].."_layer_2", pantsi)
    end
    
    if armorEnum[boots] then
      setArmorProperties(armorParts.boots, armorEnum[boots].."_layer_1", bootsi)
    end
  end
  
  -- set armor
  function setArmorProperties(part, armor, item)
    for key, value in pairs(part) do
      value.setEnabled(true)
      value.setTexture("Resource", "textures/models/armor/"..armor..".png")
      value.setColor(string.find(armor, "leather") and colorArmor(item) or {1, 1, 1})
    end
  end
  
  -- get armor color
  function colorArmor(item)
    -- get item color display tag
    local tag = item.getTag()
    if tag ~= nil and tag.display ~= nil and tag.display.color ~= nil then
      return vectors.intToRGB(tag.display.color)
    end
    
    -- else return default leather color #A06540
    return vectors.intToRGB(0xA06540)
  end
  
--collision detection by GNamimates#9366
--give it a 3D position and it will return back the position but adjusted to the closest surface
function collision(pos)-- sorry idk what to name this lmao
  local point = vectors.of({pos.x,pos.y,pos.z})
  local collision = world.getBlockState(point).getCollisionShape()
  local isColliding = false
  local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})

  for index, value in ipairs(collision) do--loop through all the collision boxes
      if value.x < blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
          if value.y < blockPos.y and value.t > blockPos.y then
              if value.z < blockPos.z and value.h > blockPos.z then
                  --detected inside the cube
                  local closest = 9999--used to see what is the closes face
                  local whoClosest = 0
                  local currentPoint = point--for somethin idk
                  --finding the closest surface from the cube
                  if math.abs(value.x-blockPos.x) < closest then
                      closest = math.abs(value.x-blockPos.x)
                      whoClosest = 0
                  end
                  if math.abs(value.y-blockPos.y) < closest then
                      closest = math.abs(value.y-blockPos.y)
                      whoClosest = 1
                  end
                  if math.abs(value.z-blockPos.z) < closest then
                      closest = math.abs(value.z-blockPos.z)
                      whoClosest = 2
                  end
                  
                  if math.abs(value.w-blockPos.x) < closest then
                      closest = math.abs(value.w-blockPos.x)
                      whoClosest = 3
                  end
                  if math.abs(value.t-blockPos.y) < closest then
                      closest = math.abs(value.t-blockPos.y)
                      whoClosest = 4
                  end
                  if math.abs(value.h-blockPos.z) < closest then
                      closest = math.abs(value.h-blockPos.z)
                      whoClosest = 5
                  end
                  --snap the closest surfance to the point
                  point.y = math.floor(currentPoint.y)+value.t
                  isColliding = true
              end
          end
      end
  end
  return {result=point,isColliding=isColliding}
end

--returns how dense the water is JK XDDDDDDDDDDDDDDDDDD
function getwaterDensity(pos)
    local density = 0
    while world.getBlockState(pos+vectors.of({0,density})).name == "minecraft:water" and 10 > density do
        density = density + 1
    end
    return density
end