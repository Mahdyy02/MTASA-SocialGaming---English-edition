--SOCIAL GAMING 2019
--CSOKI
local state = false;

function boneBreaked(e)
    local bone = getElementData(e, "char >> bone") or {true, true, true, true, true};
    if not bone[2] or not bone[3] then 
        return true;
    end
    return false;
end

function check()
if getElementData(localPlayer,"char >> pulling") then 
    local veh = getPedOccupiedVehicle(localPlayer);
    if veh then 
        if getElementData(veh,"veh:ablak") then 
            enableCrosshair(false);
        end
    else 
        enableCrosshair(false);
    end
end
end

function enableCrosshair(state)
    setPlayerHudComponentVisible("crosshair", state);
    setPedDoingGangDriveby(localPlayer, state);
    setElementData(localPlayer,"char >> pulling",state);
    if state then 
        removeEventHandler("onClientRender",root,check);
        addEventHandler("onClientRender",root,check);
    else 
        removeEventHandler("onClientRender",root,check);
    end
end

function bind()
    if isPedInVehicle(localPlayer) then 
        local seat = getPedOccupiedVehicleSeat(localPlayer);
        local veh = getPedOccupiedVehicle(localPlayer);
        if getElementData(veh,"veh:ablak") then 
            outputChatBox(exports.fv_engine:getServerSyntax("Pull","red").."Csak lehúzott ablaknál tudsz kihajolni!",255,255,255,true);
            return;
        end
        if seat > 0 then
            if boneBreaked(localPlayer) then 
                outputChatBox(exports.fv_engine:getServerSyntax("Pull","red").."Törött kézzel nem tudsz kihajolni!",255,255,255,true);
            else 
                if (getPedWeapon(localPlayer) > 21 or getPedWeapon(localPlayer) < 39) and not (getPedWeapon(localPlayer) == 23) then 
                    state = not state;
                    enableCrosshair(state); 
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Pull","red").."Nincs nálad fegyver, vagy ezzel a fegyverrel nem hajolhatsz ki!",255,255,255,true);
                end
            end
        end
    end
end

addEventHandler("onClientElementDataChange",localPlayer,function(dataName,old,new)
    if dataName == "weaponusing" then 
        if not new then 
            enableCrosshair(false);
        end
    end
end);

bindKey("x","down",bind);