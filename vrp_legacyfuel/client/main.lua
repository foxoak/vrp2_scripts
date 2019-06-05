Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")


local cvRP = module("vrp", "client/vRP")
vRP = cvRP() 

local LegacyFuel = class("LegacyFuel", vRP.Extension)

models = {
	[1] = -2007231801,
	[2] = 1339433404,
	[3] = 1694452750,
	[4] = 1933174915,
	[5] = -462817101,
	[6] = -469694731,
	[7] = -164877493
}

blacklistedVehicles = {
	[1] = 'BMX',
	[2] = 'CRUISER',
	[3] = 'FIXTER',
	[4] = 'SCORCHER',
	[5] = 'TRIBIKE',
	[6] = 'TRIBIKE2',
	[7] = 'TRIBIKE3'
}

 Vehicles 					 = {}
 pumpLoc 					 = {}
 nearPump 					 = false
 IsFueling 				 	 = false
 IsFuelingWithJerryCan   = false
 InBlacklistedVehicle	 = false
 NearVehicleWithJerryCan = false
 price 				  		 = 0
 cash 				  		 = 0
 money              		 = 0
 FuelPump 					 = 0.0

 gas_stations = {
	{ ['x'] = 49.4187,   ['y'] = 2778.793,  ['z'] = 58.043},
 	{ ['x'] = 263.894,   ['y'] = 2606.463,  ['z'] = 44.983},
 	{ ['x'] = 1039.958,  ['y'] = 2671.134,  ['z'] = 39.550},
 	{ ['x'] = 1207.260,  ['y'] = 2660.175,  ['z'] = 37.899},
 	{ ['x'] = 2539.685,  ['y'] = 2594.192,  ['z'] = 37.944},
 	{ ['x'] = 2679.858,  ['y'] = 3263.946,  ['z'] = 55.240},
 	{ ['x'] = 2005.055,  ['y'] = 3773.887,  ['z'] = 32.403},
 	{ ['x'] = 1687.156,  ['y'] = 4929.392,  ['z'] = 42.078},
 	{ ['x'] = 1701.314,  ['y'] = 6416.028,  ['z'] = 32.763},
 	{ ['x'] = 179.857,   ['y'] = 6602.839,  ['z'] = 31.868},
 	{ ['x'] = -94.4619,  ['y'] = 6419.594,  ['z'] = 31.489},
 	{ ['x'] = -2554.996, ['y'] = 2334.40,  ['z'] = 33.078},
 	{ ['x'] = -1800.375, ['y'] = 803.661,  ['z'] = 138.651},
 	{ ['x'] = -1437.622, ['y'] = -276.747,  ['z'] = 46.207},
 	{ ['x'] = -2096.243, ['y'] = -320.286,  ['z'] = 13.168},
 	{ ['x'] = -724.619, ['y'] = -935.1631,  ['z'] = 19.213},
 	{ ['x'] = -526.019, ['y'] = -1211.003,  ['z'] = 18.184},
 	{ ['x'] = -70.2148, ['y'] = -1761.792,  ['z'] = 29.534},
 	{ ['x'] = 265.648,  ['y'] = -1261.309,  ['z'] = 29.292},
 	{ ['x'] = 819.653,  ['y'] = -1028.846,  ['z'] = 26.403},
 	{ ['x'] = 1208.951, ['y'] =  -1402.567, ['z'] = 35.224},
 	{ ['x'] = 1181.381, ['y'] =  -330.847,  ['z'] = 69.316},
 	{ ['x'] = 620.843,  ['y'] =  269.100,  ['z'] = 103.089},
 	{ ['x'] = 2581.321, ['y'] = 362.039, ['z'] = 108.468}
}

function LegacyFuel:__construct()
	vRP.Extension.__construct(self)

		Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			if nearPump and not IsCloseToLastVehicle and GetAmmoInPedWeapon(PlayerPedId(),  883325847) ~= 100 and Config.EnableBuyableJerryCans then
				if GetAmmoInPedWeapon(PlayerPedId(),  883325847) > 0 then
					DrawText3Ds(pumpLoc['x'], pumpLoc['y'], pumpLoc['z'], "Pressione ~g~E ~w~para comprar um galão de combustivel. " .. Config.JerryCanPrice*(100-GetAmmoInPedWeapon(PlayerPedId(), 883325847))/100 .. "$.")
				else
					DrawText3Ds(pumpLoc['x'], pumpLoc['y'], pumpLoc['z'], "Pressione ~g~E ~w~para comprar um galão por " .. Config.JerryCanPrice .. "$.")
				end
				fillJerryCan()
			end			

			if not InBlacklistedVehicle then
				if Timer then
					DisplayHud()
				end

				if nearPump and IsCloseToLastVehicle then
					local vehicle  = GetPlayersLastVehicle()
					local fuel 	   = round(GetVehicleFuelLevel(vehicle), 1)
					if IsPedInAnyVehicle(PlayerPedId(), false) then
						DrawText3Ds(pumpLoc['x'], pumpLoc['y'], pumpLoc['z'], "Saia do veiculo para abastecer.")
					elseif IsFueling then
						local position = GetEntityCoords(vehicle)

						DrawText3Ds(pumpLoc['x'], pumpLoc['y'], pumpLoc['z'], "Pressione ~g~G ~w~para cancelar o abastecimento do seu veiculo.")
						DrawText3Ds(position.x, position.y, position.z + 0.5, fuel .. "%")
						
						DisableControlAction(0, 0, true) -- Changing view (V)
						DisableControlAction(0, 22, true) -- Jumping (SPACE)
						DisableControlAction(0, 23, true) -- Entering vehicle (F)
						DisableControlAction(0, 24, true) -- Punching/Attacking
						DisableControlAction(0, 29, true) -- Pointing (B)
						DisableControlAction(0, 30, true) -- Moving sideways (A/D)
						DisableControlAction(0, 31, true) -- Moving back & forth (W/S)
						DisableControlAction(0, 37, true) -- Weapon wheel
						DisableControlAction(0, 44, true) -- Taking Cover (Q)
						DisableControlAction(0, 56, true) -- F9
						DisableControlAction(0, 82, true) -- Mask menu (,)
						DisableControlAction(0, 140, true) -- Hitting your vehicle (R)
						DisableControlAction(0, 166, true) -- F5
						DisableControlAction(0, 167, true) -- F6
						DisableControlAction(0, 168, true) -- F7
						DisableControlAction(0, 170, true) -- F3
						DisableControlAction(0, 288, true) -- F1
						DisableControlAction(0, 289, true) -- F2
						DisableControlAction(1, 323, true) -- Handsup (X)

						if IsControlJustReleased(0, 47) then
							loadAnimDict("reaction@male_stand@small_intro@forward")
							TaskPlayAnim(PlayerPedId(), "reaction@male_stand@small_intro@forward", "react_forward_small_intro_a", 1.0, 2, -1, 49, 0, 0, 0, 0)

							self.remote._PayFuel(price)
							Citizen.Wait(2500)
							ClearPedTasksImmediately(PlayerPedId())
							FreezeEntityPosition(PlayerPedId(), false)
							FreezeEntityPosition(vehicle, false)

							price = 0
							IsFueling = false
						end
					elseif fuel > 95.0 then
						DrawText3Ds(pumpLoc['x'], pumpLoc['y'], pumpLoc['z'], "O Veiculo está com tanque cheio.")
					elseif FuelPump <= 0.0 then
						DrawText3Ds(pumpLoc['x'], pumpLoc['y'], pumpLoc['z'], "O posto está sem combustivel.")
					else
						if GetAmmoInPedWeapon(PlayerPedId(),  883325847) > 0 and GetAmmoInPedWeapon(PlayerPedId(),  883325847) < 100 and Config.EnableBuyableJerryCans then
							DrawText3Ds(pumpLoc['x'], pumpLoc['y'], pumpLoc['z'],  "Pressione ~g~G ~w~para abastecer seu veiculo. " .. Config.FuelPrice .. "$ por litro (~b~"..FuelPump.." ~w~Litros disponivel) ou ~g~E ~w~para comprar um galão R$ " .. Config.JerryCanPrice*(100-GetAmmoInPedWeapon(PlayerPedId(), 883325847))/100 .. ".")
						elseif GetAmmoInPedWeapon(PlayerPedId(),  883325847) == 0 and Config.EnableBuyableJerryCans then
							DrawText3Ds(pumpLoc['x'], pumpLoc['y'], pumpLoc['z'], "~g~G ~w~para encher o tanque. R$ " .. Config.FuelPrice .. "/L (~b~"..FuelPump.." ~w~Litros disponivel) ou ~g~E ~w~para comprar um galão R$ " .. Config.JerryCanPrice .. ".")
						else
							DrawText3Ds(pumpLoc['x'], pumpLoc['y'], pumpLoc['z'], "~g~G ~w~para encher o tanque. R$ " .. Config.FuelPrice .. "/L (~b~"..FuelPump.." ~w~Litros disponivel)")
						end
						if Config.EnableBuyableJerryCans then
							fillJerryCan()
						end
						
						if IsControlJustReleased(0, 47) then
							if Config.FuelPrice <= money then
								local vehicle = GetPlayersLastVehicle()
								local plate   = GetVehicleNumberPlateText(vehicle)
								local model = GetEntityModel(vehicle)

								ClearPedTasksImmediately(PlayerPedId())

								if GetSelectedPedWeapon(PlayerPedId()) ~= -1569615261 then
									SetCurrentPedWeapon(PlayerPedId(), -1569615261, true)
									Citizen.Wait(1000)
								end

								IsFueling = true
								FuelVehicle()
							else
								notify("~r~Você não tem dinheiro.")
							end
						end
					end
				elseif NearVehicleWithJerryCan and not nearPump and Config.EnableJerryCans then
					local vehicle  = GetPlayersLastVehicle()
					local coords   = GetEntityCoords(vehicle)
					local fuel 	   = round(GetVehicleFuelLevel(vehicle), 1)
					local jerrycan = GetAmmoInPedWeapon(PlayerPedId(), 883325847)
					
					if IsFuelingWithJerryCan then
						DrawText3Ds(coords.x, coords.y, coords.z + 0.5, "Pressione ~g~G ~w~para cancelar o abastecimento, atualmente em: " .. fuel .. "% - Galão: " .. jerrycan .. "%")

						DisableControlAction(0, 0, true) -- Changing view (V)
						DisableControlAction(0, 22, true) -- Jumping (SPACE)
						DisableControlAction(0, 23, true) -- Entering vehicle (F)
						DisableControlAction(0, 24, true) -- Punching/Attacking
						DisableControlAction(0, 29, true) -- Pointing (B)
						DisableControlAction(0, 30, true) -- Moving sideways (A/D)
						DisableControlAction(0, 31, true) -- Moving back & forth (W/S)
						DisableControlAction(0, 37, true) -- Weapon wheel
						DisableControlAction(0, 44, true) -- Taking Cover (Q)
						DisableControlAction(0, 56, true) -- F9
						DisableControlAction(0, 82, true) -- Mask menu (,)
						DisableControlAction(0, 140, true) -- Hitting your vehicle (R)
						DisableControlAction(0, 166, true) -- F5
						DisableControlAction(0, 167, true) -- F6
						DisableControlAction(0, 168, true) -- F7
						DisableControlAction(0, 170, true) -- F3
						DisableControlAction(0, 288, true) -- F1
						DisableControlAction(0, 289, true) -- F2
						DisableControlAction(1, 323, true) -- Handsup (X)

						if IsControlJustReleased(0, 47) then
							loadAnimDict("reaction@male_stand@small_intro@forward")
							TaskPlayAnim(PlayerPedId(), "reaction@male_stand@small_intro@forward", "react_forward_small_intro_a", 1.0, 2, -1, 49, 0, 0, 0, 0)

							Citizen.Wait(2500)
							ClearPedTasksImmediately(PlayerPedId())
							FreezeEntityPosition(PlayerPedId(), false)
							FreezeEntityPosition(vehicle, false)

							IsFuelingWithJerryCan = false
						end
					else
						DrawText3Ds(coords.x, coords.y, coords.z + 0.5, "Pressione ~g~G ~w~para abastecer o veículo com o galão")

						if IsControlJustReleased(0, 47) then
							local vehicle = GetPlayersLastVehicle()
							local plate   = GetVehicleNumberPlateText(vehicle)
							local model = GetEntityModel(vehicle)

							ClearPedTasksImmediately(PlayerPedId())

							IsFuelingWithJerryCan = true

							FuelVehicle()
						end
					end
				end
			else
				Citizen.Wait(500)
			end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(500)
			if IsFueling then
				local vehicle  = GetPlayersLastVehicle()
				local plate    = GetVehicleNumberPlateText(vehicle)
				local model = GetEntityModel(vehicle)
				local fuel 	   = GetVehicleFuelLevel(vehicle)
				local integer  = math.random(30, 40)
				local fuelthis = integer / 10
				local newfuel  = fuel + fuelthis
					self.remote._CheckServerFuelTable(plate,model)
					Citizen.Wait(150)
					if FuelPump <= 0.0 then
						loadAnimDict("reaction@male_stand@small_intro@forward")
						TaskPlayAnim(PlayerPedId(), "reaction@male_stand@small_intro@forward", "react_forward_small_intro_a", 1.0, 2, -1, 49, 0, 0, 0, 0)
						Citizen.Wait(2500)
						ClearPedTasksImmediately(PlayerPedId())
						FreezeEntityPosition(PlayerPedId(), false)
						FreezeEntityPosition(vehicle, false)

						IsFueling = false
					end
					
					if newfuel < 100 then
						self.remote._CheckCashOnHand()
						SetVehicleFuelLevel(vehicle, newfuel)
						IsFueling = Config.FuelPrice <= money
						self.remote._PayFuel(fuelthis * Config.FuelPrice)
						self.remote._UsedFuel(fuelthis)
						if not IsFueling then
							loadAnimDict("reaction@male_stand@small_intro@forward")
							TaskPlayAnim(PlayerPedId(), "reaction@male_stand@small_intro@forward", "react_forward_small_intro_a", 1.0, 2, -1, 49, 0, 0, 0, 0)
							Citizen.Wait(2500)
							ClearPedTasksImmediately(PlayerPedId())
							FreezeEntityPosition(PlayerPedId(), false)
							FreezeEntityPosition(vehicle, false)
						end
						for i = 1, #Vehicles do
							if Vehicles[i].plate == plate and Vehicles[i].model == model then
								self.remote._UpdateServerFuelTable(plate, model, round(GetVehicleFuelLevel(vehicle), 1))

								table.remove(Vehicles, i)
								table.insert(Vehicles, {plate = plate, model = model, fuel = newfuel})

								break
							end
						end
					else
						SetVehicleFuelLevel(vehicle, 100.0)
						loadAnimDict("reaction@male_stand@small_intro@forward")
						TaskPlayAnim(PlayerPedId(), "reaction@male_stand@small_intro@forward", "react_forward_small_intro_a", 1.0, 2, -1, 49, 0, 0, 0, 0)

						Citizen.Wait(2500)
						ClearPedTasksImmediately(PlayerPedId())
						FreezeEntityPosition(PlayerPedId(), false)
						FreezeEntityPosition(vehicle, false)

						IsFueling = false

						for i = 1, #Vehicles do
							if Vehicles[i].plate == plate and Vehicles[i].model == model then
								self.remote._UpdateServerFuelTable(plate, model, round(GetVehicleFuelLevel(vehicle), 1))

								table.remove(Vehicles, i)
								table.insert(Vehicles, {plate = plate, model = model, fuel = newfuel})

								break
							end
						end
					end
			elseif IsFuelingWithJerryCan then
				local vehicle   = GetPlayersLastVehicle()
				local plate     = GetVehicleNumberPlateText(vehicle)
				local model 	 = GetEntityModel(vehicle)
				local fuel 	    = GetVehicleFuelLevel(vehicle)
				local integer   = math.random(8, 18)
				local fuelthis  = integer / 10
				local newfuel   = fuel + fuelthis
				local jerryfuel = fuelthis
				local jerrycurr = GetAmmoInPedWeapon(PlayerPedId(), 883325847)
				local jerrynew  = jerrycurr - jerryfuel
				if jerrycurr >= jerryfuel then
					self.remote._CheckServerFuelTable(plate, model)
					Citizen.Wait(150)
					SetPedAmmo(PlayerPedId(), 883325847, round(jerrynew, 0))
					if newfuel < 100 then
						SetVehicleFuelLevel(vehicle, newfuel)

						for i = 1, #Vehicles do
							if Vehicles[i].plate == plate and Vehicles[i].model == model then
								self.remote._UpdateServerFuelTable(plate, model, round(GetVehicleFuelLevel(vehicle), 1))

								table.remove(Vehicles, i)
								table.insert(Vehicles, {plate = plate, model = model, fuel = newfuel})

								break
							end
						end
					else
						SetVehicleFuelLevel(vehicle, 100.0)
						loadAnimDict("reaction@male_stand@small_intro@forward")
						TaskPlayAnim(PlayerPedId(), "reaction@male_stand@small_intro@forward", "react_forward_small_intro_a", 1.0, 2, -1, 49, 0, 0, 0, 0)

						Citizen.Wait(2500)
						ClearPedTasksImmediately(PlayerPedId())
						FreezeEntityPosition(PlayerPedId(), false)
						FreezeEntityPosition(vehicle, false)

						IsFuelingWithJerryCan = false

						for i = 1, #Vehicles do
							if Vehicles[i].plate == plate and Vehicles[i].model == model then
								self.remote._UpdateServerFuelTable(plate, model, round(GetVehicleFuelLevel(vehicle), 1))

								table.remove(Vehicles, i)
								table.insert(Vehicles, {plate = plate, model = model, fuel = newfuel})

								break
							end
						end
					end
				else
					loadAnimDict("reaction@male_stand@small_intro@forward")
					TaskPlayAnim(PlayerPedId(), "reaction@male_stand@small_intro@forward", "react_forward_small_intro_a", 1.0, 2, -1, 49, 0, 0, 0, 0)

					Citizen.Wait(2500)
					ClearPedTasksImmediately(PlayerPedId())
					FreezeEntityPosition(PlayerPedId(), false)
					FreezeEntityPosition(vehicle, false)

					IsFuelingWithJerryCan = false

					for i = 1, #Vehicles do
						if Vehicles[i].plate == plate and Vehicles[i].model == model then
							self.remote._UpdateServerFuelTable(plate, model, round(GetVehicleFuelLevel(vehicle), 1))

							table.remove(Vehicles, i)
							table.insert(Vehicles, {plate = plate, model = model, fuel = newfuel})

							break
						end
					end
				end
			end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(250)

			if IsPedInAnyVehicle(PlayerPedId()) then
				Citizen.Wait(2500)

				Timer = true
			else
				Timer = false
			end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1500)

			nearPump 			 	= false
			IsCloseToLastVehicle 	= false
			found 				 	= false
			NearVehicleWithJerryCan = false

			local myCoords = GetEntityCoords(PlayerPedId())
			
			for i = 1, #models do
				local closestPump = GetClosestObjectOfType(myCoords.x, myCoords.y, myCoords.z, 1.5, models[i], false, false)
				
				if closestPump ~= nil and closestPump ~= 0 then
					local coords    = GetEntityCoords(closestPump)
					local vehicle   = GetPlayersLastVehicle()

					nearPump = true
					pumpLoc  = {['x'] = coords.x, ['y'] = coords.y, ['z'] = coords.z + 1.2}

					if vehicle ~= nil then
						local vehcoords = GetEntityCoords(vehicle)
						local mycoords  = GetEntityCoords(PlayerPedId())
						local distance  = GetDistanceBetweenCoords(vehcoords.x, vehcoords.y, vehcoords.z, mycoords.x, mycoords.y, mycoords.z)

						if distance < 3 then
							IsCloseToLastVehicle = true
						end
					end
					break
				end
			end

			if IsPedInAnyVehicle(PlayerPedId(), false) then
				local vehicle = GetPlayersLastVehicle()
				local plate   = GetVehicleNumberPlateText(vehicle)
				local model = GetEntityModel(vehicle)
				local fuel 	  = GetVehicleFuelLevel(vehicle)
				local found   = false

				self.remote._CheckServerFuelTable(plate, model)

				Citizen.Wait(500)

				for i = 1, #Vehicles do
					if Vehicles[i].plate == plate and Vehicles[i].model == model then
						found = true
						fuel  = round(Vehicles[i].fuel, 1)

						break
					end
				end

				if not found then
					integer = math.random(200, 800)
					fuel 	= integer / 10

					table.insert(Vehicles, {plate = plate, model = model ,fuel = fuel})

					self.remote._UpdateServerFuelTable(plate, model, fuel)
				end

				SetVehicleFuelLevel(vehicle, fuel)
			end

			local currentVeh = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))

			for i = 1, #blacklistedVehicles do
				if blacklistedVehicles[i] == currentVeh then
					InBlacklistedVehicle = true
					found 				 = true
					
					break
				end
			end

			if not found then
				InBlacklistedVehicle = false
			end

			if nearPump then
				self.remote._CheckCashOnHand()
				self.remote._CheckFuelPump()
			end

			local CurrentWeapon = GetSelectedPedWeapon(PlayerPedId())
							
			if CurrentWeapon == 883325847 then
				local MyCoords 		= GetEntityCoords(PlayerPedId())
				local Vehicle  		= GetClosestVehicle(MyCoords.x, MyCoords.y, MyCoords.z, 3.0, false, 23) == GetPlayersLastVehicle() and GetPlayersLastVehicle() or 0

				if Vehicle ~= 0 then
					NearVehicleWithJerryCan = true
				end
			end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5000)

			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			local engine  = Citizen.InvokeNative(0xAE31E7DF9B5B132E, vehicle)

			if vehicle and engine then
				local plate    	   = GetVehicleNumberPlateText(vehicle)
				local model 			= GetEntityModel(vehicle)
				local rpm 	   	   = GetVehicleCurrentRpm(vehicle)
				local fuel     	   = GetVehicleFuelLevel(vehicle)
				local usage        = Config.Usage
				local rpmfuelusage = 0

				for k, v in pairs(Config.SpecialUsage) do
					if model == GetHashKey(k) then
						usage = v
						break
					end
				end
				rpmfuelusage = fuel - rpm*usage
				Citizen.Wait(1000/(rpm*0.3))
				for i = 1, #Vehicles do
					if Vehicles[i].plate == plate and Vehicles[i].model == model then
						SetVehicleFuelLevel(vehicle, rpmfuelusage)

						local updatedfuel = round(GetVehicleFuelLevel(vehicle), 1)

						if updatedfuel ~= 0 then
							self.remote._UpdateServerFuelTable(plate, model, updatedfuel)

							table.remove(Vehicles, i)
							table.insert(Vehicles, {plate = plate, model = model, fuel = rpmfuelusage})
						end

						break
					end
				end

				if rpmfuelusage < Config.VehicleFailure then
					SetVehicleUndriveable(vehicle, true)
				elseif rpmfuelusage == 0 then
					SetVehicleEngineOn(vehicle, false, false, false)
				else
					SetVehicleUndriveable(vehicle, false)
				end
			end
		end
	end)

	function fillJerryCan()
		if IsControlJustReleased(1,  51) then
			self.remote.CheckCashOnHand()
			if GetAmmoInPedWeapon(PlayerPedId(),  883325847) > 0 then
				local price = Config.JerryCanPrice*(100-GetAmmoInPedWeapon(PlayerPedId(), 883325847))/100
				if price <= money then
					self.remote.PayFuel(price)
					GiveWeaponToPed(PlayerPedId(), 883325847, 100-GetAmmoInPedWeapon(PlayerPedId(), 883325847), false, false)
					notify("~g~Seu galão agora está cheio.")
				else
					notify("~r~Você não tem dinheiro.")
				end
			else
				if Config.JerryCanPrice <= money then
					self.remote.PayFuel(Config.JerryCanPrice)
					GiveWeaponToPed(PlayerPedId(), 883325847, 100, false, false)
					notify("~g~Você comprou um Galão.")
				else
					notify("~r~Você não tem dinheiro.")
				end
			end
		end
	end

end

function notify( text )
	SetNotificationTextEntry( "STRING" )
	AddTextComponentString( text )
	DrawNotification( false, false )
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

function FuelVehicle()
	local ped 	  = PlayerPedId()
	local coords  = GetEntityCoords(ped)
	local vehicle = GetPlayersLastVehicle()

	FreezeEntityPosition(ped, true)
	FreezeEntityPosition(vehicle, false)
	SetVehicleEngineOn(vehicle, false, false, false)
	loadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 1.0, 2, -1, 49, 0, 0, 0, 0)
end


function round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function GetSeatPedIsIn(ped)
	local vehicle = GetVehiclePedIsIn(ped, false)

	for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
		if GetPedInVehicleSeat(vehicle, i) == ped then
			return i
		end
	end

	return -2
end

function DisplayHud()
	if IsPedInAnyVehicle(PlayerPedId(), false) and GetSeatPedIsIn(PlayerPedId()) == -1 then
		local vehicle = GetPlayersLastVehicle()
		local fuel    = math.ceil(round(GetVehicleFuelLevel(vehicle), 1))
		local kmh 	  =	round(GetEntitySpeed(vehicle) * 3.6, 0)
		local mph 	  = round(GetEntitySpeed(vehicle) * 2.236936, 0)

		if fuel == 0 then
			fuel = "0"
		end
		if kmh == 0 then
			kmh = "0"
		end
		if mph == 0 then
			mph = "0"
		end

		x = 0.01135
		y = 0.002

		DrawAdvancedText(0.2195 - x, 0.77 - y, 0.005, 0.0028, 0.6, fuel, 255, 255, 255, 255, 6, 1)

		DrawAdvancedText(0.130 - x, 0.77 - y, 0.005, 0.0028, 0.6, mph, 255, 255, 255, 255, 6, 1)
		DrawAdvancedText(0.174 - x, 0.77 - y, 0.005, 0.0028, 0.6, kmh, 255, 255, 255, 255, 6, 1)

		DrawAdvancedText(0.148 - x, 0.7765 - y, 0.005, 0.0028, 0.4, "mp/h              km/h              Fuel", 255, 255, 255, 255, 6, 1)
	end
end

	Citizen.CreateThread(function()
		if Config.EnableBlips then
			for k, v in ipairs(gas_stations) do
				local blip = AddBlipForCoord(v.x, v.y, v.z)

				SetBlipSprite(blip, 361)
				SetBlipScale(blip, 0.9)
				SetBlipColour(blip, 6)
				SetBlipDisplay(blip, 4)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Gas Station")
				EndTextCommandSetBlipName(blip)
			end
		end
	end)


function LegacyFuel:ReturnFuelFromServerTable(vehInfo)
	local fuel   = round(vehInfo.fuel, 1)

	for i = 1, #Vehicles do
		if Vehicles[i].plate == vehInfo.plate and Vehicles[i].plate == model then
			table.remove(Vehicles, i)

			break
		end
	end

	table.insert(Vehicles, {plate = vehInfo.plate, model = model, fuel = fuel})
end



function LegacyFuel:RecieveCashOnHand(cb)
	money = cb
end

function LegacyFuel:RecievePumpGas(cb)
	FuelPump = cb
end

LegacyFuel.tunnel = {}
LegacyFuel.tunnel.RecieveCashOnHand = LegacyFuel.RecieveCashOnHand
LegacyFuel.tunnel.RecievePumpGas = LegacyFuel.RecievePumpGas
LegacyFuel.tunnel.ReturnFuelFromServerTable = LegacyFuel.ReturnFuelFromServerTable


vRP:registerExtension(LegacyFuel)