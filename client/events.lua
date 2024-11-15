-- Event handler for opening a shop menu
-- @param data table - contains the location of the shop
RegisterNetEvent('ry-shops:openMenu',function(data)
    local lastLocation = data.args.location
    openMenu(lastLocation)
end)

-- Event handler for sending a notification to the client
-- @param message string - the message to display
RegisterNetEvent('ry-shops:notification',function(message)
    notification(message)
end)

-- NUI callback for the player to proceed to checkout
-- @param data table - contains the total payment amount, basket items, payment type and whether to use black money
RegisterNUICallback("goToCheckout",function(data)
    goToCheckout(data.totalPayment, data.basket, data.paymentType, data.useBlackMoney)
end)

-- NUI callback for closing the menu
RegisterNUICallback("CloseMenu",function()
    closeMenu()
end)

