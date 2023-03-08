local allowedFactions = {53, 54};
local jailPos = {
    {1969.3695068359, -1374.5942382813, 997.17895507813,0,16},
    {223.83226013184, 114.93488311768, 999.015625,10,1755},
};
local jailMarkers = {};

addEventHandler("onClientResourceStart",resourceRoot,function()
    jailMarkers = {};
    local r,g,b = exports.fv_engine:getServerColor("green",false);
    for k,v in pairs(jailPos) do 
        local x,y,z,interior,dimension = unpack(v);
        local marker = createMarker(x,y,z-3.2,"cylinder",2.5,r,g,b,100);
        setElementInterior(marker,interior);
        setElementDimension(marker,dimension);
        jailMarkers[#jailMarkers + 1] = marker;
    end
end);

function jailPlayer(command,target,time,...)
if not isPos(localPlayer) then outputChatBox(e:getServerSyntax("Prison","red").."You are not in the right place. (Marker)",255,255,255,true) return end;
if not isFaction(localPlayer) then outputChatBox(e:getServerSyntax("Prison","red").."You don't belong to a faction!",255,255,255,true) return end;
    if not target or not ... or not time or not tonumber(time) or not math.floor(tonumber(time)) then 
        outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [ID / Name] [Time (Minutes)] [Reason]",255,255,255,true);
        return;
    end
    local targetPlayer = exports.fv_engine:findPlayer(localPlayer,target);
    if targetPlayer then 
        if targetPlayer == localPlayer then 
            outputChatBox(e:getServerSyntax("Prison","red").."You can't arrest yourself!",255,255,255,true);
            return;
        end
        if isPos(targetPlayer) then 
            local time = math.floor(tonumber(time));
            local reason = table.concat({...}," ");
            if time > 400 then 
                outputChatBox(e:getServerSyntax("Prison","red").."You can't give more than 400 minutes!",255,255,255,true);
                return;
            end
            triggerServerEvent("icjail.player",localPlayer,localPlayer,targetPlayer,time,reason);
        else 
            outputChatBox(e:getServerSyntax("Prison","red").."Player is not in the specified location. (Marker)",255,255,255,true);
        end
    else 
        outputChatBox(e:getServerSyntax("Prison","red").."Player not found!",255,255,255,true);
    end
end
addCommandHandler("jail",jailPlayer,false,false);


function isPos(player)
    local state = false;
    for k,v in pairs(jailMarkers) do 
        if isElementWithinMarker(player,v) then 
            state = true;
            break;
        end
    end
    return state;
end

function isFaction(player)
    local state = false;
    for k,v in pairs(allowedFactions) do 
        if getElementData(localPlayer,"faction_"..v) then 
            state = true;
            break;
        end
    end
    return state;
end


--Marker Imgage--
local distance = 50;
local jailTexture = dxCreateTexture("jail.png","dxt5");

addEventHandler("onClientPreRender", root, function()
    for i, v in ipairs(jailMarkers) do
        local x,y,z = getElementPosition(v)     
        local x2,y2,z2 = getElementPosition(localPlayer)  
        local r, g, b, a = getMarkerColor(v)
        local distancePoints = getDistanceBetweenPoints3D(x, y, z, x2,y2,z2)
		if getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v) == getElementInterior(localPlayer) then
            if distancePoints <= distance then
				local size = getMarkerSize(v)
                dxDrawMaterialLine3D(x+size/2, y+size/2, z+2.5, x-size/2, y-size/2, z+2.5, jailTexture, size*1.4, tocolor(r, g, b, 155),x,y,z)
			end
		end
    end
end)
--------------


--JAIL INFO--
local jailData = {};

addEventHandler("onClientResourceStart",resourceRoot,function()
    if getElementData(localPlayer,"loggedIn") then 
        local newValue = getElementData(localPlayer,"icjail.data");
        if newValue and newValue[1] == 1 then 
            jailData = {
                reason = newValue[3],
                time = tostring(newValue[2]),
                alltime = tostring(newValue[5]),
            };
            removeEventHandler("onClientRender",root,renderJail);
            addEventHandler("onClientRender",root,renderJail);
            triggerServerEvent("icjail.start",localPlayer,localPlayer,newValue);
        end
    end
end);

addEventHandler("onClientElementDataChange",localPlayer,function(dataName,oldValue,newValue)
    if dataName == "icjail.data" then 
        if getElementData(localPlayer,"loggedIn") then 
            local newValue = getElementData(localPlayer,dataName);
            if newValue and newValue[1] == 1 then 
                jailData = {
                    reason = newValue[3],
                    time = tostring(newValue[2]),
                    alltime = tostring(newValue[5]),
                };
                removeEventHandler("onClientRender",root,renderJail);
                addEventHandler("onClientRender",root,renderJail);
            elseif not newValue then
                jailData = {};
                removeEventHandler("onClientRender",root,renderJail);
            end
        end
    end
end);

function renderJail()
    local font = exports.fv_engine:getFont("rage",15);
    local sColor = exports.fv_engine:getServerColor("servercolor",true);
    shadowedText("Prison\ncause: "..sColor..jailData.reason..white.."\nTime: "..sColor..jailData.alltime..white.." perc\nRemaining time: "..sColor..jailData.time..white.." perc",0,0,sx,sy,tocolor(255,255,255),1,font,"center","top",false,false,false,true);
end

--UTILS--
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end