----Engine exports----
sql = exports.fv_engine:getConnection(getThisResource());

sColor = exports.fv_engine:getServerColor("servercolor",true);
blue = exports.fv_engine:getServerColor("blue",true);
setFPSLimit(100);
----------------------

Async:setPriority("high");

addEventHandler("onResourceStart",resourceRoot,function()
    setTimer(function()
        for k,v in pairs(getElementsByType("player")) do 
            takeAllWeapons(v);
            setElementData(v, "weaponusing", false );
            setElementData(v, "ammousing", false );
            setElementData(v, "weaponID", false );
            setElementData(v, "ammoID", false );
            setElementData(v, "fishingRod", false );
            if getElementData(v,"loggedIn") then 
                loadPlayerActionBar(v);
                loadPlayerItems(v);
            end
        end
        loadAllSafes();
    end,400,1);
end);

addEventHandler("onResourceStop",resourceRoot,function()
    local counter, tick = 0, getTickCount();
    for k,v in pairs(getElementsByType("player")) do
        if getElementData(v,"loggedIn") then 
            saveItems(v);
            counter = counter + 1;
        end
    end
    for k,v in pairs(getElementsByType("vehicle")) do 
        if (getElementData(v,"veh:id") or -1) > 0 then 
            saveItems(v);
            counter = counter + 1;
        end
    end
    for k,v in pairs(getElementsByType("object",resourceRoot)) do
        if (getElementData(v,"safe.id") or -1) > 0 then 
            saveItems(v);
            counter = counter + 1;
        end
    end
    --outputDebugString("ITEM_SAVE > "..counter.. " items saved in "..(getTickCount()-tick).." ms",0,200,0,200);
end);

addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "player" then 
        if dataName == "loggedIn" and newValue then 
            loadPlayerActionBar(source);
            loadPlayerItems(source,true);
        end
    end
end);

function loadPlayerItems(player,trigger)
    if not trigger then 
        trigger = false;
    end
    local accID = getElementData(player,"acc >> id");
    if accID and accID > 0 then 
        local tick = getTickCount();
        setElementData(player,"itemsTable",false);
        dbQuery(function(qh)
            local res,lines = dbPoll(qh,0);
            local temp = { {}, {}, {} };
            for k,row in pairs(res) do 
                local slot = tonumber(row["slot"]);
                local itemID = tonumber(row["itemID"]);
                local itemType = getItemType(itemID);
                temp[itemType][slot] = {row["itemID"], row["dbid"], row["darab"], row["ertek"], row["allapot"], fromJSON(row["egyebek"]) };
            end
            setElementData(player,"itemsTable",temp);
            if trigger then 
                triggerClientEvent(player,"item.returnItems",player);
            end
            --outputDebugString("ITEM > "..getPlayerName(player).. " items ("..lines..") loaded in "..(getTickCount()-tick).." ms",0,200,0,200);
        end,sql,"SELECT * FROM targyak WHERE ownerType='player' AND ownerID=?",accID);
    end
end

function getItems(player,element)
    if getElementType(element) == "player" then 
        local items = getElementData(element,"itemsTable");
        if not items then 
            loadPlayerItems(element,true);
        else 
            setElementData(player,"inventoryElement",element);
            triggerClientEvent(player,"item.returnItems",player,element);
        end
    elseif getElementType(element) == "object" and (getElementData(element,"safe.id") or -1) > 0 then 
        if checkUse(element) then return end;
        if not hasItem(player,42,1,getElementData(element,"safe.id")) then 
            if not (getElementData ( player, "admin >> level") >= 8) then
                return outputChatBox (exports.fv_engine:getServerSyntax("Item","red").."You have no key to the safe!", player, 255,255,255,true);
            else
                exports.fv_admin:sendMessageToAdmin(player, exports.fv_engine:getServerColor("servercolor",true).. exports.fv_admin:getAdminName(player) ..white.. " belenézett egy széfbe kulcs nélkül "..exports.fv_engine:getServerColor("red",true).."[".. (getElementData(element, "safe.id") or -1) .. "]", 1);
                exports.fv_logs:createLog("ADMIN_ITEMCHECK",exports.fv_admin:getAdminName(player).. " looked into a safe without a key [".. (getElementData(element, "safe.id") or -1) .. "]",player )
            end
        end
        local items = getElementData(element,"itemsTable");
        if not items then 
            loadSafeItems(element);
        end
        triggerClientEvent(player,"item.returnItems",player,element);
        exports.fv_chat:createMessage(player, "looked into a safe.",1);	
        setElementData(element,"item.used",true);
        setElementData(player,"inventoryElement",element);
    elseif getElementType(element) == "vehicle" then 
        if checkUse(element) then return end;
        local items = getElementData(element,"itemsTable");
        if not items then 
            loadVehicleItems(element);
        end
        triggerClientEvent(player,"item.returnItems",player,element);
        exports.fv_chat:createMessage(player, "he looked into a trunk.",1);
        setElementData(element,"item.used",true);
        setElementData(player,"inventoryElement",element);
    end
end
addEvent("item.getItems",true);
addEventHandler("item.getItems",root,getItems,true,"high");

addEventHandler("onPlayerQuit",root,function()
    local target = getElementData(source,"inventoryElement");
    if target then 
        setElementData(target,"item.used",false);
        collectgarbage();
    end
end);

function saveItems(element)
    local items = getElementData(element,"itemsTable");
    if items then 
        local type, dataName = getElementTypes(element);
        if type == "player" then 
            for itemType = 1, 3 do 
                if items[itemType] then 
                    for slot, value in pairs(items[itemType]) do 
                        dbExec(sql,"UPDATE targyak SET slot=?, ertek=?, allapot=?, egyebek=?, darab=?, ownerID=?, ownerType=? WHERE dbid=?",slot,value[4],value[5],toJSON(value[6] or {0}),value[3],getElementData(element,dataName),type,value[2]);
                    end
                end
            end
        else 
            for slot, value in pairs(items) do 
                dbExec(sql,"UPDATE targyak SET slot=?, ertek=?, allapot=?, egyebek=?, darab=?, ownerID=?, ownerType=? WHERE dbid=?",slot,value[4],value[5],toJSON(value[6] or {0}),value[3],getElementData(element,dataName),type,value[2]);
            end
        end
    end
    collectgarbage();
end
addEvent("item.saveItems",true);
addEventHandler("item.saveItems",root,saveItems,true,"high");

function loadPlayerActionBar(player)
    local accID = getElementData(player,"acc >> id");
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        local data = {};
        for i=1, actionSlots do 
            data[i] = {};
        end
        local data2 = {};
        for k,v in pairs(res) do 
            data2 = fromJSON(v.slots);
        end
        for k,v in pairs(data) do 
            if data2[k] then 
                data[k] = data2[k];
            end
        end
        triggerClientEvent("item.returnActionbar",player,data2);
        collectgarbage();
    end,sql,"SELECT * FROM actionBar WHERE playerID=?",accID);
end

addEvent("item.saveActionbar",true);
addEventHandler("item.saveActionbar",root,function(player,table)
    local save = {};
    for i=1,actionSlots do 
        if table[i] then 
            save[i] = table[i];
        else 
            save[i] = {};
        end
    end

    local accID = (getElementData(player,"acc >> id") or 0);
    dbExec(sql,"DELETE FROM actionBar WHERE playerID=?",accID);
    dbExec(sql,"INSERT INTO actionBar SET slots=?, playerID=?",toJSON(save),accID);
end);

function deleteItem(player,slot,item)
    dbExec(sql,"DELETE FROM targyak WHERE dbid=?",item[2]);
end
addEvent("item.deleteItem",true);
addEventHandler("item.deleteItem",root,deleteItem,true,"high");

addEvent("item.stackItems",true);
addEventHandler("item.stackItems",root,function(player,item,slot,oldItem)
    local items = getElementData(player,"itemsTable");
    if getElementType(player) == "player" then 
        local itemType = getItemType(item[1]);
        items[itemType][oldItem[3]][3] = items[itemType][oldItem[3]][3] - oldItem[2];
        items[itemType][slot] = nil;
        dbQuery(function(qh)
            local res,lines, dbid = dbPoll(qh,0);
                items[itemType][slot] = item;
                items[itemType][slot][2] = dbid;
                setElementData(player,"itemsTable",items);
                triggerEvent("item.getItems",player,player,player);
                saveItems(player);
        end,sql,"INSERT INTO targyak SET itemID=?, ownerID=?, slot=?, darab=?, ertek=?, allapot=?, egyebek=?, ownerType=?",item[1],getElementData(player,"acc >> id"),slot,item[3],item[4],item[5],toJSON(item[6]),"player");
    elseif getElementType(player) == "vehicle" or getElementType(player) == "object" then 
        local type, dataName = getElementTypes(player);
        items[oldItem[3]][3] = items[oldItem[3]][3] - oldItem[2];
        items[slot] = nil;
        dbQuery(function(qh)
            local res, lines, dbid = dbPoll(qh,0);
            items[slot] = item;
            items[slot][2] = dbid;
            setElementData(player,"itemsTable",items);
            saveItems(player);
        end,sql,"INSERT INTO targyak SET itemID=?, ownerID=?, slot=?, darab=?, ertek=?, allapot=?, egyebek=?, ownerType=?",item[1],getElementData(player,dataName),slot,item[3],item[4],item[5],toJSON(item[6]),type);
    end
    collectgarbage();
end,true,"high");

-- addEvent("item.updateItemCount",true);
-- addEventHandler("item.updateItemCount",root,function(player,slot,item,oldItem)
--     deleteItem(player,oldItem[2],oldItem[1]);
--     local items = getElementData(player,"itemsTable");
--     if getElementType(player) == "player" then 
--         local itemType = getItemType(item[1]);
--         items[itemType][slot] = nil;
--         items[itemType][slot] = item;
--     elseif getElementType(player) == "vehicle" or getElementType(player) == "object" then 
--         items[slot] = nil;
--         items[slot] = item;
--     end
--     dbExec(sql,"UPDATE targyak SET darab=? WHERE dbid=?",item[3],item[2]);
--     setElementData(player,"itemsTable",items);
--     saveItems(player);
-- end);

addEvent("item.moveItem",true);
addEventHandler("item.moveItem",root,function(player,element,slot,item,out)
    if not out then --Berakás
        if getElementType(element) == "object" or getElementType(element) == "vehicle" then 
            local itemType = getItemType(item[1]);
            local type, dataName = getElementTypes(element);
            local elementItems = getElementData(element,"itemsTable");
            elementItems[slot] = item;
            setElementData(element,"itemsTable",elementItems);
            dbExec(sql,"UPDATE targyak SET ownerID=?, ownerType=?, slot=? WHERE dbid=?",getElementData(element,dataName),type,slot,item[2]);
            exports.fv_chat:createMessage(player, "loaded an object ".. (type == "safe" and "in the safe" or "into a vehicle") .. " (".. getItemName(item[1]) .. ")",1);

            -- local targetSlot = hasElementItemPlace(element,item[1], item[3]);
            -- local itemType = getItemType(item[1]);
            -- local type, dataName = getElementTypes(element);
            -- if targetSlot then 
            --     local items = getElementData(player,"itemsTable");
            --     items[itemType][slot] = nil;

            --     local elementItems = getElementData(element,"itemsTable");
            --     elementItems[targetSlot] = item;

            --     dbExec(sql,"UPDATE targyak SET ownerID=?, ownerType=?, slot=? WHERE dbid=?",getElementData(element,dataName),type,targetSlot,item[2]);

            --     setElementData(player,"itemsTable",items);
            --     setElementData(element,"itemsTable",elementItems);

            --     saveItems(player);
            --     saveItems(element);
            --     exports.fv_chat:createMessage(player, "berakott egy tárgyat ".. (type == "safe" and "a széfbe" or "egy járműbe") .. " (".. getItemName(item[1]) .. ")",1);
            -- else 
            --     outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Nincs hely a ".. (type == "safe" and "a széfben" or "egy járműben") .." !",player,255,255,255,true);
            --     return;
            -- end
        elseif getElementType(element) == "player" then 
            local itemType = getItemType(item[1]);
            local type, dataName = getElementTypes(element);
            local elementItems = getElementData(element,"itemsTable");
            elementItems[itemType][slot] = item;
            setElementData(element,"itemsTable",elementItems);
            dbExec(sql,"UPDATE targyak SET ownerID=?, ownerType=?, slot=? WHERE dbid=?",getElementData(element,dataName),type,slot,item[2]);
            exports.fv_chat:createMessage(player, "handed over an object to "..getElementData(element,"char >> name")..". (".. getItemName(item[1]) .. ")",1);

            -- local targetSlot = hasPlayerItemPlace(element,item[1], item[3]);
            -- local itemType = getItemType(item[1]);
            -- if targetSlot then 
            --     local items = getElementData(player,"itemsTable");
            --     items[itemType][slot] = nil;

            --     local elementItems = getElementData(element,"itemsTable");
            --     elementItems[itemType][targetSlot] = item;

            --     dbExec(sql,"UPDATE targyak SET ownerID=?, ownerType=?, slot=? WHERE dbid=?",getElementData(element,"acc >> id"),"player",targetSlot,item[2]);

            --     setElementData(player,"itemsTable",items);
            --     setElementData(element,"itemsTable",elementItems);

            --     saveItems(player);
            --     saveItems(element);

            --     exports.fv_chat:createMessage(player, "átadott egy tárgyat "..getElementData(element,"char >> name").."-nak/nek. (".. getItemName(item[1]) .. ")",1);

            -- else 
            --     outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Nincs hely a játékosnál!",player,255,255,255,true);
            --     return;
            -- end
        end
    else --Kivétel
        -- local targetSlot = hasPlayerItemPlace(player,item[1],item[3]);
        -- local itemType = getItemType(item[1]);
        -- local type, dataName = getElementTypes(element);
        -- if targetSlot then 
        --     local items = getElementData(element,"itemsTable");
        --     items[slot] = nil;

        --     local elementItems = getElementData(player,"itemsTable");
        --     elementItems[itemType][targetSlot] = item;

        --     dbExec(sql,"UPDATE targyak SET ownerID=?, ownerType=?, slot=? WHERE dbid=?",getElementData(player,"acc >> id"),"player",targetSlot,item[2]);

        --     setElementData(element,"itemsTable",items);
        --     setElementData(player,"itemsTable",elementItems);

        --     saveItems(player);
        --     saveItems(element);

        --     exports.fv_chat:createMessage(player, "kivett egy tárgyat a ".. (type == "safe" and "széfből" or "csomagtartóból")..". (".. getItemName(item[1]) .. ")",1);
        -- else 
        --     outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Nincs hely a ".. (type == "safe" and "széfben") or (type == "vehicle" and "járműben").." !",player,255,255,255,true);
        --     return;
        -- end
        local itemType = getItemType(item[1]);
        local type, dataName = getElementTypes(player);
        local items = getElementData(player,"itemsTable");
        items[itemType][slot] = item;
        setElementData(player,"itemsTable",items);
        dbExec(sql,"UPDATE targyak SET ownerID=?, ownerType=?, slot=? WHERE dbid=?",getElementData(element,dataName),type,slot,item[2]);
        exports.fv_chat:createMessage(player, "took out an object from ".. (type == "safe" and "from safe" or "from the trunk")..". (".. getItemName(item[1]) .. ")",1);
    end
end,true,"high");

addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "vehicle" and dataName == "item.used" then 
        if newValue then 
            setVehicleDoorOpenRatio(source,1,1,1200);
        else 
            setVehicleDoorOpenRatio(source,1,0,1200);
        end
    end
end);

--Item Romlás
setTimer(function()
    --{itemID, itemDBID, darab, ertek, allapot, tabla };
    local tick, counter = getTickCount(), 0;
    for _, player in pairs(getElementsByType("player")) do
        local items = getElementData(player,"itemsTable");
        if items and items[1] then 
            for slot,value in pairs(items[1]) do 
                if etelek[value[1]] or halak[value[1]] then 
                    if value[5] > 0 then 
                        items[1][slot][5] = items[1][slot][5] - math.random(1,3); 
                        if items[1][slot][5] < 0 then 
                            items[1][slot][5] = 0;
                        end
                        dbExec(sql,"UPDATE targyak SET allapot=? WHERE dbid=?",items[1][slot][5],value[2]);
                        counter = counter + 1;
                    end
                end
            end
            setElementData(player,"itemsTable",items);
        end
    end

    for _, vehicle in pairs(getElementsByType("vehicle")) do
        local items = getElementData(vehicle,"itemsTable");
        if items then 
            for slot,value in pairs(items) do 
                if etelek[value[1]] or halak[value[1]] then 
                    if value[5] > 0 then 
                        items[slot][5] = items[slot][5] - math.random(1,3); 
                        if items[slot][5] < 0 then 
                            items[slot][5] = 0;
                        end
                        dbExec(sql,"UPDATE targyak SET allapot=? WHERE dbid=?",value[5],value[2]);
                        counter = counter + 1;
                    end
                end
            end
        end
        setElementData(vehicle,"itemsTable",items);
    end

    for _,safe in pairs(safes) do
        local items = getElementData(safe,"itemsTable");
        if items then 
            for slot,value in pairs(items) do 
                if etelek[value[1]] or halak[value[1]] then 
                    if value[5] > 0 then 
                        items[slot][5] = items[slot][5] - math.random(1,3); 
                        if items[slot][5] < 0 then 
                            items[slot][5] = 0;
                        end
                        dbExec(sql,"UPDATE targyak SET allapot=? WHERE dbid=?",value[5],value[2]);
                        counter = counter + 1;
                    end
                end
            end
        end
        setElementData(safe,"itemsTable",items);
    end

    --outputDebugString("ITEM > "..counter.. " item romlasztva idő: "..(getTickCount()-tick).." ms",0,200,0,200);
end,1000 * 60 * 15,0);
--------------

addEvent("item.motoz",true);
addEventHandler("item.motoz",root,function(player,element)
    local items = getElementData(element,"itemsTable");
    if not items then
        loadPlayerItems(element,true);
    else 
        triggerClientEvent(player,"item.returnItems",player,element);
    end
end);

addCommandHandler("seeinv",function(player,cmd,target)
    if getElementData(player,"admin >> level") > 6 then 
        if not getElementData(player,"admin >> duty") then 
            return outputChatBox(e:getServerSyntax("Item","red").."You are not in administrative service!",player,255,255,255,true);
        end
        if not target then return outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [Name detail/ID]",player,255,255,255,true) end;
        local targetPlayer = exports.fv_engine:findPlayer(player,target);
        local items = getElementData(targetPlayer,"itemsTable");
        if not items then
            loadPlayerItems(targetPlayer,true);
        else 
            triggerClientEvent(player,"item.returnItems",player,targetPlayer);
        end
        local targetPlayerName = getElementData(targetPlayer,"char >> name");
        exports.fv_admin:sendMessageToAdmin(player,sColor.. exports.fv_admin:getAdminName(player,true) ..white.. " looked "..sColor.. targetPlayerName:gsub("_"," ") ..white.. " inventory.", 1);
    end
end,false,false);

addEvent("item.craftItem",true);
addEventHandler("item.craftItem",root,function(player,item)
    if givePlayerItem(player,item.enditem,item.endCount,1,100,0) then 
        -- local items = getElementData(player,"itemsTable");
        for i = 1, 16 do
            if item[i] then 
                if not item[i][3] then 
                    takePlayerItem(player,item[i][1],item[i][2]);
                end
            end
        end
        -- setElementData(player,"itemsTable",items);
        exports.fv_chat:createMessage(player, "prepares an object. (".. getItemName(item.enditem) .. ")",1);
        outputChatBox(exports.fv_engine:getServerSyntax("Craft","servercolor").."You have successfully created an item: "..exports.fv_engine:getServerColor("blue",true)..getItemName(item.enditem)..white..".",player,255,255,255,true);
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Craft","red").."The crafted item did not fit in you, so the item was not made.",player,255,255,255,true);
    end
    triggerEvent("item.craftAnim",player,player,false);
end);
addEvent("item.craftAnim",true);
addEventHandler("item.craftAnim",root,function(player,state)
    if state then 
		setPedAnimation(player,"ghands","gsign4",-1,true,false,false,false);
    else 
		setPedAnimation(player,nil,nil);
    end
end);

--Exported Functions--
function setItemID(player,oldItemID,itemDBID,newItemID)
    local itemType = getItemType(oldItemID);
    local foundSlot, foundValue = false,false;
    local items = getElementData(player,"itemsTable");
    for slot, value in pairs(items[itemType]) do 
        if value[2] == itemDBID then 
            foundSlot = slot;
            foundValue = value;
            break;
        end
    end
    if foundSlot and foundValue then 
        foundValue[1] = newItemID;
        items[itemType][foundSlot] = foundValue;
        setElementData(player,"itemsTable",items);
        dbExec(sql,"UPDATE targyak SET itemID=? WHERE dbid=?",foundValue[1],foundValue[2]);
        return true;
    else 
        return false;
    end
end

function takeDutyItems(player) 
    local items = getElementData(player,"itemsTable");
    for itemType=1,3 do 
        for slot,value in pairs(items[itemType]) do 
            if value[6] and value[6][1] and value[6][1] == 1 then 
                dbExec(sql,"DELETE FROM targyak WHERE dbid=?",value[2]);
                items[itemType][slot] = nil;
            end
        end
    end
    setElementData(player,"itemsTable",items);
end

function takePlayerItem(player,itemID,count,dbID)
    if not count then count = 1 end;
    local items = getElementData(player,"itemsTable");
    local suc = false;
    local itemType = getItemType(itemID);
    for slot, value in pairs(items[itemType]) do 
        if (dbID and value[2] == dbID) or (not dbID and value[1] == itemID) then 
            if value[3] > count then 
                local new = items[itemType][slot][3] - count;
                items[itemType][slot][3] = new;
                dbExec(sql,"UPDATE targyak SET darab=? WHERE dbid=?",new,value[2]);
            else 
                items[itemType][slot] = nil;
                dbExec(sql,"DELETE FROM targyak WHERE dbid=?",value[2]);
            end
            suc = true;
            break;
        end
    end
    setElementData(player,"itemsTable",items);
    return suc;
end
addEvent("item.takePlayerItem",true);
addEventHandler("item.takePlayerItem",root,takePlayerItem,true,"high");

function hasItem(player,itemID, count, itemValue)
    local state,slotsave,dbidSave = false,-1,-1;
    if not count then count = 1 end;
    local items = getElementData(player,"itemsTable");
    local itemType = getItemType(itemID);
    if items and items[itemType] then 
        for slot,value in pairs(items[itemType]) do 
            if not itemValue then 
                if value[1] == itemID and value[3] >= count then 
                    state,slotsave,dbidSave = true, slot,value[2];
                    break;
                end
            else 
                if value[1] == itemID and value[3] >= count and value[4] == itemValue then
                    state,slotsave,dbidSave = true, slot,value[2];
                    break;
                end
            end
        end
    end
    return state,slotsave,dbidSave;
end

function hasPhone(player,number)
    local items = getElementData(player,"itemsTable");
	for slot,value in pairs(items[1]) do 
		if value[1] == 1 then 
			if value[6] and value[6][2] and (tonumber(value[6][2]) == tonumber(number)) then 
                return true;
			end
		end
	end
	return false;
end

function getItems(player,itemID)
    local temp = {};
    local items = getElementData(player,"itemsTable");
    local itemType = getItemType(itemID);
    for k,value in pairs(items[itemType]) do 
        if value[1] == itemID then 
            table.insert(temp,{value[5],value[2]});
        end
    end
    return temp;
end

function givePlayerItem(player, itemID, count, value, state, table, slot)
    local items = getElementData(player,"itemsTable");
    if not items then 
        loadPlayerItems(player);
    end
    if not slot then 
        slot = hasPlayerItemPlace(player, itemID, count);
    end
    if not slot then 
        return false;
    end
    local itemType = getItemType(itemID);
    if items[itemType][slot] then 
        return false;
    else 
        if not tonumber(table) then 
            table = toJSON(table);
        else 
            table = toJSON({table});
        end
        --{itemID, itemDBID, darab, ertek, allapot, tabla };
        items[itemType][slot] = {itemID, -1, count, value, state, fromJSON(table)};
        setElementData(player,"itemsTable",items);

        dbQuery(function(qh,itemType,slot)
            local items = getElementData(player,"itemsTable");
            local res,lines,dbid = dbPoll(qh,0);
            items[itemType][slot][2] = dbid;
            setElementData(player,"itemsTable",items);
        end,{itemType,slot},sql,"INSERT INTO targyak SET itemID = ?, ownerID = ?, slot = ?, darab = ?, ertek = ?, allapot = ?, ownerType = ?, egyebek = ?", tonumber(itemID), getElementData(player,"acc >> id"), slot, tonumber(count), tonumber(value), tonumber(state), "player", table);
        return true;
    end
end
----------------------------------

addEvent("itemlist.giveItem",true);
addEventHandler("itemlist.giveItem",root,function(player, itemID, count, value, state, table)
    if givePlayerItem(player, itemID, count, value, state, table) then 
        exports.fv_admin:sendMessageToAdmin(player,sColor.. exports.fv_admin:getAdminName(player,true) ..white.. " requested one "..sColor.. social_itemlista[itemID][1] ..white.. " object.", 1);
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."The item does not fit you!",player,255,255,255,true);
    end
end);

--Weapon Use--
function refreshAmmoUsing(player, ammoID)
	local state,slot,dbid = hasItem(player, ammoID, 1 );
	if dbid then
        setElementData(player, "ammousing", dbid);
    else
        takePlayerWeapon(player);
    end
end

function takePlayerWeapon ( player )
	setElementData ( player, "weaponusing", false );
	setElementData ( player, "ammousing", false );
    setElementData ( player, "ammoID", false );
    if getElementData(player,"weaponID") then
        exports.fv_chat:sendLocalMeAction(player, "laid down a gun. ( "..getItemName(getElementData(player,"weaponID")).." )",1);
    end
    takeAllWeapons ( player );
    setElementData ( player, "weaponID", false );
    if isElement(fishingRods[player]) then 
        destroyElement(fishingRods[player]);
        fishingRods[player] = nil
        setElementData(player,"fishingRod",false);
     end
    triggerEvent("plant.deleteCan",player,player);
end

addEventHandler ("onPlayerWeaponFire", root, function (weapon, endX, endY, endZ, hitElement, startX, startY, startZ)
    if weapon > 0 then 
        if not (getElementData(source,"skilling") or false) then
            if getElementData ( source, "weaponID" ) then
                local dbid = getElementData ( source , "ammousing" ) 
                takePlayerAmmo ( source, getElementData ( source, "ammoID" ) );
            else
                takePlayerWeapon( source );
            end
        end
    end
end);

addEventHandler ( "onPlayerWeaponSwitch", root ,function ( previousWeaponID, currentWeaponID ) --Fegyver bugfix
    if currentWeaponID == 0 then 
        takePlayerWeapon(source);
    end
end);

function takePlayerAmmo ( player, itemID )
    local items = getElementData(player,"itemsTable");
    local itemType = getItemType(itemID);
    if items and items[itemType] then 
        for slot, value in pairs(items[itemType]) do 
            if value[1] == itemID then 
                if value[3] - 1 > 0 then
                    value[3] = value[3] - 1;
                    -- dbExec(sql,"UPDATE targyak SET darab=? WHERE dbid = ?", value[3] , value[2]);
                else 
                    dbExec(sql,"DELETE FROM targyak WHERE dbid = ?", value[2]);
                    items[itemType][slot] = nil;
                    refreshAmmoUsing ( player, itemID );	
                end
            end
        end
        setElementData(player,"itemsTable",items);
    end
end

function howMuchItemHave(player, itemID, count)
    local items = getElementData(player,"itemsTable");
    local counter = 0;
    local itemType = getItemType(itemID);
    for slot, value in pairs(items[itemType]) do 
        if value[1] == itemID then 
            counter = counter + value[3];
        end
    end
    return counter;
end
----------------------











--Parancsok--
function giveItemByAdmin(player,cmd,target, itemID, darab, ertek, allapot, dutyItem)
    if not ( tonumber(getElementData ( player, "admin >> level")) > 7 ) then return end
    if getElementData(player,"admin >> level") == 10 then return end;
    if not getElementData(player,"admin >> duty") then
        return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").. "You are not in adminduty!", player, 255,0,0,true);
    end
	if not( target and itemID and darab and ertek and allapot and dutyItem ) then
		return outputChatBox ( exports.fv_engine:getServerSyntax("Use","red").."/".. cmd .. " [Name Detail] [ItemID] [Piece] [Value] [Status] [Dutyitem (0 or 1)]", player,255,255,255,true );
	else
		if not ( tonumber(itemID) and tonumber(darab) and tonumber(ertek) and tonumber(allapot) and tonumber(dutyItem) ) then
			return outputChatBox (exports.fv_engine:getServerSyntax("Use","red").. "/".. cmd .. " [Name Detail] [ItemID] [Piece] [Value] [Status] [Dutyitem (0 or 1)]", player,255,255,255,true );
		else --
			if (tonumber(itemID)) then
				if not ((tonumber(itemID) > 0) and (tonumber(itemID) <= #social_itemlista) and (tonumber(allapot) >= 0) and (tonumber(allapot) < 101) and ((tonumber(dutyItem) == 0) or (tonumber(dutyItem) == 1))  ) then
					return outputChatBox (exports.fv_engine:getServerSyntax("Use","red").. "/".. cmd .. " [Name Detail] [ItemID] [Piece] [Value] [Status] [Dutyitem (0 or 1)]", player,255,255,255,true );
				end
			end
		end
	end;
	local itemID = tonumber(itemID) --
	local targetPlayer = exports.fv_engine:findPlayer(player, target);
	local targetPlayerName = getElementData(targetPlayer,"char >> name") or getPlayerName(targetPlayer);

	local sColor = exports.fv_engine:getServerColor("servercolor",true);
	if targetPlayer then
		local success = givePlayerItem ( targetPlayer, tonumber(itemID), tonumber(darab), tonumber(ertek), tonumber(allapot), tonumber(dutyItem) );
		if (success) then
			exports.fv_admin:sendMessageToAdmin(player,sColor.. exports.fv_admin:getAdminName(player,true) ..white.. " successfully given "..sColor.. targetPlayerName:gsub("_"," ") ..white.. " a player named "..sColor.. social_itemlista[itemID][1] ..white.. " object.", 1);
			exports.fv_admin:sendMessageToAdmin(player, "Pieces : "..sColor.. darab  ..white.. " | Value : "..sColor.. ertek ..white.. " | Status : "..sColor.. allapot..white..".", 1);				
		else
			outputChatBox (exports.fv_engine:getServerSyntax("Item","red").. targetPlayerName:gsub("_"," ") .. " This item does not fit in the player named! ( ".. social_itemlista[itemID][1] .. " )", player,255,255,255,true );
			outputChatBox ( "Pieces : ".. darab  .. " | Value : ".. ertek .. " | Status : ".. allapot, player,255,255,255,true );
		end
	end
end
addCommandHandler("giveitem",giveItemByAdmin,false,false);



--Cache Clear--
addEventHandler("onPlayerQuit",root,function()
    if getElementData(source,"loggedIn") then 
        saveItems(source);
    end
end);
