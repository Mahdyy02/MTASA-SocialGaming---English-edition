function loadAllVehicleItems()
    local vehicles = getElementsByType("vehicle");
    local tick = getTickCount();
    local counter = 0;
    Async:foreach(vehicles,function(v)
        if (getElementData(v,"veh:id") or -1) > 0 then 
            loadVehicleItems(v);
            counter = counter + 1;
        end
    end,function()
        --outputDebugString("VEHICLE > ".. counter .." vehicle items loaded in "..(getTickCount()-tick).." ms",0,200,0,200);
    end);
end

function loadVehicleItems(vehicle)
    local vehID = getElementData(vehicle,"veh:id");
    dbQuery(function(qh)
        local temp = {};
        local res = dbPoll(qh,0);
        for k,v in pairs(res) do 
            local slot = tonumber(v["slot"]);
            temp[slot] = { v["itemID"], v["dbid"], v["darab"], v["ertek"], v["allapot"], fromJSON(v["egyebek"]) };
        end
        setElementData(vehicle,"itemsTable",temp);
    end, sql, "SELECT * FROM targyak WHERE ownerType='vehicle' AND ownerID=?",vehID); 
end

-- function hasVehicleItemPlace(element, itemID, count)
--     if not count then count = 1 end;
--     local items = getElementData(element,"itemsTable");
--     local kilo = getItemWeight(itemID) * count;
--     local max = getElementItemMaxWeight(element);
--     local current = 0;
--     local result = 1;
--     if items then 
--         for i=1, slots do 
--             if items[i] then 
--                 current = current + (getItemWeight(items[i][1]) * items[i][3]);
--             end
--         end
--     end
--     if current >= max or current + kilo > max then 
--         result = false;
--     else 
--         for i=1, slots do 
--             if items and not items[i] then 
--                 result = i;
--                 break
--             end
--         end
--     end
--     if items[result] then  
--         result = false;
--     end
--     return result;
-- end
