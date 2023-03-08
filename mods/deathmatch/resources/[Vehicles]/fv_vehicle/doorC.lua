local dShow = false;
local dPos = {sx/2-150,sy/2-100};
local dMove = {0,0};
local dMoving = false;
local dClick = 0;

function dRender()
    if not getElementData(localPlayer,"togHUD") then return end;
    
    local playerVehicle = getPedOccupiedVehicle(localPlayer);
    if not dShow or not isElement(dShow) or playerVehicle ~= dShow then 
        dClosePanel();
    end

    if dShow then 
        if isCursorShowing() then
            cursorX, cursorY = getCursorPosition();
            cursorX, cursorY = cursorX * sx, cursorY * sy;
            if dMoving then 
                dPos = {cursorX + dMove[1], cursorY + dMove[2]};
            end
        else 
            dMove = {};
            dMoving = false;
        end
        dxDrawRectangle(dPos[1],dPos[2],300,200,tocolor(0,0,0,150));
        dxDrawRectangle(dPos[1],dPos[2],300,20,tocolor(0,0,0,150));
        dxDrawText("Handling of doors",dPos[1],dPos[2],dPos[1]+300,dPos[2]+20,tocolor(255,255,255),1,e:getFont("rage",12),"center","center");
        dxDrawRectangle(dPos[1]-3,dPos[2],3,200,tocolor(sColor[1],sColor[2],sColor[3],180));

        dxDrawImage(dPos[1]+150-32,dPos[2]+80,64,64,"files/doors.png");

        local hoodState = getVehicleDoorOpenRatio(dShow,0);
        if hoodState == 0 then 
            dxDrawRectangle(dPos[1]+100,dPos[2]+40,100,25,tocolor(sColor[1],sColor[2],sColor[3],180));
        else 
            dxDrawRectangle(dPos[1]+100,dPos[2]+40,100,25,tocolor(red[1],red[2],red[3],180));
        end
        e:shadowedText(dStateText(hoodState),dPos[1]+100,dPos[2]+40,dPos[1]+100+100,dPos[2]+40+25,tocolor(255,255,255),1,e:getFont("rage",13),"center","center");
        
        local trunkState = getVehicleDoorOpenRatio(dShow,1);
        if trunkState == 0 then 
            dxDrawRectangle(dPos[1]+100,dPos[2]+160,100,25,tocolor(sColor[1],sColor[2],sColor[3],180));
        else 
            dxDrawRectangle(dPos[1]+100,dPos[2]+160,100,25,tocolor(red[1],red[2],red[3],180));
        end
        e:shadowedText(dStateText(trunkState),dPos[1]+100,dPos[2]+160,dPos[1]+100+100,dPos[2]+160+25,tocolor(255,255,255),1,e:getFont("rage",13),"center","center");

        local fLeftState = getVehicleDoorOpenRatio(dShow,2);
        if fLeftState == 0 then 
            dxDrawRectangle(dPos[1]+10,dPos[2]+70,85,25,tocolor(sColor[1],sColor[2],sColor[3],180));
        else 
            dxDrawRectangle(dPos[1]+10,dPos[2]+70,85,25,tocolor(red[1],red[2],red[3],180));
        end
        e:shadowedText(dStateText(fLeftState),dPos[1]+10,dPos[2]+70,dPos[1]+10+85,dPos[2]+70+25,tocolor(255,255,255),1,e:getFont("rage",13),"center","center");


        local fRightState = getVehicleDoorOpenRatio(dShow,3);
        if fRightState == 0 then 
            dxDrawRectangle(dPos[1]+205,dPos[2]+70,85,25,tocolor(sColor[1],sColor[2],sColor[3],180));
        else 
            dxDrawRectangle(dPos[1]+205,dPos[2]+70,85,25,tocolor(red[1],red[2],red[3],180));
        end
        e:shadowedText(dStateText(fRightState),dPos[1]+205,dPos[2]+70,dPos[1]+205+85,dPos[2]+70+25,tocolor(255,255,255),1,e:getFont("rage",13),"center","center");

        local rLeftState = getVehicleDoorOpenRatio(dShow,4);
        if rLeftState == 0 then 
            dxDrawRectangle(dPos[1]+10,dPos[2]+130,85,25,tocolor(sColor[1],sColor[2],sColor[3],180));
        else 
            dxDrawRectangle(dPos[1]+10,dPos[2]+130,85,25,tocolor(red[1],red[2],red[3],180));
        end
        e:shadowedText(dStateText(rLeftState),dPos[1]+10,dPos[2]+130,dPos[1]+10+85,dPos[2]+130+25,tocolor(255,255,255),1,e:getFont("rage",13),"center","center");

        local rRightState = getVehicleDoorOpenRatio(dShow,5);
        if rRightState == 0 then 
            dxDrawRectangle(dPos[1]+205,dPos[2]+130,85,25,tocolor(sColor[1],sColor[2],sColor[3],180));
        else
            dxDrawRectangle(dPos[1]+205,dPos[2]+130,85,25,tocolor(red[1],red[2],red[3],180));
        end
        e:shadowedText(dStateText(rRightState),dPos[1]+205,dPos[2]+130,dPos[1]+205+85,dPos[2]+130+25,tocolor(255,255,255),1,e:getFont("rage",13),"center","center");


        if getKeyState("mouse1") and dClick+1000 < getTickCount() then 
            if isVehicleLocked(dShow) then 
                exports.fv_infobox:addNotification("warning","Vehicle locked!");
                dClick = getTickCount();
                return;
            end
            if e:isInSlot(dPos[1]+100,dPos[2]+40,100,25) then 
                if hoodState == 0 then --Nyit 
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,0,"open");
                else --Zár
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,0,"close");
                end
                dClick = getTickCount();
            elseif e:isInSlot(dPos[1]+100,dPos[2]+160,100,25) then 
                if trunkState == 0 then --Nyit 
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,1,"open");
                else --Zár
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,1,"close");
                end
                dClick = getTickCount();
            elseif e:isInSlot(dPos[1]+10,dPos[2]+70,85,25) then 
                if fLeftState == 0 then --Nyit 
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,2,"open");
                else --Zár
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,2,"close");
                end
                dClick = getTickCount();
            elseif e:isInSlot(dPos[1]+205,dPos[2]+70,85,25) then 
                if fRightState == 0 then --Nyit 
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,3,"open");
                else --Zár
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,3,"close");
                end
                dClick = getTickCount();
            elseif e:isInSlot(dPos[1]+10,dPos[2]+130,85,25) then 
                if rLeftState == 0 then --Nyit 
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,4,"open");
                else --Zár
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,4,"close");
                end
                dClick = getTickCount();
            elseif e:isInSlot(dPos[1]+205,dPos[2]+130,85,25) then 
                if rRightState == 0 then --Nyit 
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,5,"open");
                else --Zár
                    triggerServerEvent("vehicle.doorChange",localPlayer,localPlayer,dShow,5,"close");
                end
                dClick = getTickCount();
            end
        end
    end
end

addEventHandler("onClientClick",root,function(button,state,x,y)
    if not getElementData(localPlayer,"togHUD") then return end;
    if dShow then 
        if button == "left" then 
            if state == "down" then 
                if e:isInSlot(dPos[1],dPos[2],300,20) then 
                    if not dMoving then
                        dMove = {dPos[1] - x, dPos[2] - y};
                        dMoving = true;
                    end
                end
            else 
                if dMoving then 
                    dMove = {};
                    dMoving = false;
                end
            end
        end
    end
end);

function dStateText(data)
    if data == 0 then 
        return "Opening";
    else 
        return "Closing";
    end
end

function dClosePanel()
    dShow = false;
    dMove = {};
    dMoving = false;
    removeEventHandler("onClientRender",root,dRender);
end

bindKey("F6","down",function()
    if not dShow then 
        if isPedInVehicle(localPlayer) then 
            if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
                dShow = getPedOccupiedVehicle(localPlayer);
                removeEventHandler("onClientRender",root,dRender);
                addEventHandler("onClientRender",root,dRender);
            end
        end
    else 
        dClosePanel();
    end
end);

addCommandHandler("cveh",function()
    if not dShow then 
        if isPedInVehicle(localPlayer) then 
            if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
                dShow = getPedOccupiedVehicle(localPlayer);
                removeEventHandler("onClientRender",root,dRender);
                addEventHandler("onClientRender",root,dRender);
            end
        end
    else 
        dClosePanel();
    end
end);