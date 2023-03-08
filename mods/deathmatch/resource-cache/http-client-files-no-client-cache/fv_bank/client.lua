e = exports.fv_engine;

local sx,sy = guiGetScreenSize();

local show = false;
local gui = false;
local guiActive = false;

local pedPos = {
    --skin,x,y,z,rot,NPC name
    {20,1462.4771728516, -997.513671875, 26.7421875,180,"James Melton"},
}
local bankPeds = {} --Cache table;

local tick = 0;
local clickTick = 0;
local pedTick = 0;

addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if tostring(getResourceName(res)) == "fv_engine" or getThisResource() == res then 
        e = exports.fv_engine;
        sColor = {exports.fv_engine:getServerColor("servercolor",false)};
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
        red = {exports.fv_engine:getServerColor("red",false)};
        orange = {exports.fv_engine:getServerColor("orange",false)};
        green = {exports.fv_engine:getServerColor("servercolor",false)};
        blue = {exports.fv_engine:getServerColor("servercolor",false)};
        white = "#FFFFFF";
        font = exports.fv_engine:getFont("rage",10);
        font2 = exports.fv_engine:getFont("rage",13);
        midFont2 = exports.fv_engine:getFont("rage",15);
    end
    if getThisResource() == res then 
        for k,v in pairs(pedPos) do 
            local skin,x,y,z,rot,name = unpack(v);
            local ped = createPed(skin,x,y,z,rot);
            setElementFrozen(ped,true);
            setElementData(ped,"ped.noDamage",true);
            setElementData(ped,"ped >> type","Bank employee");
            setElementData(ped,"ped >> name",name)
            bankPeds[ped] = true;
        end
        for k,v in pairs(getElementsByType("object")) do 
            if getElementModel(v) == 2942 then 
                setObjectBreakable(v,false);
            end
        end
    end
end);   

function render()
    if not getElementData(localPlayer,"network") then 
        if show then 
            if not guiGetInputEnabled() and not guiActive then 
                if isElement(gui) then 
                    destroyElement(gui);
                end
                show = false;
                removeEventHandler("onClientRender",root,render);
                setElementFrozen(localPlayer,false);
            end
        end
    end

    if show == "atm" then 
        dxDrawRectangle(sx/2-200,sy/2-150,400,190,tocolor(0,0,0,140));
        dxDrawRectangle(sx/2-203,sy/2-150,3,190,tocolor(sColor[1],sColor[2],sColor[3],250));
    else 
        dxDrawRectangle(sx/2-200,sy/2-150,400,230,tocolor(0,0,0,140));
        dxDrawRectangle(sx/2-203,sy/2-150,3,230,tocolor(sColor[1],sColor[2],sColor[3],250));
    end
    dxDrawText("Bank balance: "..sColor2..formatMoney(getElementData(localPlayer,"char >> bankmoney"))..white.."dt",sx/2-200,sy/2-145,sx/2-200+400,300,tocolor(255,255,255),1,font2,"center","top",false,false,false,true);

    dxDrawRectangle(sx/2-190,sy/2-100,380,30,tocolor(100,100,100,200));
    if getKeyState("mouse1") and tick+300 < getTickCount() then 
        if exports.fv_engine:isInSlot(sx/2-190,sy/2-100,380,30) then 
            guiBringToFront(gui);
            guiActive = true;
        else 
            guiActive = false;
        end
    end
    dxDrawText(formatMoney(tonumber(guiGetText(gui) or 0)),sx/2-185,sy/2-100,sx/2-190+380,sy/2-100+30,tocolor(255,255,255),1,font2,"left","center");
    if guiActive then
        dxDrawText("|",sx/2-185+dxGetTextWidth(formatMoney(tonumber(guiGetText(gui) or 0)),1,font2),sy/2-100,sx/2-190+380,sy/2-100+30,tocolor(0,0,0,220 * math.abs(getTickCount() % 1000 - 500) / 500),1,font2,"left","center");
    end
    dxDrawText("dt",sx/2-185,sy/2-100,sx/2-190+380-10,sy/2-100+30,tocolor(255,255,255),1,font2,"right","center");


    if (show == "bank") then 
        local inColor = tocolor(green[1],green[2],green[3],150);
        if exports.fv_engine:isInSlot(sx/2-150,sy/2-40,300,35) then 
            inColor = tocolor(green[1],green[2],green[3],255);
        end
        dxDrawRectangle(sx/2-150,sy/2-40,300,35,inColor);
        shadowedText("Deposit",sx/2-190,sy/2-40,sx/2-190+380,sy/2-40+35,tocolor(255,255,255),1,midFont2,"center","center");
    end

    if show == "atm" then 
        local outColor = tocolor(red[1],red[2],red[3],150);
        if exports.fv_engine:isInSlot(sx/2-150,sy/2-40,300,35) then 
            outColor = tocolor(red[1],red[2],red[3],255);
        end
        dxDrawRectangle(sx/2-150,sy/2-40,300,35,outColor);
        shadowedText("Exception",sx/2-190,sy/2-40,sx/2-190+380,sy/2-40+35,tocolor(255,255,255),1,midFont2,"center","center");  
        shadowedText("Press "..sColor2.."backspace "..white.."button to leave.",sx/2-200,sy/2+10,sx/2-200+400,300,tocolor(255,255,255),1,font2,"center","top",false,false,false,true);
    else
        local outColor = tocolor(red[1],red[2],red[3],150);
        if exports.fv_engine:isInSlot(sx/2-150,sy/2+10,300,35) then 
            outColor = tocolor(red[1],red[2],red[3],255);
        end
        dxDrawRectangle(sx/2-150,sy/2+10,300,35,outColor);
        shadowedText("Exception",sx/2-190,sy/2+10,sx/2-190+380,sy/2+10+35,tocolor(255,255,255),1,midFont2,"center","center"); 
        shadowedText("Press "..sColor2.."backspace "..white.."button to leave.",sx/2-200,sy/2+55,sx/2-200+400,300,tocolor(255,255,255),1,font2,"center","top",false,false,false,true);
    end
end


addEventHandler("onClientClick",root,function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
if not getNetworkState() then return end; --Net Check pénzbug kíszűrése.
if state == "down" then 
    if not show then 
        local px,py,pz = getElementPosition(localPlayer);
        if (clickedElement and bankPeds[clickedElement]) then
            if getDistanceBetweenPoints3D(px,py,pz,worldX,worldY,worldZ) < 4 then 
                if pedTick+300 > getTickCount() then return end;
                if isPedInVehicle(localPlayer) then return outputChatBox(exports.fv_engine:getServerSyntax("Bank","red").."You cannot use it from a vehicle!",255,255,255,true) end;
                gui = guiCreateEdit(-1000,-1000,0,0,0,false);
                guiEditSetMaxLength(gui,8);
                addEventHandler("onClientGUIChanged",gui,function()
                    if not tonumber(guiGetText(gui)) then 
                        guiSetText(gui,"");
                    end
                end);
                guiActive = false;
                removeEventHandler("onClientRender",root,render);
                addEventHandler("onClientRender",root,render);
                setElementFrozen(localPlayer,true);
                pedTick = getTickCount();
                show = "bank";
            else 
                outputChatBox(exports.fv_engine:getServerSyntax("Fault","red").."You are too far away!",255,255,255,true);
            end
        end
        if (clickedElement and getElementData(clickedElement,"atm.id")) then 
            if getDistanceBetweenPoints3D(px,py,pz,worldX,worldY,worldZ) < 4 then 
                if pedTick+300 > getTickCount() then return end;
                if isPedInVehicle(localPlayer) then return outputChatBox(exports.fv_engine:getServerSyntax("Bank","red").."You cannot use it from a vehicle!",255,255,255,true) end;
                gui = guiCreateEdit(-1000,-1000,0,0,"",false);
                guiEditSetMaxLength(gui,8);
                addEventHandler("onClientGUIChanged",gui,function()
                    if not tonumber(guiGetText(gui)) then 
                        guiSetText(gui,"");
                    end
                end);
                guiActive = false;
                removeEventHandler("onClientRender",root,render);
                addEventHandler("onClientRender",root,render);
                setElementFrozen(localPlayer,true);
                pedTick = getTickCount();
                show = "atm";
            else 
                outputChatBox(exports.fv_engine:getServerSyntax("Fault","red").."You are too far away!",255,255,255,true);
            end
        end
    end
    if show and button == "left" and pedTick < getTickCount() then 
        if exports.fv_engine:isInSlot(sx/2-150,sy/2-40,300,35) and show == "bank" then  --Befizetés
            if clickTick+4000 > getTickCount() then exports.fv_infobox:addNotification("error","You can't use the pot so fast!") return end;
            if guiGetText(gui) == "" or guiGetText(gui) == " " or (tonumber(guiGetText(gui)) <= 0) and not math.floor(tonumber(gui)) then  
                exports.fv_infobox:addNotification("error","The amount you entered is incorrect.")
                clickTick = getTickCount();
                return;
            end
            local amount = math.floor(tonumber(guiGetText(gui)));
            if getElementData(localPlayer,"char >> money") < amount then 
                exports.fv_infobox:addNotification("error","You don't have enough money.")
                clickTick = getTickCount();
                return;
            end
            if getElementData(localPlayer,"network") then 
                triggerServerEvent("bank > changeMoney",localPlayer,localPlayer,"in",amount);
            end
            guiSetText(gui,0);
            clickTick = getTickCount();
        end
        if (exports.fv_engine:isInSlot(sx/2-150,sy/2+10,300,35) and show == "bank") or (exports.fv_engine:isInSlot(sx/2-150,sy/2-40,300,35) and show == "atm") then  --Kifizetés
            if clickTick+4000 > getTickCount() then exports.fv_infobox:addNotification("error","You can't use the pot so fast!") return end;
            if guiGetText(gui) == "" or guiGetText(gui) == " " or (tonumber(guiGetText(gui)) <= 0) then  
                exports.fv_infobox:addNotification("error","The amount you entered is incorrect.")
                clickTick = getTickCount();
                return;
            end
            local amount = math.floor(tonumber(guiGetText(gui)));
            if getElementData(localPlayer,"char >> bankmoney") < amount then 
                exports.fv_infobox:addNotification("error","There is not enough money in your account.")
                clickTick = getTickCount();
                return;
            end
            if getElementData(localPlayer,"network") then 
                triggerServerEvent("bank > changeMoney",localPlayer,localPlayer,"out",amount);
            end
            guiSetText(gui,0);
            clickTick = getTickCount();
        end
    end
end
end);
addEventHandler("onClientKey",root,function(button,state)
    if button == "backspace" and state then 
        if show then 
            if not guiGetInputEnabled() and not guiActive then 
                if isElement(gui) then 
                    destroyElement(gui);
                end
                show = false;
                removeEventHandler("onClientRender",root,render);
                setElementFrozen(localPlayer,false);
            end
        end
    end
end);

addEventHandler("onClientObjectDamage", root, function()
    if getElementModel(source) == 2942 then 
        setObjectBreakable(source,false);
        cancelEvent();
    end
end)

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY,a,b,c,d,rot)
	if not a then a = false end;
	if not b then b = false end;
	if not c then c = false end;
    if not d then d = true end;
    if not rot then rot = 0 end;
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, a,b,c,d,false,rot)
end


function getNetworkState()
    return getElementData(localPlayer,"network");
end