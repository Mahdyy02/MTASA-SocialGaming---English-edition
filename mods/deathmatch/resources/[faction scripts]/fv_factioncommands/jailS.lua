sql = exports.fv_engine:getConnection(getThisResource());
white = "#FFFFFF";

local jailPos = {264.30081176758, 77.643890380859, 1001.0390625};
local exitPos = {1542.0959472656, -1675.1141357422, 13.553833007813};


addEvent("icjail.player",true);
addEventHandler("icjail.player",root,function(player,target,time,reason)
    local data = {1,time,reason,getElementData(player,"char >> name"),time};
    local accid = getElementData(target,"acc >> id");
    if dbExec(sql,"UPDATE characters SET icjail=? WHERE id=?",toJSON(data),accid) then 
        outputChatBox(exports.fv_engine:getServerSyntax("Jail","servercolor").."You have successfully imprisoned a "..exports.fv_engine:getServerColor("blue",true)..getElementData(target,"char >> name")..white.." player.",player,255,255,255,true);
        exports.fv_logs:createLog("IC_JAIL",getElementData(player,"char >> name").." jailed "..getElementData(target,"char >> name").. " player. Time: "..time.." minutes | Reason: "..reason,player,target);
        exports.fv_admin:sendMessageToAdmin(player,exports.fv_engine:getServerColor("servercolor",true)..getElementData(player,"char >> name")..white.." jailed "..exports.fv_engine:getServerColor("servercolor",true)..getElementData(target,"char >> name")..white.. " player. Time: "..exports.fv_engine:getServerColor("red",true)..time..white.." minutes | Reason: "..exports.fv_engine:getServerColor("red",true)..reason..white..".",3);
        data[6] = setTimer(function()
            jailTimer(target);
        end,1000*60,1);
        setElementData(target,"icjail.data",data);
        local x,y,z = unpack(jailPos);
        setElementPosition(target,x,y,z);
        setElementInterior(target,6);
        setElementDimension(target,999+getElementData(target,"acc >> id"));
    end
end);

function jailTimer(player)
if player then 
    local data = getElementData(player,"icjail.data");
    if data then 
        if data[1] == 1 then  
            if data[2]-1 <= 0 then 
                setElementPosition(player,unpack(exitPos));
                setElementDimension(player,0);
                setElementInterior(player,0);

                setElementData(player,"icjail.data",false);

                dbExec(sql,"UPDATE characters SET icjail=? WHERE id=?",toJSON(false),getElementData(player,"acc >> id"));
                outputChatBox(exports.fv_engine:getServerSyntax("Prison","servercolor").."You got out of jail.",player,255,255,255,true);
            else 
                data[2] = data[2] - 1;
                setElementPosition(player,unpack(jailPos));
                setElementInterior(player,6);
                setElementDimension(player,999+getElementData(player,"acc >> id"));

                local saveTable = {
                    data[1],
                    data[2],
                    data[3],
                    data[4],
                    data[5],
                };

                data[6] = setTimer(function()
                    jailTimer(player);
                end,1000*60,1);

                setElementData(player,"icjail.data",data);

                dbExec(sql,"UPDATE characters SET icjail=? WHERE id=?",toJSON(saveTable),getElementData(player,"acc >> id"));
            end
        end
    end
end
end

addEvent("icjail.start",true);
addEventHandler("icjail.start",root,function(player,value)
    value[6] = setTimer(function()
                    jailTimer(player);
                end,1000*60,1);
    setElementPosition(player,unpack(jailPos));
    setElementInterior(player,6);
    setElementDimension(player,100+getElementData(player,"acc >> id"));
    setElementData(player,"icjail.data",value);
end);


addEventHandler("onResourceStart",resourceRoot,function()
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"loggedIn") then 
            checkICjail(v);
        end
    end
end);

function checkICjail(player)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for k,v in pairs(res) do 
            local icjail = fromJSON(v["icjail"]);
            if icjail and icjail[1] == 1 then 
                icjail[6] = setTimer(function()
                    jailTimer(player);
                end,1000,1);
                setElementData(player,"icjail.data",icjail);
            end
        end
    end,sql,"SELECT * FROM characters WHERE id=?",getElementData(player,"acc >> id"));
end

addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "player" and dataName == "loggedIn" then 
        if newValue then 
            checkICjail(source);
        end
    end
end);