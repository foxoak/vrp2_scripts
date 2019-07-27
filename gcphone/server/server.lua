local vRPgcphone = class("vRPgcphone", vRP.Extension)

FixePhone = {
  -- Poste de police
  ['190'] = { name =  "Central da Policia", coords = { x = 438.78359985352, y = -979.37890625, z = 31.8932762146 } },
  
  -- Cabine proche du poste de police
  ['0800'] = { name = "Orelhão", coords = { x = 56.091968536377, y = -1079.8098144531, z = 29.45471572876 } },
}

ShowNumberNotification = true -- Show Number or Contact Name when you receive new SMS

 AppelsEnCours = {}
 PhoneFixeInfo = {}
 lastIndexCall = 10

--====================================================================================
-- #Author: Jonathan D @Gannon
-- #Version 2.0
--====================================================================================

function vRPgcphone:__construct()
   vRP.Extension.__construct(self)

	function getSourceFromIdentifier(identifier, cb)
		local user = vRP.users_by_cid[identifier]
		return user.source
	end

	function getPlayerID(source)
	   user = vRP.users_by_source[source]

	   if user ~= nil then
	   	return user.cid
	   end
	end

  	async( function()
  		vRP:prepare('vRP/Creategcphone',[[
										  			CREATE TABLE IF NOT EXISTS `phone_app_chat` (
												  `id` int(11) NOT NULL AUTO_INCREMENT,
												  `channel` varchar(20) NOT NULL,
												  `message` varchar(255) NOT NULL,
												  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
												  PRIMARY KEY (`id`)
												) ENGINE=InnoDB DEFAULT CHARSET=utf8;

												CREATE TABLE IF NOT EXISTS `phone_calls` (
												  `id` int(11) NOT NULL AUTO_INCREMENT,
												  `owner` varchar(10) NOT NULL COMMENT 'Num tel proprio',
												  `num` varchar(10) NOT NULL COMMENT 'Num reférence du contact',
												  `incoming` int(11) NOT NULL COMMENT 'Défini si on est à l''origine de l''appels',
												  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
												  `accepts` int(11) NOT NULL COMMENT 'Appels accepter ou pas',
												  PRIMARY KEY (`id`)
												) ENGINE=InnoDB DEFAULT CHARSET=utf8;

												CREATE TABLE IF NOT EXISTS `phone_messages` (
												  `id` int(11) NOT NULL AUTO_INCREMENT,
												  `transmitter` varchar(10) NOT NULL,
												  `receiver` varchar(10) NOT NULL,
												  `message` varchar(255) NOT NULL DEFAULT '0',
												  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
												  `isRead` int(11) NOT NULL DEFAULT '0',
												  `owner` int(11) NOT NULL DEFAULT '0',
												  PRIMARY KEY (`id`)
												) ENGINE=InnoDB DEFAULT CHARSET=utf8;

												CREATE TABLE IF NOT EXISTS `phone_users_contacts` (
												  `id` int(11) NOT NULL AUTO_INCREMENT,
												  `identifier` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
												  `number` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
												  `display` varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1',
												  PRIMARY KEY (`id`)
												) ENGINE=InnoDB DEFAULT CHARSET=utf8;

													CREATE TABLE IF NOT EXISTS `twitter_accounts` (
												  `id` int(11) NOT NULL AUTO_INCREMENT,
												  `username` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
												  `password` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
												  `avatar_url` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
												  PRIMARY KEY (`id`),
												  UNIQUE KEY `username` (`username`)
												) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

												CREATE TABLE IF NOT EXISTS `twitter_tweets` (
												  `id` int(11) NOT NULL AUTO_INCREMENT,
												  `authorId` int(11) NOT NULL,
												  `realUser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
												  `message` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
												  `time` timestamp NOT NULL DEFAULT current_timestamp(),
												  `likes` int(11) NOT NULL DEFAULT 0,
												  PRIMARY KEY (`id`),
												  KEY `FK_twitter_tweets_twitter_accounts` (`authorId`),
												  CONSTRAINT `FK_twitter_tweets_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`)
												) ENGINE=InnoDB AUTO_INCREMENT=170 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

												CREATE TABLE IF NOT EXISTS `twitter_likes` (
												  `id` int(11) NOT NULL AUTO_INCREMENT,
												  `authorId` int(11) DEFAULT NULL,
												  `tweetId` int(11) DEFAULT NULL,
												  PRIMARY KEY (`id`),
												  KEY `FK_twitter_likes_twitter_accounts` (`authorId`),
												  KEY `FK_twitter_likes_twitter_tweets` (`tweetId`),
												  CONSTRAINT `FK_twitter_likes_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`),
												  CONSTRAINT `FK_twitter_likes_twitter_tweets` FOREIGN KEY (`tweetId`) REFERENCES `twitter_tweets` (`id`) ON DELETE CASCADE
												) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

												]])
  		vRP:prepare("vRP/getNumberPhone","SELECT vrp_character_identities.phone FROM vrp_character_identities WHERE vrp_character_identities.character_id = @identifier")
  		vRP:prepare("vRP/getIdentifierByPhoneNumber", "SELECT vrp_character_identities.character_id FROM vrp_character_identities WHERE vrp_character_identities.phone = @phone_number")
  		vRP:prepare("vRP/getOrGeneratePhoneNumber","UPDATE vrp_character_identities SET phone = @myPhoneNumber WHERE character_id = @identifier")
  		vRP:prepare("vRP/getContacts","SELECT * FROM phone_users_contacts WHERE phone_users_contacts.identifier = @identifier")
  		vRP:prepare("vRP/addContact","INSERT INTO phone_users_contacts (`identifier`, `number`,`display`) VALUES(@identifier, @number, @display)")
		vRP:prepare("vRP/updateContact","UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id")
		vRP:prepare("vRP/deleteContact","DELETE FROM phone_users_contacts WHERE `identifier` = @identifier AND `id` = @id")
		vRP:prepare("vRP/deleteAllContact","DELETE FROM phone_users_contacts WHERE `identifier` = @identifier")
		vRP:prepare("vRP/getMessages","SELECT phone_messages.* FROM phone_messages LEFT JOIN vrp_character_identities ON vrp_character_identities.character_id = @identifier WHERE phone_messages.receiver = vrp_character_identities.phone")
		vRP:prepare("vRP/internalAddMessage",[[ INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);
															 SELECT * from phone_messages WHERE `id` = (SELECT LAST_INSERT_ID());]])
		vRP:prepare("vRP/internalAddMessage2","SELECT * from phone_messages WHERE `id` = @id")
		vRP:prepare("vRP/setReadMessageNumber","UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter")
		vRP:prepare("vRP/deleteMessage","DELETE FROM phone_messages WHERE `id` = @id")
		vRP:prepare("vRP/deleteAllMessageFromPhoneNumber","DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number")
		vRP:prepare("vRP/deleteAllMessage","DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber")
		vRP:prepare("vRP/getHistoriqueCall","SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 50")
		vRP:prepare("vRP/saveAppels","INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)")
		vRP:prepare("vRP/appelsDeleteHistorique","DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num")
		vRP:prepare("vRP/appelsDeleteAllHistorique","DELETE FROM phone_calls WHERE `owner` = @owner")
		vRP:prepare("vRP/DeleteOldMsgs","DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 30)")
		vRP:prepare("vRP/tchatGetmessages","SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100")
		vRP:prepare("vRP/tchatAddMessage",[[ INSERT INTO phone_app_chat (`channel`, `message`) VALUES(@channel, @message);
															SELECT * from phone_app_chat WHERE `id` = (SELECT LAST_INSERT_ID());]])		
		vRP:prepare("vRP/TwitterGetTweets",[[SELECT twitter_tweets.*,
        twitter_accounts.username as author,
        twitter_accounts.avatar_url as authorIcon
      FROM twitter_tweets
        LEFT JOIN twitter_accounts
        ON twitter_tweets.authorId = twitter_accounts.id
      ORDER BY time DESC LIMIT 130]])

      vRP:prepare("vRP/TwitterGetTweets2",[[SELECT twitter_tweets.*,
        twitter_accounts.username as author,
        twitter_accounts.avatar_url as authorIcon,
        twitter_likes.id AS isLikes
      FROM twitter_tweets
        LEFT JOIN twitter_accounts
          ON twitter_tweets.authorId = twitter_accounts.id
        LEFT JOIN twitter_likes 
          ON twitter_tweets.id = twitter_likes.tweetId AND twitter_likes.authorId = @accountId
      ORDER BY time DESC LIMIT 130]])	
    
    vRP:prepare("vRP/TwitterGetFavotireTweets",[[
		SELECT twitter_tweets.*,
        twitter_accounts.username as author,
        twitter_accounts.avatar_url as authorIcon
      FROM twitter_tweets
        LEFT JOIN twitter_accounts
          ON twitter_tweets.authorId = twitter_accounts.id
      WHERE twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
      ORDER BY likes DESC, TIME DESC LIMIT 30
    	]])	
      vRP:prepare("vRP/TwitterGetFavotireTweets2",[[
		 SELECT twitter_tweets.*,
        twitter_accounts.username as author,
        twitter_accounts.avatar_url as authorIcon,
        twitter_likes.id AS isLikes
      FROM twitter_tweets
        LEFT JOIN twitter_accounts
          ON twitter_tweets.authorId = twitter_accounts.id
        LEFT JOIN twitter_likes 
          ON twitter_tweets.id = twitter_likes.tweetId AND twitter_likes.authorId = @accountId
      WHERE twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
      ORDER BY likes DESC, TIME DESC LIMIT 30
    	]])

    	vRP:prepare("vRP/getUser",[[SELECT id, username as author, avatar_url as authorIcon FROM twitter_accounts WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password]])
    	vRP:prepare("vRP/TwitterPostTweet",[[INSERT INTO twitter_tweets (`authorId`, `message`, `realUser`) VALUES(@authorId, @message, @realUser);
				SELECT * from twitter_tweets WHERE id = (SELECT LAST_INSERT_ID())
    		]])
    	vRP:prepare("vRP/TwitterToogleLike",[[SELECT * FROM twitter_tweets WHERE id = @id]])
    	vRP:prepare("vRP/TwitterToogleLike2",[[SELECT * FROM twitter_likes WHERE authorId = @authorId AND tweetId = @tweetId]])
		vRP:prepare("vRP/TwitterToogleLike3",[[INSERT INTO twitter_likes (`authorId`, `tweetId`) VALUES(@authorId, @tweetId)]])
    	vRP:prepare("vRP/TwitterToogleLike4",[[UPDATE twitter_tweets SET likes = likes + 1 WHERE id = @id]])
    	vRP:prepare("vRP/TwitterToogleLike5",[[DELETE FROM twitter_likes WHERE id = @id]])
    	vRP:prepare("vRP/TwitterToogleLike6",[[UPDATE twitter_tweets SET likes= likes - 1 WHERE id = @id]])
    	vRP:prepare("vRP/twitter_changePassword",[[UPDATE twitter_accounts SET password= @newPassword WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password]])
    	vRP:prepare("vRP/TwitterCreateAccount",[[INSERT IGNORE INTO twitter_accounts (`username`, `password`, `avatar_url`) VALUES(@username, @password, @avatarUrl)]])
		vRP:prepare("vRP/twitter_setAvatarUrl",[[UPDATE twitter_accounts SET avatar_url= @avatarUrl WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password]])    	


		vRP:execute("vRP/Creategcphone")
		print('GCPHONE: Apagando msgs antigas...')
		vRP:execute("vRP/DeleteOldMsgs")
  	end)

	function onCallFixePhone (source, phone_number, rtcOffer, extraData)
	    local indexCall = lastIndexCall
	    lastIndexCall = lastIndexCall + 1

	    local hidden = string.sub(phone_number, 1, 1) == '#'
	    if hidden == true then
	        phone_number = string.sub(phone_number, 2)
	    end
	    local sourcePlayer = tonumber(source)
	    local srcIdentifier = getPlayerID(sourcePlayer)
	    


	    local srcPhone = ''
	    if extraData ~= nil and extraData.useNumber ~= nil then
	        srcPhone = extraData.useNumber
	    else
	        srcPhone = getNumberPhone(srcIdentifier)
	    end

	    AppelsEnCours[indexCall] = {
	        id = indexCall,
	        transmitter_src = sourcePlayer,
	        transmitter_num = srcPhone,
	        receiver_src = nil,
	        receiver_num = phone_number,
	        is_valid = false,
	        is_accepts = false,
	        hidden = hidden,
	        rtcOffer = rtcOffer,
	        extraData = extraData,
	        coords = FixePhone[phone_number].coords
	    }
	    
	    PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

	    self.remote._gcPhone_notifyFixePhoneChange(-1, PhoneFixeInfo)
	    self.remote._gcPhone_waitingCall(sourcePlayer, AppelsEnCours[indexCall], true)
	end

	function onAcceptFixePhone(source, infoCall, rtcAnswer)
	    local id = infoCall.id
	    
	    AppelsEnCours[id].receiver_src = source
	    if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
	        AppelsEnCours[id].is_accepts = true
	        AppelsEnCours[id].forceSaveAfter = true
	        AppelsEnCours[id].rtcAnswer = rtcAnswer
	        PhoneFixeInfo[id] = nil
	        self.remote._gcPhone_notifyFixePhoneChange(-1, PhoneFixeInfo)
          self.remote._gcPhone_acceptCall(AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
          SetTimeout(1000, function()
            self.remote._gcPhone_acceptCall(AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
          end)
	        saveAppels(AppelsEnCours[id])
	    end
	end

	function onRejectFixePhone(source, infoCall, rtcAnswer)
	    local id = infoCall.id
	    PhoneFixeInfo[id] = nil
	    self.remote._gcPhone_notifyFixePhoneChange(-1, PhoneFixeInfo)
	    self.remote._gcPhone_rejectCall(AppelsEnCours[id].transmitter_src)
	    if AppelsEnCours[id].is_accepts == false then
	        saveAppels(AppelsEnCours[id])
	    end
	    AppelsEnCours[id] = nil
	    
	end

	function notifyContactChange(source, identifier)
	
	    local sourcePlayer = tonumber(source)
	    local identifier = identifier
	    if sourcePlayer ~= nil then 
	        self.remote._gcPhone_contactList(sourcePlayer, getContacts(identifier))
	    end
	end

	function addMessage(source, identifier, phone_number, message)
	
		 user = vRP.users_by_source[source]
	    local sourcePlayer = tonumber(source)    
	    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
	   
	    local myPhone = getNumberPhone(identifier)
	 
	    local ouser = vRP.users_by_cid[otherIdentifier]
	    if ouser then 
	       local tomess = internalAddMessage(myPhone, phone_number, message, 0)
	       self.remote._gcPhone_receiveMessage(ouser.source, tomess)
	    end
	    local memess = internalAddMessage(phone_number, myPhone, message, 1)
	    self.remote._gcPhone_receiveMessage(user.source, memess)
	end

	function gcPhone_internal_startCall(source, phone_number, rtcOffer, extraData)
	    if FixePhone[phone_number] ~= nil then
	        onCallFixePhone(source, phone_number, rtcOffer, extraData)
	        return
	    end
	    
	    local rtcOffer = rtcOffer
	    if phone_number == nil or phone_number == '' then 
	        print('BAD CALL NUMBER IS NIL')
	        return
	    end

	    local hidden = string.sub(phone_number, 1, 1) == '#'
	    if hidden == true then
	        phone_number = string.sub(phone_number, 2)
	    end

	    local indexCall = lastIndexCall
	    lastIndexCall = lastIndexCall + 1
	    local user = vRP.users_by_source[source]	
	    local sourcePlayer = tonumber(source)
	    local srcIdentifier = getPlayerID(sourcePlayer)
	    local srcPhone = ''
	    print(json.encode(extraData))
	    if extraData ~= nil and extraData.useNumber ~= nil then
	        srcPhone = extraData.useNumber
	    else
	        srcPhone = getNumberPhone(srcIdentifier)
	    end
	    print('CALL WITH NUMBER ' .. srcPhone)

	    local destPlayer = getIdentifierByPhoneNumber(phone_number)
	    local is_valid = destPlayer ~= nil and destPlayer ~= srcIdentifier
	    AppelsEnCours[indexCall] = {
	        id = indexCall,
	        transmitter_src = sourcePlayer,
	        transmitter_num = srcPhone,
	        receiver_src = nil,
	        receiver_num = phone_number,
	        is_valid = destPlayer ~= nil,
	        is_accepts = false,
	        hidden = hidden,
	        rtcOffer = rtcOffer,
	        extraData = extraData
	    }
	    

	    if is_valid == true then
	    	 duser = vRP.users_by_cid[destPlayer]
	        --getSourceFromIdentifier(destPlayer, function (srcTo)
	        if duser then
	            srcTo = tonumber(duser.source)
	                if srcTo ~= nil then
	                    AppelsEnCours[indexCall].receiver_src = srcTo
	                    --TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
	                    self.remote._gcPhone_waitingCall(user.source, AppelsEnCours[indexCall], true)
	                    self.remote._gcPhone_waitingCall(duser.source, AppelsEnCours[indexCall], false)
	                  
	                else
	                    --TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
	                   self.remote._gcPhone_waitingCall(user.source, AppelsEnCours[indexCall], true)
	                end
	        end
	    else
	        --TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
	        self.remote.gcPhone_waitingCall(user.source, AppelsEnCours[indexCall], true)
	    end

	end

	function sendHistoriqueCall (src, num) 
	    local histo = getHistoriqueCall(num)
	    self.remote._gcPhone_historiqueCall(src, histo)
	end



end

math.randomseed(os.time()) 

--- Pour les numero du style XXX-XXXX
function getPhoneRandomNumber()
    local numBase0 = math.random(100,999)
    local numBase1 = math.random(0,9999)
    local num = string.format("%03d%04d", numBase0, numBase1 )
	return num
end

--- Exemple pour les numero du style 06XXXXXXXX
-- function getPhoneRandomNumber()
--     return '0' .. math.random(600000000,699999999)
-- end

--====================================================================================
--  Utils
--====================================================================================

function getNumberPhone(identifier)
   result = vRP:query("vRP/getNumberPhone", {
        identifier = identifier
    })
    if result[1] ~= nil then
        return result[1].phone
    end
    return nil
end

function getIdentifierByPhoneNumber(phone_number) 
    local result = vRP:query("vRP/getIdentifierByPhoneNumber", {
        phone_number = phone_number
    })
    if result[1] ~= nil then
        return result[1].character_id
    end
    return nil
end




function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        vRP:execute("vRP/getOrGeneratePhoneNumber", { 
            myPhoneNumber = myPhoneNumber,
            identifier = identifier
        })
    else
        return myPhoneNumber
    end
end
--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier)

    local result = vRP:query("vRP/getContacts", {
        identifier = identifier
    })
    return result
end
function addContact(source, identifier, number, display)

    local sourcePlayer = tonumber(source)
      affected = vRP:execute("vRP/addContact", {
        identifier  = identifier,
         number  = number,
         display  = display,
    		})
      if affected > 0 then
        notifyContactChange(sourcePlayer, identifier)
      end
end
function updateContact(source, identifier, id, number, display)
    local sourcePlayer = tonumber(source)
    affected = vRP:execute("vRP/updateContact", { 
         number  = number,
         display  = display,
         id  = id,
    })
    if affected > 0 then
        notifyContactChange(sourcePlayer, identifier)
    end
end
function deleteContact(source, identifier, id)
    local sourcePlayer = tonumber(source)
    rows = vRP:execute("vRP/deleteContact", {
         identifier  = identifier,
         id  = id,
    })
    notifyContactChange(sourcePlayer, identifier)
end
function deleteAllContact(identifier)
    rows = vRP:execute("vRP/deleteAllContact", {
         identifier  = identifier
    })
end

vRPgcphone.tunnel = {}

function vRPgcphone.tunnel:gcPhone_addContact(display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    addContact(sourcePlayer, identifier, phoneNumber, display)
end

function vRPgcphone.tunnel:gcPhone_updateContact(id, display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    updateContact(sourcePlayer, identifier, id, phoneNumber, display)
end

function vRPgcphone.tunnel:gcPhone_deleteContact(id)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    deleteContact(sourcePlayer, identifier, id)
end

--====================================================================================
--  Messages
--====================================================================================
function getMessages(identifier)
    local result = vRP:query("vRP/getMessages", {
          identifier  = identifier
    })
    return result
    --return MySQLQueryTimeStamp("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", { identifier  = identifier})
end

--function vRPgcphone.tunnel:_internalAddMessage(transmitter, receiver, message, owner, cb)
  --  return _internalAddMessage(transmitter, receiver, message, owner)
--end

function internalAddMessage(transmitter, receiver, message, owner)
    id = vRP:query("vRP/internalAddMessage", {
         transmitter  = transmitter,
         receiver  = receiver,
         message  = message,
         isRead  = owner,
         owner  = owner,
    })
    return id[1]
end



function setReadMessageNumber(identifier, num)
    local mePhoneNumber = getNumberPhone(identifier)
    vRP:execute("vRP/setReadMessageNumber", { 
         receiver  = mePhoneNumber,
         transmitter  = num
    })
end

function deleteMessage(msgId)
    vRP:execute("vRP/deleteMessage", {
         id  = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
    local source = source
    local identifier = identifier
    local mePhoneNumber = getNumberPhone(identifier)
    vRP:execute("vRP/deleteAllMessageFromPhoneNumber", { mePhoneNumber  = mePhoneNumber, phone_number  = phone_number})
end

function deleteAllMessage(identifier)
    local mePhoneNumber = getNumberPhone(identifier)
    vRP:execute("vRP/deleteAllMessage", {
         mePhoneNumber  = mePhoneNumber
    })
end

function  vRPgcphone.tunnel:gcPhone_sendMessage(phoneNumber, message)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addMessage(sourcePlayer, identifier, phoneNumber, message)
end

function vRPgcphone.tunnel:gcPhone_deleteMessage(msgId)
    deleteMessage(msgId)
end

function vRPgcphone.tunnel:gcPhone_deleteMessageNumber(number)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    deleteAllMessageFromPhoneNumber(sourcePlayer,identifier, number)
    -- TriggerClientEvent("gcphone:allMessage", sourcePlayer, getMessages(identifier))
end

function vRPgcphone.tunnel:gcPhone_deleteAllMessage()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    deleteAllMessage(identifier)
end

function vRPgcphone.tunnel:gcPhone_setReadMessageNumber(num)
    local sourcePlayer = tonumber(source)    
    local identifier = getPlayerID(sourcePlayer)
    setReadMessageNumber(identifier, num)
end

function vRPgcphone.tunnel:gcPhone_deleteALL()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(sourcePlayer)
    deleteAllMessage(identifier)
    deleteAllContact(identifier)
    appelsDeleteAllHistorique(identifier)
    self.remote._gcPhone_contactList(sourcePlayer, {})
    self.remote._gcPhone_allMessage(sourcePlayer, {})
    --self.remote._appelsDeleteAllHistorique(sourcePlayer, {})
end

--====================================================================================
--  Gestion des appels
--====================================================================================


function getHistoriqueCall (num)
    local result = vRP:query("vRP/getHistoriqueCall", {
         num  = num
    })
    return result

end


function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        rows = vRP:execute("vRP/saveAppels", {
             owner  = appelInfo.transmitter_num,
             num  = appelInfo.receiver_num,
             incoming  = 1,
             accepts  = appelInfo.is_accepts
        })
        if rows > 0 then
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            mun = "###-####"
        end
        rows = vRP:execute("vRP/saveAppels", {
             owner  = appelInfo.receiver_num,
             num  = num,
             incoming  = 0,
             accepts  = appelInfo.is_accepts
        })
            if appelInfo.receiver_src ~= nil and rows > 0 then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

function vRPgcphone.tunnel:gcPhone_getHistoriqueCall_server()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(sourcePlayer)
    local srcPhone = getNumberPhone(srcIdentifier)
    sendHistoriqueCall(sourcePlayer, srcPhone)
end




function vRPgcphone.tunnel:gcPhone_startCall(phone_number, rtcOffer, extraData)
    gcPhone_internal_startCall(source, phone_number, rtcOffer, extraData)
end

function vRPgcphone.tunnel:gcPhone_candidates(callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then 
            to = AppelsEnCours[callId].receiver_src
        end
        self.remote._gcPhone_candidates(to, candidates)
    end
end


function vRPgcphone.tunnel:gcPhone_acceptCall(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer          
            self.remote._gcPhone_acceptCall(AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
            SetTimeout(1000, function() 
              self.remote._gcPhone_acceptCall(AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
            end)
            saveAppels(AppelsEnCours[id])
        end
    end
end




function vRPgcphone.tunnel:gcPhone_rejectCall(infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            self.remote._gcPhone_rejectCall(AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            self.remote._gcPhone_rejectCall(AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then 
            saveAppels(AppelsEnCours[id])
        end
        --TriggerEvent('gcPhone:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end

function vRPgcphone.tunnel:gcPhone_appelsDeleteHistorique(numero)
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(sourcePlayer)
    local srcPhone = getNumberPhone(srcIdentifier)
    vRP:execute("vRP/appelsDeleteHistorique", {
         owner  = srcPhone,
         num  = numero
    })
end

function appelsDeleteAllHistorique(srcIdentifier)
    local srcPhone = getNumberPhone(srcIdentifier)
    vRP:execute("appelsDeleteAllHistorique", {
         owner  = srcPhone
    })
end

function vRPgcphone.tunnel:gcPhone_appelsDeleteAllHistorique()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(sourcePlayer)
    appelsDeleteAllHistorique(srcIdentifier)
end


--====================================================================================
--  OnLoad
--====================================================================================

vRPgcphone.event = {}


function vRPgcphone.event:playerSpawn(user, first_spawn)
    local sourcePlayer = tonumber(user.source)
    local identifier = getPlayerID(sourcePlayer)
    	myPhoneNumber = getOrGeneratePhoneNumber(sourcePlayer, identifier)
        self.remote._gcPhone_myPhoneNumber(sourcePlayer, myPhoneNumber)
        self.remote._gcPhone_contactList(sourcePlayer, getContacts(identifier))
        self.remote._gcPhone_allMessage(sourcePlayer, getMessages(identifier))
end

-- Just For reload
function vRPgcphone.tunnel:gcPhone_allUpdate()
    local sourcePlayer = tonumber(source)  
    local identifier = getPlayerID(sourcePlayer)
    local num = getNumberPhone(identifier)
    self.remote._gcPhone_myPhoneNumber(sourcePlayer, num)
    self.remote._gcPhone_contactList(sourcePlayer, getContacts(identifier))
    self.remote._gcPhone_allMessage(sourcePlayer, getMessages(identifier))
    self.remote._gcPhone_getBourse(sourcePlayer, getBourse())
    sendHistoriqueCall(sourcePlayer, num)
end

--====================================================================================
--  App bourse
--====================================================================================
function getBourse()
    --  Format
    --  Array 
    --    Object
    --      -- libelle type String    | Nom
    --      -- price type number      | Prix actuelle
    --      -- difference type number | Evolution 
    -- 
    -- local result = MySQL.Sync.fetchAll("SELECT * FROM `recolt` LEFT JOIN `items` ON items.`id` = recolt.`treated_id` WHERE fluctuation = 1 ORDER BY price DESC",{})
    local result = {
        {
            libelle = 'Google',
            price = 125.2,
            difference =  -12.1
        },
        {
            libelle = 'Microsoft',
            price = 132.2,
            difference = 3.1
        },
        {
            libelle = 'Amazon',
            price = 120,
            difference = 0
        }
    }
    return result
end



------------------------------------------------------------
------------------------------------------------------------
---            TCHAT SERVER ---------------------
------------------------------------------------------------
------------------------------------------------------------

function vRPgcphone.tunnel:gcphone_tchat_messages(channel, cb)
    user = vRP.users_by_source[source]
    messages = vRP:query("vRP/tchatGetmessages", { 
        channel = channel
    })
    self.remote._gcPhone_tchat_channel(user.source, channel, messages)
end

function vRPgcphone.tunnel:gcPhone_tchat_addMessage(channel, message)
  result = vRP:query("vRP/tchatAddMessage", {
    channel = channel,
    message = message
  })
    self.remote._gcPhone_tchat_receive(-1, result[1])
end

------------------------------------------------------------
------------------------------------------------------------
-----------------VRP ADDONS -------------------------

function vRPgcphone.tunnel:vrp_addons_gcphone_startCall(number, message, coords)
  user = vRP.users_by_source[source]
  vRP.EXT.Base.remote._notify(user.source,"Seu chamado foi solicitado a um "..number)
  vRP.EXT.Phone:sendServiceAlert(user, number,coords.x,coords.y,coords.z,message)
end

--====================================================================================
--  App ... WIP
--====================================================================================


-- SendNUIMessage('ongcPhoneRTC_receive_offer')
-- SendNUIMessage('ongcPhoneRTC_receive_answer')

-- RegisterNUICallback('gcPhoneRTC_send_offer', function (data)


-- end)


-- RegisterNUICallback('gcPhoneRTC_send_answer', function (data)


-- end)


--------------------------------
---------------twitter ----------
---------------------------------
--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================

function TwitterGetTweets (accountId)
  if accountId == nil then
    rows = vRP:query("vRP/TwitterGetTweets")
  else
    rows = vRP:query("vRP/TwitterGetTweets2", { accountId = accountId })
  end
  return rows
end

function TwitterGetFavotireTweets (accountId, cb)
  if accountId == nil then
     rows = vRP:query("vRP/TwitterGetFavotireTweets")
  else
     rows = vRP:query("vRP/TwitterGetFavotireTweets2", { accountId = accountId })
  end

  return rows
end

function getUser(username, password, cb)
  data = vRP:query("vRP/getUser", {
    username = username,
    password = password
  })
    return data[1]
end

function TwitterPostTweet (username, password, message, sourcePlayer, realUser, cb)
  	 user = getUser(username, password)
    if user == nil then
      if sourcePlayer ~= nil then
        TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
      end
      return
    end
    tweets = vRP:query("vRP/TwitterPostTweet", {
      authorId = user.id,
      message = message,
      realUser = realUser
    })
    tweet = tweets[1]
    tweet['author'] = user.author
    tweet['authorIcon'] = user.authorIcon
    TriggerClientEvent('gcPhone:twitter_newTweets', -1, tweet)
    TriggerEvent('gcPhone:twitter_newTweets', tweet)
end

function TwitterToogleLike (username, password, tweetId, sourcePlayer)
  user = getUser(username, password)
    if user == nil then
      if sourcePlayer ~= nil then
        TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
      end
      return
    end
   tweets = vRP:query('vRP/TwitterToogleLike', {
      id = tweetId
    })
      if (tweets[1] == nil) then return end
      local tweet = tweets[1]
      row = vRP:query('vRP/TwitterToogleLike2', {
        authorId = user.id,
        tweetId = tweetId
      }) 
        if (row[1] == nil) then
	         newrow = vRP:query('vRP/TwitterToogleLike3', {
	            authorId = user.id,
	            tweetId = tweetId
	         })
            vRP:execute('vRP/TwitterToogleLike4', {
              id = tweet.id
            })
            TriggerClientEvent('gcPhone:twitter_updateTweetLikes', -1, tweet.id, tweet.likes + 1)
            TriggerClientEvent('gcPhone:twitter_setTweetLikes', sourcePlayer, tweet.id, true)
            TriggerEvent('gcPhone:twitter_updateTweetLikes', tweet.id, tweet.likes + 1)
        else
          vRP:execute('vRP/TwitterToogleLike5', {
            id = row[1].id,
          })
          vRP:execute('vRP/TwitterToogleLike6', {
            id = tweet.id
          })
              TriggerClientEvent('gcPhone:twitter_updateTweetLikes', -1, tweet.id, tweet.likes - 1)
              TriggerClientEvent('gcPhone:twitter_setTweetLikes', sourcePlayer, tweet.id, false)
              TriggerEvent('gcPhone:twitter_updateTweetLikes', tweet.id, tweet.likes - 1)
        end
end

function TwitterCreateAccount(username, password, avatarUrl, cb)
   affected = vRP:execute('vRP/TwitterCreateAccount', {
    username = username,
    password = password,
    avatarUrl = avatarUrl
  })
   return affected
end
-- ALTER TABLE `twitter_accounts`	CHANGE COLUMN `username` `username` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci';

function TwitterShowError (sourcePlayer, title, message)
  TriggerClientEvent('gcPhone:twitter_showError', sourcePlayer, message)
end
function TwitterShowSuccess (sourcePlayer, title, message)
  TriggerClientEvent('gcPhone:twitter_showSuccess', sourcePlayer, title, message)
end

RegisterServerEvent('gcPhone:twitter_login')
AddEventHandler('gcPhone:twitter_login', function(username, password)
  local sourcePlayer = tonumber(source)
  user = getUser(username, password)
    if user == nil then
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
    else
      TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_SUCCESS')
      TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username, password, user.authorIcon)
    end
end)

RegisterServerEvent('gcPhone:twitter_changePassword')
AddEventHandler('gcPhone:twitter_changePassword', function(username, password, newPassword)
  local sourcePlayer = tonumber(source)
  user = getUser(username, password)
    if user == nil then
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_ERROR')
    else
      result = vRP:execute("twitter_changePassword", {
        username = username,
        password = password,
        newPassword = newPassword
      })
        if (result == 1) then
          TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username, newPassword, user.authorIcon)
          TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_SUCCESS')
        else
          TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_ERROR')
        end
    end
end)

RegisterServerEvent('gcPhone:twitter_createAccount')
AddEventHandler('gcPhone:twitter_createAccount', function(username, password, avatarUrl)
  local sourcePlayer = tonumber(source)
  TwitterCreateAccount(username, password, avatarUrl, function (id)
    if (id ~= 0) then
      TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username, password, avatarUrl)
		TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_ACCOUNT_CREATE_SUCCESS')      
    else
    	TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_ACCOUNT_CREATE_ERROR')
    end
  end)
end)



RegisterServerEvent('gcPhone:twitter_getTweets')
AddEventHandler('gcPhone:twitter_getTweets', function(username, password)
  local sourcePlayer = tonumber(source)
  if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
    user = getUser(username, password)
      local accountId = user and user.id
      tweets = TwitterGetTweets(accountId)
      TriggerClientEvent('gcPhone:twitter_getTweets', sourcePlayer, tweets)
  else
    tweets = TwitterGetTweets(nil)
    TriggerClientEvent('gcPhone:twitter_getTweets', sourcePlayer, tweets)
  end
end)

RegisterServerEvent('gcPhone:twitter_getFavoriteTweets')
AddEventHandler('gcPhone:twitter_getFavoriteTweets', function(username, password)
  local sourcePlayer = tonumber(source)
  if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
    user = getUser(username, password)
      local accountId = user and user.id
      tweets = TwitterGetFavotireTweets(accountId)
        TriggerClientEvent('gcPhone:twitter_getFavoriteTweets', sourcePlayer, tweets)
  else
    tweets = TwitterGetFavotireTweets(nil)
     TriggerClientEvent('gcPhone:twitter_getFavoriteTweets', sourcePlayer, tweets)
  end
end)

RegisterServerEvent('gcPhone:twitter_postTweets')
AddEventHandler('gcPhone:twitter_postTweets', function(username, password, message)
  local sourcePlayer = tonumber(source)
  local srcIdentifier = getPlayerID(source)
  TwitterPostTweet(username, password, message, sourcePlayer, srcIdentifier)
end)

RegisterServerEvent('gcPhone:twitter_toogleLikeTweet')
AddEventHandler('gcPhone:twitter_toogleLikeTweet', function(username, password, tweetId)
  local sourcePlayer = tonumber(source)
  TwitterToogleLike(username, password, tweetId, sourcePlayer)
end)


RegisterServerEvent('gcPhone:twitter_setAvatarUrl')
AddEventHandler('gcPhone:twitter_setAvatarUrl', function(username, password, avatarUrl)
  local sourcePlayer = tonumber(source)
  result = vRP:execute("vRP/twitter_setAvatarUrl", {
    username = username,
    password = password,
    avatarUrl = avatarUrl
  })
    if (result == 1) then
      TriggerClientEvent('gcPhone:twitter_setAvatarUrl', sourcePlayer, avatarUrl)
      TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_AVATAR_SUCCESS')
    else
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
    end
end)


--[[
  Discord WebHook
--]]
AddEventHandler('gcPhone:twitter_newTweets', function (tweet)
  local discord_webhook = GetConvar('discord_webhook', 'https://discordapp.com/api/webhooks/564986425129566248/2CTHH-5TxyTnEW9KHgjIfJulgmXKDyA37pNkL9-lWvu2Aexzh_ZiZNeTzvLuQafaSSDw')  if discord_webhook == '' then
    return
  end
  local headers = {
    ['Content-Type'] = 'application/json'
  }
  local data = {
    ["username"] = tweet.author,
    ["embeds"] = {{
      ["thumbnail"] = {
        ["url"] = tweet.authorIcon
      },
      ["color"] = 1942002,
      ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ", tweet.time / 1000 )
    }}
  }
  local isHttp = string.sub(tweet.message, 0, 7) == 'http://' or string.sub(tweet.message, 0, 8) == 'https://'
  local ext = string.sub(tweet.message, -4)
  local isImg = ext == '.png' or ext == '.pjg' or ext == '.gif' or string.sub(tweet.message, -5) == '.jpeg'
  if (isHttp and isImg) and true then
    data['embeds'][1]['image'] = { ['url'] = tweet.message }
  else
    data['embeds'][1]['description'] = tweet.message
  end
  PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end)




vRP:registerExtension(vRPgcphone)