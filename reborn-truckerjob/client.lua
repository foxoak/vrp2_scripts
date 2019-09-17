Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")


local cvRP = module("vrp", "client/vRP")
vRP = cvRP() 

local reborn_truckerjob = class("reborn_truckerjob", vRP.Extension)

function reborn_truckerjob:__construct()
    vRP.Extension.__construct(self)

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

--use this for debugging
function Chat(t)
    TriggerEvent("chatMessage", 'TRUCKER', { 0, 255, 255}, "" .. tostring(t))
end

--locations
--arrays
local TruckingCompany = {} 
TruckingCompany[0] = {["x"] = 1715.0076904297,["y"] = -1598.7048339844, ["z"] = 113.81462860107}
local TruckingTruck = {
    [0] = {1724.3327636719,-1587.7448730469,112.56467437744},
    [1] = {1742.3513183594,-1580.3264160156,112.6042175293},
    [2] = {1727.4803466797,-1614.3941650391,112.44622039795},
    [3] = {1710.8699951172,-1633.0706787109,112.48481750488}
}
local TruckingTrailer = {
    [0] = {1730.7670898438,-1556.5288085938,112.65879058838},
    [1] = {1737.6207275391,-1544.4066162109,112.6888961792},
    [2] = {1738.1821289063,-1534.6549072266,112.66035461426},
    [3] = {1745.5131835938,-1509.6893310547,112.81945037842},
    [4] = {1750.5987548828,-1498.1309814453,112.7942199707},
    [5] = {1754.3411865234,-1486.8299560547,112.87160491943}
}

local Truck = {"PACKER"} --"HAULER", "PACKER", "PHANTOM"}
local Trailer = {"TANKER","TANKER2","TANKER2","TANKER"}--,"TRAILERS", "TRAILERS2", "TRAILERLOGS"}

local MissionData = {
    [0] = {260.57025146484,-1263.3707275391,29.142902374268, 500}, --x,y,z,money
    [1] = {616.5,268.74987792969,103.08715820313, 600}, 
    [2] = {-728.46710205078,-935.49188232422,19.017004013062, 650},
    [3] = {2577.4802246094,361.57229614258,108.45735168457, 800},
    [4] = {-1797.8078613281,807.94110107422,138.0274810791, 1200},
    [5] = {47.992733001709,2775.6945800781,57.39754486084, 1350},
    [6] = {-2555.8757324219,2330.4143066406,32.571796417236, 1600},
    [7] = {1687.5904541016,4930.2456054688,41.5862159729, 1800},
    [8] = {1701.8393554688,6420.080078125,32.145679473877, 2000},
    [9] = {176.3996887207,6601.580078125,31.84895324707, 2300},
}
local MISSION = {}
MISSION.start = false
MISSION.tailer = false
MISSION.truck = false

MISSION.hashTruck = 0
MISSION.hashTrailer = 0

local currentMission = -1

local playerCoords
local playerPed

local GUI = {}
GUI.loaded          = false
GUI.showStartText   = false
GUI.showMenu        = false
GUI.selected        = {}
GUI.menu            = -1 --current menu

GUI.title           = {}
GUI.titleCount      = 0

GUI.desc            = {}
GUI.descCount       = 0

GUI.button          = {}
GUI.buttonCount     = 0

GUI.time            = 0

--text for mission
local text1 = false
local text2 = false

--blips
local BLIP = {}

BLIP.company = 0

BLIP.trailer = {}
BLIP.trailer.i = 0

BLIP.destination = {}
BLIP.destination.i = 0

--focus button color
local r = 0
local g= 128
local b = 192
local alpha = 200

function clear()    
    MISSION.start = false
    SetBlipRoute(BLIP.destination[BLIP.destination.i], false) 
    SetEntityAsNoLongerNeeded(BLIP.destination[BLIP.destination.i])
    
    if ( DoesEntityExist(MISSION.trailer) ) then
         SetEntityAsNoLongerNeeded(MISSION.trailer)
    end
    if ( DoesEntityExist(MISSION.truck) ) then
         SetEntityAsNoLongerNeeded(MISSION.truck)
         --SetVehicleDoorsLocked(MISSION.truck, 2)
         --SetVehicleUndriveable(MISSION.truck, true)
    end
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(MISSION.trailer))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(MISSION.truck))

    MISSION.trailer = 0
    MISSION.truck = 0
    MISSION.hashTruck = 0
    MISSION.hashTrailer = 0
    currentMission = -1
end

local initload = false
Citizen.CreateThread(function() 
    while true do
       Wait(0)
       playerPed = GetPlayerPed(-1)
       playerCoords = GetEntityCoords(playerPed, 0)
        if (not initload) then
            init()
            initload = true
        end
        tick()
    end
    
end)

function init()
 --   BLIP.company = AddBlipForCoord(TruckingCompany[0]["x"], TruckingCompany[0]["y"], TruckingCompany[0]["z"])
    SetBlipSprite(BLIP.company, 408)
  --  SetBlipDisplay(BLIP.company, 4)
   -- SetBlipScale(BLIP.company, 0.8)
   -- Citizen.Trace("Truck Blip added.")
   -- GUI.loaded = true
end

--Draw Text / Menus
function tick()
    
    --debugging stange things
    if ( type(BLIP.trailer[BLIP.trailer.i]) == "boolean" ) then
        --Citizen.Trace("-FAIL!-")
    elseif( BLIP.trailer[BLIP.trailer.i] == nil ) then
        --Citizen.Trace("-nil-")
    else
       BLIP.trailer[BLIP.trailer.i] = BLIP.trailer[BLIP.trailer.i]
       BLIP.destination[BLIP.destination.i] = BLIP.destination[BLIP.destination.i]
    end
    
    
    --Show menu, when player is near
    if( MISSION.start == false) then
    if( GetDistanceBetweenCoords( playerCoords, TruckingCompany[0]["x"], TruckingCompany[0]["y"], TruckingCompany[0]["z"] ) < 10) then
            if(GUI.showStartText == false) then
                GUI.drawStartText()
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )
            end
                --key controlling
                if(IsControlPressed(1, Keys["E"]) and GUI.showMenu == false) then
                    --clear()
                    GUI.showMenu = true
                    GUI.menu = 0
                end
                if(IsControlPressed(1, Keys["N-"]) and GUI.showMenu == true) then
                    GUI.showMenu = false
                end
            else
                GUI.showStartText = false
        end --if GetDistanceBetweenCoords ...

        --menu
        if( GUI.loaded == false ) then
            GUI.init()
        end

        if( GUI.showMenu == true and GUI.menu ~= -1) then
            if( GUI.time == 0) then
                GUI.time = GetGameTimer()
            end
            if( (GetGameTimer() - GUI.time) > 10) then
                GUI.updateSelectionMenu(GUI.menu)
                GUI.time = 0
            end
            GUI.renderMenu(GUI.menu)
        end --if GUI.loaded == false
    elseif( MISSION.start == true ) then
        
        MISSION.markerUpdate(IsEntityAttached(MISSION.trailer))
        if( IsEntityAttached(MISSION.trailer) and text1 == false) then
            TriggerEvent("mt:missiontext", "Dirija até o ~g~Destino~w~.", 10000)
            text1 = true
        elseif( not IsEntityAttached(MISSION.trailer) and text2 == false ) then
            TriggerEvent("mt:missiontext", "Pegue a ~o~Carga~w~.", 15000)
            text2 = true
        end
        Wait(2000)
        local trailerCoords = GetEntityCoords(MISSION.trailer, 0)
        if ( GetDistanceBetweenCoords(currentMission[1], currentMission[2], currentMission[3], trailerCoords ) < 25 and  not IsEntityAttached(MISSION.trailer)) then
            TriggerEvent("mt:missiontext", "Volte com o Caminhão até o Inicio para Iniciar um novo Trabalho!", 15000)
            MISSION.removeMarker()
            MISSION.destroytrailer()
            self.remote._truckerJob_success(currentMission[4])
            clear()
        elseif ( GetDistanceBetweenCoords(currentMission[1], currentMission[2], currentMission[3], trailerCoords ) < 25 and IsEntityAttached(MISSION.trailer) ) then
            TriggerEvent("mt:missiontext", "Para entregar a ~o~Carga~w~ mantenha  ~r~H~w~ Pressionado.", 15000)
        end
        
        if ( IsEntityDead(MISSION.trailer) or IsEntityDead(MISSION.truck) ) then
            MISSION.removeMarker()
            clear()
        end
    end --if MISSION.start == false
end



---------------------------------------
---------------------------------------
---------------------------------------
----------------MISSON-----------------
---------------------------------------   
---------------------------------------  
---------------------------------------
function GUI.optionMisson(trailerN)
    
    --select trailer
    MISSION.hashTrailer = GetHashKey(Trailer[trailerN + 1])
    RequestModel(MISSION.hashTrailer)
    
    while not HasModelLoaded(MISSION.hashTrailer) do
        Wait(1)
    end
    
    --select random truck
    local randomTruck = GetRandomIntInRange(1, #Truck)
    
    MISSION.hashTruck = GetHashKey(Truck[randomTruck])
    RequestModel(MISSION.hashTruck)
    
    while not HasModelLoaded(MISSION.hashTruck) do
        Wait(1)
    end
end

function GUI.mission(missionN)
 --currently one destination per ride
    BLIP.trailer.i = BLIP.trailer.i + 1
    BLIP.destination.i = BLIP.destination.i + 1
    currentMission = MissionData[missionN]
    GUI.showMenu = false
    --mission start 
    MISSION.start = true
    MISSION.spawnTruck()
    MISSION.spawnTrailer()
end

function MISSION.spawnTruck()
    local rand = math.random(#TruckingTruck)
    MISSION.truck = CreateVehicle(MISSION.hashTruck, TruckingTruck[rand][1], TruckingTruck[rand][2], TruckingTruck[rand][3], 0.0, true, false)
    SetVehicleOnGroundProperly(MISSION.trailer)
    SetVehicleNumberPlateText(MISSION.truck, "REBORN")
    SetVehRadioStation(MISSION.truck, "OFF")
    SetPedIntoVehicle(playerPed, MISSION.truck, -1)
    SetVehicleEngineOn(MISSION.truck, true, false, false)
    SetVehicleOnGroundProperly(MISSION.truck)
    
    --important
    --SetEntityAsMissionEntity(MISSION.truck, true, true);
end

function MISSION.spawnTrailer()

    local rand = math.random(#TruckingTrailer)
    MISSION.trailer = CreateVehicle(MISSION.hashTrailer, TruckingTrailer[rand][1], TruckingTrailer[rand][2], TruckingTrailer[rand][3], 250.0, true, false)
    SetVehicleOnGroundProperly(MISSION.trailer)
    
    --setMarker on trailer
    MISSION.trailerMarker()
end

local oneTime = false

function MISSION.trailerMarker()
    --BLIP.trailer.i = BLIP.trailer.i + 1 this happens in GUI.mission()
    BLIP.trailer[BLIP.trailer.i] = AddBlipForEntity(MISSION.trailer)
    SetBlipSprite(BLIP.trailer[BLIP.trailer.i], 1)
    SetBlipColour(BLIP.trailer[BLIP.trailer.i], 17)
    SetBlipRoute(BLIP.trailer[BLIP.trailer.i], false)
    Wait(50)
end

function MISSION.markerUpdate(trailerAttached)
    if( not BLIP.destination[BLIP.destination.i] and trailerAttached) then
       -- BLIP.destination.i = BLIP.destination.i + 1 this happens in GUI.mission()
        BLIP.destination[BLIP.destination.i]  = AddBlipForCoord(currentMission[1], currentMission[2], currentMission[3])
        SetBlipSprite(BLIP.destination[BLIP.destination.i], 1)
        SetBlipColour(BLIP.destination[BLIP.destination.i], 2)
        SetBlipRoute(BLIP.destination[BLIP.destination.i], true)
    end
    if( trailerAttached ) then
        SetBlipSprite(BLIP.trailer[BLIP.trailer.i], 2) --invisible
    elseif ( not trailerAttached and BLIP.trailer[BLIP.trailer.i]) then
        SetBlipSprite(BLIP.trailer[BLIP.trailer.i], 1) --visible
        SetBlipColour(BLIP.trailer[BLIP.trailer.i], 17)
    end
    Wait(50)
end

function MISSION.destroytrailer()
    SetEntityAsMissionEntity(MISSION.trailer, true, true)
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(MISSION.trailer))
    MISSION.trailer = nil
end

function MISSION.removeMarker()
    SetBlipSprite(BLIP.destination[BLIP.destination.i], 2)--invisible
    SetBlipSprite(BLIP.trailer[BLIP.trailer.i], 2) --invisible
end

function MISSION.getMoney()
    TriggerEvent("truckerJob:getMoney", currentMission[4])
end
---------------------------------------
---------------------------------------
---------------------------------------
-----------------MENU------------------
---------------------------------------   
---------------------------------------  
---------------------------------------
function GUI.drawStartText()
    TriggerEvent("mt:missiontext", "Empresa de Transporte de Combustíveis está contratando! Pressione ~b~[E]~w~ para começar.", 500)
    --GUI.showStartText = true
end

function GUI.renderMenu(menu)
    GUI.renderTitle()
    GUI.renderDesc()
    GUI.renderButtons(menu)
end

function GUI.init()
    GUI.loaded = true
    GUI.addTitle("Contratos disponíveis", 0.425, 0.19, 0.45, 0.07 )
    GUI.addDesc("Escolha o tipo de carga", 0.575, 0.375, 0.15, 0.30 )

    --menu, title, function, position
    GUI.addButton(0, "Transporte de Diesel", GUI.optionMisson, 0.35, 0.25, 0.3, 0.05 )
    GUI.addButton(0, "Transporte de Etanol", GUI.optionMisson, 0.35, 0.30, 0.3, 0.05 )    
    GUI.addButton(0, "Transporte de Gasolina", GUI.optionMisson, 0.35, 0.35, 0.3, 0.05 )        
    GUI.addButton(0, "Transporte de Podium", GUI.optionMisson, 0.35, 0.40, 0.3, 0.05 )            
    --GUI.addButton(0, "Carga de Recipientes", GUI.optionMisson, 0.35, 0.30, 0.3, 0.05 )
    --GUI.addButton(0, "Reboque Articulado", GUI.optionMisson, 0.35, 0.35, 0.3, 0.05 )
    --GUI.addButton(0, "Reboque Madereira", GUI.optionMisson, 0.35, 0.40, 0.3, 0.05 )
    GUI.addButton(0, " ", GUI.null, 0.35, 0.45, 0.3, 0.05)
    GUI.addButton(0, "Fechar Menu", GUI.exit, 0.35, 0.50, 0.3, 0.05 )
    
    GUI.buttonCount = 0

    GUI.addButton(1, "Contrato 1 - Posto Strawberry [ R$ 500 ]", GUI.mission, 0.35, 0.25, 0.3, 0.05)
    GUI.addButton(1, "Contrato 2 - Posto Vinewood [ R$ 600 ]", GUI.mission, 0.35, 0.30, 0.3, 0.05)
    GUI.addButton(1, "Contrato 3 - Posto Little Seoul [ R$ 650 ]", GUI.mission, 0.35, 0.35, 0.3, 0.05)
    GUI.addButton(1, "Contrato 4 - Posto Montanhas Tataviam [ R$ 800 ]", GUI.mission, 0.35, 0.40, 0.3, 0.05)
    GUI.addButton(1, "Contrato 5 - Posto Richman R$ 1.200 ]", GUI.mission, 0.35, 0.45, 0.3, 0.05)
    GUI.addButton(1, "Contrato 6 - Posto Deserto Grand [ R$ 1.350 ]", GUI.mission, 0.35, 0.50, 0.3, 0.05)
    GUI.addButton(1, "Contrato 7 - Posto Lago Zancudo [ R$ 1.600 ]", GUI.mission, 0.35, 0.55, 0.3, 0.05)
    GUI.addButton(1, "Contrato 8 - Posto Grapeseed [ R$ 1.800 ]", GUI.mission, 0.35, 0.60, 0.3, 0.05)
    GUI.addButton(1, "Contrato 9 - Posto Monte Chiliad [ R$ 2.000 ]", GUI.mission, 0.35, 0.65, 0.3, 0.05)
    GUI.addButton(1, "Contrato 10 - Posto Paleto [ R$ 2.300 ]", GUI.mission, 0.35, 0.70, 0.3, 0.05)
    GUI.addButton(1, "Fechar Menu", GUI.exit, 0.35, 0.80, 0.3, 0.05)
end

--Render stuff
function GUI.renderTitle()
    for id, settings in pairs(GUI.title) do
        local screen_w = 0
        local screen_h = 0
        screen_w, screen_h = GetScreenResolution(0,0)
        boxColor = {0,0,0,255}
        SetTextFont(0)
        SetTextScale(0.0, 0.40)
        SetTextColour(255, 255, 255, 255)
        SetTextCentre(true)
        SetTextDropshadow(0, 0, 0, 0, 0)
        SetTextEdge(0, 0, 0, 0, 0)
        SetTextEntry("STRING")
        AddTextComponentString(settings["name"])
        DrawText((settings["xpos"] + 0.001), (settings["ypos"] - 0.015))
        --AddTextComponentString(settings["name"])
        GUI.renderBox(
            settings["xpos"], settings["ypos"], settings["xscale"], settings["yscale"],
            boxColor[1], boxColor[2], boxColor[3], boxColor[4]
        )
    end
end

function GUI.renderDesc()
        for id, settings in pairs(GUI.desc) do
        local screen_w = 0
        local screen_h = 0
        screen_w, screen_h =  GetScreenResolution(0, 0)
        boxColor = {0,0,0,240}
        SetTextFont(0)
        SetTextScale(0.0, 0.37)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 0)
        SetTextEdge(0, 0, 0, 0, 0)
        SetTextEntry("STRING")
        AddTextComponentString(settings["name"] .. "\n" .."\n" .."Navegue com as" .. "\n" .. "Setas." .. "\n" .. "ENTER para Confirmar".. "\n")
        DrawText((settings["xpos"] - 0.06), (settings["ypos"] - 0.13))
        AddTextComponentString(settings["name"])
        GUI.renderBox(
            settings["xpos"], settings["ypos"], settings["xscale"], settings["yscale"],
            boxColor[1], boxColor[2], boxColor[3], boxColor[4]
        )
        end
end

function GUI.renderButtons(menu)
    for id, settings in pairs(GUI.button[menu]) do
        local screen_w = 0
        local screen_h = 0
        screen_w, screen_h =  GetScreenResolution(0, 0)
        boxColor = {0,0,0,100}
        if(settings["active"]) then
            boxColor = {r,g,b,alpha}
        end
        SetTextFont(0)
        SetTextScale(0.0, 0.35)
        SetTextColour(255, 255, 255, 255)
        SetTextCentre(true)
        SetTextDropShadow(0, 0, 0, 0, 0)
        SetTextEdge(0, 0, 0, 0, 0)
        SetTextEntry("STRING")
        AddTextComponentString(settings["name"])
        DrawText((settings["xpos"] + 0.001), (settings["ypos"] - 0.015))
        --AddTextComponentString(settings["name"])
        GUI.renderBox(
            settings["xpos"], settings["ypos"], settings["xscale"],
            settings["yscale"], boxColor[1], boxColor[2], boxColor[3], boxColor[4]
        )
     end     
end

function GUI.renderBox(xpos, ypos, xscale, yscale, color1, color2, color3, color4)
    DrawRect(xpos, ypos, xscale, yscale, color1, color2, color3, color4);
end

--adding stuff
function GUI.addTitle(name, xpos, ypos, xscale, yscale)
    GUI.title[GUI.titleCount] = {}
    GUI.title[GUI.titleCount]["name"] = name
    GUI.title[GUI.titleCount]["xpos"] = xpos
    GUI.title[GUI.titleCount]["ypos"] = ypos    
    GUI.title[GUI.titleCount]["xscale"] = xscale
    GUI.title[GUI.titleCount]["yscale"] = yscale
end

function GUI.addDesc(name, xpos, ypos, xscale, yscale)
    GUI.desc[GUI.descCount] = {}
    GUI.desc[GUI.descCount]["name"] = name
    GUI.desc[GUI.descCount]["xpos"] = xpos
    GUI.desc[GUI.descCount]["ypos"] = ypos  
    GUI.desc[GUI.descCount]["xscale"] = xscale
    GUI.desc[GUI.descCount]["yscale"] = yscale
end

function GUI.addButton(menu, name, func, xpos, ypos, xscale, yscale)
    if(not GUI.button[menu]) then
        GUI.button[menu] = {}
        GUI.selected[menu] = 0
    end
    GUI.button[menu][GUI.buttonCount] = {}
    GUI.button[menu][GUI.buttonCount]["name"] = name
    GUI.button[menu][GUI.buttonCount]["func"] = func
    GUI.button[menu][GUI.buttonCount]["xpos"] = xpos
    GUI.button[menu][GUI.buttonCount]["ypos"] = ypos    
    GUI.button[menu][GUI.buttonCount]["xscale"] = xscale
    GUI.button[menu][GUI.buttonCount]["yscale"] = yscale
    GUI.button[menu][GUI.buttonCount]["active"] = 0
    GUI.buttonCount = GUI.buttonCount + 1
end

function GUI.null()
end

function GUI.exit()
    GUI.showMenu = false
    print("Exit menu")
end

--update stuff
function GUI.updateSelectionMenu(menu)
    if( IsControlPressed(0, Keys["DOWN"]) ) then
        if( GUI.selected[menu] < #GUI.button[menu] ) then
            GUI.selected[menu] = GUI.selected[menu] + 1
        end
    elseif( IsControlPressed(0, Keys["TOP"]) ) then
        if( GUI.selected[menu] > 0 ) then
            GUI.selected[menu] = GUI.selected[menu] - 1 
        end
    elseif( IsControlPressed(0, Keys["ENTER"]) ) then
        if( type(GUI.button[menu][GUI.selected[menu]]["func"]) == "function" ) then
            --remember variable GUI.selected[menu]
            
            --call mission functions
            GUI.button[menu][GUI.selected[menu]]["func"](GUI.selected[menu])
            
            GUI.menu = 1
            GUI.selected[menu] = 0
            if( not GUI.menu ) then
                GUI.menu = -1
            end
            Wait(500)
            
            --GUI.button[menu][GUI.selected[menu]]["func"](GUI.selected[menu])
        else
            Citizen.Trace("\n Failes to call function! - Selected Menu: "..GUI.selected[menu].." \n")
        end
        GUI.time = 0
    end
    local i = 0
    for id, settings in ipairs(GUI.button[menu]) do
        GUI.button[menu][i]["active"] = false
        if( i == GUI.selected[menu] ) then
            GUI.button[menu][i]["active"] = true
        end
        i = i + 1
    end
end




end

-- Register a network event 
RegisterNetEvent( 'wk:deleteVehicle' )

-- Add an event handler for the deleteVehicle event. 
-- Gets called when a user types in /dv in chat (see server.lua)
AddEventHandler( 'wk:deleteVehicle', function()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        local pos = GetEntityCoords( ped )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )

                if ( DoesEntityExist( vehicle ) ) then 
                	ShowNotification( "~r~Unable to delete vehicle, try again." )
                else 
                	ShowNotification( "Vehicle deleted." )
                end 
            else 
                ShowNotification( "You must be in the driver's seat!" )
            end 
        else
            local playerPos = GetEntityCoords( ped, 1 )
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then 
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )

                if ( DoesEntityExist( vehicle ) ) then 
                	ShowNotification( "~r~Unable to delete vehicle, try again." )
                else 
                	ShowNotification( "Vehicle deleted." )
                end 
            else 
                ShowNotification( "You must be in or near a vehicle to delete it." )
            end 
        end 
    end 
end )

-- Delete car function borrowed frtom Mr.Scammer's model blacklist, thanks to him!
function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

-- Gets a vehicle in a certain direction
-- Credit to Konijima
function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

-- Shows a notification on the player's screen 
function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

vRP:registerExtension(reborn_truckerjob)