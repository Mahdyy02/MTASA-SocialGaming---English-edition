sx, sy = guiGetScreenSize()
local w,h = 290,82;

local currentStamina = 100

local framesPerSecond = 0
local framesDeltaTime = 0
local lastRenderTick = false
local fpsCount = 60;

local stat = dxGetStatus();
local bit = false;
if stat["Setting32BitColor"] then
    bit = 32;
else
    bit = 16;
end

local circleTexture = dxCreateTexture("files/circle.png","dxt5");

local time = getRealTime()
local hours = time.hour
local minutes = time.minute	
if hours < 10 then 
	hours = "0"..hours;
end 
if minutes < 10 then 
	minutes = "0"..minutes;
end


setTimer(function()
	time = getRealTime()
	hours = time.hour
	minutes = time.minute	
	if hours < 10 then 
		hours = "0"..hours;
	end 
	if minutes < 10 then 
		minutes = "0"..minutes;
	end
end,1000*30,0);

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

responsiveMultipler = reMap(sx, 1024, 1920, 0.75, 1)

function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

function getResponsiveMultipler()
	return responsiveMultipler
end


function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

addEventHandler("onClientResourceStart",getRootElement(),function(res)
	if tostring(getResourceName(res)) == "fv_engine" or res == getThisResource() then 
		font = exports.fv_engine:getFont("rage",15);
		smallFont = exports.fv_engine:getFont("rage",12);
		smallFont2 = exports.fv_engine:getFont("rage",11);
		sColor = exports.fv_engine:getServerColor("servercolor",true);
		red = {exports.fv_engine:getServerColor("red",false)};
		blue = {exports.fv_engine:getServerColor("blue",false)};
		white = "#FFFFFF"
		if getElementData(localPlayer,"loggedIn") then setElementData(localPlayer,"togHUD",true) end; 
	end
end)

-- addEventHandler("onClientElementDataChange",localPlayer,function(dataName)
-- 	if source ~= localPlayer then return end;
-- 	if dataName == "loggedIn" then 
-- 		if getElementData(localPlayer,"loggedIn") then 
-- 			setElementData(localPlayer,"togHUD",true);
-- 		end
-- 	end
-- end);

addEventHandler("onClientPreRender", root,
    function ()
        local currentTick = getTickCount()
        lastRenderTick = lastRenderTick or currentTick
        framesDeltaTime = framesDeltaTime + (currentTick - lastRenderTick)
        lastRenderTick = currentTick
        framesPerSecond = framesPerSecond + 1
       
        if (framesDeltaTime >= 1000) then
			-- setElementData(localPlayer, "fps", framesPerSecond)
			fpsCount = framesPerSecond;
            framesDeltaTime = framesDeltaTime - 1000
            framesPerSecond = 0
        end
    end
)

local money = formatMoney(getElementData(localPlayer, "char >> money") or 0)
local moneyChanging = false
local moneyChangeType;
local newMoney = 0
local typeColors = {
    ["+"] = "servercolor",
    ["-"] = "red",
}
addEventHandler("onClientElementDataChange", localPlayer,
    function(dName, oValue)
        if oValue == nil or not oValue then oValue = 0 end
        if dName == "char >> money" then
            local value = getElementData(source, dName)
		    money =	formatMoney(value);
            if value > oValue then
                moneyChangeType = "+"
                newMoney = value - oValue
                money = exports.fv_engine:getServerColor(typeColors[moneyChangeType],true) ..moneyChangeType.. formatMoney(newMoney)
            elseif oValue > value then
                moneyChangeType = "-"
                newMoney = oValue - value
                money = exports.fv_engine:getServerColor(typeColors[moneyChangeType],true) ..moneyChangeType.. formatMoney(newMoney)
            end
            moneyChanging = true
            setTimer(function()
                moneyChanging = false
                money = formatMoney(getElementData(localPlayer, "char >> money"));
            end, 2000, 1);
        end
    end
)


addEventHandler("onClientRender", getRootElement(), function()
	if not getElementData(localPlayer, "loggedIn") then
		return
	end
	if not getElementData(localPlayer,"togHUD") then 
		return
	end
		if getElementData(localPlayer,"hud.showing") then
			local x,y = getElementData(localPlayer,"hud.x"),getElementData(localPlayer,"hud.y");
			dxDrawImage(x, y, w, h, "files/bg.png" ,0,0,0,tocolor(255,255,255,255),true)
			local csik_szelesseg,csik_magassag = 39,39
			local barKezdes = 0
			local alpha = 255*0.7
			-- Élet	
			local elet_csik = getElementHealth(localPlayer)
			local eletCsikSzazalek = -(csik_magassag*(elet_csik/100))
			dxDrawImageSection(x+50, y+h/2+3, csik_szelesseg, eletCsikSzazalek, 0, 0, csik_magassag,eletCsikSzazalek, circleTexture, 0, 0, 0, tocolor(red[1],red[2],red[3],alpha),true)
			-- Armor	
			local armor_csik = getPedArmor(localPlayer)
			local armorCsikSzazalek = -(csik_magassag*(armor_csik/100))
			dxDrawImageSection(x+43 + 54, y+h/2+3, csik_szelesseg, armorCsikSzazalek, 0, 0, csik_magassag,armorCsikSzazalek, circleTexture, 0, 0, 0, tocolor(blue[1],blue[2],blue[3],alpha),true)
			-- Hunger	
			local hunger_csik = tonumber(getElementData(getLocalPlayer(),"char >> food")) or 100
			if hunger_csik > 100 then
				setElementData(localPlayer,"char >> food",100)
			end
			local hungerCsikSzazalek = -(csik_magassag*(hunger_csik/100))
			dxDrawImageSection(x+43 + 101, y+h/2+3, csik_szelesseg, hungerCsikSzazalek, 0, 0, csik_magassag,hungerCsikSzazalek, circleTexture, 0, 0, 0, tocolor(183,147,59,alpha),true)
			-- Ivászat	
			local thirsty_csik = tonumber(getElementData(getLocalPlayer(),"char >> drink")) or 100
			if thirsty_csik > 100 then
				setElementData(localPlayer,"char >> drink",100)
			end
			local thirstyCsikSzazalek = -(csik_magassag*(thirsty_csik/100))
			dxDrawImageSection(x+43 + 148, y+h/2+3, csik_szelesseg, thirstyCsikSzazalek, 0, 0, csik_magassag,thirstyCsikSzazalek, circleTexture, 0, 0, 0, tocolor(102,182,129,alpha),true)
			-- Stamina
			--local stamina_csik = (getElementData(localPlayer,"char >> stamina") or 100)
			local stamina_csik = currentStamina
			if stamina_csik > 100 then
				currentStamina = 100
				--setElementData(localPlayer,"char >> stamina",100)
			end
			local staminaCsikSzazalek = -(csik_magassag*(stamina_csik/100))
			dxDrawImageSection(x+43+195, y+h/2+3, csik_szelesseg, staminaCsikSzazalek, 0, 0, csik_magassag,staminaCsikSzazalek, circleTexture, 0, 0, 0, tocolor(200,200,200,alpha),true)
			
			
			--dxDrawText(formatMoney(math.floor(getElementData(localPlayer,"char >> money")))..sColor.." $",x, y, x+w-5,y+h, tocolor(255, 255, 255, 255), 1, font, "right", "bottom", false, false, true, true)
			dxDrawText(money..sColor.." dt",x, y, x+w-5,y+h, tocolor(255, 255, 255, 255), 1, font, "right", "bottom", false, false, true, true)

			dxDrawText(hours .. ":" ..minutes ,x , y, x+w-230,y+h, tocolor(255, 255, 255, 255), 1, font, "center", "bottom", false, false, true, true)
		end
		if getElementData(localPlayer,"ploss.showing") then 
			local x,y = getElementData(localPlayer,"ploss.x") or -1000, getElementData(localPlayer,"ploss.y") or -1000;
			shadowedText("Csomagveszteség:"..coloredNumberReverse(math.floor(getNetworkStats()["packetlossLastSecond"])).."%",x,y,0,0,tocolor(255,255,255,255),1,smallFont2,"left",nil,nil,nil,nil,true);
		end
		if getElementData(localPlayer,"bone.showing") then
			local x,y = getElementData(localPlayer,"bone.x") or -1000, getElementData(localPlayer,"bone.y") or -1000;
			x,y = x+15,y+15;
			dxDrawImage(x,y,18,46,"bone/bg.png",0,0,0,tocolor(255,255,255),true);
			--[[
				char >> bone felépítése = {Has, Bal kéz, Jobb kéz, Bal láb, Jobb láb}
			]]
			local bone = getElementData(localPlayer,"char >> bone") or {true, true, true, true, true};
			if not bone[2] then
				dxDrawImage(x,y,18,46,"bone/injureLeftArm.png",0,0,0,tocolor(255,255,255),true);
			end
			if not bone[3] then
				dxDrawImage(x,y,18,46,"bone/injureRightArm.png",0,0,0,tocolor(255,255,255),true);
			end
			if not bone[4] then
				dxDrawImage(x,y,18,46,"bone/injureLeftFoot.png",0,0,0,tocolor(255,255,255),true);
			end
			if not bone[5] then
				dxDrawImage(x,y,18,46,"bone/injureRightFoot.png",0,0,0,tocolor(255,255,255),true);
			end
		end
		if getElementData(localPlayer,"coin.showing") then 
			local x,y = getElementData(localPlayer,"coin.x") or -1000, getElementData(localPlayer,"coin.y") or -1000;

			local playerCoins = getElementData(localPlayer,"kari->Coin") or 0;
			if playerCoins < 0 then 
				playerCoins = exports.fv_engine:getServerColor("red",true) .. formatMoney(playerCoins);
			else 
				playerCoins = exports.fv_engine:getServerColor("servercolor",true) .. formatMoney(playerCoins);
			end
			shadowedText(playerCoins.." #FFFFFFCoin",x,y,x+200,y+30,tocolor(255,255,255),1,exports.fv_engine:getFont("rage",16),"right","center");
		end
end)

addEventHandler("onClientElementDataChange",localPlayer,function(dataName)
	if source == localPlayer then 
		if dateName == "loggedIn" then 
			if getElementData(localPlayer,"loggedIn") then setElementData(localPlayer,"togHUD",true) end; 
		end
	end
end);

addCommandHandler("toghud",function(command)
	if getElementData(localPlayer,"loggedIn") then 
		local state = getElementData(localPlayer,"togHUD");
		if state then 
			setElementData(localPlayer,"togHUD",false);
			outputChatBox(exports.fv_engine:getServerSyntax("HUD","red").."Sikeresen kikapcsoltad a HUD-ot!",255,255,255,true);
		else 
			setElementData(localPlayer,"togHUD",true);
			outputChatBox(exports.fv_engine:getServerSyntax("HUD","servercolor").."Sikeresen bekapcsoltad a HUD-ot!",255,255,255,true);
		end
	end
end);

addCommandHandler("showchat",function(command)
	showChat(not isChatVisible())
end)


function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, true, true)
end
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
function getPlayerLevel(player)
	local time = (getElementData(player,"char >> playedtime")/20) or 0;
	local level = 0
		if time < 5 then
			level = 1
		elseif time >= 5 and time < 10 then
			level = 2	
		elseif time >= 10 and time < 15 then
			level = 3		
		elseif time >= 15 and time < 20 then
			level = 4		
		elseif time >= 20 and time < 30 then
			level = 5		
		elseif time >= 30 and time < 40 then
			level = 6		
		elseif time >= 40 and time < 50 then
			level = 7		
		elseif time >= 50 and time < 60 then
			level = 8		
		elseif time >= 60 and time < 70 then
			level = 9		
		elseif time >= 70 and time < 90 then
			level = 10		
		elseif time >= 90 and time < 110 then
			level = 11	
		elseif time >= 110 and time < 120 then
			level = 12	
		elseif time >= 120 and time < 140 then
			level = 13	
		elseif time >= 140 and time < 160 then
			level = 14		
		elseif time >= 160 and time < 190 then
			level = 15	
		elseif time >= 190 and time < 220 then
			level = 16
		elseif time >= 220 and time < 250 then
			level = 17
		elseif time >= 250 and time < 280 then
			level = 18
		elseif time >= 280 and time < 310 then
			level = 19
		elseif time >= 310 and time < 350 then
			level = 20
		elseif time >= 350 and time < 390 then
			level = 21	
		elseif time >= 390 and time < 430 then
			level = 22
		elseif time >= 430 and time < 470 then
			level = 23	
		elseif time >= 470 and time < 500 then
			level = 24		
		elseif time >= 500 and time < 550 then
			level = 25	
		elseif time >= 550 and time < 600 then
			level = 26
		elseif time >= 600 and time < 650 then
			level = 27
		elseif time >= 650 and time < 700 then
			level = 28
		elseif time >= 700 and time < 750 then
			level = 29
		elseif time >= 750 and time < 800 then
			level = 30	
		elseif time >= 800 and time < 850 then
			level = 31		
		elseif time >= 850 and time < 900 then
			level = 32	
		elseif time >= 900 and time < 950 then
			level = 33	
		elseif time >= 950 and time < 1000 then
			level = 34
		elseif time >= 1000 and time < 1050 then
			level = 35
		elseif time >= 1050 and time < 1100 then
			level = 36
		elseif time >= 1100 and time < 1150 then
			level = 37
		elseif time >= 1150 and time < 1200 then
			level = 38
		elseif time >= 1200 and time < 1250 then
			level = 39			
		elseif time >= 1250 and time < 1250 then
			level = 40		
		elseif time >= 1250 and time < 1350 then
			level = 41				
		elseif time >= 1350 and time < 1400 then
			level = 42			
		elseif time >= 1400 and time < 1450 then
			level = 43
		elseif time >= 1450 and time < 1500 then
			level = 44
		elseif time >= 1500 and time < 1600 then
			level = 45
		elseif time >= 1600 and time < 1700 then
			level = 46
		elseif time >= 1700 and time < 1800 then
			level = 47
		elseif time >= 1800 and time < 1900 then
			level = 48	
		elseif time >= 1900 and time < 2000 then
			level = 49		
		elseif time >= 2000 and time < 2100 then
			level = 50		
		elseif time >= 2100 and time < 2200 then
			level = 51		
		elseif time >= 2200 and time < 2300 then
			level = 52		
		elseif time >= 2300 and time < 2400 then
			level = 53	
		elseif time >= 2400 and time < 2500 then
			level = 54
		elseif time >= 2500 and time < 2600 then
			level = 55
		elseif time >= 2600 and time < 2700 then
			level = 56
		elseif time >= 2700 and time < 2800 then
			level = 57
		elseif time >= 2800 and time < 2900 then
			level = 58	
		elseif time >= 2900 and time < 3000 then
			level = 59
		elseif time >= 3000 and time < 3100 then
			level = 60
		elseif time >= 3100 and time < 3200 then
			level = 61
		elseif time >= 3200 and time < 3300 then
			level = 62
		elseif time >= 3300 and time < 3400 then
			level = 63
		elseif time >= 3400 and time < 3500 then
			level = 64
		elseif time >= 3500 and time < 3600 then
			level = 65
		elseif time >= 3600 and time < 3700 then
			level = 66
		elseif time >= 3700 and time < 3800 then
			level = 67
		elseif time >= 3800 and time < 3900 then
			level = 68
		elseif time >= 3900 and time < 4000 then
			level = 69	
		elseif time >= 4000 and time < 4200 then
			level = 70	
		elseif time >= 4200 and time < 4400 then
			level = 71
		elseif time >= 4400 and time < 4600 then
			level = 72		
		elseif time >= 4600 and time < 4800 then
			level = 73	
		elseif time >= 4800 and time < 5000 then
			level = 74
		elseif time >= 5000 and time < 5500 then
			level = 75
		elseif time >= 5500 and time < 6000 then
			level = 76
		elseif time >= 6000 and time < 6500 then
			level = 77
		elseif time >= 6500 and time < 7000 then
			level = 78		
		elseif time >= 7000 and time < 7500 then
			level = 79	
		elseif time >= 7500 and time < 8500 then
			level = 80		
		elseif time >= 8500 and time < 9500 then
			level = 81		
		elseif time >= 9500 and time < 10500 then
			level = 82
		elseif time >= 10500 and time < 11500 then
			level = 83
		elseif time >= 11500 and time < 12500 then
			level = 84
		elseif time >= 12500 and time < 13500 then
			level = 85
		elseif time >= 13500 and time < 14500 then
			level = 86			
		elseif time >= 14500 and time < 15500 then
			level = 87					
		elseif time >= 15500 and time < 16500 then
			level = 88					
		elseif time >= 16500 and time < 17500 then
			level = 89	
		elseif time >= 17500 and time < 18500 then
			level = 90				
		elseif time >= 18500 and time < 19500 then
			level = 91			
		elseif time >= 19500 and time < 20500 then
			level = 92
		elseif time >= 20500 and time < 21500 then
			level = 93
		elseif time >= 21500 and time < 22500 then
			level = 94
		elseif time >= 22500 and time < 23500 then
			level = 95
		elseif time >= 23500 and time < 24500 then
			level = 96	
		elseif time >= 24500 and time < 25500 then
			level = 97			
		elseif time >= 25500 and time < 30000 then
			level = 98	
		elseif time >= 30000 then
			level = 99		
		end
	return level;
end


local isJumped = false
local controlsState = true

local increaseValue = 0.0085
local decreaseValue = 0.00375

addEventHandler("onClientPreRender", getRootElement(),
	function (timeSlice)
		--if getPedOccupiedVehicle(localPlayer) then return end;
		if not ((getElementData(localPlayer,"admin >> duty") or false) and (getElementData(localPlayer,"admin >> level") or 0) > 3 ) then
			if not doesPedHaveJetPack(localPlayer) then
				local playerVelX, playerVelY, playerVelZ = getElementVelocity(localPlayer)
				local actualSpeed = (playerVelX * playerVelX + playerVelY * playerVelY) ^ 0.5
				
				if playerVelZ >= 0.1 and not isJumped and not getPedOccupiedVehicle(localPlayer) then
					isJumped = true
					currentStamina = currentStamina - 6.5
					
					if currentStamina <= 0 then
						currentStamina = 0
						
						if controlsState then
							toggleControl("forwards", false);
							toggleControl("backwards", false);
							toggleControl("left", false);
							toggleControl("right", false);
							toggleControl("jump", false);
							toggleAllControls(false, true, false);
							triggerServerEvent("hud > sprintAnim",localPlayer,localPlayer);
							controlsState = false
						end
					end
				end
				
				if playerVelZ < 0.05 then
					isJumped = false
				end
				
				if actualSpeed < 0.05 and not isJumped then
					if currentStamina <= 100 then
						if currentStamina > 25 then
							if not controlsState then
								--triggerServerEvent("hud > sprintAnim",localPlayer,localPlayer);
								toggleControl("forwards", true);
								toggleControl("backwards", true);
								toggleControl("left", true);
								toggleControl("right", true);
								toggleControl("jump", true);
								toggleAllControls(true, true, true);
								exports.fv_dead:reloadBones();
								controlsState = true
							end
							
							currentStamina = currentStamina + increaseValue * timeSlice
						else
							currentStamina = currentStamina + increaseValue * timeSlice * 0.75
						end
					else
						currentStamina = 100
					end
				elseif actualSpeed >= 0.1 and not getPedOccupiedVehicle(localPlayer) then
					if currentStamina >= 0 then
						currentStamina = currentStamina - decreaseValue * timeSlice
					else
						currentStamina = 0
						
						if controlsState then
							toggleControl("forwards", false);
							toggleControl("backwards", false);
							toggleControl("left", false);
							toggleControl("right", false);
							toggleControl("jump", false);
							toggleAllControls(false, true, false);
							triggerServerEvent("hud > sprintAnim",localPlayer,localPlayer);
							controlsState = false
						end
					end
				end
				
				setPedControlState("walk", true)
			end
		end
	end
)


local minuteTimer = (1000*60)*15
function foodLose()
	if getElementData(getLocalPlayer(),"loggedIn") then
		if getElementData(localPlayer,"admin >> duty") then return end;
		if getElementData(localPlayer, "char >> adminJail")[1] then return end;
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
			outputChatBox(exports.fv_engine:getServerSyntax("Éhség","red").."Éhes vagy! Egyél valamit, különben rosszul leszel!",255,255,255,true)
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
end
setTimer(foodLose,minuteTimer,0)


function drinkLose()
	if getElementData(getLocalPlayer(),"loggedIn") then
		if getElementData(localPlayer,"admin >> duty") then return end;
		if getElementData(localPlayer, "char >> adminJail")[1] then return end;
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
			outputChatBox(exports.fv_engine:getServerSyntax("Szomjúság","red").."Szomjas vagy! Igyál valamit, különben rosszul leszel!",255,255,255,true)
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
end
setTimer(drinkLose,minuteTimer,0)