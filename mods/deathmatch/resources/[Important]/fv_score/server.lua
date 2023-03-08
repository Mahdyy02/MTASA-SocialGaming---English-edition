addEvent("score.getSlot",true);
addEventHandler("score.getSlot",root,function(player)
    triggerClientEvent(player,"score.returnSlot",player,getMaxPlayers());
end);
