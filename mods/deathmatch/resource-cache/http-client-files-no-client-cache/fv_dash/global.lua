white = "#FFFFFF"
tabs = {
    "Overview",
    "Property",
    "faction",
    "Admins",
    "Donation",
    "Settings"
}

ppPacks = {
    --Csomag neve,forint,pp
    {"1000PP",508,500,"Contact us!"},
    {"2000PP",1016,1000,"Contact us!"},
    {"3500PP",2032,2000,"Contact us!"},
    {"7500PP",5080,5000,"Contact us!"},
}

adminTitles = {
    [1] = "Temporary Admin Assistant",
    [2] = "Admin",
    [3] = "Admin 1",
    [4] = "Admin 2",
    [5] = "Admin 3",
    [6] = "Admin 4",
    [7] = "Admin 5",
    [8] = "Main admin",
    [9] = "AdminController",
}

ftypes = { --Frakció típusok
    --id = "típus",
    [1] = "Banda",
    [2] = "Maffia",
    [3] = "order of protection",
    [4] = "council",
    [5] = "Other"
}


function formatMoney(amount)
    amount = tonumber(amount);
    if not amount then 
        return 0;
    end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function isFaction(element,fid)
    return (getElementData(element,"faction_"..fid) or false);
end
function isFactionLeader(element,fid)
    return (getElementData(element,"faction_"..fid.."_leader") or false);
end
function isRendvedelem(fid) --Ide mindig bekell irni ha van uj fraki
    if fid == 2 then 
        return true;
    end
    return false;
end

intTypes = {
    [1] = "House",
    [2] = "Business",
    [3] = "council",
    [4] = "Garage"
}