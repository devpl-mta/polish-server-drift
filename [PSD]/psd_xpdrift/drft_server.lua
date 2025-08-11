local root = getRootElement()
local thisResourceRoot = getResourceRootElement(getThisResource())
local drift_records = {}
local drift_mejor = 0
local drift_nombre = "N/A"

addEventHandler ( "onResourceStart", thisResourceRoot,
	function()
		call(getResourceFromName("scoreboard"), "addScoreboardColumn", "Best Drift")
		call(getResourceFromName("scoreboard"), "addScoreboardColumn", "Last Drift")
		call(getResourceFromName("scoreboard"), "addScoreboardColumn", "Total Drift")
		
		executeSQLCreateTable("recordsDrift","pista TEXT, nombre TEXT, score INTEGER")
		
		addEvent("driftClienteListo", true)
		addEventHandler("driftClienteListo", root, function(player)
			triggerClientEvent(player, "driftActualizarRecord", root, drift_mejor, drift_nombre)
			if drift_mejor == 0 then
				outputChatBox("There's no record set on this map", player)
			else
				outputChatBox(string.format("The current record is %d points (%s)", drift_mejor, drift_nombre), player)
			end
		end)
	end
)

addEventHandler ( "onResourceStop", thisResourceRoot,
	function()
		call(getResourceFromName("scoreboard"), "removeScoreboardColumn", "Best Drift")
		call(getResourceFromName("scoreboard"), "removeScoreboardColumn", "Last Drift")
		call(getResourceFromName("scoreboard"), "removeScoreboardColumn", "Total Drift")
	end
)

addEventHandler ( "onGamemodeMapStart", root, function(mapResource)
	local mapname = getResourceInfo(mapResource, "name") or getResourceName(mapResource)
	local command = string.format("pista='%s'",mapname)
	local record = executeSQLSelect("recordsDrift","nombre, score",command)
	
	if #record == 0 then
		executeSQLInsert("recordsDrift",string.format("'%s', 'N/A', 0",mapname))
		drift_mejor = 0
		drift_nombre = "N/A"
	else
		drift_mejor = record[1]["score"]
		drift_nombre = record[1]["nombre"]
	end
	triggerClientEvent(root, "driftActualizarRecord", root, drift_mejor, drift_nombre)
	triggerClientEvent(root, "driftResetAllScores", root)
	if drift_mejor == 0 then
		outputChatBox("There's no record set on this map")
	else
		outputChatBox(string.format("The current record is %d points (%s)", drift_mejor, drift_nombre))
	end
end)

addEventHandler ( "onGamemodeMapStop", root, function(mapResource)
	local mapname = getResourceInfo(mapResource, "name") or getResourceName(mapResource)
	if not mapname then return end
	
	local command = string.format("pista='%s'",mapname)
	executeSQLUpdate("recordsDrift",string.format("nombre = '%s', score = %d", drift_nombre, drift_mejor), command)
end)

addEventHandler("onVehicleDamage", root, function()
	thePlayer = getVehicleOccupant(source, 0)
	if thePlayer then
		triggerClientEvent(thePlayer, "driftCarCrashed", root, source)
	end
end)

addEvent("driftNuevoRecord", true)
addEventHandler("driftNuevoRecord", root, function(score, name)
	if score > drift_mejor then
		outputChatBox(string.format("New drift record! (%d points) (%s)",score,name)) 
		drift_mejor = score
		drift_nombre = name
		triggerClientEvent(root, "driftActualizarRecord", root, drift_mejor, drift_nombre)
	end
end)