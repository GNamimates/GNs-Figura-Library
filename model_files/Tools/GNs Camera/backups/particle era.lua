
config = {
    display = {
        show_controllers = true,-- toggles on/off the controller display
        controller_strand_detail = 0.25,-- the lower the number, the more details

        trace_path = true,-- toggles on/off the path trace display
        path_subdivisions = 10,-- basically higher number = more detail

        camera_to_particle = true, -- turns the camera into a particle
    },
    theme = {-- {red ,green ,blue ,size}
        keyframe = {
            origin = {1,0,0,1},
            controller={0,0,1,1},
            strand={0,1,0,0.5}
        },
        camera = {
            origin = {1,0,0,1},
            path = {0,1,0,0.5}
        }
    },
    behavior = {
        clamp_transition_weights = true, -- if true, the transition weights will be clamped to 0-1, keeping the track from jittering
    }
}

keyframe = {}
time = 0
playbackSpeed = 1/20
duration = 0

playing = false
lastKeyframeDuration = 1
weight = 0 --lerp
KeyframeDuration = 1
KeyframeIndexBefore = 1
KeyframeIndexAfter = 1

lastPathDuration = 1
PathDuration = 1
PathIndexBefore = 1
PathIndexAfter = 1

data.setName("GN.camera")

tickspeed = 1/20

function clearPoints()
    keyframe = {}
end

function addPoint(pos,rot,controller,type,time)
    for index, p in pairs(keyframe) do--insertion sort
        if duration < time then
            duration = time
        end
        if p.time > time then
            table.insert(keyframe,index,{pos=vectors.of{pos},rot=vectors.of{rot},ctrl=vectors.of{controller},type=type,time=time})
            data.save("points",keyframe)
            return
        end
    end
    table.insert(keyframe,{pos=vectors.of{pos},rot=vectors.of{rot},ctrl=vectors.of{controller},type=type,time=time})
    data.save("points",keyframe)
end

function player_init()
    addPoint({-7.5,4,45},{20,-90,0},{0,0,1},1,0)
    addPoint({-4,3,43},{9,0,0},{-2,0,0},1,0.5)
    addPoint({0,7,45},{50,90,0},{0,0,-1},1,2)
    addPoint({-4,2,47},{-42,180,0},{2,0,0},1,4)
    addPoint({-7.5,4,45},{20,270,0},{0,0,1},1,5)
    
    --addPoint({4,0,0},{},{0,0,-2},0)
    --addPoint({0,0,2},{},{2,0,0},1)
    --addPoint({-2,0,0},{},{0,0,2},2)
    --addPoint({0,0,-2},{},{-2,0,0},3)
    --addPoint({4,0,0},{},{0,0,-2},4)

    --addPoint({2,0,0},{},{0,0,2},0)
    --addPoint({-2,0,0},{},{0,0,2},2)
    playing = true
end

function tick()
    time = time + playbackSpeed
    time = time % duration
    --time = math.lerp(0,duration,math.random())
    if config.display.show_controllers then
        for key, value in pairs(keyframe) do
            particle.addParticle("dust",value.pos,config.theme.keyframe.origin)
            particle.addParticle("dust",value.pos+value.ctrl,config.theme.keyframe.controller)
            particle.addParticle("dust",value.pos-value.ctrl,config.theme.keyframe.controller)
            local subdivision = config.display.controller_strand_detail/value.ctrl.getLength()
            for i = -1+subdivision, 1-subdivision, subdivision do
                if i ~= 0 then
                    particle.addParticle("dust",value.pos-value.ctrl*i,config.theme.keyframe.strand)
                end
            end
            --particle.addParticle("dust",value.pos-(value.ctrl*2)*(weight)+value.ctrl,config.theme.keyframe.controller)
        end
    end
end
--[[ CLASSIC LERP
function world_render(delta)
    local t = time+delta*speed-tickspeed
    if playing then
        findClosestKeyframes()
        local weight = (t-keyframe[keyframeIndexBefore].time)*(1/keyframeDuration)
        local pos = vectors.lerp(keyframe[keyframeIndexBefore].pos,keyframe[keyframeIndexAfter].pos,weight)
        local rot = vectors.lerp(keyframe[keyframeIndexBefore].rot,keyframe[keyframeIndexAfter].rot,weight)
        particle.addParticle("minecraft:dust",pos,{1,0,0,1})
        --cam(pos,rot,delta)
    end
end
]]

function world_render(delta)--lerp hell
    local t = time+delta*playbackSpeed
    if playing then
        
        for index, value in pairs(keyframe) do
            if value.time > time then
                KeyframeIndexAfter = index
                KeyframeIndexBefore = index-1
                if index ~= 1 then
                    if keyframe[index].time-keyframe[index-1].time ~= KeyframeDuration then
                        lastKeyframeDuration = KeyframeDuration
                        KeyframeDuration = keyframe[index].time-keyframe[index-1].time
                    end
                else
                    if keyframe[index].time-keyframe[index-1].time ~= KeyframeDuration then
                        lastKeyframeDuration = KeyframeDuration
                        KeyframeDuration = keyframe[index].time
                    end
                end
                break
            end
        end

        weight = (t-keyframe[KeyframeIndexBefore].time)*(1/KeyframeDuration)
        local timeModifier = math.lerp(0,math.lerp((1/lastKeyframeDuration)-(1/KeyframeDuration),0,weight),weight)*0.5
        --weight = weight+timeModifier
        if config.behavior.clamp_transition_weights then
            weight = math.clamp(weight,0,1)
        end
        --graph((1+timeModifier)*10)
        local pos = vectors.lerp(
            vectors.lerp(
                vectors.lerp(
                    keyframe[KeyframeIndexBefore].pos,
                    keyframe[KeyframeIndexBefore].pos-keyframe[KeyframeIndexBefore].ctrl*2,
                    weight),
                vectors.lerp(
                    keyframe[KeyframeIndexBefore].pos-keyframe[KeyframeIndexBefore].ctrl*2,
                    keyframe[KeyframeIndexAfter].pos,
                    weight),
                weight
            ),
            vectors.lerp(
                vectors.lerp(keyframe[KeyframeIndexBefore].pos,
                keyframe[KeyframeIndexAfter].pos+keyframe[KeyframeIndexAfter].ctrl*2,
                weight),
                vectors.lerp(keyframe[KeyframeIndexAfter].pos+keyframe[KeyframeIndexAfter].ctrl*2,
                keyframe[KeyframeIndexAfter].pos,
                weight),
                weight
            ),
            weight
        )
        local rot = vectors.lerp(
            vectors.lerp(
                vectors.lerp(
                    keyframe[KeyframeIndexBefore].rot,
                    keyframe[KeyframeIndexBefore].rot,
                    weight),
                vectors.lerp(
                    keyframe[KeyframeIndexBefore].rot,
                    keyframe[KeyframeIndexAfter].rot,
                    weight),
                weight
            ),
            vectors.lerp(
                vectors.lerp(keyframe[KeyframeIndexBefore].rot,
                keyframe[KeyframeIndexAfter].rot,
                weight),
                vectors.lerp(keyframe[KeyframeIndexAfter].rot,
                keyframe[KeyframeIndexAfter].rot,
                weight),
                weight
            ),
            weight
        )
        if config.display.camera_to_particle then
            particle.addParticle("minecraft:dust",pos,{0.8,0,0,1})
        else
            cam(pos,rot,delta)
        end
    end
    if config.display.trace_path then
        for t = 0, duration, 1/config.display.path_subdivisions do
            for index, value in pairs(keyframe) do
                if value.time > t then
                    PathIndexBefore = index
                    PathIndexAfter = index-1
                    if index ~= 1 then
                        if keyframe[index].time-keyframe[index-1].time ~= PathDuration then
                            lastPathDuration = PathDuration
                            PathDuration = keyframe[index].time-keyframe[PathIndexAfter].time
                        end
                    else
                        if keyframe[index].time-keyframe[index-1].time ~= PathDuration then
                            lastPathDuration = PathDuration
                            PathDuration = keyframe[index].time
                        end
                    end
                    break
                end
            end

            local weight = ((t-keyframe[PathIndexBefore].time)*(1/PathDuration))*-1
            local pos = vectors.lerp(
                vectors.lerp(
                    vectors.lerp(
                        keyframe[PathIndexBefore].pos,
                        keyframe[PathIndexBefore].pos+keyframe[PathIndexBefore].ctrl*2,
                        weight),
                    vectors.lerp(
                        keyframe[PathIndexBefore].pos+keyframe[PathIndexBefore].ctrl*2,
                        keyframe[PathIndexAfter].pos,
                        weight),
                    weight
                ),
                vectors.lerp(
                    vectors.lerp(keyframe[PathIndexBefore].pos,
                    keyframe[PathIndexAfter].pos-keyframe[PathIndexAfter].ctrl*2,
                    weight),
                    vectors.lerp(keyframe[PathIndexAfter].pos-keyframe[PathIndexAfter].ctrl*2,
                    keyframe[PathIndexAfter].pos,
                    weight),
                    weight
                ),
                weight
            )
            particle.addParticle("minecraft:dust",pos,{0,1,0,0.5})
        end
    end
end

function cam(pos,rot,delta)
    if type(pos) == "table" then pos = vectors.of(pos) end
    local r = player.getRot(delta)
    camera.FIRST_PERSON.setRot(vectors.of{{-r.x,-r.y,r.z}}+vectors.of{rot})
    r = r + camera.FIRST_PERSON.getRot()
    local p = pos-player.getPos(delta)-vectors.of({0, player.getEyeHeight()})
    local z = 1/math.cos(math.rad(r.x))*(math.cos(math.rad(r.y))*-p.z+math.sin(math.rad(r.y))*p.x)
    camera.FIRST_PERSON.setPos({
        math.min(math.max(math.cos(math.rad(r.y-90))*-p.z+math.sin(math.rad(r.y-90))*p.x, -500), 500),
        math.min(math.max(p.y-math.sin(math.rad(r.x))*z, -500), 500),math.min(math.max(z, -500), 500) })
end

function graph(num)
    log(string.rep("-",num).."|")
end