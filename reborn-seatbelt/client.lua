local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local isRagdoll					= false
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false
local isUiOpen = false

Citizen.CreateThread(function()
	RegisterNetEvent('tonto:Sound:PlayOnOne')
	AddEventHandler('tonto:Sound:PlayOnOne', function(soundFile, soundVolume, loop)
	    SendNUIMessage({
	        transactionType     = 'playSound',
	        transactionFile     = soundFile,
	        transactionVolume   = soundVolume,
			transactionLoop   = loop
	    })
	end)
	RegisterNetEvent('tonto:Sound:StopOnOne')
	AddEventHandler('tonto:Sound:StopOnOne', function()
	    SendNUIMessage({
	        transactionType     = 'stopSound'
	    })
	end)
end)


IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end	

Fwv = function (entity)
		    local hr = GetEntityHeading(entity) + 90.0
		    if hr < 0.0 then hr = 360.0 + hr end
		    hr = hr * 0.0174533
		    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn( GetPlayerPed(-1))
		
		if car ~= 0 and (wasInCar or IsCar(car)) then
      		wasInCar = true
             if isUiOpen == false and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({
            	   displayWindow = 'true'
            	   })
                isUiOpen = true 			
            end
			
			if beltOn then DisableControlAction(0, 75) end
			
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(car)
			
			if speedBuffer[2] ~= nil 
			   and not beltOn
			   and GetEntitySpeedVector(car, true).y >= 1.0  
			   and speedBuffer[1] >= Cfg.MinSpeed 
			   and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * Cfg.DiffTrigger) then
			   
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Citizen.Wait(1)
				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
			end
			if speedBuffer[2] ~= nil 
			   and beltOn
			   and GetEntitySpeedVector(car, true).y >= 1.0  
			   and speedBuffer[1] >= Cfg.MinSpeed 
			   and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * Cfg.DiffTriggertonto) then
					--	RequestAnimDict("weapon@w_sp_jerrycan")
					--	while not HasAnimDictLoaded("weapon@w_sp_jerrycan") do
					--	Citizen.Wait(0)
					--end
					--TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire", 8.0, -8, -1, 49, 0, 0, 0, 0)
					local cameraplayer = GetFollowVehicleCamViewMode()
					TriggerEvent("tonto:Sound:PlayOnOne","tonto",0.7,true)						
					SetFollowVehicleCamViewMode(4) 
					SetPedMotionBlur(GetPlayerPed(-1), true)					
					SetTimecycleModifier("spectator4")
					DoScreenFadeOut(0)
					Citizen.Wait(1000)					
					DoScreenFadeIn(500)
					Citizen.Wait(500)						
					DoScreenFadeOut(2000)
					Citizen.Wait(2000)					
					DoScreenFadeIn(500)
					Citizen.Wait(1000)					
					DoScreenFadeOut(2500)
					Citizen.Wait(2500)					
					DoScreenFadeIn(2000)	
					Citizen.Wait(2000)					

					--PlaySound(-1, 'ScreenFlash', 'WastedSounds', 0, 0, 1)					
					--ClearPedTasksImmediately(GetPlayerPed(-1))
					--SetTimecycleModifier("spectator5")
					--SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
					--SetPedIsDrunk(GetPlayerPed(-1), true)
					ClearTimecycleModifier()
					ClearPedTasks(GetPlayerPed(-1))
					--ResetScenarioTypesEnabled()
					--ResetPedMovementClipset(GetPlayerPed(-1), 0)
					--SetPedIsDrunk(GetPlayerPed(-1), false)
					SetPedMotionBlur(GetPlayerPed(-1), false)
					Citizen.Wait(500)
					SetFollowVehicleCamViewMode(cameraplayer)
					TriggerEvent("tonto:Sound:StopOnOne")	
			end			
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
				
			if IsControlJustReleased(0, 246) then
				beltOn = not beltOn				  
				if beltOn then 
                        TriggerEvent("pNotify:SetQueueMax", -1, "lmao", 10)
                        TriggerEvent("pNotify:SendNotification", {
                            text = "<b style = 'color:white'>"..Cfg.Strings.belt_on..".</b>",
                            type = "success",
                            queue = "lmao",
                            timeout = 5000,
                            layout = "centerRight"
                        })           
                        			SendNUIMessage({
			   displayWindow = 'false'
			   })
			isUiOpen = true              

				else 
					    TriggerEvent("pNotify:SetQueueMax", -1, "lmao", 10)
                        TriggerEvent("pNotify:SendNotification", {
                            text = "<b style = 'color:white'>"..Cfg.Strings.belt_off..".</b>",
                            type = "error",
                            queue = "lmao",
                            timeout = 5000,
                            layout = "centerRight"
                        })   
                        			SendNUIMessage({
			   displayWindow = 'true'
			   })
			isUiOpen = true  
				end 
			end
			
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
             if isUiOpen == true and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({
            	   displayWindow = 'false'
            	   })
                isUiOpen = false 
            end			
		end
		Citizen.Wait(0)
	end
end)
