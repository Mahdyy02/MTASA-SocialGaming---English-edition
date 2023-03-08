-------------------------------------------------
local time = getRealTime();
local hours = time.hour;
local minutes = time.minute;
if hours < 10 then 
	hours = "0"..hours;
end 
if minutes < 10 then 
	minutes = "0"..minutes;
end
setTimer(function()
	time = getRealTime();
	hours = time.hour;
	minutes = time.minute;	
	if hours < 10 then 
		hours = "0"..hours;
	end 
	if minutes < 10 then 
		minutes = "0"..minutes;
	end
end,1000*30,0);
function getTimeWidget()
    return hours..":"..minutes;
end

function formatMoney(value)
    return exports.fv_dx:formatMoney(value);
end

-------------------------------------------------
local moneyFont = dxCreateFont("widgets/gtaFont.ttf", 23);
local money = formatMoney(getElementData(localPlayer, "char >> money") or 0)
local moneyChanging = false
local moneyChangeType;
local newMoney = 0
local typeColors = {
    ["+"] = "servercolor",
    ["-"] = "red",
}
addEventHandler("onClientElementDataChange", localPlayer, function(dName, oValue)
    if oValue == nil or not oValue then oValue = 0 end
    if dName == "char >> money" then
        local value = getElementData(source, dName);
        money =	formatMoney(value);
        if value > oValue then
            moneyChangeType = "+";
            newMoney = value - oValue;
            money = exports.fv_engine:getServerColor(typeColors[moneyChangeType],true) ..moneyChangeType.. formatMoney(newMoney);
        elseif oValue > value then
            moneyChangeType = "-"
            newMoney = oValue - value
            money = exports.fv_engine:getServerColor(typeColors[moneyChangeType],true) ..moneyChangeType.. formatMoney(newMoney);
        end
        moneyChanging = true;
        setTimer(function()
            moneyChanging = false;
            money = formatMoney(getElementData(localPlayer, "char >> money"));
        end, 2000, 1);
    end
end);
function getMoney()
    return money;
end
-------------------------------------------------
local framesPerSecond = 0
local framesDeltaTime = 0
local lastRenderTick = false
local fpsCount = 60;
local stat = dxGetStatus();
local bit = stat["setting32BitColor"] and 32 or 16;
addEventHandler("onClientPreRender", root, function ()
    local currentTick = getTickCount();
    lastRenderTick = lastRenderTick or currentTick;
    framesDeltaTime = framesDeltaTime + (currentTick - lastRenderTick);
    lastRenderTick = currentTick;
    framesPerSecond = framesPerSecond + 1;    
    if (framesDeltaTime >= 1000) then
        fpsCount = framesPerSecond;
        framesDeltaTime = framesDeltaTime - 1000
        framesPerSecond = 0
    end
end);
-------------------------------------------------
addEventHandler("onClientRender",root,function()
    if not getElementData(localPlayer,"loggedIn") or not getElementData(localPlayer,"togHUD") then return end;
    if isWidgetShowing("fps") then
        local x,y,w,h = getWidgetDatas("fps");
        shadowedText(fpsCount..sColor2.." FPS",x, y, x+w,y+h, tocolor(255, 255, 255, 255), 1, e:getFont("rage",15), "right", "bottom", false, false, true, true);
    end
    ---
    if isWidgetShowing("ping") then 
        local x,y,w,h = getWidgetDatas("ping");
        shadowedText((getPlayerPing(localPlayer) or 100)..sColor2.." ms",x+5, y, x+w,y+h, tocolor(255, 255, 255, 255), 1, font, "left", "bottom", false, false, true, true);
    end
    ---
    if isWidgetShowing("vga") then 
        local x,y,w,h = getWidgetDatas("vga");
        shadowedText(sColor2..stat["VideoCardName"].."\n"..white.."VRAM:"..stat["VideoMemoryFreeForMTA"].."/"..stat["VideoCardRAM"].."MB, FONT:"..stat["VideoMemoryUsedByFonts"].."MB,\nTEXTURE:"..stat["VideoMemoryUsedByTextures"].."MB, RTARGET:"..stat["VideoMemoryUsedByRenderTargets"].."MB,\nRATIO:"..stat["SettingAspectRatio"]..", SIZE:"..sx.."x"..sy.."x"..bit,x,y,0,0,tocolor(255,255,255,255),1,e:getFont("rage",12),"left",nil,nil,nil,nil,true);
    end
    ---
    if isWidgetShowing("ploss") then 
        local x,y,w,h = getWidgetDatas("ploss");
        shadowedText("Csomagveszteség:"..coloredNumberReverse(math.floor(getNetworkStats()["packetlossLastSecond"])).."%",x,y,0,0,tocolor(255,255,255,255),1,e:getFont("rage",11),"left",nil,nil,nil,nil,true);
    end
    ---
    if isWidgetShowing("name") then 
        local x,y,w,h = getWidgetDatas("name");
        shadowedText(getElementData(localPlayer,"char >> name").." ("..getElementData(localPlayer,"char >> id")..") Level:"..sColor2..getPlayerLevel(localPlayer),x,y,x+w,y+h,tocolor(255,255,255,255),1,e:getFont("rage",15),"center","center",nil,nil,nil,true);
    end
    ---
    if isWidgetShowing("bone") then 
        local x,y,w,h = getWidgetDatas("bone");
        x,y = x+15,y+15;
        dxDrawImage(x,y,18,46,"widgets/bone/bg.png",0,0,0,tocolor(255,255,255),true);
        --char >> bone = {Has, Bal kéz, Jobb kéz, Bal láb, Jobb láb}
        local bone = getElementData(localPlayer,"char >> bone") or {true, true, true, true, true};
        if not bone[2] then
            dxDrawImage(x,y,18,46,"widgets/bone/injureLeftArm.png",0,0,0,tocolor(255,255,255),true);
        end
        if not bone[3] then
            dxDrawImage(x,y,18,46,"widgets/bone/injureRightArm.png",0,0,0,tocolor(255,255,255),true);
        end
        if not bone[4] then
            dxDrawImage(x,y,18,46,"widgets/bone/injureLeftFoot.png",0,0,0,tocolor(255,255,255),true);
        end
        if not bone[5] then
            dxDrawImage(x,y,18,46,"widgets/bone/injureRightFoot.png",0,0,0,tocolor(255,255,255),true);
        end
    end
    ---
    if isWidgetShowing("coin") then 
        local x,y,w,h = getWidgetDatas("coin");
        local playerCoins = getElementData(localPlayer,"kari->Coin") or 0;
        if playerCoins < 0 then 
            playerCoins = e:getServerColor("red",true) .. formatMoney(playerCoins);
        else 
            playerCoins = e:getServerColor("servercolor",true) .. formatMoney(playerCoins);
        end
        shadowedText(playerCoins..white.." Coin",x,y,x+200,y+30,tocolor(255,255,255),1,e:getFont("rage",16),"right","center");
    end
    ---
    if isWidgetShowing("money") then 
        --print("money")
        local x,y,w,h = getWidgetDatas("money");
        local money = tostring(getMoney()) ..white.."dt";
        if getElementData(localPlayer,"char >> money") < 0 then 
            money = red2..money;
        else 
            money = sColor2..money;
        end
        shadowedText(money,x,y,x + w,y + h,tocolor(255,255,255,200),1,moneyFont,"right","center",false,false,true);
    end
    ---
    if isWidgetShowing("clock") then 
        local x,y,w,h = getWidgetDatas("clock");
        shadowedText(getTimeWidget(),x,y,x + w,y + h,tocolor(255,255,255,200),1,moneyFont,"center","center",false,false,true);
    end
end);
-------------------------------------------------
-------------------------------------------------
function coloredNumberReverse(value)
    if value < 20 then 
        value = exports.fv_engine:getServerColor("servercolor",true)..tostring(value);
    elseif value >= 30 and value < 80 then 
        value = exports.fv_engine:getServerColor("orange",true)..tostring(value);
    elseif value >= 80 then 
        value = exports.fv_engine:getServerColor("red",true)..tostring(value);
    end
    return tostring(value)
end

