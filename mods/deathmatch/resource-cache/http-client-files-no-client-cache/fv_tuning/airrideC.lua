local aShow = false;
local aPos = {sx-160,sy/2-40};
local windowOffsetX, windowOffsetY = 0, 0;
local aPanelMove = false;
local aLast = 0;

function renderAirRide()
    if aShow then 
        local veh = getPedOccupiedVehicle(localPlayer);
        if not veh then 
            aShow = false;
            removeEventHandler("onClientRender",root,renderAirRide);
        end
        if veh and not getElementData(veh,"tuning.airRide") then 
            aShow = false;
            removeEventHandler("onClientRender",root,renderAirRide);
        end
        if isCursorShowing() then
            cursorX, cursorY = getCursorPosition();
            cursorX, cursorY = cursorX * sx, cursorY * sy;
        else 
            aPanelMove = false;
        end

        if aPanelMove then 
            aPos = {cursorX + windowOffsetX, cursorY + windowOffsetY};
        end

        dxDrawRectangle(aPos[1],aPos[2],150,100,tocolor(0,0,0,180));
        dxDrawRectangle(aPos[1],aPos[2],150,20,tocolor(0,0,0,180));
        dxDrawText("Air-Ride",aPos[1],aPos[2],aPos[1]+150,aPos[2]+20,tocolor(255,255,255),1,e:getFont("rage",13),"center","center");
        dxDrawRectangle(aPos[1]-3,aPos[2],3,100,tocolor(sColor[1],sColor[2],sColor[3]));

        local level = (veh and getElementData(veh,"tuning.airRide.level") or 0);
        if level == 0 then 
            level = "Alap";
        end
        dxDrawText("Current level: "..sColor2..level,aPos[1],aPos[2]+80,aPos[1]+150,0,tocolor(255,255,255),1,e:getFont("rage",10),"center","top",false,false,false,true);

        local icons = e:getFont("AwesomeFont",24);
        local upColor = tocolor(50,50,50,180);
        local downColor = tocolor(50,50,50,180);
        if e:isInSlot(aPos[1]+20,aPos[2]+25,50,50) then 
            upColor = tocolor(sColor[1],sColor[2],sColor[3],180);
        end
        dxDrawRectangle(aPos[1]+20,aPos[2]+25,50,50,upColor);
        e:shadowedText("",aPos[1]+20,aPos[2]+25,aPos[1]+20+50,aPos[2]+25+50,tocolor(200,200,200),1,icons,"center","center");

        if e:isInSlot(aPos[1]+80,aPos[2]+25,50,50) then 
            downColor = tocolor(sColor[1],sColor[2],sColor[3],180);
        end
        dxDrawRectangle(aPos[1]+80,aPos[2]+25,50,50,downColor);
        e:shadowedText("",aPos[1]+80,aPos[2]+25,aPos[1]+80+50,aPos[2]+25+50,tocolor(200,200,200),1,icons,"center","center");
    end
end

addEventHandler("onClientClick", root, function(button,state,x,y)
if aShow then 
    local veh = getPedOccupiedVehicle(localPlayer);
    if button == "left" then 
        if state == "down" then 
            if not aPanelMove then 
                if e:isInSlot(aPos[1],aPos[2],150,20) then 
                    windowOffsetX, windowOffsetY = aPos[1] - x, aPos[2] - y;
                    aPanelMove = true;
                end
            end
            if e:isInSlot(aPos[1]+20,aPos[2]+25,50,50) then --UP
                if aLast+2000 > getTickCount() then outputChatBox(exports.fv_engine:getServerSyntax("Air-Ride","red").."Wait a minute!",255,255,255,true) return end;
                local current = getElementData(veh,"tuning.airRide.level") or 0;
                if current+1 > 6 then 
                    outputChatBox(exports.fv_engine:getServerSyntax("Air-Ride","red").."It is already at the highest level.",255,255,255,true);
                    return;
                end
                triggerServerEvent("tuning.changeAirRide",localPlayer,localPlayer,veh,current+1);
                aLast = getTickCount();
            end
            if e:isInSlot(aPos[1]+80,aPos[2]+25,50,50) then --Down 
                if aLast+2000 > getTickCount() then outputChatBox(exports.fv_engine:getServerSyntax("Air-Ride","red").."Wait a minute!",255,255,255,true) return end;
                local current = getElementData(veh,"tuning.airRide.level") or 0;
                if current-1 < 0 then 
                    outputChatBox(exports.fv_engine:getServerSyntax("Air-Ride","red").."It is already at the lowest level.",255,255,255,true);
                    return;
                end
                triggerServerEvent("tuning.changeAirRide",localPlayer,localPlayer,veh,current-1);
                aLast = getTickCount();
            end
        else 
            if aPanelMove then 
                aPanelMove = false;
            end
        end
    end
end
end);

function airRideCommand(cmd)
    local veh = getPedOccupiedVehicle(localPlayer);
    if veh then 
        if getElementData(veh,"tuning.airRide") then 
            if aShow then 
                aShow = false;
                removeEventHandler("onClientRender",root,renderAirRide);
            else 
                aShow = true;
                removeEventHandler("onClientRender",root,renderAirRide);
                addEventHandler("onClientRender",root,renderAirRide);
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Air-Ride","red").."There is no Air-Ride in the vehicle!",255,255,255,true);
        end
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Air-Ride","red").."You're not in a vehicle!",255,255,255,true);
    end
end
addCommandHandler("airride",airRideCommand,false,false);
addCommandHandler("ar",airRideCommand,false,false);