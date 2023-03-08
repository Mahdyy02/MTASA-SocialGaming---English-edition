

--Engine--
local e = exports.fv_engine;
local sColor = {e:getServerColor("servercolor",false)};
local red = {e:getServerColor("red",false)};
local icons = e:getFont("AwesomeFont",16);
local icons2 = e:getFont("AwesomeFont",20);
----------

local s = Vector2(guiGetScreenSize());
local show = false;
local panel = {s.x/2-200,s.y/2-100,400,200};
local move = {};
local volume = {90};
local click = 0;

local stations = {
    {"Rádió 1", "http://213.181.210.106:80/high.mp3"},
    {"Rádió 88", "http://www.radio88.hu/stream/radio88.pls"},
    {"Petőfi Rádió","http://stream001.radio.hu:8080/mr2.mp3.m3u"},
    {"Dance FM", "http://173.192.207.51:8062/listen.pls"},
    {"Disco Rádió","http://stream.mercyradio.eu/disco.mp3"},
    {"KroneHit", "http://relay.181.fm:8068"},
    {"Old School", "http://relay.181.fm:8068"},
    {"Radio HiT", "http://asculta.radiohitfm.ro:8340/listen.pls"},
    {"Hard Techno", "http://tunein.t4e.dj/hard/dsl/mp3"},
    {"ReggaeCast", "http://64.202.98.32:808/listen.pls"},
    {"Hip Hop", "http://sverigesradio.se/topsy/direkt/2576-hi-aac.pls"},
    {"Uzic - Techo/Minimal", "http://stream.uzic.ch:9010/listen.pls"},
    {"HOT 108 Jamz", "http://108.61.30.179:4010/listen.pls"},
    {"Lakodalmas Rádió","http://stream.mercyradio.eu/lakodalmas.mp3"},
    {"Turbó Mulatós", "http://stream.mercyradio.eu/roma.mp3"},
}

local radios = {};

function render()
    if show ~= getPedOccupiedVehicle(localPlayer) or not show or not isElement(show) then 
        closeRadio();
    end
    if not show then return end;
    if isCursorShowing() then 
        local cursorX,cursorY = getCursorPosition();
        cursorX,cursorY = s.x * cursorX, s.y * cursorY;
        if move[3] then 
            panel[1] = cursorX + move[1];
            panel[2] = cursorY + move[2];
        end
        if volume[2] then 
            volume[1] = cursorX + volume[3];
            if volume[1] < 0 then 
                volume[1] = 0;
            end
            if volume[1] > 180 then 
                volume[1] = 180;
            end
            setElementData(show,"radio.volume",volume[1]);
        end
    else 
        if move[3] then 
            move[3] = false;
            move = {};
        end
    end

    dxDrawRectangle(panel[1],panel[2],panel[3],panel[4],tocolor(0,0,0,150));
    dxDrawRectangle(panel[1],panel[2],panel[3],20,tocolor(0,0,0,150));
    dxDrawText("TheDevils - Radio",panel[1],panel[2],panel[1]+panel[3],panel[2]+20,tocolor(255,255,255),1,e:getFont("rage",12),"center","center");
    dxDrawRectangle(panel[1]-3,panel[2],3,panel[4],tocolor(sColor[1],sColor[2],sColor[3],180));

    if radios[show] then 
        local bt = getSoundFFTData(radios[show],2048,257);
        if bt then 
            for i=1,256 do 
                if bt[i] and bt[i] > 0 then 
                local value = math.sqrt(bt[i]) * 128;
                    if value < panel[4] then 
                        dxDrawRectangle(panel[1],panel[2]+panel[4],1+(i*1.5),-value,tocolor(200,200,200,150));
                    end
                end
            end
        end
    end

    dxDrawRectangle(panel[1]+100,panel[2]+50,200,3,tocolor(200,200,200,150));
    dxDrawRectangle(panel[1]+100+volume[1],panel[2]+40,20,20,tocolor(sColor[1],sColor[2],sColor[3],230));

    if (getElementData(show,"radio.state") or false) then 
        local playColor = tocolor(255,255,255);
        if e:isInSlot(panel[1]+185,panel[2]+70,30,30) then 
            playColor = tocolor(red[1],red[2],red[3]);
        end
        e:shadowedText("",panel[1]+185,panel[2]+70,panel[1]+185+30,panel[2]+70+30,playColor,1,icons,"center","center");
    else 
        local playColor = tocolor(255,255,255);
        if e:isInSlot(panel[1]+185,panel[2]+70,30,30) then 
            playColor = tocolor(sColor[1],sColor[2],sColor[3]);
        end
        e:shadowedText("",panel[1]+185,panel[2]+70,panel[1]+185+30,panel[2]+70+30,playColor,1,icons,"center","center");
    end

    if getElementData(show,"radio.state") or false then
        dxDrawText(stations[(getElementData(show,"radio.station") or 1)][1],panel[1],panel[2]+100,panel[1]+panel[3],0,tocolor(255,255,255),1,e:getFont("rage",15),"center","top");
        local streamTitle = getSoundMetaTags(radios[show])["stream_title"];
        if streamTitle and string.len(streamTitle) > 2 then 
            dxDrawText(streamTitle,panel[1],panel[2]+120,panel[1]+panel[3],0,tocolor(200,200,200),1,e:getFont("rage",11),"center","top");
        end
    else 
        dxDrawText("Turned off.",panel[1],panel[2]+100,panel[1]+panel[3],0,tocolor(255,255,255),1,e:getFont("rage",15),"center","top");
    end

    local leftColor = tocolor(255,255,255);
    if e:isInSlot(panel[1]+150,panel[2]+70,30,30) then 
        leftColor = tocolor(sColor[1],sColor[2],sColor[3]);
    end
    dxDrawText("",panel[1]+150,panel[2]+70,panel[1]+150+30,panel[2]+70+30,leftColor,1,icons2,"center","center");

    local rightColor = tocolor(255,255,255);
    if e:isInSlot(panel[1]+220,panel[2]+70,30,30) then 
        rightColor = tocolor(sColor[1],sColor[2],sColor[3]);
    end
    dxDrawText("",panel[1]+220,panel[2]+70,panel[1]+220+30,panel[2]+70+30,rightColor,1,icons2,"center","center");

end

addEventHandler("onClientClick",root,function(button,state,x,y)
if not show then return end;
    if button == "left" then 
        if state == "down" then 
            if not move[3] then 
                if e:isInSlot(panel[1],panel[2],panel[3],20) then 
                    move = {panel[1] - x, panel[2] - y, true};
                end
                if e:isInSlot(panel[1]+100+volume[1],panel[2]+40,20,20) then 
                    volume[2] = true;
                    volume[3] = volume[1] - x;
                end
            end
            if e:isInSlot(panel[1]+185,panel[2]+70,30,30) then --Play/Stop
                if click+500 > getTickCount() then outputChatBox(e:getServerSyntax("Radio","red").."Not so fast!",255,255,255,true) return end;
                if (getElementData(show,"radio.state") or false) then 
                    setElementData(show,"radio.state",false);
                else 
                    setElementData(show,"radio.state",true);
                    setElementData(show,"radio.station",1);
                    setElementData(show,"radio.volume",volume[1]);
                end
                playSound("click.wav",false,false);
                click = getTickCount();
            end
            if (getElementData(show,"radio.state") or false) then 
                if e:isInSlot(panel[1]+150,panel[2]+70,30,30) then --Left
                    if click+500 > getTickCount() then outputChatBox(e:getServerSyntax("Radio","red").."Not so fast!",255,255,255,true) return end;
                    local current = (getElementData(show,"radio.station") or 1);
                    if current-1 <= 0 then 
                        setElementData(show,"radio.station",#stations);
                    else 
                        setElementData(show,"radio.station",current - 1);
                    end
                    playSound("click.wav",false,false);
                    click = getTickCount();
                end
                if e:isInSlot(panel[1]+220,panel[2]+70,30,30) then --Right
                    if click+500 > getTickCount() then outputChatBox(e:getServerSyntax("Radio","red").."Not so fast!",255,255,255,true) return end;
                    local current = (getElementData(show,"radio.station") or 1);
                    if current+1 > #stations then 
                        setElementData(show,"radio.station",1);
                    else 
                        setElementData(show,"radio.station",current + 1);
                    end
                    playSound("click.wav",false,false);
                    click = getTickCount();
                end
            end
        elseif state == "up" then 
            if move[3] then 
                move[3] = false;
                move = {};
            end
            if volume[2] then 
                volume[2] = false;
                volume[3] = nil;
            end
        end
    end
end);

bindKey("r","down",function()
    if isChatBoxInputActive() then return end;
    if getElementData(localPlayer,"collapsed") then return end;
    if getElementData(localPlayer,"guiActive") then return end;
    if isCursorShowing() then return end;
    local veh = getPedOccupiedVehicle(localPlayer);
    if veh then 
        if show then 
            closeRadio();
        else
            local seat = getPedOccupiedVehicleSeat(localPlayer);
            if seat < 2 then 
                removeEventHandler("onClientRender",root,render);
                addEventHandler("onClientRender",root,render);
                show = veh;
                volume = {};
                volume[1] = getElementData(show,"radio.volume") or 180;
            end
        end
    end
end);

function closeRadio()
    removeEventHandler("onClientRender",root,render);
    show = false;
end

function destroyRadio(veh)
    if radios[veh] then 
        destroyElement(radios[veh]);
        radios[veh] = nil;
    end
end
addEventHandler("onClientElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "vehicle" and isElementStreamedIn(source) then 
        if dataName == "radio.state" then 
            destroyRadio(source)
            if newValue then 
                local pos = Vector3(getElementPosition(source));
                radios[source] = playSound3D(stations[(getElementData(source,"radio.station") or 1)][2],pos.x,pos.y,pos.z);
                setSoundVolume(radios[source],(getElementData(source,"radio.volume") or 200) / 100);
            end
        end
        if dataName == "radio.volume" then 
            if getElementData(source,"radio.state") or false then 
                if not radios[source] then 
                    local pos = Vector3(getElementPosition(source));
                    radios[source] = playSound3D(stations[(getElementData(source,"radio.station") or 1)][2],pos.x,pos.y,pos.z);
                    setSoundVolume(radios[source],(getElementData(source,"radio.volume") or 200) / 100);
                else 
                    setSoundVolume(radios[source],(newValue or 200) / 200);
                end
            end
        end
        if dataName == "radio.station" then 
            destroyRadio(source);
            local pos = Vector3(getElementPosition(source));
            radios[source] = playSound3D(stations[(getElementData(source,"radio.station") or 1)][2],pos.x,pos.y,pos.z);
            setSoundVolume(radios[source],(getElementData(source,"radio.volume") or 200) / 100);
        end
    end
end);

addEventHandler("onClientResourceStart",resourceRoot,function()
    for k,v in pairs(getElementsByType("vehicle",root,true)) do 
        if getElementData(v,"radio.state") or false then 
            local pos = Vector3(getElementPosition(v));
            if stations[(getElementData(v,"radio.station") or 1)] and stations[(getElementData(v,"radio.station") or 1)][2] then 
                radios[v] = playSound3D(stations[(getElementData(v,"radio.station") or 1)][2],pos.x,pos.y,pos.z);
                setSoundVolume(radios[v],(getElementData(v,"radio.volume") or 200) / 100);
            end
        end
    end
end);

addEventHandler("onClientElementStreamIn", root,function()
    if getElementType(source) == "vehicle" then
        if getElementData(source,"radio.state") or false then 
            destroyRadio(source);
            local pos = Vector3(getElementPosition(source));
            radios[source] = playSound3D(stations[(getElementData(source,"radio.station") or 1)][2],pos.x,pos.y,pos.z);
            setSoundVolume(radios[source],(getElementData(source,"radio.volume") or 200) / 100);
        end
    end
end);

addEventHandler("onClientElementStreamOut", root, function()
    if getElementType(source) == "vehicle" then
        destroyRadio(source);
    end
end);

addEventHandler("onClientElementDestroy", root, function()
    if getElementType(source) == "vehicle" then
        destroyRadio(source);
    end
end);

addEventHandler("onClientPreRender",root,function()
    local veh = getPedOccupiedVehicle(localPlayer);
    for k,v in pairs(radios) do
        if v and isElement(v) then 
            local vehdim = getElementDimension(k);
            local vehint = getElementInterior(k);
            local pos = Vector3(getElementPosition(k));
            if vehdim ~= getElementDimension(v) then 
                setElementDimension(v,vehdim);
            end
            if vehint ~= getElementInterior(v) then 
                setElementInterior(v,vehint);
            end
            setElementPosition(v,pos.x,pos.y,pos.z);

            if (veh == k) then 
                setSoundVolume(v,((getElementData(k,"radio.volume") or 200) / 50));
                setSoundMaxDistance(v,50);
            else
                if getElementData(k, "veh:ablak") then
                    setSoundVolume(v,((getElementData(k,"radio.volume") or 200) / 300));
                    setSoundMaxDistance(v,5);
                else 
                    setSoundVolume(v,((getElementData(k,"radio.volume") or 200) / 150));
                    setSoundMaxDistance(v,50);
                end
            end
        else 
            radios[k] = nil;
        end
    end
end);