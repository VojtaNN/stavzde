TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local displayedMessages = {}

RegisterNetEvent('chat:SyncMessage')
AddEventHandler('chat:SyncMessage', function(message, coords)

    displayedMessages[coords] = message
    TriggerClientEvent('chat:SetMessage', -1, message, coords)

    local playerName = GetPlayerName(source)
    local steam = GetPlayerIdentifiers(source)[1]
    TriggerEvent('discord_to_discord', playerName..' ( **'..steam..'** )', ' Zde: '..message.message)

end)

RegisterNetEvent('chat:removeDisplayedMessage')
AddEventHandler('chat:removeDisplayedMessage', function(coords)

    displayedMessages[coords] = nil
    TriggerClientEvent('chat:removeMessage', -1, coords)

end)

local playerStatus = {}

AddEventHandler('playerDropped', function (reason)
    for k, v in pairs(displayedMessages) do
        if v.owner == source then
            displayedMessages[k] = nil
            TriggerClientEvent('chat:removeMessage', -1, k)
        end
    end
    if playerStatus[source] then
        TriggerClientEvent('esx_rpchat:RemovePlayerStatus', -1, source)
    end
end)



RegisterCommand('stav', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer then
        if playerStatus[_source] then
            playerStatus[_source] = nil
            TriggerClientEvent('esx_rpchat:RemovePlayerStatus', -1, _source)
            TriggerClientEvent('Rušíme zobrazování stavu.', source)
        else
            local message = rawCommand:sub(6)
            playerStatus[_source] = message
            TriggerClientEvent('esx_rpchat:SetPlayerStatus', -1, _source, message)

            local playerName = GetPlayerName(_source)
            local steam = GetPlayerIdentifiers(_source)[1]
            TriggerEvent('discord_to_discord', playerName..' ( **'..steam..'** )', ' Stav: '..message)
        end
    end
end, false)

RegisterNetEvent('esx_rpchat:RequestMessages')
AddEventHandler('esx_rpchat:RequestMessages', function()

    TriggerClientEvent('esx_rpchat:SetMessages', source, displayedMessages, playerStatus)

end)

RegisterCommand('try', function(source, args)
    local text = ''
    local steam = GetPlayerIdentifiers(source)[1]
    local chance = math.random(1, 2)
    local playerName = GetPlayerName(source)
    if chance == 1 then
        text = 'Ano'
    else
        text = 'Ne'
    end
    TriggerClientEvent('3ddo:triggerDisplay', -1, text, source)
    TriggerClientEvent('esx_rpchat:sendDo', -1, source, playerName, text, { 255, 198, 0 })
end)