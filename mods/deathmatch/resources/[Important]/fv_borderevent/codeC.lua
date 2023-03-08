local sx,sy = guiGetScreenSize()
local font = exports.fv_engine:getFont("rage",14);

local race = {
	sektor = 0;
	time = 0;
	lapTime = 0;
};

setElementData(localPlayer,"player:isRaceVeh",false);
setElementData(localPlayer,"player:isRace",false);
setElementData(localPlayer,"player:HasRace",false);

local currentMarker = 0;
local currentMarkerElement = false;
local currentBlipElement = false;

addEventHandler("onClientMarkerHit",getRootElement(),function( hitElement, md )
if hitElement == localPlayer and md then
	if getElementData(source,"isRaceStartMarker") and not getElementData(localPlayer,"player:HasRace") then
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		if isPedInVehicle(localPlayer) and getElementModel(theVehicle) == 547 then
			triggerServerEvent("race >> giveCar",localPlayer,localPlayer);
			setElementData(localPlayer,"player:isRace",true);
			currentMarker = 0;
			createNextMarker();
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Border","red").."Brabus Rocket 900-al tudsz csak a versenyen indulni.",255,255,255,true);
		end
		if getElementData(source,"isRaceStartMarker") and getElementData(localPlayer,"player:HasRace") then
			outputChatBox(exports.fv_engine:getServerSyntax("Border","servercolor") .. "Te már mentél!",255,255,255,true)
		end
		if getElementData(source,"race:sektorMarker") and isPedInVehicle(localPlayer) and getElementData(localPlayer,"player:HasRace") then
			if getElementData(source,"race:sektor") <= race.sektor then
				outputChatBox(exports.fv_engine:getServerSyntax("Border","servercolor") .. "Rossz az irány fordulj meg!!!",255,255,255,true)
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Border","servercolor") .. "A szektoridőd: " ..exports.fv_engine:getServerColor("servercolor",true) .. secondsToTimeDesc(race.lapTime) .. "#FFFFFF perc",255,255,255,true)
			end
				if getElementData(source,"race:sektor") == #raceMarker then
					setElementData(localPlayer,"player:isRace",false)
					triggerServerEvent("race >> destroy",localPlayer,localPlayer,race.time)
					if isElement(currentMarkerElement) then 
						destroyElement(currentMarkerElement);
					end
					if isElement(currentBlipElement) then 
						destroyElement(currentBlipElement);
					end
				else 
					createNextMarker();
				end
				race.lapTime = 0;
				race.sektor = race.sektor + 1;
			end
		end
	end
end)

function createNextMarker()
	currentMarker = currentMarker + 1;
	if isElement(currentMarkerElement) then 
		destroyElement(currentMarkerElement);
	end
	if isElement(currentBlipElement) then 
		destroyElement(currentBlipElement);
	end
	local x,y,z = unpack(raceMarker[currentMarker]);
	currentMarkerElement = createMarker(x,y,z,"checkpoint",5,200,0,0,100);
	setElementData(currentMarkerElement,"race:sektorMarker",true);
	setElementData(currentMarkerElement,"race:sektor",currentMarker);
	---------------------------------
	currentBlipElement = createBlip(x,y,z,33);
	attachElements(currentBlipElement,currentMarkerElement,0,0,3);
	setElementData(currentBlipElement,"blip >> color",{200,0,0});
	setElementData(currentBlipElement,"blip >> size",30);
	setElementData(currentBlipElement,"blip >> maxVisible",true);
	setElementData(currentBlipElement,"blip >> name","Következő szektor");
end


local width,height = 200,200
local posX,posY = sx/2-width/2 , 5



addEventHandler("onClientRender",getRootElement(),function()
	if getElementData(localPlayer,"player:isRace") then
		race.time = race.time + 1;
		race.lapTime = race.lapTime + 1;
		exports.fv_engine:shadowedText(secondsToTimeDesc(race.time) .. "\n Szektor: ".. race.sektor.."\nSzektor idő: " ..secondsToTimeDesc(race.lapTime),sx/2,posY,sx/2,sy/2,tocolor(255,255,255,255),1,font,"center","top")
	end
end,true,"low-5")
