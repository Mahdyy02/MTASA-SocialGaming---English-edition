local rockAttachPos = {
    {-0.35, -1, -0.3},
    {0.35, -1, -0.3},
    {0.35, -1.5, -0.3},
    {-0.35, -1.5, -0.3},
    {-0.35, -2.3, -0.3},
    {0.35, -2.3, -0.3},
}

addEvent("miner.giveVeh",true);
addEventHandler("miner.giveVeh",root,function(player)
    if not getElementData(player,"network") then return end;
    local x,y,z = getElementPosition(player);
    local rx,ry,rz = getElementRotation(player);
    local veh = createVehicle(422,x,y,z,rx,ry,rz,"B-"..getElementData(player,"acc >> id"),0,0);
    local r,g,b = exports.fv_engine:getServerColor("servercolor",false);
    setVehicleColor(veh,r,g,b,255,255,255);
    setElementData(veh,"veh:uzemanyag",100);
    setElementData(veh,"veh:motorStatusz",true);
    setVehicleEngineState(veh,true);
    setElementData(veh,"veh:id",-(getElementData(player,"acc >> id")));
    setElementData(player,"job.veh",veh);

    setElementData(veh,"miner.rock",0);

    warpPedIntoVehicle(player,veh);
    loadJobVeh(veh);
end);

addEvent("miner.removeVeh",true);
addEventHandler("miner.removeVeh",root,function(player)
    if not getElementData(player,"network") then return end;
    local veh = getPedOccupiedVehicle(player);
    if veh and getElementData(player,"job.veh") then 
        for k,v in pairs(getAttachedElements(veh)) do
            if isElement(v) then 
                destroyElement(v);
            end
        end
        destroyElement(veh);
        setElementData(player,"job.veh",false);
    end
end);

addEvent("miner.attachPlayer",true);
addEventHandler("miner.attachPlayer",root,function(player)
    if not getElementData(player,"network") then return end;
    local x,y,z = getElementPosition(player);
    local obj = createObject(3929,x,y,z);
    setObjectScale(obj,0.4);
    setElementCollisionsEnabled(obj,false);
    exports.fv_bone:attachElementToBone(obj,player,12,0.2,0.1,0.1,0,0,180);

    setElementData(player,"miner.handRock",obj);
    setPedAnimation(player,"carry","crry_prtial",0,true,false,false,true);
    outputChatBox(exports.fv_engine:getServerSyntax("Miner","green").."You have successfully knocked out a stone, put it on the platform of your work vehicle!",player,255,255,255,true);
end);

addEvent("miner.removePlayerRock",true);
addEventHandler("miner.removePlayerRock",root,function(player)
    if not getElementData(player,"network") then return end;
    local obj = getElementData(player,"miner.handRock");
    if obj and isElement(obj) then 
        destroyElement(obj);
        setElementData(player,"miner.handRock",false);
    end
end)

addEvent("miner.attachVehicle",true);
addEventHandler("miner.attachVehicle",root,function(player,veh)
    if not getElementData(player,"network") then return end;

    local obj = getElementData(player,"miner.handRock");
    if obj and isElement(obj) then 
        exports.fv_bone:detachElementFromBone(obj);
        destroyElement(obj);
        setElementData(player,"miner.handRock",false);
    end

    setPedAnimation(player,"carry","putdwn05",0,false,false,false,false);
    setElementData(veh,"miner.rock",(getElementData(veh,"miner.rock") or 0) + 1);
    if getElementData(veh,"miner.rock") > 6 then setElementData(veh,"miner.rock",6) return end;
    local x,y,z = getElementPosition(veh);
    local obj = createObject(3929, x, y, z, 0, 0, 0);
    setElementCollisionsEnabled(obj, false);
    setObjectScale(obj, 0.4);
    attachElements(obj, veh, rockAttachPos[getElementData(veh,"miner.rock")][1], rockAttachPos[getElementData(veh,"miner.rock")][2], rockAttachPos[getElementData(veh,"miner.rock")][3]);
end)

addEvent("miner.downRocks",true);
addEventHandler("miner.downRocks",root,function(player,veh)
    if not getElementData(player,"network") then return end;


    local X = getPedOccupiedVehicle(player);
    if X == veh then 
        local woods = getElementData(veh,"miner.rock");
        if woods > 0 then 
            outputChatBox(exports.fv_engine:getServerSyntax("Miner","servercolor").."You have successfully dropped the stones.",player,255,255,255,true);
            local all = 0;
            for i=1,woods do 
                local rand = math.random(500,700);
                all = all + rand;
                outputChatBox(exports.fv_engine:getServerSyntax("Miner","servercolor").." "..i..". Prize: "..exports.fv_engine:getServerColor("servercolor",true)..rand.."#FFFFFF dt",player,255,255,255,true);
            end

            for k,v in pairs(getAttachedElements(veh)) do 
                if isElement(v) then 
                    destroyElement(v);
                end
            end
            setElementData(veh,"miner.rock",0);

            outputChatBox(exports.fv_engine:getServerSyntax("Miner","servercolor").."Altogether: "..exports.fv_engine:getServerColor("servercolor",true)..all.."#FFFFFF dt",player,255,255,255,true);
            local vehHP = getElementHealth(veh);
            if vehHP < 900 then 
                local levon = math.floor((1000-vehHP));
                outputChatBox(exports.fv_engine:getServerSyntax("Miner","red").."The employer has deducted from your salary because of the broken vehicle! Repair fee: "..exports.fv_engine:getServerColor("red",true)..levon.."#FFFFFF dt",player,255,255,255,true);
                all = all - levon;
                fixVehicle(veh);
            end
            setElementData(player,"char >> money",getElementData(player,"char >> money")+all);
        end
    end
end);


addEventHandler("onPlayerQuit",root,function()
    local obj = getElementData(source,"miner.handRock")
    if obj and isElement(obj) then 
        exports.fv_bone:detachElementFromBone(obj);
        destroyElement(obj);
    end
end);