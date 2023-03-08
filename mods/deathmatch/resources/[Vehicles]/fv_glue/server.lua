	
--SocialGaming 2019
--Scriptet Írta: Csoki
addEvent("gluePlayer",true);
addEventHandler("gluePlayer",getRootElement(),function(player,slot, vehicle, x, y, z, rotX, rotY, rotZ)
	attachElements(source, vehicle, x, y, z, rotX, rotY, rotZ);
	setPedWeaponSlot(source, slot);
	setElementData(player,"glue",vehicle);
end);

addEvent("ungluePlayer",true);
addEventHandler("ungluePlayer",root,function(player)
	detachElements(player);
	setElementData(player,"glue",false);
end);