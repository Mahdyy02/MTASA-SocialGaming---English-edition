addEventHandler("onResourceStart", resourceRoot, function()
    createHotdogStalls()
end)

function createHotdogStalls()
    for k, v in pairs(hotdogStalls) do
        local object = createObject(1340, v[1], v[2], v[3], 0, 0, v[4])
        --setElementRotation(object, 0, 0, math.floor(v[4]) + 90)
        setElementRotation(object, 0, 0, v[4])
        setElementData(object, "stall.id", k)
        setElementData(object, "stall.inUse", false)
    end
end

addEvent("updatePlayerPos", true)
addEventHandler("updatePlayerPos", root, function(x, y, z, rz) 
    setElementPosition(source, x, y, z)
    setElementRotation(source, 0, 0, rz)
end)