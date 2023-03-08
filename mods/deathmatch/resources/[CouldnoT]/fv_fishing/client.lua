e = exports.fv_engine;
sColor = {exports.fv_engine:getServerColor("servercolor",false)};
sColor2 = exports.fv_engine:getServerColor("servercolor",true);
red = {exports.fv_engine:getServerColor("red",false)};
red2 = exports.fv_engine:getServerColor("red",true);
local sx,sy = guiGetScreenSize();
local lines = {};
local fishPeds = {};
local peds = {
    {154.27487182617, -1943.3707275391, 3.7734375,355, 200, "Greg Houston"},
};
local hasItems = {};
local clickTick = 0;
local kapasTimer = false;
kapasSound = false;
local itemsCount = 0;

addEventHandler("onClientResourceStart",resourceRoot,function()
    for k,v in pairs(peds) do 
        local x,y,z,rot,skin,name = unpack(v);
        local ped = createPed(skin,x,y,z,rot);
        setElementData(ped,"ped >> name",name);
        setElementData(ped,"ped >> type","Fish Buyer");
        setElementFrozen(ped,true);
        setElementData(ped,"ped.noDamage",true);
        fishPeds[ped] = true;
    end
    setElementData(localPlayer,"fishing.line",false);
    setElementData(localPlayer,"fishing",false);
end);

addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
    local playerX, playerY, playerZ = getElementPosition(localPlayer);
    if state == "down" and clickedElement then 
        if fishPeds[clickedElement] then 
            if not panel then 
                if getDistanceBetweenPoints3D(wx,wy,wz,playerX,playerY,playerZ) > 200 then 
                    outputChatBox(e:getServerSyntax("Fishing","red").."You can't talk that far.",255,255,255,true);
                    return;
                end
                hasItems = {};
                for k,v in pairs(prices) do 
                    hasItems[v[1]] = 0;
                    local item, value = exports.fv_inventory:hasItem(v[1]);
                    if item then 
                        if hasItems[v[1]] then 
                            hasItems[v[1]] = hasItems[v[1]] + 1;
                        end
                    end
                end
                panel = clickedElement;
                removeEventHandler("onClientRender",root,drawFishPanel);
                addEventHandler("onClientRender",root,drawFishPanel);
            end
        end
    end

    if button == "left" and state == "down" then 
        if testLineAgainstWater(wx, wy, wz, wx, wy, wz+500) then
            local worldX, worldY, worldZ = getWorldFromScreenPosition( x, y, 20);
            if isLineOfSightClear(worldX,worldY,worldZ, worldX,worldY,worldZ+500)  then
                if isPedInVehicle(localPlayer) then return end;
                if not getElementData(localPlayer,"fishingRod") then 
                    outputChatBox(exports.fv_engine:getServerSyntax("Fishing","red").."You don't have a fishing rod in your hand.",255,255,255,true);
                    return;
                end
                if not getElementData(localPlayer,"fishing") then
                    if getDistanceBetweenPoints3D(wx, wy, wz,playerX,playerY,playerZ) > 200 then 
                        outputChatBox(e:getServerSyntax("Fishing","red").."You can't throw that far!",255,255,255,true);
                        return;
                    end
                    if exports.fv_inventory:isCrafting() then 
                        return outputChatBox(e:getServerSyntax("Fishing","red").."You can't fish while crafting!",255,255,255,true);
                    end
                    setElementData(localPlayer,"fishing",true);
                    setElementData(localPlayer,"fishing.line",{worldX,worldY,worldZ});
                    triggerServerEvent("fishing.waterClick",localPlayer,localPlayer,true,worldX,worldY,worldZ);
                    setElementFrozen(localPlayer,true);
                    if isTimer(kapasTimer) then 
                        killTimer(kapasTimer);
                    end
                    local time = 1000*math.random(20,60);
                    kapasTimer = setTimer(function()
                        setBalanceQTEState(true,5);
                        kapasSound = playSound("files/sound.mp3",true);
                    end,time,1);
                else 
                    triggerServerEvent("fishing.waterClick",localPlayer,localPlayer,false);
                    setElementFrozen(localPlayer,false);
                    setElementData(localPlayer,"fishing.line",false);
                    setElementData(localPlayer,"fishing",false);
                    if isTimer(kapasTimer) then 
                        killTimer(kapasTimer);
                    end
                    if isElement(kapasSound) then 
                        destroyElement(kapasSound);
                    end
                end
            end
        end
    end
end);


function drawFishPanel()
    local playerX,playerY,playerZ = getElementPosition(localPlayer);
    local pedX, pedY, pedZ = getElementPosition(panel);
    if getDistanceBetweenPoints3D(pedX, pedY, pedZ, playerX, playerY, playerZ) > 2 then 
        removeEventHandler("onClientRender",root,drawFishPanel);
        panel = false;
        hasItems = {};
    end

    dxDrawRectangle(sx/2-200,sy/2-100,400,200,tocolor(0,0,0,180));
    dxDrawRectangle(sx/2-200,sy/2-100,400,30,tocolor(0,0,0,180));
    dxDrawRectangle(sx/2-203,sy/2-100,3,200,tocolor(sColor[1],sColor[2],sColor[3],180));
    dxDrawText("TheDevils - Fish For Sale",0,sy/2-100,sx,0,tocolor(255,255,255),1,e:getFont("rage",15),"center","top");
    local buttonText = "You don't have a fish.";
    local buttonColor = {red[1],red[2],red[3],180};
    local counter = 0;
    itemsCount = 0;
    for itemID,count in pairs(hasItems) do 
        local _, price = foundInPrices(itemID);
        if price then 
            local van = sColor2.."From.";
            if count == 0 then 
                van = red2.."Nothing.";
            end

            dxDrawText(exports.fv_inventory:getItemName(itemID).." - "..van,0,sy/2-70+(counter*15),sx,0,tocolor(255,255,255),1,e:getFont("rage",10),"center","top",false,false,false,true);
            counter = counter + 1;
            if count ~= 0 then 
                itemsCount = itemsCount + 1;
            end
        end
    end
    if itemsCount > 0 then 
        buttonColor = {sColor[1],sColor[2],sColor[3],180};
        buttonText = "Fish for sale.";
    end
    if e:isInSlot(sx/2-150,sy/2+40,300,30) then 
        buttonColor[4] = 220;
    end

    dxDrawRectangle(sx/2-150,sy/2+40,300,30,tocolor(unpack(buttonColor)));
    e:shadowedText(buttonText,sx/2-150,sy/2+40,sx/2-150+300,sy/2+40+30,tocolor(255,255,255),1,e:getFont("rage",14),"center","center");

    dxDrawText("Walk away from the NPC to close",0,sy/2+80,sx,0,tocolor(255,255,255),1,e:getFont("rage",12),"center","top");
end

addEventHandler("onClientClick",root,function(button,state)
if panel then 
    if button == "left" and state == "down" then 
        if e:isInSlot(sx/2-150,sy/2+40,300,30) then 
            if (getElementData(localPlayer,"network") and getKeyState("mouse1") and clickTick+1000 < getTickCount()) then 
                if exports.fv_inventory:isInventoryOpen() then 
                    return outputChatBox(exports.fv_engine:getServerSyntax("Fishing","red").."You cannot cast with an open inventory!",255,255,255,true);
                end
                if itemsCount and itemsCount > 0 then 
                    triggerServerEvent("fishing.sell",localPlayer,localPlayer,hasItems);
                    removeEventHandler("onClientRender",root,drawFishPanel);
                    panel = false;
                    hasItems = {};
                    clickTick = getTickCount();
                    cancelEvent();
                    return;
                else
                    outputChatBox(exports.fv_engine:getServerSyntax("Fishing","red").."There is no passing that you can sell!",255,255,255,true);
                    clickTick = getTickCount();
                    cancelEvent();
                    return;
                end
            end
        end
    end
end
end);

addEventHandler("onClientResourceStart",resourceRoot,function()
    for k,v in pairs(getElementsByType("player",root,true)) do 
        if getElementData(v,"fishing.line") then 
            destroyLine(v);
            lines[v] = getElementData(v,"fishing.line");
        end
    end
end);

addEventHandler("onClientElementStreamIn",root,function()
    if getElementType(source) == "player" then 
        if getElementData(source,"fishing.line") then 
            destroyLine(source);
            lines[source] = getElementData(source,"fishing.line");
        end
    end
end);

addEventHandler("onClientElementStreamOut",root,function()
    if getElementType(source) == "player" then 
        destroyLine(source);
    end
end);

addEventHandler("onClientElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "player" and isElementStreamedIn(source) then 
        if dataName == "fishing.line" then 
            if newValue then
                destroyLine(source);
                lines[source] = newValue;
            else 
                destroyLine(source);
            end
        end
    end
end);

function destroyLine(player)
    if lines[player] then 
        lines[player] = nil;
    end
end

addEventHandler("onClientPreRender",root,function()
    for player,value in pairs(lines) do 
        if not player then 
            lines[player] = nil;  
        else     
            local rod = (getElementData(player,"fishingRod") or false);
            if rod then 
                local endX,endY,endZ = unpack(value);
                local pos1 = Vector3(getPositionFromElementOffset(rod, 0.03, 0, 0));
                local pos2 = Vector3(getPositionFromElementOffset(rod, 0.045, 0, -1.3));
                dxDrawLine3D(pos1.x,pos1.y,pos1.z, pos2.x,pos2.y,pos2.z, tocolor(200,200,200,150), 0.5, false);
                dxDrawLine3D(pos2.x,pos2.y,pos2.z,endX,endY,endZ,tocolor(200,200,200,150),0.8);
            else 
                lines[player] = nil;
            end
        end
    end
end);


--UTILS--
function getPositionFromElementOffset(element,offX,offY,offZ)
	if element and isElement(element) then 
        local m = getElementMatrix(element)
        if m and element then 
            local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
            local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
            local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
            return x, y, z
        end
	end
end