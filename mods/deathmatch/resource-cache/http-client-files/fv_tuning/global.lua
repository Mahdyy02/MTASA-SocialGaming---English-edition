white = "#FFFFFF";

markerPos = {
    {2519.7255859375, -1529.4329833984, 23.883577346802},
    {2508.5712890625, -1531.9959716797, 23.861217498779},
    {1786.1501464844, -1777.0715332031, 13.542447090149},
    {1775.1501464844, -1777.0715332031, 13.542447090149},
};

menu = {
    [1] = {
        name = "Performance",
        ["submenu"] = {
            {"Motor",
                {
                    {"Factory",0,false, {{"engineAcceleration", 0}, {"maxVelocity", 0}}},
                    {"Street",50000,false, {{"engineAcceleration", 5}, {"maxVelocity", 5}}},
                    {"Race",100000,false, {{"engineAcceleration", 10}, {"maxVelocity", 10}}},
                    {"Professional",150000,false, {{"engineAcceleration", 15}, {"maxVelocity", 15}}},
                    {"Premium",1000,true, {{"engineAcceleration", 20}, {"maxVelocity", 35}}},
                }
            },
            {"Shift",{
                    {"Factory",0,false,{{"engineAcceleration", 0}}},
                    {"Street",50000,false,{{"engineAcceleration", 10}}},
                    {"Race",100000,false,{{"engineAcceleration", 15}}},
                    {"Professional",150000,false,{{"engineAcceleration", 20}}},
                    {"Premium",1000,true,{{"engineAcceleration", 30}}},
                }
            },
            {"Chip",{
                    {"Factory",0,false,{{"maxVelocity", 0}}},
                    {"Street",50000,false,{{"maxVelocity", 2}}},
                    {"Race",100000,false,{{"maxVelocity", 5}}},
                    {"Professional",150000,false,{{"maxVelocity", 10}}},
                    {"Premium",1000,true,{{"maxVelocity", 20}}},
                }
            },
            {"Brakes",{
                    {"Factory",0,false,{{"brakeDeceleration", 0}, {"brakeBias", 0}}},
                    {"Street",50000,false,{{"brakeDeceleration", 0.15}, {"brakeBias", 0.05}}},
                    {"Race",100000,false,{{"brakeDeceleration", 0.20}, {"brakeBias", 0.10}}},
                    {"Professional",150000,false,{{"brakeDeceleration", 0.25}, {"brakeBias", 0.20}}},
                    {"Premium",1000,true,{{"brakeDeceleration", 0.6}, {"brakeBias", 0.6}}},
                },
                cam = 1,
            },
            {"Wheels",{
                    {"Factory",0,false,{{"tractionMultiplier", 0}, {"tractionLoss", 0}}},
                    {"Street",50000,false,{{"tractionMultiplier", 0.1}, {"tractionLoss", 0.005}}},
                    {"Race",100000,false,{{"tractionMultiplier", 0.2}, {"tractionLoss", 0.010}}},
                    {"Professional",150000,false,{{"tractionMultiplier", 0.3}, {"tractionLoss", 0.015}}},
                    {"Premium",1000,true,{{"tractionMultiplier", 0.6}, {"tractionLoss", 0.08}}},
                },
                cam = 2,
            },
            {"Turbo",{
                    {"Factory",0,false, {{"engineAcceleration", 0}, {"maxVelocity", 0}}},
                    {"Street",50000,false, {{"engineAcceleration", 10}, {"maxVelocity", 3}}},
                    {"Race",100000,false, {{"engineAcceleration", 15}, {"maxVelocity", 7}}},
                    {"Professional",150000,false, {{"engineAcceleration", 20}, {"maxVelocity", 10}}},
                    {"Premium",1500,true, {{"engineAcceleration", 25}, {"maxVelocity", 20}}},
                }
            },
        };
    },
    [2] = {
        name = "Optic",
        ["submenu"] = {
            {"Wheels cover",12},
            {"Spoiler",2},
            {"Exhaust",13},
            {"Front Bumper",14},
            {"Rear bumper",15},
            {"Sill",3},
            {"Roof",7},
        },
        cost = 20000,
    },
    [3] = {
        name = "Coloring",
        ["submenu"] = {
            {"Color 1",{"Painting",20000},"color1"},
            {"Color 2",{"Painting",20000},"color2"},
            {"Lámpa Color",{"Coloring",25000},"headlight"},
            {"PaintJob",4,3000},
        }
    },
    [4] = {
        name = "Extras",
        ["submenu"] = {
            {"Front Wheel Width",{
                    {"Factory",0,false,"default"},
                    {"Very Narrow",60000,false,"verynarrow"},
                    {"Narrow",60000,false,"narrow"},
                    {"Wide",60000,false,"wide"},
                    {"Extra Wide",60000,false,"extrawide"},
                },
                cam = 4,
                side = "front",
            },
            {"Rear Wheel Width",{   
                    {"Factory",0,false,"default"},
                    {"Very Narrow",60000,false,"verynarrow"},
                    {"Narrow",60000,false,"narrow"},
                    {"Wide",60000,false,"wide"},
                    {"Extra Wide",60000,false,"extrawide"},
                },
                cam = 3,
                side = "rear",
            },
            {"Neon",{
                    {"Nothing",0,false,"false"},
                    {"White",5000,true,"white"},    
                    {"Blue",5000,true,"blue"},    
                    {"Red",5000,true,"red"},    
                    {"Pink",5000,true,"pink"},    
                    {"Yellow",5000,true,"orange"},    
                    {"Green",5000,true,"green"},    
                },
            },
            {"License plate number",{"Setting",2000,true}},
            {"Propulsion",{
                    {"Front wheel drive",100000,false,"fwd"},
                    {"Rear wheel drive",100000,false,"rwd"},
                    {"All wheel drive",250000,false,"awd"},
                }
            },
            {"LSD Door",{
                    {"Nothing",0,false,false},
                    {"Installation",3000,true,true},
                }
            },
            {"Wheel angle",{
                    {"Factory",0,false,0},
                    {"30°",100000,false,30},
                    {"40°",120000,false,40},
                    {"50°",140000,false,50},
                    {"60°",160000,false,60},
                    {"70°",180000,false,70},
                }
            },
            {"Variant",{
                    {"Factory",0,false,0},
                    {"Variant 1",15000,false,1},
                    {"Variant 2",15000,false,2},
                    {"Variant 3",15000,false,3},
                    {"Variant 4",15000,false,4},
                    {"Variant 5",15000,false,5},
                    {"Variant 6",15000,false,6},
                }
            },
            {"Air-Ride",{
                    {"Packaging",0,false,false},
                    {"Installation",50000,false,true},
                }
            },
        }
    },
    [5] = {
        name = "Exit",
        exit = true,
    }
}

paintjobs = {
    ["stickers"] = {"all","*remap*"},
    ["stickers2"] = {"all","*remap*"},
    ["gold"] = {"all","*remap*"},
    ["race"] = {"all","*remap*"},
    ["carbon"] = {"all","*remap*"},
    ["lava"] = {"all","*remap*"},
    ["digital"] = {"all","*remap*"},
    ["elegy1"] = {"562","*remap*"},
    ["elegy2"] = {"562","*remap*"},
    ["elegy3"] = {"562","*remap*"},
    ["elegy4"] = {"562","*remap*"},
    ["sultan1"] = {"560","*remap_impreza*"},
    ["sultan2"] = {"560","*remap_impreza*"},
    ["sultan3"] = {"560","*remap_impreza*"},
    ["uranus1"] = {"558","*remap*"},
    ["uranus2"] = {"558","*remap*"},
    ["uranus3"] = {"558","*remap*"},

    ["sheriff1_427"] = {"427", "*body*"},
    ["sheriff1_596"] = {"596", "*LAPD*"},
    ["sheriff2_596"] = {"596", "*LAPD*"},
    ["sheriff3_596"] = {"596", "*LAPD*"},
    ["fire1_596"] = {"596", "*LAPD*"},
    ["sheriff1_597"] = {"597", "*LAPD*"},
    ["sheriff2_597"] = {"597", "*LAPD*"},
    ["sheriff3_597"] = {"597", "*LAPD*"},
    ["fire1_597"] = {"597", "*LAPD*"},
    ["sheriff1_598"] = {"598", "*SCPD*"},
    ["sheriff2_598"] = {"598", "*SCPD*"},
    ["sheriff1_490"] = {"490", "*remaplandstalbody256*"},
}

neons = {
    ["white"] = 14399,
    ["blue"] = 14400,
    ["red"] = 14401,
    ["pink"] = 14402,
    ["orange"] = 14403,
    ["green"] = 14404,
};

function getPaintJobs(veh)
    local model = getElementModel(veh);
    local temp = {};
    table.insert(temp,{"none","all","*remap*"});
    for k,v in pairs(paintjobs) do 
        if tostring(v[1]) == "all" or tonumber(v[1]) == model then 
            table.insert(temp,{k,unpack(v)});
        end
    end
    return temp;
end

function formatMoney(amount)
    amount = tonumber(amount);
    if not amount then 
        return 0;
    end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function getPerformanceName(value)
    local names = {
        [1] = "Factory",
        [2] = "Street",
        [3] = "Race",
        [4] = "Professional",
        [5] = "Premium",
    }
    return names[value] or "Factory";
end