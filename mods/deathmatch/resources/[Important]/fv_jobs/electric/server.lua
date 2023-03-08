addEvent("electric.giveVeh",true);
addEventHandler("electric.giveVeh",root,function(player)
    if not getElementData(player,"network") then return end;


    local x,y,z = getElementPosition(player);
    local rx,ry,rz = getElementRotation(player);
    local veh = createVehicle(552,x,y,z,rx,ry,rz,"E-"..getElementData(player,"acc >> id"));
    local r,g,b = exports.fv_engine:getServerColor("servercolor",false);
    setVehicleColor(veh,255,255,255,r,g,b)
    setElementData(veh,"veh:uzemanyag",100);
    setElementData(veh,"veh:akkumulator",100);
    setElementData(veh,"veh:motorStatusz",true);
    setVehicleEngineState(veh,true);
    setElementData(veh,"veh:id",-(getElementData(player,"acc >> id")));
    setElementData(player,"job.veh",veh);

    warpPedIntoVehicle(player,veh);
    loadJobVeh(veh);
end);

addEvent("electric.removeVeh",true);
addEventHandler("electric.removeVeh",root,function(player)
    if not getElementData(player,"network") then return end;


    local veh = getPedOccupiedVehicle(player);
    if veh and getElementData(player,"job.veh") then 

        destroyElement(veh);
        setElementData(player,"job.veh",false);
    end
end);
