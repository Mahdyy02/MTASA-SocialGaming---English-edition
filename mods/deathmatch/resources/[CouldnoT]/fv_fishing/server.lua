local cache = {};

addEvent("fishing.waterClick",true);
addEventHandler("fishing.waterClick",root,function(player,state,x,y,z)
    if state then 
        destroyCache(player);
        local obj = createObject(1974,x,y,z);
        setObjectScale(obj,1.5);
        cache[player] = obj;
		exports.fv_chat:sendLocalMeAction(player,"The player threw the float into the water.");
    else
        destroyCache(player);
    end
end);

function destroyCache(player)
    if cache[player] then 
        destroyElement(cache[player]);
        cache[player] = nil;
    end
end

addEventHandler("onPlayerQuit",root,function()
    destroyCache(source);
end);

addEvent("fishing.sell",true);
addEventHandler("fishing.sell",root,function(player,items)
    outputChatBox(exports.fv_engine:getServerSyntax("Fishing","servercolor").."Fish for sale:",player,255,255,255,true);
    local all = 0;
    for k,v in pairs(prices) do 
        local itemID, price = unpack(v);
        if price then 
            for j, value in pairs(exports.fv_inventory:getItems(player,itemID)) do 
                local itemState, itemDBID = unpack(value);
                if itemState ~= 0 then 
                    local blue = exports.fv_engine:getServerColor("blue",true);
                    local realPrice = math.floor(price * (itemState/100));
                    outputChatBox(" ~"..exports.fv_engine:getServerColor("servercolor",true)..exports.fv_inventory:getItemName(itemID)..white.."  ("..blue..math.floor(itemState)..white.."%) - "..formatMoney(realPrice)..exports.fv_engine:getServerColor("servercolor",true).."dt",player,255,255,255,true);
                    all = all + realPrice;
                    exports.fv_inventory:takePlayerItem(player,itemID,1,itemDBID);
                end
            end
        end
    end
    setElementData(player,"char >> money",getElementData(player,"char >> money") + all);
    outputChatBox("Altogether: "..exports.fv_engine:getServerColor("servercolor",true)..formatMoney(all)..white.."dt",player,255,255,255,true);
end);

addEvent("fishing.fail",true);
addEventHandler("fishing.fail",root,function(player)
    exports.fv_inventory:setItemID(player,96,getElementData(player,"weaponusing"),72);
    exports.fv_inventory:takePlayerWeapon(player);
    setElementData(player,"fishing.line",false);
    setElementData(player,"fishing",false);
    destroyCache(player)
end);

addEvent("fishing.success",true);
addEventHandler("fishing.success",root,function(player)
    triggerEvent("fishing.fail",player,player);
    local blue = exports.fv_engine:getServerColor("blue",true);
    local randItem = prices[math.random(1,#prices)];
    if exports.fv_inventory:givePlayerItem(player,randItem[1],1,1, math.random(95,100),0) then 
        outputChatBox(exports.fv_engine:getServerSyntax("Fishing","servercolor").."You have successfully caught a fish. "..blue.."("..exports.fv_inventory:getItemName(randItem[1])..")"..white.."." ,player,255,255,255,true);
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Fishing","red").."The fish didn't fit you, so you let it back into the water.",player,255,255,255,true);
    end
end);
