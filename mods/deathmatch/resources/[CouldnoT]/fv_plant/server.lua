
sql = false;
e = exports.fv_engine;

local interval = 1000 * 60 * 60; --Óránként nő
local cans = {};

addEventHandler("onResourceStart",root,function(res)
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        sql = exports.fv_engine:getConnection(getThisResource());
        e = exports.fv_engine;
    end 

    if getThisResource() == res then 
        removeWorldModel(2203,9999999,0,0,0); --Cserepek törlése
        removeWorldModel(857,9999999,0,0,0); --Kokacserje
        removeWorldModel(858,9999999,0,0,0); --Mák
        removeWorldModel(859,9999999,0,0,0); --Marihuana
        removeWorldModel(977,9999999,0,0,0); --Kanna

        loadAllPlant();
    end
end);

--Kanna --
addEvent("plant.addCan",true);
addEventHandler("plant.addCan",root,function(player,itemDBID)
    deleteCan(player);
    setElementData(player,"weaponusing",itemDBID);
    local obj = createObject(977,0,0,0);
    setElementCollisionsEnabled(obj,false);
    setElementDimension(obj,getElementDimension(player));
    setElementInterior(obj,getElementInterior(player));
    exports.fv_bone:attachElementToBone(obj, player, 12, 0, 0, 0, 0,0,0);
    setElementData(player,"waterCan",obj);
    cans[player] = obj;
end);

function deleteCan(player)
    if cans[player] then 
        if isElement(cans[player]) then 
            destroyElement(cans[player]);
        end
    end
    setElementData(player,"waterCan",false);
    setElementData(player,"weaponusing",false);
    cans[player] = nil;
end
addEvent("plant.deleteCan",true);
addEventHandler("plant.deleteCan",root,deleteCan);
--------------

function loadAllPlant()
    local tick = getTickCount();
    dbQuery(function(qh)
        local res, lines = dbPoll(qh,0);
        Async:foreach(res,function(v)
            loadPlant(v.id);
        end,function()
            outputDebugString("PLANT -> "..lines.." loaded in "..(getTickCount()-tick).." ms!",0,150,50,0);
        end);
    end,sql,"SELECT id FROM plants");
end

function loadPlant(id)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for k,v in pairs(res) do 
            local x,y,z,interior,dimension = unpack(fromJSON(v["pos"]));
            local pot = createObject(2203,x,y,z);
            setElementDimension(pot,dimension);
            setElementInterior(pot,interior);

            local type = v["type"];
            if type and type > 0 then --Van ültetve bele.
                local plant = createObject(types[type][1],x,y,z-0.9 + ( v["increase"] / 100 ));

                setElementCollisionsEnabled(plant,false);

                if v["increase"] <= 50 then 
                    setObjectScale(plant, v["increase"] / 50);
                else 
                    setObjectScale(plant, v["increase"] / 80);
                end

                setElementData(pot,"plant.element",plant);

                -- local timer = setTimer(increasePlant,interval,0,pot);
                -- setElementData(pot,"plant.timer",timer);

                setElementDimension(plant,dimension);
                setElementInterior(plant,interior);
            else 
                v["water"] = 0;
                v["increase"] = 0;
            end

            setElementData(pot,"plant.used",false);

            setElementData(pot,"plant.id",v["id"]);
            setElementData(pot,"plant.type",v["type"]);
            setElementData(pot,"plant.increase",v["increase"]);
            setElementData(pot,"plant.water",v["water"]);
        end
    end,sql,"SELECT * FROM plants WHERE id=?",id);
end

function savePlant(pot)
    local id = getElementData(pot,"plant.id");
    local type = getElementData(pot,"plant.type");
    local increase = getElementData(pot,"plant.increase");
    local water = getElementData(pot,"plant.water");
    dbExec(sql,"UPDATE plants SET type=?, increase=?, water=? WHERE id=?",type,increase,water,id);
end

function saveAllPlant()
    local tick, counter = getTickCount(), 0;
    Async:foreach(getElementsByType("object",resourceRoot),function(v) 
        local id = getElementData(v,"plant.id");
        if getElementModel(v) == 2203 and id then 
            savePlant(v);
            counter = counter + 1;
        end
    end, function()
        outputDebugString("PLANT -> "..counter.." saved in "..(getTickCount()-tick).." ms!",0,150,50,0);
    end);
end
addEventHandler("onResourceStop",resourceRoot,saveAllPlant);
setTimer(saveAllPlant,1000*60*20,0); -- 20 percenként menti a cserepeket.

function increasePlant(pot)
    if pot and isElement(pot) then 
        local element = getElementData(pot,"plant.element") or false;
        if element and isElement(element) then 
            local waterLevel = getElementData(pot,"plant.water") or 0;
            local increaseLevel = getElementData(pot,"plant.increase") or 0;
            if waterLevel > 0 then 
                increaseLevel = increaseLevel + math.random(1,2);
                if increaseLevel > 100 then 
                    increaseLevel = 100;
                end
                waterLevel = waterLevel - math.random(3,4);
            end

            setElementData(pot,"plant.increase", increaseLevel);

            if waterLevel < 0 then 
                waterLevel = 0;
            end
            setElementData(pot,"plant.water",waterLevel);

            local potX, potY, potZ = getElementPosition(pot);
            setElementPosition(element, potX, potY, potZ - 0.9 + (increaseLevel / 100));
            if increaseLevel <= 50 then 
                setObjectScale(element, increaseLevel / 50);
            else 
                setObjectScale(element, increaseLevel / 80);
            end

            savePlant(pot);
        end
    end
end

setTimer(function()
    local tick, counter = getTickCount(), 0;
    for k,v in pairs(getElementsByType("object",resourceRoot)) do 
        if getElementModel(v) == 2203 then 
            increasePlant(v);
            counter = counter + 1;
        end
    end
    outputDebugString("PLANT -> "..counter.." increased in "..(getTickCount()-tick).." ms!",0,150,50,0);
end,interval,0);

addEvent("plant.add",true);
addEventHandler("plant.add",root,function(player)
    local x,y,z = getElementPosition(player);
    local interior, dimension = getElementInterior(player), getElementDimension(player);

    dbQuery(function(qh)
        local res, lines, dbID = dbPoll(qh,0);
        loadPlant(dbID);
        outputChatBox(e:getServerSyntax("Plant","red").."You have successfully laid a pot.",player,255,255,255,true);
    end,sql,"INSERT INTO plants SET pos=?, type=0",toJSON({x,y,z-0.8,interior,dimension}));
end);

addEvent("plant.pickUP",true);
addEventHandler("plant.pickUP",root,function(player,pot)
    if exports.fv_inventory:givePlayerItem(player,114,1,1,100,0) then 
        local dbID = getElementData(pot,"plant.id");
        dbExec(sql,"DELETE FROM plants WHERE id=?",dbID);
        local element = getElementData(pot,"plant.element");
        if element and isElement(element) then 
            destroyElement(element);
        end
        destroyElement(pot);
        outputChatBox(e:getServerSyntax("Plant","servercolor").."You picked up a pot from the ground.",player,255,255,255,true);
        exports.fv_chat:createMessage(player,"picks up a pot from the ground.",1);
    else 
        return outputChatBox(e:getServerSyntax("Plant","red").."You can't fit the tile!",player,255,255,255,true);
    end
end);

addEvent("plant.giveWater",true);
addEventHandler("plant.giveWater",root,function(player,pot)
    outputChatBox(e:getServerSyntax("Plant","servercolor").."You have successfully watered the plant.",player,255,255,255,true);

    local waterLevel = getElementData(pot,"plant.water");
    waterLevel = waterLevel + math.random(15,25);
    if waterLevel > 100 then 
        waterLevel = 100;
    end
    setElementData(pot,"plant.water",waterLevel);
    savePlant(pot);

    setElementData(player,"setPlayerAnimation",false);
end);

addEvent("plant.plantItem",true);
addEventHandler("plant.plantItem",root,function(player,temp,pot,type)
    local element = getElementData(pot,"plant.element");
    if element and isElement(element) then 
        destroyElement(element);
    end
    local x,y,z = getElementPosition(pot);
    local plant = createObject(types[type][1],x,y,z-0.9);
    setElementDimension(plant,getElementDimension(pot));
    setElementInterior(plant,getElementInterior(pot));
    setElementCollisionsEnabled(plant,false);
    setObjectScale(plant, 0);

    setElementData(pot,"plant.element",plant);

    setElementData(pot,"plant.type",type);
    setElementData(pot,"plant.increase", 0);
    setElementData(pot,"plant.water", 0);

    exports.fv_inventory:takePlayerItem(player,temp[3],1);
    setElementData(player,"setPlayerAnimation",false);

    savePlant(pot);
end);

addEvent("plant.harvest",true)
addEventHandler("plant.harvest",root,function(player,pot)
    local temp = types[getElementData(pot,"plant.type")];
    if exports.fv_inventory:givePlayerItem(player,temp[4],math.random(3,5),1,100,0) then 
        local element = getElementData(pot,"plant.element");
        if element and isElement(element) then 
            destroyElement(element);
        end
        setElementData(pot,"plant.type",0);
        setElementData(pot,"plant.increase", 0);
        setElementData(pot,"plant.water", 0);
    else 
        return outputChatBox(e:getServerSyntax("Plant","red").."The item does not fit you!",player,255,255,255,true);
    end
    setElementData(player,"setPlayerAnimation",false);
end);

--Parancsok
function delPlantByAdmin(player,cmd,id)
    if getElementData(player,"admin >> level") > 10 then 
        if not id or not tonumber(id) then 
            return outputChatBox(e:getServerSyntax("Use","red").."/"..cmd.." [ID]",player,255,255,255,true);
        end
        local id = tonumber(id);
        local plant = findPlant(id);
        if plant then 
            local element = getElementData(plant,"plant.element");
            if element and isElement(element) then 
                destroyElement(element);
            end
            destroyElement(plant);
            dbExec(sql,"DELETE FROM plants WHERE id=?",id);
            outputChatBox(e:getServerSyntax("Plant","servercolor").."Tiles deleted. ID: "..e:getServerColor("servercolor",true)..id..white..".",player,255,255,255,true);
        else 
            outputChatBox(e:getServerSyntax("Plant","red").."There is no such tile!",player,255,255,255,true);
        end
    end
end
addCommandHandler("delplant",delPlantByAdmin,false,false);

--NPC
local last = 0;
local drougPed = false;
function makeDrougPed()
    if isElement(drougPed) then 
        destroyElement(drougPed);
    end
    local current = math.random(1,#pedPos);
    while last == current do 
        current = math.random(1,#pedPos);
    end
    last = current;
    local x,y,z,rot = unpack(pedPos[current]);
    drougPed = createPed(269,x,y,z,rot);
    setElementFrozen(drougPed,true);
    setElementData(drougPed,"ped.noDamage",true);
    setElementData(drougPed,"ped >> name","Big Smoke")
    setElementData(drougPed,"ped >> type","Drug");
    setElementData(drougPed,"drougPed",true);
    setElementData(drougPed,"droug.used",{});
    outputDebugString("BigSmoke Spawnolva: "..getZoneName(getElementPosition(drougPed)),0,0,200,0);
end
addEventHandler("onResourceStart",resourceRoot,makeDrougPed);
setTimer(makeDrougPed,1000*60*60*2,0);

addEvent("droug.BUY",true);
addEventHandler("droug.BUY",root,function(player,count,cost,type)
    local itemID = types[type][3];
    if exports.fv_inventory:givePlayerItem(player,itemID,count,1,100,0) then 
        setElementData(player,"char >> money",getElementData(player,"char >> money") - cost);
        exports.fv_infobox:addNotification(player,"success","Successful purchase!");
        triggerClientEvent(player,"droug.CLOSE",player);
    else 
        return outputChatBox(e:getServerSyntax("Drug","red").."You don't have that much space!",player,255,255,255,true);
    end
end);

