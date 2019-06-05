if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
	RequestNamedPtfxAsset("scr_indep_fireworks")
	while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		Wait(10)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 21) then
            UseParticleFxAssetNextCall("scr_indep_fireworks")
            local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_burst_spawn", 59.0, 7223.0, 25.5, 0.0, 0.0, 0.0, 5.0, false, false, false, false)
        end
    end
end)