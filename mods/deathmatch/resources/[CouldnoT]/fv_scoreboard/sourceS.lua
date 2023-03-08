addEvent("requestServerSlot", true)
addEventHandler("requestServerSlot", root, function()
    triggerClientEvent(source, "receiveServerSlot", source, getMaxPlayers())
end)