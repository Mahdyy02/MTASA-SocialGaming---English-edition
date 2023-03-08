local sql = exports.fv_engine:getConnection(getThisResource());

addEventHandler("onResourceStart",resourceRoot,function()
    dbExec(sql,"UPDATE accounts SET online=0");
    dbExec(sql, "UPDATE accounts SET banDatas='[ false ]', banEnd='0000-00-00' WHERE banEnd<NOW()");
end);

addEvent("acc.register",true);
addEventHandler("acc.register",root,function(player,name,pw,mail)
    dbQuery(function(qh)
        local result,num = dbPoll(qh,0);
        if #result > 0 then 
            exports.fv_infobox:addNotification(player,"error","Your username is already used!");
            return;
        else
            qh = false;
            result = {};
            dbQuery(function(qh)
                local result = dbPoll(qh,0);
                if #result > 0 then 
                    exports.fv_infobox:addNotification(player,"error","You already have an account associated with this computer!");
                    return;
                else 
                    qh = false;
                    result = {};
                    local sql = dbExec(sql,"INSERT INTO accounts SET name=?, password=?, email=?, serial=?, ip=?, registerdatum=NOW(), lastlogin=NOW(), online=0",name,sha256(pw),mail,getPlayerSerial(player),getPlayerIP(player));
                    if sql then 
                        print(name .. " registered")
                        exports.fv_infobox:addNotification(player,"success","Successful registration, log in!");
                        triggerClientEvent(player,"acc.return",player,"login");
                    end
                end
            end,sql,"SELECT serial FROM accounts WHERE serial=?",getPlayerSerial(player));
        end
    end,sql,"SELECT name FROM accounts WHERE name=?",name);
end);

addEvent("acc.login",true);
addEventHandler("acc.login",root,function(player,name,pw)
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        if #result > 0 then 
            for k,v in pairs(result) do 
                if v.serial ~= getPlayerSerial(player) and serial ~= "0" then           
                    exports.fv_infobox:addNotification(player,"error","This account is not associated with your computer!");
                    return;
                end
                if v.online == 1 then 
                    exports.fv_infobox:addNotification(player,"error","This account is already in use!");
                    return;
                end
                dbExec(sql, "UPDATE accounts SET banDatas='[ false ]', banEnd='0000-00-00' WHERE banEnd<NOW()");

                local banDatas = fromJSON(v.banDatas);
                local banEnd = tostring(v.banEnd);
                if banEnd and banDatas then 
                    kickPlayer(player,"You've been banned!","Admin: "..banDatas[1].." | Days: "..banDatas[3].." | Expire: "..banEnd.." \nReason: "..banDatas[2]);
                    return;
                end
                setElementData(player,"acc >> id",v.id);
                setElementData(player,"acc >> loggedIn",true);
                --setElementData(player,"loggedIn",true);
                setElementData(player,"acc >> username",v.name);

                setElementData(player,"acc >> regdate",v.registerdatum);

                dbExec(sql,"UPDATE accounts SET lastlogin=NOW(), online=1 WHERE id=?",v.id);

                loadCharacter(player,v.id);
                exports.fv_infobox:addNotification(player,"success","Login successful!");
            end
        else 
            exports.fv_infobox:addNotification(player,"error","Incorrect username or password!");
            return;
        end
    end,sql,"SELECT * FROM accounts WHERE name=? AND password=?",name,sha256(pw));
end);

function loadCharacter(player,id)
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        if #result > 0 then 
            qh = false;
            result = {};
            dbQuery(function(qh)
                local result = dbPoll(qh,0);
                if #result > 0 then 
                    for k,v in pairs(result) do 
                        setElementData(player,"acc >> loggedin",true);
                        setElementData(player,"loggedIn",true);

                        setElementData(player,"char >> money",v.money);
                        setElementData(player,"char >> bankmoney",v.bankmoney);
                        setElementData(player,"char >> premiumPoints",v.premiumPoints);

                        setElementData(player,"char >> age",v.age);
                        setElementData(player,"char >> height",v.height);
                        setElementData(player,"char >> weight",v.weight);
                        setElementData(player,"char >> gender",v.gender);
                        setElementData(player,"char >> fightStyle ",v.fightStyle);
                        setElementData(player,"char >> walkStyle",v.walkStyle);
                        setElementData(player,"char >> playedtime",v.playedtime);
                        setElementData(player,"char >> food",v.food);
                        setElementData(player,"char >> drink",v.drink);
                        setElementData(player,"char >> level",v.level);
                        setElementData(player,"char >> job",v.job);

                        setElementData(player,"char >> position",v.position);
                        setElementData(player,"char >> rot",v.rot);

                        setElementData(player,"admin >> name",v.adminame);

                        --setElementHealth(player,v.health);
                        setElementData(player,"spawn.health",v.health);
                        setPedArmor(player,v.armor);
                        setElementModel(player,v.skinid);
                        setElementData(player,"char >> skin",v.skinid);

                        setElementData(player,"char >> vehSlot",v.vehSlot);
                        setElementData(player,"char >> intSlot",v.intSlot);

                        setElementData(player,"char >> radiof",v.radiofreki);

                        setElementData(player, "char >> bone", (fromJSON(v.bone) or {true, true, true, true, true})); 

                        setElementData(player,"kari->Coin",v.coins);

                        local ajail = fromJSON(v["adminjail"]);
                        if ajail and ajail[1] == 1 then 
                            ajail[6] = setTimer(function()
                                            exports.fv_admin:adminJailTimer(player);
                                        end,1000*60,1);
                            setElementData(player,"char >> adminJail",ajail);
                            setElementData(player,"char >> position",toJSON({264.33465576172, 77.65731048584, 1001.0390625,100+getElementData(player,"acc >> id"),6}));
                        end

                        local icjail = fromJSON(v["icjail"]);
                        if icjail and icjail[1] == 1 then 
                            icjail[6] = setTimer(function()
                                exports.fv_factioncommands:jailTimer(player);
                            end,1000,1);
                            setElementData(player,"icjail.data",icjail);
                            setElementData(player,"char >> position",toJSON({264.33465576172, 77.65731048584, 1001.0390625,100+getElementData(player,"acc >> id"),6}));
                        end

                        setElementData(player,"char >> name",v.charname);
                        setPlayerName(player,v.charname:gsub(" ","_"));

                        setElementData(player,"admin >> level",v.adminlevel);
                        setElementData(player,"admin >> name",v.adminname);

                        local death = false;
                        if v.death == "true" then 
                            death = true;
                        end
                        setElementData(player,"char >> dead",death);
                        exports.fv_logs:createLog("MTALOGIN",getElementData(player,"char >> name").." logged.",player);

                        triggerClientEvent(player,"acc.return",player,"charCheck");
                    end
                end
            end,sql,"SELECT * FROM characters WHERE id=?",id);
        else 
            exports.fv_infobox:addNotification(player,"info","No characters yet, create a new one.");
            triggerClientEvent(player,"acc.return",player,"charCreate");
            return;
        end
    end,sql,"SELECT id,ownerAccountName FROM characters WHERE id=?",id);
end


addEvent("acc.charCreate",true);
addEventHandler("acc.charCreate",root,function(player,name,height,weight,age,skin,gender)
    local accid = getElementData(player,"acc >> id");
    --outputDebugString(skin);
    local sql = dbExec(sql,"INSERT INTO characters SET ownerAccountName=?, charname=?, skinid=?, gender=?, age=?, weight=?, height=?, id=?",getElementData(player,"acc >> username"),name:gsub("_"," "),skin,gender,age,weight,height,accid);
    if sql then 
        exports.fv_infobox:addNotification(player,"success","Successful character creation!");
        loadCharacter(player,accid);
    else 
        exports.fv_infobox:addNotification(player,"error","Failed to create character! (MySQL error)");
        return;
    end
end);

addEvent("acc.Spawn",true);
addEventHandler("acc.Spawn",root,function(player)
    local pos = fromJSON(getElementData(player,"char >> position"));
    spawnPlayer(player,pos[1],pos[2],pos[3],getElementData(player,"char >> rot"),getElementData(player,"char >> skin"),pos[5],pos[4]);
    setElementFrozen(player,true);
    setElementHealth(player,getElementData(player,"spawn.health") or 100);

    setElementData(player,"loggedIn",true);

    if getElementData(player,"char >> dead") then 
        setElementHealth(player,0);
    end

    setTimer(function()
        exports.fv_inventory:takeDutyItems(player)
    end, 1000, 1)
end)

addEventHandler("onPlayerQuit",root,function()
    local accid = getElementData(source,"acc >> id");
    if accid then 
        dbExec(sql,"UPDATE accounts SET online=0 WHERE id=?",accid);
        savePlayer(source);
    end
end)

addEventHandler("onResourceStop",resourceRoot,function()
    for k,v in pairs(getElementsByType("player")) do 
        savePlayer(v);
    end
end);

setTimer(function()
    for k,v in pairs(getElementsByType("player")) do 
        savePlayer(v);
    end
end,1000*60*20,0);

--Save--
function savePlayer(source)
    if getElementData(source, "loggedIn") or getElementData(source, "acc >> loggedin") then
        local id = getElementData(source, "acc >> id")
        local dim = getElementDimension(source)
        if getElementData(source, "char >> dead") or getElementData(source, "inDeath") then
            local oldDimension = getElementData(source, "oldDimension") or getElementDimension(source)
            dim = oldDimension
        end
        local int = getElementInterior(source)
        local x,y,z = getElementPosition(source)
        local position = toJSON({x,y,z, dim, int, getZoneName(x,y,z)})
        local money = getElementData(source, "char >> money")
        local bankmoney = getElementData(source, "char >> bankmoney")
        local ax, ay, rot = getElementRotation(source)    
        local skinid = getElementData(source, "char >> skin")
        local fightStyle = getElementData(source, "char >> fightStyle")
        local walkStyle = getElementData(source, "char >> walkStyle")
        local charname = getElementData(source, "char >> name")
        local health = getElementHealth(source)
        local armor = getPedArmor(source)
        local job = getElementData(source, "char >> job")
        local playedtime = getElementData(source, "char >> playedtime")
        local premiumPoints = getElementData(source, "char >> premiumPoints")
        local adminlevel = getElementData(source, "admin >> level")
        local adminduty = "false"
        local adminname = tostring(getElementData(source, "admin >> name"))
        local food = getElementData(source, "char >> food")
        local drink = getElementData(source, "char >> drink")
        local level = getElementData(source, "char >> level")
        local deathReason = getElementData(source, "deathReason") or "Unknown"
        local deathReasonAdmin = getElementData(source, "deathReason >> admin") or "Unknown"
        local deathReasons = toJSON({deathReason, deathReasonAdmin})
        local bones = getElementData(source, "char >> bone") or {true, true, true, true, true}
        local bone = toJSON(bones)
        local adutytime = getElementData(source, "admin >> time") or 0
        local rtc = getElementData(source, "rtc >> using") or 0
        local fix = getElementData(source, "fix >> using") or 0
        local fuel = getElementData(source, "fuel >> using") or 0
        local ban = getElementData(source, "ban >> using") or 0
        local jail = getElementData(source, "jail >> using") or 0
        local kick = getElementData(source, "kick >> using") or 0
        local radiofreki = getElementData(source,"char >> radiof");

        local skin = getElementModel(source);
        if getElementData(source,"duty.faction") then 
            skin = (getElementData(source,"char >> civilSkin") or 1);
        end

        local death = tostring(getElementData(source,"char >> dead") or false);

        local ajail = getElementData(source,"char >> adminJail");
        if ajail and ajail[1] then 
            position = toJSON({264.33465576172, 77.65731048584, 1001.0390625,6,100+getElementData(source,"acc >> id"),getZoneName(x,y,z)});
        end

        if adminlevel == 1 then
            adminlevel = 0;
        end

        local coins = getElementData(source,"Staff->Coin");

        dbExec(sql, "UPDATE `characters` SET `position`=?, `charname`=?, `health`=?, `armor`=?, `skinid`=?, `fightStyle`=?, `walkStyle`=?, `money`=?, `bankmoney`=?, `playedtime`=?, `premiumPoints`=?, `adminlevel`=?, `job`=?, `rot`=?, `adminduty`=?, `food`=?, `drink`=?, `level`=?, `adminname`=?, `deathReasons`=?, `bone`=?, `adutytime`=?, `rtc`=?, `fix`=?, `fuel`=?, `ban`=?, `jail`=?, `kick`=?, `radiofreki`=?, `skinid`=?, `death`=?, `coins`=? WHERE `id`=?", 
                                                position, charname, health, armor, skinid, fightStyle, walkStyle, money, bankmoney, playedtime, premiumPoints, adminlevel, job, rot, adminduty, food, drink, level, adminname, deathReasons, bone, adutytime, rtc, fix, fuel, ban, jail, kick,radiofreki,skin,death,coins, id)
        --outputDebugString("save -> " .. charname .. "("..id..") - saved succesfuly!", 0, 87,255,87)
    end
end