local e = exports.fv_engine;
local sx,sy = guiGetScreenSize();
local guis = {};
local activeGUI = 0;
local clickTick = getTickCount();
local signFont = dxCreateFont("sign.ttf",28);
local currentPlayer = false;
local targetName = "";
local sign = "";
local signCount = 0;
local start = false;

--other--
local cache = {};
local suc = false;
---------

addEventHandler("onClientResourceStart",root,function(res)
    if getThisResource() == res or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        font = e:getFont("rage",13);
    end
end);

function manageGui(state) 
    if state then 
        activeGUI = 0;
        guis[1] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[1],5);
        
        guis[2] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[2],45);
    else 
        for k,v in pairs(guis) do 
            if isElement(v) then 
                destroyElement(v);
            end
        end
    end
end
manageGui(false);

function drawTicket()
    dxDrawImage(sx/2-200,sy/2-250,400,500,"bg.png");

    local penz = guiGetText(guis[1]);
    local indok = guiGetText(guis[2]);

    if penz ~= "" and not tonumber(penz) then 
        guiSetText(guis[1],"");
    end

    e:shadowedText(formatMoney(penz),sx/2-150/2,sy/2-125,sx/2-150/2+150,0,tocolor(255,255,255),1,font,"center");
    if activeGUI == 1 then 
        dxDrawText("|",sx/2-150/2+5+dxGetTextWidth(formatMoney(penz),1,font),sy/2-127,sx/2-150/2+150,0,tocolor(0,0,0,200 * math.abs(getTickCount() % 1000 - 500) / 500),1,font,"center");
    end
    e:shadowedText("$",sx/2-150/2,sy/2-125,sx/2-150/2+150,0,tocolor(255,255,255),1,font,"right");

    e:shadowedText(targetName,sx/2-55,sy/2-80,0,20,tocolor(255,255,255),1,font,"left");

    e:shadowedText(indok,sx/2-185,sy/2+10,370,20,tocolor(255,255,255),1,font,"left");
    if activeGUI == 2 then 
        dxDrawText("|",sx/2-185+5+dxGetTextWidth(indok,1,font),sy/2+7,400,20,tocolor(0,0,0,200 * math.abs(getTickCount() % 1000 - 500) / 500),1,font,"left");
    end

    local zone = getZoneName(getElementPosition(localPlayer));
    e:shadowedText(zone,sx/2-55,sy/2-58,250,20,tocolor(255,255,255),1,font,"left");

    local rt = getRealTime();
    local hour = rt.hour;
    local min = rt.minute;
    if hour < 10 then 
        hour = "0"..hour;
    end
    if min < 10 then 
        min = "0"..min;
    end
    local date = (rt.year+1900).."."..months[rt.month].."."..rt.monthday..". - "..hour..":"..min;
    e:shadowedText(date,sx/2-55,sy/2-35,250,20,tocolor(255,255,255),1,font);

    --dxDrawText(targetName,sx/2-166,sy/2+184,sx/2-166+160,sy/2+184+30,tocolor(0,0,0,180),1,signFont,"center","center");


    --dxDrawRectangle(sx/2+20,sy/2+184,160,30,tocolor(200,0,0,150));

    if tonumber(start) and (getTickCount()-start) % 50 <= 5 and signCount < string.len(getElementData(localPlayer,"char >> name")) then 
        signCount = signCount + 1;
        sign = string.sub(getElementData(localPlayer,"char >> name"),1,signCount)
        start = getTickCount();
    end
    dxDrawText(sign,sx/2+20,sy/2+184,sx/2+20+166,sy/2+184+30,tocolor(0,0,0,180),1,signFont,"center","center");


    local r,g,b = e:getServerColor("servercolor",false);
    local endColor = tocolor(r,g,b,180);
    if e:isInSlot(sx/2-100,sy/2+270,200,30) then 
        endColor = tocolor(r,g,b);
    end
    dxDrawRectangle(sx/2-100,sy/2+270,200,30,endColor);
    dxDrawBorder(sx/2-100,sy/2+270,200,30,2,tocolor(0,0,0));
    e:shadowedText("Ready",sx/2-100,sy/2+270,sx/2-100+200,sy/2+270+30,tocolor(255,255,255),1,font,"center","center");

    if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
        if e:isInSlot(sx/2-150/2,sy/2-130,150,25) then 
            guiBringToFront(guis[1]);
            activeGUI = 1;
        elseif e:isInSlot(sx/2-185,sy/2+10,370,20) then 
            guiBringToFront(guis[2]);
            activeGUI = 2;
        else 
            activeGUI = 0;
        end

        if e:isInSlot(sx/2+20,sy/2+184,160,30) then 
            start = getTickCount();
        elseif e:isInSlot(sx/2-100,sy/2+270,200,30) then 
            if guiGetText(guis[1]) == "" or guiGetText(guis[2]) == "" and not tonumber(guiGetText(guis[1])) and tonumber(guiGetText(guis[1])) < 0 then 
                outputChatBox(e:getServerSyntax("Ticket","red").."You filled it in incorrectly!",255,255,255,true);
                clickTick = getTickCount();
                return;
            end
            if sign ~= getElementData(localPlayer,"char >> name") then 
                outputChatBox(e:getServerSyntax("Ticket","red").."You didn't sign!",255,255,255,true);
                clickTick = getTickCount();
                return;
            end
            triggerServerEvent("ticket.sendOther",
                localPlayer,
                localPlayer,
                currentPlayer,
                {
                    tonumber(guiGetText(guis[1])),
                    targetName,
                    zone,
                    date,
                    guiGetText(guis[2]),
                    getElementData(localPlayer,"char >> name"),
                    localPlayer,
                }
            );

            manageGui(false);
            targetName = "";
            sign = "";
            signCount = 0;
            start = false;
            removeEventHandler("onClientRender",root,drawTicket);
            outputChatBox(e:getServerSyntax("Ticket","servercolor").."You have successfully handed over the card to the player!",255,255,255,true);

        end
        clickTick = getTickCount();
    end


    if not isElement(currentPlayer) then 
        manageGui(false);
        targetName = "";
        sign = "";
        signCount = 0;
        start = false;
        outputChatBox(e:getServerSyntax("Ticket","red").."Player exited, panel closed!",255,255,255,true);
        removeEventHandler("onClientRender",root,drawTicket);
    end
    local x,y,z = getElementPosition(localPlayer);
    local ox,oy,oz = getElementPosition(currentPlayer);
    if getDistanceBetweenPoints3D(x,y,z,ox,oy,oz) > 10 then 
        manageGui(false);
        targetName = "";
        sign = "";
        signCount = 0;
        start = false;
        outputChatBox(e:getServerSyntax("Ticket","red").."Player is very bessing from you, panel is closed!",255,255,255,true);
        removeEventHandler("onClientRender",root,drawTicket);
    end
end

function ticketPlayer(cmd, target)
    if getElementData(localPlayer,"faction_54") or getElementData(localPlayer,"faction_53") then --Rendőr / Sheriff
        if not target then  
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [Name / ID]",255,255,255,true);
            return;
        end

        local targetPlayer = exports.fv_engine:findPlayer(localPlayer,target);
        if targetPlayer then 

            --[[if targetPlayer == localPlayer then 
                outputChatBox(e:getServerSyntax("Ticket","red").."Magadat nem büntetheted meg!",255,255,255,true);
                return;
            end]]
            local x,y,z = getElementPosition(localPlayer);
            local ox,oy,oz = getElementPosition(targetPlayer);
            if getDistanceBetweenPoints3D(x,y,z,ox,oy,oz) < 10 then 
                currentPlayer = targetPlayer;
                manageGui(false);
                manageGui(true);
                targetName = getElementData(targetPlayer,"char >> name");
                sign = "";
                signCount = 0;
                start = false;
                removeEventHandler("onClientRender",root,drawTicket);
                addEventHandler("onClientRender",root,drawTicket);
            else 
                outputChatBox(e:getServerSyntax("Ticket","red").."Player is far from you!",255,255,255,true);
            end
        else 
            outputChatBox(e:getServerSyntax("Ticket","red").."Player not found",255,255,255,true);
            return;
        end
    end
end
addCommandHandler("ticket",ticketPlayer,false,false);


addEvent("ticket.showClient",true);
addEventHandler("ticket.showClient",root,function(data)
    cache = {};
    cache[1] = data[1];
    cache[2] = data[2];
    cache[3] = data[3];
    cache[4] = data[5];
    cache[5] = data[4];
    cache[6] = data[6];
    cache[7] = data[7];
    removeEventHandler("onClientRender",root,showTicket);
    addEventHandler("onClientRender",root,showTicket);
    sign = "";
    signCount = 0;
    start = false;

    outputChatBox(e:getServerSyntax("Ticket","servercolor").."Sign the fine!",255,255,255,true);
end);

function showTicket()
    dxDrawImage(sx/2-200,sy/2-250,400,500,"bg.png");

    local penz = cache[1]
    local indok = cache[2]

    e:shadowedText(formatMoney(penz),sx/2-150/2,sy/2-125,sx/2-150/2+150,0,tocolor(255,255,255),1,font,"center");
    e:shadowedText("$",sx/2-150/2,sy/2-125,sx/2-150/2+150,0,tocolor(255,255,255),1,font,"right");
  
    e:shadowedText(cache[2],sx/2-55,sy/2-80,0,20,tocolor(255,255,255),1,font,"left");

    e:shadowedText(cache[3],sx/2-55,sy/2-58,250,20,tocolor(255,255,255),1,font,"left");

    e:shadowedText(cache[4],sx/2-185,sy/2+10,370,20,tocolor(255,255,255),1,font,"left");

    e:shadowedText(cache[5],sx/2-55,sy/2-35,250,20,tocolor(255,255,255),1,font);

    dxDrawText(cache[6],sx/2+20,sy/2+184,sx/2+20+166,sy/2+184+30,tocolor(0,0,0,180),1,signFont,"center","center");

    if tonumber(start) and (getTickCount()-start) % 50 <= 5 and signCount < string.len(getElementData(localPlayer,"char >> name")) then 
        signCount = signCount + 1;
        sign = string.sub(getElementData(localPlayer,"char >> name"),1,signCount)
        start = getTickCount();
    end
    if signCount == string.len(getElementData(localPlayer,"char >> name")) and not suc then 
        suc = setTimer(function()
            removeEventHandler("onClientRender",root,showTicket);
            suc = false;
            triggerServerEvent("ticket.pay",localPlayer,localPlayer,cache);
            cache = {};
        end,1000,1);
    end
    dxDrawText(sign,sx/2-166,sy/2+184,sx/2-166+160,sy/2+184+30,tocolor(0,0,0,180),1,signFont,"center","center");
    if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
        if e:isInSlot(sx/2-166,sy/2+184,160,30) then 
            start = getTickCount();
            clickTick = getTickCount();
        end
    end
end


--UTILS--
function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end