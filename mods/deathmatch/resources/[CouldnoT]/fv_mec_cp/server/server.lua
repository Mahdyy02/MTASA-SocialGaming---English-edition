local repair_marker = createMarker (1577.3851318359, -1244.5698242188, 16.51767539978, "cylinder", 3, 135, 211, 124, 170 )
setElementAlpha(repair_marker, 0)
setElementData(repair_marker,"repair->marker",true)

function get_duty_mechanic()
	local counter = 0;
	for _,v in pairs(getElementsByType("player")) do		
		if getElementData(v,"duty.faction") == 56 then
			counter = counter + 1;
		end			
	end
	if counter == 0 then 
		setElementAlpha(repair_marker,255);
	else 
		setElementAlpha(repair_marker,0);
	end
end

setTimer ( function()
		get_duty_mechanic()
end, 5000, 0 )

function marker_on( hitElement, matchingDimension ) 
	 if getElementAlpha(repair_marker) == 255 then	
	 	if repair_marker == hitElement and getPedOccupiedVehicle ( source ) and getElementHealth(getPedOccupiedVehicle( source )) < 1000 then
	 			local cost = math.floor(1000/getElementHealth(getPedOccupiedVehicle( source ))*15)+exports.fv_carshop:getCost(getElementModel(getPedOccupiedVehicle ( source )))/100*5

		 		outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."If you want to have your vehicle fitted, press the letter 'E'",source,255,255,255,true);
				outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."The price of the repair costs "..formatMoney(cost).." dt.",source,255,255,255,true);
			 	
			 	bindKey ( source, "E", "down", car_fix)
		 	
		end
	 end	
end
addEventHandler( "onPlayerMarkerHit", getRootElement(), marker_on )

function marker_off( hitElement, matchingDimension  )
	if getElementAlpha(repair_marker) == 255 then
		if repair_marker == hitElement and getPedOccupiedVehicle ( source ) then
		 	unbindKey ( source, "E", "down", car_fix ) 
		end
	end	
end
addEventHandler( "onPlayerMarkerLeave", getRootElement(), marker_off )

function car_fix(player,cost2)
	
	local car = getPedOccupiedVehicle ( player )
	if getElementHealth(car) < 1000 then
		local cost = math.floor(1000/getElementHealth(getPedOccupiedVehicle( player ))*15)+exports.fv_carshop:getCost(getElementModel(getPedOccupiedVehicle ( player )))/100*5
		setElementData(player, "char >> money", math.floor(getElementData(player, "char >> money")-tonumber(cost) ))
		unbindKey ( player, "E", "down", car_fix ) 
		fixVehicle(car)
		outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."Your vehicle has started to be assembled!",player,255,255,255,true);
		setElementFrozen ( getPedOccupiedVehicle( player ), true )
		toggleControl (player, "enter_exit", false ) 
		setTimer ( function()
			toggleControl (player, "enter_exit", true ) 
			setElementFrozen ( getPedOccupiedVehicle( player ), false )
			outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."You have successfully repaired your vehicle!",player,255,255,255,true);
			outputChatBox(exports.fv_engine:getServerSyntax("Mechanic","servercolor").."The price of the repair is "..formatMoney(cost).." dt.",player,255,255,255,true);
		end, 60000, 1 )--60000
	end	
end
 


function formatMoney(amount)
    amount = tonumber(amount);
    if not amount then 
        return "";
    end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end