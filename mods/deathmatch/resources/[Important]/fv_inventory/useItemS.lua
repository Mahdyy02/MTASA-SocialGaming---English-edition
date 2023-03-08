addEvent("item.pps",true);
addEventHandler("item.pps",root,function(player,type)
	if type == "fix" then 
		local veh = getPedOccupiedVehicle(player);
		fixVehicle(veh);
	elseif type == "fuel" then 
		local veh = getPedOccupiedVehicle(player);
		setElementData(veh,"veh:uzemanyag",100);
	elseif type == "unflip" then 
		local veh = getPedOccupiedVehicle(player);
		local rx, ry, rz = getVehicleRotation(veh);
		setVehicleRotation(veh, 0, ry, rz);
	elseif type == "heal" then 
		setElementHealth(player,100);
		setElementData(player,"char >> food",100);
		setElementData(player,"char >> drink",100);
		setElementData(player, "char >> bone", {true, true, true, true, true});
	end
end);
-------------------------
-- New
maskTable = {};

maskTable["devil"] = {1512, 1, 90};
maskTable["vendetta"] = {1455, 1, 90}; 
maskTable["horse"] = {1485, 1, 90};
maskTable["darth"] = {1484, 1, 90};  
maskTable["gasmask"] = {1487, 1, 90}; 
maskTable["kovboy"] = {1543, 1, 90};
maskTable["zombie"] = {1544, 1, 90}; 
maskTable["vampire"] = {1666, 1, 90}; 
maskTable["skull"] = {1667, 1, 90}; 
maskTable["raccoon"] = {1668, 1, 180}; 
maskTable["owl"] = {1950, 1, 180}; 
maskTable["cat"] = {1951, 1, 180}; 
maskTable["bag"] = {1551, 1, 90}; 
maskTable["dog"] = {1546, 1, 90}; 
maskTable["baby"] = {1669, 1, 90}; 
maskTable["monster"] = {2855, 1, 90};
maskTable["tilki"] = {1854, 1, 90}; 
maskTable["admin"] = {1855, 1, 180}; 

obje = {};

-----------------------------------------------------------
fishingRods = {};
local foods = {};
local hifis = {};

local easterItems = {
    {2,1},
    {3,1},
    {4,1},
    {5,1},
    {6,1},
    {7,1},
    {8,1},
	{9,1},
	{6,1},
    {7,1},
    {8,1},
    {9,1},
    {10,1},
    {11,1},
    {12,1},
	{13,1},
	{8,1},
    {9,1},
    {10,1},
    {11,1},
    {12,1},
	{13,1},
	{8,1},
    {9,1},
    {10,1},
    {11,1},
    {12,1},
    {13,1},
	{14,1},
	{11,1},
    {12,1},
    {13,1},
    {14,1},
    {24,1},
    {31,30},
    {31,20},
    {31,10},
    {19,1},
    {70,1},
    {71,1},
    {86,1},
    {89,1},
    {91,1},
    {92,1},
}

local weaponSkills = {  
	{"Colt-45",22,69},
	{"Desert Eagle",24,71},

	{"AK-47",30,77},
	{"M4",31,78},

	{"Shotgun",25,72},
	{"Sawed-off",26,73},

	{"Mesterlövész / Vadászpuska",34,79},

	{"MP5",29,76},
	{"UZI",28,75},
},


addEvent("item.useItem",true);
addEventHandler("item.useItem",root,function(player,item,slot)
	-- local itemID, dbID, value, state, count, table = unpack(item);
	local itemID, dbID, count, value, state, table = unpack(item);
	if fegyverek[itemID] then
		if getElementData(player,"collapsed") or getElementData(player,"cuffed") or getElementData(player,"char >> taser") or isPedDead(player) then 
			outputChatBox (exports.fv_engine:getServerSyntax("Item","red").."You can't use it!", player, 255,0,0,true);
			return;
		end
		if fegyverek[itemID][2] then
			local darab = howMuchItemHave (player, fegyverek[itemID][2], 1 ) 
			if darab > 0 then
				if getElementData ( player, "weaponusing") then
					if getElementData(player, "weaponusing") == dbID then
						takePlayerWeapon(player);
					else
						outputChatBox (exports.fv_engine:getServerSyntax("Item","red").."Put your weapon first!", player, 255,0,0,true);
					end
				else
					exports.fv_chat:sendLocalMeAction(player, "pulled out a gun ("..getItemName(itemID)..").",1);
					setPedAnimation(player, "COLT45", "sawnoff_reload", 500, false, false, false, false)
					setElementData(player, "weaponusing", dbID );	
					setElementData ( player , "weaponID", itemID );
					refreshAmmoUsing(player, fegyverek[itemID][2]);
					giveWeapon ( player, fegyverek[itemID][1], darab, true )
					setElementData ( player, "ammoID", fegyverek[itemID][2] );
				end
			else
				if getElementData(player, "weaponusing") == dbID then
					takePlayerWeapon(player);
				else
					outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You have no ammunition!", player, 255,0,0,true);
				end
			end
		else
			if getElementData ( player, "weaponusing") then
				if getElementData (player, "weaponusing") == dbID then
					takePlayerWeapon(player);
				else
					outputChatBox (exports.fv_engine:getServerSyntax("Item","red").. "Put your weapon first!", player, 255,0,0,true );					
				end
			else
				exports.fv_chat:sendLocalMeAction(player, "pulled out a gun ("..getItemName(itemID)..").",1);
				setElementData(player, "weaponusing", dbID );	
				setElementData ( player , "weaponID", itemID );
				setElementData ( player, "ammoID", false );
				giveWeapon ( player, fegyverek[itemID][1], 999999, true )		
			end
		end
	end
	if itemID == 1 then --Telefon
		dbQuery(function(qh)
			local res = dbPoll(qh,0);
			if #res > 0 then
				for k,v in pairs(res) do 
					triggerClientEvent(player,"phone.showClient",player,table[2],v.wallpaper,fromJSON(v.sms),fromJSON(v.calls));
				end
			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Bad Item!",player,255,255,255,true);
			end
		end,sql,"SELECT * FROM phones WHERE number=?",table[2]);
	elseif itemID == 38 then --Széf lerakás
		local dbid = makeSafe ( player, false );
		takePlayerItem (player,itemID,1,dbID);
	elseif itemID == 47 then 
		triggerClientEvent(player,"identity.showSzemelyi",player, value);
	elseif itemID == 48 then 
		triggerClientEvent(player,"passport.showUtlevel",player, value);
	elseif itemID == 69 then --Hi-Fi
		if isPedInVehicle(player) then 
			outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You cannot use it in a vehicle!",player,255,255,255,true);
			return;
		end
		local pos = Vector3(getElementPosition(player));
		local rot = Vector3(getElementRotation(player));
		local obj = createObject(2103,pos.x,pos.y,pos.z-1,rot.x,rot.y,180+rot.z);
		setElementDimension(obj,getElementDimension(player));
		setElementInterior(obj,getElementInterior(player));    
		local id = #hifis+1;
		hifis[id] = obj;
		exports.fv_chat:sendLocalMeAction(player, "put down a hi-fi.",1);
		setElementData(obj,"hifi.id",id);
		setElementData(obj,"hifi.state",false);
		setElementData(obj,"hifi.station",false);
		setElementData(obj,"hifi.volume",80);
		takePlayerItem(player,itemID,1,dbID);
	elseif itemID == 88 then --Jelvény
		local text = table[2];
		if getElementData(player,"char >> jelveny") then 
			setElementData(player,"char >> jelveny",false);
			exports.fv_chat:sendLocalMeAction(player, "takes off his badge.",1);
		else 
			setElementData(player,"char >> jelveny",text);
			exports.fv_chat:sendLocalMeAction(player, "puts on a badge.",1);
		end
	elseif itemID == 90 then --Adásvételi nézegetés
		local datas = table[2];
		if datas then 
			triggerClientEvent(player,"sell.showClient",player,datas);
		end
	elseif itemID == 95 then --Húsvéti tojás
		if math.random(0,100) > 20 then 
			local giveID, giveCount = unpack(easterItems[math.random(1,#easterItems)]);
			if givePlayerItem(player,giveID, giveCount, 1, 100,0) then 
				setTimer(function()
					takePlayerItem(player,itemID,1,dbID);
				end,100,1);
				outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully opened the egg! reward: "..exports.fv_engine:getServerColor("blue",true)..getItemName(giveID)..white..".",player,255,255,255,true);
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Couldn't open because you don't have room.",player,255,255,255,true);
			end
		else 
			takePlayerItem(player,itemID,1,dbID);
			outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."This egg did not contain any items.",player,255,255,255,true);
		end
	elseif itemID == 96 then --Horgászbot
		if getElementData ( player, "weaponusing") then
			if getElementData (player, "weaponusing") == dbID then
				if getElementData(player,"fishing") then 
					return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You can't put it down while fishing!",player,255,255,255,true);
				end
				exports.fv_chat:sendLocalMeAction(player, "elrakott egy fegyvert ("..getItemName(itemID)..").",1);
				setPedAnimation(player, "COLT45", "sawnoff_reload", 500, false, false, false, false)
				takePlayerWeapon(player);
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Item","red").. "Put your weapon first!", player, 255,0,0,true );					
			end
		else
			exports.fv_chat:sendLocalMeAction(player, "pulled out a gun ("..getItemName(itemID)..").",1);
			setPedAnimation(player, "COLT45", "sawnoff_reload", 500, false, false, false, false)
			setElementData(player, "weaponusing", dbID);	
			setElementData(player , "weaponID", itemID);
			setElementData(player, "ammoID", false);

			local rod = createObject(325,0,0,0);
			
			exports.fv_bone:attachElementToBone(rod,player,12,-0.03,0.05,0.07,0,-90,180);

			fishingRods[player] = rod;
			setElementData(player,"fishingRod",rod);
		end
	elseif itemID == 97 then --Horgászengedély
		triggerEvent("fishing.showEngedely",player,player, value);
	--Mesterkönyvek
	elseif itemID == 98 then --Colt Mesterkönyv
		local current_data = getElementData(player,"char.weaponSkills") or fromJSON("[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ] ");
		if current_data[1] == 1000 then 
			return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You have already learned to use the weapon.",player,255,255,255,true);
		end
		current_data[1] = 1000;
		setElementData(player,"char.weaponSkills",current_data);
		setPedStat(player,weaponSkills[1][3],1000);
		takePlayerItem(player,itemID,1,dbID);
		dbExec(sql,"UPDATE characters SET weaponSkill=? WHERE id=?",toJSON(current_data),getElementData(player,"acc >> id"));
		outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully learned the use of "..exports.fv_engine:getServerColor("blue",true)..weaponSkills[1][1]..white..".",player,255,255,255,true);
	elseif itemID == 99 then 
		local current_data = getElementData(player,"char.weaponSkills") or fromJSON("[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ] ");
		if current_data[2] == 1000 then 
			return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You have already learned to use the weapon.",player,255,255,255,true);
		end
		current_data[2] = 1000;
		setElementData(player,"char.weaponSkills",current_data);
		setPedStat(player,weaponSkills[2][3],1000);
		takePlayerItem(player,itemID,1,dbID);
		dbExec(sql,"UPDATE characters SET weaponSkill=? WHERE id=?",toJSON(current_data),getElementData(player,"acc >> id"));
		outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully learned the use of "..exports.fv_engine:getServerColor("blue",true)..weaponSkills[2][1]..white..".",player,255,255,255,true);
	elseif itemID == 100 then 
		local current_data = getElementData(player,"char.weaponSkills") or fromJSON("[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ] ");
		if current_data[3] == 1000 then 
			return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You have already learned to use the weapon.",player,255,255,255,true);
		end
		current_data[3] = 1000;
		setPedStat(player,weaponSkills[3][3],1000);
		takePlayerItem(player,itemID,1,dbID);
		dbExec(sql,"UPDATE characters SET weaponSkill=? WHERE id=?",toJSON(current_data),getElementData(player,"acc >> id"));
		outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully learned the use of "..exports.fv_engine:getServerColor("blue",true)..weaponSkills[3][1]..white..".",player,255,255,255,true);
	elseif itemID == 101 then 
		local current_data = getElementData(player,"char.weaponSkills") or fromJSON("[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ] ");
		if current_data[4] == 1000 then 
			return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You have already learned to use the weapon.",player,255,255,255,true);
		end
		current_data[4] = 1000;
		setElementData(player,"char.weaponSkills",current_data);
		setPedStat(player,weaponSkills[4][3],1000);
		takePlayerItem(player,itemID,1,dbID);
		dbExec(sql,"UPDATE characters SET weaponSkill=? WHERE id=?",toJSON(current_data),getElementData(player,"acc >> id"));
		outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully learned the use of "..exports.fv_engine:getServerColor("blue",true)..weaponSkills[4][1]..white..".",player,255,255,255,true);
	elseif itemID == 102 then 
		local current_data = getElementData(player,"char.weaponSkills") or fromJSON("[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ] ");
		if current_data[5] == 1000 then 
			return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You have already learned to use the weapon.",player,255,255,255,true);
		end
		current_data[5] = 1000;
		setElementData(player,"char.weaponSkills",current_data);
		setPedStat(player,weaponSkills[5][3],1000);
		takePlayerItem(player,itemID,1,dbID);
		dbExec(sql,"UPDATE characters SET weaponSkill=? WHERE id=?",toJSON(current_data),getElementData(player,"acc >> id"));
		outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully learned the use of "..exports.fv_engine:getServerColor("blue",true)..weaponSkills[5][1]..white..".",player,255,255,255,true);
	elseif itemID == 103 then 
		local current_data = getElementData(player,"char.weaponSkills") or fromJSON("[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ] ");
		if current_data[6] == 1000 then 
			return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You have already learned to use the weapon.",player,255,255,255,true);
		end
		current_data[6] = 1000;
		setElementData(player,"char.weaponSkills",current_data);
		setPedStat(player,weaponSkills[6][3],1000);
		takePlayerItem(player,itemID,1,dbID);
		dbExec(sql,"UPDATE characters SET weaponSkill=? WHERE id=?",toJSON(current_data),getElementData(player,"acc >> id"));
		outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully learned the use of "..exports.fv_engine:getServerColor("blue",true)..weaponSkills[6][1]..white..".",player,255,255,255,true);
	elseif itemID == 104 then 
		local current_data = getElementData(player,"char.weaponSkills") or fromJSON("[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ] ");
		if current_data[7] == 1000 then 
			return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You have already learned to use the weapon.",player,255,255,255,true);
		end
		current_data[7] = 1000;
		setElementData(player,"char.weaponSkills",current_data);
		setPedStat(player,weaponSkills[7][3],1000);
		takePlayerItem(player,itemID,1,dbID);
		dbExec(sql,"UPDATE characters SET weaponSkill=? WHERE id=?",toJSON(current_data),getElementData(player,"acc >> id"));
		outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully learned the use of "..exports.fv_engine:getServerColor("blue",true)..weaponSkills[7][1]..white..".",player,255,255,255,true);
	elseif itemID == 105 then 
		local current_data = getElementData(player,"char.weaponSkills") or fromJSON("[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ] ");
		if current_data[8] == 1000 then 
			return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You have already learned to use the weapon.",player,255,255,255,true);
		end
		current_data[8] = 1000;
		setElementData(player,"char.weaponSkills",current_data);
		setPedStat(player,weaponSkills[8][3],1000);
		takePlayerItem(player,itemID,1,dbID);
		dbExec(sql,"UPDATE characters SET weaponSkill=? WHERE id=?",toJSON(current_data),getElementData(player,"acc >> id"));
		outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully learned the use of "..exports.fv_engine:getServerColor("blue",true)..weaponSkills[8][1]..white..".",player,255,255,255,true);
	elseif itemID == 106 then 
		local current_data = getElementData(player,"char.weaponSkills") or fromJSON("[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ] ");
		if current_data[9] == 1000 then 
			return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You have already learned to use the weapon.",player,255,255,255,true);
		end
		current_data[9] = 1000;
		setElementData(player,"char.weaponSkills",current_data);
		setPedStat(player,weaponSkills[9][3],1000);
		takePlayerItem(player,itemID,1,dbID);
		dbExec(sql,"UPDATE characters SET weaponSkill=? WHERE id=?",toJSON(current_data),getElementData(player,"acc >> id"));
		outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully learned the use of "..exports.fv_engine:getServerColor("blue",true)..weaponSkills[9][1]..white..".",player,255,255,255,true);
	---------------
	end
end);

addEvent("hifi.up",true);
addEventHandler("hifi.up",root,function(player,hifi)
	local hifiID = getElementData(hifi,"hifi.id");
	if hifis[hifiID] then 
		destroyElement(hifis[hifiID]);
		hifis[hifiID] = nil;
	end
	givePlayerItem(player,69,1,1,100,0);
	exports.fv_chat:sendLocalMeAction(player, "picked up a hi-fi.",1);
end);

addEventHandler("onPlayerQuit",root,function()
	local player = source;
	if isElement(fishingRods[player]) then 
		destroyElement(fishingRods[player]);
		fishingRods[player] = nil
		
	 end
end);
addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
	if getElementType(source) == "player" and dataName == "itemUse.food" then 
		if newValue == "food" then 
			local obj = createObject(2703,0,0,0);
			setElementCollisionsEnabled(obj,false);
			foods[source] = obj;
			exports["fv_bone"]:attachElementToBone(foods[source], source, 12, 0, 0.02, 0.09, 0,0,0);
		elseif newValue == "drink" then 
			local obj = createObject(2647,0,0,0);
			setObjectScale(obj,0.6);
			setElementCollisionsEnabled(obj,false);
			foods[source] = obj;
			exports["fv_bone"]:attachElementToBone(foods[source], source, 11, 0.07, 0, 0.085, 90, 45, 0);
		elseif not newValue then 
			destroyFood(source);
		end
	end
end);

addEvent("itemUse.food",true);
addEventHandler("itemUse.food",root,function(player,data,itemID,item)
	if data == "food" then 
		setPedAnimation(player, "FOOD", "eat_pizza", 2000, false, true, true, false);
		exports.fv_chat:sendLocalMeAction(player, "ate a bite of  "..getItemName(itemID)..".",1);
	end
	if data == "drink" then 
		setPedAnimation(player,"VENDING", "vend_drink2_p", 2000, false, true, true, false);
		exports.fv_chat:sendLocalMeAction(player, "took a sip of "..getItemName(itemID)..".",1);
	end
	if item[5] < 10 then 
		setElementHealth(player,getElementHealth(player) - math.random(30,40));
	end
	if getElementData(player,"char >> "..data) + 10 > 100 then 
		setElementData(player,"char >> "..data,100);
	else
		setElementData(player,"char >> "..data,getElementData(player,"char >> "..data) + 10);
	end
end);

addEvent("itemUse.foodDrop",true);
addEventHandler("itemUse.foodDrop",root,function(player,dbID,itemID)
	destroyFood(player);
	takePlayerItem(player,itemID,1,dbID);
	exports.fv_chat:sendLocalMeAction(player, "threw one "..getItemName(itemID)..".",1);
	setElementData(player,"itemUse.food",false);
end);

-- New 
function set_mask(name)
	local objeid = maskTable[name][1];
	local bodyattach = maskTable[name][2];
	local zROT = maskTable[name][3];
	obje[root] = createObject ( objeid, 0, 0, 0, 0, 0, 0 );
	exports.bone_attach:attachElementToBone(obje[root],source,bodyattach,0,0,-0.61,0,0,zROT);

	--[[local objeid = maskTable[name][1];
	local bodyattach = maskTable[name][2];
	local zROT = maskTable[name][3];
	obje[source] = createObject (objeid, 0, 0, 0, 0, 0, 0);
	exports.bone_attach:attachElementToBone(obje[source],source,bodyattach,0,0,-0.61,0,0,zROT);]]
end


addEvent("setmask",true); 
addEventHandler("setmask", root, set_mask);

function remove_mask()
		if obje[root] then
			destroyElement(obje[root]);
		end
end
addEvent("removemask",true); 
addEventHandler("removemask", root, remove_mask);
--addCommandHandler ( "deletemask", remove_mask);
---------------------------------------------------------------------- 

function destroyFood(element)
	if foods[element] then 
		exports["fv_bone"]:detachElementFromBone(foods[element]);
		destroyElement(foods[element]);
		foods[element] = nil;
	end
end

addEventHandler("onPlayerQuit",root,function()
	destroyFood(source);
end);

addEvent("item.setArmor",true);
addEventHandler("item.setArmor",root,function(player,value)
	setPedArmor(player,value);
end);