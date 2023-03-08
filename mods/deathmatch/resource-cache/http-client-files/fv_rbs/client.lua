local x, y = guiGetScreenSize()
local start = getTickCount()
local progress = ""
local tempX, tempY, tempZ, tempPRot = nil
local tempRot
local cObject
local objectID
local curr = -1
local showpanel = false

addCommandHandler("rbs", function()
    if getElementData(localPlayer, "faction_53") or getElementData(localPlayer,"faction_54") or getElementData(localPlayer,"faction_17") then
        if showpanel then
            showpanel = false
        else
            showpanel = true
            start = getTickCount()
            progress = "OutBounce"
        end
    else
        outputChatBox("[#CA2323The#ffffffDevils]: Sorry, you can't create one #CA2323Roadblock#ffffff because you are not a law enforcement member!", 255,255,255,true)
    end
end)

addEventHandler("onClientRender", getRootElement(), function()
    if showpanel then
        local startTime = (getTickCount()-start)/1200
        local panelH = interpolateBetween(10,0,0,300,0,0, startTime, progress)

        dxDrawRectangle(x/2-200/2, y/2-panelH/2, 200, panelH, tocolor(0,0,0,100))
        dxDrawRectangle(x/2-204/2, y/2-panelH/2-2, 204, panelH+4, tocolor(0,0,0,100))
        dxDrawRectangle(x/2-204/2, y/2-panelH/2-2, 2, panelH+4, tocolor(124,197,118,255))

        if panelH == 300 then

            for k, v in ipairs(objects) do
                if isInSlot(x/2-150/2, y/2-165+24*k, 150, 20) then
                    dxDrawRectangle(x/2-150/2, y/2-165+24*k, 150, 20, tocolor(124,197,118,100))
                else
                    dxDrawRectangle(x/2-150/2, y/2-165+24*k, 150, 20, tocolor(0,0,0,100))
                end
                dxDrawText(v[2], x/2, y/2-155+24*k, _, _, tocolor(255,255,255),1,"default-bold","center","center")
            end
        end
    end
end)

addEventHandler("onClientClick", getRootElement(), function(button, state,X,Y)
    if showpanel then
        if button == "left" and state == "down" then
            for k, v in ipairs(objects) do
                if clickedBox(x/2-150/2, y/2-165+24*k, 150, 20,X,Y) then
                    outputChatBox("ClickedElement:" .. v[2])
                    if isElement(cObject) then destroyElement(cObject) end
                    curr = index
                    cObject = createObject(v[1], 0, 0, 0)
                    setElementAlpha(cObject, 150)
                    setElementInterior ( cObject, getElementInterior ( localPlayer ) )
                    setElementDimension ( cObject, getElementDimension ( localPlayer ) )
                    tempRot = v[3]
                    objectID = v[1]
                    bindKey("lalt", "down", createObjectServer)
                    updateRoadblockObject()
                    removeEventHandler("onClientPreRender",getRootElement(),updateRoadblockObject)
                    addEventHandler("onClientPreRender",getRootElement(),updateRoadblockObject)
                end
            end
        end
    end
end)


function createObjectServer()
	triggerServerEvent("createObjectToServer", localPlayer, localPlayer, objectID, tempX, tempY, tempZ, tempPRot)
	if (isElement(cObject)) then
		destroyElement(cObject)
		tempX, tempY, tempZ, tempPRot = nil
		tempRot = nil
		unbindKey ( "lalt", "down", createObjectServer)
		curr = -1
	end
	removeEventHandler("onClientPreRender",getRootElement(),updateRoadblockObject)
end

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(clickedBox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end	
end

function clickedBox(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end


function updateRoadblockObject(key, keyState)
	if (isElement(cObject)) then
		local distance = 3
		local px, py, pz = getElementPosition ( localPlayer )
		local rz = getPedRotation ( localPlayer )    

		local x = distance*math.cos((rz+90)*math.pi/180) 
		local y = distance*math.sin((rz+90)*math.pi/180)
		local b2 = 15 / math.cos(math.pi/180)
		local nx = px + x
		local ny = py + y
		local nz = pz - 0.5
		  
		local objrot =  rz + tempRot
		if (objrot > 360) then
			objrot = objrot-360
		end
		  
		setElementRotation ( cObject, 0, 0, objrot )
		moveObject ( cObject, 10, nx, ny, nz)
		
		tempX = nx
		tempY = ny
		tempZ = nz
		tempPRot = objrot
	end
end