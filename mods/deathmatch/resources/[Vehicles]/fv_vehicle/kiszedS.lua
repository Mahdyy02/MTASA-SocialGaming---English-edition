addEventHandler ( "onVehicleStartEnter", getRootElement(), function(player,seat,jacked)
	if jacked then
        outputChatBox (exports.fv_engine:getServerSyntax("Vehicle","orange").."This is a NON car theft, use "..exports.fv_engine:getServerColor("servercolor",true).."/eject "..white.."to get him out  of the vehicle!", player, 0, 0, 0, true )
		cancelEvent()
    end
end)

function GetClosestPlayer(p1)
	local x, y, z = getElementPosition(p1)
	local dis = 99999
	local dis2 = 0
	local player = -1
	local type = "player"
	for key,value in ipairs(getElementsByType(type)) do
		if value ~= p1 then
			local x2, y2, z2 = getElementPosition(value)
			dis2 = getDistanceBetweenPoints3D ( x, y, z, x2, y2, z2 )
			
			if tonumber(dis2) < tonumber(dis)  then
				dis = dis2;
				player = value;
			end
		end
	end
	return player
end

addCommandHandler( "eject",
	function( player, commandName)
		local otherPlayer = GetClosestPlayer(player)
		if otherPlayer ~= -1 then
			if isPedInVehicle(otherPlayer) then
				local x, y, z = getElementPosition( player )
				if getDistanceBetweenPoints3D( x, y, z, getElementPosition( otherPlayer ) ) < 5 then
					local veh = getPedOccupiedVehicle(otherPlayer);
					if getElementData(veh,"veh:locked") or isVehicleLocked(veh) then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").. "The vehicle is locked!", player, 255,255,255, true )
						return;
					end
                    if getElementData(otherPlayer,"veh:ov") then 
                        outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").. "A player has his belt fastened!", player, 255,255,255, true )
                        return;
                    end
					removePedFromVehicle ( otherPlayer )
                    exports.fv_chat:createMessage(player, "pulls a person out of the vehicle.",1)
				else
					outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").. "There are no players nearby!", player, 255,255,255, true )
				end
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Vehicle","red").. "Player Not in vehicle!", player, 255, 255, 255, true )
			end
		end
	end
)