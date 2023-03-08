white = "#FFFFFF";

local cuffs = {};

--Handcuffs SYNC--
function setPedAnimationSpeed(player,anim,speed)
	triggerClientEvent(root, "animSped", root, player,anim,speed)
end

setTimer(function()
    for k,v in pairs(getElementsByType("player")) do 
        local obj = cuffs[v];
        if getElementData(v,"cuffed") then 
            if obj and isElement(obj) then 
                local dim,inter = getElementDimension(v),getElementInterior(v);
                local state = getElementData(v,"cuffed");
                setElementInterior(obj,inter);
                setElementDimension(obj,dim);
                setTimer(setPedAnimationSpeed,60,1,v, "pass_Smoke_in_car", 0)
                toggleControl(v,"fire", not state);
                toggleControl(v,"enter_exit", not state);
                toggleControl(v,"sprint", not state);
                toggleControl(v,"jump", not state);
                toggleControl(v,"crouch", not state);
                toggleControl(v,"aim_weapon", not state);
                --toggleControl(v,"enter_passenger", not state);
                toggleControl(v,"enter_exit", not state);
            else 
                setPedAnimation(v);
                setPedAnimation(v,"ped", "pass_Smoke_in_car", 0, true, true, true);
                setTimer(setPedAnimationSpeed,60,1,v, "pass_Smoke_in_car", 0)
                local x, y, z = getElementPosition(v);
                local box = createObject(364, x, y, z);
                setElementData(box,"player",v);
                exports.fv_bone:attachElementToBone(box, v, 12, 0,0,0,   0,40,-10);
                setElementCollisionsEnabled(box, false);
                cuffs[v] = box;
            end
        else 
            if isElement(obj) then 
                exports.fv_bone:detachElementFromBone(obj);
                destroyElement(obj);
            end
            cuffs[v] = nil;
        end
    end

    for k,v in pairs(getElementsByType("object",resourceRoot)) do 
        if getElementModel(v) == 364 then 
            local player = getElementData(v,"player")
            if player and not getElementData(player,"cuffed") then 
                destroyElement(v);
            end
        end
    end
end,1000,0);

addEventHandler("onVehicleExit", getRootElement(),
function(player, seat)
    if getElementData(player,"cuffed") then
        setTimer(function()
            if getElementData(player,"cuffed") then
                setPedAnimation(player,"ped", "pass_Smoke_in_car", 0, true, true, true);
                setTimer(setPedAnimationSpeed,60,1,player, "pass_Smoke_in_car", 0)
                local x, y, z = getElementPosition(player);
                local box = createObject(364, x, y, z);
                setElementData(box,"player",player);
                exports.fv_bone:attachElementToBone(box, player, 12, 0,0,0,   0,40,-10);
                setElementCollisionsEnabled(box, false);
                cuffs[player] = box;
            end
        end,500,1);
	end
end)

addEventHandler("onVehicleStartEnter", getRootElement(),
function(player, seat)
    if getElementData(player,"cuffed") then
        local obj = cuffs[player];
        if isElement(obj) then 
            exports.fv_bone:detachElementFromBone(obj);
            destroyElement(obj);
            cuffs[player] = nil;
        end
	end
end)

addEventHandler("onPlayerQuit", getRootElement(),function()
    local obj = cuffs[source]
    if isElement(obj) then 
        exports.fv_bone:detachElementFromBone(obj);
        destroyElement(obj);
        cuffs[source] = nil;
    end
end);

addEventHandler("onPlayerWasted", getRootElement(),function()
    if getElementData(source,"cuffed") then
        local obj = cuffs[source];
        if isElement(obj) then 
            exports.fv_bone:detachElementFromBone(obj);
            destroyElement(obj);
            cuffs[source] = nil;
        end
        local state = false;
        setElementData(source,"cuffed",state);
        toggleControl(source,"fire", not state);
        toggleControl(source,"enter_exit", not state);
        toggleControl(source,"sprint", not state);
        toggleControl(source,"jump", not state);
        toggleControl(source,"crouch", not state);
        toggleControl(source,"aim_weapon", not state);
        --toggleControl(source,"enter_passenger", not state);
        toggleControl(source,"enter_exit", not state);
        setElementData(source,"cuffed",false);
        setElementData(source,"collapsed",false);
    end
end);
--Handcuffs SYNC VÉGE--

addEvent("cuff",true);
addEventHandler("cuff",root,function(player,target,state,a)
    setElementData(target,"cuffed",state);
    toggleControl(target,"fire", not state);
    toggleControl(target,"enter_exit", not state);
    toggleControl(target,"sprint", not state);
    toggleControl(target,"jump", not state);
    toggleControl(target,"crouch", not state);
    toggleControl(target,"aim_weapon", not state);
    toggleControl(target,"enter_passenger", not state);
    local sColor = exports.fv_engine:getServerColor("servercolor",true);
    if state then 
        outputChatBox(exports.fv_engine:getServerSyntax("Handcuffs","servercolor").."You have successfully handed your player.",player,255,255,255,true);
        outputChatBox(exports.fv_engine:getServerSyntax("Handcuffs","servercolor")..sColor..getElementData(player,"char >> name")..white.." handcuffed you!",target,255,255,255,true);
        if a == "fraki" then 
            exports.fv_inventory:takePlayerItem(player,87);
        end
        setPedAnimation(target);
        setPedAnimation(target,"ped", "pass_Smoke_in_car", 0, true, true, true);
        setTimer(setPedAnimationSpeed,60,1,target, "pass_Smoke_in_car", 0)
        local x, y, z = getElementPosition(target);
        local box = createObject(364, x, y, z);
        setElementData(box,"player",target);
        exports.fv_bone:attachElementToBone(box, target, 12, 0,0,0,   0,40,-10);
        setElementCollisionsEnabled(box, false);
        cuffs[target] = box;
        toggleControl(target,"enter_exit", false);
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Handcuffs","red").."You have successfully removed the Handcuffset.",player,255,255,255,true);
        outputChatBox(exports.fv_engine:getServerSyntax("Handcuffs","red")..sColor..getElementData(player,"char >> name")..white.." took the Handcuffset off you.",target,255,255,255,true);
        if a == "fraki" then 
            exports.fv_inventory:givePlayerItem(player,87,1,1,100,0);
        end
        exports.fv_bone:detachElementFromBone(cuffs[target]);
        destroyElement(cuffs[target]);
        cuffs[target] = nil;
        setPedAnimation(target, "ped", "pass_Smoke_in_car", 0, false, false, false, false);
        toggleControl(target,"enter_exit", true);
    end
end);

function adminUncuff(player,command,...)
    if getElementData(player,"admin >> level") > 3 then 
        if not ... then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Name/ID]",player,255,255,255,true) return end;
        local target = table.concat({...}," ");
        local targetPlayer = exports.fv_engine:findPlayer(player,target);
        if targetPlayer then 
            if getElementData(targetPlayer,"cuffed") then 
                setElementData(targetPlayer,"cuffed",false);
                toggleControl(targetPlayer,"fire", true);
                toggleControl(targetPlayer,"enter_exit", true);
                toggleControl(targetPlayer,"sprint", true);
                toggleControl(targetPlayer,"jump", true);
                local sColor = exports.fv_engine:getServerColor("servercolor",true);
                outputChatBox(exports.fv_engine:getServerSyntax("Handcuffs","servercolor").."You removed the Handcuffset from the player.",player,255,255,255,true);
                outputChatBox(exports.fv_engine:getServerSyntax("Handcuffs","servercolor")..sColor..exports.fv_admin:getAdminName(player,true)..white.." took the Handcuffset off you.",targetPlayer,255,255,255,true);
            else 
                outputChatBox(exports.fv_engine:getServerSyntax("Handcuffs","red").."There are no players in Handcuffs.",player,255,255,255,true)
            end
        end
    end
end
addCommandHandler("auncuff",adminUncuff,false,false);
