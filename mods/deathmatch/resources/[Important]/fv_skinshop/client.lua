local sx, sy = guiGetScreenSize()
local valt = 1
local current = 1
local skintype = nil
local type = 1
local renderSkins = false
local menu = nil
local skintype = nil
local choose = {"Men's skin", "Women's skin"}

local ped = createPed(7, 207.72911071777, -98.705307006836, 1005.2578125)
setElementData(ped, "skinped", true)
setElementDimension(ped,2);
setElementInterior(ped,15);
setElementData(ped,"ped >> name","Tony Raya")
setElementData(ped,"ped >> type","Clothing Store");
setElementRotation(ped,0,0,180);
setElementData(ped,"ped.noDamage",true);

local skins = {
	["Man"] = {
		{
			{7, "Clothing", 300},
			{14, "Clothing", 300},
			{15, "Clothing", 300},
			{16, "Clothing", 300},
			{17, "Clothing", 300},
			{18, "Clothing", 300},
			{19, "Clothing", 300},
			{20, "Clothing", 300},
			{21, "Clothing", 300},
			{22, "Clothing", 300},
			{23, "Clothing", 300},
			{34, "Clothing", 300},
		},
		{
			{44, "Clothing", 300},
			{46, "Clothing", 300},
			{47, "Clothing", 300},
			{48, "Clothing", 300},
			{49, "Clothing", 300},
			{51, "Clothing", 300},
			{52, "Clothing", 300},
			{57, "Clothing", 300},
			{58, "Clothing", 300},
			{59, "Clothing", 300},
			{60, "Clothing", 300},
			{62, "Clothing", 300},
		},
		{
			{67, "Clothing", 300},
			{68, "Clothing", 300},
			{72, "Clothing", 300},
			{73, "Clothing", 300},
			{78, "Clothing", 300},
			
			
		},
	},		
	["Woman"] = {
		{
			{9, "Clothing", 300},		
			{10, "Clothing", 300},	
			{11, "Clothing", 300},
			{13, "Clothing", 300},
			{12, "Clothing", 300},
			{41, "Clothing", 300},
			{55, "Clothing", 300},
			{85, "Clothing", 300},
			{91, "Clothing", 300},
			{92, "Clothing", 300},
			{93, "Clothing", 300},
			{130, "Clothing", 300},
		},
		{
			{85, "Clothing", 300},
			{91, "Clothing", 300},
		}
	},	
}

local shopPed = false;

addEventHandler("onClientResourceStart",getRootElement(),function(res)
	if getResourceName(res) == "fv_engine" or getThisResource() == res then 
		font = exports.fv_engine:getFont("rage",12);
		fonts = exports.fv_engine:getFont("rage",15);
		bigFont = exports.fv_engine:getFont("rage",300);
		sColor2 = exports.fv_engine:getServerColor("servercolor",true);
		sColor = {exports.fv_engine:getServerColor("servercolor",false)};
	end
end);

function PedClick(button, state, absX, absY, wx, wy, wz, element)
	if element and getElementData(element, "skinped") then
		if state == "down" and button == "left" then
			local x, y, z = getElementPosition(getLocalPlayer())
			if getDistanceBetweenPoints3D(x, y, z, wx, wy, wz) <= 4 then
				renderSkins = not renderSkins
				menu = "typechooser"
				setElementData(localPlayer,"togHUD",false);
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), PedClick, true)

function renderSkinshop()
	if renderSkins then
		if menu == "typechooser" then
			exports.fv_blur:createBlur()
			dxDrawRectangle(sx/2 - 330/2, sy/2 - 155/2, 330, 155, tocolor(0, 0, 0, 90))
			for i = 0, 1 do
				if type == (i + 1) then
					dxDrawRectangle(sx/2 - 330/2 + 5, sy/2 - 155/2 + 5 + i * 75, 320, 70, tocolor(sColor[1],sColor[2],sColor[3],150))
				else
					dxDrawRectangle(sx/2 - 330/2 + 5, sy/2 - 155/2 + 5 + i * 75, 320, 70, tocolor(0, 0, 0, 90))
				end	
				exports.fv_engine:shadowedText(choose[i + 1],sx/2 - 330/2 + 5,  sy/2 - 155/2 + 5 + i * 75, sx/2 - 330/2 + 5+320, sy/2 - 155/2 + 5 + i * 75+70, tocolor(255, 255, 255, 255), 1, font, "center", "center", false, false, false, true)
			end
		elseif menu == "skinchooser" then
			dxDrawRectangle(sx - 260, sy/2 - 500/2, 250, 500, tocolor(0,0,0, 3000))
			dxDrawRectangle(sx - 260, sy/2 - 500/2, 250, 55, tocolor(0,0,0, 50))
			dxDrawRectangle(sx - 260, sy/2 - 500/2 + 500 - 55, 250, 55, tocolor(0,0,0, 50))	
			dxDrawText(sColor2.."The#ffffffDevils\nClothing Store",sx - 260, sy/2 - 500/2 + 7,sx-260 + 250, 50, tocolor(255, 255, 255, 255), 1, fonts, "center", "top", false, false, false, true)
			
			local elem = 0
			for k, v in ipairs(skins[skintype][valt]) do
				if current == k then
					dxDrawRectangle(sx - 255, sy/2 - 400/2 +  elem * 35 + 10, 240, 30, tocolor(sColor[1],sColor[2],sColor[3],140))
				else
					dxDrawRectangle(sx - 255, sy/2 - 400/2 +  elem * 35 + 10, 240, 30, tocolor(0,0,0, 90))			
				end
				dxDrawText(v[2] .. " - " .. v[1],sx - 255 + 5, sy/2 - 400/2 +  elem * 35 + 14, 240, 30, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, false, true)
				dxDrawText(v[3].." #FFFFFFdt",sx - 255 + 200, sy/2 - 400/2 +  elem * 35 + 16, 240, 30, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, false, true)
				
				elem = elem + 1
			end
		end
		exports.fv_engine:shadowedText("Use the arrow keys to navigate!",0,sy-200,sx,0,tocolor(255,255,255,255),0.25,bigFont,"center","top",false,false,false,true);
	end
end
addEventHandler("onClientRender", getRootElement(), renderSkinshop)

addEventHandler("onClientKey", getRootElement(), function(k, v)
	if renderSkins and v then
		if k == "arrow_u" then
			if menu == "skinchooser" then
				if current - 1 > 0 then
					current = current - 1
				elseif current - 1 == 0 and skins[skintype][valt - 1] then
					valt = valt - 1
					current = #skins[skintype][valt]
				end
				setElementModel(shopPed, skins[skintype][valt][current][1])
			elseif menu == "typechooser" then
				if type - 1 > 0 then
					type = type - 1
				end
			end
		elseif k == "arrow_d" then
			if menu == "skinchooser" then
				if current + 1 == 12 and skins[skintype][valt + 1] then
					current = 1
					valt = valt + 1
				elseif current + 1 <= #skins[skintype][valt] then
					current = current + 1
				end
				setElementModel(shopPed, skins[skintype][valt][current][1])
			elseif menu == "typechooser" then
				if type + 1 < 3 then
					type = type + 1
				end
			end
		elseif k == "enter" then
			if menu == "typechooser" then
				if type == 1 then
					skintype = "Man"
				elseif type == 2 then
					skintype = "Woman"
				end
				x, y, z = getElementPosition(localPlayer)
				if isElement(shopPed) then 
					destroyElement(shopPed);
				end
				shopPed = createPed(skins[skintype][valt][current][1],217.78422546387, -98.490875244141, 1005.2578125);
				setElementRotation(shopPed,0,0,123);
				setElementInterior(shopPed,getElementInterior(localPlayer));
				setElementDimension(shopPed,getElementDimension(localPlayer));
				setElementData(shopPed,"ped >> noName",true);
				menu = "skinchooser"
				setCameraPos(1)
			elseif menu == "skinchooser" then
				local cost = tonumber(skins[skintype][valt][current][3]);
				if tonumber(getElementData(localPlayer,"char >> money")) < cost then 
					outputChatBox(exports.fv_engine:getServerSyntax("Skinshop","red").."You don't have enough money to buy!",255,255,255,true);
					return;
				end
				triggerServerEvent("onSkinBuy", localPlayer, localPlayer, skins[skintype][valt][current][1],cost);
				setElementModel(localPlayer, skins[skintype][valt][current][1]);
				menu = nil
				current = 1
				valt = 1
				skintype = nil
				renderSkins = false
				setCameraTarget(localPlayer)
				setElementPosition(localPlayer, x, y, z)
				if isElement(shopPed) then 
					destroyElement(shopPed);
				end
				setElementData(localPlayer,"togHUD",true);

			end
		elseif k == "backspace" then
			menu = nil
			current = 1
			valt = 1
			skintype = nil
			renderSkins = false
			setCameraTarget(localPlayer)
			--setElementPosition(localPlayer, x, y, z)
			if isElement(shopPed) then 
				destroyElement(shopPed);
			end
			setElementData(localPlayer,"togHUD",true);

		end
	end
end)

local last_cam_pos = 1
local cam_pos = {}
local enabled_cam = false
function setCameraPos(id)
	lastCamTick = getTickCount ()
	last_cam_pos = id
	local x,y,z,x2,y2,z2 = getCameraMatrix()
	cam_pos = {
		{x, y, z, x2, y2, z2, 214.02319335938,-100.15660095215,1006.8994140625,214.89503479004,-99.84676361084,1006.5200805664, 1500},
	}
	enabled_cam = true
end

function updateCamPosition ()
	if cam_pos[last_cam_pos] and enabled_cam and renderSkins then
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