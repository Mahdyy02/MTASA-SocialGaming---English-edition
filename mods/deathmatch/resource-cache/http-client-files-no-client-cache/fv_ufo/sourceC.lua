addEventHandler("onClientResourceStart", resourceRoot, function()
    txd = engineLoadTXD ( "ufo.txd" )
    engineImportTXD ( txd, 447 )
    dff = engineLoadDFF ( "ufo.dff" )
    engineReplaceModel ( dff, 447 ) -- 425

    for i = 0, 44 do
        setWorldSoundEnabled ( i, false)
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    txd = engineLoadTXD ( "ufo.txd" )
    engineImportTXD ( txd, 447 )
    dff = engineLoadDFF ( "ufo.dff" )
    engineReplaceModel ( dff, 447 ) -- 425

    for i = 0, 44 do
        setWorldSoundEnabled ( i, true)
    end
end)

local sounds = {}

addEvent("ufoSound", true)
addEventHandler("ufoSound", root, function()
    local x, y, z = getElementPosition(source)
    sounds[source] = playSound3D("ufo.mp3", x, y, z, true)
    setSoundVolume(sounds[source], 10)
    setSoundMinDistance(sounds[source], 0)
    setSoundMaxDistance(sounds[source], 500)
    attachElements(sounds[source], source)
end)

addEvent("delufoSound", true)
addEventHandler("delufoSound", root, function()
    if isElement(sounds[source]) then
        destroyElement(sounds[source])
        sounds[source] = nil
    end
end)