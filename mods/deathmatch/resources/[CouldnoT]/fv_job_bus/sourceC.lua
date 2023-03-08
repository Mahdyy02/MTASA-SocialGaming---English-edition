local screenX, screenY = guiGetScreenSize()
local JOB_ID = 1
local responsiveMultipler = exports.fv_hud:getResponsiveMultipler()

local busStops = {}
function createBusStopObject()
    for k, v in pairs(busStopObject) do
        busStops[k] = createObject(1257, v[1], v[2], v[3], 0, 0, v[4] + 180)
        setObjectBreakable(busStops[k], false)
    end
end

addCommandHandler("tpb", function(cmd, id)
    local v = busStopObject[tonumber(id)]
    setElementPosition(localPlayer, v[1], v[2], v[3])
end)


addEventHandler("onClientResourceStart", resourceRoot, function()
    responsiveMultipler = exports.fv_hud:getResponsiveMultipler()
    createBusStopObject()
    if getElementData(localPlayer, "char >> job") == JOB_ID then
        setTimer(startBusJob, 100, 1)
    end
end)


addEventHandler("onClientElementDataChange", root, function(dataName, oldValue, newValue)
    if getElementType(source) == "player" and source == localPlayer then
        if dataName == "char >> job" then 
            if newValue == JOB_ID then 
                --startBusJob()
                setTimer(startBusJob, 100, 1)
            else 
                setTimer(stopBusJob, 100, 1)
            end
        end
    end
end)

function respc(v)
    return math.ceil(v * responsiveMultipler)
end

function resp(v)
    return v * responsiveMultipler
end

local buttons = {}
local activeButton = false

local busVehMarkerTick = 0

local jobBlip = nil
local jobMarker = nil
local jobPed = nil

local busStopBlip = nil
local busStopMarker = nil

local selectedBusLine = nil
local currentBusStop = 1

local green = {exports.fv_engine:getServerColor("servercolor",false)};
local font = exports.fv_engine:getFont("rage",respc(12));

function startBusJob()
    if isElement(jobPed) then
        destroyElement(jobPed)
    end

    if isElement(jobMarker) then
        destroyElement(jobMarker)
    end

    if isElement(jobBlip) then
        destroyElement(jobBlip)
    end

    if isElement(busStopBlip) then
        destroyElement(busStopBlip)
    end

    if isElement(busStopMarker) then
        destroyElement(busStopMarker)
    end

    jobPed = createPed(295, 1488.9067382813, 1305.2272949219, 1093.2963867188, 270)
    setElementFrozen(jobPed, true)
    setElementInterior(jobPed, 3)
    setElementDimension(jobPed, 1740)
    setElementData(jobPed,"ped >> name", "Joe McCarthy")
    setElementData(jobPed,"ped >> type", "Traffic Supervision")
    setElementData(jobPed, "char >> noDamage", true)

    jobMarker = createMarker(2855.6140136719, -1864.3848876953, 11.094903945923,"checkpoint", 2, green[1], green[2], green[3], 100);

    jobBlip = createBlip(2870.9992675781, -1982.4298095703, 11.108367919922, 3)
    setElementData(jobBlip, "blip >> name", "Munkahely")
    setElementData(jobBlip, "blip >> maxVisible", true)

    outputChatBox(exports.fv_engine:getServerSyntax("Bus driver","green") .. "Go to the bus station and pick up your bus line at the traffic office", 0, 0, 0, true)
end

function stopBusJob()
    if isElement(jobBlip) then
        destroyElement(jobBlip)
    end

    if isElement(busStopBlip) then
        destroyElement(busStopBlip)
    end

    if isElement(busStopMarker) then
        destroyElement(busStopMarker)
    end

    if isElement(jobPed) then
        destroyElement(jobPed)
    end
end

function destroyBusStop()
    if isElement(busStopBlip) then
        destroyElement(busStopBlip)
    end

    if isElement(busStopMarker) then
        destroyElement(busStopMarker)
    end

    currentBusStop = 1
    currentBusLine = nil
end

function createNextBusStop()
    
    if isElement(busStopBlip) then
        destroyElement(busStopBlip)
    end

    if isElement(busStopMarker) then
        destroyElement(busStopMarker)
    end

    if currentBusStop then
        if #busLines[selectedBusLine].stops < currentBusStop then
            outputChatBox(exports.fv_engine:getServerSyntax("Bus driver","green") .. "You have reached the end of the line! Go back to the bus station and pick up a new line or drop your vehicle at the green dot!", 0, 0, 0, true)
            currentBusStop = 1
            selectedBusLine = nil
            return
        end

        local x, y, z = unpack(busLines[selectedBusLine].stops[currentBusStop])
        local red = {exports.fv_engine:getServerColor("red",false)};


        busStopBlip = createBlip(x, y, z, 3)
        busStopMarker = createMarker(x, y, z, "checkpoint", 1.8, red[1], red[2], red[3], 140)

        setElementData(busStopBlip, "blip >> color", red)
        setElementData(busStopBlip, "blip >> name", "Next stop")
        setElementData(busStopBlip, "blip >> maxVisible", true)

        currentBusStop = currentBusStop + 1
    end
end

local startTime = false
local endTime = false

local barW, barH = resp(400), resp(50)
local barX, barY = (screenX - barW) * 0.5, screenY - resp(300)

function renderLoad()
    dxDrawRectangle(barX, barY, barW, barH, tocolor(0, 0, 0, 180))

    local loading = 0
    if startTime then
        local duration = endTime - startTime
        local progress = (getTickCount() - startTime) / duration
        loading = interpolateBetween(0, 0, 0, 1, 0, 0, progress, "Linear")
    end

    dxDrawRectangle(barX + resp(5), barY + resp(5), (barW - resp(10)) * loading, barH - resp(10), tocolor(unpack(green)))

    dxDrawText("Wait for the passengers to take off...", barX, barY, barX + barW, barY + barH, tocolor(255, 255, 255, 255), 1, font, "center", "center")
    if loading >= 1 then
        createNextBusStop()
        exports.fv_engine:giveMoney(localPlayer, 20)
        setControl(true)
        setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
        removeEventHandler("onClientRender", root, renderLoad)
    end
end

local panelW, panelH = respc(400), respc(500)
local panelX, panelY = (screenX - panelW) * 0.5, (screenY - panelH) * 0.5

local maxRow = 10
local rowW, rowH = panelW - respc(30), respc(30)
local rowX = panelX + respc(15)

local buttonW, buttonH = respc(150), respc(30)
local buttonX, buttonY = panelX + respc(15), panelY + panelH - buttonH - respc(10)

local font15 = exports.fv_engine:getFont("rage", respc(21));

local panelState = false

function renderLinePanel()
    buttons = {}

    local cursorX, cursorY = getCursorPosition()

	if tonumber(cursorX) then
		cursorX = cursorX * screenX
		cursorY = cursorY * screenY
	end

    dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(0, 0, 0, 180))
    dxDrawRectangle(panelX, panelY, respc(5), panelH, tocolor(unpack(green)))

    dxDrawText("Answer line!", panelX, panelY + respc(20), panelW + panelX, panelH + panelY, tocolor(255, 255, 255), 0.8, font15, "center")

    for i = 1, maxRow do
    
        local rowY = panelY + respc(100) + (rowH * (i - 1))
        if selectedBusLine == i then
            dxDrawRectangle(rowX, rowY, rowW, rowH, tocolor(green[1], green[2], green[3], 200))
            
        elseif i % 2 == 0 then
            dxDrawRectangle(rowX, rowY, rowW, rowH, tocolor(40, 40, 40, 250))
        else
            dxDrawRectangle(rowX, rowY, rowW, rowH, tocolor(60, 60, 60, 250))
        end
    
        local v = busLines[i]
        if v then
            dxDrawText(v.name .. " line", rowX + respc(5), rowY, rowX + rowW, rowY + rowH, tocolor(255, 255, 255), 1, font, "left", "center")
            dxDrawText(#v.stops .. " stop", rowX, rowY, rowX + rowW - respc(5), rowY + rowH, tocolor(255, 255, 255), 1, font, "right", "center")

            buttons["selectLine:" .. i] = {rowX, rowY, rowW, rowH}
        end
    end

    drawButton("accept", "undertake", buttonX, buttonY, buttonW, buttonH, tocolor(113, 208, 36))
    drawButton("close", "Close", panelX + panelW - respc(15) - buttonW, buttonY, buttonW, buttonH, tocolor(220, 73, 73))
    -- ** Gombok kezelése
	activeButton = false

	if tonumber(cursorX) then
		for k, v in pairs(buttons) do
			if cursorX >= v[1] and cursorX <= v[1] + v[3] and cursorY >= v[2] and cursorY <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	end
end

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button == "left" and state == "down" then
        if clickedElement and clickedElement == jobPed and not panelState then
            addEventHandler("onClientRender", root, renderLinePanel)
            panelState = true
        elseif panelState then
            if activeButton then
                if activeButton == "close" then
                    removeEventHandler("onClientRender", root, renderLinePanel)
                    panelState = false
                elseif activeButton == "accept" then
                    if selectedBusLine then
                        outputChatBox(exports.fv_engine:getServerSyntax("Bus driver","green") .. "You have selected " .. busLines[selectedBusLine].name .. " line", 0, 0, 0, true)
                        currentBusStop = 1
                        removeEventHandler("onClientRender", root, renderLinePanel)
                        panelState = false
                        createNextBusStop()
                    end
                elseif string.find(activeButton, "selectLine") then
                    local line = tonumber(split(activeButton, ":")[2])
                    selectedBusLine = line
                end
            end
        end
    end
end)

addEventHandler("onClientMarkerHit", root, function(hitElement)
    if hitElement == localPlayer then
        if source == busStopMarker then
            local vehicle = getPedOccupiedVehicle(localPlayer);
            if vehicle then
                if getVehicleSpeed(vehicle) < 25 and getElementData(localPlayer,"job.veh") == vehicle then
                    setControl(false)
                    setElementFrozen(vehicle, true)
                    startTime = getTickCount()
                    endTime = startTime + 5000
                    addEventHandler("onClientRender", root, renderLoad)
                    outputChatBox(exports.fv_engine:getServerSyntax("Bus driver","orange").."Wait for the passengers to take off.",255,255,255,true);
                else
                    outputChatBox(exports.fv_engine:getServerSyntax("Bus driver","red").."You went too fast or you don't use the vehicle for work!",255,255,255,true) 
                end
            end
        elseif source == jobMarker then
            if busVehMarkerTick+(1000*60) > getTickCount() then 
                outputChatBox(exports.fv_engine:getServerSyntax("Bus driver","red").."You can only use it every 1 minute.",255,255,255,true) 
                return
            end

            local veh = getPedOccupiedVehicle(localPlayer)
            if veh then 
                if getElementData(localPlayer,"job.veh") == veh then 
                    triggerServerEvent("bus.removeVeh",localPlayer,localPlayer)
                    destroyBusStop()
                    setControl(true)        
                    
                    outputChatBox(exports.fv_engine:getServerSyntax("Munka","orange").."You have successfully delivered the work vehicle!",255,255,255,true)
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Bus driver","red").."This is not your work vehicle!",255,255,255,true)
                end
            else 
                triggerServerEvent("bus.giveVeh",localPlayer,localPlayer);
                busVehMarkerTick = getTickCount();
                outputChatBox(exports.fv_engine:getServerSyntax("Munka","orange").."You have successfully retrieved the work vehicle!",255,255,255,true)
            end
        end
    end
end)

addCommandHandler("debug", function()
    setControl(true)
end)

--1257
local busStops = {}



-- ============== --

function getVehicleSpeed(veh)
	if veh then
		local x, y, z = getElementVelocity (veh)
		return math.sqrt( x^2 + y^2 + z^2 ) * 187.5
	end
end

function setControl(state)
    toggleControl("accelerate",state);
    toggleControl("brake",state);
    toggleControl("enter_exit",state);
    toggleControl("sprint",state);
    toggleControl("jump",state);
    toggleControl("crouch",state);
    toggleControl("fire",state);
    toggleControl("enter_passenger",state);
    if state then 
        exports.fv_dead:reloadBones();
    end
end

function drawButton(k, text, x, y, sx, sy, hoverColor, bgColor)
	if bgColor then
		dxDrawRectangle(x, y, sx, sy, bgColor)
	else
		dxDrawRectangle(x, y, sx, sy, tocolor(75, 75, 75))
	end

	local borderColor = tocolor(125, 125, 125)
	if activeButton == k then
		borderColor = hoverColor
	end

	drawOutline(x, y, sx, sy, borderColor)
	dxDrawText(text, x, y, x + sx, y + sy, -1, 0.6, font15, "center", "center")

	buttons[k] = {x, y, sx, sy}
end

function drawOutline(x, y, sx, sy, color)
	dxDrawRectangle(x, y, 1, sy, color) -- bal
	dxDrawRectangle(x + sx - 1, y, 1, sy, color) -- jobb
	dxDrawRectangle(x, y, sx, 1, color) -- felső
	dxDrawRectangle(x, y + sy - 1, sx, 1, color) -- alsó
end