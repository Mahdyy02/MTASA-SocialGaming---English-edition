sql = exports.fv_engine:getConnection(getThisResource());

local personLicense = {};

addEventHandler("onResourceStart",resourceRoot,function()
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for key,value in pairs(res) do 
            personLicense[value["id"]] = value;
        end
    end,sql,"SELECT * FROM szemelyik");
end);

function loadPersonLicense(id)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for key, value in pairs(res) do 
            personLicense[value["id"]] = value;
        end
    end,sql,"SELECT * FROM szemelyik WHERE id=?",id);
end

addEvent("identity.give",true);
addEventHandler("identity.give",root,function(player)
    local money = getElementData(player,"char >> money");
    if money >= 200 then 
        dbQuery(function(qh)
            local res,_,id = dbPoll(qh,0);
            if res then 
                local item = exports.fv_inventory:givePlayerItem(player,47,1,id,100,0);
                if item then 
                    setElementData(player,"char >> money",money - 200);
                    outputChatBox(exports.fv_engine:getServerSyntax("Identity","servercolor").."You have successfully applied for an ID card!",player,255,255,255,true);
                    loadPersonLicense(id);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Identity","red").."Application failed! You have no place!",player,255,255,255,true);
                    dbExec(sql,"DELETE FROM szemelyik WHERE id=?",id);
                end
            end
        end,sql,"INSERT INTO szemelyik SET name=?, gender=?, date=NOW(), exdate=NOW()+INTERVAL 1 MONTH, cardid=?",getElementData(player,"char >> name"),getElementData(player,"char >> gender"),randomString(6));
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Identity","red").."Application failed! You don't have enough money!",player,255,255,255,true);
        return;
    end
end);

addEvent("identity.renew",true);
addEventHandler("identity.renew",root,function(player,dbid)
    if dbExec(sql,"UPDATE szemelyik SET date=NOW(), exdate=NOW()+INTERVAL 1 MONTH WHERE id=?",dbid) then 
        loadPersonLicense(dbid);
        local money = getElementData(player,"char >> money");
        setElementData(player,"char >> money",money - 100);
        outputChatBox(exports.fv_engine:getServerSyntax("Identity","servercolor").."You have successfully renewed your ID!",player,255,255,255,true);
    end
end);

addEvent("identity.getData",true);
addEventHandler("identity.getData",root,function(player,id)
    local temp = personLicense[id];
    if temp then 
        local data = {};
        data[1] = temp["cardid"];
        data[2] = temp["name"];
        data[3] = temp["gender"];
        data[4] = temp["date"];
        data[5] = temp["exdate"];
        data[6] = temp["id"];
        triggerClientEvent(player,"identity.returnData",player,data);
    end
end);