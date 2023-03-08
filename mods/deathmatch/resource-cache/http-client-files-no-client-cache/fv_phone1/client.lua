if fileExists("client.lua") then 
    fileDelete("client.lua");
end

e = exports.fv_engine;
dx = exports.fv_dx;

--local x,y = getElementData(localPlayer,"phone.x"), getElementData(localPlayer,"phone.y");
local show = false;
local phoneData = {
    number = getElementData(localPlayer,"acc >> id"),
    wallpaper = 1,
    sms = {},
    calls = {},
};
local apps = {
    {"mail","calendar","images","camera"},
    {"map","time","weather","store"},
    {"settings","note","book","wallet"},
}
local alsoapps = { "call","sms","ad","tor" };
local appnames = {
    ["mail"] = "Mail",
    ["calendar"] = "Naptár",
    ["images"] = "Fotók",
    ["camera"] = "Kamera",
    ["map"] = "Térkép",
    ["time"] = "Óra",
    ["weather"] = "Időjárás",
    ["store"] = "App Store",
    ["settings"] = "Beállítások",
    ["note"] = "Jegyzetek",
    ["book"] = "Könyvek",
    ["wallet"] = "Wallet",
    ["call"] = "Telefon",
    ["sms"] = "Üzenetek",
    ["ad"] = "Hírdetés",
    ["tor"] = "Dark Web",
}
local napok = {};
napok[0] = "Vasárnap"
napok[1] = "Hétfő"
napok[2] = "Kedd"
napok[3] = "Szeda"
napok[4] = "Csütörtök"
napok[5] = "Péntek"
napok[6] = "Szombat"
local activeTAB = 1; 
local clickTick = 0;
local guis = {};
local showNumber = true;
local fonts = { --Iphone Fonts
    [9] = dxCreateFont("light.ttf",9);
    [11] = dxCreateFont("light.ttf",11);
    [12] = dxCreateFont("light.ttf",12);
}
local other = {
    --[[
        [1] = phoneNumber,
        [2] = playerElement,
    ]]
};
local msg = {
    --{text,playerElement},
};

local msgScroll = 0;

local keypad = {
    {"1","2","3"},
    {"4","5","6"},
    {"7","8","9"},
    {"*","0","#"},
};
local callNumber = "";

local smsScroll = 0;
local sSMS = 1;

local adTimer = false;
local darkTimer = false;

addEventHandler("onClientResourceStart",root,function(resource)
    if getThisResource() == resource or getResourceName(resource) == "fv_engine" then 
        e = exports.fv_engine;
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
        red2 = exports.fv_engine:getServerColor("red",true);
        blue = {exports.fv_engine:getServerColor("blue",false)};
        red = {exports.fv_engine:getServerColor("red",false)};
        smallFont = e:getFont("rage",12);
        smallFont2 = e:getFont("rage",10);
        mediumFont = e:getFont("rage",12);
        mediumFont2 = e:getFont("rage",14);
        icons = e:getFont("AwesomeFont",16);
        smallIcons = e:getFont("AwesomeFont",12);
    elseif getThisResource() == resource or getResourceName(resource) == "fv_dx" then 
        dx = exports.fv_dx;
    end
    if resource == getThisResource() then 
        setElementData(localPlayer,"phone.show",false);

        if dx:dxGetEdit("phone.ad") then 
            dx:dxDestroyEdit("phone.ad");
        end
        if dx:dxGetEdit("phone.msg") then 
            dx:dxDestroyEdit("phone.msg");
        end
        if dx:dxGetEdit("phone.telszam") then 
            dx:dxDestroyEdit("phone.telszam");
        end
        
        setElementData(localPlayer,"call.police",false);
        setElementData(localPlayer,"call.medic",false);
        setElementData(localPlayer,"call.vontato",false);
        setElementData(localPlayer,"call.taxi",false);
    end
end);


function switchTAB(name)
    local x,y = getElementData(localPlayer,"phone.x"), getElementData(localPlayer,"phone.y");
    if not name then 
        --activeTAB = 1;
        --[[ if #guis > 0 then 
           for k,v in pairs(guis) do
                if dx:dxGetEdit(v) then  
                    dx:dxDestroyEdit(v);
                end
            end
        else ]]
            if dx:dxGetEdit("phone.ad") then 
                dx:dxDestroyEdit("phone.ad");
            end
            if dx:dxGetEdit("phone.msg") then 
                dx:dxDestroyEdit("phone.msg");
            end
            if dx:dxGetEdit("phone.telszam") then 
                dx:dxDestroyEdit("phone.telszam");
            end
        --end
        showNumber = true; --Telefonszám megjelenítés
        sSMS = -1;
        smsScroll = 0;
    elseif name == "ad" then 
        activeTAB = 2;
        guis[#guis + 1] = dx:dxCreateEdit("phone.ad","","Hírdetés szövege",x+25,y+420,200,30);
        showNumber = true;
    elseif name == "tor" then 
        activeTAB = 3;
        guis[#guis + 1] = dx:dxCreateEdit("phone.ad","","Hírdetés szövege",x+25,y+420,200,30);
        showNumber = true;
    elseif name == "fo" then 
        activeTAB = 1;
    elseif name == "beszelgetes" then 
        activeTAB = 5;
        guis[#guis + 1] = dx:dxCreateEdit("phone.msg","","Üzenet",x+25,y+120,200,30);
    elseif name == "call" then 
        callNumber = "";
        activeTAB = 6;
    elseif name == "sms" then 
        activeTAB = 7;
    elseif name == "newsms" then 
        activeTAB = 8;
        guis[#guis + 1] = dx:dxCreateEdit("phone.telszam","","Telefonszám",x+25,y+200,200,30);
        guis[#guis + 1] = dx:dxCreateEdit("phone.msg","","Üzenet",x+25,y+250,200,30);
    elseif name == "smsread" then 
        activeTAB = 9;
        guis[#guis + 1] = dx:dxCreateEdit("phone.msg","","Üzenet",x+25,y+420,200,30);
    elseif name == "segely" then 
        activeTAB = 10;
    elseif name == "settings" then 
        activeTAB = 11;
    else 
        outputChatBox(e:getServerSyntax("Phone","red").."Hamarosan...",255,255,255,true);
        outputDebugString("nincs");
    end
end

function drawPhone()
    if not getElementData(localPlayer,"togHUD") then return end;
    x,y = getElementData(localPlayer,"phone.x"), getElementData(localPlayer,"phone.y");

    if activeTAB == 1 then --Főoldal
        dxDrawImage(x,y,250,500,"wallpapers/"..phoneData.wallpaper..".png",0,0,0,tocolor(255,255,255),false);

        dxDrawImage(x-2,y,255,500,"alsogeci.png",0,0,0,tocolor(255,255,255),false);
        
        local app = false;
        for i=1,#apps do 
            for k,v in pairs(apps[i]) do
                dxDrawImage(x-20+(k*50),y+20+(i*70),45,45,"apps/"..v..".png",0,0,0,tocolor(255,255,255),false);
                if v == "calendar" then 
                    local d = getRealTime().weekday;
                    local day = getRealTime().monthday;
                    dxDrawText(napok[d],x-20+(k*50),y+20+(i*70)+2,x-20+(k*50)+47,45,tocolor(255,255,255),0.8,"default","center","top",false,false,true);
                    dxDrawText(day,x-20+(k*50),y+20+(i*70)+13,x-20+(k*50)+47,45,tocolor(0,0,0),2,"default","center","top",false,false,true);
                end
                dxDrawText(appnames[v],x-20+(k*50),y+65+(i*70)+1,x-20+(k*50)+45,45,tocolor(0,0,0),1,fonts[9],"center");
                dxDrawText(appnames[v],x-20+(k*50),y+65+(i*70),x-20+(k*50)+45,45,tocolor(255,255,255),1,fonts[9],"center");
                if e:isInSlot(x-20+(k*50),y+20+(i*70),45,45) then 
                    app = v;
                end
            end
        end

        if getKeyState("mouse1") and clickTick+400 < getTickCount() then 
            if tostring(app) ~= "false" then
                switchTAB(app);
                clickTick = getTickCount();
            end
        end


        for k,v in pairs(alsoapps) do 
            dxDrawImage(x-20+(k*50),y+422,45,45,"apps/"..v..".png",0,0,0,tocolor(255,255,255),true);
            if getKeyState("mouse1") and clickTick+400 < getTickCount() then 
                if e:isInSlot(x-20+(k*50),y+422,45,45) then 
                    switchTAB(v);
                    clickTick = getTickCount();
                end
            end
        end
    elseif activeTAB == 2 then --Hírdetés feladás
        dx:dxSetEditPosition("phone.ad",x+25,y+420);

        dxDrawImage(x,y,250,500,"white.png",0,0,0,tocolor(255,255,255),false);
        dxDrawText("Hírdetés feladása",x,y+100,x+250,500,tocolor(0,0,0),1,mediumFont,"center","top",false,false,false);

        local cost = math.floor(string.len(dx:dxGetEditText("phone.ad") or 0) /  2); 

        dxDrawText("-A hírdetésben nem szerepelhet semmilyen szexuális tartalom.\n\n-A hírdetés költsége a hírdetés hoszzától függ.\n\n-A hírdetésben trágár szavak használata TILTOTT!",x+15,y+150,x+230,500,tocolor(0,0,0),1,smallFont2,"center","top",false,true,false);
        
        local color = sColor2;
        if getElementData(localPlayer,"char >> money") < cost then 
            color = red2;
        end        
        dxDrawText("Jelenlegi költség: "..color..cost.."#000000$",x+15,y+380,x+230,500,tocolor(0,0,0),1,mediumFont2,"center","top",false,false,false,true);

        if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
            if e:isInSlot(x+20,y+40,60,20) then --Vissza
                activeTAB = 1;
                switchTAB();
                clickTick = getTickCount();
            elseif e:isInSlot(x+180,y+345,50,30) then --Telefonszám geci
                showNumber = not showNumber;
                clickTick = getTickCount();
            end
        end
        dxDrawText("Telefonszám megjelenítése",x+25,y+345,50,y+345+30,tocolor(0,0,0),1,smallFont2,"left","center");
        if showNumber then 
            dxDrawImage(x+180,y+345,50,30,"on.png");
        else 
            dxDrawImage(x+180,y+345,50,30,"off.png");
        end
        local sendColor = tocolor(blue[1],blue[2],blue[3],100);
        if e:isInSlot(x+115,y+450,30,30) then 
            sendColor = tocolor(blue[1],blue[2],blue[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                if getElementData(localPlayer,"char >> money") < cost then 
                    outputChatBox(e:getServerSyntax("Phone","red").."Nincs elég pénzed a hírdetés feladásához!",255,255,255,true);
                else 
                    if isTimer(adTimer) then 
                        outputChatBox(e:getServerSyntax("Phone","red").."Csak percenként adhatsz fel hírdetést.",255,255,255,true);
                    else 
                        if isTimer(adTimer) then 
                            killTimer(adTimer);
                        end
                        adTimer = setTimer(function()
                            killTimer(adTimer);
                            adTimer = false;
                        end,1000*60,1);
                        triggerServerEvent("phone.ad",localPlayer,localPlayer,phoneData.number,dx:dxGetEditText("phone.ad"),cost,showNumber);
                    end
                end
                clickTick = getTickCount();
            end
        end
        dxDrawText("",x,y+450+1,x+250,y+450+30+1,tocolor(0,0,0,100),1,icons,"center","center",false,false,false,false,false,45);
        dxDrawText("",x,y+450,x+250,y+450+30,sendColor,1,icons,"center","center",false,false,false,false,false,45);
    elseif activeTAB == 3 then --DarkWEB
        dx:dxSetEditPosition("phone.ad",x+25,y+420);
        dxDrawImage(x,y,250,500,"white.png",0,0,0,tocolor(80,80,80),false);
        dxDrawImage(x,y,250,500,"dark.png",0,0,0,tocolor(90,90,90),false);

        dxDrawText("DarkWeb Hírdetés",x,y+100,x+250,500,tocolor(200,200,200),1.3,mediumFont,"center","top",false,false,false);

        local cost = math.floor(string.len(dx:dxGetEditText("phone.ad") or 0) /  2); 

        dxDrawText("-A hírdetés költsége a hírdetés hoszzától függ.",x+15,y+150,x+230,500,tocolor(200,200,200),1,smallFont2,"center","top",false,true,false);
        
        local color = sColor2;
        if getElementData(localPlayer,"char >> money") < cost then 
            color = red2;
        end        
        dxDrawText("Jelenlegi költség: "..color..cost..white.."$",x+15,y+380,x+230,500,tocolor(255,255,255),1,mediumFont2,"center","top",false,false,false,true);

        if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
            if e:isInSlot(x+20,y+40,60,20) then --Vissza
                activeTAB = 1;
                switchTAB();
                clickTick = getTickCount();
            elseif e:isInSlot(x+180,y+345,50,30) then --Telefonszám geci
                showNumber = not showNumber;
                clickTick = getTickCount();
            end
        end

        dxDrawText("Telefonszám megjelenítése",x+25,y+345,50,y+345+30,tocolor(255,255,255),1,smallFont2,"left","center");
        if showNumber then 
            dxDrawImage(x+180,y+345,50,30,"on.png");
        else 
            dxDrawImage(x+180,y+345,50,30,"off.png");
        end
        local sendColor = tocolor(blue[1],blue[2],blue[3],100);
        if e:isInSlot(x+115,y+450,30,30) then 
            sendColor = tocolor(blue[1],blue[2],blue[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                if getElementData(localPlayer,"char >> money") < cost then 
                    outputChatBox(e:getServerSyntax("Phone","red").."Nincs elég pénzed a hírdetés feladásához!",255,255,255,true);
                else 
                    if isTimer(darkTimer) then 
                        outputChatBox(e:getServerSyntax("Phone","red").."Csak percenként adhatsz fel hírdetést.",255,255,255,true);
                    else 
                        if isTimer(darkTimer) then 
                            killTimer(darkTimer);
                        end
                        darkTimer = setTimer(function()
                            killTimer(darkTimer);
                            darkTimer = false;
                        end,1000*60,1);
                        triggerServerEvent("phone.darkad",localPlayer,localPlayer,phoneData.number,dx:dxGetEditText("phone.ad"),cost,showNumber);
                    end
                end
                clickTick = getTickCount();
            end
        end
        dxDrawText("",x,y+450+1,x+250,y+450+30+1,tocolor(0,0,0,100),1,icons,"center","center",false,false,false,false,false,45);
        dxDrawText("",x,y+450,x+250,y+450+30,sendColor,1,icons,"center","center",false,false,false,false,false,45);
    elseif activeTAB == 4 then --Bejövő hívás
        if other[1] and other[2] then 
            dxDrawImage(x,y,250,500,"white.png",0,0,0,tocolor(80,80,80),false);
            dxDrawImage(x+150,y+340,50,50,"accept.png");
            dxDrawText("Fogadás",x+150,y+390,x+150+50,0,tocolor(255,255,255),1,fonts[11],"center");
            dxDrawImage(x+50,y+340,50,50,"deny.png");
            dxDrawText("Elutasít",x+50,y+390,x+50+50,50,tocolor(255,255,255),1,fonts[11],"center");

            dxDrawText("Bejövő hívás\n"..sColor2..other[1],x,y+100,x+250,0,tocolor(255,255,255),1,mediumFont,"center","top",false,false,false,true);

            if getKeyState("mouse1") and clickTick+400 < getTickCount() then 
                if e:isInSlot(x+150,y+340,50,50) then 
                    switchTAB("beszelgetes");
                    msg = {};
                    ---table.insert(msg,1,{"* felvetted a telefont *", })
                    triggerServerEvent("phone.accept",localPlayer,localPlayer,other[2]);
                    clickTick = getTickCount();
                end
                if e:isInSlot(x+50,y+340,50,50) then 
                    triggerServerEvent("phone.deny",localPlayer,localPlayer,other[2],1);
                    other = {};
                    msg = {};
                    callNumber = "";
                    switchTAB();
                    switchTAB("fo");
                    clickTick = getTickCount();
                end
            end

        else 
            switchTAB("fo");
            outputChatBox(e:getServerSyntax("Phone","red").."Másik fél lerakta a telefont.",255,255,255,true);
        end
    elseif activeTAB == 5 then --Hívás beszélgetés része
        dx:dxSetEditPosition("phone.msg",x+25,y+120);

        dxDrawImage(x,y,250,500,"white.png",0,0,0,tocolor(80,80,80),false);
        dxDrawText("Beszélgetés\n"..sColor2..other[1],x,y+70,x+250,0,tocolor(255,255,255),1,mediumFont,"center","top",false,false,false,true);

        local sendColor = tocolor(blue[1],blue[2],blue[3],200);
        if e:isInSlot(x+113,y+150,30,30) then 
            sendColor = tocolor(blue[1],blue[2],blue[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                if other[3] then
                    local text = dx:dxGetEditText("phone.msg");
                    if text == "" or text == " " or string.len(text) < 2 then 
                        outputChatBox(e:getServerSyntax("Phone","red").."A megadott üzenet túl rövid!",255,255,255,true);
                        clickTick = getTickCount();
                    end
                    if string.len(text) > 29 then 
                        outputChatBox(e:getServerSyntax("Phone","red").."A megadott üzenet túl hosszú!",255,255,255,true);
                        clickTick = getTickCount();
                    end
                    if string.len(text) <= 29 then 
                        table.insert(msg,1,{text,localPlayer});
                        msgScroll = 0; --Tetejére ugrik ha jön új üzike.
                        triggerServerEvent("phone.msgSend",localPlayer,localPlayer,other[2],{text,localPlayer});
                        dx:dxEditSetText("phone.msg","");
                    end
                else 
                    outputChatBox(e:getServerSyntax("Phone","red").."Telefont még nem vették fel!",255,255,255,true);
                end
                clickTick = getTickCount();
            end
        end
        dxDrawText("",x,y+150,x+250,y+150+30,sendColor,1,icons,"center","center",false,false,false,false,false,45);

        if #msg > 0 then 
            local count = 0;
            for k,v in pairs(msg) do 
                if k > msgScroll and count < 6 then 
                    count = count + 1;
                    --dxDrawRectangle(x+25,y+160+(count*35),200,30,tocolor(255,255,255,100));
                    if v[2] == localPlayer then 
                        dxDrawText(v[1],x+25,y+160+(count*35),x+25+200,y+160+(count*35)+30,tocolor(255,255,255),1,smallFont2,"right","center");
                    else 
                        dxDrawText(v[1],x+25,y+160+(count*35),200,y+160+(count*35)+30,tocolor(255,255,255),1,smallFont2,"left","center");
                    end
                end
            end
        end

        dxDrawImage(x+100,y+420,50,50,"deny.png"); --Lerak
        if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
            if e:isInSlot(x+100,y+420,50,50) then 
                msg = {};
                triggerServerEvent("phone.deny",localPlayer,localPlayer,other[2],2);
                other = {};
                callNumber = "";
                other = {};
                msgScroll = 0;
                switchTAB();
                switchTAB("fo");
                outputChatBox(e:getServerSyntax("Phone","servercolor").."Leraktad a telefont.",255,255,255,true);
                clickTick = getTickCount();
            end
        end
    elseif activeTAB == 6 then --Telefonszám beírás
        dxDrawImage(x,y,250,500,"keypad.png",0,0,0,tocolor(255,255,255),false);
        dxDrawRectangle(x+30,y+120,192,3,tocolor(0,0,0));
        dxDrawText(callNumber,x+30,y+100,192,3,tocolor(0,0,0),1,smallFont,"left","top");

        dxDrawText("911 - Általános segélyhívó\n333333 - Taxitársaság\n555555 - Szerelő társaság",x,y+130,x+250,0,tocolor(0,0,0),1,smallFont2,"center","top",false,false,false,true);


        local delColor = tocolor(0,0,0);
        if e:isInSlot(x+200,y+90,30,30) then 
            delColor = tocolor(blue[1],blue[2],blue[3]);
            if getKeyState("mouse1") and clickTick+150 < getTickCount() then 
                local len = string.len(callNumber)
                if len > 0 then 
                    callNumber = string.sub(callNumber,0,len-1);
                end
                clickTick = getTickCount();
            end
        end
        dxDrawText("",x+200,y+90,x+200+30,y+90+30,delColor,1,smallIcons,"center","center");

        for i,v in pairs(keypad) do 
            for k,j in pairs(v) do
                if e:isInSlot(x-30+(k*65),y+130+(i*60),50,50) then 
                    if getKeyState("mouse1") and clickTick+200 < getTickCount() then 
                        if string.len(callNumber) < 20 then 
                            callNumber = callNumber .. j;
                            clickTick = getTickCount();
                        end
                    end
                end
                --dxDrawRectangle(x-30+(k*65),y+130+(i*60),50,50,tocolor(200,10,10,100)); --DEV
            end
        end

        if e:isInSlot(x+100,y+430,50,50) and getKeyState("mouse1") and clickTick+400 < getTickCount() then 
            if callNumber == "" or callNumber == " " then
                outputChatBox(e:getServerSyntax("Phone","red").."Megadott telefonszám hibás!",255,255,255,true);
            else 
                if callNumber == "911" then 
                    switchTAB("segely");
                else 
                    triggerServerEvent("phone.startCall",localPlayer,localPlayer,callNumber,phoneData.number);
                end
            end
            clickTick = getTickCount();
        end
        if e:isInSlot(x+20,y+40,60,20) and getKeyState("mouse1") and clickTick+400 < getTickCount() then  --Vissza
            switchTAB();
            switchTAB("fo");
            clickTick = getTickCount();
        end
    elseif activeTAB == 7 then --SMS főoldal
        dxDrawImage(x,y,250,500,"white.png",0,0,0,tocolor(255,255,255),false);

        dxDrawText("Üzenetek",x,y+60,x+250,0,tocolor(0,0,0),1,mediumFont,"center","top",false,false,false,true);

        dxDrawRectangle(x+30,y+80,192,3,tocolor(0,0,0));
        dxDrawRectangle(x+30,y+118,192,3,tocolor(0,0,0));

        local newColor = tocolor(80,80,80);
        if e:isInSlot(x+30,y+93,200,20) then 
            newColor = tocolor(blue[1],blue[2],blue[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                switchTAB();
                switchTAB("newsms");
                clickTick = getTickCount();
            end
        end
        dxDrawText("",x+30,y+93,x+30+20,y+93+20,newColor,1,smallIcons,"center","center");
        dxDrawText("Új beszélgetés",x+120,y+93,x+30+20,y+93+20,newColor,1,mediumFont,"left","center");

        local count = 0;
        for k,v in pairs(phoneData.sms) do 
            if k > smsScroll and count < 10 then 
                count = count + 1;
                dxDrawRectangle(x+25,y+95+(count*35),200,25,tocolor(80,80,80,100));
                local textColor = tocolor(0,0,0);
                if e:isInSlot(x+25,y+95+(count*35),170,25) then 
                    textColor = tocolor(blue[1],blue[2],blue[3]);
                    if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                        sSMS = k;
                        switchTAB("smsread");
                        smsScroll = #phoneData.sms[sSMS] - 12;
                        clickTick = getTickCount();
                    end
                end
                dxDrawText(v[1],x+30,y+95+(count*35),200,y+95+(count*35)+25,textColor,1,fonts[11],"left","center");

                local delColor = tocolor(20,20,20);
                if e:isInSlot(x+200,y+95+(count*35),25,25) then 
                    delColor = tocolor(blue[1],blue[2],blue[3]);
                    if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                        table.remove(phoneData.sms,k);
                        outputChatBox(e:getServerSyntax("Phone","servercolor").."Sikeresen törölted a beszélgetést!",255,255,255,true);
                        triggerServerEvent("phone.smsSync",localPlayer,localPlayer,phoneData.number,phoneData.sms);
                        clickTick = getTickCount();
                    end
                end
                dxDrawText("",x+200,y+95+(count*35),x+200+28,y+95+(count*35)+28,delColor,1,smallIcons,"center","center");
            end
        end

        if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
            if e:isInSlot(x+20,y+40,60,20) then --Vissza
                activeTAB = 1;
                switchTAB();
                clickTick = getTickCount();
            end
        end
    elseif activeTAB == 8 then --Új SMS
        dxDrawImage(x,y,250,500,"white.png",0,0,0,tocolor(255,255,255),false);
        dxDrawText("Új beszélgetés kezdése",x,y+120,x+250,0,tocolor(0,0,0),1,mediumFont,"center","top",false,false,false,true);
        local sendColor = tocolor(blue[1],blue[2],blue[3],100);
        if e:isInSlot(x+110,y+300,30,30) then 
            sendColor = tocolor(blue[1],blue[2],blue[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                local number = dx:dxGetEditText("phone.telszam");
                local text = dx:dxGetEditText("phone.msg");
                if string.len(number) < 3 or string.len(text) < 3 or text == "" or text == "" then 
                    outputChatBox(e:getServerSyntax("Phone","red").."Hibásan töltötted ki!",255,255,255,true);
                else 
                    triggerServerEvent("phone.newSMS",localPlayer,localPlayer,phoneData.number,number,text,phoneData.sms);
                    dx:dxEditSetText("phone.msg","");
                end
                clickTick = getTickCount();
            end
        end
        dxDrawText("",x+105,y+300+1,x+105+30,y+300+30+1,tocolor(0,0,0,100),1,icons,"center","center",false,false,false,false,false,45);
        dxDrawText("",x+105,y+300,x+105+30,y+300+30,sendColor,1,icons,"center","center",false,false,false,false,false,45);

        if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
            if e:isInSlot(x+20,y+40,60,20) then --Vissza
                switchTAB();
                switchTAB("sms");
                clickTick = getTickCount();
            end
        end
    elseif activeTAB == 9 then --SMS olvasgatása csak mert Nevils meleg
        dxDrawImage(x,y,250,500,"white.png",0,0,0,tocolor(255,255,255),false);
        local current = phoneData.sms[sSMS];
        local count = 0;

        dxDrawText(current[1],x,y+40,x+225,500,tocolor(0,0,0),1,smallFont,"right","top",false,false,true);


        for k,v in ipairs(current) do 
            if k > smsScroll and count < 12 then 
                if type(v) == "table" and v[1] and v[2] then 
                    count = count + 1;
                    --outputChatBox(k.." "..count)
                    if tonumber(v[2]) == phoneData.number then 
                        dxDrawText(v[1],x+25,y+30+(count*30),x+25+200,y+30+(count*30)+30,tocolor(0,0,0),1,fonts[12],"right","center");
                    else
                        dxDrawText(v[1],x+25,y+30+(count*30),200,y+30+(count*30)+30,tocolor(0,0,0),1,fonts[12],"left","center");
                    end
                end
            end
        end
        local sendColor = tocolor(blue[1],blue[2],blue[3],100);
        if e:isInSlot(x+115,y+450,30,30) then 
            sendColor = tocolor(blue[1],blue[2],blue[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                local text = dx:dxGetEditText("phone.msg");
                if string.len(text) < 3 or text == "" or text == "" then 
                    outputChatBox(e:getServerSyntax("Phone","red").."Hibásan töltötted ki!",255,255,255,true);
                else 
                    if string.len(text) > 25 then 
                        outputChatBox(e:getServerSyntax("Phone","red").."Túl hosszú az üzenet!",255,255,255,true);
                    else 
                        table.insert(phoneData.sms[sSMS],{text,phoneData.number});
                        smsScroll = #phoneData.sms[sSMS] - 12;
                        triggerServerEvent("phone.sendSMS",localPlayer,localPlayer,phoneData.number,tonumber(phoneData.sms[sSMS][1]),text);
                        triggerServerEvent("phone.smsSync",localPlayer,localPlayer,phoneData.number,phoneData.sms);
                        dx:dxEditSetText("phone.msg","");
                    end
                end
                clickTick = getTickCount();
            end
        end
        dxDrawText("",x,y+450+1,x+250,y+450+30+1,tocolor(0,0,0,100),1,icons,"center","center",false,false,false,false,false,45);
        dxDrawText("",x,y+450,x+250,y+450+30,sendColor,1,icons,"center","center",false,false,false,false,false,45);
    
        if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
            if e:isInSlot(x+20,y+40,60,20) then --Vissza
                switchTAB();
                switchTAB("sms");
                clickTick = getTickCount();
            end
        end
    elseif activeTAB == 10 then --911 hívása
        dxDrawImage(x,y,250,500,"white.png",0,0,0,tocolor(255,255,255),false);
        dxDrawText("Általános segélyhívó",x,y+100,x+250,0,tocolor(0,0,0),1,mediumFont,"center","top",false,false,false,true);

        local policeColor = tocolor(blue[1],blue[2],blue[3],180);
        if e:isInSlot(x+25,y+300,200,30) then 
            policeColor = tocolor(blue[1],blue[2],blue[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                triggerServerEvent("phone.policeCall",localPlayer,localPlayer);
                closePhone();
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(x+25,y+300,200,30,policeColor);
        dxDrawText("Rendőrség",x+25,y+300,x+25+200,y+300+30,tocolor(0,0,0),1,smallFont,"center","center");

        local medicColor = tocolor(red[1],red[2],red[3],180);
        if e:isInSlot(x+25,y+350,200,30) then 
            medicColor = tocolor(red[1],red[2],red[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                triggerServerEvent("phone.medicCall",localPlayer,localPlayer);
                closePhone();
                clickTick = getTickCount();
            end
        end
        dxDrawRectangle(x+25,y+350,200,30,medicColor);
        dxDrawText("Mentőszolgálat",x+25,y+350,x+25+200,y+350+30,tocolor(0,0,0),1,smallFont,"center","center");

        if e:isInSlot(x+20,y+40,60,20) and getKeyState("mouse1") and clickTick+400 < getTickCount() then  --Vissza
            switchTAB();
            switchTAB("call");
            clickTick = getTickCount();
        end
    elseif activeTAB == 11 then --Beállítások
        dxDrawImage(x,y,250,500,"white.png",0,0,0,tocolor(255,255,255),false);

        dxDrawText("Beállítások",x,y+60,x+250,0,tocolor(0,0,0),1,mediumFont,"center","top",false,false,false,true);

        dxDrawRectangle(x+30,y+80,192,3,tocolor(0,0,0));
        dxDrawRectangle(x+30,y+118,192,3,tocolor(0,0,0));
        dxDrawRectangle(x+30,y+156,192,3,tocolor(0,0,0));

        dxDrawText("Hírdetések megjelenítése",x+30,y+93,x+30+20,y+93+20,tocolor(80,80,80),1,e:getFont("rage",10),"left","center");

        if (getElementData(localPlayer,"phone.togAD") or false) then 
            dxDrawImage(x+175,y+85,50,30,"on.png");
        else 
            dxDrawImage(x+175,y+85,50,30,"off.png");
        end

        dxDrawText("DarkWeb megjelenítése",x+30,y+118,x+30+20,y+165,tocolor(80,80,80),1,e:getFont("rage",10),"left","center");

        if (getElementData(localPlayer,"phone.togDarkAD") or false) then 
            dxDrawImage(x+175,y+124,50,30,"on.png");
        else 
            dxDrawImage(x+175,y+124,50,30,"off.png");
        end


        if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
            if e:isInSlot(x+20,y+40,60,20) then --Vissza
                switchTAB();
                switchTAB("fo");
                clickTick = getTickCount();
            end
            if e:isInSlot(x+30,y+93,200,20) then 
                setElementData(localPlayer,"phone.togAD", not getElementData(localPlayer,"phone.togAD")); 
                saveADstate();
                clickTick = getTickCount();
            end
            if e:isInSlot(x+175,y+124,50,30) then 
                setElementData(localPlayer,"phone.togDarkAD", not getElementData(localPlayer,"phone.togDarkAD")); 
                saveADstate();
                clickTick = getTickCount();
            end
        end
    end

    if activeTAB ~= 1 and activeTAB ~= 4 and activeTAB ~= 5 then --VISSZA GOMB
        local backColor = tocolor(0,0,0);
        local shadow = false;
        if e:isInSlot(x+20,y+40,60,20) then 
            backColor = tocolor(e:getServerColor("servercolor",false));
            shadow = true;
        end
        if shadow then 
            dxDrawText("⮜Vissza",x+20,y+41,0,500,tocolor(0,0,0),1,smallFont,"left","top",false,false,false);
        end
        dxDrawText("⮜Vissza",x+20,y+40,0,500,backColor,1,smallFont,"left","top",false,false,false);
    end

    dxDrawImage(x,y,250,500,"bg.png",0,0,0,tocolor(255,255,255),false);
    ------ÓRA------
    local rt = getRealTime();
    local minute = rt.minute;
    local hour = rt.hour;
    if minute < 10 then 
        minute = "0"..minute;
    end
    if hour < 10 then 
        hour = "0"..hour;
    end
    dxDrawText(hour..":"..minute,x,y+20,x+220,0,tocolor(0,0,0),1,"default-bold","right","top",false,false,false);
    ---------------
end
--addEventHandler("onClientRender",root,drawPhone);

function saveADstate()
    if fileExists("adstate.save") then 
        fileDelete("adstate.save");
    end
    local file = fileCreate("adstate.save");
    local state = toJSON({getElementData(localPlayer,"phone.togAD") or false,getElementData(localPlayer,"phone.togDarkAD") or false});
    fileWrite(file,state);
    fileClose(file);
end
addEventHandler("onClientResourceStop",resourceRoot,saveADstate);

function loadADstate()
    if fileExists("adstate.save") then 
        local file = fileOpen("adstate.save");
        local state = fromJSON(fileRead(file,4000));
        setElementData(localPlayer,"phone.togAD",state[1]);
        setElementData(localPlayer,"phone.togDarkAD",state[2]);
        fileClose(file);
    else 
        setElementData(localPlayer,"phone.togAD",true);
        setElementData(localPlayer,"phone.togDarkAD",true);
    end
end
addEventHandler("onClientResourceStart",resourceRoot,loadADstate);

addEventHandler("onClientKey",root,function(button,state)
if show then 
    if button == "mouse_wheel_down" and state then 
        if activeTAB == 5 then 
            if e:isInSlot(x+25,y+180,200,235) then 
                if msgScroll < #msg - 6 then 
                    msgScroll = msgScroll + 1;
                end
            end
        end
        if activeTAB == 7 then --SMS
            if e:isInSlot(x+25,y+120,200,350) then 
                if smsScroll < #phoneData.sms - 10 then 
                    smsScroll = smsScroll + 1;
                end
            end
        end
        if activeTAB == 9 then --SMS read
            if e:isInSlot(x+30,y+65,200,350) then 
                if smsScroll < #phoneData.sms[sSMS] - 12 then 
                    smsScroll = smsScroll + 1;
                end
            end
        end
    end
    if button == "mouse_wheel_up" and state then 
        if activeTAB == 5 then 
            if e:isInSlot(x+25,y+180,200,235) then 
                if msgScroll > 0 then 
                    msgScroll = msgScroll - 1;
                end
            end
        end
        if activeTAB == 7 then --SMS
            if e:isInSlot(x+25,y+120,200,350) then 
                if smsScroll > 0 then 
                    smsScroll = smsScroll - 1;
                end
            end
        end
        if activeTAB == 9 then --SMS read
            if e:isInSlot(x+30,y+65,200,350) then 
                if smsScroll > 0 then 
                    smsScroll = smsScroll - 1;
                end
            end
        end
    end
end
end);

--[[function scrollDown()
    if activeTAB == 5 then 
        if e:isInSlot(x+25,y+180,200,235) then 
            if msgScroll < #msg - 6 then 
                msgScroll = msgScroll + 1;
            end
        end
    end
    if activeTAB == 7 then --SMS
        if e:isInSlot(x+25,y+120,200,350) then 
            if smsScroll < #phoneData.sms - 10 then 
                smsScroll = smsScroll + 1;
            end
        end
    end
    if activeTAB == 9 then --SMS read
        if e:isInSlot(x+30,y+65,200,350) then 
            if smsScroll < #phoneData.sms[sSMS] - 12 then 
                smsScroll = smsScroll + 1;
            end
        end
    end
end
function scrollUp()
    if activeTAB == 5 then 
        if e:isInSlot(x+25,y+180,200,235) then 
            if msgScroll > 0 then 
                msgScroll = msgScroll - 1;
            end
        end
    end
    if activeTAB == 7 then --SMS
        if e:isInSlot(x+25,y+120,200,350) then 
            if smsScroll > 0 then 
                smsScroll = smsScroll - 1;
            end
        end
    end
    if activeTAB == 9 then --SMS read
        if e:isInSlot(x+30,y+65,200,350) then 
            if smsScroll > 0 then 
                smsScroll = smsScroll - 1;
            end
        end
    end
end]]
--bindKey("mouse_wheel_down","down",scrollDown);
--bindKey("mouse_wheel_up","down",scrollUp);

function closePhone()
    if activeTAB == 4 then --Ha hívják
        triggerServerEvent("phone.deny",localPlayer,localPlayer,other[2]);
        other = {};
        msg = {};
        callNumber = "";
        outputChatBox(e:getServerSyntax("Phone","red").."Elutasítottad a hívást!",255,255,255,true);
    end
    show = false;
    removeEventHandler("onClientRender",root,drawPhone);
    switchTAB();
    phoneData = {};
    setElementData(localPlayer,"phone.show",false);
    --unbindKey("mouse_wheel_down","down",scrollDown);
    --unbindKey("mouse_wheel_up","down",scrollUp);
    callNumber = "";
end
addEvent("phone.close",true);
addEventHandler("phone.close",root,closePhone);

addEvent("phone.showClient",true);
addEventHandler("phone.showClient",root,function(n,w,s,c)
    if show then 
        closePhone();
        triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer, "elrakott egy telefont");
    else 
        phoneData = {};
        switchTAB();
        switchTAB("fo");
        removeEventHandler("onClientRender",root,drawPhone);
        addEventHandler("onClientRender",root,drawPhone);
        phoneData = {
            number = n;
            wallpaper = w;
            sms = s;
            calls = c;
        }
        show = true;
        -- unbindKey("mouse_wheel_down","down",scrollDown);
        -- unbindKey("mouse_wheel_up","down",scrollUp);
        -- bindKey("mouse_wheel_down","down",scrollDown);
        -- bindKey("mouse_wheel_up","down",scrollUp);
        setElementData(localPlayer,"phone.show",n);
        callNumber = "";
        triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer, "elővett egy telefont");
    end
end);

addEvent("phone.startCall",true);
addEventHandler("phone.startCall",root,function(found,number)
    msg = {};
    other = {};
    other[1] = number;
    other[2] = found;
    other[3] = false;
    switchTAB();
    switchTAB("beszelgetes");
end);

addEvent("phone.ring",true);
addEventHandler("phone.ring",root,function(sourcePlayer,sourceNumber,n,w,s,c)
    --show = false;
    --if not show then 
        phoneData = {};
        switchTAB();
        removeEventHandler("onClientRender",root,drawPhone);
        addEventHandler("onClientRender",root,drawPhone);
        phoneData = {
            number = n;
            wallpaper = w;
            sms = s;
            calls = c;
        }
        show = true;
        -- unbindKey("mouse_wheel_down","down",scrollDown);
        -- unbindKey("mouse_wheel_up","down",scrollUp);
        -- bindKey("mouse_wheel_down","down",scrollDown);
        -- bindKey("mouse_wheel_up","down",scrollUp);
        setElementData(localPlayer,"phone.show",n);
        callNumber = "";
    --end
    msg = {};
    other = {};
    other[1] = sourceNumber;
    other[2] = sourcePlayer;
    other[3] = true;
    activeTAB = 4;
end);

addEvent("phone.felvette",true);
addEventHandler("phone.felvette",root,function()
    table.insert(msg,1,{"* felvették a telefont *",source});
    other[3] = true;
end);

addEvent("phone.lerak",true);
addEventHandler("phone.lerak",root,function(x)
    if x == 1 then 
        outputChatBox(e:getServerSyntax("Phone","red").."Másik fél nem fogadta a hívásodat.",255,255,255,true);
        other = {};
        msg = {};
        callNumber = "";
        switchTAB();
        switchTAB("call");
    elseif x == 2 then 
        outputChatBox(e:getServerSyntax("Phone","red").."Másik fél lerakta a telefont.",255,255,255,true);
        other = {};
        msg = {};
        callNumber = "";
        switchTAB();
        switchTAB("fo");
    end
end);

addEvent("phone.msgRecive",true);
addEventHandler("phone.msgRecive",root,function(data)
    table.insert(msg,1,{data[1],data[2]});
    msgScroll = 0;
end);

addEvent("phone.smsSyncClient",true);
addEventHandler("phone.smsSyncClient",root,function(data)
    phoneData.sms = {};
    phoneData.sms = tableCopy(data);
end);

--UTILS--
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, true, true)
end




--/call--
local currentMarker = {};

addEventHandler("onClientResourceStart",resourceRoot,function()
    setElementData(localPlayer,"call.elfogadva",false);
end);

addEvent("phone.createMarker",true);
addEventHandler("phone.createMarker",root,function(data,color,callid,type)
    for k,v in pairs(currentMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    currentMarker = {};
    local target = data[1];
    local x,y,z = getElementPosition(target);
    local r,g,b = e:getServerColor(color,false);
    currentMarker[1] = createMarker(x,y,z,"checkpoint",1.3,r,g,b,100);
    currentMarker[2] = createBlip(x,y,z,0);
    currentMarker[3] = callid;
    currentMarker[4] = data[1];
    currentMarker[5] = data[2];
    currentMarker[6] = type;
    setElementData(currentMarker[2],"blip >> name",callid.."-es számú hívás.");
    setElementData(currentMarker[2],"blip >> maxVisible",true);
    setElementData(currentMarker[2],"blip >> color",{r,g,b});
    attachElements(currentMarker[1],target,0,0,0);
    attachElements(currentMarker[2],target,0,0,2);

    addEventHandler("onClientMarkerHit",currentMarker[1],function(hitElement,dim)
        if hitElement == localPlayer and getElementDimension(source) == getElementDimension(localPlayer) then 
            triggerServerEvent("phone.kiert",localPlayer,localPlayer,currentMarker[3],currentMarker[4],currentMarker[5],currentMarker[6]);
            for k,v in pairs(currentMarker) do 
                if isElement(v) then 
                    destroyElement(v);
                end
            end
            currentMarker = {};
        end
    end);
end);

setTimer(function()
    if #currentMarker > 0 then 
        if not isElement(currentMarker[4]) then 
            for k,v in pairs(currentMarker) do 
                if isElement(v) then 
                    destroyElement(v);
                end
            end
            currentMarker = {};
            setElementData(localPlayer,"call.elfogadva",false);
            outputChatBox(e:getServerSyntax("Phone","red").."A játékos aki a hívást indította lelépett a szerverről, hívás törölve.",255,255,255,true);
        end
    end
end,3000,0);