Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")


local cvRP = module("vrp", "client/vRP")
vRP = cvRP() 

local vRPgcphone = class("vRPgcphone", vRP.Extension)

function vRPgcphone:__construct()
  vRP.Extension.__construct(self)


  -----------------------------
  -----------TWITTER----------

RegisterNetEvent("gcPhone:twitter_getTweets")
AddEventHandler("gcPhone:twitter_getTweets", function(tweets)
  SendNUIMessage({event = 'twitter_tweets', tweets = tweets})
end)

RegisterNetEvent("gcPhone:twitter_getFavoriteTweets")
AddEventHandler("gcPhone:twitter_getFavoriteTweets", function(tweets)
  SendNUIMessage({event = 'twitter_favoritetweets', tweets = tweets})
end)

RegisterNetEvent("gcPhone:twitter_newTweets")
AddEventHandler("gcPhone:twitter_newTweets", function(tweet)
  SendNUIMessage({event = 'twitter_newTweet', tweet = tweet})
end)

RegisterNetEvent("gcPhone:twitter_updateTweetLikes")
AddEventHandler("gcPhone:twitter_updateTweetLikes", function(tweetId, likes)
  SendNUIMessage({event = 'twitter_updateTweetLikes', tweetId = tweetId, likes = likes})
end)

RegisterNetEvent("gcPhone:twitter_setAccount")
AddEventHandler("gcPhone:twitter_setAccount", function(username, password, avatarUrl)
  SendNUIMessage({event = 'twitter_setAccount', username = username, password = password, avatarUrl = avatarUrl})
end)

RegisterNetEvent("gcPhone:twitter_createAccount")
AddEventHandler("gcPhone:twitter_createAccount", function(account)
  SendNUIMessage({event = 'twitter_createAccount', account = account})
end)

RegisterNetEvent("gcPhone:twitter_showError")
AddEventHandler("gcPhone:twitter_showError", function(title, message)
  SendNUIMessage({event = 'twitter_showError', message = message, title = title})
end)

RegisterNetEvent("gcPhone:twitter_showSuccess")
AddEventHandler("gcPhone:twitter_showSuccess", function(title, message)
  SendNUIMessage({event = 'twitter_showSuccess', message = message, title = title})
end)

RegisterNetEvent("gcPhone:twitter_setTweetLikes")
AddEventHandler("gcPhone:twitter_setTweetLikes", function(tweetId, isLikes)
  SendNUIMessage({event = 'twitter_setTweetLikes', tweetId = tweetId, isLikes = isLikes})
end)



RegisterNUICallback('twitter_login', function(data, cb)
  TriggerServerEvent('gcPhone:twitter_login', data.username, data.password)
end)
RegisterNUICallback('twitter_changePassword', function(data, cb)
  TriggerServerEvent('gcPhone:twitter_changePassword', data.username, data.password, data.newPassword)
end)


RegisterNUICallback('twitter_createAccount', function(data, cb)
  TriggerServerEvent('gcPhone:twitter_createAccount', data.username, data.password, data.avatarUrl)
end)

RegisterNUICallback('twitter_getTweets', function(data, cb)
  TriggerServerEvent('gcPhone:twitter_getTweets', data.username, data.password)
end)

RegisterNUICallback('twitter_getFavoriteTweets', function(data, cb)
  TriggerServerEvent('gcPhone:twitter_getFavoriteTweets', data.username, data.password)
end)

RegisterNUICallback('twitter_postTweet', function(data, cb)
  TriggerServerEvent('gcPhone:twitter_postTweets', data.username or '', data.password or '', data.message)
end)

RegisterNUICallback('twitter_toggleLikeTweet', function(data, cb)
  TriggerServerEvent('gcPhone:twitter_toogleLikeTweet', data.username or '', data.password or '', data.tweetId)
end)

RegisterNUICallback('twitter_setAvatarUrl', function(data, cb)
  TriggerServerEvent('gcPhone:twitter_setAvatarUrl', data.username or '', data.password or '', data.avatarUrl)
end)


  --------------------------------
  --------------------------------

  RegisterNetEvent('vrp_addons_gcphone:call')
  AddEventHandler('vrp_addons_gcphone:call', function(data)
    local playerPed   = PlayerPedId()
    local coords      = GetEntityCoords(playerPed)
    local message     = data.message
    local number      = data.number
    if message == nil then
      DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
      while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
      end
      if (GetOnscreenKeyboardResult()) then
        message =  GetOnscreenKeyboardResult()
      end
    end
    if message ~= nil and message ~= "" then
      self.remote._vrp_addons_gcphone_startCall(number, message, {
        x = coords.x,
        y = coords.y,
        z = coords.z
      })

    end
  end)


  ----------------------------------
  ---------- GESTION VIA WEBRTC ----
  ----------------------------------
  AddEventHandler('onClientResourceStart', function(res)
    DoScreenFadeIn(300)
    Citizen.Wait(15000)
    if res == "gcphone" then
        self.remote._gcPhone_allUpdate()
    end
  end)

  --====================================================================================
  -- #Author: Jonathan D @ Gannon
  --====================================================================================
   
  -- Configuration
   KeyToucheCloseEvent = {
    { code = 172, event = 'ArrowUp' },
    { code = 173, event = 'ArrowDown' },
    { code = 174, event = 'ArrowLeft' },
    { code = 175, event = 'ArrowRight' },
    { code = 176, event = 'Enter' },
    { code = 177, event = 'Backspace' },
  }
  KeyOpenClose = 289 -- F2
   KeyTakeCall = 38 -- E
   menuIsOpen = false
   contacts = {}
   messages = {}
   myPhoneNumber = ''
   isDead = false
   USE_RTC = false
   useMouse = false
   ignoreFocus = false
   takePhoto = false
   hasFocus = false

   PhoneInCall = {}
   currentPlaySound = false
   soundDistanceMax = 8.0

  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if takePhoto ~= true then
        if IsControlJustPressed(1, KeyOpenClose) then
           TooglePhone()
        end
      if menuIsOpen == true then
        for _, value in ipairs(KeyToucheCloseEvent) do
          if IsControlJustPressed(1, value.code) then
            SendNUIMessage({keyUp = value.event})
          end
        end
        if useMouse == true and hasFocus == ignoreFocus then
          local nuiFocus = not hasFocus
          SetNuiFocus(nuiFocus, nuiFocus)
          hasFocus = nuiFocus       
        elseif useMouse == false and hasFocus == true then
          SetNuiFocus(false, false)
          hasFocus = false
        end
      else
        if hasFocus  == true then
          SetNuiFocus(false, false)
          hasFocus = false 
       end   
      end
    end
    end
  end)

  Citizen.CreateThread(function ()
    local mod = 0
    while true do 
      local playerPed   = PlayerPedId()
      local coords      = GetEntityCoords(playerPed)
      local inRangeToActivePhone = false
      local inRangedist = 0
      for i, _ in pairs(PhoneInCall) do 
          local dist = GetDistanceBetweenCoords(
            PhoneInCall[i].coords.x, PhoneInCall[i].coords.y, PhoneInCall[i].coords.z,
            coords.x, coords.y, coords.z, 1)
          if (dist <= soundDistanceMax) then
            DrawMarker(1, PhoneInCall[i].coords.x, PhoneInCall[i].coords.y, PhoneInCall[i].coords.z,
                0,0,0, 0,0,0, 0.1,0.1,0.1, 0,255,0,255, 0,0,0,0,0,0,0)
            inRangeToActivePhone = true
            inRangedist = dist
            if (dist <= 2.5) then 
              SetTextComponentFormat("STRING")
              AddTextComponentString("~INPUT_PICKUP~ Atender")
              DisplayHelpTextFromStringLabel(0, 0, 1, -1)
              if IsControlJustPressed(1, KeyTakeCall) then
                PhonePlayCall(true)
                TakeAppel(PhoneInCall[i])
                PhoneInCall = {}
                StopSoundJS('ring2.ogg')
              end
            end
            break
          end
      end
      if inRangeToActivePhone == false then
        showFixePhoneHelper(coords)
      end
      if inRangeToActivePhone == true and currentPlaySound == false then
        PlaySoundJS('ring2.ogg', 0.2 + (inRangedist - soundDistanceMax) / -soundDistanceMax * 0.8 )
        currentPlaySound = true
      elseif inRangeToActivePhone == true then
        mod = mod + 1
        if (mod == 15) then
          mod = 0
          SetSoundVolumeJS('ring2.ogg', 0.2 + (inRangedist - soundDistanceMax) / -soundDistanceMax * 0.8 )
        end        
      elseif inRangeToActivePhone == false and currentPlaySound == true then
        currentPlaySound = false
        StopSoundJS('ring2.ogg')
      end
      Citizen.Wait(0)
    end
  end)

  RegisterNUICallback('onCandidates', function (data, cb)
    self.remote._gcPhone_candidates(data.id, data.candidates)
    cb()
  end)
    --====================================================================================
  --  Event - Contacts
  --====================================================================================
  RegisterNUICallback('addContact', function(data, cb) 
    print('NUI Contact')
    self.remote._gcPhone_addContact(data.display, data.phoneNumber)
  end)
  RegisterNUICallback('updateContact', function(data, cb)
    self.remote._gcPhone_updateContact(data.id, data.display, data.phoneNumber)
  end)
  RegisterNUICallback('deleteContact', function(data, cb)
    self.remote._gcPhone_deleteContact(data.id)
  end)
  RegisterNUICallback('getContacts', function(data, cb)
    cb(json.encode(contacts))
  end)
  RegisterNUICallback('getWeather', function(data, cb)
    cb(tempoa)
  end)
  RegisterNUICallback('setGPS', function(data, cb)
    SetNewWaypoint(tonumber(data.x), tonumber(data.y))
    cb()
  end)
  RegisterNUICallback('callEvent', function(data, cb)
    if data.data ~= nil then 
      TriggerEvent(data.eventName, data.data)
    else
      TriggerEvent(data.eventName)
    end
    cb()
  end)
  
  RegisterNUICallback('useMouse', function(um, cb)
    useMouse = um
  end)

  RegisterNUICallback('setIgnoreFocus', function (data, cb)
  ignoreFocus = data.ignoreFocus
  cb()
  end)

  RegisterNUICallback('takePhoto', function(data, cb)
    CreateMobilePhone(1)
    CellCamActivate(true, true)
    takePhoto = true
    Citizen.Wait(0)
    if hasFocus == true then
      SetNuiFocus(false, false)
      hasFocus = false
    end
    while takePhoto do
      Citizen.Wait(0)

      if IsControlJustPressed(1, 27) then -- Toogle Mode
        frontCam = not frontCam
        CellFrontCamActivate(frontCam)
      elseif IsControlJustPressed(1, 177) then -- CANCEL
        DestroyMobilePhone()
        CellCamActivate(false, false)
        cb(json.encode({ url = nil }))
        takePhoto = false
        break
      elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
        print('Apertou Enter Foto')
        exports['screenshot-basic']:requestScreenshotUpload(data.url, data.field, function(data)
          local resp = json.decode(data)
          DestroyMobilePhone()
          CellCamActivate(false, false)
          print(json.encode(resp))
          cb(json.encode({ url = resp.files[1].url }))
          
        end)
        takePhoto = false
      end
      HideHudComponentThisFrame(7)
      HideHudComponentThisFrame(8)
      HideHudComponentThisFrame(9)
      HideHudComponentThisFrame(6)
      HideHudComponentThisFrame(19)
      HideHudAndRadarThisFrame()
    end
    Citizen.Wait(1000)
    PhonePlayAnim('text', false, true)
  end)

  RegisterNUICallback('deleteALL', function(data, cb)
    self.remote._gcPhone_deleteALL()
    cb()
  end)

  --====================================================================================
  --  Function client | Contacts
  --====================================================================================
  function addContact(display, num)
      print('function addcontact')
      self.remote._gcPhone_addContact(display, num)
  end

  function deleteContact(num) 
      self.remote._gcPhone_deleteContact(num)
  end

  --====================================================================================
  --  Function client | Messages
  --====================================================================================
  function sendMessage(num, message)
    print('sendMessage')
    self.remote._gcPhone_sendMessage(num, message)
  end

  function deleteMessage(msgId)
    self.remote._gcPhone_deleteMessage(msgId)
    for k, v in ipairs(messages) do 
      if v.id == msgId then
        table.remove(messages, k)
        SendNUIMessage({event = 'updateMessages', messages = messages})
        return
      end
    end
  end

  function deleteMessageContact(num)
    self.remote._gcPhone_deleteMessageNumber(num)
  end

  function deleteAllMessage()
    self.remote._gcPhone_deleteAllMessage()
  end

  function setReadMessageNumber(num)
    self.remote._gcPhone_setReadMessageNumber(num)
    for k, v in ipairs(messages) do 
      if v.transmitter == num then
        v.isRead = 1
      end
    end
  end

  function requestAllMessages()
    self.remote._gcPhone_requestAllMessages()
  end

  function requestAllContact()
    self.remote._gcPhone_requestAllContact()
  end

  function rejectCall(infoCall)
    print('rejectCall')
    self.remote._gcPhone_rejectCall(infoCall)
  end

  function ignoreCall(infoCall)
   self.remote._gcPhone_ignoreCall(infoCall)
  end

  function requestHistoriqueCall() 
    self.remote._gcPhone_getHistoriqueCall_server()
  end

  function appelsDeleteHistorique (num)
    self.remote._gcPhone_appelsDeleteHistorique(num)
  end

  function vRPgcphone:appelsDeleteAllHistorique ()
    self.remote._appelsDeleteAllHistorique()
  end

  function startCall (phone_number, rtcOffer, extraData)
    self.remote._gcPhone_startCall(phone_number, rtcOffer, extraData)
  end

  function acceptCall (infoCall, rtcAnswer)
    self.remote._gcPhone_acceptCall(infoCall, rtcAnswer)
  end

  RegisterNUICallback('sendMessage', function(data, cb)
    print('NUI sendmessage')
    if data.message == '%pos%' then
      local myPos = GetEntityCoords(PlayerPedId())
      data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
    end
    self.remote._gcPhone_sendMessage(data.phoneNumber, data.message)
  end)    

  ------------------------------------------------------------------------
  ------------------------------------------------------------------------
  ------------------------TCHAT CLIENT------------------------------------
  ------------------------------------------------------------------------

  RegisterNUICallback('tchat_addMessage', function(data, cb)
    print('tchat_addMessage')
    self.remote._gcPhone_tchat_addMessage(data.channel, data.message)
  end)

  RegisterNUICallback('tchat_getChannel', function(data, cb)
      print('tchat_getChannel')
    self.remote._gcphone_tchat_messages(data.channel)
  end)
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------

end




--====================================================================================
--  Active ou Deactive une application (appName => config.json)
--====================================================================================
RegisterNetEvent('gcPhone:setEnableApp')
AddEventHandler('gcPhone:setEnableApp', function(appName, enable)
  SendNUIMessage({event = 'setEnableApp', appName = appName, enable = enable })
end)

--====================================================================================
--  Gestion des appels fixe
--====================================================================================
function startFixeCall (fixeNumber)
  local number = ''
  DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 10)
  while (UpdateOnscreenKeyboard() == 0) do
    DisableAllControlActions(0);
    Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
    number =  GetOnscreenKeyboardResult()
  end
  if number ~= '' then
    TriggerEvent('gcphone:autoCall', number, {
      useNumber = fixeNumber
    })
    PhonePlayCall(true)
  end
end


tempoa = ''

RegisterNetEvent('gcphone:CurrentWeather')
AddEventHandler('gcphone:CurrentWeather', function(tempo)
    tempoa = tempo
end)


function TakeAppel (infoCall)
  TriggerEvent('gcphone:autoAcceptCall', infoCall)
end

function vRPgcphone:gcPhone_notifyFixePhoneChange(_PhoneInCall)
  PhoneInCall = _PhoneInCall
end

--[[
  Affiche les imformations quant le joueurs est proche d'un fixe
--]]
function showFixePhoneHelper (coords)
  for number, data in pairs(FixePhone) do
    local dist = GetDistanceBetweenCoords(
      data.coords.x, data.coords.y, data.coords.z,
      coords.x, coords.y, coords.z, 1)
    if dist <= 3.0 then
      SetTextComponentFormat("STRING")
      AddTextComponentString("~g~" .. data.name .. ' ~o~' .. number .. '~n~~INPUT_PICKUP~~w~ Usar')
      DisplayHelpTextFromStringLabel(0, 0, 0, -1)
      if IsControlJustPressed(1, KeyTakeCall) then
        startFixeCall(number)
      end
      break
    end
  end
end
 



--====================================================================================
--  
--====================================================================================


RegisterNetEvent("gcPhone:forceOpenPhone")
AddEventHandler("gcPhone:forceOpenPhone", function(_myPhoneNumber)
  if menuIsOpen == false then
    TooglePhone()
  end
end)
 
--====================================================================================
--  Events
--====================================================================================
function vRPgcphone:gcPhone_myPhoneNumber(_myPhoneNumber)
  myPhoneNumber = _myPhoneNumber
  SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})
end

function vRPgcphone:gcPhone_contactList(_contacts)
  SendNUIMessage({event = 'updateContacts', contacts = _contacts})
  contacts = _contacts
end

function vRPgcphone:gcPhone_allMessage(allmessages)
  SendNUIMessage({event = 'updateMessages', messages = allmessages})
  messages = allmessages
end

function vRPgcphone:gcPhone_getBourse(bourse)
  SendNUIMessage({event = 'updateBourse', bourse = bourse})
end

function vRPgcphone:gcPhone_receiveMessage(message)
  -- SendNUIMessage({event = 'updateMessages', messages = messages})
  print('ReceiveMessage')
  SendNUIMessage({event = 'newMessage', message = message})
  table.insert(messages, message)
  if message.owner == 0 then
    local text = '~o~Nova Mensagem'
    if ShowNumberNotification == true then
      text = '~o~Nova Mensagem do ~y~'.. message.transmitter
      for _,contact in pairs(contacts) do
        if contact.number == message.transmitter then
          text = '~o~Nova Mensagem de ~g~'.. contact.display
          break
        end
      end
    end
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
  end
end



--====================================================================================
--  Function client | Appels
--====================================================================================
local inCall = false
local aminCall = false

function vRPgcphone:gcPhone_waitingCall(infoCall, initiator)
  SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
  if initiator == true then
    PhonePlayCall()
    if menuIsOpen == false then
      TooglePhone()
    end
  end
end

function vRPgcphone:gcPhone_acceptCall(infoCall, initiator)
  if inCall == false and USE_RTC == false then
    inCall = true
    print('callid')
    print(infoCall.id)    
    NetworkSetVoiceChannel(infoCall.id + 1)
    NetworkSetTalkerProximity(0.0)
  end
  if menuIsOpen == false then 
    TooglePhone()
  end
  PhonePlayCall()
  SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
end

function vRPgcphone:gcPhone_rejectCall(infoCall)
  print('gcPhone_rejectCall')
  if inCall == true then
    inCall = false
    Citizen.InvokeNative(0xE036A705F989E049)
    NetworkSetTalkerProximity(10.0)
  end
  PhonePlayText()
  SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
end


function vRPgcphone:gcPhone_historiqueCall(historique)
  SendNUIMessage({event = 'historiqueCall', historique = historique})
end




--====================================================================================
--  Event NUI - Appels
--====================================================================================


RegisterNUICallback('startCall', function (data, cb)
  print(json.encode(data))
  startCall(data.numero, data.rtcOffer, data.extraData)
  cb()
end)



RegisterNUICallback('acceptCall', function (data, cb)
  acceptCall(data.infoCall, data.rtcAnswer)
  cb()
end)
RegisterNUICallback('rejectCall', function (data, cb)
  print('NUI rejectCall')
  rejectCall(data.infoCall)
  cb()
end)

RegisterNUICallback('ignoreCall', function (data, cb)
  ignoreCall(data.infoCall)
  cb()
end)

RegisterNUICallback('notififyUseRTC', function (use, cb)
  USE_RTC = use
  if USE_RTC == true and inCall == true then
    print('USE RTC ON')
    inCall = false
    Citizen.InvokeNative(0xE036A705F989E049)
    NetworkSetTalkerProximity(10.5)
  end
  cb()
end)




function vRPgcphone:gcPhone_candidates(candidates)
  SendNUIMessage({event = 'candidatesAvailable', candidates = candidates})
end



RegisterNetEvent('gcphone:autoCall')
AddEventHandler('gcphone:autoCall', function(number, extraData)
  if number ~= nil then
    SendNUIMessage({ event = "autoStartCall", number = number, extraData = extraData})
  end
end)

RegisterNetEvent('gcphone:autoCallNumber')
AddEventHandler('gcphone:autoCallNumber', function(data)
  TriggerEvent('gcphone:autoCall', data.number)
end)

RegisterNetEvent('gcphone:autoAcceptCall')
AddEventHandler('gcphone:autoAcceptCall', function(infoCall)
  SendNUIMessage({ event = "autoAcceptCall", infoCall = infoCall})
end)

--===================
--Play sound JS
--===================
function PlaySoundJS (sound, volume)
  print('Play Sound!')
  SendNUIMessage({ event = 'playSound', sound = sound, volume = volume })
end

function SetSoundVolumeJS (sound, volume)
  print('SET VOLUME!')
  SendNUIMessage({ event = 'setSoundVolume', sound = sound, volume = volume})
end

function StopSoundJS (sound)
  print('STAPH')
  SendNUIMessage({ event = 'stopSound', sound = sound})
end

--===================
--End play sound JS
--===================




--====================================================================================
--  Gestion des evenements NUI
--==================================================================================== 
RegisterNUICallback('log', function(data, cb)
  print(data)
  cb()
end)
RegisterNUICallback('focus', function(data, cb)
  cb()
end)
RegisterNUICallback('blur', function(data, cb)
  cb()
end)
RegisterNUICallback('reponseText', function(data, cb)
  local limit = data.limit or 255
  local text = data.text or ''
  
  DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", text, "", "", "", limit)
  while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
      text = GetOnscreenKeyboardResult()
  end
  cb(json.encode({text = text}))
end)
--====================================================================================  
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
  cb(json.encode(messages))
end)

RegisterNUICallback('deleteMessage', function(data, cb)
  deleteMessage(data.id)
  cb()
end)
RegisterNUICallback('deleteMessageNumber', function (data, cb)
  deleteMessageContact(data.number)
  cb()
end)
RegisterNUICallback('deleteAllMessage', function (data, cb)
  deleteAllMessage()
  cb()
end)
RegisterNUICallback('setReadMessageNumber', function (data, cb)
  setReadMessageNumber(data.number)
  cb()
end)




function TooglePhone() 
  menuIsOpen = not menuIsOpen
  SendNUIMessage({show = menuIsOpen})
  if menuIsOpen == true then 
    PhonePlayIn()
  else
    PhonePlayOut()
  end
end

RegisterNUICallback('faketakePhoto', function(data, cb)
  menuIsOpen = false
  SendNUIMessage({show = false})
  cb()
  TriggerEvent('camera:open')
end)

RegisterNUICallback('closePhone', function(data, cb)
  menuIsOpen = false
  SendNUIMessage({show = false})
  PhonePlayOut()
  cb()
end)




----------------------------------
---------- GESTION APPEL ---------
----------------------------------
RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
  appelsDeleteHistorique(data.numero)
  cb()
end)

RegisterNUICallback('requestHistoriqueCall', function (data, cb)
  requestHistoriqueCall()
  cb()
end)

RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
  appelsDeleteAllHistorique(data.infoCall)
  cb()
end)

----------------------------------
---------- TCHAT  ---------
----------------------------------
function vRPgcphone:gcPhone_tchat_receive(message)
  SendNUIMessage({event = 'tchat_receive', message = message})
end

function vRPgcphone:gcPhone_tchat_channel(channel, messages)
  SendNUIMessage({event = 'tchat_channel', messages = messages})
end

vRPgcphone.tunnel = {}
vRPgcphone.tunnel.gcPhone_candidates = vRPgcphone.gcPhone_candidates
vRPgcphone.tunnel.gcPhone_notifyFixePhoneChange = vRPgcphone.gcPhone_notifyFixePhoneChange
vRPgcphone.tunnel.gcPhone_myPhoneNumber = vRPgcphone.gcPhone_myPhoneNumber
vRPgcphone.tunnel.gcPhone_contactList = vRPgcphone.gcPhone_contactList
vRPgcphone.tunnel.gcPhone_allMessage = vRPgcphone.gcPhone_allMessage
vRPgcphone.tunnel.gcPhone_getBourse = vRPgcphone.gcPhone_getBourse
vRPgcphone.tunnel.gcPhone_receiveMessage = vRPgcphone.gcPhone_receiveMessage
vRPgcphone.tunnel.gcPhone_waitingCall = vRPgcphone.gcPhone_waitingCall
vRPgcphone.tunnel.gcPhone_acceptCall = vRPgcphone.gcPhone_acceptCall
vRPgcphone.tunnel.gcPhone_rejectCall = vRPgcphone.gcPhone_rejectCall
vRPgcphone.tunnel.gcPhone_historiqueCall = vRPgcphone.gcPhone_historiqueCall
vRPgcphone.tunnel.appelsDeleteAllHistorique = vRPgcphone.appelsDeleteAllHistorique
vRPgcphone.tunnel.gcPhone_tchat_receive = vRPgcphone.gcPhone_tchat_receive
vRPgcphone.tunnel.gcPhone_tchat_channel = vRPgcphone.gcPhone_tchat_channel

vRP:registerExtension(vRPgcphone)
