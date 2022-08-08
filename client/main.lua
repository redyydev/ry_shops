InMenu = false
sleep = true

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        sleep = true
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
        for k,v in pairs(Config.Locations) do
            if not InMenu then
                local distance = #(coords - v.coords)
                    if distance < 1 then
                        sleep = false
                        DrawText3D(v.coords.x, v.coords.y, v.coords.z + 0.25, v.marker.text)
                        if IsControlJustReleased(0, v.marker.key) then
                            open_ui()
                        end
                    end

                    if distance <= 15 then
                        sleep = false
                        DrawMarker(v.marker.type, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.marker.size.x, v.marker.size.y, v.marker.size.z, v.marker.color.r, v.marker.color.g, v.marker.color.b, 50, false, true, 2, false, nil, nil, false)
                    end
            end
        end
        if sleep then
            Citizen.Wait(150)
        end
    end
end)

for k, v in pairs(Config.Locations) do
	shops = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
	SetBlipSprite (shops, v.blip.sprite)
	SetBlipDisplay(shops, 4)
	SetBlipScale  (shops, 0.65)
	SetBlipAsShortRange(shops, true)
	SetBlipColour(shops, v.blip.color)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(v.blip.name)
	EndTextCommandSetBlipName(shops)
end

