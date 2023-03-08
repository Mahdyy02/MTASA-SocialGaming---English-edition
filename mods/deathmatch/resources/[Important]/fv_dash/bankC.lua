local show = 1;
local gui = false;
local guiActive = false;
local scroll = 0;
local max = 8;
local id = -1;
local temp = {};
local bankTick = 0;

--PED--
local ped = createPed(22,1472.7719726563, -996.73529052734, 26.7421875);
setElementRotation(ped,0,0,180);
setElementData(ped,"ped.noDamage",true);
setElementFrozen(ped,true);
setElementData(ped,"ped >> name","Otto Jaramillo");
setElementData(ped,"ped >> type","Faction account");
addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
    if clickedElement == ped then 
        if state == "down" then 
            local x,y,z = getElementPosition(localPlayer);
            local ox,oy,oz = getElementPosition(clickedElement);
            if getDistanceBetweenPoints3D(x,y,z,ox,oy,oz) < 4 then 
                if isPedInVehicle(localPlayer) then return outputChatBox(exports.fv_engine:getServerSyntax("Bank","red").."You cannot use it from a vehicle!",255,255,255,true) end;
                triggerServerEvent("dash > getFactions",localPlayer,localPlayer);
                show = 1;
                removeEventHandler("onClientRender",root,drawFactionBank);
                addEventHandler("onClientRender",root,drawFactionBank);
                id = -1;
                scroll = 0;
                bindKey("mouse_wheel_up","down",fscrollUP);
                bindKey("mouse_wheel_down","down",fscrollDown);
                bankTick = getTickCount()-200;
                temp = {};
                for k,v in pairs(factions) do 
                    if getElementData(localPlayer,"faction_"..v[1].."_leader") then 
                        --local data = {unpack(v)};
                        temp[#temp + 1] = v;
                    end
                end

                gui = guiCreateEdit(-1000,-1000,0,0,"",false);
                guiEditSetMaxLength(gui,8);
                addEventHandler("onClientGUIChanged",gui,function()
                    if not tonumber(guiGetText(gui)) then 
                        guiSetText(gui,"");
                    end
                end);
                guiActive = false;
            end
        end
    end
end);
-------------------

addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if tostring(getResourceName(res)) == "fv_engine" or getThisResource() == res then 
        bankfont = exports.fv_engine:getFont("rage",13);
        midFont2 = exports.fv_engine:getFont("rage",15);
    end 
end)

setTimer(function()
    if show == 2 then 
        temp = {};
        for k,v in pairs(factions) do 
            if getElementData(localPlayer,"faction_"..v[1].."_leader") then 
                temp[#temp + 1] = v;
            end
        end
    end
end,100,0);

function drawFactionBank()
    if show == 1 or show == 2 then 
    local x,y,z = getElementPosition(localPlayer);
    local px,py,pz = getElementPosition(ped);
        if getDistanceBetweenPoints3D(x,y,z,px,py,pz) > 4 then 
            closeBank();
        end
    end

    if show == 1 then 
        dxDrawRectangle(sx/2-200,sy/2-150,400,300,tocolor(0,0,0,100));
        dxDrawRectangle(sx/2-203,sy/2-150,3,300,tocolor(sColor[1],sColor[2],sColor[3],180));
        e:shadowedText("Group account management",sx/2-200,sy/2-180,sx/2-200+400,0,tocolor(255,255,255),1,font,"center","top");
        if #temp > 0 then 
            local count = 0;
            for k,v in pairs(temp) do 
                if k > scroll and count < max then 
                    count = count + 1;
                    local color = tocolor(0,0,0,100);
                    if e:isInSlot(sx/2-380/2,sy/2-170+(count*35),380,30) then 
                        color = tocolor(sColor[1],sColor[2],sColor[3]);
                        if getKeyState("mouse1") and bankTick+400 < getTickCount() then 
                            show = 2;
                            id = k;
                            bankTick = getTickCount();
                        end
                    end
                    dxDrawRectangle(sx/2-380/2,sy/2-170+(count*35),380,30,color);
                    dxDrawText(v[2],sx/2-380/2,sy/2-170+(count*35),sx/2-380/2+380,sy/2-170+(count*35)+30,tocolor(255,255,255),1,smallfont,"center","center");
                end
            end
        else 
            dxDrawText("You do not lead any faction.",sx/2-200,sy/2-150,sx/2-200+400,sy/2-150+300,tocolor(255,255,255),1,font,"center","center");
        end
    elseif show == 2 then 
        local data = temp[id];
        dxDrawRectangle(sx/2-200,sy/2-150,400,230,tocolor(0,0,0,140));
        dxDrawRectangle(sx/2-203,sy/2-150,3,230,tocolor(sColor[1],sColor[2],sColor[3],250));

        dxDrawText("Faction balance: "..sColor2..formatMoney(data[4])..white.."dt",sx/2-200,sy/2-145,sx/2-200+400,300,tocolor(255,255,255),1,bankfont,"center","top",false,false,false,true);

        dxDrawRectangle(sx/2-190,sy/2-100,380,30,tocolor(100,100,100,200));
        if getKeyState("mouse1") and bankTick+300 < getTickCount() then 
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

        local inColor = tocolor(green[1],green[2],green[3],150);
        if exports.fv_engine:isInSlot(sx/2-150,sy/2-40,300,35) then 
            inColor = tocolor(green[1],green[2],green[3],255);
        end
        dxDrawRectangle(sx/2-150,sy/2-40,300,35,inColor);
        shadowedText("deposit",sx/2-190,sy/2-40,sx/2-190+380,sy/2-40+35,tocolor(255,255,255),1,midFont2,"center","center");

        local outColor = tocolor(red[1],red[2],red[3],150);
        if exports.fv_engine:isInSlot(sx/2-150,sy/2+10,300,35) then 
            outColor = tocolor(red[1],red[2],red[3],255);
        end
        dxDrawRectangle(sx/2-150,sy/2+10,300,35,outColor);
        shadowedText("Exception",sx/2-190,sy/2+10,sx/2-190+380,sy/2+10+35,tocolor(255,255,255),1,midFont2,"center","center"); 
        shadowedText("Use to exit "..sColor2.."backspace "..white.."button.",sx/2-200,sy/2+55,sx/2-200+400,300,tocolor(255,255,255),1,bankfont,"center","top",false,false,false,true);
    end
end

addEventHandler("onClientKey",root,function(button,state)
if button == "backspace" and state then 
    if show == 1 or show == 2 then 
        if not guiGetInputEnabled() and not guiActive then 
            closeBank();
        end
    end
end
if button == "mouse1" and state and getElementData(localPlayer,"network") then
    if show == 2 then 
        if exports.fv_engine:isInSlot(sx/2-150,sy/2-40,300,35) then --Befizetés
            if bankTick+1500 > getTickCount() then 
                exports.fv_infobox:addNotification("error","Slower!");
                return;
            end
            local data = temp[id];
            local amount = guiGetText(gui);
            if amount == "" or amount == "" or not tonumber(amount) or tonumber(amount) < 0 then 
                exports.fv_infobox:addNotification("error","The amount you entered is incorrect!");
            else 
                if getElementData(localPlayer,"char >> money") >= tonumber(amount) then 
                    triggerServerEvent("factionbank.give",localPlayer,localPlayer,data[1],tonumber(amount));
                    bankTick = getTickCount();
                else 
                    exports.fv_infobox:addNotification("error","You don't have enough money!")
                end
            end
        elseif exports.fv_engine:isInSlot(sx/2-150,sy/2+10,300,35) then 
            if bankTick+1500 > getTickCount() then 
                exports.fv_infobox:addNotification("error","Slower!");
                return;
            end
            local data = temp[id];
            local amount = guiGetText(gui);
            if amount == "" or amount == "" or not tonumber(amount) or tonumber(amount) < 0 then 
                exports.fv_infobox:addNotification("error","The amount you entered is incorrect!");
            else  
                if tonumber(data[4]) < tonumber(amount) then 
                    exports.fv_infobox:addNotification("error","Not enough money in the account!");
                else 
                    triggerServerEvent("factionbank.out",localPlayer,localPlayer,data[1],tonumber(amount));
                    bankTick = getTickCount();
                end
            end
        end
    end
end
end);

function closeBank()
    show = 1;
    removeEventHandler("onClientRender",root,drawFactionBank);
    id = -1;
    scroll = 0;
    unbindKey("mouse_wheel_up","down",fscrollUP);
    unbindKey("mouse_wheel_down","down",fscrollDown);
    bankTick = 0;
    temp = {};
    guiActive = false;
    if isElement(gui) then 
        destroyElement(gui);
    end
end

function fscrollUP()
    if show == 1 then 
        if exports.fv_engine:isInSlot(sx/2-200,sy/2-150,400,300) then 
            if scroll > 0 then 
                scroll = scroll - 1;
            end
        end
    end
end
function fscrollDown()
    if show == 1 then 
        if exports.fv_engine:isInSlot(sx/2-200,sy/2-150,400,300) then 
            if scroll < #factions - max then
                scroll = scroll + 1;
			end
        end
    end
end

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY,a,b,c,d)
	if not a then a = false end;
	if not b then b = false end;
	if not c then c = false end;
	if not d then d = true end;
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, a,b,c,d)
end
