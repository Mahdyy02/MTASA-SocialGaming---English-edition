--EHHEZ NE NYÚLJ!
local start = 0;

addEventHandler("onClientResourceStart",resourceRoot,function()
    outputDebugString("VehMods: Loading started!",0,0,255,0);
    start = getTickCount();
    loadMods();
end);

function loadMods()
    for k,v in pairs(vehNames) do 
        if fileExists("mods/"..k..".dff") and fileExists("mods/"..k..".txd") then 
            local txd = engineLoadTXD("mods/"..k..".txd");
            engineImportTXD(txd,tonumber(k));
            local dff = engineLoadDFF("mods/"..k..".dff")
            engineReplaceModel(dff, tonumber(k));
        else 
            outputDebugString("VehMods: "..k.." - files NOT found!");
        end
    end
    outputDebugString("VehMods: Loading complete in "..((getTickCount()-start)/1000).." sec!",0,0,255,0);
end

addEventHandler("onClientResourceStop",resourceRoot,function()
    for k,v in pairs(vehNames) do 
        engineRestoreModel(k);
    end
end);