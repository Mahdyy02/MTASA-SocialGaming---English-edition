--SOCIALGAMING 2019

addEvent("collapsed.anim",true);
addEventHandler("collapsed.anim",root,function(player,state)
    if state == "start" then 
        for k,v in pairs(toggleTable) do
            toggleControl(player,v,false);
        end

        setPedAnimation(player, 'sweet', 'sweet_injuredloop')

        setElementData(player,"collapsedTimer",setTimer(function()
            if player and isElement(player) then 
                if getElementData(player,"collapsedTime")-1 <= 0 then 
                    setElementHealth(player,0);
                    killTimer(getElementData(player,"collapsedTimer"));
                    setPedAnimation(player, 'sweet', 'sweet_injuredloop')
                else 
                    setElementData(player,"collapsedTime",getElementData(player,"collapsedTime")-1);
                    for k,v in pairs(toggleTable) do
                        toggleControl(player,v,false);
                    end
                end
            end
        end,1000,0));

    elseif state == "stop" then
        for k,v in pairs(toggleTable) do
            toggleControl(player,v,true);
        end
        setPedAnimation(player, false);

        setElementData(player,"collapsedTime",0);
        local timer = getElementData(player,"collapsedTimer") or false;
        if isTimer(timer) then 
            killTimer(timer);
            setElementData(player,"collapsedTimer",false);
        end
        setElementData(player,"collapsed",false);
        setElementData(player,"getupHelper",false);
        setElementFrozen(player,false);
    end
end);

addEvent("collapsed.item",true);
addEventHandler("collapsed.item",root,function(player,target)
    local item = exports.fv_inventory:hasItem(player,71)
    if item then
        setElementData(player,"getupPanel",true);
        setElementData(player,"getupTarget",target);
        setElementData(target,"getupHelper",player);
        exports.fv_inventory:takePlayerItem(player, 71);
    else 
        exports["fv_infobox"]:addNotification(player, "error", "You don't have a first aid kit!")
    end
end);

addEvent("collapsed.suc",true);
addEventHandler("collapsed.suc",root,function(player,target)
    setElementData(player,"getupPanel",false); --Panel off
    setElementData(player,"getupTarget",false);

    for k,v in pairs(toggleTable) do
        toggleControl(target,v,true);
    end
    setPedAnimation(target, false);

    setElementData(target,"collapsedTime",0);
    local timer = getElementData(target,"collapsedTimer") or false;
    if isTimer(timer) then 
        killTimer(timer);
        setElementData(target,"collapsedTimer",false);
    end
    setElementData(target,"collapsed",false);
    setElementData(target,"getupHelper",false);
    setElementHealth(target,50);
    setElementData(target, "char >> bone", {true, true, true, true, true});
    setElementFrozen(target,false);
    setElementFrozen(player,false);	
end);

addEvent("collapsed.dead",true);
addEventHandler("collapsed.dead",root,function(player,target)
    setElementData(player,"getupPanel",false); --Panel off
    setElementData(player,"getupTarget",false);

    for k,v in pairs(toggleTable) do
        toggleControl(target,v,true);
    end
    setPedAnimation(target, false);

    setElementData(target,"collapsedTime",0);
    local timer = getElementData(target,"collapsedTimer") or false;
    if isTimer(timer) then 
        killTimer(timer);
        setElementData(target,"collapsedTimer",false);
    end
    setElementData(target,"collapsed",false);
    setElementData(target,"getupHelper",false);

    setElementFrozen(target,false);
	setElementFrozen(player,false);
    setElementHealth(target,0);
end);

