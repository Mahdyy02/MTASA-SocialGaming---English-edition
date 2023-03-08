--Scriptet írta: Csoki
--SocialGaming 2019
e = exports.fv_engine;
dx = exports.fv_dx;
sColor = {e:getServerColor("servercolor",false)};
sColor2 = e:getServerColor("servercolor",true);
orange2 = e:getServerColor("orange",true);
blue2 = e:getServerColor("blue",true);
red = {e:getServerColor("red",false)};
red2 = e:getServerColor("red",true);
orange = {e:getServerColor("orange",false)};
sx,sy = guiGetScreenSize();
local invPos = {sx-600,sy/2-250/2};
local panelMove = {};
local cursorX,cursorY = 0,0;
local itemTextures = {};
local noItemImage = dxCreateTexture("itemKepek/unknown.png","dxt1");
local itemType = 1;
local itemShow = false;
local inventoryElement = localPlayer;
local items = { --[[ slot = {itemID, itemDBID, darab, ertek, allapot, tabla }; ]] };
local itemMove = {};
local hoverSlot = -1;
local itemTypes = {
    -- ItemTipusok : 1 = Tárgyak | 2 = Iratok | 3 = Kulcsok
    [1] = {"Things",dxCreateTexture("icons/bag.png","dxt1")},
    [2] = {"Papers",dxCreateTexture("icons/wallet.png","dxt1")},
    [3] = {"Keys",dxCreateTexture("icons/key.png","dxt1")},
    [4] = {"Craft",dxCreateTexture("icons/craft.png","dxt1")},
}
local noTexture = dxCreateTexture("icons/no.png","dxt1");
local hoverActionSlot = -1;
local actionbar = {  --[[ slot = {itemID, itemDBID, darab, ertek, allapot, tabla }; ]] };
local lastClick = 0;
local otherIcons = {
    ["object"] = {"Safe",dxCreateTexture("icons/safe.png","dxt1")},
    ["vehicle"] = {"Vehicle",dxCreateTexture("icons/vehicle.png","dxt5")},
};
local eyeTexture = dxCreateTexture("icons/eye.png","dxt5");
local usedTexture = dxCreateTexture("icons/used.png","dxt5");
local usedAmmoTexture = dxCreateTexture("icons/usedAmmo.png","dxt5");

local isFactory = false;
function makeFactoryMarkers()
    local pos = {
        --{1490.9357910156, -1722.2423095703, 13.546875,0,0},
    }
    for k,v in pairs(pos) do 
        local x,y,z,int,dim = unpack(v);
        local mark = createMarker(x,y,z-1,"cylinder",0.8,sColor[1],sColor[2],sColor[3],130);
        setElementInterior(mark,int);
        setElementDimension(mark,dim);
        addEventHandler("onClientMarkerHit",mark,function(hitElement,dim) if hitElement == localPlayer and dim then isFactory = true end end);
        addEventHandler("onClientMarkerLeave",mark,function(hitElement,dim) if hitElement == localPlayer and dim then isFactory = false end end);
    end
end

local craftTab = 1;
local selectedCraft = 1;
local craftScroll = 0;
local craftClick = 0;
local craftLoading = -1;
local craftEndTick = 0;

local openTick = 0;
itemMoveTick = 0;

addEventHandler("onClientResourceStart",root,function(res)
    if getResourceName(res) == "fv_dx" then 
        dx = exports.fv_dx;
    end
    if res == getThisResource() then 
        loadPosition();
        for i=1, 300 do 
            if fileExists("itemKepek/"..i..".png") then 
                itemTextures[i] = dxCreateTexture("itemKepek/"..i..".png","dxt1");
            end
        end
        if dx:dxGetEdit("item.stack") then 
            dx:dxDestroyEdit("item.stack");
        end
        setElementData(localPlayer,"itemUse.food",false);
        setElementData(localPlayer,"inventoryElement",false);

        makeFactoryMarkers();
    end
end);

addEventHandler("onClientResourceStop",resourceRoot,function()
    for k,v in pairs(itemTextures) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
end);

function getItemImage(id)
    return itemTextures[id] or noItemImage;
end

addEventHandler("onClientElementDataChange",root,function(dataName,oldValue,newValue)
    if dataName == "itemsTable" and (source == inventoryElement or (not inventoryElement and source == localPlayer) ) then 
        if oldValue ~= newValue then 
            items = {};
            collectgarbage();
            if (getElementType(source) == "object" or getElementType(source) == "vehicle") then 
                items[1] = newValue;
            else 
                items = newValue;
            end
        end
    end
end);

addEvent("item.returnItems",true);
addEventHandler("item.returnItems",localPlayer,function(element,type)
    if element then 
        local table = getElementData(element,"itemsTable") or { {}, {}, {} };
        items = {};
        if (getElementType(element) == "object" or getElementType(element) == "vehicle") then 
            items[1] = {};
            items[1] = table;
            inventoryElement = element;
            dx:dxCreateEdit("item.stack","0","0",invPos[1]-50,invPos[2]+210,40,25,3,3);
            removeEventHandler("onClientRender",root,inventoryRender);
            addEventHandler("onClientRender",root,inventoryRender);
            itemShow = true;
            craftLoading = -1;
        else --LocalPlayer / otherPlayer
            items = table;
            if not element then 
                inventoryElement = localPlayer;
            else
                removeEventHandler("onClientRender",root,inventoryRender);
                addEventHandler("onClientRender",root,inventoryRender);
                itemShow = true;
                inventoryElement = element;
                craftLoading = -1;
            end
        end
        if type then 
            itemType = type;
        end
        collectgarbage();
    end
    --itemType = 4;
end,true,"high");

function isInventoryOpen()
    return itemShow;
end

addEvent("item.returnActionbar",true);
addEventHandler("item.returnActionbar",localPlayer,function(table)
    for i=1, actionSlots do 
        actionbar[i] = {};
    end
    actionbar = table;
end);

function isActionbar(dbid)
    local state = false;
    for slot,value in pairs(actionbar) do 
        if value[2] == dbid then 
            state = true;
            break;
        end
    end
    return state; 
end

function findByDBID(itemID,dbID) --Actionbarhoz.
    local found = false;
    local temp = getElementData(localPlayer,"itemsTable");
    if temp then 
        local type = getItemType(itemID);
        if temp[type] then 
            for slot, value in pairs(temp[type]) do 
                local id, dbid, count, value, state, other = unpack(value);
                if tonumber(dbID) == tonumber(dbid) then 
                    found = temp[type][slot];
                    break
                end
            end
        end
    end
    return found;
end

addEventHandler("onClientKey",root,function(button,state)
    if isCrafting() then 
        cancelEvent();
    end
end);

addEventHandler("onClientPreRender",root,function(dt)
    if craftLoading ~= -1 then
        if getElementData(localPlayer,"network") then 
            craftLoading = craftLoading + (0.01*dt);
            toggleAllControls(false,false,true);
            if craftLoading >= 180 then --Craft Kész
                triggerServerEvent("item.craftItem",localPlayer,localPlayer,craftItems[craftTab][selectedCraft]);
                craftLoading = -1;
                craftEndTick = getTickCount();
                toggleAllControls(true,true,true);
            end
        end
    end
end);

addEventHandler("onClientRender",root,function() --actionbar
    hoverActionSlot = -1;
    
    setPlayerHudComponentVisible("crosshair",true);
    toggleControl("next_weapon", false);
    toggleControl("previous_weapon", false);

    if getElementData(localPlayer,"loggedIn") and getElementData(localPlayer,"actionbar.showing") and getElementData(localPlayer,"togHUD") then 
        local actionX, actionY = getElementData(localPlayer,"actionbar.x"),getElementData(localPlayer,"actionbar.y");
        dxDrawRectangle(actionX,actionY,290,50,tocolor(0,0,0,130));
        dxDrawRectangle(actionX-3,actionY,3,50,tocolor(sColor[1],sColor[2],sColor[3],180));
        for i=1, actionSlots do 
            local itemX,itemY = actionX-itemSize+2+(i*(itemSize+5)),actionY+5;
            local color = tocolor(0,0,0,130);
            if getKeyState(i) then 
                color = tocolor(sColor[1],sColor[2],sColor[3],180);
            end
            if e:isInSlot(itemX,itemY,itemSize,itemSize) then 
                hoverActionSlot = i;
                color = tocolor(sColor[1],sColor[2],sColor[3],180);
            end
            dxDrawBorder(itemX,itemY,itemSize,itemSize,1,tocolor(sColor[1],sColor[2],sColor[3],100));

            dxDrawRectangle(itemX,itemY,itemSize,itemSize,color);
            if actionbar[i] and #actionbar[i] > 0 then 
                local item = findByDBID(actionbar[i][1],actionbar[i][2]);
                local postGUI = true;
                if item then 
                    local id, dbid, count, value, state, other = unpack(item);
                    dxDrawImage(itemX,itemY,itemSize,itemSize,getItemImage(id),0,0,0,tocolor(255,255,255),postGUI);
                    shadowedText(tostring(count),itemX+2,itemY,itemSize,itemY+itemSize,tocolor(255,255,255),1,e:getFont("rage",10),"left","bottom",postGUI);

                    if (isHunger and isHunger == dbid) or ((getElementData(localPlayer,"weaponusing") or -1) == dbid) then 
                        dxDrawImage(itemX-2,itemY-2,itemSize+4,itemSize+4,usedTexture,0,0,0,tocolor(255,255,255),postGUI);
                    end
                    if ((getElementData(localPlayer,"ammousing") or -1) == dbid) then 
                        dxDrawImage(itemX-2,itemY-2,itemSize+4,itemSize+4,usedAmmoTexture,0,0,0,tocolor(255,255,255),postGUI);
                    end
                else 
                    dxDrawImage(itemX+2,itemY+2,itemSize-4,itemSize-4,noTexture,0,0,0,tocolor(255,255,255),postGUI);
                end
            end
        end
    end
end);

function inventoryRender()
    hoverSlot = -1;
    if isCursorShowing() then 
        cursorX,cursorY = getCursorPosition();
        cursorX, cursorY = cursorX * sx, cursorY * sy;

        if panelMove[1] then 
            invPos[1] = panelMove[2] + cursorX;
            invPos[2] = panelMove[3] + cursorY;
        end
    else 
        if panelMove[1] then 
            panelMove = {};
        end
    end

    dxDrawRectangle(invPos[1]-60,invPos[2]-25,480,265,tocolor(31,30,30,240));
    dxDrawRectangle(invPos[1]-63,invPos[2]-25,3,265,tocolor(sColor[1],sColor[2],sColor[3],180));

    dxDrawText(sColor2.."The"..white.."Devils",invPos[1]-60,invPos[2]-25,invPos[1]-60+480,invPos[2]-25+20,tocolor(255,255,255),1,e:getFont("rage",13),"center","center",false,false,false,true);

    if getElementType(inventoryElement) ~= "player" then 
        local pPos = Vector3(getElementPosition(localPlayer));
        local tPos = Vector3(getElementPosition(inventoryElement));
        if getDistanceBetweenPoints3D(pPos.x, pPos.y, pPos.z, tPos.x, tPos.y, tPos.z) > 5 then 
            closeInventory();
            return;
        end
        if getElementType(inventoryElement) == "vehicle" then 
            if isVehicleLocked(inventoryElement) then 
                outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Vehicle was locked.",255,255,255,true);
                closeInventory();
                return;
            end
        end
    end

    if getElementType(inventoryElement) == "player" then 
        -- dxDrawRectangle(invPos[1]+285,invPos[2]-40,135,30,tocolor(0,0,0,130));
        for type, datas in pairs(itemTypes) do 
            local typeColor = tocolor(255,255,255);
            if (e:isInSlot(invPos[1] - 102 + (type * 102),invPos[2]+210,102,25) or (itemType == type)) then 
                typeColor = tocolor(sColor[1],sColor[2],sColor[3],180);
                dxDrawRectangle(invPos[1] - 102 + (type * 102),invPos[2] + 240,102,2,tocolor(sColor[1],sColor[2],sColor[3],140));
            end 
            dxDrawImage(invPos[1] - 100 + (type * 102),invPos[2]+212,40/2.3,48/2.3,datas[2],0,0,0,typeColor);
            dxDrawText(datas[1],invPos[1] - 70 + (type * 102),invPos[2]+210,102,invPos[2]+210+25,typeColor,1,e:getFont("rage",12),"left","center");
        end

        if itemMove[1] then 
            local eyeColor = tocolor(255,255,255);
            if e:isInSlot(invPos[1]-60+240-32.5,invPos[2]-70,65,35) then 
                eyeColor = tocolor(sColor[1],sColor[2],sColor[3]);
            end
            dxDrawImage(invPos[1]-60+240-32.5,invPos[2]-70,65,35,eyeTexture,0,0,0,eyeColor);
        end
    else
        local w = dxGetTextWidth(otherIcons[getElementType(inventoryElement)][1],1,e:getFont("rage",12),false) + 50;
        -- dxDrawRectangle(invPos[1]-60+480-w,invPos[2]-40,w,30,tocolor(0,0,0,130));
        dxDrawImage(invPos[1]+390,invPos[2]+210,32/1.2,32/1.2,otherIcons[getElementType(inventoryElement)][2]);
        dxDrawText(otherIcons[getElementType(inventoryElement)][1],invPos[1]-60+480-w,invPos[2]+210,invPos[1]-60+480-35,invPos[2]+210+30,tocolor(255,255,255),1,e:getFont("rage",12),"right","center");
    end

    if inventoryElement == localPlayer or getElementType(inventoryElement) == "object" or getElementType(inventoryElement) == "vehicle" then 
        dx:dxSetEditPosition("item.stack",invPos[1]-50,invPos[2]+210);
    end

    if getElementType(inventoryElement) == "player" and inventoryElement ~= localPlayer then 
        dxDrawText(formatMoney(getElementData(inventoryElement,"char >> money"))..sColor2.."dt",invPos[1]-50,invPos[2]-25,0,0,tocolor(255,255,255),1,e:getFont("rage",15),"left","top",false,false,false,true);
    end

    if itemType == 4 then --Craft
        for k,v in pairs(craftTypes) do 
            local color = tocolor(255,255,255);
            if craftTab == k then 
                color = tocolor(sColor[1],sColor[2],sColor[3],180);
            end
            if e:isInSlot(invPos[1]-90+(k*40),invPos[2],30,30) then 
                color = tocolor(sColor[1],sColor[2],sColor[3]);
                tooltip(v.name);
                if getKeyState("mouse1") and craftClick+500 < getTickCount() and craftTab ~= k and (craftLoading == -1) then 
                    selectedCraft = 1;
                    craftTab = k;
                    craftClick = getTickCount();
                end
            end
            dxDrawRectangle(invPos[1]-90+(k*40),invPos[2],30,30,tocolor(0,0,0,180));
            dxDrawText(v.icon,invPos[1]-90+(k*40),invPos[2],invPos[1]-90+(k*40)+32,invPos[2]+30,color,1,e:getFont("AwesomeFont",13),"center","center");
        end

        local cCount = 0;
        for k,v in pairs(craftItems[craftTab]) do 
            if k > craftScroll and cCount < 5 then 
                cCount = cCount + 1;
                local color = tocolor(0,0,0,180);
                if selectedCraft == k then 
                    color = tocolor(sColor[1],sColor[2],sColor[3],180);
                end
                if e:isInSlot(invPos[1]-50,invPos[2]+10+(cCount*25),180,20) then 
                    color = tocolor(sColor[1],sColor[2],sColor[3]);
                    if getKeyState("mouse1") and craftClick+500 < getTickCount() and selectedCraft ~= k and (craftLoading == -1) then 
                        selectedCraft = k;
                        craftClick = getTickCount();
                    end
                end
                dxDrawRectangle(invPos[1]-50,invPos[2]+10+(cCount*25),180,20,color);
                dxDrawText(getItemName(v.enditem),invPos[1]-50,invPos[2]+10+(cCount*25),invPos[1]-50+180,invPos[2]+10+(cCount*25)+20,tocolor(255,255,255),1,e:getFont("rage",10),"center","center");
            end
        end

        local endItem = craftItems[craftTab][selectedCraft];
        local endColor = tocolor(0,0,0,180);
        if e:isInSlot(invPos[1]+150,invPos[2]+70,itemSize,itemSize) then 
            local faction = red2.."Not necessary."..white;
            if endItem.faction then 
                faction = sColor2..endItem.faction..white;
            end
            local pos = sColor2.."anywhere";
            if endItem.factory then 
                pos = orange2.."Factory";
            end
            tooltip(getItemName(endItem.enditem),"Faction: "..faction,"Position: "..pos);
            endColor = tocolor(sColor[1],sColor[2],sColor[3],180);
        end
        dxDrawRectangle(invPos[1]+150,invPos[2]+70,itemSize,itemSize,endColor);
        dxDrawImage(invPos[1]+150,invPos[2]+70,itemSize,itemSize,getItemImage(endItem.enditem));
        shadowedText(tostring(endItem.endCount),invPos[1]+152,invPos[2]+70,itemSize,itemSize+invPos[2]+70,tocolor(255,255,255),1,e:getFont("rage",10),"left","bottom");


        local need = {};
        local c = 0;
        local x,y = 0,invPos[2];
        for i = 1, 16 do
            x = invPos[1] + 208 + (c * (itemSize + padding));
            c = c + 1;

            dxDrawBorder(x,y,itemSize,itemSize,1,tocolor(sColor[1],sColor[2],sColor[3],100));
            dxDrawRectangle(x,y,itemSize,itemSize,tocolor(0,0,0,100));

            if craftItems[craftTab][selectedCraft][i] then 
                local item, count = unpack(craftItems[craftTab][selectedCraft][i]);
                dxDrawImage(x,y,itemSize,itemSize,getItemImage(item));
                shadowedText(tostring(count),x+2,y,itemSize,y+itemSize,tocolor(255,255,255),1,e:getFont("rage",10),"left","bottom");
                if e:isInSlot(x,y,itemSize,itemSize) then 
                    tooltip(getItemName(item));
                end

                if not hasItem(item,false,count) then 
                    table.insert(need,{item,count});
                    dxDrawImage(x-2,y-2,itemSize+4,itemSize+4,usedAmmoTexture,0,0,0,tocolor(255,255,255));
                else 
                    dxDrawImage(x-2,y-2,itemSize+4,itemSize+4,usedTexture,0,0,0,tocolor(255,255,255));
                end
            end

            if c == 4 then 
                c = 0;
                y = y + (itemSize + padding);
            end
        end

        local createButton = {red[1],red[2],red[3],110};
        if #need == 0 then 
            createButton = {sColor[1],sColor[2],sColor[3],110};
        end
        if e:isInSlot(invPos[1]-50,invPos[2]+175,180,30) then 
            createButton[4] = 200;
        end
        dxDrawRectangle(invPos[1]-50,invPos[2]+175,180,30,tocolor(createButton[1],createButton[2],createButton[3],createButton[4]));
        if craftLoading ~= -1 then 
            dxDrawRectangle(invPos[1]-50,invPos[2]+175,craftLoading,30,tocolor(createButton[1],createButton[2],createButton[3],255));
        end
        shadowedText("Preparation",invPos[1]-50,invPos[2]+175,invPos[1]-50+180,invPos[2]+175+30,tocolor(255,255,255),1,e:getFont("rage",13),"center","center");

    else
        local kilo = 0;
        local c = 0;
        local x,y = 0,invPos[2];
        for i = 1, slots do
            x = invPos[1] + (c * (itemSize + padding));
            c = c + 1;

            dxDrawBorder(x,y,itemSize,itemSize,1,tocolor(sColor[1],sColor[2],sColor[3],100));

            local slotColor = tocolor(0,0,0,100);
            if e:isInSlot(x,y,itemSize,itemSize) then 
                slotColor = tocolor(sColor[1],sColor[2],sColor[3],180);
                hoverSlot = i;
            end
            dxDrawRectangle(x,y,itemSize,itemSize,slotColor);

            if items[itemType] and items[itemType][i] then 
                local id, dbid, count, value, state, other = unpack(items[itemType][i]);

                kilo = kilo + (getItemWeight(id) * count);

                local itemX, itemY, postGUI = x,y,false;
                if itemMove[1] and itemMove[5] == i then 
                    itemX, itemY, postGUI = itemMove[2] + cursorX,itemMove[3] + cursorY, true;
                    count = itemMove[6] and itemMove[6] or count;
                end
                dxDrawImage(itemX,itemY,itemSize,itemSize,getItemImage(id),0,0,0,tocolor(255,255,255),postGUI);
                shadowedText(tostring(count),itemX+2,itemY,itemSize,itemY+itemSize,tocolor(255,255,255),1,e:getFont("rage",10),"left","bottom",postGUI);
                if isActionbar(dbid) then
                    dxDrawImage(itemX+2,itemY+2,itemSize-4,itemSize-4,noTexture,0,0,0,tocolor(255,255,255,130), false);
                end
                if (isHunger and isHunger == dbid) or ((getElementData(localPlayer,"weaponusing") or -2) == dbid) then 
                    dxDrawImage(itemX-2,itemY-2,itemSize+4,itemSize+4,usedTexture,0,0,0,tocolor(255,255,255), not postGUI);
                end
                if ((getElementData(localPlayer,"ammousing") or -2) == dbid) then 
                    dxDrawImage(itemX-2,itemY-2,itemSize+4,itemSize+4,usedAmmoTexture,0,0,0,tocolor(255,255,255), not postGUI);
                end
                if e:isInSlot(itemX,itemY,itemSize,itemSize) and itemMove[5] ~= i and not itemMove[1] then --Toolip
                    local duty = "";
                    if other and other[1] == 1 then 
                        duty = blue2.." (Duty)"..white;
                    end
                    if getElementData(localPlayer,"admin >> level") >= 11 then 
                        duty = duty ..white.." (DBID: "..red2..dbid..white..")";
                    end
                    local drawValue = "";
                    if value > 1 then 
                        drawValue = "Value: "..blue2..value;
                    elseif id == 90 then --Adásvételi
                        drawValue = "Value: "..blue2..other[2].plate;
                    elseif other and other[2] and type(other[2]) ~= "table" then 
                        drawValue = "Value: "..blue2..other[2];
                    end
                    if etelek[id] or halak[id] or (fegyverek[id] and not fegyverek[id][4]) then 
                        local state = math.floor(state);
                        tooltip(getItemName(id)..duty,"Weight: "..sColor2..(getItemWeight(id) * count)..white.."kg","Condition: "..coloredState(state)..white.."%");
                    elseif drawValue ~= "" then 
                        tooltip(getItemName(id)..duty,"Weight: "..sColor2..(getItemWeight(id) * count)..white.."kg",drawValue);
                    else
                        tooltip(getItemName(id)..duty,"Weight: "..sColor2..(getItemWeight(id) * count)..white.."kg");
                    end
                end
            end

            if c == 8 then 
                c = 0;
                y = y + (itemSize + padding);
            end
        end

        --Suly--
        local maxKilo = getElementItemMaxWeight(inventoryElement);
        local szazalek = (math.ceil(kilo) / maxKilo) * 100;

        -- dxDrawRectangle(invPos[1]-50,invPos[2],40,200,tocolor(0,0,0,60));
        dxDrawBorder(invPos[1]-50,invPos[2],40,200,1,tocolor(sColor[1],sColor[2],sColor[3],100));


        dxDrawRectangle(invPos[1]-45,invPos[2]+195,30,-szazalek*1.9,tocolor(sColor[1],sColor[2],sColor[3],180));
        shadowedTextRotated(kilo.." kg / "..maxKilo.." kg",invPos[1]-50,invPos[2],invPos[1]-50+40,invPos[2]+200,tocolor(255,255,255),1,e:getFont("rage",12),"center","center");
        ---------
    end
end

bindKey("i","down",function()
if getElementData(localPlayer,"loggedIn") then 
    if (craftLoading == -1) then 
        if dx:dxGetEdit("item.stack") then 
            dx:dxDestroyEdit("item.stack");
        end
        if itemShow then 
            closeInventory();
        else 
            triggerServerEvent("item.getItems",localPlayer,localPlayer,localPlayer);

            dx:dxCreateEdit("item.stack","0","0",invPos[1]-50,invPos[2]+210,40,25,3,3);
            inventoryElement = localPlayer;
            removeEventHandler("onClientRender",root,inventoryRender);
            addEventHandler("onClientRender",root,inventoryRender);
            itemShow = true;
        end
        itemMove = {};
        itemType = 1;
        hoverSlot = -1;
    end
end
end);

function closeInventory()
    panelMove = {};
    itemMove = {};
    itemType = 1;
    hoverSlot = -1;
    removeEventHandler("onClientRender",root,inventoryRender);
    savePosition();

    if dx:dxGetEdit("item.stack") then 
        dx:dxDestroyEdit("item.stack");
    end

    -- if inventoryElement == localPlayer then 
    --     saveInventory();
    -- end

    saveInventory();

    local clear = false;
    if inventoryElement ~= localPlayer then 
        clear = true;
        setElementData(inventoryElement,"item.used",false);
    end
    if clear then 
        items = {};
        collectgarbage();
    end
    itemShow = false;
    inventoryElement = localPlayer;
    setElementData(localPlayer,"inventoryElement",localPlayer);
    items = getElementData(localPlayer,"itemsTable");
    -- triggerServerEvent("item.getItems",localPlayer,localPlayer,localPlayer);
end

addEventHandler("onClientClick",root,function(button,state,clickX,clickY,wx,wy,wz,clickedElement)
    if not getElementData(localPlayer,"loggedIn") then return end;
    if not getElementData(localPlayer,"network") then 
        -- outputChatBox(e:getServerSyntax(nil,"red").."Rossz internet kapcsolat miatt minden tiltva!",255,255,255,true);
        panelMove = {};
        itemMove = {};
        return;
    end;

    if button == "right" and state == "down" then 
        if clickedElement then 
            local pPos = Vector3(getElementPosition(localPlayer));
            if getDistanceBetweenPoints3D(pPos.x,pPos.y,pPos.z,wx,wy,wz) < 3 and getElementType(clickedElement) ~= "player" then 
                if getElementType(clickedElement) == "object" and getElementData(clickedElement,"safe.id") or -1 > 0 then 
                    if openTick+3500 > getTickCount() then 
                        return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You can't use the safe so fast!",255,255,255,true);
                    end
                    if checkUse(clickedElement) then
                    -- if getElementData(clickedElement,"item.used") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Inventory in use!",255,255,255,true);
                        return;
                    end
                    if inventoryElement and inventoryElement ~= clickedElement then 
                        closeInventory();
                    end
                    openTick = getTickCount();
                    triggerServerEvent("item.getItems",localPlayer,localPlayer,clickedElement); --Safe Inventory
                end
                if getElementType(clickedElement) == "vehicle" then 
                    if(getElementData(clickedElement,"veh:id") or -1) > 0 or not isVehicleHasInventory(getElementModel(clickedElement)) then
                        if isPedInVehicle(localPlayer) then 
                            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You cannot open the boot in a vehicle!",255,255,255,true);
                            return;
                        end
                        if getElementData(clickedElement,"veh:locked") or isVehicleLocked(clickedElement) then 
                            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Trunk locked!",255,255,255,true);
                            return;
                        end
                        if openTick+3500 > getTickCount() then 
                            return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You can’t use the trunk so fast!",255,255,255,true);
                        end
                        if checkUse(clickedElement) then 
                        -- if getElementData(clickedElement,"item.used") then 
                            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Inventory is in use!",255,255,255,true);
                            return;
                        end
                        if inventoryElement and inventoryElement ~= clickedElement then 
                            closeInventory();
                        end
                        openTick = getTickCount();
                        triggerServerEvent("item.getItems",localPlayer,localPlayer,clickedElement); --Vehicle Inventory
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."This vehicle has no trunk.",255,255,255,true);
                        return;
                    end
                end
            end
        end
    end

    --Inventory Mozgatása--
if itemShow then 
    if button == "left" then 
        if state == "down" then 
            if not panelMove[1] and not itemMove[1] then 
                -- if e:isInSlot(invPos[1]-60,invPos[2]-40,480,30) and not e:isInSlot(invPos[1]+285,invPos[2]-40,135,30) then 
                if e:isInSlot(invPos[1]-60,invPos[2]-25,480,20) then 
                    panelMove[1] = true;
                    panelMove[2] = invPos[1] - clickX;
                    panelMove[3] = invPos[2] - clickY;
                end
            end
        end 
        if state == "up" then 
            if panelMove[1] then 
                panelMove = {};
            end
        end
    end
    ----------------------

    if button == "left" and state == "down" then 
        --Page change--
        for type, datas in pairs(itemTypes) do 
            if e:isInSlot(invPos[1] - 102 + (type * 102),invPos[2]+210,102,25) and (itemType ~= type) and (craftLoading == -1) then 
                if getElementType(inventoryElement) == "player" then 
                    if inventoryElement == localPlayer then 
                        itemType = type;
                    else 
                        if type < 4 then 
                            itemType = type;
                        end
                    end
                end
            end
        end
        ---------------
    end


    if button == "left" and (inventoryElement == localPlayer or getElementType(inventoryElement) == "object" or getElementType(inventoryElement) == "vehicle") then 
        if state == "down" and (craftLoading == -1) then 
            if itemType == 4 then --Craft Cuccai
                local need = {};
                local c = 0;
                local x,y = 0,invPos[2];
                for i = 1, 16 do
                    x = invPos[1] + 208 + (c * (itemSize + padding));
                    c = c + 1;
                    if craftItems[craftTab][selectedCraft][i] then 
                        local item, count = unpack(craftItems[craftTab][selectedCraft][i]);      
                        if not hasItem(item,false,count) then 
                            table.insert(need,{item,count});
                            dxDrawRectangle(x,y,itemSize,itemSize,tocolor(red[1],red[2],red[3],100));
                        end
                    end    
                    if c == 4 then 
                        c = 0;
                        y = y + (itemSize + padding);
                    end
                end
                if e:isInSlot(invPos[1]-50,invPos[2]+175,180,30) then  
                    if #need ~= 0 then 
                        outputChatBox(e:getServerSyntax("Craft","red").."You do not have the required items!",255,255,255,true);
                    else 
                        if getElementData(localPlayer,"fishing") then 
                            return outputChatBox(e:getServerSyntax("Item","red").."You can't craft while fishing!",255,255,255,true);
                        end
                        if craftEndTick+2000 > getTickCount() then return end;
                        local faction = craftItems[craftTab][selectedCraft].faction;
                        if faction then 
                            if exports.fv_dash:isIllegal() then 
                                craftLoading = 0;
                                triggerServerEvent("item.craftAnim",localPlayer,localPlayer,true);
                            else 
                                return outputChatBox(e:getServerSyntax("Craft","red").."You do not belong to an illegal faction!",255,255,255,true);
                            end
                        else 
                            if craftItems[craftTab][selectedCraft].factory then 
                                if isFactory then 
                                    outputChatBox(e:getServerSyntax("Craft","red").."Not yet!",255,255,255,true);
                                else 
                                    outputChatBox(e:getServerSyntax("Craft","red").."You're not in a factory!",255,255,255,true);
                                end
                            else
                                craftLoading = 0;
                                triggerServerEvent("item.craftAnim",localPlayer,localPlayer,true);
                            end
                        end
                    end
                end    
            end

            local c = 0;
            local x,y = 0,invPos[2];
            for i = 1, slots do
                x = invPos[1] + (c * (itemSize + padding));
                c = c + 1;
                if items[itemType] and items[itemType][i] then 
                    local id, dbid, count, value, state, other = unpack(items[itemType][i]);
                    if not panelMove[1] and not itemMove[1] then --ItemMozgatas
                        if e:isInSlot(x,y,itemSize,itemSize) then  
                            if lastClick+300 > getTickCount() then 
                                outputChatBox(e:getServerSyntax("Item","red").."Not so fast!",255,255,255,true);
                                return;
                            end
                            if isActionbar(dbid) or (isHunger and isHunger == dbid) or ((getElementData(localPlayer,"weaponusing") or -2) == dbid) or ((getElementData(localPlayer,"ammousing") or -2) == dbid) then 
                                outputChatBox(e:getServerSyntax("Item","red").."You cannot move if the item is in the actionbar.",255,255,255,true);
                                return;
                            end
                            itemMove[1] = true;
                            itemMove[2] = x - clickX;
                            itemMove[3] = y - clickY;
                            itemMove[4] = items[itemType][i];
                            local stack = tonumber(dx:dxGetEditText("item.stack"));
                            if stack and stack ~= 0 and stack > 0 then 
                                if count <= stack then 
                                    itemMove = {};
                                    return;
                                end
                                itemMove[6] = stack;
                            end
                            itemMove[5] = i;
                            lastClick = getTickCount();
                        end
                    end
                end
                if c == 8 then 
                    c = 0;
                    y = y + (itemSize + padding);
                end
            end
            if hoverActionSlot > 0 then 
                actionbar[hoverActionSlot] = {};
                triggerServerEvent("item.saveActionbar",localPlayer,localPlayer,actionbar);
            end
        elseif state == "up" then 
            if itemMove[1] then 
                if hoverActionSlot < 0 then 
                    if hoverSlot < 0 then --Nincs az inventoryba
                        if not clickedElement then 
                            if e:isInSlot(invPos[1]-60+240-32.5,invPos[2]-70,65,35) then --Felmutatás
                                setElementData(localPlayer,"item.show",{getTickCount(),getItemName(itemMove[4][1]),itemMove[4][3],itemMove[4][1]},true);
                                setTimer(function()
                                    setElementData(localPlayer,"item.show",false);
                                end,4000,1);
                                exports.fv_chat:createMessage(localPlayer,"shows an object. ("..getItemName(itemMove[4][1])..")",1);
                            else
                                outputChatBox(e:getServerSyntax("Item","red").."You can't throw the object!",255,255,255,true);
                            end
                            itemMove = {};
                        else 
                            if inventoryElement ~= clickedElement then 
                                if inventoryElement == localPlayer then 
                                    local pPos = Vector3(getElementPosition(localPlayer));
                                    if getDistanceBetweenPoints3D(pPos.x,pPos.y,pPos.z,wx,wy,wz) < 3 then 
                                        if (itemMove[4][6] and itemMove[4][6][1] == 1) and not (getElementType(clickedElement) == "object" and getElementData(clickedElement,"trash.id") or -1 > 0) then 
                                            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You cannot put a Duty item in the trunk/safe!",255,255,255,true);
                                            itemMove = {};
                                            return;
                                        end
                                        if getElementType(clickedElement) == "object" then 
                                            if (getElementData(clickedElement,"trash.id") or -1) > 0 then --Kuka
                                                items[itemType][itemMove[5]] = nil;
                                                triggerServerEvent("item.deleteItem",localPlayer,localPlayer,itemMove[5],itemMove[4]);
                                                exports.fv_chat:createMessage(localPlayer, "threw out one ".. getItemName(itemMove[4][1]) .. ".",1);
                                                setElementData(localPlayer,"itemsTable",items);
                                                itemMove = {};
                                            end
                                            if (getElementData(clickedElement,"safe.id") or -1) > 0 then --Széf
                                                -- triggerServerEvent("item.moveItem",localPlayer,localPlayer,clickedElement,itemMove[5],itemMove[4]);
                                                local targetSlot = hasElementItemPlace(clickedElement,itemMove[4][1],itemMove[4][3]);
                                                if targetSlot then 
                                                    items[itemType][itemMove[5]] = nil;
                                                    setElementData(localPlayer,"itemsTable",items);
                                                    triggerServerEvent("item.moveItem",localPlayer,localPlayer,clickedElement,targetSlot,itemMove[4]);
                                                else 
                                                    outputChatBox(e:getServerSyntax("Item","red").."There is no space in the safe.",255,255,255,true);
                                                end
                                                itemMove = {};
                                            end
                                        elseif getElementType(clickedElement) == "vehicle" then
                                            if (getElementData(clickedElement,"veh:id") or -1) > 0 then 
                                                if getElementData(clickedElement,"veh:locked") or isVehicleLocked(clickedElement) then 
                                                    itemMove = {};
                                                    return outputChatBox(e:getServerSyntax("Item","red").."Trunk is locked!",255,255,255,true);
                                                end
                                                -- triggerServerEvent("item.moveItem",localPlayer,localPlayer,clickedElement,itemMove[5],itemMove[4]);
                                                local targetSlot = hasElementItemPlace(clickedElement,itemMove[4][1],itemMove[4][3]);
                                                if targetSlot then 
                                                    items[itemType][itemMove[5]] = nil;
                                                    setElementData(localPlayer,"itemsTable",items);
                                                    triggerServerEvent("item.moveItem",localPlayer,localPlayer,clickedElement,targetSlot,itemMove[4]);
                                                else 
                                                    outputChatBox("item.moveItem",localPlayer,localPlayer,clickedElement,targetSlot,itemMove[4]);
                                                end
                                            else 
                                                outputChatBox(e:getServerSyntax("Item","red").."This vehicle has no boot!",255,255,255,true);
                                                return;
                                            end
                                            itemMove = {};
                                        elseif getElementType(clickedElement) == "player" then 
                                            -- triggerServerEvent("item.moveItem",localPlayer,localPlayer,clickedElement,itemMove[5],itemMove[4]);
                                            local targetSlot = hasPlayerItemPlace(clickedElement,itemMove[4][1],itemMove[4][3]);
                                            if targetSlot then 
                                                items[itemType][itemMove[5]] = nil;
                                                setElementData(localPlayer,"itemsTable",items);
                                                triggerServerEvent("item.moveItem",localPlayer,localPlayer,clickedElement,targetSlot,itemMove[4]);
                                            else 
                                                outputChatBox(e:getServerSyntax("Item","red").."This vehicle has no boot!",255,255,255,true);
                                            end
                                            itemMove = {};
                                        end
                                    else
                                        itemMove = {};
                                    end
                                elseif (getElementType(inventoryElement) == "object" or getElementType(inventoryElement) == "vehicle") and clickedElement == localPlayer then 
                                    -- triggerServerEvent("item.moveItem",localPlayer,localPlayer,inventoryElement,itemMove[5],itemMove[4],true); --Kivétel
                                    local targetSlot = hasPlayerItemPlace(localPlayer,itemMove[4][1],itemMove[4][3]);
                                    if targetSlot then 
                                        items[1][itemMove[5]] = nil;
                                        setElementData(inventoryElement,"itemsTable",items[1]);
                                        triggerServerEvent("item.moveItem",localPlayer,localPlayer,inventoryElement,targetSlot,itemMove[4],true);
                                    else 
                                        outputChatBox(e:getServerSyntax("Item","red").."This item does not fit you!",255,255,255,true);
                                    end
                                    itemMove = {};
                                else 
                                    itemMove = {};
                                end
                            else 
                                itemMove = {};
                            end
                        end
                    else 
                        local stack = tonumber(dx:dxGetEditText("item.stack"));
                        if stack and stack ~= 0 and stack > 0 then 
                            if items[itemType][hoverSlot] then 
                                itemMove = {};
                                return;
                            else 
                                if (itemMove[4][6] and itemMove[4][6][1] == 1) then 
                                    outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Duty item cannot be stacked!",255,255,255,true);
                                    itemMove = {};
                                    return;
                                end

                                local temp = tableCopy(itemMove[4]);
                                items[itemType][hoverSlot] = nil;
                                temp[3] = itemMove[6];
                                temp[2] = (- 1);
                                items[itemType][hoverSlot] = temp;

                                temp = false;   
                                temp = tableCopy(itemMove[4]);
                                temp[3] = temp[3] - itemMove[6];
                                items[itemType][itemMove[5]] = nil;
                                items[itemType][itemMove[5]] = temp;
                                itemMoveTick = getTickCount();
                                triggerServerEvent("item.stackItems",localPlayer,inventoryElement,items[itemType][hoverSlot],hoverSlot,{itemMove[4],itemMove[6],itemMove[5]});
                                itemMove = {};
                            end
                        else 
                            -- slot = {itemID, itemDBID, darab, ertek, allapot, tabla };
                            if items[itemType][hoverSlot] and hoverSlot ~= itemMove[5] then --Van ott valami -> item felcserélés!
                                local temp = items[itemType][hoverSlot];
                                if temp[1] == itemMove[4][1] and isItemStackable(itemMove[4][1]) then 
                                    if (itemMove[4][6] and itemMove[4][6][1] == 1) or (items[itemType][hoverSlot][6] and items[itemType][hoverSlot][6][1] == 1) then 
                                        outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Duty item cannot be stacked!",255,255,255,true);
                                        itemMove = {};
                                        return;
                                    end

                                    items[itemType][hoverSlot][3] = items[itemType][hoverSlot][3] + itemMove[4][3];
                                    items[itemType][itemMove[5]] = nil;
                                    itemMoveTick = getTickCount();
                                    if getElementType(inventoryElement) == "player" then 
                                        setElementData(inventoryElement,"itemsTable",items);
                                    else 
                                        setElementData(inventoryElement,"itemsTable",items[1]);
                                    end
                                    triggerServerEvent("item.deleteItem",localPlayer,localPlayer,itemMove[5],itemMove[4]);
                                    -- triggerServerEvent("item.updateItemCount",localPlayer,inventoryElement,hoverSlot,items[itemType][hoverSlot],{itemMove[4],itemMove[5]});
                                    itemMove = {};
                                else
                                    if isActionbar(temp[2]) or (isHunger and isHunger == dbid) or ((getElementData(localPlayer,"weaponusing") or -1) == dbid) or ((getElementData(localPlayer,"ammousing") or -1) == dbid)  then
                                        itemMove = {};
                                        return;
                                    end
                                    items[itemType][hoverSlot] = nil;
                                    items[itemType][hoverSlot] = itemMove[4];
                                    items[itemType][itemMove[5]] = nil;
                                    items[itemType][itemMove[5]] = temp;
                                    itemMove = {};
                                    itemMoveTick = getTickCount();
                                    -- saveInventory();
                                end
                            else 
                                items[itemType][itemMove[5]] = nil;
                                items[itemType][hoverSlot] = false;
                                items[itemType][hoverSlot] = itemMove[4];
                                itemMove = {};
                                itemMoveTick = getTickCount();
                                -- saveInventory();
                            end
                        end
                    end
                else 
                    if actionbar[hoverActionSlot] then --Van ott valami -> item felcserélés!
                        actionbar[hoverActionSlot] = {};
                    end
                    actionbar[hoverActionSlot] = {itemMove[4][1], itemMove[4][2]};
                    triggerServerEvent("item.saveActionbar",localPlayer,localPlayer,actionbar);
                    itemMove = {};
                end
            end
        end
    end

    if button == "right" and state == "down" then --Item Használat
        local c = 0;
        local x,y = 0,invPos[2];
        for i = 1, slots do
            x = invPos[1] + (c * (itemSize + padding));
            c = c + 1;
            if items[itemType] and items[itemType][i] then 
                if not panelMove[1] and not itemMove[1] and inventoryElement == localPlayer then --ItemMozgatas
                    if e:isInSlot(x,y,itemSize,itemSize) then  
                        if itemMoveTick+500 < getTickCount() and not getKeyState("mouse1") then 
                            useItem(items[itemType][i],i);
                        end
                    end
                end
            end
            if c == 8 then 
                c = 0;
                y = y + (itemSize + padding);
            end
        end
    end
end
end);

function saveInventory()
    if getElementType(inventoryElement) == "player" then 
        setElementData(inventoryElement,"itemsTable",items);
    else 
        setElementData(inventoryElement,"itemsTable",items[1]);
    end
    triggerServerEvent("item.saveItems",inventoryElement,inventoryElement);
end

addEventHandler("onClientResourceStart",resourceRoot,function()
    for i=1,actionSlots do 
        bindKey(tostring(i),"down",function()
            if actionbar[i] and #actionbar[i] > 0 then 
                local item = findByDBID(actionbar[i][1],actionbar[i][2]);
                if item then 
                    local id, dbid, count, value, state, other = unpack(item);
                    local slot = getItemSlot(id,dbid);
                    useItem(item,slot);
                end
            end
        end);
    end
end);

function isCrafting()
    if craftLoading > 0 then 
        return true;
    else 
        return false;
    end
end

function getItemSlot(itemID,dbID)
    local temp = getElementData(localPlayer,"itemsTable");
    local found = -1;
    local itemType = getItemType(itemID);
    for slot,value in pairs(temp[itemType]) do 
        if dbID == value[2] then 
            found = slot;
            return;
        end
    end
    return found;
end

function hasItem(itemID,itemValue,itemCount)
    -- triggerServerEvent("item.getItems",localPlayer,localPlayer,localPlayer);
    local temp = getElementData(localPlayer,"itemsTable");
    if not itemCount then itemCount = 1 end;
    local itemType = getItemType(itemID);
    local found = false;
    if itemValue then 
        for slot,value in pairs(temp[itemType]) do 
            if itemID == value[1] then 
                if value[3] >= itemCount then 
                    if (itemValue == value[4]) then 
                        found = true;
                        break;
                    end
                end
            end
        end
    else 
        for slot,value in pairs(temp[itemType]) do 
            if itemID == value[1] then 
                if value[3] >= itemCount then 
                    found = true;
                    break;
                end
            end
        end
    end
    return found;
end

function takePlayerItem(itemID,count,dbID)
    if not count then count = 1 end;
    local items = getElementData(localPlayer,"itemsTable");
    local suc = false;
    local itemType = getItemType(itemID);
    for slot, value in pairs(items[itemType]) do 
        if (dbID and value[2] == dbID) or (not dbID and value[1] == itemID) then 
            if value[3] > count then 
                local new = items[itemType][slot][3] - count;
                items[itemType][slot][3] = new;
            else 
                triggerServerEvent("item.deleteItem",localPlayer,localPlayer,slot,items[itemType][slot]);
                items[itemType][slot] = nil;
            end
            suc = true;
            break;
        end
    end
    setElementData(localPlayer,"itemsTable",items);
    return suc;
end

--Inventory Position Save And Load--
function savePosition()
    if fileExists("invPos.xml") then 
        fileDelete("invPos.xml");
    end
    local file = xmlCreateFile("invPos.xml","socialgaming");
    local Xchild = xmlCreateChild(file,"x");
    xmlNodeSetValue(Xchild,tostring(invPos[1]));
    local Ychild = xmlCreateChild(file,"y");
    xmlNodeSetValue(Ychild,tostring(invPos[2]));
    xmlSaveFile(file);
    xmlUnloadFile(file);
end
addEventHandler("onResourceStop",resourceRoot,savePosition);

function loadPosition()
    if fileExists("invPos.xml") then 
        local file = xmlLoadFile("invPos.xml",true);
        local x = tonumber(xmlNodeGetValue(xmlFindChild(file,"x",0)));
        local y = tonumber(xmlNodeGetValue(xmlFindChild(file,"y",0)));
        if x and y then 
            invPos = {x,y};
        else 
            invPos = {sx-600,sy/2-250/2};
        end
        xmlUnloadFile(file);
    else 
        invPos = {sx-600,sy/2-250/2};
    end
end

addCommandHandler("resetinvpos",function(cmd)
    invPos = {sx-600,sy/2-250/2};
    outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."Inventory reset.",255,255,255,true);
end);
------------------------------------


--UTILS--
function coloredState(value)
    if value < 25 then 
        return e:getServerColor("red",true)..value;
    elseif value >= 25 and value < 75 then 
        return e:getServerColor("orange",true)..value;
    else 
        return e:getServerColor("servercolor",true)..value;
    end
end
function tooltip(text,text2,text3)
    local h = 25;
    local width = dxGetTextWidth(removeHex(text),1,e:getFont("rage",12));
    local allText = text;
    if text2 then 
        h = h + 25;
        width = math.max(width,dxGetTextWidth(removeHex(text2),1,e:getFont("rage",12)));
        allText = allText .. "\n" .. text2;
    end
    if text3 then 
        h = h + 25;
        width = math.max(width,dxGetTextWidth(removeHex(text3),1,e:getFont("rage",12)));
        allText = allText .. "\n" .. text3;
    end
    dxDrawRectangle(cursorX+10,cursorY+10,width+10,h,tocolor(0,0,0,180),true);
    shadowedText(allText,cursorX+10,cursorY+10,cursorX+20+width,cursorY+10+h,tocolor(255,255,255),1,e:getFont("rage",12),"center","center",true);
end
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY,postGUI)
	if not postGUI then postGUI = false end
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, postGUI,true)
end
function shadowedTextRotated(text,x,y,w,h,color,fontsize,font,aligX,alignY,postGUI)
	if not postGUI then postGUI = false end
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI,false,false,-90) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI,false,false,-90)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI,false,false,-90) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI,false,false,-90) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, postGUI,false,false,-90)
end












--[[

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

local music = playSound("http://relay.181.fm:8068",false,false);
if music then
    local bit = getSoundFFTData(music, 2048, 2)
    for i,v in ipairs(bit) do
        anim = math.round((v *250), 5) > 250 and 250 or math.round((v * 250), 5)
        dxDrawImage(sx/2-(anim/2), sy/2-(anim/2), itemSize+anim, item+anim, noItemImage, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
end


]]