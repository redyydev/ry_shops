Framework = getFramework()
inMenu = false
cache = {}

if not (RY.Options.oxTarget) then
    Citizen.CreateThread(function()
        while true do
            if inMenu then
                Citizen.Wait(500)
            else
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local anyNearby = false

                for k, v in pairs(RY.Locations) do
                    local playerJob = GetPlayerJob()
                    local canAccess = not v.jobRestrictions.enabled or v.jobRestrictions.jobs[playerJob]

                    if canAccess then
                        for _, coords in pairs(v.menuCoords) do
                            local distance = #(playerCoords - coords)

                            if distance < 1 then
                                anyNearby = true
                                if not inMenu then
                                    DrawText3D(coords.x, coords.y, coords.z + 0.25, v.markersConfig.markerMenu.markerText)

                                    if IsControlJustReleased(0, v.markersConfig.markerMenu.useKey) then
                                        openMenu(k)
                                    end
                                end
                            end

                            if distance <= 15 then
                                anyNearby = true
                                if not inMenu then
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
                end

                if not anyNearby then
                    Citizen.Wait(500)
                else
                    Citizen.Wait(0)
                end
            end
        end
    end)
end

for k, v in pairs(RY.Locations) do
    local playerJob = GetPlayerJob()
    local canAccess = not v.jobRestrictions.enabled or v.jobRestrictions.jobs[playerJob]

    if canAccess then
        if RY.Options.oxTarget or RY.Options.qbTarget then
            for _, coords in pairs(v.menuCoords) do
                SetupTargets(k, v, coords)
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
end

