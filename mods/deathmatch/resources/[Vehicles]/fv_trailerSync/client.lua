local interval = 2500

addCommandHandler("trailersync",
	function()
		local syntax = exports['fv_engine']:getServerSyntax("Trailer", "servercolor")
		outputChatBox(syntax.."You have successfully synchronized your trailers!", 255, 255, 255, true)
		for k,v in pairs(getElementsByType("vehicle")) do
			local trailer = getVehicleTowedByVehicle(v)
			if trailer then
				setElementStreamable(v, true)
				setElementStreamable(trailer, true)
				local x,y,z = getElementPosition(v)
				setElementPosition(trailer, x, y, z)
				detachTrailerFromVehicle(v, trailer)
				attachTrailerToVehicle(v, trailer)
			end
		end
	end
)

setTimer(
	function()
		for k,v in pairs(getElementsByType("vehicle")) do
			if getVehicleOccupant(v, 0) == localPlayer then return end
			local trailer = getVehicleTowedByVehicle(v)
			if trailer then
				setElementStreamable(v, true)
				setElementStreamable(trailer, true)
				local x,y,z = getElementPosition(v)
				setElementPosition(trailer, x, y, z)
				detachTrailerFromVehicle(v, trailer)
				attachTrailerToVehicle(v, trailer)
			end
		end
	end, interval, 0
)

addEventHandler("onClientElementStreamIn", root,
	function()
		if isElement(source) and getElementType(source) == "vehicle" and not getVehicleOccupant(source, 0) == localPlayer then
			local trailer = getVehicleTowedByVehicle(source)
			if trailer then
				setElementStreamable(source, true)
				setElementStreamable(trailer, true)
				detachTrailerFromVehicle(source, trailer)
				attachTrailerToVehicle(source, trailer)
			end
		end
	end
)

addEventHandler("onClientElementStreamOut", root,
	function()
		if isElement(source) and getElementType(source) == "vehicle" and not getVehicleOccupant(source, 0) == localPlayer then
			local trailer = getVehicleTowedByVehicle(source)
			if trailer then
				setElementStreamable(source, true)
				setElementStreamable(trailer, true)
				detachTrailerFromVehicle(source, trailer)
				attachTrailerToVehicle(source, trailer)
			end
		end
	end
)
