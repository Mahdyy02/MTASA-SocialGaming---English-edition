local cache = {};
local timers = {};

addEventHandler("onResourceStart",resourceRoot,function()
    for k, v in pairs(pos) do 
        local loc,x,y,z,rot,dim,inter = unpack(v);
        local obj = createObject(1514,x,y,z,0,0,rot);
        cache[obj] = true; --Rabolható
        setElementData(obj,"srob.loc",loc);
        setElementData(obj,"srob.state",true);
        setElementData(obj,"srob.timeleft",0);
        setElementData(obj,"srob.rabolja",false);
    end
end);

addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "object" and getElementData(source,"srob.loc") then 
        if dataName == "srob.state" then 
            cache[source] = newValue;
            local obj = source;
            if newValue then 
                if timers[obj] then 
                    if isTimer(timers[obj]) then 
                        killTimer(timers[obj]);
                    end
                end
                setElementData(obj,"srob.rabolja",false);
            else 
                if timers[source] then 
                    killTimer(timers[source]);
                end
                setElementData(source,"srob.timeleft",120);
                timers[obj] = setTimer(function()
                    local timeLeft = (getElementData(obj,"srob.timeleft") or 0);
                    if timeLeft <= 0 then 
                        setElementData(obj,"srob.state",true);
                        setElementData(obj,"srob.rabolja",false);
                    else 
                        setElementData(obj,"srob.timeleft",timeLeft-1);
                    end
                end,1000*60,0);
                setElementData(obj,"srob.rabolja",true);
                alertFactions(obj);
            end
        end
    end
end);

function alertFactions(element)
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"loggedIn") then 
            if getElementData(v,"faction_53") or getElementData(v,"faction_15") then 
                outputChatBox(exports.fv_engine:getServerColor("red",true).."[Alarm]: "..exports.fv_engine:getServerColor("blue",true)..getElementData(element,"srob.loc")..white.." at cash register, hacked. All units are requested on site.",v,255,255,255,true);
            end
        end
    end
end


addEvent("srob.giveMoney",true);
addEventHandler("srob.giveMoney",root,function(player,money)
    if getElementData(player,"network") then 
        outputChatBox(exports.fv_engine:getServerSyntax("Shoprob","servercolor").."You took out a bundle of money. ("..exports.fv_engine:getServerColor("servercolor",true)..formatMoney(money)..white.."dt.)",player,255,255,255,true);
        setElementData(player,"char >> money",getElementData(player,"char >> money") + money);
    end
end);