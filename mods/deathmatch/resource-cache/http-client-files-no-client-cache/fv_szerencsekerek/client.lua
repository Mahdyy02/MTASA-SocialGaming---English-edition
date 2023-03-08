--SocialGaming 2019
e = exports.fv_engine;
dx = exports.fv_dx;
local sx, sy = guiGetScreenSize();
local zoom = math.min(1,sx / 1980);
res = function(value)
    return zoom * value;
end
resFont = function(value)
    return math.ceil(zoom * value);
end
clickTick = 0;
local coinNPC = {
    show = false;

    ped = false;
    skin = 1;
    pos = {-2398.5942382813, -589.78649902344, 132.6484375};
    rotation = 270;
    interior = 0;
    dimension = 0;
    x,y,w,h = false,false,false,false;
};
coinNPC.w = res(400);
coinNPC.h = res(260);
coinNPC.x = sx/2 - coinNPC.w/2;
coinNPC.y = sy/2 - coinNPC.h/2;

--- Network cucc
_getKeyState = getKeyState;
getKeyState = function(key)
    if getElementData(localPlayer,"network") then 
        return _getKeyState(key);
    end
end
----
addEventHandler("onClientResourceStart",getRootElement(),function(resource)
    if resource == getThisResource() or getResourceName(resource) == "fv_engine" or getResourceName(resource) == "fv_dx" then 
        e = exports.fv_engine;
        dx = exports.fv_dx;
        sColor = {e:getServerColor("servercolor",false)};
        sColor2 = e:getServerColor("servercolor",true);
        red2 = e:getServerColor("red",true);
    end
    if resource == getThisResource() then 
        engineReplaceModel(engineLoadDFF("files/wheel.dff"), 1895);

        coinNPC.ped = createPed(coinNPC.skin,coinNPC.pos[1],coinNPC.pos[2],coinNPC.pos[3],coinNPC.rotation);
        setElementDimension(coinNPC.ped,coinNPC.dimension);
        setElementInterior(coinNPC.ped,coinNPC.interior);
        setElementFrozen(coinNPC.ped,true);
        setElementData(coinNPC.ped,"ped.noDamage",true);
        setElementData(coinNPC.ped,"ped >> name","Carter James");
        setElementData(coinNPC.ped,"ped >> type","Coin Váltó");

        setElementData(localPlayer,"useWheel",false);
    end
end);

addEventHandler("onClientResourceStop",resourceRoot,function()
    if dx:dxGetEdit("coin.change") then 
        dx:dxDestroyEdit("coin.change");
    end
end);

addEventHandler("onClientClick",getRootElement(),function(button,state,clickX, clickY, wx,wy,wz,clickedElement)
if clickTick+500 > getTickCount() then return end;
    if state == "down" then 
        if clickedElement and clickedElement == coinNPC.ped then 
            local playerX, playerY, playerZ = getElementPosition(localPlayer);
            if getDistanceBetweenPoints3D(playerX, playerY, playerZ, wx,wy,wz) < 3 then 
                if not coinNPC.show then 
                    coinNPC.show = true;
                    removeEventHandler("onClientRender",root,coinNPC.render);
                    addEventHandler("onClientRender",root,coinNPC.render);
                    addEventHandler("onClientKey",root,coinNPC.onKey);
                    if dx:dxGetEdit("coin.change") then 
                        dx:dxDestroyEdit("coin.change");
                    end
                    dx:dxCreateEdit("coin.change","0","0",sx/2-res(250/2),sy/2-res(20),res(250),res(40),3,9);
                end
            end
        end
    end
end);

coinNPC.onKey = function(button,state)
    if coinNPC.show then 
        if button == "backspace" then 
            if not getElementData(localPlayer,"guiActive") then 
                coinNPC.close();
            end
        end
        if button == "mouse1" and state and getKeyState("mouse1") and not getElementData(localPlayer,"guiActive") then 
            local x,y,w,h = coinNPC.x, coinNPC.y, coinNPC.w, coinNPC.h;
            local editText = tonumber(dx:dxGetEditText("coin.change")) or 0;
            if e:isInSlot(x+w/2-res(250/2),y+res(160),res(250),res(35)) then --buy Coin
                local cost = editText * 5;
                if cost > 10 then 
                    if getElementData(localPlayer,"char >> money") >= cost then 
                        triggerServerEvent("coinNPC.buy",localPlayer,localPlayer,getElementData(localPlayer,"char >> money"),cost,editText);
                        coinNPC.close();
                    else 
                        exports.fv_infobox:addNotification("warning","Nincs elég pénzed!");
                    end
                else 
                    exports.fv_infobox:addNotification("warning","Hibás a megadott összeg!");
                end
            end
            if e:isInSlot(x+w/2-res(250/2),y+res(210),res(250),res(35)) then -- sell Coin
                local give = editText * 5;
                if getElementData(localPlayer,"kari->Coin") >= editText then 
                    triggerServerEvent("coinNPC.buy",localPlayer,localPlayer,(getElementData(localPlayer,"kari->Coin") or 0),editText,give,true);
                    coinNPC.close();
                else 
                    exports.fv_infobox:addNotification("warning","Nincs elég coinod!");
                end
            end
        end
    end
end

coinNPC.render = function()
    local playerX, playerY, playerZ = getElementPosition(localPlayer);
    local pedX, pedY, pedZ = getElementPosition(coinNPC.ped);
    if getDistanceBetweenPoints3D(playerX, playerY, playerZ, pedX, pedY, pedZ) > 3 then 
        coinNPC.close();
    end

    local x,y,w,h = coinNPC.x, coinNPC.y, coinNPC.w, coinNPC.h;

    dxDrawRectangle(x,y,w,h,tocolor(50,50,50,240));
    dxDrawRectangle(x,y,w,res(25),tocolor(20,20,20,100));
    dxDrawRectangle(x-res(3),y,res(3),h,tocolor(sColor[1],sColor[2],sColor[3],180));
    dxDrawText(sColor2.."Social"..white.."Gaming - Coin Váltó",0,y,sx,0,tocolor(200,200,200,200),1,e:getFont("rage",resFont(15)),"center","top",false,false,false,true);
    
    local editText = tonumber(dx:dxGetEditText("coin.change")) or 0;
    cost = editText * 5;
    if getElementData(localPlayer,"char >> money") < cost then 
        cost = red2.. dx:formatMoney(cost);
    else 
        cost = sColor2.. dx:formatMoney(cost);
    end

    local coinCost = editText;
    if (getElementData(localPlayer,"kari->Coin") or 0) < coinCost then 
        coinCost = red2.. dx:formatMoney(coinCost);
    else 
        coinCost = sColor2.. dx:formatMoney(coinCost);
    end

    dxDrawText("Coin Ára: "..sColor2.."1 Coin = 5$"..white.."\nTe Coinod: "..sColor2..dx:formatMoney(getElementData(localPlayer,"kari->Coin") or 0)..white.."\nKöltség: "..cost..white.."$ / "..coinCost..white.."Coin",0,y+res(30),sx,0,tocolor(255,255,255),1,e:getFont("rage",resFont(13)),"center","top",false,false,false,true);

    dx:DrawButton("Vásárlás",x+w/2-res(250/2),y+res(160),res(250),res(35),{sColor[1],sColor[2],sColor[3],180});
    dx:DrawButton("Eladás",x+w/2-res(250/2),y+res(210),res(250),res(35),{sColor[1],sColor[2],sColor[3],180});

    e:shadowedText("Bezáráshoz sétálj távolabb az NPC-től.",0,y+h,sx,0,tocolor(255,255,255),1,e:getFont("rage",resFont(15)),"center","top",false,false,false,true);
end

coinNPC.close = function()
    coinNPC.show = false;
    clickTick = getTickCount();
    removeEventHandler("onClientRender",root,coinNPC.render);
    removeEventHandler("onClientKey",root,coinNPC.onKey);
    if dx:dxGetEdit("coin.change") then 
        dx:dxDestroyEdit("coin.change");
    end
end
-------------------------------------------------------------
local wheel = {
    show = false;
    hoverValue = false;
    hoverCoin = false;
    hoverBet = false;
    coinMove = false;
    bet = {};
};
wheel.w = res(400);
wheel.h = res(440);
wheel.x = sx/2 - wheel.w/2;
wheel.y = sy/2 - wheel.h/2;

wheel.render = function()
    if not wheel.show then wheel.close() end;
    local playerX, playerY, playerZ = getElementPosition(localPlayer);
    local tableX, tableY, tableZ = getElementPosition(wheel.show);
    if getDistanceBetweenPoints3D(playerX, playerY, playerZ, tableX, tableY, tableZ) > 2 then 
        wheel.close();
    end

    wheel.hoverCoin = false;
    wheel.hoverValue = false;
    wheel.hoverBet = false;

    local x,y,w,h = wheel.x, wheel.y, wheel.w, wheel.h;
    dxDrawRectangle(x,y,w,h,tocolor(50,50,50,240));
    dxDrawRectangle(x,y,w,res(30),tocolor(20,20,20,100));
    dxDrawText(sColor2.."Social"..white.."Gaming - Szerencsekerék",x,y,x+w,y+res(30),tocolor(200,200,200,200),1,e:getFont("rage",resFont(13)),"center","center",false,false,false,true);

    local row = 0;
    local startX = x - res(65);
    for k,v in ipairs(wheelValues) do 
        local valueX, valueY = startX + (k * res(110)), y + res(60) + (row * res(110));
        dx:DrawButton("x"..v,valueX, valueY, res(90), res(90),{sColor[1],sColor[2],sColor[3],180},14);
        if wheel.bet[v] then 
            dxDrawImage(valueX + res(30), valueY + res(3), res(30), res(30),"files/coins/"..getBetImage(wheel.bet[v])..".png");
            if e:isInSlot(valueX + res(30), valueY + res(3), res(30), res(30)) then 
                tooltip("Tét: "..sColor2..dx:formatMoney(wheel.bet[v]));
                wheel.hoverBet = v;
            end
        end
        if e:isInSlot(valueX, valueY, res(90), res(90)) then 
            wheel.hoverValue = v;
        end
        if k == 3 then 
            row = row + 1;
            startX = startX - (3 * res(110));
        end
    end

    for k,v in pairs(coinTypes) do 
        local coinW, coinH = res(35), res(35);
        local valueX, valueY = x + res(5) + (k * res(45)), y + res(285);
        if e:isInSlot(valueX,valueY,res(35),res(35)) then 
            wheel.hoverCoin = v;
            coinW, coinH = res(40), res(40);
        end
        dxDrawImage(valueX,valueY,coinW,coinH,"files/coins/"..v..".png");
    end

    dx:DrawButton("Pörgetés",x + w/2 - res(320/2), y + res(340), res(320), res(40),{sColor[1],sColor[2],sColor[3],180},14);

    if wheel.coinMove then 
        if isCursorShowing() then 
            local cx,cy = getCursorPosition();
            cx,cy = sx * cx, sy * cy;
            dxDrawImage(cx-res(35/2),cy-res(35/2),res(35),res(35),"files/coins/"..wheel.coinMove..".png");
        else 
            wheel.coinMove = false;
        end
    end

    local allBet = 0;
    for k,v in pairs(wheel.bet) do 
        allBet = allBet + v;
    end
    local playerCoins = (getElementData(localPlayer,"kari->Coin") or 0) - allBet;
    dxDrawText("Egyenleg: "..sColor2..dx:formatMoney(playerCoins)..white.." Coin",x,y+h-res(40),x+w,h,tocolor(255,255,255,200),1,e:getFont("rage",resFont(15)),"center","top",false,false,false,true);

    e:shadowedText("Bezáráshoz sétálj távolabb az asztaltól.",0,y+h,sx,0,tocolor(255,255,255),1,e:getFont("rage",resFont(15)),"center","top",false,false,false,true);
end

addEventHandler("onClientClick",root,function(button,state,clickX,clicY,wx,wy,wz,clickedElement)
    if not coinNPC.show  then 
        if state == "down" and clickedElement and getElementData(clickedElement,"wheel->id") then 
            local playerX, playerY, playerZ = getElementPosition(localPlayer);
            if getDistanceBetweenPoints3D(playerX, playerY, playerZ, wx, wy, wz) < 2 then 
                if not wheel.show and clickTick+500 < getTickCount() then 
                    if checkUse(clickedElement) then return outputChatBox(e:getServerSyntax("LuckyWheel","red").."Már használja valaki!",255,255,255,true) end;
                    if getElementData(clickedElement,"luckySpin") then return outputChatBox(e:getServerSyntax("LuckyWheel","red").."Amíg mozog a kerék nem használhatod.",255,255,255,true) end;
                    if getElementData(localPlayer,"useWheel") then return outputChatBox(e:getServerSyntax("LuckyWheel","red").."Már használsz egy kereket!",255,255,255,true) end;
                    wheel.show = clickedElement;
                    removeEventHandler("onClientRender",root,wheel.render);
                    addEventHandler("onClientRender",root,wheel.render);
                    setElementData(localPlayer,"useWheel",clickedElement);
                    clickTick = getTickCount();
                end
            end
        end
        if wheel.show then 
            if button == "left" then 
                if state == "down" then 
                    if wheel.hoverCoin and not wheel.coinMove and clickTick+500 < getTickCount() then 
                        local allBet = 0;
                        for k,v in pairs(wheel.bet) do 
                            allBet = allBet + v;
                        end
                        local playerCoins = (getElementData(localPlayer,"kari->Coin") or 0) - allBet;
                        if (playerCoins) >= wheel.hoverCoin then 
                            wheel.coinMove = wheel.hoverCoin;
                            clickTick = getTickCount();
                        else 
                            exports.fv_infobox:addNotification("error","Nincs ennyi coinod!");
                        end
                    end
                elseif state == "up" then 
                    if wheel.coinMove then 
                        if wheel.hoverValue then 
                            if not wheel.bet[wheel.hoverValue] then wheel.bet[wheel.hoverValue] = 0 end;
                            wheel.bet[wheel.hoverValue] = wheel.bet[wheel.hoverValue] + wheel.coinMove;
                        end
                        wheel.coinMove = false;
                    end
                end
            end
            if button == "left" and state == "down" and getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                local x,y,w,h = wheel.x, wheel.y, wheel.w, wheel.h;
                if e:isInSlot(x + w/2 - res(320/2), y + res(340), res(320), res(40)) then 
                    local bet = 0;
                    for k,v in pairs(wheel.bet) do 
                        bet = bet + v;
                    end
                    if bet == 0 then 
                        return exports.fv_infobox:addNotification("warning","Nem tettél tétet!",255,255,255,true);
                    else 
                        triggerServerEvent("luckyWheel.spin",localPlayer,localPlayer,wheel.show,wheel.bet,(getElementData(localPlayer,"kari->Coin") or 0));
                        wheel.bet = {};
                        setElementData(localPlayer,"kari->Coin", (getElementData(localPlayer,"kari->Coin") or 0) - bet);
                        wheel.close(true);
                    end
                    clickTick = getTickCount();
                end
            end
            if button == "right" and state == "down" and getKeyState("mouse2") and clickTick+500 < getTickCount() then 
                if wheel.hoverBet then 
                    if wheel.bet[wheel.hoverBet] then 
                        wheel.bet[wheel.hoverBet] = nil;
                        wheel.hoverBet = false;
                    end
                end
            end
        end
    end
end);

addEventHandler("onClientKey",root,function(button,state)
    if wheel.show then 
        if button == "backspace" and state then 
            wheel.close();
        end
    end
end);

wheel.close = function(spin)
    wheel.show = false;
    wheel.coinMove = false;
    wheel.hoverValue = false;
    wheel.hoverCoin = false;
    wheel.hoverBet = false;
    wheel.bet = {};
    removeEventHandler("onClientRender",root,wheel.render);
    if not spin then 
        setElementData(localPlayer,"useWheel",false);
    end
end

function tooltip(text)
    local cx,cy = getCursorPosition();
    cx,cy = sx * cx, sy * cy;
    cx, cy = cx + res(10), cy + res(10);
    local w = dxGetTextWidth(text,1,e:getFont("rage",resFont(12)),true) + res(30);
    local h = res(30);
    dxDrawRectangle(cx,cy,w,h,tocolor(40,40,40,255),true);
    dxDrawText(text,cx,cy,cx+w,cy+h,tocolor(200,200,200,200),1,e:getFont("rage",12),"center","center",false,false,true,true);
end

function getBetImage(bet)
    if bet >= 5000 then 
        return "5000";
    elseif bet < 5000 and bet >= 2000 then 
        return "2000";
    elseif bet < 2000 and bet >= 1000 then 
        return "1000";
    elseif bet < 1000 and bet >= 500 then 
        return "500";
    elseif bet < 500 and bet >= 100 then 
        return "100";
    elseif bet < 100 and bet >= 10 then 
        return "10";
    elseif bet < 10 then 
        return "5";
    end
end