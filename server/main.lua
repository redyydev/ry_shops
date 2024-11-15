-- Initialize the Framework variable and purchaseLocks table
local Framework = nil
local purchaseLocks = {}

-- Determine the framework being used (ESX or QBCore) and get the shared object
if RY.Options.FrameWork == 'esx' then
    Framework = exports['es_extended']:getSharedObject()  
elseif RY.Options.FrameWork == 'qb' then
    Framework = exports['qb-core']:GetCoreObject()
end

-- Register the server event for handling the checkout process
RegisterServerEvent('ry-shops:goToCheckout')
AddEventHandler('ry-shops:goToCheckout', function(totalPayment, basket, paymentType, useBlackMoney)
    local _source = source

    -- If a purchase is already in progress for the player, do nothing
    if purchaseLocks[_source] then
        return
    end

    -- Lock the purchase process for the player
    purchaseLocks[_source] = true

    -- Function to handle payment and item delivery
    local function payAndGiveItem(xPlayer, totalPayment, basket, paymentType, useBlackMoney)
        local playerMoney = 0
        local purchaseCompleted = string.gsub(RY.Messages.purchaseCompleted, "%%total%%", totalPayment)
        local noMoney = string.gsub(RY.Messages.noMoney, "%%total%%", totalPayment)
        local paymentSuccess = false

        -- Payment logic for ESX framework
        if RY.Options.FrameWork == 'esx' then
            if useBlackMoney then
                playerMoney = xPlayer.getAccount(RY.Options.accountBlackMoney).money
                if playerMoney >= totalPayment then
                    xPlayer.removeAccountMoney(RY.Options.accountBlackMoney, totalPayment)
                    paymentSuccess = true
                end
            else
                if paymentType == 'cash' then
                    playerMoney = xPlayer.getAccount('money').money
                    if playerMoney >= totalPayment then
                        xPlayer.removeMoney(totalPayment)
                        paymentSuccess = true
                    end
                elseif paymentType == 'bank' then
                    playerMoney = xPlayer.getAccount('bank').money
                    if playerMoney >= totalPayment then
                        xPlayer.removeAccountMoney('bank', totalPayment)
                        paymentSuccess = true
                    end
                end
            end
        -- Payment logic for QBCore framework
        elseif RY.Options.FrameWork == 'qb' then
            if useBlackMoney then
                playerMoney = xPlayer.PlayerData.money[RY.Options.accountBlackMoney]
                if playerMoney >= totalPayment then
                    xPlayer.Functions.RemoveMoney(RY.Options.accountBlackMoney, totalPayment)
                    paymentSuccess = true
                end
            else
                if paymentType == 'cash' then
                    playerMoney = xPlayer.PlayerData.money["cash"]
                    if playerMoney >= totalPayment then
                        xPlayer.Functions.RemoveMoney("cash", totalPayment)
                        paymentSuccess = true
                    end
                elseif paymentType == 'bank' then
                    playerMoney = xPlayer.PlayerData.money["bank"]
                    if playerMoney >= totalPayment then
                        xPlayer.Functions.RemoveMoney("bank", totalPayment)
                        paymentSuccess = true
                    end
                end
            end
        end

        -- If payment is successful, add items to player's inventory
        if paymentSuccess then
            if RY.Options.FrameWork == 'esx' then
                for _, item in pairs(basket) do
                    xPlayer.addInventoryItem(item.itemName, item.itemQuantity)
                end
            elseif RY.Options.FrameWork == 'qb' then
                for _, item in pairs(basket) do
                    xPlayer.Functions.AddItem(item.itemName, item.itemQuantity)
                end
            end
            -- Notify the player of successful purchase
            TriggerClientEvent('ry-shops:notification', _source, purchaseCompleted)
        else
            -- Notify the player of insufficient funds
            TriggerClientEvent('ry-shops:notification', _source, noMoney)
        end
    end

    -- Get the player object based on the framework
    local xPlayer
    if RY.Options.FrameWork == 'esx' then
        xPlayer = Framework.GetPlayerFromId(_source)
    elseif RY.Options.FrameWork == 'qb' then
        xPlayer = Framework.Functions.GetPlayer(_source)
    end

    -- If player object is valid, process payment and item delivery
    if xPlayer then
        payAndGiveItem(xPlayer, totalPayment, basket, paymentType, useBlackMoney)
    end

    -- Unlock the purchase process for the player after 1 second
    Citizen.SetTimeout(1000, function()
        purchaseLocks[_source] = nil
    end)
end)

-- Clear purchase lock when a player disconnects
AddEventHandler('playerDropped', function()
    local _source = source
    purchaseLocks[_source] = nil
end)

