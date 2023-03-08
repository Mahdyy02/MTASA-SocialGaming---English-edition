sql = exports.fv_engine:getConnection(getThisResource());
factions = {};

addCommandHandler("dashfix",function(player,cmd,target)
    if getElementData(player,"admin >> level") > 7 then 
        if not target then 
            return outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..cmd.." [Név/ID]",player,255,255,255,true);
        end
        local targetPlayer = exports.fv_engine:findPlayer(player,target);
        if targetPlayer then 
            triggerClientEvent(targetPlayer,"dash.fix",targetPlayer);
            outputChatBox(exports.fv_engine:getServerSyntax("Dash","servercolor").."Fixelve.",player,255,255,255,true);
        else 
            return outputChatBox(exports.fv_engine:getServerSyntax("Dash","red").."Nincs ilyen játékos!",player,255,255,255,true);
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
                getPlayerFactions(source);
                loadPayTime(source);
                outputDebugString(getPlayerName(source).." belépett frakik lekérése!");
            end
        end
    end
end);

function loadPayTime(player)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        if res then 
            for k,v in pairs(res) do 
                triggerClientEvent(player,"dash.payTime",player,tonumber(v.payTime));
            end
        end
    end,sql,"SELECT id,payTime FROM characters WHERE id=?",getElementData(player,"acc >> id"));
end

addEvent("dash.payTimeSave",true);
addEventHandler("dash.payTimeSave",root,function(player,time)
    dbExec(sql,"UPDATE characters SET payTime=? WHERE id=?",time,getElementData(player,"acc >> id"));
end);

addEvent("dash > vehSlotBuy",true);
addEventHandler("dash > vehSlotBuy",root,function(player)
    setElementData(player,"char >> premiumPoints",getElementData(player,"char >> premiumPoints") - 200);
    setElementData(player,"char >> vehSlot", getElementData(player,"char >> vehSlot") + 1);
    exports.fv_infobox:addNotification(player,"success","Sikeres slot vásárlás!");
    dbExec(sql,"UPDATE characters SET vehSlot=?, premiumPoints=? WHERE id=?",getElementData(player,"char >> vehSlot"),getElementData(player,"char >> premiumPoints"),getElementData(player,"acc >> id"));
end);

addEvent("dash > intSlotBuy",true);
addEventHandler("dash > intSlotBuy",root,function(player)
    setElementData(player,"char >> premiumPoints",getElementData(player,"char >> premiumPoints") - 200);
    setElementData(player,"char >> intSlot", getElementData(player,"char >> intSlot") + 1);
    exports.fv_infobox:addNotification(player,"success","Sikeres slot vásárlás!");
    dbExec(sql,"UPDATE characters SET intSlot=?, premiumPoints=? WHERE id=?",getElementData(player,"char >> intSlot"),getElementData(player,"char >> premiumPoints"),getElementData(player,"acc >> id"));
end);

addEvent("dash > updateLeaderSay",true)
addEventHandler("dash > updateLeaderSay",root,function(player,faction,text)
    factions[faction][5] = text;
    dbExec(sql,"UPDATE factions SET lmessage=? WHERE id=?",text,faction);
    exports.fv_infobox:addNotification(player,"success","Sikeresen beállítottad a leader üzenetet!");
end);

--FRAKCIÓSZÁMLA--
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
        outputChatBox(exports.fv_engine:getServerSyntax("Frakciószámla","servercolor").."Sikeresen befizettél: "..exports.fv_engine:getServerColor("servercolor",true)..formatMoney(amount-adoki)..white.. " $-t "..exports.fv_engine:getServerColor("red",true).." (Adó: "..adoki.." $)",player,255,255,255,true);
        exports.fv_logs:createLog("Frakciószámla_BE",getElementData(player,"char >> name").." befizetett "..factions[id][1].." számlájára "..amount.." $-t",playerSource,targetPlayer);
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
        outputChatBox(exports.fv_engine:getServerSyntax("Frakciószámla","servercolor").."Sikeresen kivettél: "..exports.fv_engine:getServerColor("servercolor",true)..formatMoney(amount-adoki)..white.. " $-t "..exports.fv_engine:getServerColor("red",true).." (Adó: "..adoki.." $)",player,255,255,255,true);
        exports.fv_logs:createLog("Frakciószámla_KI",getElementData(player,"char >> name").." kivett "..factions[id][1].." számlájáról "..amount.." $-t",playerSource,targetPlayer);
    end
end);
----------------

function getPlayerFactions(player)
    dbQuery(function(qh)
        local members = {}
        local result = dbPoll(qh,0);
        for k,v in pairs(factions) do 
            members[k] = {};
        end
        if result then 
            for k,v in pairs(result) do 
                local id = v.faction;
			--	members[id] = {};
				if not(members[id]) then members[id] = {} end
                local leader = false;
                if v.leader == 1 then 
                    leader = true;
                end
                if v.rank > 15 then 
                    v.rank = 15;
                    dbExec(sql,"UPDATE playerFactions SET rank=? WHERE dbid=?",v.rank,v.dbid);
                end
                members[id][#members[id] + 1] = {v.dbid,v.rank,v.leader,v.dutyskin,checkOnline(v.dbid),v.charname:gsub("_"," "),v.lastlogin:gsub("-",".")}
                --outputDebugString(v.charname.." >> "..tostring(v.dbid == getElementData(player,"acc >> id")) .. " >> "..inspect(player))
                if v.dbid == getElementData(player,"acc >> id") then 
                    setElementData(player,"faction_"..id,true);
                    setElementData(player,"faction_"..id.."_rank",v.rank);
                    setElementData(player,"faction_"..id.."_leader",leader);
                    setElementData(player,"faction_"..id.."_dutyskin",v.dutyskin);
                end
            end
            --outputDebugString(inspect(player))
            triggerClientEvent(player,"dash > sendFactionDatas",player,factions,members)
        end
    --end,sql,"SELECT playerFactions.id AS id, playerFactions.faction AS faction, playerFactions.dbid AS dbid, playerFactions.rank AS rank, playerFactions.leader AS leader, playerFactions.dutyskin AS dutyskin, characters.charname AS charname, accounts.lastlogin AS lastlogin FROM accounts, playerFactions LEFT JOIN characters ON characters.id=playerFactions.dbid WHERE accounts.id=characters.id");
    end,sql,"SELECT * FROM playerFactions, accounts, characters WHERE accounts.id=playerFactions.dbid AND characters.id=playerFactions.dbid");



    local accid = getElementData(player,"acc >> id");
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        if res and #res > 0 then 
            local jelenPP = getElementData(player,"char >> premiumPoints");
            for k,v in pairs(res) do 
                if v.premiumPoints > jelenPP then 
                    setElementData(player,"char >> premiumPoints",v.premiumPoints);
                    outputChatBox(exports.fv_engine:getServerSyntax("Támogatás","servercolor").."Sikeresen támogattad a szervert! Köszönjük!",player,255,255,255,true);
                    exports.fv_infobox:addNotification(player,"success", "Sikeresen támogattad a szervert! Köszönjük!");
                end
            end
        end
    end,sql,"SELECT id,premiumPoints FROM characters WHERE id=?",accid);
end
addEvent("dash > getFactions",true);
addEventHandler("dash > getFactions",root,getPlayerFactions); --Kliens oldalról hívja meg ha megnyitja a dash-t

function loadFaction(id)
    factions[id] = {};
    local q = dbQuery(function(qh)
        local result = dbPoll(qh,0);
        if result then 
            for k,v in pairs(result) do 
                factions[v.id] = {v.name,v.type,tonumber(v.vallet),fromJSON(v.ranks),v.lmessage}
            end
        end
    end,sql,"SELECT * FROM factions WHERE id=?",id);
    if q then 
        return true;
    else 
        return false;
    end
end

function loadAllFaction()
    dbQuery(function(qh)
        local loaded = 0;
        local result,all = dbPoll(qh,0);
        for k,v in pairs(result) do 
            if loadFaction(v.id) then 
                loaded = loaded + 1;
            end
        end
        outputDebugString("Factions: "..loaded.." / "..all.." loaded!");
    end,sql,"SELECT id FROM factions");
end
addEventHandler("onResourceStart",resourceRoot,loadAllFaction);

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
        return "Ismeretlen frakció";
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
            if getElementData(v,"admin >> level") > 0 and getElementData(v,"admin >> duty") then 
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
    dbExec(sql,"UPDATE playerFactions SET rank=? WHERE faction=? AND dbid=?",rank,fid,dbid);
    exports.fv_infobox:addNotification(player,"success", "Sikeres rang változtatás.");
end);
addEvent("dash > kickPlayer",true);
addEventHandler("dash > kickPlayer",root,function(player,fid,table)
    local dbid = table[1];
    local online,target = checkOnline(dbid);
    if online then 
        setElementData(target,"faction_"..fid,false);
        setElementData(target,"faction_"..fid.."_leader",false);
        setElementData(target,"faction_"..fid.."_rank",false);
        setElementData(target,"faction_"..fid.."_dutyskin",false);
        getPlayerFactions(online);
    end
    dbExec(sql,"DELETE FROM playerFactions WHERE faction=? AND dbid=?",fid,dbid);
    getPlayerFactions(player);
end);
addEvent("dash > setLeaderState",true);
addEventHandler("dash > setLeaderState",root,function(player,state,fid,table)
    local dbid = table[1];
    local online,target = checkOnline(dbid);
    if online then 
        setElementData(target,"faction_"..fid.."_leader",state);
    end
    dbExec(sql,"UPDATE playerFactions SET leader=? WHERE faction=? AND dbid=?",state,fid,dbid);
    getPlayerFactions(player);
end);
addEvent("dash > addNewMember",true);
addEventHandler("dash > addNewMember",root,function(player,fid,target)
    local targetPlayer,targetPlayerName = exports.fv_engine:findPlayer(player,target);
    if targetPlayer then 
        if not getElementData(targetPlayer,"loggedIn") then exports.fv_infobox:addNotification(player,"error", "Játékos nincs bejelentkezve!") return end;
        if getElementData(targetPlayer,"faction_"..fid) then exports.fv_infobox:addNotification(player,"error", "Játékos már a frakció tagja!") return end;
        local dbid = getElementData(targetPlayer,"acc >> id");
        local save = dbExec(sql,"INSERT INTO playerFactions SET dbid=?, faction=?",dbid,fid);
        if save then 
            getPlayerFactions(player);
            getPlayerFactions(targetPlayer);
        end
        exports.fv_infobox:addNotification(player,"success", "Játékos felvétele sikeresen megtörtént!");
    else 
        exports.fv_infobox:addNotification(player,"error", "Játékos nem található!");
    end
end);
addEvent("dash > rankNameSave",true);
addEventHandler("dash > rankNameSave",root,function(player,fid,rank,text)
    factions[fid][4][rank][1] = text;
    dbExec(sql,"UPDATE factions SET ranks=? WHERE id=?",toJSON(factions[fid][4]),fid);
    exports.fv_infobox:addNotification(player,"success", "Rang Sikeresen szerkesztve!");
end);
addEvent("dash > rankPaySave",true);
addEventHandler("dash > rankPaySave",root,function(player,fid,rank,text)
    factions[fid][4][rank][2] = text;
    dbExec(sql,"UPDATE factions SET ranks=? WHERE id=?",toJSON(factions[fid][4]),fid);
    exports.fv_infobox:addNotification(player,"success", "Rang Sikeresen szerkesztve!");
end);
----------------------------------------

--Parancsok--
function addFactionByAdmin(player,command,type,...)   
    if getElementData(player,"admin >> level") > 6 then 
        if not (...) or not type then
            outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [tipus] [frakció neve]",player,255,255,255,true)
            outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Típusok: 1-Banda,2-Maffia,3-Rendvédelem,4-Önkormányzat,5-Egyéb",player,255,255,255,true)
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
                            outputChatBox(exports.fv_engine:getServerSyntax("Frakció","servercolor").."Sikeres frakció létrehozás. ("..name..")",player,255,255,255,true);
                            sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." létrehozott egy frakciót. ("..sColor2..name..white..")");
                        else  
                            outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Sikertelen frakció létrehozás!",player,255,255,255,true);
                        end
                    end            
                end,sql,"INSERT INTO factions SET name=?, type=?, ranks=?",name,type,ranks);
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [tipus] [frakció neve]",player,255,255,255,true);
            return;
        end
   end
end
addCommandHandler("makefaction",addFactionByAdmin,false,false);
addCommandHandler("addfaction",addFactionByAdmin,false,false);

function addPlayerToFactionByAdmin(player,command,fid,...)
    if getElementData(player,"admin >> level") > 6 then 
        if not fid or not ... then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [frakció id] [id/név]",player,255,255,255,true) return end;
        local fid = math.floor(tonumber(fid));
        if fid then 
            if not factions[fid] then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Megadott frakció nem található.",player,255,255,255,true) return end;
            local name = table.concat({...},"");
            local targetPlayer,targetPlayerName = exports.fv_engine:findPlayer(player,name);
            if targetPlayer then 
                if getElementData(targetPlayer,"faction_"..fid) then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Játékos már a frakció tagja!",player,255,255,256,true) return end;
                local save = dbExec(sql,"INSERT INTO playerFactions SET dbid=?, faction=?",getElementData(targetPlayer,"acc >> id"),fid);
                if save then 
                    getPlayerFactions(targetPlayer);
                    outputChatBox(exports.fv_engine:getServerSyntax("Frakció","servercolor").."Játékos sikeresen hozzáadva a frakcióhoz. ("..factions[fid][1]..")",player,255,255,255,true);
                    sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." hozzáadta "..sColor2..getElementData(targetPlayer,"char >> name")..white.. " játékost egy frakcióhoz. ("..sColor2..factions[fid][1]..white..")");
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Játékos nem helyezhető frakcióba!",player,255,255,255,true);
                    return;
                end
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [frakció id] [id/név]",player,255,255,255,true);
            return;
        end
   end
end 
addCommandHandler("setfaction",addPlayerToFactionByAdmin,false,false);
addCommandHandler("setplayerfaction",addPlayerToFactionByAdmin,false,false);
addCommandHandler("addplayerfaction",addPlayerToFactionByAdmin,false,false);

function setPlayerToFactionLeaderByAdmin(player,command,fid,leader,...)
    if getElementData(player,"admin >> level") > 6 then 
        if not fid or not leader or not ... then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [frakció id] [leader 0/1] [játékos]",player,255,255,255,true) return end;
        local leader = math.floor(tonumber(leader));
        local fid = math.floor(tonumber(fid));
        local target = table.concat({...},"");
        if fid and leader then 
            local targetPlayer,targetPlayerName = exports.fv_engine:findPlayer(player,target);
            if targetPlayer then 
                local isLeader = getElementData(targetPlayer,"faction_"..fid.."_leader");
                if leader == 1 then 
                    if not getElementData(targetPlayer,"faction_"..fid) then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Játékos nem tagja a frakciónak",player,255,255,255,true) return end;
                    if isLeader then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Játékos már leader rangon van a frakcióban",player,255,255,255,true) return end;
                    dbExec(sql,"UPDATE playerFactions SET leader=? WHERE dbid=? AND faction=?",1,getElementData(targetPlayer,"acc >> id"),fid);
                    getPlayerFactions(targetPlayer);
                    outputChatBox(exports.fv_engine:getServerSyntax("Frakció","servercolor").."Leader jog sikeresen adva a játékosnak!",player,255,255,255,true);
                    sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." leader jogot adott "..sColor2..getElementData(targetPlayer,"char >> name")..white.. " játékosnak. Frakció:"..sColor2..factions[fid][1]..white..".");
                elseif leader == 0 then 
                    if not getElementData(targetPlayer,"faction_"..fid) then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Játékos nem tagja a frakciónak",player,255,255,255,true) return end;
                    if not isLeader then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Játékos nem volt leader, így nem volt mit elvenni.",player,255,255,255,true) return end;
                    dbExec(sql,"UPDATE playerFactions SET leader=? WHERE dbid=? AND faction=?",0,getElementData(targetPlayer,"acc >> id"),fid);
                    getPlayerFactions(targetPlayer);
                    outputChatBox(exports.fv_engine:getServerSyntax("Frakció","servercolor").."Leader jog sikeresen elvételre került.",player,255,255,255,true);
                    sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." elvette a leader jogot "..sColor2..getElementData(targetPlayer,"char >> name")..white.. " játékostól. Frakció:"..sColor2..factions[fid][1]..white..".");
                end
            end
        else
            outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [frakció id] [leader 0/1] [játékos]",player,255,255,255,true);
            return;
        end
    end
end 
addCommandHandler("setleader",setPlayerToFactionLeaderByAdmin,false,false);
addCommandHandler("setfactionleader",setPlayerToFactionLeaderByAdmin,false,false);

function kickFactionByAdmin(player,command,fid,...)
    if getElementData(player,"admin >> level") > 6 then 
        if not fid or not ... then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [frakció id] [id/név]",player,255,255,255,true) return end;
        local fid = math.floor(tonumber(fid));
        if fid then 
            if not factions[fid] then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Megadott frakció nem található.",player,255,255,255,true) return end;
            local name = table.concat({...},"");
            local targetPlayer,targetPlayerName = exports.fv_engine:findPlayer(player,name);
            if targetPlayer then 
                if not getElementData(targetPlayer,"faction_"..fid) then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Játékos nem a frakció tagja!",player,255,255,256,true) return end;
                local online,target = checkOnline(getElementData(targetPlayer,"acc >> id"));
                if online then 
                    setElementData(target,"faction_"..fid,false);
                    setElementData(target,"faction_"..fid.."_leader",false);
                    setElementData(target,"faction_"..fid.."_rank",false);
                    setElementData(target,"faction_"..fid.."_dutyskin",false);
                end
                dbExec(sql,"DELETE FROM playerFactions WHERE faction=? AND dbid=?",fid,getElementData(targetPlayer,"acc >> id"));
                getPlayerFactions(player);
                getPlayerFactions(targetPlayer);
                outputChatBox(exports.fv_engine:getServerSyntax("Frakció","servercolor").."Játékos sikeresen kirúgva a frakcióból. ("..factions[fid][1]..")",player,255,255,255,true);

                sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." kirúgta a frakcióból  "..sColor2..getElementData(targetPlayer,"char >> name")..white.. " játékost. Frakció:"..sColor2..factions[fid][1]..white..".");
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [frakció id] [id/név]",player,255,255,255,true);
            return;
        end
    end
end 
addCommandHandler("removefaction",kickFactionByAdmin,false,false);

function showFactionsByAdmin(player,command)
    if getElementData(player,"admin >> level") > 6 then 
        outputChatBox(exports.fv_engine:getServerSyntax("Frakció Lista","servercolor"),player,255,255,255,true);
        local scolor = exports.fv_engine:getServerColor("servercolor",true);
        for k,v in pairs(factions) do  
            local name,type,vallet,ranks = unpack(v);
            outputChatBox("ID: "..scolor..k..white.." Név: "..scolor..(name or "Ismeretlen")..white.." Számla: "..scolor..formatMoney(vallet)..white.."$",player,255,255,255,true);
        end
    end
end
addCommandHandler("showfactions",showFactionsByAdmin,false,false);
addCommandHandler("factionlist",showFactionsByAdmin,false,false);

function deleteFactionByAdmin(player,command,target)
    if getElementData(player,"admin >> level") > 6 then 
        if not target then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [frakció id]",player,255,255,255,true) return end;
        local target = math.floor(tonumber(target));
        local scolor = exports.fv_engine:getServerColor("servercolor",true);
        if target then 
            if not factions[target] then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Nincs ilyen frakció!",player,255,255,255,true) return end;
            local name = factions[target][1];
            factions[target] = {};
            dbExec(sql,"DELETE FROM factions WHERE id=?",target);
            dbExec(sql,"DELETE FROM playerFactions WHERE faction=?",target);
            for k,v in pairs(getElementsByType("player")) do 
                if getElementData(v,"faction_"..target) then 
                    setElementData(v,"faction_"..target,false)
                    setElementData(v,"faction_"..target.."_leader",false)
                    setElementData(v,"faction_"..target.."_dutyskin",false)
                    setElementData(v,"faction_"..target.."_rank",false)
                end
            end
            outputChatBox(exports.fv_engine:getServerSyntax("Frakció","servercolor").."Frakció törlése sikeres! ("..scolor..name..white..")",player,255,255,255,true);
            sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." törölt egy frakciót. ("..sColor2..name..white..")");
        else outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [frakció id]",player,255,255,255,true) return end;
    end
end 
addCommandHandler("delfaction",deleteFactionByAdmin,false,false);
addCommandHandler("deletefaction",deleteFactionByAdmin,false,false);

function setFactionMoneyByAdmin(player,command,target,value)
    if getElementData(player,"admin >> level") > 6 then 
        if not target or not value then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [frakció id] [érték]",player,255,255,255,true) return end;
        local target = math.floor(tonumber(target));
        local value = math.floor(tonumber(value));
        local scolor = exports.fv_engine:getServerColor("servercolor",true);
        if target and value then
            if not factions[target] then outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."Frakció nem található!",player,255,255,255,true) return end;
            factions[target][3] = value;
            dbExec(sql,"UPDATE factions SET vallet=? WHERE id=?",value,target);
            outputChatBox(exports.fv_engine:getServerSyntax("Frakció","servercolor").."Sikeresen beállítottad a számlán lévő összeget. ( "..scolor..formatMoney(value)..white.."$ )",player,255,255,255,true);
            sendAdminMessage(sColor2..getElementData(player,"admin >> name")..white.." beállította egy frakció számláját "..sColor2..formatMoney(value)..white.. "$-ra/re. Frakció:"..sColor2..factions[target][1]..white..".");

        else outputChatBox(exports.fv_engine:getServerSyntax("Frakció","red").."/"..command.." [frakció id] [érték]",player,255,255,255,true) return end;
    end
end 
addCommandHandler("setfactionmoney",setFactionMoneyByAdmin,false,false);
addCommandHandler("setfactionwallet",setFactionMoneyByAdmin,false,false);



local jelvenyData = {
    --id = {fraki id, rövid neve};
    [1] = {2,"LSPD"},
    [2] = {5,"FBI"},
    [3] = {6,"LSMC"},
    [4] = {23,"GOV"},
    [5] = {17,"SASD"},
}
function addJelveny(player,command,fid,...)
    if not fid or not tonumber(fid) or not ... then 
        outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..command.." [tipus] [szöveg]",player,255,255,255,true);
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
        exports.fv_logs:createLog("addjelveny",getElementData(player,"char >> name").. " létrehozott egy jelvényt. Fració: "..jelvenyData[fid][2].." Szöveg: "..text,player);
        outputChatBox(exports.fv_engine:getServerSyntax("Jelvény","servercolor").."Sikeres jelvény létrehozás!",player,255,255,255,true);
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Jelvény","red").."Nincs jogosultságod a parancshoz!",player,255,255,255,true);
    end
end
addCommandHandler("addjelveny",addJelveny,false,false);

addEvent("dash > walkStyle",true);
addEventHandler("dash > walkStyle",root,function(player,id)
    setPedWalkingStyle(player,id);
end);