if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
	RequestNamedPtfxAsset("scr_indep_fireworks")
	while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		Wait(10)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if IsControlPressed(0, 21) then
            UseParticleFxAssetNextCall("scr_indep_fireworks")
            local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", 59.0, 7223.0, 2.5, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        end
    end
end)