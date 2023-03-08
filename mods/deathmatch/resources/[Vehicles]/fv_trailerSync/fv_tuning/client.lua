e = exports.fv_engine;
sx,sy = guiGetScreenSize();
local rel = 1280/sx;
local showTuning = false;
local hitVeh = false;
local sMenu = 1;
local sSubmenu = 1;
local sType = 1;
local menuType = "main";
local changeTick = 0;
local cache = {};

addEventHandler("onClientResourceStart",root,function(res) --Load Core Datas
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        sColor = {e:getServerColor("servercolor",false)};
        red = {e:getServerColor("red",false)};
        orange = {e:getServerColor("orange",false)};
        red2 = e:getServerColor("red",true);
        sColor2 = e:getServerColor("servercolor",true);
        font = e:getFont("rage",13);
        icons = e:getFont("AwesomeFont",10);
    end
end); 

addEventHandler("onClientResourceStart",resourceRoot,function()
    if getResourceState(getResourceFromName("fv_dx")) == "running" then
        if exports.fv_dx:dxGetEdit("tuning.plate") then 
            exports.fv_dx:dxDestroyEdit("tuning.plate");
        end
    end

    for k,v in pairs(markerPos) do 
        local sColor = {e:getServerColor("servercolor",false)};
        local mark = createMarker(v[1],v[2],v[3]-1.8,"cylinder",2,sColor[1],sColor[2],sColor[3],170);
        setElementDimension(mark,0);
        setElementInterior(mark,0);
        addEventHandler("onClientMarkerHit",mark,function(hitElement,dim)
            if hitElement == localPlayer and dim then 
                local veh = getPedOccupiedVehicle(localPlayer);
                if veh and getPedOccupiedVehicleSeat(localPlayer) == 0 then 
                    local pX,pY,pZ = getElementPosition(localPlayer);
                    local mX,mY,mZ = getElementPosition(source);
                    if getDistanceBetweenPoints3D(pX,pY,pZ,mX,mY,mZ) < 3 then 
                        if exports.fv_vehicle:isBike(veh) then outputChatBox(e:getServerSyntax("Tuning","red").."Bicycles cannot be tuned!",255,255,255,true) return end;
                        if getElementData(veh,"veh:id") > 0 then 
                            showTuning = source;
                            sMenu = 1;
                            sSubmenu = 1;
                            sType = 1;
                            menuType = "main";
                            changeTick = getTickCount();
                            removeEventHandler("onClientRender",root,render);
                            addEventHandler("onClientRender",root,render);
                            setElementAlpha(source,0);
                            setElementFrozen(veh,true);
                            hitVeh = veh;
                            setElementData(localPlayer,"tuning.use",true);
                            setElementData(localPlayer,"togHUD",false);
                            showChat(false);
                            setCamera(0);
                            local rx,ry,rz = getElementRotation(veh);
                            setElementRotation(veh,rx,ry,180);
                            local x,y,z = getElementPosition(source)
                            setElementPosition(veh,x,y,z+1.5);
                            cache = {};
                        else 
                            outputChatBox(e:getServerSyntax("Tuning","red").."This vehicle cannot be tuned!",255,255,255,true);
                        end
                    end
                end
            end
        end);
    end
end);

function render()
    if not getElementData(localPlayer,"network") then return end; --Network Protect

    if isElement(hitVeh) then
        setElementFrozen(hitVeh,true);
    end

    if not isElement(hitVeh) or getPedOccupiedVehicle(localPlayer) ~= hitVeh then 
        closeTuning();
    end

    dxDrawRectangle(0,sy-192*rel,sx,192*rel,tocolor(0,0,0,180));
    dxDrawImage(sx/2-(384*rel)/2,sy-192*rel,384*rel,192*rel,"files/lscustoms.png");

    dxDrawText("Cash: "..e:getServerColor("servercolor",true)..formatMoney(getElementData(localPlayer,"char >> money"))..white.." $\nPrémium Pont: "..e:getServerColor("blue",true)..formatMoney(getElementData(localPlayer,"char >> premiumPoints"))..white.." PP",20*rel,sy-192*rel,sx,sy-192*rel+192*rel,tocolor(255,255,255),1,e:getFont("rage",15*rel),"left","center",false,false,false,true);

    if menuType == "main" then 
        local h = #menu*42
        dxDrawRectangle(0,sy/2-h/2,310,h,tocolor(0,0,0,180));
        for k,v in pairs(menu) do 
            dxDrawRectangle(20,sy/2-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
            if sMenu == k then 
                local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                if v.exit then 
                    dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(red[1],red[2],red[3],180));
                else
                    dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                end
            end
            shadowedText(v.name,20,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"center","center");
        end
    elseif menuType == "submenu" then 
        local h = #menu[sMenu]["submenu"]*42
        dxDrawRectangle(0,sy/2-h/2,310,h,tocolor(0,0,0,180));
        for k,v in pairs(menu[sMenu]["submenu"]) do 
            dxDrawRectangle(20,sy/2-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
            if sSubmenu == k then 
                local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
            end
            shadowedText(v[1],20,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"center","center");
        end
        shadowedText("To go:"..red2.."BACKSPACE"..white..".",10,sy/2+h/2+5,310,h,tocolor(255,255,255),1,font,"center","top",false,false,false,true);
    elseif menuType == "type" then 
        if sMenu == 1 then --Teljesítmény
            local currentTuning = getElementData(hitVeh,"tuning.performance");
            local h = #menu[sMenu]["submenu"][sSubmenu][2]*42
            dxDrawRectangle(0,sy/2-h/2,310,h,tocolor(0,0,0,180));
            shadowedText(menu[sMenu]["submenu"][sSubmenu][1],10,sy/2-h/2-20,310,h,tocolor(255,255,255),1,font,"center");
            for k,v in pairs(menu[sMenu]["submenu"][sSubmenu][2]) do 
                dxDrawRectangle(20,sy/2-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
                if sType == k then 
                    local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                    dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                end
                shadowedText(v[1],25,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                if currentTuning and currentTuning[sSubmenu] and currentTuning[sSubmenu] == k then 
                    shadowedText("",20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,icons,"right","center",false,false,false,true);
                    shadowedText("installed",20,sy/2-h/2-30+(k*40),275,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,font,"right","center",false,false,false,true);
                else 
                    local cost = v[2];
                    if v[3] then 
                        cost = colorMoney(cost,true)..white.."PP";
                    else
                        if cost == 0 then 
                            cost = e:getServerColor("blue",true).."Ingyenes"
                        else 
                            cost = colorMoney(cost,false)..white.."$";
                        end
                    end
                    shadowedText(cost,20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
                end
            end
            shadowedText("Buying: "..sColor2.."ENTER"..white.."\nto go: "..red2.."BACKSPACE"..white..".",10,sy/2+h/2+5,310,h,tocolor(255,255,255),1,font,"center","top",false,false,false,true);
        end
        if sMenu == 2 then --Optika
            local h = #cache[1]*41
            dxDrawRectangle(0,sy/2-70-h/2,310,h,tocolor(0,0,0,180));
            shadowedText(menu[sMenu]["submenu"][sSubmenu][1],10,sy/2-70-h/2-20,310,h,tocolor(255,255,255),1,font,"center");
            for k,v in pairs(cache[1]) do 
                dxDrawRectangle(20,sy/2-70-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
                if sType == k then 
                    local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                    dxDrawRectangle(20,sy/2-70-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                end
                if k == 1 then 
                    shadowedText("no",25,sy/2-70-h/2-30+(k*40),310,sy/2-70-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                else 
                    shadowedText(menu[sMenu]["submenu"][sSubmenu][1].." "..k-1,25,sy/2-70-h/2-30+(k*40),310,sy/2-70-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                end
                if (getElementData(hitVeh,"tuning.optical") or {0,0,0,0,0,0,0})[sSubmenu] == v then 
                    shadowedText("",20,sy/2-70-h/2-30+(k*40),295,sy/2-70-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,icons,"right","center",false,false,false,true);
                    shadowedText("Current",20,sy/2-70-h/2-30+(k*40),275,sy/2-70-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,font,"right","center",false,false,false,true);
                else 
                    local cost = menu[sMenu].cost;
                    cost = colorMoney(cost,false)..white.."$";
                    shadowedText(cost,20,sy/2-70-h/2-30+(k*40),295,sy/2-70-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
                end
            end
            -- shadowedText("Vásárlás: "..sColor2.."ENTER"..white.."\nVisszalépéshez: "..red2.."BACKSPACE"..white..".",10,sy/2+h/2+5,310,h,tocolor(255,255,255),1,font,"center","top",false,false,false,true);
        end
        if sMenu == 3 then --Szinezés 
            if sSubmenu < 4 then --Szinezések 
                dxDrawRectangle(0,sy/2-42/2,310,42,tocolor(0,0,0,180));
                shadowedText(menu[sMenu]["submenu"][sSubmenu][1],10,sy/2-42/2-20,310,0,tocolor(255,255,255),1,font,"center");
                local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                dxDrawRectangle(20,sy/2-42/2+6,w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                shadowedText(menu[sMenu]["submenu"][sSubmenu][2][1],25,sy/2-42/2+6,w,sy/2-42/2+6+30,tocolor(255,255,255),1,font,"left","center");
                local cost = colorMoney(menu[sMenu]["submenu"][sSubmenu][2][2],false)..white.."$";
                shadowedText(cost,25,sy/2-42/2+6,295,sy/2-42/2+6+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);

                shadowedText("Buying: "..sColor2.."ENTER"..white.."\nto go: "..red2.."BACKSPACE"..white..".",10,sy/2+42/2+5,310,42,tocolor(255,255,255),1,font,"center","top",false,false,false,true);
            end
            if menu[sMenu]["submenu"][sSubmenu][2] == 4 then --PaintJob 
                local h = #cache*42
                dxDrawRectangle(0,sy/2-h/2,310,h,tocolor(0,0,0,180));
                shadowedText(menu[sMenu]["submenu"][sSubmenu][1],10,sy/2-h/2-20,310,h,tocolor(255,255,255),1,font,"center");
                for k,v in pairs(cache) do 
                    dxDrawRectangle(20,sy/2-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
                    if sType == k then 
                        local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                        dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                    end
                    if v[1] == "none" then 
                        shadowedText("no",25,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                    else 
                        shadowedText("PaintJob "..k-1,25,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                    end
                    if tostring(getElementData(hitVeh,"tuning.paintJob") or "none") == tostring(v[1]) then 
                        shadowedText("",20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,icons,"right","center",false,false,false,true);
                        shadowedText("Current",20,sy/2-h/2-30+(k*40),275,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,font,"right","center",false,false,false,true);
                    else 
                        local cost = menu[sMenu]["submenu"][sSubmenu][3];
                        if v[1] == "none" then 
                            cost = e:getServerColor("blue",true).."Ingyenes"
                        else 
                            cost = colorMoney(cost,true)..white.."PP";
                        end
                        shadowedText(cost,20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
                    end
                end
                shadowedText("Buying: "..sColor2.."ENTER"..white.."\nto go: "..red2.."BACKSPACE"..white..".",10,sy/2+h/2+5,310,h,tocolor(255,255,255),1,font,"center","top",false,false,false,true);
            end
        end
        if sMenu == 4 then --Extrák
            local h = 0
            if sSubmenu ~= 4 then 
                h = #menu[sMenu]["submenu"][sSubmenu][2]*42
                dxDrawRectangle(0,sy/2-h/2,310,h,tocolor(0,0,0,180));
                shadowedText(menu[sMenu]["submenu"][sSubmenu][1],10,sy/2-h/2-20,310,h,tocolor(255,255,255),1,font,"center");
                shadowedText("Buying: "..sColor2.."ENTER"..white.."\nto go: "..red2.."BACKSPACE"..white..".",10,sy/2+h/2+5,310,h,tocolor(255,255,255),1,font,"center","top",false,false,false,true);
            end
            if sSubmenu < 3 then --Kerék szélesség
                for k,v in pairs(menu[sMenu]["submenu"][sSubmenu][2]) do 
                    dxDrawRectangle(20,sy/2-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
                    if sType == k then 
                        local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                        dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                    end
                    shadowedText(v[1],25,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                    if getElementData(hitVeh,"tuning."..(menu[sMenu]["submenu"][sSubmenu].side).."Wheel") == v[4] then 
                        shadowedText("",20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,icons,"right","center",false,false,false,true);
                        shadowedText("installed",20,sy/2-h/2-30+(k*40),275,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,font,"right","center",false,false,false,true);
                    else 
                        local cost = v[2];
                        if v[3] then 
                            cost = colorMoney(cost,true)..white.."PP";
                        else
                            if cost == 0 then 
                                cost = e:getServerColor("blue",true).."Ingyenes"
                            else 
                                cost = colorMoney(cost,false)..white.."$";
                            end
                        end
                        shadowedText(cost,20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
                    end
                end
            end
            if sSubmenu == 3 then --Neon
                for k,v in pairs(menu[sMenu]["submenu"][sSubmenu][2]) do 
                    dxDrawRectangle(20,sy/2-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
                    if sType == k then 
                        local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                        dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                    end
                    shadowedText(v[1],25,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                    if tostring(getElementData(hitVeh,"tuning.neon") or false) == v[4] then 
                        shadowedText("",20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,icons,"right","center",false,false,false,true);
                        shadowedText("installed",20,sy/2-h/2-30+(k*40),275,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,font,"right","center",false,false,false,true);
                    else 
                        local cost = v[2];
                        if v[3] then 
                            cost = colorMoney(cost,true)..white.."PP";
                        else
                            if cost == 0 then 
                                cost = e:getServerColor("blue",true).."Ingyenes"
                            else 
                                cost = colorMoney(cost,false)..white.."$";
                            end
                        end
                        shadowedText(cost,20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
                    end
                end
            end
            if sSubmenu == 4 then --Rendszám

                --Right Side--
                dxDrawRectangle(sx-200,sy/2-50,200,100,tocolor(0,0,0,100));
                dxDrawRectangle(sx-203,sy/2-50,3,100,tocolor(sColor[1],sColor[2],sColor[3],180));
                dxDrawText("Enter license plate number",sx-200,sy/2-45,sx-200+200,0,tocolor(255,255,255),1,e:getFont("rage",13),"center","top");
                dxDrawText("Max 8 characters!",sx-200,sy/2+20,sx-200+200,0,tocolor(255,255,255),1,e:getFont("rage",12),"center","top");
                --------------

                dxDrawRectangle(0,sy/2-42/2,310,42,tocolor(0,0,0,180));
                shadowedText(menu[sMenu]["submenu"][sSubmenu][1],10,sy/2-42/2-20,310,0,tocolor(255,255,255),1,font,"center");
                local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                dxDrawRectangle(20,sy/2-42/2+6,w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                shadowedText(menu[sMenu]["submenu"][sSubmenu][2][1],25,sy/2-42/2+6,w,sy/2-42/2+6+30,tocolor(255,255,255),1,font,"left","center");
                local cost = colorMoney(menu[sMenu]["submenu"][sSubmenu][2][2],true)..white.."PP";
                shadowedText(cost,25,sy/2-42/2+6,295,sy/2-42/2+6+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);

                shadowedText("Buying: "..sColor2.."ENTER"..white.."\nto go: "..red2.."BACKSPACE"..white..".",10,sy/2+42/2+5,310,42,tocolor(255,255,255),1,font,"center","top",false,false,false,true);
            end
            if sSubmenu == 5 then --Meghajtás
                for k,v in pairs(menu[sMenu]["submenu"][sSubmenu][2]) do 
                    dxDrawRectangle(20,sy/2-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
                    if sType == k then 
                        local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                        dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                    end
                    shadowedText(v[1],25,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                    if getVehicleHandling(hitVeh)["driveType"] == v[4] then 
                        shadowedText("",20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,icons,"right","center",false,false,false,true);
                        shadowedText("installed",20,sy/2-h/2-30+(k*40),275,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,font,"right","center",false,false,false,true);
                    else 
                        local cost = v[2];
                        if v[3] then 
                            cost = colorMoney(cost,true)..white.."PP";
                        else
                            if cost == 0 then 
                                cost = e:getServerColor("blue",true).."Ingyenes"
                            else 
                                cost = colorMoney(cost,false)..white.."$";
                            end
                        end
                        shadowedText(cost,20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
                    end
                end
            end
            if sSubmenu == 6 then --LSD ajtó
                for k,v in pairs(menu[sMenu]["submenu"][sSubmenu][2]) do 
                    dxDrawRectangle(20,sy/2-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
                    if sType == k then 
                        local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                        dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                    end
                    shadowedText(v[1],25,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                    if (getElementData(hitVeh,"tuning.lsdDoor") or false) == v[4] then 
                        shadowedText("",20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,icons,"right","center",false,false,false,true);
                        shadowedText("installed",20,sy/2-h/2-30+(k*40),275,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,font,"right","center",false,false,false,true);
                    else 
                        local cost = v[2];
                        if v[3] then 
                            cost = colorMoney(cost,true)..white.."PP";
                        else
                            if cost == 0 then 
                                cost = e:getServerColor("blue",true).."Ingyenes"
                            else 
                                cost = colorMoney(cost,false)..white.."$";
                            end
                        end
                        shadowedText(cost,20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
                    end
                end
            end
            if sSubmenu == 7 then --Fordulószög
                for k,v in pairs(menu[sMenu]["submenu"][sSubmenu][2]) do 
                    dxDrawRectangle(20,sy/2-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
                    if sType == k then 
                        local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                        dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                    end
                    shadowedText(v[1],25,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                    if isSteeringLock(v[4]) then 
                        shadowedText("",20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,icons,"right","center",false,false,false,true);
                        shadowedText("installed",20,sy/2-h/2-30+(k*40),275,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,font,"right","center",false,false,false,true);
                    else 
                        local cost = v[2];
                        if v[3] then 
                            cost = colorMoney(cost,true)..white.."PP";
                        else
                            if cost == 0 then 
                                cost = e:getServerColor("blue",true).."Ingyenes"
                            else 
                                cost = colorMoney(cost,false)..white.."$";
                            end
                        end
                        shadowedText(cost,20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
                    end
                end
            end
            if sSubmenu == 8 then --Variáns
                for k,v in pairs(menu[sMenu]["submenu"][sSubmenu][2]) do 
                    dxDrawRectangle(20,sy/2-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
                    if sType == k then 
                        local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                        dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                    end
                    shadowedText(v[1],25,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                    if (getElementData(hitVeh,"tuning.variant") or 0) == v[4] then 
                        shadowedText("",20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,icons,"right","center",false,false,false,true);
                        shadowedText("installed",20,sy/2-h/2-30+(k*40),275,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,font,"right","center",false,false,false,true);
                    else 
                        local cost = v[2];
                        if v[3] then 
                            cost = colorMoney(cost,true)..white.."PP";
                        else
                            if cost == 0 then 
                                cost = e:getServerColor("blue",true).."Ingyenes"
                            else 
                                cost = colorMoney(cost,false)..white.."$";
                            end
                        end
                        shadowedText(cost,20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
                    end
                end
                setCamera(0);
            end
            if sSubmenu == 9 then --Air-Ride
                for k,v in pairs(menu[sMenu]["submenu"][sSubmenu][2]) do 
                    dxDrawRectangle(20,sy/2-h/2-30+(k*40),280,30,tocolor(50,50,50,180));
                    if sType == k then 
                        local w = interpolateBetween(0,0,0,280,0,0,(getTickCount()-changeTick)/300,"Linear");
                        dxDrawRectangle(20,sy/2-h/2-30+(k*40),w,30,tocolor(sColor[1],sColor[2],sColor[3],180));
                    end
                    shadowedText(v[1],25,sy/2-h/2-30+(k*40),310,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"left","center");
                    if (getElementData(hitVeh,"tuning.airRide") or false) == v[4] then 
                        shadowedText("",20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,icons,"right","center",false,false,false,true);
                        shadowedText("installed",20,sy/2-h/2-30+(k*40),275,sy/2-h/2-30+(k*40)+30,tocolor(orange[1],orange[2],orange[3]),1,font,"right","center",false,false,false,true);
                    else 
                        local cost = v[2];
                        if v[3] then 
                            cost = colorMoney(cost,true)..white.."PP";
                        else
                            if cost == 0 then 
                                cost = e:getServerColor("blue",true).."Ingyenes"
                            else 
                                cost = colorMoney(cost,false)..white.."$";
                            end
                        end
                        shadowedText(cost,20,sy/2-h/2-30+(k*40),295,sy/2-h/2-30+(k*40)+30,tocolor(255,255,255),1,font,"right","center",false,false,false,true);
                    end
                end
            end
        end
    end
end

function closeTuning()
    if showTuning then 
        setElementAlpha(showTuning,170);
        setElementDimension(showTuning,0);
    end

    showTuning = false;
    if isElement(hitVeh) then
        setElementFrozen(hitVeh,false);
        for i=0,5 do
            setVehicleDoorOpenRatio( hitVeh, i, 0, 400 );
        end
        hitVeh = false;
    end;
    removeEventHandler("onClientRender",root,render);
    setTimer(function()
        setElementData(localPlayer,"tuning.use",false);
        setElementData(localPlayer,"togHUD",true);
        showChat(true);
        removeCamHandler();
        setCameraTarget(localPlayer,localPlayer);
    end,100,1);
end

addEventHandler("onClientKey",root,function(button,state)
if not showTuning then return end;
if state then 
    if getElementData(localPlayer,"guiActive") then return end --Ha írja be a rendszámot és töröl ne dobja vissza
    if button == "arrow_u" or button == "arrow_d" then 
        cancelEvent();
    end
    if not getElementData(localPlayer,"network") then return end; --Network Protect
    if menuType == "main" then 
        if button == "arrow_d" then 
            if sMenu+1 > #menu then 
                sMenu = 1;
                changeTick = getTickCount();
            else 
                sMenu = sMenu + 1;
                changeTick = getTickCount();
            end
        elseif button == "arrow_u" then 
            if sMenu-1 < 1 then 
                sMenu = #menu;
                changeTick = getTickCount();
            else 
                sMenu = sMenu - 1;
                changeTick = getTickCount();
            end
        elseif button == "enter" then 
            if menu[sMenu].name == "Kilépés" then 
                if showTuning then setElementAlpha(showTuning,170); end;
                closeTuning();
            else 
                menuType = "submenu";
                setCamera(sMenu);
                sSubmenu = 1;
                changeTick = getTickCount();
            end
        end
    elseif menuType == "submenu" then 
        if button == "backspace" then 
            menuType = "main";
            removeCamHandler();
            setCamera(0);
            changeTick = getTickCount();
            cache = {};
        end
        if button == "enter" then 
            menuType = "type";
             if menu[sMenu]["submenu"][sSubmenu].cam then 
                setTypeCamera(0);
                setTypeCamera(menu[sMenu]["submenu"][sSubmenu].cam);
            end

            if sMenu == 2 then --Optika 
                cache = {};
                cache[1] = {};
                table.insert(cache[1],0);
                for k,v in pairs(getVehicleCompatibleUpgrades(hitVeh,menu[sMenu]["submenu"][sSubmenu][2])) do 
                    if v ~= 0 then 
                        table.insert(cache[1],v);
                    end
                end
                cache[2] = {};
                for k,v in pairs(menu[sMenu]["submenu"]) do 
                    cache[2][k] = getVehicleUpgradeOnSlot(hitVeh,v[2]);
                end
                cache[3] = getElementHealth(hitVeh);

                if #cache == 0 then 
                    exports.fv_infobox:addNotification("warning","There are no compatible parts for the vehicle!");
                    return;
                else 
                    setOpticalCamera(sSubmenu);
                end
            end
            
            if menu[sMenu]["submenu"][sSubmenu][2] == 4 then --PaintJob 
                cache = {};
                cache = getPaintJobs(hitVeh);
            end

            if sMenu == 3 and sSubmenu < 4 then --Szinezés 
                setCacheToColors();
                createColorPicker(hitVeh,sx-310,sy/2-150,300,300,menu[sMenu]["submenu"][sSubmenu][3]);
            end

            if sMenu == 4 then --Extrák
                if sSubmenu == 4 then --Rendszám
                    if exports.fv_dx:dxGetEdit("tuning.plate") then 
                        exports.fv_dx:dxDestroyEdit("tuning.plate");
                    end
                    exports.fv_dx:dxCreateEdit("tuning.plate",(getElementData(hitVeh,"veh:rendszam") or getVehiclePlateText(hitVeh)),"Rendszám",sx-195,sy/2-15,190,30);
                end
                if sSubmenu == 8 then --Variáns
                    cache = {getVehicleVariant(hitVeh)};
                end
            end

            sType = 1;
            changeTick = getTickCount();
        end
        if button == "arrow_d" then 
            if sSubmenu+1 > #menu[sMenu]["submenu"] then 
                sSubmenu = 1;
                changeTick = getTickCount();
            else 
                sSubmenu = sSubmenu + 1;
                changeTick = getTickCount();
            end
        elseif button == "arrow_u" then 
            if sSubmenu-1 < 1 then 
                sSubmenu = #menu[sMenu]["submenu"];
                changeTick = getTickCount();
            else 
                sSubmenu = sSubmenu - 1;
                changeTick = getTickCount();
            end
        end
    elseif menuType == "type" then 
        if button == "backspace" then 
            menuType = "submenu";
            setTypeCamera(0);
            setCamera(sMenu);
            if sMenu == 3 and sSubmenu < 4 then --Szinezés 
                destroyColorPicker();
                setTimer(function()
                    setVehicleColor(hitVeh,cache[1],cache[2],cache[3],cache[4],cache[5],cache[6],cache[7],cache[8],cache[9],cache[10],cache[11],cache[12]);
                    setVehicleHeadLightColor(hitVeh,cache[13],cache[14],cache[15]);
                end,50,1);
            end
            if sMenu == 4 then --Extrák
                if sSubmenu == 1 then --Első kerék szélesség
                    cache[1] = (getElementData(hitVeh,"tuning.frontWheel") or "default");
                    triggerServerEvent("tuning.wheelSize",localPlayer,localPlayer,hitVeh,"front",cache[1]);
                end
                if sSubmenu == 2 then --Hátsó kerék szélesség
                    cache[1] = (getElementData(hitVeh,"tuning.rearWheel") or "default");
                    triggerServerEvent("tuning.wheelSize",localPlayer,localPlayer,hitVeh,"rear",cache[1]);
                end
                if sSubmenu == 3 then --Neon
                    addNeon(hitVeh,getElementData(hitVeh,"tuning.neon"));
                end
                if sSubmenu == 8 then --Variáns
                    triggerServerEvent("tuning.previewVariant",localPlayer,localPlayer,hitVeh,cache[1] or getElementData(hitVeh,"tuning.variant") or 0); --Restore
                end
            end

            if exports.fv_dx:dxGetEdit("tuning.plate") then 
                exports.fv_dx:dxDestroyEdit("tuning.plate");
            end

            setTimer(function()
                if sMenu == 2 then --Optika
                    if cache[2] then 
                        for k,v in pairs(getVehicleUpgrades(hitVeh)) do 
                            removeVehicleUpgrade(hitVeh,v);
                        end
                        for k,v in pairs(cache[2]) do 
                            addVehicleUpgrade(hitVeh,v);
                        end
                    end
                    if cache[3] then 
                        setElementHealth(hitVeh,cache[3]);
                    end
                end

                cache = {};
                if sMenu == 3 then --PaintJob
                    addPaintJob(hitVeh,getElementData(hitVeh,"tuning.paintJob") or "none");
                end
            end,100,1);
            changeTick = getTickCount();
        end
        if button == "enter" then 
            if sMenu == 1 then --Teljesítmény
                local current = menu[sMenu]["submenu"][sSubmenu][2];
                if current[sType][3] then 
                    if getElementData(localPlayer,"char >> premiumPoints") < current[sType][2] then 
                        exports.fv_infobox:addNotification("error","You don't have enough premium points to buy a tuning!");
                        return;
                    end
                    triggerServerEvent("tuning.performance",localPlayer,localPlayer,hitVeh,sSubmenu,sType,"char >> premiumPoints");
                else 
                    if getElementData(localPlayer,"char >> money") < current[sType][2] then 
                        exports.fv_infobox:addNotification("error","You don't have enough money to buy a tuning!");
                        return;
                    end
                    triggerServerEvent("tuning.performance",localPlayer,localPlayer,hitVeh,sSubmenu,sType,"char >> money");
                end
            end
            if sMenu == 2 then --Optika
                local currentTunings = (getElementData(hitVeh,"tuning.optical") or {0,0,0,0,0,0,0});
                if currentTunings[sSubmenu] ~= cache[1][sType] then 
                    if getElementData(localPlayer,"char >> money") < menu[sMenu].cost then 
                        exports.fv_infobox:addNotification("error","You don't have enough money to buy a tuning!");
                        return;
                    else 
                        cache[2][sSubmenu] = cache[1][sType];
                        triggerServerEvent("tuning.buyOptical",localPlayer,localPlayer,hitVeh,sSubmenu,cache[1][sType],menu[sMenu].cost);
                    end
                end
            end
            if sMenu == 3 then --Szin
                if sSubmenu < 4 then --Szinezés 
                    if getElementData(localPlayer,"char >> money") >= menu[sMenu]["submenu"][sSubmenu][2][2] then 
                        setCacheToColors();
                        triggerServerEvent("tuning.colorSave",localPlayer,localPlayer,hitVeh,cache,menu[sMenu]["submenu"][sSubmenu][2][2]);
                    else 
                        exports.fv_infobox:addNotification("error","You don't have enough money to buy paint!");
                        return;
                    end
                end
                if menu[sMenu]["submenu"][sSubmenu][2] == 4 then --PaintJob 
                    if getElementData(hitVeh,"tuning.paintJob") ~= cache[sType][1] then 
                        if getElementData(localPlayer,"char >> premiumPoints") >= menu[sMenu]["submenu"][sSubmenu][3] or menu[sMenu]["submenu"][sSubmenu][3] == 0 then 
                            triggerServerEvent("tuning.buyPaintJob",localPlayer,localPlayer,hitVeh,cache[sType][1],menu[sMenu]["submenu"][sSubmenu][3]);
                        else 
                            exports.fv_infobox:addNotification("error","You don't have enough premium points to buy a tuning!");
                            return;
                        end
                    end
                end
            end
            if sMenu == 4 then --Extrák
                if sSubmenu < 3 then --kerék szélesség
                    local current = menu[sMenu]["submenu"][sSubmenu][2][sType];
                    if (getElementData(hitVeh,"tuning."..(menu[sMenu]["submenu"][sSubmenu].side).."Wheel") or "default") ~= current[4] then 
                        if getElementData(localPlayer,"char >> money") < current[2] then 
                            exports.fv_infobox:addNotification("error","You don't have enough money to buy a tuning!");
                            return;
                        else 
                            triggerServerEvent("tuning.wheelSize",localPlayer,localPlayer,hitVeh,menu[sMenu]["submenu"][sSubmenu].side,current[4],true,current[2]);
                            cache = {};
                            cache[1] = (getElementData(hitVeh,"tuning."..(menu[sMenu]["submenu"][sSubmenu].side).."Wheel") or "default");
                        end
                    end
                end
                if sSubmenu == 3 then --Neon
                    local current = menu[sMenu]["submenu"][sSubmenu][2][sType];
                    if getElementData(hitVeh,"tuning.neon") ~= current[4] then 
                        if getElementData(localPlayer,"char >> premiumPoints") < current[2] then 
                            exports.fv_infobox:addNotification("error","You don't have enough premium points to buy a tuning!");
                            return;
                        else 
                            triggerServerEvent("tuning.buyNeon",localPlayer,localPlayer,hitVeh,current[4],current[2]);
                        end
                    end
                end
                if sSubmenu == 4 then --Rendszám
                    local cost = menu[sMenu]["submenu"][sSubmenu][2][2];
                    if getElementData(localPlayer,"char >> premiumPoints") < cost then 
                        exports.fv_infobox:addNotification("error","You don't have enough premium points to buy a tuning!");
                        return;
                    end
                    local text = exports.fv_dx:dxGetEditText("tuning.plate");
                    if text == "" or text == " " or string.len(text) < 2 then 
                        exports.fv_infobox:addNotification("warning","The given license plate is incorrect!");
                        return;
                    end
                    if string.len(text) > 8 then 
                        exports.fv_infobox:addNotification("warning","License plate given is too long!");
                        return;
                    end
                    if not setVehiclePlateText(hitVeh,text) then 
                        exports.fv_infobox:addNotification("warning","License plate given is too long!");
                        return
                    end
                    triggerServerEvent("tuning.setPlate",localPlayer,localPlayer,hitVeh,text,cost);
                end
                if sSubmenu == 5 then --Meghajtás
                    local current = menu[sMenu]["submenu"][sSubmenu][2][sType];
                    if getVehicleHandling(hitVeh)["driveType"] ~= current[4] then 
                        if getElementData(localPlayer,"char >> money") < current[2] then 
                            exports.fv_infobox:addNotification("error","You don't have enough money to buy a tuning!");
                            return;
                        else 
                            triggerServerEvent("tuning.driveType",localPlayer,localPlayer,hitVeh,current[4],current[2]);
                        end
                    end
                end
                if sSubmenu == 6 then --LSD ajtó
                    local current = menu[sMenu]["submenu"][sSubmenu][2][sType];
                    if (getElementData(hitVeh,"tuning.lsdDoor") or false) ~= current[4] then 
                        if getElementData(localPlayer,"char >> premiumPoints") < current[2] then 
                            exports.fv_infobox:addNotification("error","You don't have enough premium points to buy a tuning!");
                            return;
                        else 
                            triggerServerEvent("tuning.lsdDoor",localPlayer,localPlayer,hitVeh,current[4],current[2]);
                        end
                    end
                end
                if sSubmenu == 7 then --Fordulószög
                    local current = menu[sMenu]["submenu"][sSubmenu][2][sType];
                    if not isSteeringLock(current[4]) then 
                        if getElementData(localPlayer,"char >> money") < current[2] then 
                            exports.fv_infobox:addNotification("error","You don't have enough money to buy a tuning!");
                            return;  
                        else 
                            triggerServerEvent("tuning.steeringLock",localPlayer,localPlayer,hitVeh,current[4],current[2]);
                        end
                    end
                end
                if sSubmenu == 8 then --Variáns
                    local current = menu[sMenu]["submenu"][sSubmenu][2][sType];
                    if (getElementData(hitVeh,"tuning.variant") or 0) ~= current[4] then 
                        if getElementData(localPlayer,"char >> money") < current[2] then 
                            exports.fv_infobox:addNotification("error","You don't have enough money to buy a tuning!");
                            return;  
                        else 
                            cache = {};
                            cache = {getVehicleVariant(hitVeh)};
                            triggerServerEvent("tuning.buyVariant",localPlayer,localPlayer,hitVeh,current[4],current[2]);
                        end
                    end
                end
                if sSubmenu == 9 then --Air-Ride
                    local current = menu[sMenu]["submenu"][sSubmenu][2][sType];
                    if (getElementData(hitVeh,"tuning.airRide") or false) ~= current[4] then 
                        if getElementData(localPlayer,"char >> money") < current[2] then 
                            exports.fv_infobox:addNotification("error","You don't have enough money to buy a tuning!");
                            return;  
                        else 
                            triggerServerEvent("tuning.buyAirRide",localPlayer,localPlayer,hitVeh,current[4],current[2]);
                        end
                    end
                end
            end
        end
        if sMenu == 1 or (sMenu == 4 and sSubmenu ~= 4) then --Teljesítmény + kerék szélesség + neon + meghajtás + LSD ajtó + Fordulószög
            if button == "arrow_d" then 
                if changeTick+500 > getTickCount() then 
                    exports.fv_infobox:addNotification("warning","Slower!");
                    return;
                end
                if sType+1 > #menu[sMenu]["submenu"][sSubmenu][2] then 
                    sType = 1;
                    changeTick = getTickCount();
                else 
                    sType = sType + 1;
                    changeTick = getTickCount();
                end
                if sMenu == 4 then --Extrák
                    if sSubmenu < 3 then --Kerék szélesség
                        local data = menu[sMenu]["submenu"][sSubmenu][2][sType][4];
                        cache = {};
                        cache[1] = (getElementData(hitVeh,"tuning."..(menu[sMenu]["submenu"][sSubmenu].side).."Wheel") or "default");
                        triggerServerEvent("tuning.wheelSize",localPlayer,localPlayer,hitVeh,menu[sMenu]["submenu"][sSubmenu].side,data);
                    end
                    if sSubmenu == 3 then --Neon
                        addNeon(hitVeh,menu[sMenu]["submenu"][sSubmenu][2][sType][4]);
                    end
                    if sSubmenu == 8 then --Variáns
                        local current = menu[sMenu]["submenu"][sSubmenu][2][sType];
                        triggerServerEvent("tuning.previewVariant",localPlayer,localPlayer,hitVeh,current[4]);
                    end
                end
            elseif button == "arrow_u" then 
                if changeTick+500 > getTickCount() then 
                    exports.fv_infobox:addNotification("warning","Slower!");
                    return;
                end
                if sType-1 < 1 then 
                    sType = #menu[sMenu]["submenu"][sSubmenu][2];
                    changeTick = getTickCount();
                else 
                    sType = sType - 1;
                    changeTick = getTickCount();
                end
                if sMenu == 4 then 
                    if sSubmenu == 1 then --Első Kerék szélesség
                        local data = menu[sMenu]["submenu"][sSubmenu][2][sType][4];
                        cache = {};
                        cache[1] = (getElementData(hitVeh,"tuning.frontWheel") or "default");
                        triggerServerEvent("tuning.wheelSize",localPlayer,localPlayer,hitVeh,"front",data);
                    end
                    if sSubmenu == 3 then --Neon
                        addNeon(hitVeh,menu[sMenu]["submenu"][sSubmenu][2][sType][4]);
                    end
                    if sSubmenu == 8 then --Variáns
                        local current = menu[sMenu]["submenu"][sSubmenu][2][sType];
                        triggerServerEvent("tuning.previewVariant",localPlayer,localPlayer,hitVeh,current[4]);
                    end
                end
            end
        else  --Ha cache tábla a menü!
            if sMenu == 2 then --Optika
                if cache and cache[1] and #cache[1] > 0 then 
                    if button == "arrow_d" then 
                        if changeTick+500 > getTickCount() then 
                            exports.fv_infobox:addNotification("warning","Slower!");
                            return;
                        end
                        if sType+1 > #cache[1] then 
                            sType = 1;
                            changeTick = getTickCount();
                        else 
                            sType = sType + 1;
                            changeTick = getTickCount();
                        end
                        addVehicleUpgrade(hitVeh,cache[1][sType]);
                    elseif button == "arrow_u" then 
                        if sType-1 < 1 then 
                            sType = #cache[1];
                            changeTick = getTickCount();
                        else 
                            sType = sType - 1;
                            changeTick = getTickCount();
                        end
                    end
                    addVehicleUpgrade(hitVeh,cache[1][sType]);
                end
            else 
                if cache and #cache > 0 then 
                    if button == "arrow_d" then 
                        if changeTick+500 > getTickCount() then 
                            exports.fv_infobox:addNotification("warning","Slower!");
                            return;
                        end
                        if sType+1 > #cache then 
                            sType = 1;
                            changeTick = getTickCount();
                        else 
                            sType = sType + 1;
                            changeTick = getTickCount();
                        end
                        if sMenu == 3 and sSubmenu == 4 then --PaintJob
                            if cache[sType][1] then 
                                addPaintJob(hitVeh,cache[sType][1]);
                            end
                        end
                    elseif button == "arrow_u" then 
                        if sType-1 < 1 then 
                            sType = #cache;
                            changeTick = getTickCount();
                        else 
                            sType = sType - 1;
                            changeTick = getTickCount();
                        end
                    end
                    if sMenu == 3 and sSubmenu == 4 then --PaintJob
                        if cache[sType][1] then 
                            addPaintJob(hitVeh,cache[sType][1]);
                        end
                    end
                end
            end
        end
    end
end
end);

function isSteeringLock(value)
    local state = false;
    local current = getVehicleHandling(hitVeh)["steeringLock"];
    if value == 0 then 
        local values = menu[4]["submenu"][7][2];
        local a = 0;
        for k,v in pairs(values) do 
            if current ~= v[4] then 
                a = a + 1;
            end
        end
        if a == #values then 
            state = true;
        end
    else 
        if current == value then 
            state = true;
        end
    end
    return state;
end

function setCacheToColors()
    cache = {};
    local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor(hitVeh, true);
    local r5, g5, b5 = getVehicleHeadLightColor(hitVeh);
    cache[1] = r1;
    cache[2] = g1;
    cache[3] = b1;

    cache[4] = r2;
    cache[5] = g2;
    cache[6] = b2;

    cache[7] = r3;
    cache[8] = g3;
    cache[9] = b3;

    cache[10] = r4;
    cache[11] = g4;
    cache[12] = b4;

    cache[13] = r5;
    cache[14] = g5;
    cache[15] = b5;
end

function setCamera(id)
    local x,y,z = getElementPosition(localPlayer);
    local a,b,c,d,e,f = getCameraMatrix(localPlayer);
    if id == 0 or id == 2  then --Főmenü
        for i=0,5 do
            setVehicleDoorOpenRatio( hitVeh, i, 0, 400 );
        end
        smoothMoveCamera(a,b,c,d,e,f,x-2,y-10,z+1,x,y,z,1000); --Főmenü
    elseif id == 1 then --Teljesítmény
        smoothMoveCamera(a,b,c,d,e,f,x-2,y-3,z+1,x,y,z,1000);
        setVehicleDoorOpenRatio(hitVeh, 0, 180, 400)
    end
end

function setTypeCamera(id)
    local x,y,z = getElementPosition(localPlayer);
    local a,b,c,d,e,f = getCameraMatrix(localPlayer);
    if id == 0 then 
        for i=0,5 do
            setVehicleDoorOpenRatio( hitVeh, i, 0, 400 );
        end
        setVehicleWheelStates(hitVeh,0,0,0,0);
    end
    if id == 1 then --Fékek
        setVehicleWheelStates(hitVeh,2,2,2,2);
        smoothMoveCamera(a,b,c,d,e,f,x+4,y-1,z-0.3,x,y,z,1000);
    elseif id == 2 then --Gumik
        smoothMoveCamera(a,b,c,d,e,f,x+4,y-1,z-0.3,x,y,z,1000);
    elseif id == 3 then --Hátsó kerék szélesség
        smoothMoveCamera(a,b,c,d,e,f,x+2.5,y+5,z,x,y,z,1000);
    elseif id == 4 then --Első kerék szélesség
        smoothMoveCamera(a,b,c,d,e,f,x-2.5,y-5,z,x,y,z,1000);
    end
end

function setOpticalCamera(id)
    local x,y,z = getElementPosition(localPlayer);
    local a,b,c,d,e,f = getCameraMatrix(localPlayer);
    if id == 1 then 
        smoothMoveCamera(a,b,c,d,e,f,x+4,y-1,z-0.3,x,y,z,1000);
    elseif id == 2 then 
        smoothMoveCamera(a,b,c,d,e,f,x,y+4,z+1,x,y,z,1000);
    elseif id == 3 then 
        smoothMoveCamera(a,b,c,d,e,f,x,y+4,z,x,y,z,1000);
    elseif id == 4 then 
        smoothMoveCamera(a,b,c,d,e,f,x+1,y-5.5,z+1,x,y,z,1000);
    elseif id == 5 then 
        smoothMoveCamera(a,b,c,d,e,f,x-1,y+5.5,z,x,y,z,1000);
    elseif id == 6 then 
        smoothMoveCamera(a,b,c,d,e,f,x+2,y-1,z-0.3,x,y,z,1000);
    elseif id == 7 then 
        smoothMoveCamera(a,b,c,d,e,f,x-2,y-2,z+1.47,x,y,z,1000); --Főmenü
    end
end

function colorMoney(value,pp)
    if not pp then 
        local color = e:getServerColor("servercolor",true);
        if getElementData(localPlayer,"char >> money") < value then 
            color = e:getServerColor("red",true);
        end
        return color..formatMoney(value); 
    else 
        local color = e:getServerColor("servercolor",true);
        if getElementData(localPlayer,"char >> premiumPoints") < value then 
            color = e:getServerColor("red",true);
        end
        return color..formatMoney(value); 
    end
end

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end

--Camera Move--
local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
function removeCamHandler()
	if(sm.moov == 1)then
        sm.moov = 0
        sm = {};
	end
end
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientPreRender",root,camRender)
	end
end
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if (sm.moov == 1) then return false end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
    setElementCollisionsEnabled (sm.object1,false) 
	setElementCollisionsEnabled (sm.object2,false) 
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	removeEventHandler("onClientPreRender",root,camRender)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end
