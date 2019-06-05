Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")


local cvRP = module("vrp", "client/vRP")
vRP = cvRP() 

local reborn_wedding = class("reborn_wedding", vRP.Extension)

function reborn_wedding:__construct()
	vRP.Extension.__construct(self)

	local casadoPlayer = {}

end

--function reborn_wedding:Casamento(nplayer)
--    local playerPed = GetPlayerPed(-1)
--
--end  

function reborn_wedding:IgrejaProxima(player)
    --local playerPed = GetPlayerID
    print('checando')
          if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 389.82382202148,-355.93930053711,48.024501800537, true ) < 5 then                
          	print('proximo')
             self.remote._VerificarProximo(player)
             return true            
          else
             return false
          end
end

function reborn_wedding:divorcio(player)


end

function reborn_wedding:FogosCL(tempo)
	timer = tempo
    local asset1 = "scr_indep_fireworks"
    if not HasNamedPtfxAssetLoaded(asset1) then
        RequestNamedPtfxAsset(asset1)
        while not HasNamedPtfxAssetLoaded(asset1) do
            Citizen.Wait(1)
        end
    end
    local asset2 = "proj_xmas_firework"
    if not HasNamedPtfxAssetLoaded(asset2) then
        RequestNamedPtfxAsset(asset2)
        while not HasNamedPtfxAssetLoaded(asset2) do
            Citizen.Wait(1)
        end
    end
    while timer > 0 do
        	Citizen.Wait(1 * 1000)
     --   if IsControlPressed(0, 21) then
            UseParticleFxAssetNextCall(asset2)
            local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", 389.0+ (math.random() * 25), -355.0 + (math.random() * 25), 80.5, 0.0, 0.0, 0.0, math.random() * 0.3 + 0.5, false, false, false, false)
            UseParticleFxAssetNextCall(asset1)
            local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", 389.0+ (math.random() * 25), -355.0 + (math.random() * 25), 46.9, 0.0, 0.0, 0.0, math.random() * 1.0 + 1.0, false, false, false, false)
            Citizen.Wait(math.random()*500)
            UseParticleFxAssetNextCall(asset2)
            local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_spiral_burst_rgw", 389.0+ (math.random() * 25), -355.0 + (math.random() * 25), 75.5, 0.0, 0.0, 0.0, math.random() * 0.3 + 0.5, false, false, false, false)
            UseParticleFxAssetNextCall(asset1)
            local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", 389.0+ (math.random() * 25), -355.0 + (math.random() * 25), 46.9, 0.0, 0.0, 0.0, math.random() * 1.0 + 1.0, false, false, false, false)
            Citizen.Wait(math.random()*500)
            UseParticleFxAssetNextCall(asset1)
            local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", 389.0+ (math.random() * 25), -355.0 + (math.random() * 25), 46.9, 0.0, 0.0, 0.0, math.random() * 1.0 + 1.0, false, false, false, false)
            Citizen.Wait(math.random()*500)
            UseParticleFxAssetNextCall(asset1)
            local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", 389.0+ (math.random() * 25), -355.0 + (math.random() * 25), 46.9, 0.0, 0.0, 0.0, math.random() * 1.0 +1.0, false, false, false, false)
            timer = timer - 1
            print(timer)
    --    end
    end

end
    reborn_wedding.tunnel = {}
    --reborn_wedding.tunnel.Casamento = reborn_wedding.Casamento
    reborn_wedding.tunnel.IgrejaProxima = reborn_wedding.IgrejaProxima
    reborn_wedding.tunnel.FogosCL = reborn_wedding.FogosCL

vRP:registerExtension(reborn_wedding)