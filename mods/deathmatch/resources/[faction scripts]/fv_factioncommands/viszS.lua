local timer = {};

function endMove(thePlayer, target)
    if target then 
        if getElementData(thePlayer, "move >> vive") then
            local x, y, z = getElementPosition(thePlayer)
            if isTimer(timer[getElementData(target, "acc >> id")]) then
                killTimer(timer[getElementData(target, "acc >> id")])
            end
            toggleAllControls(thePlayer, true)
            setElementFrozen(thePlayer, false)
            setElementData(thePlayer, "move >> status", false)
            setElementData(thePlayer, "move >> vive", false)	
        end
    else 
        if getElementData(thePlayer, "move >> viszi") then
			local x, y, z = getElementPosition(thePlayer)	
			if isTimer(timer[getElementData(thePlayer, "acc >> id")]) then
				killTimer(timer[getElementData(thePlayer, "acc >> id")])
			end
			toggleAllControls(getElementData(thePlayer, "move >> viszi"), true)
			setElementFrozen(getElementData(thePlayer, "move >> viszi"), false)
			setElementFrozen(getElementData(thePlayer, "move >> viszi"), true)
			setElementData(thePlayer, "move >> status", false)
			setElementData(getElementData(thePlayer, "move >> viszi"), "move >> status", false)
			setElementData(getElementData(thePlayer, "move >> viszi"), "move >> vive", false)
			setElementData(thePlayer, "move >> viszi", false)
	    end
    end
end

addEventHandler("onPlayerQuit", getRootElement(), function()
	if getElementData(source, "move >> status") == 2 then
		for k, v in ipairs(getElementsByType("player")) do
			if getElementData(v, "move >> viszi") == source then
                endMove(v)
            end
		end
	elseif getElementData(source, "move >> status") == 1 then
		for k, v in ipairs(getElementsByType("player")) do
			if getElementData(v, "move >> vive") == source then
				endMove(v, source)
			end
		end
	end
end);

addEventHandler("onVehicleEnter", getRootElement(), function(thePlayer, seat, jacked)
    if isElement(getElementData(thePlayer, "move >> viszi")) then
		local veh = getPedOccupiedVehicle(thePlayer);
		local enterSeat = 2;
		local siker = false;
		while(not siker) do 
			if not getVehicleOccupants(veh)[enterSeat] and warpPedIntoVehicle(getElementData(thePlayer, "move >> viszi"), veh, enterSeat) then 
				siker = true;
			else 
				enterSeat = enterSeat + 1;
				if enterSeat > 5 then 
					enterSeat = 1;
				end
			end
		end
		if siker then 
			exports.fv_chat:sendLocalMeAction(thePlayer, "implants the person he is driving in the vehicle.");
		end
    end
end);

addEventHandler("onVehicleExit", getRootElement(), function(thePlayer)
	if isElement(thePlayer) and getElementData(thePlayer, "move >> status") == 1 then
		if isElement(getElementData(thePlayer, "move >> viszi")) then
			local veh = source
			if (veh) then
				if (removePedFromVehicle(getElementData(thePlayer, "move >> viszi"))) then
					exports.fv_chat:sendLocalMeAction(thePlayer, "takes the detainee out of the vehicle.")
					setElementFrozen(getElementData(thePlayer, "move >> viszi"), true)
				end
			end
		end
	end
end);

--PARANCSOK--
function movePlayer(thePlayer, commandName, targetPlayer)
	if getElementData(thePlayer, "loggedIn") then
	
		if not (targetPlayer) and not getElementData(thePlayer, "move >> viszi") then
			outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/" .. commandName .. " [Name / ID]", thePlayer, 255 ,255, 255, true)
		elseif not (targetPlayer) and getElementData(thePlayer, "move >> viszi") then
			
			local x, y, z = getElementPosition(thePlayer)
			setElementPosition(getElementData(thePlayer, "move >> viszi"), x, y+0.5, z)
			
			exports.fv_chat:sendLocalMeAction(thePlayer, "let go " .. getPlayerName(getElementData(thePlayer, "move >> viszi")):gsub("_"," ") .. ".")
			
			if isTimer(timer[getElementData(thePlayer, "acc >> id")]) then
				killTimer(timer[getElementData(thePlayer, "acc >> id")])
			end
			
			toggleAllControls(getElementData(thePlayer, "move >> viszi"), true)
			setElementFrozen(getElementData(thePlayer, "move >> viszi"), false)
			setElementData(thePlayer, "move >> status", false)
			setElementData(getElementData(thePlayer, "move >> viszi"), "move >> status", false)
			setElementData(getElementData(thePlayer, "move >> viszi"), "move >> vive", false)
			setElementData(thePlayer, "move >> viszi", false)
		
		else
			
			local targetPlayer, targetPlayerName = exports.fv_engine:findPlayer(thePlayer, targetPlayer)
			
			if (targetPlayer) then
				
				local playerVisz = getElementData(thePlayer, "move >> viszi")
				local player = getElementData(thePlayer, "move >> status")
				local target = getElementData(targetPlayer, "move >> status")
			
				if isPedInVehicle(targetPlayer) then outputChatBox(exports.fv_engine:getServerSyntax("Carry","red").."The player is in a vehicle.", thePlayer, 255, 255, 255, true) return end
				if player then outputChatBox(exports.fv_engine:getServerSyntax("Carry","red").."You're already carrying someone.", thePlayer, 255, 255, 255, true) return end
				if target then outputChatBox(exports.fv_engine:getServerSyntax("Carry","red").."They're already carrying this player.", thePlayer, 255, 255, 255, true) return end
				
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				if (distance < 5) then
				
				if not getElementData(targetPlayer, "cuffed") then outputChatBox(exports.fv_engine:getServerSyntax("Carry","red").."You have to handcuff you first.", thePlayer, 255, 255, 255, true) return end
				
					if thePlayer == targetPlayer then outputChatBox(exports.fv_engine:getServerSyntax("Carry","red").."You can't take yourself.", thePlayer, 255 ,255, 255, true)return end	
						
						setElementData(thePlayer, "move >> viszi", targetPlayer)
						setElementData(targetPlayer, "move >> vive", thePlayer)
						setElementData(thePlayer, "move >> status", 1)
						setElementData(targetPlayer, "move >> status", 2)
						
						toggleAllControls(targetPlayer, false)
						setElementFrozen(targetPlayer, true)
						toggleControl(targetPlayer, "chatbox", true)
						toggleControl(targetPlayer, "screenshot", true)
						exports.fv_chat:sendLocalMeAction(thePlayer, "grabbed " .. getElementData(targetPlayer,"char >> name") .." and took it with him")
					
						 timer[getElementData(thePlayer, "acc >> id")] = setTimer(function()
                            if isElement(thePlayer) then
                                local ajail = getElementData(targetPlayer,"char >> adminJail");
								if ajail and ajail[1] == 1 then
                                    endMove(thePlayer);
									killTimer(timer[getElementData(thePlayer, "acc >> id")])
									return
								end
								x, y, z = getElementPosition(thePlayer)
								int, dim = getElementInterior(thePlayer), getElementDimension(thePlayer)
								setElementPosition(targetPlayer, x, y+1, z)
								setElementInterior(targetPlayer, int)
								setElementDimension(targetPlayer, dim)
                                if not isElement(targetPlayer) then
                                    endMove(thePlayer);
                                end
							end
						end, 500, 0)
					
				else
					outputChatBox(exports.fv_engine:getServerSyntax("Carry","red").."You are too far from the player.", thePlayer, 255, 255, 255, true)
				end
			end	
		end
	end
end
addCommandHandler("carry", movePlayer, false, false)