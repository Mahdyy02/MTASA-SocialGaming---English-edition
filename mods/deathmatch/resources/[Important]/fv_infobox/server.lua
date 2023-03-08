function addNotification(player, type, text,text2)
	if isElement(player) then
		triggerClientEvent(player, "showNotifications", getRootElement(), type, text,text2);
	end
end