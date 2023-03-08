local screenX, screenY = guiGetScreenSize()

local responsiveMultipler = exports.fv_hud:getResponsiveMultipler()

function respc(v)
    return math.ceil(v * responsiveMultipler)
end

function resp(v)
    return v * responsiveMultipler
end

local fonts = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
    if isElement(fonts.Roboto21) then
        destroyElement(fonts.Roboto21)
        fonts.Roboto21 = nil
    end
    fonts.Roboto21 = dxCreateFont(":fv_job_hotdog/files/Roboto-Regular.ttf", respc(21))

    if isElement(fonts.Roboto11) then
        destroyElement(fonts.Roboto11)
        fonts.Roboto11 = nil
    end
    fonts.Roboto11 = dxCreateFont(":fv_job_hotdog/files/Roboto-Regular.ttf", respc(11))

    if isElement(fonts.Roboto14) then
        destroyElement(fonts.Roboto14)
        fonts.Roboto14 = nil
    end
    fonts.Roboto14 = dxCreateFont(":fv_job_hotdog/files/Roboto-Regular.ttf", respc(14))
end)

local alphaMultipler = 1

local panelW, panelH = respc(810), respc(500)
local panelX, panelY = (screenX - panelW) * 0.5, (screenY - panelH) * 0.5

local maxRows = 13

local rowW, rowH = respc(200), respc(30)
local rowX = panelX + respc(25)

local skinW, skinH = respc(100), respc(100)
local skinX, skinY = rowX + rowW + respc(10), panelY + respc(20)

local itemW, itemH = respc(50), respc(50)
local itemX, itemY = skinX, (panelY + respc(20)) + (rowH * maxRows) - (itemH * 2) - respc(10)

local activeButton = nil

local buttons = {}
local tooltips = {}

local green = {exports.fv_engine:getServerColor("servercolor",false)};

local currentFaction = nil
local currentPackage = 1

local selectedSkin = nil
 
function renderDuty()
    buttons = {}
    tooltips = {}

    --if getPlayerName(localPlayer) == "Cody_Russel" or getPlayerName(localPlayer) == "Slavio_Mendez" or getPlayerName(localPlayer) == "Taylor_Hack" or getPlayerName(localPlayer) == "Matthew_Sanders" then
    --if getPlayerName(localPlayer) == "Cody_Russel" then
        dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(0, 0, 0, 180 * alphaMultipler))
        dxDrawRectangle(panelX, panelY, panelW, respc(5), tocolor(unpack(green)))

        dxDrawText("Öltözőszekrény", panelX + respc(20), panelY - dxGetFontHeight(1, fonts.Roboto21) - respc(1), panelX + panelW, panelY + panelH, tocolor(255, 255, 255, 255 * alphaMultipler), 1, fonts.Roboto21)

        for i = 1, maxRows do
            local rowY = panelY + respc(20) + rowH * (i - 1)

            local color = tocolor(200, 200, 200, 230 * alphaMultipler)

            if i % 2 == 0 then
                color = tocolor(40, 40, 40, 230 * alphaMultipler)
            else
                
                color = tocolor(60, 60, 60, 230 * alphaMultipler)
            end

            if currentPackage == i then
                color = tocolor(green[1], green[2], green[3], 230 * alphaMultipler)
            end
            dxDrawRectangle(rowX, rowY, rowW, rowH, color)

            local package = dutyPackages[currentFaction][i]
            if package then
                if getElementData(localPlayer,"faction_"..currentFaction.."_rank") >= package.rank then
                    dxDrawText(package.name, rowX + respc(5), rowY, rowX + rowW, rowY + rowH, tocolor(255, 255, 255, 255 * alphaMultipler), 0.8, fonts.Roboto14, "left", "center")
                    buttons["package:" .. i]  = {rowX, rowY, rowW, rowH}
                end
            end
        end

        local v = dutyPackages[currentFaction][currentPackage]
        if v then
            for i = 1, 10 do
                local x = skinX + respc(10) + (skinW + respc(10)) * (i - 1)
                local y = skinY

                if i > 5 then
                    x = skinX + respc(10) + (skinW + respc(10)) * ((i - 5) - 1)
                    y = y + skinH + respc(10)
                end

                if v.skins[i] then
                    local color = tocolor(200, 200, 200, 230 * alphaMultipler)
                    if selectedSkin == v.skins[i] then
                        color = tocolor(green[1], green[2], green[3], 230 * alphaMultipler)
                    end

                    dxDrawRectangle(x, y, skinW, skinH, color)
                    dxDrawImage(x, y, skinW, skinH, ":fv_assets/images/skins/" .. v.skins[i] .. ".png")
                    buttons["skin:" .. v.skins[i]] = {x, y, skinW, skinH}
                end
            end

            dxDrawText("Szolgálati tárgyak", itemX, itemY - dxGetFontHeight(1, fonts.Roboto14) - respc(5), itemX, itemY, tocolor(255, 255, 255, 255 * alphaMultipler), 1, fonts.Roboto14)

            for i = 1, 18 do
                local x = itemX + respc(10) + (itemW + respc(10)) * (i - 1)
                local y = itemY

                if i > 9 then
                    x = itemX + respc(10) + (itemW + respc(10)) * ((i - 9) - 1)
                    y = y + itemH + respc(10)
                end

                if v.items[i] then
                    dxDrawImage(x, y, itemW, itemH, ":fv_inventory/itemKepek/" .. v.items[i][1] .. ".png")
                    tooltips["item:" .. i] = {x, y, itemW, itemH, exports.fv_inventory:getItemName(v.items[i][1]) .. " (" .. v.items[i][2] .. " db)"}
                end
            end

            drawButton("duty", "Szolgálatba állás", rowX, panelY + panelH - respc(10) - respc(30), rowW, respc(30), tocolor(113, 208, 36))
        end

        drawButton("close", "Bezárás", panelX + panelW - respc(25) - rowW, panelY + panelH - respc(10) - respc(30), rowW, respc(30), tocolor(113, 208, 36))
    --end

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

function clickHandler(button, state)
    if button == "left" and state == "down" then
        if activeButton then
            local buttonData = split(activeButton, ":")
            if buttonData[1] == "skin" then
                selectedSkin = tonumber(buttonData[2])
            elseif buttonData[1] == "package" then
                currentPackage = tonumber(buttonData[2])
            end

            if activeButton == "duty" then
                if selectedSkin then
                    removeEventHandler("onClientRender", root, renderDuty)
                    removeEventHandler("onClientClick", root, clickHandler)
                    triggerServerEvent("comeToDuty", localPlayer, currentFaction, true, selectedSkin, currentPackage)
                    selectedSkin = nil
                else
                    outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."Nem választottál skint!",255,255,255,true);
                end
            elseif activeButton == "close" then
                removeEventHandler("onClientRender", root, renderDuty)
                removeEventHandler("onClientClick", root, clickHandler)
                selectedSkin = nil
            end
        end
    end
end

-- ** Marker

local markerSize = 1.3
local markerR, markerG, markerB = exports.fv_engine:getServerColor("blue",false)

addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if res == getThisResource() then 
        for k, v in pairs(dutyPackages) do
            local x, y, z, i, d = unpack(v.position)
            local marker = createMarker(x, y, z - 2, "cylinder", markerSize, markerR, markerG, markerB, 130)
            setElementInterior(marker, i);
            setElementDimension(marker, d);
            setElementData(marker, "duty.marker", true);
            setElementData(marker, "duty.faction", k);
            setElementData(marker, "m.custom", "duty");
        end
    end
    if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        font = exports.fv_engine:getFont("rage",10);
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
    end
end)

local showTip = false
local tipState = false
local tick = false
local dutyTick = 0
local w,h = 0,30;
local x,y = screenX/2-w/2,screenY-150;

addEventHandler("onClientMarkerHit",getRootElement(),function(hitElement,dim)
    --print("fasd")
    if hitElement == localPlayer and getElementData(source,"duty.marker") then 
        print("dsa")
        if not showTip then 
            print("asd", "asd")
            showTip = getElementData(source,"duty.faction");
            tipState = "open";
            tick = getTickCount();
            currentFaction = showTip
            
            addEventHandler("onClientRender",root,drawDuty);
        end
    end
end)

addEventHandler("onClientMarkerLeave",getRootElement(),function(hitElement,dim)
    if hitElement == localPlayer and getElementData(source,"duty.marker") then 
        if showTip then 
            showTip = false;
            tipState = "close";
            tick = getTickCount()
            currentFaction = nil
            removeEventHandler("onClientRender",root,renderDuty);
        end
    end
end)

function drawDuty()
    if tipState == "open" then 
        w = interpolateBetween(0,0,0,370,0,0,(getTickCount()-tick)/1000,"InOutQuad");
        x = screenY/2-w/2;
    else 
        w = interpolateBetween(370,0,0,0,0,0,(getTickCount()-tick)/1000,"InOutQuad");
        x = screenX/2-w/2;
        if w == 0 then 
            removeEventHandler("onClientRender",root,drawDuty);
        end
    end
    dxDrawRectangle(x,y,w,h,tocolor(0,0,0,180));
    dxDrawText("Interakcióhoz nyomd meg az 'E' gombot!",x,y,x+w,y+h,tocolor(255,255,255),1,font,"center","center",true,false,true,false);
end

local distance = 50
local texNames = {
    {"duty"}
}
local textures = {}

addEventHandler("onClientResourceStart",resourceRoot,function()
	textures = {}
	for k,v in pairs(texNames) do
		textures[v[1]] = dxCreateTexture(":fv_duty/icons/"..v[1]..".png","argb")
	end
end)

addEventHandler("onClientRender", root, function()
    for i, v in ipairs(getElementsByType("marker",resourceRoot,true)) do
       if getElementData(v,"m.custom") then
            local x,y,z = getElementPosition(v)     
            local x2,y2,z2 = getElementPosition(localPlayer)  
            local r, g, b, a = getMarkerColor(v)
            local distancePoints = getDistanceBetweenPoints3D(x, y, z, x2,y2,z2)
			if getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v) == getElementInterior(localPlayer) then
				if distancePoints <= distance then
					local size = getMarkerSize(v)
                    dxDrawMaterialLine3D(x+size/2, y+size/2, z+1.01, x-size/2, y-size/2, z+1.01, textures[getElementData(v,"m.custom")], size*1.4, tocolor(r, g, b, 155),x,y,z)
				end
			end
        end
    end
end)



addEventHandler("onClientKey", root, function(key, pressed)
    if key == "e" and pressed then
        if currentFaction then
            if getElementData(localPlayer,"faction_"..currentFaction) then 
                local currentDuty = getElementData(localPlayer,"duty.faction")
                if currentDuty and currentDuty ~= currentFaction then
                    outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."Máshol szolgálatban vagy!",255,255,255,true);
                else
                    --if dutyTick + 1000 * 5 > getTickCount() then
                        --outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."Csak fél percenként tudsz szolgálatba lépni!",255,255,255,true)
                    --else
                        if currentDuty == currentFaction then
                            triggerServerEvent("comeToDuty", localPlayer, currentFaction, false)
                            return
                        end

                        addEventHandler("onClientRender", root, renderDuty)
                        addEventHandler("onClientClick", root, clickHandler)
                        dutyTick = getTickCount()
                    --end
                end
            else
                outputChatBox(exports.fv_engine:getServerSyntax("Duty","red").."Nem vagy tag!",255,255,255,true);
            end
        end
    end
end)

-- ** Drawok  

function drawButton(k, text, x, y, sx, sy, hoverColor, bgColor)
	if bgColor then
		dxDrawRectangle(x, y, sx, sy, bgColor)
	else
		dxDrawRectangle(x, y, sx, sy, tocolor(75, 75, 75, 255 * alphaMultipler))
	end

	local borderColor = tocolor(125, 125, 125, 255 * alphaMultipler)
	if activeButton == k then
		borderColor = hoverColor
	end

	drawOutline(x, y, sx, sy, borderColor)
	dxDrawText(text, x, y, x + sx, y + sy, -1, 1, fonts.Roboto14, "center", "center")

	buttons[k] = {x, y, sx, sy}
end

function drawTooltip(text, x, y, font)
    local x, y = x + respc(30), y + respc(10)
    local fontHeight = dxGetFontHeight(1, font)
    local textWidth = dxGetTextWidth(text, 1, font)
    dxDrawRectangle(x - respc(10), y - respc(5), textWidth + respc(20), fontHeight + respc(10), tocolor(40, 40, 40, 140))
    dxDrawText(text, x, y - respc(5), x + textWidth + respc(20), y + fontHeight + respc(10) - respc(5), tocolor(255, 255, 255), 1, font, "left", "center")
end

function drawOutline(x, y, sx, sy, color)
	dxDrawRectangle(x, y, 1, sy, color) -- bal
	dxDrawRectangle(x + sx - 1, y, 1, sy, color) -- jobb
	dxDrawRectangle(x, y, sx, 1, color) -- felső
	dxDrawRectangle(x, y + sy - 1, sx, 1, color) -- alsó
end