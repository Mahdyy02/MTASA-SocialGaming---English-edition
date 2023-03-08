function medicHeal(player, cmd, target,cost)
if getElementData(player,"faction_55") then 
	if not target or not cost or not tonumber(cost) or not tonumber(cost) or not math.floor(tonumber(cost)) then
		outputChatBox(exports.fv_engine:getServerSyntax("Use","red")..white.."/"..cmd.." [ID / Name] [Award]", player, 255, 255, 255, true)
		return
	end
    local targetPlayer = exports.fv_engine:findPlayer(player, target)
    local px,py,pz = getElementPosition(player)
	local tx,ty,tz = getElementPosition(targetPlayer)
	local cost = math.floor(tonumber(cost));
	if cost < 1 or cost > 2001 then 
		outputChatBox(exports.fv_engine:getServerSyntax("Heal","red").."The maximum amount is 2,000 dt", player, 255, 255, 255, true)
		return;
	end
	if targetPlayer and getDistanceBetweenPoints3D(px,py,pz,tx,ty,tz) < 3 then
		if targetPlayer == player then 
			outputChatBox(exports.fv_engine:getServerSyntax("Heal","red").."You can't heal yourself!", player, 255, 255, 255, true)
			return
		end
		if getElementData(targetPlayer, "collapsed") then
			outputChatBox(exports.fv_engine:getServerSyntax("Heal","red").."The chosen person must be helped before you can heal!", player, 255, 255, 255, true)
			return
		end

		local bone = true;
		for k,v in pairs(getElementData(targetPlayer,"char >> bone") or {true, true, true, true, true}) do 
			if not v then 
				bone = false;
				break;
			end
		end

		if getElementHealth(targetPlayer) < 100 or not bone then
			setElementHealth(targetPlayer, 100)
			outputChatBox(exports.fv_engine:getServerSyntax("Heal","servercolor").."You have successfully healed the injured!", player, 255, 255, 255, true)
			outputChatBox(exports.fv_engine:getServerSyntax("Heal","servercolor").."An ambulance healed! fee: "..exports.fv_engine:getServerColor("servercolor",true)..(cost)..white.." dt.", targetPlayer, 255, 255, 255, true)
			setElementData(targetPlayer,"char >> money",getElementData(targetPlayer,"char >> money") - cost);
			--setElementData(player,"char >> money",getElementData(player,"char >> money") + cost);
			exports.fv_dash:giveFactionMoney(6,cost);
            setElementData(targetPlayer, "char >> bone", {true, true, true, true, true})
            toggleMoveControls(targetPlayer,true)
			exports.fv_logs:createLog("Heal",getElementData(player,"char >> name").. " healed: "..getElementData(targetPlayer,"char >> name").." player. Reason: Amount: "..cost.." dt.",player,targetPlayer);
			exports.fv_admin:sendMessageToAdmin(player,exports.fv_engine:getServerColor("servercolor",true)..getElementData(player,"char >> name")..white.. " healed: "..exports.fv_engine:getServerColor("servercolor",true)..getElementData(targetPlayer,"char >> name")..white.." player. Amount: "..exports.fv_engine:getServerColor("servercolor",true)..cost..white.." dt.",3);		
		else
			outputChatBox(exports.fv_engine:getServerSyntax("Heal","red").."The selected person has no injuries!", player, 255, 255, 255, true)
		end
	else
		outputChatBox(exports.fv_engine:getServerSyntax("Heal","red").."The selected person is not near you!", player, 255, 255, 255, true)
		return
	end
else 
	outputChatBox(exports.fv_engine:getServerSyntax("Heal","red").."You don't belong in an ambulance faction!", player, 255, 255, 255, true)
	return
end
end
addCommandHandler("heal", medicHeal)

function toggleMoveControls(element,value)
    toggleControl(element,"sprint", value)
    toggleControl(element,"jump", value)
    toggleControl(element,"fire", value)
    toggleControl(element,"aim_weapon", value)
    toggleControl(element,"enter_exit", value)
end