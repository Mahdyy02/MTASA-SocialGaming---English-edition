addEvent("taser.sound",true);
addEventHandler("taser.sound",root,function(x,y,z)
    playSound3D("weapons/tasereffect.mp3", x, y, z, false) 
end);

addEventHandler("onClientPlayerDamage",localPlayer,function(attacker,weapon)
    if weapon == 23 then 
        cancelEvent();
    end
end);

addEventHandler("onClientVehicleDamage", root, function(attacker, weapon, loss, x, y, z, tire)
    if (weapon == 23) then
        cancelEvent()
    end
end);

addEventHandler("onClientElementDataChange",localPlayer,function(dataName,old,new)
    if dataName == "char >> taser" then 
        if new then 
            fadeCamera(false, 0.5,255,255,255)            
            setTimer (function () 
                fadeCamera(true, 0.5)
            end,1000*10,1)
        else 
            toggleAllControls(true);
            exports.fv_dead:reloadBones();
        end
    end
end);
