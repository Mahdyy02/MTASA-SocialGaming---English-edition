local sx,sy = guiGetScreenSize();

--Core Exports--
e = exports.fv_engine;
red = {e:getServerColor("red",false)};
addEventHandler("onClientResourceStart",root,function(res)
    if getResourceName(res) == "fv_engine" or res == getThisResource() then 
        e = exports.fv_engine;
        red = {e:getServerColor("red",false)};
    end
end);
----------------

--Internet Check--
setElementData(localPlayer,"network",true);
local network = true;
local rot = 0;
local networkDebug = false;
addEventHandler("onClientRender",root,function()
    local current = getNetworkStats();
    if current["packetlossLastSecond"] > 10 or getPlayerPing(localPlayer) > 180 or (isTransferBoxActive() and getElementData(localPlayer,"loggedIn")) or current["packetlossTotal"] > 10 or current["messagesInResendBuffer"] > 5 or current["isLimitedByCongestionControl"] > 0 or current["isLimitedByOutgoingBandwidthLimit"] > 0 then 
        setElementData(localPlayer,"network",false);
        network = false;
        if networkDebug then 
            outputDebugString("network :: off");
        end
        if getNetworkStats()["packetlossLastSecond"] > 15 then 
            rot = rot + 1;
            exports.fv_blur:createBlur();
            shadowedText("",0,0,sx,sy,tocolor(red[1],red[2],red[3]),1,e:getFont("AwesomeFont",30),"center","center",false,false,true,false,rot);
            shadowedText("Connect to the server...",0,0,sx,sy+70,tocolor(255,255,255),1,e:getFont("rage",20),"center","center",false,false,true,false);
        end
    else 
        if not network then 
            setElementData(localPlayer,"network",true);
            network = true;
            if networkDebug then 
                outputDebugString("network :: on");
            end
        end
    end
end,true,"high+55");

function getNetworkState()
    return network;
end

addCommandHandler("networkdebug",function(cmd)
    if isDebugViewActive() then 
        networkDebug = not networkDebug;
        outputChatBox(e:getServerSyntax("Anticheat","servercolor").."Network Debug mod "..(networkDebug and "On" or "Off").."!",255,255,255,true);
    end
end);
--Internet Check End--

-- New ElementData+LoadString+TriggerServerEvent Protect--
addDebugHook("preFunction", function(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ...)
    local args = {...}
    local isSafeFunction = true
    
    for k,v in pairs(args) do
        args[k] = tostring(v)
    end
    
    if not (sourceResource and getResourceName(sourceResource)) then
        isSafeFunction = false
    end
    
    if not isSafeFunction then
        triggerServerEvent("unauthorizedFunction", localPlayer, sourceResource and getResourceName(sourceResource), functionName, luaFilename, luaLineNumber, args)
        return "skip"
    end
end, {"loadstring", "setElementData", "triggerServerEvent"});
-- New ElementData+LoadString+TriggerServerEvent Protect END--



--UTILS--
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY,a,b,c,d,rot)
	if not a then a = false end;
	if not b then b = false end;
	if not c then c = false end;
    if not d then d = true end;
    if not rot then rot = 0 end;
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, a,b,c,d,false,rot)
end