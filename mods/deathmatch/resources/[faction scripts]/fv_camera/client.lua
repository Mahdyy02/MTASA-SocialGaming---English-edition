--Social Gaming--
local kepernyom = {guiGetScreenSize()}
local PanelElolvan = false
local Matrix = 0
local save = {};
local kameraHelyek = {
	{"Police",1508.3216552734,-1578.4792480469,34.77970123291,1508.6434326172,-1579.3474121094,34.401824951172,0,0},
}
local markers = {
	{257.0393371582, 69.30436706543, 1003.640625,6,1},
}
addEventHandler("onClientResourceStart",root,function(res)
	if res == getThisResource() then  
		for k,v in pairs(markers) do 
			local x,y,z,inter,dim = unpack(v);
			local r,g,b = exports.fv_engine:getServerColor("orange",false);
			local mark = createMarker(x,y,z-1,"cylinder",1.2,r,g,b,100);
			setElementDimension(mark,dim);
			setElementInterior(mark,inter);
			addEventHandler("onClientMarkerHit",mark,function(hitElement)
				if hitElement == localPlayer then 
					if getElementData(localPlayer,"faction_2") then 
						if not PanelElolvan then 
							local x, y, z = getElementPosition(getLocalPlayer())
							local wx,wy,wz = getElementPosition(source);
							if getDistanceBetweenPoints3D(x, y, z, wx, wy, wz) <= 2 then
								PanelElolvan = true
								setElementFrozen(localPlayer,true)
								save = {getElementInterior(localPlayer),getElementDimension(localPlayer)};
							end
						end 
					else 
						outputChatBox(exports.fv_engine:getServerSyntax("camera","red").."You do not belong to a law enforcement organization!",255,255,255,true);
						return;
					end
				end
			end);
		end
	end
	if getResourceName(res) == "fv_engine" or res == getThisResource() then 
		font = exports.fv_engine:getFont("rage",12);
		font2 = exports.fv_engine:getFont("rage",10);
	end
end);

function PanelKeszit()
	if Matrix == 1 then 
		dxDrawRectangle(kepernyom[1]-100,kepernyom[2]-30,100, 30,tocolor(0,0,0,255/1.5))
		dxDrawText("egress ",kepernyom[1]-90,kepernyom[2]-25,100, 30,tocolor(255,255,255,255),1,font, "left", "top", false, false, false, true)
	end
	if PanelElolvan then
		dxDrawRectangle(kepernyom[1]/2-250/2,kepernyom[2]/2-450/2,250, 380,tocolor(0,0,0,255/1.5))
		dxDrawRectangle(kepernyom[1]/2-250/2,kepernyom[2]/2-450/2,250, 50,tocolor(0,0,0,255/2))
		dxDrawText(exports.fv_engine:getServerColor("servercolor",true).."Tunisian#ffffffDevils",0,kepernyom[2]/2-450/2+7,kepernyom[1], 50,tocolor(255, 255, 255,255),1,font, "center", "top", false, false, false, true)
		dxDrawText("Use the BACKSPACE button to close it.",0,kepernyom[2]/2+170,kepernyom[1], 50,tocolor(255, 255, 255,255),1,font, "center", "top", false, false, false, true)	
		
		for i,k in ipairs(kameraHelyek) do
			dxDrawRectangle(kepernyom[1]/2-250/2+10,kepernyom[2]/2-450/2+20+i*35,230, 30,tocolor(0,0,0,255/1.5))
			 if exports.fv_engine:isInSlot(kepernyom[1]/2-250/2+10,kepernyom[2]/2-450/2+20+i*35,230, 30) then
				local r,g,b = exports.fv_engine:getServerColor("servercolor",false);
				dxDrawRectangle(kepernyom[1]/2-250/2+10,kepernyom[2]/2-450/2+20+i*35,230, 30,tocolor(r,g,b,255/1.5))
			 end
			dxDrawText(k[1],kepernyom[1]/2-250/2+30/2,kepernyom[2]/2-450/2+25+i*35,50, 50,tocolor(255, 255, 255,255),1,font2, "left", "top", false, false, false, true)			
		end
		
	end
end
addEventHandler("onClientRender",getRootElement(),PanelKeszit)

function menuClick(gomb,stat,x,y)
	if	(PanelElolvan == true or Matrix == 1) then
		if gomb == "left" and stat == "down" then
		for k,v in ipairs(kameraHelyek) do
			if exports.fv_engine:isInSlot(kepernyom[1]/2-250/2+10,kepernyom[2]/2-450/2+20+k*35,230, 30) then
				save = {getElementInterior(localPlayer),getElementDimension(localPlayer)};

				setElementDimension(localPlayer,0);
				setElementInterior(localPlayer,0);
				setCameraMatrix(v[2],v[3],v[4],v[5],v[6],v[7])
				PanelElolvan = false
				Matrix = 1
				setElementData(localPlayer, "togHUD", false)
			end
		end
			if exports.fv_engine:isInSlot(kepernyom[1]-100,kepernyom[2]-30,100, 30) then
				Matrix = 0
				setElementFrozen(localPlayer,false)
				setElementData(localPlayer, "togHUD", true)
				triggerServerEvent("cam.setPos",localPlayer,localPlayer,save[1],save[2]);
				setCameraTarget(getLocalPlayer(),getLocalPlayer());
				save = {};
			end
		end
	end
end
addEventHandler("onClientClick",getRootElement(),menuClick)

addEventHandler("onClientKey",getRootElement(),function(gomb,s)
	if not PanelElolvan or not s then return end
	if gomb == "backspace" then
		PanelElolvan = false
		setElementFrozen(localPlayer,false)
		if #save > 0 then 
			triggerServerEvent("cam.setPos",localPlayer,localPlayer,save[1],save[2]);
		else 
			triggerServerEvent("cam.setPos",localPlayer,localPlayer,0,0);
		end
		setCameraTarget(getLocalPlayer(),getLocalPlayer());
		save = {};
	end
end);
