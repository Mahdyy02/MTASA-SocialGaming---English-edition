addEventHandler("onClientResourceStart",resourceRoot,function()
    for k,v in pairs(neons) do 
        local col = engineLoadCOL("neons/col.col");
        engineReplaceCOL(col, v);
        local dff = engineLoadDFF("neons/" .. k .. ".dff");
        engineReplaceModel(dff, v);     
    end
    Async:foreach(getElementsByType("vehicle",root,true),function(v,k)
        local neon = (getElementData(v,"tuning.neon") or false);
        if neon then 
            addNeon(v,neon);
        end
    end);
end);
-----------------

local neonCache = {};
function addNeon(veh,type)
    removeNeon(veh);
    if neons[type] then 
        local x,y,z = getElementPosition(veh);
        local obj = createObject(neons[type],x,y,z);   
        setElementAlpha(obj,0); 
        setElementCollisionsEnabled(obj,false);
        attachElements(obj,veh,0.6,0,0.1);

        local obj2 = createObject(neons[type],x,y,z);    
        setElementAlpha(obj2,0);
        setElementCollisionsEnabled(obj2,false);
        attachElements(obj2,veh,-0.6,0,0.1);

        neonCache[veh] = {obj,obj2};
    end
end

function removeNeon(veh)
    if neonCache[veh] then 
        if neonCache[veh][1] then 
            if isElement(neonCache[veh][1]) then 
                destroyElement(neonCache[veh][1]);
            end
        end
        if neonCache[veh][2] then 
            if isElement(neonCache[veh][2]) then 
                destroyElement(neonCache[veh][2]);
            end
        end
        neonCache[veh] = nil;
    end
end

addEventHandler("onClientElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "vehicle" and isElementStreamedIn(source) then 
        if dataName == "tuning.neon" then 
            if newValue then 
                if (getElementData(source,"tuning.neonState") or false) then 
                    addNeon(source,newValue);
                end
            end
        end
        if dataName == "tuning.neonState" then 
            if not getElementData(source,"tuning.neon") then 
                removeNeon(source);
                return;
            end
            if newValue then 
                addNeon(source,getElementData(source,"tuning.neon"));
            else 
                removeNeon(source);
            end
        end
    end
end);

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == "vehicle" then 
        local value = getElementData(source,"tuning.neon");
        if value then 
            if (getElementData(source,"tuning.neonState") or false) then 
                addNeon(source,value);
            end
        end
    end
end);

addEventHandler("onClientElementStreamOut", root, function()
    if getElementType(source) == "vehicle" then 
        removeNeon(source);
    end
end);

addEventHandler("onClientElementDestroy", root, function()
    if getElementType(source) == "vehicle" then 
        removeNeon(source);
    end
end);


bindKey("n","down",function()
    if isPedInVehicle(localPlayer) then 
        local veh = getPedOccupiedVehicle(localPlayer);
        if veh and getPedOccupiedVehicleSeat(localPlayer) == 0 then 
            if getElementData(veh,"tuning.neon") then 
                local state = (getElementData(veh,"tuning.neonState") or false);
                setElementData(veh,"tuning.neonState",not state);
                if not state then 
                    outputChatBox(e:getServerSyntax("Neon","servercolor").."Neon"..e:getServerColor("servercolor",true).." on"..white.."!",255,255,255,true);
                else 
                    outputChatBox(e:getServerSyntax("Neon","red").."Neon"..e:getServerColor("red",true).." turned off"..white..".",255,255,255,true);
                end
            end
        end
    end
end);