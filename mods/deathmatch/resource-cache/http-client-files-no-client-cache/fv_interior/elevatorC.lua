e = exports.fv_engine;
local sx,sy = guiGetScreenSize();
local show = false;
local tick = getTickCount();
local state = "up";

addEventHandler("onClientResourceStart",root,function(res)
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
    end
end);

addEventHandler("onClientMarkerHit",getRootElement(),function(hitElement,dim)
    if hitElement == localPlayer and dim then 
        if not isPedInVehicle(localPlayer) then 
            if getElementData(source,"elevator.id") then
                local mx,my,mz = getElementPosition(source);
                local px,py,pz = getElementPosition(localPlayer);
                if getDistanceBetweenPoints3D(mx,my,mz,px,py,pz) < 2 then 
                    removeEventHandler("onClientRender",root,drawElevator);
                    addEventHandler("onClientRender",root,drawElevator);
                    show = source;
                    tick = getTickCount();
                    state = "up";
                end
            end
        end
    end
end);

addEventHandler("onClientMarkerLeave",getRootElement(),function(hitElement,dim)
    if hitElement == localPlayer and dim then 
        if not isPedInVehicle(localPlayer) then 
            if getElementData(source,"elevator.id") then
                tick = getTickCount();
                state = "down";
            end
        end
    end
end);

function drawElevator()
    local font = e:getFont("rage",15);
    if state == "up" then 
        local x,y = interpolateBetween(sx/2-50,sy+100,0,sx/2-50,sy-150,0,(getTickCount()-tick)/1000,"OutBack");
        dxDrawRectangle(x,y,100,100,tocolor(0,0,0,180)); 
        dxDrawText("Press\n"..e:getServerColor("servercolor",true).."E"..white.."\nto interact",x,y,x+100,y+100,tocolor(255,255,255),1,font,"center","center",false,false,false,true); 
    elseif state == "down" then 
        local x,y = interpolateBetween(sx/2-50,sy-150,0,sx/2-50,sy+100,0,(getTickCount()-tick)/1000,"OutBack");
        if y == (sy+100) then 
            show = false;
            removeEventHandler("onClientRender",root,drawElevator);
        end
        dxDrawRectangle(x,y,100,100,tocolor(0,0,0,180)); 
        dxDrawText("press\n"..e:getServerColor("servercolor",true).."E"..white.."\nto interact",x,y,x+100,y+100,tocolor(255,255,255),1,font,"center","center",false,false,false,true); 
    end
end

local lastUse = getTickCount()

addEventHandler("onClientKey",root,function(button,state)
if show then 
    if button == "e" and state and not isPedInVehicle(localPlayer) then 
        if lastUse + 5000 < getTickCount() then
            triggerServerEvent("elevator.use",localPlayer,localPlayer,show);
            state = "down";
            lastUse = getTickCount();
            show = false;
        else
            outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Wait a while before using it again!",255,255,255,true);
        end
    end
end
end);