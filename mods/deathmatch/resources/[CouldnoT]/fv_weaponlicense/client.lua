e = exports.fv_engine;
sColor = {e:getServerColor("servercolor",false)};
red = {e:getServerColor("red",false)};
sColor2 = e:getServerColor("servercolor",true);
red2 = e:getServerColor("red",true);
addEventHandler("onClientResourceStart",root,function(res)
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        sColor = {e:getServerColor("servercolor",false)};
    end
end);

white = "#FFFFFF";
sx,sy = guiGetScreenSize();
zoom = 1;
if sx < 1920 then
    zoom = math.min(2, 1920 / sx);
end

local cache = {
    name = "Clark Melton",
    type = 2,
    startDate = "2018-01-01",
    endDate = "2019-01-01",
}

local types = {
    [1] = "Little Caliber",
}
local price = {
    [1] = 250000,
}

local typeTextures = {
    [1] = dxCreateTexture("img/1.png","dxt3");
}
local signFont = dxCreateFont("sign.ttf",25*zoom,false,"cleartype");

local showCard = false;

function showRender()
    local width,height = 300*zoom,150*zoom;
    local posX, posY = sx/2-width/2,sy/2-height/2;
    dxDrawRectangle(posX,posY,width,height,tocolor(0,0,0,150));
    dxDrawRectangle(posX,posY,width,20*zoom,tocolor(0,0,0,150));
    dxDrawRectangle(posX-3*zoom,posY,3*zoom,height,tocolor(sColor[1],sColor[2],sColor[3],150));
    dxDrawText("Gun license",posX+5*zoom,posY,posX+width,posY+height,tocolor(255,255,255,250),1,e:getFont("rage",13*zoom),"left","top");
    dxDrawRectangle(posX+5*zoom,posY+30*zoom,80*zoom,80*zoom,tocolor(0,0,0,150));

    dxDrawImage(posX+width-70*zoom,posY+height-70*zoom,70*zoom,70*zoom,typeTextures[cache.type]);

    dxDrawText("Name: "..sColor2..cache.name..white.."\nType: "..sColor2..types[cache.type]..white.."\nDate of issue: "..sColor2..cache.startDate..white.."\nLejárati dátum: "..red2..cache.endDate..white,posX+90*zoom,posY+30*zoom,posX+width,posY+height,tocolor(255,255,255,250),1,e:getFont("rage",11*zoom),"left","top",false,false,false,true);

    dxDrawText("Signature:",posX+5*zoom,posY,posX+width,posY+height-10*zoom,tocolor(255,255,255,250),1,e:getFont("rage",11*zoom),"left","bottom");
    dxDrawText(cache.name,posX+50*zoom,posY,posX+width,posY+height,tocolor(255,255,255,250),1,signFont,"left","bottom");
end
-- addEventHandler("onClientRender",root,showRender);

addEvent("wlicense.show",true);
addEventHandler("wlicense.show",localPlayer,function(datas)
    showCard = not showCard;
    if showCard then 
        cache = {
            name = datas[1],
            type = datas[2],
            startDate = datas[3],
            endDate = datas[4],
        };
        removeEventHandler("onClientRender",root,showRender);
        addEventHandler("onClientRender",root,showRender);
    else 
        removeEventHandler("onClientRender",root,showRender);
        cache = {};
    end
end);



---
local licensePed = createPed(170,295.49139404297, -82.527816772461, 1001.515625);
setElementDimension(licensePed,505);
setElementInterior(licensePed,4);
setElementFrozen(licensePed,true);
setElementData(licensePed,"ped.noDamage",true);
setElementData(licensePed,"ped >> name","Moses Donnie");
setElementData(licensePed,"ped >> type","Weapons license");
local shop = false;

addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
    if state == "down" and clickedElement == licensePed then 
        local playerX, playerY, playerZ = getElementPosition(localPlayer);
        if not shop then 
            if getDistanceBetweenPoints3D(wx,wy,wz,playerX,playerY,playerZ) < 3 then 
                shop = true;
                removeEventHandler("onClientRender",root,shopRender);
                addEventHandler("onClientRender",root,shopRender);
            end
        end
    end
    if button == "left" and state == "down" and shop and getElementData(localPlayer,"network") then 
        local width, height = 210*zoom,150*zoom;
        local posX,posY = sx/2-width/2, sy/2-height/2;
        for k,v in pairs(types) do 
            if e:isInSlot(posX+width-105*zoom,posY+(k*(45*zoom)),100*zoom,30*zoom) then 
                if getElementData(localPlayer,"char >> money") >= price[k] then 
                    triggerServerEvent("wlicense.buy",localPlayer,localPlayer,price[k],k);
                else 
                    return outputChatBox(e:getServerSyntax("WeaponLicense","red").."You don't have enough money!",255,255,255,true);
                end
            end
        end
    end
end);

addEventHandler("onClientKey",root,function(button,state)
    if button == "backspace" and state then 
        if shop then 
            closeShop();
        end
    end
end);   

function closeShop()
    shop = false;
    removeEventHandler("onClientRender",root,shopRender);
end

function shopRender()
    local playerX,playerY,playerZ = getElementPosition(localPlayer);
    local targetX,targetY,targetZ = getElementPosition(licensePed);
    if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) > 3 then 
        closeShop();
    end


    local width, height = 210*zoom,150*zoom;
    local posX,posY = sx/2-width/2, sy/2-height/2;
    dxDrawRectangle(posX,posY,width,height,tocolor(0,0,0,180));
    dxDrawRectangle(posX-3*zoom,posY,3*zoom,height,tocolor(sColor[1],sColor[2],sColor[3],180));
    dxDrawText(sColor2.."The"..white.."Devils - You don't have enough money",posX,posY,posX+width,height,tocolor(255,255,255),1,e:getFont("rage",11*zoom),"center","top",false,false,false,true);
    dxDrawText("Closure: "..red2.."backspace",posX,posY,posX+width,posY+height,tocolor(255,255,255),1,e:getFont("rage",11*zoom),"center","bottom",false,false,false,true);


    for k,v in pairs(types) do 
        dxDrawText(v,posX+5,posY+(k*(45*zoom)),100*zoom,posY+(k*(45*zoom))+30*zoom,tocolor(255,255,255,180),1,e:getFont("rage",10*zoom),"left","top");
        dxDrawText("Price: "..sColor2..formatMoney(price[k])..white.."dt",posX+5,posY+(k*(45*zoom)),100*zoom,posY+(k*(45*zoom))+30*zoom,tocolor(255,255,255,180),1,e:getFont("rage",10*zoom),"left","bottom",false,false,false,true);

        local buttonColor = {sColor[1],sColor[2],sColor[3],150};
        if getElementData(localPlayer,"char >> money") < price[k] then 
            buttonColor = {red[1],red[2],red[3],150};
        end
        if e:isInSlot(posX+width-105*zoom,posY+(k*(45*zoom)),100*zoom,30*zoom) then 
            buttonColor[4] = 200;
        end
        dxDrawRectangle(posX+width-105*zoom,posY+(k*(45*zoom)),100*zoom,30*zoom,tocolor(unpack(buttonColor)));
        dxDrawText("Buying",posX+width-105*zoom,posY+(k*(45*zoom)),posX+width-105*zoom+100*zoom,posY+(k*(45*zoom))+30*zoom,tocolor(255,255,255),1,e:getFont("rage",10*zoom),"center","center");
    end
end
