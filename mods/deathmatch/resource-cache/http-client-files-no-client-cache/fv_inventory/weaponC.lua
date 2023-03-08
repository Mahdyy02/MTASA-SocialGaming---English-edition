----------------------------------
local txd = engineLoadTXD("weapons/axe.txd");
engineImportTXD(txd, 321);
local dff = engineLoadDFF("weapons/axe.dff");
engineReplaceModel(dff, 321);
----------------------------------
local txd = engineLoadTXD("weapons/pickaxe.txd");
engineImportTXD(txd, 322);
local dff = engineLoadDFF("weapons/pickaxe.dff");
engineReplaceModel(dff, 322);
----------------------------------
local txd = engineLoadTXD("weapons/fishingrod.txd");
engineImportTXD(txd, 325);
local dff = engineLoadDFF("weapons/fishingrod.dff");
engineReplaceModel(dff, 325);
----------------------------------
engineImportTXD (engineLoadTXD("weapons/taser.txd"), 347);
engineReplaceModel(engineLoadDFF("weapons/taser.dff", 347), 347);
----------------------------------

-- local weaponSync = {};

-- addEventHandler("onClientPreRender",root,function()
--     for player,value in pairs(weaponSync) do 
--         if not isElement(player) then 
--             weaponSync[player] = nil;
--         else
--             --if isElementStreamedIn(player) then 
--                 local playerDimension, playerInterior = getElementDimension(player),getElementInterior(player);
--                 local x, y, z = getPedBonePosition(player, 3);
--                 local rot = math.rad(90 - getPedRotation(player));
--                 local ox,oy = math.cos(rot)*0.18,-math.sin(rot)*0.18;
--                 for id, datas in pairs(value) do 
--                     if isElement(datas[1]) then 
--                         if (getElementData(player,"weaponusing") == datas[2]) or (getElementData(player,"admin >> duty") and getElementData(player,"admin >> level") > 2) or getElementData(player,"fly") or getElementData(player,"reconPlayer") then 
--                             setElementPosition(datas[1], 0,0,0);
--                         else
--                             local rotY = 0;
--                             if weaponPos[getElementModel(datas[1])] then 
--                                 rotY = weaponPos[getElementModel(datas[1])];
--                             end
--                             setElementPosition(datas[1], x + ox, y + oy, z - 0.25)
--                             setElementRotation(datas[1], -5, rotY, getPedRotation(player));

--                             setElementDimension(datas[1],playerDimension);
--                             setElementInterior(datas[1],playerInterior);
--                         end
--                     end
--                 end
--             --end
--         end
--     end
-- end);

-- addEvent("item.syncWeapons",true);
-- addEventHandler("item.syncWeapons",localPlayer,function(table)
--     weaponSync = {};
--     weaponSync = tableCopy(table);
-- end);


local wCache = {};
local attachPos = {
    [28] = {14, 0.1, 0.05, 0, 0, -90, 90};
    [29] = {14, 0.1, 0.05, 0, 0, -90, 90};
    [24] = {13, 0.1, 0.05, 0, 0, -90, 90};

    [16] = {14, 0.15, -0.1, 0.2, 0, 0, 90};
    [17] = {14, 0.15, -0.1, 0.2, 0, 0, 90};
    [18] = {14, 0.15, -0.1, 0.2, 0, 0, 90};

    [32] = {14, 0.12, 0.05, 0, 0, -90, 90};

    [22] = {13, -0.08, 0.05, 0, 0, -90, 90};
    [23] = {13, -0.08, 0.05, 0, 0, -90, 90};

    [27] = {5, 0.16, -0, 0.3, 180, 320, -110};
    [26] = {5, 0.16, -0, 0.3, 180, 320, -110};
    [25] = {5, 0.16, -0, 0.3, 180, 320, -110};

    [33] = {5, 0.16, 0, 0.3, 180, 320, -110}; --Vadászpuska
    [34] = {5, 0.16, 0, 0.3, 180, 320, -110}; --Sniper

    [30] = {6, -0.05, 0, 0.2, 10, 150, 95}; --Ak
    [31] = {6, -0.05, 0, 0.2, 10, 150, 95}; --M4

    [2] = {6, -0.08, 0, -0.02, 10, -90, 100};
    [3] = {6, -0.08, 0, -0.02, 10, -90, 100};
    [5] = {6, -0.08, 0, -0.02, 10, -90, 100};
    [6] = {6, -0.08, 0, -0.02, 10, -90, 100};
    [7] = {6, -0.08, 0, -0.02, 10, -90, 100};
    [8] = {6, -0.08, 0, -0.02, 10, -90, 100};
};


addEventHandler("onClientResourceStart",resourceRoot,function()
    for _, player in pairs(getElementsByType("player",root,true)) do 
        if isElementStreamedIn(player) then 
            attachWeapons(player);
        end
    end
end);

addEventHandler("onClientElementStreamIn",root,function()
    if getElementType(source) == "player" then
        attachWeapons(source);
    end
end);

addEventHandler("onClientElementStreamOut",root,function()
    if getElementType(source) == "player" then 
        destroyWeapons(source);
    end
end);

addEventHandler("onClientPlayerQuit", root, function()
    destroyWeapons(source);
end);

function attachWeapons(player)
    destroyWeapons(player);
    wCache[player] = {};
    local playerX,playerY,playerZ = getElementPosition(player);
    local items = getElementData(player,"itemsTable");
    if items and type(items) == "table" then 
        for slot, value in pairs(items[1]) do 
            if fegyverek[value[1]] then 
                local weaponID = fegyverek[value[1]][1];
                local model = weaponIDtoModel(weaponID);
                if model and weaponID and not wCache[player][weaponID] then 
                    local obj = createObject(model,playerX,playerY,playerZ);
                    exports.fv_bone:attachElementToBone(obj,player,unpack(attachPos[weaponID]));

                    wCache[player][weaponID] = {obj, value[2], weaponID, value[1]};
                end
            end
        end
    end
end

function destroyWeapons(player)
    if wCache[player] then 
        for weaponID, table in pairs(wCache[player]) do 
            if isElement(table[1]) then 
                exports.fv_bone:detachElementFromBone(table[1]);
                destroyElement(table[1]);
            end
        end
    end
    wCache[player] = nil;
end

addEventHandler("onClientPreRender",root,function()
    for player, table in pairs(wCache) do 
        local playerInterior, playerDimension = getElementInterior(player), getElementDimension(player);
        local currentWeapon = getPedWeapon(player);
        for weaponID, cache in pairs(table) do 
            local obj = cache[1];
            if obj and isElement(obj) then 
                local objInterior, objDimension = getElementInterior(obj), getElementDimension(obj);
                if objInterior ~= playerInterior or objDimension ~= playerDimension then 
                    setElementDimension(obj,getElementDimension(player));
                    setElementInterior(obj,getElementInterior(player));
                end
            end
            if currentWeapon == weaponID or (getElementData(player,"admin >> duty") and getElementData(player,"admin >> level") > 2) or getElementData(player,"fly") or getElementData(player,"reconPlayer") then 
                setElementAlpha(cache[1],0);
            else 
                setElementAlpha(cache[1],255);
            end
        end
    end
end);

addEventHandler("onClientElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "player" and isElementStreamedIn(source) then 
        if dataName == "itemsTable" then 
            if oldValue ~= newValue and type(newValue) == "table" then 
                attachWeapons(source);
            end
        end
    end
end);