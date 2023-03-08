local allowFactions = {
    --id = {rövid, hosszú mint a faszom, szín (blue,green,orange)}
    [53] = {"LSPD","Los Santos Police Department","blue"},
    [56] = {"LSCM","Los Santos Car Mechanic","servercolor"},
    [68] = {"LS Taxi","Los Santos Taxi","orange"},
    --[5] = {"FBI","Federal Bureau of Investigation","blue"},
    [55] = {"LSFD","Los Santos Medical Center","red"},
    [52] = {"GOV","Los Santos Government","red"},
    [54] = {"ATF","Bureau of Alcohol, Tobacco and Firearms","blue"},
    --[37] = {"LS Carshop","Los Santos Car Shops","orange","gov"},
    --[46] = {"LS Vontató","Los Santos Vontató Társasság","orange","gov"},
    --[49] = {"SCN","Social City News","orange","gov"},
};

function sendRadio(player,command,...)
    if getElementData(player,"loggedIn") then 
        if (getElementData(player,"char >> radiof") or 0) == 0 then 
            outputChatBox(exports.fv_engine:getServerSyntax("Chat","red").."No radio frequency is set",player,255,255,255,true);
            return;
        end
        local msg = table.concat({...}, " ");
        if exports.fv_inventory:hasItem(player,86) then 
            for k,v in pairs(getElementsByType("player")) do 
                if getElementData(v,"loggedIn") then 
                    if getElementData(player,"char >> radiof") == getElementData(v,"char >> radiof") then 
                        outputChatBox("#00D0FF" .. getElementData(player,"char >> name") .. " says (on the radio): ".. msg, v, 255, 255, 255, true);
                        triggerClientEvent(v,"radio.sound",v);
                    end
                end
            end

            local x,y,z = getElementPosition(player);
            for k,v in pairs(getElementsByType("player",_,true)) do 
                if not isPedDead(v) and v ~= player then 
                    local x1,y1,z1 = getElementPosition(v);
                    local distance = getDistanceBetweenPoints3D(x,y,z,x1,y1,z1);
                    if distance < 10 then 
                        if getElementDimension(player) == getElementDimension(v) and getElementInterior(player) == getElementInterior(v) then 
                            outputChatBox(getElementData(player,"char >> name") .. " says (on the radio): ".. msg, v, 255, 255, 255, true);
                        end
                    end
                end
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Chat","red").."You don't have a radio!",player,255,255,255,true);
        end
    end
end
addCommandHandler("r",sendRadio,false,false);
addCommandHandler("Radio",sendRadio,false,false);


function tuneRadio(player,command,freki)
    if getElementData(player,"loggedIn") then 
        if not tonumber(freki) or not freki or not math.floor(tonumber(freki)) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Frequency]",player,255,255,255,true);
            return;
        end
        local freki = math.floor(tonumber(freki));
        if exports.fv_inventory:hasItem(player,86) then 
            setElementData(player,"char >> radiof",freki);
            outputChatBox(exports.fv_engine:getServerSyntax("Chat","servercolor").."You have successfully set the frequency of your radio! Frequency: "..exports.fv_engine:getServerColor("servercolor",true)..freki..white..".",player,255,255,255,true);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Chat","red").."You don't have a radio!",player,255,255,255,true);
        end
    end
end
addCommandHandler("tuneradio",tuneRadio,false,false);

function surgossegiRadio(player,command,...)
    if getElementData(player,"loggedIn") then 
        if not ... then 
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Message]",player,255,255,255,true);
            return;
        end

        local faction,id = isAllowedFaction(player);
        if faction and not (id == 68 or id == 56) then 
            local msg = table.concat({...}, " ");
            for k, v in ipairs(getElementsByType("player")) do
                if getElementData(v, "loggedIn")  then
                    local x,fid = isAllowedFaction(v);
                    if x and not (id == 68 or id == 56) then
                        outputChatBox("#F62459[" .. faction[1] .. "] " .. getElementData(player,"char >> name") .. " says (on the radio): " .. msg, v, 255, 100, 0, true)
                        triggerClientEvent(v, "radio.sound", v)
                    end
                end
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Chat","red").."You do not belong to an authorized faction!",player,255,255,255,true);
        end
    end
end
addCommandHandler("d",surgossegiRadio,false,false);


function megaphone(player,command, ...)
    local faction,id = isAllowedFaction(player);
	if faction and not (id == 68 or id == 56) then
		if not (...) then
			outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/" .. command .. " [Message]", player, 255, 255, 255, true);
		else
			for k, v in ipairs(getElementsByType("player")) do
				local x, y, z = getElementPosition(player);
				local tx, ty, tz = getElementPosition(v);
				local int, dim = getElementInterior(player), getElementDimension(player);
				local tint, tdim = getElementInterior(v), getElementDimension(v);
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz);
				local msg = table.concat({...}, " ");
				if distance <= 40 and int == tint and dim == tdim and getElementData(v, "loggedIn") then
					outputChatBox("#F6FF00" .. (getElementData(player,"char >> name") or getPlayerName(player)) .. " says <O: " .. msg, v, 255, 255, 255, true);
				end
			end
		end
    end
end
addCommandHandler("m", megaphone, false, false)
addCommandHandler("megaphone", megaphone, false, false)

function govCommand(player,command,...)
    if getElementData(player,"loggedIn") then 
        local faction = isAllowedFaction(player);
        if faction then 
            if not (...) then 
                outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/" .. command .. " [Message]", player, 255, 255, 255, true);
                return;
            end
            local message = table.concat({...}," ");
            local color = exports.fv_engine:getServerColor(faction[3],true);
            local sColor = exports.fv_engine:getServerColor("servercolor",true);
            for k,v in pairs(getElementsByType("player")) do 
                if getElementData(v,"loggedIn") then 
                    outputChatBox(color.."======["..faction[2].." - Felhívás]======",v,255,255,255,true);
                    outputChatBox(message,v,255,255,255,true);
                    if getElementData(v,"admin >> level") > 3 and getElementData(v,"admin >> duty") then 
                        outputChatBox("~ "..sColor..getElementData(player,"char >> name"),v,255,255,255,true);
                    end
                end
            end
        end
    end
end
addCommandHandler("gov",govCommand,false,false);

function isAllowedFaction(player)
    local value = false;
    local fid = false;
    for k,v in pairs(allowFactions) do 
        if getElementData(player,"faction_"..k) then 
            value = v;
            fid = k;
            break;
        end
    end
    return value,fid;
end