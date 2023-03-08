local sx,sy = guiGetScreenSize();
local show = false;
local element = false;
local tick = 0;

addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        font = exports.fv_engine:getFont("rage",12);
        font2 = exports.fv_engine:getFont("rage",11);       
        font3 = exports.fv_engine:getFont("rage",15);
        sColor = {exports.fv_engine:getServerColor("servercolor",false)};
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
        white = "#FFFFFF";
    end
end);


function shopRender()
    dxDrawRectangle(sx/2-200,sy/2-250,400,500,tocolor(0,0,0,180));
    dxDrawRectangle(sx/2-203,sy/2-250,3,500,tocolor(sColor[1],sColor[2],sColor[3]));
    shadowedText(sColor2.."TheDevils - #FFFFFFShop",0,sy/2-275,sx,500,tocolor(255,255,255),1,font3,"center","top",false,false,false,true);
    shadowedText("Press "..sColor2.."BACKSPACE#FFFFFF to close.",0,sy/2+250,sx,500,tocolor(255,255,255),1,font,"center","top",false,false,false,true);

    if shopItems[show] then 
        for k,v in pairs(shopItems[show]) do 
            local alpha = 160;
            local text = "Buying";
            if exports.fv_engine:isInSlot(sx/2+40,sy/2-275+(k*40),150,30) then 
                alpha = 200;
                text = tostring(formatMoney(v[2])).." dt";
            end
            dxDrawRectangle(sx/2+40,sy/2-275+(k*40),150,30,tocolor(sColor[1],sColor[2],sColor[3],alpha));
            shadowedText(text,sx/2+40,sy/2-275+(k*40),sx/2+40+150,sy/2-275+(k*40)+30,tocolor(255,255,255),1,font,"center","center");
            dxDrawImage(sx/2-195,sy/2-275+(k*40),30,30,exports.fv_inventory:getItemImage(v[1]));
            dxDrawText(exports.fv_inventory:getItemName(v[1]),sx/2-160,sy/2-275+(k*40),0,sy/2-275+(k*40)+30,tocolor(255,255,255),1,font2,"left","center",false,false,false,true);
        end
    end

    if show then --Bezárja ha messzire megy
        local px,py,pz = getElementPosition(localPlayer);
        local wx,wy,wz = getElementPosition(element);
        if getDistanceBetweenPoints3D(px,py,pz,wx,wy,wz) > 4 then 
            closeShop();
        end
    end
end

addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickElement)
    if state == "down" and clickElement then 
        if getElementData(clickElement,"shop.type") or false then 
            local px,py,pz = getElementPosition(localPlayer);
            if getDistanceBetweenPoints3D(px,py,pz,wx,wy,wz) < 4 and tick+1000 < getTickCount() then 
                element = clickElement;
                show = getElementData(clickElement,"shop.type");
                removeEventHandler("onClientRender",root,shopRender);
                addEventHandler("onClientRender",root,shopRender);
                setElementData(localPlayer,"pednames.show",false);
            end
        end
    end
end);

addEventHandler("onClientKey",root,function(button,state)
    if button == "backspace" and state then 
        if show then 
            closeShop();
        end
    end
    if button == "mouse1" and state then 
        if shopItems[show] then 
            for k,v in pairs(shopItems[show]) do 
                if exports.fv_engine:isInSlot(sx/2+40,sy/2-275+(k*40),150,30) then 
                    if getElementData(localPlayer,"char >> money") < v[2] then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Shop","red").."You don't have enough money to buy!",255,255,255,true);
                        return;
                    end
                    triggerServerEvent("shop.buy",localPlayer,localPlayer,v);
                    closeShop();
                end
            end
        end
    end
end);

function closeShop()
    show = false;
    element = false;
    removeEventHandler("onClientRender",root,shopRender);
    tick = getTickCount();
    setElementData(localPlayer,"pednames.show",true);
end

--UTILS--
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end