
function vRPgcphone.tunnel:gcphone_tchat_channel(channel, cb)
  
    user = vRP.get_by_source[source]
    messages = vRP:query("vRP/tchatGetmessages", { 
        channel = channel
    })
    self.remote._gcPhone_tchat_channel(user.source, channel, messages)
end

function vRPgcphone.tunnel:gcPhone_tchat_addMessage(channel, message)

  vRP:query("tchatAddMessage", {
    channel = channel,
    message = message
  })
    self.remote._gcPhone_tchat_receive(-1, reponse[1])
end


--RegisterServerEvent('gcPhone:tchat_channel')
--AddEventHandler('gcPhone:tchat_channel', function(channel)
--  local sourcePlayer = tonumber(source)
--  TchatGetMessageChannel(channel, function (messages)
    
--  end)
--end)

--RegisterServerEvent('gcPhone:tchat_addMessage')
--AddEventHandler('gcPhone:tchat_addMessage', function(channel, message)
--  TchatAddMessage(channel, message)
--end)