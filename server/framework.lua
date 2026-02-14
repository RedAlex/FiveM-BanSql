FrameworkName = nil
ESX = nil
QBCore = nil

if not GetResourceState('es_extended') == 'missing' then
    FrameworkName = 'es_extended'
    ESX = exports['es_extended']:getSharedObject()

    RegisterNetEvent('esx:playerLoaded', function(playerId)
        playerLoaded(playerId)
    end)

elseif not GetResourceState('qbx_core') == 'missing' then
    FrameworkName = 'qbx_core'
    QBCore = exports['qb-core']:GetCoreObject()

    RegisterNetEvent('QBCore:Server:PlayerLoaded', function(player)
        playerLoaded(player.PlayerData.source)
    end)

elseif not GetResourceState('qbox_core') == 'missing' then
    FrameworkName = 'qbox_core'
    QBCore = exports['qbox_core']:GetCoreObject()

    RegisterNetEvent('QBCore:Server:PlayerLoaded', function(player)
        playerLoaded(player.PlayerData.source)
    end)

else
    return
end
