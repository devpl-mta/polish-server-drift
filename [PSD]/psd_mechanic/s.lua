addEvent("naprawPojazdDlaGracza", true)
addEventHandler("naprawPojazdDlaGracza", resourceRoot, function()
    local veh = getPedOccupiedVehicle(client)
    if veh then
        fixVehicle(veh)
        outputChatBox("🔧 Mechanik naprawił twój pojazd za darmo!", client, 100, 255, 100)
    end
end)
