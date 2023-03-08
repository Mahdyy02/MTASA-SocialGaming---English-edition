function getAdminColor(element, level)
    local adminColor = exports["fv_admin"]:getAdminColor(element, level)
    return adminColor
end
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end
function shadowedTextDead(text,x,y,w,h,color,fontsize,font,aligX,alignY)
	text = text:gsub("#%x%x%x%x%x%x","")
    dxDrawText(text,x,y+1,w,h+1,tocolor(0,0,0),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y-1,w,h-1,tocolor(0,0,0),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text,x-1,y,w-1,h,tocolor(0,0,0),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x+1,y,w+1,h,tocolor(0,0,0),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end
function shadowedTextNevek(text,x,y,w,h,color,fontsize,font,aligX,alignY)
	text = text:gsub("#%x%x%x%x%x%x","")
    dxDrawText(text,x,y+1,w,h+1,tocolor(0,0,0),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y-1,w,h-1,tocolor(0,0,0),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text,x-1,y,w-1,h,tocolor(0,0,0),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x+1,y,w+1,h,tocolor(0,0,0),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,tocolor(255,0,0),fontsize,font,aligX,alignY, false, false, false, true)
end
function SecondsToClock(seconds)
	local seconds = tonumber(seconds)
  	if seconds <= 0 then
		return "00:00:00";
	else
		hours = string.format("%02.f", math.floor(seconds/3600));
		mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
		secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
		return hours..":"..mins..":"..secs
	end
end
setTimer(function()
	if isChatBoxInputActive() or isConsoleActive() then 
		setElementData(localPlayer,"typing",true);
	else 
		setElementData(localPlayer,"typing",false);
	end
end,100,0);

