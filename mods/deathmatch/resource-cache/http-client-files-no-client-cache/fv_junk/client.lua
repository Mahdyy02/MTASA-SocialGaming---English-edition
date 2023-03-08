e = exports.fv_engine;
local white = "#FFFFFF";
local sx,sy = guiGetScreenSize();

local panelState = false;
local currentVeh = false;
local Marker = false;

addEventHandler("onClientResourceStart",root,function(res)
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        sColor = {e:getServerColor("servercolor",false)};
        red = {e:getServerColor("red",false)};
        sColor2 = e:getServerColor("servercolor",true);

        font = e:getFont("rage",13);
        font2 = e:getFont("rage",11);
    end
    if res == getThisResource() then 
        Marker = createMarker(2182.7888183594, -1986.1300048828, 11.550520896912, "cylinder", 2, red[1],red[2],red[3],120);
        addEventHandler("onClientMarkerHit",Marker,function(hitPlayer,dim)
            if hitPlayer == localPlayer and isPedInVehicle(localPlayer) then 
                if not panelState then 
                    local veh = getPedOccupiedVehicle(localPlayer);
                    if veh and getElementData(veh,"veh:id") > 0 and getElementData(veh,"veh:tulajdonos") == getElementData(localPlayer,"acc >> id") then 
                        removeEventHandler("onClientRender",root,render);
                        addEventHandler("onClientRender",root,render);
                        panelState = true;
                        currentVeh = veh;
                    else 
                        outputChatBox(e:getServerSyntax("Destroy","red").."This vehicle is not yours!",255,255,255,true);
                        return;
                    end
                end
            end
        end);
        addEventHandler("onClientMarkerLeave",Marker,function(hitElement)
            if panelState then 
                closePanel();
            end
        end);
    end
end);

function closePanel()
    removeEventHandler("onClientRender",root,render);
    panelState = false;
    currentVeh = false;
end

function render()
    if not isElement(currentVeh) then 
        closePanel();
    end

    if not getElementData(localPlayer,"network") then 
        closePanel();
    end

    dxDrawRectangle(sx/2-150,sy/2-150,300,150,tocolor(0,0,0,180));
    dxDrawRectangle(sx/2-153,sy/2-150,3,150,tocolor(sColor[1],sColor[2],sColor[3],180));

    local money = exports.fv_carshop:getCost(getElementModel(currentVeh))/4;

    dxDrawText("You can smash your vehicle for: \n"..sColor2..formatMoney(money)..white.." dt",0,sy/2-130,sx,0,tocolor(255,255,255,255),1,font,"center","top",false,false,false,true);

    local buttonColor = tocolor(red[1],red[2],red[3],180);
    if e:isInSlot(sx/2-50, sy/2-75, 100, 30) then 
        buttonColor = tocolor(red[1],red[2],red[3]);
    end
    dxDrawRectangle(sx/2-50, sy/2-75, 100, 30, buttonColor);
    dxDrawText("Dismantling and Shredding",0,sy/2-75,sx,sy/2-75+30, tocolor(0,0,0,255),1,font,"center","center");
    dxDrawText("To close the panel, exit the marker.",0,sy/2-30,sx,0, tocolor(200,200,200,200),1,font2,"center");
end

addEventHandler("onClientClick",root,function(button,state)
if not getElementData(localPlayer,"network") then return end;
    if panelState then 
        if (button=="left" and state=="down") then 
            if (exports.fv_engine:isInSlot(sx/2-50, sy/2-75, 100, 30)) then
                local money = exports.fv_carshop:getCost(getElementModel(currentVeh))/4;
                triggerServerEvent("junk.destroy",localPlayer,localPlayer,currentVeh,money);
                closePanel();
            end
        end
    end
end);

--UTILS--
function formatMoney(amount)
    amount = tonumber(amount);
    if not amount then 
        return "";
    end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end