htmlEntities = module("vrp", "lib/htmlEntities")


local lcfg = module("vrp", "cfg/base")
Luang = module("vrp", "lib/Luang")
Lang = Luang()


Lang:loadLocale(lcfg.lang, module("vrp", "cfg/lang/"..lcfg.lang) or {})

--Lang:loadLocale(lcfg.lang, module("reborn-loot", "lang/"..lcfg.lang) or {})
lang = Lang.lang[lcfg.lang]


local Loot = class("reborn-loot", vRP.Extension)


local function menu_loot(self)
  	local function choices_loot(menu)
     local user = menu.user
	   local user = menu.user
	   if user ~= nil then
			nplayer = vRP.EXT.Base.remote.getNearestPlayer(user.source, 7)
			nuser = vRP.users_by_source[nplayer]  
		  	if (nuser ~= nil) then
				in_coma = vRP.EXT.Survival.remote.isInComa(nuser.source)
			  	if in_coma then
					local revive_seq = {
					  {"amb@medic@standing@kneel@enter","enter",1},
					  {"amb@medic@standing@kneel@idle_a","idle_a",1},
					  {"amb@medic@standing@kneel@exit","exit",1}
					}
					vRP.EXT.Base.remote._playAnim(user.source,false,revive_seq,false) -- anim
					SetTimeout(2000, function()
					  local ndata = nuser:getInventory()
					  local weapons = vRP.EXT.PlayerState.remote.getWeapons(nuser.source)
					  for k,v in pairs(weapons) do
					    -- convert weapons to parametric weapon items
					    if nuser:tryGiveItem("wbody|"..k, 1) then
						    if v.ammo > 0 then
						      nuser:tryGiveItem("wammo|"..k, v.ammo)
						    end
						    weapons[k] = nil
						 end
					  end
					  vRP.EXT.PlayerState.remote.giveWeapons(nuser.source, weapons, true)
						if ndata ~= nil then -- gives inventory items
						  --nuser:clearInventory()
						  for k,v in pairs(ndata) do 
							if user:tryGiveItem(k,ndata[k],true) then
								user:tryGiveItem(k,ndata[k],false,false)
								nuser:tryTakeItem(k,ndata[k],false,false)
							end
						  end
						end
					  local nmoney = nuser:getWallet()
					  if nuser:tryPayment(nmoney,false) then
						user:giveWallet(nmoney)
					  end
					end)
					vRP.EXT.Base.remote._stopAnim(user.source,false)
				else
					vRP.EXT.Base.remote._notify(user.source,lang.emergency.menu.revive.not_in_coma())
				end
		   else
			  vRP.EXT.Base.remote._notify(user.source,lang.common.no_player_near())
		   end
	   end
	end

	vRP.EXT.GUI:registerMenuBuilder("main", function(menu)
		--menu.title = 'Saquear'
		--menu.css.header_color = "rgba(240,203,88,0.75)"
		local user = menu.user
		if user ~= nil then
			if menu.user:hasPermission("player.loot") then
	    		menu:addOption("<i class=\"fas fa-search-dollar\" style=\"font-size: 12px;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Saquear Corpo", choices_loot, "Pegue os pertences de um um civil morto")
	    	end
		end
	end)
end

	
function Loot:__construct()
  vRP.Extension.__construct(self)
  
  menu_loot(self)

end

vRP:registerExtension(Loot)	









-- REBORN SCRIPTS - LOOT SYSTEM - WEAPONS MONEY ITENS - WITH PERMISSION
-- 20/07/2019 - FoxOak v1.0
-- TESTED 90%