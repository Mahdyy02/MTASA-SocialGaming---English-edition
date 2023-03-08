--
-- s_handling_loader.lua
--

addEventHandler("onResourceStart", resourceRoot,
	function()
		resetAllModelsToGTAHandling()
		resetAllVehiclesToGTAHandling()
		importHandlingCfg()
	end
, true, "high" )

addEventHandler("onResourceStop", resourceRoot,
	function()
		resetAllModelsToGTAHandling()
		resetAllVehiclesToGTAHandling()
		outputInfo( "Server - Handling reset" )
	end
 )

---------------------------------------------------------------------
-- Reset all model handling to match the standard GTA handling
---------------------------------------------------------------------
function resetAllModelsToGTAHandling()
	for id=400,611 do
		setModelHandling( id, nil )
	end
end

---------------------------------------------------------------------
-- Reset vehicle elements to match the standard GTA handling
---------------------------------------------------------------------
function resetAllVehiclesToGTAHandling()
	for _,veh in ipairs(getElementsByType("vehicle")) do
		setVehicleHandling( veh, true )
	end
end

---------------------------------------------------------------------
-- Reset vehicle elements to match the model handling
---------------------------------------------------------------------
function resetAllVehiclesToModelHandling()
	for _,veh in ipairs(getElementsByType("vehicle")) do
		setVehicleHandling( veh, false )
	end
end


---------------------------------------------------------------------
-- Read handling lines from file and set all models to match
---------------------------------------------------------------------
function importHandlingCfg()
	local handlingTable = readHandlingCfg( "handling.cfg" )
	for modelid, handlingLine in pairs(handlingTable) do
		setModelHandlingLine( modelid, handlingLine )
	end
end


---------------------------------------------------------------------
-- resetVehicleToModelHandling
---------------------------------------------------------------------
function resetVehicleToModelHandling( vehicle )
	setVehicleHandling( vehicle, false )
end


---------------------------------------------------------------------
-- setVehicleHandlingLine
---------------------------------------------------------------------
function setVehicleHandlingLine( vehicle, handlingLine )
	setHandlingLine( setVehicleHandling, getVehicleHandling, vehicle, handlingLine )
end

---------------------------------------------------------------------
-- setModelHandlingLine
---------------------------------------------------------------------
function setModelHandlingLine( modelid, handlingLine )
	setHandlingLine( setModelHandling, getModelHandling, modelid, handlingLine )
end


---------------------------------------------------------------------
-- setHandlingLine
--    To vehicle or model
---------------------------------------------------------------------
function setHandlingLine( setHandlingFunction, getHandlingFunction, target, handlingLine )
	for i=1,#props,2 do
		local name = props[i]
		local idx = props[i+1]
		local value = handlingLine[idx]
		if idx==32 or idx==33 then	-- modelFlags/handlingFlags
			value = tonumber("0x"..string.sub(tostring(value),-8))
		end
		if not willCauseWarnings(getHandlingFunction,target,name,value) then
			if not setHandlingFunction( target, name, value ) then
				outputDebug("Problem with setHandlingFunction "..tostring(target).." "..tostring(name).." "..tostring(inValue))
			end
		end
	end
	setHandlingFunction( target, "centerOfMass", { handlingLine[5], handlingLine[6], handlingLine[7] } )
end


---------------------------------------------------------------------
-- willCauseWarnings
---------------------------------------------------------------------
function willCauseWarnings(getHandlingFunction,target,name,value)
	-- Stop warnings
	if name == "animGroup" then
		if value==17 or value==23 then
			return true
		end
	elseif name == "suspensionUpperLimit" then
		if getVehicleType( target ) == "Boat" then
			local temp = getHandlingFunction(target)["suspensionLowerLimit"]
			local value2 = makeFloat(value)
			if not( value2 <= temp - 0.1 or value2 >= temp + 0.1 ) then
				--outputDebug("would skip this warningUpper:"
				--	.. " value:".. tostring(value2)
				--	.. " temp:".. tostring(temp)
				--	)
				return true
			end
		end
	elseif name == "suspensionLowerLimit" then
		if getVehicleType( target ) == "Boat" then
			local temp = getHandlingFunction(target)["suspensionUpperLimit"]
			local value2 = makeFloat(value)
			if not( value2 <= temp - 0.1 or value2 >= temp ) then
				--outputDebug("would skip this warningLower:"
				--	.. " value:".. tostring(value2)
				--	.. " temp:".. tostring(temp)
				--	)
				return true
			end
		end
	end
	return false
end


---------------------------------------------------------------------
-- makeFloat
--   Hack to make math compares the same as C++
---------------------------------------------------------------------
function makeFloat(value)
	if not isElement(eee) then
		eee = createElement("eee")
	end
	setElementPosition(eee,value,0,1000)
	value = getElementPosition(eee)
	return value
end
