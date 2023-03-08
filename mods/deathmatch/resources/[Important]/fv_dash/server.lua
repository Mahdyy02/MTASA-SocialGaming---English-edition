sql = exports.fv_engine:getConnection(getThisResource());
factions = {};
factionMembers = {};

addCommandHandler("dashfix",function(player,cmd,target)
    if getElementData(player,"admin >> level") > 7 then 
        if not target then 
            return outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [Name/ID]",player,255,255,255,true);
        end
        local targetPlayer = exports.fv_engine:findPlayer(player,target);
        if targetPlayer then 
            triggerClientEvent(targetPlayer,"dash.fix",targetPlayer);
            outputChatBox(exports.fv_engine:getServerSyntax("Dash","servercolor").."Fixed.",player,255,255,255,true);
        else 
            return outputChatBox(exports.fv_engine:getServerSyntax("Dash","red").."There is no such player!",player,255,255,255,true);
        end
    end
end);


addEventHandler("onResourceStart",getRootElement(),function(res)
    if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        sColor = {exports.fv_engine:getServerColor("servercolor",false)};
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
        red = {exports.fv_engine:getServerColor("red",false)};
        red2 = exports.fv_engine:getServerColor("red",true);
        green = {exports.fv_engine:getServerColor("green",false)};
        orange = {exports.fv_engine:getServerColor("orange",false)};
    end
    if res == getThisResource() then 
        for k,v in pairs(getElementsByType("player")) do 
            if getElementData(v,"loggedIn") then 
                loadPayTime(v);
            end
        end
    end
end);

addEventHandler("onElementDataChange",getRootElement(),function(dataName)
    if getElementType(source) == "player" then 
        if dataName == "loggedIn" then 
            if getElementData(source,"loggedIn") then 
                refreshFactionMembers(source);
                getPlayerFactions(source);
                loadPayTime(source);
                outputDebugString(getPlayerName(source).." retrieve entered freaks!");
            end
        end
    end
end);

function loadPayTime(player)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        if res then 
            for k,v in pairs(res) do 
                setElementData(player,"char.payTime",tonumber(v.payTime) or 3600);
            end
        end
    end,sql,"SELECT id,payTime FROM characters WHERE id=?",getElementData(player,"acc >> id"));
end
addEventHandler("onPlayerQuit",root,function()
    if getElementData(source,"loggedIn") then 
        dbExec(sql,"UPDATE characters SET payTime=? WHERE id=?",(getElementData(source,"char.payTime") or 3600),getElementData(source,"acc >> id"));
    end
end);
addEventHandler("onResourceStop",resourceRoot,function()
    for _, player in pairs(getElementsByType("player")) do 
        if getElementData(player,"loggedIn") then 
            dbExec(sql,"UPDATE characters SET payTime=? WHERE id=?",(getElementData(player,"char.payTime") or 3600),getElementData(player,"acc >> id"));
        end
    end
end);

addEvent("dash > vehSlotBuy",true);
addEventHandler("dash > vehSlotBuy",root,function(player)
    setElementData(player,"char >> premiumPoints",getElementData(player,"char >> premiumPoints") - 200);
    setElementData(player,"char >> vehSlot", getElementData(player,"char >> vehSlot") + 1);
    exports.fv_infobox:addNotification(player,"success","Successful slot purchase!");
    dbExec(sql,"UPDATE characters SET vehSlot=?, premiumPoints=? WHERE id=?",getElementData(player,"char >> vehSlot"),getElementData(player,"char >> premiumPoints"),getElementData(player,"acc >> id"));
end);

addEvent("dash > intSlotBuy",true);
addEventHandler("dash > intSlotBuy",root,function(player)
    setElementData(player,"char >> premiumPoints",getElementData(player,"char >> premiumPoints") - 200);
    setElementData(player,"char >> intSlot", getElementData(player,"char >> intSlot") + 1);
    exports.fv_infobox:addNotification(player,"success","Successful slot purchase!");
    dbExec(sql,"UPDATE characters SET intSlot=?, premiumPoints=? WHERE id=?",getElementData(player,"char >> intSlot"),getElementData(player,"char >> premiumPoints"),getElementData(player,"acc >> id"));
end);

addEvent("dash > updateLeaderSay",true)
addEventHandler("dash > updateLeaderSay",root,function(player,faction,text)
    factions[faction][5] = text;
    dbExec(sql,"UPDATE factions SET lmessage=? WHERE id=?",text,faction);
    exports.fv_infobox:addNotification(player,"success","You have successfully set the leader message!");
end);

--Faction Account--
addEvent("factionbank.give",true);
addEventHandler("factionbank.give",root,function(player,id,amount)
    if factions[id] then 
        local adoki = math.floor((amount/100));
        factions[id][3] = factions[id][3] + (amount-adoki);
        setElementData(player,"char >> money",getElementData(player,"char >> money") - amount);
        dbExec(sql,"UPDATE factions SET vallet=? WHERE id=?",factions[id][3],id);
        for k,v in pairs(getElementsByType("player")) do 
            if getElementData(v,"faction_"..id) then 
                getPlayerFactions(v);
            end
        end
        outputChatBox(exports.fv_engine:getServerSyntax("Faction Account","servercolor").."You have successfully paid: "..exports.fv_engine:getServerColor("servercolor",true)..formatMoney(amount-adoki)..white.. " dt "..exports.fv_engine:getServerColor("red",true).." (Tax: "..adoki.." dt)",player,255,255,255,true);
        exports.fv_logs:createLog("FACTION",getElementData(player,"char >> name").." paid "..factions[id][1].." account "..amount.." dt",playerSource,targetPlayer);
    end
end);
addEvent("factionbank.out",true);
addEventHandler("factionbank.out",root,function(player,id,amount)
    if factions[id] then 
        local adoki = math.floor((amount/100));
        setElementData(player,"char >> money",getElementData(player,"char >> money")+(amount-adoki));
        factions[id][3] = factions[id][3] - amount;
        dbExec(sql,"UPDATE factions SET vallet=? WHERE id=?",factions[id][3],id);
        for k,v in pairs(getElementsByType("player")) do 
            if getElementData(v,"faction_"..id) then 
                getPlayerFactions(v);
            end
        end
        outputChatBox(exports.fv_engine:getServerSyntax("Faction Account","servercolor").."You have successfully withdrawn: "..exports.fv_engine:getServerColor("servercolor",true)..formatMoney(amount-adoki)..white.. " dt "..exports.fv_engine:getServerColor("red",true).." (Tax: "..adoki.." dt)",player,255,255,255,true);
        exports.fv_logs:createLog("Faction Account_KI",getElementData(player,"char >> name").." took "..factions[id][1].." account "..amount.." dt",playerSource,targetPlayer);
    end
end);
----------------



function getPlayerFactions(player)
    triggerClientEvent("dash > sendFactionDatas",player,factions,factionMembers);
    -- dbQuery(function(qh)
    --     local members = {}
    --     local result = dbPoll(qh,0);
    --     for k,v in pairs(factions) do 
    --         members[k] = {};
    --     end
    --     if result then 
    --         for k,v in pairs(result) do 
    --             local id = v.faction;
	-- 			if not(members[id]) then members[id] = {} end
    --             local leader = false;
    --             if v.leader == 1 then 
    --                 leader = true;
    --             end
    --             if v.rank > 15 then 
    --                 v.rank = 15;
    --                 dbExec(sql,"UPDATE playerFactions SET rank=? WHERE dbid=?",v.rank,v.dbid);
    --             end
    --             members[id][#members[id] + 1] = {v.dbid,v.rank,v.leader,v.dutyskin,checkOnline(v.dbid),v.charname:gsub("_"," "),v.lastlogin:gsub("-",".")}
    --             if v.dbid == getElementData(player,"acc >> id") then 
    --                 setElementData(player,"faction_"..id,true);
    --                 setElementData(player,"faction_"..id.."_rank",v.rank);
    --                 setElementData(player,"faction_"..id.."_leader",leader);
    --                 setElementData(player,"faction_"..id.."_dutyskin",v.dutyskin);
    --             end
    --         end
    --         triggerClientEvent(player,"dash > sendFactionDatas",player,factions,members)
    --     end
    -- -- end,sql,"SELECT playerFactions.id AS id, playerFactions.faction AS faction, playerFactions.dbid AS dbid, playerFactions.rank AS rank, playerFactions.leader AS leader, playerFactions.dutyskin AS dutyskin, characters.charname AS charname, accounts.lastlogin AS lastlogin FROM accounts, playerFactions LEFT JOIN characters ON characters.id=playerFactions.dbid WHERE accounts.id=characters.id");
    -- end,sql,"SELECT * FROM playerFactions, accounts, characters WHERE accounts.id=playerFactions.dbid AND characters.id=playerFactions.dbid");
end

addEvent("dash > getFactions",true);
addEventHandler("dash > getFactions",root,function(player) --Kliens oldalról hívja meg ha megnyitja a dash-t
    getPlayerFactions(player);
     --Help check.
    local accid = getElementData(player,"acc >> id");
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        if res and #res > 0 then 
            local jelenPP = getElementData(player,"char >> premiumPoints");
            for k,v in pairs(res) do 
                if v.premiumPoints > jelenPP then 
                    setElementData(player,"char >> premiumPoints",v.premiumPoints);
                    outputChatBox(exports.fv_engine:getServerSyntax("Help","servercolor").."You have successfully supported the server! Thank You!",player,255,255,255,true);
                    exports.fv_infobox:addNotification(player,"success", "You have successfully supported the server! Thank You!");
                end
            end
        end
    end,sql,"SELECT id,premiumPoints FROM characters WHERE id=?",accid);
end); 

function loadFaction(id)
    factions[id] = {};
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        if result then 
            for k,v in pairs(result) do 
                factions[v.id] = {v.name,v.type,tonumber(v.vallet),fromJSON(v.ranks),v.lmessage}
            end
        end
    end,sql,"SELECT * FROM factions WHERE id=?",id);

    factionMembers[id] = {};
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        for k,v in pairs(result) do 
            factionMembers[id][#factionMembers[id] + 1] = {v.dbid,v.rank,v.leader,v.dutyskin,checkOnline(v.dbid),v.charname:gsub("_"," "),v.lastlogin:gsub("-",".")};
        end
    end,sql,"SELECT playerfactions.*, characters.charname, accounts.lastlogin FROM playerfactions, accounts, characters WHERE accounts.id=playerfactions.dbid AND characters.id=playerfactions.dbid AND playerfactions.faction=?",id);
    return true;
end

addEventHandler("onResourceStart",resourceRoot,function()
    factions = {};
    local tick = getTickCount();
    dbQuery(function(qh)
        local loaded = 0;
        local result,all = dbPoll(qh,0);
        for k,v in pairs(result) do 
            factions[v.id] = {v.name,v.type,tonumber(v.vallet),fromJSON(v.ranks),v.lmessage};
            loaded = loaded + 1;
        end
        outputDebugString("Factions: "..loaded.." / "..all.." loaded in "..(getTickCount()-tick).."ms!",0,0,100,200);
    end,sql,"SELECT * FROM factions");

    refreshFactionMembers(getElementsByType("player"));
end);

function refreshFactionMembers(player)
    factionMembers = {};
    dbQuery(function(qh,player)
        local result = dbPoll(qh,0);
        for k,v in pairs(result) do 
            if not factionMembers[v.faction] then factionMembers[v.faction] = {} end;
            local factionID = v["faction"];
            local leader = false;
            if v["leader"] == 1 then 
                leader = true;
            end
            factionMembers[factionID][#factionMembers[factionID] + 1] = {v.dbid,v.rank,v.leader,v.dutyskin,checkOnline(v.dbid),v.charname:gsub("_"," "),v.lastlogin:gsub("-",".")};
            if player then 
                if type(player) == "table" then 
                    for _, element in pairs(player) do 
                        if element and isElement(element) then 
                            if getElementData(element,"loggedIn") then 
                                if v.dbid == getElementData(element,"acc >> id") then 
                                    setElementData(element,"faction_"..factionID,true);
                                    setElementData(element,"faction_"..factionID.."_rank",v["rank"]);
                                    setElementData(element,"faction_"..factionID.."_leader",leader);
                                    setElementData(element,"faction_"..factionID.."_dutyskin",v["dutyskin"]);
                                end
                            end
                        end
                    end
                elseif isElement(player) then 
                    if v.dbid == getElementData(player,"acc >> id") then
                        setElementData(player,"faction_"..factionID,true);
                        setElementData(player,"faction_"..factionID.."_rank",v["rank"]);
                        setElementData(player,"faction_"..factionID.."_leader",leader);
                        setElementData(player,"faction_"..factionID.."_dutyskin",v["dutyskin"]);
                    end
                end
            end
        end
    end,{player},sql,"SELECT playerfactions.*, characters.charname, accounts.lastlogin FROM playerfactions, accounts, characters WHERE accounts.id=playerfactions.dbid AND characters.id=playerfactions.dbid");
end

function findFactionMembers(fid,dbid)
    local found = false;
    if factionMembers[fid] then 
        for k,v in pairs(factionMembers[fid]) do 
            if v[1] == dbid then 
                found = k;
                break;
            end
        end
    end
    return found;
end

function giveFactionMoney(fid,money) 
    if factions[fid] then 
        factions[fid][3] = factions[fid][3] + money;
        dbExec(sql,"UPDATE factions SET vallet=? WHERE id=?",factions[fid][3],fid);
    end
end
function getFactionName(fid)
    if factions[fid] then 
        return factions[fid][1];
    else 
        return "Unknown faction";
    end
end

function checkOnline(dbid)
    local found = false;
    for k,v in pairs(getElementsByType("player")) do 
        if dbid == getElementData(v,"acc >> id") then 
            found = v;
        end
    end
    if isElement(found) then 
        return true,found;
    else 
        return false;
    end
end

function sendAdminMessage(msg)
    local color = exports.fv_engine:getServerColor("red",true);
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"loggedIn") then 
            if getElementData(v,"admin >> level") > 2 and getElementData(v,"admin >> duty") then 
                outputChatBox(color.."[ADMINLOG]: "..white.." "..msg,v,255,255,255,true);
            end
        end
    end
end

--Kliens oldali gombok funkciói--
addEvent("dash > playerRankChange",true);
addEventHandler("dash > playerRankChange",root,function(player,fid,table)
    local dbid = table[1];
    local rank = table[2];
    local online,target = checkOnline(dbid);
    if online then 
        setElementData(target,"faction_"..fid.."_rank",rank);
    end
    factionMembers[fid][findFactionMembers(fid,dbid)] = table;
    dbExec(sql,"UPDATE playerfactions SET rank=? WHERE faction=? AND dbid=?",rank,fid,dbid);
    exports.fv_infobox:addNotification(player,"success", "Successful rank change.");
end);
addEvent("dash > kickPlayer",true);
addEventHandler("dash > kickPlayer",root,function(player,fid,temp)
    local dbid = temp[1];
    local online,target = checkOnline(dbid);
    if online then 
        setElementData(target,"faction_"..fid,false);
        setElementData(target,"faction_"..fid.."_leader",false);
        setElementData(target,"faction_"..fid.."_rank",false);
        setElementData(target,"faction_"..fid.."_dutyskin",false);
    end
    dbExec(sql,"DELETE FROM playerfactions WHERE faction=? AND dbid=?",fid,dbid);
    table.remove(factionMembers[fid],findFactionMembers(fid,dbid));
    getPlayerFactions(player);
end);
addEvent("dash > setLeaderState",true);
addEventHandler("dash > setLeaderState",root,function(player,state,fid,table)
    local dbid = table[1];
    local online,target = checkOnline(dbid);
    if online then 
        setElementData(target,"faction_"..fid.."_leader",state);
    end
    factionMembers[fid][findFactionMembers(fid,dbid)][3] = state;
    dbExec(sql,"UPDATE playerfactions SET leader=? WHERE faction=? AND dbid=?",state,fid,dbid);
    exports.fv_infobox:addNotification(player,"success", "Successful leader law change.");
    getPlayerFactions(player)
end);
addEvent("dash > addNewMember",true);
addEventHandler("dash > addNewMember",root,function(player,fid,target)
    local targetPlayer,targetPlayerName = exports.fv_engine:findPlayer(player,target);
    if targetPlayer then 
        if not getElementData(targetPlayer,"loggedIn") then exports.fv_infobox:addNotification(player,"error", "Player is not logged in!") return end;
        if getElementData(targetPlayer,"faction_"..fid) then exports.fv_infobox:addNotification(player,"error", "Player is already a member of the faction!") return end;
        local dbid = getElementData(targetPlayer,"acc >> id");
        dbExec(sql,"INSERT INTO playerfactions SET dbid=?, faction=?",dbid,fid);
        refreshFactionMembers(targetPlayer);

        getPlayerFactions(player);
        getPlayerFactions(targetPlayer);
        exports.fv_infobox:addNotification(player,"success", "Player recruited successfully!");
    else 
        exports.fv_infobox:addNotification(player,"error", "Player not found!");
    end
end);
addEvent("dash > rankNameSave",true);
addEventHandler("dash > rankNameSave",root,function(player,fid,rank,text)
    factions[fid][4][rank][1] = text;
    dbExec(sql,"UPDATE factions SET ranks=? WHERE id=?",toJSON(factions[fid][4]),fid);
    exports.fv_infobox:addNotification(player,"success", "Rank Edited successfully!");
end);
addEvent("dash > rankPaySave",true);
addEventHandler("dash > rankPaySave",root,function(player,fid,rank,text)
    factions[fid][4][rank][2] = text;
    dbExec(sql,"UPDATE factions SET ranks=? WHERE id=?",toJSON(factions[fid][4]),fid);
    exports.fv_infobox:addNotification(player,"success", "Rank Edited successfully!");
end);
----------------------------------------

--Parancsok--
function addFactionByAdmin(player,command,type,...)   
    if getElementData(player,"admin >> level") > 6 then 
        if not (...) or not type then
            outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [type] [name of faction]",player,255,255,255,true)
            outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."Types: 1-Gang, 2-Mafia, 3-Law Enforcement, 4-Local Government, 5-Other",player,255,255,255,true)
            return;
        end
        local type = math.floor(tonumber(type));
        local name = table.concat({...}," ")
        if type then 
            if type > 0 and type <= #ftypes then 
                local ranks = {}
                for i=1,15 do 
                    ranks[i] = {"Rang_"..i,1};
                end
                ranks = toJSON(ranks);
                local q = dbQuery(function(qh) 
                    local result,_,id = dbPoll(qh,0);
                    if id > 0 then 
                        if loadFaction(id) then 
                            outputChatBox(exports.fv_engine:getServerSyntax("faction","servercolor").."Successful faction creation. ("..name..")",player,255,255,255,true);
                            sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." created a faction. ("..sColor2..name..white..")");
                        else  
                            outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."Failed to create faction!",player,255,255,255,true);
                        end
                    end            
                end,sql,"INSERT INTO factions SET name=?, type=?, ranks=?",name,type,ranks);
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [type] [name of faction]",player,255,255,255,true);
            return;
        end
   end
end
addCommandHandler("makefaction",addFactionByAdmin,false,false);
addCommandHandler("addfaction",addFactionByAdmin,false,false);

function addPlayerToFactionByAdmin(player,command,fid,...)
    if getElementData(player,"admin >> level") > 6 then 
        if not fid or not ... then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [faction id] [id/name]",player,255,255,255,true) return end;
        local fid = math.floor(tonumber(fid));
        if fid then 
            if not factions[fid] then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."Specified faction not found.",player,255,255,255,true) return end;
            local name = table.concat({...},"");
            local targetPlayer,targetPlayerName = exports.fv_engine:findPlayer(player,name);
            if targetPlayer then 
                if getElementData(targetPlayer,"faction_"..fid) then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."Player is already a member of the faction!",player,255,255,256,true) return end;
                local save = dbExec(sql,"INSERT INTO playerfactions SET dbid=?, faction=?",getElementData(targetPlayer,"acc >> id"),fid);
                if save then 
                    refreshFactionMembers(targetPlayer);
                    -- getPlayerFactions(targetPlayer);
                    outputChatBox(exports.fv_engine:getServerSyntax("faction","servercolor").."Player successfully added to faction. ("..factions[fid][1]..")",player,255,255,255,true);
                    sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." added "..sColor2..getElementData(targetPlayer,"char >> name")..white.. " player to a faction. ("..sColor2..factions[fid][1]..white..")");
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."A player cannot be placed in a faction!",player,255,255,255,true);
                    return;
                end
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [faction id] [id/name]",player,255,255,255,true);
            return;
        end
   end
end 
addCommandHandler("setfaction",addPlayerToFactionByAdmin,false,false);
addCommandHandler("setplayerfaction",addPlayerToFactionByAdmin,false,false);
addCommandHandler("addplayerfaction",addPlayerToFactionByAdmin,false,false);

function setPlayerToFactionLeaderByAdmin(player,command,fid,leader,...)
    if getElementData(player,"admin >> level") > 6 then 
        if not fid or not leader or not ... then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [faction id] [leader 0/1] [player]",player,255,255,255,true) return end;
        local leader = math.floor(tonumber(leader));
        local fid = math.floor(tonumber(fid));
        local target = table.concat({...},"");
        if fid and leader then 
            local targetPlayer,targetPlayerName = exports.fv_engine:findPlayer(player,target);
            if targetPlayer then 
                local isLeader = getElementData(targetPlayer,"faction_"..fid.."_leader");
                if leader == 1 then 
                    if not getElementData(targetPlayer,"faction_"..fid) then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."Player is not a member of the faction",player,255,255,255,true) return end;
                    if isLeader then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."Player is already a leader in the faction",player,255,255,255,true) return end;
                    dbExec(sql,"UPDATE playerfactions SET leader=? WHERE dbid=? AND faction=?",1,getElementData(targetPlayer,"acc >> id"),fid);
                    -- getPlayerFactions(targetPlayer);
                    refreshFactionMembers(targetPlayer);
                    outputChatBox(exports.fv_engine:getServerSyntax("faction","servercolor").."Leader right successfully given to the player!",player,255,255,255,true);
                    sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." leader granted the right "..sColor2..getElementData(targetPlayer,"char >> name")..white.. " player. faction:"..sColor2..factions[fid][1]..white..".");
                elseif leader == 0 then 
                    if not getElementData(targetPlayer,"faction_"..fid) then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."Player is not a member of the faction",player,255,255,255,true) return end;
                    if not isLeader then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."Player was not a leader, so there was nothing to take.",player,255,255,255,true) return end;
                    dbExec(sql,"UPDATE playerfactions SET leader=? WHERE dbid=? AND faction=?",0,getElementData(targetPlayer,"acc >> id"),fid);
                    -- getPlayerFactions(targetPlayer);
                    refreshFactionMembers(targetPlayer);
                    outputChatBox(exports.fv_engine:getServerSyntax("faction","servercolor").."Leader rights have been successfully taken away.",player,255,255,255,true);
                    sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." took away the right of leader "..sColor2..getElementData(targetPlayer,"char >> name")..white.. " player. faction:"..sColor2..factions[fid][1]..white..".");
                end
            end
        else
            outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [faction id] [leader 0/1] [player]",player,255,255,255,true);
            return;
        end
    end
end 
addCommandHandler("setleader",setPlayerToFactionLeaderByAdmin,false,false);
addCommandHandler("setfactionleader",setPlayerToFactionLeaderByAdmin,false,false);

function kickFactionByAdmin(player,command,fid,...)
    if getElementData(player,"admin >> level") > 6 then 
        if not fid or not ... then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [faction id] [id/name]",player,255,255,255,true) return end;
        local fid = math.floor(tonumber(fid));
        if fid then 
            if not factions[fid] then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."Specified faction not found.",player,255,255,255,true) return end;
            local name = table.concat({...},"");
            local targetPlayer,targetPlayerName = exports.fv_engine:findPlayer(player,name);
            if targetPlayer then 
                if not getElementData(targetPlayer,"faction_"..fid) then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."Player is not a member of the faction!",player,255,255,256,true) return end;
                local dbid = getElementData(targetPlayer,"acc >> id");
                setElementData(targetPlayer,"faction_"..fid,false);
                setElementData(targetPlayer,"faction_"..fid.."_leader",false);
                setElementData(targetPlayer,"faction_"..fid.."_rank",false);
                setElementData(targetPlayer,"faction_"..fid.."_dutyskin",false);
                dbExec(sql,"DELETE FROM playerfactions WHERE faction=? AND dbid=?",fid,dbid);
                table.remove(factionMembers[fid],findFactionMembers(fid,dbid));
                getPlayerFactions(player);
                getPlayerFactions(targetPlayer);

                outputChatBox(exports.fv_engine:getServerSyntax("faction","servercolor").."Player successfully fired from the faction. ("..factions[fid][1]..")",player,255,255,255,true);

                sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." fired from the faction  "..sColor2..getElementData(targetPlayer,"char >> name")..white.. " player. faction:"..sColor2..factions[fid][1]..white..".");
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [faction id] [id/name]",player,255,255,255,true);
            return;
        end
    end
end 
addCommandHandler("removefaction",kickFactionByAdmin,false,false);

function showFactionsByAdmin(player,command)
    if getElementData(player,"admin >> level") > 6 then 
        outputChatBox(exports.fv_engine:getServerSyntax("Faction List","servercolor"),player,255,255,255,true);
        local scolor = exports.fv_engine:getServerColor("servercolor",true);
        for k,v in pairs(factions) do  
            local name,type,vallet,ranks = unpack(v);
            outputChatBox("ID: "..scolor..k..white.." Name: "..scolor..(name or "Unknown")..white.." Invoice: "..scolor..formatMoney(vallet)..white.."dt",player,255,255,255,true);
        end
    end
end
addCommandHandler("showfactions",showFactionsByAdmin,false,false);
addCommandHandler("factionlist",showFactionsByAdmin,false,false);

function deleteFactionByAdmin(player,command,target)
    if getElementData(player,"admin >> level") > 6 then 
        if not target then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [faction id]",player,255,255,255,true) return end;
        local target = math.floor(tonumber(target));
        local scolor = exports.fv_engine:getServerColor("servercolor",true);
        if target then 
            if not factions[target] then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."There is no such faction!",player,255,255,255,true) return end;
            local name = factions[target][1];
            factions[target] = {};
            dbExec(sql,"DELETE FROM factions WHERE id=?",target);
            dbExec(sql,"DELETE FROM playerfactions WHERE faction=?",target);
            for k,v in pairs(getElementsByType("player")) do 
                if getElementData(v,"faction_"..target) then 
                    setElementData(v,"faction_"..target,false)
                    setElementData(v,"faction_"..target.."_leader",false)
                    setElementData(v,"faction_"..target.."_dutyskin",false)
                    setElementData(v,"faction_"..target.."_rank",false)
                end
            end
            refreshFactionMembers(getElementsByType("player"));
            outputChatBox(exports.fv_engine:getServerSyntax("faction","servercolor").."Success of deleting a factions! ("..scolor..name..white..")",player,255,255,255,true);
            sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." deleted a faction. ("..sColor2..name..white..")");
        else outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [faction id]",player,255,255,255,true) return end;
    end
end 
addCommandHandler("delfaction",deleteFactionByAdmin,false,false);
addCommandHandler("deletefaction",deleteFactionByAdmin,false,false);

function setFactionMoneyByAdmin(player,command,target,value)
    if getElementData(player,"admin >> level") > 6 then 
        if not target or not value then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [faction id] [value]",player,255,255,255,true) return end;
        local target = math.floor(tonumber(target));
        local value = math.floor(tonumber(value));
        local scolor = exports.fv_engine:getServerColor("servercolor",true);
        if target and value then
            if not factions[target] then outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."Faction not found!",player,255,255,255,true) return end;
            factions[target][3] = value;
            dbExec(sql,"UPDATE factions SET vallet=? WHERE id=?",value,target);
            outputChatBox(exports.fv_engine:getServerSyntax("faction","servercolor").."You have successfully set the amount in your account. ( "..scolor..formatMoney(value)..white.."dt )",player,255,255,255,true);
            sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." set up a faction account "..sColor2..formatMoney(value)..white.. "dt To/from. faction:"..sColor2..factions[target][1]..white..".");

        else outputChatBox(exports.fv_engine:getServerSyntax("faction","red").."/"..command.." [faction id] [value]",player,255,255,255,true) return end;
    end
end 
addCommandHandler("setfactionmoney",setFactionMoneyByAdmin,false,false);
addCommandHandler("setfactionwallet",setFactionMoneyByAdmin,false,false);



local jelvenyData = {
    --id = {fraki id, rövid neve};
    [1] = {53,"LSPD"},
    [2] = {54,"ATF"},
    [3] = {55,"LSFD"},
    [4] = {52,"GOV"},
}
function addJelveny(player,command,fid,...)
    if not fid or not tonumber(fid) or not ... then 
        outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [type] [text]",player,255,255,255,true);
        outputChatBox("Tipusok: ",player,255,255,255,true);
        local types = "";
        for k,v in pairs(jelvenyData) do 
            types = types .. " | " ..k.. " - "..v[2];
        end
        outputChatBox(types,player,255,255,255,true);
        return;
    end
    local fid = math.floor(tonumber(fid));
    local text = table.concat({...}," ");
    if getElementData(player,"faction_"..jelvenyData[fid][1].."_leader") then 
        local jelvenyText = jelvenyData[fid][2].." "..text;
        exports.fv_inventory:givePlayerItem(player,88,1,1,100,{0,jelvenyText});
        exports.fv_logs:createLog("badge",getElementData(player,"char >> name").. " Created a badge. faction: "..jelvenyData[fid][2].." Text: "..text,player);
        outputChatBox(exports.fv_engine:getServerSyntax("badge","servercolor").."Successful badge creation!",player,255,255,255,true);
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("badge","red").."You do not have permission to command!",player,255,255,255,true);
    end
end
addCommandHandler("addbadge",addJelveny,false,false);

addEvent("dash > walkStyle",true);
addEventHandler("dash > walkStyle",root,function(player,id)
    setPedWalkingStyle(player,id);
end);