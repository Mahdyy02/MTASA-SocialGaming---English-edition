
-- OLD ElementData Protect--
local datas = {
    --Karakter--
    ["char >> id"] = true,
    ["acc >> id"] = true,
    ["char >> vehSlot"] = true,
    ["char >> intSlot"] = true,
    ["char >> level"] = true,
    ["char >> premiumPoints"] = true,
    ["char >> bankmoney"] = true,
    ["char >> money"] = false,
    ------------

    --Admin--
    ["admin >> name"] = true,
    ["admin >> level"] = true,
    ["char >> adminJail"] = true,
    ["fly"] = true,
    ---------
};
addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
    if client then 
        local elementType = getElementType(source);
        if elementType == "player" and datas[dataName] then 
            outputDebugString("ANTICHEAT :: "..getElementData(source,"char >> name").." changed ".. dataName.." " ..oldValue.." to "..newValue.." ", 0, 255, 0, 0);
            setElementData(source, dataName, oldValue);
            outputChatBox(exports.fv_engine:getServerSyntax("Anticheat","red").."Client-side element data change detected on element data that is protected, reset to old (Report situation to developer!)", source, 255, 255, 255, true);
            addLog(getElementData(source,"char >> name").." Protected ElementData changed! Data: "..dataName.." oldValue: "..oldValue.." newValue: "..newValue);
        end
    end
end);

addEvent("ac.elementData",true);
addEventHandler("ac.elementData",root,function(player,data,value)
    setElementData(player,data,value);
end);
-- OLD ElementData Protect--

-- New ElementData+LoadString+TriggerServerEvent Protect--
addEvent("unauthorizedFunction", true)
addEventHandler("unauthorizedFunction", getRootElement(), function (resourceName, functionName, luaFilename, luaLineNumber, args)
    local saveLog = "resourceName: " .. resourceName .. ", functionName: " .. functionName .. ", luaFilename: " .. (luaFilename or "unknown") .. ", luaLineNumber: " .. (luaLineNumber or "-") .. ", args: " .. (args and table.concat(args, "|") or "-");
    addLog(saveLog);
    outputDebugString(saveLog,0,200,0,0);
end);
-- New ElementData+LoadString+TriggerServerEvent Protect END--

function addLog(msg)
    local rt = getRealTime();
    local date = ("%04d-%02d-%02d"):format(rt.year+1900, rt.month + 1, rt.monthday);
    local file = false;
    if fileExists("logs/"..date..".log") then 
        file = fileOpen("logs/"..date..".log");
    else 
        file = fileCreate("logs/"..date..".log");
    end
    fileSetPos(file, fileGetSize(file));
    fileWrite(file, msg.."\r\n");
    fileFlush(file);
    fileClose(file);
end