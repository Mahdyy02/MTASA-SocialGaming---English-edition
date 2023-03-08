local e = exports.fv_engine;
local show = false;
local sx,sy = guiGetScreenSize();
local types = {
    "Weapons/Ammunition","Money","Master books","Other Items/Cards",
}
local active = 1;
local items = {
    [1] = {
        --itemid,db,ar
        --[[{14,1,3000}, --AK
        {15,1,3500}, -- M4A4
        {16,1,5000}, -- KATANA
        {17,1,3000}, -- DEagle
        {18,1,100}, --- Ütő
        {19,1,2000}, -- KÉS
        {21,1,2500}, -- Sörétes
        {24,1,2500}, -- Colt
        {25,1,5000}, -- MesterLővés
        {26,1,2000}, -- Vadászpuska
		{27,1,3500}, -- Mp5
		{28,1,2500}, -- UZI
		{30,1,3000}, -- TEc9
		{31,50,500}, -- 9MM löszer
		{32,30,400}, -- Sörétes Lőszer
		{33,30,500}, -- 7,6]]
		
    },
    [2] = {
        --itemid,db,ar
        {15000,1,1000},
        {100000,1,5000},
        {1000000,1,10000},
    },
    [3] = {
        --itemid,db,ar
        -- {2,1,10},
        -- {3,1,10},
        -- {4,1,10},
		-- {5,1,10},
		-- {6,1,10},
		-- {7,1,10},
		-- {8,1,10},
		-- {9,1,10},
		-- {10,1,10},
		-- {11,1,10},
		-- {12,1,10},
		-- {13,1,10},
		-- {43,1,200},
		-- {44,1,300},
		-- {45,1,300},
		{98,1,2000},
		{99,1,2000},
		{100,1,2000},
		{101,1,2000},
		{102,1,2000},
		{103,1,2000},
		{104,1,2000},
		{105,1,2000},
		{106,1,2000},
    },
    [4] = {
        --itemid,db,ar
        {1,1,200},
        {91,1,500},
        {92,1,400},
		{94,1,400},
		{38,1,500},
		{39,1,100},
		{93,1,300},
		{69,1,100},
		{70,1,100},
		{71,1,50},
		{72,1,50},
		{86,1,50},
		
    },
}
local clickTick = 0;
local scroll = 0;
local max = 8;

local timer = false;

addEventHandler("onClientResourceStart",root,function(res)
    if getThisResource() == res or getResourceName(res) == "fv_engine" then 
        e = exports.fv_engine;
        font = e:getFont("rage",11);
        icons = e:getFont("AwesomeFont",17);
        smallFont = e:getFont("rage",10);
        sColor = {e:getServerColor("servercolor",false)};
        
    end
end);

function drawShop()
    if (not getElementData(localPlayer,"network")) or getPlayerPing(localPlayer) > 180 then 
        active = 1;
        scroll = 0;
        removeEventHandler("onClientRender",root,drawShop);
    end

    dxDrawRectangle(sx/2-200,sy/2-200,400,400,tocolor(0,0,0,180));
    dxDrawRectangle(sx/2-203,sy/2-200,3,400,tocolor(sColor[1],sColor[2],sColor[3],180));

    for k,v in pairs(types) do 
        local color = tocolor(0,0,0,180);
        if e:isInSlot(sx/2-500+(k*170),sy/2+220,150,30) then 
            color = tocolor(sColor[1],sColor[2],sColor[3]);
            if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                if k ~= active then 
                    active = k;
                    scroll = 0;
                    clickTick = getTickCount();
                end
            end
        end
        if active == k then 
            color = tocolor(sColor[1],sColor[2],sColor[3]);
        end
        dxDrawRectangle(sx/2-500+(k*170),sy/2+220,150,30,color);
        e:shadowedText(v,sx/2-500+(k*170),sy/2+220,sx/2-500+(k*170)+150,sy/2+220+30,tocolor(255,255,255),1,font,"center","center");
    end

    local count = 0;
    for k,v in pairs(items[active]) do 
        if k > scroll and count < max then 
            count = count + 1;
            if active ~= 2 then 
                dxDrawImage(sx/2-190,sy/2-240+(count*50),35,35,exports.fv_inventory:getItemImage(v[1]));
                dxDrawText(exports.fv_inventory:getItemName(v[1]),sx/2-150,sy/2-240+(count*50),400,400,tocolor(255,255,255),1,font);
                dxDrawText("\n"..v[2].." db",sx/2-150,sy/2-240+(count*50),400,400,tocolor(255,255,255),1,smallFont);

                local color = tocolor(sColor[1],sColor[2],sColor[3],180);
                local text = "Vásárlás";
                if e:isInSlot(sx/2+40,sy/2-240+(count*50),150,30) then 
                    color = tocolor(sColor[1],sColor[2],sColor[3],220);
                    text = formatMoney(v[3]).." PP";
                    if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                        if getElementData(localPlayer,"char >> premiumPoints") < v[3] then 
                            exports.fv_infobox:addNotification("error","Nincs elég prémium pontod!");                        
                        else
                            if isTimer(timer) then 
                                exports.fv_infobox:addNotification("error","Csak 4 másodpercenként használhatod!");
                                clickTick = getTickCount();
                            else 
                                triggerServerEvent("ppshop.buy",localPlayer,localPlayer,v);
                                if isTimer(timer) then 
                                    killTimer(timer);
                                end
                                timer = setTimer(function()
                                    if isTimer(timer) then 
                                        killTimer(timer);
                                    end
                                end,4000,1);
                            end
                        end
                        clickTick = getTickCount();
                    end
                end
                dxDrawRectangle(sx/2+40,sy/2-240+(count*50),150,30,color);
                e:shadowedText(text,sx/2+40,sy/2-240+(count*50),sx/2+40+150,sy/2-240+(count*50)+30,tocolor(255,255,255),1,font,"center","center");
            else 
                dxDrawText(formatMoney(v[1]).. "$",sx/2-150,sy/2-230+(count*50),400,400,tocolor(255,255,255),1,font);

                dxDrawText("",sx/2-190,sy/2-240+(count*50),sx/2-190+35,sy/2-240+(count*50)+35,tocolor(255,255,255),1,icons,"center","center");
            
                local color = tocolor(sColor[1],sColor[2],sColor[3],180);
                local text = "Vásárlás";
                if e:isInSlot(sx/2+40,sy/2-240+(count*50),150,30) then 
                    color = tocolor(sColor[1],sColor[2],sColor[3],220);
                    text = formatMoney(v[3]).." PP";
                    if getKeyState("mouse1") and clickTick+500 < getTickCount() then 
                        if getElementData(localPlayer,"char >> premiumPoints") < v[3] then 
                            exports.fv_infobox:addNotification("error","Nincs elég prémium pontod!");                        
                        else 
                            if isTimer(timer) then 
                                exports.fv_infobox:addNotification("error","Csak 4 másodpercenként használhatod!");
                                clickTick = getTickCount();
                            else 
                                triggerServerEvent("ppshop.buy",localPlayer,localPlayer,v,true);
                                if isTimer(timer) then 
                                    killTimer(timer);
                                end
                                timer = setTimer(function()
                                    if isTimer(timer) then 
                                        killTimer(timer);
                                    end
                                end,4000,1);
                            end
                        end
                        clickTick = getTickCount();
                    end
                end
                dxDrawRectangle(sx/2+40,sy/2-240+(count*50),150,30,color);
                e:shadowedText(text,sx/2+40,sy/2-240+(count*50),sx/2+40+150,sy/2-240+(count*50)+30,tocolor(255,255,255),1,font,"center","center");
            end
        end
    end
end

addEventHandler("onClientKey",root,function(button,state)
    if show then 
        if button == "mouse_wheel_up" and state then 
            if e:isInSlot(sx/2-200,sy/2-200,400,400) then 
                if scroll > 0 then 
                    scroll = scroll - 1;
                end
            end
        end
        if button == "mouse_wheel_down" and state then 
            if e:isInSlot(sx/2-200,sy/2-200,400,400) then 
                if scroll < #items[active] - max then 
                    scroll = scroll + 1;
                end
            end
        end
    end
end);

-- bindKey("mouse_wheel_up","down",function()
--     if show then 
--         if e:isInSlot(sx/2-200,sy/2-200,400,400) then 
--             if scroll > 0 then 
--                 scroll = scroll - 1;
--             end
--         end
--     end
-- end)

-- bindKey("mouse_wheel_down","down",function()
--     if show then 
--         if e:isInSlot(sx/2-200,sy/2-200,400,400) then 
--             if scroll < #items[active] - max then 
--                 scroll = scroll + 1;
--             end
--         end
--     end
-- end)


bindKey("F9","down",function()
    show = not show;
    if show then 
        active = 1;
        scroll = 0;
        removeEventHandler("onClientRender",root,drawShop);
        addEventHandler("onClientRender",root,drawShop);
    else 
        removeEventHandler("onClientRender",root,drawShop);
    end
end);

--UTILS--
function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end