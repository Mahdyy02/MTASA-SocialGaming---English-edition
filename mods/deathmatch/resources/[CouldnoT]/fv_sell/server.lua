local sql = exports.fv_engine:getConnection(getThisResource());

addEvent("sell.sendOther",true);
addEventHandler("sell.sendOther",root,function(player,target,cache)
    triggerClientEvent(target,"sell.return",target,cache,player);
end);

addEvent("sell.deny",true);
addEventHandler("sell.deny",root,function(player,other)
    outputChatBox(exports.fv_engine:getServerSyntax("Purchase","red").."The sale was refused.",other,255,255,255,true);
    outputChatBox(exports.fv_engine:getServerSyntax("Purchase","red").."You have declined the sale.",player,255,255,255,true);
end);

addEvent("sell.accept",true);
addEventHandler("sell.accept",root,function(player,other,cache)
if getElementData(player,"network") and getElementData(other,"network") then 
    local veh = cache.vehicle;
    local vehid = getElementData(veh,"veh:id");
    if veh and vehid > 0 then 
        setElementData(veh,"veh:tulajdonos",getElementData(player,"acc >> id"));
        setElementData(veh,"veh.ownername",getElementData(player,"char >> name"));

        setElementData(player,"char >> money",getElementData(player,"char >> money") - tonumber(cache.cost));
        setElementData(other,"char >> money",getElementData(other,"char >> money") + tonumber(cache.cost));

        dbExec(sql,"UPDATE jarmuvek SET tulajdonos=? WHERE id=?",getElementData(player,"acc >> id"),vehid);

        dbExec(sql,"UPDATE characters SET money=? WHERE id=?",getElementData(player,"char >> money"),getElementData(player,"acc >> id"));
        dbExec(sql,"UPDATE characters SET money=? WHERE id=?",getElementData(other,"char >> money"),getElementData(other,"acc >> id"));

        outputChatBox(exports.fv_engine:getServerSyntax("Purchase","servercolor").."You have successfully sold the vehicle!",other,255,255,255,true);
        outputChatBox(exports.fv_engine:getServerSyntax("Purchase","servercolor").."Successful vehicle purchase!",player,255,255,255,true);

        exports.fv_inventory:takePlayerItem(other,89);

        local saveData = {
            seller = cache.seller,
            buyer = cache.buyer,
            plate = cache.plate,
            model = cache.model,
            km = cache.km,
            cost = cache.cost;
            date = cache.date,
        };
        local give = exports.fv_inventory:givePlayerItem(player,90,1,1,100,{0,saveData});
        if not give then 
            outputChatBox(exports.fv_engine:getServerSyntax("Purchase","red").."Completed Purchase did not fit you.",player,255,255,255,true);
        end
    end
end
end);