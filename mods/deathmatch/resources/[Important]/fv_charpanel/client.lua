sx,sy = guiGetScreenSize();

local x,y = 0,0
local r,g,b = exports.fv_engine:getServerColor("servercolor",false)
local font = exports.fv_engine:getFont("rage", 13)
local e = exports.fv_engine;
local panel = false
local element = false
local menu = {
    {"body search","motoz"},
    {"Cuff","cuff"},
    {"Carry","getup"},
    {"Close","close"},
}
local clickTick = 0;
local allowedFactions = { --Bilincselés frakik
	54, 52, 53
}


addEventHandler("onClientResourceStart",root,function(res)
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        r,g,b = exports.fv_engine:getServerColor("servercolor",false)
        font = exports.fv_engine:getFont("rage", 13)
        e = exports.fv_engine;
    end
end);


function render()
	if element and isElement(element) then
		panel = true
		local px,py,pz = getElementPosition(localPlayer);
		local ox,oy,oz = getElementPosition(element);
		if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) > 4 or not isElementOnScreen(element) then 
			closePanel()
		end

		dxDrawRectangle(x-3,y,3,180,tocolor(r,g,b));
        roundedRectangle(x,y,200,180,tocolor(0,0,0, 180));
        
        dxDrawText(getElementData(element,"char >> name"),x,y,x+200,200,tocolor(255,255,255),1,font,"center");

        for k,v in pairs(menu) do 
            local color = tocolor(80,80,80,100);
            if e:isInSlot(x+5,y+(k*35),190,30) then 
                color = tocolor(r,g,b,180);
                if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
					if v[2] == "motoz" then 
						if getElementData(element,"handsup") or getElementData(element, "collapsed") or getElementData(element,"cuffed") then 
							triggerServerEvent("item.motoz",localPlayer,localPlayer,element);
							closePanel();
						else 
                            outputChatBox(exports.fv_engine:getServerSyntax("Body Search","red").."Player has no hands on!",255,255,255,true);
						end
					elseif v[2] == "cuff" then 
						local a = perm(getElementData(element,"cuffed"))
						if a == "fraki" or a == "admin" then 
							if getElementData(element,"cuffed") then 
								triggerServerEvent("cuff",localPlayer,localPlayer,element,false,a);
							else 
								triggerServerEvent("cuff",localPlayer,localPlayer,element,true,a);
							end
						elseif not a then
							outputChatBox(exports.fv_engine:getServerSyntax("Handcuffs","red").."You have no handcuffs",255,255,255,true);
						end
                    elseif v[2] == "getup" then 
						if getElementData(element, "collapsed") then 
							if not getElementData(element,"getupHelper") then 
								triggerServerEvent("collapsed.item", localPlayer, localPlayer, element);
							else 
								outputChatBox(exports.fv_engine:getServerSyntax("Carry","red").."A player is already assisted by another player!",255,255,255,true);
							end
                        else 
                            outputChatBox(exports.fv_engine:getServerSyntax("Carry","red").."Player is not in animation!",255,255,255,true);
                        end
                    elseif v[2] == "close" then 
                        closePanel();
                    end
                    clickTick = getTickCount();
                end
            end
			dxDrawRectangle(x+5,y+(k*35),190,30,color);
			if v[2] == "cuff" and element and isElement(element) then 
				local text = v[1];
				if getElementData(element,"cuffed") then
					text = "Removing the clamp";
				end
				dxDrawText(text, x, y+(k*35), x+200, y+(k*35)+30, tocolor(255,255,255,alpha1), 1, font, "center", "center")
			else 
				dxDrawText(v[1], x, y+(k*35), x+200, y+(k*35)+30, tocolor(255,255,255,alpha1), 1, font, "center", "center")
			end
        end
	else
		panel = false
	end
end

addEventHandler("onClientClick",root,function(button,state,cx,cy,wx,wy,wz,clickedElement)
if clickedElement and getElementType(clickedElement) == "player" then 
	if button == "right" and state == "down" then 
		if not element and getElementData(clickedElement,"acc >> id") > 0 and clickedElement ~= localPlayer and not getElementData(localPlayer,"collapsed") then 
		--if not element and getElementData(clickedElement,"acc >> id") > 0 then 
			local px,py,pz = getElementPosition(localPlayer)
			if getDistanceBetweenPoints3D(px,py,pz,wx,wy,wz) < 3 then
				element = clickedElement;
				x,y = cx,cy
				removeEventHandler("onClientRender",root,render)
				addEventHandler("onClientRender",root,render)
			end
		end
	end
end
end)

function closePanel()
	removeEventHandler("onClientRender",root,render);
	element = false;
	x,y = 0,0;
end

function perm(state)
	if (getElementData(localPlayer,"admin >> duty") and getElementData(localPlayer,"admin >> level") > 2) then 
		return "admin";
	elseif (factionAllow()) then 
		if exports.fv_inventory:hasItem(87,false,1) and not state then 
			return "fraki";
		elseif state then 
			return "fraki";
		else
			return false;
		end
	end
end

function factionAllow()
	local state = false;
	for k,v in pairs(allowedFactions) do 
		if getElementData(localPlayer,"faction_"..v) then 
			state = true;
			break;
		end
	end
	return state;
end



--Bilincs Modell---
local txd = engineLoadTXD("cuff.txd",364)
engineImportTXD(txd,364)
local dff = engineLoadDFF("cuff.dff",364)
engineReplaceModel(dff,364)
------------------
--Bilincs Sync--
addEvent("animSped", true);
addEventHandler( "animSped", root, function(player,anim,speed)
	setPedAnimationSpeed(player,anim, speed);
	setPedAnimationProgress(player, "pass_Smoke_in_car", 0);
end);
------------------