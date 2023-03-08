local utlevelState = false;
local cache = {};
local click = 0;
function renderUtlevel()
    dxDrawImage(sx/2-200,sy/2-100,400,200,"utlevel/alap.png");
    dxDrawText(cache.id,sx/2-30,sy/2-90,sx/2+130,200,tocolor(255,255,255,100),1,font,"right","top",false,false,false,true);    
    dxDrawText(sColor2..cache.name,sx/2-5,sy/2-57,400,200,tocolor(255,255,255),1,font,"left","top",false,false,false,true);    
    dxDrawText(sColor2..getGender(cache.gender),sx/2-20,sy/2-30,400,200,tocolor(255,255,255),1,font,"left","top",false,false,false,true);    
    dxDrawText(sColor2..cache.date,sx/2-10,sy/2-10,400,200,tocolor(255,255,255),1,font,"left","top",false,false,false,true);    
    dxDrawText(red2..cache.exdate,sx/2+67,sy/2+10,400,200,tocolor(255,255,255),1,font,"left","top",false,false,false,true);    
    dxDrawText(blue2..cache.name,sx/2-80,sy/2+55,400,200,tocolor(255,255,255),1,signFont,"left","top",false,false,false,true);    
    dxDrawImage(sx/2-200 + 30,sy/2-100 + 50,128*0.8,128*0.8,":fv_assets/images/skins/" .. getElementModel(localPlayer) .. ".png")

    if isElementWithinColShape(localPlayer,varoshazaCol) and cache.name == getElementData(localPlayer,"char >> name") then 
        local color = tocolor(sColor[1],sColor[2],sColor[3],180);
        if e:isInSlot(sx/2-150,sy/2+120,300,35) then 
            color = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and click+500 < getTickCount() then 
                if getElementData(localPlayer,"char >> money") >= 100 then 
                    triggerServerEvent("passport.renew",localPlayer,localPlayer,cache.dbid);
                    cache = {};
                    removeEventHandler("onClientRender",root,renderUtlevel);
                    click = getTickCount();
                else
                    outputChatBox(e:getServerSyntax("Passport","red").."You don't have enough money to renew!",255,255,255,true);
                end
                click = getTickCount();
            end
        end
        dxDrawRectangle(sx/2-150,sy/2+120,300,35,color);
        dxDrawBorder(sx/2-150,sy/2+120,300,35,2,tocolor(0,0,0));
        e:shadowedText("Renewal (100 dt)",sx/2-150,sy/2+120,sx/2-150+300,sy/2+120+35,tocolor(255,255,255),1,font,"center","center");
    end
end

function showUtlevel(id)
    utlevelState = not utlevelState;
    if utlevelState then 
        triggerServerEvent("passport.getData",localPlayer,localPlayer,id);
    else 
        cache = {};
        removeEventHandler("onClientRender",root,renderUtlevel);
    end
end
addEvent("passport.showUtlevel",true);
addEventHandler("passport.showUtlevel",localPlayer,showUtlevel);

addEvent("passport.returnData",true)
addEventHandler("passport.returnData",localPlayer,function(data)
    cache = {};
    cache = {
        id = data[1];
        name = data[2];
        gender = data[3];
        date = data[4];
        exdate = data[5];
    }
    removeEventHandler("onClientRender",root,renderUtlevel);
    addEventHandler("onClientRender",root,renderUtlevel);
end);