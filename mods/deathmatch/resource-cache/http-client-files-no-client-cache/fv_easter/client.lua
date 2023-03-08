txd = engineLoadTXD ( "rabbit.txd" );
engineImportTXD ( txd, 199);
dff = engineLoadDFF ( "rabbit.dff");
engineReplaceModel ( dff, 199);
-------------------------------
local e = exports.fv_engine;
local sx,sy = guiGetScreenSize();
local show = false;

--MINIGAME--
local keys = {
    ["down"] = "",
    ["up"] = "",
    ["left"] = "",
    ["right"] = "",
}
local keyss = {
    ["arrow_l"] = "left";
    ["arrow_r"] = "right";
    ["arrow_u"] = "up";
    ["arrow_d"] = "down";
}
local cache = {};
local start = sx+50;
------------------

addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
if not getElementData(localPlayer,"network") then return end;
    if state == "down" then 
        if clickedElement and (getElementData(clickedElement,"rabbit") or false) then 
            local px,py,pz = getElementPosition(localPlayer);
            if getDistanceBetweenPoints3D(wx,wy,wz,px,py,pz) < 3 then 
                if getElementData(localPlayer,"admin >> level") > 2 then 
                    outputChatBox(exports.fv_engine:getServerSyntax("Húsvét","red").."Admin vagy nem beszélhetsz vele.",255,255,255,true);
                    return;
                end
                if getElementData(clickedElement,"used") then 
                    outputChatBox(exports.fv_engine:getServerSyntax("Húsvét","red").."Már valaki beszélt vele!",255,255,255,true);
                    return;
                end
                if not show then 
                    setElementData(clickedElement,"used",localPlayer);
                    outputChatBox("Húsvéti nyúl mondja: Üdvözöllek, "..getElementData(localPlayer,"char >> name")..". Mint láthatod eljöttem hozzátok.",255,255,255,true);
                    setTimer(function()
                        outputChatBox("Húsvéti nyúl mondja: Ha sikerül teljesítened az ügyességi próbát, megkapod az ajándékod.",255,255,255,true);

                        cache = {};
                        start = sx+50;
                        for i=1,30 do 
                            local x = {
                                [1] = "left",
                                [2] = "down",
                                [3] = "up",
                                [4] = "right"
                            }
                            cache[i] = {x[math.random(1,#x)],tocolor(255,255,255)};
                        end

                    end,500,1);
                    setTimer(function()
                        show = true;
                        removeEventHandler("onClientPreRender",root,render);
                        addEventHandler("onClientPreRender",root,render);
                        setElementFrozen(localPlayer,true);
                    end,500,1); 
                end
            end
        end
    end
end);



function render(dt)
    start = start - 0.1*dt;
    dxDrawRectangle(sx/2-25,sy-200,50,50,tocolor(0,0,0,100));

    local volt = 0;
    for k, v in pairs(cache) do 
        local button,color = unpack(v);
        dxDrawText(keys[button],start+(k*100),sy-200,0,sy-200+50,color,1,e:getFont("AwesomeFont",20),"left","center");
        if start+(k*100) < sx/2-50 and not isBoxInSlot(start+(k*100),sy-200,30,50) then 
            if color == tocolor(255,255,255) then 
                local red = {exports.fv_engine:getServerColor("red",false)};
                cache[k][2] = tocolor(red[1],red[2],red[3]);
            end
            volt = volt + 1;
        end
    end


    dxDrawText(volt.."/"..#cache,0,sy-230,sx,50,tocolor(255,255,255),1,e:getFont("rage",16),"center");

    if volt == #cache then 
        removeEventHandler("onClientPreRender",root,render);
        result();
    end
end

addEventHandler("onClientKey",root,function(downedButton,state)
    if keyss[downedButton] and state then 
        for k, v in pairs(cache) do 
            local button,color = unpack(v);
            if color == tocolor(255,255,255) then
                if isBoxInSlot(start+(k*100),sy-200,30,50) then 
                    if button == keyss[downedButton] then
                        local green = {exports.fv_engine:getServerColor("servercolor",false)};
                        cache[k][2] = tocolor(green[1],green[2],green[3]);
                    else
                        local red = {exports.fv_engine:getServerColor("red",false)};
                        cache[k][2] = tocolor(red[1],red[2],red[3]);
                    end
                    break;
                end
            end
        end
    end
end);

function isBoxInSlot( x, y, width, height )
    local targetX, targetY, targetW, targetH = sx/2-25,sy-200,50,50;
    if (x >= targetX and x <= targetX + targetW) and (y >= targetY and y <= targetY + targetH) then
        return true;
    else 
        return false;
    end
end

function result()
    local green = {exports.fv_engine:getServerColor("servercolor",false)};
    local jo = 0;
    for k,v in pairs(cache) do 
        if v[2] == tocolor(green[1],green[2],green[3]) then 
            jo = jo + 1;
        end
    end
    if jo > 25 then 
        outputChatBox("Húsvéti nyúl mondja: Ügyes vagy! Itt a jutalmad.",255,255,255,true);
        if getElementData(localPlayer,"network") then 
            triggerServerEvent("easter.giveItem",localPlayer,localPlayer);
        end
        setTimer(function()
            outputChatBox("Húsvéti nyúl mondja: Most mennem kell, remélem még találkozunk. Itt leszek a környéken egy darabig.",255,255,255,true);
        end,1500,1);
    else 
        outputChatBox("Húsvéti nyúl mondja: Ez most sajnos nem sikerült...",255,255,255,true);
        setTimer(function()
            outputChatBox("Húsvéti nyúl mondja: Ne csüggedj még találkozunk, itt leszek a környéken.",255,255,255,true);
            triggerServerEvent("easter.newPosition",localPlayer,localPlayer);
        end,500,1);
    end
    show = false;
    setElementFrozen(localPlayer,false);
end