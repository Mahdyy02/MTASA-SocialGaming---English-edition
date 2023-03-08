sx,sy = guiGetScreenSize();
e = exports.fv_engine;
white = "#FFFFFF";

local markers = {
    {1182.8775634766, -1331.0483398438, 13.583568572998},
}
local markerCache = {};
local show = false;
local state = "up";
local tick = 0;

addEventHandler("onClientResourceStart",root,function(res)
    if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        e = exports.fv_engine;
        sColor2 = e:getServerColor("servercolor",true);
    end
    if res == getThisResource() then 
        markerCache = {};
        for k,v in pairs(markers) do 
            local x,y,z = unpack(v);
            local r,g,b = e:getServerColor("red",false);
            local mark = createMarker(x,y,z-1.5,"cylinder",1,r,g,b,120);
            addEventHandler("onClientMarkerHit",mark,function(hitElement,dim)
                if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                    show = true;
                    state = "up";
                    tick = getTickCount();
                    removeEventHandler("onClientRender",root,drawHeal);
                    addEventHandler("onClientRender",root,drawHeal);
                end
            end);
            addEventHandler("onClientMarkerLeave",mark,function(hitElement,dim)
                if hitElement == localPlayer and dim then 
                    tick = getTickCount();
                    show = false;
                    state = "down";
                end
            end);

            setElementData(mark,"heal.custom",true);
            markerCache[#markerCache + 1] = mark;
        end
    end
end);

addEventHandler("onClientKey",root,function(button,state)
if show then 
    if button == "e" and state then 
	    local counter = 0;
		for _,v in pairs(getElementsByType("player")) do		
			if getElementData(v,"duty.faction") == 56 then
				counter = counter + 1;
			end			
		end
		if counter == 0 then    
	        if not isChatBoxInputActive() then 
	            if getElementData(localPlayer,"char >> money") < 500 then 
	                outputChatBox(exports.fv_engine:getServerSyntax("Healing","red").."You don't have enough money!"..sColor2.."(500 dt)"..white..".",255,255,255,true);
	                return;
	            end
	            local mc = 0;
	            for k,v in pairs(getElementsByType("player")) do 
	                if getElementData(v,"loggedIn") and getElementData(v,"faction_6") then 
	                    mc = mc + 1;
	                end
	            end
	            if mc < 3 then 
	                local check = false;
	                if getElementHealth(localPlayer) < 100 then 
	                    check = true;
	                end
	                local bones = getElementData(localPlayer,"char >> bone");
	                for k,v in pairs(bones) do 
	                    if not v then 
	                        check = true;
	                        break;
	                    end
	                end
	                if check then 
	                    setElementData(localPlayer, "char >> bone", {true, true, true, true, true});
	                    setElementHealth(localPlayer,100);
	                    --setElementData(localPlayer,"char >> money",getElementData(localPlayer,"char >> money") - 500);
	                    triggerServerEvent("ac.elementData",localPlayer,localPlayer,"char >> money",getElementData(localPlayer,"char >> money") - 500);
	                    outputChatBox(exports.fv_engine:getServerSyntax("Healing","servercolor").."Medical expenses were deducted. "..sColor2.."(500 dt)"..white..".",255,255,255,true);
	                else 
	                    outputChatBox(exports.fv_engine:getServerSyntax("Healing","red").."You don't need medical attention!",255,255,255,true);
	                    return;
	                end
	            else 
	                outputChatBox(exports.fv_engine:getServerSyntax("Healing","red").."There is an online ambulance, visit me!",255,255,255,true);
	                return;
	            end
	        end
	    else
	    	outputChatBox(exports.fv_engine:getServerSyntax("Healing","red").."You can't use this service while there is a doctor on duty.",255,255,255,true);
	    end
	end
end);


--Marker Imgage--
local distance = 50;
local healTexture = dxCreateTexture("medic.png","dxt5");

addEventHandler("onClientPreRender", root, function()
    for i, v in ipairs(markerCache) do
        local x,y,z = getElementPosition(v)     
        local x2,y2,z2 = getElementPosition(localPlayer)  
        local r, g, b, a = getMarkerColor(v)
        local distancePoints = getDistanceBetweenPoints3D(x, y, z, x2,y2,z2)
		if getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v) == getElementInterior(localPlayer) then
            if distancePoints <= distance then
				local size = getMarkerSize(v)
                dxDrawMaterialLine3D(x+size/2, y+size/2, z+0.5, x-size/2, y-size/2, z+0.5, healTexture, size*1.4, tocolor(r, g, b, 155),x,y,z)
			end
		end
    end
end)


function drawHeal()
    local font = e:getFont("rage",15);
    if state == "up" then 
        local x,y = interpolateBetween(sx/2-50,sy+100,0,sx/2-50,sy-150,0,(getTickCount()-tick)/1000,"OutBack");
        dxDrawRectangle(x,y,100,100,tocolor(0,0,0,180)); 
        dxDrawText("Healing\n"..e:getServerColor("servercolor",true).."E"..white.."\nkey",x,y,x+100,y+100,tocolor(255,255,255),1,font,"center","center",false,false,false,true); 
    elseif state == "down" then 
        local x,y = interpolateBetween(sx/2-50,sy-150,0,sx/2-50,sy+100,0,(getTickCount()-tick)/1000,"OutBack");
        if y == (sy+100) then 
            show = false;
            removeEventHandler("onClientRender",root,drawHeal);
        end
        dxDrawRectangle(x,y,100,100,tocolor(0,0,0,180)); 
        dxDrawText("Healing\n"..e:getServerColor("servercolor",true).."E"..white.."\nkey",x,y,x+100,y+100,tocolor(255,255,255),1,font,"center","center",false,false,false,true); 
    end
end