local reborn_wedding = class("reborn_wedding", vRP.Extension)

local function define_items(self)

  function VerificaIgrejaProxima(menu)
  local user = menu.user
    if not self.remote.IgrejaProxima(user.source, user.source) then
     vRP.EXT.Base.remote._notify(user.source, "Você não está no altar")
    end

  end

  function VerificarProximoAdvogado(menu)
  local user = menu.user
    if user then
        nplayer = vRP.EXT.Base.remote.getNearestPlayer(user.source, 10)
        nuser = vRP.users_by_source[nplayer] 
              if nuser ~= nil then
                print('ID cadados')
                print(user.source)
                print(nuser.source)
                 rows = vRP:query("vRP/get_casados", {character_id = nuser.cid})
                  if rows[1].casadocom > 0 then
                   ok = nuser:request("Deseja realmente a separação?", 30)
                    if ok then
                       ncasado = vRP.users_by_cid(rows[1].casadocom)
                       if ncasado ~= nil then
                       print(ncasado)
                          ok = ncasado:request("Seu conjugê está pedindo a separação, aceita?", 30)
                            if ok then
                              if user:tryTakeItem("PapelDivocio",1,false,false) then
                                 self.remote._Separacao(user.source, nplayer.cid, ncasado.cid)
                              else
                                 vRP.EXT.Base.remote._notify(user.source, "Você perdeu os papais do divorcio")      
                              end                 
                            else
                               vRP.EXT.Base.remote._notify(user.source, "A seração foi recusada")
                               vRP.EXT.Base.remote._notify(nuser.source, "A seração foi recusada")                          
                               vRP.EXT.Base.remote._notify(ncasado.source, "A seração foi recusada")
                            end
                       end
                    else
                      vRP.EXT.Base.remote._notify(user.source, "A seração foi recusada")
                      vRP.EXT.Base.remote._notify(nuser.source, "A seração foi recusada")                          
                      vRP.EXT.Base.remote._notify(ncasado.source, "A seração foi recusada")
                    end
                  else
                    vRP.EXT.Base.remote._notify(user.source, "Seu parceiro(a) já está casado com outra pessoa")
                  end
              else
                vRPclient.notify(player, {"Ninguém por perto"})
              end
    end
  end


  local function i_wedding_menu(args,menu)
                  menu:addOption("Pedir em casamento", VerificaIgrejaProxima)
  end

  local function i_divorcio_menu(args,menu)
                  menu:addOption("Solicitar assinaturas", VerificarProximoAdvogado)
  end

  local cfg = {}
  cfg.wdd= {
    ["alianca"] = {
      name = "Aliança",
      desc = "Para seu casamento",
      choices = i_wedding_menu,
      weight = 0.5
    },
    ["PapelDivocio"] = {
      name = "Papeis para divorcio",
      desc = "Papelada pra iniciar a separação",
      choices = i_divorcio_menu,
      weight = 0.5
    },
  }

    for k,v in pairs(cfg.wdd) do
       vRP.EXT.Inventory:defineItem(k,v.name,v.desc,v.choices,v.weight)
    end
end

function reborn_wedding:__construct()
  vRP.Extension.__construct(self)

  define_items(self)

  async(function()
    vRP:prepare("vRP/CampoCasado",[[ALTER TABLE vrp_character_identities ADD IF NOT EXISTS casadocom integer(11) DEFAULT 0]])
    vRP:prepare("vRP/get_casados","SELECT casadocom FROM vrp_character_identities where character_id = @character_id")
    vRP:prepare("vRP/set_casados","UPDATE vrp_character_identities set casadocom = @casadocom where character_id = @character_id")
    vRP:execute("vRP/CampoCasado")
    end)

  function fogos(nplayer)
    print('fogos')
    user = vRP.users_by_source[nplayer]
    print(nplayer)
    print(user.source)
    self.remote._FogosCL(user.source,30)
    print('ok fogos')
    local players = vRP.EXT.Base.remote.getNearestPlayers(user.source,50)
    for player in pairs(players) do
        print('players ')
        local nuser = vRP.users_by_source[player]
        print(nuser.source)
          self.remote._FogosCL(nuser.source,30)
    end 
  end
end



local items = {}

reborn_wedding.tunnel = {}


function reborn_wedding.tunnel:VerificarProximo(player)
  user = vRP.users_by_source[source]
  rows = vRP:query("vRP/get_casados", {character_id = user.cid})
  if rows[1].casadocom <= 0 then  
    if user then
        nplayer = vRP.EXT.Base.remote.getNearestPlayer(user.source, 10)
          nuser = vRP.users_by_source[nplayer]        
              if nuser ~= nil then
                 rows = vRP:query("vRP/get_casados", {character_id = nuser.cid})
                  if rows[1].casadocom <= 0 then
                    if nuser:request("Casamento: ",20) then
                      --self.remote._Casamento(nuser.source) 
                      if user:tryTakeItem("alianca",1,false,false) then
                         vRP:execute("vRP/set_casados", {casadocom = nuser.cid, character_id = user.cid})                      
                         vRP:execute("vRP/set_casados", {casadocom = user.cid, character_id = nuser.cid}) 
                         vRP.EXT.Base.remote._notify(user.source, "Você casou!")
                         vRP.EXT.Base.remote._notify(nuser.source, "Você casou!")
                         fogos(user.source)
                      end
                    else
                      vRP.EXT.Base.remote._notify(user.source, "recusou seu pedido")
                    end
                  else
                    vRP.EXT.Base.remote._notify(user.source, "Seu parceiro(a) já está casado com outra pessoa")
                  end
              else
                vRP.EXT.Base.remote._notify(user.source, "Ninguém por perto")
              end
    end
  else
    vRP.EXT.Base.remote._notify(user.source, "Você já está casado com outra pessoa")
  end  
        
end


function reborn_wedding.tunnel:ProximoIgreja(player)
  user = vRP.users_by_source[source]
  --affected
  rows = vRP:query("vRP/get_casados", {character_id = user.cid})
  print(rows[1].casadocom)
      if rows[1].casadocom <= 0 then       
          self._VerificarProximo(player)
      else
        vRP.EXT.Base.remote._notify(user.source, "Você já está casado com outra pessoa")
      end  
end

function reborn_wedding.tunnel:Separacao(advogado,marido,esposa)
  user = vRP.users_by_source[source]
  rows = vRP:query("vRP/get_casados", {character_id = user.cid})
      if rows[1].casadocom <= 0 then
          self._VerificarProximo(player)
      end
end



vRP:registerExtension(reborn_wedding)