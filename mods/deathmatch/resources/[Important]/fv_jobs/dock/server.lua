local modelID = 1224;

addEvent("dock.giveVeh",true);
addEventHandler("dock.giveVeh",root,function(player)
    if not getElementData(player,"network") then return end;


    local x,y,z = getElementPosition(player);
    local rx,ry,rz = getElementRotation(player);
    local veh = createVehicle(530,x,y,z,rx,ry,rz,"D-"..getElementData(player,"acc >> id"));
    setVehicleColor(veh,255,255,255,255,255,255)
    setElementData(veh,"veh:uzemanyag",100);
    setElementData(veh,"veh:akkumulator",100);
    setElementData(veh,"veh:motorStatusz",true);
    setVehicleEngineState(veh,true);
    setElementData(veh,"veh:id",-(getElementData(player,"acc >> id")));
    setElementData(player,"job.veh",veh);

    warpPedIntoVehicle(player,veh);
    loadJobVeh(veh);
end);

addEvent("dock.removeVeh",true);
addEventHandler("dock.removeVeh",root,function(player)
    if not getElementData(player,"network") then return end;


    local veh = getPedOccupiedVehicle(player);
    if veh and getElementData(player,"job.veh") then 
        local obj = getElementData(veh,"dock.box");
        if obj and isElement(obj) then 
            destroyElement(obj);
        end

        destroyElement(veh);
        setElementData(player,"job.veh",false);
    end
end);

addEvent("dock.attachBox",true);
addEventHandler("dock.attachBox",root,function(player)
    if not getElementData(player,"network") then return end;


    local veh = getPedOccupiedVehicle(player);
    if veh then 
        local obj = createObject(modelID,0,0,0);
        setElementCollisionsEnabled(obj,false);
        attachElements(obj,veh,0,0.7,0.5);
        setElementFrozen(obj,true);
        setElementData(veh,"dock.box",obj);
        outputChatBox(exports.fv_engine:getServerSyntax("Dock Worker","servercolor").."You have successfully picked up the box, take the "..exports.fv_engine:getServerColor("red",true).."red#FFFFFF marking!",player,255,255,255,true);
    end
end);

addEvent("dock.removeBox",true);
addEventHandler("dock.removeBox",root,function(player)
    if not getElementData(player,"network") then return end;


    local veh = getPedOccupiedVehicle(player);
    if veh then 
        local obj = getElementData(veh,"dock.box");
        if isElement(obj) then 
            destroyElement(obj);
            setElementData(veh,"dock.box",false);
        end
    end
end);