--Csoki
setElementData(localPlayer, "getupPanel", false)

local font = exports.fv_engine:getFont("rage", 9)
local barWidthV = false
local pressLocked = false
local healingPoints = 0
local barWidth = 0
local barR = 244
local barG = 65
local barB = 65
local statusR1,statusG1,statusB1 = exports.fv_engine:getServerColor("red",false);

function healingBar()
local healing = getElementData(localPlayer, "getupPanel") or false
	if healing then
		setElementFrozen(localPlayer,true)
		dxDrawImage(sx/2-20, sy/2-30, 40, 250, "roundedBar.png",0,0,0,tocolor(0,0,0,200))
		dxDrawImage(sx/2-15, sy/2-25, 30, 240, "roundedBar.png",0,0,0,tocolor(0,0,0,200))
		dxDrawImageSection(sx/2-15, sy/2+215, 30, barWidth, 0, 0, 48, barWidth, "roundedBar.png",0,0,0,tocolor(barR,barG,barB, 150))
		roundedRectangle(sx/2-20, sy/2-62, 40, 30, tocolor(0,0,0,200))
		roundedRectangle(sx/2-15, sy/2-57, 30, 20, tocolor(statusR1,statusG1,statusB1,150))
		dxDrawText(healingPoints.."/30", sx/2-15, sy/2-54, sx/2-15+30, sy/2-54, tocolor(255,255,255,200), 1, font, "center", "top")

		if not barWidthV then
			barWidth = barWidth - 8
			if barWidth <= -240 then
				barWidthV = true
			end
		end
		if barWidthV then
			barWidth = barWidth + 4
			if barWidth == 0 then
				barWidthV = false
			end
		end

		if barWidth <= 0 then
			barR = 244
			barG = 65
			barG = barG + 3
			barB = 65
		end
		if barWidth <= -40 then
			barR = 244
			barG = 118
			barG = barG + 5
			barB = 65
		end
		if barWidth <= -80 then
			barR = 244
			barG = 163
			barG = barG + 5
			barB = 65
		end
		if barWidth <= -120 then
			barR = 244
			barG = 214
			barG = barG + 5
			barB = 65
		end
		if barWidth <= -160 then
			barR = 200
			barR = barR - 5
			barB = 65
		end
		if barWidth <= -200 then
			barR = 160
			barR = barR - 5
			barB = 65
		end

		if healingPoints <= 0 or healingPoints < 10 then
			statusR1,statusG1,statusB1 = exports.fv_engine:getServerColor("red",false);
		end
		if healingPoints < 20 and healingPoints > 10 then
			statusR1,statusG1,statusB1 = exports.fv_engine:getServerColor("orange",false);
		end
		if healingPoints > 23 then
			statusR1,statusG1,statusB1 = exports.fv_engine:getServerColor("green",false);
		end
	end
end
addEventHandler("onClientRender", root, healingBar)

function healPoints()
local healing = getElementData(localPlayer, "getupPanel")
	if healing then
		if pressLocked then exports['fv_infobox']:addNotification("error", "You're trying too fast!") return end
			if barWidth < -210 then
				healingPoints = healingPoints + 3
				if healingPoints >= 30 then exports['fv_infobox']:addNotification("success", "You have successfully helped the injured!")
					healingPoints = 0
					setElementFrozen(localPlayer, false)
					triggerServerEvent("collapsed.suc",localPlayer,localPlayer,getElementData(localPlayer,"getupTarget"));
				end
				pressLocked = true
				setTimer(function() pressLocked = not pressLocked end,1000,1)
			elseif barWidth < -190 then
				healingPoints = healingPoints + 2
				if healingPoints >= 30 then exports['fv_infobox']:addNotification("success", "You have successfully helped the injured!")
					healingPoints = 0
					setElementFrozen(localPlayer, false)
					triggerServerEvent("collapsed.suc",localPlayer,localPlayer,getElementData(localPlayer,"getupTarget"));
				end
				pressLocked = true
				setTimer(function() pressLocked = not pressLocked end,1000,1)
			elseif barWidth < -140 then
				healingPoints = healingPoints + 1
				if healingPoints >= 30 then exports['fv_infobox']:addNotification("success", "You have successfully helped the injured!")
					healingPoints = 0
					setElementFrozen(localPlayer, false)
					triggerServerEvent("collapsed.suc",localPlayer,localPlayer,getElementData(localPlayer,"getupTarget"));
				end
				pressLocked = true
				setTimer(function() pressLocked = not pressLocked end,1000,1)
			elseif barWidth > -140 then
				healingPoints = healingPoints - 6
				if healingPoints <= 0 then
					exports['fv_infobox']:addNotification("error", "The injured died due to the improper solution of the resuscitation!")
					triggerServerEvent("collapsed.dead",localPlayer,localPlayer,getElementData(localPlayer,"getupTarget"));
					healingPoints = 0
					setElementFrozen(localPlayer, false)
				end
				pressLocked = true
				setTimer(function() pressLocked = not pressLocked end,1000,1)
			end
		cancelEvent();
	end
end
bindKey("space", "down", healPoints)

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		
		if (not bgColor) then
			bgColor = borderColor;
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);	
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
	end
end