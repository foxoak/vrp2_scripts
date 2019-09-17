local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp","lib/Tools")

local vRP = Proxy.getInterface("vRP")

async(function()
  vRP.loadScript("reborn_itemdrop", "server")
end)