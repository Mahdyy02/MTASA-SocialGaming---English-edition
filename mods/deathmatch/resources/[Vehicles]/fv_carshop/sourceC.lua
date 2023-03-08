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
end)

local sx,sy = guiGetScreenSize();
local rotate = 0;
local current = 1;
local show = false;
local carshopShopPed = false;
local menus = {"Speed:", "Consumption:", "Category:"};
local select = false;
local shopPeds = {
	{101,true,2131.7202148438, -1150.9805908203, 24.0966796875},
}

local loadedLimits = {};
local colors = {
	{10,10,10},
	{200,10,10},
	{200,200,200},
	{200,200,10},
	{10,10,200},
	{10,200,10},
}
local clickTick = 0;

function loadCarshopPed()
	for i,v in ipairs(shopPeds) do
		carshopShopPed = createPed(v[1],v[3],v[4],v[5])
		setElementData(carshopShopPed,"carshop:npc",v[2])
		setElementData(carshopShopPed,"ped >> type","Vehicle Dealer")
		setElementData(carshopShopPed,"ped >> name","Clark Melton")
		setElementData(carshopShopPed,"ped.noDamage",true);
		setElementFrozen(carshopShopPed,true);
	end
end
addEventHandler("onClientResourceStart",resourceRoot,loadCarshopPed);

addEventHandler("onClientPedDamage",getRootElement(),function()
	if source and getElementData(source,"ped.noDamage") then 
		cancelEvent();
	end
end);

function ClickToShop( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
	if clickedElement and getElementType(clickedElement) == "ped" and state=="down" and not show and getElementData(clickedElement,"carshop:npc") then
		local pX,pY,pZ = getElementPosition(getLocalPlayer())
		if getDistanceBetweenPoints3D(pX,pY,pZ,worldX,worldY,worldZ)<=3 then
			if not show then
				show = true;
				setCameraPos(1);
				current = 1;
				car = createVehicle(vehs[current][1], 2134.5869140625, -1131.2231445313, 25.674263000488);
				setVehicleColor(car,math.random(0,255),math.random(0,255),math.random(0,255))
				setElementDimension(car,getElementData(localPlayer,"acc >> id"));
				setElementDimension(localPlayer,getElementData(localPlayer,"acc >> id"));
				setTimer(function()
					setElementFrozen(car,true);
				end,1000,1);
				setElementData(localPlayer, "togHUD", false);
				showChat(false);
				setControl(false)
			else
				show = false;
				destroyElement(car);
			end
		end
	end
end
addEventHandler ("onClientClick",getRootElement(),ClickToShop)

function renderCarshop()
	if show then

		--Szinezés
		dxDrawRectangle(0,0,20+#colors*35,50,tocolor(0,0,0,180)); 
		for k,v in pairs(colors) do 
			dxDrawRectangle(-20+(k*35),10,30,30,tocolor(v[1],v[2],v[3]));
			if exports.fv_engine:isInSlot(-20+(k*35),10,30,30) then 
				if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
					setVehicleColor(car,v[1],v[2],v[3],v[1],v[2],v[3]);
					clickTick = getTickCount();
				end
			end
		end
		---------

		dxDrawRectangle(sx-410,sy/2-150,400,280,tocolor(0,0,0,160));
		dxDrawRectangle(sx-410,sy/2-150,2,280,tocolor(sColor[1],sColor[2],sColor[3]));
		dxDrawRectangle(sx-410,sy/2-150,400,30,tocolor(100,100,100,100));
		dxDrawText(exports.fv_vehmods:getVehicleRealName(vehs[current][1]),sx-410,sy/2-150,sx-410+400,sy/2-150+35,tocolor(255,255,255),1,font,"center","center");

		for i=1,3 do 
			dxDrawRectangle(sx-400,sy/2-140+(i*40),380,25,tocolor(100,100,100,100));
			dxDrawText(menus[i].." "..sColor2..vehs[current][i+2],sx-400,sy/2-140+(i*40),sx-400+380,sy/2-140+(i*40)+25,tocolor(255,255,255),1,font2,"center","center",false,false,false,true);
		end

		dxDrawRectangle(sx-400,sy/2-140+(4*40),380,25,tocolor(100,100,100,100));
		dxDrawText("Limit: "..sColor2..getModelCount(vehs[current][1])..white.."/"..sColor2..vehs[current][8],sx-400,sy/2-140+(4*40),sx-400+380,sy/2-140+(4*40)+25,tocolor(255,255,255),1,font2,"center","center",false,false,false,true);

		dxDrawRectangle(sx-400,sy/2-140+(5*40),380,25,tocolor(100,100,100,100));
		dxDrawText("Price: "..sColor2..formatMoney(vehs[current][6])..white.."dt / "..sColor2..formatMoney(vehs[current][7])..white.."PP",sx-400,sy/2-140+(5*40),sx-400+380,sy/2-140+(5*40)+25,tocolor(255,255,255),1,font,"center","center",false,false,false,true);

		dxDrawText("Use "..sColor2.."backspace"..white.." to exit!",10,sy-30, 450,40,tocolor(255,255,255),1,font, "left", "top", false, false, false, true)						

		dxDrawText("Buying: "..sColor2.."ENTER"..white..".",sx-410,sy/2+100,sx-410+400,0,tocolor(255,255,255),1,font,"center","top",false,false,false,true);

		if select then 
			dxDrawRectangle(sx/2-252,sy/2-50,2,100,tocolor(sColor[1],sColor[2],sColor[3]));
			dxDrawRectangle(sx/2-250,sy/2-50,500,100,tocolor(0,0,0,160));
			dxDrawText("Select a currency.",sx/2-250,sy/2-50,sx/2-250+500,0,tocolor(255,255,255),1,font,"center");

			if exports.fv_engine:isInSlot(sx/2-240,sy/2-10,230,40) then 
				dxDrawRectangle(sx/2-240,sy/2-10,230,40,tocolor(sColor[1],sColor[2],sColor[3]));
			else 
				dxDrawRectangle(sx/2-240,sy/2-10,230,40,tocolor(100,100,100,100));
			end
			exports.fv_engine:shadowedText("Money",sx/2-240,sy/2-10,sx/2-240+230,sy/2-10+40,tocolor(255,255,255),1,font,"center","center");
			
			if exports.fv_engine:isInSlot(sx/2+10,sy/2-10,230,40) then 
				dxDrawRectangle(sx/2+10,sy/2-10,230,40,tocolor(sColor[1],sColor[2],sColor[3]));
			else 
				dxDrawRectangle(sx/2+10,sy/2-10,230,40,tocolor(100,100,100,100));
			end
			exports.fv_engine:shadowedText("Premium Point",sx/2+10,sy/2-10,sx/2+10+230,sy/2-10+40,tocolor(255,255,255),1,font,"center","center");
		end
		--CarRotate--
		rotate = rotate + 0.2
		setElementRotation(car, 0, 0, rotate)
	end
end
addEventHandler("onClientRender", getRootElement(), renderCarshop)


local clickTick = 0;
addEventHandler("onClientKey",root,function(button,state)
if not getNetworkState() then return end;
	if button == "enter" and state then 
		if show then
			if not select then 
				select = true;
			end
		end
	end
	if button == "backspace" and state then 
		if show then
			if select then 
				select = false;
			else 
				show = false;
				select = false;
				setCameraTarget(localPlayer);
				if isElement(car) then
					destroyElement(car);
				end
				setElementData(localPlayer, "togHUD", true);
				showChat(true);
				setElementDimension(localPlayer,0);
				setControl(true)
			end
		end
	end

	if button == "arrow_r" and state and not select then 
		if show then
			if current+1 > #vehs then
				current = 1
			else
				current = current + 1		
			end	
			setElementModel(car, vehs[current][1])
			setVehicleColor(car,math.random(0,255),math.random(0,255),math.random(0,255))
		end
	end
	if button == "arrow_l" and state and not select then 
		if show then
			if current-1 <= 0 then
				current = #vehs
			else
				current = current - 1;	
			end	
			setElementModel(car, vehs[current][1])	
			setVehicleColor(car,math.random(0,255),math.random(0,255),math.random(0,255))
		end
	end

	if button == "mouse1" and state then 
		if clickTick+500 > getTickCount() then return end;
		if show and select then 
			if exports.fv_engine:isInSlot(sx/2-240,sy/2-10,230,40) then --Dollár
				local cost = vehs[current][6];
				if getPlayerVehCount()+1 > getElementData(localPlayer,"char >> vehSlot") then 
					exports.fv_infobox:addNotification("error","You don't have a free vehicle slot!");
					return;
				end
				if getModelCount(vehs[current][1]) >= vehs[current][8] then 
					exports.fv_infobox:addNotification("error","This vehicle has reached its limit!");
					return;
				end
				if getElementData(localPlayer,"char >> money") < cost then 
					exports.fv_infobox:addNotification("error","You don't have enough money!");
					return;
				end
				clickTick = getTickCount();
				triggerServerEvent("onServerBuy",localPlayer,localPlayer,getElementModel(car),cost,"char >> money",{getVehicleColor(car,true)});
				closeShop();
			end
			if exports.fv_engine:isInSlot(sx/2+10,sy/2-10,230,40) then 
				local cost = vehs[current][7];
				if getPlayerVehCount()+1 > getElementData(localPlayer,"char >> vehSlot") then 
					exports.fv_infobox:addNotification("error","You don't have a free vehicle slot!");
					return;
				end
				if getElementData(localPlayer,"char >> premiumPoints") < cost then 
					exports.fv_infobox:addNotification("error","You don't have enough premium points!");
					return;
				end
				clickTick = getTickCount();
				triggerServerEvent("onServerBuy",localPlayer,localPlayer,getElementModel(car),cost,"char >> premiumPoints",{getVehicleColor(car,true)});
				closeShop();
			end
		end
	end
end);


function closeShop()
	show = false;
	select = false;
	setCameraTarget(localPlayer);
	if isElement(car) then
		destroyElement(car);
	end
	setElementData(localPlayer, "togHUD", true);
	showChat(true);
	setElementDimension(localPlayer,0);
end
addEvent("closeShop",true);
addEventHandler("closeShop",root,closeShop);


function getPlayerVehCount()
	local count = 0;
	for k,v in pairs(getElementsByType("vehicle")) do 
		if getElementData(v,"veh:id") then 
			if getElementData(v,"veh:faction") == 0 then
				if getElementData(v,"veh:tulajdonos") == getElementData(localPlayer,"acc >> id") then 
					count = count + 1;
				end
			end
		end
	end
	return count;
 end

addEvent("carshop.syncLimit",true);
addEventHandler("carshop.syncLimit",localPlayer,function(table)
	loadedLimits = {};
	loadedLimits = table;
end);

function getModelCount(model)
	return loadedLimits[model] or 9999;
end

--Camera--
local last_cam_pos = 1
local cam_pos = {}
local enabled_cam = false
function setCameraPos(id)
	lastCamTick = getTickCount ()
	last_cam_pos = id
	local x,y,z,x2,y2,z2 = getCameraMatrix()
	cam_pos = {
		{x, y, z, x2, y2, z2, 2121.7392578125,-1130.2210693359,27.054100036621,2122.6962890625,-1130.3039550781,26.775793075562, 700},
	}
	enabled_cam = true
end
function updateCamPosition ()
	if cam_pos[last_cam_pos] and enabled_cam then
		local cTick = getTickCount ()
		local delay = cTick - lastCamTick
		local duration = cam_pos[last_cam_pos][13]
		local easing = "Linear"
		if duration and easing then
			local progress = delay/duration
			if progress < 1 then
				local cx,cy,cz = interpolateBetween (
					cam_pos[last_cam_pos][1],cam_pos[last_cam_pos][2],cam_pos[last_cam_pos][3],
					cam_pos[last_cam_pos][7],cam_pos[last_cam_pos][8],cam_pos[last_cam_pos][9],
					progress,easing
				)
				local tx,ty,tz = interpolateBetween (
					cam_pos[last_cam_pos][4],cam_pos[last_cam_pos][5],cam_pos[last_cam_pos][6],
					cam_pos[last_cam_pos][10],cam_pos[last_cam_pos][11],cam_pos[last_cam_pos][12],
					progress,easing
				)
				setCameraMatrix (cx,cy,cz,tx,ty,tz)
			else
				enabled_cam = false
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), updateCamPosition)



--Internet Check--
--[[setElementData(localPlayer,"network",true);
setTimer(function()
    if getNetworkStats()["packetlossLastSecond"] > 15 then 
        setElementData(localPlayer,"network",false);
    else 
        setElementData(localPlayer,"network",true);
    end
end,140,0);]]
function getNetworkState()
    return getElementData(localPlayer,"network");
end

