
white = "#FFFFFF";

prices = {
    {74, 500}, --Ponty
    {75, 700}, --Harcsa
    {76, 900}, --Keszeg
    {77, 1100}, --Csuka 
    {78, 2000}, --Pisztráng
    {79, 5000}, --Cápa
    {80, 2200}, --Süllő
    --Szarok
    {81, false}, --Konzerv geci
    {82, false}, --Rossz fasz
    {83, false}, --Üres Palack
    {84, false}, --Hínár 
};


function foundInPrices(itemID)
    local found = false;
    for k,v in pairs(prices) do 
        if v[1] == itemID then 
            found = v;
            break;
        end
    end
    return unpack(found);
end

function formatMoney(amount)
    amount = tonumber(amount);
    if not amount then 
        return 0;
    end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end