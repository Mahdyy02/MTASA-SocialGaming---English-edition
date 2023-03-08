--
-- s_player_management.lua
--

playerInfo = {}

addEventHandler("onResourceStart", resourceRoot,
	function()
		for _,player in ipairs(getElementsByType("player")) do
			addPlayerInfo(player)
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function()
		addPlayerInfo(source)
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		onPlayerNowDriving( source, nil )
		removePlayerInfo(source)
	end
)

addEventHandler("onVehicleEnter", root,
	function(thePlayer, seat, jacked)
		if seat == 0 then
			onPlayerNowDriving( thePlayer, source )
		end
	end
)

addEventHandler("onVehicleExit", root,
	function(thePlayer, seat, jacker)
		onPlayerNowDriving( thePlayer, nil )
	end
)

addEventHandler("onElementModelChange", root,
	function(oldModel, newModel)
		if getElementType(source)=="vehicle" then
			onPlayerNowDriving( thePlayer, source )
		end
	end
)

addEventHandler("onElementDeleted", root,
	function()
		if getElementType(source)=="vehicle" then
			removeVehicleInfo( source )
		end
	end
)


-- 250ms timer to make sure handling is what we expect
setTimer(
	function()
		for player,_ in pairs(g_PlayerInfo) do
			local vehicle = getPedOccupiedVehicle( player )
			if vehicle and getPedOccupiedVehicleSeat( player ) == 0 then
				onPlayerNowDriving( player, vehicle )
			else
				onPlayerNowDriving( player, nil )
			end
		end
	end
,250,0)


---------------------------------------------------------------------
-- onPlayerNowDriving
---------------------------------------------------------------------
function onPlayerNowDriving( player, vehicle )
	local modelid = vehicle and getElementModel(vehicle)
	local plrInfo = getPlayerInfo(player)
	if (not plrInfo.vehicle ~= not vehicle) or (plrInfo.vehiclemodel ~= modelid)  then
		-- Remove old handling
		if plrInfo.vehicle then
			removePlayerVehicleHandling( player, plrInfo.vehicle )
		end
		plrInfo.vehicle = vehicle
		plrInfo.vehiclemodel = modelid
		-- Add new handling
		if plrInfo.vehicle then
			applyPlayerVehicleHandling( player, plrInfo.vehicle )
		end
	end
end


---------------------------------------------------------------------
--
-- Player vehicle handling
--
--
---------------------------------------------------------------------

---------------------------------------------------------------------
-- applyPlayerVehicleHandling
--    Add player handling to the vehicle
---------------------------------------------------------------------
function applyPlayerVehicleHandling( player, vehicle  )
	local handlingLine = getPlayerHandlingLineForVehicle( player, vehicle )
	if handlingLine then
		-- Apply player handling line if there
		setVehicleHandlingLine( vehicle, handlingLine )
		local vehInfo = getVehicleInfo( vehicle )
		vehInfo.handlingOwner = player
	else
		-- Default handling if nothing from the player
		local vehInfo = findVehicleInfo( vehicle )
		if vehInfo then
			resetVehicleToModelHandling( vehicle )
			removeVehicleInfo( vehicle )
		end
	end
end


---------------------------------------------------------------------
-- removePlayerVehicleHandling
--    Remove player handling from the vehicle
---------------------------------------------------------------------
function removePlayerVehicleHandling( player, vehicle )
	-- If player did have handling applied, then remove it
	local vehInfo = findVehicleInfo( vehicle )
	if vehInfo and vehInfo.handlingOwner == player then
		resetVehicleToModelHandling( vehicle )
		removeVehicleInfo( vehicle )
	end
end


---------------------------------------------------------------------
-- getPlayerHandlingLineForVehicle
--    false if not there
---------------------------------------------------------------------
function getPlayerHandlingLineForVehicle( player, vehicle )
	local plrInfo = getPlayerInfo( player )
	-- Maybe queue if handlingTable not set yet
	if plrInfo.handlingTable then
		local modelid = getElementModel(vehicle)
		local handlingLine = plrInfo.handlingTable[modelid]
		return handlingLine
	end
	return false
end




---------------------------------------------------------------------
--
-- VehicleInfo
--
--
---------------------------------------------------------------------
g_VehicleInfo = {}

---------------------------------------------------------------------
-- findVehicleInfo
--   false if not there
---------------------------------------------------------------------
function findVehicleInfo( vehicle )
	return g_VehicleInfo[vehicle]
end

---------------------------------------------------------------------
-- getVehicleInfo
--   add if not there
---------------------------------------------------------------------
function getVehicleInfo( vehicle )
	if not g_VehicleInfo[vehicle] then
		g_VehicleInfo[vehicle] = {}
	end
	return g_VehicleInfo[vehicle]
end

---------------------------------------------------------------------
-- removeVehicleInfo
---------------------------------------------------------------------
function removeVehicleInfo( vehicle )
	g_VehicleInfo[vehicle] = nil
end



---------------------------------------------------------------------
--
-- PlayerInfo
--
--
---------------------------------------------------------------------
g_PlayerInfo = {}

---------------------------------------------------------------------
-- addPlayerInfo
---------------------------------------------------------------------
function addPlayerInfo( player )
	g_PlayerInfo[player] = {}
end

---------------------------------------------------------------------
-- removePlayerInfo
---------------------------------------------------------------------
function removePlayerInfo( player )
	g_PlayerInfo[player] = nil
end

---------------------------------------------------------------------
-- getPlayerInfo
---------------------------------------------------------------------
function getPlayerInfo( player )
	return g_PlayerInfo[player]
end


---------------------------------------------------------------------
-- Save handling info from player
---------------------------------------------------------------------
addEvent("onPlayerHandlingCfgChange", true)
addEventHandler("onPlayerHandlingCfgChange", resourceRoot,
	function(handlingTable)
		local plrInfo = getPlayerInfo( client )
		plrInfo.handlingTable = handlingTable
		plrInfo.vehiclemodel = -1	-- This will force a handling reload
	end
)
