addEvent("bus.giveVeh",true);
addEventHandler("bus.giveVeh",root,function(player)
    if not getElementData(player,"network") then return end;

    local x,y,z = getElementPosition(player);
    local rx,ry,rz = getElementRotation(player);
    local veh = createVehicle(431,x,y,z,rx,ry,rz,"D-"..getElementData(player,"acc >> id"));
    setElementData(veh,"veh:uzemanyag",100);
    setElementData(veh,"veh:akkumulator",100);
    setElementData(veh,"veh:motorStatusz",true);
    setVehicleEngineState(veh,true);
    setElementData(veh,"veh:id",-(getElementData(player,"acc >> id")));
    setElementData(player,"job.veh",veh);

    warpPedIntoVehicle(player,veh);
    loadJobVeh(veh);

    outputChatBox(exports.fv_engine:getServerSyntax("Bus driver","servercolor").."Go to the stop! "..exports.fv_engine:getServerColor("red",true).."(Red marking)#FFFFFF.",player,255,255,255,true);
end);

addEvent("bus.removeVeh",true);
addEventHandler("bus.removeVeh",root,function(player)
    if not getElementData(player,"network") then return end;

    local veh = getPedOccupiedVehicle(player);
    if veh and getElementData(player,"job.veh") then 
        destroyElement(veh);
        setElementData(player,"job.veh",false);
    end
end);

function loadJobVeh(veh)
    if not isElement(veh) then return end;
    setElementAlpha(veh,100);
    setVehicleDamageProof(veh,true)
    --setElementCollisionsEnabled(veh,false);
    setTimer(function()
        setElementAlpha(veh,150);
            setTimer(function()
                --[[setElementAlpha(veh,150);
                setTimer(function()
                    setElementAlpha(veh,200);
                    setTimer(function()]]
                        setElementAlpha(veh,255);
                        setVehicleDamageProof(veh,false);
                        --setElementCollisionsEnabled(veh,true);
                    --end,1500,1);
                --end,1000,1);
            end,1000,1);
    end,1000,1);
end