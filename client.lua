RegisterNetEvent('BanSql:Respond')
AddEventHandler('BanSql:Respond', function()
	TriggerServerEvent("BanSql:CheckMe")
end)

local menuOpen = false
local currentToken = nil

local function setMenuState(open)
	menuOpen = open
	SetNuiFocus(open, open)
end

RegisterNetEvent('BanSql:UI:Open')
AddEventHandler('BanSql:UI:Open', function(payload)
	if not payload then
		return
	end

	currentToken = payload.token
	setMenuState(true)

	SendNUIMessage({
		action = 'openMenu',
		token = payload.token,
		texts = payload.texts or {}
	})
end)

RegisterNetEvent('BanSql:UI:PlayersResult')
AddEventHandler('BanSql:UI:PlayersResult', function(payload)
	SendNUIMessage({
		action = 'playersResult',
		requestId = payload and payload.requestId,
		success = payload and payload.success,
		message = payload and payload.message,
		results = payload and payload.results or {},
		hasMore = payload and payload.hasMore,
		nextOffset = payload and payload.nextOffset
	})
end)

RegisterNetEvent('BanSql:UI:HistoryResult')
AddEventHandler('BanSql:UI:HistoryResult', function(payload)
	SendNUIMessage({
		action = 'historyResult',
		requestId = payload and payload.requestId,
		success = payload and payload.success,
		message = payload and payload.message,
		results = payload and payload.results or {},
		hasMore = payload and payload.hasMore,
		nextOffset = payload and payload.nextOffset
	})
end)

RegisterNetEvent('BanSql:UI:BanResult')
AddEventHandler('BanSql:UI:BanResult', function(payload)
	SendNUIMessage({
		action = 'banResult',
		success = payload and payload.success,
		message = payload and payload.message
	})
end)

RegisterNetEvent('BanSql:UI:UnbanResult')
AddEventHandler('BanSql:UI:UnbanResult', function(payload)
	SendNUIMessage({
		action = 'unbanResult',
		success = payload and payload.success,
		message = payload and payload.message
	})
end)

RegisterNetEvent('BanSql:UI:Close')
AddEventHandler('BanSql:UI:Close', function()
	if menuOpen then
		setMenuState(false)
	end
	currentToken = nil
	SendNUIMessage({ action = 'closeMenu' })
end)

RegisterNUICallback('closeMenu', function(data, cb)
	if currentToken then
		TriggerServerEvent('BanSql:UI:CloseSession', currentToken)
	end
	currentToken = nil
	setMenuState(false)
	cb({ success = true })
end)

RegisterNUICallback('searchByName', function(data, cb)
	if not menuOpen then
		cb({ success = false })
		return
	end

	local hideSensitive = true
	if data and data.hideSensitive ~= nil then
		hideSensitive = data.hideSensitive
	end

	TriggerServerEvent('BanSql:UI:SearchByName', (data and data.token) or currentToken, data and data.requestId, data and data.query or "", data and data.offset or 0, hideSensitive)
	cb({ success = true })
end)

RegisterNUICallback('loadRecentPlayers', function(data, cb)
	if not menuOpen then
		cb({ success = false })
		return
	end

	local hideSensitive = true
	if data and data.hideSensitive ~= nil then
		hideSensitive = data.hideSensitive
	end

	TriggerServerEvent('BanSql:UI:RecentPlayers', (data and data.token) or currentToken, data and data.requestId, data and data.offset or 0, hideSensitive)
	cb({ success = true })
end)

RegisterNUICallback('loadBanHistory', function(data, cb)
	if not menuOpen then
		cb({ success = false })
		return
	end

	TriggerServerEvent('BanSql:UI:BanHistory', (data and data.token) or currentToken, data and data.requestId, data and data.offset or 0)
	cb({ success = true })
end)

RegisterNUICallback('submitBan', function(data, cb)
	if not menuOpen then
		cb({ success = false })
		return
	end

	TriggerServerEvent('BanSql:UI:CreateBan',
		(data and data.token) or currentToken,
		data and data.playerId,
		data and data.days,
		data and data.permanent,
		data and data.reason
	)
	cb({ success = true })
end)

RegisterNUICallback('unbanLicense', function(data, cb)
	if not menuOpen then
		cb({ success = false })
		return
	end

	TriggerServerEvent('BanSql:UI:UnbanLicense', (data and data.token) or currentToken, data and data.license or "")
	cb({ success = true })
end)

--Event Demo

--TriggerServerEvent("BanSql:ICheat")
--TriggerServerEvent("BanSql:ICheat", "Auto-Cheat Custom Reason")