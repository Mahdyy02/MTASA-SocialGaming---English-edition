sql = exports.fv_engine:getConnection(getThisResource());
local jailPos = {264.33465576172, 77.65731048584, 1001.0390625};
local exitPos = {1448.0446777344, -1661.9300537109, 13.546875};

function adminJail(player,command,target,time,...)
    local playerAdminLevel = getElementData(player,"admin >> level") or 0;
    if (hasPermission(player, "ajail" )) or playerAdminLevel == -1 then 
        if not (target) or not time or not tonumber(time) or not ... then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").. "/".. command .. " [Name / ID] [Time] [Reason]", player,255,255,255,true ) return end
        local targetPlayer = exports['fv_engine']:findPlayer(player, target);
        if (targetPlayer) then
            if targetPlayer == player then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can't put yourself in jail!",player,255,255,255,true) return end;
            local reason = table.concat({...}, " ");
            local time = math.floor(tonumber(time));
            local cJail = getElementData(targetPlayer,"char >> adminJail");
            if cJail and cJail[1] == 1 then 
                outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is already in jail!",player,255,255,255,true);
                return;
            else 

                if isPedInVehicle(targetPlayer) then 
                    removePedFromVehicle(targetPlayer);
                end
                local adminName = (playerAdminLevel == -1 and "RP őr") or getAdminName(player,true);

                local datas = {
                    1,
                    adminName,
                    reason,
                    time,
                    time,
                    setTimer(function()
                                adminJailTimer(targetPlayer);
                            end,1000*60,1),
                    getElementData(player,"admin >> level"),
                    getAdminName(player,true),
                }
                setElementPosition(targetPlayer,unpack(jailPos));
                setElementInterior(targetPlayer,6);
                setElementDimension(targetPlayer,100+getElementData(targetPlayer,"acc >> id"));
                setElementData(targetPlayer,"char >> adminJail",datas);

                local saveTable = {
                    datas[1],
                    datas[2],
                    datas[3],
                    datas[4],
                    datas[5],
                    0,
                    datas[7],
                    datas[8],
                }
                dbExec(sql,"UPDATE characters SET adminjail=? WHERE id=?",toJSON(saveTable),getElementData(targetPlayer,"acc >> id"));
            
                local color = exports.fv_engine:getServerColor("red",true);
                local sColor = exports.fv_engine:getServerColor("servercolor",true);
                outputChatBox(color.."[AdminJail]: "..sColor..adminName..white.." adminjailbe put "..sColor..getElementData(targetPlayer,"char >> name")..white.." játékost.",root,255,255,255,true);
                outputChatBox(color.."[AdminJail]: "..white.."Time: "..sColor..time..white.." perc.",root,255,255,255,true);
                outputChatBox(color.."[AdminJail]: "..white.."Reason: "..sColor..reason..white..".",root,255,255,255,true);
                exports.fv_infobox:addNotification(root,"adminjail",adminName.."put into adminjail "..getElementData(targetPlayer,"char >> name").." player.","reason: "..reason.." Time: "..time.." perc");
                exports.fv_logs:createLog("AJAIL",adminName.." ("..getAdminName(player,true)..") adminjailbe rakta "..getAdminName(targetPlayer).." játékost. Idő: "..time.." Indok: "..reason);

                setElementData(player,"admin.jail",getElementData(player,"admin.jail") + 1);
                dbExec(sql,"UPDATE characters SET jail=? WHERE id=?",getElementData(player,"admin.jail"),getElementData(player,"acc >> id"));
            end
        end
    else
        noAdmin ( player, "ajail" );
    end
end
addCommandHandler("ajail",adminJail,false,false);

function unjailPlayer(player,command,target)
    local playerAdminLevel = getElementData(player,"admin >> level") or 0;
    if (hasPermission(player, "unjail" )) or playerAdminLevel == -1 then
        if not (target) then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").. "/".. command .. "[Partial name / ID]", player,255,255,255,true ) return end
        local targetPlayer = exports['fv_engine']:findPlayer(player, target);
        if (targetPlayer) then
            local data = getElementData(targetPlayer,"char >> adminJail");
            if data and data[1] == 1 then 
                local needLevel = data[7];
                if getElementData(player,"admin >> level") >= needLevel then 
                    if isTimer(data[6]) then 
                        killTimer(data[6]);
                    end
                    local adminName = (playerAdminLevel == -1 and "RP őr") or getAdminName(player,true);
                    setElementPosition(targetPlayer,unpack(exitPos));
                    setElementDimension(targetPlayer,0);
                    setElementInterior(targetPlayer,0);
                    setElementData(targetPlayer,"char >> adminJail",false);
                    local sColor = exports.fv_engine:getServerColor("servercolor",true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."You successfully took it out "..sColor..getElementData(targetPlayer,"char >> name")..white.." játékost az adminjailből.",player,255,255,255,true);
                    sendMessageToAdmin(player,sColor..adminName..white.." kivette "..sColor..getAdminName(targetPlayer)..white.." játékost az adminjailből!", 3)
                    exports.fv_logs:createLog("UNJAIL",adminName.." ("..getAdminName(player)..") kivette "..getAdminName(targetPlayer).." játékost az adminjailből!");
                    dbExec(sql,"UPDATE characters SET adminjail=? WHERE id=?",toJSON(false),getElementData(targetPlayer,"acc >> id"));
                    outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..sColor..adminName..white.." taken out of your admins!",targetPlayer,255,255,255,true);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."A senior admin put you in a prison, you can't take it out!",player,255,255,255,true);
                    return;
                end
            else 
                outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not in admins.",player,255,255,255,true);
                return;
            end
        end
    else 
        noAdmin ( player, "unjail" )
    end
end
addCommandHandler("unjail",unjailPlayer,false,false);

-- ZERO TOLERANCIA

--[[function asegit(targetPlayer)
    print(getPlayerName(targetPlayer))
            local x,y,z = unpack(getElementData(targetPlayer,"dead.pos"));
            spawnPlayer(targetPlayer,x,y,z,rot,(getElementData(targetPlayer,"dead.skin") or 1),getElementData(targetPlayer,"dead.interior"),getElementData(targetPlayer,"dead.dimension"));
            setCameraTarget(targetPlayer,targetPlayer);
            setElementData(targetPlayer,"char >> dead",false);
            setElementData(targetPlayer, "char >> bone", {true, true, true, true, true});
            setElementData(targetPlayer,"char >> food",100);
            setElementData(targetPlayer,"char >> drink",100);
            outputChatBox(exports.fv_engine:getServerSyntax("Death","red")..exports.fv_engine:getServerColor("servercolor",true).."Zéró tolerancia#FFFFFF felsegített téged! (ADMIN)",targetPlayer,255,255,255,true);
end

addEventHandler("onPlayerWasted",getRootElement(),function(ammo, attacker, weapon, bodypart)
    print("Duty:", getAdminInDuty())
    if getAdminInDuty() < 2 then
        if isElement(attacker) then
            asegit(source)
            
            goAdminjail(attacker, "Zéró tolerancia (Ölés)", 300)   
        end
        
    end
    
end);]]

function getAdminInDuty()
    local c = 0
    for k,v in pairs(getElementsByType("player")) do
        if getElementData(v,"admin >> duty") then
            c = c + 1
        end
    end
    print(c)
    return c
end

function goAdminjail(targetPlayer, reason, time)
    if isPedInVehicle(targetPlayer) then 
        removePedFromVehicle(targetPlayer);
    end
    local adminName = "Zéró Tolerancia"
    local time = tonumber(time)
    local datas = {
        1,
        adminName,
        reason,
        time,
        time,
        setTimer(function()
                    adminJailTimer(targetPlayer);
                end,1000*60,1),
        7,
        "Zeró Tolerancia",
    }
    setElementPosition(targetPlayer,unpack(jailPos));
    setElementInterior(targetPlayer,6);
    setElementDimension(targetPlayer,100+getElementData(targetPlayer,"acc >> id"));
    setElementData(targetPlayer,"char >> adminJail",datas);

    local saveTable = {
        datas[1],
        datas[2],
        datas[3],
        datas[4],
        datas[5],
        0,
        datas[7],
        datas[8],
    }
    dbExec(sql,"UPDATE characters SET adminjail=? WHERE id=?",toJSON(saveTable),getElementData(targetPlayer,"acc >> id"));

    local color = exports.fv_engine:getServerColor("red",true);
    local sColor = exports.fv_engine:getServerColor("servercolor",true);
    outputChatBox(color.."[AdminJail]: "..sColor..adminName..white.." put into adminjail "..sColor..getElementData(targetPlayer,"char >> name")..white.." játékost.",root,255,255,255,true);
    outputChatBox(color.."[AdminJail]: "..white.."Time: "..sColor..time..white.." perc.",root,255,255,255,true);
    outputChatBox(color.."[AdminJail]: "..white.."cause: "..sColor..reason..white..".",root,255,255,255,true);
    exports.fv_infobox:addNotification(root,"adminjail",adminName.." put into adminjail "..getElementData(targetPlayer,"char >> name").." player.","Reason: "..reason.." Time: "..time.." perc");
    exports.fv_logs:createLog("AJAIL",adminName.." ("..getAdminName(player,true)..") adminjailbe rakta "..getAdminName(targetPlayer).." játékost. Idő: "..time.." Indok: "..reason);
end





function adminJailTimer(player)
    if isElement(player) then 
        local jailData = getElementData(player,"char >> adminJail");
        if jailData and jailData[1] == 1 then 
            if jailData[4]-1 <= 0 then 
                setElementPosition(player,unpack(exitPos));
                setElementDimension(player,0);
                setElementInterior(player,0);

                setElementData(player,"char >> adminJail",false);

                dbExec(sql,"UPDATE characters SET adminjail=? WHERE id=?",toJSON(false),getElementData(player,"acc >> id"));

                outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."You got rid of your admins, next time try to get the right gameplay.",player,255,255,255,true);
            else 
                setElementPosition(player,unpack(jailPos));
                setElementInterior(player,6);
                setElementDimension(player,100+getElementData(player,"acc >> id"));
                jailData[4] = jailData[4] - 1;
                jailData[6] = setTimer(function()
                                adminJailTimer(player);
                            end,1000*60,1);

                local saveTable = {
                    jailData[1],
                    jailData[2],
                    jailData[3],
                    jailData[4],
                    jailData[5],
                    0,
                    jailData[7],
                    jailData[8],
                }
                dbExec(sql,"UPDATE characters SET adminjail=? WHERE id=?",toJSON(saveTable),getElementData(player,"acc >> id"));

                setElementData(player,"char >> adminJail",jailData);
            end
        end
    end
end

function offlineAdminjail(player,command,target,time,...)
	if not hasPermission(player, "ojail") then noAdmin(player, "ojail") return end
	if not (...) then outputChatBox( exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [character name (_ with line)] [time] [reason]",player, 255,255,255,true) return end
	local reason = table.concat({...}, " ");
	dbQuery(function(qh)
		local res = dbPoll(qh,0);
		if #res > 0 then 
			for k,v in pairs(res) do 
				local ajail = fromJSON(v.adminjail);
				if ajail and ajail[1] then 
					outputChatBox( exports.fv_engine:getServerSyntax("Admin","red").."Player is already in admins!",player, 255,255,255,true)
					return;
				else 
					local datas = {
						1,
						getAdminName(player,true),
						reason,
						time,
						time,
						0,
                        getElementData(player,"admin >> level"),
                        getAdminName(player,true),
					}
					dbExec(sql,"UPDATE characters SET adminjail=?, position=? WHERE id=?",toJSON(datas),toJSON({jailPos[1],jailPos[2],jailPos[3],6,(math.random(100,3000))}),v.id);

					local color = exports.fv_engine:getServerColor("red",true);
					local sColor = exports.fv_engine:getServerColor("servercolor",true);
					outputChatBox(color.."[OfflineJail]: "..sColor..getAdminName(player,true)..white.." put into adminjail "..sColor..v.charname..white.." játékost.",root,255,255,255,true);
					outputChatBox(color.."[OfflineJail]: "..white.."Time: "..sColor..time..white.." perc.",root,255,255,255,true);
					outputChatBox(color.."[OfflineJail]: "..white.."Reason: "..sColor..reason..white..".",root,255,255,255,true);
                    exports.fv_logs:createLog("OfflineJAIL",getAdminName(player).." adminjailbe rakta "..v.charname.." játékost. Idő: "..time.." Indok: "..reason);
                    
                    setElementData(player,"admin.jail",getElementData(player,"admin.jail") + 1);
                    dbExec(sql,"UPDATE characters SET jail=? WHERE id=?",getElementData(player,"admin.jail"),getElementData(player,"acc >> id"));
				end
			end
		else 
			outputChatBox( exports.fv_engine:getServerSyntax("Admin","red").."No characters with the specified value.",player, 255,255,255,true)
			return;
		end
	end,sql,"SELECT * FROM characters WHERE charname=?",tostring(target:gsub("_"," ")),time,...);
end
addCommandHandler("ojail",offlineAdminjail,false,false);

function getJailedPlayers(player,command)
    if not hasPermission(player, "jailed") then noAdmin(player, "jailed") return end
    local sColor = exports.fv_engine:getServerColor("servercolor",true);
    local red = exports.fv_engine:getServerColor("red",true);
    outputChatBox("------"..red.."Imprisoned Players"..white.."------",player,255,255,255,true);
    local count = 0;
    local all = 0;
    for k,v in pairs(getElementsByType("player")) do 
        local data = getElementData(v,"char >> adminJail");
        if data and data[1] == 1 then 
            outputChatBox(" ~ ID: "..sColor..getElementData(v,"char >> id")..white.." | "..sColor..getElementData(v,"char >> name")..white.." | Time: "..sColor..data[5]..white.." perc | Hátralévő idő: "..sColor..data[4]..white.." perc | Indok: "..sColor..data[3]..white.." | ADMIN: "..sColor..data[2]..white..".",player,255,255,255,true);
            count = count + 1;
        end
        all = all + 1;
    end
    if count == 0 then 
        outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."There is no player in prison!",player,255,255,255,true);
    end
    if count > 0 then 
        outputChatBox(sColor.."~~"..white.."Altogether: "..sColor..count..white.." / "..all,player,255,255,255,true);
    end
end
addCommandHandler("jailed",getJailedPlayers);

addEvent("adminjail.start",true);
addEventHandler("adminjail.start",root,function(player,value)
    value[6] = setTimer(function()
                    adminJailTimer(player);
                end,1000*60,1);
    setElementPosition(player,unpack(jailPos));
    setElementInterior(player,6);
    setElementDimension(player,100+getElementData(player,"acc >> id"));
    setElementData(player,"char >> adminJail",value);
end);
