--[[local shopPed = createPed(180,293.5442199707, -83.785850524902, 1001.515625,90);
setElementDimension(shopPed,505);
setElementInterior(shopPed,4);
setElementFrozen(shopPed,true);
setElementData(shopPed,"ped.noDamage",true);
setElementData(shopPed,"ped >> name","Willis Brown");
setElementData(shopPed,"ped >> type","Fegyverbolt");]]

local weaponShop = false;
local shopItems = {
    {"Colt 45",450000,24},
    {"Shotgun",750000,26},
};

function weaponShopRender()
    local playerX,playerY,playerZ = getElementPosition(localPlayer);
    local targetX,targetY,targetZ = getElementPosition(shopPed);
    if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) > 3 then 
        closeWeaponShop();
    end

    local width, height = 210*zoom,150*zoom;
    local posX,posY = sx/2-width/2, sy/2-height/2;
    dxDrawRectangle(posX,posY,width,height,tocolor(0,0,0,180));
    dxDrawRectangle(posX-3*zoom,posY,3*zoom,height,tocolor(sColor[1],sColor[2],sColor[3],180));
    dxDrawText(sColor2.."The"..white.."Devils - Gun shop",posX,posY,posX+width,height,tocolor(255,255,255),1,e:getFont("rage",11*zoom),"center","top",false,false,false,true);
    dxDrawText("Bezárás: "..red2.."backspace",posX,posY,posX+width,posY+height,tocolor(255,255,255),1,e:getFont("rage",11*zoom),"center","bottom",false,false,false,true);


    for k,v in pairs(shopItems) do 
        dxDrawText(v[1],posX+5,posY+(k*(45*zoom)),100*zoom,posY+(k*(45*zoom))+30*zoom,tocolor(255,255,255,180),1,e:getFont("rage",10*zoom),"left","top");
        dxDrawText("Ár: "..sColor2..formatMoney(v[2])..white.."$",posX+5,posY+(k*(45*zoom)),100*zoom,posY+(k*(45*zoom))+30*zoom,tocolor(255,255,255,180),1,e:getFont("rage",10*zoom),"left","bottom",false,false,false,true);

        local buttonColor = {sColor[1],sColor[2],sColor[3],150};
        if getElementData(localPlayer,"char >> money") < v[2] then 
            buttonColor = {red[1],red[2],red[3],150};
        end
        if e:isInSlot(posX+width-105*zoom,posY+(k*(45*zoom)),100*zoom,30*zoom) then 
            buttonColor[4] = 200;
        end
        dxDrawRectangle(posX+width-105*zoom,posY+(k*(45*zoom)),100*zoom,30*zoom,tocolor(unpack(buttonColor)));
        dxDrawText("Vásárlás",posX+width-105*zoom,posY+(k*(45*zoom)),posX+width-105*zoom+100*zoom,posY+(k*(45*zoom))+30*zoom,tocolor(255,255,255),1,e:getFont("rage",10*zoom),"center","center");
    end
end

function closeWeaponShop()
    removeEventHandler("onClientRender",root,weaponShopRender);
    weaponShop = false;
end

addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
    if state == "down" and clickedElement and clickedElement == shopPed then 
        if not weaponShop then 
            local playerX, playerY, playerZ = getElementPosition(localPlayer);
            if getDistanceBetweenPoints3D(playerX,playerY,playerZ,wx,wy,wz) < 3 then 
                weaponShop = true;
                removeEventHandler("onClientRender",root,weaponShopRender);
                addEventHandler("onClientRender",root,weaponShopRender);
            end
        end
    end
    if weaponShop then 
        if button == "left" and state == "down" then 
            if getElementData(localPlayer,"network") then
                local width, height = 210*zoom,150*zoom;
                local posX,posY = sx/2-width/2, sy/2-height/2;      
                for k,v in pairs(shopItems) do 
                    if e:isInSlot(posX+width-105*zoom,posY+(k*(45*zoom)),100*zoom,30*zoom) then 
                        if getElementData(localPlayer,"char >> money") < v[2] then 
                            return outputChatBox(e:getServerSyntax("WeaponShop","red").."You don't have enough money!",255,255,255,true);
                        else 
                            triggerServerEvent("wShop.buy",localPlayer,localPlayer,v);
                            closeWeaponShop();
                        end
                    end
                end
            end
        end
    end
end);