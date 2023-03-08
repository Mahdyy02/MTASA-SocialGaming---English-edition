if fileExists("client.lua") then 
    fileDelete("client.lua")
end

e = exports.fv_engine
signFont = dxCreateFont("sign.ttf",28);

local sx,sy = guiGetScreenSize();
local cache = {};
local target = false;
local gui,guiActive = false,false;
local clickTick = 0;

local sign = "";
local signCount = 0;
local start = false;

local show = false;

addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if getResourceName(res) == "fv_engine" or getThisResource() then 
        e = exports.fv_engine;
        font = e:getFont("rage",13);
        font2 = e:getFont("rage",10);
        sColor = {e:getServerColor("servercolor",false)};
        red = {e:getServerColor("red",false)};
    end
end);

function renderSell()
    local penz = cache.cost;
    if isElement(gui) then 
        penz = guiGetText(gui);
        if penz ~= "" and not tonumber(penz) then 
            guiSetText(gui,"");
        end
    end

    local w,h = 600,700;
    dxDrawImage(sx/2-w/2,sy/2-h/2,w,h,"sellvehicle.png");

    dxDrawText(cache.seller,sx/2-w/2+130,sy/2-h/2+80,sx/2-w/2+220+200,0,tocolor(0,0,0),1,font,"center","top"); --Eladó
    dxDrawText(cache.buyer,sx/2-w/2+30,sy/2-h/2+110,sx/2-w/2+100+200,0,tocolor(0,0,0),1,font,"center","top"); --Vevő
    dxDrawText(cache.plate,sx/2-w/2+55,sy/2-h/2+145,sx/2-w/2+105+130,0,tocolor(0,0,0),1,font,"center","top"); --Rendszám
    dxDrawText(cache.model,sx/2-w/2+210,sy/2-h/2+149,sx/2-w/2+340+155,0,tocolor(0,0,0),1,font2,"center","top"); --Típus
    --Jármű adatok--
    dxDrawText(cache.model,sx/2-w/2+150,sy/2+30,0,0,tocolor(0,0,0),1,font,"left","top"); --Típus
    dxDrawText(cache.plate,sx/2-w/2+195,sy/2+55,0,0,tocolor(0,0,0),1,font,"left","top"); --Rendszám
    dxDrawText(cache.km,sx/2-w/2+135,sy/2+80,0,0,tocolor(0,0,0),1,font,"left","top"); --KM
    dxDrawText("km",sx/2-w/2+300,sy/2+80,0,0,tocolor(0,0,0),1,font,"left","top");
    dxDrawText(formatMoney(guiGetText(gui)),sx/2-w/2+145,sy/2+108,0,0,tocolor(0,0,0),1,font,"left","top"); --KM
    if guiActive then 
        dxDrawText("|",sx/2-w/2+145+dxGetTextWidth(formatMoney(guiGetText(gui)),1,font,false),sy/2+108,0,0,tocolor(0,0,0,200* math.abs(getTickCount() % 1000 - 500) / 500),1,font,"left","top"); --|
    end
    dxDrawText("dt",sx/2-w/2+310,sy/2+108,0,0,tocolor(0,0,0),1,font,"left","top"); --KM
    if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
        if e:isInSlot(sx/2-w/2+145,sy/2+108,180,20) then 
            guiBringToFront(gui);
            guiActive = true;
            clickTick = getTickCount();
        else 
            guiActive = false;
            clickTick = getTickCount();
        end
        if e:isInSlot(sx/2-w/2+30,sy/2+240,180,30) then 
            if penz == "" or penz == " " or tonumber(penz) < 0 or not tonumber(penz) then 
                outputChatBox(e:getServerSyntax("Purchase","red").."You did not enter a price.",255,255,255,true);
                return;
            end
            start = getTickCount();
        end
        if e:isInSlot(sx/2-100,sy/2+h/2-45,200,30) then 
            if penz == "" or penz == " " or tonumber(penz) < 0 or not tonumber(penz) then 
                outputChatBox(e:getServerSyntax("Purchase","red").."You did not enter a price.",255,255,255,true);
                return;
            end
            if sign ~= getElementData(localPlayer,"char >> name") then 
                outputChatBox(e:getServerSyntax("Purchase","red").."You didn't sign!",255,255,255,true);
                clickTick = getTickCount();
                return;
            end
            cache.cost = tonumber(penz);
            triggerServerEvent("sell.sendOther",localPlayer,localPlayer,target,cache);

            --Close
            if isElement(gui) then 
                destroyElement(gui);
            end
            guiActive = false;
            target = false;
            cache = {};
            sign = "";
            signCount = 0;
            start = false;
            removeEventHandler("onClientRender",root,renderSell);
            -------
            outputChatBox(e:getServerSyntax("Purchase","servercolor").."You have successfully transferred Purchase to the person!",255,255,255,true);
            return;
        end
        if e:isInSlot(sx/2-100,sy/2+h/2+5,200,30) then --Bezárás
            if isElement(gui) then 
                destroyElement(gui);
            end
            guiActive = false;
            target = false;
            cache = {};
            sign = "";
            signCount = 0;
            start = false;
            removeEventHandler("onClientRender",root,renderSell);
            return;
        end
    end
    ----------------

    local rt = getRealTime();
    local date = (rt.year+1900).."."..months[rt.month].."."..rt.monthday..".";
    if not cache.date then 
        cache.date = date;
    end
    dxDrawText(cache.date or date,sx/2-w/2+85,sy/2+320,0,0,tocolor(0,0,0),1,font2,"left","top"); --Dátum

    --dxDrawRectangle(sx/2-w/2+30,sy/2+240,180,30,tocolor(200,0,0,100));
    if tonumber(start) and (getTickCount()-start) % 50 <= 5 and signCount < string.len(getElementData(localPlayer,"char >> name")) then 
        signCount = signCount + 1;
        sign = string.sub(getElementData(localPlayer,"char >> name"),1,signCount)
        start = getTickCount();
    end
    dxDrawText(sign,sx/2-w/2+30,sy/2+230,sx/2-w/2+30+180,30,tocolor(0,0,0),1,signFont,"center","top"); --Eladó

    --dxDrawText(cache.seller,sx/2-w/2+30,sy/2+270,sx/2-w/2+30+220,0,tocolor(0,0,0),1,signFont,"center","top"); --Eladó

    --dxDrawRectangle(sx/2-w/2+380,sy/2+240,180,30,tocolor(200,0,0,100));
    --dxDrawText(cache.buyer,sx/2-w/2+450,sy/2+270,sx/2-w/2+450+200,0,tocolor(0,0,0),1,signFont,"center","top"); --Vásárló

    if not isElement(target) then 
        if isElement(gui) then 
            destroyElement(gui);
        end
        guiActive = false;
        removeEventHandler("onClientRender",root,renderSell);
        target = false;
        cache = {};
        sign = "";
        signCount = 0;
        start = false;
        outputChatBox(e:getServerSyntax("Purchase","red").."Player has moved away from you or exited.",255,255,255,true);
    else 
        local x,y,z = getElementPosition(localPlayer);
        local ox,oy,oz = getElementPosition(target);
        local distance = getDistanceBetweenPoints3D(x,y,z,ox,oy,oz);
        if distance > 4 or not isElement(cache.vehicle) then 
            if isElement(gui) then 
                destroyElement(gui);
            end
            guiActive = false;
            removeEventHandler("onClientRender",root,renderSell);
            target = false;
            cache = {};
            sign = "";
            signCount = 0;
            start = false;
            outputChatBox(e:getServerSyntax("Purchase","red").."Player has moved away from you or exited.",255,255,255,true);
        end
    end

    local endColor = tocolor(sColor[1],sColor[2],sColor[3],180);
    if e:isInSlot(sx/2-100,sy/2+h/2-45,200,30) then 
        endColor = tocolor(sColor[1],sColor[2],sColor[3]);
    end
    dxDrawRectangle(sx/2-100,sy/2+h/2-45,200,30,endColor);
    dxDrawBorder(sx/2-100,sy/2+h/2-45,200,30,2,tocolor(0,0,0));
    e:shadowedText("Ready",sx/2-100,sy/2+h/2-45,sx/2-100+200,sy/2+h/2-45+30,tocolor(255,255,255),1,font,"center","center");

    local cancelColor = tocolor(red[1],red[2],red[3],180);
    if e:isInSlot(sx/2-100,sy/2+h/2+5,200,30) then 
        cancelColor = tocolor(red[1],red[2],red[3]);
    end
    dxDrawRectangle(sx/2-100,sy/2+h/2+5,200,30,cancelColor);
    dxDrawBorder(sx/2-100,sy/2+h/2+5,200,30,2,tocolor(0,0,0));
    e:shadowedText("Cancel",sx/2-100,sy/2+h/2+5,sx/2-100+200,sy/2+h/2+5+30,tocolor(255,255,255),1,font,"center","center");
end

function sellVehicle(cmd,...)
    local veh = getPedOccupiedVehicle(localPlayer);
    if veh then 
        if not exports.fv_inventory:hasItem(89) then outputChatBox(e:getServerSyntax("Purchase","red").."No Empty Purchased!",255,255,255,true) return end;

        if getElementData(veh,"veh:faction") == 0 and getElementData(veh,"veh:tulajdonos") == getElementData(localPlayer,"acc >> id") then 
            if not ... then
                outputChatBox(e:getServerSyntax("Use","red").."/"..cmd.." [Name/ID]",255,255,255,true);
                return;
            end
            local x = table.concat({...}," ");
            local targetPlayer = exports.fv_engine:findPlayer(localPlayer,x);
            if targetPlayer then 
                local x,y,z = getElementPosition(localPlayer);
                local ox,oy,oz = getElementPosition(targetPlayer);
                local distance = getDistanceBetweenPoints3D(x,y,z,ox,oy,oz);
                if distance < 3 then 
                    sign = "";
                    signCount = 0;
                    cache = {};
                    start = false;
                    target = targetPlayer;
                    cache = {
                        seller = getElementData(localPlayer,"char >> name"),
                        buyer = getElementData(targetPlayer,"char >> name"),
                        plate = getVehiclePlateText(veh),
                        model = exports.fv_vehmods:getVehicleRealName(veh),
                        km = (math.ceil(getElementData(veh,"veh:km")) or 0),
                        vehicle = veh,
                        cost = 0;
                    };
                    gui = guiCreateEdit(-1000,-1000,0,0,"",false);
                    guiEditSetMaxLength(gui,11);
                    guiActive = false;
                    removeEventHandler("onClientRender",root,renderSell);
                    addEventHandler("onClientRender",root,renderSell);
                else 
                    outputChatBox(e:getServerSyntax("Purchase","red").."Player is far from you!",255,255,255,true);
                end
            else 
                outputChatBox(e:getServerSyntax("Purchase","red").."There is no such player!",255,255,255,true);
            end
        else 
            outputChatBox(e:getServerSyntax("Purchase","red").."Your vehicle is not yours!",255,255,255,true);
            return;
        end
    else 
        outputChatBox(e:getServerSyntax("Purchase","red").."You're not in a vehicle!",255,255,255,true);
    end
end
addCommandHandler("sell",sellVehicle,false,false);
addCommandHandler("Purchase",sellVehicle,false,false);


addEvent("sell.return",true);
addEventHandler("sell.return",root,function(dataTable,other)
    if not other then 
        outputChatBox(e:getServerSyntax("Purchase","red").."Player stepped down, sale canceled.",255,255,255,true);
    else 
        sign = "";
        signCount = 0;
        start = false;
        cache = {};
        cache = tableCopy(dataTable);
        target = other;
        removeEventHandler("onClientRender",root,renderSell2);
        addEventHandler("onClientRender",root,renderSell2);
    end
end);

function renderSell2()
    local penz = cache.cost;

    local w,h = 600,700;
    dxDrawImage(sx/2-w/2,sy/2-h/2,w,h,"sellvehicle.png");

    dxDrawText(cache.seller,sx/2-w/2+130,sy/2-h/2+80,sx/2-w/2+220+200,0,tocolor(0,0,0),1,font,"center","top"); --Eladó
    dxDrawText(cache.buyer,sx/2-w/2+30,sy/2-h/2+110,sx/2-w/2+100+200,0,tocolor(0,0,0),1,font,"center","top"); --Vevő
    dxDrawText(cache.plate,sx/2-w/2+55,sy/2-h/2+145,sx/2-w/2+105+130,0,tocolor(0,0,0),1,font,"center","top"); --Rendszám
    dxDrawText(cache.model,sx/2-w/2+210,sy/2-h/2+149,sx/2-w/2+340+155,0,tocolor(0,0,0),1,font2,"center","top"); --Típus
    --Jármű adatok--
    dxDrawText(cache.model,sx/2-w/2+150,sy/2+30,0,0,tocolor(0,0,0),1,font,"left","top"); --Típus
    dxDrawText(cache.plate,sx/2-w/2+195,sy/2+55,0,0,tocolor(0,0,0),1,font,"left","top"); --Rendszám
    dxDrawText(cache.km,sx/2-w/2+135,sy/2+80,0,0,tocolor(0,0,0),1,font,"left","top"); --KM
    dxDrawText("km",sx/2-w/2+300,sy/2+80,0,0,tocolor(0,0,0),1,font,"left","top");
    dxDrawText(formatMoney(cache.cost),sx/2-w/2+145,sy/2+108,0,0,tocolor(0,0,0),1,font,"left","top"); --KM
    dxDrawText("dt",sx/2-w/2+310,sy/2+108,0,0,tocolor(0,0,0),1,font,"left","top"); --KM
    ----------------

    local rt = getRealTime();
    local date = (rt.year+1900).."."..months[rt.month].."."..rt.monthday..".";
    dxDrawText(cache.date or date,sx/2-w/2+85,sy/2+320,0,0,tocolor(0,0,0),1,font2,"left","top"); --Dátum

    if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
        if e:isInSlot(sx/2-w/2+380,sy/2+240,180,30) then 
            start = getTickCount();
            clickTick = getTickCount();
        end

        if e:isInSlot(sx/2-100,sy/2+h/2-45,200,30) then --Kész
            if getPlayerVehCount()+1 > getElementData(localPlayer,"char >> vehSlot") then 
                outputChatBox(e:getServerSyntax("Purchase","red").."You don't have a free slot to buy!",255,255,255,true);
                clickTick = getTickCount();
                return;
            else 
                if getElementData(localPlayer,"char >> money") >= tonumber(cache.cost) then 
                    triggerServerEvent("sell.accept",localPlayer,localPlayer,target,cache);
                    removeEventHandler("onClientRender",root,renderSell2);
                    target = false;
                    cache = {};
                    clickTick = getTickCount();
                    return;
                else
                    outputChatBox(e:getServerSyntax("Purchase","red").."You don't have enough money to buy!",255,255,255,true);
                    clickTick = getTickCount();
                end
            end
        end

        if e:isInSlot(sx/2-100,sy/2+h/2+5,200,30) then --Mégsem
            removeEventHandler("onClientRender",root,renderSell2);
            triggerServerEvent("sell.deny",localPlayer,localPlayer,target);
            target = false;
            cache = {};
            clickTick = getTickCount();
            return;
        end
    end

    if tonumber(start) and (getTickCount()-start) % 50 <= 5 and signCount < string.len(getElementData(localPlayer,"char >> name")) then 
        signCount = signCount + 1;
        sign = string.sub(getElementData(localPlayer,"char >> name"),1,signCount)
        start = getTickCount();
    end
    dxDrawText(cache.seller,sx/2-w/2+30,sy/2+230,sx/2-w/2+30+180,30,tocolor(0,0,0),1,signFont,"center","top"); --Eladó

    dxDrawText(sign,sx/2-w/2+380,sy/2+230,sx/2-w/2+380+180,0,tocolor(0,0,0),1,signFont,"center","top"); --Vásárló

    if not isElement(target) then 
        removeEventHandler("onClientRender",root,renderSell2);
        target = false;
        cache = {};
        sign = "";
        signCount = 0;
        start = false;
        outputChatBox(e:getServerSyntax("Purchase","red").."Seller has moved away from you or left.",255,255,255,true);
    else 
        local x,y,z = getElementPosition(localPlayer);
        local ox,oy,oz = getElementPosition(target);
        local distance = getDistanceBetweenPoints3D(x,y,z,ox,oy,oz);
        if distance > 4 or not isElement(cache.vehicle) then 
            removeEventHandler("onClientRender",root,renderSell2);
            target = false;
            cache = {};
            sign = "";
            signCount = 0;
            start = false;
            outputChatBox(e:getServerSyntax("Purchase","red").."Seller has moved away from you or left.",255,255,255,true);
        end
    end

    local endColor = tocolor(sColor[1],sColor[2],sColor[3],180);
    if e:isInSlot(sx/2-100,sy/2+h/2-45,200,30) then 
        endColor = tocolor(sColor[1],sColor[2],sColor[3]);
    end
    dxDrawRectangle(sx/2-100,sy/2+h/2-45,200,30,endColor);
    dxDrawBorder(sx/2-100,sy/2+h/2-45,200,30,2,tocolor(0,0,0));
    e:shadowedText("Kész",sx/2-100,sy/2+h/2-45,sx/2-100+200,sy/2+h/2-45+30,tocolor(255,255,255),1,font,"center","center");

    local cancelColor = tocolor(red[1],red[2],red[3],180);
    if e:isInSlot(sx/2-100,sy/2+h/2+5,200,30) then 
        cancelColor = tocolor(red[1],red[2],red[3]);
    end
    dxDrawRectangle(sx/2-100,sy/2+h/2+5,200,30,cancelColor);
    dxDrawBorder(sx/2-100,sy/2+h/2+5,200,30,2,tocolor(0,0,0));
    e:shadowedText("Elutasítás",sx/2-100,sy/2+h/2+5,sx/2-100+200,sy/2+h/2+5+30,tocolor(255,255,255),1,font,"center","center");
end

addEvent("sell.showClient",true);
addEventHandler("sell.showClient",root,function(data)
    show = not show;
    if show then 
        cache = {};
        cache = {
            buyer = data.buyer;
            seller = data.seller;
            plate = data.plate;
            model = data.model;
            km = data.km;
            date = data.date;
            cost = data.cost;
        };
        removeEventHandler("onClientRender",root,renderShow);
        addEventHandler("onClientRender",root,renderShow); 
    else 
        cache = {};
        removeEventHandler("onClientRender",root,renderShow);
    end
end);

function renderShow()
    local penz = cache.cost;

    local w,h = 600,700;
    dxDrawImage(sx/2-w/2,sy/2-h/2,w,h,"sellvehicle.png");

    dxDrawText(cache.seller,sx/2-w/2+130,sy/2-h/2+80,sx/2-w/2+220+200,0,tocolor(0,0,0),1,font,"center","top"); --Eladó
    dxDrawText(cache.buyer,sx/2-w/2+30,sy/2-h/2+110,sx/2-w/2+100+200,0,tocolor(0,0,0),1,font,"center","top"); --Vevő
    dxDrawText(cache.plate,sx/2-w/2+55,sy/2-h/2+145,sx/2-w/2+105+130,0,tocolor(0,0,0),1,font,"center","top"); --Rendszám
    dxDrawText(cache.model,sx/2-w/2+210,sy/2-h/2+149,sx/2-w/2+340+155,0,tocolor(0,0,0),1,font2,"center","top"); --Típus
    --Jármű adatok--
    dxDrawText(cache.model,sx/2-w/2+150,sy/2+30,0,0,tocolor(0,0,0),1,font,"left","top"); --Típus
    dxDrawText(cache.plate,sx/2-w/2+195,sy/2+55,0,0,tocolor(0,0,0),1,font,"left","top"); --Rendszám
    dxDrawText(cache.km,sx/2-w/2+135,sy/2+80,0,0,tocolor(0,0,0),1,font,"left","top"); --KM
    dxDrawText("km",sx/2-w/2+300,sy/2+80,0,0,tocolor(0,0,0),1,font,"left","top");
    dxDrawText(formatMoney(cache.cost),sx/2-w/2+145,sy/2+108,0,0,tocolor(0,0,0),1,font,"left","top"); --KM
    dxDrawText("dt",sx/2-w/2+310,sy/2+108,0,0,tocolor(0,0,0),1,font,"left","top"); --KM
    ----------------
    dxDrawText(cache.date,sx/2-w/2+85,sy/2+320,0,0,tocolor(0,0,0),1,font2,"left","top"); --Dátum

    dxDrawText(cache.seller,sx/2-w/2+30,sy/2+230,sx/2-w/2+30+180,30,tocolor(0,0,0),1,signFont,"center","top"); --Eladó
    dxDrawText(cache.buyer,sx/2-w/2+380,sy/2+230,sx/2-w/2+380+180,0,tocolor(0,0,0),1,signFont,"center","top"); --Vásárló

    local cancelColor = tocolor(red[1],red[2],red[3],180);
    if e:isInSlot(sx/2-100,sy/2+h/2+5,200,30) then 
        cancelColor = tocolor(red[1],red[2],red[3]);
        if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
            cache = {};
            show = false;
            clickTick = getTickCount();
            removeEventHandler("onClientRender",root,renderShow);
        end
    end
    dxDrawRectangle(sx/2-100,sy/2+h/2+5,200,30,cancelColor);
    dxDrawBorder(sx/2-100,sy/2+h/2+5,200,30,2,tocolor(0,0,0));
    e:shadowedText("Bezárás",sx/2-100,sy/2+h/2+5,sx/2-100+200,sy/2+h/2+5+30,tocolor(255,255,255),1,font,"center","center");
end

--UTILS--
function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end
function tableCopy(tab, recursive)
    local ret = {}
    for key, value in pairs(tab) do
        if (type(value) == "table") and recursive then ret[key] = table.copy(value)
        else ret[key] = value end
    end
    return ret
end
function getPlayerVehCount()
	local count = 0;
	for k,v in pairs(getElementsByType("vehicle")) do 
		if getElementData(v,"veh:id") then 
			if getElementData(v,"veh:faction") == 0 then
				if getElementData(v,"veh:tulajdonos") == getElementData(localPlayer,"acc >> id") then 
					count = count + 1;
				end
			end
		end
	end
	return count;
 end