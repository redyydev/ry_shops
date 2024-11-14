RY = {}

RY.Options = {
    FrameWork = 'esx', -- esx or qb
    accountBlackMoney = 'black_money', -- account Name of Black Money
    oxTarget = false, -- if false it will enable markers/3dtext
}

RY.Messages = {
    purchaseCompleted = "Successfully Purchased (-%total%$), thank you!",
    noMoney = "You don't have enought money (You need %total%$)"
}

RY.Locations = {
    ['shop1'] = {
        shopName = 'SUPER MARKET',
        useBlackMoney = false, -- if true player have to pay with black money.
        menuCoords = {
            vector3(25.63,-1347.48,29.48),
            --vector3(373.875,-1602.753,29.291), example
        },

        -- Categorys
        categorysConfig = {'food', 'electronics', 'utilities'},

        -- OxTarget
        oxTargetConfig = {
            icon = 'fa-solid fa-cube',
            label = 'Shop',
        },

        -- Markers
        markersConfig = {
            markerMenu = {
                useKey = 38, -- E
                markerType = 2,
                markerSize  = {x = 0.3, y = 0.3, z = 0.3}, 
                markerColor = {r = 255, g = 255, b = 255},
                markerText = '[ ~g~E~w~ ] Shop'
            },
        },

        -- Blips
        blipsConfig = {
            blipMenu = {
                blipName = '24/7 Shop',
                blipSprite = 59,
                blipScale = 0.8,
                blipColor = 2,
                blipShow = true,
            },
        },

        -- Shop Items
        shopItems = {
            [1] = {
                itemName = "apple", -- item name in Database
                itemLabel = "Apple", -- item lable to display in UI
                itemImage = "apple.png", -- image in html/assets
                itemPrice = 5, -- item price
                itemCategory = 'food', -- item category
            },
            [2] = {
                itemName = "kiwi",
                itemLabel = "Kiwi",
                itemImage = "kiwi.png",
                itemPrice = 2,
                itemCategory = 'food',
            },
            [3] = {
                itemName = "phone",
                itemLabel = "Phone",
                itemImage = "phone.png",
                itemPrice = 100,
                itemCategory = 'electronics',
            },
            [4] = {
                itemName = "bandage",
                itemLabel = "Bandage",
                itemImage = "Bandage.png",
                itemPrice = 25,
                itemCategory = 'utilities',
            },
        }
    },

    ['blackmarket'] = {
        shopName = 'BLACK MARKET',
        useBlackMoney = true,
        menuCoords = vector3(-1.8970, -1400.0311, 29.2717),

        -- Categorys
        categorysConfig = {'ilegal'},

        -- OxTarget
        oxTargetConfig = {
            icon = 'fa-solid fa-cube',
            label = 'Black Market',
        },

        -- Markers
        markersConfig = {
            markerMenu = {
                useKey = 38, 
                markerType = 2,
                markerSize  = {x = 0.3, y = 0.3, z = 0.3}, 
                markerColor = {r = 255, g = 255, b = 255},
                markerText = '[ ~g~E~w~ ] BLACK MARKET'
            },
        },

        -- Blips
        blipsConfig = {
            blipMenu = {
                blipName = 'BLACK MARKET',
                blipSprite = 59,
                blipScale = 0.8,
                blipColor = 2,
                blipShow = false,
            },
        },

        -- Shop Items
        shopItems = {
            [1] = {
                itemName = "radio", 
                itemLabel = "Radio", 
                itemImage = "radio.png", 
                itemPrice = 250,
                itemCategory = 'ilegal',
            },
        }
    },
}

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
