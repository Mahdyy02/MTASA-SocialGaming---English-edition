
local transLicense = {};

addEventHandler("onResourceStart",resourceRoot,function()
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for key,value in pairs(res) do 
            transLicense[value["id"]] = value;
        end
    end,sql,"SELECT * FROM utlevelek");
end);

function loadTransLicense(id)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for key, value in pairs(res) do 
            transLicense[value["id"]] = value;
        end
    end,sql,"SELECT * FROM utlevelek WHERE id=?",id);
end

addEvent("passport.give",true);
addEventHandler("passport.give",root,function(player)
    local money = getElementData(player,"char >> money");
    if money >= 200 then 
        dbQuery(function(qh)
            local res,_,id = dbPoll(qh,0);
            if res then 
                local item = exports.fv_inventory:givePlayerItem(player,48,1,id,100,0);
                if item then 
                    outputChatBox(exports.fv_engine:getServerSyntax("Passport","servercolor").."You have successfully applied for a passport!",player,255,255,255,true);
                    loadTransLicense(id);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Passport","red").."Application failed! You have no place!",player,255,255,255,true);
                    dbExec(sql,"DELETE FROM utlevelek WHERE id=?",id);
                end
            end
        end,sql,"INSERT INTO utlevelek SET name=?, gender=?, date=NOW(), exdate=NOW()+INTERVAL 1 MONTH, cardid=?",getElementData(player,"char >> name"),getElementData(player,"char >> gender"),randomString(6));
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Passport","red").."Application failed! You don't have enough money!",player,255,255,255,true);
        return;
    end
end);

addEvent("passport.renew",true);
addEventHandler("passport.renew",root,function(player,dbid)
    if dbExec(sql,"UPDATE utlevelek SET date=NOW(), exdate=NOW()+INTERVAL 1 MONTH WHERE id=?",dbid) then 
        loadTransLicense(dbid);
        local money = getElementData(player,"char >> money");
        setElementData(player,"char >> money",money - 100);
        outputChatBox(exports.fv_engine:getServerSyntax("Passport","servercolor").."You have successfully renewed your passport!",player,255,255,255,true);
    end
end);


addEvent("passport.getData",true);
addEventHandler("passport.getData",root,function(player,id)
    local temp = transLicense[id];
    if temp then 
        local data = {};
        data[1] = temp["cardid"];
        data[2] = temp["name"];
        data[3] = temp["gender"];
        data[4] = temp["date"];
        data[5] = temp["exdate"];
        triggerClientEvent(player,"passport.returnData",player,data);
    end
end);