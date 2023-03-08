local sx,sy = guiGetScreenSize();

local skillPed = createPed(220,298.15243530273, -82.527572631836, 1001.515625);
setElementDimension(skillPed,505);
setElementInterior(skillPed,4);
setElementFrozen(skillPed,true);
setElementData(skillPed,"ped.noDamage",true);
setElementData(skillPed,"ped >> name","Philip Cain");
setElementData(skillPed,"ped >> type","Weapon shot");

local walls = {
    {310.78112792969, -66.427635192871, 1001.515625},
    {316.61474609375, -66.693641662598, 1001.515625},
    {324.44506835938, -65.035675048828, 1001.515625}
};
local targets = { 1584, 1585, 1586 };
local target_pos = {
    {311.33560180664, -69.04598236084, 1001.515625},
    {311.77648925781, -60.959548950195, 1001.515625},
    {317.10348510742, -57.703029632568, 1001.515625},
    {317.10348510742, -63.175643920898, 1001.515625},
    {311.26986694336, -64.385665893555, 1001.515625},
    {317.29223632813, -67.6484375, 1001.515625},
    {324.93380737305, -67.092742919922, 1001.515625},
    {324.93380737305, -63.803974151611, 1001.515625},
    {324.93380737305, -60.302772521973, 1001.515625},
};
local player_pos = {303.03170776367, -64.104606628418, 1001.515625};
local end_pos = {301.6884765625, -77.163398742676, 1001.515625};
local current_target = false;
local current_target_id = 1;
local target_counter = 100;
local time = -1;
local time_timer = false;
local skilling = false;

function renderSkill()
    local sColor = exports.fv_engine:getServerColor("servercolor",true);
    local red = {exports.fv_engine:getServerColor("red",false)};
    local mediumFont = exports.fv_engine:getFont("rage",15);

    shadowedText("Remaining time: "..secondsToClock(time)..white.."\nRemaining targets: "..sColor..target_counter..white.."/100",10,0,sx,sy-55,tocolor(255,255,255),1,mediumFont,"left","bottom",false,false,false,true);


    local exitColor = tocolor(red[1],red[2],red[3],180);
    if exports.fv_engine:isInSlot(10,sy-50,200,30) then 
        exitColor = tocolor(red[1],red[2],red[3],220);
    end
    dxDrawRectangle(10,sy-50,200,30,exitColor);
    dxDrawBorder(10,sy-50,200,30,2,tocolor(0,0,0,180));
    shadowedText("Leave the shooting range",10,sy-50,210,sy-50+30,tocolor(255,255,255),1,exports.fv_engine:getFont("rage",13),"center","center");
end

function startSkill(weapon)
    if isTimer(time_timer) then 
        killTimer(time_timer);
    end
    -- setElementDimension(localPlayer,getElementData(localPlayer,"char >> id"));
    triggerServerEvent("skill.setDim",localPlayer,localPlayer,getElementData(localPlayer,"char >> id"));

    skilling = weapon;
    setElementData(localPlayer,"skilling",true);

    time = 180;
    target_counter = 100;

    time_timer = setTimer(function()
        time = time - 1;
        if time < 0 then 
            time = 0;
            outputChatBox(exports.fv_engine:getServerSyntax("WeaponSkill","red").."Time is up, skill upgrade failed.",255,255,255,true);
            stopSkill();
            if isTimer(time_timer) then
                killTimer(time_timer);
            end
        end
    end,1000,0);  

    for k,v in pairs(walls) do 
        local x,y,z = unpack(v);
        local obj = createObject(9339,x,y,z-1);
        setElementDimension(obj,getElementDimension(localPlayer));
        setElementInterior(obj,getElementInterior(localPlayer));
    end

    removeEventHandler("onClientRender",root,renderSkill);
    addEventHandler("onClientRender",root,renderSkill);

    triggerServerEvent("skill.takeWeapons",localPlayer,localPlayer);
    triggerServerEvent("skill.giveWeapon",localPlayer,localPlayer,weapons[skilling]);

    setElementPosition(localPlayer,unpack(player_pos));
    setElementRotation(localPlayer,0,0,260);

    setElementFrozen(localPlayer,true);

    makeNextTarget();
end

function makeNextTarget()
    if current_target and isElement(current_target) then
        destroyElement(current_target)
    end
    local id = math.random(1,#target_pos);
    while (current_target_id == id) do 
        id = math.random(1,#target_pos);
    end
    current_target_id = id;
    local x,y,z = unpack(target_pos[current_target_id]);
    current_target = createObject(targets[math.random(1,#targets)],x,y,z-1);
    setElementRotation(current_target,0,0,90);
    setElementDimension(current_target,getElementDimension(localPlayer));
    setElementInterior(current_target,getElementInterior(localPlayer));
end

function stopSkill()
    if current_target and isElement(current_target) then
        destroyElement(current_target)
    end
    for k,v in pairs(getElementsByType("object",resourceRoot)) do 
        destroyElement(v);
    end
    -- setElementDimension(localPlayer,getElementDimension(skillPed));
    triggerServerEvent("skill.setDim",localPlayer,localPlayer,getElementDimension(skillPed));

    setElementPosition(localPlayer,unpack(end_pos));

    skilling = false;

    setElementData(localPlayer,"skilling",false);

    if isTimer(time_timer) then 
        killTimer(time_timer);
    end
    triggerServerEvent("skill.takeWeapons",localPlayer,localPlayer);

    setElementFrozen(localPlayer,false);

    removeEventHandler("onClientRender",root,renderSkill);
end

function isSkilling()
    if skilling then 
        return true;
    else 
        return false;
    end
end

addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement )
    if skilling then 
        if hitElement and getElementType(hitElement) == "object" then 
            if isTarget(hitElement) then 
                local x,y,z = getElementPosition(hitElement);
                moveObject(hitElement,250,x,y,z-2);
                setTimer(makeNextTarget,450,1);
                target_counter = target_counter - 1;
                if target_counter < 0 then 
                    local current_state = getPedStat(localPlayer,weapons[skilling][3]);
                    current_state = current_state + math.random(100,250);
                    if current_state > 1000 then 
                        current_state = 1000;
                    end
                    triggerServerEvent("skill.updateSkill",localPlayer,localPlayer,skilling,current_state);
                    outputChatBox(exports.fv_engine:getServerSyntax("WeaponSkill","servercolor").."Your use of weapons has increased. New value: "..exports.fv_engine:getServerColor("blue",true)..current_state..white.."/1000.",255,255,255,true);
                    stopSkill();
                end
            end
        end
    end
end);

function isTarget(object)
    local state = false;
    for k,v in pairs(targets) do 
        if getElementModel(object) == v then 
           state = true;
           break; 
        end
    end
    return state;
end


--Ped panel
local panel = false;
local selectedWeapon = false;
local clickTick = 0;
addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
    if skilling then 
        if button == "left" and state == "down" then 
            if exports.fv_engine:isInSlot(10,sy-50,200,30) then 
                stopSkill();
                outputChatBox(exports.fv_engine:getServerSyntax("WeaponSkill","red").."You left the shooting range, you didn't get the skill points.",255,255,255,true);
            end
        end
    end


    if state == "down" and clickedElement and clickedElement == skillPed then 
        local playerX, playerY, playerZ = getElementPosition(localPlayer);
        if getDistanceBetweenPoints3D(playerX,playerY,playerZ,wx,wy,wz) < 2 then 
            if not panel then 
                removeEventHandler("onClientRender",root,panelRender);
                addEventHandler("onClientRender",root,panelRender);
                panel = true;
                clickTick = getTickCount();
            end
        end
    end
    if panel and button == "left" and state == "down" then 
        if clickTick+1000 > getTickCount() then 
            return;
        end
        for k,v in pairs(weapons) do 
            if exports.fv_engine:isInSlot(sx/2-200,sy/2-200+(k*40),400,40) and selectedWeapon ~= k then 
                selectedWeapon = k;
                break;
            end
        end
        if exports.fv_engine:isInSlot(sx/2-100,sy/2+205,200,30) then --Start
            if not selectedWeapon then 
                return outputChatBox(exports.fv_engine:getServerSyntax("WeaponSkill","red").."No weapon selected.",255,255,255,true);
            end
            if getElementData(localPlayer,"char >> money") < 8000 then 
                return outputChatBox(exports.fv_engine:getServerSyntax("WeaponSkill","red").."You don't have enough money.",255,255,255,true);
            end
            local x = weapons[selectedWeapon];
            if getPedStat(localPlayer,x[3]) == 1000 then 
                return outputChatBox(exports.fv_engine:getServerSyntax("WeaponSkill","red").."You don't need to practice.",255,255,255,true);
            else 
                startSkill(selectedWeapon);
                triggerServerEvent("ac.elementData",localPlayer,localPlayer,"char >> money",getElementData(localPlayer,"char >> money") - 8000);
                closePanel();
            end
        end
        if exports.fv_engine:isInSlot(sx/2+180,sy/2-200,20,20) then  --Close
            closePanel();
        end
    end
end);

function panelRender()
    local playerX,playerY,playerZ = getElementPosition(localPlayer);
    local pedX,pedY,pedZ = getElementPosition(skillPed);
    if getDistanceBetweenPoints3D(playerX,playerY,playerZ,pedX,pedY,pedZ) > 2 then 
        closePanel();
    end

    local red = {exports.fv_engine:getServerColor("red",false)};
    local sColor = {exports.fv_engine:getServerColor("servercolor",false)};
    local mediumFont = exports.fv_engine:getFont("rage",12);
    dxDrawRectangle(sx/2-200,sy/2-200,400,40,tocolor(0,0,0,250));
    dxDrawText(exports.fv_engine:getServerColor("servercolor",true).."The"..white.."Devils - Weapon shot",sx/2-200,sy/2-200,sx/2-200+400,sy/2-200+40,tocolor(255,255,255),1,exports.fv_engine:getFont("rage",15),"center","center",false,false,false,true);

    dxDrawRectangle(sx/2-203,sy/2-200,3,440,tocolor(sColor[1],sColor[2],sColor[3],180));

    for k,v in pairs(weapons) do 
        local alpha = 200;
        if k % 2 == 0 then 
            alpha = 250;
        end
        dxDrawRectangle(sx/2-200,sy/2-200+(k*40),400,40,tocolor(50,50,50,alpha));
        local hoverAlpha = 0;
        if selectedWeapon == k then 
            hoverAlpha = 100;
        end
        if exports.fv_engine:isInSlot(sx/2-200,sy/2-200+(k*40),400,40) then 
            hoverAlpha = 180;
        end

        dxDrawRectangle(sx/2-200,sy/2-200+(k*40),400,40,tocolor(sColor[1],sColor[2],sColor[3],hoverAlpha));
        dxDrawText(v[1],sx/2-195,sy/2-200+(k*40),400,sy/2-200+(k*40)+40,tocolor(255,255,255),1,mediumFont,"left","center");
        dxDrawText(exports.fv_engine:getServerColor("servercolor",true)..getPedStat(localPlayer,v[3])..white.."/1000",sx/2-200,sy/2-200+(k*40),sx/2+195,sy/2-200+(k*40)+40,tocolor(255,255,255),1,mediumFont,"right","center",false,false,false,true);
    end

    dxDrawRectangle(sx/2-200,sy/2+200,400,40,tocolor(0,0,0,250));

    local buttonColor = {red[1],red[2],red[3],180};
    if getElementData(localPlayer,"char >> money") > 3999 then 
        buttonColor = {sColor[1],sColor[2],sColor[3],180};
    end
    if exports.fv_engine:isInSlot(sx/2-100,sy/2+205,200,30) then 
        buttonColor[4] = 220;
    end
    dxDrawRectangle(sx/2-100,sy/2+205,200,30,tocolor(buttonColor[1],buttonColor[2],buttonColor[3],buttonColor[4]));
    dxDrawText("Gyakorlás (8000 $)",sx/2-100,sy/2+205,sx/2-100+200,sy/2+205+30,tocolor(255,255,255),1,exports.fv_engine:getFont("rage",12),"center","center");

    local closeColor = tocolor(255,255,255);
    if exports.fv_engine:isInSlot(sx/2+180,sy/2-200,20,20) then 
        closeColor = tocolor(red[1],red[2],red[3]);
    end
    dxDrawText("",sx/2+180,sy/2-200,sx/2+180+20,sy/2-200+20,closeColor,1,exports.fv_engine:getFont("AwesomeFont",13),"center","center");
end

function closePanel()
    selectedWeapon = false;
    removeEventHandler("onClientRender",root,panelRender);
    panel = false;
end


triggerServerEvent("skill.takeWeapons",localPlayer,localPlayer);
