Citizen.CreateThread(function() 
    local asset1 = "scr_indep_fireworks"
    if not HasNamedPtfxAssetLoaded(asset1) then
        RequestNamedPtfxAsset(asset1)
        while not HasNamedPtfxAssetLoaded(asset1) do
            Citizen.Wait(1)
        end
        print('done')
    end
    local asset2 = "proj_xmas_firework"
    if not HasNamedPtfxAssetLoaded(asset2) then
        RequestNamedPtfxAsset(asset2)
        while not HasNamedPtfxAssetLoaded(asset2) do
            Citizen.Wait(1)
        end
        print('done')
    end
    while true do
        Citizen.Wait(math.random() * 1000)
        if IsControlPressed(0, 21) then
            print('tempo'..tempoa)
            UseParticleFxAssetNextCall(asset2)
            local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", 200.0+ (math.random() * 25), 7223.0 + (math.random() * 25), 32.5, 0.0, 0.0, 0.0, math.random() * 0.3 + 0.5, false, false, false, false)
            UseParticleFxAssetNextCall(asset1)
            local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", 200.0+ (math.random() * 25), 7223.0 + (math.random() * 25), 2.5, 0.0, 0.0, 0.0, math.random() * 1.0 + 1.0, false, false, false, false)
            Citizen.Wait(math.random()*500)
            UseParticleFxAssetNextCall(asset2)
            local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_spiral_burst_rgw", 200.0+ (math.random() * 25), 7223.0 + (math.random() * 25), 23.5, 0.0, 0.0, 0.0, math.random() * 0.3 + 0.5, false, false, false, false)
            UseParticleFxAssetNextCall(asset1)
            local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", 200.0+ (math.random() * 25), 7223.0 + (math.random() * 25), 2.5, 0.0, 0.0, 0.0, math.random() * 1.0 + 1.0, false, false, false, false)
            Citizen.Wait(math.random()*500)
            UseParticleFxAssetNextCall(asset1)
            local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", 200.0+ (math.random() * 25), 7223.0 + (math.random() * 25), 2.5, 0.0, 0.0, 0.0, math.random() * 1.0 + 1.0, false, false, false, false)
            Citizen.Wait(math.random()*500)
            UseParticleFxAssetNextCall(asset1)
            local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", 200.0+ (math.random() * 25), 7223.0 + (math.random() * 25), 2.5, 0.0, 0.0, 0.0, math.random() * 1.0 +1.0, false, false, false, false)
        end
    end
end)
