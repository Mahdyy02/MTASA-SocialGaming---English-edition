local sx, sy = guiGetScreenSize()
local kijelolt = 1
local current = 1
local panelelol = false
local rotates = {-90, -45, 0, 45, 90, 135, 180, 225, 270}

addEventHandler("onClientResourceStart",getRootElement(),function(res)
	if tostring(getResourceName(res)) == "fv_engine" or res == getThisResource() then 
		font = exports.fv_engine:getFont("rage",13);
	end
end)

local fastanims = {
	{55,"Nothing", "", "", -1, false, false, false},
	{43,"Thinking", "COP_AMBIENT", "Coplook_think", -1, true, false, false},
	{5,"Standing with hands on hips", "COP_AMBIENT", "Coplook_shake", -1, true, false, false},
	{55,"Dance 2", "DANCING", "dance_loop", -1, true, false, false},
	{45,"Handshake 1", "GANGS", "hndshkaa", -1, false, false, false},
	{45,"lying down", "INT_HOUSE", "BED_In_L", -1, false, false, false},		
	{33,"Communication", "GANGS", "prtial_gngtlkA", -1, true, false, false},
	{45,"Laughter", "RAPPING", "Laugh_01", -1, false, false, false},	
}
function renderfastaim()
	setPedControlState(localPlayer,"walk",true);
	if not panelelol then return end
	local sx, sy = guiGetScreenSize()

	exports.fv_blur:createBlur()

	local w, h = 100, 100
	local left, top = sx/2 - w/2, sy/2 - h/2
	dxDrawText ("".. fastanims[current][2] .. "",0, sy/2 - 150/2 + 150, sx, 150, tocolor(255, 255, 255,255 ), 1, font, "center", "top", false, false, false, true)
	
	progress = (getTickCount() - asdtick) / 500

	panelTopa = interpolateBetween (
			top,0,0,
			top +220, 0, 0,
			progress,"InOutQuad"
		)
	panelTopa1 = interpolateBetween (
			top ,0,0,
			top-220, 0, 0,
			progress,"InOutQuad"
		)
	panelTopa2 = interpolateBetween (
			left,0,0,
			left - 220, 0, 0,
			progress,"InOutQuad"
		)
	panelTopa3 = interpolateBetween (
			left,0,0,
			left + 220, 0, 0,
			progress,"InOutQuad"
		)
	panelTopa4 = interpolateBetween (
			top,0,0,
			top + 165, 0, 0,
			progress,"InOutQuad"
		)
	panelTopa5 = interpolateBetween (
			left,0,0,
			left + 165, 0, 0,
			progress,"InOutQuad"
		)
	panelTopa6 = interpolateBetween (
			top,0,0,
			top - 165, 0, 0,
			progress,"InOutQuad"
		)
	panelTopa7 = interpolateBetween (
			left,0,0,
			left - 165, 0, 0,
			progress,"InOutQuad"
		)
	

	dxDrawImage(sx/2 - 150/2, sy/2 - 150/2, 150, 150,"arrow.png",rotates[current],0,0,tocolor(255,255,255,255),true)
		
	dxDrawRectangle(left, panelTopa, w, h, tocolor(0, 0, 0, 200))
	dxDrawRectangle(panelTopa5, panelTopa4, w, h, tocolor(0, 0, 0, 200))
	dxDrawRectangle(panelTopa5, panelTopa6, w, h, tocolor(0, 0, 0, 200))
	dxDrawRectangle(panelTopa7, panelTopa6, w, h, tocolor(0, 0, 0, 200))
	dxDrawRectangle(panelTopa7, panelTopa4, w, h, tocolor(0, 0, 0, 200))
	dxDrawRectangle(panelTopa2, top, w, h, tocolor(0, 0, 0, 200))
	
	dxDrawRectangle(left, panelTopa1 , w, h, tocolor(0, 0, 0, 200))
	dxDrawRectangle(panelTopa3, top , w, h, tocolor(0, 0, 0, 200))
	
	if current == 1 then
		dxDrawRectangle(left, panelTopa1, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(left, panelTopa1 + h, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(left + w, panelTopa1 , 2, h + 2, tocolor(100,147,63, 200))	
		dxDrawRectangle(left, panelTopa1, 2, h, tocolor(100,147,63, 200))			
	elseif current == 2 then
		dxDrawRectangle(panelTopa5, panelTopa6, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa5, panelTopa6 + h, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa5 + w, panelTopa6 , 2, h + 2, tocolor(100,147,63, 200))	
		dxDrawRectangle(panelTopa5, panelTopa6, 2, h, tocolor(100,147,63, 200))		
	elseif current == 3 then
		dxDrawRectangle(panelTopa3, top, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa3, top + h, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa3 + w, top , 2, h + 2, tocolor(100,147,63, 200))	
		dxDrawRectangle(panelTopa3, top, 2, h, tocolor(100,147,63, 200))		
	elseif current == 4 then
		dxDrawRectangle(panelTopa5, panelTopa4, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa5, panelTopa4 + h, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa5 + w, panelTopa4 , 2, h + 2, tocolor(100,147,63, 200))	
		dxDrawRectangle(panelTopa5, panelTopa4, 2, h, tocolor(100,147,63, 200))		
	elseif current == 5  then
		dxDrawRectangle(left, panelTopa , w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(left, panelTopa  + h, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(left + w, panelTopa  , 2, h + 2, tocolor(100,147,63, 200))	
		dxDrawRectangle(left, panelTopa , 2, h, tocolor(100,147,63, 200))		
	elseif current == 6  then
		dxDrawRectangle(panelTopa7, panelTopa4, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa7, panelTopa4+ h, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa7 + w, panelTopa4 , 2, h + 2, tocolor(100,147,63, 200))	
		dxDrawRectangle(panelTopa7, panelTopa4, 2, h, tocolor(100,147,63, 200))		
	elseif current == 7  then
		dxDrawRectangle(panelTopa2, top, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa2, top + h, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa2 + w, top , 2, h + 2, tocolor(100,147,63, 200))	
		dxDrawRectangle(panelTopa2, top, 2, h, tocolor(100,147,63, 200))		
	elseif current == 8  then
		dxDrawRectangle(panelTopa7, panelTopa6, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa7, panelTopa6 + h, w, 2, tocolor(100,147,63, 200))
		dxDrawRectangle(panelTopa7 + w, panelTopa6 , 2, h + 2, tocolor(100,147,63, 200))	
		dxDrawRectangle(panelTopa7, panelTopa6, 2, h, tocolor(100,147,63, 200))		
	end
end
addEventHandler("onClientRender", root, renderfastaim)
local animba = false
bindKey("F1", "up", function()
	if not getElementData(localPlayer,"loggedIn") then return end;
	if getElementData(localPlayer,"collapsed") then return end;
	if isPedDead(localPlayer) then return end;
	triggerServerEvent("applyfastanim", localPlayer, localPlayer,
		fastanims[current][3],
		fastanims[current][4],
		fastanims[current][5],
		fastanims[current][6],
		fastanims[current][7],
		fastanims[current][8],	
		fastanims[current][9]				
	)
	animba = true
	setElementData(localPlayer, "togHUD", true)
	panelelol = false
	current = 1
	showChat(true);
end)

bindKey("F1", "down", function()
	if not getElementData(localPlayer,"loggedIn") then return end;
	if getElementData(localPlayer,"collapsed") then return end;
	if isPedDead(localPlayer) then return end;
	setElementData(localPlayer, "togHUD", false)
	asdtick = getTickCount()
	panelelol = true
	showChat(false);
end)

bindKey("mouse_wheel_down", "down", function()
	if not panelelol then return end
	cancelEvent()
	if current <= 7 then
		current = current + 1
	else
		current = 1
	end
	playSound("valaszto.mp3")
end)

bindKey("mouse_wheel_up", "down", function()
	if not panelelol then return end
	cancelEvent()
	if current >= 2 then
		current = current - 1
	else
		current = 8
	end
	playSound("valaszto.mp3")
end)

bindKey("space", "down", function()
	if getElementData(localPlayer,"char >> taser") then return end;
	if getElementData(localPlayer,"cuffed") then return end;
	if type(getElementData(localPlayer,"setPlayerAnimation")) == "table" then return end;
	if not getElementData(localPlayer,"collapsed") then 
		triggerServerEvent("removeanim", localPlayer, localPlayer)
	end
end)



local headMove = true;
addEventHandler("onClientCursorMove", root,function(_, _, _, _, x, y, z)
	if headMove then 
		setPedLookAt(localPlayer, x,y,z)
	end
end);
addCommandHandler("headmove",function(cmd)
	headMove = not headMove;
	if headMove then 
		outputChatBox(exports.fv_engine:getServerSyntax("Head movement","green").."Head movement on!",255,255,255,true);
	else 
		outputChatBox(exports.fv_engine:getServerSyntax("Head movement","red").."Head movement off!",255,255,255,true);
	end
end);