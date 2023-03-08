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
};
local currentHifi = false;
local panel = {sx/2,sy/2};
local move = {};
local sounds = {};
local hifiClick = 0;

addEventHandler("onClientResourceStart",root,function()
    for k,v in pairs(getElementsByType("object")) do 
        if (getElementData(v,"hifi.id") or -1) > 0 then 
            destroyHifiSound(v);
            if getElementData(v,"hifi.state") then 
                playHifiSound(v,getElementData(v,"hifi.station"),getElementData(v,"hifi.volume"));
            end
        end
    end
end);

addEventHandler("onClientElementDataChange",root,function(dataName,oldValue, newValue)
    if getElementType(source) == "object" and (getElementData(source,"hifi.id") or -1) > 0 and isElementStreamedIn(source) then 
        if dataName == "hifi.state" then 
            destroyHifiSound(source);
            if newValue then 
                playHifiSound(source,1,getElementData(source,"hifi.volume"));
            end
        end
        if dataName == "hifi.station" then 
            destroyHifiSound(source);
            playHifiSound(source,newValue,getElementData(source,"hifi.volume"));
        end
        if dataName == "hifi.volume" then 
            setSoundMaxDistance(sounds[source],newValue/2);
            setSoundVolume(sounds[source],newValue/6);
        end
    end
end);

addEventHandler("onClientElementStreamIn", root,function()
    if getElementType(source) == "object" and (getElementData(source,"hifi.id") or -1) > 0 then 
        destroyHifiSound(source);
        if getElementData(source,"hifi.state") then 
            playHifiSound(source,getElementData(source,"hifi.station"),getElementData(source,"hifi.volume"));
        end
    end
end);

addEventHandler("onClientElementStreamOut", root,function()
    if getElementType(source) == "object" and (getElementData(source,"hifi.id") or -1) > 0 then 
        destroyHifiSound(source);
    end
end);

addEventHandler("onClientElementDestroy", root, function()
    if getElementType(source) == "object" and (getElementData(source,"hifi.id") or -1) > 0 then 
        destroyHifiSound(source);
    end
end);

function playHifiSound(hifi,station,volume)
    if not station then station = 1 end;
    if not volume then volume = 80 end;
    local pos = Vector3(getElementPosition(hifi));
    sounds[hifi] = playSound3D(stations[station][2],pos.x,pos.y,pos.z);
    setSoundMaxDistance(sounds[hifi],volume/2);
    setSoundVolume(sounds[source],volume/6);
    setElementData(sounds[hifi],"hifi",hifi);       
    setElementDimension(sounds[hifi],getElementDimension(hifi));
    setElementInterior(sounds[hifi],getElementInterior(hifi));         
end

function destroyHifiSound(element)
    if sounds[element] then 
        if isElement(sounds[element]) then 
            destroyElement(sounds[element]);
        end
        sounds[element] = nil;
    end
end

addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
    if button == "right" and state == "down" and clickedElement and (getElementData(clickedElement,"hifi.id") or -1) > 0 then 
        local pos = Vector3(getElementPosition(localPlayer));
        if getDistanceBetweenPoints3D(wx,wy,wz,pos.x,pos.y,pos.z) < 3 then 
            if not currentHifi then 
                currentHifi = clickedElement;
                panel = {x,y};
                move = {};
                removeEventHandler("onClientRender",root,drawHifi);
                addEventHandler("onClientRender",root,drawHifi);
            end
        else 
            outputChatBox(e:getServerSyntax("Item","red").."You're too far from the hi-fi.",255,255,255,true);
        end
    end
    if currentHifi and button == "left" and state == "down" then --Panel Show
        if e:isInSlot(panel[1]+180,panel[2],20,20) then --Close
            closeHifi();
        elseif e:isInSlot(panel[1]+10,panel[2]+30,180,20) then --Change State
            if hifiClick+1000 > getTickCount() then 
                return outputChatBox(e:getServerSyntax("Hifi","red").."Not so fast!",255,255,255,true);
            end
            setElementData(currentHifi,"hifi.state",not (getElementData(currentHifi,"hifi.state") or false));
            if getElementData(currentHifi,"hifi.state") then 
                if not tonumber(getElementData(currentHifi,"hifi.volume")) then 
                    setElementData(currentHifi,"hifi.volume",50);
                end
                setElementData(currentHifi,"hifi.station",1);
            end
            exports.fv_chat:createMessage(localPlayer, "pressed a button on the hi-fi.",1);
            hifiClick = getTickCount();
        elseif e:isInSlot(panel[1]+10,panel[2]+60,180,20) then --Left
            if hifiClick+1000 > getTickCount() then 
                return outputChatBox(e:getServerSyntax("Hifi","red").."Not so fast!",255,255,255,true);
            end
            local station = (getElementData(currentHifi,"hifi.station") or 1);
            if station-1 <= 0 then 
                setElementData(currentHifi,"hifi.station",#stations);
            else 
                setElementData(currentHifi,"hifi.station",station - 1);
            end
            exports.fv_chat:createMessage(localPlayer, "pressed a button on the hi-fi.",1);
            hifiClick = getTickCount();
        elseif e:isInSlot(panel[1]+10,panel[2]+90,180,20) then --Right
            if hifiClick+1000 > getTickCount() then 
                return outputChatBox(e:getServerSyntax("Hifi","red").."Not so fast!",255,255,255,true);
            end
            local station = (getElementData(currentHifi,"hifi.station") or 1);
            if station+1 > #stations then 
                setElementData(currentHifi,"hifi.station",1);
            else 
                setElementData(currentHifi,"hifi.station",station + 1);
            end
            exports.fv_chat:createMessage(localPlayer, "pressed a button on the hi-fi.",1);
            hifiClick = getTickCount();
        elseif e:isInSlot(panel[1]+10,panel[2]+120,180,20) then --Hifi UP
            triggerServerEvent("hifi.up",localPlayer,localPlayer,currentHifi);
            destroyHifiSound(currentHifi);
            closeHifi();
        end
    end
    if currentHifi and button == "left" then 
        local volume = (getElementData(currentHifi,"hifi.volume") or 80);
        if e:isInSlot(panel[1]+10+volume,panel[2]+160,20,20) then --Volume
            if state == "down" then 
                move[1] = true;
                move[2] = volume - x;
            end
        end
        if state == "up" then 
            if move[1] then 
                move = {};
            end
        end
    end
end);

function closeHifi()
    currentHifi = false;
    panel = {};
    move = {};
    removeEventHandler("onClientRender",root,drawHifi);
end

function drawHifi()
    if not currentHifi or not isElement(currentHifi) then 
        closeHifi();
        return;
    end
    local pos = Vector3(getElementPosition(localPlayer));
    local pos2 = Vector3(getElementPosition(currentHifi));
    if getDistanceBetweenPoints3D(pos.x,pos.y,pos.z,pos2.x,pos2.y,pos2.z) > 3 then 
        closeHifi();
        return;
    end

    dxDrawRectangle(panel[1],panel[2],200,200,tocolor(0,0,0,180));
    dxDrawRectangle(panel[1]-3,panel[2],3,200,tocolor(sColor[1],sColor[2],sColor[3],180));

    dxDrawText("Radio",panel[1],panel[2],panel[1]+200,panel[2],tocolor(255,255,255),1,e:getFont("rage",12),"center","top");

    local closeColor = tocolor(255,255,255);
    if e:isInSlot(panel[1]+180,panel[2],20,20) then --Close
        closeColor = tocolor(red[1],red[2],red[3]);
    end
    dxDrawText("",panel[1]+180,panel[2],panel[1]+180+20,panel[2]+20,closeColor,1,e:getFont("AwesomeFont",12),"center","center");

    local stateAlpha = 180;
    if e:isInSlot(panel[1]+10,panel[2]+30,180,20) then 
        stateAlpha = 250;
    end
    local stateColor = tocolor(red[1],red[2],red[3],stateAlpha);
    local state = "Kikapcsolva";
    if (getElementData(currentHifi,"hifi.state") or false) then 
        stateColor = tocolor(sColor[1],sColor[2],sColor[3],stateAlpha);
        state = "Bekapcsolva";
    end

    dxDrawRectangle(panel[1]+10,panel[2]+30,180,20,stateColor);
    dxDrawText(state,panel[1]+10,panel[2]+30,panel[1]+190,panel[2]+50,tocolor(255,255,255),1,e:getFont("rage",12),"center","center");


    local leftColor = tocolor(sColor[1],sColor[2],sColor[3],180);
    if e:isInSlot(panel[1]+10,panel[2]+60,180,20) then 
        leftColor = tocolor(sColor[1],sColor[2],sColor[3]);
    end
    dxDrawRectangle(panel[1]+10,panel[2]+60,180,20,leftColor);
    e:shadowedText("",panel[1]+10,panel[2]+60,panel[1]+10+180,panel[2]+60+20,tocolor(255,255,255),1,e:getFont("AwesomeFont",11),"center","center");

    local rightColor = tocolor(sColor[1],sColor[2],sColor[3],180);
    if e:isInSlot(panel[1]+10,panel[2]+90,180,20) then 
        rightColor = tocolor(sColor[1],sColor[2],sColor[3]);
    end
    dxDrawRectangle(panel[1]+10,panel[2]+90,180,20,rightColor);
    e:shadowedText("",panel[1]+10,panel[2]+90,panel[1]+10+180,panel[2]+90+20,tocolor(255,255,255),1,e:getFont("AwesomeFont",11),"center","center");


    local upColor = tocolor(red[1],red[2],red[3],180);
    if e:isInSlot(panel[1]+10,panel[2]+120,180,20) then 
        upColor = tocolor(red[1],red[2],red[3]);
    end
    dxDrawRectangle(panel[1]+10,panel[2]+120,180,20,upColor);
    dxDrawText("Felvesz",panel[1]+10,panel[2]+120,panel[1]+10+180,panel[2]+120+20,tocolor(255,255,255),1,e:getFont("rage",12),"center","center");


    local volume = getElementData(currentHifi,"hifi.volume") or 80;
    if isCursorShowing() then 
        local cursorX,cursorY = getCursorPosition();
        cursorX,cursorY = sx * cursorX, sy * cursorY;

        if move[1] then 
            volume = cursorX + move[2];
        end
        if volume < 0 then 
            volume = 0;
        end
        if volume > 160 then 
            volume = 160;
        end
        setElementData(currentHifi,"hifi.volume",volume);
    else 
        if move[1] then 
            move = {};
        end
    end
    dxDrawRectangle(panel[1]+10,panel[2]+170,180,3,tocolor(100,100,100));
    dxDrawRectangle(panel[1]+10+volume,panel[2]+160,20,20,tocolor(sColor[1],sColor[2],sColor[3]));


    local station = "Kikapcsolva.";
    if (getElementData(currentHifi,"hifi.state") or false) then 
        station = stations[getElementData(currentHifi,"hifi.station") or 1][1];
    end
    dxDrawText(station,panel[1],panel[2]+180,panel[1]+200,0,tocolor(255,255,255),1,e:getFont("rage",10),"center","top");
end

addEventHandler("onClientRender",root,function()
    local player = Vector3(getElementPosition(localPlayer));
    for k,v in pairs(sounds) do 
        local hifi = Vector3(getElementPosition(v));
        if getDistanceBetweenPoints3D(hifi.x,hifi.y,hifi.z,player.x,player.y,player.z) < 15 then 
            local hifi = getElementData(v,"hifi")
            local bt = getSoundFFTData(v,2048,257);
            if bt then 
                for i=1,256 do 
                    if bt[i] and bt[i] > 0 then 
                        local value = math.sqrt(bt[i]) * 256;
                        local progress = value/2;
                        local scale = interpolateBetween(1.5, 0, 0, 0.8, 0, 0, progress, "OutQuad");
                        setObjectScale(hifi,scale);
                    end
                end
            end
        end
    end
end);


