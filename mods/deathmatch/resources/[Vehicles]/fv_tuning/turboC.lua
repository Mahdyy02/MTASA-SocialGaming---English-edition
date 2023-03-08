local oldState = 0
local newState = 0

function checkVehicleGearboxChange()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh and getElementData(veh,"tuning.performance") and getElementData(veh,"tuning.performance")[6] and getElementData(veh,"tuning.performance")[6] == 5 then
		newState = getVehicleCurrentGear(veh);
		
		if newState ~= oldState then
			oldState = newState;
			
			local x, y, z = getElementPosition(veh);
			local sound = playSound3D("files/turbo.mp3", x, y, z, false);
			setSoundMaxDistance(sound, 100);
            setSoundVolume(sound, 1);
            attachElements(sound,veh,0,0,0);
		end
	end
end
setTimer(checkVehicleGearboxChange, 500, 0);