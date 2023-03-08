local trees = {}
local attachPos = { 
    {-0.7,-1,0},
    {0,-1,0},
    {0.7,-1,0},
    {0.3,-1,0.42},
    {-0.3,-1,0.42},
    {0,-1,0.9}
};
--kivagott fa : 684

function treeSpawn()
    local x,y,z = -1201.5726318359, -1058.2330322266, 129.00483703613;
    local id = 0;
    local tick = getTickCount();
    Async:iterate(1,18,function(i)
		for k=1,13 do
            local obj = createObject(654,x+(i*10),y+(k*10),z-1);
            local col = createColSphere(x+(i*10),y+(k*10),z,1.5);
            trees[id] = {x+(i*10),y+(k*10),z,obj,col};
            setElementData(col,"lumberjack.obj",obj);
            setElementData(col,"lumberjack.id",id);
            setElementData(obj,"lumberjack.col",col);
            setElementData(obj,"lumberjack.hp",100);
            setElementData(obj,"lumberjack.id",id);
            id = id + 1;
		end
    end);

	outputDebugString("LUMBERJACK >> spawned "..id.." wood in "..(getTickCount()-tick).." ms",0,200,200,200)
end
addEventHandler("onResourceStart",resourceRoot,treeSpawn);

function respawnTree(id)
    local x,y,z,obj,col,cutted = unpack(trees[id]);

    if not col then 
        col = createColSphere(x,y,z,1.5);
    end
    if not obj then 
        obj = createObject(654,x,y,z-1);
    end
    setElementData(col,"lumberjack.obj",obj);
    setElementData(col,"lumberjack.id",id);
    setElementData(obj,"lumberjack.col",col);
    setElementData(obj,"lumberjack.hp",100);
    setElementData(obj,"lumberjack.id",id);

    outputDebugString("LUMBERJACK >> ID:"..id.." respawned!",0,200,200,200);
end


addEvent("lumberjack.kickWood",true);
addEventHandler("lumberjack.kickWood",root,function(player,obj)
    if not getElementData(player,"network") then return end;

    setElementFrozen(player,true);
    local x,y,z = getElementPosition(obj);
    local mx,my,mz = 0,0,0;
    local randed = math.random(0,2);
    if randed == 1 then
        mx,my,mz = 0,80,0;
    elseif randed == 0 then
        mx,my,mz = 80,0,0;
    elseif randed == 2 then 
        mx,my,mz = 80,80,0;
    end
    local col = getElementData(obj,"lumberjack.col");
    if isElement(col) then 
        destroyElement(col);
        trees[getElementData(obj,"lumberjack.id")][5] = false;
    end
    local id = getElementData(obj,"lumberjack.id");
    if moveObject(obj,2000,x,y,z,mx,my,mz) then
        setTimer(function()
            if isElement(obj) then 
                trees[getElementData(obj,"lumberjack.id")][4] = false;
                destroyElement(obj);
            end
            setElementFrozen(player,false);
            local obj = createObject(684,0,0,0);
            setElementCollisionsEnabled(obj,false);
            setObjectScale(obj,0.5);
            setPedAnimation(player, "CARRY", "liftup", 1000, false) -- felemelés
            exports.fv_bone:attachElementToBone(obj, player, 12, 0, 0.2, 0, 0, 0, -110);
            setPedAnimation(player, "CARRY", "crry_prtial", 1, false)
            setElementData(player,"lumberjack.handWood",obj);
            
            outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","servercolor").."You have successfully cut down the tree, put it on the work vehicle "..exports.fv_engine:getServerColor("servercolor",true).."E#FFFFFF".." button.",player,255,255,255,true);

            setTimer(function() --Kivágás után 5 percel respawnol
                respawnTree(id);
            end,1000*60*5,1);
        end,3000,1)
    end
end);


addEvent("lumberjack.giveVeh",true);
addEventHandler("lumberjack.giveVeh",root,function(player)
    if not getElementData(player,"network") then return end;


    local x,y,z = getElementPosition(player);
    local rx,ry,rz = getElementRotation(player);
    local veh = createVehicle(578,x,y,z,rx,ry,rz,"F-"..getElementData(player,"acc >> id"));
    setVehicleColor(veh,255,255,255,255,255,255)
    setElementData(veh,"veh:uzemanyag",100);
    setElementData(veh,"veh:akkumulator",100);
    setElementData(veh,"veh:motorStatusz",true);
    setVehicleEngineState(veh,true);
    setElementData(veh,"veh:id",-(getElementData(player,"acc >> id")));
    setElementData(player,"job.veh",veh);

    setElementData(veh,"lumberjack.wood",0);

    warpPedIntoVehicle(player,veh);
    loadJobVeh(veh);
end);

addEvent("lumberjack.removeVeh",true);
addEventHandler("lumberjack.removeVeh",root,function(player)
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

addEvent("lumberjack.removePlayerWood",true);
addEventHandler("lumberjack.removePlayerWood",root,function(player)
    if not getElementData(player,"network") then return end;


    local wood = getElementData(player,"lumberjack.handWood");
    if wood and isElement(wood) then 
        exports.fv_bone:detachElementFromBone(wood);
        destroyElement(wood);
        setElementData(player,"lumberjack.handWood",false);
    end
end);

addEvent("lumberjack.woodToVeh",true);
addEventHandler("lumberjack.woodToVeh",root,function(player,veh)
    if not getElementData(player,"network") then return end;

    triggerEvent("lumberjack.removePlayerWood",player,player);
    local woodCount = getElementData(veh,"lumberjack.wood");
    local obj = createObject(684,0,0,0);
    setObjectScale(obj,0.5);
    setElementCollisionsEnabled(obj,false);
    local aPos = attachPos[woodCount+1];
    attachElements(obj,veh,aPos[1],aPos[2],aPos[3]);
    setPedAnimation(player);
    setElementData(veh,"lumberjack.wood",woodCount+1);
    outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","servercolor").."You have successfully put the tree on the car!",player,255,255,255,true);
end);

addEvent("lumberjack.downWood",true);
addEventHandler("lumberjack.downWood",root,function(player,veh)
    if not getElementData(player,"network") then return end;
    local X = getPedOccupiedVehicle(player);
    if X == veh then 
        local woods = getElementData(veh,"lumberjack.wood");
        if woods > 0 then 
            outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","servercolor").."You have successfully dropped the trees.",player,255,255,255,true);
            local all = 0;
            for i=1,woods do 
                local rand = math.random(500,800);
                all = all + rand;
                outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","servercolor").." "..i..". Price: "..exports.fv_engine:getServerColor("servercolor",true)..rand.."#FFFFFF dt",player,255,255,255,true);
            end

            for k,v in pairs(getAttachedElements(veh)) do 
                if isElement(v) then 
                    destroyElement(v);
                end
            end
            setElementData(veh,"lumberjack.wood",0);


            outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","servercolor").."Altogether: "..exports.fv_engine:getServerColor("servercolor",true)..all.."#FFFFFF dt",player,255,255,255,true);

            local vehHP = getElementHealth(veh);
            if vehHP < 900 then 
                local levon = math.floor((1000-vehHP));
                outputChatBox(exports.fv_engine:getServerSyntax("lumberjack","red").."The employer has deducted from your salary because of the broken vehicle! Repair fee: "..exports.fv_engine:getServerColor("red",true)..levon.."#FFFFFF $",player,255,255,255,true);
                all = all - levon;
                fixVehicle(veh);
            end
            setElementData(player,"char >> money",getElementData(player,"char >> money")+all);
        end
    end
end);

addEventHandler("onPlayerQuit",root,function()
    local obj = getElementData(source,"lumberjack.handWood")
    if obj and isElement(obj) then 
        exports.fv_bone:detachElementFromBone(obj);
        destroyElement(obj);
    end
end);