
addCommandHandler("gp", function(p)
    local x, y, z = getElementPosition(localPlayer)
    outputChatBox("C: {" .. x .. ", " .. y .. ", " .. z .. "}")
    
end)

addCommandHandler("getpos", function(cmd)
    --if not hasPermission(localPlayer, "getpos") then noAdmin(cmd) return end
        local x,y,z = getElementPosition(localPlayer)
        local dim, int = getElementDimension(localPlayer), getElementInterior(localPlayer)
        local a, a, rot = getElementRotation(localPlayer)
        setClipboard(x .. ", " .. y .. ", " .. z)
        local syntax = "C: "
        local green = "#ffffff"
        local white = "#ffffff"
        outputChatBox(syntax .. "XYZ" .. ": ".. green .. x .. white ..", " .. green .. y .. white .. ", " .. green .. z,255,255,255,true)
        outputChatBox(syntax .. "Interior" .. ": ".. green .. int,255,255,255,true)
        outputChatBox(syntax .. "Dimension" .. ": ".. green .. dim,255,255,255,true)
        outputChatBox(syntax .. "Rotation" .. ": ".. green .. rot,255,255,255,true)
end);

function onPreFunction( sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ... )
    local args = { ... }
    local resname = sourceResource and getResourceName(sourceResource)
    if string.find(args[1], "10:00") and resname ~= "fv_debug" then
        print( "CLIENT preFunction"
            .. " " .. tostring(resname)
            .. " " .. tostring(functionName)
            .. " allowed: " .. tostring(isAllowedByACL)
            .. " file: " .. tostring(luaFilename)
            .. "(" .. tostring(luaLineNumber) .. ")"
            .. " numArgs: " .. tostring(#args)
            .. " arg1: " .. tostring(args[1])
            )
    end
end
addDebugHook( "preFunction", onPreFunction, {"dxDrawText"})

addCommandHandler("sed", function(dataKey, dataValue)
    setElementData(localPlayer, "loggedIn", false)
end)

addCommandHandler("sed2", function(dataKey, dataValue)
    setElementData(localPlayer, "loggedIn", true)
end)