addEvent("anim - give", true)
addEventHandler("anim - give", root,
    function(ped, anim)
        setElementData(ped, "forceAnimation", anim)
        setTimer(setPedAnimation, 50, 2, ped, anim[1], anim[2], -1, false, true, false)
    end
)

addEvent("health - give", true)
addEventHandler("health - give", root,
    function(ped)
        setElementHealth(ped, 100)
    end
)
addEvent("GoServerToBackClient", true)
addEventHandler("GoServerToBackClient", root,
    function(veh, attacker, weapon)
        triggerClientEvent(attacker, "onClientVehicleDamageCopy", attacker, veh, attacker, weapon)
    end
)
addEvent("bone.outputChatBox",true);
addEventHandler("bone.outputChatBox",root,function(target,text)
    outputChatBox(text,target,255,255,255,true);

    local sColor = exports.fv_engine:getServerColor("servercolor",true);
    local white = "#FFFFFF";
    exports.fv_admin:sendMessageToAdmin(source,sColor..exports.fv_admin:getAdminName(source,true)..white.. " meggyógyította "..sColor..getElementData(target,"char >> name")..white.." játékost.",3);
    exports.fv_logs:createLog("AGYOGYIT",exports.fv_admin:getAdminName(source,true).." meggyógyította "..getElementData(target,"char >> name").." játékost.",source,target);
end);