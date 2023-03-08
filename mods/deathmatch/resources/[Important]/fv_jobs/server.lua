--Job vehicle--

Async:setPriority("high")

addEvent("job.destroyVeh",true);
addEventHandler("job.destroyVeh",root,function(player)

    local veh = getElementData(player,"job.veh");
    if veh and isElement(veh) then 
        local dockBox = getElementData(veh,"dock.box");
        if dockBox and isElement(dockBox) then 
            destroyElement(dockBox);
        end

        for k,v in pairs(getAttachedElements(veh)) do --Ha valamit rá attacholtam akkor törlöm hogy ne lebegjen ott magába
            if isElement(v) then 
                destroyElement(v);
            end
        end

        destroyElement(veh);
        setElementData(player,"job.veh",false);
        outputChatBox(exports.fv_engine:getServerSyntax("Munka","orange").."Your work vehicle has been deleted!",player,255,255,255,true);
    end
end);

addEventHandler("onPlayerQuit",getRootElement(),function()
    if getElementData(source,"loggedIn") then 
        triggerEvent("job.destroyVeh",source,source);
    end
end);



--Vehicle UTILS--
function loadJobVeh(veh)
    if not isElement(veh) then return end;
    setElementAlpha(veh,100);
    setVehicleDamageProof(veh,true)
    --setElementCollisionsEnabled(veh,false);
    setTimer(function()
        setElementAlpha(veh,150);
            setTimer(function()
                --[[setElementAlpha(veh,150);
                setTimer(function()
                    setElementAlpha(veh,200);
                    setTimer(function()]]
                        setElementAlpha(veh,255);
                        setVehicleDamageProof(veh,false);
                        --setElementCollisionsEnabled(veh,true);
                    --end,1500,1);
                --end,1000,1);
            end,1000,1);
    end,1000,1);
end
