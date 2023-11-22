Framework = nil

if RY.Options.FrameWork == 'esx' then
    Framework = exports['es_extended']:getSharedObject()   
elseif RY.Options.FrameWork == 'qb' then
    Framework = exports['qb-core']:GetCoreObject()
end

RegisterServerEvent('ry-shops:checkout')
AddEventHandler('ry-shops:checkout', function(itemName, itemQuantity, itemTotal, payment)
	local _source = source
    local xPlayer = nil
    local playerMoney = 0

    if RY.Options.FrameWork == 'esx' then
        xPlayer = Framework.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if payment == 'cash' then
                playerMoney = xPlayer.getAccount('money').money
    
                if playerMoney >= tonumber(itemTotal) then 
                    xPlayer.removeMoney(tonumber(itemTotal))
                    xPlayer.addInventoryItem(itemName, itemQuantity)
                    TriggerClientEvent('ry-shops:notification', _source, RY.Messages.purchaseCompleted)
                else
                    TriggerClientEvent('ry-shops:notification', _source, RY.Messages.noMoney)
                end
            elseif payment == 'bank' then
                playerMoney = xPlayer.getAccount('bank').money
                
                if playerMoney >= tonumber(itemTotal) then 
                    xPlayer.removeAccountMoney('bank', tonumber(itemTotal))
                    xPlayer.addInventoryItem(itemName, itemQuantity)
                    TriggerClientEvent('ry-shops:notification', _source, RY.Messages.purchaseCompleted)
                else
                    TriggerClientEvent('ry-shops:notification', _source, RY.Messages.noMoney)
                end
            end
        end
    elseif RY.Options.FrameWork == 'qb' then
        xPlayer = Framework.Functions.GetPlayer(_source)
        if xPlayer ~= nil then
            if payment == 'cash' then
                playerMoney = xPlayer.PlayerData.money["cash"]

                if playerMoney >= tonumber(itemTotal) then 
                    xPlayer.Functions.RemoveMoney("cash", tonumber(itemTotal))
                    xPlayer.Functions.AddItem(itemName, itemQuantity)
                    TriggerClientEvent('ry-shops:notification', _source, RY.Messages.purchaseCompleted)
                else
                    TriggerClientEvent('ry-shops:notification', _source, RY.Messages.noMoney)
                end
            elseif payment == 'bank' then
                playerMoney = xPlayer.PlayerData.money["bank"]
                
                if playerMoney >= tonumber(itemTotal) then 
                    xPlayer.Functions.RemoveMoney("bank", tonumber(itemTotal))
                    xPlayer.Functions.AddItem(itemName, itemQuantity)
                    TriggerClientEvent('ry-shops:notification', _source, RY.Messages.purchaseCompleted)
                else
                    TriggerClientEvent('ry-shops:notification', _source, RY.Messages.noMoney)
                end
            end
        end
    end
end)



