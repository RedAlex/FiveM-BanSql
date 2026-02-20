local function sanitizeFilePart(value)
    local cleaned = tostring(value or "unknown")
    cleaned = cleaned:gsub("^%s+", ""):gsub("%s+$", "")
    cleaned = cleaned:gsub("[^%w%-_]", "_")
    cleaned = cleaned:gsub("_+", "_")
    if cleaned == "" then
        cleaned = "unknown"
    end
    return string.lower(cleaned)
end

local function sendScreenshotWebhook(target, success, filePath)
    local webhookUrl = ""
    
    if Config and Config.AntiCheatScreenshotWebhook and tostring(Config.AntiCheatScreenshotWebhook) ~= "" then
        webhookUrl = Config.AntiCheatScreenshotWebhook
    elseif Config and Config.DiscordWebhook and tostring(Config.DiscordWebhook) ~= "" then
        webhookUrl = Config.DiscordWebhook
    else
        return
    end

    if not (IdDataStorage and IdDataStorage[target]) then
        return
    end

    local playerName = tostring(IdDataStorage[target].playername or "unknown")
    local dateTime = os.date("%d/%m/%Y à %H:%M:%S")
    local statusText = success and "✅ Screenshot captured" or "❌ Screenshot failed"
    local description = string.format("**Target ID:** %d\n**Player Name:** %s\n**Date/Time:** %s\n**Status:** %s", target, playerName, dateTime, statusText)
    
    if success and filePath then
        description = description .. "\n**File:** " .. tostring(filePath)
    end

    local payload = {
        embeds = {
            {
                title = "AntiCheat Screenshot",
                description = description,
                color = success and 3066993 or 15158332, -- Green for success, Red for error
                thumbnail = {
                    url = "https://raw.githubusercontent.com/citizenfx/cfx-server-data/master/resources/[system]/monitor/ui/assets/monitoring.png"
                }
            }
        }
    }

    PerformHttpRequest(webhookUrl, function(statusCode, response, headers)
        if statusCode >= 200 and statusCode < 300 then
            print("[BanSql anticheat] Screenshot webhook sent successfully")
        else
            print("[BanSql anticheat] Failed to send screenshot webhook: HTTP " .. statusCode)
        end
    end, "POST", json.encode(payload), { ["Content-Type"] = "application/json" })
end

local function banFromAnticheat(playerId, reason, sourceName)
    local target = tonumber(playerId)
    if not target or target <= 0 then
        return
    end

    local ping = GetPlayerPing(target)
    if not ping or ping <= 0 then
        return
    end

    local banReason = (reason and tostring(reason) ~= "") and tostring(reason) or "Cheating"
    local sourcePlayerName = (sourceName and tostring(sourceName) ~= "") and tostring(sourceName) or "AntiCheese"
    if not (IdDataStorage and IdDataStorage[target]) then
        print("[BanSql anticheat] IdDataStorage missing for " .. tostring(target) .. ", addBan export aborted")
        return
    end

    local targetPlayerName = tostring(IdDataStorage[target].playername or "unknown")

    if type(ban) ~= "function" then
        print("[BanSql anticheat] ban function unavailable, addBan export aborted")
        return
    end

    ban(0, IdDataStorage[target].license or "n/a", IdDataStorage[target].steamid or "n/a", IdDataStorage[target].fivemid or "n/a", IdDataStorage[target].liveid or "n/a", IdDataStorage[target].xblid or "n/a", IdDataStorage[target].discord or "n/a", IdDataStorage[target].playerip or "n/a", IdDataStorage[target].tokens or {}, targetPlayerName, sourcePlayerName, 0, banReason, 1)

    local permanentText = (Text and Text.yourpermban) and Text.yourpermban or "You are permanently banned: "
    DropPlayer(target, permanentText .. banReason)
end

local function isAuthorizedInvoker()
    local invoker = GetInvokingResource()

    if Config and Config.AntiCheatBridgeUseAllowList == false then
        return invoker, (invoker ~= nil)
    end

    local allowed = {
        [GetCurrentResourceName()] = true
    }

    if Config and type(Config.AntiCheatBridgeAllowedResources) == "table" then
        for _, resourceName in ipairs(Config.AntiCheatBridgeAllowedResources) do
            if type(resourceName) == "string" and resourceName ~= "" then
                allowed[resourceName] = true
            end
        end
    end

    return invoker, (invoker ~= nil and allowed[invoker] == true)
end

local function buildScreenshotOptions(target)
    local options = {
        encoding = "jpg",
        quality = 0.5
    }

    if Config and Config.AntiCheatScreenshotSaveToFile then
        local prefix = tostring(Config.AntiCheatScreenshotFilePrefix or "cache/anticheat")
        local safePlayerName = sanitizeFilePart(((IdDataStorage and IdDataStorage[target]) and IdDataStorage[target].playername) or "unknown")
        local dateTime = os.date("%Y-%m-%d_%H-%M-%S")
        options.fileName = string.format("%s_%s_%s.jpg", prefix, safePlayerName, dateTime)
    end

    return options
end

exports("addBan", function(playerId, reason, sourceName)
    local invoker, allowed = isAuthorizedInvoker()
    if not allowed then
        print("[BanSql anticheat] blocked unauthorized addBan export call from " .. tostring(invoker))
        return
    end

    banFromAnticheat(playerId, reason, sourceName)
end)

exports("takeScreenshot", function(playerId)
    local invoker, allowed = isAuthorizedInvoker()
    if not allowed then
        print("[BanSql anticheat] blocked unauthorized takeScreenshot export call from " .. tostring(invoker))
        return
    end

    local target = tonumber(playerId)
    if not target or target <= 0 then
        return
    end

    if GetResourceState("screenshot-basic") == "started" then
        local options = buildScreenshotOptions(target)
        exports["screenshot-basic"]:requestClientScreenshot(target, options, function(err, data)
            if err then
                print("[BanSql anticheat] screenshot-basic error for " .. tostring(target) .. ": " .. tostring(err))
                sendScreenshotWebhook(target, false, nil)
                return
            end

            if options.fileName then
                print("[BanSql anticheat] screenshot saved for " .. tostring(target) .. " -> " .. tostring(data))
                sendScreenshotWebhook(target, true, data)
            else
                print("[BanSql anticheat] screenshot captured for " .. tostring(target))
                sendScreenshotWebhook(target, true, data)
            end
        end)
    else
        print("[BanSql anticheat] screenshot-basic is not started, screenshot skipped")
    end
end)
