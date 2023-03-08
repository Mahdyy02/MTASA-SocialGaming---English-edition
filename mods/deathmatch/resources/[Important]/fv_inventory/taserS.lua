local taser = {};

addEventHandler ("onPlayerWeaponFire", root, function (weapon, endX, endY, endZ, hitElement, startX, startY, startZ)
    if weapon == 23 then 
        local x,y,z = getElementPosition(source);
        triggerClientEvent(root,"taser.sound",root,x,y,z);
        
        if hitElement and not (getElementData(hitElement,"admin >> duty") and getElementData(hitElement,"admin >> level") > 2) then 
            setElementData ( hitElement, "char >> taser", true )
            setElementFrozen ( hitElement, true )
            toggleAllControls(hitElement,false)
            toggleControl(hitElement,"chatbox",true);
            setPedAnimation( hitElement, "crack", "crckidle2", -1, true, false, true)
            if isTimer(taser[hitElement]) then 
                killTimer(taser[hitElement]);
            end
            taser[hitElement] = setTimer(function()
                if isElement(hitElement) then 
                    setElementData(hitElement, "char >> taser", false)
                    setElementFrozen(hitElement, false)
                    setPedAnimation(hitElement)
                    toggleAllControls(hitElement,true)
                    taser[hitElement] = nil
                end
            end, 1000*20, 1)
        end
    end
end)
