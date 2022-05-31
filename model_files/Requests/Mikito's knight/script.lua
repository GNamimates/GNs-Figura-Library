for _, v in pairs(vanilla_model) do
    v.setEnabled(false)
end

capeGroup = {
    model.Body.Cape,
    model.Body.Cape.cape2,
    model.Body.Cape.cape2.cape3,
    model.Body.Cape.cape2.cape3.cape4,
    model.Body.Cape.cape2.cape3.cape4.cape5,
    model.Body.Cape.cape2.cape3.cape4.cape5.cape6,
    model.Body.Cape.cape2.cape3.cape4.cape5.cape6.cape7,
    model.Body.Cape.cape2.cape3.cape4.cape5.cape6.cape7.cape8,
    model.Body.Cape.cape2.cape3.cape4.cape5.cape6.cape7.cape8.cape9,
    model.Body.Cape.cape2.cape3.cape4.cape5.cape6.cape7.cape8.cape9.cape10,
}

capeRot = {
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
}

LastCapeRot = {
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
    vectors.of{0, 0, 0},
}

t = 0

capeEnabled = true

lastBodyRot = 0

function tick()
    capeEnabled = player.getEquipmentItem("5").getType() ~= "minecraft:elytra"
    for key, value in pairs(capeGroup) do
        value.setEnabled(capeEnabled)
    end
    if capeEnabled then
        t = t + 1
        local vel = player.getVelocity()
        local playerRot = player.getRot()
        localVel = vectors.of{
            -(math.sin(math.rad(-playerRot.y+90))*-vel.x)-(math.cos(math.rad(-playerRot.y+90))*-vel.z)+(lastBodyRot-player.getBodyYaw())*-0.01,
            math.min(vel.y*2,0),
            (math.sin(math.rad(-playerRot.y))*vel.x)+(math.cos(math.rad(-playerRot.y))*vel.z),
        }
        local rot = math.toAngle(localVel+vectors.of{0,0.3,0.3})-vectors.of{45,0,0}
        capeRot[1] = vectors.of{-rot.x,0,rot.y}
        LastCapeRot[1] = capeRot[1] * 1
        for i = 9, 1, -1 do
            LastCapeRot[i] = capeRot[i] * 1
            capeRot[i+1] = capeRot[i]
        end
    end
    lastBodyRot = player.getBodyYaw()
end

function world_render(delta)
    if capeEnabled then
        for key, value in pairs(capeGroup) do
            local finalCapeRot = capeRot[key]
            local finalLastCapeRot = LastCapeRot[key]
            local t = t + delta
            if key ~= 1 then
                finalLastCapeRot = finalLastCapeRot - LastCapeRot[key-1]
                finalCapeRot = finalCapeRot - capeRot[key-1]
            end
            value.setRot(vectors.lerp(finalLastCapeRot,finalCapeRot,delta)+vectors.of{0,0,
            math.sin(t*00.1)*0.05+
            math.sin(t*0.25)*0.1,
            })
        end
    end
end

function math.toAngle(pos)
    local y = math.atan2(pos.x,pos.z)
    local result = vectors.of({math.atan2((math.sin(y)*pos.x)+(math.cos(y)*pos.z),pos.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end

