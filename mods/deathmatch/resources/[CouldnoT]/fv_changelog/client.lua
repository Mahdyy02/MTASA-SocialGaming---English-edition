local e = exports.fv_engine;
local sx,sy = guiGetScreenSize();
local show = false;
local scroll,max = 0,14;
local cache = {};

addEventHandler("onClientResourceStart",root,function(res)
    if res == getThisResource() or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        topFont = e:getFont("rage",15);
        textFont = e:getFont("rage",11);
        textFont2 = e:getFont("rage",10);
        sColor = {e:getServerColor("servercolor",false)};
    end
end);

function renderChangelog()
    exports.fv_blur:createBlur();
    local w,h = 900,450;
    dxDrawRectangle(sx/2-w/2,sy/2-h/2,w,h,tocolor(0,0,0,110));
    dxDrawRectangle(sx/2-w/2,sy/2-h/2,w,30,tocolor(20,20,20));
    e:shadowedText("Changelog",0,sy/2-h/2-30,sx,h,tocolor(255,255,255),1,topFont,"center");
    dxDrawRectangle(sx/2-w/2-3,sy/2-h/2,3,h,tocolor(sColor[1],sColor[2],sColor[3]));

    dxDrawRectangle(sx/2-w/2+130,sy/2-h/2,5,h,tocolor(20,20,20));
    dxDrawRectangle(sx/2+w/2-100,sy/2-h/2,5,h,tocolor(20,20,20));
    dxDrawRectangle(sx/2+w/2-250,sy/2-h/2,5,h,tocolor(20,20,20));

    dxDrawText("Script",sx/2-w/2+10,sy/2-h/2+5,w,h,tocolor(255,255,255),1,textFont,"left");
    dxDrawText("Date",sx/2-w/2,sy/2-h/2+5,sx/2-w/2+w-10,h,tocolor(255,255,255),1,textFont,"right");
    dxDrawText("Developer",sx/2+w/2-250,sy/2-h/2+5,sx/2+w/2-90,h,tocolor(255,255,255),1,textFont,"center");

    local count = 0;
    for k,v in pairs(cache) do 
        if k > scroll and count < max then 
            count = count + 1;
            local resource,change,developer,date = unpack(v);

            local color = tocolor(0,0,0,50);
            if k % 2 == 0 then 
                color = tocolor(0,0,0,80);
            end
            dxDrawRectangle(sx/2-w/2,sy/2-h/2+(count*30),w,30,color);
            dxDrawText(resource,sx/2-w/2+10,sy/2-h/2+5+(count*30),w,h,tocolor(255,255,255),1,textFont2,"left");
            dxDrawText(change,sx/2-w/2+150,sy/2-h/2+5+(count*30),w,h,tocolor(255,255,255),1,textFont,"left");
            dxDrawText(developer,sx/2+w/2-250,sy/2-h/2+5+(count*30),sx/2+w/2-90,h,tocolor(255,255,255),1,textFont,"center");
            dxDrawText(date:gsub("-","."),sx/2-w/2,sy/2-h/2+5+(count*30),sx/2-w/2+w-10,h,tocolor(255,255,255),1,textFont,"right");
        end
    end
end

function scrollDown()
    if scroll < #cache - max then 
        scroll = scroll + 1;
    end
end
function scrollUp()
    if scroll > 0 then 
        scroll = scroll - 1;
    end
end

function showChangelog(state)
    if show then 
        bindKey("mouse_wheel_down","down",scrollDown);
        bindKey("mouse_wheel_up","down",scrollUp);
        removeEventHandler("onClientRender",root,renderChangelog);
        addEventHandler("onClientRender",root,renderChangelog);
        setElementData(localPlayer,"togHUD",false);
        showChat(false);
    else 
        unbindKey("mouse_wheel_down","down",scrollDown);
        unbindKey("mouse_wheel_up","down",scrollUp);
        removeEventHandler("onClientRender",root,renderChangelog);
        setElementData(localPlayer,"togHUD",true);
        showChat(true);
        cache = {};
    end
end

addEvent("changelog.return",true);
addEventHandler("changelog.return",root,function(data)
    cache = {};
    --[[for k,v in pairs(data) do
        cache[#cache + 1] = v;
    end]]
    for k,v in pairs(data) do 
        cache[#cache + 1] = {v.script,v.leiras,v.developer,v.datum};
    end
end);

bindKey("F2","down",function()
    show = not show;
    showChangelog(show);
    if show then 
        triggerServerEvent("changelog.get",localPlayer,localPlayer);
    end
end);

addCommandHandler("changelog",function(cmd)
    if getElementData(localPlayer,"loggedIn") then 
        triggerServerEvent("changelog.get",localPlayer,localPlayer);
        show = not show;
        showChangelog(show);
    end
end);