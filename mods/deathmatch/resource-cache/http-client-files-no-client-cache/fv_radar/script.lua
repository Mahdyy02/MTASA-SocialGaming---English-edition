local white = "#FFFFFF";
local sX, sY = guiGetScreenSize();
local width, height = 0,0;
local posX,posY = 5, sY-height-15;
local waterColor = tocolor(110, 158, 204);
local bSize = 20;
local showBigMap = false;
local minimapTarget = dxCreateRenderTarget(350,250,false);
local arrowTexture = dxCreateTexture("files/arrow.png","dxt3",true);
local targetTexture = dxCreateTexture("files/logo.png","dxt3",true);
local shadowTexture = dxCreateTexture("files/shadow.png","dxt3",true);
local texture = dxCreateTexture( "files/map.png", "dxt5", true);
dxSetTextureEdge(texture, 'border', waterColor);
local imageWidth, imageHeight = dxGetMaterialSize(texture);
local blipTextures = {};
local playerBlips = {};

local mapRatio = 6000 / imageWidth;


blipNames = {
	[2] = "North",
	[4] = "Border",
	[5] = "City Hall",
	[6] = "Police",
	[7] = "Gas station",
	[8] = "Driving School",
	[9] = "Pawnshop",
	[10] = "Factory",
	[11] = "Car dealership",
	[12] = "Plaza",
	[13] = "Hospital",
	[14] = "Mine",
	[27] = "Clothing store",
	[26] = "Tuning",
	[28] = "Airport",
	[29] = "Bank",
	[17] = "Gun shop",
	[30] = "Fishing",
	[31] = "Assembly Plant",
	[32] = "Lottery",
	[22] = "Port",
	[24] = "Taxi Telep",
	[35] = "Hobby shop",
	[38] = "Sheriff's office",
	[39] = "ATF office",
}	

addEventHandler("onClientResourceStart",getRootElement(),function(res)
	if tostring(getResourceName(res)) == "fv_engine" or res == getThisResource() then 
		font = exports.fv_engine:getFont("rage",13);
		font2 = exports.fv_engine:getFont("rage",10);
		sColor = {exports.fv_engine:getServerColor("servercolor",false)};
		sColor2 = exports.fv_engine:getServerColor("servercolor",true);
		red = {exports.fv_engine:getServerColor("red",false)};
		blue = {exports.fv_engine:getServerColor("blue",false)};
		if getElementData(localPlayer,"loggedIn") then setElementData(localPlayer,"togHUD",true) end; 

		for i=0,50 do 
			if fileExists("blips/"..i..".png") then 
				blipTextures[i] = dxCreateTexture("blips/"..i..".png","dxt3",true);
			end
		end
	end
end)

addEventHandler("onClientPreRender",root,function()		
	if not (getElementData(localPlayer, "loggedIn")) or not (getElementData(localPlayer,"togHUD")) or not (getElementData(localPlayer,"radar.showing")) or showBigMap then
		return
	end
	if getElementDimension(localPlayer) == 0 then
		width, height = getElementData(localPlayer,"radar.w") or 350, getElementData(localPlayer,"radar.h") or 250;
		posX,posY = getElementData(localPlayer,"radar.x"),getElementData(localPlayer,"radar.y");
		local px,py, pz = getElementPosition(localPlayer);
		local _, _, camZ = getElementRotation(getCamera());
			
		local mW, mH = dxGetMaterialSize(minimapTarget);
		if mW ~= width or mH ~= height then 
			destroyElement(minimapTarget);
			minimapTarget = dxCreateRenderTarget(width, height,false);
		end
			
		dxSetRenderTarget(minimapTarget, true);
			local mW, mH = dxGetMaterialSize(minimapTarget);
			local ex,ey = mW/2 -px/(6000/imageWidth), mH/2 + py/(6000/imageHeight);
			dxDrawRectangle(0,0,mW,mH, waterColor);
			dxDrawImage(ex - imageWidth/2, (ey - imageHeight/2), imageWidth, imageHeight, texture, camZ, (px/(6000/imageWidth)), -(py/(6000/imageHeight)), tocolor(255, 255, 255, 255));
		dxSetRenderTarget();

		dxDrawRectangle(posX, posY, width, height, tocolor(0, 0, 0, 255*0.7),true);
		dxDrawRectangle(posX, posY, 2, height, tocolor(sColor[1],sColor[2],sColor[3], 255),true);

		dxDrawImage(posX+6,posY+3,width-9,height-6,minimapTarget,0,0,0,tocolor(255,255,255),true);

		for k, v in ipairs(getElementsByType("blip")) do
			local bx, by = getElementPosition(v);
			local actualDist = getDistanceBetweenPoints2D(px,py, bx, by);
			local bIcon = getBlipIcon(v);
			local bSize = getElementData(v,"blip >> size") or 22;
			if actualDist <= 200 or (getElementData(v, "blip >> maxVisible")) then
				local dist = actualDist/(6000/((imageWidth+imageHeight)/2));
				local rot = findRotation(bx, by, px, py)-camZ;
				local blipX, blipY = getPointFromDistanceRotation( (posX+width+posX)/2, (posY+posY+height)/2, math.min(dist, math.sqrt((posY+posY+height)/2-posY^2 + posX+width-(posX+width+posX)/2^2)), rot );
					
				local blipX = math.max(posX+17, math.min(posX+width-15, blipX))
				local blipY = math.max(posY+15, math.min(posY+height-40, blipY))

				local r,g,b = unpack(getElementData(v,"blip >> color") or {255,255,255});
				dxDrawImage(blipX - bSize/2, blipY - bSize/2, bSize, bSize, blipTextures[bIcon] or "blips/0.png", 0, 0, 0, tocolor(r,g,b),true);
			end
		end

		--GPS Line--
		if #gpsLines > 0 then 
			local streetX, streetY = false, false;
			for k,v in pairs(gpsLines) do 
				local bx, by, bz = unpack(v);
				local actualDist = getDistanceBetweenPoints2D(px,py, bx, by);
				local dist = actualDist/(6000/((imageWidth+imageHeight)/2));
				local rot = findRotation(bx, by, px, py)-camZ;
				local blipX, blipY = getPointFromDistanceRotation( (posX+width+posX)/2, (posY+posY+height)/2, math.min(dist, math.sqrt((posY+posY+height)/2-posY^2 + posX+width-(posX+width+posX)/2^2)), rot );
					
				local blipX = math.max(posX+5, math.min(posX+width-5, blipX))
				local blipY = math.max(posY+5, math.min(posY+height-25, blipY))
				if blipX ~= posX+5 and blipX ~= posX+width-5 and blipY ~= posY+5 and blipY ~= posY+height-25 then 
					if(streetX and streetY) then
						dxDrawLine (streetX, streetY, blipX, blipY, tocolor(red[1],red[2],red[3], 255), 4,true)
						streetX, streetY = blipX, blipY;
					else
						streetX, streetY = blipX, blipY;
					end
				end
				if gpsLines[k + 1] then 
					local next = Vector3(gpsLines[k + 1]);
					dxDrawLine3D(bx,by,bz+0.2, next.x, next.y, next.z+0.2,tocolor(red[1],red[2],red[3],180),20);
				end
			end
		--GPS Info Text--
			local icons = exports.fv_engine:getFont("AwesomeFont",20);
			--if nextWp then 
				if currentWaypoint ~= nextWp and not tonumber(reRouting) then
					if nextWp > 1 then
						waypointInterpolation = {getTickCount(), currentWaypoint}
					end
					currentWaypoint = nextWp
				end
				dxDrawRectangle(posX+3,posY,width-3,40,tocolor(0,0,0,150),true);
				if tonumber(reRouting) then
					currentWaypoint = nextWp
					dxDrawText("",posX+15,posY,0,posY+40,tocolor(255,255,255),0.8,icons,"left","center",false,false,true,true);
					dxDrawText("Redesign...",posX+50,posY,0,posY+40,tocolor(255,255,255),1,font,"left","center",false,false,true,true);
				elseif turnAround then --Visszafordulás
					dxDrawText("",posX+15,posY,0,posY+40,tocolor(255,255,255),0.8,icons,"left","center",false,false,true,true);
					dxDrawText("Turn back where possible!",posX+50,posY,0,posY+40,tocolor(255,255,255),1,font,"left","center",false,false,true,true);
				elseif not waypointInterpolation then
					local irany = gpsWaypoints[nextWp][2];
					if irany == "left" then 
						dxDrawText("",posX+10,posY,0,posY+40,tocolor(255,255,255),1,icons,"left","center",false,false,true,true);
						dxDrawText((floor((gpsWaypoints[nextWp][3] or 0) / 10) * 10).."m after turn left.",posX+50,posY,0,posY+40,tocolor(255,255,255),1,font,"left","center",false,false,true,true);
					elseif irany == "right" then 
						dxDrawText("",posX+10,posY,0,posY+40,tocolor(255,255,255),1,icons,"left","center",false,false,true,true);
						dxDrawText((floor((gpsWaypoints[nextWp][3] or 0) / 10) * 10).."m after turn left.",posX+50,posY,0,posY+40,tocolor(255,255,255),1,font,"left","center",false,false,true,true);
					else 
						dxDrawText("",posX+20,posY,0,posY+40,tocolor(255,255,255),1,icons,"left","center",false,false,true,true);
						dxDrawText("Move on "..(floor((gpsWaypoints[nextWp][3] or 0) / 10) * 10).."m",posX+50,posY,0,posY+40,tocolor(255,255,255),1,font,"left","center",false,false,true,true);
					end
				else
					local irany = gpsWaypoints[nextWp][2];
					if irany == "left" then 
						dxDrawText("",posX+10,posY,0,posY+40,tocolor(255,255,255),1,icons,"left","center",false,false,true,true);
						dxDrawText((floor((gpsWaypoints[nextWp][3] or 0) / 10) * 10).."m after turn left.",posX+50,posY,0,posY+40,tocolor(255,255,255),1,font,"left","center",false,false,true,true);
					elseif irany == "right" then 
						dxDrawText("",posX+10,posY,0,posY+40,tocolor(255,255,255),1,icons,"left","center",false,false,true,true);
						dxDrawText((floor((gpsWaypoints[nextWp][3] or 0) / 10) * 10).."m after turn right.",posX+50,posY,0,posY+40,tocolor(255,255,255),1,font,"left","center",false,false,true,true);
					else 
						dxDrawText("",posX+20,posY,0,posY+40,tocolor(255,255,255),1,icons,"left","center",false,false,true,true);
						dxDrawText("Move on "..(floor((gpsWaypoints[nextWp][3] or 0) / 10) * 10).."m",posX+50,posY,0,posY+40,tocolor(255,255,255),1,font,"left","center",false,false,true,true);
					end
				end
			--end
		end
		-----------------

		dxDrawImage(posX+6,posY+3,width-9,height-6,shadowTexture,0,0,0,tocolor(255,255,255),true);

		dxDrawImage(posX + width/2 - 15/2, posY + height/2 -15/2, 15, 15, arrowTexture, camZ-getPedRotation(localPlayer), 0, 0, tocolor(255, 255, 255, 255), true);
		dxDrawRectangle(posX + 3, posY+height-27, width-3, 25, tocolor(0, 0, 0, 200),true);
		local zoneName = getZoneName(px, py, pz);
		dxDrawText(zoneName, posX + 30, posY+height-27, width - 12,posY+height-27+28, tocolor(255, 255, 255, 255), 1, font, "left", "center", false, false, true, true);
		dxDrawImage(posX + 10, posY+height-23, 17, 17, targetTexture,0,0,0, tocolor(255 ,255 ,255 ,255),true);
	end
end)
function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end
function findRotation(x1,y1,x2,y2)
	local t = -math.deg(math.atan2(x2-x1,y2-y1))
	if t < 0 then t = t + 360 end;
	return t;
end
--RADAR VÉGE--

--NAGY MAP--
local playerX,playerY,playerZ = getElementPosition(localPlayer);
local mapUnit = imageWidth / 6000;
local currentZoom = 1.5;
local minZoom, maxZoom = 1.5, 3;

local mapOffsetX, mapOffsetY = 0,0;
local mapMoved = false;
local changeTick = 0;

function bigMapRender()
	if getElementDimension(localPlayer) ~= 0 or getElementInterior(localPlayer) ~= 0 then return end;
	posX, posY, width, height = 25, 25, sX - 50, sY - 50;

	if(isCursorShowing()) and mapMoved then
		local cursorX, cursorY = getCursorPosition();
		local mapX, mapY = getWorldFromMapPosition(cursorX, cursorY);

		local absoluteX = cursorX * sX;
		local absoluteY = cursorY * sY;

		if getKeyState("mouse1") and exports.fv_engine:isInSlot(posX, posY, width, height) then
			playerX = -(absoluteX * currentZoom - mapOffsetX);
			playerY = absoluteY * currentZoom - mapOffsetY;
	
			playerX = math.max(-3000, math.min(3000, playerX));
			playerY = math.max(-3000, math.min(3000, playerY));
		end
	else 
		if (not mapMoved) then
			playerX, playerY, playerZ = getElementPosition(localPlayer);
		end
	end

	local _, _, playerRotation = getElementRotation(localPlayer);
	local mapX = (((3000 + playerX) * mapUnit) - (width / 2) * currentZoom);
	local mapY = (((3000 - playerY) * mapUnit) - (height / 2) * currentZoom);
	local mapWidth, mapHeight = width * currentZoom, height * currentZoom;
	local localX, localY, localZ = getElementPosition(localPlayer);

	dxDrawRectangle(posX - 5, posY - 5, width + 10, height + 10,tocolor(0,0,0,180));
	dxDrawRectangle(posX - 8, posY - 5, 3, height + 10,tocolor(sColor[1],sColor[2],sColor[3],180));
	dxDrawImageSection(posY, posX, width, height, mapX, mapY, mapWidth, mapHeight, texture, 0, 0, 0, tocolor(255, 255, 255, 255), false);
	dxDrawImage(posX, posY, width, height, "files/shadow.png");
	dxDrawRectangle(posX, posY + height - 30, width, 30,tocolor(0,0,0,180));

	for _, blip in pairs(getElementsByType("blip")) do
		local blipX, blipY, blipZ = getElementPosition(blip);
		local icon = getBlipIcon(blip);
		local size = (getElementData(blip,"blip >> size") or 22);
		local color = getElementData(blip,"blip >> color") or {255,255,255};

		local blipDistance = getDistanceBetweenPoints2D(blipX, blipY, playerX, playerY);
		if (blipDistance <= (1000*(currentZoom*3))) then 
			local centerX, centerY = (posX + (width / 2)), (posY + (height / 2));
			local leftFrame = (centerX - width / 2) + (30/2);
			local rightFrame = (centerX + width / 2) - (30/2);
			local topFrame = (centerY - height / 2) + (30/2);
			local bottomFrame = (centerY + height / 2) - 40;
			local blipX, blipY = getMapFromWorldPosition(blipX, blipY);
			centerX = math.max(leftFrame, math.min(rightFrame, blipX));
			centerY = math.max(topFrame, math.min(bottomFrame, blipY));

			dxDrawImage(centerX - (size / 2), centerY - (size / 2), size, size, blipTextures[icon], 0, 0, 0, tocolor(color[1], color[2], color[3], a));

			if exports.fv_engine:isInSlot(centerX - (size / 2), centerY - (size / 2), size, size) then 
				local blipName = getElementData(blip, "blip >> name") or blipNames[icon] or "Ismeretlen Blip";
				local textWidth = dxGetTextWidth(blipName,1,font2,true);
				local cursorX, cursorY = getCursorPosition()
				cursorX, cursorY = cursorX*sX + 10, cursorY*sY + 10
				dxDrawRectangle(cursorX,cursorY,textWidth + 10, 20,tocolor(0,0,0,180));
				dxDrawText(blipName,cursorX,cursorY,cursorX + textWidth + 10,cursorY+20,tocolor(255,255,255),1,font2,"center","center",false,false,false,true);
			end
		end
	end

	--GPS Line--
	local streetX, streetY = false, false;
	for k,v in pairs(gpsLines) do
		local gpsX,gpsY = unpack(v);
		local centerX, centerY = (posX + (width / 2)), (posY + (height / 2));
		local leftFrame = (centerX - width / 2) + (30/2);
		local rightFrame = (centerX + width / 2) - (30/2);
		local topFrame = (centerY - height / 2) + (30/2);
		local bottomFrame = (centerY + height / 2) - 40;
		gpsX,gpsY = getMapFromWorldPosition(gpsX,gpsY);
		gpsX, gpsY = math.max(leftFrame, math.min(rightFrame, gpsX)), math.max(topFrame, math.min(bottomFrame, gpsY));
		if streetX and streetY then 
			dxDrawLine (streetX, streetY, gpsX, gpsY, tocolor(red[1],red[2],red[3], 255), 4,true);
			streetX, streetY = gpsX, gpsY;
		else 
			streetX, streetY = gpsX, gpsY;
		end
	end
	-------

	--3D Blippek--
	local textColor = tocolor(red[1],red[2],red[3]);
	if getElementData(localPlayer,"3dBlip") or false then 
		textColor = tocolor(sColor[1],sColor[2],sColor[3]);
	end
	dxDrawRectangle(posX, posY + height - 30, dxGetTextWidth("3D Blippek",1,font,false)+10, 30,tocolor(0,0,0,180));
	dxDrawText("3D Blippek",posX+5, posY + height-30, 20,posY + height+2,textColor,1,font,"left","center");
	-------------

	--Player Arrow--
	local blipX, blipY = getMapFromWorldPosition(localX, localY);
	if (blipX >= posX and blipX <= posX + width) then
		if (blipY >= posY and blipY <= posY + height) then
			dxDrawImage(blipX - 7, blipY - 7, 14, 14, arrowTexture, 360 - playerRotation, 0, 0, tocolor(255, 255, 255, a), false);
		end
	end
	----------------

	dxDrawText("To reset, press "..sColor2.."SPACE"..white.." button.",posX, posY + height-30, posX + width,posY + height+2,tocolor(255,255,255),1,font,"center","center",false,false,false,true);

	dxDrawText(getZoneName(playerX,playerY,0),posX, posY + height-30, posX + width - 10,posY + height+2,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
end

addEventHandler("onClientClick",root,function(button,state,x,y)
if showBigMap then 
	if button == "left" then 
		if state == "down" then 
			if exports.fv_engine:isInSlot(posX,posY,width,height-30) then 
				mapOffsetX = x * currentZoom + playerX;
				mapOffsetY = y * currentZoom - playerY;
				mapMoved = true;
			end
			if exports.fv_engine:isInSlot(posX, posY + height - 30, dxGetTextWidth("3D Blippek",1,font,false)+10, 30) then 
				if changeTick+300 > getTickCount() then return end;
				setElementData(localPlayer,"3dBlip",not getElementData(localPlayer,"3dBlip"));
				if getElementData(localPlayer,"3dBlip") then 
					exports.fv_infobox:addNotification("success","3D Blippek bekapcsolva!");
				else 
					exports.fv_infobox:addNotification("error","3D Blippek kikapcsolva!");
				end
				changeTick = getTickCount();
			end
		end
	end
	if button == "right" and state == "down" then 
		if occupiedVehicle and isElement(occupiedVehicle) then 
			local cursorX, cursorY = getCursorPosition();
			local gpsX,gpsY = getWorldFromMapPosition(cursorX, cursorY);

			if getElementData(occupiedVehicle, "gpsDestination") then
				setElementData(occupiedVehicle, "gpsDestination", false)
			else
				setElementData(occupiedVehicle, "gpsDestination", {gpsX, gpsY});
			end
		end
	end
end
end);

addEventHandler("onClientKey",root,function(button,state)
	if button == "F11" and state then 
		cancelEvent();
		if not showBigMap then 
			removeEventHandler("onClientRender",root,bigMapRender);
			addEventHandler("onClientRender",root,bigMapRender);
			showBigMap = true;
			mapMoved = false;
			setElementData(localPlayer,"togHUD",false);
			showChat(false);
		else 
			removeEventHandler("onClientRender",root,bigMapRender);
			showBigMap = false;
			setElementData(localPlayer,"togHUD",true);
			showChat(true);
		end
	end
	if showBigMap then 
		if button == "space" and state then 
			mapMoved = false;
		end

		if button == "mouse_wheel_up" and state then 
			currentZoom = math.max(currentZoom - 0.05, minZoom);
		end

		if button == "mouse_wheel_down" and state then 
			currentZoom = math.min(currentZoom + 0.05, maxZoom);
		end
	end
end);

-- --Big Map Zoom--
-- bindKey("mouse_wheel_up", "down",
-- function()
-- 	if showBigMap then
-- 		currentZoom = math.max(currentZoom - 0.05, minZoom);
-- 	end
-- end)
-- bindKey("mouse_wheel_down", "down",
-- function()
-- 	if showBigMap then
-- 		currentZoom = math.min(currentZoom + 0.05, maxZoom);
-- 	end
-- end)
-- --------------

function getMapFromWorldPosition(worldX, worldY)
	local centerX, centerY = (posX + (width / 2)), (posY + (height / 2));
	local mapLeftFrame = centerX - ((playerX - worldX) / currentZoom * mapUnit);
	local mapRightFrame = centerX + ((worldX - playerX) / currentZoom * mapUnit);
	local mapTopFrame = centerY - ((worldY - playerY) / currentZoom * mapUnit);
	local mapBottomFrame = centerY + ((playerY - worldY) / currentZoom * mapUnit);

	centerX = math.max(mapLeftFrame, math.min(mapRightFrame, centerX));
	centerY = math.max(mapTopFrame, math.min(mapBottomFrame, centerY));

	return centerX, centerY;
end

function getWorldFromMapPosition(mapX, mapY)
	return playerX + ((mapX * ((width * currentZoom) * 2)) - (width * currentZoom)), playerY + ((mapY * ((height * currentZoom) * 2)) - (height * currentZoom)) * -1;
end
---------------------------------------

--GPS--
gpsLines = {};
gpsBlip = false;
waypointInterpolation = false;
function clearGPSRoute()
	gpsLines = {}
	if isElement(gpsBlip) then 
		destroyElement(gpsBlip);
	end
end

function addGPSLine(x, y, z)
	table.insert(gpsLines, {x, y, z or 0});

	local markerX, markerY, markerZ = unpack(gpsLines[#gpsLines]);
	if isElement(gpsBlip) then 
		setElementPosition(gpsBlip,markerX, markerY, markerZ);
	else
		gpsBlip = createBlip(markerX, markerY, markerZ-10,34);
	end
	setElementData(gpsBlip,"blip >> name","GPS Marking");
	setElementData(gpsBlip,"blip >> color",{red[1],red[2],red[3]});
	setElementData(gpsBlip, "blip >> maxVisible", true);
end

addEventHandler("onClientElementDataChange", getRootElement(),function (dataName, oldValue)
	if source == occupiedVehicle then
		if dataName == "gpsDestination" then
			local dataValue = getElementData(source, dataName) or false;
			if dataValue then
				gpsThread = coroutine.create(makeRoute);
				coroutine.resume(gpsThread, unpack(dataValue));
				waypointInterpolation = false;
			else
				endRoute();
			end
		end
	end
end);
-------


--------------------
---SZERVER BLIPEK---
--------------------
north = createBlip( 733.1318359375, 3700.951171875, -200, 2, 2, 255, 255, 255, 255) -- észak blip
setBlipOrdering ( north,  -2000 )
setElementData(north, "blip >> maxVisible", true)
setElementData(north,"blip >> name","Észak")


addEventHandler("onClientResourceStart", getResourceRootElement(), function()
	--Határok--
	createBlip(51.619071960449, -1531.3640136719, 5.2908096313477,4);
	createBlip(-84.958023071289, -912.29962158203, 17.761297225952,4);
	createBlip(-966.33569335938, -344.58251953125, 36.234508514404,4);
	createBlip(-10.164685249329, -1330.3544921875, 11.078838348389,4); 
	createBlip(9.6179990768433, -1352.6108398438, 10.328424453735,4); 
	----
	createBlip(1413.2408447266, -1675.1842041016, 13.65468788147,5); --VH
	createBlip(1453.0764160156, -1780.2860107422, 14.9921875,12); --Pláza
	--Benzinkút--
	createBlip(1939.0870361328, -1771.9074707031, 13.3828125,7); --Déli
	createBlip(1003.4955444336, -933.46716308594, 42.1796875,7); --Északi
	createBlip(-92.038734436035, -1171.6634521484, 2.365868806839,7); --Fint Clounty Benzinkút [határ útán]
	createBlip(-1605.6553955078, -2714.2795410156, 48.533473968506,7); --Whestone Benzinkút
	createBlip(-1673.9758300781, 415.76565551758, 7.1796875,7); --Whestone Benzinkút
	createBlip(-2417.5773925781, 977.64434814453, 45.296875,7); --Whestone Benzinkút
	createBlip(654.97766113281, -565.12640380859, 16.3359375,7); --Dillimore Benzinkút
	
	
	----
	
	createBlip(2131.4741210938, -1149.8084716797, 24.222597122192,11); --Autóker
	createBlip(1178.6690673828, -1323.2567138672, 14.131476402283,13); --Kórház
	createBlip(-809.02661132813, -1886.5118408203, 11.562000274658,14); --Bánya
	createBlip(1223.3532714844, -1815.1697998047, 16.59375,8); --Tanuló
	createBlip(2508.5712890625, -1531.9959716797, 23.861217498779,26); --Tuningoló
	createBlip(1781.0625, -1778.4853515625, 13.540859222412,26) -- Tuningoló
	createBlip(2243.619140625, -1663.6823730469, 15.4765625,27); --Binco
	createBlip(1962.2155761719, -2193.2609863281, 13.546875,28); --Reptér
	createBlip(1463.2000732422, -1016.4307250977, 25.83006477356,29); -- Bank
	createBlip(1365.7059326172, -1279.8519287109, 13.546875,17); -- FegyverBolt
	createBlip(153.49002075195, -1925.7678222656, 3.7696437835693,30); -- FegyverBolt
	createBlip(1576.4592285156, -1246.5628662109, 19.188358306885,31); -- SzerelőTelep
	createBlip(1565.5856933594, -1168.1490478516, 24.078125,32); -- lottozó
	createBlip(2119.5798339844, -2139.7341308594, 13.6328125,24); -- Taxi Telep
	createBlip(835.72088623047, -2066.6481933594, 12.8671875,22); -- Kikötő
	createBlip(1553.8039550781, -1675.673828125, 16.1953125,6); -- Rendőrség
	createBlip(2851.5815429688, -1532.3845214844, 11.09375,39); -- ATF
	
	local hobbi = createBlip(875.84295654297, -1565.0676269531, 13.530944824219,35); --Hobbi Bolt
	setElementData(hobbi,"blip >> size",20);


	local casino = createBlip(1022.5088500977, -1122.1760253906, 23.871459960938,36); --Kaszinó
	setElementData(casino,"blip >> size",20);
	setElementData(casino,"blip >> name","Casino")

	
	local junk = createBlip(2182.763671875, -1985.8367919922, 13.550592422485,33);
	setElementData(junk,"blip >> color",{255,0,0});
	setElementData(junk,"blip >> name","Crush");
	setElementData(junk,"blip >> size",25);
	
end)

--[[addEventHandler("onClientElementDataChange",localPlayer,function(dataName,oldValue,newValue)
if getElementData(localPlayer,"loggedIn") then 
if getElementData(localPlayer,"admin >> level") > 2 then 
	if dataName == "admin >> duty" or dataName == "admin >> level" then 
		if newValue or newValue == 13 then 
			playerBlips = {};
			for k,v in pairs(getElementsByType("player")) do 
				if getElementData(v,"loggedIn") then 
					if v ~= localPlayer then 
						local blip = createBlipAttachedTo(v,15);
						setElementData(blip,"blip >> name",getElementData(v,"char >> name") or getPlayerName(v));
						playerBlips[v] = blip;
					end
				end
			end
		else 
			for k,v in pairs(playerBlips) do 
				if isElement(v) then 
					destroyElement(v);
				end
			end
			playerBlips = {};
		end
	end
end
end
end);]]


addEventHandler("onClientPlayerQuit",root,function()
	if playerBlips[source] then 
		destroyElement(playerBlips[source]);
	end
end);

--GPS UTILS--
occupiedVehicle = getPedOccupiedVehicle(localPlayer);
addEventHandler("onClientVehicleEnter", getRootElement(),
	function (player)
		if player == localPlayer then
			if occupiedVehicle ~= source then
				occupiedVehicle = source
			end
		end
	end
)

addEventHandler("onClientVehicleExit", getRootElement(),
	function (player)
		if player == localPlayer then
			if occupiedVehicle == source then
				occupiedVehicle = false
			end
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if occupiedVehicle == source then
			occupiedVehicle = false
		end
	end
)

addEventHandler("onClientVehicleExplode", getRootElement(),
	function ()
		if occupiedVehicle == source then
			occupiedVehicle = false
		end
	end
)