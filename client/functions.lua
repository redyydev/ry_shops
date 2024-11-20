local shopItems = {}

-- openMenu is called when the player enters a shop location
-- it checks if the player's current job is allowed to access the shop
-- if allowed, it caches the shop's items and sends them to the client to display
function openMenu(lastLocation)
    -- check if the shop has job restrictions
    if RY.Locations[lastLocation].jobRestrictions.enabled then
        local playerJob = nil
        
        -- get the player's current job
        if RY.Options.FrameWork == 'esx' then
            playerJob = Framework.GetPlayerData().job.name
        elseif RY.Options.FrameWork == 'qb' then
            playerJob = Framework.Functions.GetPlayerData().job.name
        end

        -- if the player's job is not allowed to access the shop, return
        if not RY.Locations[lastLocation].jobRestrictions.jobs[playerJob] then
            return
        end
    end

    -- cache the last location
    cache.lastLocation = lastLocation
   
    -- cache the shop's items
    shopItems = {}
    for k,v in pairs(RY.Locations[cache.lastLocation].shopItems) do
        -- create a new item with the item's id, name, label, image, price, category and quantity
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

    -- blur the screen and send the data to the client to display
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

-- goToCheckout triggers a server event to process the checkout for a shop
-- totalPayment: the total amount to be paid
-- basket: the list of items the player wants to purchase
-- paymentType: the type of payment (e.g., cash, bank)
-- useBlackMoney: boolean indicating whether black money should be used
function goToCheckout(totalPayment, basket, paymentType, useBlackMoney)
    -- Trigger the server event to handle the checkout process
    TriggerServerEvent('ry-shops:goToCheckout', totalPayment, basket, paymentType, useBlackMoney)
end

-- Returns the player's current job name
-- @return string The player's current job name
function GetPlayerJob()
    -- Check if the framework is set and handle potential null references
    if RY.Options.FrameWork then
        -- If the framework is ESX, return the player's job name from the ESX player data
        if RY.Options.FrameWork == 'esx' then
            local playerData = Framework.GetPlayerData()
            if playerData and playerData.job then
                return playerData.job.name
            end
        -- If the framework is QBCore, return the player's job name from the QBCore player data
        elseif RY.Options.FrameWork == 'qb' then
            local playerData = Framework.Functions.GetPlayerData()
            if playerData and playerData.job then
                return playerData.job.name
            end
        end
    end
end

-- SetupTargets adds a target for the player to interact with at the given coordinates
-- @param k string The key of the shop
-- @param v table The table containing the shop data
-- @param coords vector3 The coordinates to place the target
function SetupTargets(k, v, coords)
    if RY.Options.oxTarget then
        -- Add a target for the player to interact with at the given coordinates
        -- The target is a box zone with the specified size and rotation
        -- The target has one option: to open the shop menu
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

-- Returns the shared object of the framework
-- @return table The shared object of the framework
function getFramework()
    -- If the framework is ESX, return the shared object of ESX
    if RY.Options.FrameWork == 'esx' then
        return exports['es_extended']:getSharedObject()
    -- If the framework is QBCore, return the shared object of QBCore
    elseif RY.Options.FrameWork == 'qb' then
        return exports['qb-core']:GetCoreObject()
    end
end

-- Closes the shop menu and resets the state
-- Triggers the screen blur to fade out over 1 second
-- Sends a message to the NUI to close the menu
-- Disables focus on the NUI
-- Sets the inMenu variable to false
function closeMenu()
	-- Trigger the screen blur to fade out over 1 second
	TriggerScreenblurFadeOut(1000)
	
	-- Send a message to the NUI to close the menu
	SendNUIMessage({action = "closeMenu"})
	
	-- Disable focus on the NUI
	SetNuiFocus(false, false)
	
	-- Set the inMenu variable to false
	inMenu = false
end

function DrawText3D(x, y, z, text)
    -- Set the scale of the text
    SetTextScale(0.35, 0.35)
    -- Set the font of the text
    SetTextFont(4)
    -- Make the text proportional
    SetTextProportional(1)
    -- Set the color of the text (white with an alpha of 215)
    SetTextColour(255, 255, 255, 215)
    -- Prepare the text for drawing
    SetTextEntry("STRING")
    -- Center the text
    SetTextCentre(true)
    -- Add the text to be drawn
    AddTextComponentString(text)
    -- Set the origin for drawing the text
    SetDrawOrigin(x, y, z, 0)
    -- Draw the text at the specified origin
    DrawText(0.0, 0.0)

    -- Calculate the background rectangle width based on text length
    local factor = (string.len(text)) / 370
    -- Draw a background rectangle behind the text
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    -- Clear the drawing origin
    ClearDrawOrigin()
end
