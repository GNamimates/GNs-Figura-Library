function player_init()
    for key, value in pairs(vanilla_model) do
        value.setEnabled(false)    
    end
    nameplate.ENTITY.setPos({0,-100,0})
    
end