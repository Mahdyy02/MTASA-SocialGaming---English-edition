addEventHandler("onVehicleEnter", root, function()
    if getElementModel(source) == 447 then
        triggerClientEvent(getElementsByType("player"), "ufoSound", source)
    end
end)

addEventHandler("onVehicleExit", root, function()
    if getElementModel(source) == 447 then
        triggerClientEvent(getElementsByType("player"), "delufoSound", source)
    end
end)

addCommandHandler("imaufo", function(p)
    setElementData(p, "char >> ufo", true)
    outputChatBox("UFO lettél", p)
end)

addCommandHandler("imnotaufo", function(p)
    setElementData(p, "char >> ufo", false)
    outputChatBox("Nem vagy UFO", p)
end)


addCommandHandler("ufoelrabol", function(p, cmd, target)
    local target = exports['fv_engine']:findPlayer(p, target) 
    if isPedInVehicle(target) then
		local targetVehicle = getPedOccupiedVehicle(target);
        
		attachElements(targetVehicle, getPedOccupiedVehicle(p), 0, 0, -7)
		
		fadeCamera(target, false, 3, 255, 255, 255);
		toggleAllControls(target, false);
		for i, occupant in pairs(getVehicleOccupants(targetVehicle)) do
			fadeCamera(occupant, false, 3, 255, 255, 255);
			toggleAllControls(occupant, false);
		end
		
		setElementCollisionsEnabled(targetVehicle, false);
		
    else
        attachElements(target, getPedOccupiedVehicle(p), 0, 0, -7)
		
		fadeCamera(target, false, 3, 255, 255, 255);
		toggleAllControls(target, false);
		
		setElementCollisionsEnabled(target, false);
    end
    exports.fv_infobox:addNotification(target, "warning","Elraboltak az UFO-k!")
    exports.fv_infobox:addNotification(p, "warning","Elraboltad az embert!")

end)

addCommandHandler("ufoletesz", function(p, cmd, target)
    local target = exports['fv_engine']:findPlayer(p, target) 
    if isPedInVehicle(target) then
		local targetVehicle = getPedOccupiedVehicle(target);
		
		fadeCamera(target, true, 3);
		toggleAllControls(target, true);
		for i, occupant in pairs(getVehicleOccupants(targetVehicle)) do
			fadeCamera(occupant, true, 3);
			toggleAllControls(occupant, true);
		end
		
		setElementCollisionsEnabled(targetVehicle, true);
		
		detachElements(targetVehicle);
		
    else
        detachElements(target)
		
		fadeCamera(target, true, 3);
		toggleAllControls(target, true);
		
		setElementCollisionsEnabled(target, true);
    end
    exports.fv_infobox:addNotification(target, "warning","Letettek az UFOk")
    exports.fv_infobox:addNotification(p, "warning","Letetted az embert!")
end)