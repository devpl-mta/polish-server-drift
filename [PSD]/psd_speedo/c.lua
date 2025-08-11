-- LICZNIK SAMOCHODOWY
-- Autor: devpl

local screenW, screenH = guiGetScreenSize()
local font = "bankgothic"

addEventHandler("onClientRender", root, function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh and getPedOccupiedVehicleSeat(localPlayer) == 0 then

        local vx, vy, vz = getElementVelocity(veh)
        local speed = math.sqrt(vx^2 + vy^2 + vz^2) * 180
        speed = math.floor(speed)

        local hp = getElementHealth(veh)
        local hpPercent = math.floor((hp / 1000) * 100)

        dxDrawText(speed, screenW - 240, screenH - 100, screenW, screenH, tocolor(255, 255, 255, 255), 2.0, font, "left", "top")

        dxDrawText("HP: " .. hpPercent .. "%", screenW - 240, screenH - 60, screenW, screenH, tocolor(0, 255, 0, 255), 1.5, font, "left", "top")
    end
end)
