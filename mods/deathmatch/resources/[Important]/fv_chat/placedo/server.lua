local placeDoCache = {}

function placeDo(playerSource,cmd,...)
	if getElementData(playerSource,"loggedIn") then
		if getElementData(playerSource,"placedo") > 5 then outputChatBox(exports.fv_engine:getServerSyntax("PlaceDo","red").."Simultaneously deposited do number 5! Delete the current ones if you want to put down a new one.",playerSource,255,255,255,true) return end;
		if(...)then
			local message = table.concat({...}, " ")
			if(#message >= 8 and #message <= 200)then
				local x,y,z = getElementPosition(playerSource)
				local dbid = getElementData(playerSource,"acc >> id")
				local name = getElementData(playerSource,"char >> name"):gsub("_", " ") or getPlayerName(playerSource):gsub("_", " ")
				local id = #placeDoCache+1;
				placeDoCache[id] = {
					["x"] = x,
					["y"] = y,
					["z"] = z,
					["owner"] = dbid,
					["ownerName"] = name,
					["message"] = message,
				}
				setTimer(function()
					if placeDoCache[id] then 
						local doOwner = findByAccountID(placeDoCache[id]["owner"]);
						if doOwner then 
							setElementData(doOwner,"placedo",getElementData(doOwner,"placedo") - 1);
						end
						table.remove(placeDoCache,id);
						triggerClientEvent(root,"receivePlaceDo",root,placeDoCache);
					end
				end,1000*60*10,1);
				triggerClientEvent(root,"receivePlaceDo",root,placeDoCache);
				setElementData(playerSource,"placedo",getElementData(playerSource,"placedo") + 1);
				outputChatBox(exports.fv_engine:getServerSyntax("PlaceDo","servercolor").."Do not put down, if you do not delete after 10 minutes will be automatically deleted!",playerSource,255,255,255,true);
			else
				outputChatBox(exports.fv_engine:getServerSyntax("PlaceDo","red").."The text can be a minimum of 8 and a maximum of 200 characters.", playerSource,61,122,188,true)
			end
		else
			outputChatBox(exports.fv_engine:getServerSyntax("Use","servercolor").."/" .. cmd .. " [text]", playerSource,61,122,188,true)
		end
	end
end
addCommandHandler("placedo",placeDo,false,false)

addEvent("deleteMyOnePlaceDo",true)
addEventHandler("deleteMyOnePlaceDo",getRootElement(),function(playerSource,id)
	table.remove(placeDoCache,id);
	triggerClientEvent(root,"receivePlaceDo",root,placeDoCache);
	outputChatBox(exports.fv_engine:getServerSyntax("PlaceDo","servercolor").."Deleted successfully!",playerSource,255,255,255,true);
end);

addEvent("placeDoSync",true)
addEventHandler("placeDoSync",getRootElement(),function(playerSource)
	triggerClientEvent(root,"receivePlaceDo",root,placeDoCache);
end);

function findByAccountID(id)
	local found = false;
	for k, v in pairs(getElementsByType("player")) do 
		if (getElementData(v,"acc >> id") or 0) == id then 
			found = v;
			break;
		end
	end
	return found;
end