local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = exports.fv_hud:getResponsiveMultipler()
local serverSlot = 100

function respc(v)
    return math.ceil(v * responsiveMultipler)
end

function resp(v)
    return v * responsiveMultipler
end

addEvent("receiveServerSlot", true)
addEventHandler("receiveServerSlot", root, function(slot)
    serverSlot = slot
end)

addEventHandler("onClientResourceStart", root, function(res)
    if getThisResource() == res or getResourceName(res) == "fv_engine" or getResourceName(res) == "fv_hud" then 
        responsiveMultipler = exports.fv_hud:getResponsiveMultipler()
        e = exports.fv_engine;
        sColor = {e:getServerColor("servercolor",false)};
        sColor2 = e:getServerColor("servercolor",true);
        topFont = e:getFont("rage",respc(18));
        font = e:getFont("rage",respc(11));
		resetPlayerTable()
		triggerServerEvent("requestServerSlot", localPlayer)
	
    end
end)

local players = {}
local scoreInterpolation = {}
local scorePanel = false
local alphaMultipler = 0     
local maxLines = 13
local listOffset = 0

function compare(a,b)
	return a[1] < b[1]
end

function resetPlayerTable()
	setTimer(function() 
		players = {}
		for k, v in pairs(getElementsByType("player")) do
			if v ~= localPlayer then
				if not getElementData(v, "char >> ufo") then
					table.insert(players, {getElementData(v, "char >> id"), getPlayerName(v), v})
					table.sort(players, compare)
				end
			end
		end
	end, 100, 1)

	--[[for i = 1, 100 do
		table.insert(players, {i, "Vezetéknév Keresztnév " .. i, localPlayer})
		table.sort(players, compare)
	end--]]
end

function initScoreboard(state)
    
    if state then
		if alphaMultipler == 0 then
			listOffset = 0
            scoreInterpolation.startTick = getTickCount()
            scoreInterpolation.endTick = scoreInterpolation.startTick + 500
            lastOpenTick = getTickCount()
            addEventHandler("onClientRender", root, renderScoreboard)
            addEventHandler("onClientKey", root, keyHandler, true, "high+9999")
        end
    else
        --if alphaMultipler == 1 then
            scoreInterpolation.startTick = getTickCount()
            scoreInterpolation.endTick = scoreInterpolation.startTick + 500
        --end
    end
    scorePanel = state

end

local panelW, panelH = respc(500), respc(600)
local panelX, panelY = (screenX - panelW) * 0.5, (screenY - panelH) * 0.5 

local rowW, rowH = panelW - respc(5), respc(35)
local rowX = panelX + respc(5) 

function renderScoreboard()

	local scoreDuration = scoreInterpolation.endTick - scoreInterpolation.startTick
	local scoreProgress = (getTickCount() - scoreInterpolation.startTick) / scoreDuration
    
    if scorePanel then
        alphaMultipler = interpolateBetween(0, 0, 0, 1, 0, 0, scoreProgress, "Linear")
    else
        alphaMultipler = interpolateBetween(alphaMultipler, 0, 0, 0, 0, 0, scoreProgress, "Linear")
		if alphaMultipler == 0 then
            removeEventHandler("onClientRender", root, renderScoreboard)
        end
    end
    
	
	-- Alap
    dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(0, 0, 0, 180 * alphaMultipler))
    dxDrawRectangle(panelX, panelY, respc(5), panelH, tocolor(sColor[1], sColor[2], sColor[3], 255 * alphaMultipler))
    
    -- Szöveg
    dxDrawText(sColor2.."The#FFFFFFDevils", panelX, panelY, panelW + panelX, panelH + panelY, tocolor(255, 255, 255, 255 * alphaMultipler), 1, topFont, "center", "top", false, false, false, true)

	-- Kilistázás
	local textX, textY = panelX + respc(10), panelY + respc(80)

	for i = 1, maxLines do
		local rowY = panelY + respc(70) + rowH * (i - 1)

		if i % 2 == 0 then
			dxDrawRectangle(rowX, rowY, rowW, rowH, tocolor(40, 40, 40, 230 * alphaMultipler))
		else
			dxDrawRectangle(rowX, rowY, rowW, rowH, tocolor(60, 60, 60, 230 * alphaMultipler))
		end
	end

	local hTextX, hTextY = panelX + respc(10), panelY + respc(45)
	dxDrawText("#", hTextX + respc(10), hTextY, hTextX + rowW, hTextY + rowH, tocolor(255, 255, 255, 255 * alphaMultipler), 1, font, "left", "top")
	dxDrawText("Name", hTextX + respc(40), hTextY, hTextX + rowW, hTextY + rowH, tocolor(255, 255, 255, 255 * alphaMultipler), 1, font, "left", "top")
	dxDrawText("Online", hTextX + respc(290), hTextY, hTextX + rowW, hTextY + rowH, tocolor(255, 255, 255, 255 * alphaMultipler), 1, font, "left", "top")
	dxDrawText("Level", hTextX, hTextY, hTextX + rowW - respc(70), hTextY + rowH, tocolor(255, 255, 255, 255 * alphaMultipler), 1, font, "right", "top")
	dxDrawText("Ping", hTextX, hTextY, hTextX + rowW - respc(10), hTextY + rowH, tocolor(255, 255, 255, 255 * alphaMultipler), 1, font, "right", "top")

	local rowY = panelY + respc(70)

	local pColor = tocolor(255, 255, 255, 255 * alphaMultipler)
	if getElementData(localPlayer, "admin >> duty") then
		local r, g, b = hex2rgb(exports.fv_admin:getAdminColor(localPlayer))
		pColor = tocolor(r, g, b, 255 * alphaMultipler)
	end

	dxDrawText(getElementData(localPlayer, "char >> id"), rowX + respc(10), rowY, rowX + rowW, rowY + rowH, pColor, 1, font, "left", "center")
	dxDrawText(exports.fv_admin:getAdminName(localPlayer):gsub("_", " "), rowX + respc(40), rowY, rowX + rowW, rowY + rowH, pColor, 1, font, "left", "center")
	dxDrawText(SecondsToClock((getElementData(localPlayer,"onlineTime") or 0)), rowX + respc(290), rowY, rowX + rowW - respc(140), rowY + rowH, pColor, 1, font, "left", "center")
	dxDrawText(exports.fv_interface:getPlayerLevel(localPlayer), rowX, rowY, rowX + rowW - respc(70), rowY + rowH, pColor, 1, font, "right", "center")
	dxDrawText(getPlayerPing(localPlayer), rowX, rowY, rowX + rowW - respc(10), rowY + rowH, pColor, 1, font, "right", "center")

	for i = 1, maxLines - 1 do
		local rowY = panelY + rowH + respc(70) + rowH * (i - 1)

		local v = players[i + listOffset]
		if v and isElement(v[3]) then

			local pColor = tocolor(255, 255, 255, 255 * alphaMultipler)
			if getElementData(v[3], "admin >> duty") then
				local r, g, b = hex2rgb(exports.fv_admin:getAdminColor(v[3]))
				pColor = tocolor(r, g, b, 255 * alphaMultipler)
			end
			

				dxDrawText(v[1], rowX + respc(10), rowY, rowX + rowW, rowY + rowH, pColor, 1, font, "left", "center")
				if getElementData(v[3],"loggedIn") then
					dxDrawText(exports.fv_admin:getAdminName(v[3]):gsub("_", " "), rowX + respc(40), rowY, rowX + rowW, rowY + rowH, pColor, 1, font, "left", "center")
					dxDrawText(exports.fv_interface:getPlayerLevel(v[3]), rowX, rowY, rowX + rowW - respc(70), rowY + rowH, pColor, 1, font, "right", "center")
				else
					dxDrawText(v[2]:gsub("_", " "), rowX + respc(40), rowY, rowX + rowW, rowY + rowH, tocolor(100, 100, 100, 255 * alphaMultipler), 1, font, "left", "center")
				end
				dxDrawText(SecondsToClock((getElementData(v[3],"onlineTime") or 0)), rowX + respc(290), rowY, rowX + rowW, rowY + rowH, pColor, 1, font, "left", "center")
				dxDrawText(getPlayerPing(v[3]), rowX, rowY, rowX + rowW - respc(10), rowY + rowH, pColor, 1, font, "right", "center")
			
		end
	end

	local currentPlayers = #players
	dxDrawRectangle(panelX + respc(5), panelY + panelH - respc(30), panelW - respc(5), respc(30), tocolor(sColor[1], sColor[2], sColor[3], 100 * alphaMultipler)) -- Háttér
	dxDrawRectangle(panelX + respc(5), panelY + panelH - respc(30), (panelW - respc(5)) * (currentPlayers / serverSlot), respc(30), tocolor(sColor[1], sColor[2], sColor[3], 200 * alphaMultipler))  
	dxDrawText("Players: " .. currentPlayers + 1 .. "/" .. serverSlot, panelX, panelY + panelH - respc(30), panelW + panelX, respc(30) + panelY + panelH - respc(30), tocolor(255, 255, 255, 255 * alphaMultipler), 1, font, "center", "center")
end

--[[bindKey("tab", "both", function(button, state)
	if getElementData(localPlayer,"loggedIn") then
		if state == "down" then
			initScoreboard(true)
		elseif state == "up" then
			initScoreboard(false)
		end
	end
end)--]]

function keyHandler(button, state)
	if state then
		if #players > maxLines then
			if button == "mouse_wheel_down" and listOffset < #players - maxLines + 1 then
				listOffset = listOffset + 1
			elseif button == "mouse_wheel_up" and listOffset > 0 then
				listOffset = listOffset - 1
			end
		end
	end
end

addEventHandler("onClientKey", root, function(key, pressed)
	if key == "tab" or key == "TAB" then
		if getElementData(localPlayer,"loggedIn") or getElementData(localPlayer,"acc >> loggedin") then
			initScoreboard(pressed)
		else
			initScoreboard(false)
			print("score error, you are not logged in")
		end
	end
end)

setTimer(function()
    if getElementData(localPlayer,"loggedIn") or getElementData(localPlayer,"acc >> loggedin") then 
        local c = (getElementData(localPlayer,"onlineTime") or 0);
        setElementData(localPlayer,"onlineTime",c + 1);
    end
end,1000,0);

addEventHandler("onClientPlayerJoin", root, function()
	resetPlayerTable()	
end)

addEventHandler("onClientPlayerQuit", root, function()
	resetPlayerTable()
end)


function drawButton(k, text, x, y, sx, sy, hoverColor, bgColor)
	if bgColor then
		dxDrawRectangle(x, y, sx, sy, bgColor)
	else
		dxDrawRectangle(x, y, sx, sy, tocolor(75, 75, 75))
	end

	local borderColor = tocolor(125, 125, 125)
	if activeButton == k then
		borderColor = hoverColor
	end

	drawOutline(x, y, sx, sy, borderColor)
	dxDrawText(text, x, y, x + sx, y + sy, -1, 0.6, font15, "center", "center")

	buttons[k] = {x, y, sx, sy}
end

function drawOutline(x, y, sx, sy, color)
	dxDrawRectangle(x, y, 1, sy, color) -- bal
	dxDrawRectangle(x + sx - 1, y, 1, sy, color) -- jobb
	dxDrawRectangle(x, y, sx, 1, color) -- felső
	dxDrawRectangle(x, y + sy - 1, sx, 1, color) -- alsó
end

function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
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