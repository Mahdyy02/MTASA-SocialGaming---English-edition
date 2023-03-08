local ship = {};
local sPos = {
	["start"] = {2545.8603515625, -3500, 2.5};
	["end"] = {2545.8603515625, -2683.0007324219, 2.5};
}
local moveTime = 30000;

local spawnHour = math.random(18,20);
local lastday = 0;

local bPos = {
	{2536.1750488281, -2637.9375, 12.78125},
	{2550.1252441406, -2634.0471191406, 12.78125},
	{2548.7751464844, -2631.1555175781, 15.140625},
	{2546.7021484375, -2627.4494628906, 18.046875},
	{2536.0769042969, -2624.8542480469, 20.953125},
	{2547.1447753906, -2613.8645019531, 20.953125},
	{2555.3034667969, -2650.703125, 20.953125},
	{2537.9899902344, -2654.0703125, 20.953125},
	{2535.7297363281, -2674.1733398438, 20.953125},
	{2558.6145019531, -2682.4792480469, 20.953125},
	{2551.2873535156, -2668.1252441406, 20.953125},
	{2545.84765625, -2694.1713867188, 20.953125},
	{2532.2922363281, -2695.0544433594, 18.046875},
	{2539.18359375, -2706.8850097656, 12.78125},
	{2557.3740234375, -2705.4147949219, 12.78125},
	{2545.6774902344, -2712.6843261719, 15.140625},
	{2554.771484375, -2719.8354492188, 23.852624893188},
	{2536.9267578125, -2722.0295410156, 23.859375},
	{2547.9001464844, -2587.6687011719, 14.2265625},
	{2556.3833007813, -2601.4753417969, 12.78125},
	{2542.7895507813, -2602.802734375, 12.78125},
	{2553.98828125, -2608.9338378906, 18.046875},
	{2556.3640136719, -2617.1064453125, 20.953125},
	{2557.9702148438, -2662.8571777344, 26.765625},
	{2544.3388671875, -2664.1213378906, 26.765625},
	{2531.4965820313, -2680.4294433594, 26.765625},
	{2533.5805664063, -2643.3645019531, 26.765625},
}

addEventHandler("onResourceStart",resourceRoot,function()
	--Dokk--
	createObject(1698,2527, -2635.3, 12.5,0,0,90);
	createObject(1698,2527, -2634, 12.5,0,0,90);
	createObject(1698,2527, -2636.4, 12.5,0,0,90);
	createObject(1698,2527, -2637.7, 12.5,0,0,90);
	--------

	spawnHour = math.random(14,18);
	print(spawnHour)
	outputDebugString("WeaponShip >> "..spawnHour,0,120,120,0);
	setTimer(function()
		local hour = getRealTime().hour;
		local day = getRealTime().monthday;
		if hour == spawnHour and lastDay ~= day then 
			if #ship == 0 then 
				createShip();
			end
		end
	end,1000,0);
end);

addEvent("ship.getInfo",true);
addEventHandler("ship.getInfo",root,function(player)
	outputChatBox(exports.fv_engine:getServerSyntax("Weapon ship","servercolor").."The ship is expected "..exports.fv_engine:getServerColor("blue",true)..spawnHour..white.." arrives at.",player,255,255,255,true);
end);


function createShip()
	if not isElement(ship) then 
		ship[1] = createObject(9585,sPos["start"][1],sPos["start"][2],sPos["start"][3])
		ship[2] = createObject(9586,sPos["start"][1],sPos["start"][2]-2.3,sPos["start"][3]+10)
		ship[3] = createObject(9584,sPos["start"][1],sPos["start"][2]-75,sPos["start"][3]+18)
		ship[4] = createObject(9587,sPos["start"][1],sPos["start"][2]+14,sPos["start"][3]+16)
		ship[5] = createObject(9761,sPos["start"][1],sPos["start"][2]-1.3,sPos["start"][3]+18.8)
		ship[6] = createObject(9698,sPos["start"][1]-1.15,sPos["start"][2]-63.45,sPos["start"][3]+20.9)
		ship[7] = createObject(2634,sPos["start"][1]+2,sPos["start"][2]-58.2,sPos["start"][3]+16,0,0,270)

		for i=1,#ship do 
			setElementRotation(ship[i],0,0,90);
		end

		moveObject(ship[1],moveTime,sPos["end"][1],sPos["end"][2],sPos["end"][3]);
		moveObject(ship[2],moveTime,sPos["end"][1],sPos["end"][2]-2.3,sPos["end"][3]+10);
		moveObject(ship[3],moveTime,sPos["end"][1],sPos["end"][2]-75,sPos["end"][3]+18);
		moveObject(ship[4],moveTime,sPos["end"][1],sPos["end"][2]+14,sPos["end"][3]+16);
		moveObject(ship[5],moveTime,sPos["end"][1],sPos["end"][2]-1.3,sPos["end"][3]+18.8);
		moveObject(ship[6],moveTime,sPos["end"][1]-1.15,sPos["end"][2]-63.45,sPos["end"][3]+20.9);
		moveObject(ship[7],moveTime,sPos["end"][1]+2,sPos["end"][2]-58.2,sPos["end"][3]+16);
		setTimer(function()
			for k,v in pairs(getElementsByType("player")) do 
				if getElementData(v,"loggedIn") then 
					if isFaction(v) then 
						outputChatBox(exports.fv_engine:getServerSyntax("Weapon ship","blue").."A consignment of weapons arrived at the docks in Los Santos.",v,255,255,255,true);
						outputChatBox(exports.fv_engine:getServerSyntax("Weapon ship","blue").."The ship is at the docks for 1 hour.",v,255,255,255,true);
					end
				end
			end

			--Destroy Timer--
			setTimer(function()
				for k,v in pairs(getElementsByType("player")) do 
					if getElementData(v,"loggedIn") then 
						if isFaction(v) then 
							outputChatBox(exports.fv_engine:getServerSyntax("Weapon ship","red").."The ship left the docks in Los Santos.",v,255,255,255,true);
						end
					end
				end
				for k,v in pairs(ship) do 
					if isElement(v) then 
						destroyElement(v);
					end
					ship[k] = nil;
				end
				for k,v in pairs(getElementsByType("object")) do 
					if getElementModel(v) == 1271 then 
						if getElementData(v,"ship.box") then 
							destroyElement(v);
						end
					end
				end
				spawnHour = math.random(17,20);
				lastDay = getRealTime().monthday;
				outputDebugString("WeaponShip >> "..spawnHour,0,120,120,0);
			end,1000*60*60,1);
			----------------

			createBoxes();
		end,moveTime,1);
	end
end

function createBoxes()
	for k,v in pairs(bPos) do 
		local x,y,z = unpack(v);
		local obj = createObject(1271,x,y,z-0.6);
		setElementData(obj,"ship.box",true);
		setElementData(obj,"ship.state",true);
		setElementFrozen(obj,true);
	end
end

addEvent("ship.destroy",true);
addEventHandler("ship.destroy",root,function(player,obj)
	if isElement(obj) then 
		destroyElement(obj);
	end
end);

addEvent("ship.giveItems",true);
addEventHandler("ship.giveItems",root,function(player,obj,fegyverek)
if getElementData(player,"network") then 
	local rand = math.random(0,100);
	if rand < 60 then 
		outputChatBox(exports.fv_engine:getServerSyntax("Weapon ship","red").."There was nothing in this box.",player,255,255,255,true);
		triggerEvent("ship.destroy",player,player,obj);
		return;
	else 
		local rand = math.random(1,#fegyverek)
		local itemID = fegyverek[rand][1];
		local db = fegyverek[rand][2];
		if db == 2 then 
			db = math.random(20,70);
		end
		exports.fv_inventory:givePlayerItem(player,itemID,db,1,100,0);
		outputChatBox(exports.fv_engine:getServerSyntax("Weapon ship","servercolor").."You have successfully opened the box. Contents: "..exports.fv_engine:getServerColor("blue",true)..exports.fv_inventory:getItemName(itemID)..white..".",player,255,255,255,true);
		triggerEvent("ship.destroy",player,player,obj);
	end
end
end);

