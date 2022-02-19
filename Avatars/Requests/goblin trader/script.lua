---================[CREDITS]=======================--
--|GNamimates           - basically everything else|
--|ligma                 
--|figura vsc extension - presets                  |
---================================================--

--=====CONFIG======--
isNamePlateHidden = false
--====END OF CONFIG====--

for _, v in pairs(vanilla_model) do
    v.setEnabled(false)
end

for _, v in pairs(model) do
    v.setPos({0,21,0})
end
nameplate.ENTITY.setPos({0,-1,0})
elytra_model.LEFT_WING.setEnabled(false)
elytra_model.RIGHT_WING.setEnabled(false)

action_wheel.SLOT_1.setFunction(function ()
    nameplate.ENTITY.setEnabled(isNamePlateHidden)
    isNamePlateHidden = not isNamePlateHidden
end)