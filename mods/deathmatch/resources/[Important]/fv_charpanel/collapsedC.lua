--Script by Csoki 2019 | SocialGaming

--Set Default values
setElementData(localPlayer,"collapsed",false);
setElementData(localPlayer,"getupTarget",false);
setElementData(localPlayer,"getupHelper",false); 
-----------------------

addEventHandler("onClientRender",root,function()
    if getElementData(localPlayer,"loggedIn") then 
        local health = getElementHealth(localPlayer);
        if not isPedDead(localPlayer) and health > 0 and health < 21 then 
            if not getElementData(localPlayer,"collapsed") then 
                setElementData(localPlayer,"collapsedTime",downTime);

                triggerServerEvent("collapsed.anim",localPlayer,localPlayer,"start");
                setElementData(localPlayer,"getupHelper",false);
                setElementData(localPlayer,"getupTarget",false);
                setElementData(localPlayer,"collapsed",true);
            end
        elseif isPedDead(localPlayer) or health > 20 then 
            if getElementData(localPlayer,"collapsed") then 
                setElementData(localPlayer,"collapsedTime",0);
                local timer = getElementData(localPlayer,"collapsedTimer") or false;
                if isTimer(timer) then 
                    killTimer(timer);
                    setElementData(localPlayer,"collapsedTimer",false);
                end
                triggerServerEvent("collapsed.anim",localPlayer,localPlayer,"stop");
                setElementData(localPlayer,"collapsed",false);
                setElementData(localPlayer,"getupHelper",false);
                setElementData(localPlayer,"getupTarget",false);
            end
        end

        if getElementData(localPlayer,"collapsed") then 
            setElementFrozen(localPlayer,true);
            local font = exports.fv_engine:getFont("rage", 24)
            local time = getElementData(localPlayer,"collapsedTime");
            exports.fv_engine:shadowedText(SecondsToClock(time),0,sy/2, sx, sy/2, tocolor(255,255,255), 1, font, "center", "top");
        end
    end
end);


--UTILS--
function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
    if seconds and seconds <= 0 then
        return "00:00";
    else
	    hours = string.format("%02.f", math.floor(seconds/3600));
	    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
	    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
	    return mins..":"..secs
    end
end
