local oldMessage = exports["fv_engine"]:getServerData("name")
local maxLength = 120
local bubbleTimer = nil

local emojis = {
    [":)"] = {"smiles.", false},
    [":("] = {"sad.", false},
    [":D"] = {"name.", {"rapping", "laugh_01"}},
    ["xD"] = {"tears from laughter.", {"rapping", "laugh_01"}},
    [";)"] = {"wink.", false},
    [":O"] = {"is surprised.", false},
    ["O_O"] = {"is surprised.", false},
    ["O-O"] = {"is surprised.", false},
    [";("] = {"bursts into tears", {"GRAVEYARD", "mrnF_loop"}},
    [":'("] = {"bursts into tears", {"GRAVEYARD", "mrnF_loop"}},
}

local OOCCache = {}
local showOOC = true;

addEventHandler("onClientResourceStart",getRootElement(),function(res)
	if tostring(getResourceName(res)) == "fv_engine" or res == getThisResource() then 
        font = exports.fv_engine:getFont("Yantramanav-Regular", 11);
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
    end
end);

function createMessage(element, message, mtype)
    if element == localPlayer then
        onClientMessage(localPlayer, message, mtype)
    end
end
addEvent("createMessage", true)
addEventHandler("createMessage", root, createMessage)

function onClientMessage(element, message, mtype)
    if not getElementData(element, "loggedIn") then return end
    if element ~= localPlayer then return end

    if getElementData(localPlayer, "afk") then
        setElementData(localPlayer, "afk", false)
    end
    oldMessage = message
    if mtype ~= "ooc" then
        if isPedDead(localPlayer) then return end
        if getElementHealth(localPlayer) <= 1 then return end
        setElementData(localPlayer, "bubbleOn", true)
        if isTimer(bubbleTimer) then killTimer(bubbleTimer) end
        bubbleTimer = setTimer(
            function()
                setElementData(localPlayer, "bubbleOn", false)
            end, 8.5 * 1000, 1
        )
    end
    if mtype == 0 then
        local veh = getPedOccupiedVehicle(localPlayer)
        local isWindowableVeh = false
        if veh then
            if getVehicleType(veh) == "Automobile" or getVehicleType(veh) == "Monster Truck" then 
                isWindowableVeh = true;
            end
        end
        --outputChatBox("isWindowableVeh: " .. tostring(isWindowableVeh))
        --outputChatBox("VEH: " .. tostring(isElement(veh)))
        if veh and isWindowableVeh then
            --local message
            if string.len(message) > 1 then
                message = string.upper(string.sub(message, 1, 1)) .. string.sub(message, 2, string.len(message))
            elseif string.len(message) < 1 or string.len(message) == 0 then
                return
            elseif string.sub(message, 1, 1) == " " then
                return    
            elseif string.len(message) > maxLength then
                return
            else
                message = string.upper(string.sub(message, 1, 1))
            end
            
            for k,v in pairs(emojis) do
                --local message = string.upper(message)
                --local k = string.upper(k)
                if string.upper(message):find(string.upper(k), 1, true) then
                    onClientMessage(localPlayer, emojis[k][1], 1)
                    if emojis[k][2] then
                        if not getPedOccupiedVehicle(localPlayer) then 
                            setElementData(localPlayer, "animation", emojis[k][2])
                        end
                    end
                    return
                end
            end
            
            local name = exports['fv_admin']:getAdminName(element)
            if getElementData(veh, "veh:ablak") then
                outputChatBox(name.." says: "..message, 255,255,255)
            else
                outputChatBox(name.." says (In vehicle): "..message, 255,255,255)
            end

            local x,y,z = getElementPosition(localPlayer)
            for k,v in pairs(getElementsByType("player",_,true)) do
                if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                    local x1, y1, z1 = getElementPosition(v)
                    local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                    local veh2 = getPedOccupiedVehicle(v)
                    --outputChatBox("WINDOWSTATE: " .. tostring(getElementData(veh, "veh:ablak")))
                    if veh2 and veh == veh2 then
                        local r,g,b = 255,255,255
                        if getElementData(veh, "veh:ablak") then
                            triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." says: "..message, r,g,b)
                        else    
                            triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." says (In vehicle): "..message, r,g,b)
                        end    
                    elseif distance <= 8 and getElementData(veh, "veh:ablak") then
                        local r,g,b = 255,255,255
                        --outputChatBox(distance)
                        if distance <= 2 then
                            r,g,b = 255,255,255
                        elseif distance <= 4 then
                            r,g,b = 191, 191, 191 --75% white
                        elseif distance <= 6 then
                            r,g,b = 166, 166, 166 --65% white
                        elseif distance <= 8 then
                            r, g, b = 115, 115, 115 --45% white
                        else
                            r, g, b = 95, 95, 95 --?% white
                        end
                        
                        triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." says: "..message, r,g,b)
                    end
                end
            end
        else
            --local message
            if string.len(message) > 1 then
                message = string.upper(string.sub(message, 1, 1)) .. string.sub(message, 2, string.len(message))
            elseif string.len(message) < 1 or string.len(message) == 0 then
                return
            elseif string.sub(message, 1, 1) == " " then
                return    
            elseif string.len(message) > maxLength then
                return
            else
                message = string.upper(string.sub(message, 1, 1))
            end
            
            for k,v in pairs(emojis) do
                if string.upper(message):find(string.upper(k), 1, true) then
                    onClientMessage(localPlayer, emojis[k][1], 1)
                    if emojis[k][2] then
                        if not getPedOccupiedVehicle(localPlayer) then 
                            setElementData(localPlayer, "animation", emojis[k][2])
                        end
                    end
                    return
                end
            end
            
            local name = exports['fv_admin']:getAdminName(element)
            if getElementData(element, "admin >> duty") then
                local adminColor = exports.fv_admin:getAdminColor(element, level)
                insertOOC(adminColor.."(( "..name..": "..message.." ))")
            else
                outputChatBox(name.." says: "..message, 255,255,255)
            end
            
            local x,y,z = getElementPosition(localPlayer)
            for k,v in pairs(getElementsByType("player",_,true)) do
                if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                    local x1, y1, z1 = getElementPosition(v)
                    local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                    local veh2 = getPedOccupiedVehicle(v)
                    --outputChatBox("WINDOWSTATE: " .. tostring(getElementData(veh, "veh:ablak")))
                    local nowVeh = veh
                    if not nowVeh then
                        nowVeh = veh2
                    end
                    if distance <= 8 and not veh2 or distance <= 8 and veh2 and getElementData(nowVeh, "veh:ablak") then
                        local r,g,b = 255,255,255
                        if distance <= 2 then
                            r,g,b = 255,255,255
                        elseif distance <= 4 then
                            r,g,b = 191, 191, 191 --75% white
                        elseif distance <= 6 then
                            r,g,b = 166, 166, 166 --65% white
                        elseif distance <= 8 then
                            r, g, b = 115, 115, 115 --45% white
                        else
                            r, g, b = 95, 95, 95 --?% white
                        end
                        if getElementData(element, "admin >> duty") then
                            local adminColor = exports.fv_admin:getAdminColor(element, level)
                            triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, adminColor.."(( "..name..": "..message.." ))", r,g,b, false, true)
                        else
                            triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." says: "..message, r,g,b)
                        end
                    elseif veh2 and distance <= 4 and getElementData(veh2, "veh:ablak") then
                        local r,g,b = 255,255,255
                        if distance <= 2 then
                            r,g,b = 166, 166, 166 --65% white
                        elseif distance <= 4 then
                            r, g, b = 115, 115, 115 --45% white
                        else
                            r, g, b = 95, 95, 95 --?% white
                        end
                        if getElementData(element, "admin >> duty") then
                            local adminColor = exports.fv_admin:getAdminColor(element, level)
                            triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, adminColor.."(( "..name..": "..message.." ))", r,g,b, false, true)
                        else
                            triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." says: "..message, r,g,b)
                        end
                    end
                end
            end
        end
    elseif mtype == 1 then
        --local message
        if string.len(message) > 1 then
            message = string.sub(message, 1, 1) .. string.sub(message, 2, string.len(message))
        elseif string.len(message) < 1 or string.len(message) == 0 then
            local syntax = exports['fv_engine']:getServerSyntax(false, "error")
            outputChatBox(syntax .. " /me [i7ses]", 255,255,255,true)
            return
        elseif string.sub(message, 1, 1) == " " then
            return    
        elseif string.len(message) > maxLength then
            return
        else
            message = string.sub(message, 1, 1)
        end
        
        for k,v in pairs(emojis) do
            if string.upper(message):find(string.upper(k), 1, true) then
                --onClientMessage(localPlayer, emojis[k][1], 1)
                message = emojis[k][1]
                if emojis[k][2] then
                    if not getPedOccupiedVehicle(localPlayer) then 
                        setElementData(localPlayer, "animation", emojis[k][2])
                    end
                end
                return
            end
        end
        
        local name = exports['fv_admin']:getAdminName(element)
        outputChatBox(" ***"..name.." "..message, 194, 162, 218)

        local x,y,z = getElementPosition(localPlayer)
        for k,v in pairs(getElementsByType("player",_,true)) do
            if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                local x1, y1, z1 = getElementPosition(v)
                local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                local veh2 = getPedOccupiedVehicle(v)
                if distance <= 8 then
                    local r,g,b = 194, 162, 218
                    triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, " ***"..name.." "..message, r,g,b, false, false, nil, "me")
                end
            end
        end
    elseif mtype == "do" then
        --local message
        if string.len(message) > 1 then
            message = string.sub(message, 1, 1) .. string.sub(message, 2, string.len(message))
        elseif string.len(message) < 1 or string.len(message) == 0 then
            local syntax = exports['fv_engine']:getServerSyntax(false, "error")
            outputChatBox(syntax .. " /do [fe3l]", 255,255,255,true)
            return
        elseif string.sub(message, 1, 1) == " " then
            return    
        elseif string.len(message) > maxLength then
            return
        else
            message = string.sub(message, 1, 1)
        end
        
        for k,v in pairs(emojis) do
            if string.upper(message):find(string.upper(k), 1, true) then
                onClientMessage(localPlayer, emojis[k][1], 1)
                if emojis[k][2] then
                    if not getPedOccupiedVehicle(localPlayer) then 
                        setElementData(localPlayer, "animation", emojis[k][2])
                    end
                end
                return
            end
        end 
        
        local name = exports['fv_admin']:getAdminName(element)
        outputChatBox(" * "..message.." (("..name.."))", 255, 51, 102)
        
        local x,y,z = getElementPosition(localPlayer)
        for k,v in pairs(getElementsByType("player",_,true)) do
            if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                local x1, y1, z1 = getElementPosition(v)
                local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                local veh2 = getPedOccupiedVehicle(v)
                if distance <= 8 then
                    local r,g,b = 255, 51, 102
                    triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, " * "..message.." (("..name.."))", r,g,b, false, false, nil, "me")
                end
            end
        end    
    elseif mtype == "ame" then
        --local message
        if string.len(message) > 1 then
            message = string.sub(message, 1, 1) .. string.sub(message, 2, string.len(message))
        elseif string.len(message) < 1 or string.len(message) == 0 then
            local syntax = exports['fv_engine']:getServerSyntax(false, "error")
            outputChatBox(syntax .. " /ame [A visual description of your character]", 255,255,255,true)
            return
        elseif string.sub(message, 1, 1) == " " then
            return    
        elseif string.len(message) > maxLength then
            return
        else
            message = string.sub(message, 1, 1)
        end
        
        for k,v in pairs(emojis) do
            if string.upper(message):find(string.upper(k), 1, true) then
                onClientMessage(localPlayer, emojis[k][1], 1)
                if emojis[k][2] then
                    if not getPedOccupiedVehicle(localPlayer) then 
                        setElementData(localPlayer, "animation", emojis[k][2])
                    end
                end
                return
            end
        end
        
        local name = exports['fv_admin']:getAdminName(element)
        outputChatBox(" >> "..name.." "..message, 183, 146, 211)

        local x,y,z = getElementPosition(localPlayer)
        for k,v in pairs(getElementsByType("player",_,true)) do
            if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                local x1, y1, z1 = getElementPosition(v)
                local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                local veh2 = getPedOccupiedVehicle(v)
                if distance <= 8 then
                    local r,g,b = 183, 146, 211
                    triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, " >> "..name.." "..message, r,g,b)
                end
            end
        end
    elseif mtype == "shout" then
        local veh = getPedOccupiedVehicle(localPlayer)
        local isWindowableVeh = false
        if veh then
            isWindowableVeh = getElementData(veh,"veh:ablak") or true
        end
        if veh and isWindowableVeh then
            --local message
            if string.len(message) > 1 then
                message = string.upper(string.sub(message, 1, 1)) .. string.sub(message, 2, string.len(message))
            elseif string.len(message) < 1 or string.len(message) == 0 then
                local syntax = exports['fv_engine']:getServerSyntax(false, "error")
                outputChatBox(syntax .. " /s [Text]", 255,255,255,true)
                return
            elseif string.sub(message, 1, 1) == " " then
                return    
            elseif string.len(message) > maxLength then
                return
            else
                message = string.upper(string.sub(message, 1, 1))
            end
            
            for k,v in pairs(emojis) do
                --local message = string.upper(message)
                --local k = string.upper(k)
                if string.upper(message):find(string.upper(k), 1, true) then
                    onClientMessage(localPlayer, emojis[k][1], 1)
                    if emojis[k][2] then
                        if not getPedOccupiedVehicle(localPlayer) then 
                            setElementData(localPlayer, "animation", emojis[k][2])
                        end
                    end
                    return
                end
            end
            
            local name = exports['fv_admin']:getAdminName(element)
            if getElementData(veh, "veh:ablak") then
                outputChatBox(name.." shouts: "..message, 255,255,255)
            else
                outputChatBox(name.." shouts (In vehicle): "..message, 255,255,255)
            end
            
            local x,y,z = getElementPosition(localPlayer)
            for k,v in pairs(getElementsByType("player",_,true)) do
                if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                    local x1, y1, z1 = getElementPosition(v)
                    local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                    local veh2 = getPedOccupiedVehicle(v)
                    if veh2 and veh == veh2 then
                        local r,g,b = 255,255,255
                        if getElementData(veh, "veh:ablak") then
                            triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." shouts: "..message, r,g,b)
                        else
                            triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." shouts (In vehicle): "..message, r,g,b)
                        end
                    elseif distance <= 18 and getElementData(veh, "veh:ablak") then
                        local r,g,b = 255,255,255
                        --outputChatBox(distance)
                        if distance <= 4 then
                            r,g,b = 255,255,255
                        elseif distance <= 8 then
                            r,g,b = 191, 191, 191 --75% white
                        elseif distance <= 12 then
                            r,g,b = 166, 166, 166 --65% white
                        elseif distance <= 16 then
                            r, g, b = 115, 115, 115 --45% white
                        else
                            r, g, b = 95, 95, 95 --?% white
                        end
                        triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." shouts: "..message, r,g,b)
                    elseif distance <= 4 and getElementData(veh, "veh:ablak") then
                        local r,g,b = 255,255,255
                        --outputChatBox(distance)
                        if distance <= 2 then
                            r,g,b = 166, 166, 166
                        elseif distance <= 4 then
                            r,g,b = 115, 115, 115
                        end
                        triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." shouts (In vehicle): "..message, r,g,b)
                    end
                end
            end
        else
            --local message
            if string.len(message) > 1 then
                message = string.upper(string.sub(message, 1, 1)) .. string.sub(message, 2, string.len(message))
            elseif string.len(message) < 1 or string.len(message) == 0 then
                local syntax = exports['fv_engine']:getServerSyntax(false, "error")
                outputChatBox(syntax .. " /s [Text]", 255,255,255,true)
                return
            elseif string.sub(message, 1, 1) == " " then
                return    
            elseif string.len(message) > maxLength then
                return
            else
                message = string.upper(string.sub(message, 1, 1))
            end
            
            for k,v in pairs(emojis) do
                if string.upper(message):find(string.upper(k), 1, true) then
                    onClientMessage(localPlayer, emojis[k][1], 1)
                    if emojis[k][2] then
                        if not getPedOccupiedVehicle(localPlayer) then 
                            setElementData(localPlayer, "animation", emojis[k][2])
                        end
                    end
                    return
                end
            end
            
            setElementData(localPlayer, "animation", {"ON_LOOKERS","shout_01"})
            
            local name = exports['fv_admin']:getAdminName(element)
            outputChatBox(name.." shouts: "..message, 255,255,255)
            
            local x,y,z = getElementPosition(localPlayer)
            for k,v in pairs(getElementsByType("player",_,true)) do
                if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                    local x1, y1, z1 = getElementPosition(v)
                    local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                    local veh2 = getPedOccupiedVehicle(v)
                    if distance <= 18 and not veh2 or distance <= 18 and veh2 and getElementData(veh2, "veh:ablak") then
                        local r,g,b = 255,255,255
                        if distance <= 4 then
                            r,g,b = 255,255,255
                        elseif distance <= 8 then
                            r,g,b = 191, 191, 191 --75% white
                        elseif distance <= 12 then
                            r,g,b = 166, 166, 166 --65% white
                        elseif distance <= 16 then
                            r, g, b = 115, 115, 115 --45% white
                        else
                            r, g, b = 95, 95, 95 --?% white
                        end
                        triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." shouts: "..message, r,g,b)
                    elseif veh2 and distance <= 6 and getElementData(veh2, "veh:ablak") then
                        local r,g,b = 255,255,255
                        if distance <= 2 then
                            r,g,b = 191, 191, 191 --75% white
                        elseif distance <= 4 then
                            r,g,b = 166, 166, 166 --65% white
                        elseif distance <= 6 then
                            r, g, b = 115, 115, 115 --45% white
                        else
                            r, g, b = 95, 95, 95 --?% white
                        end
                        triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." shouts: "..message, r,g,b)
                    end
                end
            end
        end
    elseif mtype == "c" then
        local veh = getPedOccupiedVehicle(localPlayer)
        local isWindowableVeh = false
        if veh then
            isWindowableVeh = exports['fv_vehicle']:isWindowableVeh(getElementModel(veh))
        end
        if veh and isWindowableVeh then
            --local message
            if string.len(message) > 1 then
                message = string.upper(string.sub(message, 1, 1)) .. string.sub(message, 2, string.len(message))
            elseif string.len(message) < 1 or string.len(message) == 0 then
                local syntax = exports['fv_engine']:getServerSyntax(false, "error")
                outputChatBox(syntax .. " /c [Text]", 255,255,255,true)
                return
            elseif string.sub(message, 1, 1) == " " then
                return    
            elseif string.len(message) > maxLength then
                return
            else
                message = string.upper(string.sub(message, 1, 1))
            end
            
            for k,v in pairs(emojis) do
                --local message = string.upper(message)
                --local k = string.upper(k)
                if string.upper(message):find(string.upper(k), 1, true) then
                    onClientMessage(localPlayer, emojis[k][1], 1)
                    if emojis[k][2] then
                        if not getPedOccupiedVehicle(localPlayer) then     
                            setElementData(localPlayer, "animation", emojis[k][2])
                        end
                    end
                    return
                end
            end
            
            local name = exports['fv_admin']:getAdminName(element)
            if not getElementData(veh, "veh:ablak") then
                outputChatBox(name.." whispers: "..message, 255,255,255)
            else
                outputChatBox(name.." whispers (In vehicle): "..message, 255,255,255)
            end
            
            local x,y,z = getElementPosition(localPlayer)
            for k,v in pairs(getElementsByType("player",_,true)) do
                if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                    local x1, y1, z1 = getElementPosition(v)
                    local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                    local veh2 = getPedOccupiedVehicle(v)
                    if veh2 and veh == veh2 then
                        local r,g,b = 255,255,255
                        if not getElementData(veh, "veh:ablak") then
                            triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." whispers (In vehicle): "..message, r,g,b, true)
                        else
                            triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." whispers (In vehicle): "..message, r,g,b, true)
                        end
                    elseif distance <= 2 and not getElementData(veh, "veh:ablak") then
                        local r,g,b = 255,255,255
                        --outputChatBox(distance)
                        if distance <= 2 then
                            r,g,b = 255,255,255
                        end
                        triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." whispers: "..message, r,g,b, true)
                    end
                end
            end
        else
            --local message
            if string.len(message) > 1 then
                message = string.upper(string.sub(message, 1, 1)) .. string.sub(message, 2, string.len(message))
            elseif string.len(message) < 1 or string.len(message) == 0 then
                local syntax = exports['fv_engine']:getServerSyntax(false, "error")
                outputChatBox(syntax .. " /c [Text]", 255,255,255,true)
                return
            elseif string.sub(message, 1, 1) == " " then
                return    
            elseif string.len(message) > maxLength then
                return
            else
                message = string.upper(string.sub(message, 1, 1))
            end
            
            for k,v in pairs(emojis) do
                if string.upper(message):find(string.upper(k), 1, true) then
                    onClientMessage(localPlayer, emojis[k][1], 1)
                    if emojis[k][2] then
                        if not getPedOccupiedVehicle(localPlayer) then 
                            setElementData(localPlayer, "animation", emojis[k][2])
                        end
                    end
                    return
                end
            end
            
            local name = exports['fv_admin']:getAdminName(element)
            outputChatBox(name.." whispers: "..message, 255,255,255)

            local x,y,z = getElementPosition(localPlayer)
            for k,v in pairs(getElementsByType("player",_,true)) do
                if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                    local x1, y1, z1 = getElementPosition(v)
                    local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                    local veh2 = getPedOccupiedVehicle(v)
                    if distance <= 2 and not veh2 or distance <= 2 and veh2 and not getElementData(veh2, "veh:ablak") then
                        local r,g,b = 255,255,255
                        if distance <= 2 then
                            r,g,b = 255,255,255
                        end
                        triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, name.." whispers: "..message, r,g,b, true)
                    end
                end
            end
        end
    elseif mtype == "try2 >> success" then
        --local message
        if string.len(message) > 1 then
            message = string.sub(message, 1, 1) .. string.sub(message, 2, string.len(message))
        elseif string.len(message) < 1 or string.len(message) == 0 then
            local syntax = exports['fv_engine']:getServerSyntax(false, "error")
            outputChatBox(syntax .. " /try2 [Text]", 255,255,255,true)
            return
        elseif string.sub(message, 1, 1) == " " then
            return    
        elseif string.len(message) > maxLength then
            return
        else
            message = string.sub(message, 1, 1)
        end
        
        for k,v in pairs(emojis) do
            if string.upper(message):find(string.upper(k), 1, true) then
                --onClientMessage(localPlayer, emojis[k][1], 1)
                message = emojis[k][1]
                if emojis[k][2] then
                    if not getPedOccupiedVehicle(localPlayer) then 
                        setElementData(localPlayer, "animation", emojis[k][2])
                    end
                end
                return
            end
        end
        
        local name = exports['fv_admin']:getAdminName(element)
        outputChatBox(" ***"..name.." tries to "..message.." and he succeeds!", 71, 209, 71)

        local x,y,z = getElementPosition(localPlayer)
        for k,v in pairs(getElementsByType("player",_,true)) do
            if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                local x1, y1, z1 = getElementPosition(v)
                local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                local veh2 = getPedOccupiedVehicle(v)
                if distance <= 8 then
                    local r,g,b = 71, 209, 71
                    triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, " ***"..name.." tries to "..message.." and he succeeds!", r,g,b)
                end
            end
        end
    elseif mtype == "try2 >> failed" then
        --local message
        if string.len(message) > 1 then
            message = string.sub(message, 1, 1) .. string.sub(message, 2, string.len(message))
        elseif string.len(message) < 1 or string.len(message) == 0 then
            local syntax = exports['fv_engine']:getServerSyntax(false, "error")
            outputChatBox(syntax .. " /try2 [Text]", 255,255,255,true)
            return
        elseif string.sub(message, 1, 1) == " " then
            return    
        elseif string.len(message) > maxLength then
            return
        else
            message = string.sub(message, 1, 1)
        end
        
        for k,v in pairs(emojis) do
            if string.upper(message):find(string.upper(k), 1, true) then
                --onClientMessage(localPlayer, emojis[k][1], 1)
                message = emojis[k][1]
                if emojis[k][2] then
                    if not getPedOccupiedVehicle(localPlayer) then 
                        setElementData(localPlayer, "animation", emojis[k][2])
                    end
                end
                return
            end
        end
        
        local name = exports['fv_admin']:getAdminName(element)
        outputChatBox(" ***"..name.." tries to "..message..", but unfortunately he failed!", 255, 51, 51)

        local x,y,z = getElementPosition(localPlayer)
        for k,v in pairs(getElementsByType("player",_,true)) do
            if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                local x1, y1, z1 = getElementPosition(v)
                local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                local veh2 = getPedOccupiedVehicle(v)
                if distance <= 8 then
                    local r,g,b = 255, 51, 51
                    triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, " ***"..name.." tries to "..message.." but unfortunately he failed!", r,g,b)
                end
            end
        end    
    elseif mtype == "try >> success" then
        --local message
        if string.len(message) > 1 then
            message = string.sub(message, 1, 1) .. string.sub(message, 2, string.len(message))
        elseif string.len(message) < 1 or string.len(message) == 0 then
            local syntax = exports['fv_engine']:getServerSyntax(false, "error")
            outputChatBox(syntax .. " /try [Text]", 255,255,255,true)
            return
        elseif string.sub(message, 1, 1) == " " then
            return    
        elseif string.len(message) > maxLength then
            return
        else
            message = string.sub(message, 1, 1)
        end
        
        for k,v in pairs(emojis) do
            if string.upper(message):find(string.upper(k), 1, true) then
                --onClientMessage(localPlayer, emojis[k][1], 1)
                message = emojis[k][1]
                if emojis[k][2] then
                    if not getPedOccupiedVehicle(localPlayer) then 
                        setElementData(localPlayer, "animation", emojis[k][2])
                    end
                end
                return
            end
        end
        
        local name = exports['fv_admin']:getAdminName(element)
        outputChatBox(" ***"..name.." tries "..message.." and he succeeds!", 71, 209, 71)

        local x,y,z = getElementPosition(localPlayer)
        for k,v in pairs(getElementsByType("player",_,true)) do
            if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                local x1, y1, z1 = getElementPosition(v)
                local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                local veh2 = getPedOccupiedVehicle(v)
                if distance <= 8 then
                    local r,g,b = 71, 209, 71
                    triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, " ***"..name.." tries "..message.." and he succeeds!", r,g,b)
                end
            end
        end
    elseif mtype == "try >> failed" then
        --local message
        if string.len(message) > 1 then
            message = string.sub(message, 1, 1) .. string.sub(message, 2, string.len(message))
        elseif string.len(message) < 1 or string.len(message) == 0 then
            local syntax = exports['fv_engine']:getServerSyntax(false, "error")
            outputChatBox(syntax .. " /tries [Text]", 255,255,255,true)
            return
        elseif string.sub(message, 1, 1) == " " then
            return    
        elseif string.len(message) > maxLength then
            return
        else
            message = string.sub(message, 1, 1)
        end
        
        for k,v in pairs(emojis) do
            if string.upper(message):find(string.upper(k), 1, true) then
                --onClientMessage(localPlayer, emojis[k][1], 1)
                message = emojis[k][1]
                if emojis[k][2] then
                    if not getPedOccupiedVehicle(localPlayer) then 
                        setElementData(localPlayer, "animation", emojis[k][2])
                    end
                end
                return
            end
        end
        
        local name = exports['fv_admin']:getAdminName(element)
        outputChatBox(" ***"..name.." tries "..message.." but unfortunately he failed!", 255, 51, 51)

        local x,y,z = getElementPosition(localPlayer)
        for k,v in pairs(getElementsByType("player",_,true)) do
            if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                local x1, y1, z1 = getElementPosition(v)
                local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                local veh2 = getPedOccupiedVehicle(v)
                if distance <= 8 then
                    local r,g,b = 255, 51, 51
                    triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, " ***"..name.." tries "..message.." but unfortunately he failed!", r,g,b)
                end
            end
        end
    elseif mtype == "ooc" then
        --local message
        
        --[[
        KELL MÉG BELE AZ ADMINDUTYS CUCC
        ]]
        
        if string.len(message) > maxLength then
            return
        elseif string.len(message) > 1 then
            message = string.sub(message, 1, 1) .. string.sub(message, 2, string.len(message))
        elseif string.len(message) < 1 or string.len(message) == 0 then
            local syntax = exports['fv_engine']:getServerSyntax(false, "error")
            outputChatBox(syntax .. " /b [Text]", 255,255,255,true)
            return
        elseif string.sub(message, 1, 1) == " " then
            return    
        else
            message = string.sub(message, 1, 1)
        end
        
        local name = exports['fv_admin']:getAdminName(element)
        local time = getRealTime()
        local time1 = time.hour
        if time1 < 10 then
            time1 = "0" .. tostring(time1)
        end
        local time2 = time.minute
        if time2 < 10 then
            time2 = "0" .. tostring(time2)
        end
        local time3 = time.second
        if time3 < 10 then
            time3 = "0" .. tostring(time3)
        end
        --local time = time1..":"..time2..":"..time3
        local time = ""
        if getElementData(element,"admin >> duty") then 
            local adminColor = exports.fv_admin:getAdminColor(element, level)
            insertOOC(adminColor.."(( "..name..": "..message.." ))")
        else 
            insertOOC("(( "..name..": "..message.." ))")
        end

        local x,y,z = getElementPosition(localPlayer)
        for k,v in pairs(getElementsByType("player",_,true)) do
            if v ~= localPlayer and getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) then
                local x1, y1, z1 = getElementPosition(v)
                local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
                local veh2 = getPedOccupiedVehicle(v)
                if distance <= 11 then
                    local r,g,b = 255, 255, 255
                    triggerServerEvent("giveMessageToClient", localPlayer,  localPlayer, v, "(( "..name..": "..message.." ))", r,g,b, false, true)
                end
            end
        end
    end
end
addEvent("onClientMessage", true)
addEventHandler("onClientMessage", localPlayer, onClientMessage)

function rePresentSay(cmd, ...)
    local text = table.concat({...}, " ")
    onClientMessage(localPlayer, text, 0)
end
addCommandHandler("Say", rePresentSay)
addCommandHandler("SAY", rePresentSay)
addCommandHandler("saY", rePresentSay)
addCommandHandler("sAY", rePresentSay)
addCommandHandler("sAy", rePresentSay)

function rePresentMe(cmd, ...)
    local text = table.concat({...}, " ")
    onClientMessage(localPlayer, text, 1)
end
addCommandHandler("Do", rePresentMe)
addCommandHandler("do", rePresentMe)
addCommandHandler("DO", rePresentMe)
addCommandHandler("dO", rePresentMe)

function rePresentDo(cmd, ...)
    local text = table.concat({...}, " ")
    onClientMessage(localPlayer, text, "do")
end
addCommandHandler("Me", rePresentDo)
addCommandHandler("me", rePresentDo)
addCommandHandler("ME", rePresentDo)
addCommandHandler("mE", rePresentDo)

function rePresentAme(cmd, ...)
    local text = table.concat({...}, " ")
    onClientMessage(localPlayer, text, "ame")
end
addCommandHandler("AME", rePresentAme)
addCommandHandler("aMe", rePresentAme)
addCommandHandler("Ame", rePresentAme)
addCommandHandler("aME", rePresentAme)
addCommandHandler("AMe", rePresentAme)
addCommandHandler("ame", rePresentAme)

function rePresentShout(cmd, ...)
    local text = table.concat({...}, " ")
    onClientMessage(localPlayer, text, "shout")
end
addCommandHandler("s", rePresentShout)
addCommandHandler("S", rePresentShout)
addCommandHandler("Shout", rePresentShout)
addCommandHandler("shout", rePresentShout)

function rePresentC(cmd, ...)
    local text = table.concat({...}, " ")
    onClientMessage(localPlayer, text, "c")
end
addCommandHandler("c", rePresentC)
addCommandHandler("C", rePresentC)

function rePresentTry(cmd, ...)
    local text = table.concat({...}, " ")
    local rand = math.random(1,2) 
    if rand == 1 then
        onClientMessage(localPlayer, text, "try >> success")
    else
        onClientMessage(localPlayer, text, "try >> failed")
    end
end
addCommandHandler("try", rePresentTry)
addCommandHandler("Try", rePresentTry)

function rePresentTry2(cmd, ...)
    local text = table.concat({...}, " ")
    local rand = math.random(1,2) 
    if rand == 1 then
        onClientMessage(localPlayer, text, "try2 >> success")
    else
        onClientMessage(localPlayer, text, "try2 >> failed")
    end
end
addCommandHandler("try2", rePresentTry2)
addCommandHandler("Try2", rePresentTry2)

addEvent("chat -- receive", true)
addEventHandler("chat -- receive", root,
    function(e, message, r,g,b, whisper, ooc)
        if e == localPlayer then    
            if ooc then
                --outputChatBox(message, r,g,b)
                insertOOC(message)
            else
                outputChatBox(message, r,g,b)
            end
        end
    end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        bindKey("b", "down", "chatbox", "OOC")
        bindKey("y", "down", "chatbox", "Radio")
    end
)

function useOOC(cmd, ...)
    if not isPedDead(localPlayer) then 
        local text = table.concat({...}, " ")
        onClientMessage(localPlayer, text, "ooc")
    end
end
addCommandHandler("b", useOOC)
addCommandHandler("B", useOOC)
addCommandHandler("OOC", useOOC)
addCommandHandler("ooc", useOOC)
addCommandHandler("Ooc", useOOC)
addCommandHandler("OoC", useOOC)

function insertOOC(text)
    if #OOCCache >= 10 then
		table.remove(OOCCache,10)
    end
    table.insert (OOCCache,1,text)
    outputConsole("[OOC] " .. text:gsub("#%x%x%x%x%x%x",""))
end

function drawnOOC()
    if not getElementData(localPlayer, "togHUD") then return end
    if showOOC then 
        --OOC
        local oocfont = "default-bold";
        local x,y = 26, 32+(20*getChatboxLayout()["chat_lines"]);
        local shadow = false;
        if (getElementData(localPlayer,"customooc.showing") or false) then 
            oocfont = font
            shadow = true;
            x,y = getElementData(localPlayer,"customooc.x"),getElementData(localPlayer,"customooc.y")+15;
        end
        if not shadow then
            dxDrawText("OOC Chat (to clear use /clearooc)", x+1, y - 10+1, x+1, y - 15+1, tocolor(0,0,0,255), 1, oocfont, "left", "center",shadow)
            dxDrawText("OOC Chat (to clear use /clearooc)", x, y - 10, x, y - 15, tocolor(255,255,255), 1, oocfont, "left", "center",shadow)
        else 
            shadowedText("OOC Chat (to clear use /clearooc)", x, y - 10, x, y - 15, tocolor(255,255,255,255), 1, oocfont, "left", "center",shadow)
        end
        for k,v in ipairs(OOCCache) do
            local ay = 165-(k*15)
            if not shadow then 
                dxDrawText(v:gsub("#%x%x%x%x%x%x",""), x+1, y + ay - 20+1, x+1, y + ay+1, tocolor(0,0,0,255), 1, oocfont, "left", "center",shadow)
                dxDrawText(v, x, y + ay - 20, x, y + ay, tocolor(255,255,255), 1, oocfont, "left", "center",shadow,false,false,true);
            else 
                shadowedText(v, x, y + ay - 20, x, y + ay, tocolor(255,255,255,255), 1, oocfont, "left", "center",shadow)
            end
        end
    end
end
addEventHandler("onClientRender", root, drawnOOC, true, "low-5")

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY,shadow)
    if not shadow then shadow = false end;
    if shadow then 
        dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
        dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true)
        dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
        dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    end
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, true, true)
end

function clearOOC(cmd)
    local syntax = exports['fv_engine']:getServerSyntax("Chat", "servercolor");
    outputChatBox(syntax.."OOC Chat successfully cleared!", 255,255,255,true)
    OOCCache = {}
end
addCommandHandler("clearooc", clearOOC,false,false)
addCommandHandler("co", clearOOC,false,false)

function clearChat(cmd)
    local chatData = getChatboxLayout()
    local lines = chatData["chat_lines"]
    for i = 0, lines do
        outputChatBox(" ")
    end
    local syntax = exports['fv_engine']:getServerSyntax("Chat", "servercolor");
    outputChatBox(syntax.."Chat successfully cleared!", 255,255,255,true)
end
addCommandHandler("clearchat", clearChat,false,false);

function togOOC(cmd)
    showOOC = not showOOC;
    if showOOC then 
        local syntax = exports['fv_engine']:getServerSyntax("Chat", "servercolor");
        outputChatBox(syntax.."OOC Chat successfully enabled!", 255,255,255,true)
    else 
        local syntax = exports['fv_engine']:getServerSyntax("Chat", "red");
        outputChatBox(syntax.."OOC Chat successfully disabled!", 255,255,255,true)
    end
end
addCommandHandler("togooc", togOOC,false,false);