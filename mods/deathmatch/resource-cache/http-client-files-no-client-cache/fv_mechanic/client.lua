e = exports.fv_engine;
local sx,sy = guiGetScreenSize();
local colPos = {
    {2278.0061035156, -1997.0285644531, 13.593503952026}, --1 BOX
    --[[{1442.9039306641, 2330.513671875, 10.926562309265}, --2 BOX
    {2458.79296875, -2135.1086425781, 13.57656288147}, -- 3 BOX
    {1458.4744873047, 2330.9812011719, 10.910937309265}, -- 4BOX
    {1476.4809570313, 2329.9365234375, 10.91093730926}, -- 6BOX
    {1491.9320068359, 2331.1462402344, 10.910937309265},  -- 7 BOX 
    {1507.0811767578, 2331.052734375, 10.910937309265}, -- 8 BOX
    {1521.7596435547, 2331.1323242188, 10.910937309265}, -- 9 BOX
    {1537.7495117188, 2331.4406738281, 10.910937309265}, --]] -- 9 BOX
}
local isCol = false;
local componentList = {
    ["door_lf_dummy"] = {"Left front door",1,2},
    ["door_rf_dummy"] = {"Right front door",1,3},
    ["door_lr_dummy"] = {"Left rear door",1,4},
    ["door_rr_dummy"] = {"Right rear door",1,5},
    ["boot_dummy"] = {"Boot",1,1, 6},
    ["bonnet_dummy"] = {"Bonnet",1,0},
    ["windscreen_dummy"] = {"Windscreen",1,0},

    ["bump_front_dummy"] = {"Front Bumper",2,5},
    ["bump_rear_dummy"] = {"Rear bumper",2,6},

    ["wheel_lf_dummy"] = {"Left front wheel", 3, 1},
	["wheel_rf_dummy"] = {"Right front wheel", 3, 3},
	["wheel_lb_dummy"] = {"Left rear wheel", 3, 2},
	["wheel_rb_dummy"] = {"Right rear wheel", 3, 4},
}
local clickTick = 0;
local bugMarker = false;
local repairMarker = false;
local compSave = {};
local loading = {0,"Equipment",false,false,false,false};

--Cache Tables--
local cols = {};
local colVehicles = {};
local carryVehicles = {};
----------------

addEventHandler("onClientResourceStart",root,function(res)
    if getResourceName(res) == "fv_engine" or getThisResource() then 
        e = exports.fv_engine;
        font = exports.fv_engine:getFont("rage", 13);
        font2 = exports.fv_engine:getFont("rage", 15);
        sColor = {exports.fv_engine:getServerColor("servercolor",false)};
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
    end 

    if getThisResource() == res then 

        setControl(true);

        compSave = false;

        setElementData(localPlayer,"mechanic.hand",false);
        setElementData(localPlayer,"mechanic.comp",false);
        setElementData(localPlayer,"isMechanicCol",false);

        for k,v in pairs(colPos) do 
            local x,y,z = unpack(v);
            local col = createColSphere(x,y,z,4.5);
            setElementData(col,"mechanic.col",true);
            cols[col] = true;

            addEventHandler("onClientColShapeHit",col,function(hitElement,dim)
                if hitElement == localPlayer and dim then 
                    if not isCol then 
                        if getElementData(localPlayer,"duty.faction") == 56 then --Csak ha dutyba van!
                            isCol = source;
                            colVehicles = {};
                            for k,v in pairs(getElementsByType("vehicle",_,true)) do 
                                if isElementWithinColShape(v,col) then 
                                    colVehicles[v] = true;
                                end
                            end
                            setElementData(localPlayer,"isMechanicCol",true);
                        end
                    end
                end 
                if getElementType(hitElement) == "vehicle" then 
                    if not colVehicles[hitElement] then 
                        colVehicles[hitElement] = true;
                    end
                end
            end);
            addEventHandler("onClientColShapeLeave",col,function(hitElement,dim)
                if hitElement == localPlayer and dim then 
                    if isCol then 
                        isCol = false;
                        colVehicles = {};
                        setElementData(localPlayer,"isMechanicCol",false);
                    end
                end
            end);
        end

        --[[local r,g,b = exports.fv_engine:getServerColor("red",false);
        bugMarker = createMarker(2438.2924804688, -2141.5717773438, 12.546875,"cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",bugMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                local carry = getElementData(localPlayer,"mechanic.hand");
                if carry then 
                    triggerServerEvent("mechanic.deleteHand",localPlayer,localPlayer);
                    setControl(true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have successfully deleted the part.",255,255,255,true);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."you have no part in your hands.",255,255,255,true);
                end
            end
        end);


        r,g,b = exports.fv_engine:getServerColor("blue",false);
        repairMarker = createMarker(1434.0979003906, 2329.5246582031, 9.9203119277954, "cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",repairMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                if getElementData(localPlayer,"mechanic.hand") then 
                    local carry = getElementData(localPlayer,"mechanic.hand");
                    if getElementData(carry,"mechanic.repaired") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."This part has already been repaired!",255,255,255,true);
                        return;
                    end
                    fixVehicle(carry);
                    setElementData(carry,"mechanic.repaired",true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."The part was successfully repaired.",255,255,255,true);
                else 
                    if compSave and #compSave > 0 then 
                        triggerServerEvent("mechanic.down",localPlayer,localPlayer,compSave[1],compSave[2],compSave[3],compSave[4],true);
                        setControl(false);
                        compSave = {};
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have no parts in your hand.",255,255,255,true);
                    end
                end
            end
        end);
 		local r,g,b = exports.fv_engine:getServerColor("red",false);
        bugMarker = createMarker(2447.2868652344, -2141.6169433594, 12.546875,"cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",bugMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                local carry = getElementData(localPlayer,"mechanic.hand");
                if carry then 
                    triggerServerEvent("mechanic.deleteHand",localPlayer,localPlayer);
                    setControl(true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have successfully deleted the part.",255,255,255,true);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."you have no part in your hands.",255,255,255,true);
                end
            end
        end);


        r,g,b = exports.fv_engine:getServerColor("blue",false);
        repairMarker = createMarker(1449.6369628906, 2329.1171875, 9.8203125, "cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",repairMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                if getElementData(localPlayer,"mechanic.hand") then 
                    local carry = getElementData(localPlayer,"mechanic.hand");
                    if getElementData(carry,"mechanic.repaired") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."This part has already been repaired!",255,255,255,true);
                        return;
                    end
                    fixVehicle(carry);
                    setElementData(carry,"mechanic.repaired",true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."The part was successfully repaired.",255,255,255,true);
                else 
                    if compSave and #compSave > 0 then 
                        triggerServerEvent("mechanic.down",localPlayer,localPlayer,compSave[1],compSave[2],compSave[3],compSave[4],true);
                        setControl(false);
                        compSave = {};
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have no parts in your hand.",255,255,255,true);
                    end
                end
            end
        end);
         local r,g,b = exports.fv_engine:getServerColor("red",false);
        bugMarker = createMarker(2455.68359375, -2141.8024902344, 12.546875,"cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",bugMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                local carry = getElementData(localPlayer,"mechanic.hand");
                if carry then 
                    triggerServerEvent("mechanic.deleteHand",localPlayer,localPlayer);
                    setControl(true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have successfully deleted the part.",255,255,255,true);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."you have no part in your hands.",255,255,255,true);
                end
            end
        end);


        r,g,b = exports.fv_engine:getServerColor("blue",false);
        repairMarker = createMarker(1464.5437011719, 2329.3278808594, 9.9203119277954, "cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",repairMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                if getElementData(localPlayer,"mechanic.hand") then 
                    local carry = getElementData(localPlayer,"mechanic.hand");
                    if getElementData(carry,"mechanic.repaired") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."This part has already been repaired!",255,255,255,true);
                        return;
                    end
                    fixVehicle(carry);
                    setElementData(carry,"mechanic.repaired",true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."The part was successfully repaired.",255,255,255,true);
                else 
                    if compSave and #compSave > 0 then 
                        triggerServerEvent("mechanic.down",localPlayer,localPlayer,compSave[1],compSave[2],compSave[3],compSave[4],true);
                        setControl(false);
                        compSave = {};
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have no parts in your hand.",255,255,255,true);
                    end
                end
            end
        end);
         local r,g,b = exports.fv_engine:getServerColor("red",false);
        bugMarker = createMarker(2464.3840332031, -2141.7868652344, 12.546875,"cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",bugMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                local carry = getElementData(localPlayer,"mechanic.hand");
                if carry then 
                    triggerServerEvent("mechanic.deleteHand",localPlayer,localPlayer);
                    setControl(true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have successfully deleted the part.",255,255,255,true);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."you have no part in your hands.",255,255,255,true);
                end
            end
        end);


        r,g,b = exports.fv_engine:getServerColor("blue",false);
        repairMarker = createMarker(1481.5460205078, 2329.5600585938, 9.9203119277954, "cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",repairMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                if getElementData(localPlayer,"mechanic.hand") then 
                    local carry = getElementData(localPlayer,"mechanic.hand");
                    if getElementData(carry,"mechanic.repaired") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."This part has already been repaired!",255,255,255,true);
                        return;
                    end
                    fixVehicle(carry);
                    setElementData(carry,"mechanic.repaired",true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."The part was successfully repaired.",255,255,255,true);
                else 
                    if compSave and #compSave > 0 then 
                        triggerServerEvent("mechanic.down",localPlayer,localPlayer,compSave[1],compSave[2],compSave[3],compSave[4],true);
                        setControl(false);
                        compSave = {};
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have no parts in your hand.",255,255,255,true);
                    end
                end
            end
        end);
         local r,g,b = exports.fv_engine:getServerColor("red",false);
        bugMarker = createMarker(2471.3464355469, -2141.8837890625, 12.546875,"cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",bugMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                local carry = getElementData(localPlayer,"mechanic.hand");
                if carry then 
                    triggerServerEvent("mechanic.deleteHand",localPlayer,localPlayer);
                    setControl(true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have successfully deleted the part.",255,255,255,true);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."you have no part in your hands.",255,255,255,true);
                end
            end
        end);


        r,g,b = exports.fv_engine:getServerColor("blue",false);
        repairMarker = createMarker(1498.6536865234, 2329.357421875, 9.9203119277954, "cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",repairMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                if getElementData(localPlayer,"mechanic.hand") then 
                    local carry = getElementData(localPlayer,"mechanic.hand");
                    if getElementData(carry,"mechanic.repaired") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."This part has already been repaired!",255,255,255,true);
                        return;
                    end
                    fixVehicle(carry);
                    setElementData(carry,"mechanic.repaired",true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."The part was successfully repaired.",255,255,255,true);
                else 
                    if compSave and #compSave > 0 then 
                        triggerServerEvent("mechanic.down",localPlayer,localPlayer,compSave[1],compSave[2],compSave[3],compSave[4],true);
                        setControl(false);
                        compSave = {};
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have no parts in your hand.",255,255,255,true);
                    end
                end
            end
        end);
         local r,g,b = exports.fv_engine:getServerColor("red",false);
        bugMarker = createMarker(2479.4340820313, -2141.7482910156, 12.546875,"cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",bugMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                local carry = getElementData(localPlayer,"mechanic.hand");
                if carry then 
                    triggerServerEvent("mechanic.deleteHand",localPlayer,localPlayer);
                    setControl(true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have successfully deleted the part.",255,255,255,true);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."you have no part in your hands.",255,255,255,true);
                end
            end
        end);


        r,g,b = exports.fv_engine:getServerColor("blue",false);
        repairMarker = createMarker(1513.1010742188, 2329.2473144531, 9.9203119277954, "cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",repairMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                if getElementData(localPlayer,"mechanic.hand") then 
                    local carry = getElementData(localPlayer,"mechanic.hand");
                    if getElementData(carry,"mechanic.repaired") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."This part has already been repaired!",255,255,255,true);
                        return;
                    end
                    fixVehicle(carry);
                    setElementData(carry,"mechanic.repaired",true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."The part was successfully repaired.",255,255,255,true);
                else 
                    if compSave and #compSave > 0 then 
                        triggerServerEvent("mechanic.down",localPlayer,localPlayer,compSave[1],compSave[2],compSave[3],compSave[4],true);
                        setControl(false);
                        compSave = {};
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have no parts in your hand.",255,255,255,true);
                    end
                end
            end
        end);
         local r,g,b = exports.fv_engine:getServerColor("red",false);
        bugMarker = createMarker(1403.0385742188, 2355.4951171875, 9.9203119277954,"cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",bugMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                local carry = getElementData(localPlayer,"mechanic.hand");
                if carry then 
                    triggerServerEvent("mechanic.deleteHand",localPlayer,localPlayer);
                    setControl(true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have successfully deleted the part.",255,255,255,true);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."you have no part in your hands.",255,255,255,true);
                end
            end
        end);


        r,g,b = exports.fv_engine:getServerColor("blue",false);
        repairMarker = createMarker(1528.6590576172, 2328.9162597656, 9.6203117370605, "cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",repairMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                if getElementData(localPlayer,"mechanic.hand") then 
                    local carry = getElementData(localPlayer,"mechanic.hand");
                    if getElementData(carry,"mechanic.repaired") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."This part has already been repaired!",255,255,255,true);
                        return;
                    end
                    fixVehicle(carry);
                    setElementData(carry,"mechanic.repaired",true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."The part was successfully repaired.",255,255,255,true);
                else 
                    if compSave and #compSave > 0 then 
                        triggerServerEvent("mechanic.down",localPlayer,localPlayer,compSave[1],compSave[2],compSave[3],compSave[4],true);
                        setControl(false);
                        compSave = {};
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have no parts in your hand.",255,255,255,true);
                    end
                end
            end
        end);--]]
         local r,g,b = exports.fv_engine:getServerColor("red",false);
        bugMarker = createMarker(2262.0676269531, -2001.2131347656, 12.593503952026,"cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",bugMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                local carry = getElementData(localPlayer,"mechanic.hand");
                if carry then 
                    triggerServerEvent("mechanic.deleteHand",localPlayer,localPlayer);
                    setControl(true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have successfully deleted the part.",255,255,255,true);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."you have no part in your hands.",255,255,255,true);
                end
            end
        end);


        r,g,b = exports.fv_engine:getServerColor("blue",false);
        repairMarker = createMarker(2262.2077636719, -1998.1990966797, 12.593503952026, "cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",repairMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                if getElementData(localPlayer,"mechanic.hand") then 
                    local carry = getElementData(localPlayer,"mechanic.hand");
                    if getElementData(carry,"mechanic.repaired") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."This part has already been repaired!",255,255,255,true);
                        return;
                    end
                    fixVehicle(carry);
                    setElementData(carry,"mechanic.repaired",true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."The part was successfully repaired.",255,255,255,true);
                else 
                    if compSave and #compSave > 0 then 
                        triggerServerEvent("mechanic.down",localPlayer,localPlayer,compSave[1],compSave[2],compSave[3],compSave[4],true);
                        setControl(false);
                        compSave = {};
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have no parts in your hand.",255,255,255,true);
                    end
                end
            end
        end);
         local r,g,b = exports.fv_engine:getServerColor("red",false);
        bugMarker = createMarker(2262.2124023438, -1995.2097167969, 12.587186813354,"cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",bugMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                local carry = getElementData(localPlayer,"mechanic.hand");
                if carry then 
                    triggerServerEvent("mechanic.deleteHand",localPlayer,localPlayer);
                    setControl(true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have successfully deleted the part.",255,255,255,true);
                else 
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."you have no part in your hands.",255,255,255,true);
                end
            end
        end);


        r,g,b = exports.fv_engine:getServerColor("blue",false);
        repairMarker = createMarker(2261.7497558594, -2003.9202880859, 12.587186813354, "cylinder",2,r,g,b,150);
        addEventHandler("onClientMarkerHit",repairMarker,function(hitElement,dim)
            if hitElement == localPlayer and dim and not isPedInVehicle(localPlayer) then 
                if getElementData(localPlayer,"mechanic.hand") then 
                    local carry = getElementData(localPlayer,"mechanic.hand");
                    if getElementData(carry,"mechanic.repaired") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."This part has already been repaired!",255,255,255,true);
                        return;
                    end
                    fixVehicle(carry);
                    setElementData(carry,"mechanic.repaired",true);
                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."The part was successfully repaired.",255,255,255,true);
                else 
                    if compSave and #compSave > 0 then 
                        triggerServerEvent("mechanic.down",localPlayer,localPlayer,compSave[1],compSave[2],compSave[3],compSave[4],true);
                        setControl(false);
                        compSave = {};
                    else 
                        outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have no parts in your hand.",255,255,255,true);
                    end
                end
            end
        end);
    end
end);

addEventHandler("onClientRender",root,function()
if not getElementData(localPlayer,"network") then return end;
    if isCol and not isPedInVehicle(localPlayer) then 
        for vehicle,valid in pairs(colVehicles) do 
            if isElement(vehicle) and not carryVehicles[vehicle] and isElementWithinColShape(vehicle,isCol) then 
                local count = 0;
                for k,v in pairs(componentList) do 
                    if validComponent(vehicle,k) then 
                        local wx,wy,wz = getVehicleComponentPosition(vehicle,k,"world");
                        local damaged = false;

                        if v[2] == 1 then --Ajtók
                            if getVehicleDoorState(vehicle,v[3]) > 0 then 
                                damaged = true;
                            end
                        end

                        if v[2] == 2 then --Panelek
                            if getVehiclePanelState(vehicle,v[3]) ~= 0 then 
                                damaged = true;
                            end
                        end

                        if v[2] == 3 then --Kerekek
                            local wheels = {getVehicleWheelStates(vehicle)};
                            if wheels[v[3]] ~= 0 then 
                                damaged = true;
                            end
                        end

                        if damaged then 
                            if wx and wy and wz then 
                                local x,y = getScreenFromWorldPosition(wx,wy,wz);
                                if x and y then 
                                    local w = dxGetTextWidth(v[1],1,font,false)+20;
                                    local color = tocolor(255,255,255);
                                    if exports.fv_engine:isInSlot(x-w/2,y-5,w,30) then 
                                        color = tocolor(sColor[1],sColor[2],sColor[3]);
                                        if getKeyState("mouse1") and clickTick+1500 < getTickCount() then 
                                            local carry = getElementData(localPlayer,"mechanic.hand");
                                            if not getVehicleComponentVisible(vehicle,k) then --Felszerelés
                                                if not carry then 
                                                    compSave = {vehicle,k,v[2],v[3]};
                                                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."No parts in your hand, go to "..sColor2.."green#FFFFFF market to pick up the part",255,255,255,true);
                                                    clickTick = getTickCount();
                                                    return;
                                                end
                                                if getElementData(carry,"mechanic.comp") ~= k then 
                                                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You have the wrong part in your hand!",255,255,255,true);
                                                    clickTick = getTickCount();
                                                    return;
                                                end
                                                if not getElementData(carry,"mechanic.repaired") then 
                                                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."Only repaired parts can be installed!",255,255,255,true);
                                                    clickTick = getTickCount();
                                                    return;
                                                end
                                                setControl(false);
                                                triggerServerEvent("mechanic.applyAnimation", localPlayer, localPlayer, "BOMBER", "BOM_Plant_Loop", -1, true, false, false);
                                                setElementFrozen(localPlayer,true);
                                                loading = {};
                                                loading = {
                                                    [1] = -1,
                                                    [2] = "Equipment",
                                                    [3] = vehicle,
                                                    [4] = k,
                                                    [5] = v[2],
                                                    [6] = v[3],
                                                    [7] = 1,
                                                }
                                                removeEventHandler("onClientPreRender",root,loadingRender);
                                                addEventHandler("onClientPreRender",root,loadingRender);
                                            else --Leszerelés
                                                if carry then 
                                                    outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","red").."You already have a part in your hand!",255,255,255,true);
                                                    clickTick = getTickCount();
                                                    return;
                                                end
                                                setControl(false);
                                                triggerServerEvent("mechanic.applyAnimation", localPlayer, localPlayer, "BOMBER", "BOM_Plant_Loop", -1, true, false, false);
                                                setElementFrozen(localPlayer,true);
                                                loading = {};
                                                loading = {
                                                    [1] = -1,
                                                    [2] = "Disarmament",
                                                    [3] = vehicle,
                                                    [4] = k,
                                                    [5] = v[2],
                                                    [6] = v[3],
                                                    [7] = false;
                                                }
                                                removeEventHandler("onClientPreRender",root,loadingRender);
                                                addEventHandler("onClientPreRender",root,loadingRender);
                                                --triggerServerEvent("mechanic.down",localPlayer,localPlayer,vehicle,k,v[2],v[3]);
                                            end
                                            clickTick = getTickCount();
                                        end
                                    end
                                    exports.fv_engine:roundedRectangle(x-w/2,y-5,w,30,tocolor(0,0,0,180));
                                    dxDrawText(v[1],x,y,x,y,color,1,font,"center","top");
                                end
                            end
                            count = count + 1;
                        end
                    end
                end

                local light = getVehLight(vehicle);
                local hp = getElementHealth(vehicle);

                if hp < 999 or light then 

                    dxDrawRectangle(sx-200,sy/2-50,200,100,tocolor(0,0,0,180));
                    dxDrawRectangle(sx-203,sy/2-50,3,100,tocolor(sColor[1],sColor[2],sColor[3],180));

                    if hp < 999 then 
                        local engineColor = tocolor(sColor[1],sColor[2],sColor[3],180);
                        if e:isInSlot(sx-195,sy/2-40,190,30) then 
                            engineColor = tocolor(sColor[1],sColor[2],sColor[3]);
                            if getKeyState("mouse1") and clickTick+1500 < getTickCount() then 
                                --if count == 0 then 
                                    if getElementHealth(vehicle) < 999 then 
                                        setControl(false);
                                        triggerServerEvent("mechanic.applyAnimation", localPlayer, localPlayer, "BOMBER", "BOM_Plant_Loop", -1, true, false, false);
                                        setElementFrozen(localPlayer,true);
                                        loading = {};
                                        loading = {
                                            [1] = -1,
                                            [2] = "Engine repair",
                                            [3] = vehicle,
                                            [4] = k,
                                            [5] = 5,
                                            [6] = 1,
                                            [7] = 2;
                                        }
                                        removeEventHandler("onClientPreRender",root,loadingRender);
                                        addEventHandler("onClientPreRender",root,loadingRender);
                                    else 
                                        outputChatBox(e:getServerSyntax("Mechanic","red").."No repair required.",255,255,255,true);
                                    end
                                --else 
                                    --outputChatBox(e:getServerSyntax("Mechanic","red").."Repair all parts first.",255,255,255,true);
                                --end
                                clickTick = getTickCount();
                            end
                        end
                        dxDrawRectangle(sx-195,sy/2-40,190,30,engineColor);
                        dxDrawText("Engine repair",sx-195,sy/2-40,sx-195+190,sy/2-40+30,tocolor(0,0,0),1,font,"center","center");
                    end

                    if light then 
                        local lightColor = tocolor(sColor[1],sColor[2],sColor[3],180);
                        if e:isInSlot(sx-195,sy/2+10,190,30) then 
                            lightColor = tocolor(sColor[1],sColor[2],sColor[3]);
                            if getKeyState("mouse1") and clickTick+1500 < getTickCount() then 
                                setControl(false);
                                triggerServerEvent("mechanic.applyAnimation", localPlayer, localPlayer, "BOMBER", "BOM_Plant_Loop", -1, true, false, false);
                                setElementFrozen(localPlayer,true);
                                loading = {};
                                loading = {
                                    [1] = -1,
                                    [2] = "Repair lamps",
                                    [3] = vehicle,
                                    [4] = k,
                                    [5] = 4,
                                    [6] = 1,
                                    [7] = 3;
                                }
                                removeEventHandler("onClientPreRender",root,loadingRender);
                                addEventHandler("onClientPreRender",root,loadingRender);
                                clickTick = getTickCount();
                            end
                        end
                        dxDrawRectangle(sx-195,sy/2+10,190,30,lightColor);
                        dxDrawText("Repair Lamp",sx-195,sy/2+10,sx-195+190,sy/2+10+30,tocolor(0,0,0),1,font,"center","center");
                    end

                end
                --[[local light = false;
                if count == 0 and not engine then 
                    local damaged = false;
                    for i=0,3 do 
                        if getVehicleLightState(vehicle,i) == 1 then
                            damaged = true;
                        end
                    end
                    light = damaged
                    if damaged then 
                        local wx,wy,wz = getElementPosition(vehicle);
                        local x,y = getScreenFromWorldPosition(wx,wy,wz);
                        if x and y then 
                            exports.fv_engine:roundedRectangle(x-50,y-100,100,30,tocolor(0,0,0,180));
                            local lightColor = tocolor(255,255,255);
                            if exports.fv_engine:isInSlot(x-50,y-100,100,30) then 
                                lightColor = tocolor(sColor[1],sColor[2],sColor[3]);
                                if getKeyState("mouse1") and clickTick+1500 < getTickCount() then 
                                    setControl(false);
                                    triggerServerEvent("mechanic.applyAnimation", localPlayer, localPlayer, "BOMBER", "BOM_Plant_Loop", -1, true, false, false);
                                    setElementFrozen(localPlayer,true);
                                    loading = {};
                                    loading = {
                                        [1] = -1,
                                        [2] = "Repair lamps",
                                        [3] = vehicle,
                                        [4] = k,
                                        [5] = 4,
                                        [6] = 1,
                                        [7] = 3;
                                    }
                                    removeEventHandler("onClientPreRender",root,loadingRender);
                                    addEventHandler("onClientPreRender",root,loadingRender);
                                    clickTick = getTickCount();
                                end
                            end
                            dxDrawText("Lámpák",x-50,y-100,x-50+100,y-100+30,lightColor,1,font,"center","center");
                        end
                    end
                end
                if not light and count == 0 and getElementHealth(vehicle) < 500 then 
                    local wx,wy,wz = getElementPosition(vehicle);
                    local x,y = getScreenFromWorldPosition(wx,wy,wz);
                    if x and y then 
                        exports.fv_engine:roundedRectangle(x-50,y-100,100,30,tocolor(0,0,0,180));
                        local engineColor = tocolor(255,255,255);
                        if exports.fv_engine:isInSlot(x-50,y-100,100,30) then 
                            engineColor = tocolor(sColor[1],sColor[2],sColor[3]);
                            if getKeyState("mouse1") and clickTick+1500 < getTickCount() then 
                                setControl(false);
                                triggerServerEvent("mechanic.applyAnimation", localPlayer, localPlayer, "BOMBER", "BOM_Plant_Loop", -1, true, false, false);
                                setElementFrozen(localPlayer,true);
                                loading = {};
                                loading = {
                                    [1] = -1,
                                    [2] = "Engine repair",
                                    [3] = vehicle,
                                    [4] = k,
                                    [5] = 5,
                                    [6] = 1,
                                    [7] = 2;
                                }
                                removeEventHandler("onClientPreRender",root,loadingRender);
                                addEventHandler("onClientPreRender",root,loadingRender);
                                clickTick = getTickCount();
                            end
                        end
                        dxDrawText("Motor",x-50,y-100,x-50+100,y-100+30,engineColor,1,font,"center","center");
                    end
                end]]
            --else 
                --colVehicles[vehicle] = false;
                break;
            end
        end
    end
end);

function loadingRender(dt)
    if loading[1] < 100 then 
        loading[1] = loading[1] + (dt*0.01);
    elseif loading[1] > 100 then 
        if not loading[7] then --leszerelés
            setVehicleComponentVisible(loading[3],loading[4],false);
            triggerServerEvent("mechanic.down",localPlayer,localPlayer,loading[3],loading[4],loading[5],loading[6]);
            setElementFrozen(localPlayer,false);
            setControl(false);
        elseif loading[7] == 1 then  --felszerelés
            setVehicleComponentVisible(loading[3],loading[4],true);
            fixComponent(loading[3],loading[4]);
            triggerServerEvent("mechanic.applyAnimation", localPlayer, localPlayer);
            triggerServerEvent("mechanic.deleteHand",localPlayer,localPlayer);
            setElementFrozen(localPlayer,false);
            setControl(true);
        elseif loading[7] == 2 then --motor javítása
            triggerServerEvent("mechanic.fixVehicle",localPlayer,localPlayer,loading[3]);
            triggerServerEvent("mechanic.applyAnimation", localPlayer, localPlayer);
            setElementFrozen(localPlayer,false);
            setControl(true);
        elseif loading[7] == 3 then 
            for i=0,3 do 
                setVehicleLightState(loading[3],i,0);
            end
            triggerServerEvent("mechanic.applyAnimation", localPlayer, localPlayer);
            setElementFrozen(localPlayer,false);
            setControl(true);
            outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."You have successfully repaired the lights!",255,255,255,true);
        end
        loading = {};
        removeEventHandler("onClientPreRender",root,loadingRender);
    end
    if loading[1] then
        exports.fv_engine:roundedRectangle(sx/2-205,sy-175,410,50,tocolor(0,0,0,180));
        dxDrawRectangle(sx/2-200,sy-170,loading[1]*4,40,tocolor(sColor[1],sColor[2],sColor[3],180));
        exports.fv_engine:shadowedText(loading[2],sx/2-200,sy-170,sx/2-200+400,sy-170+40,tocolor(255,255,255),1,font2,"center","center");
    end
end

addEvent("mechanic.handSync",true);
addEventHandler("mechanic.handSync",root,function(veh,component)
    if not carryVehicles[veh] then 
        carryVehicles[veh] = component;
    end
end);

addEventHandler("onClientPreRender",root,function() --Szinkronizáció
    for k,v in pairs(carryVehicles) do 
        if isElement(k) then 
            for component in pairs(getVehicleComponents(k)) do 
                if component ~= v then 
                    setVehicleComponentVisible(k,component,false);
                else 
                    setVehicleComponentVisible(k,component,true);
                end

                setElementCollisionsEnabled(k, false);
                setElementFrozen(k, true);
            end
        else 
            carryVehicles[k] = nil;
        end
    end
end);

addEventHandler("onClientVehicleStartEnter",root,function(player) --Nem tud beülni abba amit visz valaki
    if player == localPlayer then 
        if source and carryVehicles[source] then 
            cancelEvent();
        end
    end
end);   

function fixComponent(veh,comp)
    local name,type,helo = unpack(componentList[comp]);
    if type == 1 then 
        setVehicleDoorState(veh,helo,0);
    elseif type == 2 then 
        setVehiclePanelState(veh,helo,0);
    elseif type == 3 then 
        local wheels = {getVehicleWheelStates(veh)};
        wheels[helo] = nil;
        wheels[helo] = 0;
        setVehicleWheelStates(veh,unpack(wheels));
    end
end

function getVehLight(veh)
    local light = false;
    for i=0,3 do 
        if getVehicleLightState(veh,i) == 1 then
            light = true;
            break;
        end
    end
    return light;
end

--UTILS--
function validComponent(vehicle, component)
	for value in pairs(getVehicleComponents(vehicle)) do
		if value == component then
			return true
		end
	end

	return false
end
function setControl(state)
    toggleControl("accelerate",state);
    toggleControl("brake",state);
    toggleControl("enter_exit",state);
    toggleControl("sprint",state);
    toggleControl("jump",state);
    toggleControl("crouch",state);
    toggleControl("fire",state);
end