e = exports.fv_engine;
dx = exports.fv_dx;

local sx,sy = guiGetScreenSize();
local open = false;
local tab = 0;
local currentVeh = false;
local buttons = {
    {"main page","overview",3},
    {"Edit unit number","egysegszam",2},
    {"Circled persons","players",5},
    {"Circled vehicles","vehicles",6},
    {"new post","new",4},
    --{"Büntető törvénykönyv","btk",7},
    {"Check-Out","logout"},
}
local clickTick = getTickCount();
local cache = {
    players = {};
    vehicles = {};
};
local wpScroll = 0;
local wvScroll = 0;

local btkScroll = 0;

addEventHandler("onClientResourceStart",root,function(res)
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        sColor = {exports.fv_engine:getServerColor("servercolor",false)};
        red = {exports.fv_engine:getServerColor("red",false)};
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
        red2 = exports.fv_engine:getServerColor("red",true);
        blue = exports.fv_engine:getServerColor("blue",true);
        blue2 = {e:getServerColor("blue",false)};
        buttonFont = e:getFont("rage",11);
        topFont = e:getFont("rage",15);
        loginFont = e:getFont("rage",15);
        mediumFont = e:getFont("rage",13);
        smallFont = e:getFont("rage",11);
        icons = e:getFont("AwesomeFont",18);
    end
    if res == getThisResource() or getResourceName(res) == "fv_dx" then 
        dx = exports.fv_dx;
    end
    if res == getThisResource() then --EZ A SCRIPT
        setElementData(localPlayer,"mdc.loggedIn",false);
    end
end);

function destroyGUIs()
    if dx:dxGetEdit("mdc.egysegszam") then 
        dx:dxDestroyEdit("mdc.egysegszam");
    end
    if dx:dxGetEdit("mdc.username") then 
        dx:dxDestroyEdit("mdc.username");
    end
    if dx:dxGetEdit("mdc.pass") then 
        dx:dxDestroyEdit("mdc.pass");
    end
    if dx:dxGetEdit("mdc.pname") then 
        dx:dxDestroyEdit("mdc.pname");
    end
    if dx:dxGetEdit("mdc.location") then 
        dx:dxDestroyEdit("mdc.location");
    end
    if dx:dxGetEdit("mdc.reason") then 
        dx:dxDestroyEdit("mdc.reason");
    end
    if dx:dxGetEdit("mdc.vname") then 
        dx:dxDestroyEdit("mdc.vname");
    end
    if dx:dxGetEdit("mdc.vlocation") then 
        dx:dxDestroyEdit("mdc.vlocation");
    end
    if dx:dxGetEdit("mdc.vreason") then 
        dx:dxDestroyEdit("mdc.vreason");
    end
    if dx:dxGetEdit("mdc.vplate") then 
        dx:dxDestroyEdit("mdc.vplate");
    end
    if dx:dxGetEdit("mdc.search") then 
        dx:dxDestroyEdit("mdc.search");
    end
end
addEventHandler("onClientResourceStop",resourceRoot,destroyGUIs);

function renderMDC()
    if not isPedInVehicle(localPlayer) or currentVeh ~= getPedOccupiedVehicle(localPlayer) then
        openMDC();
    end
    dxDrawRectangle(sx/2-450,sy/2-250,900,500,tocolor(0,0,0,150)); --All BG
    e:shadowedText("Tunisian Devils - MDC",0,sy/2-280,sx,0,tocolor(255,255,255),1,topFont,"center","top"); --Top Text
    dxDrawRectangle(sx/2+250,sy/2-250,200,500,tocolor(0,0,0,100)); --Right Bar

    for k,v in pairs(buttons) do 
        local text,func,tabnumber = unpack(v);
        local color;
        if func == "logout" then 
            local r,g,b = exports.fv_engine:getServerColor("red",false);
            color = tocolor(r,g,b,180);
        else 
            color = tocolor(70,70,70,240);
        end
        local shadowed = false;
        if e:isInSlot(sx/2+255,sy/2-280+(k*40),190,30) then 
            if func == "logout" then 
                local r,g,b = exports.fv_engine:getServerColor("red",false);
                color = tocolor(r,g,b);
            else 
                color = tocolor(exports.fv_engine:getServerColor("servercolor",false));
            end
            shadowed = true;
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                if getElementData(currentVeh,"mdc.loggedIn") then 
                    destroyGUIs();
                    wpScroll = 0;
                    wvScroll = 0;
                    if func == "egysegszam" then 
                        tab = 2;
                        local current = (getElementData(currentVeh,"mdc.egysegszam") or "");
                        local egysegszam = dx:dxCreateEdit("mdc.egysegszam",current,"Egységszám",sx/2-200,sy/2-20,200,30);
                    elseif func == "new" then 
                        tab = 4;
                        local pname = dx:dxCreateEdit("mdc.pname","","Név",sx/2-350,sy/2-40,200,30);
                        local location = dx:dxCreateEdit("mdc.location","","Vizuális leírás",sx/2-350,sy/2,200,30);
                        local reason = dx:dxCreateEdit("mdc.reason","","Indoklás",sx/2-350,sy/2+40,200,30);
            
                        local vname = dx:dxCreateEdit("mdc.vname","","Tipus",sx/2-50,sy/2-80,200,30);
                        local location = dx:dxCreateEdit("mdc.vlocation","","Tartózkodási hely",sx/2-50,sy/2-40,200,30);
                        local reason = dx:dxCreateEdit("mdc.vreason","","Indoklás",sx/2-50,sy/2,200,30);
                        local plate = dx:dxCreateEdit("mdc.vplate","","Rendszám",sx/2-50,sy/2+40,200,30);
                    elseif func == "players" then 
                        tab = 5;
                        triggerServerEvent("mdc.getWantedPlayers",localPlayer,localPlayer);
                        local search = dx:dxCreateEdit("mdc.search","","Keresés (Név)",sx/2-200,sy/2+210,200,30);
                    elseif func == "vehicles" then 
                        tab = 6;
                        triggerServerEvent("mdc.getWantedVehicles",localPlayer,localPlayer);
                        local search = dx:dxCreateEdit("mdc.search","","Keresés (Rendszám)",sx/2-200,sy/2+210,200,30);
                    elseif func == "btk" then 
                        btkScroll = 0;
                        tab = 7;
                    elseif func == "attekintes" then 
                        tab = 3;
                    elseif func == "logout" then 
                        triggerServerEvent("mdc.logout",localPlayer,localPlayer,currentVeh);
                    end
                    clickTick = getTickCount();
                end
            end
        end
        if tab == tabnumber then 
            color = tocolor(exports.fv_engine:getServerColor("servercolor",false));
            shadowed = true;
        end
        dxDrawRectangle(sx/2+255,sy/2-280+(k*40),190,30,color);
        if shadowed then 
            e:shadowedText(text,sx/2+255,sy/2-280+(k*40),sx/2+255+190,sy/2-280+(k*40)+30,tocolor(255,255,255),1,buttonFont,"center","center");
        else 
            dxDrawText(text,sx/2+255,sy/2-280+(k*40),sx/2+255+190,sy/2-280+(k*40)+30,tocolor(255,255,255),1,buttonFont,"center","center");
        end
    end

    if tab == 1 then --LOGIN
        if getElementData(currentVeh,"mdc.loggedIn") then 
            if (getElementData(currentVeh,"mdc.egysegszam") or "") ~= "" then 
                tab = 3;
                destroyGUIs();
            else 
                tab = 2;
                destroyGUIs();
                local current = (getElementData(currentVeh,"mdc.egysegszam") or "");
                local egysegszam = dx:dxCreateEdit("mdc.egysegszam",current,"Egységszám",sx/2-200,sy/2-20,200,30);
            end
        else 
            dxDrawText("Login here: "..blue.."Mobile Data Computer",sx/2-450,sy/2-70,sx/2-450+700,500,tocolor(255,255,255),1,loginFont,"center","top",false,false,false,true);

            local buttonColor = tocolor(sColor[1],sColor[2],sColor[3],100);
            if e:isInSlot(sx/2-250,sy/2+60,300,30) then 
                buttonColor = tocolor(sColor[1],sColor[2],sColor[3]);
                if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                    triggerServerEvent("mdc.login",localPlayer,localPlayer,dx:dxGetEditText("mdc.username"),dx:dxGetEditText("mdc.pass"),currentVeh);
                    clickTick = getTickCount();
                end
            end
            dxDrawRectangle(sx/2-250,sy/2+60,300,30,buttonColor);
            e:shadowedText("Login",sx/2-250,sy/2+60,sx/2-250+300,sy/2+60+30,tocolor(255,255,255),1,buttonFont,"center","center");
        end
    elseif tab == 2 then --Egységszám megadása
        dxDrawText("Enter your unit number: ",sx/2-450,sy/2-70,sx/2-450+700,500,tocolor(255,255,255),1,loginFont,"center","top",false,false,false,true);
        local buttonColor = tocolor(sColor[1],sColor[2],sColor[3],100);
        if e:isInSlot(sx/2-250,sy/2+20,300,30) then 
            buttonColor = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                triggerServerEvent("mdc.egysegszam",localPlayer,localPlayer,currentVeh,dx:dxGetEditText("mdc.egysegszam"));
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx/2-250,sy/2+20,300,30,buttonColor);
        e:shadowedText("Ready",sx/2-250,sy/2+20,sx/2-250+300,sy/2+20+30,tocolor(255,255,255),1,buttonFont,"center","center");
    elseif tab == 3 then --Áttekintés
        if getElementData(localPlayer,"faction_2") then 
            dxDrawImage(sx/2-200,sy/2-230,200,200,"icons/police.png");
        elseif getElementData(localPlayer,"faction_17") then 
            dxDrawImage(sx/2-200,sy/2-230,200,200,"icons/sheriff.png");
        elseif getElementData(localPlayer,"faction_5") then 
            dxDrawImage(sx/2-200,sy/2-230,200,200,"icons/fbi.png");
        end

        dxDrawText("People around: "..sColor2..#cache.players..white..".\nCircled vehicles: "..sColor2..#cache.vehicles..white..".",sx/2-450,sy/2-250,sx/2-450+700,sy/2-250+500,tocolor(255,255,255),1,mediumFont,"center","center",false,false,false,true);
    
        local vehMode = 0;
        if currentVeh then 
            vehMode = (getElementData(currentVeh,"mdc.mode") or 1);
        end
        local x = e:getServerColor(types[vehMode][2],true);
        dxDrawText("Current status:"..x..types[vehMode][1],sx/2-250,sy/2+50,sx/2-250+300,0,tocolor(255,255,255),1,buttonFont,"center","top",false,false,false,true);
    
        for k,v in pairs(types) do 
            local r,g,b = e:getServerColor(v[2],false);
            local buttonColor = tocolor(r,g,b,200);
            if e:isInSlot(sx/2-175,sy/2+80+(k*40),150,30) then 
                buttonColor = tocolor(r,g,b);
                if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                    if k ~= vehMode then 
                        setElementData(currentVeh,"mdc.mode",k);
                        triggerServerEvent("mdc.setVehMode",localPlayer,localPlayer,currentVeh,k);
                    end
                    clickTick = getTickCount();
                end
            end
            dxDrawRectangle(sx/2-175,sy/2+80+(k*40),150,30,buttonColor);
            e:shadowedText(v[1],sx/2-175,sy/2+80+(k*40),sx/2-175+150,sy/2+80+(k*40)+30,tocolor(255,255,255),1,buttonFont,"center","center");
        end

    elseif tab == 4 then --Új bejegyzés
        dxDrawText("New entry in the law enforcement system.",sx/2-450,sy/2-200,sx/2-450+700,500,tocolor(255,255,255),1,loginFont,"center","top",false,false,false,true);

        dxDrawText("Recruitment of a person.",sx/2-350,sy/2-65,sx/2-350+200,0,tocolor(255,255,255),1,mediumFont,"center","top");

        local pButton = tocolor(sColor[1],sColor[2],sColor[3],100);
        if e:isInSlot(sx/2-350,sy/2+80,200,30) then 
            pButton = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then --Player WANTED
                triggerServerEvent("mdc.playerWanted",localPlayer,localPlayer,dx:dxGetEditText("mdc.pname"),dx:dxGetEditText("mdc.location"),dx:dxGetEditText("mdc.reason"));
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx/2-350,sy/2+80,200,30,pButton);
        e:shadowedText("Ready",sx/2-350,sy/2+80,sx/2-350+200,sy/2+80+30,tocolor(255,255,255),1,mediumFont,"center","center");


        dxDrawText("Pick up a vehicle.",sx/2-50,sy/2-105,sx/2-50+200,0,tocolor(255,255,255),1,mediumFont,"center","top");
        local vButton = tocolor(sColor[1],sColor[2],sColor[3],100);
        if e:isInSlot(sx/2-50,sy/2+80,200,30) then 
            vButton = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then  
                triggerServerEvent("mdc.vehicleWanted",localPlayer,localPlayer,dx:dxGetEditText("mdc.vname"),dx:dxGetEditText("mdc.vlocation"),dx:dxGetEditText("mdc.vreason"),dx:dxGetEditText("mdc.vplate"))
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(sx/2-50,sy/2+80,200,30,vButton);
        e:shadowedText("Ready",sx/2-50,sy/2+80,sx/2-50+200,sy/2+80+30,tocolor(255,255,255),1,mediumFont,"center","center");
    elseif tab == 5 then --Wanted players
        dxDrawRectangle(sx/2-450,sy/2-250,700,500,tocolor(0,0,0,150)); --Left BG
        if #cache.players == 0 then 
            dxDrawText("No people circled",sx/2-450,sy/2-250,sx/2-450+700,sy/2-250+500,tocolor(255,255,255),1,mediumFont,"center","center");
        else
            for k=1,10 do 
                local alpha = 100;
                if k%2 == 0 then 
                    alpha = 150;
                end
                dxDrawRectangle(sx/2-450,sy/2-300+(k*50),700,50,tocolor(80,80,80,alpha));
            end

            local search = dx:dxGetEditText("mdc.search");
            if search ~= "" or search == "" then 
                local count = 0;
                for k,v in pairs(cache.players) do 
                    if string.find(string.lower(v[1]),string.lower(search)) then 
                        if k > wpScroll and count < 9 then 
                            count = count + 1;
                            dxDrawText("Name: "..sColor2..v[1]..white.."\nreason: "..red2..v[3],sx/2-445,sy/2-295+(count*50),700,50,tocolor(255,255,255),1,smallFont,"left","top",false,false,false,true);
                            dxDrawText("Visual description: \n"..sColor2..v[2],sx/2-450,sy/2-295+(count*50),sx/2-450+700,50,tocolor(255,255,255),1,smallFont,"center","top",false,false,false,true);
                            local trashColor = tocolor(200,200,200,200);
                            if e:isInSlot(sx/2+200,sy/2-293+(count*50),35,35) then 
                                trashColor = tocolor(red[1],red[2],red[3]);
                                if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                                    triggerServerEvent("mdc.removeSQL",localPlayer,localPlayer,"Players",v[4]);
                                    table.remove(cache.players,k);
                                    clickTick = getTickCount();
                                end
                            end
                            dxDrawText("",sx/2+200,sy/2-293+(count*50),sx/2+200+35,sy/2-293+(count*50)+35,trashColor,1,icons,"center","center");
                        end
                    end
                end
            else 
                local count = 0;
                for k,v in pairs(cache.players) do 
                    if k > wpScroll and count < 9 then 
                        count = count + 1;
                        dxDrawText("Name: "..sColor2..v[1]..white.."\nreason: "..red2..v[3],sx/2-445,sy/2-295+(count*50),700,50,tocolor(255,255,255),1,smallFont,"left","top",false,false,false,true);
                        dxDrawText("Visual description: \n"..sColor2..v[2],sx/2-450,sy/2-295+(count*50),sx/2-450+700,50,tocolor(255,255,255),1,smallFont,"center","top",false,false,false,true);
                        local trashColor = tocolor(200,200,200,200);
                        if e:isInSlot(sx/2+200,sy/2-293+(count*50),35,35) then 
                            trashColor = tocolor(red[1],red[2],red[3]);
                            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                                triggerServerEvent("mdc.removeSQL",localPlayer,localPlayer,"Players",v[4]);
                                table.remove(cache.players,k);
                                clickTick = getTickCount();
                            end
                        end
                        dxDrawText("",sx/2+200,sy/2-293+(count*50),sx/2+200+35,sy/2-293+(count*50)+35,trashColor,1,icons,"center","center");
                    end
                end
            end
        end
    elseif tab == 6 then --Wanted vehicles
        dxDrawRectangle(sx/2-450,sy/2-250,700,500,tocolor(0,0,0,150)); --Left BG
        if #cache.vehicles == 0 then 
            dxDrawText("No circling vehicle.",sx/2-450,sy/2-250,sx/2-450+700,sy/2-250+500,tocolor(255,255,255),1,mediumFont,"center","center");
        else
            for k=1,10 do 
                local alpha = 100;
                if k%2 == 0 then 
                    alpha = 150;
                end
                dxDrawRectangle(sx/2-450,sy/2-300+(k*50),700,50,tocolor(80,80,80,alpha));
            end
            local search = dx:dxGetEditText("mdc.search");
            if search ~= "" or search == "" then 
                local count = 0;
                for k,v in pairs(cache.vehicles) do 
                    if string.find(string.lower(v[4]),string.lower(search)) then 
                        if k > wvScroll and count < 9 then 
                            count = count + 1;
                            dxDrawText("Type: "..sColor2..v[1]..white.."\nreason: "..red2..v[3],sx/2-445,sy/2-295+(count*50),700,50,tocolor(255,255,255),1,smallFont,"left","top",false,false,false,true);
                            dxDrawText("Place of residence: "..sColor2..v[2]..white.."\nLicense plate number: "..sColor2..v[4],sx/2-450,sy/2-295+(count*50),sx/2-450+700,50,tocolor(255,255,255),1,smallFont,"center","top",false,false,false,true);
                            local trashColor = tocolor(200,200,200,200);
                            if e:isInSlot(sx/2+200,sy/2-293+(count*50),35,35) then 
                                trashColor = tocolor(red[1],red[2],red[3]);
                                if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                                    triggerServerEvent("mdc.removeSQL",localPlayer,localPlayer,"Vehicles",v[5]);
                                    table.remove(cache.vehicles,k);
                                    clickTick = getTickCount();
                                end
                            end
                            dxDrawText("",sx/2+200,sy/2-293+(count*50),sx/2+200+35,sy/2-293+(count*50)+35,trashColor,1,icons,"center","center");
                        end
                    end
                end
            else 
                local count = 0;
                for k,v in pairs(cache.vehicles) do 
                    if k > wvScroll and count < 9 then 
                        count = count + 1;
                        dxDrawText("Type: "..sColor2..v[1]..white.."\nReason: "..red2..v[3],sx/2-445,sy/2-295+(count*50),700,50,tocolor(255,255,255),1,smallFont,"left","top",false,false,false,true);
                        dxDrawText("Place of residence: "..sColor2..v[2]..white.."\nLicense plate number: "..sColor2..v[4],sx/2-450,sy/2-295+(count*50),sx/2-450+700,50,tocolor(255,255,255),1,smallFont,"center","top",false,false,false,true);
                        local trashColor = tocolor(200,200,200,200);
                        if e:isInSlot(sx/2+200,sy/2-293+(count*50),35,35) then 
                            trashColor = tocolor(red[1],red[2],red[3]);
                            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                                triggerServerEvent("mdc.removeSQL",localPlayer,localPlayer,"Vehicles",v[5]);
                                table.remove(cache.vehicles,k);
                                clickTick = getTickCount();
                            end
                        end
                        dxDrawText("",sx/2+200,sy/2-293+(count*50),sx/2+200+35,sy/2-293+(count*50)+35,trashColor,1,icons,"center","center");
                    end
                end
            end
        end
    elseif tab == 7 then --BTK
        if btkScroll == 0 then 
            dxDrawImage(sx/2-450,sy/2-250,700,500,"btk1.png");
        else 
            dxDrawImage(sx/2-450,sy/2-250,700,500,"btk2.png");
        end
    end
end

function mdcSetMode(cmd, mode)
	mode = tonumber(mode);
	local veh = getPedOccupiedVehicle(localPlayer);
	if (veh) then
		if (getElementData(veh, "mdc.egysegszam")) then
			if types[mode] then
				if (getElementData(veh, "mdc.mode") ~= mode) then
					setElementData(veh,"mdc.mode", mode);
					triggerServerEvent("mdc.setVehMode", localPlayer, localPlayer, veh, mode);
				end
			end
		end
	end
end
addCommandHandler("setmdcmode", mdcSetMode, false);

addEventHandler("onClientKey",root,function(button,state)
if open then 
    if button == "mouse_wheel_up" and state then 
        if e:isInSlot(sx/2-450,sy/2-250,700,500) then --Left Side
            if tab == 5 then 
                if wpScroll > 0 then 
                    wpScroll = wpScroll - 1;
                end
            end
            if tab == 6 then 
                if wvScroll > 0 then 
                    wvScroll = wvScroll - 1;
                end
            end
            if tab == 7 then 
                if btkScroll > 0 then 
                    btkScroll = btkScroll - 1;
                end
            end
        end
    elseif button == "mouse_wheel_down" and state then 
        if e:isInSlot(sx/2-450,sy/2-250,700,500) then --Left Side
            if tab == 5 then 
                if wpScroll < #cache.players - 9 then 
                    wpScroll = wpScroll + 1;
                end
            end
            if tab == 6 then 
                if wvScroll < #cache.vehicles - 9 then 
                    wvScroll = wvScroll + 1;
                end
            end
            if tab == 7 then 
                if btkScroll == 0 then 
                    btkScroll = btkScroll + 1;
                end
            end
        end
    end
end
end);   

function openMDC()
    if open then 
        destroyGUIs();
        removeEventHandler("onClientRender",root,renderMDC);
        open = false;
        currentVeh = false;
        -- unbindKey("mouse_wheel_down","down",scrollDown);
        -- unbindKey("mouse_wheel_up","down",scrollUp);
    else
        open = true;
        tab = 1;
        wpScroll = 0;
        wvScroll = 0;                     
        btkScroll = 0;
        removeEventHandler("onClientRender",root,renderMDC);
        addEventHandler("onClientRender",root,renderMDC);
        currentVeh = getPedOccupiedVehicle(localPlayer);
        destroyGUIs();
        triggerServerEvent("mdc.getWantedPlayers",localPlayer,localPlayer);
        triggerServerEvent("mdc.getWantedVehicles",localPlayer,localPlayer);
        if tab == 1 then 
            local username = dx:dxCreateEdit("mdc.username","","Felhasználónév",sx/2-200,sy/2-20,200,30);
            local passwd = dx:dxCreateEdit("mdc.pass","","Jelszó",sx/2-200,sy/2+20,200,30,2);
        elseif tab == 2 then 
            local current = (getElementData(currentVeh,"mdc.egysegszam") or "");
            local egysegszam = dx:dxCreateEdit("mdc.egysegszam",current,"Egységszám",sx/2-200,sy/2-20,200,30);
        elseif tab == 4 then --Új
            local pname = dx:dxCreateEdit("mdc.pname","","Név",sx/2-350,sy/2-40,200,30);
            local location = dx:dxCreateEdit("mdc.location","","Vizuális leírás",sx/2-350,sy/2,200,30);
            local reason = dx:dxCreateEdit("mdc.reason","","Indoklás",sx/2-350,sy/2+40,200,30);

            local vname = dx:dxCreateEdit("mdc.vname","","Tipus",sx/2-50,sy/2-80,200,30);
            local location = dx:dxCreateEdit("mdc.vlocation","","Tartózkodási hely",sx/2-50,sy/2-40,200,30);
            local reason = dx:dxCreateEdit("mdc.vreason","","Indoklás",sx/2-50,sy/2,200,30);
            local plate = dx:dxCreateEdit("mdc.vplate","","Rendszám",sx/2-50,sy/2+40,200,30);
        end
        -- bindKey("mouse_wheel_down","down",scrollDown);
        -- bindKey("mouse_wheel_up","down",scrollUp);
    end
end

addEvent("mdc.setTab",true);
addEventHandler("mdc.setTab",root,function(a)
    tab = a;
    --Edits Clear--
    destroyGUIs();
    ---------------
    if tab == 1 then 
        local username = dx:dxCreateEdit("mdc.username","","Felhasználónév",sx/2-200,sy/2-20,200,30);
        local passwd = dx:dxCreateEdit("mdc.pass","","Jelszó",sx/2-200,sy/2+20,200,30,2);
    end
end);

addEvent("mdc.returnWantedPlayers",true);
addEventHandler("mdc.returnWantedPlayers",root,function(datas)
    cache.players = {};
    cache.players = tableCopy(datas);
end);

addEvent("mdc.returnWantedVehicles",true);
addEventHandler("mdc.returnWantedVehicles",root,function(datas)
    cache.vehicles = {};
    cache.vehicles = tableCopy(datas);
end);

--PARANCSOK--
addCommandHandler("mdc",function(cmd)
if isAllowedFaction(localPlayer) then 
    if isPedInVehicle(localPlayer) then 
        local veh = getPedOccupiedVehicle(localPlayer);
        
		local allowed = false;
		for k, v in pairs(allowedFactions) do
			if (getElementData(veh, "veh:faction") == v) then
				allowed = true;
				break;
			else
				allowed = false;
			end
		end
		
		if (allowed) then
			openMDC();
		end
    else 
        if open then 
            removeEventHandler("onClientRender",root,renderMDC);
            open = false;
        end
    end
end
end,false,false);




--Vehicle Blips--
local blips = {};

addEventHandler("onClientElementDataChange",root,function(dataName,oldValue,newValue)
if isAllowedFaction(localPlayer) then 
    if getElementType(source) == "vehicle" then
		local allowed = false;
		for i, faction in pairs(allowedFactions) do
			if (getElementData(source, "veh:faction") == faction) then
				allowed = true;
				break;
			else
				allowed = false;
			end
		end
	
        if allowed then 
            if dataName == "mdc.mode" then 
                local blip = blips[source];
                local geci = (getElementData(source,"mdc.egysegszam") or false);
                if blip then 
                    local r,g,b = exports.fv_engine:getServerColor(types[newValue][2],false);
                    setElementData(blip,"blip >> color",{r,g,b});
                    setElementData(blip,"blip >> name",types[newValue][1].." | "..geci)
                else 
                    if geci then --Tehát ha kivered
                        local x,y,z = getElementPosition(source);
                        local blip = createBlip(x,y,z,33);
                        attachElements(blip,source,0,0,3);
                        local r,g,b = exports.fv_engine:getServerColor(types[getElementData(source,"mdc.mode")][2],false);
                        setElementData(blip,"blip >> color",{r,g,b});
                        setElementData(blip,"blip >> size",30);
                        setElementData(blip,"blip >> maxVisible",true);
                        setElementData(blip,"blip >> name",types[getElementData(source,"mdc.mode")][1].." | "..geci)
                        blips[source] = blip;
                    end
                end
            end
        end
    end
else 
    for k,v in pairs(blips) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    blips = {};
end
if getElementType(source) == "player" and source == localPlayer then 
    if string.find(dataName,"faction_") and not string.find(dataName,"_rank") and not string.find(dataName,"_dutyskin") and not string.find(dataName,"_leader") then 
        if newValue and isAllowedFaction(localPlayer) then 
            for k,v in pairs(blips) do 
                if isElement(v) then 
                    destroyElement(v);
                end
            end
            blips = {};
            for k,v in pairs(getElementsByType("vehicle")) do 
				createBlips(v);
            end
        end 
    end
    if dataName == "loggedIn" and newValue then 
        if isAllowedFaction(localPlayer) then 
            for k,v in pairs(blips) do 
                if isElement(v) then 
                    destroyElement(v);
                end
            end
            blips = {};
            for k,v in pairs(getElementsByType("vehicle")) do
				local allowed = false;
				for i, faction in pairs(allowedFactions) do
					if (getElementData(v, "veh:faction") == faction) then
						allowed = true;
						break;
					else
						allowed = false;
					end
				end
			
                if allowed then
                    createBlips(v);
                end
            end
        end
    end
end
end);

function createBlips(veh)
    if not veh then veh = getPedOccupiedVehicle(localPlayer) end;
	
	local allowed = false;
	for i, faction in pairs(allowedFactions) do
		if (getElementData(veh, "veh:faction") == faction) then
			allowed = true;
			break;
		else
			allowed = false;
		end
	end
	
	if allowed then
		if isAllowedFaction(localPlayer) then 
			local geci = (getElementData(veh,"mdc.egysegszam") or false);
			if geci then --Tehát ha kivered
				local x,y,z = getElementPosition(veh);
				local blip = createBlip(x,y,z,33);
				attachElements(blip,veh,0,0,3);
				local r,g,b = exports.fv_engine:getServerColor(types[getElementData(veh,"mdc.mode")][2],false);
				setElementData(blip,"blip >> color",{r,g,b});
				setElementData(blip,"blip >> size",30);
				setElementData(blip,"blip >> maxVisible",true);
				setElementData(blip,"blip >> name",types[getElementData(veh,"mdc.mode")][1].." | "..geci)
				blips[veh] = blip;
			end
		end
	end
end

--Change Blip Color--
setTimer(function()
    if isAllowedFaction(localPlayer) then 
        for k,v in pairs(blips) do 
            if not isElement(v) then 
                blips[k] = nil;
            end
            if isElement(v) then 
                if getElementData(k,"mdc.mode") == 2 then             
                    local blue = {exports.fv_engine:getServerColor("blue",false)};
                    local r,g,b = unpack(getElementData(v,"blip >> color") or {blue[1],blue[2],blue[3]});
                    if blue[1] == r and blue[2] == g and blue[3] == b then 
                        local r,g,b = exports.fv_engine:getServerColor("red",false);
                        setElementData(v,"blip >> color",{r,g,b});
                    else 
                        local r,g,b = exports.fv_engine:getServerColor("blue",false);
                        setElementData(v,"blip >> color",{r,g,b});
                    end
                end
                if (getElementData(k,"mdc.mode") or 0) == 0 then 
                    destroyElement(v);
                    blips[k] = nil;
                end
                setElementDimension(v,getElementDimension(k));
                setElementInterior(v,getElementInterior(k));
            end
        end
    else 
        for k,v in pairs(blips) do 
            if isElement(v) then 
                destroyElement(v);
            end
            blips[k] = nil;
        end
        blips = {};
    end
end,500,0);


