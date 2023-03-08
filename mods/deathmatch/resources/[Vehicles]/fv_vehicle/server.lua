connection = exports.fv_engine:getConnection(getThisResource());

vehiclesCache = {};
loadedVehicles = {};

addEventHandler("onResourceStart",getRootElement(),function(res)
	if getResourceName(res) == "fv_engine" or getThisResource() == res then 
		sColor = exports.fv_engine:getServerColor("servercolor",true);
		red = exports.fv_engine:getServerColor("red",true);
		blue = exports.fv_engine:getServerColor("blue",true);
	end
end);

addEventHandler("onResourceStart",resourceRoot,function()
    loadFactionVehicles();

    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"loggedIn") then 
            loadPlayerVehicles(getElementData(v,"acc >> id"),v);
        end
    end
end);

function loadFactionVehicles()
	dbQuery(function (qh)
		local result, rows = dbPoll(qh, 0)
		if rows > 0 then
			for _, row in pairs(result) do
				loadVehicle(row)
			end
		end
	end, connection, "SELECT * FROM jarmuvek WHERE frakcio > 0");
end

addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "player" and oldValue ~= newValue then 
        if dataName == "loggedIn" and newValue then 
            local accountID = getElementData(source,"acc >> id") or 0;
            if accountID > 0 then 
                loadPlayerVehicles(accountID, source);
                --outputDebugString("VEHICLE > "..accountID.." has loggedIn, vehicles loading.",0,10,150,10);
            end
        end
    end
end);

function loadPlayerVehicles(charID, playerElement)
	if not charID then return end;
    local charID = tonumber(charID)
	dbQuery(function (qh, charID, sourcePlayer)
		if isElement(sourcePlayer) then
			local result, rows = dbPoll(qh, 0);
            if rows > 0 then
                vehiclesCache[charID] = {};
                for _, row in pairs(result) do
                    table.insert(vehiclesCache[charID], row["id"]);
                    loadVehicle(row);
                end
            end
		else
			dbFree(qh)
		end
	end, {charID, playerElement}, connection, "SELECT * FROM jarmuvek WHERE tulajdonos = ? AND frakcio = '0'", charID);
end

function loadVehicle(data)
	if data then
		local vehicleID = data["id"];
		if isElement(loadedVehicles[vehicleID]) then return end;
        local licensePlate = data["rendszam"];


        local rot = fromJSON(data["rot"] or "[ [ 0,0,0 ] ]");
        local position = {tonumber(data["x"]),tonumber(data["y"]),tonumber(data["z"]), tonumber(rot[1] or 0), tonumber(rot[2] or 0), tonumber(rot[3] or 0), data["interior"], data["dimension"]};

        local parkedPosition = fromJSON(data["parkedPosition"]);
		local vehicle = createVehicle(tonumber(data["model"]), position[1], position[2], position[3], position[4], position[5], position[6], licensePlate, false);
        if vehicle then
            setElementInterior(vehicle, position[7]);
			setElementDimension(vehicle, position[8]);
            triggerClientEvent("vehicleSpawnProtect", vehicle, vehicle);
            slowLoad(vehicle);
			setVehicleRespawnPosition(vehicle, position[1], position[2], position[3], position[4], position[5], position[6]);
			setElementData(vehicle, "vehicle.parkedPosition", (parkedPosition and #parkedPosition > 0) and parkedPosition or position);

			setElementData(vehicle, "veh:id", vehicleID);
			setElementData(vehicle, "veh:tulajdonos", data["tulajdonos"]);
			setElementData(vehicle, "veh:faction", data["frakcio"]);

            setElementData(vehicle, "veh:motorStatusz", data["motorStatusz"] == 1);
            setVehicleEngineState(vehicle, data["motorStatusz"] == 1);

            setElementData(vehicle, "veh:locked", data["locked"] == 1)
            setVehicleLocked(vehicle,data["locked"] == 1);

            setElementData(vehicle, "veh:lights", data["lampa"] == 1);
            setVehicleOverrideLights(vehicle, data["lampa"] == 1 and 2 or 1);

			setElementData(vehicle, "handbrake", false);

			setVehiclePlateText(vehicle, licensePlate)

			local panels = fromJSON(data["jarmuToresek"]);
			if panels then
				setTimer(function()
					for panel,state in pairs(panels) do 
						local panel = tonumber(panel);
						if panel < 7 then --Panels
							setVehiclePanelState(vehicle,tonumber(panel),tonumber(state));
						elseif panel > 6 and panel < 12 then --Doors
							setVehicleDoorState(vehicle,tonumber(panel-6),tonumber(state));
						end
					end
				end, 50, 1);
			end

			if data["lampaSzine"] then
				setVehicleHeadLightColor(vehicle, unpack(fromJSON(data["lampaSzine"])));
			end

			setVehicleFuelTankExplodable(vehicle, false)
			setVehicleColor(vehicle, unpack(fromJSON(data["jarmuSzine"])));
			print("data[\"hp\"] - "..data["hp"]);
			setTimer(setElementHealth, 100, 1, vehicle, tonumber(data["hp"]));

			setElementData(vehicle, "veh:uzemanyag", data["uzemanyag"] or 0);
			setElementData(vehicle, "veh:km", data["km"] or 0);

            loadedVehicles[vehicleID] = vehicle;
            
            if getResourceState(getResourceFromName("fv_tuning")) == "running" then 
				exports.fv_tuning:loadVehicleTuning(vehicle);
            end
        end
        --    outputDebugString("VEHICLE > LOAD dbID: " .. vehicleID .. " | ownerID: " .. data["tulajdonos"].. " | Faction: "..data["frakcio"],0,10,150,10,0);
		--[[
        else 
            dbExec(connection,"DELETE FROM jarmuvek WHERE id=?",data["id"]);
            outputDebugString("[VEHICLE] "..data["id"].." (dbid) load failed, SQL data deleted.",1);
        end
		--]]
	end
end

function saveAllVehicles()
	for k, v in pairs(loadedVehicles) do
		saveVehicle(v)
	end
end
addEventHandler("onResourceStop",resourceRoot,saveAllVehicles); --Mentés

function saveVehicle(vehicle)
	if not isElement(vehicle) then return end;
	local vehicleID = getElementData(vehicle, "veh:id") or 0
	if vehicleID > 0 then
		local vehicleX, vehicleY, vehicleZ = getElementPosition(vehicle);
		local rx, ry, rz = getElementRotation(vehicle);
        local model = getElementModel(vehicle);
        
        local panels = {};
        for i=0,6 do 
            panels[i] = getVehiclePanelState(vehicle,i);
        end
        for i=0,5 do 
            panels[7+i] = getVehicleDoorState(vehicle,i);
        end

        local datas = {
            x = vehicleX,
            y = vehicleY,
            z = vehicleZ,
            rot = toJSON({rx,ry,rz});
            interior = getElementInterior(vehicle);
            dimension = getElementDimension(vehicle);
            motorStatusz = getElementData(vehicle, "veh:motorStatusz") and 1 or 0,
            locked = getElementData(vehicle, "veh:locked") and 1 or 0,
            lampa = getElementData(vehicle, "veh:lights") and 1 or 0,
            uzemanyag = getElementData(vehicle, "veh:uzemanyag") or 0,
            km = getElementData(vehicle, "veh:km") or 0,
            jarmuToresek = toJSON(panels),
            jarmuSzine = toJSON({getVehicleColor(vehicle, true)}),
            lampaSzine = toJSON({getVehicleHeadLightColor(vehicle)}),
            hp = math.max(320, math.min(getElementHealth(vehicle), 1000)),
            frakcio = getElementData(vehicle, "veh:faction") or 0,
            tulajdonos = getElementData(vehicle, "veh:tulajdonos") or 0,
        };
        local columns = {};
        local columnValues = {};

        for k,v in pairs(datas) do
            table.insert(columns, k .. " = ?");
            table.insert(columnValues, v);
        end
        table.insert(columnValues, vehicleID);
        dbExec(connection, "UPDATE jarmuvek SET " .. table.concat(columns, ", ") .. " WHERE id = ?", unpack(columnValues));
        --outputDebugString("VEHICLE > SAVE dbID: " .. vehicleID .. " | ownerID: " .. datas["tulajdonos"].. " | Faction: "..datas["frakcio"],0,10,150,10);
	end
end

function addVehicle(tulajID,modelID,x,y,z,sqlID,r,g,b,faction,rotation)
    if not faction then faction = 0 end;
    if not rotation then rotation = 0 end;
    local plate = createPlate();
    dbExec(connection,"UPDATE jarmuvek SET rendszam=?, frakcio=?, tulajdonos=?, km=0 WHERE id=?",plate,faction,tulajID,sqlID);

    dbQuery(function(qh)
        local result = dbPoll(qh,0)[1];
        loadVehicle(result);
    end,connection,"SELECT * FROM jarmuvek WHERE id=?",sqlID);
end

addEventHandler("onElementDataChange",root,function(dataName, oldValue, newValue)
    if getElementType(source) == "vehicle" then 
        if dataName == "veh:tulajdonos" then 
            setVehicleOwnerName(source,newValue); 
        end
    end
end);

function setVehicleOwnerName(vehicle, ownerAccountID)
    local vehicleFaction = (getElementData(vehicle,"veh:faction") or 0);
    if vehicleFaction > 0 then 
        setElementData(vehicle,"veh.ownername","Frakció "..vehicleFaction);
    else
        dbQuery(function(qh,vehicle)
            local result = dbPoll(qh,0)
            if result and #result > 0 and result[1]["charname"] then 
                setElementData(vehicle,"veh.ownername", tostring(result[1]["charname"]));
            else 
                setElementData(vehicle,"veh.ownername", "Ismeretlen");
            end
        end,{vehicle},connection,"SELECT charname FROM characters WHERE id=?",ownerAccountID);
    end
end

function unloadPlayerVehicles(charID)
	if not charID then return end;
    local charID = tonumber(charID);
	if vehiclesCache[charID] then
		for _, vehicleID in pairs(vehiclesCache[charID]) do
			if loadedVehicles[vehicleID] then
				saveVehicle(loadedVehicles[vehicleID]);
				if isElement(loadedVehicles[vehicleID]) then
					destroyElement(loadedVehicles[vehicleID]);
				end
				loadedVehicles[vehicleID] = nil;
			end
		end
	end
end
addEventHandler("onPlayerQuit", getRootElement(), function ()
	local characterId = getElementData(source, "acc >> id") or 0;
	if characterId > 0 then
		unloadPlayerVehicles(characterId);
	end
end);

function deleteVehicle(vehicleID)
	if not vehicleID then return end;
	vehicleID = tonumber(vehicleID);
	if loadedVehicles[vehicleID] then
		if isElement(loadedVehicles[vehicleID]) then
			destroyElement(loadedVehicles[vehicleID]);
		end
		loadedVehicles[vehicleID] = nil;
	end
    dbExec(connection, "DELETE FROM targyak WHERE ownerID = ? AND ownerType = 'vehicle'", vehicleID);
    dbExec(connection, "DELETE FROM jarmuvek WHERE id=?",vehicleID);
end

addEvent("toggleVehicleLock", true)
addEventHandler("toggleVehicleLock", getRootElement(), function(vehicle, players, task)
    if isElement(vehicle) and isElement(vehicle) then
        if getElementData(vehicle, "veh:locked") then
            setElementData(vehicle, "veh:locked", false);
            setVehicleLocked(vehicle, false);
            if getVehicleOccupant(vehicle) == source and not task[1] then
                if not isBike(vehicle) then
                    triggerClientEvent(getVehicleOccupants(vehicle), "playVehicleSound", vehicle, "simple", "lockin.ogg");
                    exports.fv_chat:createMessage(source,"unlock a vehicle ("..exports.fv_vehmods:getVehicleRealName(vehicle)..").",1);
                else 
                    exports.fv_chat:createMessage(source,"take a padlock from "..exports.fv_vehmods:getVehicleRealName(vehicle)..".",1);
                end
                return;
            end
            if isBike(vehicle) then
                exports.fv_chat:createMessage(source,"take a padlock from "..exports.fv_vehmods:getVehicleRealName(vehicle)..".",1);
            else 
                triggerClientEvent(players, "onVehicleLockEffect", vehicle)
                exports.fv_chat:createMessage(source,"unlock a vehicle ("..exports.fv_vehmods:getVehicleRealName(vehicle)..").",1);
            end
        else
            setElementData(vehicle, "veh:locked", true);
            setVehicleLocked(vehicle, true);
            if getVehicleOccupant(vehicle) == source and not task[1] then
                if not isBike(vehicle) then 
                    triggerClientEvent(getVehicleOccupants(vehicle), "playVehicleSound", vehicle, "simple", "lockin.ogg");
                    exports.fv_chat:createMessage(source,"lock a vehicle ("..exports.fv_vehmods:getVehicleRealName(vehicle)..").",1);
                else 
                    exports.fv_chat:createMessage(source,"you put a padlock on "..exports.fv_vehmods:getVehicleRealName(vehicle)..".",1);
                end
                return;
            end
            if isBike(vehicle) then
                exports.fv_chat:createMessage(source,"you put a padlock on "..exports.fv_vehmods:getVehicleRealName(vehicle)..".",1);
            else 
                triggerClientEvent(players, "onVehicleLockEffect", vehicle);
                exports.fv_chat:createMessage(source,"lock a vehicle ("..exports.fv_vehmods:getVehicleRealName(vehicle)..").",1);
            end
        end
        if not isBike(vehicle) then 
            triggerClientEvent(players, "playVehicleSound", vehicle, "3d", "lockout.ogg");
        end
    end
end);

addEventHandler("onVehicleStartExit", getRootElement(), function (player)
	if getElementData(player, "veh:ov") then
		cancelEvent();
		exports.fv_infobox:addNotification(player,"warning","Unfasten your belt first!");
	elseif not isBike(source) and getVehicleType(source) ~= "Boat" then
		if getElementData(source, "veh:locked") or isVehicleLocked(source) then
			cancelEvent();
            exports.fv_infobox:addNotification(player,"warning", "You can't get out while the doors are locked!");
		end
    end
end);

addEventHandler("onVehicleEnter", getRootElement(), function ()
    if not isBike(source) then
        setVehicleEngineState(source, getElementData(source, "veh:motorStatusz"));
        setVehicleDamageProof(source, false);
    else 
        setVehicleEngineState(source, true);
        setVehicleDamageProof(source, true);
    end
    if isBike(source) or getVehicleType(source) == "Boat" then
        setElementData(source, "veh:ablak", false);
    end
end);

addEvent("syncVehicleSound", true);
addEventHandler("syncVehicleSound", getRootElement(), function (typ, path, players)
	if isElement(source) then
		if typ and path then
			triggerClientEvent(players, "playVehicleSound", source, typ, path);
		end
	end
end);

addEvent("toggleVehicleEngine", true)
addEventHandler("toggleVehicleEngine", getRootElement(), function (vehicle, toggle)
    if isElement(source) then
        if isElement(vehicle) then
            if toggle then
                if getElementHealth(vehicle) <= 350 then
                    exports.fv_infobox:addNotification(source,"error", "The vehicle engine is too damaged.");
                    exports.fv_chat:createMessage(source,"tries to start the engine of the vehicle but fails.",1);
                    return;
                elseif getElementData(vehicle, "veh:uzemanyag") <= 0 then
                    exports.fv_infobox:addNotification(source,"error", "The vehicle has run out of fuel.");
                    exports.fv_chat:createMessage(source,"tries to start the engine of the vehicle but fails.",1);
                    return
                end
                exports.fv_chat:createMessage(source,"starts the engine of a vehicle ("..exports.fv_vehmods:getVehicleRealName(vehicle)..").",1);
            else
                exports.fv_chat:createMessage(source,"stops the engine of a vehicle ("..exports.fv_vehmods:getVehicleRealName(vehicle)..").",1);
            end
            setVehicleEngineState(vehicle, toggle);
            setElementData(vehicle, "veh:motorStatusz", toggle);
        end
    end
end);

addEvent("vehicle.doorChange",true);
addEventHandler("vehicle.doorChange",root,function(player,veh,door,state)
    if state == "close" then 
        setVehicleDoorOpenRatio(veh,door,0,500);
    else 
        setVehicleDoorOpenRatio(veh,door,90,500);
    end
end);

addEvent("toggleVehicleLights", true)
addEventHandler("toggleVehicleLights", getRootElement(), function (vehicle)
    if getElementData(vehicle, "veh:lights") then
        setVehicleOverrideLights(vehicle, 1);
        setElementData(vehicle, "veh:lights", false);
        exports.fv_chat:createMessage(source, "turns off the vehicle lights.",1);
    else
        setVehicleOverrideLights(vehicle, 2)
        setElementData(vehicle, "veh:lights", true)
        exports.fv_chat:createMessage(source, "turns on the vehicle lights.",1);
    end
    triggerClientEvent(getVehicleOccupants(vehicle), "playVehicleSound", vehicle, "simple", "lightswitch.ogg")
end);

function startSlowLoad(veh)
	if not veh then return end;
	setElementAlpha(veh,10);
	setTimer(function()
		if not veh then return end;
		setElementAlpha(veh,100);
			setTimer(function()
				if not veh then return end;
				setElementAlpha(veh,150);
				setTimer(function()
					if not veh then return end;
					setElementAlpha(veh,200);
					setTimer(function()
						if not veh then return end;
                        setElementAlpha(veh,255);
					end,1500,1);
				end,1500,1);
			end,1500,1);
	end,1500,1);
end

function slowLoad(veh)
	startSlowLoad(veh);
end

setTimer(function()
    for k,v in pairs(getElementsByType("vehicle",root)) do 
        local vehID = getElementData(v,"veh:id") or 0;
        local engineState = getVehicleEngineState(v);
        if vehID > 0 and engineState then 
            local currentFuel = getElementData(v,"veh:uzemanyag") or 0;
            if currentFuel > 0 then 
                currentFuel = getVehicleSpeed(v) > 0 and currentFuel - 1 or currentFuel - 0.5;
                if currentFuel < 0 then 
                    currentFuel = 0;
                    setElementData(v,"veh:motorStatusz",false);
                    setVehicleEngineState(v,false);
                end
                setElementData(v,"veh:uzemanyag",currentFuel);
            end
        end
    end
end,1000 * 60 * 0.5,0);


--VEHICLE DAMAGE--
addEventHandler("onVehicleDamage",root,function(loss) --Nem robban fel meg ilyenek
	if getElementHealth(source) < 300 then
		setElementHealth(source,350);
        setElementData(source,"veh:motorStatusz",false);
        setVehicleEngineState(source,false);
		resetVehicleExplosionTime(source);
	end
end);

setTimer(function() --Nem robbannak a kocsik.
    for k,v in pairs(getElementsByType("vehicle")) do
		if getElementHealth(v) < 300 then 
			setElementHealth(v,350);
			setElementData(v,"veh:motorStatusz",false);
			setVehicleEngineState(v,false);
		end
	end
end,2000,0);