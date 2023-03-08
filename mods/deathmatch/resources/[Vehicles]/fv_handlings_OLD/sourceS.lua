addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		for model, properties in pairs(customHandling) do
			for property, value in pairs(properties) do
				if value == "true" then
					setModelHandling(model, property, true)
				elseif value == "false" then
					setModelHandling(model, property, false)
				elseif property == "modelFlags" or property == "handlingFlags" then
					setModelHandling(model, property, tonumber("0x" .. value))
				else
					setModelHandling(model, property, value)
				end
			end
		end

		for _, vehicle in ipairs(getElementsByType("vehicle")) do
			applyCustomHandling(vehicle)
		end
	end
)

function loadHandling(vehicle)
	applyCustomHandling(vehicle)
end

addEventHandler("onResourceStop", getResourceRootElement(),
	function ()
		for model in pairs(customHandling) do
			for property in pairs(getOriginalHandling(model)) do
				setModelHandling(model, property, nil)
			end
		end

		for _, vehicle in ipairs(getElementsByType("vehicle")) do
			local model = getElementModel(vehicle)

			if customHandling[model] then
				for property, value in pairs(getOriginalHandling(model)) do
					setVehicleHandling(vehicle, property, value)
				end
			end
		end
	end
)