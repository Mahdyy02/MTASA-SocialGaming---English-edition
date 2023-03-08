local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = 1
local JOB_ID = 6

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local fonts = {}

local tooltips = {}

local jobActive = false
local activeButton = nil
local activeTooltip = nil

local currentStall = nil
local currentStallObject = nil
local currentBuyer = nil
local currentOrder = nil
local currentPage = "hotdogs"

local selectedHotdog = {} -- {hotdog, Kolbász}
local selectedDrink = {} -- {cup, Ital}

local totalPrice = 0
local tip = 0

addEventHandler("onClientResourceStart", resourceRoot, function()
    if isElement(fonts.Roboto11) then
        destroyElement(fonts.Roboto11)
        fonts.Roboto11 = nil
    end
    fonts.Roboto11 = dxCreateFont("files/Roboto-Regular.ttf", respc(11))

    if isElement(fonts.Roboto13) then
        destroyElement(fonts.Roboto13)
        fonts.Roboto13 = nil
    end
    fonts.Roboto13 = dxCreateFont("files/Roboto-Regular.ttf", respc(13))

    if isElement(fonts.Roboto14) then
        destroyElement(fonts.Roboto14)
        fonts.Roboto14 = nil
    end
    fonts.Roboto14 = dxCreateFont("files/Roboto-Regular.ttf", respc(14))

    if isElement(fonts.RobotoB15) then
        destroyElement(fonts.RobotoB15)
        fonts.RobotoB15 = nil
    end
    fonts.RobotoB15 = dxCreateFont("files/Roboto-Bold.ttf", respc(15))

    if isElement(fonts.lunabar) then
        destroyElement(fonts.lunabar)
        fonts.lunabar = nil
    end
    fonts.lunabar = dxCreateFont("files/lunabar.ttf", respc(30), false, "antialiased")

    if getElementData(localPlayer, "char >> job") == JOB_ID then
        createStallBlips()
        jobInfo()
    end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue, newValue)
    if getElementType(source) == "player" and source == localPlayer then
        if dataName == "char >> job" then 
            if newValue == JOB_ID then 
                jobInfo()
                createStallBlips()
            else 
                destroyStallBlips()
            end
        end
    end
end)

local stallPlayerOffset = {-1.25, 0, 0, 270}
local stallPedOffset = {1.25, 0, 0, 90}

local stallRotation
local stallX, stallY, stallZ 

function jobInfo()
    outputChatBox(exports.fv_engine:getServerSyntax("Hotdog vendor","servercolor") .. "Go looking for a hot-dog booth and then click on the booth.", 0, 0, 0, true)
end

local stallBlips = {}

function createStallBlips()
    for k, v in pairs(hotdogStalls) do
        stallBlips[k] = createBlip(v[1], v[2], v[3], 37)
        setElementData(stallBlips[k], "blip >> name", "Hotdog stand")    
    end
end

function destroyStallBlips()
    for k, v in pairs(stallBlips) do
        if isElement(v) then destroyElement(v) end 
    end
end

local cupIsFull = false
local progress = 0


addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if button == "left" and state == "down" then
        if jobActive then
            if activeButton then
                local buttonData = split(activeButton, ":")

                if #buttonData == 1 then
                    if activeButton == "delete" then
                        selectedHotdog = {}
                        selectedDrink = {}
                    elseif activeButton == "leave" then
                        endJob()
                    else
                        currentPage = activeButton
                    end
                elseif #buttonData == 2 then
                    if buttonData[1] == "hotdog" then
                        selectedHotdog = {tonumber(buttonData[2])}
                    elseif buttonData[1] == "sausage" then
                        selectedHotdog[2] = tonumber(buttonData[2])
                    elseif buttonData[1] == "cup" then
                        selectedDrink= {tonumber(buttonData[2])}
                        playSound("files/emptycup.mp3")
                        progress = 0
                        cupIsFull = false
                    elseif buttonData[1] == "drink" then
                        local liquidNumber = tonumber(buttonData[2])

                        if selectedDrink[2] ~= liquidNumber then
                            selectedDrink[2] = liquidNumber
                            progress = 0
                            cupIsFull = false
                        end
                    end
                end
            else
                if clickedElement and clickedElement == currentBuyer then
                    if #selectedHotdog == 2 and #selectedDrink == 2 then

                        if currentOrder.hotdog[1] ~= selectedHotdog[1] then 
                            print("The buyer didn't ask for such a croissant!")
                            exports.fv_infobox:addNotification("error", "The buyer didn't ask for such a croissant!")
                            return
                        end

                        if currentOrder.hotdog[2] ~= selectedHotdog[2] then
                            print("The buyer did not ask for such a sausage!") 
                            exports.fv_infobox:addNotification("error", "The buyer did not ask for such a sausage!")
                            return
                        end
                        
                        if progress < 1 then 
                            print("You didn't fill the cup full!") 
                            exports.fv_infobox:addNotification("error", "You didn't fill the cup full!")
                            return
                        end

                        if currentOrder.drink[1] ~= selectedDrink[1] then 
                            print("Not such a glass asked the buyer!") 
                            exports.fv_infobox:addNotification("error", "Not such a glass asked the buyer!")
                            return
                        end

                        if currentOrder.drink[2] ~= selectedDrink[2] then 
                            print("The buyer did not ask for such a soft drink!") 
                            exports.fv_infobox:addNotification("error", "The buyer did not ask for such a soft drink!")
                            return
                        end

                        cupIsFull = false

                        local totalIncome = totalPrice + tip 

                        print("Order successfully completed, handed over! looking " .. totalIncome .. "dt")
                        exports.fv_infobox:addNotification("success", "Order successfully completed, handed over! looking " .. totalIncome .. "dt")
                        exports.fv_engine:giveMoney(localPlayer, totalIncome)

                        selectedHotdog = {}
                        selectedDrink = {}

                        if isElement(currentBuyer) then
                            destroyElement(currentBuyer)
                        end

                        if currentOrder then
                            currentOrder = nil
                        end

                        setTimer(function()
                            if jobActive then
                                createBuyer()
                                createOrder()
                            end
                        end, 1500, 1)
                    else
                        print("The order is not ready!")
                        exports.fv_infobox:addNotification("error", "The order is not ready!")
                    end
                end
            end
        else
            if clickedElement and getElementModel(clickedElement) == 1340 and getElementData(clickedElement, "stall.id") then
                local oX, oY, oZ = getElementPosition(clickedElement)
                local pX, pY, pZ = getElementPosition(localPlayer)

                if getDistanceBetweenPoints3D(oX, oY, oZ, pX, pY, pZ) <= 5 then

                    if getElementData(localPlayer, "char >> job") ~= JOB_ID then
                        outputChatBox(exports.fv_engine:getServerSyntax("Hotdog vendor","servercolor") .. "You're not a Hotdog vendor.", 0, 0, 0, true)
                        return
                    end

                    if isElement(getElementData(clickedElement, "stall.inUse")) then
                        exports.fv_infobox:addNotification("error", "This booth is busy! "," You're looking for another booth")
                    else    
                        if isPedInVehicle(localPlayer) then
                            exports.fv_infobox:addNotification("error", "Get out of the vehicle")
                        else
                            exports.fv_infobox:addNotification("info", "You occupied this booth")
                            currentStall = getElementData(clickedElement, "stall.id")
                            currentStallObject = clickedElement
                            print(getElementPosition(clickedElement))
                            print(getElementRotation(clickedElement))
                            setElementData(clickedElement, "stall.inUse", localPlayer)
                            startJob()
                        end
                    end
                end
            end
        end
    end
end)

function startJob()
    jobActive = true

    selectedHotdog = {}
    selectedDrink = {}

    totalPrice = 0

    stallRotation = hotdogStalls[currentStall][4]
    stallX, stallY, stallZ = hotdogStalls[currentStall][1], hotdogStalls[currentStall][2], hotdogStalls[currentStall][3]

    local playerOffsetX, playerOffsetY = rotateAround(stallRotation, stallPlayerOffset[1], stallPlayerOffset[2])
    triggerServerEvent("updatePlayerPos", localPlayer, stallX + playerOffsetX, stallY + playerOffsetY, stallZ + stallPlayerOffset[3], stallRotation + stallPlayerOffset[4])

    createBuyer()
    setTimer(setCameraMode, 50, 1, "sell")
    showChat(false)
    showCursor(true)
    setElementFrozen(localPlayer, true)
    toggleAllControls(false)
    addEventHandler("onClientRender", root, renderHotdogStall)
    setElementData(localPlayer,"togHUD",false);
end

function endJob()
    selectedHotdog = {}
    selectedDrink = {}
    jobActive = false
    currentOrder = nil
    showChat(true)
    showCursor(false)
    setElementFrozen(localPlayer, false)
    toggleAllControls(true)
    setCameraMode()

    if isElement(currentBuyer) then
        destroyElement(currentBuyer)
    end

    setElementData(currentStallObject, "stall.inUse", false)
    removeEventHandler("onClientRender", root, renderHotdogStall)
    setElementData(localPlayer,"togHUD",true);
end

function setCameraMode(cameraMode)
    if cameraMode == "sell" then
        if isElement(currentBuyer) then
            local pX, pY, pZ = getElementPosition(localPlayer)
            local bX, bY, bZ = getElementPosition(currentBuyer)
            setCameraMatrix(pX, pY, pZ + 0.5, bX, bY, bZ + 0.5)
        end
    else
        setCameraTarget(localPlayer)
    end
end

function createBuyer()
    if isElement(currentBuyer) then
        destroyElement(currentBuyer)
    end

    local pedOffsetX, pedOffsetY = rotateAround(stallRotation, stallPedOffset[1], stallPedOffset[2])

    currentBuyer = createPed(100, stallX + pedOffsetX, stallY + pedOffsetY, stallZ + stallPedOffset[3], stallRotation + stallPedOffset[4])
    setElementFrozen(currentBuyer, true)

    createOrder()
end

function createOrder()
    if currentOrder then
        currentOrder = nil
    end

    selectedHotdog = {}
    selectedDrink = {}

    totalPrice = 0

    local hotdog = math.random(1, #hotdogs)
    local sausage = math.random(1, #sausages)

    local cup = math.random(1, #cups)
    local drink = math.random(1, #drinks)

    currentOrder = {
        ["hotdog"] = {hotdog, sausage},
        ["drink"] = {cup, drink}
    }

    totalPrice = hotdogs[hotdog].price + sausages[sausage].price + cups[cup].price + 3
    tip = math.random(1, math.floor(totalPrice / 2))

end

local barButtons = {
    [1] = {"hotdogs"},
    [2] = {"sausages"},
    [3] = {"cups"},
    [4] = {"drinks"},
    [5] = {"delete"},
    [6] = {"leave"},
}

local barW, barH = screenX, respc(200)
local barX, barY = 0, screenY - barH

local buttonW, buttonH = respc(200), respc(40)
local buttonX = barX + respc(20)

local fillSound = nil

local green = {exports.fv_engine:getServerColor("servercolor",false)};

function renderHotdogStall()
    setCameraMode("sell")

    tooltips = {}
    buttons = {}

    dxDrawRectangle(barX, barY, barW, barH, tocolor(0, 0, 0, 180))
    dxDrawRectangle(barX, barY, barW, respc(5), tocolor(unpack(green)))

    if currentOrder then
        drawOrder(10, 300, currentOrder, true)
    end

    local buttonY = barY + respc(10)
    local i = 0
    for k, v in ipairs(barButtons) do
        local bX = buttonX + (buttonW + respc(10)) * i  
        i = i + 1
        drawButton(v[2], v[1], bX, buttonY, buttonW, buttonH, tocolor(113, 208, 36))
    end
    
    if currentPage == "hotdogs" then
        local hotdogX, hotdogY = barX + respc(20), barY + respc(40)

        for k, v in pairs(hotdogs) do
            local crescentSize = resp(256 * 0.60) -- hotdog kép mérete
            local x, y = hotdogX + (respc(20) + crescentSize) * (k - 1), hotdogY

            drawHotdog(k, x, y, nil, 0.6)

            buttons["hotdog:" .. k] = {x, y + respc(50), crescentSize, crescentSize - respc(90)}
            tooltips["hotdog:" .. k] = {x, y + respc(50), crescentSize, crescentSize - respc(90), v.name}

        end
    elseif currentPage == "sausages" then   
        local sausageX, sausageY = barX + respc(20), barY + respc(30)
        local sizeMultipler = 0.75

        for k, v in pairs(sausages) do
            local sausageSize = resp(264 * sizeMultipler) -- kolbász kép mérete
            local x, y = sausageX + (respc(20) + sausageSize) * (k - 1), sausageY

            dxDrawImage(x, y, sausageSize, sausageSize, "files/" .. v.image)

            buttons["sausage:" .. k] = {x, y + respc(50), sausageSize, sausageSize - respc(50)}
            tooltips["sausage:" .. k] = {x, y + respc(50), sausageSize, sausageSize - respc(100), v.name}
        end
    elseif currentPage == "cups" then   
        local cupX, cupY = barX + respc(20), barY + respc(70)
        local sizeMultipler = 0.45

        for i = 1, #cups do
            local imageSize = resp(256 * sizeMultipler)
            local x, y= cupX + (respc(50) + imageSize) * (i - 1), cupY
        
            drawCup(i, x, y, nil, sizeMultipler)

            buttons["cup:" .. i] = {x, y, imageSize, imageSize}
            tooltips["cup:" .. i] = {x, y, imageSize, imageSize, cups[i].name}
        end
    elseif currentPage == "drinks" then   
        local drinkX, drinkY = barX + respc(20), barY + respc(70)

        for k, v in pairs(drinks) do
            local w, h = respc(100), respc(100)
            local x = drinkX + (respc(20) + w) * (k - 1)
            
            dxDrawRectangle(x, drinkY, w, h, tocolor(unpack(v[2])))
            dxDrawImage(x, drinkY, w, h, "files/" .. v[3])            

            buttons["drink:" .. k] = {x, drinkY, w, h}
            tooltips["drink:" .. k] = {x, drinkY, w, h, v[1]}
        end

        if activeButton and string.find(activeButton, "drink:") and selectedDrink[1] then
            if getKeyState("mouse1") and not cupIsFull then
                progress = progress + 0.0075
        
                if not fillSound then
                    fillSound = playSound("files/pourdrink.mp3")
                end
        
                if progress >= 1 then
                            progress = 1
                    cupIsFull = true
                    if isElement(fillSound) then
                        destroyElement(fillSound)
                    end
                            fillSound = nil
                end
            end

            if not getKeyState("mouse1") or cupIsFull then
                if isElement(fillSound) then
                    destroyElement(fillSound)
                end
                fillSound = nil
            end
        end
    end

    if #selectedHotdog > 0 then
        drawHotdog(selectedHotdog[1], screenX - respc(300), barY - respc(236), selectedHotdog[2])
    end

    if #selectedDrink > 0 then
        drawCup(selectedDrink[1], screenX - respc(300), barY - respc(450), selectedDrink[2])
    end

   

    -- ** Active Button Check
    local cx, cy = getCursorPosition()
    activeButton = false
    
    if cx and cy then
        cx, cy = screenX * cx, screenY * cy

        for k, v in pairs(buttons) do
            if cx >= v[1] and cx <= v[1] + v[3] and cy >= v[2] and cy <= v[2] + v[4] then
                activeButton = k
                break
            end
        end

        for k, v in pairs(tooltips) do
            if cx >= v[1] and cx <= v[1] + v[3] and cy >= v[2] and cy <= v[2] + v[4] then
                drawTooltip(v[5], cx, cy, fonts.Roboto11)
                break
            end
        end
    end
end

-- =============== --
-- ** Drawok **    --
-- =============== --

function drawHotdog(typ, x, y, sausage, sizeMultipler)
	if not hotdogs[typ] then
		return
    end
    
    local sizeMultipler = sizeMultipler or 1

	local crescentSize = resp(256 * sizeMultipler) -- hotdog kép mérete
	local sausageSize = resp(264 * sizeMultipler) -- kolbász kép mérete

	dxDrawImage(x, y, crescentSize, crescentSize, "files/" .. hotdogs[typ].images[1]) -- hotdog hátsó része

	if sausages[sausage] then -- kolbász
		dxDrawImage(x + (crescentSize - sausageSize) / 2, y + (crescentSize - sausageSize) / 2 - resp(15), sausageSize, sausageSize, "files/" .. sausages[sausage].image)
	end

	dxDrawImage(x + resp(5), y + resp(10), crescentSize, crescentSize, "files/" .. hotdogs[typ].images[2]) -- hotdog elülső része
end

function drawCup(typ, x, y, liquid, sizeMultipler)
	if not cups[typ] then
		return
	end

    local sizeMultipler = sizeMultipler or 1

	local imageSize = resp(256 * sizeMultipler)
	dxDrawImage(x, y, imageSize, imageSize, "files/" .. cups[typ].images[1]) -- cup külseje

	if drinks[liquid] then
		dxDrawImageSection(x, y + imageSize, imageSize, -imageSize * progress, 0, 0, imageSize / responsiveMultipler, -imageSize / responsiveMultipler * progress, "files/cup_" .. cups[typ].mark .. "_liquid.png", 0, 0, 0, tocolor(unpack(drinks[liquid][2])))
	end

	dxDrawImage(x, y, imageSize, imageSize, "files/" .. cups[typ].images[2]) -- üveg effekt
end

function drawOrder(x, y, data, center)
    local data = data or {}
    local sizeMultipler = 0.3
    local orderW, orderH = respc(733 * sizeMultipler), respc(1233 * sizeMultipler)
    if center then
        x, y = respc(10), (screenY - orderH) * 0.5
    end

    dxDrawImage(x, y, orderW, orderH, "files/order.png")
    dxDrawText("ORDER", x, y + respc(43), x + orderW, y + orderH, tocolor(0, 0, 0), 1, fonts.RobotoB15, "center")

    local textY = y + respc(90)
    
    if data.hotdog then
        dxDrawText("Hotdog:", x + respc(10), textY, x, y, tocolor(50, 50, 50, 180), 1, fonts.Roboto14)
        textY = textY + respc(31)
        dxDrawText("- " .. hotdogs[data.hotdog[1]].name .. " hotdog", x + respc(10), textY, x, y, tocolor(50, 50, 50, 180), 1, fonts.Roboto14)
        textY = textY + respc(31)
        dxDrawText("- " .. sausages[data.hotdog[2]].name, x + respc(10), textY, x, y, tocolor(50, 50, 50, 180), 1, fonts.Roboto14)
    end

    
    if data.drink then
        textY = textY + respc(31)
        dxDrawText("Beer:", x + respc(10), textY, x, y, tocolor(50, 50, 50, 180), 1, fonts.Roboto14)
        textY = textY + respc(31)
        dxDrawText("- " .. cups[data.drink[1]].name .. " cup", x + respc(10), textY, x, y, tocolor(50, 50, 50, 180), 1, fonts.Roboto14)
        textY = textY + respc(31)
        dxDrawText("- " .. drinks[data.drink[2]][1] .. " drink", x + respc(10), textY, x, y, tocolor(50, 50, 50, 180), 1, fonts.Roboto14)
    end
end

function drawTooltip(text, x, y, font)
    local x, y = x + respc(30), y + respc(10)
    local fontHeight = dxGetFontHeight(1, font)
    local textWidth = dxGetTextWidth(text, 1, font)
    dxDrawRectangle(x - respc(10), y - respc(5), textWidth + respc(20), fontHeight + respc(10), tocolor(40, 40, 40, 140))
    dxDrawText(text, x, y - respc(5), x + textWidth + respc(20), y + fontHeight + respc(10) - respc(5), tocolor(255, 255, 255), 1, font, "left", "center")
end

function drawButton(k, text, x, y, sx, sy, hoverColor, bgColor)
	if bgColor then
		dxDrawRectangle(x, y, sx, sy, bgColor)
	else
		dxDrawRectangle(x, y, sx, sy, tocolor(75, 75, 75))
	end

	local borderColor = tocolor(125, 125, 125)
	if activeButton == k then
		borderColor = hoverColor
	end

	drawOutline(x, y, sx, sy, borderColor)
	dxDrawText(text, x, y, x + sx, y + sy, -1, 1, fonts.Roboto14, "center", "center")

	buttons[k] = {x, y, sx, sy}
end

function drawOutline(x, y, sx, sy, color)
	dxDrawRectangle(x, y, 1, sy, color) -- bal
	dxDrawRectangle(x + sx - 1, y, 1, sy, color) -- jobb
	dxDrawRectangle(x, y, sx, 1, color) -- felső
	dxDrawRectangle(x, y + sy - 1, sx, 1, color) -- alsó
end