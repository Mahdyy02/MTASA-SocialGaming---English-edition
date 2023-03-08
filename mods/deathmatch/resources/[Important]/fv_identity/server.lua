addEvent("sell.give",true);
addEventHandler("sell.give",root,function(player)
    local money = getElementData(player,"char >> money");
    if money >= 100 then 
        local item = exports.fv_inventory:givePlayerItem(player,89,1,1,100,0);
        if item then 
            setElementData(player,"char >> money",money - 200);
            outputChatBox(exports.fv_engine:getServerSyntax("purchase","servercolor").."You have successfully purchased an empty sale!",player,255,255,255,true);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("purchase","red").."Unsuccessful purchase! You have no place!",player,255,255,255,true);
        end
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("purchase","red").."Unsuccessful purchase! You don't have enough money!",player,255,255,255,true);
        return;
    end
end);
