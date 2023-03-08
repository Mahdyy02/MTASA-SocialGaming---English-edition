local trash = {};

function loadTrash(id)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for k,v in pairs(res) do 
            local pos = fromJSON(v["pos"]);
            local trashObject = createObject(1359, pos[1], pos[2], pos[3]);
            setElementInterior(trashObject, pos[4]);
            setElementDimension(trashObject, pos[5]);
            setElementData(trashObject,"trash.id",id);

            trash[id] = trashObject;
        end
    end,sql,"SELECT * FROM kukak WHERE dbid=?",id);
end

addEventHandler("onResourceStart",resourceRoot,function()
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for k,v in pairs(res) do 
            loadTrash(v.dbid);
        end
    end,sql,"SELECT dbid FROM kukak");
end);

--Parancsok--
function placeTrash( player, cmd )
	if not ( tonumber(getElementData ( player, "admin >> level")) > 8 ) then return	end
	local x, y, z = getElementPosition  ( player );
	local z = z - 0.4
	local interior = getElementInterior ( player );
	local dimenzio = getElementDimension ( player );
	local pos = toJSON({x,y,z,interior,dimenzio});
	dbQuery(function(query)
		local query, query_lines,dbid = dbPoll(query, 0)	
		local trashObject = createObject ( 1359, x, y, z );
		setElementInterior ( trashObject, interior );
		setElementDimension ( trashObject, dimenzio );
        setElementData ( trashObject, "trash.id", dbid );
        trash[dbid] = trashObject;
		exports.fv_admin:sendMessageToAdmin(player, sColor.. exports.fv_admin:getAdminName(player)..white.. " placed a trash can "..sColor.. getZoneName(x,y,z) ..white.. " környékén. [ID: "..blue.. dbid..white.. "]", 1);
	end, sql, "INSERT INTO kukak SET pos = ?", pos) 
end
addCommandHandler("createbin",placeTrash,false,false);

function removeTrash(player,cmd,id)
    if not ( tonumber(getElementData ( player, "admin >> level")) > 8 ) then return	end
    if not id or not tonumber(id) then 
        outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [ID]",player,255,255,255,true);
        return;
    end
    local id = tonumber(id);
    if trash[id] then 
        if isElement(trash[id]) then 
            destroyElement(trash[id]);
        end
        trash[id] = nil;
        dbExec(sql,"DELETE FROM kukak WHERE dbid=?",id);
        local x,y,z = getElementPosition(player);
        exports.fv_admin:sendMessageToAdmin(player, sColor.. exports.fv_admin:getAdminName(player)..white.. " deleted a trash can "..sColor.. getZoneName(x,y,z) ..white.. " környékén. [ID: "..blue.. id ..white.. "]", 1);
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."There is no trash with this ID!",player,255,255,255,true);
        return;
    end
end
addCommandHandler("delbin",removeTrash,false,false);