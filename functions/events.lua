RegisterNUICallback("checkout",function(data)
    TriggerServerEvent('ry_shops:checkout', data.name, data.item, data.quantity, data.total, data.type)
end)

RegisterNUICallback("CloseUI",function()
    close_ui()
end)
