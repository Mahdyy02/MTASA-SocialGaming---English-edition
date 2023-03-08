if fileExists("handbrakeC.lua") then
	fileDelete("handbrakeC.lua")
end

local sx,sy = guiGetScreenSize ()

hand = {}
hand.show = false
hand.x = sx-100
hand.y = sy/2-256/2
hand.cursorY = sy/2
hand.currentY = hand.y+128-(6/2)
hand.maxY1 = hand.y+30
hand.maxY2 = hand.y+220
hand.obecnaStrefa = 2
hand.strefa1 = 39
hand.strefa2 = 168
hand.strefa3 = 39
hand.bind = "lalt"
hand.state = false
hand.currentCursorPos = 0
hand.veh = nil
hand.cursorState = nil
hand.oldCursorX = sx/2
hand.oldCursorY = sy/2

typesWithHandbrake = {"Automobile", "Plane", "Monster Truck","Helicopter","Bike"}

function isTypeAvaible (typ)
	if typ then
		local res = false
		for k,v in ipairs(typesWithHandbrake) do
			if v == typ then
				return true
			end
		end
	end
end

addEventHandler( "onClientRestore", getRootElement(), function()
	local veh = getPedOccupiedVehicle (getLocalPlayer())
	if veh then
		if getVehicleOccupant (veh) == getLocalPlayer() then
			showHandbrakeGui (false)
		end
	end
end)

function setPlayerHandbrakeEditingMode (state)
	if state == true then
		bindKey (hand.bind , "both", showOrHideHandbrakeGui)
	elseif state == false then
		unbindKey (hand.bind , "both", showOrHideHandbrakeGui)
	end
end

function showOrHideHandbrakeGui (key,keystate)
	local veh = getPedOccupiedVehicle (getLocalPlayer())
	if veh then
		if getVehicleOccupant (veh) == getLocalPlayer() then
			local typ = getVehicleType (veh)
			if isTypeAvaible (typ) then
				if key == hand.bind  then
					if keystate == "down" then
						showHandbrakeGui (true) 
					end
					if keystate == "up" then
						showHandbrakeGui (false)
					end
				end
			end
		end 
	end
end

function showHandbrakeGui (state)
	if state == true then
		hand.cursorState = isCursorShowing ()
		if hand.cursorState then
			cx, cy = getCursorPosition ()
			hand.oldCursorX, hand.oldCursorY = cx*sx, cy*sy
		end
		hand.veh = getPedOccupiedVehicle(getLocalPlayer())
		if getElementSpeed (hand.veh) < 5 then
			showCursor (true)
			hand.currentCursorPos = nil
			if hand.show == false then -- bindy
				hand.currentY = hand.y + hand.strefa1 + 4 + (hand.strefa2/2) - (16/2)
			end
			hand.show = true
		end
	elseif state == false then
		if hand.cursorState == true then
			setCursorPosition (hand.oldCursorX,hand.oldCursorY)
		end
		showCursor (false)
		hand.show = false
		hand.currentCursorPos = nil
	end
	hand.obecnaStrefa = 2
end

function getHandbrakeState ()
	if hand then
		return hand.state
	end
end

addEvent ("onHandbrakeZoneChange", true)
addEventHandler ("onHandbrakeZoneChange", getRootElement(),
	function (zone)
		local veh = getPedOccupiedVehicle(getLocalPlayer())
		if veh then
			if zone == 1 then
				triggerServerEvent ("onGuiHandbrakeStateChange", getLocalPlayer(), false, veh)
			elseif zone == 3 then
				local handbrakeSound = playSound ("handbrake/handbrake.wav",false)
				setSoundVolume(handbrakeSound, 0.5)
				triggerServerEvent ("onGuiHandbrakeStateChange", getLocalPlayer(), true, veh)
			end
		end
	end
)

addEventHandler( "onClientCursorMove", getRootElement( ),
    function ( _, _, x, y )
		if isMTAWindowActive () == false and getKeyState (hand.bind) == true and hand.show == true then
			if hand.currentCursorPos == nil then
				hand.currentCursorPos = sy/2
				setCursorPosition (sx,sy/2)
				y = sy/2
			end
			local delta = (y - hand.currentCursorPos)
			local newY = hand.currentY + delta
			if newY > hand.maxY2 then
				newY = hand.maxY2
			elseif newY < hand.maxY1 then
				newY = hand.maxY1
			end
			setCursorPosition (sx,newY)
			hand.currentCursorPos = newY
			local st1 = hand.y+hand.strefa1
			local st2 = st1 + 2 + hand.strefa2
			local st3 = st2 + 2
			if newY < st1 then
				if hand.obecnaStrefa ~= 1 then
					hand.obecnaStrefa = 1
					triggerEvent ("onHandbrakeZoneChange", getRootElement(), 1)
				end
			end
			if newY > st1 and newY < st3 then
				if hand.obecnaStrefa ~= 2 then
					hand.obecnaStrefa = 2
					triggerEvent ("onHandbrakeZoneChange", getRootElement(), 2)
				end
			end
			if newY > st3 then
				if hand.obecnaStrefa ~= 3 then
					hand.obecnaStrefa = 3
					triggerEvent ("onHandbrakeZoneChange", getRootElement(), 3)
				end
			end
			hand.currentY = newY
		end
    end
)

addEventHandler ("onClientRender", getRootElement(),
	function ()
		if hand.show == true then
			local veh = getPedOccupiedVehicle(getLocalPlayer())
			if veh then
				if getElementSpeed (veh) < 5 then
					dxDrawImage (hand.x,hand.y,65,275,"handbrake/bg.png")
					dxDrawImage(hand.x,hand.currentY,64,16,"handbrake/vonal.png")
				end
			else
				showHandbrakeGui (false)
			end
		end
	end
)

addEventHandler ("onClientVehicleStartExit", getRootElement(),
	function (player,seat,door)
		if seat == 0 and player == getLocalPlayer() then
			setPlayerHandbrakeEditingMode (false)
			toggleControl ("accelerate", true)
			toggleControl ("brake_reverse", true)
			unbindKey ("accelerate", "down", informatePlayerAboutHandbrake)
			unbindKey ("brake_reverse", "down", informatePlayerAboutHandbrake)
			hand.state = false
		end
	end
)

addEventHandler ("onClientPlayerVehicleEnter", getLocalPlayer(),
	function (veh,seat)
		if seat == 0 then
			setPlayerHandbrakeEditingMode (true)
		end
	end
)

function onBrakedVehicleEnter (veh)
	toggleControl ("accelerate", false)
	toggleControl ("brake_reverse", false)
	bindKey ("accelerate", "down", informatePlayerAboutHandbrake)
	bindKey ("brake_reverse", "down", informatePlayerAboutHandbrake)
	setTimer(
		function ()
			exports.rp_help:showTip (8)
		end
	,500,1)
	hand.state = true
	toggleEmergencyIcon (2,true)
end
addEvent ("onBrakedVehicleEnter", true)
addEventHandler ("onBrakedVehicleEnter", getRootElement(), onBrakedVehicleEnter)

function onVehicleHandbrakeStateChange (state)
	if state == false then
		if hand.state == true then
			toggleControl ("accelerate", true)
			toggleControl ("brake_reverse", true)
			unbindKey ("accelerate", "down", informatePlayerAboutHandbrake)
			unbindKey ("brake_reverse", "down", informatePlayerAboutHandbrake)
			hand.state = false
			toggleEmergencyIcon (2,false)
		end
	end
	if state == true then
		if hand.state == false then
			toggleControl ("accelerate", false)
			toggleControl ("brake_reverse", false)
			bindKey ("accelerate", "down", informatePlayerAboutHandbrake)
			bindKey ("brake_reverse", "down", informatePlayerAboutHandbrake)
			hand.state = true
			toggleEmergencyIcon (2,true)
		end
	end
end
addEvent ("onVehicleHandbrakeStateChange", true)
addEventHandler ("onVehicleHandbrakeStateChange", getRootElement(), onVehicleHandbrakeStateChange)

function informatePlayerAboutHandbrake ()
	local playerVeh = getPedOccupiedVehicle (getLocalPlayer())
	if playerVeh then
		if getVehicleEngineState (playerVeh) == true then
			outputChatBox (exports.fv_engine:getServerSyntax("Jármű","red").."A kézifék be van húzva.", 255,168,0,true)
		end
	end
end

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 161
		end
	else
		return false
	end
end