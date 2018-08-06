local BanList = {}
local BanListHistory = {}



CreateThread(function()
    local AllListLoad = false

	loadBanList()
	loadBanListHistory()

	Wait(2000)
	  repeat
        if BanList ~= {} and BanListHistory ~= {} then
            print("La BanList et l'historique a ete charger avec succes")
            AllListLoad = true
        else
            print("ERROR : La BanList et l'historique n'a pas ete charger nouvelle tentative dans 5 seconde.")
            Wait(5000)
			loadBanListHistory()
			loadBanList()
        end
      until AllListLoad == true
end)


TriggerEvent('es:addGroupCommand', 'ban:load', "admin", function ()
  loadBanList()
  Wait(2000)
  if BanList ~= {} then
    TriggerClientEvent('chatMessage', source, "Banlist", {255, 0, 0}, "La liste a été avec succes")
    BanListLoad = true
  else
    TriggerClientEvent('chatMessage', source, "Banlist", {255, 0, 0}, "ERROR : La BanList n'a pas été charger.")
  end
end)

TriggerEvent('es:addGroupCommand', 'ban:history', "admin", function (source, args, user)
 if args[1] ~= nil and BanListHistory ~= {} then
	local nombre = (tonumber(args[1]))
    local name   = table.concat(args, " ",2)
	local noresult = 0
	
		for i = 1, #BanListHistory, 1 do
			if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
				noresult = noresult + 1
			end
		end
			if nombre < noresult then
				if nombre > 0 then
					local expiration = BanListHistory[nombre].expiration
					local timeat     = BanListHistory[nombre].timeat
					local calcul1    = expiration - timeat
					local calcul2    = calcul1 / 86400
					local calcul2 	 =  math.ceil(calcul2)
					local resultat = (tostring(BanListHistory[nombre].targetplayername)) .. " , " .. (tostring(BanListHistory[nombre].sourceplayername)) .. " , " .. (tostring(BanListHistory[nombre].reason)) .. " , " .. calcul2 .. " jours "
					
					TriggerClientEvent('chatMessage', source, "BanList " .. nombre .. " : ", {255, 0, 0}, resultat)
				elseif nombre == 0 then
					for i = 1, #BanListHistory, 1 do
						if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
							local expiration = BanListHistory[i].expiration
							local timeat     = BanListHistory[i].timeat
							local calcul1    = expiration - timeat
							local calcul2    = calcul1 / 86400
							local calcul2 	 =  math.ceil(calcul2)					
							local resultat = (tostring(BanListHistory[i].targetplayername)) .. " , " .. (tostring(BanListHistory[i].sourceplayername)) .. " , " .. (tostring(BanListHistory[i].reason)) .. " , " .. calcul2 .. " jours "
						
							TriggerClientEvent('chatMessage', source, "BanList " .. i .. " : ", {255, 0, 0}, resultat)
						end
					end
				end
			else
				TriggerClientEvent('chatMessage', source, "BanList : ", {255, 0, 0}, "Il n'y a pas autant de résultats !")
			end
 end
end)

TriggerEvent('es:addGroupCommand', 'ban:unban', "admin", function (source, args, user)
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
            TriggerClientEvent('chatMessage', source, "BanList", {255, 0, 0}, name .. " a été déban")
        else
            TriggerClientEvent('chatMessage', source, "BanList", {255, 0, 0}, "Le nom n'est pas valide")
        end
    end)
 end
end)

TriggerEvent('es:addGroupCommand', 'ban:add', "admin", function (source, args, user)
		local target = tonumber(args[1])
		local duree = tonumber(args[2])
		local reason = table.concat(args, " ",3)
		
		if reason == nil then
			reason="Aucune raison"
		end
		if target > 0 then
			local ping = GetPlayerPing(target)
        
			if ping > 0 then
				if duree < 365 then
					local sourceplayername = GetPlayerName(source)
					local targetplayername = GetPlayerName(target)
					local identifier = GetPlayerIdentifiers(target)[1]
				
					if duree > 0 then
						ban(source,target,identifier,targetplayername,sourceplayername,duree,reason)
						DropPlayer(target, "Vous avez ete ban pour " .. reason)
					else
						permban(source,target,identifier,targetplayername,sourceplayername,duree,reason)
						DropPlayer(target, "Vous avez ete ban permanant pour " .. reason)
					end
				
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Duree du ban incorrecte' } } )
				end	
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'ID du joueur incorrect' } } )
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'ID du joueur incorrect' } } )
		end
end)



function ban(source,target,identifier,targetplayername,sourceplayername,duree,reason)
--calcul total expiration (en secondes)
	local expiration = duree * 86400
	local timeat = os.time()
	
	if expiration < os.time() then
		expiration = os.time()+expiration
	end
	
		MySQL.Async.execute(
                'INSERT INTO banlist (identifier,targetplayername,sourceplayername,reason,expiration,timeat) VALUES (@identifier,@targetplayername,@sourceplayername,@reason,@expiration,@timeat)',
                { 
				['@identifier']       = identifier,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = expiration,
				['@timeat']           = os.time(),
				},
				function ()
				end)
					TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Vous avez banni : ' .. targetplayername .. ' pendant ' .. duree .. ' jours parce que ' .. reason } } )
					Wait(1000)
					loadBanList()
				
		MySQL.Async.execute(
                'INSERT INTO banlisthistory (identifier,targetplayername,sourceplayername,reason,expiration,timeat) VALUES (@identifier,@targetplayername,@sourceplayername,@reason,@expiration,@timeat)',
                { 
				['@identifier']       = identifier,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = expiration,
				['@timeat']           = os.time(),
				},
				function ()
				end)
				Wait(1000)
				loadBanListHistory()			
end

function permban(source,target,identifier,targetplayername,sourceplayername,duree,reason)
	
	MySQL.Async.execute(
                'INSERT INTO banlist (identifier,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@identifier,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                { 
				['@identifier']       = identifier,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = 1,
				['@timeat']           = os.time(),
				['@permanent']        = 1,
				},
				function()
				end)
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Vous avez banni : ' .. targetplayername .. ' de facon permanente parce que ' .. reason } } )
				Wait(1000)
				loadBanList()

				
	MySQL.Async.execute(
                'INSERT INTO banlisthistory (identifier,targetplayername,sourceplayername,reason,expiration,timeat.permanent) VALUES (@identifier,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                { 
				['@identifier']       = identifier,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = 1,
				['@timeat']           = os.time(),
				['@permanent']        = 1,
				},
				function()
				end)
				Wait(1000)
				loadBanListHistory()
end

function loadBanList()
  MySQL.Async.fetchAll(
    'SELECT * FROM banlist',
    {},
    function (identifiers)
      BanList = {}

      for i=1, #identifiers, 1 do
        table.insert(BanList, {
			identifier  = identifiers[i].identifier,
			reason      = identifiers[i].reason,
			expiration  = identifiers[i].expiration,
			permanent   = identifiers[i].permanent
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
    local steamID = GetPlayerIdentifiers(source)[1]
	
	--Si Banlist pas chargée
	if (Banlist == {}) then
		Citizen.Wait(1000)
	end

    if steamID == false then
		setKickReason("Vous devez ouvrir steam !")
		CancelEvent()
    end
	
	for i = 1, #BanList, 1 do
		if (tostring(BanList[i].identifier)) == tostring(steamID) and (tonumber(BanList[i].expiration)) > os.time() and (tonumber(BanList[i].permanent)) == 0 then
			local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = (day - math.floor(day)) * 24
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason("Vous etes banni pour : " .. BanList[i].reason .. ". Il reste : " .. txtday .. " Jours " ..txthrs .. " Heures " ..txtminutes .. " Minutes ")
						CancelEvent()
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = tempsrestant / 60
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason("Vous etes banni pour : " .. BanList[i].reason .. ". Il reste : " .. txtday .. " Jours " .. txthrs .. " Heures " .. txtminutes .. " Minutes ")
						CancelEvent()
				elseif tempsrestant < 60 then
					local txtday     = 0
					local txthrs     = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason("Vous etes banni pour : " .. BanList[i].reason .. ". Il reste : " .. txtday .. " Jours " .. txthrs .. " Heures " .. txtminutes .. " Minutes ")
						CancelEvent()
				end
		end
	
		if (tostring(BanList[i].identifier)) == tostring(steamID) and (tonumber(BanList[i].permanent)) == 1 then
			setKickReason("Vous etes banni parce que " .. BanList[i].reason .. " de facon permanente, contactez un admin pour plus d'infos")
			CancelEvent()
		end
	
		if (tostring(BanList[i].identifier)) == tostring(steamID) and (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then
			deletebanned(steamID)
		end
	
		break
	end
	
end)








