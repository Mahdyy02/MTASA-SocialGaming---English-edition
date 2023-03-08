slots = 32;
padding = 10;
itemSize = 42;
actionSlots = 6;

white = "#FFFFFF"

etelek = {
	[2] = true,
	[3] = true,
	[4] = true,
	[5] = true,
	[6] = true,
	[7] = true
};

italok = {
	[8] = true, 
	[9] = true, 
	[10] = true,
	[11] = true,
	[12] = true,
	[13] = true
};

halak = {
    [74] = true,
    [75] = true,
    [76] = true,
    [77] = true,
    [78] = true,
    [79] = true,
    [80] = true
};

-- ItemTypes: 1 = Objects 2 = Documents 3 = Keys
social_itemlista = {
	-- {Name, Decay, Stackable, Suly (kg), Item Type}
	{"Telephone", false, false, 0.1, 1},--1
	{"Batata mo9leya", true, false, 0.1, 1},--2
	{"donuts", true, false, 0.1, 1},--3
	{"Tacos", true, false, 0.1, 1},--4
	{"Kebab", true, false, 0.1, 1},--5
	{"Hamburger", true, false, 0.1, 1},--6
	{"Burger",true,false,0.1,1},--7
	{"Becks",false,true,0.5,1},--8
	{"RedBull", false,true,0.2,1},--9
	{"Cola",false, true,0.2,1},--10
	{"Dabouza mé", false, true, 0.5, 1},--11
	{"Celtia", false, true, 0.5, 1},--12
	{"Whiskey",false,true,0.5,1},--13
	{"AK47", false, false, 5,1},--14 
	{"M4",false,false,5, 1},--15 
	{"Katana",false,false,5,1},--16 
	{"Desert Eagle",false,false,3,1},--17 
	{"3sa Baseball", false, false, 1,1},--18 
	{"Sekina", false, false, 0.2,1},--19
	{"Matrak",false,false,0.2,1},--20
	{"Mok7la",false,false,3,1},--21 
	{"Sawn pipe",false,false,3,1},--22 
	{"7bar",false,true,0.01,1},--23
	{"Colt 45",false,false,1,1},--24
	{"Sniper",false,false,3,1},--25 
	{"Shotgun",false,false,3,1},--26 
	{"MP5",false,false,2,1},--27
	{"MAC10",false,false,2,1},--28
	{"choque électrique",false,false,2,1},--29
	{"TEC-9",false,false,3,1},--30
	{"kartouch 9mm", false, true,0.01, 1},--31
	{"kartouch mok7la",false,true,0.01, 1},--32
	{"kartouch 7.76mm",false,true,0.01, 1},--33
	{"Paint sprayer",false,false,0.2, 1},--34
	{"dabouza oxygéne",false,false,2,1},--35
	{"Mes7a",false,false,0.5,1},--36
	{"Menchar",false,false,1,1},--37
	{"5azna",false,false,5,1},--38
	{"Parachute",false,false,1,1},--39
	{"mefte7 karhba",false,false,0, 3},--40
	{"mefte7 dar",false,false,0,3},--41
	{"mefte7 5azna", false,false,0,3},--42
	{"ja3bou9",false,true,0.1,1},--43
	{"LSD", false,true,0.1,1},--44
	{"Cocaine",false,true,0.1,1},--45
	{"NEMTOMMIEZ",false,true,0.1,1},--46
	{"Bita9et ta3rif",false,false,0,2},--47
	{"Passport", false,false,0,2},--48
	{"Permis",false,false,0,2},--49
	{"Credit card",false,false,0,3},--50
	{"Viseur AK47",false,true,0.5,1},--51
	{"4a5ira AK47",false,true,0.5,1},--52
	{"Ja3bet AK47",false,true,0.5,1},--53
	{"Zined AK47",false,true,0.2,1},--54
	{"Yedd AK47",false,true,0.2,1},--55
	{"AK47 plan",false,false,0,1},--56
	{"Yedd M4",false,true,0.5,1},--57
	{"Zined",false,true,0.2,1},--58
	{"4a5ira M4",false,true,0.5,1},--59
	{"Viseur M4",false,true,0.5,1},--60
	{"ja3bet M4",false,true,0.2,1},--61
	{"M4 plan",false,false,0,1},--62
	{"Desert Eagle yed",false,true,0.2,1},--63
	{"ja3bet Desert Eagle",false,true,0.2,1},--64
	{"Zined Desert Eagle",false,true,0.2,1},--65
	{"Ta3miret Desert Eagle",false,true,0.2,1},--66
	{"Desert Eagle plan",false,false,0,1},--67
	{"Fes",false,false,0.5,1},--68
	{"Hi-Fi",false,false,2,1}, --69
	{"Dwé",false,true,0.2,1}, --70
	{"Sandou9 dwé",false,true,1,1}, --71
	--Horgászat--
	{"3sat Sonara",false,false,1,1}, --72
	{"Sonara",false,true,0.2,1}, --73
	{"Manneni",false,false,2,1}, --74
	{"9arous",false,false,3,1}, --75
	{"Sardina",false,false,2.5,1}, --76
	{"Sbares",false,false,3.5,1}, --77
	{"Trilia",false,false,3,1}, --78
	{"9erch",false,false,6,1}, --79
	{"Wrata",false,false,4,1}, --80
	{"Tonn",false,false,0.3,1}, --81
	{"Botte plastique",false,false,0.3,1}, --82
	{"Dabouza fergha",false,false,0.3,1}, --83
	{"4ri3",false,false,0.3,1}, --84
	---------
	{"Mefte7 baweba",false,false,0.1,3}, --85
	{"Radio",false,false,0.1,1}, --86
	{"Handcuffs",false,false,0.1,1}, --87
	{"Badge",false,false,0.1,2}, --88
	{"war9a fergha",false,false,0.1,2}, --89
	{"byou3 w chré",false,false,0.1,2}, --90
	{"Fixed card",false,true,0.1,1}, --91
	{"Fuel card",false,true,0.1,1}, --92
	{"Unflip card",false,true,0.1,1}, --93
	{"Healing card",false,true,0.1,1}, --94
	{"Easter egg",false,true,1,1}, --95
	{"3sa w Sonara",false,false,1,1}, --96
	{"ro5set sayd",false,false,0.1,2}, --97
	--Master books
	{"Colt-45 Master book",false,false,1,1}, --98
	{"Desert Eagle Master book",false,false,1,1}, --99
	{"AK47 Master book",false,false,1,1}, --100
	{"M4 Master book",false,false,1,1}, --101
	{"Shotgun Master book",false,false,1,1}, --102
	{"Sawn pipe Master book",false,false,1,1}, --103
	{"Sniper / Hunting Rifle Master book",false,false,1,1}, --104
	{"MP5 Master book",false,false,1,1}, --105
	{"MAC10 Master book",false,false,1,1}, --106
	{"Ro5set sle7",false,false,0.2,2}, --107
	---
	{"zore3et Koka",false,true,0.2,1}, --108
	{"zore3et ward",false,true,0.2,1}, --109
	{"zori3et Zatla",false,true,0.2,1}, --110
	{"ward",false,true,0.3,1}, --111
	{"war9et zatla",false,true,0.3,1}, --112
	{"war9et cocaine",false,true,0.3,1}, --113
	{"Ma7bes",false,false,1.2,1}, --114
	{"Mirach",false,false,3,1}, --115
	{"Torche",false,false,0.1,1}, --116
	{"Cigarette paper",false,true,0.1,1}, --117
	---
	{"Brikeya",false,false,0.1,1}, --118
	{"m8arfa",false,false,0.1,1}, --119
	{"Ibret zore9a",false,false,0.1,1}, --120
	{"Chemist Set",false,false,0.5,1}, --121
	-- BANKROB ITEM
	{"Rachklou",false,false,0.5,1}, --122
	{"C4",false,false,0.5,1}, --123
	{"Medda metfajra",false,false,0.3,1}, --124
	{"Scotch",false,false,0.3,1}, --125
	{"Mongela",false,false,0.3,1}, --126
	{"5yout 4aw",false,false,0.3,1}, --127
	{"Devil mask",false,false,0.1,1}, --128
	{"Vendetta mask",false,false,0.1,1}, --129
	{"Horse mask",false,false,0.1,1}, --130
	{"Darth mask",false,false,0.1,1}, --131
	{"Gasmask mask",false,false,0.1,1}, --132
	{"kovboy mask",false,false,0.1,1}, --133
	{"Zombie mask",false,false,0.1,1}, --134
	{"Vampire mask",false,false,0.1,1}, --135
	{"Skull mask",false,false,0.1,1}, --136
	{"Raccoon mask",false,false,0.1,1}, --137
	{"Owl mask",false,false,0.1,1}, --138
	{"Cat mask",false,false,0.1,1}, --139
	{"Bag",false,false,0.1,1}, --140
	{"Dog mask",false,false,0.1,1}, --141
	{"Baby mask",false,false,0.1,1}, --142
	{"Monster mask",false,false,0.1,1}, --143
	{"Tilki mask",false,false,0.1,1}, --144
	{"Admin mask",false,false,0.1,1}, --145
} 

craftTypes = {
	[1] = {
		name = "General",
		icon = "",
	},
	[2] = {
		name = "Weapon",
		icon = "",
	},
	[3] = {
		name = "Drug",
		icon = "",
	}
}

craftItems = {
	[1] = {
		{ --Horgászbot csalival
			[6] = {72,1},
			[7] = {73,1},
			enditem = 96, --Kész item
			endCount = 1,
			faction = false, --Frakció kell e
			factory = false, --Gyár kell e
		},
		{ --Horgászbot csalival
			[6] = {124,1},
			[7] = {125,1},
			[11] = {126,1},
			[10] = {127,1},
			enditem = 123, --Kész item
			endCount = 1,
			faction = false, --Frakció kell e
			factory = false, --Gyár kell e
		},
	},
	[2] = {
		{ --Deagle
			[6] = {66,1},
			[7] = {64,1},
			[10] = {63,1},
			[11] = {65,1},
			enditem = 17, --Kész item
			endCount = 1,
			faction = "illegal", --Frakció kell e
			factory = true, --Gyár kell e
		},
		{ --AK47
			[5] = {51,1},
			[6] = {54,1},
			[7] = {53,1},
			[9] = {58,1},
			[10] = {52,1},
			[11] = {55,1},
			enditem = 14, --Kész item
			endCount = 1,
			faction = "illegal", --Frakció kell e
			factory = true, --Gyár kell e
		},
		{ --M4
			[5] = {57,1},
			[6] = {60,1},
			[7] = {61,1},
			[9] = {58,1},
			[10] = {59,1},
			enditem = 15, --Kész item
			endCount = 1,
			faction = "illegal", --Frakció kell e
			factory = true, --Gyár kell e
		},
	},
	[3] = {
		{
			--[slot] = {itemID, count, NOT take},
			[6] = {116,1,true},
			[7] = {112,1},
			[11] = {117,1},
			enditem = 43, --Kész item
			endCount = 1,
			faction = false, --Frakció kell e
			factory = false, --Gyár kell e
		},
		{
			--[slot] = {itemID, count, NOT take},
			[3] = {111,1},
			[6] = {120,1},
			[7] = {119,1,true},
			[11] = {118,1,true},
			enditem = 44, --Kész item
			endCount = 1,
			faction = "Illegal", --Frakció kell e
			factory = false, --Gyár kell e
		},
		{
			--[slot] = {itemID, count, NOT take},
			[7] = {113,1},
			[11] = {121,1,true},
			enditem = 45, --Kész item
			endCount = 1,
			faction = "Illegal", --Frakció kell e
			factory = false, --Gyár kell e
		},
	}
}

-- weapons = {[itemID] = {gta weapon time, ammunition (if manual (eg knife) then false), true the metal detector will not indicate it}}
fegyverek = {
	[14] = {30, 33}, 
	[15] = {31,33}, 
	[16] = {8,false},
	[17] = {24, 31},
	[18] = {5,false,true}, 
	[19] = {4,false}, 
	[20] = {3,false,true},
	[21] = {25, 32}, 
	[22] = {26, 32},
	[24] = {22,31},
	[25] = {34, 33}, 
	[26] = {33,33}, 
	[27] = {29, 31}, 
	[28] = {28, 31}, 
	[29] = {23, false,false,true}, 
	[30] = {32, 31}, 
	[34] = {41, 23},
	[35] = {42, false}, 
	[36] = {10, false,true},
	[37] = {9,false}, 
	[39] = {46,1},
	[68] = {11,false,true},
};

weaponPos = {
    [355] = 260, --Ak
    [356] = -60, --M4
    [349] = 270, --Shotgun
    [336] = -20, --Baseball Ütő 
    [339] = 10, --Katana
    [350] = -50, --Lefűrészelt
    [351] = 280, --Taktikai
    [353] = -50, --Mp5
    [357] = -80, --Vadászpuska
    [358] = -80, --Sniper
};

function weaponIDtoModel(id)
	local table = {
		[30] = 355,
		[31] = 356,
		[25] = 349,
		[5] = 336,
		[8] = 339,
		[26] = 350,
		[27] = 351,
		[29] = 353,
		[33] = 357,
		[34] = 358,
	}
	return table[id] or false;
end

vehicles_without_inventory = {
	[592] = true,
	[577] = true,
	[511] = true,
	[512] = true,
	[593] = true,
	[520] = true,
	[553] = true,
	[476] = true,
	[519] = true,
	[460] = true,
	[513] = true,
	[548] = true,
	[425] = true,
	[417] = true,
	[563] = true,
	[447] = true,
	[469] = true,
	[509] = true,
	[481] = true,
	[510] = true,
	[441] = true,
	[464] = true,
	[594] = true,
	[501] = true,
	[465] = true,	
	[564] = true,	
	[606] = true,	
	[607] = true,	
	[610] = true,	
	[584] = true,	
	[611] = true,	
	[608] = true,
	[435] = true,	
	[450] = true,	
	[591] = true,	
	[590] = true,	
	[538] = true,	
	[570] = true,	
	[569] = true,	
	[537] = true,	
	[449] = true,	
	[568] = true,	
	[424] = true,	
	[571] = true,	
	[471] = true,
	[539] = true,	
	[574] = true,	
	[485] = true,	
	[532] = true,		
	[530] = true,
	[432] = true,
	[572] = true,
	[583] = true,	
	[473] = true,	
}

vehicles_with_limited_inventory = {
	[581] = 5,
	[462] = 5,
	[521] = 5,
	[463] = 5,
	[522] = 5,
	[461] = 5,
	[448] = 5,
	[468] = 5,
	[586] = 5,			
}

function isVehicleHasInventory ( vehModel )
	if (tonumber(vehModel)) then
		if (vehicles_without_inventory[vehModel]) then
			return false;
		end
		return true;
	end
	return false;
end

function getElementItemMaxWeight(element)
    if getElementType(element) == "vehicle" then --Jármű
        return getVehicleMaxInventory(getElementModel(element));
    elseif getElementType(element) == "object" then --Széf
        return 50;
    elseif getElementType(element) == "player" then --Játékos
        return 30;
    end
end

function getVehicleMaxInventory(vehModel)
	if (tonumber(vehModel)) then
		if (vehicles_with_limited_inventory[vehModel]) then
			return vehicles_with_limited_inventory[vehModel]
		end
		return 50;
	end
	return 0;
end

function getItemName(id)
	if social_itemlista[id] then 
		return social_itemlista[id][1];
	else 
		return false;
	end
end

function tableCopy(tab, recursive)
    local ret = {}
    for key, value in pairs(tab) do
        if (type(value) == "table") and recursive then ret[key] = tableCopy(value)
        else ret[key] = value end
    end
    return ret
end

function getItemType(itemID)
	if social_itemlista[itemID] then 
		return social_itemlista[itemID][5];
	else 
		return false;
	end
end
function getItemWeight(itemID)
	if social_itemlista[itemID] then 
		return social_itemlista[itemID][4];
	else 
		return false;
	end
end

function isItemStackable(itemID)
	if social_itemlista[itemID] then 
		return social_itemlista[itemID][3];
	else 
		return false;
	end
end

function removeHex(text)
    return type(text)=="string" and string.gsub(text, "#%x%x%x%x%x%x", "") or text
end

function formatMoney(amount)
    amount = tonumber(amount);
    if not amount then 
        return "";
    end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

function checkUse(element)
	local found = false;
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v,"inventoryElement") == element then 
			found = v;
			break
		end
	end
	return found;
end

function getElementTypes(element)
	local type = getElementType(element);
	if type == "player" then 
		return "player","acc >> id";
	elseif type == "vehicle" then 
		return "vehicle","veh:id";
	elseif type == "object" then 
		return "safe","safe.id";
	end
end


--New
function hasElementItemPlace(element,itemID, count)
	if not count then count = 1 end;
	local items = getElementData(element,"itemsTable");
    local kilo = getItemWeight(itemID) * count;
    local max = getElementItemMaxWeight(element);
    local current = 0;
    local result = 1;
    if items then 
        for i=1, slots do 
            if items[i] then 
                current = current + (getItemWeight(items[i][1]) * items[i][3]);
            end
        end
    end
    if current >= max or current+kilo > max then 
        result = false;
    else 
        for i=1, slots do 
            if items and not items[i] then 
                result = i;
                break
            end
        end
    end
    if items[result] then  
        result = false;
    end
    return result;
end

function hasPlayerItemPlace(player, itemID, count)
    if not count then count = 1 end;
    local items = getElementData(player,"itemsTable");
    local kilo = getItemWeight(itemID) * count;
    local itemType = getItemType(itemID);
    local max = getElementItemMaxWeight(player);
    local current = 0;
    local result = 1;
    if items[itemType] then 
        for i=1, slots do 
            items = getElementData(player,"itemsTable");
            if items[itemType][i] then 
                current = current + (getItemWeight(items[itemType][i][1]) * items[itemType][i][3]);
            end
        end
    end
    if current >= max or current+kilo > max then 
        result = false;
    else 
        for i=1, slots do 
            items = getElementData(player,"itemsTable");
            if items[itemType] and not items[itemType][i] then 
                result = i;
                break
            end
        end
    end
    items = getElementData(player,"itemsTable");
    if items[itemType][result] then  
        result = false;
    end
    return result;
end