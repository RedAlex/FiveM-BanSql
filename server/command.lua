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

RegisterCommand("search", function(source, args, raw)
    if source == 0 then
        cmdsearch(source, args)
    end
end, true)

RegisterCommand("banoffline", function(source, args, raw)
    if source == 0 then
        cmdbanoffline(source, args)
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
    ESX.RegisterCommand('sqlban', Config.Permission, function(xPlayer, args, showError)
        local esxArgs = {args.id, args.day, args.reason}
        cmdban(xPlayer.source, esxArgs)
    end, true, {help = Text.ban, validate = true, arguments = {
        {name = "id", help = "ID du joueur", type = "number"},
        {name = "day", help = Text.dayhelp, type = "number"},
        {name = "reason", help = Text.reason, type = "string"}
    }})

    ESX.RegisterCommand('sqlunban', Config.Permission, function(xPlayer, args, showError)
        local esxArgs = {args.name}
        cmdunban(xPlayer.source, esxArgs)
    end, true, {help = Text.unban, validate = true, arguments = {
        {name = "name", help = Text.steamname, type = "string"}
    }})

    ESX.RegisterCommand('sqlsearch', Config.Permission, function(xPlayer, args, showError)
        local esxArgs = {args.name}
        cmdsearch(xPlayer.source, esxArgs)
    end, true, {help = Text.bansearch, validate = false, arguments = {
        {name = "name", help = Text.steamname, type = "string"}
    }})

    ESX.RegisterCommand('sqlbanoffline', Config.Permission, function(xPlayer, args, showError)
        local esxArgs = {args.permid, args.day, args.reason}
        cmdbanoffline(xPlayer.source, esxArgs)
    end, true, {help = Text.banoff, validate = true, arguments = {
        {name = "permid", help = Text.permid, type = "number"},
        {name = "day", help = Text.dayhelp, type = "number"},
        {name = "reason", help = Text.reason, type = "string"}
    }})

    ESX.RegisterCommand('sqlbanhistory', Config.Permission, function(xPlayer, args, showError)
        local esxArgs = {args.name}
        cmdbanhistory(xPlayer.source, esxArgs)
    end, true, {help = Text.history, validate = true, arguments = {
        {name = "name", help = Text.steamname, type = "string"}
    }})

    ESX.RegisterCommand('sqlbanreload', Config.Permission, function(xPlayer, args, showError)
        cmdbanreload(xPlayer.source)
    end, true, {help = Text.reload, validate = false})
end

function registerQBXCommands(framework)
    local exports_name = (framework == 'qbox_core') and 'qbox_core' or 'qbx_core'
    
    exports[exports_name]:CreateCommand({
        name = 'sqlban',
        description = Text.ban,
        permission = Config.Permission,
        params = {{name = "id"}, {name = "day", help = Text.dayhelp}, {name = "reason", help = Text.reason}},
    }, function(source, args)
        cmdban(source, args)
    end)

    exports[exports_name]:CreateCommand({
        name = 'sqlunban',
        description = Text.unban,
        permission = Config.Permission,
        params = {{name = "name", help = Text.steamname}},
    }, function(source, args)
        cmdunban(source, args)
    end)

    exports[exports_name]:CreateCommand({
        name = 'sqlsearch',
        description = Text.bansearch,
        permission = Config.Permission,
        params = {{name = "name", help = Text.steamname}},
    }, function(source, args)
        cmdsearch(source, args)
    end)

    exports[exports_name]:CreateCommand({
        name = 'sqlbanoffline',
        description = Text.banoff,
        permission = Config.Permission,
        params = {{name = "permid", help = Text.permid}, {name = "day", help = Text.dayhelp}, {name = "reason", help = Text.reason}},
    }, function(source, args)
        cmdbanoffline(source, args)
    end)

    exports[exports_name]:CreateCommand({
        name = 'sqlbanhistory',
        description = Text.history,
        permission = Config.Permission,
        params = {{name = "name", help = Text.steamname}},
    }, function(source, args)
        cmdbanhistory(source, args)
    end)

    exports[exports_name]:CreateCommand({
        name = 'sqlbanreload',
        description = Text.reload,
        permission = Config.Permission,
    }, function(source)
        cmdbanreload(source)
    end)
end