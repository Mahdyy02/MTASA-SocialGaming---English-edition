local sObject = {}
local maxRoadBlock = 1000

addEvent("createObjectToServer", true)
addEventHandler("createObjectToServer", root, function (player, objectID, x, y, z, rot)
	local id = 0
	for i = 1, maxRoadBlock do 
		if (sObject[i] == nil) then 
			sObject[i] = createObject(objectID, x, y, z-0.21, 0, 0, rot)
			setElementInterior ( sObject[i], getElementInterior ( player ) )
			setElementDimension ( sObject[i], getElementDimension ( player ) )
			setElementData(sObject[i], "object:name", i)
			setElementData(sObject[i], "object:create", getElementData(player, "char >> name"))
			id = i
			break
		end
	end
	if not (id == 0) then
		outputChatBox("#ffffff[#CA2323The#ffffffDevils - #CA2323Roadblock#ffffff]#ffffff Roadblock successfully created ID: #E9D460" .. id.. "#ffffff.", player, 0, 255, 0, true)
	else
		outputChatBox("#ffffff[#CA2323The#ffffffDevils - #CA2323Roadblock#ffffff]#ffffff Too many roadblocks made please delete some.", player, 0, 255, 0, true)
	end
end)


function removeRoadblock(thePlayer, commandName, id)
	if getElementData(thePlayer,"faction_53") or getElementData(thePlayer,"faction_54") or getElementData(thePlayer,"faction_17") then 
		if not (id) then
				outputChatBox("#ffffff[#CA2323The#ffffffDevils - #CA2323Roadblock#ffffff] #ffffff/"..commandName.. " [Roadblock ID]", thePlayer, 255, 255, 255, true)
		else
			id = tonumber(id)
			if (sObject[id]==nil) then
				outputChatBox("#ffffff[#CA2323The#ffffffDevils - #CA2323Roadblock#ffffff]#ffffff There is no roadblock with this id.", thePlayer, 0, 255, 0, true)
			else
				local object = sObject[id]
					
				destroyElement(object)
				sObject[id] = nil
				outputChatBox("#ffffff[#CA2323The#ffffffDevils - #CA2323Roadblock#ffffff]#ffffff Roadblock successfully deleted ID: #E9D460 ".. id .."#ffffff.", thePlayer, 0, 255, 0, true)
			end
		end
	end
end
addCommandHandler("delrbs", removeRoadblock, false, false)


function getNearbyRoadblocks(thePlayer, commandName)
	if getElementData(thePlayer,"faction_53") or getElementData(thePlayer,"faction_54") or getElementData(thePlayer,"faction_17") then 
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox(" ", thePlayer, 255, 126, 0)
		local found = false
			
		for i = 1, maxRoadBlock do
			if not (sObject[i]==nil) then
				local x, y, z = getElementPosition(sObject[i])
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if (distance<=10) then
					outputChatBox("#ffffff[#CA2323The#ffffffDevils - #CA2323Roadblock#ffffff]#ffffff Nearby roadblocks ID: #E9D460 ".. i .."#ffffff.", thePlayer, 0, 255, 0, true)
					found = true
				end
			end
		end
			
		if not (found) then
			outputChatBox("#ffffff[#CA2323The#ffffffDevils - #CA2323Roadblock#ffffff]#ffffff There are no roadblocks near you.", thePlayer, 0, 255, 0, true)
		end
	end
end
addCommandHandler("nearbyrbs", getNearbyRoadblocks, false, false)
