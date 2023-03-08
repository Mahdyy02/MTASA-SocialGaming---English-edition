local carLicense = {};

addEventHandler("onResourceStart",resourceRoot,function()
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for key,value in pairs(res) do 
            carLicense[value["id"]] = value;
        end
    end,sql,"SELECT * FROM jogsik");
end);

function loadCarLicense(id)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for key, value in pairs(res) do 
            carLicense[value["id"]] = value;
        end
    end,sql,"SELECT * FROM jogsik WHERE id=?",id);
end

addEvent("jogsi.givecar",true);
addEventHandler("jogsi.givecar",root,function(player)
    local x,y,z = getElementPosition(player);
    local veh = createVehicle(550,x,y,z);
    setElementData(player,"jogsi.veh",veh);
    setElementData(veh,"veh:uzemanyag",100);
    setElementData(veh,"veh:akkumulator",100);
    setElementData(veh,"veh:motorStatusz",1);
    setVehicleEngineState(veh,true);
    setElementData(veh,"veh:id",-(getElementData(player,"acc >> id")));


    warpPedIntoVehicle(player,veh);
end);

addEvent("jogsi.end",true);
addEventHandler("jogsi.end",root,function(player)
    local veh = getPedOccupiedVehicle(player);
    if veh then 
        destroyElement(veh);
        dbQuery(function(qh)
            local res,_,id = dbPoll(qh,0);
            if res then 
                local item = exports.fv_inventory:givePlayerItem(player,49,1,id,100,0);
                if item then 
                    outputChatBox(exports.fv_engine:getServerSyntax("Driving license","servercolor").."You have successfully deposited your license!",player,255,255,255,true);
                    loadCarLicense(id);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Driving license","red").."A license could not be granted because there was no space in the inventory!",player,255,255,255,true);
                    dbExec(sql,"DELETE FROM jogsik WHERE id=?",id);
                end
            end
        end,sql,"INSERT INTO jogsik SET adatok=?, date=NOW(), exdate=NOW()+INTERVAL 1 MONTH",toJSON({getElementData(player,"char >> name"),getElementData(player,"char >> gender")}));
    end
end);

addEvent("jogsi.getData",true);
addEventHandler("jogsi.getData",root,function(player,id)
    if carLicense[id] then 
        local temp = carLicense[id];
        local datas = {};
        local x = fromJSON(temp["adatok"]);
        datas[1] = x[1];
        datas[2] = x[2];
        datas[3] = temp["date"];
        datas[4] = temp["exdate"];
        datas[5] = temp["id"];
        triggerClientEvent(player,"jogsi.returnDatas",player,datas);
    end
end);

addEvent("jogsi.renew",true);
addEventHandler("jogsi.renew",root,function(player,dbid)
    if dbExec(sql,"UPDATE jogsik SET date=NOW(), exdate=NOW()+INTERVAL 1 MONTH WHERE id=?",dbid) then 
        loadCarLicense(dbid);
        local money = getElementData(player,"char >> money");
        setElementData(player,"char >> money",money - 100);
        outputChatBox(exports.fv_engine:getServerSyntax("Driving license","servercolor").."You have successfully renewed your license!",player,255,255,255,true);
    end
end);