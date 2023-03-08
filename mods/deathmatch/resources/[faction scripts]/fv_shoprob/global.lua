white = "#FFFFFF";

pos = {
    --Helyszín,x,y,z,rot,dim,inter
    {"South Gas Station",1925.9432373047, -1768.6959228516, 13.5,-90,0,0},
    {"North Gas Station",1011.3572387695, -911.30633544922, 42.40,-85,0,0},
    {"Flint County Gas Station", -71.776397705078, -1179.3100585938, 2.4,150,0,0},
    {"Easter Basin Gas Station", -1684.0686035156, 420.58697509766, 7.5,-45,0,0},
    {"Whetstone Gas Station", -1600.9626464844, -2704.8508300781, 48.8,-120,0,0},
	
}

allowedFactions = {
    7,8,9,10,20,24,15,26,16,31,18,38,45,43
}

function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function isAfaction(element)
    local found = false;
    for k,v in pairs(allowedFactions) do 
        if getElementData(element,"faction_"..v) then 
            found = true;
            break;
        end
    end
    return found;
end