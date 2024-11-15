local shopItems = {}

function openMenu(lastLocation)
    if RY.Locations[lastLocation].jobRestrictions.enabled then
        local playerJob = nil
        
        if RY.Options.FrameWork == 'esx' then
            playerJob = Framework.GetPlayerData().job.name
        elseif RY.Options.FrameWork == 'qb' then
            playerJob = Framework.Functions.GetPlayerData().job.name
        end

        if not RY.Locations[lastLocation].jobRestrictions.jobs[playerJob] then
            return
        end
    end

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
    SendNUIMessage({
        action = 'openMenu',
        data = {
            shopItems = shopItems,
            shopName = RY.Locations[cache.lastLocation].shopName,
            categorys = RY.Locations[cache.lastLocation].categorysConfig,
            useBlackMoney = RY.Locations[cache.lastLocation].useBlackMoney
        }
    })
    SetNuiFocus(true, true)
    inMenu = true
end

function goToCheckout(totalPayment, basket, paymentType, useBlackMoney) 
	TriggerServerEvent('ry-shops:goToCheckout', totalPayment, basket, paymentType, useBlackMoney)
end

function GetPlayerJob()
    if RY.Options.FrameWork == 'esx' then
        return Framework.GetPlayerData().job.name
    elseif RY.Options.FrameWork == 'qb' then
        return Framework.Functions.GetPlayerData().job.name
    end
end

function SetupTargets(k, v, coords)
    if RY.Options.oxTarget then
        exports.ox_target:addBoxZone({
            coords = coords,
            size = vector3(3, 3, 3),
            rotation = 45,
            debug = false,
            options = {
                {
                    name = 'shop' .. k,
                    event = 'ry-shops:openMenu',
                    args = { location = k },
                    icon = v.oxTargetConfig.icon,
                    label = v.oxTargetConfig.label
                }
            }
        })
    end
end

function getFramework()
    if RY.Options.FrameWork == 'esx' then
        return exports['es_extended']:getSharedObject()
    elseif RY.Options.FrameWork == 'qb' then
        return exports['qb-core']:GetCoreObject()
    end
end

function closeMenu()
	TriggerScreenblurFadeOut(1000)
	SendNUIMessage({action = "closeMenu"})
	SetNuiFocus(false, false)
  
	inMenu = false
end

function DrawText3D(x, y, z, text)
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