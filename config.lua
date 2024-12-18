RY = {}

-- Configuration options for the shop framework and settings
RY.Options = {
    FrameWork = 'esx', -- Choose between 'esx' or 'qb' framework
    accountBlackMoney = 'black_money', -- Account name for black money transactions
    oxTarget = false, -- Enable or disable oxTarget integration
}

-- Messages for notifications
RY.Messages = {
    purchaseCompleted = "Successfully Purchased (-%total%$), thank you!",
    noMoney = "You don't have enough money (You need %total%$)"
}

-- Shop locations and configurations
RY.Locations = {
    ['shop1'] = {
        shopName = 'SUPER MARKET',
        useBlackMoney = false, -- Payment with black money is disabled
        jobRestrictions = {
            enabled = false, -- Job restrictions are not enabled
            jobs = {} -- All jobs can access
        },

        
        menuCoords = {
            vector3(373.8, 325.8, 103.5),
            vector3(2557.4, 382.2, 108.6),
            vector3(-3038.9, 585.9, 7.9),
            vector3(-3241.9, 1001.4, 12.8),
            vector3(547.4, 2671.7, 42.1),
            vector3(1961.4, 3740.6, 32.3),
            vector3(2678.9, 3280.6, 55.2),
            vector3(1729.2, 6414.1, 35.0)
        },

        categorysConfig = {'food', 'electronics', 'utilities'},

        oxTargetConfig = {
            icon = 'fa-solid fa-cube',
            label = 'Shop',
        },

        markersConfig = {
            markerMenu = {
                useKey = 38, -- Key to open the menu (E)
                markerType = 2,
                markerSize = {x = 0.3, y = 0.3, z = 0.3},
                markerColor = {r = 255, g = 255, b = 255},
                markerText = '[ ~g~E~w~ ] Shop'
            },
        },

        blipsConfig = {
            blipMenu = {
                blipName = '24/7 Shop',
                blipSprite = 59,
                blipScale = 0.8,
                blipColor = 2,
                blipShow = true,
            },
        },

        shopItems = {
            [1] = {
                itemName = "apple", -- Item name in the database
                itemLabel = "Apple", -- Display label in UI
                itemImage = "apple.png", -- Image in html/assets
                itemPrice = 5, -- Item price
                itemCategory = 'food', -- Item category
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
        useBlackMoney = true, -- Payment with black money is enabled
        jobRestrictions = {
            enabled = true, -- Job restrictions are enabled
            jobs = {
                ['police'] = true,
                ['mechanic'] = true
            }
        },
        
        menuCoords = {
            vector3(-1.8970, -1400.0311, 29.2717),
        },

        categorysConfig = {'ilegal'},

        oxTargetConfig = {
            icon = 'fa-solid fa-cube',
            label = 'Black Market',
        },

        markersConfig = {
            markerMenu = {
                useKey = 38, 
                markerType = 2,
                markerSize = {x = 0.3, y = 0.3, z = 0.3},
                markerColor = {r = 255, g = 255, b = 255},
                markerText = '[ ~g~E~w~ ] BLACK MARKET'
            },
        },

        blipsConfig = {
            blipMenu = {
                blipName = 'BLACK MARKET',
                blipSprite = 59,
                blipScale = 0.8,
                blipColor = 2,
                blipShow = false,
            },
        },

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

-- Function to send notifications based on the framework
function notification(msg, type)
    if RY.Options.FrameWork == 'esx' then
        Framework.ShowNotification(msg) -- ESX notification
    elseif RY.Options.FrameWork == 'qb' then
        Framework.Functions.Notify(msg) -- QB notification
    end
    -- Example custom notification
    --[[ TriggerEvent('mythic_notify:client:SendAlert', {
        type = type,
        text = msg,
        length = 7500
    })]]--
end

