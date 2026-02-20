FrameworkName = nil
ESX = nil
QBCore = nil

-- If none of the frameworks are present at this moment, show a warning and continue polling
if GetResourceState('es_extended') == 'missing' and GetResourceState('qbx_core') == 'missing' and GetResourceState('qbox_core') == 'missing' then 
    print(Lang:t('frameworkerror'))
    return
end

-- Poll every second until a framework is started and detected
CreateThread(function()
    local startTime = os.time()
    local timeout = 300 -- seconds (5 minutes)
    while FrameworkName == nil do
        if os.time() - startTime >= timeout then
            print("^1[FiveM-BanSql] No framework detected within 5 minutes, disabling resource^7")
            StopResource(GetCurrentResourceName())
            return
        end
        if GetResourceState('es_extended') == 'started' then
            FrameworkName = 'es_extended'
            ESX = exports['es_extended']:getSharedObject()
            RegisterNetEvent('esx:playerLoaded', function(playerId)
                playerLoaded(playerId)
            end)
            print('FiveM-BanSql: using es_extended')
            registerESXCommands()
            break

        elseif GetResourceState('qbx_core') == 'started' then
            FrameworkName = 'qbx_core'
            QBCore = exports['qb-core']:GetCoreObject()
            RegisterNetEvent('QBCore:Server:PlayerLoaded', function(player)
                playerLoaded(player.PlayerData.source)
            end)
            print('FiveM-BanSql: using qbx_core')
            registerQBXCommands('qbx_core')
            break

        elseif GetResourceState('qbox_core') == 'started' then
            FrameworkName = 'qbox_core'
            QBCore = exports['qbox_core']:GetCoreObject()
            RegisterNetEvent('QBCore:Server:PlayerLoaded', function(player)
                playerLoaded(player.PlayerData.source)
            end)
            print('FiveM-BanSql: using qbox_core')
            registerQBXCommands('qbox_core')
            break
        end

        Wait(1000)
    end
end)

