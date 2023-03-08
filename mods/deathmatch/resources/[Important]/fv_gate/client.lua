--SocialGaming | Csoki
local sx,sy = guiGetScreenSize();
local e = false; --Engine export.
local clickTick = 0;
local pObject = false;
local pos = {};
local editing = false;
local tick = getTickCount();
local nearbyGate = false;

addEventHandler("onClientResourceStart",root,function(res)
    if getResourceName(res) == "fv_engine" or getThisResource(res) then 
        e = exports.fv_engine;
        sColor = {e:getServerColor("servercolor",false)};
        sColor2 = e:getServerColor("servercolor",true);
        red = {e:getServerColor("red",false)};

        font = e:getFont("rage",10);
        font2 = e:getFont("rage",11);
        font3 = e:getFont("rage",13);
        icons = e:getFont("AwesomeFont",24);
    end
end);

function render()
    dxDrawRectangle(10,sy-310,100,300,tocolor(0,0,0,100));
    dxDrawBorder(10,sy-310,100,300,3,tocolor(0,0,0));
    for k,v in pairs(ids) do 
        local color = tocolor(0,0,0,100);
        if e:isInSlot(15,sy-330+(k*25),90,20) then 
            color = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and clickTick+700 < getTickCount() then 
                if isElement(pObject) then 
                    setElementModel(pObject,v);
                    pos["model"] = getElementModel(pObject);
                else 
                    local x,y,z = getElementPosition(localPlayer);
                    local rx,ry,rz = getElementRotation(localPlayer);
                    local dim = getElementDimension(localPlayer);
                    local inter = getElementInterior(localPlayer);
                    
                    pObject = createObject(v,x,y,z,rx,ry,rz);
                    setElementCollisionsEnabled(pObject,false);

                    setElementDimension(pObject,dim);
                    setElementInterior(pObject,inter);
                    pos["dimension"] = dim;
                    pos["interior"] = inter;
                    pos["time"] = 4;
                    pos["model"] = getElementModel(pObject);
                end
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(15,sy-330+(k*25),90,20,color);
        dxDrawText(v,15,sy-330+(k*25),105,sy-330+(k*25)+20,tocolor(255,255,255),1,font,"center","center");
    end
end

function preRender(dt)
    if isElement(pObject) then 
        local alpha = interpolateBetween(145,0,0,200,0,0,(getTickCount()-tick)/1500,"CosineCurve");
        setElementAlpha(pObject,alpha);

        local x,y,z = getElementPosition(pObject);
        local rx,ry,rz = getElementRotation(pObject);

        local moveValue = 0.01;

        --Mozgatás--
        dxDrawRectangle(sx/2-130,sy-220,210,140,tocolor(0,0,0,100));
        dxDrawBorder(sx/2-130,sy-220,210,140,3,tocolor(0,0,0));
        e:shadowedText("Move",sx/2-130,sy-220,sx/2-130+210,140,tocolor(255,255,255),1,font2,"center");

        local upColor = tocolor(255,255,255);
        if e:isInSlot(sx/2-50,sy-200,50,50) then 
            upColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") then 
                setElementPosition(pObject,x,y + moveValue,z);
            end
        end
        e:shadowedText("",sx/2-50,sy-200,sx/2-50+50,sy-200+50,upColor,1,icons,"center","center");

        local downColor = tocolor(255,255,255);
        if e:isInSlot(sx/2-50,sy-140,50,50) then 
            downColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") then 
                setElementPosition(pObject,x,y - moveValue,z);
            end
        end
        e:shadowedText("",sx/2-50,sy-140,sx/2-50+50,sy-140+50,downColor,1,icons,"center","center");

        local leftColor = tocolor(255,255,255);
        if e:isInSlot(sx/2-120,sy-170,50,50) then 
            leftColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") then 
                setElementPosition(pObject,x - moveValue,y,z);
            end
        end
        e:shadowedText("",sx/2-120,sy-170,sx/2-120+50,sy-170+50,leftColor,1,icons,"center","center");

        local rightColor = tocolor(255,255,255);
        if e:isInSlot(sx/2+20,sy-170,50,50) then 
            rightColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") then 
                setElementPosition(pObject,x + moveValue,y,z);
            end
        end
        e:shadowedText("",sx/2+20,sy-170,sx/2+20+50,sy-170+50,rightColor,1,icons,"center","center");
        -----------------

        --Fel - Le--
        dxDrawRectangle(sx/2+90,sy-220,60,140,tocolor(0,0,0,100));
        dxDrawBorder(sx/2+90,sy-220,60,140,3,tocolor(0,0,0));
        e:shadowedText("Up/Down",sx/2+90,sy-220,sx/2+90+60,140,tocolor(255,255,255),1,font2,"center");
        local plusColor = tocolor(255,255,255);
        if e:isInSlot(sx/2+95,sy-200,50,50) then 
            plusColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") then 
                setElementPosition(pObject,x,y,z + moveValue);
            end
        end
        e:shadowedText("",sx/2+95,sy-200,sx/2+95+50,sy-200+50,plusColor,1,icons,"center","center");

        local minusColor = tocolor(255,255,255);
        if e:isInSlot(sx/2+95,sy-140,50,50) then 
            minusColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") then 
                setElementPosition(pObject,x,y,z - moveValue);
            end
        end
        e:shadowedText("",sx/2+95,sy-140,sx/2+95+50,sy-140+50,minusColor,1,icons,"center","center");
        -----------------
       
        --Forgatás--
        dxDrawRectangle(sx/2-130,sy-70,210,60,tocolor(0,0,0,100));
        dxDrawBorder(sx/2-130,sy-70,210,60,3,tocolor(0,0,0));

        local lrColor = tocolor(255,255,255);
        if e:isInSlot(sx/2-100,sy-65,50,50) then 
            lrColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") then 
                setElementRotation(pObject,rx,ry,rz + (moveValue*4));
            end
        end
        e:shadowedText("",sx/2-100,sy-65,sx/2-100+50,sy-65+50,lrColor,1,icons,"center","center");

        local rrColor = tocolor(255,255,255);
        if e:isInSlot(sx/2,sy-65,50,50) then 
            rrColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") then 
                setElementRotation(pObject,rx,ry,rz - (moveValue*4));
            end
        end
        e:shadowedText("",sx/2,sy-65,sx/2+50,sy-65+50,rrColor,1,icons,"center","center");


        dxDrawRectangle(sx/2+100,sy-70,150,60,tocolor(0,0,0,100));
        dxDrawBorder(sx/2+100,sy-70,150,60,3,tocolor(0,0,0));
        local urColor = tocolor(255,255,255);
        if e:isInSlot(sx/2+110,sy-66,50,50) then 
            urColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") then 
                setElementRotation(pObject,rx,ry - (moveValue*10),rz);
            end
        end
        dxDrawText("",sx/2+110,sy-66,sx/2+110+50,sy-66+50,urColor,1,icons,"center","center");

        local drColor = tocolor(255,255,255);
        if e:isInSlot(sx/2+180,sy-66,50,50) then 
            drColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") then 
                setElementRotation(pObject,rx,ry + (moveValue*10),rz);
            end
        end
        dxDrawText("",sx/2+180,sy-66,sx/2+180+50,sy-66+50,drColor,1,icons,"center","center")

        -----------------

        --Nyitási - Zárási Pozíció választása--
        local openColor = tocolor(sColor[1],sColor[2],sColor[3],130);
        if e:isInSlot(sx-210,sy-90,200,30) then 
            openColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and clickTick+700 < getTickCount() then 
                pos["open"] = {
                    x,y,z,rx,ry,rz
                };
                outputChatBox(e:getServerSyntax("Gate","servercolor").."You have successfully set the opening position.",255,255,255,true);
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx-210,sy-90,200,30,openColor);
        dxDrawBorder(sx-210,sy-90,200,30,3,tocolor(0,0,0,200));
        e:shadowedText("Opening Position",sx-210,sy-90,sx-210+200,sy-90+30,tocolor(255,255,255),1,font3,"center","center");


        local closeColor = tocolor(red[1],red[2],red[3],180);
        if e:isInSlot(sx-210,sy-50,200,30) then 
            closeColor = tocolor(red[1],red[2],red[3]);
            if getKeyState("mouse1") and clickTick+700 < getTickCount() then 
                pos["close"] = {
                    x,y,z,rx,ry,rz
                };
                outputChatBox(e:getServerSyntax("Gate","servercolor").."You have successfully set the closing position.",255,255,255,true);
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx-210,sy-50,200,30,closeColor);
        dxDrawBorder(sx-210,sy-50,200,30,3,tocolor(0,0,0,180));
        e:shadowedText("Closing Position",sx-210,sy-50,sx-210+200,sy-50+30,tocolor(255,255,255),1,font3,"center","center");
        -----------------
        

        --Mentés--
        local saveColor = tocolor(sColor[1],sColor[2],sColor[3],130);
        if e:isInSlot(sx-210,sy-130,200,30) then 
            saveColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and clickTick+700 < getTickCount() then 
                if not pos["open"] or not pos["close"] then 
                    outputChatBox(e:getServerSyntax("Gate","red").."You have not set the open / close position.",255,255,255,true);
                else 
                    triggerServerEvent("gate.create",localPlayer,localPlayer,pos);
                    closeGateCreate();
                end
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx-210,sy-130,200,30,saveColor);
        e:shadowedText("Rescue",sx-210,sy-130,sx-210+200,sy-130+30,tocolor(255,255,255),1,font3,"center","center");
        dxDrawBorder(sx-210,sy-130,200,30,3,tocolor(0,0,0));
        -----------------
    end
end

addCommandHandler("creategate",function()
    if getElementData(localPlayer,"admin >> level") > 10 then 
        if editing then 
            closeGateCreate();
        else 
            editing = true;
            removeEventHandler("onClientRender",root,render);
            addEventHandler("onClientRender",root,render);

            removeEventHandler("onClientPreRender",root,preRender);
            addEventHandler("onClientPreRender",root,preRender);

            if isElement(pObject) then 
                destroyElement(pObject);
            end
            pos = {};
            outputChatBox(e:getServerSyntax("Gate","servercolor").."Gate storage on!",255,255,255,true);
        end
    end
end);

function closeGateCreate()
    editing = false;
    if isElement(pObject) then 
        destroyElement(pObject);
    end
    pos = {};
    removeEventHandler("onClientRender",root,render);
    
    removeEventHandler("onClientPreRender",root,preRender);

    outputChatBox(e:getServerSyntax("Gate","red").."Gate storage off!",255,255,255,true);
end

function nearbyGateSet()
if getElementData(localPlayer,"admin >> level") > 6 then 
    nearbyGate = not nearbyGate;
    if nearbyGate then 
        removeEventHandler("onClientRender",root,renderNearbyGate);
        addEventHandler("onClientRender",root,renderNearbyGate);
        outputChatBox(e:getServerSyntax("Gate","servercolor").."Nearby gates on.",255,255,255,true);
    else 
        removeEventHandler("onClientRender",root,renderNearbyGate);
        outputChatBox(e:getServerSyntax("Gate","red").."Nearby gates off.",255,255,255,true);
    end
end
end
addCommandHandler("nearbygate",nearbyGateSet,false,false);
addCommandHandler("nearbygates",nearbyGateSet,false,false);


function renderNearbyGate()
    for k,v in pairs(getElementsByType("object",resourceRoot)) do 
        if isElement(v) and getElementData(v,"gate.id") then 
            local x,y = getScreenFromWorldPosition(getElementPosition(v));
            if x and y then 
                local id = tostring(getElementData(v,"gate.id"));
                e:shadowedText("ID: "..id,x,y,x,y,tocolor(255,255,255),1,font3,"center","center");
            end
        end
    end
end


--UTILS--
function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

