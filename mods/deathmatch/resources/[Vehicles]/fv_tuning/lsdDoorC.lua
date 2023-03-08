local oldDoorRatios = {}
local doorStatus = {}
local doorTimers = {}
local vehiclesWithScissorDoor = {}
local doorAnimTime = 250

addEventHandler("onClientResourceStart", resourceRoot, function()
	for _, vehicle in pairs(getElementsByType("vehicle",root,true)) do
		if isElementStreamedIn(vehicle) then
			if getElementData(vehicle, "tuning.lsdDoor") then
				vehiclesWithScissorDoor[vehicle] = true
			end
		end
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	removeVehicleFromTable(source)
end)

addEventHandler("onClientElementStreamOut", root, function()
	removeVehicleFromTable(source)
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "vehicle" then
		if getElementData(source, "tuning.lsdDoor") then
			vehiclesWithScissorDoor[source] = true
		end
	end
end)

addEventHandler("onClientElementDataChange", root, function(data)
	if getElementType(source) == "vehicle" then
		if data == "tuning.lsdDoor" then
			if isElementStreamedIn(source) then
				vehiclesWithScissorDoor[source] = getElementData(source, "tuning.lsdDoor")
				
				if not vehiclesWithScissorDoor[source] then
					removeVehicleFromTable(source)
				end
			end
		end
	end
end)

addEventHandler("onClientPreRender", root, function()
	for vehicle in pairs(vehiclesWithScissorDoor) do
		if isElement(vehicle) then
			if not doorTimers[vehicle] then
				doorTimers[vehicle] = {}
			end
			
			local doorRatios = {}
			
			for i = 1, 4 do
				local i = i + 1
				local doorRatio = getVehicleDoorOpenRatio(vehicle, i)
 
				if doorRatio and oldDoorRatios[vehicle] and oldDoorRatios[vehicle][i] then
					local oldDoorRatio = oldDoorRatios[vehicle][i]
 
					if not doorStatus[vehicle] then
						doorStatus[vehicle] = {}
					end
					
					local doorPreviousState = doorStatus[vehicle][i]
					
					if not doorPreviousState then
						doorPreviousState = "closed"
					end
					
					if doorPreviousState == "closed" and doorRatio > oldDoorRatio then
						doorStatus[vehicle][i] = "opening"
						doorTimers[vehicle][i] = setTimer(function(vehicle,i)
							doorStatus[vehicle][i] = "open"
							doorTimers[vehicle][i] = nil
						end, doorAnimTime, 1, vehicle, i)
					elseif doorPreviousState == "open" and doorRatio < oldDoorRatio then
						doorStatus[vehicle][i] = "closing"
						doorTimers[vehicle][i] = setTimer(function(vehicle, i)
							doorStatus[vehicle][i] = "closed"
							doorTimers[vehicle][i] = nil
						end, doorAnimTime, 1, vehicle, i)
					end
				elseif not oldDoorRatios[vehicle] then
					oldDoorRatios[vehicle] = {}
				end
				
				if doorRatio then
					oldDoorRatios[vehicle][i] = doorRatio
				end
			end
		else
			vehiclesWithScissorDoor[vehicle] = nil
			oldDoorRatios[vehicle] = nil
			doorStatus[vehicle] = nil
			doorTimers[vehicle] = nil
		end
	end
	
	for vehicle, doors in pairs(doorStatus) do
		if vehiclesWithScissorDoor[vehicle] then
			local doorX, doorY, doorZ = -72, -25, 0
			
			for door, status in pairs(doors) do
				local ratio = 0
				
				if status == "open" then
					ratio = 1
				end
				
				local doorTimer = doorTimers[vehicle][door]
				
				if doorTimer and isTimer(doorTimer) then
					local timeLeft = getTimerDetails(doorTimer)
					
					ratio = timeLeft / doorAnimTime
					
					if status == "opening" then
						ratio = 1 - ratio
					end
				end

                local dummyName = (door == 2 and "door_lf_dummy") or (door == 3 and "door_rf_dummy") or (door == 4 and "door_lr_dummy") or (door == 5 and "door_rr_dummy")
				
				if dummyName then
					local doorX, doorY, doorZ = doorX * ratio, doorY * ratio, doorZ * ratio
					
					if string.find(dummyName, "rf") then
						doorY, doorZ = doorY * -1, doorZ * -1
					end
					
					setVehicleComponentRotation(vehicle, dummyName, doorX, doorY, doorZ)
				end
			end
		end
	end
end)

function setVehicleDoorToLSD(vehicle, state)
	if getElementType(vehicle) == "vehicle" then
		setElementData(vehicle, "tuning.lsdDoor", state, true)
	
		if not state then
			removeVehicleFromTable(vehicle)
		end
	end
end

function removeVehicleFromTable(vehicle)
	if getElementType(vehicle) == "vehicle" then
		vehiclesWithScissorDoor[vehicle] = nil
		oldDoorRatios[vehicle] = nil
		doorStatus[vehicle] = nil
		doorTimers[vehicle] = nil
	end
end
