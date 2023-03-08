----------------------------------
local txd = engineLoadTXD("miner/car.txd");
engineImportTXD(txd,422);
local dff = engineLoadDFF("miner/car.dff");
engineReplaceModel(dff, 422);
----------------------------------

local minerRocks = {
    {-808.65679931641, -1876.0390625, 11.748561859131},
    {-797.55828857422, -1869.0184326172, 11.646293640137},
    {-824.8408203125, -1891.7438964844, 11.958889007568},
    {-817.587890625, -1884.9321289063, 11.829280853271},
}
local rockHit = 0;
local minerVehMarker = {};
local minerMarkerTick = 0;
local minerVehTick = 0;
local minerEndMarker = {};

addEventHandler("onClientElementDataChange",localPlayer,function(dataName,oldValue,newValue)
    if dataName == "char >> job" then 
        if newValue == 4 then 
            startMiner();
        else
            stopMiner();
        end
    end
end);
addEventHandler("onClientResourceStart",resourceRoot,function()
    if getElementData(localPlayer,"char >> job") == 4 then 
        startMiner();
    end
    setElementData(localPlayer,"miner.handRock",false);

    for k,v in pairs(minerRocks) do 
        local x,y,z = unpack(v);
        local obj = createObject(896,x,y,z);
        setElementData(obj,"miner.rock",true);
        setElementData(obj,"miner.hp",100);
    end
end);

function startMiner()
    minerVehMarker = {}
    local sColor = {exports.fv_engine:getServerColor("servercolor",false)};
    minerVehMarker[1] = createMarker(-627.97467041016, -1842.5462646484, 24.295623779297,"checkpoint",2,sColor[1],sColor[2],sColor[3],100);
    minerVehMarker[2] = createBlip(-627.97467041016, -1842.5462646484, 24.295623779297,3);
    setElementData(minerVehMarker[2],"blip >> name","Munkahely");
    setElementData(minerVehMarker[2],"blip >> maxVisible",true);

    addEventHandler("onClientMarkerHit",minerVehMarker[1],function(hitElement)
        if hitElement == localPlayer then 
            local veh = getPedOccupiedVehicle(localPlayer);
            if minerMarkerTick+(1000*60) > getTickCount() then outputChatBox(exports.fv_engine:getServerSyntax("Miner","red").."You can only use it every 1 minute!",255,255,255,true) return end;
            if veh then 
                if veh == getElementData(localPlayer,"job.veh") then 
                    triggerServerEvent("miner.removeVeh",localPlayer,localPlayer);
                    minerMarkerTick = getTickCount();
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Miner","red").."This is not your work vehicle!",255,255,255,true);
                    return;
                end
            else 
                if getElementData(localPlayer,"job.veh") then outputChatBox(exports.fv_engine:getServerSyntax("Miner","red").."You already have a work vehicle!",255,255,255,true) return end;
                triggerServerEvent("miner.giveVeh",localPlayer,localPlayer);
                minerMarkerTick = getTickCount();
            end
        end
    end);

    local red = {exports.fv_engine:getServerColor("red",false)};
    minerEndMarker[1] = createMarker(-2111.568359375, -259.78063964844, 35.3203125,"checkpoint",2,red[1],red[2],red[3],100);
    minerEndMarker[2] = createBlip(-2111.568359375, -259.78063964844, 35.3203125,1);
    setElementData(minerEndMarker[2],"blip >> name","Kő leadó");
    setElementData(minerEndMarker[2],"blip >> color",red);
    setElementData(minerEndMarker[2],"blip >> maxVisible",true);
    addEventHandler("onClientMarkerHit",minerEndMarker[1],function(hitElement)
        if hitElement == localPlayer then 
            local veh = getPedOccupiedVehicle(localPlayer);
            if veh and veh == getElementData(localPlayer,"job.veh") then 
                local woods = getElementData(veh,"miner.rock");
                if woods > 0 then 
                    triggerServerEvent("miner.downRocks",localPlayer,localPlayer,veh);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Miner","red").."There is not a stone in the car!",255,255,255,true);
                    return;
                end
            end
        end
    end);  
end

function stopMiner()
    for k,v in pairs(minerVehMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    triggerServerEvent("miner.removePlayerRock",localPlayer,localPlayer);
    for k,v in pairs(minerEndMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
end

addEventHandler("onClientRender",root,function() --Rock Check
if getElementData(localPlayer,"char >> job") == 4 then 
    local px,py,pz = getElementPosition(localPlayer);
    for k,v in pairs(getElementsByType("object",resourceRoot,true)) do 
        if (getElementData(v,"miner.rock") or false) then 
            local ox,oy,oz = getElementPosition(v);
            if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) < 10 then 
                local x,y = getScreenFromWorldPosition(ox,oy,oz);
                if x and y then 
                    dxDrawRectangle(x-155,y-25,310,50,tocolor(0,0,0,180));
                    local r,g,b = exports.fv_engine:getServerColor("servercolor",false);
                    dxDrawRectangle(x-150,y-20,(getElementData(v,"miner.hp") or 0)*3,40,tocolor(r,g,b,180));

                    local target = getPedTarget(localPlayer);
                    if target == v then
                        -- if getKeyState("mouse1") and not isCursorShowing() and rockHit+1000 < getTickCount() and getPedWeapon(localPlayer) == 11 and getElementData(localPlayer,"network") then 
                        --     if (getElementData(localPlayer,"miner.handRock") or false) then 
                        --         outputChatBox(exports.fv_engine:getServerSyntax("Miner","red").."Már van egy kő a kezedben!",255,255,255,true);
                        --         rockHit = getTickCount();
                        --         return;
                        --     end
                        --     setElementData(v,"miner.hp",getElementData(v,"miner.hp")-math.random(7,15));
                        --     if getElementData(v,"miner.hp") < 0 then 
                        --         setElementData(v,"miner.hp",100);
                        --         triggerServerEvent("miner.attachPlayer",localPlayer,localPlayer);
                        --         setControl(false);
                        --     end
                        --     rockHit = getTickCount();
                        -- end
                    end
                end
            end
        end
    end
    if not isPedInVehicle(localPlayer) then 
        for k,v in pairs(getElementsByType("vehicle",resourceRoot,true)) do 
            if getElementModel(v) == 422 then 
                local vx,vy,vz = getVehicleComponentPosition(v,"boot_dummy","world");
                if getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz) < 2 then 
                    local x,y = getScreenFromWorldPosition(vx,vy,vz);
                    if x and y then 
                        local sColor = exports.fv_engine:getServerColor("servercolor",true);
                        shadowedText("Laying stone: "..sColor.."E#FFFFFF button.\n"..sColor..(getElementData(v,"miner.rock") or 0).."#FFFFFF/6 db",x-100,y,x+100,0,tocolor(255,255,255),1,exports.fv_engine:getFont("rage",13),"center","top",false,false,false,true);
                        if getKeyState("e") and minerVehTick+4000 < getTickCount() and not isCursorShowing() then 
                            if not getElementData(localPlayer,"network") then return end;

                            if not getElementData(localPlayer,"miner.handRock") then 
                                outputChatBox(exports.fv_engine:getServerSyntax("Miner","red").."You don't have a stone in your hand!",255,255,255,true);
                                minerVehTick = getTickCount();
                                return;
                            end
                            if getElementData(v,"miner.rock")+1 > 6 then 
                                outputChatBox(exports.fv_engine:getServerSyntax("Miner","red").."There are no more stones on the vehicle, the stone in your hand has been removed!",255,255,255,true);
                                triggerServerEvent("miner.removePlayerRock",localPlayer,localPlayer);
                                setControl(true);
                                minerVehTick = getTickCount();
                                return;
                            end
                            triggerServerEvent("miner.attachVehicle",localPlayer,localPlayer,v);
                            setControl(true);
                            minerVehTick = getTickCount();
                        end
                    end
                end
            end
        end
    end
end
end)


addEventHandler("onClientKey",root,function(button,state)
if getElementData(localPlayer,"char >> job") == 4 then 
    if button == "mouse1" and state then 
        local targetRock = false;
        local px,py,pz = getElementPosition(localPlayer);
        for k,v in pairs(getElementsByType("object",resourceRoot,true)) do 
            if (getElementData(v,"miner.rock") or false) then 
                local ox,oy,oz = getElementPosition(v);
                if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) < 10 then 
                    if getPedTarget(localPlayer) == v then 
                        targetRock = v;
                        break;
                    end
                end
            end 
        end
        if targetRock then 
            if getKeyState("mouse1") and not isCursorShowing() and rockHit+1000 < getTickCount() and getPedWeapon(localPlayer) == 11 and getElementData(localPlayer,"network") then 
                if (getElementData(localPlayer,"miner.handRock") or false) then 
                    outputChatBox(exports.fv_engine:getServerSyntax("Miner","red").."You already have a stone in your hand!",255,255,255,true);
                    rockHit = getTickCount();
                    return;
                end
                setElementData(targetRock,"miner.hp",getElementData(targetRock,"miner.hp")-math.random(7,12));
                if getElementData(targetRock,"miner.hp") < 0 then 
                    setElementData(targetRock,"miner.hp",100);
                    triggerServerEvent("miner.attachPlayer",localPlayer,localPlayer);
                    setControl(false);
                end
                rockHit = getTickCount();
            end
        end
    end
end
end);


