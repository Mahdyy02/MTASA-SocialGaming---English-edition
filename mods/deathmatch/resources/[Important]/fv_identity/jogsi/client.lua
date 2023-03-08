local current = 0;
local show = false;
local kerdesek = {
    {"9adeh el sor3a el 9oswa fel mdina?","300 km/h","40 km/h","50 km/h","100 km/h",3},
    {"Shneya naw3 el 4aw elli tnajem testa3mlou fi karhabtek?","abye4","a7mer","a54ar","wardi",1},
    {"Lezmek 3andek is3afet fel karhba?","Eyh","Le","Kima theb","momken",1},
    {"Karhbtek tfal9etleha 3ajla.\n tnajem tkamel?","Moleha rabby","Ne7iha w nkamel","Ne9ef","Nemshi lel salle7",3},
    {"Anehi el jiha li tsou9 feha?","Imin","fel west","Kima theb","Isar",1},
    {"Wa9t ywa9aflek 7akem shneya ta3mel?","Ne9ef direct","nraki 3am imin w ne9ef","Nemshi lel markez","N5af w nohreb",2},
    {"Shneya sor3a el 9oswa fel autoroute?","200 km/h","50 km/h","90 km/h","20 km/h",3},
    {"Wa9t tshouf karhba tejri feha siren shta3mel?","No9reb lel isar besh ydoubel","Ne9ef","chihemni fih","Kima nheb",1},
    {"El karhba etdakhen bkolha.\nShta3mel?","Shneya el moshkla sokhnet","Ne9ef nkalem salle7","Nkamel beha lel salle7","Elli yse3edni",2},
    {"Ken 4rabt we7ed bel karhba shta3mel","Oumourou howa ma7alesh 3inih","N3awnou belli na9der","Nkalem el ambulance","Nohreb",2},
    {"Kif yebda m5adem el 4 phares tnajem tdouble 3lih?","Najem","Manajemsh","Kima nheb","Neb3ed alih",2},
}
local cache = {};
local kesz = false;
local carMarker = false;
local currentMarker = {};

local ped = createPed(20,1488.9400634766, 1305.3107910156, 1093.2963867188);
setElementDimension(ped,6);
setElementInterior(ped,3);
setElementRotation(ped,0,0,267);
setElementData(ped,"ped >> name","Rick Titball");
setElementData(ped,"ped >> type","Driving school");

local route = {
    {1213.6643066406, -1844.5220947266, 13.3828125},
    {1368.4417724609, -1872.6175537109, 12.814780235291},
    {1550.3953857422, -1874.5502929688, 12.814604759216},
    {1703.1390380859, -1814.0313720703, 12.798000335693},
    {1819.5239257813, -1872.7563476563, 12.844794273376},
    {1963.8454589844, -1874.6854248047, 12.814319610596},
    {1901.5787353516, -1750.9326171875, 12.814069747925},
    {1705.9638671875, -1730.4018554688, 12.815205574036},
    {1468.5947265625, -1730.0063476563, 12.815147399902},
    {1261.5047607422, -1710.6195068359, 12.814549446106},
    {1173.0867919922, -1783.4173583984, 12.830400466919},
    {1213.6643066406, -1844.5220947266, 13.3828125}
}

addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
if clickedElement == ped then 
    if state == "down" then 
        if not show then 
            if getElementData(localPlayer,"char >> money") < 2000 then 
                outputChatBox(exports.fv_engine:getServerSyntax("Driving license","red").."You don't have enough money! "..sColor2.."(2000 dt)"..white..".",255,255,255,true);
                return;
            end
            show = true;
            kesz = false;
            cache = {};
            current = 1;
            removeEventHandler("onClientRender",root,renderKerdesek);
            addEventHandler("onClientRender",root,renderKerdesek);
            setElementFrozen(localPlayer,true);
            -- setElementData(localPlayer,"char >> money",getElementData(localPlayer,"char >> money") - 2000);
            triggerServerEvent("ac.elementData",localPlayer,localPlayer,"char >> money",getElementData(localPlayer,"char >> money") - 2000);
        end
    end
end
end);   

function renderKerdesek()
    dxDrawRectangle(sx/2-300,sy/2-200,600,300,tocolor(0,0,0,180));
    dxDrawRectangle(sx/2-300,sy/2-200,3,300,tocolor(sColor[1],sColor[2],sColor[3],180));

    if not kesz then 
        dxDrawText(kerdesek[current][1],0,sy/2-160,sx,400,tocolor(255,255,255),1,font,"center");
        for k,v in pairs(kerdesek[current]) do 
            if k ~= 1 and k ~= 6 then 
                local color = tocolor(50,50,50,170);
                if e:isInSlot(sx/2-550/2,sy/2-150+(k*40),550,30) then 
                    color = tocolor(sColor[1],sColor[2],sColor[3],180);
                end
                dxDrawRectangle(sx/2-550/2,sy/2-150+(k*40),550,30,color);
                dxDrawText(v,sx/2-550/2,sy/2-150+(k*40),sx/2-550/2+550,sy/2-150+(k*40)+30,tocolor(255,255,255),1,font,"center","center")
            end
        end
    else 
        local all = 0;
        for k,v in pairs(cache) do 
            if v then 
                all = all + 1;
            end
        end
        all = all*10;

        if all < 60 then 
            dxDrawText("You have failed the test.",0,sy/2-160,sx,400,tocolor(255,255,255),1,font,"center");
        else 
            dxDrawText("Successful test.\n\n\nWait a while and the practice exam will begin",0,sy/2-160,sx,400,tocolor(255,255,255),1,font,"center");
        end
        dxDrawText("\n"..all.."%",0,sy/2-160,sx,400,tocolor(255,255,255),1,font,"center");
    end
end

addEventHandler("onClientKey",root,function(button,state)
    if button == "mouse1" and state then 
        if show then 
            for k,v in pairs(kerdesek[current]) do 
                if k ~= 1 and k ~= 6 then 
                    if e:isInSlot(sx/2-550/2,sy/2-150+(k*40),550,30) then 
                        if kerdesek[current][6] == k-1 then 
                            cache[current] = true;
                        else 
                            cache[current] = false;
                        end
                        current = current + 1;
                        if current >= #kerdesek then 
                            kesz = true;
                            setTimer(function()
                                kesz = false;
                                show = false;
                                removeEventHandler("onClientRender",root,renderKerdesek);

                                local all = 0;
                                for k,v in pairs(cache) do 
                                    if v then 
                                        all = all + 1;
                                    end
                                end
                                all = all*10;
                                if all > 60 then 
                                    startGyakorlati();
                                end
                                cache = {};
                                setElementFrozen(localPlayer,false);
                            end,3000,1);
                        end
                    end
                end
            end
        end
    end
end);

function startGyakorlati()
    outputChatBox(exports.fv_engine:getServerSyntax("Driving license","servercolor").."Go to the BLUE marker to get started.",255,255,255,true);
    if isElement(carMarker) then 
        destroyElement(carMarker);
    end
    carMarker = createMarker(1244.4801025391, -1834.0098876953, 13.392681121826,"checkpoint",2,0,0,200,100);
    addEventHandler("onClientMarkerHit",carMarker,function(hitElement,dim)
        if hitElement == localPlayer then 
            if isPedInVehicle(localPlayer) then 
                outputChatBox(exports.fv_engine:getServerSyntax("Driving license","red").."You can't go in a car!",255,255,255,true);
                return;
            end
            triggerServerEvent("jogsi.givecar",localPlayer,localPlayer);
            destroyElement(source);
            current = 0;
            getNextMarker();
        end
    end);
    outputDebugString(tostring(carMarker))

    for k,v in pairs(currentMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    currentMarker = {};
end

function getNextMarker()
    for k,v in pairs(currentMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    currentMarker = {};

    current = current + 1;
    local x,y,z = unpack(route[current]);
    currentMarker[1] = createMarker(x,y,z,"checkpoint",2,200,0,0,100);
    if current == #route then 
        addEventHandler("onClientMarkerHit",currentMarker[1],function(hitElement)
            if hitElement == localPlayer then 
                local veh = getPedOccupiedVehicle(localPlayer);
                if veh and getElementData(localPlayer,"jogsi.veh") == veh then 
                    for k,v in pairs(currentMarker) do 
                        if isElement(v) then 
                            destroyElement(v);
                        end
                    end
                    currentMarker = {};
                    triggerServerEvent("jogsi.end",localPlayer,localPlayer);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Driving license","red").."This is not the training car!",255,255,255,true);
                    return; 
                end
            end
        end);   
    else 
        addEventHandler("onClientMarkerHit",currentMarker[1],function(hitElement)
            if hitElement == localPlayer then 
                local veh = getPedOccupiedVehicle(localPlayer);
                if veh and getElementData(localPlayer,"jogsi.veh") == veh then 
                    getNextMarker();
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Driving license","red").."This is not the training car!",255,255,255,true);
                    return; 
                end
            end
        end);  
    end
    currentMarker[2] = createBlip(x,y,z,1);
    setElementData(currentMarker[2],"blip >> name","Next point");
    setElementData(currentMarker[2],"blip >> color",{200,0,0});
end


--Card Drawing and Functions--

local cardCache = {};
local cardState = false;
local click = 0;
function renderJogsi()
    dxDrawImage(sx/2-200,sy/2-100,400,200,"jogsi/alap.png");
    dxDrawText(sColor2..cardCache.name,sx/2-110,sy/2-49,400,200,tocolor(255,255,255),1,font,"left","top",false,false,false,true);
    dxDrawText(sColor2..getGender(cardCache.gender),sx/2-150,sy/2-28,400,200,tocolor(255,255,255),1,smallFont,"left","top",false,false,false,true);
    dxDrawText(sColor2..cardCache.date,sx/2-145,sy/2+15,400,200,tocolor(255,255,255),1,smallFont,"left","top",false,false,false,true);
    dxDrawText(red2..cardCache.exdate,sx/2-80,sy/2+40,400,200,tocolor(255,255,255),1,smallFont,"left","top",false,false,false,true);
    dxDrawText(sColor2..cardCache.name,sx/2-80,sy/2+60,400,200,tocolor(255,255,255),1,signFont,"left","top",false,false,false,true);

    if isElementWithinColShape(localPlayer,varoshazaCol) and cardCache.name == getElementData(localPlayer,"char >> name") then 
        local color = tocolor(sColor[1],sColor[2],sColor[3],180);
        if e:isInSlot(sx/2-150,sy/2+120,300,35) then 
            color = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and click+500 < getTickCount() then 
                if getElementData(localPlayer,"char >> money") >= 100 then 
                    triggerServerEvent("jogsi.renew",localPlayer,localPlayer,cardCache.id);
                    removeEventHandler("onClientRender",root,renderJogsi);
                    cardCache = {};
                    cardState = false;
                else
                    outputChatBox(e:getServerSyntax("Driving license","red").."You don't have enough money to renew!",255,255,255,true);
                end
                click = getTickCount();
            end
        end
        dxDrawRectangle(sx/2-150,sy/2+120,300,35,color);
        dxDrawBorder(sx/2-150,sy/2+120,300,35,2,tocolor(0,0,0));
        e:shadowedText("Renewal (100 dt)",sx/2-150,sy/2+120,sx/2-150+300,sy/2+120+35,tocolor(255,255,255),1,font,"center","center");
    end
end

function showJogsi(id)
    cardState = not cardState;
    if cardState then 
        triggerServerEvent("jogsi.getData",localPlayer,localPlayer,id);
    else 
        removeEventHandler("onClientRender",root,renderJogsi);
        cardCache = {};
        cardState = false;
    end
end

addEvent("jogsi.returnDatas",true);
addEventHandler("jogsi.returnDatas",localPlayer,function(datas)
    cardState = true;
    cardCache.name = datas[1];
    cardCache.gender = datas[2];
    cardCache.date = datas[3];
    cardCache.exdate = datas[4];
    cardCache.id = datas[5];
    removeEventHandler("onClientRender",root,renderJogsi);
    addEventHandler("onClientRender",root,renderJogsi);
end);