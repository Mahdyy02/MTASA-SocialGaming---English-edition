local sx,sy = guiGetScreenSize();
local cam = {
    ["start"] = {813.86608886719,-1102.3422851563,29.346799850464,813.53173828125,-1101.798828125,28.5767993927}; --start
    ["end"] = {814.03527832031,-1094.3575439453,29.360000610352,813.63763427734,-1094.7984619141,28.555347442627}; --end
}
local camPos = "start";
local camUP = 0;
local ped = false;
local time = 0;
local deadTimer = false;
local camRemover = false;

--Camera Move--
local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
        removeEventHandler("onClientPreRender",root,camRender)
        --setCameraTarget(localPlayer, localPlayer)
        camMove = false
	end
end
function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	end
end
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then return false end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
    addEventHandler("onClientPreRender",root,camRender, true, "low")
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"Linear")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"Linear")
	sm.moov = 1
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
    setTimer(destroyElement,time,1,sm.object2)
    camMove = true;
	return true
end
function getOtherCam(current)
    if current == "start" then 
        return "end";
    else 
        return "start";
    end
end
function moveCam()
    smoothMoveCamera(cam[camPos][1],cam[camPos][2],cam[camPos][3],cam[camPos][4],cam[camPos][5],cam[camPos][6],cam[getOtherCam(camPos)][1],cam[getOtherCam(camPos)][2],cam[getOtherCam(camPos)][3],cam[getOtherCam(camPos)][4],cam[getOtherCam(camPos)][5],cam[getOtherCam(camPos)][6],10000);
    setTimer(function()
        if not isPedDead(localPlayer) then return end;
        camPos = getOtherCam(camPos);
        moveCam();
     end,10500,1); 
end
function goUPrender()
    if camUP > 50 and camUP ~= 10 then 
        camUP = 50;
        camPos = "start";
        moveCam();
        removeEventHandler("onClientRender",root,goUPrender);
    end
    local a,b,c,d,e,f = getCameraMatrix(localPlayer);
    setCameraMatrix(a,b,c+0.1,d,e,f);
    camUP = camUP + 0.1;
    exports.fv_blur:createBlur();
    dxDrawRectangle(0,0,sx,sy,tocolor(0,0,0,camUP*4.6));
    exports.fv_engine:shadowedText("Death: " .. SecondsToClock(time),0,0,sx,sy,tocolor(255,255,255),1,exports.fv_engine:getFont("rage",30),"center","center");
end
-----------------
addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        font = exports.fv_engine:getFont("rage", 10);
    end
end);

function deadTimeRender()
    local x,y = getScreenFromWorldPosition(getElementPosition(ped));
    if x and y then 
        dxDrawRectangle(x-100,y,200,50,tocolor(200,200,200,100));
        exports.fv_engine:shadowedText(getElementData(localPlayer,"char >> name").." tet5ayel fi rou7ek mayet.\nMazel: "..SecondsToClock(time).." w tfi9!",x-100,y,x-100+200,y+50,tocolor(255,255,255),1,font,"center","center",false,false,false,true);
    end
end

function startDead(t)
    time = t;
    setElementData(localPlayer,"dead.skin",getElementModel(localPlayer));
    setElementData(localPlayer,"dead.pos",{getElementPosition(localPlayer)});
    setElementData(localPlayer,"dead.interior",getElementInterior(localPlayer));
    setElementData(localPlayer,"dead.dimension",getElementDimension(localPlayer));
    if isElement(ped) then 
        destroyElement(ped);
    end
    ped = createPed(getElementModel(localPlayer),811.30920410156, -1098.3413085938, 25.90625-0.8);
    setElementFrozen(ped,true);
    setElementRotation(ped,90,360,90,"ZYX",true);
    setElementCollisionsEnabled(ped,false);
    camPos = "start";
    removeEventHandler("onClientRender",root,deadTimeRender);
    addEventHandler("onClientRender",root,deadTimeRender);

    camUP = 0;
    removeEventHandler("onClientRender",root,goUPrender);
    addEventHandler("onClientRender",root,goUPrender);

    if isTimer(deadTimer) then 
        killTimer(deadTimer);
    end
    deadTimer = setTimer(function()
        time = time - 1;
        if time <= 0 then 
            killTimer(deadTimer);
            stopDead();
            triggerServerEvent("dead.respawn",localPlayer,localPlayer);
        end
    end,1000,0);
    setElementHealth(localPlayer,0);
    setElementData(localPlayer,"char >> dead",true);
    showChat(false);
end

function stopDead()
    if isElement(ped) then 
        destroyElement(ped);
    end
    if isTimer(deadTimer) then 
        killTimer(deadTimer);
    end
    removeCamHandler();
    removeEventHandler("onClientRender",root,deadTimeRender);
    camRemover = setTimer(function()
        if sm.moov == 1 then 
            removeCamHandler();
        else 
            if isTimer(camRemover) then 
                killTimer(camRemover);
            end
        end
    end,500,0);  
    time = 0;
    showChat(true);

    goUP = 0;
    removeEventHandler("onClientRender",root,goUPrender);
    setCameraTarget(localPlayer);

    setElementData(localPlayer,"dead.interior",false);
    setElementData(localPlayer,"dead.dimension",false);
end 


addEvent("dead.startClient",true);
addEventHandler("dead.startClient",root,function(player)
    if player == localPlayer then 
        startDead(60*5);
    end
end);
addEventHandler("onClientPlayerWasted",getRootElement(),function(killer,weapon,body)
    if source == localPlayer then 
        if body == 9 then 
            startDead(60*5);
        else 
            startDead(60*5);
        end
    end
end);
addEventHandler("onClientResourceStart",resourceRoot,function()
    if isPedDead(localPlayer) or (getElementData(localPlayer,"char >> dead") or false) then 
        startDead(60*5);
    end
end);
addEventHandler("onClientElementDataChange",getRootElement(),function(dataName)
if source == localPlayer then 
    if dataName == "char >> dead" then 
        local value = getElementData(localPlayer,"char >> dead");
        if value then 
            startDead(60*5);
        else 
            stopDead();
        end
    end
end
end);

addEventHandler("onClientPlayerDamage",root,function(attacker, weapon, bodypart)
    if getElementData(source,"admin >> duty") and getElementData(source,"admin >> level") > 2 then return end;
    if bodypart == 9 and weapon ~= 23 then 
        setElementHealth(source,0);
    end
end);



--UTILS--
function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
    if seconds and seconds <= 0 then
        return "00:00";
    else
	    hours = string.format("%02.f", math.floor(seconds/3600));
	    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
	    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
	    return mins..":"..secs
    end
end
