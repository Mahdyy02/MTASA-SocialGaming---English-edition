if fileExists("client.lua") then 
	fileDelete("client.lua");
end
----------------------------------
local txd = engineLoadTXD("p.txd");
engineImportTXD(txd,5565);
local dff = engineLoadDFF("p.dff");
engineReplaceModel(dff, 5565);
removeWorldModel(1676,10000,0,0,0);
removeWorldModel(3465,10000,0,0,0);
----------------------------------
local sx,sy = guiGetScreenSize()
local element = nil
local trueElements = {false,false}
local lineX,lineY,lineZ = 0,0,0
local pX,pY,pZ = 0,0,0
local pisztoly = nil
local vehMarkersOnSide = {}
local vehicleLiveID = -1
local vehicleLiveElement = false
local FillingProgress = 0
local tankolasStarted = false

local LiterAr = 50 --[[$]]

local sideMarkers = {
	[562] = {1.3,-1.6,-0.3}, -- Elegy
}

addEventHandler("onClientResourceStart",getRootElement(),function(res)
	if tostring(getResourceName(res)) == "fv_engine" or res == getThisResource() then 
		font = exports.fv_engine:getFont("rage",13);
		font2 = exports.fv_engine:getFont("rage",10);
		sColor = {exports.fv_engine:getServerColor("servercolor",false)};
		sColor2 = exports.fv_engine:getServerColor("servercolor",true);
		red = {exports.fv_engine:getServerColor("red",false)};
		blue = {exports.fv_engine:getServerColor("blue",false)};
		white = "#FFFFFF";
	end
end);

addEvent("sendFuelPrice",true);
addEventHandler("sendFuelPrice",root,function(ar)
	LiterAr = ar;
end);

function drawPanel()
	if not getElementData(localPlayer,"network") then return end;

	local a = vehicleLiveElement:getData("veh:uzemanyag") + math.ceil(FillingProgress);
	if a > 100 then 
		a = 100;
	end

	if not trueElements[1] then return end
			if tankolasStarted then

			dxDrawRectangle(sx/2-200,sy-200,400,130,tocolor(0,0,0,160));
			dxDrawRectangle(sx/2-202,sy-200,2,130,tocolor(sColor[1],sColor[2],sColor[3]));
			exports.fv_engine:shadowedText("Refueling",sx/2-200,sy-220,sx/2-200+400,100,tocolor(255,255,255),1,font,"center","top");
			dxDrawText("Fuel Price: "..sColor2..LiterAr..white.."dt",sx/2-200,sy-200,sx/2-200+400,100,tocolor(255,255,255),1,font2,"right","top",false,false,false,true);
			dxDrawText("Refueling Price:"..sColor2..formatMoney(calculateAndTakePrice(math.floor(FillingProgress)))..white.."dt",sx/2-198,sy-200,sx/2-200+400,100,tocolor(255,255,255),1,font2,"left","top",false,false,false,true);
		
			dxDrawText("To refuel, press "..sColor2.."left mouse "..white.."button.",sx/2-200,sy-175,sx/2-200+400,100,tocolor(255,255,255),1,font2,"center","top",false,false,false,true);
		
			dxDrawRectangle(sx/2-190,sy-150,380,30,tocolor(100,100,100,160));
			dxDrawRectangle(sx/2-190,sy-150,math.floor(a)*3.8,30,tocolor(sColor[1],sColor[2],sColor[3]));
			exports.fv_engine:shadowedText(math.floor(a).."/100 %",sx/2-190,sy-150,sx/2-190+380,sy-150+30,tocolor(255,255,255),1,font,"center","center");
		
			if exports.fv_engine:isInSlot(sx/2-180/2,sy-110,150,30) then 
				dxDrawRectangle(sx/2-180/2,sy-110,180,30,tocolor(sColor[1],sColor[2],sColor[3]));
			else
				dxDrawRectangle(sx/2-180/2,sy-110,180,30,tocolor(100,100,100,160));
			end
			exports.fv_engine:shadowedText("Completion",sx/2-150/2,sy-110,sx/2-150/2+150,sy-110+30,tocolor(255,255,255),1,font2,"center","center");

		else
			tankolasStarted = true
		end

	if tankolasStarted and getKeyState("mouse1") then
		FillingProgress = FillingProgress + 0.025
		if FillingProgress > (100-vehicleLiveElement:getData("veh:uzemanyag")) then
			tankolasStarted = false
			if (localPlayer:getData("char >> money") or 0) >= calculateAndTakePrice(math.floor(FillingProgress)) then
				outputChatBox(exports.fv_engine:getServerSyntax("Refill","servercolor").."Successful refueling. Price: "..sColor2..formatMoney(calculateAndTakePrice(math.floor(FillingProgress)))..white.."dt",255,255,255,true);
				--localPlayer:setData("char >> money",localPlayer:getData("char >> money")-calculateAndTakePrice(math.floor(FillingProgress)))
				triggerServerEvent("ac.elementData",localPlayer,localPlayer,"char >> money",localPlayer:getData("char >> money")-calculateAndTakePrice(math.floor(FillingProgress)));
				vehicleLiveElement:setData("veh:uzemanyag", a)
				triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil,nil)
				trueElements[1] = false
				trueElements[2] = false
				trueElements[3] = true
				tankolasStarted = false
				FillingProgress = 0
				removeEventHandler("onClientRender",getRootElement(),drawPanel)
				exitRefill()
			end
		end
	end
end

function calculateAndTakePrice(Liter)
	if Liter and isElement(vehicleLiveElement) then
		return (Liter * LiterAr)
	end
end
function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

addEventHandler("onClientClick",getRootElement(),function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "right" and state == "down" then
		element = clickedElement
		if element and clickedElement and getElementType(clickedElement) == "object" and clickedElement:getData("refill:object") == 1 then
			if tonumber(localPlayer:getData("refill:pisztoly") or 0) == 0 then
				trueElements[1] = true
				lineX,lineY,lineZ = getElementPosition(clickedElement)
				toggleControl("fire",false)
				pisztoly = createObject(5565,0,0,0)
				exports.fv_bone:attachElementToBone(pisztoly,localPlayer,12,0,0,0.06,-180,0,0)
				removeEventHandler("onClientRender",root,drawLine);
				addEventHandler("onClientRender",root,drawLine);
				addVehiclesMarker();

				localPlayer:setData("refill:pisztoly",1)
			else
				trueElements[1] = false
				lineX,lineY,lineZ = -1,-1,-1
				toggleControl("fire",true)
				if isElement(pisztoly) then
					destroyElement(pisztoly)
				end
				exitRefill();
				localPlayer:setData("refill:pisztoly",0)
			end
		end
	elseif button == "left" and state == "down" then		
		if vehicleLiveElement then 
			if exports.fv_engine:isInSlot(sx/2-150/2,sy-110,150,30) then
				if FillingProgress > 0 and calculateAndTakePrice(math.floor(FillingProgress)) > 0 then
					tankolasStarted = false
					if (getLocalPlayer():getData("char >> money") or 0) >= calculateAndTakePrice(math.floor(FillingProgress)) then
						outputChatBox(exports.fv_engine:getServerSyntax("Refill","servercolor").."Successful refueling. Price: "..sColor2..formatMoney(calculateAndTakePrice(math.floor(FillingProgress)))..white.."dt",255,255,255,true);
						--localPlayer:setData("char >> money",localPlayer:getData("char >> money")-calculateAndTakePrice(math.floor(FillingProgress)))
						triggerServerEvent("ac.elementData",localPlayer,localPlayer,"char >> money",localPlayer:getData("char >> money")-calculateAndTakePrice(math.floor(FillingProgress)));
						vehicleLiveElement:setData("veh:uzemanyag", vehicleLiveElement:getData("veh:uzemanyag") + math.ceil(FillingProgress))
						FillingProgress = 0
						trueElements[2] = false
						tankolasStarted = false	
						triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
						exitRefill()
					else
						outputChatBox(exports.fv_engine:getServerSyntax("Refill","red").."You don't have enough money to refuel!",255,255,255,true)		
					end
				end			
			end
		end
	end
end)

addEventHandler("onClientKey",root,function(button,state)
	if button == "mouse1" and vehicleLiveElement then 
		if state then 
			triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, "SWORD", "sword_IDLE");
		else 
			triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil);
		end
	end
end);

function drawLine()
	pX,pY,pZ = getPedBonePosition(localPlayer,25)
	if getDistanceBetweenPoints3D(pX,pY,pZ,lineX,lineY,lineZ) > 5 then
		outputChatBox(exports.fv_engine:getServerSyntax("Refill","red").."You can't go that far.",255,255,255,true);
		exitRefill();
	else
		dxDrawLine3D (lineX,lineY,lineZ-1.2, pX,pY,pZ, tocolor ( 0,0,0,255 ), 1.5)
	end
end

function exitRefill()
	trueElements[1] = false;
	toggleControl("fire",true);
	if isElement(pisztoly) then 
		destroyElement(pisztoly);
	end
	localPlayer:setData("refill:pisztoly",0);
	tankolasStarted = false;
	FillingProgress = 0;
	tankolasStarted = false;
	removeEventHandler("onClientRender",root,drawLine);
	removeEventHandler("onClientRender",getRootElement(),drawPanel);
	removeVehicleMarker();
	vehicleLiveElement = false;
	vehicleLiveID = false;
end

function addVehiclesMarker()
	for k,v in ipairs(getElementsByType("vehicle",_,true)) do
		if tonumber(v:getData("veh:id") or 0) > 0 and getElementDimension(v) == getElementDimension(localPlayer) then
			VehNormalID = getElementModel(v)
			local attach = sideMarkers[VehNormalID];
			local x,y,z = getElementPosition(v)
			if not sideMarkers[VehNormalID] then 
				attach = {1.3,-2,-0.5};
			end
			local mark = createMarker(x,y,z,"cylinder",0.6,sColor[1],sColor[2],sColor[3],130)
			attachElements(mark,v,attach[1],attach[2],attach[3])
			setElementData(mark,"veh.refillMarker",v);
			addEventHandler("onClientMarkerHit",mark,function(hitElement)
				if hitElement == localPlayer then 
					vehicleLiveElement = source:getData("veh.refillMarker");
					vehicleLiveID = vehicleLiveElement:getData("veh:id");
					if getElementData(vehicleLiveElement,"veh:uzemanyag") < 100 then 
						if getVehicleEngineState(vehicleLiveElement) then outputChatBox(exports.fv_engine:getServerSyntax("Refill","red").."You can't refuel with the engine running.",255,255,255,true);
							vehicleLiveID = false;
							vehicleLiveElement = false;
							return
						end
						removeEventHandler("onClientRender",getRootElement(),drawPanel);
						addEventHandler("onClientRender",getRootElement(),drawPanel);
					else 
						vehicleLiveID = false;
						vehicleLiveElement = false;
						outputChatBox(exports.fv_engine:getServerSyntax("Refill","red").."The tank of this vehicle is full.",255,255,255,true);
					end
				end
			end)
			addEventHandler("onClientMarkerLeave",mark,function(hitElement)
				if hitElement == localPlayer then 
					vehicleLiveElement = false;
					vehicleLiveID = false;
					removeEventHandler("onClientRender",getRootElement(),drawPanel);
				end
			end)

			vehMarkersOnSide[v:getData("veh:id")] = mark
		end
	end
end
function removeVehicleMarker()
	for k,v in pairs(vehMarkersOnSide) do 
		if isElement(v) then 
			setElementData(v,"veh.refillMarker",false);
			destroyElement(v);
			vehMarkersOnSide[k] = nil;
		end
	end
end

function oldalMarkerKezeles(p)
	if p ~= getLocalPlayer() then return end
	if not getPedOccupiedVehicle(localPlayer) then 
		if ( source == vehMarkersOnSide[vehicleLiveID] and (p:getData("refill:pisztoly") == 1) ) then
			if getElementData(vehicleLiveElement,"veh:uzemanyag") < 100 then
				trueElements[2] = true
			end
		end
	end
end
addEventHandler("onClientMarkerHit",getRootElement(),oldalMarkerKezeles)

function oldalMarkerKezeles_Leave(p)
	if p ~= getLocalPlayer() then return end
	
	if ( source == vehMarkersOnSide[vehicleLiveID] and (p:getData("refill:pisztoly") == 1) ) then
		if trueElements[2] then
			trueElements[2] = false
		end
	end
end
addEventHandler("onClientMarkerLeave",getRootElement(),oldalMarkerKezeles_Leave)


-- Robbanásmentes Tankolás :D
for k,v in ipairs(getElementsByType("object")) do
	if v:getData("refill:object") == 1 then
		v:setBreakable(false)
	end
end
