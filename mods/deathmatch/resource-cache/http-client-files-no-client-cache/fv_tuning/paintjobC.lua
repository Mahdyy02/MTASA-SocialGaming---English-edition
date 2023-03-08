local pjTextures = {};
local pjCache = {};

addEventHandler("onClientResourceStart",resourceRoot,function()
    for name,_ in pairs(paintjobs) do
        if fileExists("paintjobs/"..name..".png") then 
            pjTextures[name] = dxCreateTexture("paintjobs/"..name..".png","dxt5");
        end
    end;
    setTimer(function()
        Async:foreach(getElementsByType("vehicle",root,true),function(v)
            local value = getElementData(v,"tuning.paintJob");
            if value then 
                addPaintJob(v,value);
            end
        end);
    end,100,1);
end);


function addPaintJob(veh,name)
    removePaintJob(veh);
    if name and pjTextures[name] and fileExists("paintjobs/"..name..".png") and veh then 
        local shader = dxCreateShader("replace.fx",0,100);
		dxSetShaderValue(shader, "TEXTURE", pjTextures[name]);
		engineApplyShaderToWorldTexture(shader, paintjobs[name][2] or "*remap*", veh);
        pjCache[veh] = {shader,name};
    end
end

function removePaintJob(veh)
    if pjCache[veh] then 
        if pjCache[veh][1] then 
            engineRemoveShaderFromWorldTexture(pjCache[veh][1],paintjobs[pjCache[veh][2]][2] or "*remap*",veh);
            if isElement(pjCache[veh][1]) then 
                destroyElement(pjCache[veh][1]);
            end
        end
        pjCache[veh] = nil;
    end
end

addEventHandler("onClientElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "vehicle" and isElementStreamedIn(source) then 
        if dataName == "tuning.paintJob" then 
            print("asd")
            if newValue then 
                print("rá")
                addPaintJob(source,newValue);
            end
        end
    end
end);

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == "vehicle" then 
        local value = getElementData(source,"tuning.paintJob");
        if value then 
            addPaintJob(source,value);
        end
    end
end);

addEventHandler("onClientElementStreamOut", root, function()
    if getElementType(source) == "vehicle" then 
        removePaintJob(source);
    end
end);

addEventHandler("onClientElementDestroy", root, function()
    if getElementType(source) == "vehicle" then 
        removePaintJob(source);
    end
end);

addCommandHandler("gpj", function()
    print(inspect(getPaintJobs(getPedOccupiedVehicle(localPlayer))))
end)