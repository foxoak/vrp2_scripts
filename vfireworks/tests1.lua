StartParticleFxNonLoopedAtCoord("proj_indep_flare_fuse_glow_lit", 0.0,0.0,0.0, 0.0,0.0,0.0,1.0,0,0,0)
StartParticleFxNonLoopedOnEntity2("scr_clown_appears", PlayerPedId(), 0.0, 0.0, -0.5, 0.0, 0.0, 0.0, 1.0, false, false, false)
Citizen.InvokeNative("0xC95EB1DB6E92113D", 

if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
	RequestNamedPtfxAsset("scr_indep_fireworks")
	while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		Wait(10)
	end
end
local playerCoords = GetEntityCoords(PlayerPedId(), true)
UseParticleFxAssetNextCall("scr_indep_fireworks")
local part = StartParticleFxLoopedAtCoord("scr_indep_firework_trailburst", playerCoords.x, playerCoords.y, playerCoords.z-1.0, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

if not HasNamedPtfxAssetLoaded("core") then
	RequestNamedPtfxAsset("core")
	while not HasNamedPtfxAssetLoaded("core") do
		Wait(1)
	end
end
local playerCoords = GetEntityCoords(PlayerPedId(), true)
UseParticleFxAssetNextCall("core")
local part = StartParticleFxLoopedAtCoord("fire_wrecked_tank_cockpit", playerCoords.x, playerCoords.y, playerCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)








if not HasNamedPtfxAssetLoaded("core") then
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do
        Wait(1)
    end
end
SetPtfxAssetNextCall("core")
local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
print(x,y,z)
StartParticleFxLoopedAtCoord("water_splash_bicycle_trail_mist", x, y, z+0.7, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

--StartParticleFxNonLoopedOnEntity("scr_clown_appears", GetPlayerPed(-1), 0.0, 0.0, -0.5, 0.0, 0.0, 0.0, 1.0, false, false, false)

