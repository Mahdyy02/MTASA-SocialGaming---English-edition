local alertedFactions = { 2 };

addEvent("detector.alert",true);
addEventHandler("detector.alert",root,function(player,pos,weap)
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"loggedIn") then 
            if allowFaction(v) then 
                outputChatBox(exports.fv_engine:getServerSyntax("Metal Detector","red").."Weapon detected "..exports.fv_engine:getServerColor("servercolor",true)..pos..white.." near. Weapon: "..exports.fv_engine:getServerColor("servercolor",true)..weap..white..".",v,255,255,255,true);
            end
        end
    end
end);

function allowFaction(element)
    local found = false;
    for k, v in pairs(alertedFactions) do  
        if getElementData(element,"faction_"..v) then 
            found = true;
            break;
        end
    end
    return found;
end