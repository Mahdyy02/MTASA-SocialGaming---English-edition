sx,sy = guiGetScreenSize();
local show = false;
local tick = getTickCount();
local state = "open";
local w,h = 0,30;
local x,y = sx/2-w/2,sy-150;
local dutyTick = 0;

addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if res == getThisResource() then 
        for k,v in pairs(dutyPostions) do
            local size,x,y,z,interior,dimension = unpack(v);
            local r,g,b = exports.fv_engine:getServerColor("blue",false);
            local mark = createMarker(x,y,z-2,"cylinder",size,r,g,b,130);
            --local mark = createMarker(x,y,z-1.3,"cylinder",size,r,g,b,130);
            setElementInterior(mark,interior);
            setElementDimension(mark,dimension);
            setElementData(mark,"duty.mark",true);
            setElementData(mark,"duty.faction",k);
            setElementData(mark,"m.custom","duty");
        end
    end
    if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        font = exports.fv_engine:getFont("rage",10);
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
    end
end)
addEventHandler("onClientMarkerHit",getRootElement(),function(hitElement,dim)
    if hitElement == localPlayer and dim and getElementData(source,"duty.mark") then 
        if not show then 
            show = getElementData(source,"duty.faction");
            state = "open";
            tick = getTickCount();
            removeEventHandler("onClientRender",root,drawDuty);
            addEventHandler("onClientRender",root,drawDuty);
        end
    end
end);
addEventHandler("onClientMarkerLeave",getRootElement(),function(hitElement,dim)
    if hitElement == localPlayer and getElementData(source,"duty.mark") then 
        if show then 
            show = false;
            state = "close";
            tick = getTickCount();
        end
    end
end);
function drawDuty()
    if state == "open" then 
        w = interpolateBetween(0,0,0,370,0,0,(getTickCount()-tick)/1000,"InOutQuad");
        x = sx/2-w/2;
    else 
        w = interpolateBetween(370,0,0,0,0,0,(getTickCount()-tick)/1000,"InOutQuad");
        x = sx/2-w/2;
        if w == 0 then 
            removeEventHandler("onClientRender",root,drawDuty);
        end
    end
    dxDrawRectangle(x,y,w,h,tocolor(0,0,0,180));
    dxDrawText("Press 'E' to interact!",x,y,x+w,y+h,tocolor(255,255,255),1,font,"center","center",true,false,true,false);
end
addEventHandler("onClientKey",root,function(button,state)
    if button == "e" and state then 
        if show and show > 0 then 
            if getElementData(localPlayer,"faction_"..show) then 
                local cD = getElementData(localPlayer,"duty.faction");
                if cD and cD ~= show then 
                    outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."You are on duty elsewhere!",255,255,255,true);
                else 
                    if dutyTick+1000*60 > getTickCount() then outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."You can only enter service every minute!",255,255,255,true) return end;
                    if not cD then 
                        if getElementData(localPlayer,"faction_"..show.."_dutyskin") == 0 then 
                            outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."Not set dutyskin! Go to the binco!",255,255,255,true);
                            return;
                        end
                        triggerServerEvent("duty.interaction",localPlayer,localPlayer,show,true,getElementData(localPlayer,"faction_"..show.."_dutyskin"));
                    else 
                        triggerServerEvent("duty.interaction",localPlayer,localPlayer,show,false,getElementData(localPlayer,"char >> civilSkin"));
                    end
                    dutyTick = getTickCount();
                end
            else 
                outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."You do not belong to the faction!",255,255,255,true);
                return;
            end
        end
    end
end);

--Marker Imgage--
local distance = 50
local texNames = {
    {"duty"}
}
local textures = {}

addEventHandler("onClientResourceStart",resourceRoot,function()
	textures = {}
	for k,v in pairs(texNames) do
		textures[v[1]] = dxCreateTexture("icons/"..v[1]..".png","argb")
	end
end)

addEventHandler("onClientPreRender", root, function()
    for i, v in ipairs(getElementsByType("marker",resourceRoot,true)) do
       if getElementData(v,"m.custom") then
            local x,y,z = getElementPosition(v)     
            local x2,y2,z2 = getElementPosition(localPlayer)  
            local r, g, b, a = getMarkerColor(v)
            local distancePoints = getDistanceBetweenPoints3D(x, y, z, x2,y2,z2)
			if getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v) == getElementInterior(localPlayer) then
				if distancePoints <= distance then
					local size = getMarkerSize(v)
                    dxDrawMaterialLine3D(x+size/2, y+size/2, z+1.01, x-size/2, y-size/2, z+1.01, textures[getElementData(v,"m.custom")], size*1.4, tocolor(r, g, b, 155),x,y,z)
				end
			end
        end
    end
end)

