addCommandHandler("getcar", function(playerSource, cmd, id)
	if (tonumber(getElementData(playerSource,"admin >> level")) > 2) then
		if not id then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [id]",playerSource,255,255,255,true) return end;
		local vehicle = findVehicle(id);
		local x,y,z = getElementPosition(playerSource);
		if vehicle then 
			outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."You have successfully teleported the following vehicle to yourself: " ..sColor..id,playerSource,255,255,255,true);
			setElementPosition(vehicle,x+4,y,z);
			setElementDimension(vehicle,getElementDimension(playerSource));
			setElementInterior(vehicle, getElementInterior(playerSource));
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."There is no such vehicle.",playerSource,255,255,255,true);
		end
	end
end);
addCommandHandler("gotocar", function(playerSource, cmd, id)
	if (tonumber(getElementData(playerSource,"admin >> level")) > 2) then
		if not id then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [id]",playerSource,255,255,255,true) return end;
		if tonumber(id) > 0 then
			local vehicle = findVehicle(id);
			local x,y,z = getElementPosition(vehicle)
			if vehicle then 
				outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."You have successfully teleported to the next vehicle: " ..sColor..id,playerSource,255,255,255,true);
				setElementPosition(playerSource,x+4,y,z);
				setElementDimension(playerSource,getElementDimension(vehicle));
				setElementInterior(playerSource, getElementDimension(vehicle));
			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."There is no such vehicle.",playerSource,255,255,255,true);
			end
		else
			outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [ID]", playerSource,166,196,103,true);			
		end
	end
end);
addCommandHandler("park", function(player)
	local vehicle = getPedOccupiedVehicle(player);
	if not isElement(vehicle) then return outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."You're not in a vehicle!",player,255,255,255,true) end;
    local vehicleID = tonumber(getElementData(vehicle, "veh:id")) or -65535;
    local vehicleFaction = getElementData(vehicle,"veh:faction") or 0;
    local vehOwner = getElementData(vehicle,"veh:tulajdonos");
    if not ((vehicleFaction > 0 and (getElementData(player,"faction_"..vehicleFaction.."_leader") or false)) or (getElementData(player,"acc >> id") == vehOwner) or ( getElementData(player,"admin >> level") > 2 and getElementData(player,"admin >> duty") )) then
        return outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."This is not your vehicle!",player,255,255,255,true);
    end
    local x, y, z = getElementPosition(vehicle);
    local rx, ry, rz = getElementRotation(vehicle);
    local interior = getElementInterior(vehicle);
    local dimension = getElementDimension(vehicle);
    local currentPosition = {x, y, z, rx, ry, rz, interior, dimension};
    if dbExec(connection, "UPDATE jarmuvek SET parkedPosition = ? WHERE id = ? ", toJSON(currentPosition), vehicleID) then
        setVehicleRespawnPosition(vehicle, x, y, z, rx, ry, rz);
        setElementData(vehicle, "vehicle.parkedPosition", currentPosition);
        outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."Your vehicle has been parked successfully!",player,255,255,255,true);
        exports.fv_infobox:addNotification(player,"success","Your vehicle has been parked successfully!");
    end
end);
addCommandHandler("makeveh", function (playerSource, cmd, target, modellID,r,g,b,faction)
	if (tonumber(getElementData(playerSource,"admin >> level")) > 7) then
		if target and modellID and r and g and b and getElementDimension(playerSource) == 0 and getElementInterior(playerSource) == 0 then
            local dyk = modellID;
            modellID = tonumber(modellID);
            if not modellID then modellID = getVehicleModelFromName(dyk) end;
            if not faction then faction = 0 end;
            faction = math.floor(tonumber(faction));
            local targetPlayer,targetPlayerName = exports["fv_engine"]:findPlayer(playerSource, target);
            if targetPlayer then
                local owner = 0;
                if faction > 0 then 
                    owner = -faction;
                else
                    owner = getElementData(targetPlayer,"acc >> id");
                end
                local x,y,z = getElementPosition(targetPlayer);
                dbQuery(function(qh) 
                    local result, _, vehID = dbPoll(qh, 0);
                    if result then
                        local rx,ry,rz = getElementRotation(targetPlayer);
                        addVehicle(tonumber(getElementData(targetPlayer,"acc >> id")),tonumber(modellID),x,y,z,vehID,r,g,b,faction);
                        exports.fv_inventory:givePlayerItem(targetPlayer,40,1,vehID,100,0);
                        outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."Successful game creation! ID: " ..sColor..vehID,playerSource,255,255,255,true);
                        exports.fv_logs:createLog("CreateVeh",exports.fv_admin:getAdminName(playerSource).. " created a vehicle: "..getVehicleNameFromModel(modellID)..", Owner: "..(getElementData(targetPlayer,"char >> name"):gsub("_"," "))..".",playerSource,targetPlayer);
                        exports.fv_admin:sendMessageToAdmin(playerSource,sColor..getElementData(playerSource,"admin >> name")..white.." created a vehicle. Model: "..sColor..getVehicleNameFromModel(modellID)..white..", Owner: "..sColor..(getElementData(targetPlayer,"char >> name"):gsub("_"," "))..white..".",3);
                    end
                end, connection, "INSERT INTO jarmuvek SET x=?,y=?,z=?,model=?,interior=?,dimension=?,tulajdonos=?,jarmuSzine=?,frakcio=?,rot=?",x,y,z,modellID,0,0,owner,toJSON({tonumber(r),tonumber(g),tonumber(b),0,0,0}),faction,toJSON({rx,ry,rz}));
            end
        else
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." #ffffff[ID] [vehicle ID] [r] [g] [b] [faction]",playerSource,255,255,255,true);
        end	
	end
end);
addCommandHandler("nearbyvehicles",function(playerSource, cmd)
	if (tonumber(getElementData(playerSource,"admin >> level")) > 2) then
		local pX,pY,pZ = getElementPosition(playerSource);
		outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."Nearby vehicles:",playerSource,255,255,255,true);
		for k,v in ipairs(getElementsByType("vehicle")) do
			if getElementDimension(v) == getElementDimension(playerSource) then 
				vX,vY,vZ = getElementPosition(v);
				local dist = getDistanceBetweenPoints3D(pX,pY,pZ,vX,vY,vZ);
				local id = getElementData(v,"veh:id");
				local owner = getElementData(v,"veh.ownername") or "Unkown";
				if dist <= 15 then
					outputChatBox("Vehicle name: "..sColor..getVehicleName(v)..white.. " | Distance: " ..sColor..math.ceil(dist) ..white.. " meter | ID: [" ..sColor.. id ..white.. "] | Owner: " ..sColor..owner, playerSource, 255,255,255,true);
				end
			end
		end
	end
end);
function unflipCar(thePlayer, commandName, targetPlayer)
	if (tonumber(getElementData(thePlayer, "admin >> level")) > 2) then
		if not targetPlayer then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."You are not in a vehicle.", thePlayer,210, 77, 87,true);
			else
				local veh = getPedOccupiedVehicle(thePlayer);
				local rx, ry, rz = getVehicleRotation(veh);
				setVehicleRotation(veh, 0, ry, rz);
				outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."Your vehicle is reversed.", thePlayer, 0, 255, 0,true);
			end
		else
			local targetPlayer = exports["fv_engine"]:findPlayer(thePlayer, targetPlayer);
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedIn");
				
				if (not logged) then
					outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."The player is not logged in.", thePlayer, 255, 0, 0,true);
				else
					local pveh = getPedOccupiedVehicle(targetPlayer);
					if pveh then
						local rx, ry, rz = getVehicleRotation(pveh);
						setVehicleRotation(pveh, 0, ry, rz);
						outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."Your vehicle has been restored " ..sColor..exports.fv_admin:getAdminName(thePlayer,true) ..white.. ".", targetPlayer,  255, 194, 14,true)
						outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."We have recovered "..sColor ..getElementData(targetPlayer,"char >> name"):gsub("_"," ") ..white.. " vehicle.", thePlayer,  255, 194, 14,true)
					else
						outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red")..getElementData(targetPlayer,"char >> name"):gsub("_"," ") .. " not in vehicle.", thePlayer, 210, 77, 87,true);
					end
				end
			end
		end
	end
end
addCommandHandler("unflip", unflipCar, false, false);
addCommandHandler("fuelveh", function(playerSource, cmd, player)
    if (tonumber(getElementData(playerSource, "admin >> level")) > 7) then
        if player then
            local targetPlayer,targetPlayerName = exports["fv_engine"]:findPlayer(playerSource, player);
            if targetPlayer then
                local playerInVehicle = getPedOccupiedVehicle(targetPlayer);
                if playerInVehicle then
                    setElementData(playerInVehicle,"veh:uzemanyag",100);
                    outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."An admin refueled your vehicle!!",targetPlayer,255,255,255,true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."An admin refueled your vehicle!!",playerSource,255,255,255,true);
                    exports.fv_logs:createLog("FUELVEH",getElementData(playerSource,"admin >> name").. " filled "..(getElementData(targetPlayer,"char >> name"):gsub("_"," ")).." vehicle.",playerSource,targetPlayer);
                    exports.fv_admin:sendMessageToAdmin(playerSource,sColor..getElementData(playerSource,"admin >> name")..white.." filled "..sColor..(getElementData(targetPlayer,"char >> name"):gsub("_"," "))..white.." vehicle.",3);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."Player is not sitting in a vehicle!",playerSource,255,255,255,true);
                end
            end	
        else
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/".. cmd .. " [id/name]",playerSource,255,255,255,true);
        end
	end
end);
addCommandHandler("delveh",function(player,cmd,target)
	if getElementData(player,"admin >> level") > 7 then 
		if not target then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [vehicle id]",player,255,255,255,true) return end;
		local target = math.floor(tonumber(target));
		if not target then return outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [vehicle id]",player,255,255,255,true) end;
        local veh = findVehicle(target);
        if loadedVehicles[target] then 
            deleteVehicle(target);
            exports.fv_logs:createLog("DELVEH",exports.fv_admin:getAdminName(player).. " deleted a vehicle. ID: "..target,player);
            exports.fv_admin:sendMessageToAdmin(player,sColor..getElementData(player,"admin >> name")..white.." deleted a vehicle. ID: "..sColor..target..white..".",3);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."Vehicle not found!",player,255,255,255,true);
        end
	end
end)

addCommandHandler("rtc",function(thePlayer,cmd)
	if getElementData(thePlayer,"admin >> level") > 3 then 
		local px, py, pz = getElementPosition(thePlayer)
		for k, v in ipairs(getElementsByType("vehicle")) do 
			local vx, vy, vz = getElementPosition(v)
			local dist = getDistanceBetweenPoints3D ( px, py, pz, vx, vy, vz )
			local int, dim = getElementInterior(thePlayer), getElementDimension(thePlayer)
			local tint, tdim = getElementInterior(v), getElementDimension(v)
			if dist <= 3 and int == tint and dim == tdim then
                local parkedPosition = getElementData(v,"vehicle.parkedPosition");
                setElementPosition(v,parkedPosition[1],parkedPosition[2],parkedPosition[3]);
                setElementRotation(v,parkedPosition[4],parkedPosition[5],parkedPosition[6]);
                setElementInterior(v,parkedPosition[7]);
                setElementDimension(v,parkedPosition[8]);
                fixVehicle(v);
                setElementData(v,"veh:locked",true);
                setVehicleLocked(v,true);
                setElementData(v,"veh:motorStatusz",false);
                setVehicleEngineState(v,false);
                setElementData(v,"veh:lights",false);
                setVehicleOverrideLights(v,1);
                outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."You have successfully RTC-ed the vehicle. ID: "..sColor.. getElementData(v, "veh:id") ..white.. ".", thePlayer, 255, 255, 255, true)		
                exports.fv_logs:createLog("RTC",getElementData(thePlayer,"admin >> name").. " RTC-ed a vehicle. ID: "..(getElementData(v,"veh:id")),thePlayer);
                exports.fv_admin:sendMessageToAdmin(thePlayer,sColor..getElementData(thePlayer,"admin >> name")..white.." He RTC-ed a vehicle. ID: "..sColor..(getElementData(v,"veh:id"))..white..".",3);			
			end
		end
	end
end);

function isVehicleOccupied(veh)
	local occupants = getVehicleOccupants(veh);
	for i, v in pairs(occupants) do
		if (v) then
			return true
		end
	end
	return false;
end

function rtcAll(player, cmd)
	if tonumber(getElementData(player,"admin >> level")) > 7 then
		for k, v in pairs(getElementsByType("vehicle")) do
			local parkedPosition = getElementData(v,"vehicle.parkedPosition");
			if (parkedPosition) then
				setElementPosition(v,parkedPosition[1],parkedPosition[2],parkedPosition[3]);
				setElementRotation(v,parkedPosition[4],parkedPosition[5],parkedPosition[6]);
				setElementInterior(v,parkedPosition[7]);
				setElementDimension(v,parkedPosition[8]);
				fixVehicle(v);
				setElementData(v,"veh:locked",true);
				setVehicleLocked(v,true);
				setElementData(v,"veh:motorStatusz",false);
				setVehicleEngineState(v,false);
				setElementData(v,"veh:lights",false);
				setVehicleOverrideLights(v,1);
			end
		end
		
		exports.fv_logs:createLog("RTC",getElementData(player,"admin >> name").. " RTC-ed all vehicles.",player);
		outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."You have successfully RTC-ed all vehicles.", player, 255, 255, 255, true);
		exports.fv_admin:sendMessageToAdmin(player,sColor..getElementData(player,"admin >> name")..white.." RTC-ed all vehicles.", 7);			
	end
end
addCommandHandler("rtcall", rtcAll, false, false);

--[[
addCommandHandler("rtc2",function(thePlayer,command)
	if getElementData(thePlayer,"admin >> level") > 3 then 
		local px, py, pz = getElementPosition(thePlayer)
		for k, v in ipairs(getElementsByType("vehicle")) do 
			vx, vy, vz = getElementPosition(v)
			local dist = getDistanceBetweenPoints3D ( px, py, pz, vx, vy, vz )
			local int, dim = getElementInterior(thePlayer), getElementDimension(thePlayer)
			local tint, tdim = getElementInterior(v), getElementDimension(v)
			if dist <= 3 and int == tint and dim == tdim then
				setElementPosition(v, -6000, -6000-(getElementData(v,"veh:id")), 30,true)
				setElementDimension(v,0);
				setElementInterior(v,0);
				setElementFrozen(v,true);

				outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."Sikeresen RTC2-zted a járművet. ID: "..sColor.. getElementData(v, "veh:id") ..white.. ".", thePlayer, 255, 255, 255, true)		
				exports.fv_logs:createLog("RTC2",getElementData(thePlayer,"admin >> name").. " RTC2-zött egy járművet. ID: "..(getElementData(v,"veh:id")),thePlayer);
				exports.fv_admin:sendMessageToAdmin(thePlayer,sColor..getElementData(thePlayer,"admin >> name")..white.." RTC2-zött egy járművet. ID: "..sColor..(getElementData(v,"veh:id"))..white..".",3);	
			end
		end
	end
end);
--]]

addCommandHandler("setcarhp",function(thePlayer,command,value)
	if getElementData(thePlayer,"admin >> level") > 4 then 
		local veh = getPedOccupiedVehicle(thePlayer);
		if veh then 
			if not value or not tonumber(value) then 
				outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [value (350-1000)]",thePlayer,255,255,255,true);
				return;
			end
			local value = math.floor(tonumber(value));
			if value > 349 and value < 1001 then 
				if setElementHealth(veh,value) then 
					outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."You have successfully set the vehicle HP. ID: "..sColor.. getElementData(veh, "veh:id") ..white.. ", HP: "..sColor..value..white..".", thePlayer, 255, 255, 255, true)		
					exports.fv_logs:createLog("SETCARHP",getElementData(thePlayer,"admin >> name").. " set the HP of a car. ID: "..(getElementData(veh,"veh:id"))..", HP: "..value..".",thePlayer);
					exports.fv_admin:sendMessageToAdmin(thePlayer,sColor..getElementData(thePlayer,"admin >> name")..white.." set the HP of a car. ID: "..sColor..(getElementData(veh,"veh:id"))..white..", HP: "..sColor..value..white..".",3);	
				else 
					outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."The value you entered is incorrect!",thePlayer,255,255,255,true);
					return;
				end
			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."The value you entered is incorrect!",thePlayer,255,255,255,true);
				return;
			end
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").."You're not in a vehicle!",thePlayer,255,255,255,true);
			return;
		end
	end
end);

function setColor(player, commandName, r1, g1, b1, r2, g2, b2 )
	if getElementData(player, "admin >> level") > 7 then
		if not (r1) or not (g1) or not (b1) then
			outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/" .. commandName .. " [R] [G] [B]", player, 255, 255, 255, true)
		else
			local veh = getPedOccupiedVehicle(player)
			if (veh) then
				local r1, g1, b1, r2, g2, b2 = tonumber(r1), tonumber(g1), tonumber(b1), tonumber(r2), tonumber(g2), tonumber(b2)
				local color = setVehicleColor(veh, r1, g1, b1, r2, g2, b2)
				local sql = dbExec(connection, "UPDATE jarmuvek SET jarmuSzine=? WHERE id=?", toJSON({r1, g1, b1, r2, g2, b2}), getElementData(veh, "veh:id"))
				exports.fv_logs:createLog("SETCOLOR",exports.fv_admin:getAdminName(player).. " He repainted a vehicle. ID: "..getElementData(veh,"veh:id"),player);
				exports.fv_admin:sendMessageToAdmin(player,sColor..exports.fv_admin:getAdminName(player).. " He repainted a vehicle. ID: "..sColor..getElementData(veh,"veh:id")..white..".",3);
				if (color) or (sql) then
					outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","servercolor").."You have successfully recolored the vehicle.", player, 255, 255, 255, true)
				else
					outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").. "Failed to repaint the vehicle.", player, 255, 254, 255, true)
				end
			end
		end
	end
end
addCommandHandler("setvehiclecolor", setColor, false, false)
addCommandHandler("setvehcolor", setColor, false, false)
addCommandHandler("setcolor", setColor, false, false)

function ChangeLock(player,command)
	local veh = getPedOccupiedVehicle(player);
	if veh then
		local vehFaction = getElementData(veh, "veh:faction");
		if (getElementData(player, "faction_"..vehFaction.."_leader")) then
			local id = getElementData(veh,"veh:id");
			if id > 0 then 
				local suc = exports.fv_inventory:givePlayerItem(player,40,1,id,100,0);
				if suc then
					outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."You have successfully made a key to the car!",player,255,255,255,true);

					sendMessageToAdmin(player,getAdminName(player,true).." asked for a key for a vehicle. ID: "..sColor..id..white..".", 3);
					exports.fv_logs:createLog("CHANGELOCK",getAdminName(player,true).." asked for a key for a vehicle. ID: "..id..".",player);

				else 
					outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You have no place for the key!",player,255,255,255,true);
				end
			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can't make a key for this game!",player,255,255,255,true);
			end
		else
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You are not the leader of this faction!",player,255,255,255,true);
		end
	else 
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You're not in a vehicle!",player,255,255,255,true);
	end
end
addCommandHandler("changelock",ChangeLock,false,false);
-----------
