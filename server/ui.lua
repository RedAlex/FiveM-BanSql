local uiSessions = {}
local UI_PAGE_SIZE = 20

local function trim(value)
    if not value then
        return ""
    end
    return tostring(value):gsub("^%s+", ""):gsub("%s+$", "")
end

local function createToken(source)
    local randomPart = math.random(100000, 999999)
    return string.format("%s:%s:%s", source, GetGameTimer(), randomPart)
end

local function isSessionValid(source, token)
    local session = uiSessions[source]
    if not session then
        return false
    end
    if not token or tostring(token) ~= tostring(session.token) then
        return false
    end
    if os.time() - session.createdAt > 900 then
        uiSessions[source] = nil
        return false
    end
    return true
end

local function formatDate(ts)
    local n = tonumber(ts) or 0
    if n <= 0 then
        return "N/A"
    end
    return os.date("%Y-%m-%d %H:%M:%S", n)
end

local function toBanInfoResult(row, hideSensitive)
    local result = {
        id = row.id,
        playername = row.playername,
        last_modified_at = tonumber(row.last_modified_at) or 0,
        last_modified_label = formatDate(row.last_modified_at)
    }

    if not hideSensitive then
        result.license = row.license
        result.steamid = row.steamid
        result.fivemid = row.fivemid
        result.liveid = row.liveid
        result.xblid = row.xblid
        result.discord = row.discord
        result.playerip = row.playerip
        result.tokens = row.tokens
    end

    return result
end

local function sendPlayersResult(source, requestId, rawRows, hideSensitive, offset)
    local rows = rawRows or {}
    local hasMore = #rows > UI_PAGE_SIZE
    local limitedRows = {}

    for i = 1, math.min(#rows, UI_PAGE_SIZE) do
        limitedRows[#limitedRows + 1] = toBanInfoResult(rows[i], hideSensitive)
    end

    TriggerClientEvent('BanSql:UI:PlayersResult', source, {
        requestId = requestId,
        success = true,
        results = limitedRows,
        hasMore = hasMore,
        nextOffset = (tonumber(offset) or 0) + #limitedRows
    })
end

local function runBanInfoQuery(source, requestId, query, params, hideSensitive, offset)
    MySQL.Async.fetchAll(query, params, function(data)
        sendPlayersResult(source, requestId, data, hideSensitive, offset)
    end)
end

function openBanSqlUI(source)
    if source == 0 then
        return
    end

    local token = createToken(source)
    uiSessions[source] = {
        token = token,
        createdAt = os.time()
    }

    TriggerClientEvent('BanSql:UI:Open', source, {
        token = token,
        texts = {
            title = "BanSql Admin",
            hideSensitive = "Masqué les informations confidentiel",
            page1Title = "Choix de l'action",
            searchByName = "Recherche par steamname",
            searchPlaceholder = "Steamname...",
            searchButton = "Search",
            lastConnectedButton = "Affiché les derniere joueurs connecté",
            historyButton = "Affichage de l'historique de ban",
            page2Title = "Résultats",
            continueSearch = "Continuer les recherche",
            banButton = "Ban",
            page3Title = "Historique de ban",
            stillBanned = "Toujours banni",
            notBanned = "Non banni",
            unbanButton = "Déban",
            page4Title = "Arguments du ban",
            dayLabel = "Nombre de jours",
            permanentLabel = "Permanent",
            reasonLabel = "Raison",
            nextButton = "Continuer",
            page5Title = "Confirmation",
            confirmButton = "Confirmer",
            backButton = "Retour",
            closeButton = "Fermer",
            invalidSession = Lang:t('ui_invalid_session'),
            invalidName = Lang:t('invalidname'),
            invalidId = Lang:t('invalidid'),
            invalidTime = Lang:t('invalidtime'),
            noReason = Lang:t('noreason'),
            noResults = Lang:t('noresult'),
            loading = "Chargement..."
        }
    })
end

RegisterNetEvent('BanSql:UI:CloseSession')
AddEventHandler('BanSql:UI:CloseSession', function(token)
    if isSessionValid(source, token) then
        uiSessions[source] = nil
    end
end)

RegisterNetEvent('BanSql:UI:SearchByName')
AddEventHandler('BanSql:UI:SearchByName', function(token, requestId, playerName, offset, hideSensitive)
    if not isSessionValid(source, token) then
        TriggerClientEvent('BanSql:UI:PlayersResult', source, {
            requestId = requestId,
            success = false,
            message = Lang:t('ui_invalid_session')
        })
        return
    end

    local target = trim(playerName)
    local pageOffset = tonumber(offset) or 0
    local hide = hideSensitive == true

    if target == "" then
        TriggerClientEvent('BanSql:UI:PlayersResult', source, {
            requestId = requestId,
            success = false,
            message = Lang:t('invalidname')
        })
        return
    end

    runBanInfoQuery(
        source,
        requestId,
        'SELECT * FROM baninfo WHERE LOWER(playername) LIKE LOWER(@playername) ORDER BY last_modified_at DESC, id DESC LIMIT @limit OFFSET @offset',
        {
            ['@playername'] = ("%" .. target .. "%"),
            ['@limit'] = UI_PAGE_SIZE + 1,
            ['@offset'] = pageOffset
        },
        hide,
        pageOffset
    )
end)

RegisterNetEvent('BanSql:UI:RecentPlayers')
AddEventHandler('BanSql:UI:RecentPlayers', function(token, requestId, offset, hideSensitive)
    if not isSessionValid(source, token) then
        TriggerClientEvent('BanSql:UI:PlayersResult', source, {
            requestId = requestId,
            success = false,
            message = Lang:t('ui_invalid_session')
        })
        return
    end

    local pageOffset = tonumber(offset) or 0
    local hide = hideSensitive == true

    runBanInfoQuery(
        source,
        requestId,
        'SELECT * FROM baninfo ORDER BY last_modified_at DESC, id DESC LIMIT @limit OFFSET @offset',
        {
            ['@limit'] = UI_PAGE_SIZE + 1,
            ['@offset'] = pageOffset
        },
        hide,
        pageOffset
    )
end)

RegisterNetEvent('BanSql:UI:BanHistory')
AddEventHandler('BanSql:UI:BanHistory', function(token, requestId, offset)
    if not isSessionValid(source, token) then
        TriggerClientEvent('BanSql:UI:HistoryResult', source, {
            requestId = requestId,
            success = false,
            message = Lang:t('ui_invalid_session')
        })
        return
    end

    local cbSource = source -- capture la valeur de source
    local pageOffset = tonumber(offset) or 0

    MySQL.Async.fetchAll(
        'SELECT h.id, h.license, h.targetplayername, h.sourceplayername, h.reason, h.added, h.timeat, h.expiration, h.permanent, b.license AS active_license, b.expiration AS active_expiration, b.permanent AS active_permanent '
        .. 'FROM banlisthistory h '
        .. 'LEFT JOIN banlist b ON b.license = h.license '
        .. 'ORDER BY h.timeat DESC, h.id DESC '
        .. 'LIMIT @limit OFFSET @offset',
    {
        ['@limit'] = UI_PAGE_SIZE + 1,
        ['@offset'] = pageOffset
    }, function(data)
        local rows = data or {}
        local hasMore = #rows > UI_PAGE_SIZE
        local limited = {}

        for i = 1, math.min(#rows, UI_PAGE_SIZE) do
            local row = rows[i]
            local active = false
            if row.active_license then
                local activePermanent = tonumber(row.active_permanent) == 1
                local activeExpiration = tonumber(row.active_expiration) or 0
                active = activePermanent or activeExpiration > os.time()
            end

            limited[#limited + 1] = {
                id = row.id,
                license = row.license,
                targetplayername = row.targetplayername,
                sourceplayername = row.sourceplayername,
                reason = row.reason,
                added = row.added,
                timeat = tonumber(row.timeat) or 0,
                timeat_label = formatDate(row.timeat),
                expiration = tonumber(row.expiration) or 0,
                permanent = tonumber(row.permanent) == 1,
                isActive = active
            }
        end

        TriggerClientEvent('BanSql:UI:HistoryResult', cbSource, {
            requestId = requestId,
            success = true,
            results = limited,
            hasMore = hasMore,
            nextOffset = pageOffset + #limited
        })
    end)
end)

RegisterNetEvent('BanSql:UI:CreateBan')
AddEventHandler('BanSql:UI:CreateBan', function(token, playerId, days, permanent, reason)
    local adminSource = source

    if not isSessionValid(adminSource, token) then
        TriggerClientEvent('BanSql:UI:BanResult', adminSource, {
            success = false,
            message = Lang:t('ui_invalid_session')
        })
        return
    end

    local targetId = tonumber(playerId)
    local isPermanent = permanent == true
    local duration = tonumber(days)
    local cleanReason = trim(reason)

    if not targetId or targetId <= 0 then
        TriggerClientEvent('BanSql:UI:BanResult', adminSource, {
            success = false,
            message = Lang:t('invalidid')
        })
        return
    end

    if isPermanent then
        duration = 0
    end

    if not duration or duration < 0 or duration >= 365 then
        TriggerClientEvent('BanSql:UI:BanResult', adminSource, {
            success = false,
            message = Lang:t('invalidtime')
        })
        return
    end

    if cleanReason == "" then
        cleanReason = Lang:t('noreason')
    end

    MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE id = @id', {
        ['@id'] = targetId
    }, function(data)
        if not data or not data[1] then
            TriggerClientEvent('BanSql:UI:BanResult', adminSource, {
                success = false,
                message = Lang:t('invalidid')
            })
            return
        end

        local sourceplayername = GetPlayerName(adminSource)
        if not sourceplayername or sourceplayername == "" then
            TriggerClientEvent('BanSql:UI:BanResult', adminSource, {
                success = false,
                message = Lang:t('invalidid')
            })
            return
        end

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

        local permanentFlag = (duration <= 0) and 1 or 0
        ban(adminSource, data[1].license, data[1].steamid, data[1].fivemid, data[1].liveid, data[1].xblid, data[1].discord, data[1].playerip, tokenTable, data[1].playername, sourceplayername, duration, cleanReason, permanentFlag)

        TriggerClientEvent('BanSql:UI:BanResult', adminSource, {
            success = true,
            message = Lang:t('ui_ban_sent')
        })
    end)
end)

RegisterNetEvent('BanSql:UI:UnbanLicense')
AddEventHandler('BanSql:UI:UnbanLicense', function(token, license)
    if not isSessionValid(source, token) then
        TriggerClientEvent('BanSql:UI:UnbanResult', source, {
            success = false,
            message = Lang:t('ui_invalid_session')
        })
        return
    end

    local cleanLicense = trim(license)
    if cleanLicense == "" then
        TriggerClientEvent('BanSql:UI:UnbanResult', source, {
            success = false,
            message = Lang:t('invalidid')
        })
        return
    end

    MySQL.Async.execute('DELETE FROM banlist WHERE license = @license', {
        ['@license'] = cleanLicense
    }, function(changed)
        if changed and changed > 0 then
            loadBanList()
            TriggerClientEvent('BanSql:UI:UnbanResult', source, {
                success = true,
                message = Lang:t('isunban')
            })
        else
            TriggerClientEvent('BanSql:UI:UnbanResult', source, {
                success = false,
                message = Lang:t('invalidid')
            })
        end
    end)
end)

AddEventHandler('playerDropped', function()
    uiSessions[source] = nil
end)
