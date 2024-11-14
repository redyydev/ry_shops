Framework = nil
inMenu = false
sleepWait = true
cache = {}

if RY.Options.FrameWork == 'esx' then
    Framework = exports['es_extended']:getSharedObject()   
elseif RY.Options.FrameWork == 'qb' then
    Framework = exports['qb-core']:GetCoreObject()
end

if not RY.Options.oxTarget then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            sleepWait = true
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
   
            if not InMenu then
                for k,v in pairs(RY.Locations) do
                    for _, coords in pairs(v.menuCoords) do
                        local distanceBetwennPlayerAndMenu = #(playerCoords - coords)        
                        if distanceBetwennPlayerAndMenu < 1 then
                            sleepWait = false
                            DrawText3D(coords.x, coords.y, coords.z + 0.25, v.markersConfig.markerMenu.markerText)                        
                            if IsControlJustReleased(0, v.markersConfig.markerMenu.useKey) then
                                openMenu(k)
                            end
                        end

                        if distanceBetwennPlayerAndMenu <= 15 then
                            sleepWait = false
                            DrawMarker(
                                v.markersConfig.markerMenu.markerType, 
                                coords.x, coords.y, coords.z, 
                                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                                v.markersConfig.markerMenu.markerSize.x, 
                                v.markersConfig.markerMenu.markerSize.y, 
                                v.markersConfig.markerMenu.markerSize.z, 
                                v.markersConfig.markerMenu.markerColor.r, 
                                v.markersConfig.markerMenu.markerColor.g, 
                                v.markersConfig.markerMenu.markerColor.b, 
                                50, false, true, 2, false, nil, nil, false
                            )
                        end
                    end
                end
            end
            if sleepWait then
                Citizen.Wait(150)
            end
        end
    end)
end

for k, v in pairs(RY.Locations) do
    if RY.Options.oxTarget then
        for _, coords in pairs(v.menuCoords) do
            exports.ox_target:addBoxZone({
                coords = coords,
                size = vector3(3,3,3),
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

    if v.blipsConfig.blipMenu.blipShow then
        for _, coords in pairs(v.menuCoords) do
            local shop = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(shop, v.blipsConfig.blipMenu.blipSprite)
            SetBlipDisplay(shop, 4)
            SetBlipScale(shop, v.blipsConfig.blipMenu.blipScale)
            SetBlipAsShortRange(shop, true)
            SetBlipColour(shop, v.blipsConfig.blipMenu.blipColor)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v.blipsConfig.blipMenu.blipName)
            EndTextCommandSetBlipName(shop)
        end
    end
end
