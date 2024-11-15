RegisterNetEvent('ry-shops:openMenu',function(data)
    local lastLocation = data.args.location
    openMenu(lastLocation)
end)

RegisterNetEvent('ry-shops:notification',function(message)
    notification(message)
end)

RegisterNUICallback("goToCheckout",function(data)
    goToCheckout(data.totalPayment, data.basket, data.paymentType, data.useBlackMoney)
end)

RegisterNUICallback("CloseMenu",function()
    closeMenu()
end)
