local e = exports.fv_engine;
local sx,sy = guiGetScreenSize();
local white = "#FFFFFF";
local w,h = 0,0;
local state = "close";
local tick = getTickCount();
local allSlot = 0;
local scroll = 0;

addEventHandler("onClientResourceStart",root,function(res)
    if getThisResource() == res or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        sColor = {e:getServerColor("servercolor",false)};
        sColor2 = e:getServerColor("servercolor",true);
        topFont = e:getFont("rage",14);
        font = e:getFont("rage",11);
    end
end);

addEvent("score.returnSlot",true);
addEventHandler("score.returnSlot",root,function(data)
    allSlot = data;
end);

bindKey("tab","down",function()
    if state ~= "open" then 
        triggerServerEvent("score.getSlot",localPlayer,localPlayer);
        removeEventHandler("onClientRender",root,render);
        addEventHandler("onClientRender",root,render);
        state = "open";
        tick = getTickCount();
        unbindKey("mouse_wheel_up","down",scrollUp);
        unbindKey("mouse_wheel_down","down",scrollDown);
        bindKey("mouse_wheel_up","down",scrollUp);
        bindKey("mouse_wheel_down","down",scrollDown);
        playSound("open.mp3",false);
    end
end);

bindKey("tab","up",function()
    if state == "open" then 
        state = "close";
        tick = getTickCount();
        playSound("open.mp3",false);
    end
end);

function scrollDown()
    if scroll < #getElementsByType("player") - 19 then 
        scroll = scroll + 1;
    end
end

function scrollUp()
    if scroll > 0 then 
        scroll = scroll - 1;
    end
end

function render()
    if state == "open" then 
        w,h = interpolateBetween(0,0,0,500,500,0,(getTickCount()-tick)/500,"OutBack");
    elseif state == "close" then 
        w,h = interpolateBetween(500,500,0,0,0,0,(getTickCount()-tick)/500,"OutBack");
        if w == 0 then 
            unbindKey("mouse_wheel_up","down",scrollUp);
            unbindKey("mouse_wheel_down","down",scrollDown);
            removeEventHandler("onClientRender",root,render);
        end
    end

    local players = getElementsByType("player");
    table.sort(players,function(a,b)
        if a ~= localPlayer and b ~= localPlayer then
            return (getElementData(a,"char >> id") or 1000) < (getElementData(b,"char >> id") or 1000);
        end
    end);

    if h > 80 and w > 100 then 
    dxDrawRectangle(sx/2-w/2-3,sy/2-h/2,3,h,tocolor(sColor[1],sColor[2],sColor[3],180));
    end

    for i=1,20 do 
        local color = tocolor(60,60,60,250);
        if i%2 == 0 then 
            color = tocolor(40,40,40,250);
        end
        dxDrawRectangle(sx/2-w/2,sy/2-h/2-25+(i*(h/20)),w,h/20,color);
    end

    if w > 300 then 
        shadowedText(sColor2.."The"..white.."Devils - Scoreboard",sx/2-w/2,sy/2-h/2-25,sx/2-w/2+w,h,tocolor(255,255,255),1,topFont,"center");
        --Header--
        dxDrawText("ID",sx/2-w/2+10,sy/2-h/2-25+(1*(h/20)),w,sy/2-h/2-25+(1*(h/20))+h/20,tocolor(255,255,255),1,font,"left","center");
        dxDrawText("Name",sx/2-w/2+60,sy/2-h/2-25+(1*(h/20)),w,sy/2-h/2-25+(1*(h/20))+h/20,tocolor(255,255,255),1,font,"left","center");
        dxDrawText("Online time",sx/2-w/2,sy/2-h/2-25+(1*(h/20)),sx/2-w/2+w-195,sy/2-h/2-25+(1*(h/20))+h/20,tocolor(255,255,255),1,font,"right","center");
        dxDrawText("Hours",sx/2-w/2,sy/2-h/2-25+(1*(h/20)),sx/2-w/2+w-90,sy/2-h/2-25+(1*(h/20))+h/20,tocolor(255,255,255),1,font,"right","center");
        dxDrawText("Ping",sx/2-w/2,sy/2-h/2-25+(1*(h/20)),sx/2-w/2+w-10,sy/2-h/2-25+(1*(h/20))+h/20,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
        ---------

        local count = 1;
        for k,v in pairs(players) do 
            if k > scroll and count < 20 then 
                count = count + 1;
                local id = (getElementData(v,"char >> id") or 1000);
                if (getElementData(v,"loggedIn") or false) then 
                    local name = exports.fv_admin:getAdminName(v);
                    local onlineTime = (getElementData(v,"onlineTime") or 0);
                    local level = (exports.fv_interface:getPlayerLevel(v) or 1);
                    local ping = (getPing(v));

                    if (getElementData(v,"admin >> duty") and getElementData(v,"admin >> level") > 2) or (getElementData(v,"admin >> level") > 0 and getElementData(v,"admin >> level") < 3) then
                        --local rang = exports['fv_admin']:getAdminTitle(v)
                        local aColor = exports.fv_admin:getAdminColor(v);
                        --name = name..aColor.." ["..rang.."]"
                        name = aColor..name
                    end
                    dxDrawText(id,sx/2-w/2+10,sy/2-h/2-25+(count*(h/20)),w,sy/2-h/2-25+(count*(h/20))+h/20,tocolor(255,255,255,200),1,font,"left","center");
                    dxDrawText(name,sx/2-w/2+60,sy/2-h/2-25+(count*(h/20)),w,sy/2-h/2-25+(count*(h/20))+h/20,tocolor(255,255,255,200),1,font,"left","center",false,false,false,true);
                    dxDrawText(SecondsToClock(onlineTime),sx/2-w/2,sy/2-h/2-25+(count*(h/20)),sx/2-w/2+w-200,sy/2-h/2-25+(count*(h/20))+h/20,tocolor(255,255,255,200),1,font,"right","center");
                    dxDrawText(level,sx/2-w/2,sy/2-h/2-25+(count*(h/20)),sx/2-w/2+w-100,sy/2-h/2-25+(count*(h/20))+h/20,tocolor(255,255,255,200),1,font,"right","center");
                    dxDrawText(ping,sx/2-w/2,sy/2-h/2-25+(count*(h/20)),sx/2-w/2+w-10,sy/2-h/2-25+(count*(h/20))+h/20,tocolor(255,255,255,200),1,font,"right","center",false,false,false,true);
                else 
                    dxDrawText(id,sx/2-w/2+10,sy/2-h/2-25+(count*(h/20)),w,sy/2-h/2-25+(count*(h/20))+h/20,tocolor(100,100,100),1,font,"left","center");
                    dxDrawText("You are not logged in!",sx/2-w/2+150,sy/2-h/2-25+(count*(h/20)),sx/2-w/2+w,sy/2-h/2-25+(count*(h/20))+h/20,tocolor(100,100,100),1,font,"center","center");
                    dxDrawText(getPlayerName(v):gsub("#%x%x%x%x%x%x",""),sx/2-w/2+60,sy/2-h/2-25+(count*(h/20)),w,sy/2-h/2-25+(count*(h/20))+h/20,tocolor(100,100,100),1,font,"left","center");
                    dxDrawText(getPlayerPing(v),sx/2-w/2,sy/2-h/2-25+(count*(h/20)),sx/2-w/2+w-10,sy/2-h/2-25+(count*(h/20))+h/20,tocolor(100,100,100),1,font,"right","center",false,false,false,true);
                end
            end
        end
        shadowedText(sColor2..#players..white.." / "..allSlot,sx/2-w/2,sy/2+h/2,sx/2-w/2+w,h,tocolor(255,255,255),1,topFont,"center");
    end
end

function getPing(element)
    local ping = getPlayerPing(element);
    if ping > 160 then 
        ping = e:getServerColor("red",true) .. ping;
    elseif ping < 101 and ping > 80 then 
        ping = e:getServerColor("orange",true) .. ping;
    else
        ping = e:getServerColor("servercolor",true) .. ping;
    end
    return ping;
end

setTimer(function()
    if getElementData(localPlayer,"loggedIn") then 
        local c = (getElementData(localPlayer,"onlineTime") or 0);
        setElementData(localPlayer,"onlineTime",c + 1);
    end
end,1000,0);

--UTILS--
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end
function SecondsToClock(seconds)
	local seconds = tonumber(seconds)
  	if seconds <= 0 then
		return "00:00:00";
	else
		local hours = string.format("%02.f", math.floor(seconds/3600));
		local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
		local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
		return hours..":"..mins..":"..secs
	end
end