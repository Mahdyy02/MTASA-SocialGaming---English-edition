----------------------------------
local txd = engineLoadTXD("dock/car.txd");
engineImportTXD(txd,530);
local dff = engineLoadDFF("dock/car.dff");
engineReplaceModel(dff, 530);
----------------------------------
local dockVehMarker = {};
local dockMarkerTick = 0;
local boxSpawn = {
    {2824.1633300781, -2381.1843261719, 12.075541496277},
    {2824.8083496094, -2459.1040039063, 12.094569206238},
};
local boxCache = {};

local endPoints = {
    {2784.7709960938, -2417.3471679688, 13.634400367737},
    {2784.0568847656, -2455.7719726563, 13.634573936462},
    {2783.8649902344, -2494.1071777344, 13.655068397522},
}
local endMarker = false;

addEventHandler("onClientResourceStart",resourceRoot,function()
    setElementData(localPlayer,"job.veh",false);
    if getElementData(localPlayer,"char >> job") == 2 then 
        startDockJob();
    else 
        stopDockJob();
    end
end);
addEventHandler("onClientElementDataChange",localPlayer,function(dataName,oldValue,newValue)
    if dataName == "char >> job" then 
        if newValue == 2 then 
            startDockJob();
        else 
            stopDockJob();
        end
    end
end);

function startDockJob()
    local sColor = {exports.fv_engine:getServerColor("servercolor",false)};
    dockVehMarker[1] = createMarker(2715.2233886719, -2414.0251464844, 13.6328125,"checkpoint",2,sColor[1],sColor[2],sColor[3],100);
    dockVehMarker[2] = createBlip(2715.2233886719, -2414.0251464844, 13.6328125,3);
    setElementData(dockVehMarker[2],"blip >> name","Munkahely");
    setElementData(dockVehMarker[2],"blip >> maxVisible",true);
    addEventHandler("onClientMarkerHit",dockVehMarker[1],function(hitElement)
        if hitElement == localPlayer then 
            if not getElementData(localPlayer,"network") then return end;

            local veh = getPedOccupiedVehicle(localPlayer);
            if dockMarkerTick+(1000*60) > getTickCount() then outputChatBox(exports.fv_engine:getServerSyntax("Dock Worker","red").."You can only use it every 1 minute!",255,255,255,true) return end;
            if veh then 
                if veh == getElementData(localPlayer,"job.veh") then 
                    triggerServerEvent("dock.removeVeh",localPlayer,localPlayer);
                    for k,v in pairs(boxCache) do 
                        local obj,mark = unpack(v);
                        if isElement(obj) then 
                            destroyElement(obj);
                        end
                        if isElement(mark) then 
                            destroyElement(mark);
                        end
                    end
                    dockMarkerTick = getTickCount();
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Dock Worker","red").."This is not your work vehicle!",255,255,255,true);
                    return;
                end
            else 
                if getElementData(localPlayer,"job.veh") then outputChatBox(exports.fv_engine:getServerSyntax("Dock Worker","red").."You already have a work vehicle!",255,255,255,true) return end;
                triggerServerEvent("dock.giveVeh",localPlayer,localPlayer);
                dockMarkerTick = getTickCount();
                generateBoxes();
            end
        end
    end);
end

function stopDockJob()
    for k,v in pairs(dockVehMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    if isElement(endMarker) then 
        destroyElement(endMarker);
    end
    for k,v in pairs(boxCache) do 
        local obj,mark = unpack(v);
        if isElement(obj) then 
            destroyElement(obj);
        end
        if isElement(mark) then 
            destroyElement(mark);
        end
    end
    triggerServerEvent("job.destroyVeh",localPlayer,localPlayer);
end

function generateBoxes()
    local modelID = 1224;
    for k,v in pairs(boxSpawn) do 
        local x,y,z = unpack(v);
        local obj = createObject(modelID,x,y,z-0.37);
        setElementFrozen(obj,true);
        local orange = {exports.fv_engine:getServerColor("orange",false)};
        local mark = createMarker(x,y,z,"checkpoint",2,orange[1],orange[2],orange[3],160);
        setElementData(mark,"dock.obj",obj);
        addEventHandler("onClientMarkerHit",mark,function(hitElement)
            if hitElement == localPlayer then 
                if not getElementData(localPlayer,"network") then return end;

                local veh = getPedOccupiedVehicle(localPlayer);
                if veh and veh == getElementData(localPlayer,"job.veh") then 
                    if getElementData(veh,"dock.box") then outputChatBox(exports.fv_engine:getServerSyntax("Dock Worker","red").."There is already a box on the truck!",255,255,255,true) return end;
                    triggerServerEvent("dock.attachBox",localPlayer,localPlayer);
                    destroyElement(getElementData(source,"dock.obj"));
                    destroyElement(source);
                    createEnd();
                end
            end
        end)
        boxCache[#boxCache + 1] = {obj,mark};
    end
end

function createEnd()
    local red = {exports.fv_engine:getServerColor("red",false)};
    local rand = math.random(1,#endPoints);
    local x,y,z = unpack(endPoints[rand]);
    endMarker = createMarker(x,y,z,"checkpoint",2,red[1],red[2],red[3],100);
    addEventHandler("onClientMarkerHit",endMarker,function(hitElement)
        if hitElement == localPlayer then 
            local veh = getPedOccupiedVehicle(localPlayer);
            if veh and veh == getElementData(localPlayer,"job.veh") then 
                local box = getElementData(veh,"dock.box");
                if box then 
                    local rand = math.random(150,300);
                    triggerServerEvent("dock.removeBox",localPlayer,localPlayer);
                    -- setElementData(localPlayer,"char >> money",getElementData(localPlayer,"char >> money") + rand);
                    triggerServerEvent("ac.elementData",localPlayer,localPlayer,"char >> money",getElementData(localPlayer,"char >> money") + rand);
                    outputChatBox(exports.fv_engine:getServerSyntax("Dock Worker","servercolor").."You successfully dropped the box. salary: "..exports.fv_engine:getServerColor("servercolor",true)..rand.." #FFFFFFdt",255,255,255,true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Dock Worker","servercolor").."If you still want to work then go to the ship for the next box. "..exports.fv_engine:getServerColor("orange",true).."(Yellow marking)#FFFFFF.",255,255,255,true);
                    if getBoxCount() < 1 then 
                        generateBoxes()
                    end
                    destroyElement(source);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Dock Worker","red").."There is no box on the truck!",255,255,255,true);
                end
            end
        end
    end);
end

function getBoxCount()
    local count = 0;
    for k,v in pairs(boxCache) do 
        local obj,mark = unpack(v);
        if isElement(obj) and isElement(mark) then 
            count = count + 1;
        end
    end
    return count;
end 
--[[function typeDrawing()
    local px,py,pz = getElementPosition(localPlayer);
    if getDistanceBetweenPoints3D(px,py,pz,2773.962890625, -2417.1887207031, 19.227592468262) < 40 then 
        local x,y = getScreenFromWorldPosition(2773.962890625, -2417.1887207031, 19.227592468262);
        if x and y then 
            dxDrawRectangle(x-100,y,200,40,tocolor(0,0,0,180));
            dxDrawText("Raktár 1",x-100,y,x-100+200,y+40,tocolor(255,255,255),1,"default-bold","center","center")
        end
    end
end
addEventHandler("onClientRender",root,typeDrawing)]]