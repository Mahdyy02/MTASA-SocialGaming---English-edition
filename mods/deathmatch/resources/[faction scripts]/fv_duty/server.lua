local sql = exports.fv_engine:getConnection(getThisResource());

addEvent("duty.interaction",true);
addEventHandler("duty.interaction",root,function(player,show,state,skin)
    if not state then
        setElementData(player,"duty.faction",false);
        outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."You have successfully left the service!",player,255,255,255,true);
        sendFactionMessage(player,show,state);
        exports.fv_inventory:takeDutyItems(player);
        setElementModel(player,getElementData(player,"char >> civilSkin"));
        setPedArmor(player, 0)
    else 
        setElementData(player,"duty.faction",show);
        outputChatBox(exports.fv_engine:getServerSyntax("Duty","servercolor").."You have successfully entered service!",player,255,255,255,true);
        setPedArmor(player, 100)
        sendFactionMessage(player,show,state);
        if dutyItems[show] and #dutyItems[show] > 0 then 
            for k,v in pairs(dutyItems[show]) do 
                local id,darab,ertek,allapot = unpack(v);
                 local suc = exports.fv_inventory:givePlayerItem(player,id,darab,ertek,allapot,1);
                    if not suc then 
                    outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."The duty item does not fit you! ("..exports.fv_inventory:getItemName(id)..").",player,255,255,255,true);
                 end
            end
        end
        setElementData(player,"char >> civilSkin",getElementModel(player));
        setElementModel(player,skin);
    end
end);

function sendFactionMessage(player,fid,state)
    for k,v in pairs(getElementsByType("player")) do 
        if player ~= v then 
            if getElementData(v,"faction_"..fid) then 
                if state then 
                    outputChatBox(syntax(exports.fv_dash:getFactionName(fid))..exports.fv_admin:getAdminName(player).." entered service!",v,255,255,255,true);
                else 
                    outputChatBox(syntax(exports.fv_dash:getFactionName(fid))..exports.fv_admin:getAdminName(player).." left the service!",v,255,255,255,true);
                end
            end
        end
    end
end

function syntax(text)
    local color = exports.fv_engine:getServerColor("blue",true);
    return color.."["..text.."]: #FFFFFF"
end



--DutySkin--
addEvent("duty.setSkin",true);
addEventHandler("duty.setSkin",root,function(player,f,skin)
    local accID = getElementData(player,"acc >> id");
    dbExec(sql,"UPDATE playerFactions SET dutyskin=? WHERE dbid=? AND faction=?",skin,accID,f);
    setElementData(player,"faction_"..f.."_dutyskin",skin);
    exports.fv_infobox:addNotification(player,"info","You have successfully set up your dutyskin!");    
    if isCursorShowing(player) then
        showCursor(player, false)
    end
end);