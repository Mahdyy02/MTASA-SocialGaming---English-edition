safes = {};

function loadAllSafes()
    dbQuery(function(qh)
        local res,lines = dbPoll(qh,0);
        local tick = getTickCount();
        Async:foreach(res,function(value)
            loadSafe(value.dbid);
        end,function()
            --outputDebugString("SAFE > ".. lines .." safes loaded in "..(getTickCount()-tick).." ms",0,200,0,200);
            loadAllVehicleItems();
        end);
    end,sql,"SELECT dbid FROM szefek");
end

function loadSafe(id)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for k,v in pairs(res) do 
            local poziciok = fromJSON(tostring(v["pos"]));
            local x, y, z = poziciok[1], poziciok[2], poziciok[3];
            local interior = poziciok[4];
            local dimenzio = poziciok[5];
            local rotacio = poziciok[6];
            local dbid = tonumber(v["dbid"]);
            
            local safe = createObject(2332, x,y,z);
            setElementInterior(safe, interior);
            setElementDimension(safe, dimenzio);
            setElementRotation(safe, 0,0,rotacio);
            setElementDoubleSided(safe,true);

            setElementData(safe,"safe.id",dbid);

            safes[dbid] = safe;

            loadSafeItems(safe);
        end
    end,sql,"SELECT * FROM szefek WHERE dbid=?",id);
end

function loadSafeItems(safe)
    local safeID = getElementData(safe,"safe.id");
    dbQuery(function(qh)
        local temp = {};
        local res = dbPoll(qh,0);
        for k,v in pairs(res) do 
            local slot = tonumber(v["slot"]);
            temp[slot] = { v["itemID"], v["dbid"], v["darab"], v["ertek"], v["allapot"], fromJSON(v["egyebek"]) }
        end
        setElementData(safe,"itemsTable",temp);
    end, sql, "SELECT * FROM targyak WHERE ownerType='safe' AND ownerID=?",safeID); 
end

--PARANCSOK--
function makeSafe( player, cmd )
	if cmd then
		if not ( tonumber(getElementData ( player, "admin >> level")) > 7 ) then return	end
	end
    local x, y, z = getElementPosition ( player );
    local interior = getElementInterior ( player );
    local dimenzio = getElementDimension ( player );
    local _,_, rotacio = getElementRotation  (player);
    dbQuery(function(query)
        local query, query_lines,dbid = dbPoll(query, 0)
        loadSafe(dbid);
        givePlayerItem ( player, 42, 1, dbid, 100, 0,false )
    end, sql, "INSERT INTO szefek SET pos = ?", toJSON({x,y,z - 0.5,interior,dimenzio,rotacio + 180})); 	
end
addCommandHandler("createsafe", makeSafe,false,false);
addCommandHandler("makesafe", makeSafe,false,false);

function moveSafeByAdmin(player,cmd,safeID)
    if (tonumber(getElementData(player, "admin >> level") or 0) > 6) then
        if not safeID or not tonumber(safeID) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [Safe ID]",player,255,255,255,true);
            return;
        end
        local safeID = tonumber(safeID);
        if safes[safeID] then 
            local x, y, z = getElementPosition ( player );
            local interior = getElementInterior ( player );
            local dimenzio = getElementDimension ( player );
            local _,_, rotacio = getElementRotation  (player);
            setElementPosition ( safes[safeID], x, y, z - 0.5 );
            setElementInterior ( safes[safeID], interior);
            setElementDimension ( safes[safeID], dimenzio);
            setElementRotation ( safes[safeID], 0,0,rotacio+180);	
            dbExec(sql,"UPDATE szefek SET pos = ? WHERE dbid = ?",  toJSON({x,y,z-0.5,interior,dimenzio,rotacio+180}), tonumber(safeID));
            exports.fv_admin:sendMessageToAdmin(player, sColor.. exports.fv_admin:getAdminName(player,true) ..white.. " moved a Safe "..exports.fv_engine:getServerColor("red",true).."[".. (getElementData(safes[safeID], "safe.id") or -1) .. "]", 1);
            exports.fv_logs:createLog("MOVESAFE",exports.fv_admin:getAdminName(player,true) .. " moved a Safe [".. (getElementData(safes[safeID], "safe.id") or -1) .. "]",player );
        end
    end
end
addCommandHandler("movesafe",moveSafeByAdmin,false,false);

function deleteSafeByAdmin(player,cmd,safeid)
	if not ( tonumber(getElementData ( player, "admin >> level")) > 7 ) then return	end
    if not getElementData(player,"admin >> duty") then
        return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").. "You are not in adminduty!", player, 255,0,0,true);
    end
	if (safeid) then
        if (tonumber(safeid)) then
            local safeid = tonumber(safeid);
            if safes[safeid] then 
                local x,y,z = getElementPosition(safes[safeid]);
                exports.fv_admin:sendMessageToAdmin(player, sColor.. exports.fv_admin:getAdminName(player,true) ..white.. " erased a Safe [ID: "..blue.. safeid ..white.. "]", 1);
                exports.fv_logs:createLog("DELSAFE",exports.fv_admin:getAdminName(player,true) .." erased a Safe [ID: "..safeid .. "]",player );
                destroyElement(safes[safeid]);
                dbExec(sql,"DELETE FROM szefek WHERE dbid = ?", tonumber(safeid));
                safes[safeid] = nil; 
                return;
            end
			return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").. "There is no Safe with this ID!", player, 255,0,0,true);
		end
	else 
        outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.. " [safeid]", player, 0,0,0,true );
    end
end
addCommandHandler("delsafe",deleteSafeByAdmin,false,false);
addCommandHandler("deletesafe",deleteSafeByAdmin,false,false);

function gotoSafe(player,cmd,safeID)
    if not ( tonumber(getElementData ( player, "admin >> level")) > 6 ) then return	end
    if not safeID or not tonumber(safeID) or not math.floor(tonumber(safeID)) then 
        return outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [Safe ID]",player,255,255,255,true);
    end
    local safeID = math.floor(tonumber(safeID));
    local safeOBJ = safes[safeID];
    if safeOBJ and isElement(safeOBJ) then 
        local x,y,z = getElementPosition(safeOBJ);
        setElementPosition(player,x+1,y,z);
        setElementInterior(player,getElementInterior(safeOBJ));
        setElementDimension(player,getElementDimension(safeOBJ));
        outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully teleported to Safe!",player,255,255,255,true);

        exports.fv_admin:sendMessageToAdmin(player, sColor.. exports.fv_admin:getAdminName(player,true):gsub("_", " ") ..white.. " teleported to a Safe. [ID: "..blue.. safeID ..white.. "]", 1);
        exports.fv_logs:createLog("GOTOSAFE",exports.fv_admin:getAdminName(player,true) .. " teleported to a Safe. [ID: ".. safeID .. "]",player );

    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Safe not found.",player,255,255,255,true);
    end
end
addCommandHandler("gotosafe",gotoSafe,false,false);