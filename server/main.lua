Framework = nil

if RY.Options.FrameWork == 'esx' then
    Framework = exports['es_extended']:getSharedObject()   
elseif RY.Options.FrameWork == 'qb' then
    Framework = exports['qb-core']:GetCoreObject()
end

RegisterServerEvent('ry-shops:goToCheckout')
AddEventHandler('ry-shops:goToCheckout', function(totalPayment, basket, paymentType, useBlackMoney)
    local _source = source
    local xPlayer = nil
    local playerMoney = 0

    local purchaseCompleted = RY.Messages.purchaseCompleted
    purchaseCompleted = string.gsub(purchaseCompleted, "%%total%%", totalPayment)

    local noMoney = RY.Messages.noMoney
    noMoney = string.gsub(noMoney, "%%total%%", totalPayment)

    if RY.Options.FrameWork == 'esx' then
        xPlayer = Framework.GetPlayerFromId(_source)
        if useBlackMoney then
            playerMoney = xPlayer.getAccount(RY.Options.accountBlackMoney).money
            if playerMoney >= totalPayment then
                xPlayer.removeAccountMoney(RY.Options.accountBlackMoney, totalPayment)
                for k,v in pairs(basket) do
                    xPlayer.addInventoryItem(v.itemName, v.itemQuantity)
                end
                TriggerClientEvent('ry-shops:notification', _source, purchaseCompleted)
            else
                TriggerClientEvent('ry-shops:notification', _source, noMoney)
            end
        else
            if paymentType == 'cash' then
                playerMoney = xPlayer.getAccount('money').money
                if playerMoney >= totalPayment then 
                    xPlayer.removeMoney(totalPayment)
                    for k,v in pairs(basket) do
                        xPlayer.addInventoryItem(v.itemName, v.itemQuantity)
                    end
                    TriggerClientEvent('ry-shops:notification', _source, purchaseCompleted)
                else
                    TriggerClientEvent('ry-shops:notification', _source, noMoney)
                end
    
            elseif paymentType == 'bank' then
                playerMoney = xPlayer.getAccount('bank').money
                if playerMoney >= totalPayment then 
                    xPlayer.removeAccountMoney('bank', totalPayment)
                    for k,v in pairs(basket) do
                        xPlayer.addInventoryItem(v.itemName, v.itemQuantity)
                    end
                    TriggerClientEvent('ry-shops:notification', _source, purchaseCompleted)
                else
                    TriggerClientEvent('ry-shops:notification', _source, noMoney)
                end
            end
        end
    elseif RY.Options.FrameWork == 'qb' then
        xPlayer = Framework.Functions.GetPlayer(_source)
        if useBlackMoney then
            playerMoney = xPlayer.PlayerData.money[RY.Options.accountBlackMoney]
            if playerMoney >= totalPayment then
                Player.Functions.RemoveMoney(RY.Options.accountBlackMoney, totalPayment)
                for k,v in pairs(basket) do
                    xPlayer.Functions.AddItem(v.itemName, v.itemQuantity)
                end
                TriggerClientEvent('ry-shops:notification', _source, purchaseCompleted)
            else
                TriggerClientEvent('ry-shops:notification', _source, noMoney)
            end
        else
            if paymentType == 'cash' then
                playerMoney = xPlayer.PlayerData.money["cash"]
                if playerMoney >= totalPayment then 
                    xPlayer.Functions.RemoveMoney("cash", totalPayment)
                    for k,v in pairs(basket) do
                        xPlayer.Functions.AddItem(v.itemName, v.itemQuantity)
                    end
                    TriggerClientEvent('ry-shops:notification', _source, purchaseCompleted)
                else
                    TriggerClientEvent('ry-shops:notification', _source, noMoney)
                end
            elseif paymentType == 'bank' then
                playerMoney = xPlayer.PlayerData.money["bank"]
                if playerMoney >= totalPayment then 
                    xPlayer.Functions.RemoveMoney("bank", totalPayment)
                    for k,v in pairs(basket) do
                        xPlayer.Functions.AddItem(v.itemName, v.itemQuantity)
                    end
                    TriggerClientEvent('ry-shops:notification', _source, purchaseCompleted)
                else
                    TriggerClientEvent('ry-shops:notification', _source, noMoney)
                end
            end
        end
    end
end)


