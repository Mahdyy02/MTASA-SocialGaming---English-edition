local hud = {};
hud.bg = dxCreateTexture("hud/bg.png","dxt3");
hud.circle = dxCreateTexture("hud/circle.png","dxt3");

addEventHandler("onClientResourceStart",resourceRoot,function()
    if getElementData(localPlayer,"loggedIn") then setElementData(localPlayer,"togHUD",true) end; 
end);

addEventHandler("onClientElementDataChange",localPlayer,function(dataName)
	if source == localPlayer then 
		if dateName == "loggedIn" then 
			if getElementData(localPlayer,"loggedIn") then setElementData(localPlayer,"togHUD",true) end; 
		end
	end
end);

addEventHandler("onClientRender",root,function()
    if not getElementData(localPlayer,"loggedIn") or not getElementData(localPlayer,"togHUD") then return end;
    if isWidgetShowing("hud") then
        local x,y,w,h = getWidgetDatas("hud");
        dxDrawImage(x, y, w, h, hud.bg, 0, 0, 0, tocolor(255,255,255,255), true);
        local circleSize = 39;
        local alpha = 255*0.5
        local bars = {
            {{red[1],red[2],red[3],alpha},getElementHealth(localPlayer)};
            {{blue[1],blue[2],blue[3],alpha},getPedArmor(localPlayer)};
            {{orange[1],orange[2],orange[3],alpha},getElementData(localPlayer,"char >> food")};
            {{blue[1],blue[2],blue[3],alpha},getElementData(localPlayer,"char >> drink")};
            {{200,200,200,alpha},getStamina()};
        };
        for k,v in pairs(bars) do 
            local barValue = -(circleSize*(v[2]/100));
            dxDrawImageSection(x+50 + ((k-1) * (circleSize+8)), y+h/2+3, circleSize, barValue, 0, 0, circleSize, barValue, hud.circle, 0, 0, 0, tocolor(unpack(v[1])),true);
        end

        dxDrawText(getTimeWidget(),x , y, x+w-230,y+h, tocolor(255, 255, 255, 255), 1, e:getFont("rage",15), "center", "bottom", false, false, true, true);
        dxDrawText(getMoney()..sColor2.." dt",x, y, x+w-5,y+h, tocolor(255, 255, 255, 255), 1, e:getFont("rage",15), "right", "bottom", false, false, true, true)
    end
end);

--HUNGER AND DRINK--
local minuteTimer = (1000*60)*10
setTimer(function()
    if getElementData(getLocalPlayer(),"loggedIn") then
		if getElementData(localPlayer,"admin >> duty") then return end;
		if tonumber(getElementData(getLocalPlayer(),"char >> food") or 100) > 0 then
			local randomLose = math.random(1,10)
			local main = getElementData(getLocalPlayer(),"char >> food") or 100
			local newValue = main-randomLose
			if main > 100 then
				randomLose = math.random(1,10)
			else
				setElementData(getLocalPlayer(), "char >> food", newValue)
			end
		else
			outputChatBox(exports.fv_engine:getServerSyntax("Hunger","red").."Are you hungry! Eat something or you'll be ill!",255,255,255,true)
			local randomHpLose = math.random(5,10)
			local health = getElementHealth (getLocalPlayer())
			local newHpValue = health-randomHpLose
			setElementHealth (getLocalPlayer(), newHpValue)
		end
		if getElementData(getLocalPlayer(),"char >> food") < 0 then
			setElementData(getLocalPlayer(), "char >> food", 0)
		end
		if getElementData(getLocalPlayer(),"char >> food") > 100 then
			setElementData(getLocalPlayer(), "char >> food", 100)
		end
	end
    if getElementData(getLocalPlayer(),"loggedIn") then
		if getElementData(localPlayer,"admin >> duty") then return end;
		if tonumber(getElementData(getLocalPlayer(),"char >> drink") or 100) > 0 then
			local randomLose = math.random(1,10)
			local main = tonumber(getElementData(getLocalPlayer(),"char >> drink")) or 100
			local newValue = main-randomLose
			if main > 100 then
				randomLose = math.random(1,10)
			else
				setElementData(getLocalPlayer(), "char >> drink", newValue)
			end
		else
			outputChatBox(exports.fv_engine:getServerSyntax("Thirst","red").."Are you thirsty! Drink something or you'll be ill!",255,255,255,true)
			local randomHpLose = math.random(5,10)
			local health = getElementHealth (getLocalPlayer())
			local newHpValue = health-randomHpLose
			setElementHealth (getLocalPlayer(), newHpValue)
		end
		if tonumber(getElementData(getLocalPlayer(),"char >> drink")) < 0 then
			setElementData(getLocalPlayer(), "char >> drink", 0)
		end
		if tonumber(getElementData(getLocalPlayer(),"char >> drink")) > 100 then
			setElementData(getLocalPlayer(), "char >> drink", 100)
		end
	end
end,minuteTimer,0)
