local showTime = 6
local bubbles = {}
--[[
Tábla felépítése:
bubbles = {element, text, {r,g,b}, id}
]]
local bubblesID = 0
local maxBubbles = 3

function jsonGET(file)
    local fileHandle
    local jsonDATA = {}
    if not fileExists(file) then
        fileHandle = fileCreate(file)
        fileWrite(fileHandle, toJSON({["disabled"] = false}))
        fileClose(fileHandle)
        fileHandle = fileOpen(file)
    else
        fileHandle = fileOpen(file)
    end
    if fileHandle then
        local buffer
        local allBuffer = ""
        while not fileIsEOF(fileHandle) do
            buffer = fileRead(fileHandle, 500)
            allBuffer = allBuffer..buffer
        end
        jsonDATA = fromJSON(allBuffer)
        fileClose(fileHandle)
    end
    return jsonDATA
end
 
function jsonSAVE(file, data)
    if fileExists(file) then
        fileDelete(file)
    end
    local fileHandle = fileCreate(file)
    fileWrite(fileHandle, toJSON(data))
    fileFlush(fileHandle)
    fileClose(fileHandle)
    return true
end

local value = {}
value["disabled"] = false

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        value = jsonGET("bubbles/@save.json")
    end
)

addEventHandler("onClientResourceStop", resourceRoot,
    function()
        jsonSAVE("bubbles/@save.json", value)
    end
)

function toggleBubbles(cmd)
    value["disabled"] = not value["disabled"]
    if not value["disabled"] then
        local syntax = exports['fv_engine']:getServerSyntax(false, "success")
        outputChatBox(syntax.. "You've successfully turned on the bubbles!", 255,255,255,true)
        addEventHandler("onClientRender", root, drawnBubbles, true, "low-5")
    else
        local syntax = exports['fv_engine']:getServerSyntax(false, "success")
        outputChatBox(syntax.. "You have successfully disabled text bubbles!", 255,255,255,true)
        removeEventHandler("onClientRender", root, drawnBubbles)
    end
end
addCommandHandler("bubbles", toggleBubbles)
addCommandHandler("togglebubbles", toggleBubbles)
addCommandHandler("bubble", toggleBubbles)
addCommandHandler("togglebubble", toggleBubbles)

local fontsize = 1
local font = exports['fv_engine']:getFont("Roboto", 12)
addEventHandler("onClientResourceStart", root,
    function(startedRes)
        if getResourceName(startedRes) == "fv_engine" then
            font = exports['fv_engine']:getFont("Roboto", 12)
        end
    end
)

function addBubble(element, text, r,g,b)
    if #bubbles + 1 > maxBubbles then return end
    local element, text, r,g,b = element, text, r, g, b
    local flood = false
    
    if getPedOccupiedVehicle(element) then
        if getElementData(getPedOccupiedVehicle(element), "veh >> windowState") then return end
    end
    
    for k,v in pairs(bubbles) do
        if v[2] == text then
            flood = true
            return
        end
    end
    
    for k,v in pairs(bubbles) do
        if v[1] == element then
            bubbles[k][7] = bubbles[k][7] + 1
        end
    end
    
    --if flood then return end --antiflood
    
    local length = dxGetTextWidth(text, fontsize, font) + 20
    local tableToRecord = {element, text, r,g,b,255, 1, length, "normal"}
    table.insert(bubbles, tableToRecord)
    setTimer(
        function()
            for k,v in pairs(bubbles) do
                if v[1] == element and v[2] == text then
                    bubbles[k][9] = "shading"
                    return
                end
            end
        end, showTime * 1000, 1
    )
end
addEvent("addBubble", true)
addEventHandler("addBubble", root, addBubble)

function removeText(element, text)
    
    --[[
    for k,v in pairs(bubbles) do
        if v[1] == element then
            bubbles[k][7] = bubbles[k][7] - 1
        end
    end
    ]]
    
    local search = false
    for k,v in pairs(bubbles) do
        if v[1] == element and v[2] == text then
            bubbles[k] = nil
            search = true
            break
        end
    end
end

local animSpeed = 2
local maxDistance = 18

local x2,y2 = guiGetScreenSize()
local multipable = false
local multipler = 0.5
if y2 <= 768 then
    multipable = true
end

if multipable then
    multipler = 1
end

function drawnBubbles()
    if getPedOccupiedVehicle(localPlayer) then
        if getElementData(getPedOccupiedVehicle(localPlayer), "veh:ablak") then return end
    end
    local px,py,pz = getElementPosition(localPlayer)
    local cameraX, cameraY, cameraZ = getCameraMatrix()
    local int2 = getElementInterior(localPlayer)
    local dim2 = getElementDimension(localPlayer)
    for k,v in pairs(bubbles) do
        local element, text, r,g,b,a, id, length, anim = unpack(v)
        if isElement(element) then
            if isElementOnScreen(element) then
                local dim1 = getElementDimension(element)
                local int1 = getElementInterior(element)
                if getElementAlpha(element) == 255 and dim1 == dim2 and int1 == int2 then
                    local worldX, worldY, worldZ = getElementPosition(element)
                    local lineClear = isLineOfSightClear(worldX,worldY,worldZ,px,py,pz,true,false,false,true,false,false,false)
                    if lineClear then
                        local distance = math.sqrt((cameraX - worldX) ^ 2 + (cameraY - worldY) ^ 2 + (cameraZ - worldZ) ^ 2) - 3
                        if distance < 0 then
                            distance = 0
                        end
                        local boneX, boneY, boneZ = getPedBonePosition(element, 5)
                        --local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
                        if distance < maxDistance then
                            local size = 1 - (distance / maxDistance)
                            --[[
                            if distance <= 5 then
                                size = 1
                            end
                            
                            local sx, sy = getScreenFromWorldPosition(x,y,z + (0.2*multipler)*size + ((0.15*multipler) * id)*size)
                            local specialText = getElementData(element, "specialText")
                            if specialText then
                                if multipable then
                                    sx, sy = getScreenFromWorldPosition(x, y, z + (0.4*multipler)*size + ((0.15*multipler) * id)*size)
                                else   
                                    sx, sy = getScreenFromWorldPosition(x, y, z + (0.85*multipler)*size + ((0.15*multipler) * id)*size)
                                end
                            else
                                if multipable then
                                    sx, sy = getScreenFromWorldPosition(x, y, z + (0.3*multipler)*size + ((0.15*multipler) * id)*size)
                                else   
                                    sx, sy = getScreenFromWorldPosition(x, y, z + (0.67*multipler)*size + ((0.15*multipler) * id)*size)
                                end
                            end
                            ]]
                            local sx, sy = getScreenFromWorldPosition(boneX, boneY, boneZ + 0.4)
                            local specialText = getElementData(element, "specialText")
                            if specialText then
                                sx, sy = getScreenFromWorldPosition(boneX, boneY, boneZ + 0.6)
                            end
                            local veh = getPedOccupiedVehicle(element)
                            if sx and sy and not veh then
                                local sy = sy - ((40 * id) * size)
                                --local sx, sy = math.floor(sx), math.floor(sy)
                                if anim == "shading" then
                                    bubbles[k][6] = bubbles[k][6] - animSpeed
                                    a = a - animSpeed
                                    if bubbles[k][6] <= 0 then
                                        a = 0
                                        bubbles[k][6] = 0
                                        bubbles[k][9] = "normal"
                                        removeText(element, text)
                                    end
                                end
                                roundedRectangle(sx - ((length)/2 * size), sy, (length * size), 20 * size, tocolor(0,0,0,math.min(220, a)), tocolor(0,0,0,0))
                                dxDrawRectangle(sx - ((length)/2 * size), sy, (length * size), 20 * size, tocolor(0,0,0,math.min(180, a)))
                                dxDrawText(text, sx, sy, sx, sy + ((35)/2)*size, tocolor(r,g,b,a), size, font, "center", "center")
                            end
                        end
                    end
                end
            end
        else
            bubbles[k] = nil
        end
    end
end

addEventHandler("onClientPlayerQuit", root,
    function()
        if bubbles[source] then
            bubbles[source] = nil
        end
    end
)
    
if not value["disabled"] then
    addEventHandler("onClientRender", root, drawnBubbles, true, "low-5")
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 180)
		end
		if (not bgColor) then
			bgColor = borderColor
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
        
        --Sarkokba pötty:
        dxDrawRectangle(x + 0.5, y + 0.5, 1, 2, borderColor, postGUI); -- bal felső
        dxDrawRectangle(x + 0.5, y + h - 1.5, 1, 2, borderColor, postGUI); -- bal alsó
        dxDrawRectangle(x + w - 2, y + 0.5, 1, 2, tocolor(0,0,0,255), postGUI); -- bal felső
        dxDrawRectangle(x + w - 2, y + h - 1.5, 1, 2, borderColor, postGUI); -- bal alsó
	end
end