colors = {
    --['colorname'] = {r, g, b, hex},
    ['red'] = {220, 73, 73, "#dc4949"},
	['green'] = {113, 208, 36, "#71d024"},
    ['blue'] = {51, 153, 255,"#3399ff"},
	['blue2'] = {36, 109, 208, "#246dd0"},
	['yellow'] = {208, 153, 36, "#d09924"},
    ["orange"] = {255, 153, 51, "#ff9933"},
    ['lightyellow'] = {255, 209, 26, "#ffd11a"},
    ["servercolor"] = {202, 35, 35, "#ca2323"}
}

serverColor = 'servercolor'
serverName = 'TheDevils'
hexCode = colors[serverColor][4]
low = hexCode .. '[' .. serverName .. '] #FFFFFF'
local serverSide = false
addEventHandler("onResourceStart", resourceRoot,
    function()
        serverSide = true
    end
)

serverData = {
    ['developer'] = 'CouldnoT',  
    ['owner'] = ' & Omar ',
	['version'] = "1.0",
    ['name'] = serverName,
    ['color'] = serverColor,
    ['web'] = "thedevils.com",
	['mod'] = 'The Devils',
	['city'] = 'Los Santos',
	['minScreenSize'] = {1280,720},
	['defaultBlurLevel'] = 0,
	['syntax'] = low,
}

function getVersion()
    return serverData["version"]
end

function converType(t)
    if t == "error" then
        return 'red'
    elseif t == "info" then
        return 'blue'
    elseif t == "warning" then
        return serverColor
    elseif t == "success" then
        return 'green'
    end
    
    return nil
end

function getServerSyntax(extra, t)
    if extra and type(extra) == "string" then
        if t then
            if colors[t] then
                return colors[t][4] .. '[' .. serverName .. ' - ' .. extra .. '] #FFFFFF'
            else
                return colors[converType(t)][4] .. '[' .. serverName .. ' - ' .. extra .. '] #FFFFFF'
            end
        else
            return hexCode .. '[' .. serverName .. ' - ' .. extra .. '] #FFFFFF'
        end
    else
        if t then
            if colors[t] then
                return colors[t][4] .. '[' .. serverName .. '] #FFFFFF'
            else
                return colors[converType(t)][4] .. '[' .. serverName .. '] #FFFFFF'
            end
        else
            return serverData['syntax']
        end
    end
end

local fSyntax = getServerSyntax(false, "success")

function findPlayer(sourcePlayer, id)
    
    if id == "*" or utfSub(id, 1, 1) == "*" then
        return sourcePlayer
    end
    
    local table = {}
    for k,v in pairs(getElementsByType("player")) do
        local name = string.lower(getElementData(v, "char >> name") or getPlayerName(v))
        local logged = false
        if utfSub(name, 1, #id) == string.lower(id) then
            table[#table + 1] = {v, name}
            logged = true
        end
        local adminname = string.lower(exports['fv_admin']:getAdminName(v) or "---ISMERETLEN---")
        if utfSub(adminname, 1, #id) == string.lower(id) and not logged then
            table[#table + 1] = {v, adminname}
            logged = true
        end
        local number = tonumber(getElementData(v, "char >> id")) or -1
        local number2 = tonumber(id) or -2
        if number == number2 and not logged then
            table[#table + 1] = {v, adminname}
            logged = true
        end
    end
    
    if #table == 0 then

    elseif #table == 1 then
        return table[1][1]
    elseif #table > 1 then
        if serverSide then
            outputChatBox(fSyntax .. "Találatok: ("..id.."-ra/re)", sourcePlayer, 255, 255, 255, true)
            for k,v in pairs(table) do
                local name = v[2]
                local id = getElementData(v[1], "char >> id")
                outputChatBox(name .. "("..id..")", sourcePlayer, 255, 255, 255, true)
            end
        else
            outputChatBox(fSyntax .. "Találatok: ("..id.."-ra/re)", 255, 255, 255, true)
            for k,v in pairs(table) do
                local name = v[2]
                local id = getElementData(v[1], "char >> id")
                outputChatBox(name .. "("..id..")", 255, 255, 255, true)
            end
        end
    end
    
    return false
end

function getServerColor(color, hexCode)
    if not hexCode then
	    local r,g,b = colors[serverColor][1], colors[serverColor][2], colors[serverColor][3]
		if color and colors[color] then
		    r,g,b = colors[color][1], colors[color][2], colors[color][3]
		end
		return r,g,b
	else
	    local hex = colors[serverColor][4]
		if color and colors[color] then
		    hex = colors[color][4]
		end
		return hex
	end
end

function getServerData(dataName)
    local data = 'unknown'
    if dataName then
	    local value = serverData[dataName]
	    if value then
		    data = value
		end
	end
	return data
end

function getMinScreenSize() 
    return serverData['minScreenSize']
end

local times = {
    ['month'] = {
	    [0] = "Január",
		[1] = "Febrár", 
		[2] = "Március", 
		[3] = "Április", 
		[4] = "Május",
		[5] = "Június",
		[6] = "Júlis", 
		[7] = "Augusztus",
		[8] = "Szeptember",
		[9] = "Október",
		[10] = "November",
		[11] = "December",
	},
    ['week'] = {
	    [0] = "Vasárnap",
		[1] = "Hétfő", 
		[2] = "Kedd", 
		[3] = "Szerda", 
		[4] = "Csütörtök",
		[5] = "Péntek",
		[6] = "Szombat", 
	},
}

local _getElementType = getElementType
function getElementType(element)
    if _getElementType(element) == "player" then
        return 1, "player"
    elseif _getElementType(element) == "vehicle" then
        return 2, "vehicle"
    elseif _getElementType(element) == "object" then
        return 3, "object"
    else
        return 4, _getElementType(element)
    end
end

local elementData = {
    [1] = "char >> id",
    [2] = "vehicle >> id",
    [3] = "object >> id",
}

function getElementIDName(element)
    local elementid = elementData[getElementType(element)]
    if elementid then
        return elementid
    end
    return -1
end

function getElementID(element)
    local elementid = elementData[getElementType(element)]
    if elementid then
        return tonumber(getElementData(element, elementid) or -1)
    end
    return -1
end

function getTimeStringByNumber(timevalue, number)
    if times[timevalue] and times[timevalue][number] then
	    return times[timevalue][number]
	end
	return false
end

-----------STRING FUNKCIÓK-----------
function stringInsert(value, insert, place)
	local isLen = string.len(value)
	if isLen > place then
		return string.sub(value, 1,place-1) .. tostring(insert) .. string.sub(value, place, string.len(value))
	else
		return value
	end
end

function split(s)
	local newString = s
	newString = stringInsert(newString, "\n", 34)
	newString = stringInsert(newString, "\n", 68)
	newString = stringInsert(newString, "\n", 102)
	newString = stringInsert(newString, "\n", 136)
	newString = stringInsert(newString, "\n", 170)
	newString = stringInsert(newString, "\n", 204)
	newString = stringInsert(newString, "\n", 238)
    return newString
end

function modifyString(str)
	if str then
		return tostring(split(str))
	end
end

function math.round(number, decimals, method) 
    decimals = decimals or 0 
    local factor = 10 ^ decimals 
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor 
    else return tonumber(("%."..decimals.."f"):format(number)) end 
end 

function thousandsStepper(amount)
	local formatted = amount
	
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
		if (k==0) then
			break
		end
	end

	return formatted
end

function table.val_to_str ( v )
	if "string" == type( v ) then
		v = string.gsub( v, "\n", "\\n" )
		if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
			return "'" .. v .. "'"
		end
		return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
	else
		return "table" == type( v ) and table.tostring( v ) or tostring( v )
	end
end

function table.key_to_str ( k )
	if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
		return k
	else
		return "[" .. table.val_to_str( k ) .. "]"
	end
end

function table.tostring(tbl)
	local result, done = {}, {}
	for k, v in ipairs( tbl ) do
		table.insert( result, table.val_to_str( v ) )
		done[ k ] = true
	end
	for k, v in pairs( tbl ) do
		if not done[ k ] then
			table.insert( result,
			table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
		end
	end
	return "{" .. table.concat( result, "," ) .. "}"
end

function getTreeCentre(model)
	if model == 7607 then
		return 0, 0, 0
	elseif model == 7608 then
		return -2, 0, 0
	elseif model == 7637 then
		return -1, 0, 0
	elseif model == 7638 then
		return 0, 0, 0
	end
end

function getTreeStart(model)
	if model == 7607 then
		return 1, 0, 0
	elseif model == 7608 then
		return 0, 0, 0
	elseif model == 7637 then
		return 2, 0, 0
	elseif model == 7638 then
		return 4, 0, 0
	end
end

function getTreeEnd(model)
	if model == 7607 then
		return -1, 0, 0
	elseif model == 7608 then
		return -4, 0, 0
	elseif model == 7637 then
		return -4, 0, 0
	elseif model == 7638 then
		return -4, 0, 0
	end
end

function getRealGroundPosition(x, y, z)
	local hit, hitX, hitY, hitZ = processLineOfSight(x, y, z+10, x, y, z-10, true, false, false, true)
	if hit then
		return hitZ
	else
		return nil
	end
end

function toFloor(num)
	return tonumber(string.sub(tostring(num), 0, -2)) or 0
end

local firstName = { "Michael","Christopher","Matthew","Joshua","Jacob","Andrew","Daniel","Nicholas","Tyler","Joseph","David","Brandon","James","John","Ryan","Zachary","Justin","Anthony","William","Robert", "Dean", "George", "Norman", "Lloyd", "Dennis", "Seymour", "Willie", "Richard", "Bobby", "Jody", "Danny", "Seth", "Tommy", "Timothy", "Junior"}
local lastName = { "Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark", "Hummer", "Smith", "Touchet", "Trotter", "Nagle", "Dunbar", "Davis", "Grenier", "Duff", "Alston", "Winslow", "Borunda", "Duncan", "Heath", "Keeler", "Skinner", "Daniel", "Layfield", "Decker", "Ames", "Christie" }

function createRandomMaleName()
	local random1 = math.random(1, #firstName)
	local random2 = math.random(1, #lastName)
	local name = firstName[random1].." "..lastName[random2]
	return name
end

function getRealTimeForIPB(time)
	local time = getRealTime(time)
	local str = ""
	if (time.hour < 10) then
		str = "0"..time.hour
	else
		str = time.hour
	end
	if (time.minute < 10) then
		str = str..":0"..time.minute
	else
		str = str..":"..time.minute
	end
	if (time.second < 10) then
		str = str..":0"..time.second
	else
		str = str..":"..time.second
	end
	return str
end

local jobs = {
    --[id] = "JobName"
    [0] = "Munkanélküli"
}

function convertJobIDtoName(id)
    return jobs[id]
end

dataKey = md5("sgaming");
function getKey()
	return dataKey;
end