white = "#FFFFFF";

weapons = {
    --Fegyvernév,fegyverID,skillID
    {"Colt-45",22,69},
	{"Desert Eagle",24,71},

	{"AK-47",30,77},
	{"M4",31,78},

	{"Shotgun",25,72},
	{"With sawn pipe",26,73},

	{"Sniper / Hunting Rifle",34,79},
    
	{"MP5",29,76},
	{"UZI",28,75},
};

function secondsToClock(seconds)
	local seconds = tonumber(seconds)
  	if seconds <= 0 then
		return "00:00";
	else
		local hours = string.format("%02.f", math.floor(seconds/3600));
		local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        local time = mins..":"..secs;
        if seconds < 11 then 
            time = exports.fv_engine:getServerColor("red",true) .. time;
        end
		return time; 
	end
end
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, true, true)
end
function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end