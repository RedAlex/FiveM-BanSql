-- Version Check
local CURRENT_VERSION = GetResourceMetadata(GetCurrentResourceName(), 'version')
local GITHUB_REPO = "RedAlex/FiveM-BanSql"
local GITHUB_API = "https://api.github.com/repos/" .. GITHUB_REPO .. "/releases/latest"

function sendUpdateNotification(currentVer, latestVer, changelog)
    if not Config.EnableUpdateNotif or Config.DiscordWebhook == '' then
        return
    end
    
    local downloadUrl = "https://github.com/" .. GITHUB_REPO .. "/releases/latest"
    local fields = {{
        name = "🔗 Action Required",
        value = "[Download Latest Release](" .. downloadUrl .. ")",
        inline = false
    }}

    if changelog and tostring(changelog) ~= "" then
        local notes = tostring(changelog)
        if #notes > 1000 then
            notes = notes:sub(1, 1000) .. "\n..."
        end
        table.insert(fields, {
            name = "Changelog",
            value = notes,
            inline = false
        })
    end

    local payload = {
        embeds = {{
            title = Text.updateAvailable,
            description = "**" .. Text.updateCurrentVer .. "** " .. currentVer .. "\n**" .. Text.updateLatestVer .. "** " .. latestVer,
            color = 16776960, -- Yellow
            fields = fields,
            footer = {
                text = "FiveM-BanSql Auto Update Notification"
            },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }}
    }
    
    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers)
        if err ~= 200 then
            print("^3[FiveM-BanSql] Error sending update notification to Discord (Code: " .. err .. ")^7")
        end
    end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

function checkForUpdates()
    PerformHttpRequest(GITHUB_API, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local success, response = pcall(json.decode, resultData)
            if success and response then
                local latestVersion = response.tag_name or response.name
                local releaseNotes = response.body
                -- Remove 'v' prefix if present
                if latestVersion:sub(1, 1) == 'v' then
                    latestVersion = latestVersion:sub(2)
                end
                
                if compareVersions(latestVersion, CURRENT_VERSION) > 0 then
                    print("^2========================================^7")
                    print("^3" .. Text.updateCheckTitle .. "^7")
                    print("^1" .. Text.updateCurrentVer .. "^7" .. CURRENT_VERSION)
                    print("^2" .. Text.updateLatestVer .. "^7" .. latestVersion)
                    print("^4" .. Text.updateDownload .. "^7https://github.com/" .. GITHUB_REPO .. "/releases/latest")
                    if releaseNotes and tostring(releaseNotes) ~= "" then
                        local notes = tostring(releaseNotes)
                        if #notes > 2000 then
                            notes = notes:sub(1, 2000) .. "\n..."
                        end
                        print("^6Changelog:^7\n" .. notes)
                    end
                    print("^2========================================^7")
                    -- Send Discord notification
                    sendUpdateNotification(CURRENT_VERSION, latestVersion, releaseNotes)
                else
                    print("^2" .. Text.updateUpToDate .. CURRENT_VERSION .. ")^7")
                end
            end
        else
            print("^3" .. Text.updateError .. errorCode .. ")^7")
        end
    end, 'GET')
end

function compareVersions(v1, v2)
    local parts1 = {}
    local parts2 = {}
    
    for part in v1:gmatch("[^.]+") do
        table.insert(parts1, tonumber(part) or 0)
    end
    
    for part in v2:gmatch("[^.]+") do
        table.insert(parts2, tonumber(part) or 0)
    end
    
    for i = 1, math.max(#parts1, #parts2) do
        local p1 = parts1[i] or 0
        local p2 = parts2[i] or 0
        
        if p1 > p2 then return 1 end
        if p1 < p2 then return -1 end
    end
    
    return 0
end

-- Check for updates on start
CreateThread(function()
    Wait(1000)
    checkForUpdates()
end)
