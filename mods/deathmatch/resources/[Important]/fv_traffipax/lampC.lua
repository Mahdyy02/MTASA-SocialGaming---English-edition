local trafficLights = {}
local trafficObjects = {
	[1350] = {-3, -6, -0.5, 9},
	[1351] = {-3, -6, -0.5, 9},
	[1352] = {-3, -6, -0.5, 9},
	[3855] = {-3, -6, -0.5, 9},
	[1315] = {-2, -2, -2.5, 3.5},
	[1283] = {1.2, -4, -3, 6},
	[1284] = {1.2, -4, -3, 6},
	[1283] = {1.2, -4, -3, 6},
}
local trafficAttached = {}
function isGrovementVehicle(veh)
	return policeCars[getElementModel(veh)];
end

local nextTicket
function doTicket(veh)
	if isTimer(nextTicket) then return end
	nextTicket = setTimer(function() end, 2000, 1)
	if isGrovementVehicle(veh) then return end
	if getVehicleCurrentGear(veh) > 0 and exports.fv_vehicle:getVehicleSpeed(veh) > 0 then
		local ticket = 1000
		local serverColor = exports.fv_engine:getServerColor("servercolor",true);
		outputChatBox(exports.fv_engine:getServerSyntax("Lamp","red").."You drove through the red! Fine: "..serverColor..formatMoney(ticket)..white.."$.",255,255,255,true)
		-- setElementData(localPlayer,"char >> money",getElementData(localPlayer,"char >> money") - ticket);
		triggerServerEvent("ac.elementData",localPlayer,localPlayer,"char >> money",getElementData(localPlayer,"char >> money") - ticket);
	end
end

function calculateRotation(rot)
	local rot = math.floor(rot)
	rot = 360-rot
	if rot > 70 and rot < 110 then
		return 270
	elseif rot > 160 and rot < 200 then
		return 180
	elseif rot > 250 and rot < 290 then
		return 90
	elseif rot < 20 then
		return 0
	else
		return nil
	end
end
function addTrafficLightCollision(obj)
	if not trafficLights[obj] then
		local offset = trafficObjects[getElementModel(obj)]
		local x, y, z = getElementPosition(obj)
		if getZoneName(x, y, z, true) == "Unknown" then return end
		
		trafficLights[obj] = createColTube(x, y, z, offset[4] or 2, 2)
		attachElements(trafficLights[obj], obj, offset[1], offset[2], offset[3])
		
		trafficAttached[trafficLights[obj]] = obj
	end
end

function removeTrafficLightCollision(obj)
	if trafficLights[obj] then
		trafficAttached[trafficLights[obj]] = nil
		destroyElement(trafficLights[obj])
		trafficLights[obj] = nil
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	for k, v in ipairs(getElementsByType("object", root, true)) do
		if trafficObjects[getElementModel(v)] then
			addTrafficLightCollision(v)
		end
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "object" then
		if trafficObjects[getElementModel(source)] then
			addTrafficLightCollision(source)
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "object" then
		if trafficObjects[getElementModel(source)] then
			removeTrafficLightCollision(source)
		end
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	if getElementType(source) == "object" then
		if trafficObjects[getElementModel(source)] then
			removeTrafficLightCollision(source)
		end
	end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(player)
	if player ~= localPlayer then return end
	local object = trafficAttached[source]
	if object then
		local veh = getPedOccupiedVehicle(player)
		if veh then
			if getPedOccupiedVehicleSeat(player) == 0 then
				if not exports.fv_vehicle:isBike(veh) then
					local _, _, rz = getElementRotation(object)
					calculateLampTicket(rz, veh)
				end
			end
		end
	end
end)


function calculateLampTicket(rot, veh)
	local realRot = calculateRotation(rot)
	if realRot then
		local _, _, vz = getElementRotation(veh)
		local vehRot = calculateRotation(vz)
		if realRot == vehRot then
			local trafficState = getTrafficLightState()
			if realRot == 270 or realRot == 90 then
				if trafficState == 0 or trafficState == 1 or trafficState == 2 then
					doTicket(veh)
				end
			elseif realRot == 0 or realRot == 180 then
				if trafficState == 2 or trafficState == 3 or trafficState == 4 then
					doTicket(veh)
				end
			end
		end
	end
end

