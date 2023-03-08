local timers = {};

addEvent("taxiclock.start",true);
addEventHandler("taxiclock.start",root,function(player,veh)
    if not timers[veh] then 
        setElementData(veh,"taxiclock.state",true); 

        timers[veh] = setTimer(function()
            if isElement(veh) then 
                if getElementData(veh,"taxiclock.state") then 
                    local kmh = getVehicleSpeed(veh);
                    if kmh > 0 then 
                        local current = (getElementData(veh,"taxiclock.travelled") or 0);
                        setElementData(veh,"taxiclock.travelled",current + (kmh/120));
                    end
                end
            else 
                killTimer(timers[veh]);
                timers[veh] = false;
            end
        end,1000,0);
    end
end);

addEvent("taxiclock.stop",true);
addEventHandler("taxiclock.stop",root,function(player,veh)
    if timers[veh] then 
        killTimer(timers[veh]);
        timers[veh] = false;
    end
    setElementData(veh,"taxiclock.state",false); 
end);

addEvent("taxiclock.reset",true);
addEventHandler("taxiclock.reset",root,function(player,veh)
    if isTimer(timers[veh]) then 
        killTimer(timers[veh]);
    end
    timers[veh] = false;
    setElementData(veh,"taxiclock.state",false);
    setElementData(veh,"taxiclock.travelled",0);
end);

addEvent("taxiclock.paytaxi",true);
addEventHandler("taxiclock.paytaxi",root,function(player,veh,driver,cost)
    setElementData(player,"char >> money",getElementData(player,"char >> money") - cost);
    setElementData(driver,"char >> money",getElementData(driver,"char >> money") + cost);

    if isTimer(timers[veh]) then 
        killTimer(timers[veh]);
    end
    timers[veh] = false;
    setElementData(veh,"taxiclock.state",false);
    setElementData(veh,"taxiclock.travelled",0);
    
    outputChatBox(exports.fv_engine:getServerSyntax("taximeter","servercolor").."You have successfully paid the price of the taxi.",player,255,255,255,true);
    local sColor = exports.fv_engine:getServerColor("servercolor",true);
    outputChatBox(exports.fv_engine:getServerSyntax("taximeter","servercolor")..sColor..getElementData(player,"char >> name")..white.." paid the price of the taxi. "..sColor.."("..formatMoney(cost).." $)"..white..".",driver,255,255,255,true);
end);