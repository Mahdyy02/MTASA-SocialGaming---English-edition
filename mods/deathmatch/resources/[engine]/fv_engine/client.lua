local minFontSize = 6
local maxFontSize = 16
local screenSize = {guiGetScreenSize()}
fonts = {}
local fontsSource = {
    --["fontName"] = "source"
	["Yantramanav-Black"] = "files/fonts/Yantramanav-Black.ttf",
    ["Yantramanav-Regular"] = "files/fonts/Yantramanav-Regular.ttf",
    ["rage"] = "files/fonts/rage.ttf",
	["Roboto"] = "files/fonts/Roboto.ttf", 
    ["AwesomeFont"] = "files/fonts/FontAwesome.ttf",

}

local disabledHUD = {
    {"all", false},
    {"crosshair",true},
}




-- _setElementData = setElementData

-- function setElementData(element, dataName, value)
--     triggerServerEvent("core >> setElementData", element, element, dataName, value)
-- end

-- function removeElementData(element, dataName)
--     triggerServerEvent("core >> removeElementData", element, element, dataName)
-- end



addEventHandler("onClientResourceStart", resourceRoot, 
    function()
        
        setBlurLevel(serverData["defaultBlurLevel"])
		
		for k,v in pairs(disabledHUD) do
		    setPlayerHudComponentVisible(v[1], v[2])
		end
	
		--[[outputDebugString("Fontok betöltés alatt! Lagg warning", 3)
        outputDebugString("", 3)
        
		for k,v in pairs(fontsSource) do
		    for i = minFontSize, maxFontSize, 1 do
			    local font = dxCreateFont(v, i)
				local subText = k .. i
				fonts[subText] = font
			end
		end
        
		outputDebugString("Fontok sikeressen betöltöttek!", 3)
		outputConsole("Fontok sikeressen betöltöttek!!")]]
		
	end
)

function getFont(font, size)
    local fontE = false
    
    if font and size then
	    local subText = font .. size
	    local value = fonts[subText]
	    if value then
		    fontE = value
		end
	end
    
    if not fontE then
		local v = fontsSource[font]
		fontE = dxCreateFont(v,size)
		local subText = font .. size 
		fonts[subText] = fontE
        outputDebugString("Font:" ..font.. " Size: "..size.." created",0,255,255,255)
    end
    
	return fontE
end

local cursorState = isCursorShowing()
local cursorX, cursorY = screenSize[1]/2, screenSize[2]/2
if cursorState then
    local cursorX, cursorY = getCursorPosition()
    cursorX, cursorY = cursorX * screenSize[1], cursorY * screenSize[2]
end

addEventHandler("onClientCursorMove", root, 
    function(_, _, x, y)
        cursorX, cursorY = x, y
    end
)

function isInBox(dX, dY, dSZ, dM, eX, eY)
    if eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM then
        return true
    else
        return false
    end
end

function isInSlot(xS,yS,wS,hS)
    if isCursorShowing() then
        if isInBox(xS,yS,wS,hS, cursorX, cursorY) then
            return true
        else
            return false
        end
    end 
end

bindKey("m", "down", 
    function()   
	    showCursor(not cursorState)
        cursorState = not cursorState
        setCursorAlpha(255)
	end
)

function getFonts()
    return fonts
end

function getCursorPosition()
    return cursorX, cursorY
end

function dxCreateBorder(x,y,w,h,color)
    if not color then
        color = tocolor(0,0,0,180)
    end
	dxDrawRectangle(x,y,w+1,1,color) -- Fent
	dxDrawRectangle(x,y+1,1,h,color) -- Bal Oldal
	dxDrawRectangle(x+1,y+h,w,1,color) -- Lent Oldal
	dxDrawRectangle(x+w,y+1,1,h,color) -- Jobb Oldal
end


function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text,x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) -- Fent
    dxDrawText(text,x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) -- Lent
    dxDrawText(text,x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) -- Bal
    dxDrawText(text,x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) -- Jobb
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end



function linedRectangle(x,y,w,h,color,color2,size)
    if not color then
        color = tocolor(0,0,0,180)
    end
    if not color2 then
        color2 = color
    end
    if not size then
        size = 3
    end
	dxDrawRectangle(x, y, w, h, color) -- Háttér
	dxDrawRectangle(x - size, y - size, w + (size * 2), size, color2) -- felső
	dxDrawRectangle(x - size, y + h, w + (size * 2), size, color2) -- alsó
	dxDrawRectangle(x - size, y, size, h, color2) -- bal
	dxDrawRectangle(x + w, y, size, h, color2) -- jobb
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 180)
		end
		if (not bgColor) then
			bgColor = borderColor
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
        
        --Sarkokba pötty:
        dxDrawRectangle(x + 0.5, y + 0.5, 1, 2, borderColor, postGUI); -- bal felső
        dxDrawRectangle(x + 0.5, y + h - 1.5, 1, 2, borderColor, postGUI); -- bal alsó
        dxDrawRectangle(x + w - 0.5, y + 0.5, 1, 2, borderColor, postGUI); -- bal felső
        dxDrawRectangle(x + w - 0.5, y + h - 1.5, 1, 2, borderColor, postGUI); -- bal alsó
	end
end



addEventHandler("onClientPedDamage", root,
    function()
        if getElementData(source, "char >> noDamage") then
            cancelEvent()
        end    
    end
)

addEventHandler("onClientPlayerStealthKill", localPlayer,
    function(target)
        if getElementData(target, "char >> noDamage") then
            cancelEvent()
        end    
    end
)

local _addCommandHandler = addCommandHandler
function addCommandHandler(cmd, ...)
	if type(cmd) == "table" then
		for k, v in ipairs(cmd) do
			_addCommandHandler(v, ...)
		end
	else
		_addCommandHandler(cmd, ...)
	end
end

local sm = {}
sm.moov = 0
sm.object1, sm.object2 = nil, nil

local function camRender()
	local x1, y1, z1 = getElementPosition(sm.object1)
	local x2, y2, z2 = getElementPosition(sm.object2)
	setCameraMatrix(x1, y1, z1, x2, y2, z2)
end

local function removeCamHandler()
	if (sm.moov == 1) then
		sm.moov = 0
		removeEventHandler("onClientPreRender", root, camRender)
	end
end

function stopSmoothMoveCamera()
	if (sm.moov == 1) then
		if (isTimer(sm.timer1)) then killTimer(sm.timer1) end
		if (isTimer(sm.timer2)) then killTimer(sm.timer2) end
		if (isTimer(sm.timer3)) then killTimer(sm.timer3) end
		if (isElement(sm.object1)) then destroyElement(sm.object1) end
		if (isElement(sm.object2)) then destroyElement(sm.object2) end
		removeCamHandler()
		sm.moov = 0
	end
end

function drawlogo(x,y,w,h, color)
    dxDrawImage ( x,y,w,h, 'files/logo.png', 0, 0, 0, color )
end


function smoothMoveCamera(x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time, easing)
	if (sm.moov == 1) then return false end
	sm.object1 = createObject(1337, x1, y1, z1)
	sm.object2 = createObject(1337, x1t, y1t, z1t)
	setElementAlpha(sm.object1, 0)
	setElementAlpha(sm.object2, 0)
    setElementCollisionsEnabled(sm.object1, false)
    setElementCollisionsEnabled(sm.object2, false)
	setObjectScale(sm.object1, 0.01)
	setObjectScale(sm.object2, 0.01)
	moveObject(sm.object1, time, x2, y2, z2, 0, 0, 0, (easing and easing or "InOutQuad"))
	moveObject(sm.object2, time, x2t, y2t, z2t, 0, 0, 0, (easing and easing or "InOutQuad"))
	
	addEventHandler("onClientPreRender", root, camRender, true, "low")
	sm.moov = 1
	sm.timer1 = setTimer(removeCamHandler, time, 1)
	sm.timer2 = setTimer(destroyElement, time, 1, sm.object1)
	sm.timer3 = setTimer(destroyElement, time, 1, sm.object2)
	
	return true
end

local show = true



function sendMessageToAdmin(element, text, neededLevel)
    local pair = {}
    for k,v in pairs(getElementsByType("player")) do
        if getElementData(v, "loggedIn") then 
            local adminlevel = getElementData(v, "admin >> level") or 0
            if adminlevel >= neededLevel then
                pair[v] = true
            end
        end
    end
    
    for k,v in pairs(pair) do
        triggerServerEvent("outputChatBox", localPlayer, k, text)
    end
end

--// MoneyGlobal

function hasMoney(element, money, bankMoney)
    if not bankMoney then
        local oldMoney = getElementData(element, "char >> money") or 0
        if oldMoney - money >= 0 then
            return true
        else
            return false
        end
    else
        local oldMoney = getElementData(element, "char >> bankmoney") or 0
        if oldMoney - money >= 0 then
            return true
        else
            return false
        end
    end
end

function takeMoney(element, money, bankMoney)
    if not bankMoney then
        if hasMoney(element, money, false) then
            local oldMoney = getElementData(element, "char >> money") or 0
            setElementData(element, "char >> money", oldMoney - money)
            return true
        else
            return false
        end
    else
        if hasMoney(element, money, true) then
            local oldMoney = getElementData(element, "char >> bankmoney") or 0
            setElementData(element, "char >> bankmoney", oldMoney - money)
            return true
        else
            return false
        end
    end
end

function giveMoney(element, money, bankMoney)
    if not bankMoney then
        local oldMoney = getElementData(element, "char >> money") or 0
        setElementData(element, "char >> money", oldMoney + money)
        return true
    else
        local oldMoney = getElementData(element, "char >> bankmoney") or 0
        setElementData(element, "char >> bankmoney", oldMoney + money)
        return true
    end
end