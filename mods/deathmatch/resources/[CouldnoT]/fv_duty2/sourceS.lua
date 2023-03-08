local connection = exports.fv_engine:getConnection(getThisResource())

addEvent("comeToDuty", true)
addEventHandler("comeToDuty", root, function(faction, duty, skin, package)
    if duty then
        setElementData(source, "duty.faction", faction)
        if dutyPackages[faction][package].items then
            for k, v in pairs(dutyPackages[faction][package].items) do
                local given = exports.fv_inventory:givePlayerItem(source, v[1], v[2], v[3], v[4], 1)
                if not given then
                    outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."Nem fér el nálad a tárgy ("..exports.fv_inventory:getItemName(v[1])..").",source,255,255,255,true)
                end
            end
        end
        if dutyPackages[faction][package].armor then
            setPedArmor(source, dutyPackages[faction][package].armor)
        end
        setElementData(source,"char >> civilSkin", getElementModel(source));
        setElementModel(source, skin);
        outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."Szolgálatba léptél!", source,255,255,255,true)
        sendFactionMessage(source,faction,duty)
    else
        setPedArmor(source, 0)
        setElementData(source,"duty.faction",false)
        setElementModel(source,getElementData(source,"char >> civilSkin"))
        exports.fv_inventory:takeDutyItems(source)
        outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."Kiléptél a szolgálatból!", source,255,255,255,true)
        sendFactionMessage(source,faction,duty)
    end
end)

function sendFactionMessage(player,fid,state)
    for k,v in pairs(getElementsByType("player")) do 
        if player ~= v then 
            if getElementData(v,"faction_"..fid) then 
                if state then 
                    outputChatBox(syntax(exports.fv_dash:getFactionName(fid))..exports.fv_admin:getAdminName(player).." szolgálatba lépett!",v,255,255,255,true);
                else 
                    outputChatBox(syntax(exports.fv_dash:getFactionName(fid))..exports.fv_admin:getAdminName(player).." kilépett a szolgálatból!",v,255,255,255,true);
                end
            end
        end
    end
end

function syntax(text)
    local color = exports.fv_engine:getServerColor("blue",true);
    return color.."["..text.."]: #FFFFFF"
end