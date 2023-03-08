white = "#FFFFFF";

types = {
    --ID, {modelid, "név", mag itemID, kész item},
    [1] = {857,"Coca seeds",108,113}, --Koka
    [2] = {858,"Poppy Seeds",109,111}, --Mak
    [3] = {859,"Marijuana Seeds",110,112}, --Mariska
}
types[0] = {false,"Empty tiles"};

function findPlant(id)
    local found = false;
    for _, object in pairs(getElementsByType("object",resourceRoot)) do 
        local plantID = getElementData(object,"plant.id");
        if plantID and id == plantID then 
            found = object;
            break;
        end
    end
    return found;
end

pedPos = {
    {-401.12414550781, -1418.8956298828, 25.720909118652,4},
    {-247.57800292969, -2202.8608398438, 29.03938293457,311},
    {-2409.3786621094, -2189.9426269531, 34.0390625,0},
    {992.34912109375, 3.1428818702698, 92.489120483398,192},
    {1586.2833251953, -1960.8870849609, 13.546875,350},
    {1036.6707763672, -2199.1538085938, 38.409950256348,0},
    {338.81671142578, -563.70391845703, 17.195192337036,271}
};

function formatMoney(amount)
    amount = tonumber(amount);
    if not amount then 
        return 0;
    end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end