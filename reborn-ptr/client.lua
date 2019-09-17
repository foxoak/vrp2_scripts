Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

local cvRP = module("vrp", "client/vRP")
vRP = cvRP() 

local rebornptr = class("rebornptr", vRP.Extension)

function rebornptr:__construct()
  vRP.Extension.__construct(self)
  ativou = true

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait( 0 )
			local ped = PlayerPedId()
			if DoesEntityExist( ped ) and not IsEntityDead( ped ) then
				if not IsPauseMenuActive() then 
					loadAnimDict( "random@arrests" )
					
					if IsControlJustReleased( 0, 246 ) and ativou then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
						ClearPedTasks(ped)
						SetEnableHandcuffs(ped, false)
					else
						if IsControlJustPressed( 0, 246 ) and not IsPlayerFreeAiming(PlayerId()) and ativou then -- INPUT_CHARACTER_WHEEL (LEFT ALT)							
							TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
							SetEnableHandcuffs(ped, true)

						elseif IsControlJustPressed( 0, 246 ) and IsPlayerFreeAiming(PlayerId()) and ativou then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
							TaskPlayAnim(ped, "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
							SetEnableHandcuffs(ped, true)
						end 
						if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) then
							DisableActions(ped)
						elseif IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
							DisableActions(ped)
						end
					end
				end 
			end 
		end
	end )
end

function rebornptr:voiceChannelPlayerSpeakingChange(channel, player, speaking)
	print('oi PTR event')
	print(channel)
  if channel == "radio" then
    if speaking then
    	ativou = true
    	print(ativou)
    else
      ativou = false
      print(ativou)
    end
  end
end

function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end
rebornptr.event = {}
rebornptr.event.voiceChannelPlayerSpeakingChange = rebornptr.voiceChannelPlayerSpeakingChange

rebornptr.tunnel = {}

vRP:registerExtension(rebornptr)

--Reborn Radio ptr FoxOak,Mayk
