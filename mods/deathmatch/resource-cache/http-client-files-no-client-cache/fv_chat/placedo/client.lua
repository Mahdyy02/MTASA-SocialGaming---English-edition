local screen = {guiGetScreenSize()};
local placeDoCache = {};
local clickTick = 0;

addEventHandler("onClientResourceStart",resourceRoot,function()
    setTimer(function()
        triggerServerEvent("placeDoSync",localPlayer,localPlayer);
    end,1000,1);
    setElementData(localPlayer,"placedo",0);
end);

addEvent("receivePlaceDo",true)
addEventHandler("receivePlaceDo",localPlayer,function(tbl)
	placeDoCache = tbl;
end);

addEventHandler("onClientRender",getRootElement(),function()
    if getElementData(localPlayer,"loggedIn") then
        if #placeDoCache > 0 then 
            local font = exports.fv_engine:getFont("rage",11);
            local icons = exports.fv_engine:getFont("AwesomeFont",18);
            for k,v in pairs(placeDoCache) do
                local x = v["x"];
                local y = v["y"];
                local z = v["z"];
                local owner = v["owner"];
                local ownerName = v["ownerName"];
                local message = v["message"];
                local playerX,playerY,playerZ = getElementPosition(localPlayer);
                local placeX,placeY,placeZ = x,y,z;
                local pdistance = getDistanceBetweenPoints3D(playerX,playerY,playerZ,placeX,placeY,placeZ);
                if(pdistance <= 20)then
                    local posX,posY = getScreenFromWorldPosition(placeX,placeY,placeZ-0.55);
                    if(posX and posY)then
                        local progress = pdistance/20
                        local scale = interpolateBetween(1, 0, 0, 0.3, 0, 0, progress, "OutQuad")
                        scale = scale*(screen[1]+1280)/(1280*1.9);
                        exports.fv_engine:shadowedText("* "..message.." (("..ownerName..")) *",posX,posY,posX,posY,tocolor(255,51,102,255),1*scale,font,"center","center");
                        if (owner == getElementData(localPlayer,"acc >> id") or (getElementData(localPlayer,"admin >> duty") and getElementData(localPlayer,"admin >> level") > 2)) then
                            local alpha = 200;
                            if pdistance < 3 then 
                                exports.fv_engine:shadowedText("",posX-15*scale,posY+10,posX-15*scale+30*scale,posY+10+30*scale,tocolor(255,51,102,alpha),1*scale,icons,"center","center");
                                if isCursorShowing() and exports.fv_engine:isInSlot(posX-((35/2)*scale),posY+(25*scale),35*scale,35*scale) then 
                                    alpha = 255;
                                    if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                                        --if (owner == getElementData(localPlayer,"acc >> id") or getElementData(localPlayer,"admin >> duty")) then
                                            triggerServerEvent("deleteMyOnePlaceDo",localPlayer,localPlayer,k);
                                            clickTick = getTickCount();
                                            return;
                                        --end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
	end
end);

