local screenW, screenH = guiGetScreenSize()

function rysujNapis()
dxDrawText("Polski Serwer Driftu v. 0.1", 
    0, 10, screenW, 50, 
    tocolor(255, 255, 255, 255), 
    1.0, "bankgothic",
    "center", "top", 
    false, false, false, true
)

end

addEventHandler("onClientRender", root, rysujNapis)
