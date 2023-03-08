local currentStamina = 100;
local isJumped = false
local controlsState = true

local increaseValue = 0.0085
local decreaseValue = 0.00375

addEventHandler("onClientPreRender", getRootElement(),
	function (timeSlice)
		--if getPedOccupiedVehicle(localPlayer) then return end;
		if not ((getElementData(localPlayer,"admin >> duty") or false) and (getElementData(localPlayer,"admin >> level") or 0) > 3 ) then
			if not doesPedHaveJetPack(localPlayer) then
				local playerVelX, playerVelY, playerVelZ = getElementVelocity(localPlayer)
				local actualSpeed = (playerVelX * playerVelX + playerVelY * playerVelY) ^ 0.5
				
				if playerVelZ >= 0.1 and not isJumped and not getPedOccupiedVehicle(localPlayer) then
					isJumped = true
					currentStamina = currentStamina - 6.5
					
					if currentStamina <= 0 then
						currentStamina = 0
						
						if controlsState then
							toggleControl("forwards", false);
							toggleControl("backwards", false);
							toggleControl("left", false);
							toggleControl("right", false);
							toggleControl("jump", false);
							toggleAllControls(false, true, false);
							triggerServerEvent("hud > sprintAnim",localPlayer,localPlayer);
							controlsState = false
						end
					end
				end
				
				if playerVelZ < 0.05 then
					isJumped = false
				end
				
				if actualSpeed < 0.05 and not isJumped then
					if currentStamina <= 100 then
						if currentStamina > 25 then
							if not controlsState then
								toggleControl("forwards", true);
								toggleControl("backwards", true);
								toggleControl("left", true);
								toggleControl("right", true);
								toggleControl("jump", true);
								toggleAllControls(true, true, true);
								exports.fv_dead:reloadBones();
								controlsState = true
							end
							
							currentStamina = currentStamina + increaseValue * timeSlice
						else
							currentStamina = currentStamina + increaseValue * timeSlice * 0.75
						end
					else
						currentStamina = 100
					end
				elseif actualSpeed >= 0.1 and not getPedOccupiedVehicle(localPlayer) then
					if currentStamina >= 0 then
						currentStamina = currentStamina - decreaseValue * timeSlice
					else
						currentStamina = 0
						
						if controlsState then
							toggleControl("forwards", false);
							toggleControl("backwards", false);
							toggleControl("left", false);
							toggleControl("right", false);
							toggleControl("jump", false);
							toggleAllControls(false, true, false);
							triggerServerEvent("hud > sprintAnim",localPlayer,localPlayer);
							controlsState = false
						end
					end
				end
				
				setPedControlState("walk", true)
			end
		end
	end
)

function getStamina()
    return currentStamina;
end
