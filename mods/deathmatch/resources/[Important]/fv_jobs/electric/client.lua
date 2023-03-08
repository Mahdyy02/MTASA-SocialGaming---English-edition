if fileExists("electric/client.lua") then 
    fileDelete("electric/client.lua")
end

----------------------------------
local txd = engineLoadTXD("electric/car.txd");
engineImportTXD(txd,552);
local dff = engineLoadDFF("electric/car.dff");
engineReplaceModel(dff, 552);
----------------------------------
local repair = false;
local cursorX,cursorY = 0,0;
local colors = {
    {200,20,20},
    {200,20,200},
    {20,200,200},
    {20,200,20},
    {200,200,20},
    {50,50,50},
}
local colors2 = {
    {200,20,200},
    {200,200,20},
    {20,200,20},
    {20,200,200},
    {200,20,20},
    {50,50,50},
}
local lX,lY = 0,0;
local lineColor = {};
local lines = {};
local showBox = false;

local electricVehMarker = {};
local electricMarkerTick = 0;

local electricBoxes = {
    {1938.6524658203, -1923.1519775391, 13.546875},
    {1915.7850341797, -1923.0028076172, 13.546875},
    {1891.7631835938, -1922.8560791016, 13.546875},
    {1844.900390625, -1922.8385009766, 13.546875},
    {1904.6318359375, -1946.3000488281, 13.546875},
    {1929.3774414063, -1946.3511962891, 13.554269790649},
    {1915.1342773438, -1979.4816894531, 13.546875},
    {1922.5789794922, -2022.4273681641, 13.546875},
    {1923.8446044922, -2041.5599365234, 13.546875},
    {1894.0141601563, -2042.5194091797, 13.539081573486},
    {1893.8370361328, -2013.4971923828, 13.546875},
    {1874.1938476563, -2012.9011230469, 13.546875},
    {1872.6614990234, -2042.1351318359, 13.546875},
    {1834.5198974609, -2042.5428466797, 13.546875},
    {1832.5565185547, -2013.8739013672, 13.546875},
    {1813.5754394531, -2012.8403320313, 13.546875},
    {1770.7873535156, -2102.9963378906, 13.546875},
    {1788.1917724609, -2122.9006347656, 13.546875},
    {1758.1335449219, -2122.2553710938, 13.554349899292},
    {1709.5173339844, -2122.0639648438, 13.546875},
    {1677.1722412109, -2117.8752441406, 13.546875},
    {2157.0524902344, -1291.5126953125, 23.9765625},
    {2121.6379394531, -1289.3752441406, 25.499334335327},
    {2082.1977539063, -1291.3063964844, 23.97047996521},
    {2057.0571289063, -1270.3354492188, 23.984375},
    {2081.3913574219, -1251.2770996094, 23.979652404785},
    {2082.3293457031, -1230.5329589844, 23.9765625},
    {2133.4250488281, -1230.6138916016, 23.9765625},
    {2164.3515625, -1230.4337158203, 23.9765625},
    {2185.3215332031, -1211.8106689453, 23.967796325684},
    {2250.8393554688, -1211.4768066406, 23.96875},
    {2461.8395996094, -1246.9539794922, 24.233585357666},
    {2500.7807617188, -1246.8994140625, 34.792514801025},
    {2584.8784179688, -1245.4255371094, 46.546886444092},
    {2607.1215820313, -1057.4691162109, 69.57299041748},
    {2579.40234375, -1058.4334716797, 69.582359313965},
    {2533.3459472656, -1037.7683105469, 69.578125},
    {2513.4682617188, -1057.6848144531, 69.552383422852},
    {2490.3166503906, -1054.3308105469, 68.26139831543},
}
local oldRandom = -1;
local currentMarker = {};
local moveType = "left"
local spacer = 0
local blurShader,blurTec = false,false;
local screen = false;

addEventHandler("onClientResourceStart",resourceRoot,function()
    if getElementData(localPlayer,"char >> job") == 3 then 
        startElectric();
    end
    blurShader, blurTec = dxCreateShader("electric/shader.fx")
end);
addEventHandler("onClientElementDataChange",localPlayer,function(dataName,oldValue,newValue)
    if dataName == "char >> job" then 
        if newValue == 3 then 
            startElectric();
        else 
            stopElectric();
        end
    end
end);

function startElectric()
    local sColor = {exports.fv_engine:getServerColor("servercolor",false)};
    electricVehMarker[1] = createMarker(1666.1447753906, -1892.3637695313, 13.546875,"checkpoint",2,sColor[1],sColor[2],sColor[3],100);
    electricVehMarker[2] = createBlip(1666.1447753906, -1892.3637695313, 13.546875,3);
    setElementData(electricVehMarker[2],"blip >> name","Munkahely");
    setElementData(electricVehMarker[2],"blip >> maxVisible",true);
    addEventHandler("onClientMarkerHit",electricVehMarker[1],function(hitElement)
        if hitElement == localPlayer then 
            if not getElementData(localPlayer,"network") then return end;

            local veh = getPedOccupiedVehicle(localPlayer);
            if electricMarkerTick+(1000*60) > getTickCount() then outputChatBox(exports.fv_engine:getServerSyntax("Electrician","red").."You can only use it every 1 minute!",255,255,255,true) return end;
            if veh then 
                if veh == getElementData(localPlayer,"job.veh") then 
                    triggerServerEvent("electric.removeVeh",localPlayer,localPlayer);
                    for k,v in pairs(currentMarker) do 
                        if isElement(v) then 
                            destroyElement(v);
                        end
                    end
                    dockMarkerTick = getTickCount();
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Electrician","red").."This is not your work vehicle!",255,255,255,true);
                    return;
                end
            else 
                if getElementData(localPlayer,"job.veh") then outputChatBox(exports.fv_engine:getServerSyntax("Electrician","red").."You already have a work vehicle!",255,255,255,true) return end;
                triggerServerEvent("electric.giveVeh",localPlayer,localPlayer);
                electricNextPoint();
                electricMarkerTick = getTickCount();
            end
        end
    end);
end

function stopElectric()
    for k,v in pairs(currentMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    lX,lY = 0,0;
    lineColor = {};
    lines = {};
    tableRand(colors);
    tableRand(colors2);
    removeEventHandler("onClientRender",root,repairDraw);
    showBox = false;
    for k,v in pairs(electricVehMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
end

function electricNextPoint()
    for k,v in pairs(currentMarker) do 
        if isElement(v) then 
            destroyElement(v);
        end
    end
    lX,lY = 0,0;
    lineColor = {};
    lines = {};
    tableRand(colors);
    tableRand(colors2);
    removeEventHandler("onClientRender",root,repairDraw);
    showBox = false;
    local rand = math.random(1,#electricBoxes);
    if oldRandom > 0 then 
        while oldRandom == rand do 
            rand = math.random(1,#electricBoxes);
        end
    end
    local x,y,z = unpack(electricBoxes[rand]);
    local r,g,b = exports.fv_engine:getServerColor("red",false);
    currentMarker[1] = createMarker(x,y,z,"checkpoint",1.5,r,g,b,100);
    currentMarker[2] = createBlip(x,y,z,1);
    setElementData(currentMarker[2],"blip >> color",{r,g,b});
    setElementData(currentMarker[2],"blip >> name","Célpont");
    setElementData(currentMarker[2],"blip >> maxVisible",true);
    oldRandom = rand;
    addEventHandler("onClientMarkerHit",currentMarker[1],function(hitElement)
        if hitElement == localPlayer then 
            if not getElementData(localPlayer,"network") then return end;

            if isPedInVehicle(localPlayer) then outputChatBox(exports.fv_engine:getServerSyntax("Electrician","red").."You can't do the job from a car!",255,255,255,true) return end;
            setElementFrozen(localPlayer,true);
            showBox = true;
            addEventHandler("onClientRender",root,repairDraw);
        end
    end);   
end


function repairDraw()
    if not getElementData(localPlayer,"network") then return end;

    if isCursorShowing() then 
        cursorX,cursorY = getCursorPosition();
        cursorX,cursorY = cursorX*sx,cursorY*sy;
    end

    local sColor = {exports.fv_engine:getServerColor("servercolor",false)};

    dxDrawImage(sx/2-256,sy/2-256,512,512,"electric/box.png");
    exports.fv_engine:shadowedText("Connect the cables",0,sy/2-185,sx+70,0,tocolor(255,255,255),1,exports.fv_engine:getFont("rage",13),"center");

    for k,v in pairs(colors) do 
        local r,g,b = unpack(v);
        dxDrawRectangle(sx/2-93+(k*32),sy/2+37,24,24,tocolor(r,g,b));
    end
    for k,v in pairs(colors2) do 
        local r,g,b = unpack(v);
        dxDrawRectangle(sx/2-60+(k*23),sy/2-75,20,20,tocolor(r,g,b));
    end

    if lX > 0 and lY > 0 then 
        dxDrawLine(lX,lY,cursorX,cursorY,tocolor(lineColor[1],lineColor[2],lineColor[3]),5);
    end

    if #lines > 0 then 
        for k,v in pairs(lines) do 
            local x,y,x2,y2,color = unpack(v);
            dxDrawLine(x,y,x2,y2,tocolor(color[1],color[2],color[3]),5);
        end
    end
end

addEventHandler("onClientClick",root,function(button,state,x,y)
    if not getElementData(localPlayer,"network") then return end;

if showBox then 
    if button == "left" then 
        if state == "down" then 
            for k,v in pairs(colors) do 
                local r,g,b = unpack(v);
                if exports.fv_engine:isInSlot(sx/2-93+(k*32),sy/2+37,24,24) then 
                    if usedColor({r,g,b}) then outputChatBox(exports.fv_engine:getServerSyntax("Electrician","red").."You have already connected this cable!",255,255,255,true) 
                        return;
                    else 
                        lX,lY = x,y;
                        lineColor = {r,g,b};
                    end
                end
            end
        else 
            for k,v in pairs(colors2) do 
                local r,g,b = unpack(v);
                if exports.fv_engine:isInSlot(sx/2-60+(k*23),sy/2-75,20,20) and not usedColor({r,g,b}) then 
                    if r == lineColor[1] and g == lineColor[2] and b == lineColor[3] then 
                        lines[#lines + 1] = {lX,lY,x,y,lineColor};
                        if #lines == 6 then 
                            lines = {};
                            tableRand(colors);
                            tableRand(colors2);
                            local rand = math.random(300,400);
                            -- setElementData(localPlayer,"char >> money",getElementData(localPlayer,"char >> money") + rand);
                            triggerServerEvent("ac.elementData",localPlayer,localPlayer,"char >> money",getElementData(localPlayer,"char >> money") + rand);
                            outputChatBox(exports.fv_engine:getServerSyntax("Electrician","servercolor").."You have successfully installed the electrical network. Payment: "..exports.fv_engine:getServerColor("servercolor",true)..rand.."#FFFFFF dt",255,255,255,true);
                            removeEventHandler("onClientRender",root,repairDraw);
                            setElementFrozen(localPlayer,false);
                            for k,v in pairs(currentMarker) do 
                                if isElement(v) then 
                                    destroyElement(v);
                                end
                            end
                            electricNextPoint();
                            outputChatBox(exports.fv_engine:getServerSyntax("Electrician","servercolor").."Go to the next place. "..exports.fv_engine:getServerColor("red",true).."(Piros jelölés)#FFFFFF.",255,255,255,true);
                        end
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Electrician","red").."You connected the cables incorrectly, so the power shook!",255,255,255,true);
                        addEventHandler("onClientRender",root,electricEffectRender);
                        screen = dxCreateScreenSource(sx, sy);
                        setTimer(function()
                            removeEventHandler("onClientRender",root,electricEffectRender);
                        end,3000,1);
                        setElementHealth(localPlayer,getElementHealth(localPlayer)-math.random(1,10));
                    end
                    break;
                end
            end
            lX,lY = 0,0;
            lineColor = {};
        end
    end
end
end);

function electricEffectRender()
    if blurShader then
        dxUpdateScreenSource(screen)
                
        dxSetShaderValue(blurShader, "ScreenSource", screen)
        dxSetShaderValue(blurShader, "BlurStrength", 25)
        dxSetShaderValue(blurShader, "UVSize", sx, sy)

        dxDrawImage(0, 0, sx, sy, blurShader)
    end

    dxUpdateScreenSource(screen, true)

    if screen then
        if spacer == -50 and moveType == "left" then
            moveType = "right"
        elseif spacer == 0 and moveType == "right" then
            moveType = "left"
        end
        
        if moveType == "left" then
            spacer = spacer - 0.5
        elseif moveType == "right" then
            spacer = spacer + 0.5
        end

        dxDrawImage(spacer, -25, sx + 50, sy + 50, screen)
    end
end


function usedColor(color)
    local found = false;
    for k,v in pairs(lines) do 
        if color[1] == v[5][1] and color[2] == v[5][2] and color[3] == v[5][3] then 
            found = true;
            break;
        end
    end
    return found;
end
function tableRand(tbl)
    local size = #tbl
    for i = size, 1, -1 do
        local rand = math.random(size)
        tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end
tableRand(colors);
tableRand(colors2);