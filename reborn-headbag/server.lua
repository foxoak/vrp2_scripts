local reborn_headbag = class("reborn_headbag", vRP.Extension)


local function define_items(self)

  local function VerificarProximo(menu)
    local user = menu.user
    print('servidor')
    print(user)
      if user then
          nplayer = vRP.EXT.Base.remote.getNearestPlayer(user.source, 7)
          print(nplayer)
              nuser = vRP.users_by_source[nplayer]         
              if nuser then
                print(nuser.source)
                print('oi')
                 checkHeadBag = vRP.EXT.reborn_headbag.remote.checkHeadBag(nuser.source) 
                 print(checkHeadBag)   
                 if not checkHeadBag then
                    print('ok')
                    print('colocar saco')
                    self.remote._PutHeadBag(nuser.source) 
                    user:tryTakeItem("saco_pao",1,false,false)
                 else
                    vRP.EXT.Base.remote._notify(user.source, "Já está encapuzado")
                 end
              else
                  vRP.EXT.Base.remote._notify(user.source,"Ninguém por perto")
              end
      end
  end

  local function RetirarProximo(menu)
  local user = menu.user
    if user then
        nplayer = vRP.EXT.Base.remote.getNearestPlayer(user.source, 7)
            nuser = vRP.users_by_source[nplayer]  
            if nuser then
               checkHeadBag = self.remote.checkHeadBag(nuser.source)  
                if checkHeadBag then
                    self.remote._deletebaghead(nuser.source)
                else
                  vRP.EXT.Base.remote._notify(user.source,"Não tem ninguém próximo encapuzado")
                end
            else
                vRP.EXT.Base.remote._notify(user.source,"Ninguém por perto")
            end
    end
end

  local function i_headbag_menu(args,menu)
                  menu:addOption("Usar", VerificarProximo)
                  menu:addOption("Retirar", RetirarProximo)
  end

    cfg.hbag= {
      ["saco_pao"] = {
        name = "Saco de pão",
        desc = "Saco de pão - ideal para carregar seus cacetinhos",
        choices = i_headbag_menu,
        weight = 1.0
      },
    }

    for k,v in pairs(cfg.hbag) do
       vRP.EXT.Inventory:defineItem(k,v.name,v.desc,v.choices,v.weight)
    end

end

function reborn_headbag:__construct()
  vRP.Extension.__construct(self)

  define_items(self)

end



local items = {}

reborn_headbag.tunnel = {}









--Player
--[[vRP.registerMenuBuilder({"main", function(add, data)
	local user_id = vRP.getUserId({data.player})
	local choices = {}	
	if user_id ~= nil then
		--choices["Colocar capuz"] = {VerificarProximo, "Coloca um saco na cabeça da vítima"}
		choices["Retirar capuz"] = {RetirarProximo, 	 "Retira o capuz da cabeça da vítima"}
		add(choices)
	end
end})]]

vRP:registerExtension(reborn_headbag)



