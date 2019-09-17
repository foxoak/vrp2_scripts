local reborn_truckerjob = class("reborn_truckerjob", vRP.Extension)

function reborn_truckerjob:__construct()
  vRP.Extension.__construct(self)

end

reborn_truckerjob.tunnel = {}


  function reborn_truckerjob.tunnel:truckerJob_success(amount) -- handles the event
    print('truckerJob:success')
    print(amount)
    user = vRP.users_by_source[source]
    print(user.source)
      sdata = vRP:getGData("GasStation:pump")
      print(sdata)
      litros = tonumber(msgpack.unpack(sdata))
      print(litros)
      if litros <= 0.0 then
         litros = 0.5
      end
      print(litros)
      print('pau no cu de quem ta lendo')
      valor = round(amount+((1/litros)*100000),0)
      print(valor)
      user:giveWallet(valor)
      vRP.EXT.Base.remote._notify(user.source,"Você recebeu ~g~R$"..tostring(valor)..".")
      vRP:setGData("GasStation:pump", msgpack.pack(round(litros,0)+round(amount/3,0)))
      vRP.EXT.Base.remote._notify(user.source,"A cidade tem no momento ~g~"..tostring(round(litros,0)).."~b~ Litros de combustivel")
  end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


vRP:registerExtension(reborn_truckerjob)