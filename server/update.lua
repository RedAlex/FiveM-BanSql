-- Version Check
local CURRENT_VERSION = GetResourceMetadata(GetCurrentResourceName(), 'version')
local GITHUB_REPO = "RedAlex/FiveM-BanSql"
local GITHUB_API = "https://api.github.com/repos/" .. GITHUB_REPO .. "/releases/latest"

function checkForUpdates()
    PerformHttpRequest(GITHUB_API, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local success, response = pcall(json.decode, resultData)
            if success and response then
                local latestVersion = response.tag_name or response.name
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
                    print("^2========================================^7")
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
