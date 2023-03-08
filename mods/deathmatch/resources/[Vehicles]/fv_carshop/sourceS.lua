local mysql = exports.fv_engine:getConnection(getThisResource())

local poses = {
	{2148.6037597656, -1133.7009277344, 25.566972732544,262},
	{2148.125, -1138.4110107422, 25.496683120728,262},
	{2147.3857421875, -1143.3474121094, 24.95708656311,262},
	{2147.5249023438, -1147.9718017578, 24.443735122681,262},
	{2147.3415527344, -1152.9279785156, 23.901977539063,262},
	{2147.4404296875, -1157.2318115234, 23.845975875854,262},
	{2146.6416015625, -1161.5817871094, 23.8203125,262},
	{2147.0710449219, -1166.0432128906, 23.8203125,262},
	{2146.64453125, -1170.7515869141, 23.8203125,262},
	{2146.3044433594, -1175.5040283203, 23.8203125,262},
	{2147.2583007813, -1179.9858398438, 23.8203125,262},

	{2162.0217285156, -1177.7136230469, 23.816740036011,94},
	{2162.0891113281, -1172.9124755859, 23.819984436035,94},
	{2161.6867675781, -1168.2093505859, 23.815536499023,94},
	{2161.7329101563, -1163.2335205078, 23.81679725647,94},
	{2161.5007324219, -1157.9305419922, 23.840545654297,94},
	{2161.994140625, -1153.0467529297, 23.89324760437,94},
	{2162.1079101563, -1148.291015625, 24.376554489136,94},
	{2162.4704589844, -1143.9359130859, 24.82130241394,94},
}

local loadedLimits = {};

addEventHandler("onResourceStart",resourceRoot,function()
	getVehLimits();
end);

addEventHandler("onPlayerJoin",root,function()
	triggerClientEvent(source,"carshop.syncLimit",source,loadedLimits);
end);

function getVehLimits()
	for k,v in pairs(vehs) do 
		dbQuery(function(qh)
			local result = dbPoll(qh,0);
			loadedLimits[v[1]] = #result;
			dbFree(qh);
		end,mysql,"SELECT * FROM jarmuvek WHERE model=?",v[1]);
	end
	setTimer(function()
		triggerClientEvent(root,"carshop.syncLimit",root,loadedLimits);
	end,1000,1);
	outputDebugString("Veh Limits Sync");
end

setTimer(getVehLimits,1000 * 60,0);

function buyNewCar(player, vehid, cost, types, color)

	if types == "char >> premiumPoints" then 
		dbExec(mysql,"UPDATE characters SET premiumPoints=? WHERE id=?",getElementData(player,"char >> premiumPoints")-cost,getElementData(player,"acc >> id"));
	end
	setElementData(player,types,getElementData(player,types)-cost); --Levonás


	local rand = math.random(1,#poses);
	local x,y,z,rot = unpack(poses[rand]);

	dbQuery(function(qh)
		local result,_,id = dbPoll(qh,0);
		local veh = exports.fv_vehicle:addVehicle(getElementData(player,"acc >> id"),vehid,x,y,z,id,color[1],color[2],color[3],0,rot);
		loadedLimits[vehid] = loadedLimits[vehid] + 1;
		setElementData(player, "char >> bone", {true, true, true, true, true});
		triggerClientEvent(root,"carshop.syncLimit",root,loadedLimits);
		exports.fv_infobox:addNotification(player,"success","Successful purchase! You can find the vehicle in the parking lot.");
		exports.fv_inventory:givePlayerItem(player,40,1,id,100,0);
	end,mysql,"INSERT INTO jarmuvek SET x=?, y=?, z=?, rot=?, model=?, jarmuSzine=?",x,y,z,toJSON({0,0,rot}),vehid,toJSON(color));
	--triggerClientEvent(player,"closeShop",player);
end
addEvent("onServerBuy", true)
addEventHandler("onServerBuy", getRootElement(), buyNewCar)

