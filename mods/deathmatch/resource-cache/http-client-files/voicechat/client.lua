--[[
This script was creadted by MazzMan (Maxim W.).
Copyright 2012 by MazzMan.
You can use this for your server. You are not allowed to sell this or make money in any other way with this!
If you use something from this script, please don't forget me in the credits.
Have fun!
]]--

maxdistance = 10	--max. distance from where you can here someone
checktime = 1000 			--interval in ms

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()
	setTimer(function()
		for _, thePlayer in ipairs(getElementsByType("player"))do
			if not (thePlayer == localPlayer) then
				local disable, volume = true, 0
				if not (isPedDead(thePlayer) and isPedDead(localPlayer)) then
					if (getElementData(thePlayer,"isCall") == localPlayer) then
						disable, volume = false, math.max(volume, 2)
					end
					if isPlayerSameRadio(thePlayer) then
						if getElementData(localPlayer,"use.radio") then
							disable, volume = false, math.max(volume, 2)
						else
							disable, volume = false, math.max(volume, 0.5)
						end
					end

					local x2, y2, z2 = getCameraMatrix()
					local target = getCameraTarget()
					if target then
						if getElementType(target) == "player" then
							x2, y2, z2 = getPedBonePosition(target, 8)
						elseif getElementType(target) == "vehicle" then
							local vehicle = getPedOccupiedVehicle(localPlayer)
							if vehicle and target == vehicle then
								x2, y2, z2 = getPedBonePosition(localPlayer, 8)
							else
								x2, y2, z2 = getElementPosition(target)
							end
						end
					end
					local x1, y1, z1 = getPedBonePosition(thePlayer, 8)
					local distance = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
					if (distance <= maxdistance)then
						local hit = processLineOfSight(x1, y1, z1+0.5, x2, y2, z2+0.5, true, false, false, true, false, true, true)
						if not (hit)then
							disable, volume = false, math.max(volume, math.max(math.min((-distance+maxdistance)/maxdistance, 1), 0))
						end
					end
				end
				setSoundVolume(thePlayer, volume)
				--setPlayerVoiceMuted(thePlayer, disable)
			end
		end	
	end, checktime, 0)
end)

function isPlayerSameRadio(thePlayer)
	if not (thePlayer and getElementType(thePlayer) == "player") then return end
	local serial = getElementData(thePlayer,"use.radio")
	local allRadio = exports.fv_inventory:getItems(thePlayer, 86)
	if allRadio and serial then
		--for _, item in ipairs(allRadio) do
			local radiof = exports.fv_inventory:getItemValue(thePlayer,86,serial)
			if radiof and radiof > 0 and exports.fv_inventory:hasItem(86, radiof) then
				return true
			end
		--end
	end
	return false
	--[[if ((getElementData(localPlayer,"char >> radiof") or 0) > 0 and exports.fv_inventory:hasItem(86)) then
		if (getElementData(thePlayer,"char >> radiof") == getElementData(localPlayer,"char >> radiof")) then
			return true
		end
	end]]
end
-----------------------
-- (c) 2012 by MazzMan
-----------------------