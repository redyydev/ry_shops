-- Initialize the framework and set initial state
Framework = getFramework()
inMenu = false
cache = {}

-- Check if oxTarget option is disabled
if not (RY.Options.oxTarget) then
    Citizen.CreateThread(function()
        while true do
            if inMenu then
                Citizen.Wait(500)
            else
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local anyNearby = false

                -- Iterate over all shop locations
                for k, v in pairs(RY.Locations) do
                    local playerJob = GetPlayerJob()
                    local canAccess = not v.jobRestrictions.enabled or v.jobRestrictions.jobs[playerJob]

                    if canAccess then
                        for _, coords in pairs(v.menuCoords) do
                            local distance = #(playerCoords - coords)

                            -- Check if player is close enough to open the menu
                            if distance < 1 then
                                anyNearby = true
                                if not inMenu then
                                    DrawText3D(coords.x, coords.y, coords.z + 0.25, v.markersConfig.markerMenu.markerText)

                                    -- Open menu if the designated key is released
                                    if IsControlJustReleased(0, v.markersConfig.markerMenu.useKey) then
                                        openMenu(k)
                                    end
                                end
                            end

                            -- Draw marker if player is within 15 units
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

                -- Wait longer if no location is nearby
                if not anyNearby then
                    Citizen.Wait(500)
                else
                    Citizen.Wait(0)
                end
            end
        end
    end)
end

-- Setup targets and blips for each location
for k, v in pairs(RY.Locations) do
    local playerJob = GetPlayerJob()
    local canAccess = not v.jobRestrictions.enabled or v.jobRestrictions.jobs[playerJob]

    if canAccess then
        -- Setup targets if oxTarget or qbTarget option is enabled
        if RY.Options.oxTarget or RY.Options.qbTarget then
            for _, coords in pairs(v.menuCoords) do
                SetupTargets(k, v, coords)
            end
        end

        -- Setup blips if they are configured to be shown
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