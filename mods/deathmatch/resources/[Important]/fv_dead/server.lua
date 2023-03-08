local sql = exports.fv_engine:getConnection(getThisResource());

local x,y,z,rot = 832.3173828125, -1101.7918701172, 24.296875,270 --Respawn Pos

local boneNames = {
    [3] = "Upper body",
    [4] = "Ass",
    [5] = "Force tax",
    [6] = "Arm",
    [7] = "Left leg",
    [8] = "Right leg",
    [9] = "Headshot",
}

local illegalItems = {14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37}


addEvent("dead.respawn",true);
addEventHandler("dead.respawn",root,function(player)
    spawnPlayer(player,x,y,z,rot,(getElementData(player,"dead.skin") or 1),0,0)
    setCameraTarget(player,player);
    setElementData(player,"char >> dead",false);
    setElementData(player,"char >> food",100);
    setElementData(player,"char >> drink",100);
    setElementData(player, "char >> bone", {true, true, true, true, true});

    local takeString = ""
    local takedItems = 0
    for k, v in pairs(illegalItems) do
        if exports.fv_inventory:hasItem(player,v) then
            exports.fv_inventory:takePlayerItem(player, v)
            takeString = takeString .. exports.fv_inventory:getItemName(v) .. ", "
            takedItems = takedItems + 1
        end
    end

    if takedItems > 0 then
        outputChatBox(exports.fv_engine:getServerSyntax("Death","red") .. "We took the following illegal items from you:", player, 0, 0, 0, true)
        outputChatBox(exports.fv_engine:getServerSyntax("Death","red") .. takeString, player, 0, 0, 0, true)
    end

    dbExec(sql,"UPDATE characters SET death=?, bone=? WHERE id=?",tostring(false),toJSON(getElementData(player,"char >> bone")),getElementData(player,"acc >> id"));
end);

addEventHandler("onPlayerWasted",getRootElement(),function(ammo, attacker, weapon, bodypart)
    local accid = getElementData(source,"acc >> id");
    if accid and accid > 0 then 
        dbExec(sql,"UPDATE characters SET death=? WHERE id=?",tostring(true),accid);

        if isElement(attacker) then 
            if getElementType(attacker) == "player" then 
                attacker = getElementData(attacker,"char >> name") or "Ismeretlen";
            elseif getElementType(attacker) == "vehicle" then 
                attacker = "Elütötték";
            else
                attacker = "Ismeretlen";
            end
        else 
            attacker = "Ismeretlen";
        end

        --if isElement(attacker) then 
            for k,v in pairs(getElementsByType("player")) do
                if getElementData(v,"loggedIn") and (getElementData(v,"admin >> level") or 0) > 2 then --ADMIN 1 től
                    outputChatBox("[KILL-LOG]: "..attacker.. " killed "..getElementData(source,"char >> name").. " player. Weapon: "..(getWeaponNameFromID(weapon) or "Nincs").." Helyszín: "..getZoneName(getElementPosition(source)).." Testrész: "..(boneNames[bodypart] or "Ismeretlen")..".",v,210,210,210,true);
                end
            end
            exports.fv_logs:createLog("KILL",attacker.." killed "..getElementData(source,"char >> name").. " player. Weapon: "..(getWeaponNameFromID(weapon) or "Nincs").." Helyszín: "..getZoneName(getElementPosition(source)).." Testrész: "..(boneNames[bodypart] or "Ismeretlen")..".",source);
        --end

        
    end
end);


addEventHandler("onElementDataChange",getRootElement(),function(dataName) --Check on Login
    if getElementType(source) == "player" then 
        local accid = getElementData(source,"acc >> id");
        if accid and accid > 0 then 
            if dataName == "loggedIn" then 
                if getElementData(source,"loggedIn") then 
                    local player = source;
                    dbQuery(function(qh)
                        local res = dbPoll(qh,0);
                        for k,v in pairs(res) do 
                            local dead = false;
                            if tostring(v.death) == "true" then 
                                dead = true;
                            end
                            if dead then 
                                setElementData(player,"char >> dead",true);
                                triggerClientEvent(player,"dead.startClient",player,player);
                            end
                        end
                    end,sql,"SELECT death FROM characters WHERE id=?",accid);
                end
            end
        end
    end
end);

addEventHandler("onPlayerQuit",getRootElement(),function() --Death save on quit
    local accid = getElementData(source,"acc >> id");
    if accid and accid > 0 then 
        if getElementData(source,"char >> dead") or isPedDead(source) then 
            dbExec(sql,"UPDATE characters SET death=? WHERE id=?",tostring(true),accid);
        else 
            dbExec(sql,"UPDATE characters SET death=? WHERE id=?",tostring(false),accid);
        end
    end
end);


--Parancsok--
function respawnByAdmin(player,cmd,target)
    if getElementData(player,"admin >> level") > 2 then 
        if not target then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [Name/ID]",player,255,255,255,true) return end;
        local targetPlayer = exports.fv_engine:findPlayer(player,target);
        if targetPlayer then 
            if not getElementData(targetPlayer,"char >> dead") or not isPedDead(targetPlayer) then outputChatBox(exports.fv_engine:getServerSyntax("Death","red").."Játékos nem halott!",player,255,255,255,true) return end;
            local x,y,z = unpack(getElementData(targetPlayer,"dead.pos"));
            spawnPlayer(targetPlayer,x,y,z,rot,(getElementData(targetPlayer,"dead.skin") or 1),getElementData(targetPlayer,"dead.interior"),getElementData(targetPlayer,"dead.dimension"));
            setCameraTarget(targetPlayer,targetPlayer);
            setElementData(targetPlayer,"char >> dead",false);
            setElementData(targetPlayer, "char >> bone", {true, true, true, true, true});
            setElementData(targetPlayer,"char >> food",100);
            setElementData(targetPlayer,"char >> drink",100);
            outputChatBox(exports.fv_engine:getServerSyntax("Death","green").."You have successfully helped the player!",player,255,255,255,true);
            outputChatBox(exports.fv_engine:getServerSyntax("Death","red")..exports.fv_engine:getServerColor("servercolor",true)..getElementData(player,"admin >> name").."#FFFFFF helped you (ADMIN)",targetPlayer,255,255,255,true);

            local sColor = exports.fv_engine:getServerColor("servercolor",true);
            local white = "#FFFFFF";
            exports.fv_logs:createLog("ASEGIT",exports.fv_admin:getAdminName(player).. " helped a player:  "..(getElementData(targetPlayer,"char >> name"):gsub("_"," "))..".",player);
            exports.fv_admin:sendMessageToAdmin(player,sColor..getElementData(player,"admin >> name")..white.." helped a player:  "..sColor..(getElementData(targetPlayer,"char >> name"):gsub("_"," "))..white..".",3);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Death","red").."Player not found!",player,255,255,255,true);
        end
    end
end
addCommandHandler("revive",respawnByAdmin,false,false);

function respawnAllByAdmin(player, cmd)
	if getElementData(player,"admin >> level") > 5 then 
		for k, v in pairs(getElementsByType("player")) do
			if (getElementData(v, "loggedIn")) then
				respawnByAdmin(player, cmd, getElementData(v, "char >> name"));
			end
		end
		
		 exports.fv_admin:sendMessageToAdmin(player,sColor..getElementData(player,"admin >> name")..white.." helped everyone.",3);
	end
end
addCommandHandler("reviveall", respawnAllByAdmin, false, false);