function getDate()
    local rt = getRealTime();
    local minute = rt.minute;
    local hour = rt.hour;
    if minute < 10 then 
        minute = "0"..minute;
    end
    if hour < 10 then 
        hour = "0"..hour;
    end
    local temp = string.format("%04d.%02d.%02d - %02d:%02d", rt.year + 1900, rt.month + 1, rt.monthday, hour, minute);
    return temp;
end

local sx,sy = guiGetScreenSize();
local date = getDate();

addEventHandler("onClientRender",root,function()
    if not getElementData(localPlayer,"acc >> id") then return end;

    dxDrawText("TheDevils | accountID: "..getElementData(localPlayer,"acc >> id").." | "..date,5,0,sx,sy,tocolor(255,255,255,255/2),1,"default-bold","left","bottom");
end);


setTimer(function()
    date = getDate();
end,1000*10,0);