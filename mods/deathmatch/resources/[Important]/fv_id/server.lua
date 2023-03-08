local cache = {}

local serverslot = getMaxPlayers()

addEventHandler("onResourceStart", resourceRoot,
    function()
        for k,v in pairs(getElementsByType("player")) do
            local id = getElementData(v, "char >> id")
            if id and not cache[id] then
                cache[id] = v
            else 
                setElementData(v,"char >> id",false);
                setPlayerID(v)
            end
        end
    end

)

function setPlayerID(player)
    serverslot = getMaxPlayers()
    for i = 1, serverslot do
        if not cache[i] then
            cache[i] = player
            setElementData(player, "char >> id", i)
            return
        end
    end
end


addEventHandler("onPlayerJoin", root,
    function()
        serverslot = getMaxPlayers()
        for i = 1, serverslot do
            if not cache[i] then
                cache[i] = source
                setElementData(source, "char >> id", i)
                return
            end
        end
    end

)



addEventHandler("onPlayerQuit", root,
    function()
        local id = getElementData(source, "char >> id")
        if id then
            cache[id] = nil
        end
    end

)