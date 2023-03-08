--SocialGaming 2019
sx,sy = guiGetScreenSize();
local engineStartTimer = false;
local preEngineStart = false;
local lastEngineStart = 0;
local beltSound = false;
local vehicleStatsHandled = false;
local plateSHOW = false;

addEventHandler("onClientResourceStart",getRootElement(), function(resource)
    if getThisResource() == resource or getResourceName(resource) == "fv_engine" then 
        sColor = {exports.fv_engine:getServerColor("servercolor",false)};
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
        e = exports.fv_engine;
		font = exports.fv_engine:getFont("rage", 13);
		red = {exports.fv_engine:getServerColor("red",false)};
    end
    if resource == getThisResource() then 
        setElementData(localPlayer,"veh:ov",false);
    end
end);

addEvent("vehicleSpawnProtect", true)
addEventHandler("vehicleSpawnProtect", getRootElement(), function (vehicle)
	if isElement(vehicle) then
        local cols = {};

        for k, v in ipairs(getElementsByType("vehicle", getRootElement(), true)) do
            setElementCollidableWith(vehicle, v, false);
            table.insert(cols, v)
        end

        for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
            setElementCollidableWith(vehicle, v, false);
            table.insert(cols, v);
        end

        setTimer(function ()
            if isElement(vehicle) then
                for i = 1, #cols do
                    if isElement(cols[i]) then
                        v = cols[i];
                        setElementCollidableWith(vehicle, v, true);
                    end
                end
             end
        end, 6500, 1);
    end
end);

addEvent("playVehicleSound", true)
addEventHandler("playVehicleSound", getRootElement(), function (type, path)
    path = "files/"..path;
    if isElement(source) then
        if type == "3d" then
            local sourcePosX, sourcePosY, sourcePosZ = getElementPosition(source);
            local sourceInterior = getElementInterior(source);
            local sourceDimension = getElementDimension(source);
            local soundElement = playSound3D(path, sourcePosX, sourcePosY, sourcePosZ);

            if isElement(soundElement) then
                setElementInterior(soundElement, sourceInterior);
                setElementDimension(soundElement, sourceDimension);

                attachElements(soundElement, source);
            end
        else
            playSound(path);
        end
    end
end);


addEvent("onVehicleLockEffect", true);
addEventHandler("onVehicleLockEffect", getRootElement(), function()
	if isElement(source) then processLockEffect(source) end;
end);

function processLockEffect(vehicle)
	if isElement(vehicle) then
		if getVehicleOverrideLights(vehicle) == 0 or getVehicleOverrideLights(vehicle) == 1 then
			setVehicleOverrideLights(vehicle, 2);
		else
			setVehicleOverrideLights(vehicle, 1);
		end
        setTimer(function()
            if getVehicleOverrideLights(vehicle) == 0 or getVehicleOverrideLights(vehicle) == 1 then
                setVehicleOverrideLights(vehicle, 2)
            else
                setVehicleOverrideLights(vehicle, 1)
            end
		end, 250, 3);
	end
end

addEventHandler("onClientKey",root,function(button,state)
    if isChatBoxInputActive() then return end;
	if guiGetInputEnabled() then return end;
	if getElementData(localPlayer,"guiActive") then return end;
    if button == "k" and state then 
        vehicleLock();
    end
end);

function vehicleLock()
    if not getElementData(localPlayer,"loggedIn") then return end;
	local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer);
	local playerInterior = getElementInterior(localPlayer);
	local playerDimension = getElementDimension(localPlayer);

	local vehicleFound = getPedOccupiedVehicle(localPlayer);
	local lastMinDistance = math.huge;
	if not isElement(vehicleFound) then
		local vehicles = getElementsByType("vehicle", getRootElement(), true);
		for i = 1, #vehicles do
			local vehicle = vehicles[i];
			if isElement(vehicle) and getElementInterior(vehicle) == playerInterior and getElementDimension(vehicle) == playerDimension then
				local distance = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, getElementPosition(vehicle));
				if distance <= 5 and distance < lastMinDistance then
					lastMinDistance = distance;
					vehicleFound = vehicle;
				end
			end
		end
	end
    if isElement(vehicleFound) then
        if (getElementData(localPlayer,"admin >> duty") and getElementData(localPlayer,"admin >> level") > 2) or exports.fv_inventory:hasItem(40,getElementData(vehicleFound,"veh:id")) then 
            triggerServerEvent("toggleVehicleLock", localPlayer, vehicleFound, getElementsByType("player", getRootElement(), true), {getPedTask(localPlayer, "primary", 3)});
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."You don't have a key to the vehicle.",255,255,255,true);
        end
	end
end

addEventHandler("onClientVehicleEnter", getRootElement(), function (player, seat)
    setVehicleDoorOpenRatio(source, 2, 0, 0);
    setVehicleDoorOpenRatio(source, 3, 0, 0);
    setVehicleDoorOpenRatio(source, 4, 0, 0);
    setVehicleDoorOpenRatio(source, 5, 0, 0);
    if player == localPlayer then 
        setElementData(localPlayer, "theOldCar", getElementData(source, "veh:id"));
        if seat == 0 then 
            outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."You can start the engine by pressing "..sColor2.."SPACE + J"..white.." buttons.",255,255,255,true);
        end
        outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."Seat belt is "..sColor2.."F5"..white.." you can attach it by pressing the button.",255,255,255,true);
        outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."To use the radio, press "..sColor2.."R"..white.." button.",255,255,255,true);
    end
end);

addEventHandler("onClientVehicleStartEnter", getRootElement(), function (player, seat, door)
    if player == localPlayer then
        if getVehicleType(source) == "Bike" or getVehicleType(source) == "BMX" or getVehicleType(source) == "Boat" then
            if getElementData(source, "veh:locked") or isVehicleLocked(source) then
                cancelEvent();
                exports.fv_infobox:addNotification("error", "This vehicle is locked!");
            end
        end
    end
end);

addEventHandler("onClientElementStreamIn", getRootElement(), function ()
    if getElementType(source) == "vehicle" then
        setVehicleDoorOpenRatio(source, 2, 0, 0);
        setVehicleDoorOpenRatio(source, 3, 0, 0);
        setVehicleDoorOpenRatio(source, 4, 0, 0);
        setVehicleDoorOpenRatio(source, 5, 0, 0);
        for i = 0, 6 do
            setVehiclePanelState(source, i, getVehiclePanelState(source, i));
        end
        local window = getElementData(source, "veh:ablak");
        for i = 2, 5 do
            setVehicleWindowOpen(source, i, window);
        end
    end
end);

addCommandHandler("oldcar", function()
	outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").. "Your previous vehicle: " ..sColor2.. getElementData(localPlayer, "theOldCar") or "You didn't sit in a vehicle."..white..".", 255,255,255, true);
end);

addCommandHandler("thiscar",function(command)
	if getElementData(localPlayer,"loggedIn") then 
		local veh = getPedOccupiedVehicle(localPlayer);
		if veh then 
			outputChatBox(exports.fv_engine:getServerSyntax("thiscar","servercolor").."Current vehicle ID:"..sColor2..(getElementData(veh,"veh:id") or "Unknown")..white..".",255,255,255,true);
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("thiscar","red").."You're not in a vehicle.",255,255,255,true);
		end
	end
end);

bindKey("F4", "down", function()
    if not getElementData(localPlayer,"loggedIn") then return end;
    local veh = getPedOccupiedVehicle(localPlayer);
    local seat = getPedOccupiedVehicleSeat(localPlayer);
    if veh and seat == 0 and getVehicleType(veh) == "Automobile" then
        local state = (getElementData(veh, "veh:ablak") or false);
        setElementData(veh, "veh:ablak", not state);
        local text = state and "pulls" or "lowers";
        exports.fv_chat:createMessage(localPlayer, text.. " the window of your vehicle",1)
    end
end);

addEventHandler("onClientElementDataChange", root,function(dName, oldValue, newValue)
    if getElementType(source) == "vehicle" and isElementStreamedIn(source) then
        if dName == "veh:ablak" then
            for i = 2, 5 do
                setVehicleWindowOpen(source, i, newValue);
            end
        end
    end
end);

bindKey("j", "both", function (key, state)
	if not getElementData(localPlayer, "loggedIn") then return end;
	local playerVehicle = getPedOccupiedVehicle(localPlayer);
	if playerVehicle then
		if getVehicleOccupant(playerVehicle) == localPlayer then
			if getVehicleType(playerVehicle) ~= "BMX" then
				if state == "down" then
					if not getElementData(playerVehicle, "veh:motorStatusz") then
                        if preEngineStart then 
                            triggerServerEvent("syncVehicleSound", playerVehicle, "3d", "starter.ogg", getElementsByType("player", root, true));
                            engineStartTimer = setTimer(function()
                                if (getElementData(localPlayer,"admin >> duty") and getElementData(localPlayer,"admin >> level") > 2) or exports.fv_inventory:hasItem(40,getElementData(playerVehicle,"veh:id")) then 
                                    triggerServerEvent("toggleVehicleEngine", localPlayer, playerVehicle, true);
                                    lastEngineStart = getTickCount();
                                else 
                                    outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."You don't have a key to the vehicle!",255,255,255,true);
                                end
                            end, 1300, 1);
                        end
                    else
                        if (getElementData(localPlayer,"admin >> duty") and getElementData(localPlayer,"admin >> level") > 2) or exports.fv_inventory:hasItem(40,getElementData(playerVehicle,"veh:id")) then 
                            triggerServerEvent("toggleVehicleEngine", localPlayer, playerVehicle, false);
                        else 
                            outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."You don't have a key to the vehicle!",255,255,255,true);
                        end
					end
				end
			end
		end
	end
end);

bindKey("space", "both", function (key, state)
    if not getElementData(localPlayer, "loggedIn") then return end;
    local playerVehicle = getPedOccupiedVehicle(localPlayer);
    if playerVehicle then
        if getVehicleOccupant(playerVehicle) == localPlayer then
            if getVehicleType(playerVehicle) ~= "BMX" then
                if state == "down" then
                    preEngineStart = true;
                elseif state == "up" then
                    preEngineStart = false;
                end
            end
        end
    end
end);

bindKey("l", "down", function()
	if isPedInVehicle(localPlayer) then
        local vehicle = getPedOccupiedVehicle(localPlayer);
		if getVehicleType(vehicle) ~= "BMX" and getVehicleOccupant(vehicle) == localPlayer then
			if not getElementData(vehicle, "index.left") and not getElementData(vehicle, "index.right") and not getElementData(vehicle, "index.middle") then
				triggerServerEvent("toggleVehicleLights", localPlayer, vehicle);
			end
		end
	end
end);

--ÖV--
addEventHandler("onClientVehicleExit",root,function(player,seat)
    if player == localPlayer then 
        if isElement(beltSound) then 
            destroyElement(beltSound);
        end
        setElementData(localPlayer,"veh:ov",false);
    end
end);

function toggleSeatbelt()
    if isPedInVehicle(localPlayer) then 
        local veh = getPedOccupiedVehicle(localPlayer);
        if isBike(veh) or getVehicleType(veh) == "Bike" then return end;
        if getElementData(localPlayer,"veh:ov") then --Kikapcs
            setElementData(localPlayer,"veh:ov",false);
            if isElement(beltSound) then 
                destroyElement(beltSound);
            end
            if getElementData(veh,"veh:motorStatusz") then
                beltSound = playSound("files/seatbelt.wav",true);
            end
            exports.fv_chat:createMessage(localPlayer,"unfasten the seat belt.",1);

        else 
            setElementData(localPlayer,"veh:ov",true);
            if isElement(beltSound) then 
                destroyElement(beltSound);
            end
            exports.fv_chat:createMessage(localPlayer,"fasten the seat belt.",1);
        end
    end
end
bindKey("F5","down", toggleSeatbelt);
addCommandHandler("defend", toggleSeatbelt, false);

setTimer(function()
    if isPedInVehicle(localPlayer) then 
        local veh = getPedOccupiedVehicle(localPlayer);
        if isBike(veh) or getVehicleType(veh) == "Bike" then return end;
        local seats = getVehicleOccupants(veh);
        local all, ok = 0,0;
        for seat, player in pairs(seats) do
            if player then 
                if not getElementData(player,"veh:ov") then 
                    if not isElement(beltSound) then 
                        if getElementData(veh,"veh:motorStatusz") then
                            beltSound = playSound("files/seatbelt.wav",true);
                        end
                    end
                else 
                    ok = ok + 1;
                end
                all = all + 1;
            end
        end
        if all == ok then 
            if isElement(beltSound) then 
                destroyElement(beltSound);
            end
        end
    else
        if getElementData(localPlayer,"veh:ov") then setElementData(localPlayer,"veh:ov",false) end; 
    end
end,500,0);

addCommandHandler("dl", function()
    if not getElementData(localPlayer,"loggedIn") then return end;
    if vehicleStatsHandled then
        removeEventHandler("onClientRender", getRootElement(), renderVehicleStats);
        vehicleStatsHandled = false;
    else
        addEventHandler("onClientRender", getRootElement(), renderVehicleStats);
        vehicleStatsHandled = true;
    end
end);

function renderVehicleStats()
	local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer);
	local vehicles = getElementsByType("vehicle", getRootElement(), true);
	for k = 1, #vehicles do
		v = vehicles[k];
		if isElement(v) and isElementOnScreen(v) then
			local vehiclePosX, vehiclePosY, vehiclePosZ = getElementPosition(v);
			if isLineOfSightClear(playerPosX, playerPosY, playerPosZ, vehiclePosX, vehiclePosY, vehiclePosZ, true, false, false, true, false, false, false, localPlayer) then
				local dist = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, vehiclePosX, vehiclePosY, vehiclePosZ);
				if dist <= 20 then
					local screenPosX, screenPosY = getScreenFromWorldPosition(vehiclePosX, vehiclePosY, vehiclePosZ);
					if screenPosX and screenPosY then
						local scaleFactor = 1 - dist / 75;
						local vehicleId = getElementData(v, "veh:id") or "Ideiglenes";
						local vehicleName = exports.fv_vehmods:getVehicleRealName(v);
						local vehicleModel = getElementModel(v);

						local sx = dxGetTextWidth(vehicleName, scaleFactor, font) + 50 * scaleFactor;
						local sy = 80 * scaleFactor;

						local x = screenPosX - sx / 2;
						local y = screenPosY - sy / 2;

						dxDrawRectangle(x - 7, y - 7, sx + 14, sy + 14, tocolor(0, 0, 0, 180));
						dxDrawRectangle(x - 9, y - 7, 3, sy + 14, tocolor(sColor[1],sColor[2],sColor[3], 180));

						dxDrawText(vehicleName, x, y, x + sx, y, tocolor(255, 255, 255), scaleFactor, font, "center", "top", false, false, false, true);
							
						dxDrawText("ID:", x, y + 25 * scaleFactor, x + sx, 0, tocolor(255, 255, 255), scaleFactor, font, "left", "top");
						dxDrawText(sColor2..vehicleId, x, y + 25 * scaleFactor, x + sx, 0, tocolor(255,255,255), scaleFactor, font, "right", "top",false,false,false,true);

						dxDrawText("Modell:", x, y + 45 * scaleFactor, x + sx, 0, tocolor(255, 255, 255), scaleFactor, font, "left", "top");
						dxDrawText(sColor2..vehicleModel, x, y + 45 * scaleFactor, x + sx, 0, tocolor(255,255,255), scaleFactor, font, "right", "top",false,false,false,true);

						dxDrawText("Plate", x, y + 65 * scaleFactor, x + sx, 0, tocolor(255, 255, 255), scaleFactor, font, "left", "top");
						dxDrawText(sColor2..getVehiclePlateText(v), x, y + 65 * scaleFactor, x + sx, 0, tocolor(255,255,255), scaleFactor, font, "right", "top",false,false,false,true);
					end
				end
			end
		end
	end
end

setTimer(function()
	if isPedInVehicle(localPlayer) then 
		local veh = getPedOccupiedVehicle(localPlayer);
		if veh then
			if getVehicleOccupant(veh, 0) == localPlayer then
				local speed = getVehicleSpeed(veh);
				if speed > 0 then
                    local megtett = (speed/1000);
                    local km = (getElementData(veh,"veh:km") or 0);
					km = km + megtett;
					setElementData(veh, "veh:km", km);
				end
			end
		end
	end
end, 1000, 0);

addEventHandler("onClientVehicleEnter", getRootElement(), function(thePlayer, seat)
	if player == localPlayer then
		if tonumber(getElementData(source,"veh:uzemanyag") or 0) <= 0 then
			setElementData(source,"veh:uzemanyag",0)
            setElementData(source,"veh:motorStatusz",false);
            setVehicleEngineState(source,false);
		end
    end
end);

addEventHandler("onClientVehicleCollision", root, function(collider, force, bodyPart, x, y, z, nx, ny, nz)
	if source == getPedOccupiedVehicle(localPlayer) then
		if getElementData(localPlayer,"admin >> duty") then return end;
		local realDamage = (force)*0.12;
		if realDamage > 7 then
			realDamage = realDamage/3;
			if getElementData(localPlayer, "veh:ov") then
				setElementHealth(localPlayer, getElementHealth(localPlayer) - realDamage/2);
			else
				setElementHealth(localPlayer, getElementHealth(localPlayer) - realDamage);
			end
		end
    end
end);

addEventHandler("onClientResourceStart",resourceRoot,function()
    if fileExists("@plateDraw.xml") then 
        local file = xmlLoadFile("@plateDraw.xml",true);
        local savedState = tonumber(xmlNodeGetAttribute(file,"state"));
        if savedState == 1 then 
            savedState = true;
        else 
            savedState = false;
        end
        changePlateState(savedState);
        xmlUnloadFile(file);
    end
end);

function changePlateState(state)
    if not state then 
        removeEventHandler("onClientRender",root,plateDraw);
        plateSHOW = false;
    else 
        removeEventHandler("onClientRender",root,plateDraw);
        addEventHandler("onClientRender",root,plateDraw);
        plateSHOW = true;
    end
end

addEventHandler("onClientKey",root,function(button,state)
	if button == "F10" and state then 
		if getElementData(localPlayer,"loggedIn") then 
            if plateSHOW then 
                changePlateState(false);
                outputChatBox(exports.fv_engine:getServerSyntax("License plate number","red").."You have successfully turned off license plate display.",255,255,255,true);
            else 
                changePlateState(true);
                outputChatBox(exports.fv_engine:getServerSyntax("License plate number","servercolor").."You have successfully turned on license plate display.",255,255,255,true);
            end
            if fileExists("@plateDraw.xml") then fileDelete("@plateDraw.xml") end;
            local file = xmlCreateFile("@plateDraw.xml","socialgaming");
            local saveState = 0;
            if plateSHOW then saveState = 1 end;
            xmlNodeSetAttribute(file,"state",saveState);
            xmlSaveFile(file);
            xmlUnloadFile(file);
		end
	end
end);

function plateDraw()
	local pVeh = getPedOccupiedVehicle(localPlayer);
    local playerX, playerY, playerZ = getElementPosition(localPlayer);
    local playerDimension = getElementDimension(localPlayer);
    for k,v in pairs(getElementsByType("vehicle",root,true)) do 
        if playerDimension == getElementDimension(v) then 
            if not pVeh or pVeh ~= v then 
                local vehicleX, vehicleY, vehicleZ = getElementPosition(v);
                if getDistanceBetweenPoints3D(playerX, playerY, playerZ, vehicleX, vehicleY, vehicleZ) < 35 then 
                    if (not processLineOfSight(playerX, playerY, playerZ, vehicleX, vehicleY, vehicleZ, true, false, false, true, false, true)) then 
                        local x,y = getScreenFromWorldPosition(vehicleX, vehicleY, vehicleZ+1);
                        if x and y then 
                            dxDrawRectangle(x-50,y-15,100,30,tocolor(23,23,23,240));
                            dxDrawImage(x-8,y+14,16,8,"files/arrow.png",0,0,0,tocolor(23,23,23,240));
                            dxDrawText(string.upper((getElementData(v,"veh:rendszam") or getVehiclePlateText(v))),x-50,y-15,x-50+100,y-15+30,tocolor(255,255,255),1,font,"center","center");
                        end
                    end
                end
            end
        end
	end
end