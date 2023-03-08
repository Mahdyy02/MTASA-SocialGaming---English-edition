--
-- _handling_common.lua
--

bIsClient = getLocalPlayer ~= nil
bIsServer = not bIsClient
sideName = bIsClient and "Client" or "Server"

---------------------------------------------------------------------
-- Read handling lines from file and set all models to match
---------------------------------------------------------------------
function readHandlingCfg( filename )
	local handlingTable = {}

	local hReadFile = fileOpen( filename )
	if not hReadFile then
		outputInfo( sideName .. " - No custom handling file" )
		return handlingTable
	end

	local lineNumber = 0
	local linesRead = 0
	local linesCustomized = 0
	local buffer = ""
	while true do

		local endpos = string.find(buffer, "\n")

		-- If can't find CR, try to load more from the file
		if not endpos then
			if fileIsEOF( hReadFile ) then
				break
			end
			buffer = buffer .. fileRead( hReadFile, 500 )
		end

		if endpos then
			-- Process line
			lineNumber = lineNumber + 1
			local line = string.sub(buffer, 1, endpos - 1)
			buffer = string.sub(buffer, endpos + 1)

			-- Is a handling line
			if string.sub(line,1,1) >= 'A' and string.sub(line,1,1) <= 'Z' then

				line = string.gsub(line, "\t", " ")
				local p = split(line,' ')
				local bFail = false

				if #p ~= 36 then
					outputDebug( "Line "..tostring(lineNumber).." has "..#p.." parts. Expected 36. (" .. string.sub(line,1,20) .. "...)" )
					bFail = true
				end

				local modelId = getVehicleModelFromHandlingName ( p[1] )
				if not modelId then
					bFail = true
				end

				if not bFail then
					linesRead = linesRead + 1

					-- Reduce size of data
					p[1] = modelId

					for i=2,#p do
						if i == 20 then
							p[i] = (tonumber(p[i]) ~= 0)	-- ABS
						elseif i == 14 then
							p[i] = tonumber(p[i]) / 2.5		-- engineAcceleration
						elseif i == 16 then
							p[i] = driveTypeTable[p[i]]		-- driveType
						elseif i == 17 then
							p[i] = engineTypeTable[p[i]]	-- engineType
						elseif i == 32 or i == 33 then
							p[i] = string.sub(tostring(p[i]),-8)	-- modelFlags/handlingFlags (leave as string)
						elseif i == 31 or i == 34 or i == 35 then
							p[i] = nil						-- monetary/headLight/tailLight (unused)
						else
							p[i] = tonumber(p[i])			-- number
						end
					end

					-- Copy to list if line is not the same as std handling
					if not isOriginalHandling( p ) then 
						handlingTable[modelId] = p
						linesCustomized = linesCustomized + 1
					end
				end
			end
		end
	end
	fileClose(hReadFile)
	outputInfo( sideName .. " loaded:"
		.. " linesRead:".. tostring(linesRead)
		.. " linesCustomized:".. tostring(linesCustomized)
		)
	return handlingTable
end


---------------------------------------------------------------------
-- Is handle line the same as GTA default
---------------------------------------------------------------------
function isOriginalHandling(handlingLine)
	local modelId = handlingLine[1]
	local orig = getOriginalHandling(modelId)
	for i=1,#props,2 do
		local name = props[i]
		local idx = props[i+1]
		local origValue = orig[name]
		local testValue = handlingLine[idx]
		if idx==32 or idx==33 then	-- modelFlags/handlingFlags
			testValue = tonumber("0x"..string.sub(tostring(testValue),-8))
		end
		if not isEqualish( origValue, testValue ) then
			--outputDebug(""
			--	.. " id:".. tostring(modelId)
			--	.. " name:".. tostring(name)
			--	.. " orig:".. tostring(origValue)
			--	.. " test:".. tostring(testValue)
			--	.. " idx:".. tostring(idx)
			--	)
			return false
		end
	end

	local name = "centerOfMass"
	local torigValue = orig["centerOfMass"]
	local ttestValue = { handlingLine[5], handlingLine[6], handlingLine[7] }
	for c=1,3 do
		local origValue = torigValue[c]
		local testValue = ttestValue[c]
		if not isEqualish( origValue, testValue ) then
			--outputDebug(""
			--	.. " id:".. tostring(modelId)
			--	.. " name:".. tostring(name)
			--	.. " orig:".. tostring(origValue)
			--	.. " test:".. tostring(testValue)
			--	.. " c:".. tostring(c)
			--	)
			return false
		end
	end
	return true
end


---------------------------------------------------------------------
-- Is virtually the same value
---------------------------------------------------------------------
function isEqualish(a,b)
	local na = tonumber(a)
	local nb = tonumber(b)
	if na and nb then
		local dif = math.abs( na - nb )
		local thresh = math.abs( na / 10000000 )
		if dif < thresh then
			return true
		end
	end
	return string.lower(tostring(a)) == string.lower(tostring(b))
end


props = {
		"mass", 2,
		"turnMass", 3,
		"dragCoeff", 4,
		--"centerOfMass", { 5, 6, 7 } )
		"percentSubmerged", 8,
		"tractionMultiplier", 9,
		"tractionLoss", 10,
		"tractionBias", 11,
		"numberOfGears", 12,
		"maxVelocity", 13,
		"engineAcceleration", 14,
		"engineInertia", 15,
		"driveType", 16,
		"engineType", 17,
		"brakeDeceleration", 18,
		"brakeBias", 19,
		"ABS", 20,
		"steeringLock", 21,
		"suspensionForceLevel", 22,
		"suspensionDamping", 23,
		"suspensionHighSpeedDamping", 24,
		"suspensionUpperLimit", 25,
		"suspensionLowerLimit", 26,
		"suspensionFrontRearBias", 27,
		"suspensionAntiDiveMultiplier", 28,
		"seatOffsetDistance", 29,
		"collisionDamageMultiplier", 30,
		--"monetary", 31,
		"modelFlags", 32,
		"handlingFlags", 33,
		--"headLight", 34,
		--"tailLight", 35,
		"animGroup", 36,
		}


driveTypeTable = { ["R"]="rwd", ["F"]="fwd", ["4"]="awd" }
engineTypeTable = { ["P"]="petrol", ["D"]="diesel", ["E"]="electric" }


bigTable = {
	400, "LANDSTAL", 
	401, "BRAVURA", 
	402, "BUFFALO", 
	403, "LINERUN", 
	404, "PEREN", 
	405, "SENTINEL", 
	406, "DUMPER", 
	407, "FIRETRUK", 
	408, "TRASH", 
	409, "STRETCH", 
	410, "MANANA", 
	411, "INFERNUS", 
	412, "VOODOO", 
	413, "PONY", 
	414, "MULE", 
	415, "CHEETAH", 
	416, "AMBULAN", 
	417, "LEVIATHN", 
	418, "MOONBEAM", 
	419, "ESPERANT", 
	420, "TAXI", 
	421, "WASHING", 
	422, "BOBCAT", 
	423, "MRWHOOP", 
	424, "BFINJECT", 
	425, "HUNTER", 
	426, "PREMIER", 
	427, "ENFORCER", 
	428, "SECURICA", 
	429, "BANSHEE", 
	430, "PREDATOR", 
	431, "BUS", 
	432, "RHINO", 
	433, "BARRACKS", 
	434, "HOTKNIFE", 
	435, "ARTICT1", 
	436, "PREVION", 
	437, "COACH", 
	438, "CABBIE", 
	439, "STALLION", 
	440, "RUMPO", 
	441, "RCBANDIT", 
	442, "ROMERO", 
	443, "PACKER", 
	444, "MONSTER", 
	445, "ADMIRAL", 
	446, "SQUALO", 
	447, "SEASPAR", 
	448, "MOPED", 
	449, "TRAM", 
	450, "ARTICT2", 
	451, "TURISMO", 
	452, "SPEEDER", 
	453, "REEFER", 
	454, "TROPIC", 
	455, "FLATBED", 
	456, "YANKEE", 
	457, "GOLFCART", 
	458, "SOLAIR", 
	459, "TOPFUN", 
	460, "SEAPLANE", 
	461, "BIKE", 
	462, "MOPED", 
	463, "FREEWAY", 
	464, "RCBARON", 
	465, "RCRAIDER", 
	466, "GLENDALE", 
	467, "OCEANIC", 
	468, "DIRTBIKE", 
	469, "SPARROW", 
	470, "PATRIOT", 
	471, "QUADBIKE", 
	472, "COASTGRD", 
	473, "DINGHY", 
	474, "HERMES", 
	475, "SABRE", 
	476, "RUSTLER", 
	477, "ZR350", 
	478, "WALTON", 
	479, "REGINA", 
	480, "COMET", 
	481, "BMX", 
	482, "BURRITO", 
	483, "CAMPER", 
	484, "MARQUIS", 
	485, "BAGGAGE", 
	486, "DOZER", 
	487, "MAVERICK", 
	488, "COASTMAV", 
	489, "RANCHER", 
	490, "FBIRANCH", 
	491, "VIRGO", 
	492, "GREENWOO", 
	493, "CUPBOAT", 
	494, "HOTRING", 
	495, "SANDKING", 
	496, "BLISTAC", 
	497, "POLMAV", 
	498, "BOXVILLE", 
	499, "BENSON", 
	500, "MESA", 
	501, "RCGOBLIN", 
	502, "HOTRING", 
	503, "HOTRING", 
	504, "BLOODRA", 
	505, "RANCHER", 
	506, "SUPERGT", 
	507, "ELEGANT", 
	508, "JOURNEY", 
	509, "CHOPPERB", 
	510, "MTB", 
	511, "BEAGLE", 
	512, "CROPDUST", 
	513, "STUNT", 
	514, "PETROL", 
	515, "RDTRAIN", 
	516, "NEBULA", 
	517, "MAJESTIC", 
	518, "BUCCANEE", 
	519, "SHAMAL", 
	520, "HYDRA", 
	521, "FCR900", 
	522, "NRG500", 
	523, "HPV1000", 
	524, "CEMENT", 
	525, "TOWTRUCK", 
	526, "FORTUNE", 
	527, "CADRONA", 
	528, "FBITRUCK", 
	529, "WILLARD", 
	530, "FORKLIFT", 
	531, "TRACTOR", 
	532, "COMBINE", 
	533, "FELTZER", 
	534, "REMINGTN", 
	535, "SLAMVAN", 
	536, "BLADE", 
	537, "FREIGHT", 
	538, "STREAK", 
	539, "VORTEX", 
	540, "VINCENT", 
	541, "BULLET", 
	542, "CLOVER", 
	543, "SADLER", 
	544, "FIRETRUK", 
	545, "HUSTLER", 
	546, "INTRUDER", 
	547, "PRIMO", 
	548, "CARGOBOB", 
	549, "TAMPA", 
	550, "SUNRISE", 
	551, "MERIT", 
	552, "UTILITY", 
	553, "NEVADA", 
	554, "YOSEMITE", 
	555, "WINDSOR", 
	556, "MTRUCK_A", 
	557, "MTRUCK_B", 
	558, "URANUS", 
	559, "JESTER", 
	560, "SULTAN", 
	561, "STRATUM", 
	562, "ELEGY", 
	563, "RAINDANC", 
	564, "RCTIGER", 
	565, "FLASH", 
	566, "TAHOMA", 
	567, "SAVANNA", 
	568, "BANDITO", 
	569, "FREIFLAT", 
	570, "CSTREAK", 
	571, "KART", 
	572, "MOWER", 
	573, "DUNE", 
	574, "SWEEPER", 
	575, "BROADWAY", 
	576, "TORNADO", 
	577, "AT400", 
	578, "DFT30", 
	579, "HUNTLEY", 
	580, "STAFFORD", 
	581, "BF400", 
	582, "NEWSVAN", 
	583, "TUG", 
	584, "PETROTR", 
	585, "EMPEROR", 
	586, "WAYFARER", 
	587, "EUROS", 
	588, "HOTDOG", 
	589, "CLUB", 
	590, "FREIFLAT", 
	591, "ARTICT3", 
	592, "ANDROM", 
	593, "DODO", 
	594, "RCCAM", 
	595, "LAUNCH", 

	596, "POLICE_LA", 
	597, "POLICE_SF", 
	598, "POLICE_VG", 
	599, "POLRANGER", 

	600, "PICADOR", 
	601, "SWATVAN", 
	602, "ALPHA", 
	603, "PHOENIX", 
	604, "GLENDALE", 
	605, "SADLER", 
	606, "BAGBOXA", 
	607, "BAGBOXB", 
	608, "STAIRS", 
	609, "BOXBURG", 
	610, "FARM_TR1", 
	611, "UTIL_TR1",
	}

ignoreNames = {
	["AIRTRAIN"]=1,
	["BLOODRB"]=1,
	["RANGER"]=1,
	["FLOAT"]=1,
	["ROLLER"]=1,
	["WAYFARER"]=1,
	["RIO"]=1,
	}

---------------------------------------------------------------------
-- getVehicleModelFromHandlingName
--   Handling file vehicle name to model id
---------------------------------------------------------------------
function getVehicleModelFromHandlingName(name)
	if ignoreNames[name] then
		return false
	end
	for i=1,#bigTable,2 do
		if bigTable[i+1] == name then
			return bigTable[i]
		end
	end
	outputDebug( "Can't find vehicle for handling name " .. name )
	return false
end

---------------------------------------------------------------------
-- outputs
---------------------------------------------------------------------
function outputInfo(msg)
	outputChatBox(msg)
end

function outputDebug(msg)
	outputDebugString(msg)
end
