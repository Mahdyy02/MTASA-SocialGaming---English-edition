local e = exports.fv_engine;
local sx,sy = guiGetScreenSize();
local show = true;
local x,y = sx-155,sy/2-150/2;
local move = {};
local lastTick = 0;
local buttons = { 
    {"Launch", "servercolor","start"},
    {"Shutdown", "red","stop"},
    {"Reset", "orange","reset"},
};
local clickTick = getTickCount();

addEventHandler("onClientResourceStart",root,function(res)
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        font = e:getFont("rage",15);
        font2 = e:getFont("rage",13);
    end
end);

function drawTaxiClock()
    local veh = getPedOccupiedVehicle(localPlayer);
    if veh and models[getElementModel(veh)] then 
        if isCursorShowing() then 
            local cursorX, cursorY = getCursorPosition();
            local cursorX, cursorY = cursorX * sx, cursorY * sy;
            if move[1] then 
                x = cursorX + move[2];
                y = cursorY + move[3];
            end
        else 
            if move[1] then 
                move = {};
            end
        end
        local state = (getElementData(veh,"taxiclock.state") or false);
        local taxiCost = (math.ceil(getElementData(veh,"taxiclock.travelled") or 0) * 15);
        local driver = getVehicleController(veh);

        dxDrawRectangle(x-150,y,300,150,tocolor(0,0,0,150));
        dxDrawRectangle(x-150,y,300,30,tocolor(0,0,0,150));
        dxDrawText("taximeter",x-150,y,x-150+300,y+30,tocolor(255,255,255),1,font2,"center","center");
        dxDrawText(string.format("%0.2f", tostring(getElementData(veh,"taxiclock.travelled") or 0)/2),x-150,y,x-150+300,y+100,tocolor(255,255,255),1,font,"center","center");
        dxDrawText("KM: ",x-145,y,x-150+300,y+100,tocolor(255,255,255),1,font,"left","center");

        dxDrawText(e:getServerColor("servercolor",true)..tostring(formatMoney(taxiCost)),x-150,y,x-150+300,y+170,tocolor(255,255,255),1,font,"center","center",false,false,false,true);
        dxDrawText("$: ",x-145,y,x-150+300,y+170,tocolor(255,255,255),1,font,"left","center");

        if driver == localPlayer then 
            for k,v in pairs(buttons) do 
                local name,get,func = unpack(v);
                local color = {e:getServerColor(get,false)};
                color[4] = 150;
                if e:isInSlot(x-235+(k*95),y+110,90,25) then 
                    color[4] = 250;
                    if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                        if func == "start" then 
                            if not getElementData(veh,"taxiclock.state") then 
                                triggerServerEvent("taxiclock.start",localPlayer,localPlayer,veh);
                            else 
                                outputChatBox(e:getServerSyntax("taximeter","red").."Taxi clock is already started!",255,255,255,true);
                            end
                        elseif func == "stop" then 
                            if not getElementData(veh,"taxiclock.state") then 
                                outputChatBox(e:getServerSyntax("taximeter","red").."Taxi clock is not started!",255,255,255,true);
                            else 
                                triggerServerEvent("taxiclock.stop",localPlayer,localPlayer,veh);
                            end
                        elseif func == "reset" then 
                            triggerServerEvent("taxiclock.reset",localPlayer,localPlayer,veh);
                        end
                        clickTick = getTickCount();
                    end
                end
                dxDrawRectangle(x-235+(k*95),y+110,90,25,tocolor(color[1],color[2],color[3],color[4]));
                e:shadowedText(name,x-235+(k*95),y+110,x-235+(k*95)+90,y+110+25,tocolor(255,255,255),1,font2,"center","center");
            end
        else 
            local check = "red";
            if not state then 
                check = "servercolor";
            end
            local color = {e:getServerColor(check,false)};
            color[4] = 150;
            if e:isInSlot(x-142.5,y+110,285,25) then 
                color[4] = 250;
                if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                    if not getElementData(veh,"taxiclock.state") then 
                        if taxiCost == 0 then 
                            outputChatBox(e:getServerSyntax("taximeter","red").."You have nothing to pay!",255,255,255,true);
                            clickTick = getTickCount(); 
                            return;
                        end
                        if getElementData(localPlayer,"char >> money") >= taxiCost then 
                            if isElement(driver) then 
                                triggerServerEvent("taxiclock.paytaxi",localPlayer,localPlayer,veh,driver,taxiCost);
                            else 
                                outputChatBox(e:getServerSyntax("taximeter","red").."There is no driver in the car!",255,255,255,true);
                            end
                        else 
                            outputChatBox(e:getServerSyntax("taximeter","red").."You don't have enough money to pay!",255,255,255,true);
                        end
                    else
                        outputChatBox(e:getServerSyntax("taximeter","red").."Taxi clock is not stopped!",255,255,255,true);
                    end
                   clickTick = getTickCount(); 
                end
            end
            dxDrawRectangle(x-142.5,y+110,285,25,tocolor(color[1],color[2],color[3],color[4]));
            e:shadowedText("Payment",x-142.5,y+110,x-142.5+285,y+110+25,tocolor(255,255,255),1,font2,"center","center");
        end

        dxDrawText(getState(veh),x-150,y,x-150+295,y+30,tocolor(255,255,255),1,font2,"right","center",false,false,false,true);
    end
end
addEventHandler("onClientRender",root,drawTaxiClock);

addEventHandler("onClientClick",root,function(button,state,cx,cy)
if show then 
    if button == "left" then 
        if state == "down" then 
            if e:isInSlot(x-150,y,300,30) then   
                move = {};
                move[1] = true;
                move[2] = x-cx;
                move[3] = y-cy;
            end
        elseif state == "up" then 
            move = {};
        end
    end
end
end);


function getState(veh)
    local state = (getElementData(veh,"taxiclock.state") or false);
    if state then 
        return e:getServerColor("servercolor",true).."Launched.";
    else 
        return e:getServerColor("red",true).."Stopped.";
    end
end