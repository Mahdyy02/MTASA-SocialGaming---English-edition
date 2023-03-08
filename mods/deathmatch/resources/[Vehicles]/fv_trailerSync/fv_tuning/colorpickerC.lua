local cursorIsMoving, pickingColor, pickingLuminance = false, false, false
local pickerTexture = dxCreateTexture("files/colorpicker.png","dxt5");
pickerData = {}

addEventHandler("onClientRender", root, function()
	if pickerData and pickerData["colortype"] ~= nil and pickerData["active"] then
		--> Vehicle color
		local selectedR, selectedG, selectedB = pickerData["color"][1], pickerData["color"][2], pickerData["color"][3]
		
		if pickerData["vehicle"] and isElement(pickerData["vehicle"]) then
			local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor(pickerData["vehicle"], true)
			local r5, g5, b5 = getVehicleHeadLightColor(pickerData["vehicle"])
			
			if pickerData["colortype"] == "color1" then
				r1, g1, b1 = selectedR, selectedG, selectedB
			elseif pickerData["colortype"] == "color2" then
				r2, g2, b2 = selectedR, selectedG, selectedB
			elseif pickerData["colortype"] == "color3" then
				r3, g3, b3 = selectedR, selectedG, selectedB
			elseif pickerData["colortype"] == "color4" then
				r4, g4, b4 = selectedR, selectedG, selectedB
			elseif pickerData["colortype"] == "headlight" then
				r5, g5, b5 = selectedR, selectedG, selectedB
			end
			
			setVehicleColor(pickerData["vehicle"], r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4)
			setVehicleHeadLightColor(pickerData["vehicle"], r5, g5, b5)
		end
		
		--> Color selector
		dxDrawRectangle(pickerData["posX"]-5, pickerData["posY"]-5, pickerData["width"]+10, pickerData["height"]+10,tocolor(0, 0, 0, 255))
		dxDrawRectangle(pickerData["posX"]-8, pickerData["posY"]-5, 3, pickerData["height"]+10,tocolor(e:getServerColor("servercolor",false)));
		dxDrawImage(pickerData["posX"], pickerData["posY"], pickerData["width"], pickerData["height"], pickerTexture)
                
		--> Luminance selector
		local arrowX = pickerData["posX"] + ((1 - pickerData["lightness"]) * (pickerData["width"]))
		arrowX = math.max(pickerData["posX"], math.min(pickerData["posX"] + pickerData["width"], arrowX))
		
		dxDrawRectangle(pickerData["posX"] - 2, pickerData["posY"] + pickerData["height"] - 22, pickerData["width"] + 4, 20, tocolor(0, 0, 0, 255))
		
		for i = 0, (pickerData["width"]) do
			local luminanceR, luminanceG, luminanceB = HSLToRGB(pickerData["hue"], pickerData["saturation"], ((pickerData["width"]) - i) / (pickerData["width"]))
			dxDrawRectangle(pickerData["posX"] + i, pickerData["posY"] + pickerData["height"] - 20, 1, 20, tocolor(luminanceR * 255, luminanceG * 255, luminanceB * 255, 255))
		end
        dxDrawRectangle(arrowX, pickerData["posY"] + pickerData["height"] - 20, 2, 20, tocolor(0, 0, 0, 200))

		if isCursorShowing() and isMoving then
			local cursorX, cursorY = getCursorPosition()
			cursorX = cursorX * sx
			cursorY = cursorY * sy
            if getKeyState("mouse1") and pickingColor then
                cursorX = math.max(pickerData["posX"], math.min(pickerData["posX"] + pickerData["width"], cursorX))
				cursorY = math.max(pickerData["posY"], math.min(pickerData["posY"] + pickerData["height"] - 25, cursorY))
				setCursorPosition(cursorX, cursorY)

				pickerData["hue"], pickerData["saturation"] = (cursorX - pickerData["posX"]) / (pickerData["width"] - 1), ((pickerData["height"] - 1) - cursorY + pickerData["posY"]) / (pickerData["height"] - 1)
				local convertedR, convertedG, convertedB = HSLToRGB(pickerData["hue"], pickerData["saturation"], pickerData["lightness"])
				local oldR, oldG, oldB = HSLToRGB(pickerData["hue"], pickerData["saturation"], 0.5)
				pickerData["selectedColor"] = convertColor({oldR * 255, oldG * 255, oldB * 255})
				pickerData["color"] = convertColor({convertedR * 255, convertedG * 255, convertedB * 255, pickerData["color"][4]})
            elseif getKeyState("mouse1") and pickingLuminance then
                cursorX = math.max(pickerData["posX"], math.min(pickerData["posX"] + pickerData["width"], cursorX))
				cursorY = math.max(pickerData["posY"] + pickerData["height"] - 20, math.min(pickerData["posY"] + pickerData["height"], cursorY))
				setCursorPosition(cursorX, cursorY)

				pickerData["lightness"] = ((pickerData["width"]) - cursorX + pickerData["posX"]) / (pickerData["width"])
				local convertedR, convertedG, convertedB = HSLToRGB(pickerData["hue"], pickerData["saturation"], pickerData["lightness"])
				pickerData["color"] = convertColor({convertedR * 255, convertedG * 255, convertedB * 255, pickerData["color"][4]})
			end
		end
	end
end)

addEventHandler("onClientClick", root, function(button, state, cursorX, cursorY)
	if pickerData and pickerData["colortype"] ~= nil and pickerData["active"] then
		if button == "left" and state == "down" then
			if cursorX >= pickerData["posX"] and cursorX <= pickerData["posX"] + pickerData["width"] and cursorY >= pickerData["posY"] and cursorY <= pickerData["posY"] + pickerData["height"] - 25 then
				isMoving, pickingColor, pickingLuminance = true, true, false
			elseif cursorX >= pickerData["posX"] and cursorX <= pickerData["posX"] + pickerData["width"] and cursorY >= pickerData["posY"] + pickerData["height"] - 20 and cursorY <= pickerData["posY"] + pickerData["height"] then
				isMoving, pickingColor, pickingLuminance = true, false, true
			end
		else
			isMoving, pickingColor, pickingLuminance = false, false, false
		end
	end
end)

function setPaletteType(type)
	if type then
		pickerData["colortype"] = type
	end
end

function createColorPicker(vehicle, x, y, w, h, colortype)
	if vehicle and x and y and w and h and colortype then
		pickerData = {["active"] = true, ["posX"] = x, ["posY"] = y, ["width"] = w, ["height"] = h, ["colortype"] = colortype, ["vehicle"] = vehicle}
		updatePaletteColor(vehicle, colortype)
	end
end

function destroyColorPicker()
	pickerData["active"] = false
	pickerData = {}
	pickerData = nil
end

function updatePaletteColor(vehicle, colortype)
	if vehicle and colortype then
		local vehicleColor = {255, 255, 255}
		local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor(vehicle, true)
		local r5, g5, b5 = getVehicleHeadLightColor(vehicle)
		if pickerData["colortype"] == "color1" then
			vehicleColor = {r1, g1, b1}
		elseif pickerData["colortype"] == "color2" then
			vehicleColor = {r2, g2, b2}
		elseif pickerData["colortype"] == "color3" then
			vehicleColor = {r3, g3, b3}
		elseif pickerData["colortype"] == "color4" then
			vehicleColor = {r4, g4, b4}
		elseif pickerData["colortype"] == "headlight" then
			vehicleColor = {r5, g5, b5}
		end		
		pickerData["color"] = convertColor({vehicleColor[1], vehicleColor[2], vehicleColor[3]})
		pickerData["hue"], pickerData["saturation"], pickerData["lightness"] = RGBToHSL(pickerData["color"][1] / 255, pickerData["color"][2] / 255, pickerData["color"][3] / 255)
		local currentR, currentG, currentB = HSLToRGB(pickerData["hue"], pickerData["saturation"], 0.5)
		pickerData["selectedColor"] = convertColor({currentR * 255, currentG * 255, currentB * 255})
	end
end

function convertColor(color)
	color[1] = fixColorValue(color[1])
	color[2] = fixColorValue(color[2])
	color[3] = fixColorValue(color[3])
	color[4] = fixColorValue(color[4])
	return color
end

function fixColorValue(value)
	if not value then
		return 255
	end
	
	value = math.floor(tonumber(value))
	
	if value < 0 then
		return 0
	elseif value > 255 then
		return 255
	else
		return value
	end
end

function HSLToRGB(hue, saturation, lightness)
	local lightnessValue2
	
	if lightness < 0.5 then
		lightnessValue2 = lightness * (saturation + 1)
	else
		lightnessValue2 = (lightness + saturation) - (lightness * saturation)
	end
	
	local lightnessValue1 = lightness * 2 - lightnessValue2
	local r = HUEToRGB(lightnessValue1, lightnessValue2, hue + 1 / 3)
	local g = HUEToRGB(lightnessValue1, lightnessValue2, hue)
	local b = HUEToRGB(lightnessValue1, lightnessValue2, hue - 1 / 3)
	
	return r, g, b
end

function HUEToRGB(lightness1, lightness2, hue)
	if hue < 0 then
		hue = hue + 1
	elseif hue > 1 then
		hue = hue - 1
	end

	if hue * 6 < 1 then
		return lightness1 + (lightness2 - lightness1) * hue * 6
	elseif hue * 2 < 1 then
		return lightness2
	elseif hue * 3 < 2 then
		return lightness1 + (lightness2 - lightness1) * (2 / 3 - hue) * 6
	else
		return lightness1
	end
end

function RGBToHSL(red, green, blue)
	local max = math.max(red, green, blue)
	local min = math.min(red, green, blue)
	local hue, saturation, lightness = 0, 0, (min + max) / 2
	if max == min then
		hue, saturation = 0, 0
	else
		local different = max - min
		if lightness < 0.5 then
			saturation = different / (max + min)
		else
			saturation = different / (2 - max - min)
		end
		if max == red then
			hue = (green - blue) / different
			if green < blue then
				hue = hue + 6
			end
		elseif max == green then
			hue = (blue - red) / different + 2
		else
			hue = (red - green) / different + 4
		end

		hue = hue / 6
	end

	return hue, saturation, lightness
end