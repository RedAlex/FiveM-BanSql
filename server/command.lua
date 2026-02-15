-- Command Registration for multiple frameworks
-- Uses framework detection from server/framework.lua
-- Supports: es_extended, qbx_core, qbox_core

local function registerCommands()
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
        cmdban(xPlayer.source, args)
    end, {help = Text.ban, params = {{name = "id"}, {name = "day", help = Text.dayhelp}, {name = "reason", help = Text.reason}}})

    ESX.RegisterCommand('sqlunban', Config.Permission, function(xPlayer, args, showError)
        cmdunban(xPlayer.source, args)
    end, {help = Text.unban, params = {{name = "name", help = Text.steamname}}})

    ESX.RegisterCommand('sqlsearch', Config.Permission, function(xPlayer, args, showError)
        cmdsearch(xPlayer.source, args)
    end, {help = Text.bansearch, params = {{name = "name", help = Text.steamname}}})

    ESX.RegisterCommand('sqlbanoffline', Config.Permission, function(xPlayer, args, showError)
        cmdbanoffline(xPlayer.source, args)
    end, {help = Text.banoff, params = {{name = "permid", help = Text.permid}, {name = "day", help = Text.dayhelp}, {name = "reason", help = Text.reason}}})

    ESX.RegisterCommand('sqlbanhistory', Config.Permission, function(xPlayer, args, showError)
        cmdbanhistory(xPlayer.source, args)
    end, {help = Text.history, params = {{name = "name", help = Text.steamname}}})

    ESX.RegisterCommand('sqlbanreload', Config.Permission, function(xPlayer, args, showError)
        cmdbanreload(xPlayer.source)
    end, {help = Text.reload})
end

local function registerQBXCommands(framework)
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

registerCommands()
