local e;

addEventHandler("onClientResourceStart",root,function(res)
    if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        e = exports.fv_engine;
        gearFont = e:getFont("rage",14);
        speedFont = e:getFont("rage",20);
        speedFont2 = e:getFont("rage",13);
        rpmFont = e:getFont("rage",12);
        tempomatFont = exports.fv_engine:getFont("rage",13);

        red = {e:getServerColor("red",false)};
        red2 = e:getServerColor("red",true);
        sColor = {e:getServerColor("servercolor",false)};
        orange = {e:getServerColor("orange",false)};
        orange2 = e:getServerColor("orange",true);
        blue = {e:getServerColor("blue",false)};
    end
end);

function renderSpeedo()
    local veh = getPedOccupiedVehicle(localPlayer);
    if veh and getElementData(localPlayer,"speedo.showing") and getElementData(localPlayer,"togHUD") and not exports.fv_vehicle:isBike(veh) then 
        local seat = getPedOccupiedVehicleSeat(localPlayer);
        if seat == 0 or seat == 1 then 
            local x, y = getElementData(localPlayer,"speedo.x"),getElementData(localPlayer,"speedo.y");
            dxDrawImage(x+20,y+20,300,300,"images/speedobg.png",0,0,0,tocolor(255,255,255),true);
            local speed = getVehicleSpeed(veh);
            local drawSpeed = speed*0.76;
            if math.ceil(drawSpeed) > 401 then 
                drawSpeed = 400;
            end

            dxDrawText(getFormatGear(veh),x+177,y+260,0,y+325,tocolor(255,255,255),1,gearFont,"left","center",false,false,true,false);
            shadowedText(tostring(math.floor(speed)),x+20,y+220,x+320,0,tocolor(255,255,255),1,speedFont,"center","top",false,false,true,false);
            shadowedText("km/h",x+20,y+250,x+320,0,tocolor(255,255,255),1,speedFont2,"center","top",false,false,true,false);

            shadowedText(math.floor(getElementData(veh,"veh:km") or 0).." km",x+20,y+185,x+320,0,tocolor(180,180,180),1,speedFont2,"center","top",false,false,true,false);

            dxDrawImage(x+20,y+20,300,300,"images/fuelbg.png",0,0,0,tocolor(255,255,255),true);
            dxDrawImage(x-15,y+20,300,300,"images/fuelicon.png",0,0,0,tocolor(255,255,255),true);

            local fuel = (getElementData(veh,"veh:uzemanyag") or 50);
            dxDrawImageSection(x+20, y+320, 300 , -(fuel*3), 0, 0, 300,-(fuel*3), "images/fuelvonal.png", 0, 0, 0,tocolor(255,255,255),true);

            dxDrawImage(x+20,y+20,300,300,"images/nitrobg.png",0,0,0,tocolor(255,255,255),true);
            dxDrawImage(x+45,y+20,300,300,"images/nitroicon.png",0,0,0,tocolor(255,255,255),true);
            local nitro = getVehicleNitroLevel(veh);
            if nitro then 
                nitro = nitro*100;
                dxDrawImageSection(x+20, y+320, 300 , -(nitro*3), 0, 0, 300,-(nitro*3), "images/nitrovonal.png", 0, 0, 0,tocolor(255,255,255),true);
            end

            dxDrawImage(x+155,y+85,30,30,"icons/belt.png",0,0,0,tocolor(0,0,0),true);
            if not getElementData(localPlayer,"veh:ov") then 
                dxDrawImage(x+155,y+85,30,30,"icons/belt.png",0,0,0,tocolor(red[1],red[2],red[3],255 *math.abs(getTickCount() % 2000) / 500),true);
            else
                dxDrawImage(x+155,y+85,30,30,"icons/belt.png",0,0,0,tocolor(sColor[1],sColor[2],sColor[3],255),true);
            end

            dxDrawImage(x+130,y+85,30,30,"icons/arrow_l.png",0,0,0,tocolor(0,0,0),true);
            if getElementData(veh, "index.left") and getTickCount() % 1000 < 500 then
                dxDrawImage(x+130,y+85,30,30,"icons/arrow_l.png",0,0,0,tocolor(orange[1],orange[2],orange[3],255),true);
            end

            dxDrawImage(x+180,y+85,30,30,"icons/arrow_r.png",0,0,0,tocolor(0,0,0),true);
            if getElementData(veh, "index.right") and getTickCount() % 1000 < 500 then
                dxDrawImage(x+180,y+85,30,30,"icons/arrow_r.png",0,0,0,tocolor(orange[1],orange[2],orange[3],255),true);
            end

            dxDrawImage(x+115,y+115,30,30,"icons/engine.png",0,0,0,tocolor(0,0,0),true);
            if getVehicleEngineState(veh) and getElementHealth(veh) > 501 then 
                dxDrawImage(x+115,y+115,30,30,"icons/engine.png",0,0,0,tocolor(sColor[1],sColor[2],sColor[3]),true);
            elseif getElementHealth(veh) > 251 and getElementHealth(veh) < 500 then 
                dxDrawImage(x+115,y+115,30,30,"icons/engine.png",0,0,0,tocolor(orange[1],orange[2],orange[3],255 *math.abs(getTickCount() % 2000) / 1000),true);
            elseif getElementHealth(veh) < 251 then 
                dxDrawImage(x+115,y+115,30,30,"icons/engine.png",0,0,0,tocolor(red[1],red[2],red[3]),true);
            end

            dxDrawImage(x+145,y+115,30,30,"icons/handbrake.png",0,0,0,tocolor(0,0,0),true);
            if getElementData(veh,"kezifek") then
                dxDrawImage(x+145,y+115,30,30,"icons/handbrake.png",0,0,0,tocolor(red[1],red[2],red[3]),true);
            end
            
            dxDrawImage(x+175,y+115,30,30,"icons/headlight.png",0,0,0,tocolor(0,0,0),true);
            if getVehicleOverrideLights(veh) > 1 then 
                dxDrawImage(x+175,y+115,30,30,"icons/headlight.png",0,0,0,tocolor(blue[1],blue[2],blue[3]),true);
            end

            dxDrawImage(x+200,y+115,30,30,"icons/locked.png",0,0,0,tocolor(0,0,0),true);
            if isVehicleLocked(veh) then 
                dxDrawImage(x+200,y+115,30,30,"icons/locked.png",0,0,0,tocolor(red[1],red[2],red[3]),true);
            end

            dxDrawImage(x+20,y+20,300,300,"images/mutato.png",drawSpeed,0,0,tocolor(255,255,255),true);
        end
    end
end
addEventHandler("onClientRender",root,renderSpeedo);

function renderRPM()
    local veh = getPedOccupiedVehicle(localPlayer);
    if veh and getElementData(localPlayer,"rpm.showing") and getElementData(localPlayer,"togHUD") then 
        local seat = getPedOccupiedVehicleSeat(localPlayer);
        if seat == 0 or seat == 1 then 
            local x, y = getElementData(localPlayer,"rpm.x"),getElementData(localPlayer,"rpm.y");
            dxDrawImage(x,y,140,140,"images/rpmbg.png",0,0,0,tocolor(255,255,255),true);
            local rpmDraw,rpm = getVehicleRPM(veh);
            shadowedText(tostring(math.ceil(rpm)),x,y+80,x+140,140,tocolor(255,255,255),1,rpmFont,"center","top",false,false,true);
            shadowedText("RPM",x,y+93,x+140,140,tocolor(255,255,255),1,rpmFont,"center","top",false,false,true);
            dxDrawImage(x,y,140,140,"images/rpmmutato.png",rpmDraw,0,0,tocolor(255,255,255),true);
        end
    end
end
addEventHandler("onClientRender",root,renderRPM);

function renderTempomat()
    local veh = getPedOccupiedVehicle(localPlayer);
    if veh and getElementData(localPlayer,"tempomat.showing") and getElementData(localPlayer,"togHUD") then 
        local seat = getPedOccupiedVehicleSeat(localPlayer);
        if seat == 0 or seat == 1 then 
            local x, y = getElementData(localPlayer,"tempomat.x"),getElementData(localPlayer,"tempomat.y");
            local w,h = 200,25;
            local text = red2.."Kikapcsolva.";
            if getElementData(veh,"tempomat.state") then 
                text = orange2..math.floor(getElementData(veh,"tempomat.limitSpeed")).." km/h";
            end
            shadowedText("Tempomat: "..text,x,y,x+w,y+h,tocolor(255,255,255),1,tempomatFont,"right","center");
        end
    end
end
addEventHandler("onClientRender",root,renderTempomat);
