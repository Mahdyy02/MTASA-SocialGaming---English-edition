addEvent("toggleSirenSound", true)
addEventHandler("toggleSirenSound", root, function(soundID)
    local modelID = getElementModel(getPedOccupiedVehicle(source)) 
    if allowedVehicles[modelID] then
        triggerClientEvent(getElementsByType("player"), "toggleSirenSound", source, soundID)
    end
end)

addEvent("toggleSirenLights", true)
addEventHandler("toggleSirenLights", root, function(lightID)
    local vehicle = getPedOccupiedVehicle(source)
    local modelID = getElementModel(vehicle)
    if allowedVehicles[modelID] and sirenPos[modelID] then
        if lightID and tonumber(lightID) then
            addVehicleSirens(vehicle, #sirenPos[modelID][lightID], 2, false, false, true, true)
            for k, v in ipairs(sirenPos[modelID][lightID]) do
                setVehicleSirens(vehicle, k, unpack(v))
            end
            setVehicleSirensOn(vehicle, false)
            setVehicleSirensOn(vehicle, true)
        else
            setVehicleSirensOn(vehicle, false)
        end
    end
end)

addEventHandler("onVehicleEnter", root, function(player, seat)
    if allowedVehicles[getElementModel(source)] then
        bindAirhorn(player)
    end
end)

function bindAirhorn(player)
    bindKey(player, "lctrl", "down", playAirhorn, player)
    bindKey(player, "lctrl", "up", stopAirhorn, player)
end

function playAirhorn(player)
    if isPedInVehicle(player) and allowedVehicles[getElementModel(getPedOccupiedVehicle(player))] then
        triggerClientEvent(getElementsByType("player"), "useAirhorn", player, true)
    end
end

function stopAirhorn(player)
    if isPedInVehicle(player) and allowedVehicles[getElementModel(getPedOccupiedVehicle(player))] then
        triggerClientEvent(getElementsByType("player"), "useAirhorn", player, false)
    end
end