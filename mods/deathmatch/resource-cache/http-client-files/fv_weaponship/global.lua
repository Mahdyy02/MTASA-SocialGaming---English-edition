white = "#FFFFFF";

alertfactions = { 54, 60, 62, 10, 57, 65};

function isFaction(player)
    local state = false;
    for k,v in pairs(alertfactions) do 
        if getElementData(player,"faction_"..v) then 
            state = true;
            break;
        end
    end
    return state;
end

function tableRand(tbl)
    local size = #tbl
    for i = size, 1, -1 do
        local rand = math.random(size)
        tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end