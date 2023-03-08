--Global Variables--
sx,sy = guiGetScreenSize();
varoshazaCol = createColSphere(1410.1721191406, -1675.2377929688, 13.65468788147,9);
signFont = dxCreateFont("sign.ttf",20);
--------------------

--Local Variables--
local ped = false;
local menuDatas = {
    {"Bita9it Ta3rif (200 dt)","identity","Enroll"},
    {"Passport (200 dt)","passport","Enroll"},
    {"Fishing license (2000 dt)","fish","Buying"},
    {"Blank Sale (100 dt)","sell","Buying"},
};
local panelShow = false;
-------------------

--Core Export--
e = exports.fv_engine;
sColor = {e:getServerColor("servercolor",false)};
sColor2 = e:getServerColor("servercolor",true);
red = {e:getServerColor("red",false)};
red2 = e:getServerColor("red",true);
blue2 = e:getServerColor("blue",true);
menuFont = e:getFont("rage",13);
font = e:getFont("rage",13);
smallFont = e:getFont("rage",11);
addEventHandler("onClientResourceStart",root,function(res)
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        sColor = {e:getServerColor("servercolor",false)};
        sColor2 = e:getServerColor("servercolor",true);
        red = {e:getServerColor("red",false)};
        red2 = e:getServerColor("red",true);
        blue2 = e:getServerColor("blue",true);
        menuFont = e:getFont("rage",13);
        smallFont = e:getFont("rage",11);
    end
    if res == getThisResource() then 
        ped = createPed(20,1406.0222167969, -1674.1551513672, 13.65468788147);
        setElementRotation(ped,0,0,270);
        setElementData(ped,"ped >> name","Lamar Johnson");
        setElementData(ped,"ped >> type","Document office");
        setElementData(ped,"ped.noDamage",true);
        setElementFrozen(ped,true);
    end
end);
---------------


addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
    if clickedElement and clickedElement == ped then 
        if state then 
            local x,y,z = getElementPosition(localPlayer);
            local distance = getDistanceBetweenPoints3D(x,y,z,wx,wy,wz);
            if distance < 5 then    
                if not panelShow then 
                    panelShow = true;
                    removeEventHandler("onClientRender",root,drawIgenyles);
                    addEventHandler("onClientRender",root,drawIgenyles);
                end
            end
        end
    end
end);

addEventHandler("onClientKey",root,function(button,state)
if panelShow then 
    if button == "mouse1" and state then 
        for k,v in pairs(menuDatas) do 
            local name,type,buttonText = unpack(v);
            if e:isInSlot(sx/2+50,sy/2-130+(k*45),140,35) then 
                triggerServerEvent(type..".give",localPlayer,localPlayer);
                --Close Panel
                panelShow = false;
                removeEventHandler("onClientRender",root,drawIgenyles);
            end
        end
    elseif button == "backspace" and state then 
        panelShow = false;
        removeEventHandler("onClientRender",root,drawIgenyles);
    end
end
end);

function drawIgenyles()
    dxDrawRectangle(sx/2-200,sy/2-100,400,200,tocolor(0,0,0,180));
    dxDrawRectangle(sx/2-202,sy/2-100,2,200,tocolor(sColor[1],sColor[2],sColor[3],180));
    e:shadowedText("Passport Office",0,sy/2-125,sx,400,tocolor(255,255,255),1,menuFont,"center","top");
    e:shadowedText("Press BACKSPACE to exit.",0,sy/2+100,sx,400,tocolor(255,255,255),1,menuFont,"center","top");
    for k,v in pairs(menuDatas) do 
        local name,type,buttonText = unpack(v);
        local buttonColor = tocolor(sColor[1],sColor[2],sColor[3],150);
        dxDrawText(name,sx/2-200+10,sy/2-130+(k*45),400,sy/2-130+(k*45)+35,tocolor(255,255,255),1,menuFont,"left","center")
        if e:isInSlot(sx/2+50,sy/2-130+(k*45),140,35) then 
            buttonColor = tocolor(sColor[1],sColor[2],sColor[3]);
        end
        dxDrawRectangle(sx/2+50,sy/2-130+(k*45),140,35,buttonColor);
        e:shadowedText(buttonText,sx/2+50,sy/2-130+(k*45),sx/2+50+140,sy/2-130+(k*45)+35,tocolor(255,255,255),1,menuFont,"center","center");
    end
end
