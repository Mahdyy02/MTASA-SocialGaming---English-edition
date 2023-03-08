local sql = exports.fv_engine:getConnection(getThisResource());
local white = "#FFFFFF";
local gates = {};

function loadGate(id)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        if #res > 0 then 
            for k,v in pairs(res) do 
                local open = fromJSON(v.open);
                local close = fromJSON(v.close);
                local obj = createObject(v.model,close[1],close[2],close[3], close[4],close[5],close[6]);
                setElementInterior(obj,v.interior);
                setElementDimension(obj,v.dimension);

                setElementData(obj,"gate.id",v.id);
                setElementData(obj,"gate.open",open);
                setElementData(obj,"gate.close",close);
                setElementData(obj,"gate.time",v.time*400);
                setElementData(obj,"gate.state","close");
                gates[v.id] = obj;
            end
        end
    end,sql,"SELECT * FROM kapuk WHERE id=?",id);
end

function loadAllGate()
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        if #res > 0 then 
            local count = 0;
            for k,v in pairs(res) do 
                loadGate(v.id);
                count = count + 1;
            end
            outputDebugString("Gate: "..count.." gate loaded.");
        end
    end,sql,"SELECT id FROM kapuk");
end
addEventHandler("onResourceStart",resourceRoot,loadAllGate);

addEvent("gate.create",true);
addEventHandler("gate.create",root,function(player,pos)
    dbQuery(function(qh)
        local res,_,id = dbPoll(qh,0);
        if id > 0 then 
            loadGate(id);
        end
    end,sql,"INSERT INTO kapuk SET open=?, close=?, model=?, interior=?, dimension=?, time=?",toJSON(pos["open"]),toJSON(pos["close"]),tonumber(pos["model"]),tonumber(pos["interior"]),tonumber(pos["dimension"]),tonumber(pos["time"]));
end);

function setGateState(id,player)
    if id and gates[id] then 
        local obj = gates[id];
        if getElementData(obj,"gate.state") == "close" then 
            local x,y,z,rx,ry,rz = unpack(getElementData(obj,"gate.open"));
            local close = getElementData(obj,"gate.close");
            local rotZ = calculateDifferenceBetweenAngles(close[6], rz);
            local rotY = calculateDifferenceBetweenAngles(close[5],ry);
            setElementData(obj,"gate.moving",true);
            if moveObject(obj,getElementData(obj,"gate.time"),x,y,z,rx,rotY,rotZ) then 
                setElementData(obj,"gate.state","open");
                setTimer(function()
                    setElementData(obj,"gate.moving",false);
                end,getElementData(obj,"gate.time")+100,1);
            end
        else 
            local x,y,z,rx,ry,rz = unpack(getElementData(obj,"gate.close"));
            local open = getElementData(obj,"gate.open");
            local rotZ = calculateDifferenceBetweenAngles(open[6], rz);
            local rotY = calculateDifferenceBetweenAngles(open[5],ry);
            setElementData(obj,"gate.moving",true);
            if moveObject(obj,getElementData(obj,"gate.time"),x,y,z,rx,rotY,rotZ) then 
                setElementData(obj,"gate.state","close");
                setTimer(function()
                    setElementData(obj,"gate.moving",false);
                end,getElementData(obj,"gate.time")+100,1);
            end
        end
    end
end

function useGate(player)
	local posX, posY, posZ = getElementPosition(player);
	for k, object in ipairs(getElementsByType("object", getResourceRootElement())) do
		local gateID = getElementData(object, "gate.id");
		if gateID then
			local gX, gY, gZ = getElementPosition(object);
			local distance = getDistanceBetweenPoints3D(posX, posY, posZ, gX, gY, gZ);
            if (distance<=8) then
                if not getElementData(object,"gate.moving") then 
                    local item = exports.fv_inventory:hasItem(player,85,1,gateID);
                    if (getElementData(player,"admin >> level") > 3 and getElementData(player,"admin >> duty")) or item then
                        setGateState(gateID, player);
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Gate","red").."You have no key to the gate!",player,255,255,255,true);
                    end
                end
			end
		end
	end
end
addCommandHandler("gate", useGate)

function deleteGate(player,command,id)
    if getElementData(player,"admin >> level") > 10 then 
        if not id or not tonumber(id) then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [id]",player,255,255,255,true) return end;
        local id = tonumber(id);
        if gates[id] then 
            local obj = gates[id];
            if obj then 
                destroyElement(obj);
            end
            dbExec(sql,"DELETE FROM kapuk WHERE id=?",id);
            outputChatBox(exports.fv_engine:getServerSyntax("Gate","servercolor").."Gate deleted successfully! ID: " ..exports.fv_engine:getServerColor("servercolor",true)..id..white..".",player,255,255,255,true);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Gate","red").."There is no such gate.",player,255,255,255,true);
        end
    end
end
addCommandHandler("delgate",deleteGate,false,false);
addCommandHandler("deletegate",deleteGate,false,false);

--UTILS--
function calculateDifferenceBetweenAngles(firstAngle, secondAngle) 
    difference = secondAngle - firstAngle; 
    while (difference < -180) do 
        difference = difference + 360 
    end 
    while (difference > 180) do 
        difference = difference - 360 
    end 
    return difference 
end 
