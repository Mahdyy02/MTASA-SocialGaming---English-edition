--SocialGaming 2019
--Script: Csoki
white = "#FFFFFF";
bikeModels = {
	[481] = true,
	[509] = true,
	[510] = true,
};
local strings = {"1","2","3","4","5","6","7","8","9"};

function isBike(v)
	if bikeModels[getElementModel(v)] then 
		return true;
	else 
		return false;
	end
end

function getVehicleSpeed(veh)
	if not veh then 
		veh = getPedOccupiedVehicle(localPlayer);
	end
	if veh then
		local x, y, z = getElementVelocity (veh)
		return math.sqrt( x^2 + y^2 + z^2 ) * 187.5
	end
end

function findVehicle(vehicleID)
    local vehicleID = tonumber(vehicleID);
    local found = false;
    for k,v in pairs(getElementsByType("vehicle")) do 
        local vehID = getElementData(v,"veh:id") or 0;
        if vehID == vehicleID then 
            found = v;
            break;
        end
    end
    return found;
end

function createPlate()
	if strings then
		local stringChanger = "TUNIS-"
		for i=1,8 do
			local randomNum = math.random(1,#strings)
			stringChanger = stringChanger .. strings[randomNum]
		end
		return stringChanger
	end
end