addEvent("mechanic.down",true)
addEventHandler("mechanic.down",root,function(player,rVeh,component,type,helo,buzi)
    local x,y,z = getElementPosition(player);
    local veh = createVehicle(getElementModel(rVeh),x,y,z+15);
    local attach = {0,0,0,0,0,0};
    if type == 1 then --Ajtó
        if helo == 2 then 
            attach = {0.3,1.3,0.8, 0,0,90};
        elseif helo == 4 then 
            attach = {-0.7,1.3,0.8, 0,0,90};
        elseif helo == 5 then 
            attach = {-0.7,-0.7,0.8, 0,0,90};
        elseif helo == 3 then 
            attach = {0.4,-0.7,0.8, 0,0,90};
        elseif helo == 0 then 
            attach = {0,-0.9,0.1, 0,0,0};
        elseif helo == 1 then 
            attach = {0,3,0.3, 0,0,0};
        end
        setVehicleDoorState(veh,helo,getVehicleDoorState(rVeh,helo));
    elseif type == 2 then --Panel
        if helo == 6 then 
            attach = {0,3,0.8, 0,0,0};
        elseif helo == 5 then 
            attach = {0,-2,0.8, 0,0,0};
        end
        setVehiclePanelState(veh,helo,getVehiclePanelState(rVeh,helo));
    elseif type == 3 then --Kerék
        if helo == 4 then 
            attach = {-1.6,-0.5,1, 0,0,90};
        elseif helo == 3 then 
            attach = {1.6,-0.5,1, 0,0,90};
        elseif helo == 2 then 
            attach = {-1.6,1.3,1, 0,0,90};
        elseif helo == 1 then 
            attach = {1.6,1.3,1, 0,0,90};
        end
        local states = {getVehicleWheelStates(rVeh)};
        setVehicleWheelStates(veh,unpack(states));
    end
    attachElements(veh,player,unpack(attach));
    setElementCollisionsEnabled(veh,false);
    setVehicleDamageProof(veh,true);
    setVehicleColor(veh,getVehicleColor(rVeh));
    setElementData(veh,"mechanic.comp",component);
    setElementData(veh,"mechanic.carry",player);
    triggerClientEvent(root,"mechanic.handSync",root,veh,component);

    setPedAnimation(player, "CARRY", "crry_prtial", 0, true, false, false);

    setElementData(player,"mechanic.hand",veh);
    if buzi then 
        setElementData(veh,"mechanic.repaired",true);
    else 
        setElementData(veh,"mechanic.repaired",false);
    end
end);

addEvent("mechanic.sync",true);
addEventHandler("mechanic.sync",root,function(veh,component,state)
    triggerClientEvent(root,"mechanic.compVisible",root,veh,component,state);
end);

addEvent("mechanic.deleteHand",true);
addEventHandler("mechanic.deleteHand",root,function(player)
    local carry = getElementData(player,"mechanic.hand");
    if carry then 
        destroyElement(carry);
        setElementData(player,"mechanic.hand",false);
        setElementData(player,"mechanic.repaired",false);
    end
end);

addEvent("mechanic.applyAnimation",true);
addEventHandler("mechanic.applyAnimation",root,function(player,anim1,anim2,time,egy,ketto,harom)
    setPedAnimation(player,anim1,anim2,time,egy,ketto,harom);
end);

addEvent("mechanic.fixVehicle",true);
addEventHandler("mechanic.fixVehicle",root,function(player,vehicle)
    setElementHealth(vehicle,1000);
    --fixVehicle(vehicle);
    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."You have successfully repaired the engine!",player,255,255,255,true);
end);