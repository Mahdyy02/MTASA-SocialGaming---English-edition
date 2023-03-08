white = "#FFFFFF";

vehicleModels = {
	[596] = true, -- Police LS
	[599] = true, -- Police Ranger
	[490] = true, -- FBI Rancher
	[598] = true, -- Police LV
	[528] = true, -- FBI Truck
	[597] = true, -- Police SF
    [497] = true, -- FBI Maverick
    [427] = true, -- Enforcer
    [472] = true, -- Coastguard
}

allowedFactions = { 54, 53 };

btk = {
    {"Abridgment","Name of the infringement","fine","Prison","Other"},
    {"CD","Convinced Driving - Careless driving","700 dt","0",""},
}

types = {
    {"Patrol","servercolor"},
    {"Persecution","orange"},
    {"Action","red"},
}
types[0] = {"Off","red"};

function isAllowedFaction(player)
    local state = false;
    for k,v in pairs(allowedFactions) do 
        if getElementData(player,"faction_"..v) then 
            state = true;
            break;
        end
    end
    return state;
end

function isAllowedFactionLeader(player)
    local state = false;
    for k,v in pairs(allowedFactions) do 
        if getElementData(player,"faction_"..v.."_leader") then 
            state = true;
            break;
        end
    end
    return state;
end

--UTILS--
function tableCopy(t)
	if type(t) == "table" then
		local r = {}
		for k, v in pairs(t) do
			r[k] = tableCopy(v);
		end
		return r;
	else
		return t;
	end
end
