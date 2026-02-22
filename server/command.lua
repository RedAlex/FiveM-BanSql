-- Command Registration for multiple frameworks
-- Uses framework detection from server/framework.lua
-- Supports: es_extended, qbx_core, qbox_core

-- Console Commands (Always available)
RegisterCommand("ban", function(source, args, raw)
    if source == 0 then
        cmdban(source, args)
    end
end, true)

RegisterCommand("unban", function(source, args, raw)
    if source == 0 then
        cmdunban(source, args)
    end
end, true)

RegisterCommand("banhistory", function(source, args, raw)
    if source == 0 then
        cmdbanhistory(source, args)
    end
end, true)

RegisterCommand("banreload", function(source, args, raw)
    if source == 0 then
        cmdbanreload(source)
    end
end, true)


function registerESXCommands()
    ESX.RegisterCommand('sqlbanmenu', Config.Permission, function(xPlayer, args, showError)
        openBanSqlUI(xPlayer.source)
    end, true, {help = 'Open BanSql UI', validate = false, arguments = {}})

    ESX.RegisterCommand('sqlban', Config.Permission, function(xPlayer, args, showError)
        local esxArgs = {args.id, args.day, args.reason}
        cmdban(xPlayer.source, esxArgs)
    end, true, {help = Lang:t('ban'), validate = true, arguments = {
        {name = "id", help = Lang:t('playeridhelp'), type = "number"},
        {name = "day", help = Lang:t('dayhelp'), type = "number"},
        {name = "reason", help = Lang:t('reason'), type = "string"}
    }})

    ESX.RegisterCommand('sqlunban', Config.Permission, function(xPlayer, args, showError)
        local esxArgs = {args.name}
        cmdunban(xPlayer.source, esxArgs)
    end, true, {help = Lang:t('unban'), validate = true, arguments = {
        {name = "name", help = Lang:t('steamname'), type = "string"}
    }})

    ESX.RegisterCommand('sqlbanhistory', Config.Permission, function(xPlayer, args, showError)
        local esxArgs = {args.name}
        cmdbanhistory(xPlayer.source, esxArgs)
    end, true, {help = Lang:t('history'), validate = true, arguments = {
        {name = "name", help = Lang:t('steamname'), type = "string"}
    }})

    ESX.RegisterCommand('sqlbanreload', Config.Permission, function(xPlayer, args, showError)
        cmdbanreload(xPlayer.source)
    end, true, {help = Lang:t('reload'), validate = false})
end

function registerQBXCommands(framework)
    local exports_name = (framework == 'qbox_core') and 'qbox_core' or 'qbx_core'

    exports[exports_name]:CreateCommand({
        name = 'sqlbanmenu',
        description = 'Open BanSql UI',
        permission = Config.Permission,
    }, function(source)
        openBanSqlUI(source)
    end)
    
    exports[exports_name]:CreateCommand({
        name = 'sqlban',
        description = Lang:t('ban'),
        permission = Config.Permission,
        params = {{name = "id"}, {name = "day", help = Lang:t('dayhelp')}, {name = "reason", help = Lang:t('reason')}},
    }, function(source, args)
        cmdban(source, args)
    end)

    exports[exports_name]:CreateCommand({
        name = 'sqlunban',
        description = Lang:t('unban'),
        permission = Config.Permission,
        params = {{name = "name", help = Lang:t('steamname')}},
    }, function(source, args)
        cmdunban(source, args)
    end)

    exports[exports_name]:CreateCommand({
        name = 'sqlbanhistory',
        description = Lang:t('history'),
        permission = Config.Permission,
        params = {{name = "name", help = Lang:t('steamname')}},
    }, function(source, args)
        cmdbanhistory(source, args)
    end)

    exports[exports_name]:CreateCommand({
        name = 'sqlbanreload',
        description = Lang:t('reload'),
        permission = Config.Permission,
    }, function(source)
        cmdbanreload(source)
    end)
end