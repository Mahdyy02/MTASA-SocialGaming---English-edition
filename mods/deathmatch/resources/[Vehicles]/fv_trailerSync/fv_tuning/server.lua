local sql = exports.fv_engine:getConnection(getThisResource());

Async:setPriority("high");

--[[
    MySQL Changes
  
    ALTER TABLE `jarmuvek` CHANGE `jarmuTuningok` `jarmuTuningok` VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '[ [ 1, 1, 1, 1, 1, 1 ] ]'; 
    UPDATE jarmuvek SET jarmuTuningok='[ [ 1, 1, 1, 1, 1, 1 ] ]';

    ALTER TABLE `jarmuvek` CHANGE `stickerID` `stickerID` VARCHAR(255) NOT NULL DEFAULT 'false';
    UPDATE jarmuvek SET stickerID="false";
    ALTER TABLE `jarmuvek` CHANGE `lampaSzine` `lampaSzine` VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '[ [ 255, 255, 255 ] ]';

    ALTER TABLE `jarmuvek` ADD `frontWheel` VARCHAR(255) NOT NULL DEFAULT 'default' AFTER `lampaSzine`;
    ALTER TABLE `jarmuvek` ADD `rearWheel` VARCHAR(255) NOT NULL DEFAULT 'default' AFTER `lampaSzine`;

    ALTER TABLE `jarmuvek` CHANGE `neonID` `neonID` VARCHAR(255) NOT NULL DEFAULT 'false'; 
    UPDATE jarmuvek SET neonID="false";

    ALTER TABLE `jarmuvek` ADD `driveType` VARCHAR(20) NOT NULL DEFAULT 'false' AFTER `km`; 

    ALTER TABLE `jarmuvek` ADD `lsdDoor` INT(1) NOT NULL DEFAULT '0' AFTER `driveType`; 

    ALTER TABLE `jarmuvek` ADD `steeringLock` INT(3) NOT NULL DEFAULT '0' AFTER `lsdDoor`; 

    ALTER TABLE `jarmuvek` ADD `variant` INT(1) NOT NULL DEFAULT '0' AFTER `steeringLock`; 

    ALTER TABLE `jarmuvek` ADD `airRide` VARCHAR(30) NOT NULL DEFAULT 'false' AFTER `variant`; 

    ALTER TABLE `jarmuvek` CHANGE `jarmuOptikaiTuningok` `jarmuOptikaiTuningok` VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]'; 

    UPDATE jarmuvek SET jarmuOptikaiTuningok='[ [ 0, 0, 0, 0, 0, 0, 0 ] ]'
]]

addEventHandler("onVehicleStartExit",root,function(player)
    if getElementData(player,"tuning.use") then 
        cancelEvent();
    end
end);

addEventHandler("onResourceStart",root,function(res)
    if res == getThisResource() or getResourceName(res) == "fv_vehicle" then 
        setTimer(function()
            local vehicles = getElementsByType("vehicle");
            Async:foreach(vehicles,function(v)
                if isElement(v) and (getElementData(v,"veh:id") or 0) > 0 then 
                    loadVehicleTuning(v);
                end
            end);
            -- for k,v in pairs(getElementsByType("vehicle")) do 
            --     if isElement(v) and (getElementData(v,"veh:id") or 0) > 0 then 
            --         loadVehicleTuning(v);
            --     end
            -- end
        end,120,1);
    end
end);

function loadVehicleTuning(veh)
    if getElementData(veh,"veh:id") > 0 then 
        dbQuery(function(qh)
            local res = dbPoll(qh,0);
            for k,v in pairs(res) do 
                setElementData(veh,"tuning.performance",fromJSON(v.jarmuTuningok));

                if v.driveType ~= "false" then 
                    setElementData(veh,"tuning.driveType",v.driveType);
                end

                if v.stickerID == "false" then 
                    setElementData(veh,"tuning.paintJob",false);
                else 
                    setElementData(veh,"tuning.paintJob",v.stickerID);
                end

                if v.neonID == "false" then 
                    setElementData(veh,"tuning.neon",false);
                else 
                    setElementData(veh,"tuning.neon",tostring(v.neonID));
                    setElementData(veh,"tuning.neonState",true);
                end

                if v.lsdDoor == 1 then 
                    setElementData(veh,"tuning.lsdDoor",true);
                else 
                    setElementData(veh,"tuning.lsdDoor",false);
                end

                setElementData(veh,"tuning.variant",v.variant);
                setVehicleVariant(veh,v.variant,v.variant);

                local airRide = false;
                if v.airRide == "true" then 
                    airRide = true;
                end
                setElementData(veh,"tuning.airRide",airRide);

                -- loadWheelSize(veh,"front",v.frontWheel);
                -- loadWheelSize(veh,"rear",v.rearWheel);
                setElementData(veh,"tuning.frontWheel",v.frontWheel);
                setElementData(veh,"tuning.rearWheel",v.rearWheel);
                loadPerformance(veh,fromJSON(v.jarmuTuningok));
                if v.steeringLock ~= 0 then 
                    setElementData(veh,"tuning.steeringLock",v.steeringLock);
                    setVehicleHandling(veh,"steeringLock",v.steeringLock);
                end

                setElementData(veh,"tuning.optical",fromJSON(v.jarmuOptikaiTuningok));
                loadOpticalTuning(veh,fromJSON(v.jarmuOptikaiTuningok));
            end
        end,sql,"SELECT id,jarmuTuningok,stickerID,frontWheel,rearWheel,neonID,driveType,lsdDoor,steeringLock,variant,airRide,jarmuOptikaiTuningok FROM jarmuvek WHERE id=?",getElementData(veh,"veh:id"));
    end
end

function loadOpticalTuning(veh,data)
    if data and #data > 0 then 
        for k,v in pairs(getVehicleUpgrades(veh)) do 
            removeVehicleUpgrade(veh,v);
        end
        setTimer(function()
            for k,v in pairs(data) do 
                if v > 0 then 
                    addVehicleUpgrade(veh,v);
                end
            end
        end,50,1);
    end
end

addEventHandler("onVehicleEnter",root,function(player,seat)
    --if seat == 0 then 
        local veh = source;
        setTimer(function()
            loadPerformance(veh,(getElementData(veh,"tuning.performance") or false));
            if getElementData(veh,"veh:id") > 0 then 
                outputDebugString("Tuning: "..getElementData(veh,"veh:id").." (id) tunings loaded!",0,100,100,100);
            end
        end,50,1);
    --end
end);

function saveVehicleTuning(veh)
    if getElementData(veh,"tuning.performance") then 
        dbExec(sql,"UPDATE jarmuvek SET jarmuTuningok=?, jarmuOptikaiTuningok=? WHERE id=?",toJSON(getElementData(veh,"tuning.performance")),toJSON(getElementData(veh,"tuning.optical") or {0,0,0,0,0,0,0}),getElementData(veh,"veh:id"));
    end
    dbExec(sql,"UPDATE jarmuvek SET stickerID=? WHERE id=?",tostring(getElementData(veh,"tuning.paintJob")),getElementData(veh,"veh:id")); --PaintJob Save
end

addEventHandler("onResourceStop",root,function(res)
    if getResourceName(res) == "fv_vehicle" or getThisResource() == res then 
        for k,v in pairs(getElementsByType("vehicle")) do 
            saveVehicleTuning(v);
            setElementData(v,"tuning.airRide.level",0);
        end
    end
end);

function loadPerformance(veh,table)
    setVehicleHandling(veh, false);
    exports.fv_handlings:loadHandling(veh);
    if not table then 
        dbQuery(function(qh)
            local res = dbPoll(qh,0);
            for k,v in pairs(res) do 
                table = fromJSON(v.jarmuTuningok);
            end
        end,sql,"SELECT jarmuTuningok FROM jarmuvek WHERE id=?",getElementData(veh,"veh:id"));
    end
    if table and #table > 0 then
        Async:foreach(table,function(v,k)
            if v > 1 then 
                local current = menu[1]["submenu"][k][2][v];
                if current[4] then 
                    for j,l in pairs(current[4]) do 
                        if l[2] > 0 then 
                            local original = getVehicleHandling(veh);
                            setVehicleHandling(veh,l[1],original[l[1]]+(l[2]/2) * original[l[1]]/100,false);
                        end
                    end
                end
            end
        end);
        local driveType = (getElementData(veh,"tuning.driveType") or false);
        if driveType then 
            setVehicleHandling(veh,"driveType",driveType);
        end

        local arLevel = getElementData(veh,"tuning.airRide.level") or 0;
        if arLevel ~= 0 then 
            setAirRideLevel(veh,arLevel);
        end

        loadWheelSize(veh,"front",getElementData(veh,"tuning.frontWheel"));
        loadWheelSize(veh,"rear",getElementData(veh,"tuning.rearWheel"));

        if getElementData(veh,"tuning.steeringLock") or false then 
            setVehicleHandling(veh,"steeringLock",getElementData(veh,"tuning.steeringLock"));
        end
    end
end

addEvent("tuning.performance",true);
addEventHandler("tuning.performance",root,function(player,veh,submenu,level,dataName)
    local current = menu[1]["submenu"][submenu][2][level]

    if current[2] == 0 then 
        exports.fv_infobox:addNotification(player,"success","You have successfully reset to factory.");
    else 
        exports.fv_infobox:addNotification(player,"success","Successful purchase!");
        setElementData(player,dataName,getElementData(player,dataName) - current[2]);
        dbExec(sql,"UPDATE characters SET premiumPoints=? WHERE id=?",getElementData(player,"char >> premiumPoints"),getElementData(player,"acc >> id"));
    end

    local currentData = getElementData(veh,"tuning.performance") or fromJSON("[ [ 1, 1, 1, 1, 1, 1 ] ]");
    if currentData[submenu] then 
        currentData[submenu] = level;
    end
    setElementData(veh,"tuning.performance",currentData);
    loadPerformance(veh,currentData);
    saveVehicleTuning(veh);
end);

addEvent("tuning.buyPaintJob",true);
addEventHandler("tuning.buyPaintJob",root,function(player,veh,paintJob,cost)
    if paintJob == "none" then paintJob = false end;

    setElementData(player,"char >> premiumPoints",getElementData(player,"char >> premiumPoints") - cost);
    dbExec(sql,"UPDATE characters SET premiumPoints=? WHERE id=?",getElementData(player,"char >> premiumPoints"),getElementData(player,"acc >> id"));

    setElementData(veh,"tuning.paintJob",paintJob);
    exports.fv_infobox:addNotification(player,"success","Successful purchase!");
    saveVehicleTuning(veh);
end);

addEvent("tuning.colorSave",true);
addEventHandler("tuning.colorSave",root,function(player,veh,cache,cost)
    setElementData(player,"char >> money",getElementData(player,"char >> money") - cost);
    setVehicleColor(veh,cache[1],cache[2],cache[3],cache[4],cache[5],cache[6]); --Color!
    setVehicleHeadLightColor(veh,cache[13],cache[14],cache[15]);
    dbExec(sql,"UPDATE jarmuvek SET jarmuSzine=?, lampaSzine=? WHERE id=?",toJSON({cache[1],cache[2],cache[3],cache[4],cache[5],cache[6]}),toJSON({cache[13],cache[14],cache[15]}),getElementData(veh,"veh:id"));
    exports.fv_infobox:addNotification(player,"success","Successful purchase!");    
end);

addEvent("tuning.wheelSize",true);
addEventHandler("tuning.wheelSize",root,function(player,veh,side,type,buy,cost)
    local typee = 0;
    if type == "verynarrow" then typee = 1;
    elseif type == "narrow" then typee = 2;
    elseif type == "wide" then typee = 4;
    elseif type == "extrawide" then typee = 8;
    elseif type == "default" then typee = 0;
    end
    local data = 3;
    if side == "rear" then 
        data = 4;
    end
    setVehicleHandlingFlags(veh, data, typee);

    if buy then 
        setElementData(player,"char >> money", getElementData(player,"char >> money") - cost);
        setElementData(veh,"tuning."..side.."Wheel",type);
        dbExec(sql,"UPDATE jarmuvek SET "..side.."Wheel=? WHERE id=?",(getElementData(veh,"tuning."..side.."Wheel") or "default"),getElementData(veh,"veh:id"));
        exports.fv_infobox:addNotification(player,"success","Successful purchase!");    
    end
end);

function loadWheelSize(veh,side,size)
    local typee = 0;
    if size == "verynarrow" then typee = 1;
    elseif size == "narrow" then typee = 2;
    elseif size == "wide" then typee = 4;
    elseif size == "extrawide" then typee = 8;
    elseif size == "default" then typee = 0;
    end
    local data = 3;
    if side == "rear" then 
        data = 4;
    end
    setVehicleHandlingFlags(veh, data, typee);
    setElementData(veh,"tuning."..side.."Wheel",size);
end

addEvent("tuning.buyNeon",true);
addEventHandler("tuning.buyNeon",root,function(player,veh,neon,cost)
    if neon == "false" then 
        setElementData(veh,"tuning.neon",false);
        exports.fv_infobox:addNotification(player,"success","Sikeresen leszerelted az alkatrészt!");    
    else 
        setElementData(veh,"tuning.neon",neon);
        setElementData(veh,"tuning.neonState",true);

        setElementData(player,"char >> premiumPoints",getElementData(player,"char >> premiumPoints") - cost);
        dbExec(sql,"UPDATE characters SET premiumPoints=? WHERE id=?",getElementData(player,"char >> premiumPoints"),getElementData(player,"acc >> id"));

        exports.fv_infobox:addNotification(player,"success","Successful purchase!");    
    end

    dbExec(sql,"UPDATE jarmuvek SET neonID=? WHERE id=?",tostring(getElementData(veh,"tuning.neon") or false),getElementData(veh,"veh:id"));
end);

addEvent("tuning.setPlate",true);
addEventHandler("tuning.setPlate",root,function(player,veh,text,cost)
    --Ékezet kiszedés--
    text = text:gsub("á","a");
    text = text:gsub("Á","A");
    text = text:gsub("é","e");
    text = text:gsub("É","E");
    text = text:gsub("ó","o");
    text = text:gsub("Ó","O");
    text = text:gsub("ú","u");
    text = text:gsub("Ú","U");
    text = text:gsub("ü","u");
    text = text:gsub("Ü","U");
    text = text:gsub("ö","o");
    text = text:gsub("Ö","O");
    text = text:gsub("ő","o");
    text = text:gsub("Ő","O");
    text = text:gsub("ű","u");
    text = text:gsub("Ű","U");
    text = text:gsub("í","i");
    text = text:gsub("Í","I");
    ------------------
    setVehiclePlateText(veh,text);
    setElementData(veh,"veh:rendszam",text);
    dbExec(sql,"UPDATE jarmuvek SET rendszam=? WHERE id=?",text,getElementData(veh,"veh:id"));

    setElementData(player,"char >> premiumPoints",getElementData(player,"char >> premiumPoints") - cost);
    dbExec(sql,"UPDATE characters SET premiumPoints=? WHERE id=?",getElementData(player,"char >> premiumPoints"),getElementData(player,"acc >> id"));

    exports.fv_infobox:addNotification(player,"success","Successful purchase!");    
end);

addEvent("tuning.driveType",true);
addEventHandler("tuning.driveType",root,function(player,veh,value,cost)
    setElementData(veh,"tuning.driveType",value);
    setVehicleHandling(veh,"driveType",value);

    setElementData(player,"char >> money", getElementData(player,"char >> money") - cost);
    exports.fv_infobox:addNotification(player,"success","Successful purchase!");    

    dbExec(sql,"UPDATE jarmuvek SET driveType=? WHERE id=?",value,getElementData(veh,"veh:id"));
end);

addEvent("tuning.lsdDoor",true);
addEventHandler("tuning.lsdDoor",root,function(player,veh,value,cost)
    setElementData(veh,"tuning.lsdDoor",value);

    if value then 
        setElementData(player,"char >> money", getElementData(player,"char >> money") - cost);
        exports.fv_infobox:addNotification(player,"success","Successful purchase!");    
    else 
        exports.fv_infobox:addNotification(player,"success","Sikeresen visszaállítottad gyárira.");    
    end

    local saveValue = 0;
    if value then 
        saveValue = 1;
    end
    dbExec(sql,"UPDATE jarmuvek SET lsdDoor=? WHERE id=?",saveValue,getElementData(veh,"veh:id"));
end);

addEvent("tuning.steeringLock",true);
addEventHandler("tuning.steeringLock",root,function(player,veh,value,cost)
    if value ~= 0 then 
        setElementData(player,"char >> money", getElementData(player,"char >> money") - cost);
        exports.fv_infobox:addNotification(player,"success","Successful purchase!");    
    else 
        exports.fv_infobox:addNotification(player,"success","Sikeresen visszaállítottad gyárira.");    
    end
    dbExec(sql,"UPDATE jarmuvek SET steeringLock=? WHERE id=?",value,getElementData(veh,"veh:id"));
    loadVehicleTuning(veh);
end);

addEvent("tuning.previewVariant",true);
addEventHandler("tuning.previewVariant",root,function(player,veh,variant)
    setVehicleVariant(veh,variant,variant);
end);

addEvent("tuning.buyVariant",true);
addEventHandler("tuning.buyVariant",root,function(player,veh,value,cost)
    if value ~= 0 then 
        setElementData(player,"char >> money", getElementData(player,"char >> money") - cost);
        exports.fv_infobox:addNotification(player,"success","Successful purchase!");    
    else 
        exports.fv_infobox:addNotification(player,"success","Sikeresen visszaállítottad gyárira.");    
    end
    setVehicleVariant(veh,value,value);
    setElementData(veh,"tuning.variant",value);
    dbExec(sql,"UPDATE jarmuvek SET variant=? WHERE id=?",value,getElementData(veh,"veh:id"));
end);

addEvent("tuning.buyAirRide",true);
addEventHandler("tuning.buyAirRide",root,function(player,veh,value,cost)
    if value then 
        setElementData(player,"char >> money", getElementData(player,"char >> money") - cost);
        exports.fv_infobox:addNotification(player,"success","Successful purchase! Használathoz: /airride");    
    else 
        exports.fv_infobox:addNotification(player,"success","Sikeresen visszaállítottad gyárira.");    
    end
    setElementData(veh,"tuning.airRide",value);
    dbExec(sql,"UPDATE jarmuvek SET airRide=? WHERE id=?",tostring(value),getElementData(veh,"veh:id"));
end);

addEvent("tuning.changeAirRide",true);
addEventHandler("tuning.changeAirRide",root,function(player,veh,level)
    setTimer(function()
        setAirRideLevel(veh,level);
        setElementData(veh,"tuning.airRide.level",level);
    end,2000,1);
end);


function setAirRideLevel(veh,level)
    if tonumber(level) == 0 then
        exports.fv_handlings:loadHandling(veh);
    elseif tonumber(level) == 1 then
        setVehicleHandling(veh, "suspensionLowerLimit", 0.009);
    elseif tonumber(level) == 2 then
        setVehicleHandling(veh, "suspensionLowerLimit", -0.05);
    elseif tonumber(level) == 3 then
        setVehicleHandling(veh, "suspensionLowerLimit", -0.1);
    elseif tonumber(level) == 4 then
        setVehicleHandling(veh, "suspensionLowerLimit", -0.2);
    elseif tonumber(level) == 5 then
        setVehicleHandling(veh, "suspensionLowerLimit", -0.35);
    elseif tonumber(level) == 5 then
        setVehicleHandling(veh, "suspensionLowerLimit", -0.45);
    end
end


addEvent("tuning.buyOptical",true);
addEventHandler("tuning.buyOptical",root,function(player,veh,hely,tune,cost)
    local current = getElementData(veh,"tuning.optical") or {0,0,0,0,0,0,0};
    outputDebugString(hely);
    current[hely] = tune;
    setElementData(veh,"tuning.optical",current);
    for k,v in pairs(getVehicleUpgrades(veh)) do 
        removeVehicleUpgrade(veh,v);
    end
    for k,v in pairs(current) do 
        addVehicleUpgrade(veh,v);
    end
    dbExec(sql,"UPDATE jarmuvek SET jarmuOptikaiTuningok=? WHERE id=?",toJSON(current),getElementData(veh,"veh:id"));

    setElementData(player,"char >> money", getElementData(player,"char >> money") - cost);
    exports.fv_infobox:addNotification(player,"success","Successful purchase!");    
end);

--UTILS--
function setVehicleHandlingFlags(vehicle, byte, value)
	if vehicle then
		local handlingFlags = string.format("%X", getVehicleHandling(vehicle)["handlingFlags"])
		local reversedFlags = string.reverse(handlingFlags) .. string.rep("0", 8 - string.len(handlingFlags))
		local currentByte, flags = 1, ""
		for values in string.gmatch(reversedFlags, ".") do
			if type(byte) == "table" then
				for _, v in ipairs(byte) do
					if currentByte == v then
						values = string.format("%X", tonumber(value))
					end
				end
			else
				if currentByte == byte then
					values = string.format("%X", tonumber(value))
				end
			end
			
			flags = flags .. values
			currentByte = currentByte + 1
		end
		setVehicleHandling(vehicle, "handlingFlags", tonumber("0x" .. string.reverse(flags)), false)
	end
end


