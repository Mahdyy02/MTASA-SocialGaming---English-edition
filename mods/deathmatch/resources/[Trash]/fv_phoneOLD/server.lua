white = "#FFFFFF";
local contacts = {}
local sql = exports.fv_engine:getConnection(getThisResource());

addEvent("phone.ad",true);
addEventHandler("phone.ad",root,function(player,phoneNumber,text,cost,showNumber)
    if text == "" or text == " " or string.len(text) < 3 then 
        outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Hibás a megadott szöveg!",player,255,255,255,true);
        return;
    end
    setElementData(player,"char >> money",getElementData(player,"char >> money") - cost);
    for k, v in ipairs(getElementsByType("player")) do  
        if getElementData(v,"loggedIn") and getElementData(v,"phone.togAD") then 
            outputChatBox (exports.fv_engine:getServerColor("servercolor",true).." HIRDETÉS: #ffcc00" ..text.. " ((" .. getElementData(player,"char >> name") .. "))",v,255,255,255,true);
            if showNumber then 
                outputChatBox (exports.fv_engine:getServerColor("servercolor",true).." Kapcsolat: #ffcc00" .. phoneNumber,v,255,255,255,true);
            end
        end
    end
end);

addEvent("phone.darkad",true);
addEventHandler("phone.darkad",root,function(player,phoneNumber,text,cost,showNumber)
    if text == "" or text == " " or string.len(text) < 3 then 
        outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Hibás a megadott szöveg!",player,255,255,255,true);
        return;
    end
    setElementData(player,"char >> money",getElementData(player,"char >> money") - cost);
    for k, v in ipairs(getElementsByType("player")) do  
        if getElementData(v,"loggedIn") and getElementData(v,"phone.togDarkAD") then 
            if not rendvedelmis(v) then 
                outputChatBox (exports.fv_engine:getServerColor("red",true).." DarkWeb: #ffcc00" ..text.. " ((" .. getElementData(player,"char >> name") .. "))",v,255,255,255,true);
                if showNumber then 
                    outputChatBox (exports.fv_engine:getServerColor("red",true).." Kapcsolat: #ffcc00" .. phoneNumber,v,255,255,255,true);
                end
            end
        end
    end
end);

function rendvedelmis(p)
    if getElementData(p,"faction_2") or getElementData(p,"faction_5") or getElementData(p,"faction_17") then 
        return true;
    else 
        return false;
    end
end

addEvent("phone.startCall",true);
addEventHandler("phone.startCall",root,function(player,number,sourceNumber)
    if number == "333333" then 
        taxiCall(player);
        return;
    elseif number == "555555" then 
        mechanicCall(player);
        return;
    -- elseif number == "0421" then 
    --     if getResourceState(getResourceFromName("fv_easter")) == "running" then 
    --        outputChatBox(exports.fv_engine:getServerSyntax("Húsvét","orange").."A húsvéti nyúl tartózkodási helye jelenleg: "..exports.fv_engine:getServerColor("servercolor",true)..getZoneName(exports.fv_easter:getRabbitPos()),player,255,255,255,true);
    --     end
    --     return;
    end

    local found = false;
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"loggedIn") then 
            if exports.fv_inventory:hasPhone(v,number) then 
                found = v;
                break;
            end
        end
    end
    if not found then 
        outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Telefonszámon előfizető nem kapcsolható!",player,255,255,255,true);
        return;
    end
    if found == player then 
        outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Magadat nem tudod felhívni!",player,255,255,255,true);
        return;
    end

    if found then
        
        if getElementData(found,"isCall") then 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."A hívott szám foglalt.",player,255,255,255,true);
            return;
        end

        if (getElementData(found,"phone.show") or 0) == 0 then 
            --triggerClientEvent(found,"phone.close",found);
            triggerEvent("sendLocalMeAction",found,found, "elővett egy telefont");
        end

        --if not (getElementData(found,"phone.show") or false) or (getElementData(found,"phone.show") or 0) ~= number then
            dbQuery(function(qh)
                local res = dbPoll(qh,0);
                if #res > 0 then
                    for k,v in pairs(res) do 
                        --triggerClientEvent(found,"phone.showClient",found,number,v.wallpaper,fromJSON(v.sms),fromJSON(v.calls));
                        triggerClientEvent(found,"phone.ring",found,player,sourceNumber,number,v.wallpaper,fromJSON(v.sms),fromJSON(v.calls));
                        exports.fv_chat:createMessage(found,"csörög a telefonja","do");
                    end
                end
            end,sql,"SELECT * FROM phones WHERE number=?",number);
        --end
        triggerClientEvent(player,"phone.startCall",player,found,number);
    end
end);

addEvent("phone.accept",true);
addEventHandler("phone.accept",root,function(player,target)
    triggerClientEvent(target,"phone.felvette",target);
    setElementData(player,"isCall",target);
end);

addEvent("phone.deny",true);
addEventHandler("phone.deny",root,function(player,target,x)
    triggerClientEvent(target,"phone.lerak",target,x);
    setElementData(player,"isCall",false);
    setElementData(target,"isCall",false);
end);

addEvent("phone.msgSend",true);
addEventHandler("phone.msgSend",root,function(player,target,data)
    local x,y,z = getElementPosition(player);
    for k,v in pairs(getElementsByType("player")) do 
        local px,py,pz = getElementPosition(v);
        local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz);
        if distance <= 8 then 
            if distance <= 2 then
                r,g,b = 255,255,255;
            elseif distance <= 4 then
                r,g,b = 191, 191, 191; --75% white
            elseif distance <= 6 then
                r,g,b = 166, 166, 166; --65% white
            elseif distance <= 8 then
                r, g, b = 115, 115, 115; --45% white
            else
                r, g, b = 95, 95, 95; --?% white
            end
            outputChatBox(getElementData(player,"char >> name") .." mondja (telefonba): "..data[1],v,r,g,b,true);
        end
    end

    triggerClientEvent(target,"phone.msgRecive",target,data);
end);

--SMS--
addEvent("phone.newSMS",true);
addEventHandler("phone.newSMS",root,function(player,sourceNumber,number,text,sourceSMS)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        if #res > 0 then 
            for k,v in pairs(res) do 
                local sms = fromJSON(v.sms);
                sms = addSMS(sms,text,sourceNumber,number);
                sms2 = addSMS(sourceSMS,text,sourceNumber,sourceNumber);
                dbExec(sql,"UPDATE phones SET sms=? WHERE number=?",toJSON(sms),number);
                dbExec(sql,"UPDATE phones SET sms=? WHERE number=?",toJSON(sms2),sourceNumber);
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."Sikeres üzenet küldés!",player,255,255,255,true);
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Ilyen telefonszámon nincs előfizető.",player,255,255,255,true);
        end
    end,sql,"SELECT * FROM phones WHERE number=?",number);
end);

addEvent("phone.smsSync",true);
addEventHandler("phone.smsSync",root,function(player,sourceNumber,smsTable)
    dbExec(sql,"UPDATE phones SET sms=? WHERE number=?",toJSON(smsTable),sourceNumber);
end);

addEvent("phone.sendSMS",true);
addEventHandler("phone.sendSMS",root,function(player,sourceNumber,number,text)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        if #res > 0 then 
            for k,v in pairs(res) do 
                local sms = fromJSON(v.sms);
                sms = addSMS(sms,text,sourceNumber,number);
                dbExec(sql,"UPDATE phones SET sms=? WHERE number=?",toJSON(sms),number);
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."Sikeres üzenet küldés!",player,255,255,255,true);
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Ilyen telefonszámon nincs előfizető.",player,255,255,255,true);
        end
    end,sql,"SELECT * FROM phones WHERE number=?",number);
end);

function addSMS(t,text,sourceNumber,number)
    local temp = {};
    local found = false;
    if t and #t > 0 then 
        for k, v in pairs(t) do 
            if tonumber(v[1]) == tonumber(sourceNumber) then 
                --table.insert(t[k][2],{text,sourceNumber});
                t[k][#t[k] + 1] = {text,sourceNumber};
                found = true;
                break;
            end
        end
    else 
        t = {};
    end
    if not found then 
        table.insert(t,{tostring(sourceNumber),{text,sourceNumber}});
    end
    temp = tableCopy(t);

    local owner = false;
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"loggedIn") then 
            if exports.fv_inventory:hasPhone(v,number) then 
                owner = v;
                break;
            end
        end
    end
    if owner then --Ha online a player
        triggerClientEvent(owner,"phone.smsSyncClient",owner,temp);
    end

    return temp;
end
-------


function newPhone(player,ar)
    local number = tonumber("77"..math.random(1111,9999)..math.random(11,99));
    dbQuery(function(qh)
        local res,_,id = dbPoll(qh,0);
        if id > 0 then 
            local suc = exports.fv_inventory:givePlayerItem(player,1,1,0,100,{0,number});
            if suc then 
                setElementData(player,"char >> money",getElementData(player,"char >> money") - ar);
                outputChatBox(exports.fv_engine:getServerSyntax("Telefon","servercolor").."Sikeresen vásároltál egy telefont",player,255,255,255,true);
            else 
                dbExec(sql,"DELETE FROM phones WHERE id=?",id);
                outputChatBox(exports.fv_engine:getServerSyntax("Telefon","red").."Telefon nem fér el nálad!",player,255,255,255,true);
            end
        end
    end,sql,"INSERT INTO phones SET number=?",number);
end



--/call--

local call = {};
call["medic"] = {};
call["police"] = {};
call["vontato"] = {};
call["taxi"] = {};

local types = {
    ["medic"] = 55,
    ["police"] = 53,
    ["vontato"] = 56,
    ["taxi"] = 4,
}

function callCommand(player,cmd)
    if getElementData(player,"loggedIn") then 
        if exports.fv_inventory:hasItem(player,1,1) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."Az alábbi telefonszámok hívásával tudod értesíteni a szervezeteket.",player,255,255,255,true);
            outputChatBox(exports.fv_engine:getServerColor("blue",true).."911 "..white.." - Általános segélyhívó (Rendőr, Mentő)",player,255,255,255,true);
            outputChatBox(exports.fv_engine:getServerColor("orange",true).."333333 "..white.." - Taxitársaság",player,255,255,255,true);
            outputChatBox(exports.fv_engine:getServerColor("servercolor",true).."555555 "..white.." - Szerelő társaság",player,255,255,255,true);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Nincs telefonod.",player,255,255,255,true);
            return;
        end
    end
end
addCommandHandler("call",callCommand,false,false);


addEvent("phone.policeCall",true);
addEventHandler("phone.policeCall",root,function(player)
    local players = vannakPlayerek("police");
    if #players == 0 then 
        outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Sajnos nincs elérhető rendvédelmi tag.",player,255,255,255,true);
        return;
    else 
        if vanHivasa(player,"police") then 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Már kihívtad a rendőröket.",player,255,255,255,true);
            return;
        else
            local id = #call["police"] + 1
            call["police"][id] = {player,false}; 
            exports.fv_infobox:addNotification(player,"success","Sikeresen értesítetted a rendőrséget!");
            for k,v in pairs(players) do 
                if isElement(v) then 
                    outputChatBox(exports.fv_engine:getServerColor("blue",true).."[Hívás]: "..white.."Hívás érkezett! ("..exports.fv_engine:getServerColor("blue",true)..getZoneName(getElementPosition(player))..white..") Elfogadáshoz: "..exports.fv_engine:getServerColor("servercolor",true).."/paccept "..id,v,255,255,255,true);
                end
            end
        end
    end
end);

addEvent("phone.medicCall",true);
addEventHandler("phone.medicCall",root,function(player)
    local players = vannakPlayerek("medic");
    if #players == 0 then 
        outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Sajnos nincs elérhető mentős.",player,255,255,255,true);
        return;
    else 
        if vanHivasa(player,"medic") then 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Már kihívtad a mentőket.",player,255,255,255,true);
            return;
        else
            local id = #call["medic"] + 1
            call["medic"][id] = {player,false}; 
            exports.fv_infobox:addNotification(player,"success","Sikeresen értesítetted a mentőket!");
            for k,v in pairs(players) do 
                if isElement(v) then 
                    outputChatBox(exports.fv_engine:getServerColor("red",true).."[Hívás]: "..white.."Hívás érkezett! ("..exports.fv_engine:getServerColor("blue",true)..getZoneName(getElementPosition(player))..white..") Elfogadáshoz: "..exports.fv_engine:getServerColor("servercolor",true).."/maccept "..id,v,255,255,255,true);
                end
            end
        end
    end
end);

function taxiCall(player)
    local players = vannakPlayerek("taxi");
    if #players == 0 then 
        outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Sajnos nincs elérhető taxis.",player,255,255,255,true);
        return;
    else 
        if vanHivasa(player,"taxi") then 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Már kihívtad a taxitársaságot.",player,255,255,255,true);
            return;
        else
            local id = #call["taxi"] + 1
            call["taxi"][id] = {player,false}; 
            exports.fv_infobox:addNotification(player,"success","Sikeresen értesítetted a taxitársaságot!");
            for k,v in pairs(players) do 
                if isElement(v) then 
                    outputChatBox(exports.fv_engine:getServerColor("orange",true).."[Hívás]: "..white.."Hívás érkezett! ("..exports.fv_engine:getServerColor("blue",true)..getZoneName(getElementPosition(player))..white..") Elfogadáshoz: "..exports.fv_engine:getServerColor("servercolor",true).."/taccept "..id,v,255,255,255,true);
                end
            end
        end
    end
end

function mechanicCall(player)
    local players = vannakPlayerek("vontato");
    if #players == 0 then 
        outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Sajnos nincs elérhető szerelő.",player,255,255,255,true);
        return;
    else 
        if vanHivasa(player,"vontato") then 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Már kihívtad a szerelő társaságot.",player,255,255,255,true);
            return;
        else
            local id = #call["vontato"] + 1
            call["vontato"][id] = {player,false}; 
            exports.fv_infobox:addNotification(player,"success","Sikeresen értesítetted a szerelő társaságot!");
            for k,v in pairs(players) do 
                if isElement(v) then 
                    outputChatBox(exports.fv_engine:getServerColor("servercolor",true).."[Hívás]: "..white.."Hívás érkezett! ("..exports.fv_engine:getServerColor("blue",true)..getZoneName(getElementPosition(player))..white..") Elfogadáshoz: "..exports.fv_engine:getServerColor("servercolor",true).."/vaccept "..id,v,255,255,255,true);
                end
            end
        end
    end
end

function vannakPlayerek(type)
    local table = {};
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"loggedIn") and getElementData(v,"faction_"..types[type]) then 
            table[#table + 1] = v;
        end
    end
    return table;
end

function vanHivasa(player,type)
    local van = false;
    for k,v in pairs(call[type]) do 
        if v[1] == player then 
            van = true;
            break;
        end
    end
    return van;
end

addEvent("phone.kiert",true);
addEventHandler("phone.kiert",root,function(player,id,target,state,type)
    outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."Kiértek a hívásodra!",target,255,255,255,true);
    setElementData(player,"call.elfogadva",false);
    call[type][id] = nil;
    outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."Kiérkeztél a hívás helyszínére.",player,255,255,255,true);
end);


function pAccept(player,command,id)
    if getElementData(player,"faction_53") then 
        if not id or not math.floor(tonumber(id)) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..command.." [hívás száma]",player,255,255,255,true);
            return;
        end
        if getElementData(player,"call.elfogadva") then 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Már van elfogadott hívásod!",player,255,255,255,true);
            return;
        end
        local id = math.floor(tonumber(id));
        if id and call["police"][id] then 
            if call["police"][id][2] then 
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Ezt a hívást már elfogadták!",player,255,255,255,true);
                return;
            else 
                call["police"][id][2] = true;
                setElementData(player,"call.elfogadva",true);
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."Sikeresen elfogadtad a hívást!",player,255,255,255,true);
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."A rendőrség elfogadta a hívásodat!",call["police"][id][1],255,255,255,true);
                triggerClientEvent(player,"phone.createMarker",player,call["police"][id],"blue",id,"police");
                sentOtherFactionMember(exports.fv_engine:getServerColor("servercolor",true)..getElementData(player,"char >> name")..white.." elfogadta a "..exports.fv_engine:getServerColor("servercolor",true)..id..white.." számú hívást.","police","blue");
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Ilyen számmal nem található hívás.",player,255,255,255,true);
            return;
        end
    end
end
addCommandHandler("paccept", pAccept, false, false);


function mAccept(player,command,id)
    if getElementData(player,"faction_55") or getElementData(player,"faction_54") then 
        if not id or not math.floor(tonumber(id)) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..command.." [hívás száma]",player,255,255,255,true);
            return;
        end
        if getElementData(player,"call.elfogadva") then 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Már van elfogadott hívásod!",player,255,255,255,true);
            return;
        end
        local id = math.floor(tonumber(id));
        if id and call["medic"][id] then 
            if call["medic"][id][2] then 
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Ezt a hívást már elfogadták!",player,255,255,255,true);
                return;
            else 
                call["medic"][id][2] = true;
                setElementData(player,"call.elfogadva",true);
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."Sikeresen elfogadtad a hívást!",player,255,255,255,true);
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."A mentők elfogadták a hívásodat!",call["medic"][id][1],255,255,255,true);
                triggerClientEvent(player,"phone.createMarker",player,call["medic"][id],"red",id,"medic");
                sentOtherFactionMember(exports.fv_engine:getServerColor("servercolor",true)..getElementData(player,"char >> name")..white.." elfogadta a "..exports.fv_engine:getServerColor("servercolor",true)..id..white.." számú hívást.","medic","red");
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Ilyen számmal nem található hívás.",player,255,255,255,true);
            return;
        end
    end
end
addCommandHandler("maccept",mAccept,false,false);

function tAccept(player,command,id)
    if getElementData(player,"faction_4") then 
        if not id or not math.floor(tonumber(id)) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..command.." [hívás száma]",player,255,255,255,true);
            return;
        end
        if getElementData(player,"call.elfogadva") then 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Már van elfogadott hívásod!",player,255,255,255,true);
            return;
        end
        local id = math.floor(tonumber(id));
        if id and call["taxi"][id] then 
            if call["taxi"][id][2] then 
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Ezt a hívást már elfogadták!",player,255,255,255,true);
                return;
            else 
                call["taxi"][id][2] = true;
                setElementData(player,"call.elfogadva",true);
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."Sikeresen elfogadtad a hívást!",player,255,255,255,true);
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."A taxitársaság elfogadta a hívásodat!",call["taxi"][id][1],255,255,255,true);
                triggerClientEvent(player,"phone.createMarker",player,call["taxi"][id],"orange",id,"taxi");
                sentOtherFactionMember(exports.fv_engine:getServerColor("servercolor",true)..getElementData(player,"char >> name")..white.." elfogadta a "..exports.fv_engine:getServerColor("servercolor",true)..id..white.." számú hívást.","taxi","orange");
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Ilyen számmal nem található hívás.",player,255,255,255,true);
            return;
        end
    end
end
addCommandHandler("taccept",tAccept,false,false);

function vAccept(player,command,id)
    if getElementData(player,"faction_56") then 
        if not id or not math.floor(tonumber(id)) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..command.." [hívás száma]",player,255,255,255,true);
            return;
        end
        if getElementData(player,"call.elfogadva") then 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Már van elfogadott hívásod!",player,255,255,255,true);
            return;
        end
        local id = math.floor(tonumber(id));
        if id and call["vontato"][id] then 
            if call["vontato"][id][2] then 
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Ezt a hívást már elfogadták!",player,255,255,255,true);
                return;
            else 
                call["vontato"][id][2] = true;
                setElementData(player,"call.elfogadva",true);
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."Sikeresen elfogadtad a hívást!",player,255,255,255,true);
                outputChatBox(exports.fv_engine:getServerSyntax("Phone","servercolor").."A szerelő társaság elfogadta a hívásodat!",call["vontato"][id][1],255,255,255,true);
                triggerClientEvent(player,"phone.createMarker",player,call["vontato"][id],"servercolor",id,"vontato");
                sentOtherFactionMember(exports.fv_engine:getServerColor("servercolor",true)..getElementData(player,"char >> name")..white.." elfogadta a "..exports.fv_engine:getServerColor("servercolor",true)..id..white.." számú hívást.","vontato","servercolor");
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Phone","red").."Ilyen számmal nem található hívás.",player,255,255,255,true);
            return;
        end
    end
end
addCommandHandler("vaccept",vAccept,false,false);

function sentOtherFactionMember(text,type,color)
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"loggedIn") then 
            if getElementData(v,"faction_"..types[type]) then 
                outputChatBox(exports.fv_engine:getServerColor(color,true).."[Hívás]: "..white..text,v,255,255,255,true);
            end
        end
    end
end

function load_contact(player,number)
    contacts[number] = {}
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        if #res > 0 then
            for k,v in pairs(res) do 
                contacts[number][#contacts[number] + 1] = {v.name,v.number} 

            end
            triggerClientEvent(player, "phone->loadC->contact", player,contacts[number])
        else
            triggerClientEvent(player, "phone->loadC->contact", player,contacts[number])
        end
    end,sql,"SELECT * FROM mobil_c WHERE owner_n=? ORDER BY id DESC",number);
   
end
addEvent("phone->load->contact",true)
addEventHandler("phone->load->contact", getRootElement(), load_contact)

function add_contact( player,number,addname,addnumber )
    dbExec(sql, "INSERT INTO `mobil_c` SET owner_n = ?, name = ? , number = ? ",number,addname,addnumber)
end
addEvent("phone->add->contact",true)
addEventHandler("phone->add->contact", getRootElement(), add_contact)

function delete_contact( player,number,addnumber )
    dbExec(sql, "DELETE FROM `mobil_c` WHERE owner_n = ? and number = ?",number ,addnumber)

    load_contact(player,number)

end
addEvent("phone->delete->contact",true)
addEventHandler("phone->delete->contact", getRootElement(), delete_contact)

function save_bg( player,number,bg)
    dbExec(sql, "UPDATE `phones` SET wallpaper = ? WHERE number = ?",bg,number)
end
addEvent("phone->save->bg",true)
addEventHandler("phone->save->bg", getRootElement(), save_bg)