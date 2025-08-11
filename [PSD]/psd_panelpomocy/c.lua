local panelPomocy = nil
local zakladki = nil

function togglePanelPomocy()
    if panelPomocy and guiGetVisible(panelPomocy) then
        guiSetVisible(panelPomocy, false)
        showCursor(false)
        outputChatBox("[Pomoc] Wyłączyłeś Panel Pomocy", 255, 100, 100)
    else
        if not isElement(panelPomocy) then
            utworzPanelPomocy()
        end
        guiSetVisible(panelPomocy, true)
        showCursor(true)
        outputChatBox("[Pomoc] Odpaliłeś Panel Pomocy", 100, 255, 100)
    end
end
addCommandHandler("pomoc", togglePanelPomocy)

function utworzPanelPomocy()
    local screenW, screenH = guiGetScreenSize()
    local width, height = 600, 400
    local posX = (screenW - width) / 2
    local posY = (screenH - height) / 2

    panelPomocy = guiCreateWindow(posX, posY, width, height, "Panel Pomocy - Polski Serwer Driftu", false)
    guiWindowSetSizable(panelPomocy, false)

    zakladki = guiCreateTabPanel(10, 25, width - 20, height - 35, false, panelPomocy)

    local tabStart = guiCreateTab("Start", zakladki)
    guiCreateLabel(10, 10, 500, 60, [[
Witaj na Polskim Serwerze Driftu!
Driftuj, zarabiaj XP i odblokowuj nowe możliwości.
Miłej zabawy!]], false, tabStart)

    local tabKomendy = guiCreateTab("Komendy", zakladki)
    guiCreateLabel(10, 10, 500, 200, [[
/pomoc - otwiera panel pomocy
/drift - pokazuje twój drift XP
/tp - teleport do strefy driftu (jeśli aktywne)
/report - zgłoś gracza do administracji
]], false, tabKomendy)

    local tabAdmin = guiCreateTab("Administracja", zakladki)
    guiCreateLabel(10, 10, 500, 200, [[
Główny Administrator: Dawid
Moderatorzy: Kuba, Mati

Używaj /report jeśli ktoś łamie zasady.]] , false, tabAdmin)

    local tabUpdate = guiCreateTab("Aktualizacje", zakladki)
    guiCreateLabel(10, 10, 550, 300, [[
v0.1:
- Dodano system XP Drift
- Powitalne okno
- Panel Pomocy (/pomoc)
- UI w stylu GTA
]], false, tabUpdate)

    guiSetVisible(panelPomocy, true)
end
