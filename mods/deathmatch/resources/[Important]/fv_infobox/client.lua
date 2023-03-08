local sx,sy = guiGetScreenSize();
local infos = {};
local types = {
    ["info"] = {"","servercolor"};
    ["warning"] = {"","orange"};
    ["error"] = {"","red"};
    ["success"] = {"","green"};
    ["admindutyon"] = {"","blue"};
    ["admindutyoff"] = {"","red"};
    ["kick"] = {"","orange"};
    ["adminjail"] = {"","servercolor"};
    ["ban"] = {"","red"};
};

local kick = {};

addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        font = exports.fv_engine:getFont("Yantramanav-Regular", 13);
        icons = exports.fv_engine:getFont("AwesomeFont",12);
        bigIcons = exports.fv_engine:getFont("AwesomeFont",21);
    end
end);

addEventHandler("onClientRender",root,function()
    if #infos > 0 then 
        --[[
            for k,v in pairs(infos) do 
            local textWidth = dxGetTextWidth(v.text,1,font,false) + 20 + 30;

            if v.tick+(textWidth*23) < getTickCount() then 
                v.state = "close";
                v.tick = getTickCount();
            end
            if v.state == "open" then 
                v.h = interpolateBetween(0,0,0,30,0,0,(getTickCount()-v.tick)/1500,"OutBack");
                v.w = interpolateBetween(0,0,0,textWidth,0,0,(getTickCount()-v.tick)/2000,"OutBack");
            elseif v.state == "close" then 
                v.h = interpolateBetween(30,0,0,0,0,0,(getTickCount()-v.tick)/1000,"OutBack");
                v.w = interpolateBetween(textWidth,0,0,0,0,0,(getTickCount()-v.tick)/500,"OutBack");
                if v.w == 0 then 
                    table.remove(infos,k);
                end
            end
            local color = {exports.fv_engine:getServerColor(types[v.type][2],false)};
            dxDrawRectangle(sx/2-v.w/2,sy-100-v.h/2-(k*43),v.w,v.h,tocolor(0,0,0,100),true);
            dxDrawBorder(sx/2-v.w/2,sy-100-v.h/2-(k*43),v.w,v.h,1,tocolor(color[1],color[2],color[3],200),true);
            dxDrawText(v.text,sx/2-v.w/2+30,sy-100-v.h/2-(k*43),sx/2-v.w/2+v.w,sy-100-v.h/2-(k*43)+v.h,tocolor(255,255,255,200),1,font,"center","center",true,false,true,false);
            if v.w > 30 then
                shadowedText(types[v.type][1],sx/2-v.w/2+5,sy-100-v.h/2-(k*43),v.w,sy-100-v.h/2-(k*43)+v.h,tocolor(color[1],color[2],color[3],200),1,icons,"left","center");
            end
        end
        ]]
        for k,v in pairs(infos) do 
            local textWidth = dxGetTextWidth(v.text,1,font,false) + 20 + 30;

            if v.tick+(textWidth*23) < getTickCount() then 
                v.state = "up";
                v.tick = getTickCount();
            end

            if v.state == "down" then 
                v.y = interpolateBetween(0,0,0,(k*40),0,0,(getTickCount()-v.tick)/700,"InBack");
                v.x = sx/2-15-textWidth/2;
                --v.h = interpolateBetween(0,0,0,30,0,0,(getTickCount()-v.tick)/1000,"OutBack");
            elseif v.state == "up" then 
                v.y = interpolateBetween((k*40),0,0,-40,0,0,(getTickCount()-v.tick)/1500,"InBack");
                v.x = sx/2-15-textWidth/2;
                if v.y <= -30 then 
                    table.remove(infos,k);
                end
            end
            local color = {exports.fv_engine:getServerColor(types[v.type][2],false)};
            exports.fv_engine:roundedRectangle(v.x-35,v.y,30,v.h,tocolor(color[1],color[2],color[3],130),tocolor(color[1],color[2],color[3]),true);
            shadowedText(types[v.type][1],v.x-35,v.y,v.x-35+30,v.y+v.h,tocolor(255,255,255),1,icons,"center","center");

            exports.fv_engine:roundedRectangle(v.x,v.y,textWidth,v.h,tocolor(0,0,0,100),tocolor(0,0,0,160),true);
            dxDrawText(v.text,v.x,v.y,v.x+textWidth,v.y+v.h,tocolor(255,255,255),1,font,"center","center",true,false,true,false);
        end
    end
    if #kick > 0 then 
        for k,v in pairs(kick) do 

            local width1 = dxGetTextWidth(v.text,1,font,false) + 10;
            local width2 = dxGetTextWidth(v.text2,1,font,false) + 10;

            local width = math.max(width1,width2);

            if v.tick+(width*10) < getTickCount() then 
                v.state = "close";
                v.tick = getTickCount();
            end
            v.w = width;
            if v.state == "open" then 
                v.x = interpolateBetween(sx,0,0,sx-70-width,0,0,(getTickCount()-v.tick)/1000,"OutBack");
                --v.w = interpolateBetween(0,0,0,width,0,0,(getTickCount()-v.tick)/700,"OutBack");
            elseif v.state == "close" then 
                v.x = interpolateBetween(sx-70-width,0,0,sx+70,0,0,(getTickCount()-v.tick)/1000,"InBack");
                --v.w = interpolateBetween(v.w,0,0,sx+100,0,0,(getTickCount()-v.tick)/700,"OutBack");
                if v.x >= sx+70 then 
                    table.remove(kick,k);
                end
            end
            dxDrawRectangle(v.x,100+(k*60),v.w+60,50,tocolor(0,0,0,60),true);
            dxDrawBorder(v.x,100+(k*60),v.w+60,50,3,tocolor(0,0,0));

            local color = {exports.fv_engine:getServerColor(types[v.type][2],false)};
            dxDrawText(types[v.type][1],v.x+10,100+(k*60),v.w,100+(k*60)+50,tocolor(color[1],color[2],color[3]),1,bigIcons,"left","center",false,false,true);

            dxDrawText(v.text,v.x+60,100+(k*60),v.w,55,tocolor(255,255,255),1,font,"left","top",false,false,true);
            dxDrawText(v.text2,v.x+60,125+(k*60),v.w,55,tocolor(255,255,255),1,font,"left","top",false,false,true);
        end
    end
end);

function addNotification(typ,txt,txt2)
    --table.insert(infos,{type=typ, text=txt, tick=getTickCount(), state="open", w=0, h=0});
    if typ == "kick" or typ == "adminjail" or typ == "ban" then
        table.insert(kick,{type=typ, text=txt, text2=txt2, tick=getTickCount(), state="open",x=0, w=0});
    else 
        table.insert(infos,{type=typ, text=txt, tick=getTickCount(), state="down", w=0, h=30,x=0,y=0});
        if fileExists("sounds/"..typ..".mp3") then 
            playSound("sounds/"..typ..".mp3",false);
        else 
            playSound("sounds/info.wav",false);
        end
    end
end
addEvent("showNotifications", true)
addEventHandler("showNotifications", getRootElement(), addNotification)


--UTILS--
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false,false,true,false) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false,false,true,false)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false,false,true,false) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false,false,true,false) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false,false,true,false)
end
function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color,true)
	dxDrawRectangle(x + w, y, radius, h, color,true)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color,true)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color,true)
end