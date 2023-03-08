local sql = exports.fv_engine:getConnection(getThisResource());

addEventHandler("onResourceStart",resourceRoot,function()
    sql = exports.fv_engine:getConnection(getThisResource());
    dbExec(sql,"UPDATE mdcaccounts SET online=0"); --SQL Data set to default.

    for k,v in pairs(getElementsByType("vehicle")) do 
        if vehicleModels[getElementModel(v)] then 
            setElementData(v,"mdc.loggedIn",false);
            setElementData(v,"mdc.egysegszam",false);
            setElementData(v,"mdc.mode",0);
        end
    end
end);

addEventHandler("onPlayerQuit",root,function()
    if getElementData(source,"mdc.loggedIn") then 
        local id = getElementData(source,"mdc.id");
        dbExec(sql,"UPDATE mdcAccounts SET online=0 WHERE id=?",id);
    end
end);


addEvent("mdc.login",true);
addEventHandler("mdc.login",root,function(player,name,pass,vehicle)
    if name == "" or name == " " or pass == "" or pass == " " then 
        outputChatBox(exports.fv_engine:getServerSyntax("MDC","red").."Invalid name or password!",player,255,255,255,true);
        return;
    end
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        if #result > 0 then 
            for k,v in pairs(result) do 
                if v.online == 1 then  
                    outputChatBox(exports.fv_engine:getServerSyntax("MDC","red").."Account is already in use!",player,255,255,255,true);
                    return;
                else 
                    sendMessage("blue",exports.fv_engine:getServerColor("servercolor",true)..getElementData(player,"char >> name")..white.." logged in to MDC.");
                    setElementData(player,"mdc.loggedIn",true);
                    setElementData(vehicle,"mdc.loggedIn",true);
                    setElementData(player,"mdc.id",v.id);
                    dbExec(sql,"UPDATE mdcaccounts SET online=1 WHERE id=?",v.id);
                end
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("MDC","red").."Invalid name or password!",player,255,255,255,true);
            return;
        end
    end,sql,"SELECT * FROM mdcaccounts WHERE username=? AND pass=?",name,pass);
end);

addEvent("mdc.egysegszam",true);
addEventHandler("mdc.egysegszam",root,function(player,veh,egysegszam)
if egysegszam == "" or egysegszam == " " or string.len(egysegszam) < 2 then outputChatBox(exports.fv_engine:getServerSyntax("MDC","red").."The specified unit number is incorrect.",player,255,255,255,true) return end;
    if isElement(veh) then 
        setElementData(veh,"mdc.egysegszam",egysegszam);
        outputChatBox(exports.fv_engine:getServerSyntax("MDC","servercolor").."You have successfully set the unit number!",player,255,255,255,true);
        triggerClientEvent(player,"mdc.setTab",player,3);
        sendMessage("blue",exports.fv_engine:getServerColor("servercolor",true)..egysegszam..white.." számú egység "..exports.fv_engine:getServerColor("servercolor",true).." létrejött"..white..".");
    end
end);

addEvent("mdc.playerWanted",true);
addEventHandler("mdc.playerWanted",root,function(player,name,location,reason)
    if name == "" or location == "" or reason == "" or name == " " or location == " " or reason == " " or string.len(name) < 2 or string.len(location) < 2 or string.len(reason) < 2 then outputChatBox(exports.fv_engine:getServerSyntax("MDC","red").."The data provided is incorrect!",player,255,255,255,true) return end;
    local save = dbExec(sql,"INSERT INTO mdcwantedplayers SET name=?, location=?, indok=?",name,location,reason);
    if save then 
        outputChatBox(exports.fv_engine:getServerSyntax("MDC","servercolor").."Successful circling posting.",player,255,255,255,true);
        getWantedPlayers();
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("MDC","red").."Failed to post. Try again.",player,255,255,255,true);
        return;
    end
end);

function getWantedPlayers(element)
    if not element then element = root end;
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        local datas = {};
        for k,v in pairs(result) do 
            table.insert(datas,{v.name,v.location,v.indok,v.id});
        end
        triggerClientEvent(element,"mdc.returnWantedPlayers",element,datas);
    end,sql,"SELECT * FROM mdcwantedplayers");
end
addEvent("mdc.getWantedPlayers",true);
addEventHandler("mdc.getWantedPlayers",root,getWantedPlayers);

addEvent("mdc.vehicleWanted",true);
addEventHandler("mdc.vehicleWanted",root,function(player,tipus,location,reason,plate)
    if tipus == "" or location == "" or reason == "" or plate == "" or tipus == " " or location == " " or reason == " " or plate == " " or string.len(tipus) < 2 or string.len(location) < 2 or string.len(reason) < 2 or string.len(plate) < 2 then outputChatBox(exports.fv_engine:getServerSyntax("MDC","red").."The data provided is incorrect!",player,255,255,255,true) return end;
    local save = dbExec(sql,"INSERT INTO mdcwantedvehicles SET name=?, location=?, indok=?, rendszam=?",tipus,location,reason,plate);
    if save then 
        outputChatBox(exports.fv_engine:getServerSyntax("MDC","servercolor").."Successful circling posting.",player,255,255,255,true);
        getWantedVehicles();
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("MDC","red").."Failed to post. Try again.",player,255,255,255,true);
        return;
    end
end);

function getWantedVehicles(element)
    if not element then element = root end;
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        local datas = {};
        for k,v in pairs(result) do 
            table.insert(datas,{v.name,v.location,v.indok,v.rendszam,v.id});
        end
        triggerClientEvent(element,"mdc.returnWantedVehicles",element,datas);
    end,sql,"SELECT * FROM mdcwantedvehicles");
end
addEvent("mdc.getWantedVehicles",true);
addEventHandler("mdc.getWantedVehicles",root,getWantedVehicles);

addEvent("mdc.removeSQL",true);
addEventHandler("mdc.removeSQL",root,function(player,tipus,id)
    if dbExec(sql,"DELETE FROM mdcWanted"..tipus.." WHERE id=?",id) then 
        getWantedPlayers(player);
        getWantedPlayers();
        getWantedVehicles(player);
        getWantedVehicles();
        outputChatBox(exports.fv_engine:getServerSyntax("MDC","servercolor").."Successful deletion of the entry!",player,255,255,255,true);
    end
end);

addEvent("mdc.setVehMode",true);
addEventHandler("mdc.setVehMode",root,function(player,veh,mode)
    setElementData(veh,"mdc.mode",mode);
    local egysegszam = getElementData(veh,"mdc.egysegszam");
    sendMessage(types[mode][2],exports.fv_engine:getServerColor("servercolor",true)..egysegszam..white.." service status: "..exports.fv_engine:getServerColor(types[mode][2],true)..types[mode][1]..white..".");
end);

addEvent("mdc.logout",true);
addEventHandler("mdc.logout",root,function(player,v)
    if getElementData(player,"mdc.loggedIn") then 
        local id = getElementData(player,"mdc.id");
        dbExec(sql,"UPDATE mdcaccounts SET online=0 WHERE id=?",id);
        setElementData(player,"mdc.id",false);
        setElementData(player,"mdc.loggedIn",false);
    end
    setElementData(v,"mdc.loggedIn",false);
    local egysegszam = getElementData(v,"mdc.egysegszam");
    if egysegszam then 
        sendMessage("blue",exports.fv_engine:getServerColor("servercolor",true)..egysegszam..white.." number of units "..exports.fv_engine:getServerColor("red",true).."dissolved"..white..".");
    end
    setElementData(v,"mdc.egysegszam",false);
    setElementData(v,"mdc.mode",0);
    sendMessage("red",exports.fv_engine:getServerColor("servercolor",true)..getElementData(player,"char >> name")..white.." logged out of MDC.");
    triggerClientEvent(player,"mdc.setTab",player,1);
end);


function sendMessage(color,msg)
if not color then color = blue end;
    for k,v in pairs(getElementsByType("player")) do 
        if isAllowedFaction(v) then 
            outputChatBox(exports.fv_engine:getServerColor(color,true).."[MDC] "..white..msg,v,255,255,255,true);
        end
    end
end


--PARANCSOK--
function addMDCaccount(player,command,name,pass)
    if isAllowedFactionLeader(player) then --csak ha megfelelő frakiba van!
        if not name or not pass then 
            outputChatBox(exports.fv_engine:getServerSyntax("use","red").."/"..command.." [Name] [Password]",player,255,255,255,true);
            return;
        end
        dbQuery(function(qh)
            local result = dbPoll(qh,0);
            if #result > 0 then 
                outputChatBox(exports.fv_engine:getServerSyntax("MDC","red").."You already have a user with that name!",player,255,255,255,true);
                return;
            else 
                if dbExec(sql,"INSERT INTO mdcaccounts SET username=?, pass=?",name,pass) then 
                    outputChatBox(exports.fv_engine:getServerSyntax("MDC","servercolor").."Successful MDC user creation. Name:"..exports.fv_engine:getServerColor("servercolor",true)..name..white.." Password: "..exports.fv_engine:getServerColor("servercolor",true)..pass..white..".",player,255,255,255,true);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("MDC","red").."Failed to create user! (MySQL ERROR)",player,255,255,255,true);
                end
            end
        end,sql,"SELECT username FROM mdcaccounts WHERE username=?",name);
    end
end
addCommandHandler("createmdcaccount",addMDCaccount,false,false);
addCommandHandler("addmdcaccount",addMDCaccount,false,false);

addCommandHandler("gotopos",function(player,command,x,y,z)
    if getElementData(player,"admin >> level") > 8 then 
        if not x or not y or not z then 
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [x] [y] [z]",player,255,255,255,true);
            return;
        end
        local x = tonumber(x);
        local y = tonumber(y);
        local z = tonumber(z);
        setElementPosition(player,x,y,z);
    end
end,false,false);