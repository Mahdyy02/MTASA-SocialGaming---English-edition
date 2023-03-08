
e = exports.fv_engine;
local sx,sy = guiGetScreenSize();
local zoom = math.min(1,sx / 1980);
local plantElement = false;
local selectedItem = 1;
local clickTick = 0;
local progressBar = {
    value = 0;
};

--- Network cucc + progress közbe semmi klikk ;)
_getKeyState = getKeyState;
getKeyState = function(key)
    if getElementData(localPlayer,"network") and progressBar.value == 0 then 
        return _getKeyState(key);
    end
end
addEventHandler("onClientKey",root,function(button,state)
    if plantElement then 
        if not getKeyState(button) then 
            cancelEvent();
        end
    end
end);
---

addEventHandler("onClientResourceStart",root,function(res)
    if getThisResource() == res or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        sColor = {exports.fv_engine:getServerColor("servercolor",false)};
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
        blue = {exports.fv_engine:getServerColor("blue",false)};
        red = {exports.fv_engine:getServerColor("red",false)};
        font = e:getFont("rage",13);
        smallFont = e:getFont("rage",10);
    end

    if res == getThisResource() then 
        setElementData(localPlayer,"waterCan",false);

        engineImportTXD(engineLoadTXD("models/kokacserje.txd"), 857);
        engineReplaceModel(engineLoadDFF("models/kokacserje.dff"), 857);

        engineImportTXD(engineLoadTXD("models/mak.txd"), 858);
        engineReplaceModel(engineLoadDFF("models/mak.dff"), 858);

        engineImportTXD(engineLoadTXD("models/marihuana.txd"), 859);
        engineReplaceModel(engineLoadDFF("models/marihuana.dff"), 859);

        engineReplaceModel(engineLoadDFF("models/cserep.dff"), 2203);

        engineImportTXD(engineLoadTXD("models/kanna.txd"), 977);
        engineReplaceModel(engineLoadDFF("models/kanna.dff"), 977);
    end
end);

addEventHandler("onClientClick",root,function(button,state,clickX,clickY,wx,wy,wz,clickedElement)
    if clickedElement and (getElementData(clickedElement,"plant.id") or -1) > 0 then 
        if button == "right" and state == "down" then
            if not plantElement then 
                local playerX, playerY, playerZ = getElementPosition(localPlayer);
                if getDistanceBetweenPoints3D(playerX, playerY, playerZ, wx,wy,wz) < 2 then
                    if getElementData(clickedElement,"plant.used") and isElement(getElementData(clickedElement,"plant.used")) then 
                        return outputChatBox(e:getServerSyntax("Plant","red").."Someone is just using the pot.",255,255,255,true);
                    end
                    exports.fv_dx:addElementEdge(clickedElement,{sColor[1],sColor[2],sColor[3]});
                    plantElement = clickedElement;
                    removeEventHandler("onClientRender",root,plantRender);
                    addEventHandler("onClientRender",root,plantRender);
                    setElementData(clickedElement,"plant.used",localPlayer);
                    progressBar.value = 0;
                end
            end
        end
    end
end);

function closePlant()
    exports.fv_dx:destroyElementEdge(plantElement);
    setElementData(plantElement,"plant.used",false);
    plantElement = false;
    selectedItem = 1;
    removeEventHandler("onClientRender",root,plantRender);
end

function plantRender()
    local playerX,playerY,playerZ = getElementPosition(localPlayer);
    local plantX,plantY,plantZ = getElementPosition(plantElement);
    if getDistanceBetweenPoints3D(playerX, playerY, playerZ, plantX, plantY, plantZ) > 2 then 
        return closePlant();
    end

    local x,y = getScreenFromWorldPosition(plantX,plantY,plantZ + 0.8);
    if x and y then
        local plantType = getElementData(plantElement,"plant.type") or -1;
        if plantType > 0 then --Van bele ültetve.
            local plantIncrease = getElementData(plantElement,"plant.increase") or 50;
            local plantWater = getElementData(plantElement,"plant.water") or 50;

            dxDrawRectangle(x - 125,y - 50,250,180,tocolor(0,0,0,150));
            dxDrawRectangle(x - 125,y - 50,250,20,tocolor(0,0,0,150));
            dxDrawRectangle(x - 127,y - 50,3,180,tocolor(sColor[1],sColor[2],sColor[3],150));
            e:shadowedText(types[plantType][2] .. "cserje",x - 122, y - 50, x, y,tocolor(200,200,200),1,font,"left","top");

            local closeColor = tocolor(200,200,200,200);
            if e:isInSlot(x + 105,y - 50,20,20) then 
                closeColor = tocolor(red[1],red[2],red[3],180);
                if getKeyState("mouse1") and clickTick+1000 < getTickCount() then 
                    closePlant();
                    clickTick = getTickCount();
                end
            end
            dxDrawText("",x + 105,y - 50,x + 105+20,y - 50 + 23,closeColor,1,e:getFont("AwesomeFont",12),"center","center");


            dxDrawRectangle(x - 100,y - 20,200,20,tocolor(80,80,80,150));
            dxDrawRectangle(x - 100,y - 20,plantIncrease * 2,20,tocolor(unpack(coloredValue(plantIncrease))));
            e:shadowedText("Growth: " .. plantIncrease .. "%",x,y - 20,x,y - 20 + 20,tocolor(255,255,255),1,smallFont,"center","center");

            dxDrawRectangle(x - 100,y + 10,200,20,tocolor(80,80,80,150));
            dxDrawRectangle(x - 100,y + 10,plantWater*2,20,tocolor(blue[1], blue[2], blue[3],200));
            e:shadowedText("Moisture: ".. plantWater .. "%",x,y + 10,x,y + 30,tocolor(255,255,255),1,smallFont,"center","center");

            local waterButton = {red[1],red[2],red[3],180};
            if plantWater < 100 then 
                waterButton = {sColor[1],sColor[2],sColor[3],180};
            end
            if e:isInSlot(x - 100,y + 40,200,20) then 
                waterButton[4] = 220;
                if getKeyState("mouse1") and clickTick+2000 < getTickCount() then 
                    if plantWater == 100 then 
                        outputChatBox(e:getServerSyntax("Plant","red").."The plant does not need watering.",255,255,255,true);
                        clickTick = getTickCount();
                    else
                        if exports.fv_inventory:hasItem(115) and getElementData(localPlayer,"waterCan") then 
                            setElementData(localPlayer,"setPlayerAnimation",{"SWORD", "sword_IDLE"});
                            progressBar.text = "Irrigation...";
                            progressBar.value = 0;
                            progressBar.endFunction = waterPlant;
                            removeEventHandler("onClientPreRender",root,progressBar.render);
                            addEventHandler("onClientPreRender",root,progressBar.render);
                        else 
                            outputChatBox(e:getServerSyntax("Plant","red").."You don't have a jug.",255,255,255,true);
                        end
                        clickTick = getTickCount();
                    end
                end
            end
            dxDrawRectangle(x - 100,y + 40,200,20,tocolor(waterButton[1], waterButton[2], waterButton[3], waterButton[4]));
            e:shadowedText("Irrigation",x - 100,y + 40,x - 100+200,y + 40+20,tocolor(255,255,255),1,smallFont,"center","center");

            local harvestButton = {red[1],red[2],red[3],180};
            if plantIncrease == 100 then 
                harvestButton = {sColor[1],sColor[2],sColor[3],180};
            end
            if e:isInSlot(x - 100,y + 70,200,20) then 
                harvestButton[4] = 220;
                if getKeyState("mouse1") and clickTick+2000 < getTickCount() then 
                    if plantIncrease == 100 then 
                        setElementData(localPlayer,"setPlayerAnimation",{"bomber","bom_plant"});
                        progressBar.text = "harvesting...";
                        progressBar.value = 0;
                        progressBar.endFunction = harvestPlant;
                        removeEventHandler("onClientPreRender",root,progressBar.render);
                        addEventHandler("onClientPreRender",root,progressBar.render);
                    else 
                        outputChatBox(e:getServerSyntax("Plant","red").."Plant has not grown yet!",255,255,255,true);
                    end
                    clickTick = getTickCount();
                end
            end
            dxDrawRectangle(x - 100,y + 70,200,20,tocolor(unpack(harvestButton)));
            e:shadowedText("harvesting",x - 100,y + 70,x - 100 + 200,y + 70 + 20,tocolor(255,255,255),1,smallFont,"center","center");

            local pickUpColor = tocolor(red[1],red[2],red[3],180);
            if e:isInSlot(x - 100,y + 100,200,20) then 
                pickUpColor = tocolor(red[1],red[2],red[3],220);
                if getKeyState("mouse1") and clickTick+2000 < getTickCount() then 
                    triggerServerEvent("plant.pickUP",localPlayer,localPlayer,plantElement);
                    closePlant();
                    clickTick = getTickCount();
                end
            end
            dxDrawRectangle(x - 100,y + 100,200,20,pickUpColor);
            e:shadowedText("Adding tiles",x - 100,y + 100,x - 100+200,y + 100+20,tocolor(255,255,255),1,smallFont,"center","center");

        else --Üres cserép
            dxDrawRectangle(x - 125,y - 50,250,100,tocolor(0,0,0,150));
            dxDrawRectangle(x - 125,y - 50,250,20,tocolor(0,0,0,150));
            dxDrawRectangle(x - 127,y - 50,3,100,tocolor(sColor[1],sColor[2],sColor[3],150));
            e:shadowedText(types[plantType][2],x - 122, y - 50, x, y,tocolor(200,200,200),1,font,"left","top");

            local closeColor = tocolor(200,200,200,200);
            if e:isInSlot(x + 105,y - 50,20,20) then 
                closeColor = tocolor(red[1],red[2],red[3],180);
                if getKeyState("mouse1") and clickTick+1000 < getTickCount() then 
                    closePlant();
                    clickTick = getTickCount();
                end
            end
            dxDrawText("",x + 105,y - 50,x + 105+20,y - 50 + 23,closeColor,1,e:getFont("AwesomeFont",12),"center","center");

            local upColor = {red[1],red[2],red[3],180};
            if e:isInSlot(x - 100,y - 20,200,20) then 
                upColor[4] = 220;
                if getKeyState("mouse1") and clickTick+1000 < getTickCount() then 
                    triggerServerEvent("plant.pickUP",localPlayer,localPlayer,plantElement);
                    closePlant();
                    clickTick = getTickCount();
                end
            end
            dxDrawRectangle(x - 100,y - 20,200,20,tocolor(unpack(upColor)));
            e:shadowedText("Adding tiles",x - 100,y - 20,x - 100+200,y - 20+20,tocolor(255,255,255),1,smallFont,"center","center");


            local isItem = exports.fv_inventory:hasItem(types[selectedItem][3]);
            local plantColor = isItem and {sColor[1],sColor[2],sColor[3],180} or {red[1],red[2],red[3],180};
            if e:isInSlot(x - 75,y + 10,150,20) then 
                plantColor[4] = 220;
                tooltip("Planting");
                if getKeyState("mouse1") and clickTick+1000 < getTickCount() then 
                    if isItem then 
                        setElementData(localPlayer,"setPlayerAnimation",{"bomber","bom_plant"});
                        progressBar.text = "Planting...";
                        progressBar.value = 0;
                        progressBar.endFunction = plantItem;
                        removeEventHandler("onClientPreRender",root,progressBar.render);
                        addEventHandler("onClientPreRender",root,progressBar.render);
                    else 
                        outputChatBox(e:getServerSyntax("Plant","red").."You don't have the core you need.",255,255,255,true);
                    end
                    clickTick = getTickCount();
                end
            end
            dxDrawRectangle(x - 75,y + 10,150,20,tocolor(unpack(plantColor)));
            e:shadowedText(types[selectedItem][2] .. " core",x - 75,y + 10,x - 75 + 150,y + 10 + 20,tocolor(255,255,255),1,smallFont,"center","center");

            local leftColor = tocolor(200,200,200,200);
            if e:isInSlot(x - 100,y + 10,20,20) then 
                leftColor = tocolor(sColor[1],sColor[2],sColor[3],200);
                if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                    selectedItem = (selectedItem-1 < 1) and #types or selectedItem - 1;
                    clickTick = getTickCount();
                end
            end
            dxDrawText("",x - 100,y + 10,x - 100 + 20,y + 10 + 20,leftColor,1,e:getFont("AwesomeFont",14),"center","center");

            local rightColor = tocolor(200,200,200,200);
            if e:isInSlot(x + 80,y + 10,20,20) then 
                rightColor = tocolor(sColor[1],sColor[2],sColor[3],200);
                if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                    selectedItem = (selectedItem+1 > #types) and 1 or selectedItem + 1;
                    clickTick = getTickCount();
                end
            end
            dxDrawText("",x + 80,y + 10,x + 80 + 20,y + 10 + 20,rightColor,1,e:getFont("AwesomeFont",14),"center","center");

        end
    end
end

function progressBar.render(dt)
    if getElementData(localPlayer,"network") then 
        progressBar.value = progressBar.value + 0.01 * dt;
        if progressBar.value >= 100 then 
            progressBar.value = 100;
            progressBar.endFunction();
            progressBar.text = "";
            progressBar.value = 0;
            removeEventHandler("onClientPreRender",root,progressBar.render);
        end

        local w,h = 300 * zoom, 40 * zoom;
        local x,y = sx / 2 - w / 2, sy - 200 * zoom;
        dxDrawRectangle(x - 5 * zoom,y - 5 * zoom,w + 10 * zoom,h + 10 * zoom,tocolor(0,0,0,180));
        dxDrawRectangle(x,y,(progressBar.value * 3) * zoom,h,tocolor(sColor[1],sColor[2],sColor[3],180));
        e:shadowedText(progressBar.text,x - 5 * zoom,y - 5 * zoom,x - 5 * zoom + w + 10 * zoom,y - 5 * zoom + h + 10 * zoom,tocolor(255,255,255),1,e:getFont("rage",16),"center","center");
    end
end

function plantItem()
    triggerServerEvent("plant.plantItem",localPlayer,localPlayer,types[selectedItem],plantElement,selectedItem);
end

function harvestPlant()
    triggerServerEvent("plant.harvest",localPlayer,localPlayer,plantElement);
    closePlant();
end

function waterPlant()
    triggerServerEvent("plant.giveWater",localPlayer,localPlayer,plantElement);
end

--Utils
function coloredValue(value)
    if value <= 25 then 
        return {e:getServerColor("red",false)};
    elseif value > 25 and value <= 70 then 
        return {e:getServerColor("orange",false)};
    elseif value > 70 then 
        return {e:getServerColor("servercolor",false)};
    end
end
function tooltip(text)
    local font = e:getFont("rage",15 * zoom);
    local width = dxGetTextWidth(text,1,font,false) + (20 * zoom);
    local height = 23 * zoom;
    local x,y = getCursorPosition();
    x,y = x * sx, y * sy;
    x, y = x + (10 * zoom), y + (10 * zoom);
    dxDrawRectangle(x,y,width,height,tocolor(100,100,100,250),true);
    dxDrawText(text,x,y,x + width,y + height,tocolor(255,255,255),1,font,"center","center",false,false,true);
end
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY,postGUI)
	if not postGUI then postGUI = false end
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, postGUI,true)
end
----

--Parancsok
local nearbyShow = false;
function nearbyPlants(cmd)
    if getElementData(localPlayer,"admin >> level") > 10 then 
        nearbyShow = not nearbyShow;
        if nearbyShow then 
            removeEventHandler("onClientRender",root,nearbyRender);
            addEventHandler("onClientRender",root,nearbyRender);
        else
            removeEventHandler("onClientRender",root,nearbyRender);
        end
    end
end
addCommandHandler("nearbyplants",nearbyPlants,false,false);

function nearbyRender()
    for _,object in pairs(getElementsByType("object",resourceRoot)) do 
        if getElementModel(object) == 2203 then 
            local ID = getElementData(object,"plant.id") or -1;
            if ID then 
                local x,y = getScreenFromWorldPosition(getElementPosition(object));
                if x and y then 
                    dxDrawText("ID: "..sColor2..ID,x,y,x,y,tocolor(255,255,255),1,e:getFont("rage",13),"center","center",false,false,false,true);
                end
            end
        end
    end
end



--core NPC--
if exports.fv_dx:dxGetEdit("drougNPC") then 
    exports.fv_dx:dxDestroyEdit("drougNPC");
end

local minigame = {
    npc = false;
    cache = {
        true,
        0,
        getTickCount(),
        -1,
    };
    r = -1,
    g = -1,
    b = -1;
};

addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
    if state == "down" then 
        if clickedElement and getElementData(clickedElement,"drougPed") then 
            if minigame.cache[1] then 
                local usedPlayers = getElementData(clickedElement,"droug.used") or {};
                if usedPlayers[localPlayer] then 
                    return outputChatBox(e:getServerSyntax("Drug","red").."You already dealed with him, please try again later.",255,255,255,true);
                end
                if exports.fv_dx:dxGetEdit("drougNPC") then 
                    exports.fv_dx:dxDestroyEdit("drougNPC");
                end
                minigame.cache[1] = false;
                minigame.cache[2] = 0;
                minigame.cache[3] = getTickCount();
                minigame.cache[4] = -1;
                minigame.npc = clickedElement;
                exports.fv_dx:addElementEdge(clickedElement,{red[1],red[2],red[3]});
                removeEventHandler("onClientRender",root,minigameRender);
                addEventHandler("onClientRender",root,minigameRender);
                usedPlayers[localPlayer] = true;
                setElementData(clickedElement,"droug.used",usedPlayers);
            end
        end
    end
end);

function minigameRender()
    if minigame.npc then 
        local playerX,playerY,playerZ = getElementPosition(localPlayer);
        local tX,tY,tZ = getElementPosition(minigame.npc);
        if getDistanceBetweenPoints3D(playerX,playerY,playerZ,tX,tY,tZ) > 2 then 
            outputChatBox(e:getServerSyntax("Drug","red").."You walked away from the NPC, the conversation was interrupted.",255,255,255,true);
            minigameClose();
            return;
        end
    else 
        minigameClose();
    end

    local state, value, tick = unpack(minigame.cache);
    local progress = (getTickCount()-tick)/700;
    if minigame.cache[4] < 0 then 
        minigame.cache[2] = interpolateBetween(0,0,0,100,0,0,progress,"CosineCurve");
        minigame.r, minigame.g, minigame.b = interpolateBetween(red[1],red[2],red[3],sColor[1],sColor[2],sColor[3],progress,"CosineCurve");
    end
    dxDrawRectangle(sx/2-155,sy-200,310,40,tocolor(0,0,0,180));
    dxDrawRectangle(sx/2-150,sy-195,minigame.cache[2]*3,30,tocolor(minigame.r, minigame.g, minigame.b,180));

    e:shadowedText("10.000 dt",sx/2-155,sy-225,310,40,tocolor(255,255,255),1,e:getFont("rage",15),"left","top");
    e:shadowedText("1.000 dt",sx/2-155,sy-225,sx/2-155+310,40,tocolor(255,255,255),1,e:getFont("rage",15),"right","top");

    if minigame.cache[4] > 0 then 
        shadowedText("Price recommended by Big Smoke: "..sColor2..formatMoney(minigame.cache[4])..white.."dt",sx/2-155,sy-200,sx/2-155+310,sy-200+40,tocolor(255,255,255),1,e:getFont("rage",12),"center","center");
    end
end

addEventHandler("onClientKey",root,function(button,state)
    if getElementData(localPlayer,"network") then
        if button == "space" and state then 
            if not minigame.cache[1] and minigame.npc then 
                local x = 100-minigame.cache[2];
                if x < 10 then 
                    x = 10;
                end
                minigame.cache[4] = math.floor(10000/100*x);
                setTimer(function()
                    removeEventHandler("onClientRender",root,minigameRender);
                    removeEventHandler("onClientRender",root,minigameshopRender);
                    addEventHandler("onClientRender",root,minigameshopRender);
                    exports.fv_dx:dxCreateEdit("drougNPC","1","1",sx/2-25*zoom,sy/2+60*zoom,50*zoom,30*zoom,3,2);
                end,2000,1);
                cancelEvent(); --Ne ugorjon a geci
            end
        end
    end
end);

function minigameshopRender()
    if minigame.npc then 
        local playerX,playerY,playerZ = getElementPosition(localPlayer);
        local tX,tY,tZ = getElementPosition(minigame.npc);
        if getDistanceBetweenPoints3D(playerX,playerY,playerZ,tX,tY,tZ) > 2 then 
            outputChatBox(e:getServerSyntax("Drug","red").."You walked away from the NPC, the conversation was interrupted.",255,255,255,true);
            minigameClose();
            return;
        end
    else 
        minigameClose();
    end


    local editText = exports.fv_dx:dxGetEditText("drougNPC");

    local w,h = 320*zoom, 240*zoom;
    local x,y = sx/2 - w/2, sy/2 - h/2;
    dxDrawRectangle(x,y,w,h,tocolor(0,0,0,100));
    dxDrawRectangle(x-3*zoom,y,3*zoom,h,tocolor(sColor[1],sColor[2],sColor[3],180));
    dxDrawText("Price recommended by Big Smoke:\n"..sColor2..formatMoney(minigame.cache[4])..white.."dt/db",x,y,x+w,h,tocolor(255,255,255),1,e:getFont("rage",15*zoom),"center","top",false,false,false,true);
    local textY = y + 15*zoom
    local allCost = tonumber(editText) * minigame.cache[4];
    for key, value in pairs(types) do 
        if key > 0 then 
            local padding = key * (40*zoom);
            dxDrawText(value[2].." core",x+10*zoom,textY+padding,w,h,tocolor(200,200,200,200),1,e:getFont("rage",15*zoom));
            local buttonColor = tocolor(sColor[1],sColor[2],sColor[3],180);
            if e:isInSlot(x+w-125*zoom,textY+padding,120*zoom,30*zoom) then 
                buttonColor = tocolor(sColor[1],sColor[2],sColor[3],220);
                if getKeyState("mouse1") and clickTick+1000 < getTickCount() then 
                    if getElementData(localPlayer,"char >> money") > allCost then 
                        triggerServerEvent("droug.BUY",localPlayer,localPlayer,tonumber(editText),allCost,key);
                    else 
                        exports.fv_infobox:addNotification("warning","core",255,255,255,true);
                    end
                    clickTick = getTickCount();
                end
            end
            dxDrawRectangle(x+w-125*zoom,textY+padding,120*zoom,30*zoom,buttonColor);
            shadowedText("Buying",x+w-125*zoom,textY+padding,x+w-125*zoom+120*zoom,textY+padding+30*zoom,tocolor(255,255,255),1,e:getFont("rage",15*zoom),"center","center");
        end
    end
    dxDrawText("Quantity: ",x+10*zoom,sy/2+60*zoom,w,h,tocolor(200,200,200,200),1,e:getFont("rage",15*zoom));
    dxDrawText("Price Total: "..sColor2..formatMoney(allCost)..white.."dt",x+10*zoom,y,w,y+h,tocolor(200,200,200,200),1,e:getFont("rage",15*zoom),"left","bottom",false,false,false,true);
    shadowedText("Walk away from the NPC to close.",x,y,x+w,y+h+25*zoom,tocolor(255,255,255),1,e:getFont("rage",15*zoom),"center","bottom",false,false,false,true);
end

minigameClose = function()
    removeEventHandler("onClientRender",root,minigameRender);
    removeEventHandler("onClientRender",root,minigameshopRender);
    exports.fv_dx:destroyElementEdge(minigame.npc);
    minigame.cache[4] = -1;
    minigame.cache[2] = 0;
    minigame.cache[1] = true;
    minigame.npc = false;
    if exports.fv_dx:dxGetEdit("drougNPC") then 
        exports.fv_dx:dxDestroyEdit("drougNPC");
    end
end
addEvent("droug.CLOSE",true);
addEventHandler("droug.CLOSE",localPlayer,minigameClose);
