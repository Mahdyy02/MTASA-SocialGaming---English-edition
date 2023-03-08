--SocialGaming 2019--
function updateTime()
	local realtime = getRealTime()
	hour = realtime.hour + 2
	if hour >= 24 then
		hour = hour - 24
	elseif hour < 0 then
		hour = hour + 24
	end
	minute = realtime.minute
	setTime(hour, minute)

	nextupdate = (60-realtime.second) * 1000
	setMinuteDuration( nextupdate )
	setTimer( setMinuteDuration, nextupdate + 5, 1, 60000 )
	outputDebugString("Realtime -> Time Set: "..hour..":"..minute,0,255,255,0);
end

--- valós időjárás
local weatherIDs = {
	["Haze"] = math.random(12,15),
	["Mostly Cloudy"] = 2,
	["Clear"] = 10,
	["Cloudy"] = math.random(0,7),
	["Flurries"] = 32,
	["Fog"] = math.random(0,7),
	["Mostly Sunny"] = math.random(0,7),
	["Partly Cloudy"] = math.random(0,7),
	["Partly Sunny"] = math.random(0,7),
	["Freezing Rain"] = 2,
	["Rain"] = 2,
	["Sleet"] = 2,
	-- ["Snow"] = 31,
	["Sunny"] = 11,
	["Thunderstorms"] = 8,
	["Thunderstorm"] = 8,
	["Unknown"] = 0,
	["Overcast"] = 7,
	["Scattered Clouds"] = 7,
	["Light Snow"] = 4,
}

local weatherNames = {
	["Haze"] = "Foggy",
	["Mostly Cloudy"] = "Mostly Cloudy",
	["Clear"] = "Clear",
	["Cloudy"] = "Cloudy",
	["Flurries"] = "Flurries",
	["Fog"] = "Foggy",
	["Mostly Sunny"] = "Mostly Sunny",
	["Partly Cloudy"] = "Partly Cloudy",
	["Partly Sunny"] = "Partly Sunny",
	["Freezing Rain"] = "Freezing Rain",
	["Rain"] = "Rain",
	["Sleet"] = "Sleet",
	["Snow"] = "Snow",
	["Sunny"] = "Sunny",
	["Thunderstorms"] = "Thunderstorms",
	["Thunderstorm"] = "Thunderstorms",
	["Unknown"] = "Unknown",
	["Overcast"] = "Overcast",
	["Scattered Clouds"] = "Clouds",
	["Light Snow"] = "Light Snow",
}

function fetchWeather()
	updateTime()
	setRainLevel(0)
end
setTimer(fetchWeather, 1000*60*10, 0)
addEventHandler("onResourceStart", resourceRoot, fetchWeather)
