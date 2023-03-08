local fishState = false;
local cache = {};
local click = 0;

function renderHorgasz()
    dxDrawImage(sx/2-200,sy/2-100,400,200,"fish/alap.png");
    dxDrawText(cache.id,sx/2-30,sy/2-85,sx/2+130,200,tocolor(255,255,255,100),1,font,"right","top",false,false,false,true);    
    dxDrawText(sColor2..cache.name,sx/2-30,sy/2-47,400,200,tocolor(255,255,255),1,font,"left","top",false,false,false,true);    
    dxDrawText(sColor2..getGender(cache.gender),sx/2-50,sy/2-25,400,200,tocolor(255,255,255),1,font,"left","top",false,false,false,true);    
    dxDrawText(sColor2..cache.date,sx/2-40,sy/2,400,200,tocolor(255,255,255),1,font,"left","top",false,false,false,true);    
    dxDrawText(red2..cache.exdate,sx/2+48,sy/2+22,400,200,tocolor(255,255,255),1,font,"left","top",false,false,false,true);    
    dxDrawText(blue2..cache.name,sx/2-80,sy/2+55,400,200,tocolor(255,255,255),1,signFont,"left","top",false,false,false,true);    
    dxDrawImage(sx/2-200 + 15,sy/2-100 + 60,128*0.7,128*0.7,":fv_assets/images/skins/" .. getElementModel(localPlayer) .. ".png")

    if isElementWithinColShape(localPlayer,varoshazaCol) and cache.name == getElementData(localPlayer,"char >> name") then 
        local color = tocolor(sColor[1],sColor[2],sColor[3],180);
        if e:isInSlot(sx/2-150,sy/2+120,300,35) then 
            color = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and click+500 < getTickCount() then 
                if getElementData(localPlayer,"char >> money") >= 1500 then 
                    triggerServerEvent("fish.renew",localPlayer,localPlayer,cache.dbid);
                    cache = {};
                    removeEventHandler("onClientRender",root,renderHorgasz);
                    click = getTickCount();
                else
                    outputChatBox(e:getServerSyntax("Horgászengedély","red").."Nincs elég pénzed a megújításhoz!",255,255,255,true);
                end
                click = getTickCount();
            end
        end
        dxDrawRectangle(sx/2-150,sy/2+120,300,35,color);
        dxDrawBorder(sx/2-150,sy/2+120,300,35,2,tocolor(0,0,0));
        e:shadowedText("Megújítás (1500 $)",sx/2-150,sy/2+120,sx/2-150+300,sy/2+120+35,tocolor(255,255,255),1,font,"center","center");
    end
end

addEvent("fishing.show",true);
addEventHandler("fishing.show",localPlayer,function(data)
    fishState = not fishState;
    if fishState then 
        cache = {};
        cache = {
            id = data[1];
            name = data[2];
            gender = data[3];
            date = data[4];
            exdate = data[5];
            dbid = data[6];
        }
        removeEventHandler("onClientRender",root,renderHorgasz);
        addEventHandler("onClientRender",root,renderHorgasz);
    else 
        cache = {};
        removeEventHandler("onClientRender",root,renderHorgasz);
    end
end);