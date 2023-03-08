--SocialGaming 2019
--Script: Csoki
local sql = exports.fv_engine:getConnection(getThisResource());
local strings = {"Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M","1","2","3","4","5","6","7","8","9"}

Async:setPriority("high");

addEventHandler("onResourceStart",getRootElement(),function(res)
	if getResourceName(res) == "fv_engine" or getThisResource() == res then 
		sColor = exports.fv_engine:getServerColor("servercolor",true);
	end
end);

function loadVehicle(id)
    dbQuery(function(qh)
        Async:foreach(dbPoll(qh,0),function(v)
            local rot = fromJSON(v.rot);
            local veh = createVehicle(tonumber(v.model),tonumber(v.x),tonumber(v.y),tonumber(v.z),tonumber(rot[1] or 0),tonumber(rot[2] or 0),tonumber(rot[3] or 0),tostring(v.rendszam));
            if veh then 
				setElementData(veh,"veh:id",tonumber(v.id));
				if tonumber(v.uzemanyag) < 0 then 
					setElementData(veh,"veh:uzemanyag",0);
				else 
					setElementData(veh,"veh:uzemanyag",tonumber(v.uzemanyag));
				end
                setElementData(veh,"veh:tulajdonos",v.tulajdonos);
                setElementData(veh,"veh:faction",v.frakcio);
                setElementData(veh,"veh:km",v.km);

                setElementData(veh,"veh:alvazSzam",v.alvazSzam);
                setElementData(veh,"veh:motorSzam",v.motorSzam);

                local vehColor = fromJSON(tostring(v["jarmuSzine"]));
                setVehicleColor(veh,vehColor[1],vehColor[2],vehColor[3],vehColor[4],vehColor[5],vehColor[6]);

				local lightColor = fromJSON(tostring(v["lampaSzine"]));
				setVehicleHeadLightColor(veh, lightColor[1], lightColor[2], lightColor[3]);

                setElementData(veh,"veh:motorStatusz",convertBool(v.motorStatusz));
                setElementData(veh,"veh:lampa",convertBool(v.lampa));
                setElementData(veh,"veh:locked",convertBool(v.locked));

                setElementData(veh,"handbrake",false);

				setVehiclePlateText(veh,tostring(v.rendszam));
				setElementData(veh,"veh:rendszam",tostring(v.rendszam));

                if not findOwner(veh) and v.frakcio == 0 then 
					setElementDimension(veh,math.random(2,100));
					setElementData(veh,"veh.saved",true);
					setElementData(veh,"veh.savedDim",v.dimension);
                else 
                    setElementDimension(veh,v.dimension);
                end
                setElementInterior(veh,v.interior);

				setElementData(veh,"veh:park",{tonumber(v.x),tonumber(v.y),tonumber(v.z),v.dimension,v.interior})

                if v.frakcio > 0 then 
                    setOwnerName(veh,v.frakcio,true);
                else
                    setOwnerName(veh,v.tulajdonos);
                end

                local panels = fromJSON(v.jarmuToresek);
                if panels and #panels == 11 then 
                    for panel,state in pairs(panels) do 
                        local panel = tonumber(panel);
                        if panel < 7 then --Panels
                            setVehiclePanelState(veh,tonumber(panel),tonumber(state));
                        elseif panel > 6 and panel < 12 then --Doors
                            setVehicleDoorState(veh,tonumber(panel-6),tonumber(state));
                        end
                    end
                end

                setElementData(veh,"veh:ablak",false);

                setElementHealth(veh,v.hp);

				slowLoad(veh);
				exports.fv_tuning:loadVehicleTuning(veh);
            else 
                outputDebugString("[VEHICLE] "..id.." loading failed!",0,255,0,0);
            end
        end);
    end,sql,"SELECT * FROM jarmuvek WHERE id=?",id);
end

function loadAllVehicle()
    dbQuery(function(qh)
        local tick = getTickCount();
        local count = 0;
        Async:foreach(dbPoll(qh,0),function(v)
            loadVehicle(v.id);
            count = count + 1;
        end,function()
            outputDebugString("[VEHICLE] "..count.." vehicle(s) loaded in "..(getTickCount()-tick).." ms",0,255,255,0);
        end);
    end,sql,"SELECT id FROM jarmuvek");
end
addEventHandler("onResourceStart",resourceRoot,loadAllVehicle);

function saveVehicle(veh)
    local id = getElementData(veh,"veh:id");
	local x,y,z = getElementPosition(veh);
    local rot = toJSON({getElementRotation(veh)});
    local interior,dimension = getElementInterior(veh),getElementDimension(veh);
    local owner = findOwner(veh);
    if not owner and getElementData(veh,"veh:tulajdonos") > 0 then 
        dimension = getElementData(veh,"veh:tulajdonos");
	end
	local parkData = (getElementData(veh,"veh:park") or false);
	if parkData then 
		x,y,z,dimension,interior = unpack(parkData)
	end
    local panels = {};
    for i=0,6 do 
        panels[i] = getVehiclePanelState(veh,i);
    end
    for i=0,5 do 
        panels[6+i] = getVehicleDoorState(veh,i);
    end
    dbExec(sql,"UPDATE jarmuvek SET hp=?, x=?, y=?, z=?, rot=?,interior=?, dimension=?, uzemanyag=?, lampa=?, locked=?, motorStatusz=?, tulajdonos=?, jarmuToresek=?, motorSzam=?, alvazSzam=?, rendszam=?, ablak=? WHERE id=?",getElementHealth(veh),x,y,z,rot,interior,dimension,(getElementData(veh,"uzemanyag") or 100), convertNumber(getElementData(veh,"veh:lights")), convertNumber(getElementData(veh,"veh:locked")), convertNumber(getElementData(veh,"veh:motorStatusz")),getElementData(veh,"veh:tulajdonos"),toJSON(panels),getElementData(veh,"veh:motorSzam"),getElementData(veh,"veh:alvazSzam"),getVehiclePlateText(veh),convertNumber(getElementData(veh,"veh:ablak")),id);
end

function saveAllVehicle()
    local vehicles = getElementsByType("vehicle");
    local tick = getTickCount();
    local count = 0;
    Async:foreach(vehicles,function(v)
        if (getElementData(v,"veh:id") or -1) > 0 then 
            saveVehicle(v);
            count = count + 1;
        end
    end);
    outputDebugString("[VEHICLE] "..count.." vehicle(s) saved in "..(getTickCount()-tick).." ms",0,255,255,0);
end
addEventHandler("onResourceStop",resourceRoot,saveAllVehicle);
setTimer(saveAllVehicle,1000*60*30,0); --Fél óránként mentés

-- addEventHandler("onVehicleExit",root,function(player)
--     if getElementData(source,"veh:id") > 0 then 
--         saveVehicle(source);
--     end
-- end);

addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "vehicle" then 
        if dataName == "veh:motorStatusz" then --Motor
            setVehicleEngineState(source,newValue);
        end
        if dataName == "veh:lights" then --Lampa
            if newValue then 
                setVehicleOverrideLights(source,2);
            else 
                setVehicleOverrideLights(source,1);
            end
        end
        if dataName == "veh:locked" then 
            setVehicleLocked(source,newValue);
        end
    end
end);

--VEHICLE DAMAGE--
addEventHandler("onVehicleDamage",root,function(loss) --Nem robban fel meg ilyenek
	if getElementHealth(source) < 300 or (getElementHealth(source)-loss) < 300 then
		setElementHealth(source,350);
		setElementData(source,"veh:motorStatusz",false);
		resetVehicleExplosionTime(source);
	end
end);

setTimer(function() --Nem robbannak a kocsik.
	local vehicles = getElementsByType("vehicle",root);
	Async:foreach(vehicles,function(v)
		if getElementHealth(v) < 300 then 
			setElementHealth(v,350);
			setElementData(v,"veh:motorStatusz",false);
			setVehicleEngineState(v,false);
		end
	end);
end,2000,0);
-----------------

addEventHandler("onVehicleEnter",root,function()
    if isBike(source) then 
        setElementData(source,"veh:motorStatusz",true);
    else 
        if getElementData(source,"veh:motorStatusz") then 
            setVehicleEngineState(source,true);
        else 
            setVehicleEngineState(source,false);
        end
    end
end);

addEventHandler("onVehicleStartEnter",root,function(player)
	if getElementData(source,"veh:locked") then 
		outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Jármű zárva!",player,255,255,255,true);
		exports.fv_infobox:addNotification(player,"error","Jármű zárva!");
		cancelEvent();
	end
end);

addEventHandler("onVehicleStartExit",root,function(player)
    if getElementData(source,"veh:locked") then 
        outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Jármű zárva!",player,255,255,255,true);
        cancelEvent();
	end
	if not isBike(source) or not getVehicleType(source) == "Bike" then 
		if getElementData(player,"veh:ov") then 
			outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Előbb kösd ki az övedet!",player,255,255,255,true);
			cancelEvent();
		end
	end
end);

function addVehicle(tulajID,modelID,x,y,z,sqlID,r,g,b,fraki,rotation)
    if not fraki then fraki = 0 end;
    if not rotation then rotation = 0 end;
    local veh = createVehicle(modelID,x,y,z)
	if not veh then 
		outputDebugString("[VEHICLE] "..sqlID.." (dbid) load failed, SQL data deleted.",1)
		dbExec(sql,"DELETE FROM jarmuvek WHERE id=?",sqlID);
		return;
    end
	setElementData(veh,"veh:alvazSzam",tostring(createRandomString()))
	setElementData(veh,"veh:motorSzam",tostring(createRandomString()))

    setElementData(veh,"veh:uzemanyag",100);
    setElementData(veh,"veh:id",sqlID);
    setElementData(veh,"veh:lights",false);
    setElementData(veh,"veh:motorStatusz",false);
    setElementData(veh,"veh:locked",false);
    setElementData(veh,"handbrake",false);
    setElementData(veh,"veh:km",0);
    setElementData(veh,"veh:tulajdonos",tulajID);
    setElementData(veh,"veh:faction",fraki);
    setVehicleColor(veh,r,g,b);

    setElementInterior(veh,0);
    setElementDimension(veh,0);

    setElementRotation(veh,0,0,rotation);

    if fraki == 0 then 
        setOwnerName(veh,tulajID);
    else 
        setOwnerName(veh,fraki,true);
    end
    
    local plate = createPlate();
	setVehiclePlateText(veh,plate);
    setElementData(veh,"veh:rendszam",plate);
	
	exports.fv_tuning:loadVehicleTuning(veh);

    dbExec(sql,"UPDATE jarmuvek SET rendszam=?, km=0 WHERE id=?",plate,sqlID);
end
--PARANCSOK--
addCommandHandler("makeveh",
function (playerSource, cmd, target, modellID , r,g,b,faction)
	if (tonumber(getElementData(playerSource,"admin >> level")) > 7) then
		if target and modellID and r and g and b and getElementDimension(playerSource)==0 and getElementInterior(playerSource) == 0 then
        local dyk = modellID
        modellID = tonumber(modellID)
        if not modellID then
            modellID = getVehicleModelFromName(dyk)
        end
        if not faction then 
            faction = 0;
        end
        faction = math.floor(tonumber(faction))
        local targetPlayer,targetPlayerName = exports["fv_engine"]:findPlayer(playerSource, target)
        if targetPlayer then
            local owner = 0;
            if faction > 0 then 
                owner = -faction
            else
                owner = getElementData(targetPlayer,"acc >> id");
            end
            local x,y,z = getElementPosition(targetPlayer);
                local insterT = dbQuery(function(qh) 
                    local QueryEredmeny, _, Beszurid = dbPoll(qh, 0)
                    if QueryEredmeny then
                        local rx,ry,rz = getElementRotation(targetPlayer);
                        addVehicle(tonumber(getElementData(targetPlayer,"acc >> id")),tonumber(modellID),x,y,z,Beszurid,r,g,b,faction)
                        outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Sikeres jámű létrehozás! ID: " ..Beszurid,playerSource,255,255,255,true)
                        exports.fv_logs:createLog("CreateVeh",exports.fv_admin:getAdminName(playerSource).. " Létrehozott egy járművet: "..getVehicleNameFromModel(modellID)..", Tulaj: "..(getElementData(targetPlayer,"char >> name"):gsub("_"," "))..".",playerSource,targetPlayer);
                        exports.fv_admin:sendMessageToAdmin(playerSource,sColor..getElementData(playerSource,"admin >> name")..white.." létrehozott egy járművet. Modell: "..sColor..getVehicleNameFromModel(modellID)..white..", Tulaj: "..sColor..(getElementData(targetPlayer,"char >> name"):gsub("_"," "))..white..".",3);
                    end
                end,sql, "INSERT INTO jarmuvek SET x=?,y=?,z=?,model=?,interior=?,dimension=?,tulajdonos=?,jarmuSzine=?,frakcio=?,rot=?",x,y,z,modellID,0,0,owner,toJSON({tonumber(r),tonumber(g),tonumber(b),0,0,0}),faction,toJSON({rx,ry,rz}))
            end
		else
			outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..cmd.." #ffffff[ID] [jármű ID] [r] [g] [b] [frakció]",playerSource,255,255,255,true)
		end	
	end
end)

addCommandHandler("nearbyvehicles",
function(playerSource, cmd)
	if (tonumber(getElementData(playerSource,"admin >> level")) > 0) then
		local pX,pY,pZ = getElementPosition(playerSource)
		outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Közelben lévő járművek:",playerSource,255,255,255,true)
		for k,v in ipairs(getElementsByType("vehicle")) do
			if getElementDimension(v) == getElementDimension(playerSource) then 
				vX,vY,vZ = getElementPosition(v)
				local dist = getDistanceBetweenPoints3D(pX,pY,pZ,vX,vY,vZ)
				local id = getElementData(v,"veh:id")
				local owner = getElementData(v,"veh.ownername") or "Ismeretlen"
				if dist <= 15 then
					local color = exports.fv_engine:getServerColor("servercolor",true);
					local white = "#FFFFFF";
					outputChatBox("Jármű neve: "..color..getVehicleName(v)..white.. " | Távolság: " ..color..math.ceil(dist) ..white.. " méter | ID: [" ..color.. id ..white.. "] | Tulajdonos: " ..color..owner, playerSource, 255,255,255,true)
				end
			end
		end
	end
end)

addCommandHandler("getcar",
	function(playerSource, cmd, id)
		if (tonumber(getElementData(playerSource,"admin >> level")) > 2) then
			if not id then outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..cmd.." [id]",playerSource,255,255,255,true) return end;
			local kocsi = findVehicle(id)
			local x,y,z = getElementPosition(playerSource)
			if kocsi then 
				outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Sikeresen magadhoz teleportáltad a következő kocsit: " ..id,playerSource,255,255,255,true)
				setElementPosition(kocsi,x+4,y,z)
				setElementDimension(kocsi,getElementDimension(playerSource))
				setElementInterior(kocsi, getElementInterior(playerSource))
			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Nincs találat!",playerSource,255,255,255,true)
			end
		end
	end
)

addCommandHandler("gotocar",
	function(playerSource, cmd, id)
		if (tonumber(getElementData(playerSource,"admin >> level")) > 2) then
			if not id then outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..cmd.." [id]",playerSource,255,255,255,true) return end;
			if tonumber(id) > 0 then
				local kocsi = findVehicle(id)
				local x,y,z = getElementPosition(kocsi)
				if kocsi then 
					outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Sikeresen teleportáltál a következő kocsihoz: " ..id,playerSource,255,255,255,true)
					setElementPosition(playerSource,x+4,y,z)
					setElementDimension(playerSource,getElementDimension(kocsi))
					setElementInterior(playerSource, getElementDimension(kocsi))
				else 
					outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Nincs találat!",playerSource,255,255,255,true)
				end
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..cmd.." [ID]", playerSource,166,196,103,true)			
			end
		end
	end
)

function unflipCar(thePlayer, commandName, targetPlayer)
	if (tonumber(getElementData(thePlayer, "admin >> level")) > 2) then
		if not targetPlayer then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Nem vagy jármûben.", thePlayer,210, 77, 87,true)
			else
				local veh = getPedOccupiedVehicle(thePlayer)
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRotation(veh, 0, ry, rz)
				outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."A jármûved visszafordítva.", thePlayer, 0, 255, 0,true)
			end
		else
			local targetPlayer,targetPlayerName = exports["fv_engine"]:findPlayer(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedIn")
				
				if (not logged) then
					outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."A játékos nincs bejelentkezve.", thePlayer, 255, 0, 0,true)
				else
					local pveh = getPedOccupiedVehicle(targetPlayer)
					if pveh then
						local rx, ry, rz = getVehicleRotation(pveh)
						setVehicleRotation(pveh, 0, ry, rz)
						local color = exports.fv_engine:getServerColor("servercolor",true);
						outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."A jármûved helyreállította " ..color..exports.fv_admin:getAdminName(thePlayer,true) .. "#ffffff.", targetPlayer,  255, 194, 14,true)
						outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Helyreállítottad "..color ..getElementData(targetPlayer,"char >> name"):gsub("_"," ") .. "#ffffff jármûvét.", thePlayer,  255, 194, 14,true)
					else
						outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red")..getElementData(targetPlayer,"char >> name"):gsub("_"," ") .. " nincs jármûben.", thePlayer, 210, 77, 87,true)
					end
				end
			end
		end
	end
end
addCommandHandler("unflip", unflipCar, false, false)

addCommandHandler("fuelveh",
	function(playerSource, cmd, player)
		if (tonumber(getElementData(playerSource, "admin >> level")) > 6) then
			if player then
				local targetPlayer,targetPlayerName = exports["fv_engine"]:findPlayer(playerSource, player)
				if targetPlayer then
					local playerInVehicle = getPedOccupiedVehicle(targetPlayer)
						if playerInVehicle then
							setElementData(playerInVehicle,"veh:uzemanyag",100)
							outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Egy admin megtankolta a járműved!",targetPlayer,255,255,255,true)
							outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Sikeresen megtankoltad a járművet!",playerSource,255,255,255,true)
							exports.fv_logs:createLog("FUELVEH",getElementData(playerSource,"admin >> name").. " megtankolta "..(getElementData(targetPlayer,"char >> name"):gsub("_"," ")).." járművét.",playerSource,targetPlayer);
							exports.fv_admin:sendMessageToAdmin(playerSource,sColor..getElementData(playerSource,"admin >> name")..white.." megtankolta "..sColor..(getElementData(targetPlayer,"char >> name"):gsub("_"," "))..white.." járművét.",3);
						else 
							outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Játékos nem ül járműben!",playerSource,255,255,255,true);
						end
				end	
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/".. cmd .. " [id/név]",playerSource,255,255,255,true)
			end
		end
	end
)

addCommandHandler("delveh",function(player,cmd,target)
	if getElementData(player,"admin >> level") > 7 then 
		if not target then outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..cmd.." [jármű id]",player,255,255,255,true) return end;
		local target = math.floor(tonumber(target));
		if target then 
			local veh = findVehicle(target);
			if veh then 
				destroyElement(veh);
				dbExec(sql,"DELETE FROM jarmuvek WHERE id=?",target);
				exports.fv_logs:createLog("DELVEH",exports.fv_admin:getAdminName(player).. " törölt egy járművet. ID: "..target,player);
				exports.fv_admin:sendMessageToAdmin(player,sColor..getElementData(player,"admin >> name")..white.." törölt egy járművet. ID: "..sColor..target..white..".",3);
			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Jármű nem található!",player,255,255,255,true);
			end
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..cmd.." [jármű id]",player,255,255,255,true);
			return;
		end
	end
end)

addCommandHandler("rtc",function(thePlayer,cmd)
	if getElementData(thePlayer,"admin >> level") > 3 then 
		local px, py, pz = getElementPosition(thePlayer)
	
	for k, v in ipairs(getElementsByType("vehicle")) do 
		vx, vy, vz = getElementPosition(v)
		local dist = getDistanceBetweenPoints3D ( px, py, pz, vx, vy, vz )
		local int, dim = getElementInterior(thePlayer), getElementDimension(thePlayer)
		local tint, tdim = getElementInterior(v), getElementDimension(v)
		if dist <= 3 and int == tint and dim == tdim then
		
			local vehicleQ = dbQuery(function(qh)
				local vehicleH,vehszam = dbPoll(qh,0)
				if #vehicleH > 0 then
					for k1,v1 in ipairs(vehicleH) do
						setElementPosition(v, v1.x, v1.y, v1.z,true)
						setElementInterior(v, v1.interior or 0)
						setElementDimension(v, v1.dimension or 0)
						local rot = fromJSON(v1.rot)
						setElementRotation(v, rot[1], rot[2], rot[3])
						setElementData(v, "veh:uzemanyag", 100)
						setElementData(v, "veh:akkumulator", 100)
						fixVehicle(v)
						setVehicleLocked(v, true)
						setElementData(v,"veh:locked",true)
						setElementData(v, "veh:lampa", 0)
						setVehicleOverrideLights(v, 1)
						setElementData(v, "veh:motorStatusz", false);
						setVehicleEngineState(v,false);
						outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Sikeresen RTC-zted a járművet. ID: "..sColor.. getElementData(v, "veh:id") ..white.. ".", thePlayer, 255, 255, 255, true)		
						exports.fv_logs:createLog("RTC",getElementData(thePlayer,"admin >> name").. " RTC-zett egy járművet. ID: "..(getElementData(v,"veh:id")),thePlayer);
						exports.fv_admin:sendMessageToAdmin(thePlayer,sColor..getElementData(thePlayer,"admin >> name")..white.." RTC-zett egy járművet. ID: "..sColor..(getElementData(v,"veh:id"))..white..".",3);			
					end
				end
			end,sql,"SELECT * FROM jarmuvek WHERE id='" .. getElementData(v, "veh:id") .. "'")
		end
	end
	end
end);

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

			outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Sikeresen RTC2-zted a járművet. ID: "..sColor.. getElementData(v, "veh:id") ..white.. ".", thePlayer, 255, 255, 255, true)		
			exports.fv_logs:createLog("RTC2",getElementData(thePlayer,"admin >> name").. " RTC2-zött egy járművet. ID: "..(getElementData(v,"veh:id")),thePlayer);
			exports.fv_admin:sendMessageToAdmin(thePlayer,sColor..getElementData(thePlayer,"admin >> name")..white.." RTC2-zött egy járművet. ID: "..sColor..(getElementData(v,"veh:id"))..white..".",3);	
		end
	end
	end
end);

addCommandHandler("setcarhp",function(thePlayer,command,value)
	if getElementData(thePlayer,"admin >> level") > 4 then 
		local veh = getPedOccupiedVehicle(thePlayer);
		if veh then 
			if not value or not tonumber(value) then 
				outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..command.." [érték (350-1000)]",thePlayer,255,255,255,true);
				return;
			end
			local value = math.floor(tonumber(value));
			if value > 349 and value < 1001 then 
				if setElementHealth(veh,value) then 
					outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Sikeresen beállítottad a jármű HP-ját. ID: "..sColor.. getElementData(veh, "veh:id") ..white.. ", HP: "..sColor..value..white..".", thePlayer, 255, 255, 255, true)		
					exports.fv_logs:createLog("SETCARHP",getElementData(thePlayer,"admin >> name").. " beállította egy kocsi HP-ját. ID: "..(getElementData(veh,"veh:id"))..", HP: "..value..".",thePlayer);
					exports.fv_admin:sendMessageToAdmin(thePlayer,sColor..getElementData(thePlayer,"admin >> name")..white.." beállította egy kocsi HP-ját. ID: "..sColor..(getElementData(veh,"veh:id"))..white..", HP: "..sColor..value..white..".",3);	
				else 
					outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Hibás a megadott érték!",thePlayer,255,255,255,true);
					return;
				end
			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Hibás a megadott érték!",thePlayer,255,255,255,true);
				return;
			end
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Nem ülsz járműben!",thePlayer,255,255,255,true);
			return;
		end
	end
end);

function setColor(player, commandName, r1, g1, b1, r2, g2, b2 )
	if getElementData(player, "admin >> level") > 7 then
		if not (r1) or not (g1) or not (b1) then
			outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/" .. commandName .. " [R] [G] [B]", player, 255, 255, 255, true)
		else
			local veh = getPedOccupiedVehicle(player)
			if (veh) then
				local r1, g1, b1, r2, g2, b2 = tonumber(r1), tonumber(g1), tonumber(b1), tonumber(r2), tonumber(g2), tonumber(b2)
				local color = setVehicleColor(veh, r1, g1, b1, r2, g2, b2)
				local sql = dbExec(sql, "UPDATE jarmuvek SET jarmuSzine=? WHERE id=?", toJSON({r1, g1, b1, r2, g2, b2}), getElementData(veh, "veh:id"))
				exports.fv_logs:createLog("SETCOLOR",exports.fv_admin:getAdminName(player).. " Átszinezett egy járművet. ID: "..getElementData(veh,"veh:id"),player);
				exports.fv_admin:sendMessageToAdmin(player,sColor..exports.fv_admin:getAdminName(player).. " Átszinezett egy járművet. ID: "..sColor..getElementData(veh,"veh:id")..white..".",3);
				if (color) or (sql) then
					outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Sikeresen átszínezted a járművet.", player, 255, 255, 255, true)
				else
					outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").. "Nem sikerült átszínezni a járművet.", player, 255, 254, 255, true)
				end
			end
		end
	end
end
addCommandHandler("setvehiclecolor", setColor, false, false)
addCommandHandler("setvehcolor", setColor, false, false)
addCommandHandler("setcolor", setColor, false, false)


addCommandHandler("park",function(player,cmd)
    if getElementData(player,"network") then
        local veh = getPedOccupiedVehicle(player); 
        if not veh then outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Nem ülsz járműben!",player,255,255,255,true) return end;
		local vehOwner = getElementData(veh,"veh:tulajdonos");
		local vehFaction = (getElementData(veh,"veh:faction") or 0);
		if vehFaction > 0 then 
			if (getElementData(player,"faction_"..vehFaction.."_leader") or false) or ( getElementData(player,"admin >> level") > 2 and getElementData(player,"admin >> duty") )then 
				local x,y,z = getElementPosition(veh);
				setElementData(veh,"veh:park",{x,y,z,getElementDimension(veh),getElementInterior(veh)});
				saveVehicle(veh);
				outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Sikeresen leparkoltad a járművet!",player,255,255,255,true);
			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Csak leader parkolhatja le!",player,255,255,255,true);
			end
		else
			if ( vehOwner == getElementData(player,"acc >> id") and getElementData(veh,"veh:id") ) or ( getElementData(player,"admin >> level") > 2 and getElementData(player,"admin >> duty") ) then 
				local x,y,z = getElementPosition(veh);
				setElementData(veh,"veh:park",{x,y,z,getElementDimension(veh),getElementInterior(veh)});
				saveVehicle(veh);
				outputChatBox(exports.fv_engine:getServerSyntax("Jármű","servercolor").."Sikeresen leparkoltad a járművet!",player,255,255,255,true);
			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Jármű","red").."Ez nem a te járműved!",player,255,255,255,true);
			end
		end
    end
end)
---------

--UTILS--
function findVehicle(id)
    local vehicles = getElementsByType("vehicle");
    local found = false;
    Async:foreach(vehicles,function(v)
        if tonumber(getElementData(v,"veh:id")) == tonumber(id) or tostring(getElementData(v,"veh:id")) == tostring(id) then
            found = v;
		end
    end);
	return found;
end
function startSlowLoad(veh)
	if not veh then return end;
	setElementAlpha(veh,10);
	setElementCollisionsEnabled(veh,false);
	setElementFrozen(veh,true);
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
						setElementCollisionsEnabled(veh,true);
						setElementFrozen(veh,false);
					end,1500,1);
				end,1500,1);
			end,1500,1);
	end,1500,1);
end
function slowLoad(veh)
	startSlowLoad(veh);
end
function setOwnerName(veh,owner,faction)
    if faction then 
        setElementData(veh,"veh.ownername","Frakció "..owner);
    else 
        dbQuery(function(qh)
            local res = dbPoll(qh,0);
            for k,v in pairs(res) do 
                setElementData(veh,"veh.ownername",v.charname);
            end
        end,sql,"SELECT charname FROM characters WHERE id=?",owner);
    end
end
function createRandomString()
	if strings then
		local stringChanger = ""
		for i=1,8 do
			local randomNum = math.random(1,#strings)
			stringChanger = stringChanger .. strings[randomNum]
		end
		return stringChanger
	end
end
function createPlate()
	if strings then
		local stringChanger = "S-"
		for i=1,6 do
			local randomNum = math.random(1,#strings)
			stringChanger = stringChanger .. strings[randomNum]
		end
		return stringChanger
	end
end
------

--Üzemanyag Fogyasztás
setTimer(function()
	local vehicles = getElementsByType("vehicle");
    Async:foreach(vehicles,function(veh)
        if isBike(veh) then return end;
        if getElementDimension(veh) > 0 then return end;
        if getElementData(veh,"veh:id") and getElementData(veh,"veh:id") < 0 then return end;
        if getElementData(veh,"veh:uzemanyag") and getElementData(veh,"veh:uzemanyag") < 0 then return end;
	   
		if tonumber(getElementData(veh,"veh:uzemanyag") or 0) > 0 or tonumber(getElementData(veh,"veh:uzemanyag") or 0)-1 > 0 or tonumber(getElementData(veh,"veh:uzemanyag") or 0)-0.5 > 0 then
			if getElementData(veh,"veh:motorStatusz") then
				if getVehicleSpeed(veh) > 0 then
                    setElementData(veh,"veh:uzemanyag",getElementData(veh,"veh:uzemanyag") - 1);
                else
                    setElementData(veh,"veh:uzemanyag",getElementData(veh,"veh:uzemanyag") - 0.5);
				end
			end
        else
            setElementData(veh,"veh:uzemanyag",0);
            setElementData(veh,"veh:motorStatusz",false);
		end
	end);
end,1000*60*1.5,0);

--KM mentés
addEvent("veh.saveKilometer",true);
addEventHandler("veh.saveKilometer",root,function(player,veh,km)
	local id = getElementData(veh,"veh:id");
	if id > 0 then 
		dbExec(sql,"UPDATE jarmuvek SET km=? WHERE id=?",km,id);
	end
end);
---------------

--Ha játékos lelép akkor a kocsi más dimenzióba.
addEventHandler("onPlayerQuit",root,function()
    if getElementData(source,"loggedIn") then 
        for k,veh in pairs(getElementsByType("vehicle")) do 
            if getElementData(veh,"veh:faction") == 0 and getElementData(veh,"veh:tulajdonos") == getElementData(source,"acc >> id") then 
				for _,p in pairs(getVehicleOccupants(veh)) do 
					removePedFromVehicle(p);
				end
				setElementData(veh,"veh.savedDim",getElementDimension(veh));
                setElementDimension(veh,math.random(2,100));
                setElementFrozen(veh,true);
				setElementData(veh,"veh.saved",true);
				saveVehicle(veh);
            end
        end
    end
end);
addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "player" then 
        if dataName == "loggedIn" then 
            if newValue then 
                for k,v in pairs(getElementsByType("vehicle")) do 
                    if getElementData(v,"veh.saved") and getElementData(v,"veh:faction") == 0 and getElementData(v,"veh:tulajdonos") == getElementData(source,"acc >> id") then 
                        setElementDimension(v,(getElementData(v,"veh.savedDim") or 0));
                        slowLoad(v);
                    end
                end
            end
        end
    end
end);


addEvent("veh.sound",true);
addEventHandler("veh.sound",root,function(player,veh,sound)
	triggerClientEvent(root,"vehicle.sound",root,veh,sound);
end);

addEvent("vehicle.doorChange",true);
addEventHandler("vehicle.doorChange",root,function(player,veh,door,state)
    if state == "close" then 
        setVehicleDoorOpenRatio(veh,door,0,500);
    else 
        setVehicleDoorOpenRatio(veh,door,90,500);
    end
end);