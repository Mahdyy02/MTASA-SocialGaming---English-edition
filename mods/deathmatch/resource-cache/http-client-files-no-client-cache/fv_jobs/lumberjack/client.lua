local currentWood = false;
local woodHit = 0;

local lumberVehMarker = {};
local lumberMarkerTick = 0;

local lumberEtick = 0;

local lumberDownMarker = {};

addEventHandler("onClientResourceStart",resourceRoot,function()
    if getElementData(localPlayer,"char >> job") == 5 then 
        startLumberJack();
    else 
        stopLumberJack();
    end
    setElementData(localPlayer,"lumberjack.handWood",false);
end);
addEventHandler("onClientElementDataChange",localPlayer,function(dataName,oldValue,newValue)
    if dataName == "char >> job" then 
        if newValue == 5 then 
            startLumberJack();
        else 
            stopLumberJack();
        end
    end
end);

function startLumberJack()
    local green = {exports.fv_engine:getServerColor("servercolor",false)};
    lumberVehMarker[1] = createMarker(-1167.5108642578, -1137.0316162109, 129.21875,"checkpoint",2,green[1],green[2],green[3],100);
    lumberVehMarker[2] = createBlip(-1167.5108642578, -1137.0316162109, 129.21875,3);
    setElementData(lumberVehMarker[2],"blip >> name","Munkahely");
    setElementData(lumberVehMarker[2],"blip >> maxVisible",true);
    addEventHandler("onClientMarkerHit",lumberVehMarker[1],function(hitElement)
        if hitElement == localPlayer then 
            local veh = getPedOccupiedVehicle(localPlayer);
            if lumberMarkerTick+(1000*60) > getTickCount() then outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","red").."You can only use it every 1 minute!",255,255,255,true) return end;
            if veh then 
                if veh == getElementData(localPlayer,"job.veh") then 
                    triggerServerEvent("lumberjack.removeVeh",localPlayer,localPlayer);
                    lumberMarkerTick = getTickCount();
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","red").."Ez nem a munkajárműved!",255,255,255,true);
                    return;
                end
            else 
                if getElementData(localPlayer,"job.veh") then outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","red").."You already have a work vehicle!",255,255,255,true) return end;
                triggerServerEvent("lumberjack.giveVeh",localPlayer,localPlayer);
                lumberMarkerTick = getTickCount();
            end
        end
    end);

    local red = {exports.fv_engine:getServerColor("red",false)};
    lumberDownMarker[1] = createMarker(-551.31140136719, -189.1950378418, 78.40625,"checkpoint",2,red[1],red[2],red[3],100);
    lumberDownMarker[2] = createBlip(-551.31140136719, -189.1950378418, 78.40625,1);
    setElementData(lumberDownMarker[2],"blip >> color",red);
    setElementData(lumberDownMarker[2],"blip >> name","Fa leadó");
    setElementData(lumberDownMarker[2],"blip >> maxVisible",true);

    addEventHandler("onClientMarkerHit",lumberDownMarker[1],function(hitElement)
        if hitElement == localPlayer then 
            local veh = getPedOccupiedVehicle(localPlayer);
            if veh and veh == getElementData(localPlayer,"job.veh") then 
                local woods = getElementData(veh,"lumberjack.wood");
                if woods > 0 then 
                    if not getElementData(localPlayer,"network") then return end;
                    triggerServerEvent("lumberjack.downWood",localPlayer,localPlayer,veh);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","red").."There is no tree in the car!",255,255,255,true);
                    return;
                end
            end
        end
    end);   
end

function stopLumberJack()
    for k,v in pairs(lumberVehMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    lumberVehMarker = {};

    for k,v in pairs(lumberDownMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    lumberDownMarker = {};
end

addEventHandler("onClientColShapeHit", root, function(element)
    if getElementType(element) == "player" and element == localPlayer and getElementData(localPlayer,"char >> job") == 5 then 
        if source then 
            local obj = getElementData(source,"lumberjack.obj");
            if obj and isElement(obj) then 
                currentWood = obj;
                removeEventHandler("onClientRender",root,drawWoodStats);
                addEventHandler("onClientRender",root,drawWoodStats);
            end
        end
    end
end);

addEventHandler("onClientColShapeLeave", root, function(element)
    if getElementType(element) == "player" and element == localPlayer and getElementData(localPlayer,"char >> job") == 5 then 
        local obj = getElementData(source,"lumberjack.obj");
        if obj and isElement(obj) then 
            currentWood = false;
            removeEventHandler("onClientRender",root,drawWoodStats);
        end
    end
end);


function drawWoodStats()
if not currentWood then return end;
    local ox,oy,oz = getElementPosition(currentWood);
    local x,y = getScreenFromWorldPosition(ox,oy,oz+2);
    if x and y then 
        dxDrawRectangle(x-155,y-25,310,50,tocolor(0,0,0,180));
        local r,g,b = exports.fv_engine:getServerColor("servercolor",false);
        dxDrawRectangle(x-150,y-20,getElementData(currentWood,"lumberjack.hp")*3,40,tocolor(r,g,b,180));
    end
end
addEventHandler("onClientRender",root,drawWoodStats);

addEventHandler("onClientKey",root,function(button,state)
if getElementData(localPlayer,"char >> job") == 5 and not isPedInVehicle(localPlayer) then
    if button == "mouse1" and state then 
        if currentWood then 
            local target = getPedTarget(localPlayer);
            if target == currentWood then 
                if getKeyState("mouse1") and woodHit+1000 < getTickCount() and not isCursorShowing() and getPedWeapon(localPlayer) == 10 and getElementData(localPlayer,"network") then 
                    setElementData(currentWood,"lumberjack.hp",getElementData(currentWood,"lumberjack.hp")-math.random(8,15));
                    if getElementData(currentWood,"lumberjack.hp") < 0 then 
                        setElementData(currentWood,"lumberjack.hp",0);
                        triggerServerEvent("lumberjack.kickWood",localPlayer,localPlayer,currentWood);
                        setControl(false);
                        currentWood = false;
                        removeEventHandler("onClientRender",root,drawWoodStats);
                    end
                    woodHit = getTickCount();
                end
            end
        end
    end
end
end);

addEventHandler("onClientRender",root,function()
    if getElementData(localPlayer,"char >> job") == 5 and not isPedInVehicle(localPlayer) then 
        for k,veh in pairs(getElementsByType("vehicle")) do 
            if getElementModel(veh) == 578 then 
                local px,py,pz = getElementPosition(localPlayer);
                local vx,vy,vz = getVehicleComponentPosition(veh,"chassis_vlo","world");
                if vx and vy and vz and getDistanceBetweenPoints3D(vx,vy,vz,px,py,pz) < 3 then 
                    local x,y = getScreenFromWorldPosition(vx,vy,vz);
                    if x and y then 
                        shadowedText("Laying wood: "..exports.fv_engine:getServerColor("servercolor",true).."E#FFFFFF key.\n"..exports.fv_engine:getServerColor("servercolor",true)..(getElementData(veh,"lumberjack.wood") or 0).."#FFFFFF/6 db",x-100,y,x+100,0,tocolor(255,255,255),1,exports.fv_engine:getFont("rage",12),"center","top",false,false,false,true);
                        if getKeyState("e") and lumberEtick+500 < getTickCount() and not isCursorShowing() and getElementData(localPlayer,"network") then 
                            if not getElementData(localPlayer,"lumberjack.handWood") then 
                                outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","red").."You don't have a tree in your hand!",255,255,255,true);
                                lumberEtick = getTickCount();
                                return;
                            end
                            if (getElementData(veh,"lumberjack.wood") or 0)+1 > 6 then 
                                outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","red").."No more wood can fit in the cart, the wood in your hand has been discarded.",255,255,255,true);
                                triggerServerEvent("lumberjack.removePlayerWood",localPlayer,localPlayer);
                                triggerServerEvent("takeWeapons",localPlayer,localPlayer);
                                setControl(true);
                                lumberEtick = getTickCount();
                                return;
                            end
                            triggerServerEvent("lumberjack.woodToVeh",localPlayer,localPlayer,veh);
                            setControl(true);
                            lumberEtick = getTickCount();
                        end
                    end
                end
            end
        end
    end
end);