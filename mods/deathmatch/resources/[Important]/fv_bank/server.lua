local sql = exports.fv_engine:getConnection(getThisResource());

addEventHandler("onResourceStart",getRootElement(),function(res)
	if getResourceName(res) == "fv_engine" or getThisResource() == res then 
		sColor = exports.fv_engine:getServerColor("servercolor",true);
		white = "#FFFFFF";
	end
end);

addEvent("bank > changeMoney",true);
addEventHandler("bank > changeMoney",root,function(player,state,amount)
if getElementData(player,"network") then 
    local adoki = math.floor((amount/100));
    if state == "in" then 
        setElementData(player,"char >> money",getElementData(player,"char >> money")-amount);
        exports.fv_dash:giveFactionMoney(23,adoki);
        setElementData(player,"char >> bankmoney",getElementData(player,"char >> bankmoney")+(amount-adoki));
        outputChatBox(exports.fv_engine:getServerSyntax("Bank","servercolor").."You have successfully paid: "..exports.fv_engine:getServerColor("servercolor",true)..formatMoney(amount-adoki)..white.. " dt "..exports.fv_engine:getServerColor("red",true).." (Tax: "..adoki.." dt)",player,255,255,255,true);
    elseif state == "out" then 
        setElementData(player,"char >> money",getElementData(player,"char >> money")+(amount-adoki));
        setElementData(player,"char >> bankmoney",getElementData(player,"char >> bankmoney")-amount);
        outputChatBox(exports.fv_engine:getServerSyntax("Bank","servercolor").."You have successfully withdrawn: "..exports.fv_engine:getServerColor("servercolor",true)..formatMoney(amount-adoki)..white.. " dt "..exports.fv_engine:getServerColor("red",true).." (Tax: "..adoki.." dt)",player,255,255,255,true);
    end
    dbExec(sql,"UPDATE characters SET money=?, bankmoney=? WHERE id=?",getElementData(player,"char >> money"),getElementData(player,"char >> bankmoney"),getElementData(player,"acc:id"));
end
end);

--2942
function loadATM(id)
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        for k,v in pairs(result) do 
            local x,y,z,dim,inter,rot = unpack(fromJSON(v.pos));
            local atm = createObject(2942,x,y,z,0,0,rot);
            setElementData(atm,"atm.id",v.id);
        end
    end,sql,"SELECT * FROM atmek WHERE id=?",id);
end
addEventHandler("onResourceStart",resourceRoot,function()
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        local counter = 0;
        for k,v in pairs(result) do 
            loadATM(v.id);
            counter = counter + 1;
        end
        outputDebugString("ATM > "..counter.." loaded!",3,200,200,200);
    end,sql,"SELECT id FROM atmek");
end);

function addATM(player,command)
    if getElementData(player,"admin >> level") > 8 then 
        local x,y,z = getElementPosition(player)
        local dim,inter = getElementDimension(player),getElementInterior(player);
        local _,_,rot = getElementRotation(player);
        local pos = toJSON({x,y,z-0.3,dim,inter,rot+180});
        dbQuery(function(qh)
            local result,_,id = dbPoll(qh,0);
            loadATM(id);

            exports.fv_logs:createLog("ADDATM",exports.fv_admin:getAdminName(player).. " created an ATM. ID:"..id..".",player);
            exports.fv_admin:sendMessageToAdmin(playerSource,exports.fv_admin:getAdminName(player).. " created an ATM. ID: "..sColor..id..white..".",3);

        end,sql,"INSERT INTO atmek SET pos=?",pos);
        local x,y,z = getElementPosition(player)
    end
end
addCommandHandler("addatm",addATM,false,false);
addCommandHandler("makeatm",addATM,false,false);

function nearbyATM(player,command)
    if getElementData(player,"admin >> level") > 8 then 
        local x,y,z = getElementPosition(player);
        outputChatBox(exports.fv_engine:getServerSyntax("Bank","green").."Nearby ATMs:",player,255,255,255,true);
        for k,v in pairs(getElementsByType("object",resourceRoot)) do 
            local ox,oy,oz = getElementPosition(v);
            local distance = getDistanceBetweenPoints3D(x,y,z,ox,oy,oz);
            if distance < 11 then 
                outputChatBox("ID: "..exports.fv_engine:getServerColor("servercolor",true)..getElementData(v,"atm.id")..white.." Distance: "..exports.fv_engine:getServerColor("servercolor",true)..math.floor(distance)..white..".",player,255,255,255,true);
            end
        end
    end
end
addCommandHandler("nearbyatm",nearbyATM,false,false);
addCommandHandler("nearbyatms",nearbyATM,false,false);

function deleteATM(player,command,target)
    if getElementData(player,"admin >> level") > 8 then 
        if not target or not tonumber(target) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Use","orange").."/"..command.." [id]",player,255,255,255,true);
            return;
        end
        local found = false;
        local target = tonumber(target);
        for k,v in pairs(getElementsByType("object",resourceRoot)) do 
            if getElementData(v,"atm.id") == target then 
                found = v;
                break;
            end
        end
        if not found then 
            outputChatBox(exports.fv_engine:getServerSyntax("Bank","red").."No results for this id.",player,255,255,255,true);
            return;
        end
        if found then 
            local idsave = getElementData(found,"atm.id");
            if dbExec(sql,"DELETE FROM atmek WHERE id=?",getElementData(found,"atm.id")) then 
                destroyElement(found);
                outputChatBox(exports.fv_engine:getServerSyntax("Bank","green").."You have successfully deleted an ATM!",player,255,255,255,true);
                exports.fv_logs:createLog("DELATM",exports.fv_admin:getAdminName(player).. " deleted an ATM. ID:"..idsave..".",player);
                exports.fv_admin:sendMessageToAdmin(playerSource,exports.fv_admin:getAdminName(player).. " deleted an ATM. ID: "..sColor..idsave..white..".",3);
            end
        end
    end
end
addCommandHandler("delatm",deleteATM,false,false);
addCommandHandler("deleteatm",deleteATM,false,false);
addCommandHandler("removeatm",deleteATM,false,false);


--[[function allow(player)
    if getPlayerSerial(player) == "D7896CF67693A8014C5ADE794A90C294" then 
        return true;
    end
    return false;
end]]