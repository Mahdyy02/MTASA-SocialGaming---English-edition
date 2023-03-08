--AFK--
local afkTimer = false;
local lastClick = 0;

addEventHandler("onClientResourceStart",resourceRoot,function()
	setElementData(localPlayer,"afk.time",0);
	setElementData(localPlayer,"afk",false);
	if not isMTAWindowActive() then 
		setElementData(localPlayer,"afk",true)
		setElementData(localPlayer,"afk.time",0)
		if isTimer(afkTimer) then 
			killTimer(afkTimer)
		end
		afkTimer = setTimer(function()
			setElementData(localPlayer,"afk.time",getElementData(localPlayer,"afk.time")+1);
		end,1000,0);
	end
end);
addEventHandler("onClientRestore", getLocalPlayer(),
function()
	lastClick = getTickCount ()
	setElementData(localPlayer,"afk",false)
	if isTimer(afkTimer) then 
		killTimer(afkTimer)
	end
end)
addEventHandler("onClientKey", getRootElement(), 
function()
	lastClick = getTickCount ()
	if getElementData(localPlayer,"afk") then
		setElementData (localPlayer,"afk",false)
		if isTimer(afkTimer) then 
			killTimer(afkTimer)
		end
	end
end)
addEventHandler("onClientMinimize", getRootElement(),
function()
	setElementData(localPlayer,"afk",true)
	setElementData(localPlayer,"afk.time",0)
	if isTimer(afkTimer) then 
		killTimer(afkTimer)
	end
	afkTimer = setTimer(function()
		setElementData(localPlayer,"afk.time",getElementData(localPlayer,"afk.time")+1);
	end,1000,0);
end)
addEventHandler ("onClientRender",getRootElement(),
function()
	local cTick = getTickCount ()
	if cTick-lastClick >= 150000 then
		if not getElementData(localPlayer,"afk") then
			local hp = getElementHealth(localPlayer);
			if hp > 0 then
				setElementData (localPlayer,"afk",true)
				setElementData(localPlayer,"afk.time",0)
				if isTimer(afkTimer) then 
					killTimer(afkTimer)
				end
				afkTimer = setTimer(function()
					setElementData(localPlayer,"afk.time",getElementData(localPlayer,"afk.time")+1);
				end,1000,0);
			end
		end
	end
end)
addEventHandler("onClientCursorMove", getRootElement(),
function(x,y)
	lastClick = getTickCount ()
	if getElementData(localPlayer,"afk") then
		setElementData (localPlayer,"afk",false)
		if isTimer(afkTimer) then 
			killTimer(afkTimer)
		end
	end
end)