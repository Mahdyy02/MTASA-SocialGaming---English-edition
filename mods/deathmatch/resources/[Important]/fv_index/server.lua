local cache = {}
local state = {}
local beepTimer = {}

function startIndex(veh, dName)
    if not isTimer(cache[veh]) then
        local oldLight = getElementData(veh, "veh:lights")
        setElementData(veh, "oldLight", oldLight)
        --if oldLight then
        local table = {}
        for i = 0,3 do
            local v = getVehicleLightState(veh, i)
            table[i] = v
        end
        setElementData(veh, "oldLightState", table)
        --end
        --setElementData(veh, "veh:lights", true)
        setVehicleOverrideLights(veh, 2)
        local state = false
        local num = 0
        if getElementData(veh, "veh:lights") then
            state = true
        end
        if state then
            num = 1
        end
        
        if not getElementData(veh, "index.middle") then
            if getElementData(veh, "index.left") then
                if table[0] == 0 then
                    setVehicleLightState(veh, 0, num)
                end
                setVehicleLightState(veh, 3, num)
            else
                if getElementData(veh, "veh:lights") then
                    if getVehicleLightState(veh, 0) == 0 then
                        setVehicleLightState(veh, 0, 0)
                    end
                    if getVehicleLightState(veh, 3) == 0 then
                        setVehicleLightState(veh, 3, 0)
                    end
                else
                    setVehicleLightState(veh, 0, 1)
                    setVehicleLightState(veh, 3, 1)
                end
            end

            if getElementData(veh, "index.right") then
                if table[1] == 0 then
                    setVehicleLightState(veh, 1, num)
                end
                setVehicleLightState(veh, 2, num)
            else
                if getElementData(veh, "veh:lights") then
                    if getVehicleLightState(veh, 1) == 0 then
                        setVehicleLightState(veh, 1, 0)
                    end
                    if getVehicleLightState(veh, 2) == 0 then
                        setVehicleLightState(veh, 2, 0)
                    end
                else
                    setVehicleLightState(veh, 1, 1)
                    setVehicleLightState(veh, 2, 1)
                end
            end
        end
        
        if getElementData(veh, "index.middle") then
            if table[0] == 0 then
                setVehicleLightState(veh, 0, num)
            end
            setVehicleLightState(veh, 3, num)
            if table[1] == 0 then
                setVehicleLightState(veh, 1, num)
            end
            setVehicleLightState(veh, 2, num)
        end
        
        local controller = getVehicleController(veh)
        if controller then
            triggerClientEvent(controller, "index", controller, controller, veh)
        end

        state = not state
        local veh = veh
        cache[veh] = setTimer(
            function()
                if not isElement(veh) then
                    stopIndex(veh, dName)
                end
                local num = 0
                if state then
                    num = 1
                end
                
                if not getElementData(veh, "index.middle") then
                    if getElementData(veh, "index.left") then
                        if table[0] == 0 then
                            setVehicleLightState(veh, 0, num)
                        end
                        setVehicleLightState(veh, 3, num)
                    else
                        if getElementData(veh, "veh:lights") then
                            if getVehicleLightState(veh, 0) == 0 then
                                setVehicleLightState(veh, 0, 0)
                            end
                            if getVehicleLightState(veh, 3) == 0 then
                                setVehicleLightState(veh, 3, 0)
                            end
                        else
                            setVehicleLightState(veh, 0, 1)
                            setVehicleLightState(veh, 3, 1)
                        end
                    end

                    if getElementData(veh, "index.right") then
                        if table[1] == 0 then
                            setVehicleLightState(veh, 1, num)
                        end
                        setVehicleLightState(veh, 2, num)
                    else
                        if getElementData(veh, "veh:lights") then
                            if getVehicleLightState(veh, 1) == 0 then
                                setVehicleLightState(veh, 1, 0)
                            end
                            if getVehicleLightState(veh, 2) == 0 then
                                setVehicleLightState(veh, 2, 0)
                            end
                        else
                            setVehicleLightState(veh, 1, 1)
                            setVehicleLightState(veh, 2, 1)
                        end
                    end
                end
                
                if getElementData(veh, "index.middle") then
                    if table[0] == 0 then
                        setVehicleLightState(veh, 0, num)
                    end
                    setVehicleLightState(veh, 3, num)
                    if table[1] == 0 then
                        setVehicleLightState(veh, 1, num)
                    end
                    setVehicleLightState(veh, 2, num)
                end

                state = not state
            end, 310, 0
        )
        
        if isTimer(beepTimer[veh]) then killTimer (beepTimer) end
        
        beepTimer[veh] = setTimer(
            function()
                if isElement(veh) then
                    local controller = getVehicleController(veh)
                    if controller then
                        triggerClientEvent(controller, "index", controller, controller, veh)
                    end
                else
                    stopIndex(veh, dName)
                end
            end, 665, 0
        )
    end
end

local convertNameToNumber = {
    ["index.left"] = 1,
    ["index.right"] = 0,
}

function stopIndex(veh, dName)
    if isTimer(cache[veh]) then
        killTimer(cache[veh])
        cache[veh] = nil
        if not veh or not isElement(veh) then return end;
        local anotherLightState
        if dName ~= "index.middle" then
            anotherLightState = getVehicleLightState(veh, convertNameToNumber[dName])
        end
        for i = 0,3 do
            setVehicleLightState(veh, i, 0)
        end
        local oldLight = getElementData(veh, "oldLight")
        setElementData(veh, "veh:lights", not oldLight)
        setElementData(veh, "veh:lights", oldLight)
        --if oldLight then
        local table = getElementData(veh, "oldLightState") or {}
        if getElementData(veh, "veh:lights") then
            if dName ~= "index.middle" then
                if anotherLightState == 1 then
                    local name = convertNameToNumber[dName]
                    table[name] = anotherLightState
                end
            end
        end
        for k,v in pairs(table) do
            setVehicleLightState(veh, k, v)
        end
        setElementData(veh, "oldLightState", nil)
        --end
    end
    if isTimer(beepTimer[veh]) then
        killTimer(beepTimer[veh])
        beepTimer[veh] = nul
    end
end

addEventHandler("onElementDataChange", root,
    function(dName)
        if getElementType(source) == "vehicle" then
            if dName == "index.left" or dName == "index.right" then
                if getElementData(source, "index.middle") then return end
                local value1 = getElementData(source, "index.left")
                local value2 = getElementData(source, "index.right")
                if value1 or value2 then
                    startIndex(source, dName)
                end
                if not value1 and not value2 then
                    stopIndex(source, dName)
                end
            elseif dName == "index.middle" then
                local value = getElementData(source, "index.middle")
                if value then
                    setElementData(source, "index.middle", true)
                    if value1 then
                        setElementData(source, "index.left", true)
                    end
                    if value2 then
                        setElementData(source, "index.right", true)
                    end
                    startIndex(source, "index.middle")
                else
                    stopIndex(source, "index.middle")
                end
            end
        end
    end
)