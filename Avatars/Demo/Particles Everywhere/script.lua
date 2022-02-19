position = nil

heartCount = 30

heart = {}

DIST = 20

function player_init()
    for _ = 1, heartCount, 1 do
        table.insert(heart,{
            pos = vectors.of{math.random()*DIST,math.random()*DIST,math.random()*DIST},
        })
    end
end

function tick()
    position = renderer.getCameraPos()
    for index = 1, heartCount, 1 do
        heart[index].pos = heart[index].pos + vectors.of{0,0.02,0}
        model["NO_PARENT"..index].setPos({
            (math.floor(((position.x-heart[index].pos.x)/DIST)-DIST/-DIST*0.5)*DIST+heart[index].pos.x)*-16,
            (math.floor(((position.y-heart[index].pos.y)/DIST)-DIST/-DIST*0.5)*DIST+heart[index].pos.y)*-16,
            (math.floor(((position.z-heart[index].pos.z)/DIST)-DIST/-DIST*0.5)*DIST+heart[index].pos.z)*16,
        })
    end
    
end