local powitalneOkno = nil
local zamknijPrzycisk = nil

function pokazPowitanie()
    local screenW, screenH = guiGetScreenSize()

    local width, height = 350, 180
    local posX = screenW - width - 20
    local posY = (screenH / 2) - (height / 2)

    powitalneOkno = guiCreateWindow(posX, posY, width, height, "Witaj!", false)
    guiWindowSetSizable(powitalneOkno, false)

    local tekst = [[
Witaj na Polskim Serwerze Driftu!
Cieszymy się, że dołączyłeś.

Podstawowe komendy znajdziesz pod:
/pomoc
]]
    guiCreateLabel(10, 25, width - 20, 100, tekst, false, powitalneOkno)

    zamknijPrzycisk = guiCreateButton(10, height - 40, width - 20, 30, "Zamknij", false, powitalneOkno)

    addEventHandler("onClientGUIClick", zamknijPrzycisk, function()
        if isElement(powitalneOkno) then
            destroyElement(powitalneOkno)
        end
    end, false)
end

addEventHandler("onClientResourceStart", resourceRoot, pokazPowitanie)
