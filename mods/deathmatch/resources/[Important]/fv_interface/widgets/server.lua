addEvent("hud > sprintAnim",true);
addEventHandler("hud > sprintAnim",root,function(player)
	setPedAnimation(player,"FAT", "idle_tired", 8000, true, false, true, false)
end);

addEvent("hud.weaponOverheat",true);
addEventHandler("hud.weaponOverheat",root,function(player,targets,weaponDBID)
	for _,targetPlayer in pairs(targets) do 
		triggerClientEvent(targetPlayer,"hud.weaponOverheatSound",player);
	end
end);