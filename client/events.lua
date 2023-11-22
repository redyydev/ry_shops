RegisterNetEvent('ry-shops:openMenu',function(data)
    local lastLocation = data.args.location
    openMenu(lastLocation)
end)

RegisterNetEvent('ry-shops:notification',function(message)
    notification(message)
end)

RegisterNUICallback("checkout",function(data)
   local basket = {}
   local payment = data.payment
    
   basket = {}
   basket = data.basket

   Citizen.Wait(100)

   checkout(basket, payment)
end)

RegisterNUICallback("CloseMenu",function()
    closeMenu()
end)