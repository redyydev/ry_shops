RY = {}

RY.Options = {
    FrameWork = 'esx', -- esx or qb

    oxTarget = {
        enable = false, -- if false it will enable markers/3dtext
        icons = {
            menu = 'fa-solid fa-cube',
        } ,
        labels = {
            menu = 'Shop',
        }
    }
}

RY.Messages = {
    purchaseCompleted = "Successfully Purchased, thank you!",
    noMoney = "You don't have enought money."
}

RY.Locations = {
    ['shop1'] = {
        shopName = 'SUPER MARKET',
        menuCoords = vector3(25.63,-1347.48,29.48),

        -- Categorys
        categorysConfig = {'food', 'electronics', 'utilities'},

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
                blipColor = 2
            },
        },

        -- Shop Items
        shopItems = {
            [1] = {
                itemName = "apple",
                itemLabel = "Apple",
                itemImage = "apple.png",
                itemPrice = 2,
                itemCategory = 'food',
                -- IMAGE RESOLUTION --
                -- 150x100 Pixels --
                -- IMAGE RESOLUTION --
            },
            [2] = {
                itemName = "kiwi",
                itemLabel = "Kiwi",
                itemImage = "kiwi.png",
                itemPrice = 2,
                itemCategory = 'food',
                -- IMAGE RESOLUTION --
                -- 150x100 Pixels --
                -- IMAGE RESOLUTION --
            },
            [3] = {
                itemName = "phone",
                itemLabel = "Phone",
                itemImage = "phone.png",
                itemPrice = 100,
                itemCategory = 'electronics',
                -- IMAGE RESOLUTION --
                -- 150x100 Pixels --
                -- IMAGE RESOLUTION --
            },
            [4] = {
                itemName = "bandage",
                itemLabel = "Bandage",
                itemImage = "Bandage.png",
                itemPrice = 25,
                itemCategory = 'utilities',
                -- IMAGE RESOLUTION --
                -- 150x100 Pixels --
                -- IMAGE RESOLUTION --
            },
        }

    },
}
