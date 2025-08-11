function naprawAuto()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        triggerServerEvent("naprawPojazdDlaGracza", resourceRoot)
    else
        outputChatBox("[Mechanik] Musisz być w pojeździe, żeby wezwać mechanika!", 255, 100, 100)
    end
end
addCommandHandler("mechanik", naprawAuto)
