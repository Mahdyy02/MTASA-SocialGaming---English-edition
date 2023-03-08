addEventHandler("onDebugMessage", getRootElement(),
	function (message, level, file, line, r, g, b)
		local color
		if level == 1 then
			level = "[ERROR] "
			color = tocolor(215, 89, 89)
		elseif level == 2 then
			level = "[WARNING] "
			color = tocolor(255, 150, 0)
		elseif level == 3 then
			level = "[INFO] "
			color = tocolor(50, 179, 239)
		else
			level = "[INFO] "
			color = tocolor(r, g, b)
		end

		local time = getRealTime()
		local timeStr = "[" .. string.format("%02d:%02d:%02d", time.hour, time.minute, time.second) .. "]"
		local devs = {}

		for k, v in pairs(getElementsByType("player")) do
			if getElementData(v, "admin >> level") >= 10 then
				table.insert(devs, v)
			end
		end

		if file and line then
			triggerLatentClientEvent(devs, "addDebugLine", resourceRoot, level .. file .. ":" .. line .. ", " .. message, color, timeStr)
		else
			triggerLatentClientEvent(devs, "addDebugLine", resourceRoot, level .. message, color, timeStr)
		end
	end
)