Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")


local cvRP = module("vrp", "client/vRP")
vRP = cvRP() 

local vRPRebornFaturas = class("vRPRebornFaturas", vRP.Extension)

function vRPRebornFaturas:__construct()
	vRP.Extension.__construct(self)

end


function vRPRebornFaturas:aviso(target,msg,valor)
   print(GetPlayerFromServerId(target))
	local handle = RegisterPedheadshot(GetPlayerPed(GetPlayerFromServerId(target)))
	while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
		Citizen.Wait(0)
	end
	local txd2 = GetPedheadshotTxdString(handle)
	--DrawCTRPNotification('Faturas', 'Recebimento',msg,txd2,1)
	SetNotificationBackgroundColor(130)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	SetNotificationMessage(txd2, txd2, false, 1, 'Faturas', 'Recebimento')
	DrawNotification(false, false)


end

	function DrawCTRPNotification(title, subject, msg, icon, iconType)

	end

vRPRebornFaturas.tunnel = {}
vRPRebornFaturas.tunnel.aviso = vRPRebornFaturas.aviso

vRP:registerExtension(vRPRebornFaturas)
