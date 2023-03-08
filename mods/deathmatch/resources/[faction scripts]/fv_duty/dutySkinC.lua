local pedPos = {202.42918395996, -95.669364929199, 1005.2578125};
local dShow = false;
local currentSkin = 1;
local faction = 0;
local dPed = false;

function dutySkinRender()
	local font = exports.fv_engine:getFont("rage",13);
	local white = "#FFFFFF";
	local sColor = exports.fv_engine:getServerColor("servercolor",true);
	shadowedText("Skin selection:"..sColor.." ARROWS"..white.."\nSkin Adjustment:"..sColor.." ENTER"..white.."\negress: "..sColor.."BACKSPACE",0,0,sx,sy,tocolor(255,255,255),1,font,"center","bottom",true);
end


function setDutySkin(f)
	dShow = true;
	currentSkin = 1;
	faction = f;
	removeEventHandler("onClientRender",root,dutySkinRender);
	addEventHandler("onClientRender",root,dutySkinRender);
	dPed = createPed(dutySkins[f][currentSkin],pedPos[1],pedPos[2],pedPos[3],180);
	setElementFrozen(dPed,true);
	setElementData(dPed,"ped >> noName",true);
	setElementDimension(dPed,getElementDimension(localPlayer));
	setElementInterior(dPed,getElementInterior(localPlayer));
	setCameraMatrix(203.11099243164,-102.41850280762,1007.0435180664,203.0590057373,-101.48038482666,1006.7011108398);
	setElementFrozen(localPlayer,true);
	setElementData(localPlayer,"togHUD",false);
	showChat(false);
end

function closeDutySkin()
	if isElement(dPed) then 
		destroyElement(dPed);
	end
	dShow = false;
	currentSkin = 1;
	faction = 0;
	removeEventHandler("onClientRender",root,dutySkinRender);
	setCameraTarget(localPlayer,localPlayer);
	setElementFrozen(localPlayer,false);
	setElementData(localPlayer,"togHUD",true);
	showChat(true);
end

addEventHandler("onClientKey",root,function(button,state)
if dShow then 
	if button == "arrow_l" and state then --Balra
		if currentSkin-1 <= 0 then 
			currentSkin = #dutySkins[faction];
			setElementModel(dPed,dutySkins[faction][currentSkin]);
		else 
			currentSkin = currentSkin - 1;
			setElementModel(dPed,dutySkins[faction][currentSkin]);
		end
	elseif button == "arrow_r" and state then --Jobbra
		if currentSkin+1 > #dutySkins[faction] then 
			currentSkin = 1;
			setElementModel(dPed,dutySkins[faction][currentSkin]);
		else 
			currentSkin = currentSkin + 1;
			setElementModel(dPed,dutySkins[faction][currentSkin]);
		end
	elseif button == "enter" and state then 
		triggerServerEvent("duty.setSkin",localPlayer,localPlayer,faction,dutySkins[faction][currentSkin]);
		closeDutySkin();
	elseif button == "backspace" and state then 
		closeDutySkin();
	end
end
end);

--UTILS--
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY,postGUI)
	if not postGUI then postGUI = false end
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI,true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI,true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI,true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, postGUI,true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, postGUI,true)
end