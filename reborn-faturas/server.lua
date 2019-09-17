local vRPRebornFaturas = class("vRPRebornFaturas", vRP.Extension)


local function faturas_menu(self)

	function ch_escolha(menu, fullid)
		user = menu.user -- vRP.getUserSource({player}) VERIFICAR AQUI ID OU SOURCE
		--txt = tostring(menu.data.title)
		--local b = string.find(txt,"]")
		--local s = string.sub(txt,3, b-1)
		id = tonumber(fullid)
		if user:request('Deseja pagar esta fatura', 20) then
			payBill(user.source,id)
		end
		user:actualizeMenu()
	end

	function ch_enviar(menu,fullid)
	  user = menu.user
	  print('Enviar')
	  print(user.source)
			if user then
				nplayer = vRP.EXT.Base.remote.getNearestPlayer(user.source,10)
				print(nplayer)
						if nplayer then
							sendBill(user.source, nplayer, label, valor)
						else
							vRP.EXT.Base.remote._notify(user.source,'Não tem ninguem por perto')
						end
			end
	end

	vRP.EXT.GUI:registerMenuBuilder("Faturas", function(menu)
		menu.title = 'Em Aberto'
		menu.css.header_color = "rgba(240,203,88,0.75)"
		local user = menu.user
		local result = vRP:query("vRP/getBill", {identifier = user.cid})
			local bills = {}
			for i=1, #result, 1 do
				local identity = vRP.EXT.Identity:getIdentity(result[i].sender)
				dsp_name = identity.firstname.." "..identity.name
				table.insert(bills, {
					id         = result[i].id,
					identifier = result[i].identifier,
					sender     = result[i].sender,
					targetType = result[i].target_type,
					target     = result[i].target,
					label      = result[i].label,
					amount     = result[i].amount,
					sname	 		 = dsp_name
				})	
			end
		if user ~= nil then
	    	menu:addOption("Enviar Fatura", ch_enviar, "Envie uma fatura a um civil próximo")
			for k, v in pairs(bills) do
				label = "Pagar a fatura de R$"..tostring(v.amount).." para o Sr(a)."..tostring(v.sname)
				sitem = "[#"..v.id.."] - "..v.label --.." "..tostring(v.amount)
				menu:addOption(sitem, ch_escolha, label, v.id) 
			end			
		end
	end)
end

function vRPRebornFaturas:__construct()
  vRP.Extension.__construct(self)

  async(function()
  	vRP:prepare('vRP/CreateBilling',[[
													CREATE TABLE IF NOT EXISTS `vrp_user_billing` (
													  `id` int(11) NOT NULL AUTO_INCREMENT,
													  `user_id` varchar(255) COLLATE utf8mb4_bin NOT NULL,
													  `sender` varchar(255) COLLATE utf8mb4_bin NOT NULL,
													  `target_type` varchar(50) COLLATE utf8mb4_bin NOT NULL,
													  `target` varchar(255) COLLATE utf8mb4_bin NOT NULL,
													  `label` varchar(255) COLLATE utf8mb4_bin NOT NULL,
													  `amount` int(11) NOT NULL,
													  PRIMARY KEY (`id`)
													) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
													]])
  	 vRP:prepare('vRP/sendBill','INSERT INTO vrp_user_billing (user_id, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)')
  	 vRP:prepare('vRP/getBill','SELECT * FROM vrp_user_billing WHERE user_id = @identifier')
  	 vRP:prepare('vRP/getTargetBills','SELECT * FROM vrp_user_billing WHERE user_id = @identifier')
  	 vRP:prepare('vRP/payBill','SELECT * FROM vrp_user_billing WHERE id = @id')
  	 vRP:prepare('vRP/DeleteBill','DELETE from vrp_user_billing WHERE id = @id')
  	 vRP:execute('vRP/CreateBilling')

  	end)
  faturas_menu(self)

  local function m_faturas(menu)
    menu.user:openMenu("Faturas")
  end
  vRP.EXT.GUI:registerMenuBuilder("main", function(menu)
    menu:addOption('<i class=\"fas fa-file-invoice-dollar\" style=\"font-size: 12px;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Faturas', m_faturas,'Pagar/Enviar Faturas')
  end)

	function payBill(source, id)
		local xPlayer = vRP.users_by_source[source]
		print(id)
		print(source)
		print('paybill')
		if id ~= nil then 
			result = vRP:query('vRP/payBill', {id = id})

				local sender     = result[1].sender
				local targetType = result[1].target_type
				local target     = result[1].target
				local amount     = result[1].amount

				local xTarget = tonumber(sender)
				print(xTarget)
				--if targetType == 'player' then
					sourceTarget = vRP.users_by_cid[xTarget]
					if sourceTarget ~= nil then
						print('SourceTarget')
						print(sourceTarget.source)
						if xPlayer ~= nil then
							print('xplayer')
							print(xPlayer.cid)
							print(amount)
							if xPlayer:tryPayment(amount,false) then
								print('pagou')
								rowsChanged = vRP:execute('vRP/DeleteBill', {id = id})
								print('Deletou')
										sourceTarget:giveBank(amount)
										print('deu dinheiro')
										vRP.EXT.Base.remote._notify(xPlayer.source,'Você pagou a fatura')
										local identity = vRP.EXT.Identity:getIdentity(xPlayer.cid)
												dsp_name = identity.firstname.." "..identity.name
												self.remote._aviso(sourceTarget.source, xPlayer.source, 'Você recebeu o valor de R$'..amount.." do "..dsp_name,amount)
												--vRPclient.notify(sourceTarget,{'Você recebeu o valor de R$'..amount.." do "..dsp_name})      											
							else
								vRP.EXT.Base.remote._notify(xPlayer.source,'Você não tem dinheiro para pagar a fatura')

							end
						else
							vRP.EXT.Base.remote._notify(xPlayer.source,'O emitente da fatura não está disponivel')
						end					
					else
						vRP.EXT.Base.remote._notify(xPlayer.source,'O emitente da fatura não está disponivel')
					end
				--end
		end
	end

	function sendBill(playerS, targetS, label, amount)
		--local _source = vRP.getUserSource({player})
		local xPlayer = vRP.users_by_source[playerS]
		local xTarget = vRP.users_by_source[targetS]
		print('existe')
		local identity = vRP.EXT.Identity:getIdentity(xTarget.cid)
		print('identidade')
		print(xTarget.cid)
		dsp_name = identity.firstname.." "..identity.name						
		title = "Valor da fatura para "..tostring(xTarget.cid).." - "..tostring(dsp_name)
		amount = xPlayer:prompt(title,"")
		valor = tonumber(amount)
		motivo = xPlayer:prompt("Motivo (msg curta)","")
		label = motivo
		if label ~= "" and valor > 0 then
			amount        = round(amount,0)
			if amount > 0 then
				if xTarget ~= nil then
					rows = vRP:execute("vRP/sendBill",
					{
						identifier  = xTarget.cid,
						sender      = xPlayer.cid,
						target_type = "player",
						target      = xTarget.cid,
						label       = label,
						amount      = amount
					})
					  self.remote._aviso(xTarget.source, xPlayer.source, 'Enviei uma fatura para você',amount)
						--vRPclient.notify(xTarget,{'Você recebeu uma fatura'})
	      	end
	    	end
		else
			vRP.EXT.Base.remote._notify(xPlayer.source,'Fatura não emitida')
		end	
	end
end

vRPRebornFaturas.tunnel = {}

function vRPRebornFaturas.tunnel:EnviarNoty(player,nplayer,msg,valor,handle,txd)
	self.remote._aviso(nplayer, msg, valor, handle, txd)
end



function vRPRebornFaturas.tunnel:getBill(cb)
  local xPlayer = vRP.users_by_source[source]
	result = vRP:query('vRP/getBill', {identifier = xPlayer.cid})
		local bills = {}
		for i=1, #result, 1 do
			table.insert(bills, {
				id         = result[i].id,
				identifier = result[i].identifier,
				sender     = result[i].sender,
				targetType = result[i].target_type,
				target     = result[i].target,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end
		return bills
end

function vRPRebornFaturas.tunnel:getTargetBills(source, cb, target)
local xPlayer = vRP.users_by_source[target]

	rows = vRP:query('vRP/getTargetBills', {
		identifier = xPlayer.cid
	})
		local bills = {}
		for i=1, #rows, 1 do
			table.insert(bills, {
				id         = result[i].id,
				identifier = result[i].identifier,
				sender     = result[i].sender,
				targetType = result[i].target_type,
				target     = result[i].target,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end

		return bills
end



function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

vRP:registerExtension(vRPRebornFaturas)

