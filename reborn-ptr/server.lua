local rebornptr = class("rebornptr", vRP.Extension)


function rebornptr:__construct()
  vRP.Extension.__construct(self)


end

vRP:registerExtension(rebornptr)