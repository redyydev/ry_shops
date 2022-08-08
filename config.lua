Config = {}


Config.Framework = "esx"        -- "esx" or "qb-core"

Config.Options = {
    ['purchase_complete'] = "Successfully Purchased, thank you!",
    ['no_money'] = "You don't have enought money."
}

Config.Locations = {
    ['lossantosavenue'] = {  -- name of the location, you can put whatever you like.
        coords = vector3(25.63,-1347.48,29.48), -- coord for the menu.
        marker = {
            key = 38, -- key to open the menu. Default E
            type = 2, -- type of marker.
            size  = {x = 0.3, y = 0.3, z = 0.3}, -- size of marker.
            color = {r = 255, g = 255, b = 255}, -- color of marker.
            text = '[ ~g~E~w~ ] Shop' -- text of marker.
        },
        blip = {
            name = '24/7 Shop', -- name of the blip in map.
            sprite = 59, -- sprite of the blip.
            scale = 0.8, -- scale of the.
            color = 2 -- color of the. 
        }
    },
}

Config.Products = {
    [1] = {
        name = "Apple", -- name in the menu
        item = "apple", -- item name in database *remember that you need the item in database to work 100%*
        image = "apple.png", -- image of product in html/assets
        -- IMAGE RESOLUTION --
        -- 150x100 Pixels --
        -- IMAGE RESOLUTION --
        price = 1, -- price of product
        available = true, -- if is available to buy it or not
        type = "item" -- item or weapon
    },
    [2] = {
        name = "Kiwi",
        item = "kiwi",
        image = "kiwi.png",
        price = 4,
        available = true,
        type = "item"
    },
    [3] = {
        name = "Banana",
        item = "banana",
        image = "banana.png",
        price = 2,
        available = true,
        type = "item"
    },
    [4] = {
        name = "Phone",
        item = "phone",
        image = "phone.png",
        price = 100,
        available = true,
        type = "item"
    },
    [5] = {
        name = "Burger",
        item = "burger",
        image = "burger.png",
        price = 100,
        available = true,
        type = "item"
    },
    [6] = {
        name = "Water",
        item = "water",
        image = "water.png",
        price = 100,
        available = true,
        type = "item"
    },
    [7] = {
        name = "Beer",
        item = "beer",
        image = "beer.png",
        price = 1500,
        available = false,
        type = "item"
    },
    [8] = {
        name = "Bandage",
        item = "bandage",
        image = "bandage.png",
        price = 1500,
        available = true,
        type = "item"
    },
    [9] = {
        name = "Knife",
        item = "WEAPON_KNIFE",
        image = "Knife.png",
        price = 1500,
        available = true,
        type = "weapon"
    },
}
