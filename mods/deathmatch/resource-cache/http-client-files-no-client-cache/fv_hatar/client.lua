
setElementData(localPlayer,"isBorder",false);
e = exports.fv_engine;
white = "#FFFFFF";
sColor = {e:getServerColor("servercolor",false)};
sColor2 = e:getServerColor("servercolor",true);
red = {e:getServerColor("red",false)};

local s = Vector2(guiGetScreenSize());
local show = false;


function render()
    if getElementData(show,"border.state") then 
        dxDrawRectangle(s.x/2-200,s.y/2-100,400,200,tocolor(0,0,0,180));
        dxDrawRectangle(s.x/2-203,s.y/2-100,3,200,tocolor(sColor[1],sColor[2],sColor[3],180));

        dxDrawText("TheDevils - Border",0,s.y/2-100,s.x,200,tocolor(255,255,255),1,e:getFont("rage",15),"center","top");
        dxDrawText("Border crossing fee: "..sColor2.."150"..white.."dt",0,s.y/2-50,s.x,200,tocolor(255,255,255),1,e:getFont("rage",15),"center","top",false,false,false,true);

        local acceptColor = tocolor(sColor[1],sColor[2],sColor[3],180);
        if e:isInSlot(s.x/2-200,s.y/2+10,400,40) then 
            acceptColor = tocolor(sColor[1],sColor[2],sColor[3]);
        end
        local denyColor = tocolor(red[1],red[2],red[3],180);
        if e:isInSlot(s.x/2-200,s.y/2+60,400,40) then 
            denyColor = tocolor(red[1],red[2],red[3]);
        end
        dxDrawRectangle(s.x/2-200,s.y/2+10,400,40,acceptColor);
        e:shadowedText("Crossing",s.x/2-200,s.y/2+10,s.x/2-200+400,s.y/2+10+40,tocolor(255,255,255),1,e:getFont("rage",15),"center","center");
        dxDrawRectangle(s.x/2-200,s.y/2+60,400,40,denyColor);
        e:shadowedText("Cancel",s.x/2-200,s.y/2+60,s.x/2-200+400,s.y/2+60+40,tocolor(255,255,255),1,e:getFont("rage",15),"center","center");
    end
end
--addEventHandler("onClientRender",root,render);
addEventHandler("onClientKey",root,function(button,state)
    if show and getElementData(show,"border.state") then 
        if button == "mouse1" and state then 
            if e:isInSlot(s.x/2-200,s.y/2+10,400,40) then 
                if getElementData(localPlayer,"char >> money") < 1500 then 
                    return exports.fv_infobox:addNotification("warning","You don't have enough money!");
                end
                triggerServerEvent("border.open",localPlayer,localPlayer,show);
                closePanel();
            end
            if e:isInSlot(s.x/2-200,s.y/2+60,400,40) then 
                closePanel(true);
            end
        end
        if button == "enter" and state then 
            if getElementData(localPlayer,"char >> money") < 1500 then 
                return exports.fv_infobox:addNotification("warning","You don't have enough money!");
            end
            triggerServerEvent("border.open",localPlayer,localPlayer,show);
            closePanel();
            cancelEvent();
        end
    end
end);

addEventHandler("onClientColShapeHit",root,function(hitElement,dimension)
    if (getElementData(source,"border.id") or -1) > 0 then 
        if hitElement == localPlayer then 
            if not show then 
                local veh = getPedOccupiedVehicle(localPlayer);
                if veh and getPedOccupiedVehicleSeat(localPlayer) == 0 then 
                    removeEventHandler("onClientRender",root,render);
                    addEventHandler("onClientRender",root,render);
                    show = source;
                    setElementData(localPlayer,"isBorder",true);
                end
            end
        end
    end
end);

addEventHandler("onClientColShapeLeave",root,function(hitElement,dimension)
    if hitElement == localPlayer then 
        if show then 
            closePanel(true);
        end
    end
end);

function closePanel(data)
    show = false;
    removeEventHandler("onClientRender",root,render);
    if data then 
        setElementData(localPlayer,"isBorder",false);
    end
end