addEventHandler("onResourceStart", resourceRoot, function()
    spawnPlayer(source, 1422.1225585938, -1675.1296386719, 13.546875)
    fadeCamera(source, false)
end)
addCommandHandler("spawn", function(p, cmd)
    print("asd")
    spawnPlayer(p, 1422.1225585938, -1675.1296386719, 13.546875)
    fadeCamera(p, false)
    setCameraTarget(p)
end)

addCommandHandler("gp", function(p)
    local x, y, z = getElementPosition(p)
    outputChatBox("S: {" .. x .. ", " .. y .. ", " .. z .. "}")
    
end)

function onPreFunction( sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ... )
    local args = { ... }
    local resname = sourceResource and getResourceName(sourceResource)
    
        print( "SERVER: preFunction"
            .. " " .. tostring(resname)
            .. " " .. tostring(functionName)
            .. " allowed: " .. tostring(isAllowedByACL)
            .. " file: " .. tostring(luaFilename)
            .. "(" .. tostring(luaLineNumber) .. ")"
            .. " numArgs: " .. tostring(#args)
            .. " arg1: " .. tostring(args[1])
            )
    
end
addDebugHook( "preFunction", onPreFunction, {"cancelEvent"})

addCommandHandler("res", function(p, cmd)
    for k, v in pairs(getResources()) do
        local name = getResourceName(v)
        outputChatBox(name, p)
    end
end)