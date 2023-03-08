local gateState = {}

addEventHandler("onResourceStart", resourceRoot, function()
    for k, v in pairs(gates) do
        gateState[k] = "close"
    end 
end)

addEvent("getGateStates", true)
addEventHandler("getGateStates", root, function()
    if not isElement(source) then return end
    triggerClientEvent(source, "receiveGateStates", source, gateState)
end)

addCommandHandler("go", function(player, cmd, id)
    local id = tonumber(id)
    if id then
        triggerClientEvent(getElementsByType("player"), "setGateState", player, id, "open")
        gateState[id] = "open"
    end
end)

addCommandHandler("goc", function(player, cmd, id)
    local id = tonumber(id)
    if id then
        triggerClientEvent(getElementsByType("player"), "setGateState", player, id)
        gateState[id] = "close"
    end
end)