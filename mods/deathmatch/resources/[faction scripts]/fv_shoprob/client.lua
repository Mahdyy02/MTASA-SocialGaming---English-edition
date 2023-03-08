e = exports.fv_engine;

local sx,sy = guiGetScreenSize();
local clickTick = getTickCount();
local state = 0;
local clicked = false;
local load = -1;

local moneyPos = {
    [1] = {sx/2-135,sy/2+30},
    [2] = {sx/2-60,sy/2+30},
    [3] = {sx/2+10,sy/2+30},
    [4] = {sx/2+85,sy/2+30},
    [5] = {sx/2-138,sy/2+180},
    [6] = {sx/2-60,sy/2+180},
    [7] = {sx/2+10,sy/2+180},
    [9] = {sx/2+85,sy/2+180},
}

local moneys = {};

addEventHandler("onClientResourceStart",root,function(res)
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        sColor = {e:getServerColor("servercolor",false)};
        red = {e:getServerColor("red",false)};
        font = e:getFont("rage",12);
        font2 = e:getFont("rage",10);
        white = '#FFFFFF'
    end
    if res == getThisResource() then 
        for k,v in pairs(getElementsByType("object")) do 
            if getElementModel(v) == 1514 then 
                setObjectBreakable(v,false);
            end
        end
    end
end);

function render(dt)
    local px,py,pz = getElementPosition(localPlayer);
    local ox,oy,oz = getElementPosition(clicked);
    if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) > 3 then 
        if state > 1 then 
            setElementData(clicked,"srob.state",false);
            setElementData(clicked,"srob.rabolja",localPlayer);
        end
        closeRob();
        outputChatBox(e:getServerSyntax("Shoprob","red").."Since you left the cashier, the robbery was interrupted.",255,255,255,true);
    end

    if isPedDead(localPlayer) then 
        if state > 1 then 
            setElementData(clicked,"srob.state",false);
            setElementData(clicked,"srob.rabolja",localPlayer);
        end
        closeRob();
        outputChatBox(e:getServerSyntax("Shoprob","red").."Since you died, the robbery was interrupted.",255,255,255,true);
    end

    if getElementData(clicked,"srob.rabolja") and getElementData(clicked,"srob.rabolja") ~= localPlayer then 
        closeRob();
        outputChatBox(e:getServerSyntax("Shoprob","red").."You can't rob!",255,255,255,true);
    end

    if state == 1 then 
        dxDrawRectangle(sx/2-150,sy/2-50,300,100,tocolor(0,0,0,180));
        dxDrawRectangle(sx/2-153,sy/2-50,3,100,tocolor(sColor[1],sColor[2],sColor[3],180));

        dxDrawText("Tunisian Devils - store Robbery",0,sy/2-70,sx,100,tocolor(255,255,255),1,font,"center","top");
        dxDrawText("Are you sure you want to rob the store?",0,sy/2-40,sx,100,tocolor(255,255,255),1,font,"center","top");

        local okColor = tocolor(sColor[1],sColor[2],sColor[3],180);
        if e:isInSlot(sx/2-110,sy/2,100,30) then 
            okColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                state = 2;
                load = -1;
                setElementData(clicked,"srob.state",false);
                setElementData(clicked,"srob.rabolja",localPlayer);
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx/2-110,sy/2,100,30,okColor);
        dxDrawText("Robbery",sx/2-110,sy/2,sx/2-110+100,sy/2+30,tocolor(255,255,255),1,font,"center","center");

        local noColor = tocolor(red[1],red[2],red[3],180);
        if e:isInSlot(sx/2+10,sy/2,100,30) then 
            noColor = tocolor(red[1],red[2],red[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                closeRob();
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx/2+10,sy/2,100,30,noColor);
        dxDrawText("Cancel",sx/2+10,sy/2,sx/2+10+100,sy/2+30,tocolor(255,255,255),1,font,"center","center");
    end
    if state == 2 then 
        dxDrawRectangle(sx/2-150,sy/2-50,300,100,tocolor(0,0,0,180));
        dxDrawRectangle(sx/2-153,sy/2-50,3,100,tocolor(sColor[1],sColor[2],sColor[3],180));

        load = load + (0.02*dt)/7
        if load > 200 then 
            generateMoney();
            state = 3;
            load = 200;
        end
        dxDrawText("You turn on the cash register...",0,sy/2-40,sx,100,tocolor(255,255,255),1,font,"center","top");
        dxDrawRectangle(sx/2-100,sy/2-15,200,30,tocolor(50,50,50));
        dxDrawRectangle(sx/2-100,sy/2-15,load,30,tocolor(sColor[1],sColor[2],sColor[3]));
        dxDrawText("Run to abort.",0,sy/2+20,sx,100,tocolor(255,255,255),1,font,"center","top");
    end
    if state == 3 then 

        local all = 0;
        for k,v in pairs(moneys) do 
            if v then 
                all = all + v;
            end
        end

        dxDrawImage(sx/2-200,sy/2-350,400,700,"bg.png");
        dxDrawText("Take the money out of the cash register.",0,sy/2-340,sx,100,tocolor(0,0,0),1,font,"center","top");

        dxDrawText("Checkout contents:\n"..tostring(formatMoney(all)).."dt",100,sy/2-280,sx,100,tocolor(0,0,0),1,font2,"center","top");

        for k,v in pairs(moneyPos) do 
            if moneys[k] then 
                dxDrawImage(v[1],v[2],55,99,"money.png");
                if e:isInSlot(v[1],v[2],55,99) and getKeyState("mouse1") and clickTick+300 < getTickCount() then 
                    triggerServerEvent("srob.giveMoney",localPlayer,localPlayer,moneys[k]);
                    moneys[k] = nil;


                    local all = 0;
                    for k,v in pairs(moneys) do 
                        if v then 
                            all = all + v;
                        end
                    end

                    if all <= 0 then 
                        closeRob();
                        outputChatBox(e:getServerSyntax("Shoprob","servercolor").."You robbed the store, the cops are on their way.",255,255,255,true);
                    end
                    clickTick = getTickCount();
                end
            end
        end

        local exitColor = tocolor(red[1],red[2],red[3],200);
        if e:isInSlot(sx/2-150/2,sy/2-40,150,25) then 
            exitColor = tocolor(red[1],red[2],red[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                closeRob();
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx/2-150/2,sy/2-40,150,25,exitColor);
        dxDrawBorder(sx/2-150/2,sy/2-40,150,25,2,tocolor(0,0,0));
        dxDrawText("Closure",sx/2-150/2,sy/2-40,sx/2-150/2+150,sy/2-40+25,tocolor(0,0,0),1,font,"center","center");
    end
end

addEventHandler("onClientClick",root,function(button,bstate,x,y,wx,wy,wz,clickedElement)
    if bstate == "down" and clickedElement and getElementData(clickedElement,"srob.loc") then 
        if isAfaction(localPlayer) then 
            local px,py,pz = getElementPosition(localPlayer);
            local distance = getDistanceBetweenPoints3D(wx,wy,wz,px,py,pz);
            if distance < 3 then 
                if state == 0 then 
                    if not getElementData(clickedElement,"srob.state") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Shoprob","red").."This store is currently not robbable. Wait: "..e:getServerColor("red",true)..(getElementData(clickedElement,"srob.timeleft"))..white.." minute",255,255,255,true);
                        return
                    end
                    if getElementData(clickedElement,"srob.rabolja") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Shoprob","red").."This shop has already been robbed / robbed!",255,255,255,true);
                        return;
                    end
                    local lehet = 0;
                    for k,v in pairs(getElementsByType("player")) do 
                        if getElementData(v,"loggedIn") then 
                            if getElementData(v,"faction_53") then 
                                lehet = lehet + 1;
                            end
                        end
                    end
                    if lehet > 0 then 
                        clicked = clickedElement;
                        state = 1;
                        removeEventHandler("onClientPreRender",root,render);
                        addEventHandler("onClientPreRender",root,render);
                        load = -1;
                    else 
                        outputChatBox(e:getServerSyntax("Shoprob","red").."Minimum "..e:getServerColor("red",true).."4"..white.." a law enforcement player must be online to rob.",255,255,255,true);
                        return;
                    end
                end
            end
        else 
            outputChatBox(e:getServerSyntax("Shoprob","red").."Only gangs /maffia can rob!",255,255,255,true);
            return;
        end
    end
end);

function closeRob()
    removeEventHandler("onClientPreRender",root,render);
    state = 0;
    clicked = false;
    load = -1;
end

function generateMoney()
    moneys = {};
    local no = math.random(0,100);
    if no > 10 then 
        for i=1,#moneyPos do 
            local rand = math.random(1,100);
            if rand < 50 then 
                moneys[i] = math.floor(tonumber(rand*120));
            end
        end
    end
    local all = 0;
    for k,v in pairs(moneys) do 
        all = all + v;
    end
    if all == 0 then 
        outputChatBox(e:getServerSyntax("Shoprob","red").."Unfortunately, the checkout is empty.",255,255,255,true);
    end
end


--UTILS--
function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end



allowedFactions = {
    7,8,9,10,20,24,15,26,16,31,18,38,60,43
}

function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function isAfaction(element)
    local found = false;
    for k,v in pairs(allowedFactions) do 
        if getElementData(element,"faction_"..v) then 
            found = true;
            break;
        end
    end
    return found;
end