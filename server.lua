local Text               = {}
local lastduree          = ""
local lasttarget         = ""
local BanList            = {}
local BanListLoad        = false
local BanListHistory     = {}
local BanListHistoryLoad = false


CreateThread(function()
	if Config.Lang == "fr" then
		Text = Config.TextFr
	elseif Config.Lang == "en" then
		Text = Config.TextEn
	else
		print("FIveM-BanSql : Invalid Config.Lang")
	end
	while true do
		Wait(1000)
        if BanListLoad == false then
			loadBanList()
			if BanList ~= {} then
				print(Text.banlistloaded)
				BanListLoad = true
			else
				print(Text.starterror)
			end
		end
		if BanListHistoryLoad == false then
			loadBanListHistory()
            if BanListHistory ~= {} then
				print(Text.historyloaded)
				BanListHistoryLoad = true
			else
				print(Text.starterror)
			end
		end
	end
end)


TriggerEvent('es:addGroupCommand', 'banreload', "admin", function (source)
  BanListLoad        = false
  BanListHistoryLoad = false
  Wait(5000)
  if BanListLoad == true then
	TriggerEvent('bansql:sendMessage', source, Text.banlistloaded)
	if BanListHistoryLoad == true then
		TriggerEvent('bansql:sendMessage', source, Text.historyloaded)
	end
  else
	TriggerEvent('bansql:sendMessage', source, Text.loaderror)
  end
end)

TriggerEvent('es:addGroupCommand', 'banhistory', "admin", function (source, args, user)
 if args[1] ~= nil and BanListHistory ~= {} then
	local nombre = (tonumber(args[1]))
	local name   = table.concat(args, " ",1)
	if name ~= "" then

			if nombre ~= nil and nombre > 0 then
					local expiration = BanListHistory[nombre].expiration
					local timeat     = BanListHistory[nombre].timeat
					local calcul1    = expiration - timeat
					local calcul2    = calcul1 / 86400
					local calcul2 	 =  math.ceil(calcul2)
					local resultat   = (tostring(BanListHistory[nombre].targetplayername)) .. " , " .. (tostring(BanListHistory[nombre].sourceplayername)) .. " , " .. (tostring(BanListHistory[nombre].reason)) .. " , " .. calcul2 .. Text.day
					
					TriggerEvent('bansql:sendMessage', source, (nombre .." : ".. resultat))
			else
					for i = 1, #BanListHistory, 1 do
						if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
							local expiration = BanListHistory[i].expiration
							local timeat     = BanListHistory[i].timeat
							local calcul1    = expiration - timeat
							local calcul2    = calcul1 / 86400
							local calcul2 	 =  math.ceil(calcul2)					
							local resultat   = (tostring(BanListHistory[i].targetplayername)) .. " , " .. (tostring(BanListHistory[i].sourceplayername)) .. " , " .. (tostring(BanListHistory[i].reason)) .. " , " .. calcul2 .. Text.day

							TriggerEvent('bansql:sendMessage', source, (i .." : ".. resultat))
						end
					end
			end
	else
		TriggerEvent('bansql:sendMessage', source, Text.invalidname)
	end
  else
	TriggerEvent('bansql:sendMessage', source, Text.addhistory)
  end
end)

TriggerEvent('es:addGroupCommand', 'unban', "admin", function (source, args, user)
  if args[1] ~= nil then
    local name = table.concat(args, " ")
     MySQL.Async.fetchScalar('SELECT identifier FROM banlist WHERE targetplayername=@name',
    {
        ['@name'] = name
    }, function(identifier)
        if identifier ~= nil then
            MySQL.Async.execute(
            'DELETE FROM banlist WHERE targetplayername=@name',
            {
              ['@name']  = name
            },
                function ()
                loadBanList()
            end)
			TriggerEvent('bansql:sendMessage', source, name .. Text.isban)
        else
			TriggerEvent('bansql:sendMessage', source, Text.invalidname)
        end
    end)
  else
	TriggerEvent('bansql:sendMessage', source, Text.invalidname)
  end
end)

TriggerEvent('es:addGroupCommand', 'ban', "admin", function (source, args, user)
		local target    = tonumber(args[1])
		local duree     = tonumber(args[2])
		local reason    = table.concat(args, " ",3)
		local permanent = 0
		
		if reason == "" then
			reason = Text.noreason
		end
		if target ~= nil and target > 0 then
			local ping = GetPlayerPing(target)
        
			if ping ~= nil and ping > 0 then
				if duree ~= nil and duree < 365 then
					local sourceplayername = GetPlayerName(source)
					local targetplayername = GetPlayerName(target)
					local identifier 	   = GetPlayerIdentifiers(target)[1]
					local license          = GetPlayerIdentifiers(target)[2]
					local playerip         = GetPlayerIdentifiers(target)[3]
				
					if duree > 0 then
						ban(source,identifier,license,playerip,targetplayername,sourceplayername,duree,reason,permanent)
						DropPlayer(target, Text.yourban .. reason)
					else
						local permanent = 1
						ban(source,identifier,license,playerip,targetplayername,sourceplayername,duree,reason,permanent)
						DropPlayer(target, Text.yourpermban .. reason)
					end
				
				else
					TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
				end	
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidid)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidid)
			TriggerEvent('bansql:sendMessage', source, Text.add)
		end
end)

TriggerEvent('es:addGroupCommand', 'banoffline', "admin", function (source, args, user)
	if args ~= "" then
		lastduree  = tonumber(args[1])
		lasttarget = table.concat(args, " ",2)
		if lastduree ~= "" and lastduree ~= nil then
			if lasttarget ~= "" and lasttarget ~= nil then
				TriggerEvent('bansql:sendMessage', source, (lasttarget .. Text.during .. lastduree .. Text.forcontinu))
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidid)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
			TriggerEvent('bansql:sendMessage', source, Text.addoff)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.addoff)
	end
end)

TriggerEvent('es:addGroupCommand', 'reason', "admin", function (source, args, user)
		local duree      = lastduree
		local name       = lasttarget
		local reason     = table.concat(args, " ",1)
		local permanent  = 0
		local playerip   = "0.0.0.0"

		if Config.esx then
			MySQL.Async.fetchScalar('SELECT identifier FROM users WHERE name=@name',
			{
				['@name']       = name
			}, function(identifier)

				if identifier == nil then
					TriggerEvent('bansql:sendMessage', source, Text.invalidid)
				else
					local steamID = identifier

					MySQL.Async.fetchScalar('SELECT license FROM users WHERE name=@name',
					{
						['@name']       = name
					}, function(license)

						if license ~= nil then
							local fivemID = license						

							if reason == "" then
								reason = Text.noreason
							end

								if name ~= "" then
									if duree ~= nil and duree < 365 then
										local sourceplayername = GetPlayerName(source)

										if duree > 0 then
											ban(source,steamID,fivemID,playerip,name,sourceplayername,duree,reason,permanent)
											lastduree  = ""
											lasttarget = ""
										else
											local permanent = 1
											ban(source,steamID,fivemID,playerip,name,sourceplayername,duree,reason,permanent)
											lastduree  = ""
											lasttarget = ""
										end

									else
										TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
									end	
								else
									TriggerEvent('bansql:sendMessage', source, Text.invalidid)
								end
						end
					end)
				end

			end)
		else
--			Here use futur BanUserList to find info
		end
end)

-- console / rcon can also utilize es:command events, but breaks since the source isn't a connected player, ending up in error messages
AddEventHandler('bansql:sendMessage', function(source, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1Banlist', message } } )
	else
		print('SqlBan: ' .. message)
	end
end)


function ban(source,identifier,license,playerip,targetplayername,sourceplayername,duree,reason,permanent)
--calcul total expiration (en secondes)
	local expiration = duree * 86400
	local timeat     = os.time()
	
	if expiration < os.time() then
		expiration = os.time()+expiration
	end
	
		table.insert(BanList, {
			identifier = identifier,
			license    = license,
			playerip   = playerip,
			reason     = reason,
			expiration = expiration,
			permanent  = permanent
          })

		MySQL.Async.execute(
                'INSERT INTO banlist (identifier,license,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@identifier,@license,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                { 
				['@identifier']       = identifier,
				['@license']          = license,
				['@playerip']         = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = expiration,
				['@timeat']           = os.time(),
				['@permanent']        = permanent,
				},
				function ()
		end)
		
		TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.during .. duree .. Text.forr .. reason))
				
		MySQL.Async.execute(
                'INSERT INTO banlisthistory (identifier,license,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@identifier,@license,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                { 
				['@identifier']       = identifier,
				['@license']          = license,
				['@playerip']         = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = expiration,
				['@timeat']           = os.time(),
				['@permanent']        = permanent,
				},
				function ()
		end)
		
		BanListHistoryLoad = false
end

function loadBanList()
  MySQL.Async.fetchAll(
    'SELECT * FROM banlist',
    {},
    function (identifiers)
      BanList = {}

      for i=1, #identifiers, 1 do
        table.insert(BanList, {
			identifier = identifiers[i].identifier,
			license    = identifiers[i].license,
			playerip   = identifiers[i].playerip,
			reason     = identifiers[i].reason,
			expiration = identifiers[i].expiration,
			permanent  = identifiers[i].permanent
          })
      end
    end
  )
end

function loadBanListHistory()
  MySQL.Async.fetchAll(
    'SELECT * FROM banlisthistory',
    {},
    function (identifiers)
      BanListHistory = {}

      for i=1, #identifiers, 1 do
        table.insert(BanListHistory, {
			identifier       = identifiers[i].identifier,
			license          = identifiers[i].license,
			playerip         = identifiers[i].playerip,
			targetplayername = identifiers[i].targetplayername,
			sourceplayername = identifiers[i].sourceplayername,
			reason           = identifiers[i].reason,
			expiration       = identifiers[i].expiration,
			permanent        = identifiers[i].permanent,
			timeat           = identifiers[i].timeat
          })
      end
    end
  )
end


function deletebanned(identifier) 

MySQL.Async.execute(
            'DELETE FROM banlist WHERE identifier=@identifier',
            {
              ['@identifier']  = identifier
            },
                function ()
                loadBanList()
            end)
end



AddEventHandler('playerConnecting', function (playerName,setKickReason)
    local steamID  = GetPlayerIdentifiers(source)[1]
	local license  = GetPlayerIdentifiers(source)[2]
	local playerip = GetPlayerIdentifiers(source)[3]

	
	--Si Banlist pas chargée
	if (Banlist == {}) then
		Citizen.Wait(1000)
	end

    if steamID == false then
		setKickReason("Vous devez ouvrir steam !")
		CancelEvent()
    end
	
	for i = 1, #BanList, 1 do
		if ((tostring(BanList[i].identifier)) == tostring(steamID) or (tostring(BanList[i].license)) == tostring(license) or (tostring(BanList[i].playerip)) == tostring(playerip)) and (tonumber(BanList[i].expiration)) > os.time() and (tonumber(BanList[i].permanent)) == 0 then
			local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = (day - math.floor(day)) * 24
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason("Vous etes banni pour : " .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day ..txthrs .. Text.hour ..txtminutes .. Text.minute)
						CancelEvent()
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = tempsrestant / 60
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason("Vous etes banni pour : " .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
				elseif tempsrestant < 60 then
					local txtday     = 0
					local txthrs     = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason("Vous etes banni pour : " .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
				end
		end
	
		if ((tostring(BanList[i].identifier)) == tostring(steamID) or (tostring(BanList[i].license)) == tostring(license) or (tostring(BanList[i].playerip)) == tostring(playerip)) and (tonumber(BanList[i].permanent)) == 1 then
			setKickReason(Text.yourpermban .. BanList[i].reason)
			CancelEvent()
		end
	
		if ((tostring(BanList[i].identifier)) == tostring(steamID) or (tostring(BanList[i].license)) == tostring(license) or (tostring(BanList[i].playerip)) == tostring(playerip)) and (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then
			deletebanned(steamID)
		end
	
	end
	
end)








