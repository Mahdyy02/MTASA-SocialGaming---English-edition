function getVehicleSpeed(veh)
	if veh then
		local x, y, z = getElementVelocity (veh)
		return math.sqrt( x^2 + y^2 + z^2 ) * 187.5
	end
end
function getFormatGear(veh)
    local gear = getVehicleCurrentGear(veh)
    local rear = "R"
	local neutral = "N"
    if (gear > 0) and getVehicleSpeed(veh) > 0 then 
		return gear
	elseif getVehicleSpeed(veh) <= 0 then 
		return neutral;
    else
        return rear
    end
end
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, true, true)
end
function getVehicleRPM(vehicle)
    local vehicleRPM = 0
        if (vehicle) then  
            if (getVehicleEngineState(vehicle)) then
                if getVehicleCurrentGear(vehicle) > 0 then             
                vehicleRPM = math.floor((getVehicleSpeed(vehicle)/getVehicleCurrentGear(vehicle))*120 + 0.5);
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750);
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900);
                end
             else
                vehicleRPM = math.floor(getVehicleSpeed(vehicle)*120 + 0.5);
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750);
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900);
                end
            end
        else
            vehicleRPM = 0;
        end
        return tonumber(vehicleRPM * 0.027551020408163266),tonumber(vehicleRPM*0.75);
    else
        return 0;
    end
end