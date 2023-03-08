vehicleRaceStartMarker = createMarker(2838.9125976563, -1869.6948242188, 10.927760124207,"checkpoint",2,229,160,12,180)
--raceVehMarker = createMarker(2838.2785644531, -1934.2767333984, 9.9375, "cylinder", 4, 255, 204, 1, 50)

setElementData(vehicleRaceStartMarker,"isRaceStartMarker",true)

local sColor = exports.fv_engine:getServerColor("servercolor",true);
local white = "#FFFFFF";

local raceMarkers = {}
local raceVehicle = {}


addEvent("race >> giveCar",true)
addEventHandler("race >> giveCar",getRootElement(),function(element)
    exports.fv_admin:sendMessageToAdmin(element,"BorderEvent >> START " ..sColor.. getElementData(element,"char >> name") ..white.. " elkezdte a Border-t!",2);
	setElementData(element,"player:isRaceVeh",true)
	setElementData(element,"player:HasRace",true)
	outputChatBox(exports.fv_engine:getServerSyntax("Border","servercolor").."Sikeresen elkezdted a versenyt.",element,255,255,255,true);
end)

local racePlayers = {}
local raceGlobalPlayers = {}

addEvent("race >> destroy",true)
addEventHandler("race >> destroy",getRootElement(),function(element,raceTime) -- 
	exports.fv_admin:sendMessageToAdmin(element,"BorderEvent >> VÉGE " ..sColor.. getElementData(element,"char >> name")..white.. " ideje: " ..sColor.. secondsToTimeDesc(raceTime) ..white.. " perc",2)
	racePlayers[element] = {getPlayerName(element),getElementData(element,"player:raceTime")}
	raceGlobalPlayers[#raceGlobalPlayers +1] = {getElementData(element,"char >> name"),raceTime}
	outputChatBox(exports.fv_engine:getServerSyntax("Border","servercolor") .. "Sikeresen végig mentél a Border körön!",element,55,255,255,true)
    outputChatBox(exports.fv_engine:getServerSyntax("Border","servercolor") .. "Az időd: " ..sColor.. secondsToTimeDesc(raceTime) ..white.. " perc",element,255,255,255,true)
end)

addCommandHandler("racestats",function(player,cmd)
	local temp = raceGlobalPlayers;
	outputChatBox(exports.fv_engine:getServerSyntax("Border","servercolor").."Verseny eredményei:",player,255,255,255,true);
	table.sort(temp,function(a,b)
		return a[2] < b[2];
	end);
	for k,v in pairs(temp) do 
		outputChatBox("["..k.."] "..sColor..v[1] ..white.." --> "..sColor..secondsToTimeDesc(v[2]),player,255,255,255,true);
	end
end);