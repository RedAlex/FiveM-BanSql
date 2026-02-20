function cmdban(source, args)
	local target    = tonumber(args[1])
	local duree     = tonumber(args[2])
	local reason    = table.concat(args, " ",3)

	if args[1] then		
		if reason == "" then
			reason = Lang:t('noreason')
		end
		if target and target > 0 then
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
					ban(source, playerData.license, playerData.steamid, playerData.fivemid, playerData.liveid, playerData.xblid, playerData.discord, playerData.playerip, playerData.tokens, playerData.playername, sourceplayername, duree, reason, permanent)

					local currentPing = GetPlayerPing(target)
					if currentPing and currentPing > 0 then
						DropPlayer(target, (duree > 0 and Lang:t('yourban') or Lang:t('yourpermban')) .. reason)
					else
						
						TriggerEvent('bansql:sendMessage', source, Lang:t('invalidid'))
					end
				else
					TriggerEvent('bansql:sendMessage', source, Lang:t('invalidid'))
				end
			else
				TriggerEvent('bansql:sendMessage', source, Lang:t('invalidtime'))
			end	
		else
			TriggerEvent('bansql:sendMessage', source, Lang:t('invalidid'))
		end
	else
		TriggerEvent('bansql:sendMessage', source, Lang:t('cmdban'))
	end
end

function cmdunban(source, args)
	if args[1] then
	local target = table.concat(args, " ")
	MySQL.Async.fetchAll('SELECT * FROM banlist WHERE LOWER(targetplayername) LIKE LOWER(@playername)', 
	{
		['@playername'] = ("%"..target.."%")
	}, function(data)
		if data[1] then
			if #data > 1 then
				TriggerEvent('bansql:sendMessage', source, Lang:t('toomanyresult'))
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
						if Config.DiscordWebhook and tostring(Config.DiscordWebhook) ~= "" then
						local sourceplayername = ""
						if source ~= 0 then
							sourceplayername = tostring(GetPlayerName(source))
						else
							sourceplayername = "Console"
						end
					local message = (data[1].targetplayername .. Lang:t('isunban') .." ".. Lang:t('by') .." ".. sourceplayername)
					sendToDiscord(Config.DiscordWebhook, message)
				end
				TriggerEvent('bansql:sendMessage', source, data[1].targetplayername .. Lang:t('isunban'))
				end)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Lang:t('invalidname'))
		end

	end)
	else
		TriggerEvent('bansql:sendMessage', source, Lang:t('invalidname'))
	end
end

function cmdsearch(source, args)
	local target = table.concat(args, " ")
	if target ~= "" then
		MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE LOWER(playername) LIKE LOWER(@playername)', 
		{
			['@playername'] = ("%"..target.."%")
		}, function(data)
			if data[1] then
				if #data < 50 then
					for i=1, #data, 1 do
						TriggerEvent('bansql:sendMessage', source, data[i].id.." "..data[i].playername)
					end
				else
					TriggerEvent('bansql:sendMessage', source, Lang:t('toomanyresult'))
				end
			else
				TriggerEvent('bansql:sendMessage', source, Lang:t('invalidname'))
			end
		end)
	else
		TriggerEvent('bansql:sendMessage', source, Lang:t('invalidname'))
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
								reason = Lang:t('noreason')
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
						ban(source,data[1].license,data[1].steamid,data[1].fivemid,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,tokenTable,data[1].playername,sourceplayername,duree,reason,permanent)
						else
							TriggerEvent('bansql:sendMessage', source, Lang:t('invalidtime'))
						end
					else
						TriggerEvent('bansql:sendMessage', source, Lang:t('invalidid'))
					end
				end)
			else
				TriggerEvent('bansql:sendMessage', source, Lang:t('invalidname'))
			end
		else
			TriggerEvent('bansql:sendMessage', source, Lang:t('invalidtime'))
			TriggerEvent('bansql:sendMessage', source, Lang:t('cmdbanoff'))
		end
	else
		TriggerEvent('bansql:sendMessage', source, Lang:t('cmdbanoff'))
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
				local resultat   = tostring(BanListHistory[nombre].targetplayername.." , "..BanListHistory[nombre].sourceplayername.." , "..BanListHistory[nombre].reason.." , "..calcul2..Lang:t('day').." , "..BanListHistory[nombre].added)

				TriggerEvent('bansql:sendMessage', source, (nombre .." : ".. resultat))
			else
				for i = 1, #BanListHistory, 1 do
					if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
						local expiration = BanListHistory[i].expiration
						local timeat     = BanListHistory[i].timeat
						local calcul1    = expiration - timeat
						local calcul2    = calcul1 / 86400
						local calcul2 	 = math.ceil(calcul2)					
						local resultat   = tostring(BanListHistory[i].targetplayername.." , "..BanListHistory[i].sourceplayername.." , "..BanListHistory[i].reason.." , "..calcul2..Lang:t('day').." , "..BanListHistory[i].added)
						TriggerEvent('bansql:sendMessage', source, (i .." : ".. resultat))
					end
				end
			end
		else
			TriggerEvent('bansql:sendMessage', source, Lang:t('invalidname'))
		end
	else
		TriggerEvent('bansql:sendMessage', source, Lang:t('cmdhistory'))
	end
end

function sendToDiscord(canal,message)
	local DiscordWebHook = canal
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

function ban(source,license,steamid,fivemid,liveid,xblid,discord,playerip,tokens,targetplayername,sourceplayername,duree,reason,permanent)
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
				steamid    = steamid,
				fivemid    = fivemid,
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
					'INSERT INTO banlist (license,steamid,fivemid,liveid,xblid,discord,playerip,tokens,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@license,@steamid,@fivemid,@liveid,@xblid,@discord,@playerip,@tokens,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
					{ 
					['@license']          = license,
					['@steamid']          = steamid,
					['@fivemid']          = fivemid,
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
			TriggerEvent('bansql:sendMessage', source, (Lang:t('youban') .. targetplayername .. Lang:t('during') .. duree .. Lang:t('forr') .. reason))
		else
			TriggerEvent('bansql:sendMessage', source, (Lang:t('youban') .. targetplayername .. Lang:t('permban') .. reason))

			if Config.DiscordWebhook and tostring(Config.DiscordWebhook) ~= "" then
				local license1,steamid1,fivemid1,liveid1,xblid1,discord1,playerip1,token1,targetplayername1,sourceplayername1,message
				if not license          then license1          = "N/A" else license1          = license          end
				if not steamid          then steamid1         = "N/A" else steamid1         = steamid          end
				if not fivemid          then fivemid1         = "N/A" else fivemid1         = fivemid          end
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
				message = (targetplayername1..Lang:t('isban').." "..duree..Lang:t('forr')..reason.." "..Lang:t('by').." "..sourceplayername1.."```"..steamid1.."\n"..fivemid1.."\n"..license1.."\n"..liveid1.."\n"..xblid1.."\n"..discord1.."\n"..playerip1.."\n"..token1.."```")
			else
				message = (targetplayername1..Lang:t('isban').." "..Lang:t('permban')..reason.." "..Lang:t('by').." "..sourceplayername1.."```"..steamid1.."\n"..fivemid1.."\n"..license1.."\n"..liveid1.."\n"..xblid1.."\n"..discord1.."\n"..playerip1.."\n"..token1.."```")
				end
				sendToDiscord(Config.DiscordWebhook, message)
			end

			MySQL.Async.execute(
					'INSERT INTO banlisthistory (license,steamid,fivemid,liveid,xblid,discord,playerip,tokens,targetplayername,sourceplayername,reason,added,expiration,timeat,permanent) VALUES (@license,@steamid,@fivemid,@liveid,@xblid,@discord,@playerip,@tokens,@targetplayername,@sourceplayername,@reason,@added,@expiration,@timeat,@permanent)',
					{ 
					['@license']          = license,
					['@steamid']          = steamid,
					['@fivemid']          = fivemid,
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
			TriggerEvent('bansql:sendMessage', source, (targetplayername .. Lang:t('alreadyban') .. reason))
		end
	end)

		Citizen.CreateThread(function()
			Wait(100) -- small delay to ensure IdDataStorage is populated for recent joins
			for _, pid in ipairs(GetPlayers()) do
				local psrc = tonumber(pid)
				local pdata = IdDataStorage[psrc]
				if pdata then
					if tostring(pdata.license) == tostring(license)
					or tostring(pdata.steamid) == tostring(steamid)
					or tostring(pdata.fivemid) == tostring(fivemid)
					or tostring(pdata.liveid) == tostring(liveid)
					or tostring(pdata.xblid) == tostring(xblid)
					or tostring(pdata.discord) == tostring(discord)
					or (tokenData and pdata.tokens and tokenStringContains(tokenData, pdata.tokens)) then
						local ping = GetPlayerPing(psrc)
						if ping and ping > 0 then
							DropPlayer(psrc, (permanent == 1 and Lang:t('yourpermban') or Lang:t('yourban')) .. reason)
						end
						break
					end
				end
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
				steamid    = data[i].steamid,
				fivemid    = data[i].fivemid,
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
				steamid          = data[i].steamid,
				fivemid          = data[i].fivemid,
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
		local license,steamid,fivemid,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a","n/a"

		for _, v in ipairs(GetPlayerIdentifiers(player))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamid = v
			elseif string.sub(v, 1, string.len("fivem:")) == "fivem:" then
				fivemid = v
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
								or (tostring(BanList[i].steamid)) == tostring(steamid) 
								or (tostring(BanList[i].fivemid)) == tostring(fivemid) 
								or (tostring(BanList[i].liveid)) == tostring(liveid) 
								or (tostring(BanList[i].xblid)) == tostring(xblid) 
								or (tostring(BanList[i].discord)) == tostring(discord) 
								or (tostring(BanList[i].playerip)) == tostring(playerip)
								or (BanList[i].tokens and tokenStringContains(BanList[i].tokens, tokens))) 
		then

				if (tonumber(BanList[i].permanent)) == 1 then
					DropPlayer(player, Lang:t('yourban') .. BanList[i].reason)
					break
				elseif (tonumber(BanList[i].expiration)) > os.time() then

					local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
					if tempsrestant > 0 then
					DropPlayer(player, Lang:t('yourban') .. BanList[i].reason)
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
		local license,steamid,fivemid,liveid,xblid,discord,playerip
		local playername = tostring(GetPlayerName(source))

		for _, v in ipairs(GetPlayerIdentifiers(source))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamid = v
			elseif string.sub(v, 1, string.len("fivem:")) == "fivem:" then
				fivemid = v
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
			steamid = steamid,
			fivemid = fivemid,
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
				MySQL.Async.execute('INSERT INTO baninfo (license,steamid,fivemid,liveid,xblid,discord,playerip,tokens,playername) VALUES (@license,@steamid,@fivemid,@liveid,@xblid,@discord,@playerip,@tokens,@playername)', 
					{ 
					['@license']    = license,
					['@steamid']    = steamid,
					['@fivemid']    = fivemid,
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
				MySQL.Async.execute('UPDATE `baninfo` SET `steamid` = @steamid, `fivemid` = @fivemid, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `tokens` = @tokens, `playername` = @playername WHERE `license` = @license', 
					{ 
					['@license']    = license,
					['@steamid']    = steamid,
					['@fivemid']    = fivemid,
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
		TriggerEvent('bansql:sendMessage', source, Lang:t('banlistloaded'))
		if BanListHistoryLoad == true then
			TriggerEvent('bansql:sendMessage', source, Lang:t('historyloaded'))
		end
	else
		TriggerEvent('bansql:sendMessage', source, Lang:t('loaderror'))
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