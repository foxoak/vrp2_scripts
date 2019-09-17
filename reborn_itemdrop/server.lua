IDManager = module("vrp", "lib/IDManager")
IDm = IDManager()

local vRPRebornItemDrop = class("vRPRebornItemDrop", vRP.Extension)



function vRPRebornItemDrop:__construct()
	vRP.Extension.__construct(self)

	local markers_ids = IDm
	local items = {}

	AddEventHandler('DropSystem:create',function(item,name,count,px,py,pz)
		local id = markers_ids:gen()
		if id then
			items[id] = { item = item, count = count, x = px, y = py, z = pz, name = name, tempo = 1200 }
			TriggerClientEvent('DropSystem:createForAll',-1,id,items[id])
		end
	end)
	
	RegisterServerEvent('DropSystem:drop')
	AddEventHandler('DropSystem:drop',function(item,count)
		local user_id = vRP.getUserId(source)
		if user_id then
			vRP.giveInventoryItem(user_id,item,count)
			TriggerClientEvent('DropSystem:createForAll',-1)
		end
	end)
	
	RegisterServerEvent('DropSystem:take')
	AddEventHandler('DropSystem:take',function(id)
		local user = vRP.users_by_source[source]
		if user then
			if items[id] ~= nil then
				local citem = vRP.EXT.Inventory:computeItem(items[id].item)

				local new_weight = user:getInventoryWeight()+citem.weight*items[id].count
				if new_weight <= user:getInventoryMaxWeight() then
					if items[id] == nil then
						return
					end
					user:tryGiveItem(items[id].item,items[id].count,false,false)
					vRP.EXT.Base.remote._playAnim(user.source,true,{{"pickup_object","pickup_low"}},false)
					items[id] = nil
					markers_ids:free(id)
					TriggerClientEvent('DropSystem:remove',-1,id)
				else
					TriggerClientEvent("Notify",source,"negado","Mochila cheia.")
				end
			end
		end
	end)
	

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			for k,v in pairs(items) do
				if items[k].tempo > 0 then
					items[k].tempo = items[k].tempo - 1
					if items[k].tempo <= 0 then
						items[k] = nil
						markers_ids:free(k)
						TriggerClientEvent('DropSystem:remove',-1,k)
					end
				end
			end
		end
	end)

end

vRP:registerExtension(vRPRebornItemDrop)