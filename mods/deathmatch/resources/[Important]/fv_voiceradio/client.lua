local sx, sy = guiGetScreenSize()
local radioImage = dxCreateTexture("radio/radio.png")
local rix, riy = dxGetMaterialSize(radioImage)

engineImportTXD(engineLoadTXD("radio/modelRadio.txd"), 2037)
engineReplaceModel(engineLoadDFF("radio/modelRadio.dff"), 2037)

addEvent("radio.sound",true);
addEventHandler("radio.sound",root,
function(fast)
	playSoundFrontEnd(47);
	setTimer(playSoundFrontEnd, fast and 400 or 800, 1, 48);
end);


addEventHandler("onClientPlayerVoiceStart", root,
function()
	if (source == localPlayer) then return end
	if (isPlayerSameRadio(source) and getElementData(source,"use.radio")) then
		triggerEvent("radio.sound",localPlayer, true);
		setSoundEffectEnabled(source, "compressor", true)
	end
end)

addEventHandler("onClientPlayerVoiceStop", root,
function()
	if (source == localPlayer) then return end
	if (isPlayerSameRadio(source) and getElementData(source,"use.radio")) then
		triggerEvent("radio.sound",localPlayer, true);
		setSoundEffectEnabled(source, "compressor", false)
	end
end)

addEventHandler("onClientElementDataChange", root,
function (key, _, use)
    if not (key == "F7") then return end
    if wasEventCancelled(  ) then return end
    if (source == localPlayer) then
	    if key == "F7" then
	        addEventHandler("onClientRender", root, drawRadio)
	    else
	    	removeEventHandler("onClientRender", root, drawRadio)
	    end
	    playSound("radio/turnOn.mp3")
	else
		local x, y, z = getElementPosition(source)
	    local turnOn = playSound3D("radio/turnOn.mp3", x, y, z)
	    setSoundMaxDistance(turnOn, 5)
	end
end)

function drawRadio ()
	dxDrawImage(sx-rix-10, sy-riy-(10), rix, riy, radioImage)
end

function isPlayerSameRadio(thePlayer)
	if not (thePlayer and getElementType(thePlayer) == "player") then return end
	local serial = getElementData(thePlayer,"use.radio")
	local allRadio = exports.fv_inventory:getItems(thePlayer, 86)
	if allRadio and serial then
		--for _, item in ipairs(allRadio) do
			local radiof = exports.fv_inventory:getItemValue(thePlayer,86,serial)
			if radiof and radiof > 0 and exports.fv_inventory:hasItem(86, radiof) then
				return true
			end
		--end
	end
	return false
	--[[if ((getElementData(localPlayer,"char >> radiof") or 0) > 0 and exports.fv_inventory:hasItem(86)) then
		if (getElementData(thePlayer,"char >> radiof") == getElementData(localPlayer,"char >> radiof")) then
			return true
		end
	end]]
end