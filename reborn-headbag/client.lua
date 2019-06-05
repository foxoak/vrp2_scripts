Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")


local cvRP = module("vrp", "client/vRP")
vRP = cvRP() 

local reborn_headbag = class("reborn_headbag", vRP.Extension)

HaveBagOnHead = false

function reborn_headbag:__construct()
    vRP.Extension.__construct(self)

end

function reborn_headbag:checkHeadBag()
    print('check')
    print(HaveBagOnHead)
  return HaveBagOnHead
end

function reborn_headbag:PutHeadBag()
    print('PutBag ')
    local playerPed = GetPlayerPed(-1)
    ObjectBag = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true) -- Create head bag object!
    AttachEntityToEntity(ObjectBag, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- Attach object to head
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openGeneral'})
    HaveBagOnHead = true
end 

AddEventHandler('playerSpawned', function() --This event delete head bag when player is spawn again
        DeleteEntity(ObjectBag)
        SetEntityAsNoLongerNeeded(ObjectBag)
        SendNUIMessage({type = 'closeAll'})
        HaveBagOnHead = false
end)

function reborn_headbag:deletebaghead()
    DeleteEntity(ObjectBag)
    SetEntityAsNoLongerNeeded(ObjectBag)
    SendNUIMessage({type = 'closeAll'})
    HaveBagOnHead = false
end

reborn_headbag.tunnel = {}
reborn_headbag.tunnel.checkHeadBag = reborn_headbag.checkHeadBag
reborn_headbag.tunnel.PutHeadBag = reborn_headbag.PutHeadBag
reborn_headbag.tunnel.deletebaghead = reborn_headbag.deletebaghead

vRP:registerExtension(reborn_headbag)

