addEventHandler("onClientElementDataChange",localPlayer,function(dataName)
    if dataName == "char >> playedtime" then 
        -- setElementData(localPlayer,"char >> level",getPlayerLevel(localPlayer));
        triggerServerEvent("ac.elementData",localPlayer,localPlayer,"char >> level",getPlayerLevel(localPlayer));
    end
end);

function findID(cmd, id)
    if not id then
        local syntax = exports['fv_engine']:getServerSyntax("Használat", "red")
        outputChatBox(syntax .. " /"..cmd.." [target]", 255,255,255,true)
        return
    end

    local target = exports['fv_engine']:findPlayer(localPlayer, id)
    if target then
        local syntax = exports['fv_engine']:getServerSyntax("ID", "servercolor")
        local blue = exports.fv_engine:getServerColor("blue",true);
        outputChatBox(syntax ..blue.. tostring(exports['fv_admin']:getAdminName(target)) ..white.. " idje: " ..blue..tonumber(getElementData(target, "char >> id") or -1)..white..".", 255,255,255,true)
    else
        local syntax = exports['fv_engine']:getServerSyntax("ID", "error")
        outputChatBox(syntax .. "A játékos nem található", 255,255,255,true)
    end
end
addCommandHandler("id", findID)

function findLevel(cmd, id)
    if not id then
        local syntax = exports['fv_engine']:getServerSyntax("Használat", "red")
        outputChatBox(syntax .. " /"..cmd.." [target]", 255,255,255,true)
        return
    end

    local target = exports['fv_engine']:findPlayer(localPlayer, id)
    if target then
        local syntax = exports['fv_engine']:getServerSyntax("Szint", "servercolor");
        local blue = exports.fv_engine:getServerColor("blue",true);
        outputChatBox(syntax ..blue.. tostring(exports['fv_admin']:getAdminName(target)) ..white.. " szintje: " ..blue.. tonumber(getPlayerLevel(target) or 1)..white..".", 255,255,255,true)
    else
        local syntax = exports['fv_engine']:getServerSyntax("Szint", "error")
        outputChatBox(syntax .. "A játékos nem található", 255,255,255,true)
    end
end
addCommandHandler("level", findLevel)
addCommandHandler("lvl", findLevel)
addCommandHandler("szint", findLevel)

