--[[
  SYSTEM WYŚCIGU
  Autor: devpl
--]]

local startPos = Vector3(251.82436, -74.32504, 1.42969)
local checkpointPositions = {
    Vector3(304.21164, -74.25861, 1.42969),
    Vector3(330.33820, -102.34911, 1.42969),
    Vector3(330.52731, -166.51666, 1.29027),
    Vector3(298.61008, -209.53146, 1.42396),
    Vector3(244.64021, -209.61909, 1.42739),
    Vector3(196.74879, -209.29095, 1.42935),
    Vector3(149.28409, -209.49113, 1.43062),
}
local finishPos = Vector3(134.89339, -179.57756, 1.42969)

local raceMarker = nil
local raceBlip = nil
local guiWindow = nil
local countdown = 0
local countdownTick = 0
local showingCountdown = false
local checkpointIndex = 1
local currentCheckpoint = nil
local raceStartTime = 0
local raceTimerVisible = false
local frozenPlayer = false

function createRaceStart()
    raceMarker = createMarker(startPos.x, startPos.y, startPos.z - 1, "cylinder", 2, 255, 0, 0, 150)
    raceBlip = createBlipAttachedTo(raceMarker, 53)
end

function showRaceGUI()
    if guiWindow then return end

    guiWindow = guiCreateWindow(0.7, 0.4, 0.25, 0.2, "Wyścig - Blueberry", true)
    guiWindowSetSizable(guiWindow, false)

    local startBtn = guiCreateButton(0.1, 0.6, 0.35, 0.3, "Rozpocznij", true, guiWindow)
    local exitBtn  = guiCreateButton(0.55, 0.6, 0.35, 0.3, "Wyjdź", true, guiWindow)

    addEventHandler("onClientGUIClick", startBtn, function()
        destroyElement(guiWindow)
        guiWindow = nil
        setElementFrozen(localPlayer, true)
        frozenPlayer = true
        startCountdown()
    end, false)

    addEventHandler("onClientGUIClick", exitBtn, function()
        destroyElement(guiWindow)
        guiWindow = nil
    end, false)
end

function startCountdown()
    countdown = 3
    countdownTick = getTickCount()
    showingCountdown = true
    addEventHandler("onClientRender", root, renderCountdown)
end

function renderCountdown()
    local now = getTickCount()
    if now - countdownTick >= 1000 then
        countdown = countdown - 1
        countdownTick = now
    end

    local text = ""
    local color = tocolor(255, 255, 0, 255)
    if countdown >= 1 then
        text = tostring(countdown)
    elseif countdown == 0 then
        text = "START!"
        color = tocolor(0, 255, 0, 255)
    else
        showingCountdown = false
        removeEventHandler("onClientRender", root, renderCountdown)
        setElementFrozen(localPlayer, false)
        frozenPlayer = false
        startRace()
        return
    end

    dxDrawText(text, 0, 0, sx, sy, color, 5, "bankgothic", "center", "center")
end

function startRace()
    checkpointIndex = 1
    raceStartTime = getTickCount()
    raceTimerVisible = true
    addEventHandler("onClientRender", root, renderRaceTimer)
    showNextCheckpoint()
end

function renderRaceTimer()
    if not raceTimerVisible then return end
    local elapsed = (getTickCount() - raceStartTime) / 1000
    local text = string.format("Czas: %.2f s", elapsed)
    dxDrawText(text, 0, sy - 50, sx, sy, tocolor(255, 255, 255, 200), 2, "bankgothic", "center", "top")
end

function showNextCheckpoint()
    if currentCheckpoint and isElement(currentCheckpoint) then destroyElement(currentCheckpoint) end

    local pos = checkpointPositions[checkpointIndex]
    if pos then
        currentCheckpoint = createMarker(pos.x, pos.y, pos.z - 1, "checkpoint", 4, 0, 255, 255, 150)
        addEventHandler("onClientMarkerHit", currentCheckpoint, function(el)
            if el == localPlayer then
                checkpointIndex = checkpointIndex + 1
                showNextCheckpoint()
            end
        end)
    else
        currentCheckpoint = createMarker(finishPos.x, finishPos.y, finishPos.z - 1, "checkpoint", 4, 0, 255, 0, 150)
        addEventHandler("onClientMarkerHit", currentCheckpoint, function(el)
            if el == localPlayer then
                destroyElement(currentCheckpoint)
                outputChatBox("#00ff00[WYŚCIG] #ffffffUkończyłeś wyścig! Gratulacje!", 255, 255, 255, true)
                triggerServerEvent("zakonczWyscig", localPlayer)
                raceTimerVisible = false
                removeEventHandler("onClientRender", root, renderRaceTimer)
            end
        end)
    end
end

addEventHandler("onClientMarkerHit", resourceRoot, function(el)
    if el == localPlayer and source == raceMarker and isPedInVehicle(el) then
        showRaceGUI()
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    sx, sy = guiGetScreenSize()
    createRaceStart()
end)