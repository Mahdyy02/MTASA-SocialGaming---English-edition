--[[local sx,sy = guiGetScreenSize();
local show = false;
local cache = {};
local active = 1;
local typeScroll = 0;
local typeMax = 19;
local count = 0;
local clickTick = 0;
local contentScroll = 0;
local contentMax = 19;
local activeString = "";

function renderLogs()
    dxDrawRectangle(sx/2-400,sy/2-350,800,700,tocolor(0,0,0,180));
    dxDrawRectangle(sx/2-400,sy/2-350,200,700,tocolor(0,0,0,180));
    local r,g,b = exports.fv_engine:getServerColor("servercolor",false);
    count = 1;
    local geci = 0;
    for k,v in pairs(cache) do 
        if count > typeScroll and geci < typeMax then 
            geci = geci + 1;
            if active == count then 
                activeString = k;
                dxDrawRectangle(sx/2-390,sy/2-370+(geci*35),180,30,tocolor(r,g,b,180));
                local geci2 = 0;
                for j,l in pairs(v) do
                    if j > contentScroll and geci2 < contentMax then 
                        geci2 = geci2 + 1;
                        dxDrawRectangle(sx/2-200,sy/2-370+(geci2*35),590,30,tocolor(200,200,200,50));
                        dxDrawText(l[1],sx/2-190,sy/2-370+(geci2*35),sx/2-200+590,sy/2-370+(geci2*35)+30,tocolor(255,255,255),1,"default-bold","left","center");
                        dxDrawText(l[2],sx/2-200,sy/2-370+(geci2*35),sx/2-200+580,sy/2-370+(geci2*35)+30,tocolor(255,255,255),1,"default-bold","right","center");
                    end
                end
            else 
                dxDrawRectangle(sx/2-390,sy/2-370+(geci*35),180,30,tocolor(200,200,200,50));
            end
            if getKeyState("mouse1") and clickTick+400 < getTickCount() then 
                if exports.fv_engine:isInSlot(sx/2-390,sy/2-370+(geci*35),180,30) then 
                    active = count;
                    contentScroll = 0;
                    clickTick = getTickCount();
                end
            end
            dxDrawText(k,sx/2-390,sy/2-370+(geci*35),sx/2-390+180,sy/2-370+30+(geci*35),tocolor(255,255,255),1,"default-bold","center","center");
        end
        count = count + 1;
    end
end

addCommandHandler("logs",function()
    if getElementData(localPlayer,"admin >> level") > 7 then 
        show = not show;
        if show then 
            triggerServerEvent("logs.getAll",localPlayer,localPlayer);
            outputChatBox(exports.fv_engine:getServerSyntax("Log","servercolor").."Várj egy kicsit amíg a logok betöltenek.",255,255,255,true);
        else 
            cache = {};
            active = 1;
            typeScroll = 0;
            typeMax = 19;
            count = 0;
            clickTick = 0;
            contentScroll = 0;
            contentMax = 19;
            activeString = "";
            removeEventHandler("onClientRender",root,renderLogs);
        end
    end
end);

bindKey("mouse_wheel_up","down",function()
if show then 
    if exports.fv_engine:isInSlot(sx/2-400,sy/2-350,200,700) then 
        if typeScroll > 0 then 
            typeScroll = typeScroll - 1;
        end
    end
    if exports.fv_engine:isInSlot(sx/2-200,sy/2-350,600,700) then 
        if contentScroll > 0 then 
            contentScroll = contentScroll - 1;
        end
    end
end
end);
bindKey("mouse_wheel_down","down",function()
if show then 
    if exports.fv_engine:isInSlot(sx/2-400,sy/2-350,200,700) then 
        if typeScroll < count - typeMax then 
            typeScroll = typeScroll + 1;
        end
    end
    if exports.fv_engine:isInSlot(sx/2-200,sy/2-350,600,700) then 
        if contentScroll < #cache[activeString] - contentMax then 
            contentScroll = contentScroll + 1;
        end
    end
end
end);

addEvent("logs.return",true);
addEventHandler("logs.return",root,function(datas)
    active = 1;
    typeScroll = 0;
    typeMax = 19;
    count = 0;
    clickTick = 0;
    contentScroll = 0;
    contentMax = 19;
    activeString = "";
    cache = {};
    for k,v in pairs(datas) do 
        cache[k] = v;
    end
    typeScroll = 0;
    count = 0;
    removeEventHandler("onClientRender",root,renderLogs);
    addEventHandler("onClientRender",root,renderLogs);
end);
]]





function createLog(system, content)
    if system and content then
        triggerServerEvent("createLog", localPlayer, system, content)
    end
end

function deleteLog(dbid)
    if dbid then
        triggerServerEvent("deleteLog", localPlayer, dbid)
    end
end
