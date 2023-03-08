local gateCache = {}
local shader = nil
local texture = nil

addEventHandler("onClientResourceStart", resourceRoot, function()
    createGates()
    triggerServerEvent("getGateStates", localPlayer)
end)

addEvent("receiveGateStates", true)
addEventHandler("receiveGateStates", root, function(states)
    for k, v in pairs(states) do
        triggerEvent("setGateState", localPlayer, k, v)
    end
end)

function applyTexture(object)
    if not isElement(texture) then
        texture = dxCreateTexture("files/ws_rollerdoor_fire.png", "dxt3")
    end

    if not isElement(shader) then
        shader = dxCreateShader("files/changer.fx", 0, 200, false, "object")
    end
        
    if isElement(shader) and isElement(texture) then
        dxSetShaderValue(shader, "TEXTURE", texture)
        engineApplyShaderToWorldTexture(shader, "alleydoor9b", object)
    end
end

function createGates()
    for k, v in pairs(gates) do
        gateCache[k] = createObject(3294, unpack(v))
        applyTexture(gateCache[k])
    end 
end


addEvent("setGateState", true)
addEventHandler("setGateState", root, function(id, state)
    if state == "open" then
        local gatePos = {getElementPosition(gateCache[id])}
        moveObject(gateCache[id], 1000, gatePos[1], gatePos[2], gatePos[3] + 5)
    else
        local gatePos = {gates[id][1], gates[id][2], gates[id][3]}
        moveObject(gateCache[id], 1000, gatePos[1], gatePos[2], gatePos[3])
    end
end)

--[[
addEventHandler("onClientRender", root, function()
    for k, v in pairs(gates) do
        local sx, sy = getScreenFromWorldPosition(v[1], v[2], v[3])
        if sx then
            dxDrawText(k, sx, sy, sx, sy)
        end
    end
end)]]