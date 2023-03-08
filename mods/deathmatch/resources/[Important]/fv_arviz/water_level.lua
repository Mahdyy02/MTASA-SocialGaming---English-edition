level = 0
highlevel = 0
floodWater1 = 0

function setAllWatersLevel(level)
	setWaterLevel(level)
	if isElement(floodWater1) then
		if (getElementType(floodWater1) == "water") then
			if (level > 0.2) then
				setWaterLevel(floodWater1, level)
			else
				setWaterLevel(floodWater1, -500)
			end
		end
	end
end

function checkLevel(glevel)
	local allow_negative = get("allow_negative")
	if ((allow_negative == "false") and (tonumber(glevel) < 0)) then
		return false
	end
	return true
end

function setFloodWeather()
	local flood_weather = get("flood_weather")
	if (flood_weather ~= "") then
		setWeather(tonumber(flood_weather))
	end
end

function setFloodEndWeather()
	local flood_end_weather = get("flood_end_weather")
	if (flood_end_weather ~= "") then
		setWeather(tonumber(flood_end_weather))
	end
end

function waterLevel ( source,  glevel )
	if ( checkLevel(glevel) == true ) then
		highlevel = tonumber ( glevel )
		if (highlevel == nil) then
			highlevel = 0
		end
		if (highlevel ~= level) then
			if ( isTimer(waterTimer)) then
				killTimer(waterTimer)
			end
			--water is going up
			if (highlevel > level) then
				setFloodWeather()
				waterTimer = setTimer ( addSomeWater, 100, 0, highlevel )
				
			else --water is going down
				setFloodEndWeather()
				waterTimer = setTimer ( removeSomeWater, 100, 0, highlevel )
				
			end
			outputDebugString ( "Water Level changed by " .. getPlayerName ( source ) .. " to a level " .. highlevel .. ".", 3 )
		end
	end
end
addEvent( "onWaterLevel", true )
addEventHandler( "onWaterLevel", getRootElement(), waterLevel )

function showClientGui(source, command, highlevel)
	local neg = get("allow_negative")
	if getElementData(source, "admin >> level") > 11 then
		triggerClientEvent( source, "onShowWindow", getRootElement(), level, neg, highlevel)
	end
end
addCommandHandler("water", showClientGui)

function addSomeWater ( highlevel )
	local thelevel = level
	local speed = tonumber(get("speed"))
	level = thelevel + tonumber(speed)

	setAllWatersLevel(level)
	
	if (level >= highlevel) then
		level = highlevel
		if ( isTimer(waterTimer)) then
			killTimer(waterTimer)
		end
		setFloodEndWeather()
	end
end

function removeSomeWater ( highlevel )
	local thelevel = level
	local speed = tonumber(get("speed"))
	level = thelevel - speed
	
	setAllWatersLevel(level)
	
	if (level <= highlevel) then
		level = highlevel
		if ( isTimer(waterTimer)) then
			killTimer(waterTimer)
		end
	end
end

function initialize()
	setWaterLevel(0)
	floodWater1 = createWater ( -2998, -2998, -500, 2998, -2998, -500, -2998, 2998, -500, 2998, 2998, -500)
end
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), initialize)

function destroy()
	if ( isTimer(waterTimer)) then
		killTimer(waterTimer)
	end
	setWaterLevel(floodWater1, -500)
	setWaterLevel(0)
	setFloodEndWeather()
end
addEventHandler ( "onResourceStop", getRootElement(), destroy)

function onPlayerJoin()
	setAllWatersLevel(level)
end
addEventHandler( "onPlayerJoin", getRootElement(), onPlayerJoin )