local shopItems = {}

function openMenu(lastLocation)
	cache.lastLocation = lastLocation
	
	shopItems = {}
	for k,v in pairs(RY.Locations[cache.lastLocation].shopItems) do
		table.insert(shopItems, {
			itemID = k,
			itemName = v.itemName,
			itemLabel = v.itemLabel,
			itemImage = v.itemImage,
			itemPrice = v.itemPrice,
			itemCategory = v.itemCategory,
			itemQuantity = 1,
			itemTotal = v.itemPrice
		})
	end

	TriggerScreenblurFadeIn(1)
	SendNUIMessage({action = 'openMenu', data = { shopItems = shopItems, shopName = RY.Locations[cache.lastLocation].shopName, categorys = RY.Locations[cache.lastLocation].categorysConfig, useBlackMoney = RY.Locations[cache.lastLocation].useBlackMoney }})
	SetNuiFocus(true, true)

	InMenu = true
end

function goToCheckout(totalPayment, basket, paymentType, useBlackMoney) 
	TriggerServerEvent('ry-shops:goToCheckout', totalPayment, basket, paymentType, useBlackMoney)
end

function notification(msg, type)
    if RY.Options.FrameWork == 'esx' then
        Framework.ShowNotification(msg) -- Default ESX notification
    elseif RY.Options.FrameWork == 'qb' then
        Framework.Functions.Notify(msg) -- Default QB notification
    end

    --[[ TriggerEvent('mythic_notify:client:SendAlert', {							example mythic notification
    	type = type,
    	text = msg,
    	length = 7500
     })]]--
end

function closeMenu()
	TriggerScreenblurFadeOut(1000)
	SendNUIMessage({action = "closeMenu"})
	SetNuiFocus(false, false)
  
	InMenu = false
end











































function DrawText3D(x, y, z, text)
	local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))

	local distance = GetDistanceBetweenCoords(x, y, z, px, py, pz, false)

	if distance <= 6 then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(true)
		AddTextComponentString(text)
		SetDrawOrigin(x,y,z, 0)
		DrawText(0.0, 0.0)
		local factor = (string.len(text)) / 370
		DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
		ClearDrawOrigin()
	end
end