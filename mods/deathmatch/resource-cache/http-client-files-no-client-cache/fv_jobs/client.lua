--Scriptet Írta: Csoki
addEventHandler("onClientResourceStart",root,function(res)
    if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        sColor = {exports.fv_engine:getServerColor("servercolor",false)};
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
        red = {exports.fv_engine:getServerColor("red",false)};
        white = "#FFFFFF";
        font = exports.fv_engine:getFont("rage",11);
        font2 = exports.fv_engine:getFont("rage",12);
        font3 = exports.fv_engine:getFont("rage",14);

        bigFont = exports.fv_engine:getFont("Yantramanav-Regular",17);
    end
end);


sx,sy = guiGetScreenSize();

local show = false;
local jobPed = createPed(214,1406.009765625, -1675.44921875, 13.65468788147);
setElementData(jobPed,"ped >> name","Jessica Smith");
setElementData(jobPed,"ped >> type","Recruitment");
setElementFrozen(jobPed,true);
setElementData(jobPed,"ped.noDamage",true);
setElementRotation(jobPed,0,0,265);
addEventHandler("onClientClick",root,function(button,state,_,_,wx,wy,wz,element)
    if state == "down" and element and element == jobPed then 
        local px,py,pz = getElementPosition(localPlayer);
        if getDistanceBetweenPoints3D(px,py,pz,wx,wy,wz) < 5 and not show then 
            if not getElementData(localPlayer,"network") then return end;

            show = true;
            removeEventHandler("onClientRender",root,jobPanelRender);
            addEventHandler("onClientRender",root,jobPanelRender);
            setElementFrozen(localPlayer,true);
        end
    end
end);

function jobPanelRender()
    dxDrawRectangle(sx/2-240,sy/2-150,480,300,tocolor(0,0,0,160));
    dxDrawRectangle(sx/2-243,sy/2-150,3,300,tocolor(sColor[1],sColor[2],sColor[3]));
    exports.fv_engine:shadowedText("Working",sx/2-200,sy/2-175,sx/2-200+400,0,tocolor(255,255,255),1,bigFont,"center","top");
    shadowedText("To exit, press "..sColor2.."backspace"..white.." button.",sx/2-200,sy/2+160,sx/2-200+400,0,tocolor(255,255,255),1,font3,"center","top");

    for k,v in pairs(jobs) do 
        local name,desc = unpack(v);
        dxDrawText(name,sx/2-235,sy/2-190+(k*50),400,300,tocolor(255,255,255),1,font2);
        dxDrawText(desc,sx/2-235,sy/2-170+(k*50),400,300,tocolor(255,255,255),1,font);

        local text = "Contract.";
        local color = {sColor[1],sColor[2],sColor[3],150};
        if getElementData(localPlayer,"char >> job") == k then 
            text = "Termination.";
            color = {red[1],red[2],red[3],100};
        end
        if exports.fv_engine:isInSlot(sx/2+80,sy/2-190+(k*50),150,35) then 
            color[4] = 255;
        end
        dxDrawRectangle(sx/2+80,sy/2-190+(k*50),150,35,tocolor(color[1],color[2],color[3],color[4]));
        exports.fv_engine:shadowedText(text,sx/2+80,sy/2-190+(k*50),sx/2+80+150,sy/2-190+(k*50)+35,tocolor(255,255,255),1,font,"center","center");
    end
end

addEventHandler("onClientKey",root,function(button,state)
    if not getElementData(localPlayer,"network") then return end;

    if button == "mouse1" and state and show then 
        for k,v in pairs(jobs) do 
            local name,desc = unpack(v);
            if exports.fv_engine:isInSlot(sx/2+80,sy/2-190+(k*50),150,35) then 
                if getElementData(localPlayer,"char >> job") == k then 
                    setElementData(localPlayer,"char >> job",0);
                    exports.fv_infobox:addNotification("info","You have successfully quit your job.");
                else 
                    if (getElementData(localPlayer,"char >> job") or 0) ~= k and (getElementData(localPlayer,"char >> job") or 0) > 0 then 
                        exports.fv_infobox:addNotification("error","Terminate your previous job.");
                        return;
                    end
                    setElementData(localPlayer,"char >> job",k);
                    exports.fv_infobox:addNotification("info","You have successfully contracted "..name..".");
                end
            end
        end
    end
    if button == "backspace" and state then 
        if show then 
            removeEventHandler("onClientRender",root,jobPanelRender);
            show = false;
            setElementFrozen(localPlayer,false);
        end
    end
end);


--UTILS--
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, true, true)
end
function getVehicleSpeed(veh)
	if veh then
		local x, y, z = getElementVelocity (veh)
		return math.sqrt( x^2 + y^2 + z^2 ) * 187.5
	end
end
function getRandomSkin()
	local all = getValidPedModels()
	return all[math.random(1,#all)]
end
function setControl(state)
    toggleControl("accelerate",state);
    toggleControl("brake",state);
    toggleControl("enter_exit",state);
    toggleControl("sprint",state);
    toggleControl("jump",state);
    toggleControl("crouch",state);
    toggleControl("fire",state);
    toggleControl("enter_passenger",state);
    if state then 
        exports.fv_dead:reloadBones();
    end
end
setControl(true);
-------------------------------



--Vehicle Delete--
local delTimer = false;
addEventHandler("onClientPlayerVehicleExit", localPlayer, function(veh, seat)
    if veh and getElementData(localPlayer,"job.veh") == veh then 
        if isTimer(delTimer) then 
            killTimer(delTimer);
        end
        delTimer = setTimer(function()
            triggerServerEvent("job.destroyVeh",localPlayer,localPlayer);
            delTimer = false;
            setControl(true);
        end,1000*60*10,1);
        outputChatBox(exports.fv_engine:getServerSyntax("Work","orange").."You got out of your work vehicle if you didn't sit back "..exports.fv_engine:getServerColor("servercolor",true).."10#FFFFFF percen belül törlődik!",255,255,255,true);
    end
end);
addEventHandler("onClientPlayerVehicleEnter",localPlayer,function(veh, seat)
    if veh and getElementData(localPlayer,"job.veh") == veh then 
        if isTimer(delTimer) then 
            killTimer(delTimer);
            outputChatBox(exports.fv_engine:getServerSyntax("Work","orange").."You sat back in the work vehicle, it will not be deleted.",255,255,255,true);
        end
    end
end);



--Ped no Damage--
addEventHandler("onClientPedDamage",root,function()
    if getElementData(source,"ped.noDamage") then 
        cancelEvent();
    end
end);
addEventHandler("onClientPlayerStealthKill", localPlayer, function(target)
    if getElementData(target,"ped.noDamage") then 
        cancelEvent();
    end
end)