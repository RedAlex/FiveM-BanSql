function cmdban(source, args)
	local target    = tonumber(args[1])
	local duree     = tonumber(args[2])
	local reason    = table.concat(args, " ",3)

	if args[1] then		
		if reason == "" then
			reason = Text.noreason
		end
		if target and target > 0 then
			local ping = GetPlayerPing(target)
			if duree and duree < 365 then
				local playerData = IdDataStorage[target]
				if playerData then
					local sourceplayername = ""
					if source ~= 0 then
						sourceplayername = tostring(GetPlayerName(source))
					else
						sourceplayername = "Console"
					end

					local permanent = (duree <= 0) and 1 or 0
					ban(source, playerData.license, playerData.identifier, playerData.liveid, playerData.xblid, playerData.discord, playerData.playerip, playerData.tokens, playerData.playername, sourceplayername, duree, reason, permanent)
				
					local currentPing = GetPlayerPing(target)
					if currentPing and currentPing > 0 then
						DropPlayer(target, (duree > 0 and Text.yourban or Text.yourpermban) .. reason)
					else
						TriggerEvent('bansql:sendMessage', source, Text.invalidid)
					end
				else
					TriggerEvent('bansql:sendMessage', source, Text.invalidid)
				end
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
			end	
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidid)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.cmdban)
	end
end

function cmdunban(source, args)
	if args[1] then
	local target = table.concat(args, " ")
	MySQL.Async.fetchAll('SELECT * FROM banlist WHERE targetplayername like @playername', 
	{
		['@playername'] = ("%"..target.."%")
	}, function(data)
		if data[1] then
			if #data > 1 then
				TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
				for i=1, #data, 1 do
					TriggerEvent('bansql:sendMessage', source, data[i].targetplayername)
				end
			else
				MySQL.Async.execute(
				'DELETE FROM banlist WHERE targetplayername = @name',
				{
				  ['@name']  = data[1].targetplayername
				},
					function ()
					loadBanList()
					if Config.EnableDiscordLink then
						local sourceplayername = ""
						if source ~= 0 then
							sourceplayername = tostring(GetPlayerName(source))
						else
							sourceplayername = "Console"
						end
						local message = (data[1].targetplayername .. Text.isunban .." ".. Text.by .." ".. sourceplayername)
						sendToDiscord(Config.webhookunban, message)
					end
					TriggerEvent('bansql:sendMessage', source, data[1].targetplayername .. Text.isunban)
				end)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidname)
		end

	end)
	else
		TriggerEvent('bansql:sendMessage', source, Text.invalidname)
	end
end

function cmdsearch(source, args)
	local target = table.concat(args, " ")
	if target ~= "" then
		MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE playername like @playername', 
		{
			['@playername'] = ("%"..target.."%")
		}, function(data)
			if data[1] then
				if #data < 50 then
					for i=1, #data, 1 do
						TriggerEvent('bansql:sendMessage', source, data[i].id.." "..data[i].playername)
					end
				else
					TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
				end
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidname)
			end
		end)
	else
		TriggerEvent('bansql:sendMessage', source, Text.invalidname)
	end
end

function cmdbanoffline(source, args)
	if args ~= "" then
		local target           = tonumber(args[1])
		local duree            = tonumber(args[2])
		local reason           = table.concat(args, " ",3)
		local sourceplayername = ""
		if source ~= 0 then
			sourceplayername = tostring(GetPlayerName(source))
		else
			sourceplayername = "Console"
		end

		if duree ~= "" then
			if target ~= "" then
				MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE id = @id', 
				{
					['@id'] = target
				}, function(data)
					if data[1] then
						if duree and duree < 365 then
							if reason == "" then
								reason = Text.noreason
							end
							local permanent = (duree <= 0) and 1 or 0
							local tokenTable = {}
							if data[1].tokens and data[1].tokens ~= "" then
								local ok, parsed = pcall(json.decode, data[1].tokens)
								if ok and type(parsed) == 'table' then
									tokenTable = parsed
								else
									for s in string.gmatch(tostring(data[1].tokens), "[^,]+") do
										table.insert(tokenTable, s)
									end
								end
							end
							ban(source,data[1].license,data[1].identifier,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,tokenTable,data[1].playername,sourceplayername,duree,reason,permanent)
						else
							TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
						end
					else
						TriggerEvent('bansql:sendMessage', source, Text.invalidid)
					end
				end)
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidname)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
			TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
	end
end

function cmdbanhistory(source, args)
	if args[1] and BanListHistory then
	local nombre = (tonumber(args[1]))
	local name   = table.concat(args, " ",1)
		if name ~= "" then
			if nombre and nombre > 0 then
				local expiration = BanListHistory[nombre].expiration
				local timeat     = BanListHistory[nombre].timeat
				local calcul1    = expiration - timeat
				local calcul2    = calcul1 / 86400
				local calcul2 	 = math.ceil(calcul2)
				local resultat   = tostring(BanListHistory[nombre].targetplayername.." , "..BanListHistory[nombre].sourceplayername.." , "..BanListHistory[nombre].reason.." , "..calcul2..Text.day.." , "..BanListHistory[nombre].added)

				TriggerEvent('bansql:sendMessage', source, (nombre .." : ".. resultat))
			else
				for i = 1, #BanListHistory, 1 do
					if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
						local expiration = BanListHistory[i].expiration
						local timeat     = BanListHistory[i].timeat
						local calcul1    = expiration - timeat
						local calcul2    = calcul1 / 86400
						local calcul2 	 = math.ceil(calcul2)					
						local resultat   = tostring(BanListHistory[i].targetplayername.." , "..BanListHistory[i].sourceplayername.." , "..BanListHistory[i].reason.." , "..calcul2..Text.day.." , "..BanListHistory[i].added)

						TriggerEvent('bansql:sendMessage', source, (i .." : ".. resultat))
					end
				end
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidname)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.cmdhistory)
	end
end

function sendToDiscord(canal,message)
	local DiscordWebHook = canal
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

function ban(source,license,identifier,liveid,xblid,discord,playerip,tokens,targetplayername,sourceplayername,duree,reason,permanent)
	MySQL.Async.fetchAll('SELECT * FROM banlist WHERE license = @license', 
	{
		['@license'] = (license)
	}, function(data)
		if not data[1] then
			local expiration = duree * 86400 --calcul total expiration (en secondes)
			local timeat     = os.time()
			local added      = os.date()

			if expiration < os.time() then
				expiration = os.time()+expiration
			end

			-- normalize tokens input into a table of tokens
			local tokenData = {}
			if type(tokens) == 'table' then
				tokenData = tokens
			elseif tokens and tokens ~= '' then
				local ok, parsed = pcall(json.decode, tokens)
				if ok and type(parsed) == 'table' then
					tokenData = parsed
				else
					for s in string.gmatch(tostring(tokens), "[^,]+") do
						table.insert(tokenData, s)
					end
				end
			end

			table.insert(BanList, {
				license    = license,
				identifier = identifier,
				liveid     = liveid,
				xblid      = xblid,
				discord    = discord,
				playerip   = playerip,
				tokens     = tokenData,
				reason     = reason,
				expiration = expiration,
				permanent  = permanent
			  })

			MySQL.Async.execute(
					'INSERT INTO banlist (license,identifier,liveid,xblid,discord,playerip,tokens,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@tokens,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
					{ 
					['@license']          = license,
					['@identifier']       = identifier,
					['@liveid']           = liveid,
					['@xblid']            = xblid,
					['@discord']          = discord,
					['@playerip']         = playerip,
					['@tokens']            = (tokenData and json.encode(tokenData) or nil),
					['@targetplayername'] = targetplayername,
					['@sourceplayername'] = sourceplayername,
					['@reason']           = reason,
					['@expiration']       = expiration,
					['@timeat']           = timeat,
					['@permanent']        = permanent,
					},
					function ()
			end)

			if permanent == 0 then
				TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.during .. duree .. Text.forr .. reason))
			else
				TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.permban .. reason))
			end

			if Config.EnableDiscordLink then
				local license1,identifier1,liveid1,xblid1,discord1,playerip1,token1,targetplayername1,sourceplayername1,message
				if not license          then license1          = "N/A" else license1          = license          end
				if not identifier       then identifier1       = "N/A" else identifier1       = identifier       end
				if not liveid           then liveid1           = "N/A" else liveid1           = liveid           end
				if not xblid            then xblid1            = "N/A" else xblid1            = xblid           end
				if not discord          then discord1          = "N/A" else discord1          = discord          end
				if not playerip         then playerip1         = "N/A" else playerip1         = playerip         end
				local token1 = "N/A"
				if tokenData and type(tokenData) == 'table' then
					token1 = json.encode(tokenData)
				elseif tokens and tokens ~= '' then
					token1 = tostring(tokens)
				end
				if not targetplayername then targetplayername1 = "N/A" else targetplayername1 = targetplayername end
				if not sourceplayername then sourceplayername1 = "N/A" else sourceplayername1 = sourceplayername end
				if permanent == 0 then
					message = (targetplayername1..Text.isban.." "..duree..Text.forr..reason.." "..Text.by.." "..sourceplayername1.."```"..identifier1.."\n"..license1.."\n"..liveid1.."\n"..xblid1.."\n"..discord1.."\n"..playerip1.."\n"..token1.."```")
				else
					message = (targetplayername1..Text.isban.." "..Text.permban..reason.." "..Text.by.." "..sourceplayername1.."```"..identifier1.."\n"..license1.."\n"..liveid1.."\n"..xblid1.."\n"..discord1.."\n"..playerip1.."\n"..token1.."```")
				end
				sendToDiscord(Config.webhookban, message)
			end

			MySQL.Async.execute(
					'INSERT INTO banlisthistory (license,identifier,liveid,xblid,discord,playerip,tokens,targetplayername,sourceplayername,reason,added,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@tokens,@targetplayername,@sourceplayername,@reason,@added,@expiration,@timeat,@permanent)',
					{ 
					['@license']          = license,
					['@identifier']       = identifier,
					['@liveid']           = liveid,
					['@xblid']            = xblid,
					['@discord']          = discord,
					['@playerip']         = playerip,
					['@tokens']            = (tokenData and json.encode(tokenData) or nil),
					['@targetplayername'] = targetplayername,
					['@sourceplayername'] = sourceplayername,
					['@reason']           = reason,
					['@added']            = added,
					['@expiration']       = expiration,
					['@timeat']           = timeat,
					['@permanent']        = permanent,
					},
					function ()
			end)
			
			BanListHistoryLoad = false
		else
			TriggerEvent('bansql:sendMessage', source, (targetplayername .. Text.alreadyban .. reason))
		end
	end)
end

function loadBanList()
	MySQL.Async.fetchAll(
		'SELECT * FROM banlist',
		{},
		function (data)
		  BanList = {}

		  for i=1, #data, 1 do
			local tokenData = {}
			if data[i].tokens and data[i].tokens ~= "" then
				local ok, parsed = pcall(json.decode, data[i].tokens)
				if ok and type(parsed) == 'table' then
					tokenData = parsed
				else
					for s in string.gmatch(tostring(data[i].tokens), "[^,]+") do
						table.insert(tokenData, s)
					end
				end
			end
			table.insert(BanList, {
				license    = data[i].license,
				identifier = data[i].identifier,
				liveid     = data[i].liveid,
				xblid      = data[i].xblid,
				discord    = data[i].discord,
				playerip   = data[i].playerip,
				tokens     = tokenData,
				reason     = data[i].reason,
				expiration = data[i].expiration,
				permanent  = data[i].permanent
			  })
		  end
	end)
end

function loadBanListHistory()
	MySQL.Async.fetchAll(
		'SELECT * FROM banlisthistory',
		{},
		function (data)
		  BanListHistory = {}

		  for i=1, #data, 1 do
			local tokenData = {}
			if data[i].tokens and data[i].tokens ~= "" then
				local ok, parsed = pcall(json.decode, data[i].tokens)
				if ok and type(parsed) == 'table' then
					tokenData = parsed
				else
					for s in string.gmatch(tostring(data[i].tokens), "[^,]+") do
						table.insert(tokenData, s)
					end
				end
			end
			table.insert(BanListHistory, {
				license          = data[i].license,
				identifier       = data[i].identifier,
				liveid           = data[i].liveid,
				xblid            = data[i].xblid,
				discord          = data[i].discord,
				playerip         = data[i].playerip,
				tokens           = tokenData,
				targetplayername = data[i].targetplayername,
				sourceplayername = data[i].sourceplayername,
				reason           = data[i].reason,
				added            = data[i].added,
				expiration       = data[i].expiration,
				permanent        = data[i].permanent,
				timeat           = data[i].timeat
			  })
		  end
	end)
end

function deletebanned(license) 
	MySQL.Async.execute(
		'DELETE FROM banlist WHERE license=@license',
		{
		  ['@license']  = license
		},
		function ()
			loadBanList()
	end)
end

function doublecheck(player)
	if GetPlayerIdentifiers(player) then
		local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"

		for k,v in ipairs(GetPlayerIdentifiers(player))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		local tokens = GetPlayerTokens(player) or {}

		for i = 1, #BanList, 1 do
						if 
									((tostring(BanList[i].license)) == tostring(license) 
								or (tostring(BanList[i].identifier)) == tostring(steamID) 
								or (tostring(BanList[i].liveid)) == tostring(liveid) 
								or (tostring(BanList[i].xblid)) == tostring(xblid) 
								or (tostring(BanList[i].discord)) == tostring(discord) 
								or (tostring(BanList[i].playerip)) == tostring(playerip)
								or (BanList[i].tokens and tokenStringContains(BanList[i].tokens, tokens))) 
		then

				if (tonumber(BanList[i].permanent)) == 1 then
					DropPlayer(player, Text.yourban .. BanList[i].reason)
					break

				elseif (tonumber(BanList[i].expiration)) > os.time() then

					local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
					if tempsrestant > 0 then
						DropPlayer(player, Text.yourban .. BanList[i].reason)
						break
					end

				elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

					deletebanned(license)
					break

				end
			end
		end
	end
end


function playerLoaded(source)
	CreateThread(function()
	Wait(5000)
		local license,steamID,liveid,xblid,discord,playerip
		local playername = tostring(GetPlayerName(source))

		for k,v in ipairs(GetPlayerIdentifiers(source))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		local tokens = GetPlayerTokens(source) or {}

		--Loading in memory until next server restart.
		IdDataStorage[source] = {
			license = license,
			identifier = steamID,
			liveid = liveid,
			xblid = xblid,
			discord = discord,
			playerip = playerip,
			tokens = tokens,
			playername = playername
		}

		MySQL.Async.fetchAll('SELECT * FROM `baninfo` WHERE `license` = @license', {
			['@license'] = license
		}, function(data)
		local found = false
			for i=1, #data, 1 do
				if data[i].license == license then
					found = true
				end
			end
			if not found then
				MySQL.Async.execute('INSERT INTO baninfo (license,identifier,liveid,xblid,discord,playerip,tokens,playername) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@tokens,@playername)', 
					{ 
					['@license']    = license,
					['@identifier'] = steamID,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@tokens']     = (tokens and json.encode(tokens) or nil),
					['@playername'] = playername
					},
					function ()
				end)
			else
				MySQL.Async.execute('UPDATE `baninfo` SET `identifier` = @identifier, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `tokens` = @tokens, `playername` = @playername WHERE `license` = @license', 
					{ 
					['@license']    = license,
					['@identifier'] = steamID,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@tokens']     = (tokens and json.encode(tokens) or nil),
					['@playername'] = playername
					},
					function ()
				end)
			end
		end)
		if Config.MultiServerSync then
			doublecheck(source)
		end
	end)
end

function cmdbanreload(source)
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
end

-- Check whether any token from player's tokens exists in the stored ban token table
function tokenStringContains(banTokenTable, playerTokens)
	if not banTokenTable or type(banTokenTable) ~= 'table' then return false end
	if not playerTokens or type(playerTokens) ~= 'table' then return false end
	for _, bt in ipairs(banTokenTable) do
		if bt and bt ~= '' then
			for _, pt in ipairs(playerTokens) do
				if pt and pt ~= '' and tostring(pt) == tostring(bt) then
					return true
				end
			end
		end
	end
	return false
end