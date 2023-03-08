if fileExists("client.lua") then 
    fileDelete("client.lua");
end

sx,sy = guiGetScreenSize();
e = exports.fv_engine;
local tab = 0;
local w,h = 0,0;
local tick = getTickCount();
local panelstate = "open";
local lastKey = 0;
local playerInteriors = {};
local playerVehicles = {};
local shaders = {
	--Név,státusz
	{"HD textures",false},
	{"Vehicle reflection",false},
	{"More beautiful water",false},
	{"Sky effect",false},
}
local admins = {};
local selectedAdmin = 1;
factions = {};
local factionMembers = {};
local factionVehicles = {};
local sFaction = 1;
local factionMenu = { 
    {"Overview",""},
    {"Members",""}, 
    {"ranks",""},
    {"Vehicles",""}, 
    {"Other",""}
};
local sFmenu = 1;
local sFmember = 1;
local leaderButtons = {
    {"Rank Increase","",{exports.fv_engine:getServerColor("servercolor",false)}},
    {"Rank Reduction","",{exports.fv_engine:getServerColor("orange",false)}},
    {"sacking","",{exports.fv_engine:getServerColor("red",false)}},
}
local sFrank = 1;
local rankGUI = false;
local rankGUI2 = false;
local sFveh = 1;
local leaderM = false;

local vCount = 0;
local vScroll = 0;
local vMax = 10;
local sVeh = 1;
local kTick = 0;

local iCount = 0;
local iScroll = 0;
local iMax = 10;
local sInt = 1;

local vehMarker = false;

local walkStyles = {
    {118, "Normal"},
	{55, "bulk up"},
	{56, "taut"},
	{69, "Strait"},
	{119, "stooping"},
	{121, "Gangster 1"},
    {122, "Gangster 2"},
    {120, "Old 1"},
	{123, "Old 2"},
	{124, "Fat"},
	{126, "Drunk"},
	{129, "Female 1"},
	{131, "Female 2"},
	{132, "Female 3"},
	{133, "Female 4"},
};

local walkStyle = 1;

local skinPreview = {};

local changeMenu = 0;

local crosshair = 1;
local crosshairCount = 20;

addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        font = exports.fv_engine:getFont("rage", 15);
        font2 = exports.fv_engine:getFont("Roboto", 15);
        font3 = exports.fv_engine:getFont("rage", 10);
        font4 = exports.fv_engine:getFont("rage", 10);
        sColor = {exports.fv_engine:getServerColor("servercolor",false)};
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
        red = {exports.fv_engine:getServerColor("red",false)};
        red2 = exports.fv_engine:getServerColor("red",true);
        green = {exports.fv_engine:getServerColor("green",false)};
        orange = {exports.fv_engine:getServerColor("orange",false)};
        icons = exports.fv_engine:getFont("AwesomeFont",12);
        smallfont = exports.fv_engine:getFont("rage",12);
        e = exports.fv_engine;
    end
    if res == getThisResource() then 
        if getElementData(localPlayer,"loggedIn") then 
            triggerServerEvent("dash > getFactions",localPlayer,localPlayer);
        end

        local shader = dxCreateShader("shader.fx")
        local texture = dxCreateTexture("sniper.png");
        dxSetShaderValue(shader, "reTexture", texture);
        engineApplyShaderToWorldTexture(shader, "snipercrosshair");

        local shader, texture = false,false;

        local shader = dxCreateShader("shader.fx")
        local texture = dxCreateTexture("cranes_dyn2.ws_finalbuild.png");
        dxSetShaderValue(shader, "reTexture", texture);
        engineApplyShaderToWorldTexture(shader, "ws_finalbuild");


    end
end);

function drawDash()
    if panelstate == "open" then 
        w,h = interpolateBetween(0,0,0,970,530,0,(getTickCount()-tick)/600,"OutBack");
    else
        w,h = interpolateBetween(970,530,0,0,0,0,(getTickCount()-tick)/600,"OutBack");
        if w == 0 and h == 0 then 
            removeEventHandler("onClientRender",root,drawDash);
            tab = 0;
            showChat(true);
            saveShaders();
            admins = {};
            setElementData(localPlayer,"togHUD",true);
        end
    end
    -- exports.fv_blur:createBlur();
    dxDrawRectangle(sx/2-w/2,sy/2-h/2,w,h,tocolor(37,39,36,230)); 
    if w > 700 then 
        dxDrawBorder(sx/2-w/2,sy/2-h/2,w,h,3,tocolor(200,200,200,100)); 
        dxDrawRectangle(sx/2-w/2+175,sy/2-h/2,3,h,tocolor(200,200,200,100)); 
        dxDrawImage(sx/2-w/2+25,sy/2-h/2+10,128,150,"icon.png");
        for k,v in pairs(tabs) do 
            if exports.fv_engine:isInSlot(sx/2-w/2+10,sy/2-50+(k*45),160,40) or k == tab then
                dxDrawRectangle(sx/2-w/2+7,sy/2-50+(k*45),3,40,tocolor(sColor[1],sColor[2],sColor[3],200));
            end
            dxDrawRectangle(sx/2-w/2+10,sy/2-50+(k*45),160,40,tocolor(100,100,100,100));
            dxDrawImage(sx/2-w/2+13,sy/2-50+(k*45)+3,32,32,"icons/"..k..".png");
            dxDrawText(v,sx/2-w/2+10,sy/2-50+(k*45),sx/2-w/2+10+150,sy/2-50+(k*45)+40,tocolor(255,255,255,200),1,font,"right","center");
        end    
        exports.fv_engine:shadowedText(tabs[tab],sx/2-w/2+130,sy/2-h/2-30,sx/2-w/2+w,h,tocolor(255,255,255,200),1,font2,"center");

        if tab == 1 then

            if w > 200 then 
                local tempW,tempH = math.floor(w*1.3),math.floor(h*1.3);
                exports.fv_op:setProjection(skinPreview[2],sx/2-tempW/2+120,sy/2-tempH/2-40,tempW,tempH,false,true);
                exports.fv_engine:shadowedText("Current Skin",sx/2+w/2-250,sy/2+h/2-30,sx/2+w/2,0,tocolor(255,255,255),1,font,"center","top",false,false,true,true);
            end

            dxDrawText("Account ID: "..sColor2..getElementData(localPlayer,"acc >> id")..white.."\nCaracter ID: "..sColor2..getElementData(localPlayer,"acc >> id")..white.."\nSkin ID: "..sColor2..getElementModel(localPlayer)..white.."\n\nAdmin Level:"..sColor2..getElementData(localPlayer,"admin >> level")..white.."\nAdmin Name: "..sColor2..getElementData(localPlayer,"admin >> name")..white.."\n\nVitality: "..sColor2..math.floor(getElementHealth(localPlayer))..white.." %\nArmor: "..sColor2..math.floor(getPedArmor(localPlayer))..white.." %\nHunger: "..sColor2..math.floor(getElementData(localPlayer,"char >> food"))..white.." %\nThirst: "..sColor2..math.floor(getElementData(localPlayer,"char >> drink"))..white.." %\n\nLevel: "..sColor2..getElementData(localPlayer,"char >> level")..white.."\nAccount Name: "..sColor2..getElementData(localPlayer,"acc >> username")..white.."\nCaracter Name: "..sColor2..getElementData(localPlayer,"char >> name")..white.."\nCash: "..sColor2..formatMoney(getElementData(localPlayer,"char >> money"))..white.."dt\nBank Balance: "..sColor2..formatMoney(getElementData(localPlayer,"char >> bankmoney"))..white.."dt\nPremium Points: "..sColor2..formatMoney(getElementData(localPlayer,"char >> premiumPoints"))..white.."PP\nPlayed Minutes: "..sColor2..getElementData(localPlayer,"char >> playedtime")..white.."\nPay: "..sColor2..SecondsToClock(getElementData(localPlayer,"char.payTime") or 3600),sx/2-w/2+200,sy/2-h/2+5,sx/2-w/2+w,h,tocolor(255,255,255,200),1,font2,"left","top",false,false,false,true);
            
            --Current Job--
            local sizeX,sizeY = 364/2,319/2;
            local job = tonumber(getElementData(localPlayer,"char >> job"));
            if not job or job == 0 then 
                exports.fv_engine:shadowedText("Your current job:\nUnemployed",sx/2+150-sizeX/2,sy/2-h/2+sizeY*3,sx/2+150-sizeX/2+sizeX,0,tocolor(255,255,255),1,font,"center","top",false,false,false,true);
            else 
                dxDrawImage(sx/2+150-sizeX/2,sy/2-h/2+sizeY*2+40,sizeX,sizeY,"jobs/"..job..".png");
                exports.fv_engine:shadowedText("Your current job:\n\n\n\n\n"..exports.fv_jobs:getJobName(job),sx/2+150-sizeX/2,sy/2-h/2+sizeY*2+40,sx/2+150-sizeX/2+sizeX,0,tocolor(255,255,255),1,font,"center","top",false,false,false,true);
            end
            ---------------
        end

        if tab == 2 then 
            dxDrawText("Vehicles ("..#playerVehicles.."/"..(getElementData(localPlayer,"char >> vehSlot") or 0).." db)",sx/2-w/2+200,sy/2-h/2+10,sx/2-w/2+200+w/3.3,0,tocolor(255,255,255),1,smallfont,"center","top")
            dxDrawText("Real estate ("..#playerInteriors.."/"..(getElementData(localPlayer,"char >> intSlot") or 0).." db)",sx/2+170,sy/2-h/2+10,sx/2+200+w/3.3,h-150,tocolor(255,255,255),1,smallfont,"center","top")

            if exports.fv_engine:isInSlot(sx/2-w/2+190,sy/2-h/2+10,80,30) then
                if getKeyState("mouse1") and kTick+1000 < getTickCount() then 
                    if getElementData(localPlayer,"char >> premiumPoints") >= 200 then 
                        triggerServerEvent("dash > vehSlotBuy",localPlayer,localPlayer);
                        kTick = getTickCount();
                    else 
                        exports.fv_infobox:addNotification("warning","You don't have enough bonuses to buy the slot! (200PP)");
                        kTick = getTickCount();
                    end
                end
                tooltip("200PP");
                dxDrawRectangle(sx/2-w/2+190,sy/2-h/2+10,80,30,tocolor(sColor[1],sColor[2],sColor[3],200))
            else
                dxDrawRectangle(sx/2-w/2+190,sy/2-h/2+10,80,30,tocolor(200,200,200,50))
            end
            exports.fv_engine:shadowedText("+ Slot",sx/2-w/2+190,sy/2-h/2+10,sx/2-w/2+190+80,sy/2-h/2+10+30,tocolor(255,255,255),1,font4,"center","center");

            if #playerVehicles > 0 then
                for k=1,10 do 
                    local a = 50;
                    if k%2 == 0 then 
                        a = 80;
                    end 
                    dxDrawRectangle(sx/2-w/2+200,sy/2-h/2+50+(k*30),w/3.3,20,tocolor(200,200,200,a)) --Vehicle
                end
                dxDrawText("Modell",sx/2-w/2+200,sy/2-h/2+50,sx/2-w/2+200+w/3.3,sy/2-h/2+50+20,tocolor(255,255,255),1,smallfont,"center","center")
                dxDrawText("ID",sx/2-w/2+200+3,sy/2-h/2+50,sx/2-w/2+200+w/3.3,sy/2-h/2+50+20,tocolor(255,255,255),1,smallfont,"left","center")
                dxDrawText("Condition",sx/2-w/2+200+3,sy/2-h/2+50,sx/2-w/2+200+w/3.3,sy/2-h/2+50+20,tocolor(255,255,255),1,smallfont,"right","center")
                local count = 0;
                for k,v in pairs(playerVehicles) do 
                    if k > vScroll and count < vMax then
                        count = count + 1;
                        vCount = count;
                        if getKeyState("mouse1") and kTick+500 < getTickCount() then 
                            if exports.fv_engine:isInSlot(sx/2-w/2+200,sy/2-h/2+50+(count*30),w/3.3,20) then 
                                if sVeh ~= k then 
                                    sVeh = k;
                                    kTick = getTickCount();
                                end
                            end
                        end
                        if getKeyState("mouse2") and kTick+500 < getTickCount() then 
                            if exports.fv_engine:isInSlot(sx/2-w/2+200,sy/2-h/2+50+(count*30),w/3.3,20) then 
                                if getElementDimension(v) > 0 then exports.fv_infobox:addNotification("error","Vehicle is in garage, cannot be assigned!") return end;
                                if isElement(vehMarker) then 
                                    destroyElement(vehMarker);
                                    if isElement(vehBlip) then 
                                        destroyElement(vehBlip);
                                    end
                                    exports.fv_infobox:addNotification("info","Selection deleted.");
                                else
                                    local x,y,z = getElementPosition(v);
                                    vehMarker = createMarker(x,y,z,"checkpoint",2.3,sColor[1],sColor[2],sColor[3],100);

                                    local blue = {exports.fv_engine:getServerColor("blue",false)};
                                    vehBlip = createBlip(x,y,z,33);
                                    setElementData(vehBlip,"blip >> color",{blue[1],blue[2],blue[3]});
                                    setElementData(vehBlip,"blip >> name","Vehicle marking");
                                    setElementData(vehBlip,"blip >> size",25);

                                    addEventHandler("onClientMarkerHit",vehMarker,function(hitElement)
                                        if hitElement == localPlayer then 
                                            exports.fv_infobox:addNotification("info","You found your vehicle!");
                                            destroyElement(vehMarker);
                                            if isElement(vehBlip) then 
                                                destroyElement(vehBlip);
                                            end
                                        end
                                    end);
                                    attachElements(vehMarker,v);
                                    attachElements(vehBlip,v);
                                    exports.fv_infobox:addNotification("success","Vehicle selected!");
                                end
                                kTick = getTickCount();
                            end
                        end
                        if sVeh == k then 
                            dxDrawRectangle(sx/2-w/2+200,sy/2-h/2+50+(count*30),w/3.3,20,tocolor(sColor[1],sColor[2],sColor[3]));
                        end

                        local model = exports.fv_vehmods:getVehicleRealName(v) or getVehicleNameFromModel(getElementModel(v));

                        exports.fv_engine:shadowedText(model,sx/2-w/2+200,sy/2-h/2+50+(count*30),sx/2-w/2+200+w/3.3,sy/2-h/2+50+(count*30)+20,tocolor(255,255,255),1,smallfont,"center","center");
                        exports.fv_engine:shadowedText(getElementData(v,"veh:id"),sx/2-w/2+200+3,sy/2-h/2+50+(count*30),sx/2-w/2+200+w/3.3,sy/2-h/2+50+(count*30)+20,tocolor(255,255,255),1,smallfont,"left","center");
                        exports.fv_engine:shadowedText(math.ceil(getElementHealth(v)/10).."%",sx/2-w/2+200+3,sy/2-h/2+50+(count*30),sx/2-w/2+200+w/3.3,sy/2-h/2+50+(count*30)+20,tocolor(255,255,255),1,smallfont,"right","center");
                    end
                end
                local jelen = playerVehicles[sVeh];
                if not isElement(jelen) then return end;
                local motor = red2.."stopped.";
                if getVehicleEngineState(jelen) then 
                    motor = sColor2.."Started.";
                end
                local lampa = red2.."disconnected.";
                if getVehicleOverrideLights(jelen) > 0 then 
                    lampa = sColor2.."flipping.";
                end
                local ajto = red2.."Closed.";
                if not isVehicleLocked(jelen) then 
                    ajto = sColor2.."open.";
                end
                local kezifek = red2.."released.";
                if isElementFrozen(jelen) then 
                    kezifek = sColor2.."retracted.";
                end
                dxDrawText("Motor: "..motor..white.."\nFuel: "..sColor2..math.floor(getElementData(jelen,"veh:uzemanyag"))..white.."%\nLicense plate number: "..sColor2..getVehiclePlateText(jelen)..white.."\nLamp: "..lampa..white.."\nDoor: "..ajto..white.."\nhand brake: "..kezifek..white,sx/2-w/2+200,sy/2-h/2+50+380,sx/2-w/2+200+w/3.3,sy/2-h/2+50+400+20,tocolor(255,255,255),1,font4,"left","center",false,false,false,true);
                
                local performance = getElementData(jelen,"tuning.performance") or fromJSON("[ [ 1, 1, 1, 1, 1, 1 ] ]");
                local airRide = red2.."None.";
                if getElementData(jelen,"tuning.airRide") or false then 
                    airRide = sColor2.."From!";
                end
                local lsdDoor = red2.."None.";
                if getElementData(jelen,"tuning.lsdDoor") or false then 
                    lsdDoor = sColor2.."Again!";
                end
                dxDrawText("Motor: "..sColor2..exports.fv_tuning:getPerformanceName(performance[1])..white.."\nbill: "..sColor2..exports.fv_tuning:getPerformanceName(performance[2])..white.."\nChip: "..sColor2..exports.fv_tuning:getPerformanceName(performance[3])..white.."\nBrakes: "..sColor2..exports.fv_tuning:getPerformanceName(performance[4])..white.."\nTires: "..sColor2..exports.fv_tuning:getPerformanceName(performance[5])..white.."\nTurbó: "..sColor2..exports.fv_tuning:getPerformanceName(performance[6])..white.."\nAir-Ride: "..airRide..white.."\nLSD Door: "..lsdDoor,sx/2-w/2+200,sy/2-h/2+50+380,sx/2-w/2+200+w/3.3,sy/2-h/2+50+400+20,tocolor(255,255,255),1,font4,"right","center",false,false,false,true);
            else
                dxDrawText("You don't have a vehicle.",sx/2-w/2+200,sy/2-h/2+50,sx/2-w/2+200+w/3.3,sy/2-h/2+50+h-150,tocolor(255,255,255),1,font,"center","center");
            end

            if exports.fv_engine:isInSlot(sx/2+170,sy/2-h/2+10,80,30) then
                if getKeyState("mouse1") and kTick+1000 < getTickCount() then 
                    if getElementData(localPlayer,"char >> premiumPoints") >= 200 then 
                        triggerServerEvent("dash > intSlotBuy",localPlayer,localPlayer);
                        kTick = getTickCount();
                    else 
                        exports.fv_infobox:addNotification("warning","You don't have enough bonuses to buy the slot! (200PP)");
                        kTick = getTickCount();
                    end
                end
                tooltip("200PP");
                dxDrawRectangle(sx/2+170,sy/2-h/2+10,80,30,tocolor(sColor[1],sColor[2],sColor[3],200))
            else
                dxDrawRectangle(sx/2+170,sy/2-h/2+10,80,30,tocolor(200,200,200,50))
            end
            exports.fv_engine:shadowedText("+ Slot",sx/2+170,sy/2-h/2+10,sx/2+170+80,sy/2-h/2+10+30,tocolor(255,255,255),1,font4,"center","center");

            if #playerInteriors > 0 then 
                dxDrawText("Name",sx/2+170,sy/2-h/2+50,sx/2+170+w/3.3-3,sy/2-h/2+50+20,tocolor(255,255,255),1,smallfont,"right","center");
                dxDrawText("ID",sx/2+170+3,sy/2-h/2+50,sx/2+170+w/3.3,sy/2-h/2+50+20,tocolor(255,255,255),1,smallfont,"left","center");
                for k=1,10 do 
                    local a = 50;
                    if k%2 == 0 then 
                        a = 80;
                    end 
                    dxDrawRectangle(sx/2+170,sy/2-h/2+50+(k*30),w/3.3,20,tocolor(200,200,200,a)); --Interior
                end
                local count = 0;
                for k,v in pairs(playerInteriors) do 
                    if k > iScroll and count < iMax then
                        count = count + 1;
                        iCount = count;
                        if getKeyState("mouse1") and kTick+500 < getTickCount() then 
                            if exports.fv_engine:isInSlot(sx/2+170,sy/2-h/2+50+(count*30),w/3.3,20) then 
                                if sInt ~= k then 
                                    sInt = k;
                                    kTick = getTickCount();
                                end
                            end
                        end
                        if sInt == k then 
                            dxDrawRectangle(sx/2+170,sy/2-h/2+50+(k*30),w/3.3,20,tocolor(sColor[1],sColor[2],sColor[3]));
                        end
                        exports.fv_engine:shadowedText(getElementData(v,"id"),sx/2+173,sy/2-h/2+50+(count*30),sx/2+170+w/3.3,sy/2-h/2+50+(count*30)+20,tocolor(255,255,255),1,smallfont,"left","center");
                        exports.fv_engine:shadowedText(getElementData(v,"name"),sx/2+170,sy/2-h/2+50+(count*30),sx/2+170+w/3.3-3,sy/2-h/2+50+(count*30)+20,tocolor(255,255,255),1,smallfont,"right","center");
                    end
                end
                local jelen = playerInteriors[sInt];
                if not isElement(jelen) then return end;
                local ajto = red2.."Open.";
                if (getElementData(jelen,"locked") or 0) == 1 then 
                    ajto = sColor2.."Closed.";
                end
                local gps = getZoneName(getElementPosition(jelen));
                dxDrawText("Type: "..sColor2..intTypes[getElementData(jelen,"type") or 1]..white.."\nDoor: "..ajto..white.."\nPosition: "..sColor2..gps,sx/2+170,sy/2-h/2+50+380,sx/2+170+w/3.3,sy/2-h/2+50+400+20,tocolor(255,255,255),1,font4,"left","center",false,false,false,true);
            else  
                dxDrawText("You don't have a property.",sx/2+170,sy/2-h/2+50,sx/2+170+w/3.3,sy/2-h/2+50+h-150,tocolor(255,255,255),1,font,"center","center");
            end
        end

        if tab == 3 then --FRAKCIÓ
            if #factions ~= 0 then
                for k=1,17 do 
                    local a = 50;
                    if k%2 == 0 then 
                        a = 80;
                    end 
                    dxDrawRectangle(sx/2-(w/2)+185,sy/2-h/2+(k*30)-15,w/4,20,tocolor(200,200,200,a));
                    if sFaction == k then 
                        dxDrawRectangle(sx/2-(w/2)+185,sy/2-h/2+(k*30)-15,w/4,20,tocolor(sColor[1],sColor[2],sColor[3],200));
                    end
                end
                for k,v in pairs(factions) do 
                    local fid,name,type,wallet,ranks = unpack(v);
                    exports.fv_engine:shadowedText(name,sx/2-(w/2)+185,sy/2-h/2+(k*30)-15,sx/2-(w/2)+185+w/4,sy/2-h/2+(k*30)-15+23,tocolor(255,255,255),1,smallfont,"center","center",false,false,false,true);
                end
                local current = factions[sFaction];

                dxDrawText(current[2],sx/2-w/2+185+w/4,sy/2-h/2,sx/2-w/2+185+w/4+w-180-w/4,20,tocolor(255,255,255),1,font,"center"); --Fraki név középen fent

                for k,v in pairs(factionMenu) do 
                    local text,icon = unpack(v);
                    local color = tocolor(255,255,255,100);
                    if sFmenu == k or exports.fv_engine:isInSlot(sx/2-w/2+185+w/4+30,sy/2-h/2+(k*30),180,27) then 
                        color = tocolor(sColor[1],sColor[2],sColor[3]);
                    end
                    dxDrawRectangle(sx/2-w/2+185+w/4+30,sy/2-h/2+(k*30),180,27,tocolor(200,200,200,50));
                    dxDrawText(text,sx/2-w/2+185+w/4+35,sy/2-h/2+(k*30),sx/2-w/2+185+w/4+30+175,sy/2-h/2+(k*30)+26,tocolor(255,255,255),1,smallfont,"left","center");
                    dxDrawText(icon,sx/2-w/2+185+w/4+30,sy/2-h/2+(k*30),sx/2-w/2+185+w/4+30+175,sy/2-h/2+(k*30)+26,color,1,icons,"right","center");
                end

                if sFmenu == 1 then 
                    local online,all = getFactionOnlineMembers(current[1]);
                    dxDrawText("Faction Data:\n\nID: "..sColor2..current[1]..white.."\nType: "..sColor2..ftypes[current[3]]..white.."\nBank Balance: "..sColor2..formatMoney(current[4])..white.."dt\nOnline members: "..sColor2..online..white.."/"..sColor2..all..white.."\nNumber of vehicles: "..sColor2..#factionVehicles[current[1]]..white.."\nLeader Message:\n"..sColor2..current[6],sx/2-w/2+185+w/4,sy/2-60,sx/2-w/2+185+w/4+w-180-w/4-10,sy/2-h/2+h,tocolor(255,255,255),1,font,"center","top",false,false,false,true);              
                    dxDrawImage(sx/2+w/2-120,sy/2-h/2+40,100,100,"faction/"..current[3]..".png",0,0,0,tocolor(255,255,255,100));        
                    dxDrawText(ftypes[current[3]],sx/2+w/2-120,sy/2-h/2+140,sx/2+w/2-120+100,100,tocolor(255,255,255),1,smallfont,"center");        
                elseif sFmenu == 2 then 
                    dxDrawText("Name",sx/2+w/2-210,sy/2-h/2+40,sx/2+w/2-210+200-5,0,tocolor(255,255,255,255),1,smallfont,"right");
                    dxDrawText("Online",sx/2+w/2-210,sy/2-h/2+40,sx/2+w/2-210+200-5,0,tocolor(255,255,255,255),1,smallfont,"left");
                    for k=1,15 do 
                        local color = tocolor(200,200,200,30);
                        dxDrawRectangle(sx/2+w/2-210,sy/2-h/2+35+(k*30),200,25,color);
                    end

                    local count = 0;
                    for k,v in pairs(factionMembers[current[1]]) do 
                        if k > vScroll and count < 15 then 
                            count = count + 1;
                            local online = "off";
                            if v[5] then 
                                online = "on";
                            end
                            if sFmember == k then 
                                dxDrawRectangle(sx/2+w/2-210,sy/2-h/2+35+(count*30),200,25,tocolor(sColor[1],sColor[2],sColor[3]));
                            end
                            if exports.fv_engine:isInSlot(sx/2+w/2-210,sy/2-h/2+35+(count*30),200,25) then 
                                if sFmember ~= k and getKeyState("mouse1") and kTick+500 < getTickCount() then 
                                    sFmember = k;
                                    kTick = getTickCount();
                                end
                            end
                            exports.fv_engine:shadowedText(v[6],sx/2+w/2-210,sy/2-h/2+35+(count*30),sx/2+w/2-210+200-5,sy/2-h/2+35+(count*30)+30,tocolor(255,255,255,255),1,smallfont,"right","center");
                            dxDrawImage(sx/2+w/2-205,sy/2-h/2+40+(count*30),15,15,online..".png");
                        end
                    end
                   local member = factionMembers[current[1]][sFmember];
                   local online = red2.."No.";
                   if member[5] then 
                        online = sColor2.."Yes.";
                   end
                   local leader = red2.."No.";
                   if member[3] == 1 then 
                        leader = sColor2.."Yes.";
                   end
                   local lastLogin = member[7];
                   if online == (sColor2.."Yes.") then 
                        lastLogin = "Currently Online!";
                   end
                   local dutyskin = member[4];
                   if dutyskin == 0 then 
                        dutyskin = red2.."Not set!";
                   end
                   dxDrawText(member[6].."\nOnline: "..online..white.."\nLast login: "..sColor2..lastLogin..white.."\nRank: "..sColor2..current[5][member[2]][1]..white.." ("..member[2]..")\nLeader: "..sColor2..leader..white.."\nDuty Skin: "..sColor2..dutyskin,sx/2-w/2+185+w/4,sy/2-60,sx/2-w/2+185+w/4+330,sy/2-60+300,tocolor(255,255,255),1,font4,"center","top",true,false,false,true);  
                   
                   --Leader cuccok
                    if getElementData(localPlayer,"faction_"..current[1].."_leader") then 
                        for k,v in pairs(leaderButtons) do 
                            local button,icon,color = unpack(v);
                            local a = 150;
                            if exports.fv_engine:isInSlot(sx/2-w/2+190+w/4,sy/2+40+(k*30),320,25) then 
                                a = 200;
                            end
                            dxDrawRectangle(sx/2-w/2+190+w/4,sy/2+40+(k*30),320,25,tocolor(color[1],color[2],color[3],a));
                            exports.fv_engine:shadowedText(button,sx/2-w/2+190+w/4+5,sy/2+40+(k*30),sx/2-w/2+190+w/4+315,sy/2+40+(k*30)+25,tocolor(255,255,255),1,smallfont,"left","center");
                            exports.fv_engine:shadowedText(icon,sx/2-w/2+190+w/4,sy/2+40+(k*30),sx/2-w/2+190+w/4+315,sy/2+40+(k*30)+25,tocolor(255,255,255),1,icons,"right","center");
                        end
                        local a = 150;
                        if exports.fv_engine:isInSlot(sx/2-w/2+190+w/4,sy/2+40+120,320,25) then 
                            a = 200;
                        end
                        if member[3] == 1 then --Leader Elvétel
                            dxDrawRectangle(sx/2-w/2+190+w/4,sy/2+40+120,320,25,tocolor(red[1],red[2],red[3],a));
                            exports.fv_engine:shadowedText("Leader takedown",sx/2-w/2+190+w/4+5,sy/2+40+120,sx/2-w/2+190+w/4+315,sy/2+40+120+25,tocolor(255,255,255),1,smallfont,"left","center");
                            exports.fv_engine:shadowedText("",sx/2-w/2+190+w/4,sy/2+40+120,sx/2-w/2+190+w/4+315,sy/2+40+120+25,tocolor(255,255,255),1,icons,"right","center");
                        else --Leader Adás
                            dxDrawRectangle(sx/2-w/2+190+w/4,sy/2+40+120,320,25,tocolor(sColor[1],sColor[2],sColor[3],a));
                            exports.fv_engine:shadowedText("Giving Leader",sx/2-w/2+190+w/4+5,sy/2+40+120,sx/2-w/2+190+w/4+315,sy/2+40+120+25,tocolor(255,255,255),1,smallfont,"left","center");
                            exports.fv_engine:shadowedText("",sx/2-w/2+190+w/4,sy/2+40+120,sx/2-w/2+190+w/4+315,sy/2+40+120+25,tocolor(255,255,255),1,icons,"right","center");
                        end
                        local a2 = 50;
                        if exports.fv_engine:isInSlot(sx/2-w/2+190+w/4+160/2,sy/2+40+175,160,25) then 
                            a2 = 100;
                        end
                        dxDrawRectangle(sx/2-w/2+190+w/4,sy/2+40+150,320,25,tocolor(200,200,200,50));
                        dxDrawRectangle(sx/2-w/2+190+w/4+160/2,sy/2+40+175,160,25,tocolor(200,200,200,a2));
                        exports.fv_engine:shadowedText("Add a member",sx/2-w/2+190+w/4+160/2,sy/2+40+175,sx/2-w/2+190+w/4+160/2+160,sy/2+40+175+25,tocolor(255,255,255),1,smallfont,"center","center");

                        if isElement(memberGUI) then 
                            guiSetPosition(memberGUI,sx/2-w/2+190+w/4,sy/2+40+150,false); --GUI JÓ HELYEN LEGYEN
                            exports.fv_engine:shadowedText(guiGetText(memberGUI),sx/2-w/2+190+w/4+3,sy/2+40+150,sx/2-w/2+190+w/4+320,sy/2+40+150+25,tocolor(255,255,255),0.94,"default-bold","left","center");
                        end
                    else 
                        if isElement(memberGUI) then 
                            destroyElement(memberGUI);
                        end
                    end
                elseif sFmenu == 3 then 
                    dxDrawText("Rank name",sx/2+w/2-210,sy/2-h/2+40,sx/2+w/2-210+200-5,0,tocolor(255,255,255,255),1,smallfont,"right");
                    dxDrawText("ID",sx/2+w/2-210,sy/2-h/2+40,sx/2+w/2-210+200-5,0,tocolor(255,255,255,255),1,smallfont,"left");
                    for k=1,15 do 
                        local color = tocolor(200,200,200,30);
                        if sFrank == k then 
                            color = tocolor(sColor[1],sColor[2],sColor[3]);
                        end
                        dxDrawRectangle(sx/2+w/2-210,sy/2-h/2+35+(k*30),200,25,color);
                    end
                    for k,v in pairs(current[5]) do 
                        local name,pay = unpack(v);
                        exports.fv_engine:shadowedText(name,sx/2+w/2-180,sy/2-h/2+35+(k*30),sx/2+w/2-210+195,sy/2-h/2+35+(k*30)+25,tocolor(255,255,255),1,smallfont,"right","center",true);
                        exports.fv_engine:shadowedText(k,sx/2+w/2-205,sy/2-h/2+35+(k*30),sx/2+w/2-210+195,sy/2-h/2+35+(k*30)+25,tocolor(255,255,255),1,smallfont,"left","center",true);
                    end
                    if getElementData(localPlayer,"faction_"..current[1].."_leader") then
                        local a,a1 = 50,50;
                        if exports.fv_engine:isInSlot(sx/2-w/2+190+w/4+160/2,sy/2+40+25,160,25) then 
                            a = 100;
                        end
                        if exports.fv_engine:isInSlot(sx/2-w/2+190+w/4+160/2,sy/2+140+25,160,25) then 
                            a1 = 100;
                        end
                        dxDrawRectangle(sx/2-w/2+190+w/4,sy/2+40,320,25,tocolor(200,200,200,50));
                        dxDrawRectangle(sx/2-w/2+190+w/4+160/2,sy/2+40+25,160,25,tocolor(200,200,200,a));
                        exports.fv_engine:shadowedText("Rank Save Name",sx/2-w/2+190+w/4+160/2,sy/2+40+25,sx/2-w/2+190+w/4+160/2+160,sy/2+40+25+25,tocolor(255,255,255),1,smallfont,"center","center");
                        if isElement(rankGUI) then 
                            guiSetPosition(rankGUI,sx/2-w/2+190+w/4,sy/2+40,false);
                            exports.fv_engine:shadowedText(guiGetText(rankGUI),sx/2-w/2+190+w/4+3,sy/2+40,sx/2-w/2+190+w/4+320,sy/2+40+25,tocolor(255,255,255),0.94,"default-bold","left","center");
                        end
                        if current[3] > 2 then --Ha legál
                            dxDrawRectangle(sx/2-w/2+190+w/4,sy/2+40+100,320,25,tocolor(200,200,200,50));
                            dxDrawRectangle(sx/2-w/2+190+w/4+160/2,sy/2+140+25,160,25,tocolor(200,200,200,a1));
                            exports.fv_engine:shadowedText("Rank Save payment",sx/2-w/2+190+w/4+160/2,sy/2+140+25,sx/2-w/2+190+w/4+160/2+160,sy/2+140+25+25,tocolor(255,255,255),1,smallfont,"center","center");
                            if isElement(rankGUI2) then 
                                local value = tonumber(guiGetText(rankGUI2))
                                if not value or value < 0 then 
                                    guiSetText(rankGUI2,"");
                                end
                                if value > 30000 then
                                    guiSetText(rankGUI2,"30000");
                                end
                                guiSetPosition(rankGUI2,sx/2-w/2+190+w/4,sy/2+40+100,false);
                                exports.fv_engine:shadowedText(formatMoney(tonumber(guiGetText(rankGUI2))),sx/2-w/2+190+w/4+3,sy/2+40+100,sx/2-w/2+190+w/4+320,sy/2+40+100+25,tocolor(255,255,255),0.94,"default-bold","left","center");
                            end
                        else 
                            if isElement(rankGUI2) then 
                                destroyElement(rankGUI2);
                            end
                        end
                    else 
                        if isElement(rankGUI) then 
                            destroyElement(rankGUI);
                        end
                        if isElement(rankGUI2) then 
                            destroyElement(rankGUI2);
                        end
                    end
                elseif sFmenu == 4 then 
                    if #factionVehicles[current[1]] > 0 then 
                        dxDrawText("Vehicle",sx/2+w/2-210,sy/2-h/2+40,sx/2+w/2-210+200-5,0,tocolor(255,255,255,255),1,smallfont,"right");
                        dxDrawText("ID",sx/2+w/2-210,sy/2-h/2+40,sx/2+w/2-210+200-5,0,tocolor(255,255,255,255),1,smallfont,"left");

                        for k=1,15 do 
                            local color = tocolor(200,200,200,30);
                            dxDrawRectangle(sx/2+w/2-210,sy/2-h/2+35+(k*30),200,25,color);
                        end
                        local count = 0;
                        --sFveh = k;
                        for k,v in pairs(factionVehicles[current[1]]) do 
                            if k > vScroll and count < 15 then 
                                count = count + 1;
                                if exports.fv_engine:isInSlot(sx/2+w/2-210,sy/2-h/2+35+(count*30),200,25) and getKeyState("mouse1") and kTick+500 < getTickCount() then 
                                    if sFveh ~= k then 
                                        sFveh = k;
                                        kTick = getTickCount();
                                    end
                                end
                                if sFveh == k then 
                                    dxDrawRectangle(sx/2+w/2-210,sy/2-h/2+35+(count*30),200,25,tocolor(sColor[1],sColor[2],sColor[3]));
                                end
                                exports.fv_engine:shadowedText(exports.fv_vehmods:getVehicleRealName(v) or getVehicleNameFromModel(getElementModel(v)),sx/2+w/2-180,sy/2-h/2+35+(count*30),sx/2+w/2-210+195,sy/2-h/2+35+(count*30)+25,tocolor(255,255,255),1,smallfont,"right","center",true);
                                exports.fv_engine:shadowedText(getElementData(v,"veh:id"),sx/2+w/2-205,sy/2-h/2+35+(count*30),sx/2+w/2-210+195,sy/2-h/2+35+(count*30)+25,tocolor(255,255,255),1,smallfont,"left","center",true);
                            end
                        end
                        local veh = factionVehicles[current[1]][sFveh];
                        local motor = red2.."stopped.";
                        local lampa = red2.."disconnected.";
                        local zar = red2.."Closed.";
                        local kezifek = red2.."released.";
                        if getVehicleEngineState(veh) then  
                            motor = sColor2.."Started.";
                        end
                        if getVehicleOverrideLights(veh) > 0 then 
                            lampa = sColor2.."flipping.";
                        end
                        if not isVehicleLocked(veh) then 
                            zar = sColor2.."Open.";
                        end
                        if isElementFrozen(veh) then 
                            kezifek = sColor2.."retracted.";
                        end
                        local zone = getZoneName(getElementPosition(veh));

                        local performance = getElementData(veh,"tuning.performance") or fromJSON("[ [ 1, 1, 1, 1, 1, 1 ] ]");
                        local airRide = red2.."None.";
                        if getElementData(veh,"tuning.airRide") or false then 
                            airRide = sColor2.."From!";
                        end
                        local lsdDoor = red2.."None.";
                        if getElementData(veh,"tuning.lsdDoor") or false then 
                            lsdDoor = sColor2.."Again!";
                        end

                        dxDrawText((exports.fv_vehmods:getVehicleRealName(veh) or getVehicleNameFromModel(getElementModel(veh))),sx/2-w/2+185+w/4,sy/2-60,sx/2-w/2+185+w/4+330,sy/2-60+300,tocolor(255,255,255),1,font4,"center","top",true,false,false,true);  
                        dxDrawText("\nID: "..sColor2..getElementData(veh,"veh:id")..white.."\nPosition: "..sColor2..zone..white.."\n\nCondition: "..sColor2..math.floor(getElementHealth(veh)/10)..white.."%\nFuel: "..sColor2..getElementData(veh,"veh:uzemanyag")..white.."%\n\nLicense plate number: "..sColor2..getVehiclePlateText(veh)..white.."\n\nMotor: "..sColor2..motor..white.."\nLámpa: "..sColor2..lampa..white.."\nDoors: "..sColor2..zar..white.."\nHand brake: "..kezifek..white.."\n\nDimension: "..sColor2..getElementDimension(veh)..white.."\nInterior: "..sColor2..getElementInterior(veh),sx/2-w/2+195+w/4,sy/2-60,sx/2-w/2+185+w/4+330,sy/2-60+300,tocolor(255,255,255),1,font4,"left","top",true,false,false,true);  
                        dxDrawText("\nMotor: "..sColor2..exports.fv_tuning:getPerformanceName(performance[1])..white.."\nVáltó: "..sColor2..exports.fv_tuning:getPerformanceName(performance[2])..white.."\nChip: "..sColor2..exports.fv_tuning:getPerformanceName(performance[3])..white.."\nBrakes: "..sColor2..exports.fv_tuning:getPerformanceName(performance[4])..white.."\nTires: "..sColor2..exports.fv_tuning:getPerformanceName(performance[5])..white.."\nTurbo: "..sColor2..exports.fv_tuning:getPerformanceName(performance[6])..white.."\nAir-Ride: "..airRide..white.."\nLSD Door: "..lsdDoor,sx/2-w/2+185+w/4,sy/2-60,sx/2-w/2+185+w/4+320,sy/2-60+300,tocolor(255,255,255),1,font4,"right","top",true,false,false,true);  
                    else
                        dxDrawText("Faction has no vehicles!",sx/2-w/2+185+w/4,sy/2-60,sx/2-w/2+185+w/4+w-180-w/4-10,sy/2-h/2+h,tocolor(255,255,255),1,font,"center","center",false,false,false,true);              
                    end
                elseif sFmenu == 5 then 
                    dxDrawImage(sx/2+w/2-120,sy/2-h/2+40,100,100,"faction/"..current[3]..".png",0,0,0,tocolor(255,255,255,100));        
                    dxDrawText(ftypes[current[3]],sx/2+w/2-120,sy/2-h/2+140,sx/2+w/2-120+100,100,tocolor(255,255,255),1,smallfont,"center");     

                    if getElementData(localPlayer,"faction_"..current[1].."_leader") then 
                        dxDrawText("Edit Leader Message",sx/2-w/2+185+w/4,sy/2-60,sx/2-w/2+185+w/4+520,sy/2-h/2+h,tocolor(255,255,255),1,smallfont,"center","top",false,false,false,true);              
                        dxDrawRectangle(sx/2-w/2+185+w/4+10,sy/2-20,520,150,tocolor(200,200,200,60));

                        dxDrawText(guiGetText(leaderM),sx/2-w/2+185+w/4+13,sy/2-13,sx/2-w/2+185+w/4+10+520,sy/2-20+150,tocolor(255,255,255),0.93,"default-bold","left","top",false,true,false,false);

                        if string.len(guiGetText(leaderM)) > 200 then 
                            guiSetText(leaderM,"");
                        end

                        if exports.fv_engine:isInSlot(sx/2-w/2+185+w/4+10,sy/2+160,520,25) then
                            if getKeyState("mouse1") and kTick+300 < getTickCount() then
                                local text = guiGetText(leaderM);
                                if text ~= "" or text ~= " " then 
                                    triggerServerEvent("dash > updateLeaderSay",localPlayer,localPlayer,current[1],text)
                                    current[6] = text;
                                end
                                kTick = getTickCount();
                            end
                            dxDrawRectangle(sx/2-w/2+185+w/4+10,sy/2+160,520,25,tocolor(sColor[1],sColor[2],sColor[3]));
                        else
                            dxDrawRectangle(sx/2-w/2+185+w/4+10,sy/2+160,520,25,tocolor(200,200,200,60));
                        end
                        exports.fv_engine:shadowedText("Setting",sx/2-w/2+185+w/4+10,sy/2+160,sx/2-w/2+185+w/4+10+520,sy/2+160+25,tocolor(255,255,255),1,smallfont,"center","center");

                    else 
                        dxDrawText("Leader A message can only be edited by a leader!",sx/2-w/2+185+w/4,sy/2-60,sx/2-w/2+185+w/4+w-180-w/4-10,sy/2-h/2+h,tocolor(255,255,255),1,smallfont,"center","top",false,false,false,true);   
                        if isElement(leaderM) then 
                            destroyElement(leaderM);
                        end
                    end
                    if factions[sFaction][3] and factions[sFaction][3] > 2 then --Csak legál
                        if exports.fv_engine:isInSlot(sx/2-w/2+185+w/4+10,sy/2+230,520,25) then 
                            if getKeyState("mouse1") and kTick+300 < getTickCount() then
                                if getElementDimension(localPlayer) == 2 and getElementInterior(localPlayer) == 15 then 
                                    exports.fv_duty:setDutySkin(current[1]);
                                    tick = getTickCount();
                                    panelstate = "close";
                                    if skinPreview and skinPreview[1] and isElement(skinPreview[1]) then 
                                        exports.fv_op:destroyObjectPreview(skinPreview[2]);
                                        destroyElement(skinPreview[1]);
                                        skinPreview = {};
                                    end
                                else 
                                    exports.fv_infobox:addNotification("error","You're not in the binco!");
                                end
                                kTick = getTickCount();
                            end
                            dxDrawRectangle(sx/2-w/2+185+w/4+10,sy/2+230,520,25,tocolor(sColor[1],sColor[2],sColor[3]));
                        else 
                            dxDrawRectangle(sx/2-w/2+185+w/4+10,sy/2+230,520,25,tocolor(200,200,200,60));
                        end
                        exports.fv_engine:shadowedText("Duty Skin Setting",sx/2-w/2+185+w/4+10,sy/2+230,sx/2-w/2+185+w/4+10+520,sy/2+230+25,tocolor(255,255,255),1,smallfont,"center","center");
                    end
                end
            else
                dxDrawText("You do not belong to a faction!",sx/2-w/2+185,sy/2-h/2,sx/2-w/2+185+w-180,sy/2-h/2+h,tocolor(255,255,255),1,font,"center","center");
            end
        end

        if tab == 4 then 
            for k,v in pairs(admins) do
                local a = 50;
                if k%2 == 0 then 
                    a = 80;
                end 
                if exports.fv_engine:isInSlot(sx/2-(w/2)+180+10,sy/2-h/2+(k*40)-30,w/3,30) or k == selectedAdmin then
                    dxDrawRectangle(sx/2-(w/2)+180+10,sy/2-h/2+(k*40)-15,w/3,30,tocolor(sColor[1],sColor[2],sColor[3],100));
                else
                    dxDrawRectangle(sx/2-(w/2)+180+10,sy/2-h/2+(k*40)-15,w/3,30,tocolor(200,200,200,a));
                end
                dxDrawText(adminTitles[k],sx/2-(w/2)+10+180,sy/2-h/2+(k*40)-15,sx/2-(w/2)+10+180+w/3,sy/2-h/2+(k*40)-15+30,tocolor(255,255,255),1,font,"center","center");
            end
            if #admins[selectedAdmin] > 0 then
                for k=0,16 do 
                    local a = 50;
                    if k%2 == 0 then 
                        a = 80;
                    end 
                    dxDrawRectangle(sx/2+(w/2)-w/3.3-10,sy/2-h/2+(k*30)+10,w/3.3,20,tocolor(200,200,200,a));
                end

                for k,v in pairs(admins[selectedAdmin]) do 
                    local k = k - 1;
                    local image = "off";
                    if getElementData(v,"admin >> duty") then
                        image = "on";
                    end
                    if selectedAdmin == 1 or selectedAdmin == 2 then
                        image = "on";
                        dxDrawText(getElementData(v,"char >> name"),sx/2+(w/2)-w/3.3-10,sy/2-h/2+(k*30)+10,sx/2+(w/2)-w/3.3-10+w/3.3,sy/2-h/2+(k*30)+10+23,tocolor(255,255,255),1,font3,"center","center");
                    else
                        dxDrawText(getElementData(v,"admin >> name"),sx/2+(w/2)-w/3.3-10,sy/2-h/2+(k*30)+10,sx/2+(w/2)-w/3.3-10+w/3.3,sy/2-h/2+(k*30)+10+23,tocolor(255,255,255),1,font3,"center","center");
                    end
                    dxDrawImage(sx/2+(w/2)-w/3.3+w/3.3-30,sy/2-h/2+(k*30)+12,15,15,image..".png");
                    if image == "on" then 
                        dxDrawText(sColor2.."ID: "..getElementData(v,"char >> id"),sx/2+(w/2)-w/3.3-5,sy/2-h/2+(k*30)+10,sx/2+(w/2)-w/3.3-10+w/3.3,sy/2-h/2+(k*30)+10+20,tocolor(255,255,255),1,font3,"left","center",false,false,false,true);
                    end
                end
            else 
                dxDrawText("There is no admin available.",sx/2+(w/2)-w/2-10,sy/2-h/2,sx/2+(w/2)-w/2-10+w/2+160,sy/2-h/2+h,tocolor(255,255,255),1,font,"center","center");
            end
            local sizeX,sizeY = 771/7,1124/7
            dxDrawImage(sx/2+105-sizeX/2,sy/2-sizeY/2,sizeX,sizeY,"icon.png")
        end

        if tab == 5 then
            for k,v in pairs(ppPacks) do 
                local name,realMoney,PP,number = unpack(v);
                dxDrawText(name,sx/2-w/2+180+(k*w/5),sy/2-h/2+200,sx/2-w/2-315+(k*w/5)+300,0,tocolor(255,255,255),1.3,font2,"center","top",false,false,false,true);
                dxDrawText("Phone call: "..sColor2..number..white.."\nSMS text: "..sColor2.." TheDevils "..(getElementData(localPlayer,"acc >> id")),sx/2-w/2+180+(k*w/5),sy/2-h/2+250,sx/2-w/2-315+(k*w/5)+300,0,tocolor(255,255,255),0.6,exports.fv_engine:getFont("rage",18),"center","top",false,false,false,true);
                dxDrawText("Package Price:\n"..sColor2..formatMoney(realMoney)..white.." Ft\nCredited PP quantity:\n"..sColor2..formatMoney(PP)..white.." PP",sx/2-w/2+180+(k*w/5),sy/2-h/2+300,sx/2-w/2-315+(k*w/5)+300,0,tocolor(255,255,255),0.6,font2,"center","top",false,false,false,true);
            end

            --IDG
            -- dxDrawText("Támogatás jelenleg:\nTeamSpeak 3 szerveren lehetséges (Nevils váró)\nts.socialgaming.hu",sx/2-w/2+185,sy/2-h/2,sx/2-w/2+185+w-180,sy/2-h/2+h,tocolor(255,255,255),1,exports.fv_engine:getFont("rage",16),"center","center");

            dxDrawText("The grant does not entitle you to disregard the rules!\nWe are not responsible for prescribed SMS.",sx/2-w/2+180,sy/2-h/2,sx/2-w/2+w,sy/2-h/2+h,tocolor(255,255,255),1,"default-bold","center","bottom");
        end

        if tab == 6 then 
            for k,v in pairs(shaders) do 
                local a = 200;
                local name,state = unpack(v);
                if exports.fv_engine:isInSlot(sx/2-(w/3)/2+60,sy/2-h/2+(k*40),w/3,30) then 
                    a = 250;
                end
                if state then
                    dxDrawRectangle(sx/2-(w/3)/2+60,sy/2-h/2+(k*40),w/3,30,tocolor(sColor[1],sColor[2],sColor[3],a));
                else
                    dxDrawRectangle(sx/2-(w/3)/2+60,sy/2-h/2+(k*40),w/3,30,tocolor(red[1],red[2],red[3],a));
                end
                exports.fv_engine:shadowedText(name,sx/2-(w/3)/2+60,sy/2-h/2+(k*40),sx/2-(w/3)/2+w/3+60,sy/2-h/2+(k*40)+30,tocolor(255,255,255),1,font,"center","center");
            end

            local walkColor = tocolor(0,0,0,100);
            if exports.fv_engine:isInSlot(sx/2-(w/3)/2+60,sy/2,w/3,40) then 
                walkColor = tocolor(0,0,0,200);
                if getKeyState("mouse1") and kTick+500 < getTickCount() then 
                    if walkStyle+1 > #walkStyles then 
                        walkStyle = 1;
                    else 
                        walkStyle = walkStyle + 1;
                    end
                    triggerServerEvent("dash > walkStyle",localPlayer,localPlayer,walkStyles[walkStyle][1]);
                    kTick = getTickCount();
                end
            end
            dxDrawRectangle(sx/2-(w/3)/2+60,sy/2,w/3,40,walkColor);

            if walkStyles[walkStyle] and walkStyles[walkStyle][2] then 
                dxDrawText("Walking Style: "..sColor2..walkStyles[walkStyle][2],sx/2-(w/3)/2+60,sy/2,sx/2-(w/3)/2+60+w/3,sy/2+40,tocolor(255,255,255),1,font2,"center","center",false,false,false,true);
            else 
                walkStyle = 1;
            end

            dxDrawImage(sx/2+20,sy/2+80,40,40,"crosshairs/"..crosshair..".png");
            dxDrawImage(sx/2+60,sy/2+80,40,40,"crosshairs/"..crosshair..".png",90);
            dxDrawImage(sx/2+20,sy/2+120,40,40,"crosshairs/"..crosshair..".png",-90);
            dxDrawImage(sx/2+60,sy/2+120,40,40,"crosshairs/"..crosshair..".png",180);

            dxDrawRectangle(sx/2-30,sy/2+100,40,40,tocolor(0,0,0,100));
            local leftColor = tocolor(255,255,255,150);
            if exports.fv_engine:isInSlot(sx/2-30,sy/2+100,40,40) then 
                leftColor = tocolor(sColor[1],sColor[2],sColor[3],250);
                if getKeyState("mouse1") and kTick+500 < getTickCount() then 
                    if crosshair-1 <= 0 then 
                        crosshair = crosshairCount;
                    else 
                        crosshair = crosshair - 1;
                    end
                    loadCrosshair();
                    kTick = getTickCount();
                end
            end
            dxDrawText("",sx/2-30,sy/2+100,sx/2-30+40,sy/2+100+40,leftColor,1,exports.fv_engine:getFont("AwesomeFont",15),"center","center");

            dxDrawRectangle(sx/2+110,sy/2+100,40,40,tocolor(0,0,0,100));
            local rightColor = tocolor(255,255,255,150);
            if exports.fv_engine:isInSlot(sx/2+110,sy/2+100,40,40) then 
                rightColor = tocolor(sColor[1],sColor[2],sColor[3],250);
                if getKeyState("mouse1") and kTick+500 < getTickCount() then 
                    if crosshair+1 > crosshairCount then 
                        crosshair = 1;
                    else 
                        crosshair = crosshair + 1;
                    end
                    loadCrosshair();
                    kTick = getTickCount();
                end
            end
            dxDrawText("",sx/2+110,sy/2+100,sx/2+110+40,sy/2+100+40,rightColor,1,exports.fv_engine:getFont("AwesomeFont",15),"center","center");
        end
    end
end

function loadCrosshair()
    local shader = dxCreateShader("shader.fx");
    local texture = dxCreateTexture("crosshairs/"..crosshair..".png");
    dxSetShaderValue(shader, "reTexture", texture);
    engineApplyShaderToWorldTexture(shader, "sitem16");
end


addCommandHandler("admins",function(command)
    if not getElementData(localPlayer,"loggedIn") then return end;
    if tab == 0 then 
        panelstate = "open";
        w,h = 0,0;
        tick = getTickCount();
        addEventHandler("onClientRender",root,drawDash);
        showChat(false);
        tab = 4;
        getAdmins();
        triggerServerEvent("dash > getFactions",localPlayer,localPlayer);
        playerInteriors = {};
        playerVehicles = {};
        sVeh = 1;
        sInt = 1;
        for k,v in pairs(getElementsByType("marker")) do 
            if getElementData(v,"id") and not getElementData(v,"outElement") then 
                if getElementData(v,"owner") == getElementData(localPlayer,"acc >> id") then
                    playerInteriors[#playerInteriors + 1] = v;
                end
            end
        end
        for k,v in pairs(getElementsByType("vehicle")) do 
            if getElementData(v,"veh:id") then 
                if getElementData(v,"veh:faction") == 0 then
                    if getElementData(v,"veh:tulajdonos") == getElementData(localPlayer,"acc >> id") then 
                        playerVehicles[#playerVehicles + 1] = v;
                    end
                end
            end
        end
        playSound("open.mp3",false);
        setElementData(localPlayer,"togHUD",false);
        showCursor(true);
    else
        tick = getTickCount();
        panelstate = "close";
        showCursor(false);
        if skinPreview and skinPreview[1] and isElement(skinPreview[1]) then 
            exports.fv_op:destroyObjectPreview(skinPreview[2]);
            destroyElement(skinPreview[1]);
            skinPreview = {};
        end
    end
end);

addEventHandler("onClientKey",root,function(button,state)
    if not getElementData(localPlayer,"loggedIn") then return end;
    if button == "F3" and state then 
        if lastKey+1000 > getTickCount() then 
            exports.fv_infobox:addNotification("error", "You can't use it so fast!");
            cancelEvent();
            return;
        end;
        if tab == 0 then 
            panelstate = "open";
            w,h = 0,0;
            tick = getTickCount();
            addEventHandler("onClientRender",root,drawDash);
            showChat(false);
            getAdmins();
            triggerServerEvent("dash > getFactions",localPlayer,localPlayer);
            playerInteriors = {};
            playerVehicles = {};
            sVeh = 1;
            sInt = 1;
            for k,v in pairs(getElementsByType("marker")) do 
                if getElementData(v,"id") and not getElementData(v,"outElement") then 
                    if getElementData(v,"owner") == getElementData(localPlayer,"acc >> id") then
                        playerInteriors[#playerInteriors + 1] = v;
                    end
                end
            end
            for k,v in pairs(getElementsByType("vehicle")) do 
                if getElementData(v,"veh:id") then 
                    if getElementData(v,"veh:faction") == 0 then
                        if getElementData(v,"veh:tulajdonos") == getElementData(localPlayer,"acc >> id") then 
                            playerVehicles[#playerVehicles + 1] = v;
                        end
                    end
                end
            end
            tab = 3;
            playSound("open.mp3",false);
            setElementData(localPlayer,"togHUD",false);
            showCursor(true);
        else 
            tick = getTickCount();
            panelstate = "close";
            if skinPreview and skinPreview[1] and isElement(skinPreview[1]) then 
                exports.fv_op:destroyObjectPreview(skinPreview[2]);
                destroyElement(skinPreview[1]);
                skinPreview = {};
            end
            showCursor(false);
        end
        lastKey = getTickCount();
    end
end);


addEventHandler("onClientKey",root,function(button,state)
if not getElementData(localPlayer,"loggedIn") then return end;
    if button == "home" and state then 
        if lastKey+1000 > getTickCount() then 
            exports.fv_infobox:addNotification("error", "You can't use it so fast!");
            cancelEvent();
            return;
        end;
        if tab == 0 then 
            panelstate = "open";
            w,h = 0,0;
            tick = getTickCount();
            tab = 1; 
            addEventHandler("onClientRender",root,drawDash);
            showChat(false);
            getAdmins();
            triggerServerEvent("dash > getFactions",localPlayer,localPlayer);
            playerInteriors = {};
            playerVehicles = {};
            sVeh = 1;
            sInt = 1;
            for k,v in pairs(getElementsByType("marker")) do 
                if getElementData(v,"id") and not getElementData(v,"outElement") then 
                    if getElementData(v,"owner") == getElementData(localPlayer,"acc >> id") then
                        playerInteriors[#playerInteriors + 1] = v;
                    end
                end
            end
            for k,v in pairs(getElementsByType("vehicle")) do 
                if getElementData(v,"veh:id") then 
                    if getElementData(v,"veh:faction") == 0 then
                        if getElementData(v,"veh:tulajdonos") == getElementData(localPlayer,"acc >> id") then 
                            playerVehicles[#playerVehicles + 1] = v;
                        end
                    end
                end
            end
            playSound("open.mp3",false);
            setElementData(localPlayer,"togHUD",false);
            showCursor(true);
            if skinPreview and skinPreview[1] and isElement(skinPreview[1]) then 
                exports.fv_op:destroyObjectPreview(skinPreview[2]);
                destroyElement(skinPreview[1]);
                skinPreview = {};
            end

            setTimer(function()
                local temp = createPed(getElementModel(localPlayer),0,0,0);
                setElementInterior(temp,getElementInterior(localPlayer));
                setElementDimension(temp,getElementDimension(localPlayer));
                setElementCollisionsEnabled(temp,false);
                setElementData(temp,"ped >> noName",true);
                local preview = exports.fv_op:createObjectPreview(temp,0,0,140,0,0,sx,sy,false,true);
                exports.fv_op:setPositionOffsets(preview,1,2,0);
                skinPreview[1] = temp;
                skinPreview[2] = preview;
            end,200,1);

        elseif tab > 0 then 
            tick = getTickCount();
            panelstate = "close";
            if skinPreview and skinPreview[1] and isElement(skinPreview[1]) then 
                destroyElement(skinPreview[1]);
                exports.fv_op:destroyObjectPreview(skinPreview[2]);
                skinPreview = {};
            end
            showCursor(false);
        end
        lastKey = getTickCount();

        if tab == 3 then
            if sFmenu == 2 then 
                memberGUI = guiCreateEdit(sx/2-w/2+190+w/4,sy/2+40+150,320,25,"Name/ID",false);
                guiSetAlpha(memberGUI,0);
            elseif sFmenu == 3 then 
                if isElement(rankGUI) then 
                    destroyElement(rankGUI);
                end
                if isElement(rankGUI2) then 
                    destroyElement(rankGUI2);
                end
                local f = factions[sFaction][5][sFrank];
                rankGUI = guiCreateEdit(sx/2-w/2+190+w/4,sy/2+40,320,25,f[1],false);
                guiSetAlpha(rankGUI,0);
                rankGUI2 = guiCreateEdit(sx/2-w/2+190+w/4,sy/2+40+100,320,25,f[2],false);
                guiSetAlpha(rankGUI2,0);
            end
        end
        cancelEvent();
    end 

    if button == "mouse1" and state then 
        if tab > 0 and w > 400 then 
            for k,v in pairs(tabs) do 
                if exports.fv_engine:isInSlot(sx/2-w/2+10,sy/2-50+(k*45),160,40) then
                    if changeMenu+500 > getTickCount() then exports.fv_infobox:addNotification("warning","Slower") return end;
                    if k ~= tab then 
                        tab = k;
                        sVeh = 1;
                        sInt = 1;
                        vScroll = 0;
                    end
                    if skinPreview and skinPreview[1] and isElement(skinPreview[1]) then 
                        exports.fv_op:destroyObjectPreview(skinPreview[2]);
                        destroyElement(skinPreview[1]);
                        skinPreview = {};
                    end
                    if tab == 1 then 
                        setTimer(function()
                            local temp = createPed(getElementModel(localPlayer),0,0,0);
                            setElementInterior(temp,getElementInterior(localPlayer));
                            setElementDimension(temp,getElementDimension(localPlayer));
                            setElementCollisionsEnabled(temp,false);
                            setElementData(temp,"ped >> noName",true);
                            local preview = exports.fv_op:createObjectPreview(temp,0,0,140,0,0,sx,sy,false,true);
                            exports.fv_op:setPositionOffsets(preview,1,2,0);
                            skinPreview[1] = temp;
                            skinPreview[2] = preview;
                        end,200,1);
                    end
                    changeMenu = getTickCount();
                end 
            end
            if tab == 3 then 
                for k=1,17 do 
                    if exports.fv_engine:isInSlot(sx/2-(w/2)+185,sy/2-h/2+(k*30)-15,w/4,20) then 
                        if sFaction ~= k then 
                            sFaction = k;
                            sFmenu = 1;
                            sFmember = 1;
                            sFrank = 1;
                            sFveh = 1;
                            vScroll = 0;
                        end
                   end
                end
                for k,v in pairs(factionMenu) do --Fraki menüje.
                    if exports.fv_engine:isInSlot(sx/2-w/2+185+w/4+30,sy/2-h/2+(k*30),180,27) then 
                        if sFmenu ~= k then 
                            sFmenu = k;
                            vScroll = 0;
                            if sFmenu == 2 then 
                                if isElement(memberGUI) then 
                                    destroyElement(memberGUI);
                                end
                                memberGUI = guiCreateEdit(sx/2-w/2+190+w/4,sy/2+40+150,320,25,"Name/ID",false);
                                guiSetAlpha(memberGUI,0);
                            else 
                                if isElement(memberGUI) then 
                                    destroyElement(memberGUI);
                                end
                            end

                            if sFmenu == 3 then 
                                if isElement(rankGUI) then 
                                    destroyElement(rankGUI);
                                end
                                if isElement(rankGUI2) then 
                                    destroyElement(rankGUI2);
                                end
                                local f = factions[sFaction][5][sFrank];
                                rankGUI = guiCreateEdit(sx/2-w/2+190+w/4,sy/2+40,320,25,f[1],false);
                                guiSetAlpha(rankGUI,0);
                                rankGUI2 = guiCreateEdit(sx/2-w/2+190+w/4,sy/2+40+100,320,25,f[2],false);
                                guiSetAlpha(rankGUI2,0);
                            else 
                                if isElement(rankGUI) then 
                                    destroyElement(rankGUI);
                                end
                                if isElement(rankGUI2) then 
                                    destroyElement(rankGUI2);
                                end
                            end

                            if sFmenu == 5 then 
                                if isElement(leaderM) then 
                                    destroyElement(leaderM);
                                end
                                local f = factions[sFaction][6];
                                leaderM = guiCreateMemo(sx/2-w/2+185+w/4+10,sy/2-20,520,150,f,false);
                                guiSetAlpha(leaderM,0);
                            else 
                                if isElement(leaderM) then 
                                    destroyElement(leaderM);
                                end
                            end
                        end
                    end
                end
                if sFmenu == 2 then 
                    if factions and factions[sFaction] and getElementData(localPlayer,"faction_"..factions[sFaction][1].."_leader") then --Leader Gombok
                        local current = factions[sFaction][1];
                        for k,v in pairs(leaderButtons) do 
                            if exports.fv_engine:isInSlot(sx/2-w/2+190+w/4,sy/2+40+(k*30),320,25) then 
                                local rank = factionMembers[current][sFmember][2];
                                if k == 1 then --Rang Emelés
                                    if rank+1 > 15 then 
                                        exports.fv_infobox:addNotification("error", "Player is in the highest rank!");
                                    else 
                                        factionMembers[current][sFmember][2] = rank+1;
                                        triggerServerEvent("dash > playerRankChange",localPlayer,localPlayer,current,factionMembers[current][sFmember]);
                                    end
                                elseif k == 2 then --Rang Csökkentés
                                    if rank-1 <= 0 then
                                        exports.fv_infobox:addNotification("error", "Player is in the lowest rank!");
                                    else
                                        factionMembers[current][sFmember][2] = rank-1;
                                        triggerServerEvent("dash > playerRankChange",localPlayer,localPlayer,current,factionMembers[current][sFmember]);
                                    end
                                elseif k == 3 then --Kirúgás
                                    if factionMembers[current][sFmember][1] == getElementData(localPlayer,"acc >> id") then exports.fv_infobox:addNotification("error", "You can't fire yourself!") return end;
                                    triggerServerEvent("dash > kickPlayer",localPlayer,localPlayer,current,factionMembers[current][sFmember]);
                                    sFmember = 1;
                                end
                            end
                        end
                        if exports.fv_engine:isInSlot(sx/2-w/2+190+w/4,sy/2+40+120,320,25) then --Leader adás/elvétel.
                            local member = factionMembers[current][sFmember];
                            if member[3] == 1 then --Leader elvétel
                                if member[1] == getElementData(localPlayer,"acc >> id") then exports.fv_infobox:addNotification("error", "You can't fire yourself!") return end;
                                triggerServerEvent("dash > setLeaderState",localPlayer,localPlayer,0,current,member);
                            else --Leader adás
                                triggerServerEvent("dash > setLeaderState",localPlayer,localPlayer,1,current,member); 
                            end
                        end
                        if exports.fv_engine:isInSlot(sx/2-w/2+190+w/4+160/2,sy/2+40+175,160,25) then --Tag felvétele.
                            if isElement(memberGUI) then 
                                local text = guiGetText(memberGUI);
                                if text ~= "" or text ~= " " then 
                                    triggerServerEvent("dash > addNewMember",localPlayer,localPlayer,current,text);
                                end
                            end
                        end
                    end
                end
                if factions[sFaction] and getElementData(localPlayer,"faction_"..factions[sFaction][1].."_leader") then --Rang kezelés csak leadernek!
                    local current = factions[sFaction][1];
                    if sFmenu == 3 then 
                        for k=1,15 do --Rang választás
                            if exports.fv_engine:isInSlot(sx/2+w/2-210,sy/2-h/2+35+(k*30),200,25) then 
                                if k ~= sFrank then 
                                    sFrank = k;
                                    if isElement(rankGUI) then 
                                        guiSetText(rankGUI,factions[sFaction][5][sFrank][1]);
                                        guiSetText(rankGUI2,factions[sFaction][5][sFrank][2]);
                                    end
                                end
                            end 
                        end
                        if exports.fv_engine:isInSlot(sx/2-w/2+190+w/4+160/2,sy/2+40+25,160,25) then -- Rang név mentés
                            if isElement(rankGUI) then 
                                local text = guiGetText(rankGUI);
                                if text ~= "" or text ~= " " then 
                                    factions[sFaction][5][sFrank][1] = text;
                                    triggerServerEvent("dash > rankNameSave",localPlayer,localPlayer,current,sFrank,text);
                                end
                            end
                        end
                        if factions[sFaction][3] and factions[sFaction][3] > 2 then --Csak legál
                            if exports.fv_engine:isInSlot(sx/2-w/2+190+w/4+160/2,sy/2+140+25,160,25) then --Rang fizetés mentés
                                if isElement(rankGUI2) then 
                                    local text = guiGetText(rankGUI2);
                                    if text ~= "" or text ~= " " then 
                                        factions[sFaction][5][sFrank][2] = text;
                                        triggerServerEvent("dash > rankPaySave",localPlayer,localPlayer,current,sFrank,text);
                                    end
                                end
                            end
                        else 
                            if isElement(rankGUI2) then 
                                destroyElement(rankGUI2);
                            end
                        end
                    end
                end
                if sFmenu == 4 then 
                    --sFveh = 1;
                    local current = factions[sFaction][1];
                    factionVehicles[current] = {};
                    factionVehicles[current] = getFactionVehicles(current);
                end
            end

            if tab == 4 then 
                for k,v in pairs(admins) do
                    if exports.fv_engine:isInSlot(sx/2-(w/2)+180+10,sy/2-h/2+(k*40)-15,w/3,30) then
                        if k ~= selectedAdmin then
                            selectedAdmin = k;
                        end
                    end
                end
            end

            if tab == 6 then 
                for k,v in pairs(shaders) do 
                    local name,state = unpack(v);
                    if exports.fv_engine:isInSlot(sx/2-(w/3)/2,sy/2-h/2+(k*40),w/3,30) then 
                        shaderManage(k,not state);
                    end 
                end
            end
        end
    end
    if button == "mouse_wheel_up" and state then 
        if tab == 2 then
            if exports.fv_engine:isInSlot(sx/2-w/2+200,sy/2-h/2+50,w/3.3,h-150) then
                if vScroll > 0 then
                    vScroll = vScroll - 1;
                end
            end
            if exports.fv_engine:isInSlot(sx/2+170,sy/2-h/2+50,w/3.3,h-150) then 
                if iScroll > 0 then 
                    iScroll = iScroll - 1;
                end
            end
        end
        if tab == 3 then 
            if sFmenu == 4 then 
                if exports.fv_engine:isInSlot(sx/2+w/2-210,sy/2-h/2,200,h) and vScroll > 0 then 
                    vScroll = vScroll - 1;
                end
            elseif sFmenu == 2 then 
                if exports.fv_engine:isInSlot(sx/2+w/2-210,sy/2-h/2,200,h) and vScroll > 0 then 
                    vScroll = vScroll - 1;
                end
            end
        end
    end
    if button == "mouse_wheel_down" and state then 
        if tab == 2 then
            if exports.fv_engine:isInSlot(sx/2-w/2+200,sy/2-h/2+50,w/3.3,h-150) then
                if vScroll < #playerVehicles - vMax then
                    vScroll = vScroll + 1;
                end
            end
            if exports.fv_engine:isInSlot(sx/2+170,sy/2-h/2+50,w/3.3,h-150) then 
                if iScroll < #playerInteriors - iMax then 
                    iScroll = iScroll + 1;
                end
            end
        end
        if tab == 3 then 
            if sFmenu == 4 then 
                local current = factions[sFaction][1];
                if exports.fv_engine:isInSlot(sx/2+w/2-210,sy/2-h/2,200,h) then 
                    if vScroll < #factionVehicles[current] - 15 then 
                        vScroll = vScroll + 1;
                    end
                end
            elseif sFmenu == 2 then 
                if exports.fv_engine:isInSlot(sx/2+w/2-210,sy/2-h/2,200,h) then 
                    if vScroll < #factionMembers[factions[sFaction][1]] - 15 then 
                        vScroll = vScroll + 1;
                    end
                end
            end
        end
    end
end);


addEvent("dash > sendFactionDatas",true);
addEventHandler("dash > sendFactionDatas",localPlayer,function(ftable,members)
    factions = {};
    factionVehicles = {};
    factionMembers = members;
    for k,v in pairs(members) do 
        if getElementData(localPlayer,"faction_"..tonumber(k)) then 
            factions[#factions + 1] = {k,unpack(ftable[k])};
            factionVehicles[k] = getFactionVehicles(k);
        end
    end
    sortFactionMembers();
    triggerServerEvent("dash > walkStyle",localPlayer,localPlayer,walkStyles[walkStyle][1]);
end);

function sortFactionMembers()
    for k,v in pairs(factionMembers) do --Tagok rendezése
        table.sort(factionMembers[k],function(a,b)
            local rank1 = a[2];
            local rank2 = b[2];
            return rank1 > rank2;
        end);
    end
end

function getFactionOnlineMembers(id)
    local online = 0;
    local all = 0;
	if ( factionMembers[id] ) then
		for i, k in pairs ( factionMembers[id] ) do
			if ( k[5] ) then
				online = online + 1;
			end
			all = all + 1;
		end
	end
    return online,all;
end

function getFactionVehicles(id)
    local table = {};
    for k,v in pairs(getElementsByType("vehicle")) do 
        if getElementData(v,"veh:id") and getElementData(v,"veh:id") > 0 then 
            local f = getElementData(v,"veh:faction");
            if f and f == id then 
                table[#table + 1] = v;
            end
        end
    end
    return table;
end
--Shader--
function shaderManage(id,state)
	if id == 1 then
		if state then
			enableDetail();
		else
			disableDetail();
		end
	elseif id == 2 then
		if state then
			startCarPaintReflect();
		else
			stopCarPaintReflect();
		end
	elseif id == 3 then	
		if state then
			startWaterRefract()
		else
			stopWaterRefract()
		end
	elseif id == 4 then
		if state then
			startShaderResource();
		else
			stopShaderResource();
		end
    end
	shaders[id][2] = state;
end
function saveShaders()
    if fileExists("shaders.xml") then 
        fileDelete("shaders.xml");
    end
    local file = xmlCreateFile("shaders.xml","socialgaming");
    for k,v in pairs(shaders) do 
        local name,state = unpack(v);
        if state then 
            state = 1;
        else 
            state = 0;
        end
        local child = xmlCreateChild(file,"shader_"..tostring(k));
        xmlNodeSetValue(child,tostring(state));
    end
    xmlSaveFile(file);
    xmlUnloadFile(file);

    if fileExists("dash_config.xml") then 
        fileDelete("dash_config.xml");
    end
    local file = xmlCreateFile("dash_config.xml","socialgaming");
    xmlNodeSetAttribute(file,"walkStyle",tostring(walkStyle));
    xmlNodeSetAttribute(file,"crosshair",tostring(crosshair));
    xmlSaveFile(file);
    xmlUnloadFile(file);
end
addEventHandler("onClientResourceStop",resourceRoot,saveShaders);

addEventHandler("onClientResourceStart",resourceRoot,function()
    if fileExists("shaders.xml") then 
        local file = xmlLoadFile("shaders.xml");
        for k, v in pairs(shaders) do 
            local name,state = unpack(v);
            local saveState = tonumber(xmlNodeGetValue(xmlFindChild(file,"shader_"..tostring(k),0)));
            if saveState then 
                if saveState == 1 then 
                    saveState = true;
                else 
                    saveState = false;
                end
                shaders[k] = {name,saveState};
                shaderManage(k,saveState);
            end
        end
        xmlUnloadFile(file);
    end

    if fileExists("dash_config.xml") then 
        local file = xmlLoadFile("dash_config.xml");
        local style = tonumber(xmlNodeGetAttribute(file,"walkStyle"));
        if style then 
            walkStyle = style;
            if walkStyles[walkStyle] and walkStyles[walkStyle][1] then 
                triggerServerEvent("dash > walkStyle",localPlayer,localPlayer,walkStyles[walkStyle][1]);
            end
        end

        local cross = tonumber(xmlNodeGetAttribute(file,"crosshair"));
        if cross then 
            crosshair = cross;
        end
        xmlUnloadFile(file);
    end

    -- setTimer(function()
    --     triggerServerEvent("dash > walkStyle",localPlayer,localPlayer,walkStyles[walkStyle][1]);
    -- end,1500,1);
end);
addEventHandler("onClientElementDataChange",localPlayer,function(dataName,oldValue,newValue)
    if dataName == "loggedIn" and newValue then 
        if walkStyles[walkStyle] and walkStyles[walkStyle][1] then 
            triggerServerEvent("dash > walkStyle",localPlayer,localPlayer,walkStyles[walkStyle][1]);
        end
    end
end);
------------

addEvent("dash.fix",true);
addEventHandler("dash.fix",localPlayer,function()
	if fileExists("shaders.save") then
        fileDelete("shaders.save");
    end
    if fileExists("walkStyle.save") then 
        fileDelete("walkStyle.save");
    end
    if fileExists("shaders.xml") then
        fileDelete("shaders.xml");
    end
    if fileExists("walkStyle.xml") then 
        fileDelete("walkStyle.xml");
    end
    shaders = {
        {"HD textures",false},
        {"Vehicle reflection",false},
        {"More beautiful water",false},
        {"Sky effect",false},
    };
    walkStyle = 1;
    triggerServerEvent("dash > walkStyle",localPlayer,localPlayer,walkStyles[walkStyle][1]);
    if fileExists("crosshair.save") then 
        fileDelete("crosshair.save");
    end
    if fileExists("crosshair.xml") then 
        fileDelete("crosshair.xml");
    end
    crosshair = 1;
    crosshairCount = 15;
    loadCrosshair();
end)

--Admin--
function getAdmins()
    selectedAdmin = 1;
    admins = {};
    for i=1,9 do 
        admins[i] = {};
    end 
    for k,v in pairs(getElementsByType("player")) do
        local level = getElementData(v,"admin >> level");
        if level and level > 0 and level < 10 then 
            if level == 13 then 
                level = 12;
            end
            admins[level][#admins[level] + 1] = v;
        end
    end
end
--------

function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	-- dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	-- dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end
function tooltip(text)
	local cx,cy = getCursorPosition();
	cx,cy = cx*sx,cy*sy;
	cx,cy = cx+10,cy+10;
	local width = dxGetTextWidth(text,1,font4)+10;
	dxDrawRectangle(cx-5,cy,width,20,tocolor(255,255,255,200),true);
	dxDrawText(text,cx-5,cy,(cx-5)+width,cy+20,tocolor(0,0,0),1,font4,"center","center",false,false,true,true);
end
function SecondsToClock(seconds)
	local seconds = tonumber(seconds)
  	if seconds <= 0 then
		return "00:00";
	else
		local hours = string.format("%02.f", math.floor(seconds/3600));
		local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
		local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
		return mins..":"..secs
	end
end

--PAYDAY--
setTimer(function()
    if getElementData(localPlayer,"loggedIn") and not getElementData(localPlayer,"afk") then 
        local timeLeft = getElementData(localPlayer,"char.payTime") or 3600;
        timeLeft = timeLeft - 1;
        if timeLeft < 0 then 
            if getElementData(localPlayer,"network") then
                triggerServerEvent("payday.give",localPlayer,localPlayer);       
                timeLeft = 3600;
            end
        end
        setElementData(localPlayer,"char.payTime",timeLeft);
    end
end,1000,0);



local illegalFactions = {
    7,9,10,15,16,24,43,38
};

function isIllegal()
    local state = false;
    for k,v in pairs(illegalFactions) do 
        if getElementData(localPlayer,"faction_"..v) then 
            state = true;
            break;
        end
    end
    return state;
end