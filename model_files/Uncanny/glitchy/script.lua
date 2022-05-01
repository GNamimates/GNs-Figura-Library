--by the Lime Newon :3 <3

OPACITY = 0
INTENSITY = 0.5
HIDE_PLAYER_MODEL = true
RAINBOW_MODE = false

for _, v in pairs(vanilla_model) do
    v.setEnabled(not HIDE_PLAYER_MODEL)
end


for key, value in pairs(model) do
    value.setTexture("Skin")
end

for key, value in pairs(model) do
    value.setTexture("Skin")
end
if RAINBOW_MODE then
    model.R.setColor({1,0,0})
    model.G.setColor({0,1,0})
    model.B.setColor({0,0,1})
end



model.R.setOpacity(OPACITY)
model.G.setOpacity(OPACITY)
model.B.setOpacity(OPACITY)

function world_render()
    for key, value in pairs(model) do
        value.setPos({lerp(-INTENSITY,INTENSITY,math.random()),lerp(-INTENSITY,INTENSITY,math.random()),lerp(-INTENSITY,INTENSITY,math.random())})
    end
end

function lerp(a, b, x)
    return a + (b - a) * x
end
