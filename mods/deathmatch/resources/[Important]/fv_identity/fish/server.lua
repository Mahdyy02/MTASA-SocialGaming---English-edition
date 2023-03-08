local fishLicenses = {};

addEventHandler("onResourceStart",resourceRoot,function()
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for key,value in pairs(res) do 
            fishLicenses[value["id"]] = value;
        end
    end,sql,"SELECT * FROM hengedelyek");
end);

addEvent("fish.give",true);
addEventHandler("fish.give",root,function(player)
    local money = getElementData(player,"char >> money");
    if money >= 200 then 
        dbQuery(function(qh)
            local res,_,id = dbPoll(qh,0);
            if res then 
                local item = exports.fv_inventory:givePlayerItem(player,97,1,id,100,0);
                if item then 
                    setElementData(player,"char >> money",money - 2000);
                    outputChatBox(exports.fv_engine:getServerSyntax("Horgászengedély","servercolor").."Sikeresen igényeltél egy horgászengedélyt!",player,255,255,255,true);
                    loadFishLicense(id);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Horgászengedély","red").."Sikertelen igénylés! Nincs hely nálad!",player,255,255,255,true);
                    dbExec(sql,"DELETE FROM szemelyik WHERE id=?",id);
                end
            end
        end,sql,"INSERT INTO hengedelyek SET name=?, gender=?, date=NOW(), exdate=NOW()+INTERVAL 1 MONTH, cardid=?",getElementData(player,"char >> name"),getElementData(player,"char >> gender"),randomString(6));
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Horgászengedély","red").."Sikertelen igénylés! Nincs elég pénzed!",player,255,255,255,true);
        return;
    end
end);

addEvent("fishing.showEngedely",true);
addEventHandler("fishing.showEngedely",root,function(player,id)
    local temp = fishLicenses[id];
    if temp then 
        local data = {};
        data[1] = temp["cardid"];
        data[2] = temp["name"];
        data[3] = temp["gender"];
        data[4] = temp["date"];
        data[5] = temp["exdate"];
        data[6] = temp["id"];
        triggerClientEvent(player,"fishing.show",player,data);
    end
end);

addEvent("fish.renew",true);
addEventHandler("fish.renew",root,function(player,dbid)
    dbExec(sql,"UPDATE hengedelyek SET date=NOW(), exdate=NOW()+INTERVAL 1 MONTH WHERE id=?",dbid);
    loadFishLicense(dbid);
    local money = getElementData(player,"char >> money");
    setElementData(player,"char >> money",money - 1500);
    outputChatBox(exports.fv_engine:getServerSyntax("Horgászengedély","servercolor").."Sikeresen megújítottad az engedélyed!",player,255,255,255,true);
end);

function loadFishLicense(id)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for key, value in pairs(res) do 
            fishLicenses[value["id"]] = value;
        end
    end,sql,"SELECT * FROM hengedelyek WHERE id=?",id);
end