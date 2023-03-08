function blipsRender()
    local px,py,pz = getElementPosition(localPlayer);
    if getElementDimension(localPlayer) == 0 then 
        for k,v in pairs(getElementsByType("blip")) do 
            local x,y = getScreenFromWorldPosition(getElementPosition(v));
            local bx,by,bz = getElementPosition(v);
            local distance = getDistanceBetweenPoints3D(px,py,pz,bx,by,bz);
            if x and y then 
                if (distance < 500 or (getElementData(v,"blip >> maxVisible") or false)) then 
                    local icon = getBlipIcon(v);
                    if icon ~= 2 and icon ~= 15 then 
                        local name = "Ismeretlen Blip";
                        if (getElementData(v, "blip >> name") or false) then
                            name = getElementData(v, "blip >> name");
                        elseif blipNames[icon] then
                            name = blipNames[icon];
                        end 
                        local r,g,b = unpack(getElementData(v,"blip >> color") or {255,255,255});
                        dxDrawImage(x,y+15,25,25,"blips/"..icon..".png",0,0,0,tocolor(r,g,b,180));
                        exports.fv_engine:shadowedText(name.."\n "..math.floor(distance).." m",x,y+40,x+30,0,tocolor(255,255,255),1,font,"center","top");
                    end
                end
            end
        end
    end
end

addEventHandler("onClientElementDataChange",localPlayer,function(dataName,oldValue,newValue)
    if dataName == "3dBlip" then 
        if newValue then 
            removeEventHandler("onClientRender",getRootElement(),blipsRender);
            addEventHandler("onClientRender",getRootElement(),blipsRender);
        else 
            removeEventHandler("onClientRender",getRootElement(),blipsRender);
        end
    end
end);

addEventHandler("onClientResourceStart",resourceRoot,function()
    if getElementData(localPlayer,"3dBlip") then 
        addEventHandler("onClientRender",getRootElement(),blipsRender);
    end
    loadState()
end)

function loadState()
    if fileExists("3dstate.save") then 
        local file = fileOpen("3dstate.save");
        local cache = fileRead(file,1000);
        if cache == "true" then 
            cache = true;
        else 
            cache = false;
        end
        setElementData(localPlayer,"3dBlip",cache);
        fileClose(file);
        outputDebugString(" 3D blips state LOADED!",0,100,100,100,200);
    end
end

function saveState()
    if fileExists("3dstate.save") then 
        fileDelete("3dstate.save");
    end
    local file = fileCreate("3dstate.save");
    fileWrite(file,tostring(getElementData(localPlayer,"3dBlip")));
    fileClose(file);
    outputDebugString(" 3D blips state SAVED!",0,100,100,100,200);
end
addEventHandler("onClientResourceStop",resourceRoot,saveState);