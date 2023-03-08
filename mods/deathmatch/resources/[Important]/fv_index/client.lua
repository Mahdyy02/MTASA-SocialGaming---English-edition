function interactLeftLight()
    if isTimer(spamTimer) then return end
    spamTimer = setTimer(function() end, 350, 1)
    if isCursorShowing() then return end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        --if getVehicleLightState(veh, 0) ~= 0 and not getElementData(veh, "index.left") then return end
        if getElementData(veh, "index.right") then return end
        if getElementData(veh, "index.middle") then return end
        if getVehicleType(veh) == "Automobile" or getVehicleType(veh) == "Monster Truck" then
            if getPedOccupiedVehicleSeat(localPlayer) == 0 then
                local oldValue = getElementData(veh, "index.left")
                setElementData(veh, "index.left", not oldValue)
            end
        end
    end
end

function interactRightLight()
    if isTimer(spamTimer) then return end
    spamTimer = setTimer(function() end, 350, 1)
    if isCursorShowing() then return end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        if getElementData(veh, "index.middle") then return end
        --if getVehicleLightState(veh, 1) ~= 0 and not getElementData(veh, "index.right") then return end
        if getElementData(veh, "index.left") then return end
        if getVehicleType(veh) == "Automobile" or getVehicleType(veh) == "Monster Truck" then
            if getPedOccupiedVehicleSeat(localPlayer) == 0 then
                local oldValue = getElementData(veh, "index.right")
                setElementData(veh, "index.right", not oldValue)
            end
        end
    end
end

function interactMiddleLight()
    if isTimer(spamTimer) then return end
    spamTimer = setTimer(function() end, 350, 1)
    if getElementData(localPlayer, "keysDenied") then return end
    if isCursorShowing() then return end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        --if getVehicleLightState(veh, 0) ~= 0 and not getElementData(veh, "index.left") and getVehicleLightState(veh, 1) ~= 0 and not getElementData(veh, "index.right") then return end
        if getVehicleType(veh) == "Automobile" or getVehicleType(veh) == "Monster Truck" then
            if getPedOccupiedVehicleSeat(localPlayer) == 0 then
                local oldValue = getElementData(veh, "index.middle")
                local newValue = not oldValue
                if newValue then
                    if getElementData(veh, "index.right") then return end
                    if getElementData(veh, "index.left") then return end
                end
                setElementData(veh, "index.middle", newValue)
            end
        end
    end
end

bindKey("mouse1", "down", interactLeftLight)
bindKey("mouse2", "down", interactRightLight)
bindKey("F7", "down", interactMiddleLight)

addEvent("index", true)
addEventHandler("index", root,
    function(p, veh)
        if p == localPlayer then
        	if getPedOccupiedVehicle(localPlayer) then
            	setSoundVolume(playSound("files/index.mp3"), 0.7)
            end
        end
    end
)