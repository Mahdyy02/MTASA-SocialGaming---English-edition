local sirenSounds = {}
local airhornSounds = {}
local screenX, screenY = guiGetScreenSize()

local responsiveMultipler = exports.fv_hud:getResponsiveMultipler()

function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local sirenButtons = {
	[1] = {"sound:1", "Voice 1", "sound.png"},
	[2] = {"sound:2", "Voice 2", "sound.png"},
	[3] = {"sound:3", "Voice 3", "sound.png"},
	[4] = {"light:1", "Light 1", "light.png"},
	[5] = {"light:2", "Light 2", "light.png"},
	[6] = {"strobe:1", "Spotlight 1", "light.png"},
}

local draggingPanel = false

local panelW, panelH = respc(300), respc(110)
local panelX, panelY = (screenX - panelW) * 0.5, screenY - respc(200)


addEventHandler("onClientResourceStart",root,function(res)
	if getResourceName(res) == "fv_engine" or getThisResource() == res then 
		e = exports.fv_engine;
		sColor = {exports.fv_engine:getServerColor("servercolor",false)};
		font = exports.fv_engine:getFont("rage",12);
	end
end);

local activeControls = {
	sound = false,
	light = false,
	strobe = false
}

addCommandHandler("siren",
	function (command, id)
		id = tonumber(id)

		if not id or id < 0 or id > 3 then
			outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/" .. command .. " [0-3 (0 == turning off)]", 50, 179, 239, true)
			return
		end

		if (getPedOccupiedVehicleSeat(localPlayer) == 0 or getPedOccupiedVehicleSeat(localPlayer) == 1) and allowedVehicles[getElementModel(getPedOccupiedVehicle(localPlayer))] then
			if id == 0 then
				triggerSirenFunctions("sound", false)
			else
				triggerSirenFunctions("sound", id)
			end
		end
	end
)

addCommandHandler("lights",
	function (command, id)
		id = tonumber(id)

		if not id or id < 0 or id > 3 then
			outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/" .. command .. " [0-3 (0 == turning off)]", 50, 179, 239, true)
			return
		end

		if (getPedOccupiedVehicleSeat(localPlayer) == 0 or getPedOccupiedVehicleSeat(localPlayer) == 1) and allowedVehicles[getElementModel(getPedOccupiedVehicle(localPlayer))] then
			if id == 0 then
				triggerSirenFunctions("lights", false)
			else
				triggerSirenFunctions("lights", id)
			end
		end
	end
)


function triggerSirenFunctions(type, id)
	local vehicleElement = getPedOccupiedVehicle(localPlayer)

	if type == "sound" then
		local sirenData = getElementData(vehicleElement, "vehicle.siren") or {sound = false, light = false, strobe = false}

		if sirenData.sound ~= id then
			sirenData.sound = id
			triggerServerEvent("toggleSirenSound", localPlayer, id)
		elseif not id or sirenData.sound == id then
			sirenData.sound = false
			triggerServerEvent("toggleSirenSound", localPlayer, false)
		end

		setElementData(vehicleElement, "vehicle.siren", sirenData)
	elseif type == "lights" then
		local sirenData = getElementData(vehicleElement, "vehicle.siren") or {sound = false, light = false, strobe = false}

		if sirenData.light ~= id then
			if id ~= 3 then
				sirenData.light = id
				triggerServerEvent("toggleSirenLights", localPlayer, id)
			else
				sirenData.strobe = 1
				setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.siren", sirenData)
			end
		elseif not id or sirenData.light == id then
			sirenData.light = false
			triggerServerEvent("toggleSirenLights", localPlayer, false)
		end

		setElementData(vehicleElement, "vehicle.siren", sirenData)
   end
end

local buttons = {}
local activeButton = false

function drawControlButton(x, y, w, h, type, id, img)
	dxDrawRectangle(x, y, w, h, tocolor(50, 50, 50, 200))
	if activeControls[type] == id then
		dxDrawImage(x + respc(5), y + respc(5), w - respc(10), h - respc(10), img, 0, 0, 0, tocolor(0, 144, 255))
	else
		dxDrawImage(x + respc(5), y + respc(5), w - respc(10), h - respc(10), img, 0, 0, 0, tocolor(255, 255, 255))
	end
end

addEventHandler("onClientRender", root, function()
	if isPedInVehicle(localPlayer) then
	--if not panel then return end

		local veh = getPedOccupiedVehicle(localPlayer)
		local seat = getPedOccupiedVehicleSeat(localPlayer);
		if veh and allowedVehicles[getElementModel(veh)] and (seat == 0 or seat == 1) then

			local absX, absY = getCursorPosition()

			if isCursorShowing() then
				absX = absX * screenX
				absY = absY * screenY

				if getKeyState("mouse1") then
					if absX >= panelX and absX <= panelX + panelW and absY >= panelY and absY <= panelY + panelH and not activeButton and not draggingPanel then
						draggingPanel = {absX, absY, panelX, panelY}
					end

					if draggingPanel then
						panelX = absX - draggingPanel[1] + draggingPanel[3]
						panelY = absY - draggingPanel[2] + draggingPanel[4]
					end
				elseif draggingPanel then
					draggingPanel = false
				end
			else
				absX, absY = -1, -1

				if draggingPanel then
					draggingPanel = false
				end
			end

			local buttonSize = respc(35)
			local buttonX, buttonY = panelX + respc(10), panelY + respc(15)

			dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(0, 0, 0, 180))
			dxDrawRectangle(panelX, panelY, panelW, respc(5), tocolor(unpack(sColor)))

			local c = 0
			for k, v in ipairs(sirenButtons) do
				local x = buttonX + (buttonSize + respc(10)) * (k - 1)
				local y = buttonY 

				if k > 3 then
					y = y + buttonSize + respc(10)
					x = buttonX + (buttonSize + respc(10)) * c
					c = c + 1
				end

				drawControlButton(x, y, buttonSize, buttonSize, split(v[1], ":")[1], tonumber(split(v[1], ":")[2]), "files/" .. v[3])
				buttons[v[1]] = {x, y, buttonSize, buttonSize}
			end

			dxDrawText("Unit:", panelX + respc(150), panelY + respc(10), panelX, panelY, tocolor(255, 255, 255, 255), 1, font)
			dxDrawText(getElementData(veh, "vehicle.unit") or "Unknown", panelX + respc(155), panelY + respc(35), panelX, panelY, tocolor(255, 255, 255, 255), 0.80, font)

			activeButton = false

			if isCursorShowing() then
				for k, v in pairs(buttons) do
					if absX >= v[1] and absX <= v[1] + v[3] and absY >= v[2] and absY <= v[2] + v[4] then
						activeButton = k
						break
					end
				end
			end
		end
	end
end)

addEventHandler("onClientPlayerVehicleEnter", getRootElement(),
	function (vehicle, seat)
		if source == localPlayer and (seat == 0 or seat == 1) then
			activeControls = getElementData(vehicle, "vehicle.siren") or {sound = false, light = false, strobe = false}
		end
	end
)

addEventHandler("onClientClick", root, function(button, state)
	if button == "left" and state == "down" then
		if activeButton then
			local selected = split(activeButton, ":")
			
			if selected[1] == "sound" then
				local soundID = tonumber(selected[2])

				if activeControls.sound == soundID then
					activeControls.sound = false
				else
					activeControls.sound = soundID
				end

				triggerServerEvent("toggleSirenSound", localPlayer, activeControls.sound)
			elseif selected[1] == "light" then
				local lightID = tonumber(selected[2])

				if activeControls.light == lightID then
					activeControls.light= false
				else
					activeControls.light = lightID
				end

				triggerServerEvent("toggleSirenLights", localPlayer, activeControls.light)
			elseif selected[1] == "strobe" then
				local strobeID = tonumber(selected[2])

				if activeControls.strobe == strobeID then
					activeControls.strobe= false
				else
					activeControls.strobe = strobeID
				end
			end

			setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.siren", activeControls)
		end
	end
end) 

addEventHandler("onClientElementDataChange", root, function(dataName)
	if getPedOccupiedVehicle(localPlayer) and source == getPedOccupiedVehicle(localPlayer) and (getPedOccupiedVehicleSeat(localPlayer) == 0 or getPedOccupiedVehicleSeat(localPlayer) == 1) then
		if dataName == "vehicle.siren" then
			activeControls = getElementData(source, "vehicle.siren") or {sound = false, light = false, strobe = false}
		end
	end
end)

addEventHandler("onClientClick", root, function(vehicle, seat)
	if source == localPlayer and (seat == 0 or seat == 1) then
		activeControls = getElementData(vehicle, "vehicle.siren") or {sound = false, light = false, strobe = false}
	end
end)


addEvent("toggleSirenSound", true)
addEventHandler("toggleSirenSound", root, function(soundID)
	if source == localPlayer and not isPedInVehicle(source) then
		return
	end

	local vehicle = getPedOccupiedVehicle(source)
	local modelID = getElementModel(vehicle) 
	if soundID and tonumber(soundID) then
		if allowedVehicles[modelID] and vehiclesSiren[modelID] then

			if isElement(sirenSounds[vehicle]) then
				destroyElement(sirenSounds[vehicle])
			end
			print(vehiclesSiren[modelID][soundID])
			local x, y, z = getElementPosition(vehicle)
			if vehiclesSiren[modelID][soundID] then
				sirenSounds[vehicle] = playSound3D("sounds/" .. vehiclesSiren[modelID][soundID], x, y, z, true)
				setSoundMaxDistance(sirenSounds[vehicle], 200)
				attachElements(sirenSounds[vehicle], vehicle)
				setSoundVolume(sirenSounds[vehicle], 0.5)
			end
		end
	else
		if isElement(sirenSounds[vehicle]) then
			destroyElement(sirenSounds[vehicle])
		end
	end
end)

addEvent("useAirhorn", true)
addEventHandler("useAirhorn", root, function(state)
	if source == localPlayer and not isPedInVehicle(source) then
		return
	end

	local vehicle = getPedOccupiedVehicle(source)
	local modelID = getElementModel(vehicle) 
	if state then
		if allowedVehicles[modelID] and vehiclesSiren[modelID] then
			if isElement(airhornSounds[vehicle]) then
				destroyElement(airhornSounds[vehicle])
			end

			local x, y, z = getElementPosition(vehicle)
			if vehiclesSiren[modelID]["horn"] then
				airhornSounds[vehicle] = playSound3D("sounds/" .. vehiclesSiren[modelID]["horn"], x, y, z, true)
				setSoundMaxDistance(airhornSounds[vehicle], 200)
				attachElements(airhornSounds[vehicle], vehicle)
			end
		end
	else
		if isElement(airhornSounds[vehicle]) then
			destroyElement(airhornSounds[vehicle])
		end
	end
end)

addCommandHandler("setsign", function(cmd, unit)
	if not unit then 
		outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [Unit number]", 255,255,255,true)
		return
	end

	if isPedInVehicle(localPlayer) then
		local vehicle = getPedOccupiedVehicle(localPlayer) 
		if allowedVehicles[getElementModel(vehicle)] then
			setElementData(vehicle, "vehicle.unit", unit)
		end
	end
end)

local vehicleLightData = {}
local strobeLightTimer = {}

function processStrobe(vehicle, state)
	if isElement(vehicle) then
		if state then
			setVehicleLightState(vehicle, 0, 1)
			setVehicleLightState(vehicle, 3, 1)
			setVehicleLightState(vehicle, 1, 0)
			setVehicleLightState(vehicle, 2, 0)
			setVehicleHeadLightColor(vehicle, 255, 255, 255) -- 0, 0, 255
		else
			setVehicleLightState(vehicle, 0, 0)
			setVehicleLightState(vehicle, 3, 0)
			setVehicleLightState(vehicle, 1, 1)
			setVehicleLightState(vehicle, 2, 1)
			setVehicleHeadLightColor(vehicle, 255, 255, 255) -- 255, 0, 0
		end

		strobeLightTimer[vehicle] = setTimer(processStrobe, 150, 1, vehicle, not state)
	else
		strobeLightTimer[vehicle] = nil
	end
end

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue, newValue)
	if getElementType(source) == "vehicle" then
		
		if dataName == "vehicle.siren" then
			local data = getElementData(source, "vehicle.siren") or {sound = false, light = false, strobe = false}

			if data.strobe then
				if not vehicleLightData[source] then
					vehicleLightData[source] = {}

					for i = 0, 3 do
						vehicleLightData[source][i] = getVehicleLightState(source, i)
					end

					vehicleLightData[source].color = {getVehicleHeadLightColor(source)}
					vehicleLightData[source].override = getVehicleOverrideLights(source)

					setVehicleOverrideLights(source, 2)

					strobeLightTimer[source] = setTimer(processStrobe, 150, 1, source, true)
				end
			else
				if isTimer(strobeLightTimer[source]) then
					killTimer(strobeLightTimer[source])
				end

				if vehicleLightData[source] then
					for i = 0, 3 do
						setVehicleLightState(source, i, vehicleLightData[source][i])
					end

					setVehicleHeadLightColor(source, unpack(vehicleLightData[source].color))
					setVehicleOverrideLights(source, vehicleLightData[source].override)

					vehicleLightData[source] = nil
				end
			end
		end
	end
end)