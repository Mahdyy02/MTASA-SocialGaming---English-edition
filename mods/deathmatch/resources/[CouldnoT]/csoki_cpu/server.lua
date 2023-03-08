local playerTimers = {}
function sendStats(player)
	if isElement(player) then
		local columns, rows = getPerformanceStats("Lua timing")
		triggerClientEvent(player, "receiveServerStat", player, columns, rows)
		playerTimers[player] = setTimer(sendStats, 1000, 1, player)
	end
end

addEvent("getServerStat", true)
addEventHandler("getServerStat", root, function()
	sendStats(client)
end)

addEvent("destroyServerStat", true)
addEventHandler("destroyServerStat", root, function()
	if isTimer(playerTimers[client]) then
		killTimer(playerTimers[client])
		playerTimers[client] = nil
	end
end)


addEventHandler("onPlayerQuit",root,function()
	if playerTimers[source] then 
		if isTimer(playerTimers[source]) then 
			killTimer(playerTimers[source]);
		end
		playerTimers[source] = nil;
	end
end);