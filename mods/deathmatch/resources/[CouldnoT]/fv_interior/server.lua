local kapcsolat = exports["fv_engine"]:getConnection(getThisResource())

addEventHandler("onResourceStart",getRootElement(),function(res)
	if getResourceName(res) == "fv_engine" or getThisResource() == res then 
		sColor = {exports.fv_engine:getServerColor("servercolor",false)};
		sColor2 = exports.fv_engine:getServerColor("servercolor",true);
		blue = {exports.fv_engine:getServerColor("blue",false)};
		red = {exports.fv_engine:getServerColor("red",false)};
		red2 = exports.fv_engine:getServerColor("red",true);
		orange = {exports.fv_engine:getServerColor("orange",false)};
	end
end);

function foundMarkers(id)
	local result = {};
	for k, v in ipairs (getElementsByType("marker")) do
		if getElementData(v, "id") == id then
			result[#result + 1] = v;
		end	
	end
	return result;
end

function delInteriorByAdmin(player,command,target)
	if getElementData(player,"admin >> level") > 7 then 
		if not target then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [id]",player,255,255,255,true) return end;
		local target = tonumber(target);
		if target then 
			local markers = foundMarkers(target);
			if #markers > 0 then 
				local sql = dbExec(kapcsolat,"DELETE FROM interiors WHERE id=?",target);
				if sql then 
					if isElement(markers[1]) then 
						destroyElement(markers[1])
					end
					if isElement(markers[2]) then 
						destroyElement(markers[2])
					end
					outputChatBox(exports.fv_engine:getServerSyntax("Interior","servercolor").."You have successfully wiped the interior.",player,255,255,255,true);
				else 
					outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Delete failed! (MySQL error)",player,255,255,255,true);
				end
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Interior not found!",player,255,255,255,true);
				return;
			end
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [id]",player,255,255,255,true);
			return;
		end
	end
end
addCommandHandler("delinterior",delInteriorByAdmin,false,false);

addCommandHandler("addinterior", 
	function(playerSource, cmd, intid, type, name, price, faction)
		if getElementData(playerSource,"admin >> level") > 7 then 
			if intid and name and price and type and faction and (tonumber(type) > 0 and tonumber(type) < 5) then
				x,y,z = getElementPosition(playerSource)
				intbel = interiors[tonumber(intid)]
				if intbel then
					local interiorid = intbel[1]
					local ix = intbel[2]
					local iy = intbel[3]
					local iz = intbel[4]
					local query = dbQuery(kapcsolat, "INSERT INTO interiors SET x = ?, y = ?, z = ?, interiorx = ?, interiory = ?, interiorz = ?, name = ?, type = ?, cost = ?, faction = ?, interior = ?",x, y, z, ix, iy, iz, name, type, price, faction, interiorid)
					local insertered, _, insertid = dbPoll(query, -1)
					if insertered then
						loadOneInteriorWhereID(insertid)
					end
				end
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [INTERIORID] [TYPE] [NAME] [PRICE] [FACTION]", playerSource,169,139,101,true)	
				outputChatBox(exports.fv_engine:getServerSyntax("Tipusok","servercolor").."1- House", playerSource,169,139,101,true)	
				outputChatBox(exports.fv_engine:getServerSyntax("Tipusok","servercolor").."2- Business", playerSource,169,139,101,true)	
				outputChatBox(exports.fv_engine:getServerSyntax("Tipusok","servercolor").."3- Municipality", playerSource,169,139,101,true)	
				outputChatBox(exports.fv_engine:getServerSyntax("Tipusok","servercolor").."4- Garage", playerSource,169,139,101,true)	
			end
		end
	end
)

addCommandHandler("nearbyinteriors",function(player,command)
	if getElementData(player,"admin >> level") > 7 then 
		local count = 0;
		local x,y,z = getElementPosition(player);
		outputChatBox(exports.fv_engine:getServerSyntax("Interior","servercolor").."Nearby interiors:",player,255,255,255,true);
		for k,v in pairs(getElementsByType("marker",resourceRoot)) do 
			if getElementData(v,"insElement") then 
				local mx,my,mz = getElementPosition(v);
				local distance = getDistanceBetweenPoints3D(x,y,z,mx,my,mz)
				if distance < 30 then 
					count = count + 1;
					outputChatBox("- ID: "..sColor2..getElementData(v,"id")..white.." | "..sColor2..getElementData(v,"name")..white.." | Distance: "..sColor2..math.floor(distance)..white.." .",player,255,255,255,true);
				end
			end
		end
		if count == 0 then
			outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."There is no interior near you!",player,255,255,255,true);
		end
	end
end,false,false);

function loadOneInteriorWhereID(id)
	dbQuery(function(qh)
		local result = dbPoll(qh,0);
		for k, v in ipairs(result) do
			if v["owner"] > 0 and v["type"] == 1 then --Ház aminek tulaja van!
				intPickup = createMarker(v["x"],v["y"],v["z"]-1,"cylinder",0.8,sColor[1],sColor[2],sColor[3],100);			
				intinPickup = createMarker(v["interiorx"],v["interiory"],v["interiorz"]-1,"cylinder",0.8,sColor[1],sColor[2],sColor[3],100);			
			elseif v["type"] == 4 then --Garázs
				intPickup = createMarker(v["x"],v["y"],v["z"]-1,"cylinder",0.8,blue[1],blue[2],blue[3],100);			
				intinPickup = createMarker(v["interiorx"],v["interiory"],v["interiorz"]-1,"cylinder",0.8,blue[1],blue[2],blue[3],100);	
			elseif v["type"] == 3 then --Önkormányzat
				intPickup = createMarker(v["x"],v["y"],v["z"]-1,"cylinder",0.8,200,200,200,100);			
				intinPickup = createMarker(v["interiorx"],v["interiory"],v["interiorz"]-1,"cylinder",0.8,200,200,200,100);		
			elseif v["type"] == 2 and v["owner"] > 0 then 
				intPickup = createMarker(v["x"],v["y"],v["z"]-1,"cylinder",0.8,orange[1],orange[2],orange[3],100);			
				intinPickup = createMarker(v["interiorx"],v["interiory"],v["interiorz"]-1,"cylinder",0.8,orange[1],orange[2],orange[3],100);	
			else --Többbi egyéb
				intPickup = createMarker(v["x"],v["y"],v["z"]-1,"cylinder",0.8,red[1],red[2],red[3],100);			
				intinPickup = createMarker(v["interiorx"],v["interiory"],v["interiorz"]-1,"cylinder",0.8,red[1],red[2],red[3],100);	
			end
			setElementInterior(intinPickup, v["interior"])
			setElementDimension(intinPickup, v["id"])
			setElementData(intinPickup, "owner",v["owner"] )				
			setElementData(intinPickup, "locked", v["locked"])
			setElementData(intinPickup, "typePick", "inSide")
			setElementData(intinPickup, "outElement", intPickup)
			setElementData(intinPickup, "x", v["x"])				
			setElementData(intinPickup, "y",v["y"])				
			setElementData(intinPickup, "z", v["z"])					
			setElementData(intinPickup, "id", v["id"])
			setElementData(intinPickup, "type", v["type"])				
			setElementData(intPickup, "id", v["id"])
			setElementData(intPickup, "insElement", intinPickup)			
			setElementData(intPickup, "typePick", "outside")			
			setElementData(intPickup, "name",v["name"] )
			setElementData(intPickup, "type", v["type"])				
			setElementData(intPickup, "interior",v["interior"] )				
			setElementData(intPickup, "dimension", v["dimension"])				
			setElementData(intPickup, "owner",v["owner"] )				
			setElementData(intPickup, "locked", v["locked"])				
			setElementData(intPickup, "x", v["x"])				
			setElementData(intPickup, "y",v["y"])				
			setElementData(intPickup, "z", v["z"])				
			setElementData(intPickup, "intx", v["interiorx"])				
			setElementData(intPickup, "inty", v["interiory"])				
			setElementData(intPickup, "intz", v["interiorz"] )				
			setElementData(intPickup, "cost", v["cost"])				
			setElementData(intPickup, "rented", v["rented"])				
			setElementData(intPickup, "renter", v["renter"])	
			setElementData(intPickup, "kulso", false)
		end
	end,kapcsolat,"SELECT * FROM interiors WHERE id=?",id)
end

function updateOwner(pickupID, localPlayer, interiorType)
	local res = dbExec(kapcsolat, "UPDATE interiors SET owner=? WHERE id = ?", getElementData(localPlayer,"acc >> id"),pickupID)
	for k, v in ipairs (getElementsByType("marker")) do
		if getElementData(v, "id") == pickupID then
			x, y, z = getElementPosition(v)
			destroyElement(v)
		end	
	end
	loadOneInteriorWhereID(pickupID)
end
addEvent("updateInteriorOwner", true)
addEventHandler("updateInteriorOwner", getRootElement(), updateOwner)

function changeInterior(player, x, y, z, int, dim)
	setElementPosition(player, x, y, z + 0.5)
	setElementDimension(player, dim)
	setElementInterior(player, int)
end
addEvent("changeInterior", true)
addEventHandler("changeInterior", getRootElement(), changeInterior)

function changeVehInterior(player,veh, x, y, z, int, dim)
	outputDebugString(x.."  "..y.."  "..z.." dim:"..dim.."   int:" ..int)
	if veh then
		if veh == getPedOccupiedVehicle(player) then
			setElementDimension(veh, dim)
			setElementInterior(veh, int)	
			setElementPosition(veh, x, y, z + 1)
			setElementPosition(player, x, y, z + 0.5)
			setElementDimension(player, dim)
			setElementInterior(player, int)
		end
	end
end
addEvent("changeVehInterior", true)
addEventHandler("changeVehInterior", getRootElement(), changeVehInterior)

addEventHandler("onResourceStart",resourceRoot,function()
	Async:setPriority("high");
	dbQuery(function(qh)
		local result,rows = dbPoll(qh,0);
		--[[for k, v in ipairs(result) do
			loadOneInteriorWhereID(v["id"]);
		end]]
		Async:foreach(result, function(data)
			loadOneInteriorWhereID(data["id"]);
		end);
	end,kapcsolat,"SELECT id FROM interiors");
end)

function isInPickup( thePlayer, thePickup, distance )
	if isElement( thePlayer ) and isElement( thePickup ) then
		local ax, ay, az = getElementPosition(thePlayer)
		local bx, by, bz = getElementPosition(thePickup)
		return getDistanceBetweenPoints3D(ax, ay, az, bx, by, bz) < ( distance or 2 ) and getElementInterior(thePlayer) == getElementInterior(thePickup) and getElementDimension(thePlayer) == getElementDimension(thePickup)
	else
		return false
	end
end

addEvent("int > hitMarker",true);
addEventHandler("int > hitMarker",root,function(thePlayer,marker)
	local pickuptype = getElementData(marker, "type")
	
	local pdimension = getElementDimension(thePlayer)
	local idimension = getElementDimension(marker)
	
	if pdimension == idimension then
		local name = getElementData( marker, "name" )
		
		if name then
			local owner = getElementData( marker, "owner" )
			local cost = getElementData( marker, "cost" )
			local id = getElementData(marker, "id")
			local ownerName = false;
			local q = dbQuery(function(qh,cost,owner,name,type)
				local result = dbPoll(qh,0)
				if #result > 0 then 
					for k,v in pairs(result) do 
						ownerName = v["charname"];
						triggerClientEvent(thePlayer, "renderInterior", thePlayer, name, ownerName, type, cost, owner, id, true)
						if ownerName == getElementData(thePlayer,"char >> name") then 
							outputChatBox(exports.fv_engine:getServerSyntax("Interior","blue").."For sale: "..sColor2.."/sellhouse"..white..".",thePlayer,255,255,255,true);
						end
					end
				else
					triggerClientEvent(thePlayer, "renderInterior", thePlayer, name, ownerName, type, cost, owner, true)
				end
			end,{cost,owner,name,getElementData( marker, "type" )},kapcsolat,"SELECT charname FROM characters WHERE id=?",owner);
		end
	end
end);
addEvent("int > leaveMarker",true)
addEventHandler("int > leaveMarker",root,function(thePlayer,marker)
	triggerClientEvent(thePlayer, "renderInterior", thePlayer, nil, nil, nil, nil, nil,nil, false)
end);
addEvent("interior.giveKey",true);
addEventHandler("interior.giveKey",root,function(player,id)
	exports.fv_inventory:givePlayerItem(player,41,1,id,100,0);
end);


--INTERIOR ELADÁS--
addEvent("sellHouse.sendOther",true);
addEventHandler("sellHouse.sendOther",root,function(target,value)
	outputChatBox(exports.fv_engine:getServerSyntax("Interior","blue")..sColor2..getElementData(source,"char >> name")..white.." elszeretne adni neked egy interiort! "..red2.."(2 minutes to accept)"..white..".",target,255,255,255,true);
	outputChatBox(exports.fv_engine:getServerSyntax("Interior","blue").."Price: "..sColor2..formatMoney(value)..white.." dt.",target,255,255,255,true);
	outputChatBox(exports.fv_engine:getServerSyntax("Interior","blue").."Acceptance: "..sColor2.."/accepttrade "..white.."| Rejection: "..red2.."/rejecttrade",target,255,255,255,true);
	setElementData(target,"sellSource",source);
	setElementData(target,"sellValue",value);

	outputChatBox(exports.fv_engine:getServerSyntax("Interior","blue").."You offered the house for sale. Price: "..sColor2..formatMoney(value)..white.." dt"..red2.." (2 minutes for player to accept)"..white..".",source,255,255,255,true);
end);
addEvent("sellHouse.accept",true);
addEventHandler("sellHouse.accept",root,function(player,sSource,value)
	if not isElement(sSource) then 
		outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Player not found!",player,255,255,255,true);
		return;
	end
	local sourceTimer = getElementData(sSource,"sellTimer");
	if isTimer(sourceTimer) then 
		killTimer(sourceTimer);
	end
	setElementData(sSource,"sellTimer",false);

	local marker = getElementData(sSource,"sellMarker");
	setElementData(marker,"owner",getElementData(player,"acc >> id"));
	if getElementData(marker,"outElement") then 
		setElementData(getElementData(marker,"outElement"),"owner",getElementData(player,"acc >> id"));
	else 
		setElementData(getElementData(marker,"insElement"),"owner",getElementData(player,"acc >> id"));
	end
	dbExec(kapcsolat,"UPDATE interiors SET owner=? WHERE id=?",getElementData(player,"acc >> id"),getElementData(marker,"id"));

	outputChatBox(exports.fv_engine:getServerSyntax("Interior","servercolor").."The other party has accepted the sale, You have successfully sold the house!",sSource,255,255,255,true);

	setElementData(sSource,"char >> money",getElementData(sSource,"char >> money") + value);
	setElementData(player,"char >> money",getElementData(player,"char >> money") - value);

	setElementData(sSource,"sellMarker",false);

	setElementData(player,"sellSource",false);
	setElementData(player,"sellValue",false);

	outputChatBox(exports.fv_engine:getServerSyntax("Interior","servercolor").."You have successfully bought the house!",player,255,255,255,true);
end);
addEvent("sellHouse.deny",true);
addEventHandler("sellHouse.deny",root,function(player,sSource,value)
	if not isElement(sSource) then 
		outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Player not found!",player,255,255,255,true);
		return;
	end
	local sourceTimer = getElementData(sSource,"sellTimer");
	if isTimer(sourceTimer) then 
		killTimer(sourceTimer);
	end
	outputChatBox(exports.fv_engine:getServerSyntax("Interior","servercolor").."Another party refused to sell, House was not sold!",sSource,255,255,255,true);

	setElementData(sSource,"sellMarker",false);

	setElementData(player,"sellSource",false);
	setElementData(player,"sellValue",false);

	outputChatBox(exports.fv_engine:getServerSyntax("Interior","servercolor").."You have declined your purchase!",player,255,255,255,true);
end);
addEvent("sellhouse.timeLeft",true);
addEventHandler("sellhouse.timeLeft",root,function(player,target)
	setElementData(player,"sellTimer",false);
	setElementData(player,"sellMarker",false);

	outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Sales time has expired. The interior was not sold!",player,255,255,255,true);
	outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."You did not accept the sale of the offered interior within 2 minutes.",target,255,255,255,true);

	setElementData(target,"sellSource",false);
	setElementData(target,"sellValue",false);
end);