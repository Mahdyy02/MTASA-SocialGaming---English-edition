local sql = exports.fv_engine:getConnection(getThisResource());

local tableCoins = {};

function loadWheel(id)
	dbQuery(function(qh)
		local res = dbPoll(qh,0);
		for k,v in pairs(res) do 
			local x,y,z, rx,ry,rz, interior, dimension = unpack(fromJSON(v.pos));
			local table = createObject(1896,x,y,z,rx,ry,rz);	
			local column = createObject(1897,x,y,z);
			attachElements(column,table,0,0.6,1);			

			local wX,wY,wZ = getPositionFromElementAtOffset(table,0,0.6,1.1);
			local wheel = createObject(1895,wX,wY,wZ,rx,ry,rz);
			setElementDoubleSided(wheel,true);
			local wheelRot = math.random(math.random(0,360));
			setElementRotation(wheel,rx,wheelRot,rz,"default",true)

			local aX,aY,aZ = getPositionFromElementAtOffset(table,0,0.55,2.1);
			local arrow = createObject(1898,aX,aY,aZ,rx,ry,rz);

			setElementData(table,"luckyWheel.wheel",wheel);
			setElementData(table,"luckyWheel.arrow",arrow);
			setElementData(table,"luckyWheel.column",column);
			setElementData(table,"luckyWheel",true);
			setElementData(table,"wheel->start",false);
			setElementData(table,"wheel->id",v.id);

			setElementInterior(table,interior);
			setElementInterior(column,interior);
			setElementInterior(wheel,interior);
			setElementInterior(arrow,interior);

			setElementDimension(table,dimension);
			setElementDimension(column,dimension);
			setElementDimension(wheel,dimension);
			setElementDimension(arrow,dimension);

			local wX,wY,wZ = getPositionFromElementAtOffset(table,0,1.6,1.1);
			local testWheel = createObject(1895,wX,wY,wZ,rx,ry,rz);
			setElementAlpha(testWheel,0);
			setElementDoubleSided(testWheel,true);
			setElementRotation(testWheel,rx,wheelRot,rz,"default",true)
			setElementCollisionsEnabled(testWheel,false);
			setElementInterior(testWheel,interior);
			setElementDimension(testWheel,dimension);

			local aX,aY,aZ = getPositionFromElementAtOffset(table,0,1.55,2.1);
			local testArrow = createObject(1898,aX,aY,aZ,rx,ry,rz);
			setElementAlpha(testArrow,0);
			setElementCollisionsEnabled(testArrow,false);
			setElementInterior(testArrow,interior);
			setElementDimension(testArrow,dimension);

			setElementData(table,"luckyWheel.testObjects",{testArrow,testWheel});


			tableCoins[table] = {};
		end
	end,sql,"SELECT * FROM luckywheels WHERE id=?",id);
end

function loadAllWheel()
	local dnsmap = createObject ( 3043, 968.90002, -53.2, 1001.6, 90, 2, 176 )
	setElementInterior(dnsmap,3);	
	setElementDimension(dnsmap,1167);
	local tick = getTickCount();
	dbQuery(function(qh)
		local res,lines = dbPoll(qh,0);
		for k,v in pairs(res) do 
			loadWheel(v.id);
		end
		outputDebugString("LuckyWheel -> "..lines.." loaded in "..(getTickCount()-tick).."ms",0,100,100,0);
	end,sql,"SELECT id FROM luckywheels");
end
addEventHandler("onResourceStart",resourceRoot,loadAllWheel);

function addWheel(player,cmd)
	if getElementData(player,"admin >> level") > 10 then 
		local x,y,z = getElementPosition(player);
		local rx,ry,rz = getElementRotation(player);
		local interior, dimension = getElementInterior(player), getElementDimension(player);
		dbQuery(function(qh)
			local res, lines, dbID = dbPoll(qh,0);
			loadWheel(dbID);
			outputChatBox(exports.fv_engine:getServerSyntax("LuckyWheel","servercolor").."Sikeresen leraktad a szerencsekereket. ID: "..exports.fv_engine:getServerColor("servercolor",true)..dbID,player,255,255,255,true);
		end,sql,"INSERT INTO luckywheels SET pos=?",toJSON({x,y,z,rx,ry,rz,interior,dimension}));
	end
end
addCommandHandler("addluckywheel",addWheel,false,false);

addEvent("luckyWheel.spin",true);
addEventHandler("luckyWheel.spin",root,function(player,wheelTable,bets,playerCoins)
	if playerCoins == (getElementData(player,"kari->Coin") or 0) then 
		setElementData(wheelTable,"luckySpin",true);
		local arrow = getElementData(wheelTable,"luckyWheel.arrow");
		local wheelObj = getElementData(wheelTable,"luckyWheel.wheel");
		local wheelX, wheelY, wheelZ = getElementPosition(wheelObj);

		local testArrow, testWheel = unpack(getElementData(wheelTable,"luckyWheel.testObjects"));
		setElementRotation(testWheel,getElementRotation(wheelObj));
		local testX,testY, testZ = getElementPosition(testWheel);

		local startTick = getTickCount();
		local winnerNumber = 0;
		local winRotate = 0;

		local esely = math.random(0,100);
		local realWinner = wheelValues[math.random(1,#wheelValues-1)];
		if esely < 10 then 
			outputDebugString(getElementData(player,"char >> name").." neki van esélye :)");
			realWinner = wheelValues[math.random(1,#wheelValues)];
		elseif esely > 10 and esely < 80 then 
			realWinner = 1;
		end
		-- local realWinner = 40;
		repeat
			local multip = (360/#wheelOffsets);
			moveObject(testWheel,0,testX,testY,testZ,0, multip, 0);
			winRotate = winRotate + multip;
			local distances = {};
			for k,v in pairs(wheelOffsets) do 
				local markerX,markerY,markerZ = getPositionFromElementAtOffset(testArrow,0.01,0,-0.15);
				local eX,eY,eZ = getPositionFromElementAtOffset(testWheel,v[1],v[2],v[3]);
				table.insert(distances,{getDistanceBetweenPoints3D(markerX,markerY,markerZ,eX,eY,eZ), v[4], k});
			end
			table.sort(distances,function(a,b)
				return a[1] < b[1];
			end);
			winnerNumber = distances[1][2];
			-- outputChatBox("next Y: "..winRotate)
			-- outputChatBox("real: "..realWinner.." win: "..winnerNumber);
			if winnerNumber == realWinner and winRotate > 10 then 
				local moveTime = 3000;
				moveObject(wheelObj, moveTime, wheelX, wheelY, wheelZ, 0, (360*math.random(1,3))+winRotate, 0, "InOutQuad");
				setTimer(function()
					if player and isElement(player) then 
						if bets[realWinner] then 
							local sColor = exports.fv_engine:getServerColor("servercolor",true);
							outputChatBox(exports.fv_engine:getServerSyntax("LuckyWheel","servercolor").."Pörgettél: "..sColor..realWinner..white..".",player,255,255,255,true);
							outputChatBox(exports.fv_engine:getServerSyntax("LuckyWheel","servercolor").."Tét: "..sColor..bets[realWinner]..white.." Coin.",player,255,255,255,true);
							outputChatBox(exports.fv_engine:getServerSyntax("LuckyWheel","servercolor").."Nyeremény: "..sColor..exports.fv_dx:formatMoney(bets[realWinner]*realWinner)..white.." Coin.",player,255,255,255,true);
							setElementData(player,"kari->Coin",getElementData(player,"kari->Coin") + (bets[realWinner]*realWinner));
							exports.fv_logs:createLog("LuckyWheel",getElementData(player,"char >> name").." | tét: "..bets[realWinner].." | nyert: "..exports.fv_dx:formatMoney(bets[realWinner]*realWinner),source,target);
						else 
							outputChatBox(exports.fv_engine:getServerSyntax("LuckyWheel","servercolor").."Nem nyertél.",player,255,255,255,true);
						end
						setElementData(player,"useWheel",false);
					end
					outputDebugString("LuckyWheel >> END in "..(getTickCount()-startTick).."ms",0,60,60,60);
					setTimer(setElementData,500,1,wheelTable,"luckySpin",false);
				end,moveTime+100,1);
				break;
			end
		until (winnerNumber == realWinner and winRotate > 10)
	end
end);

-- function wheel_delete(player,element)
-- 	setElementData(element,"wheel->start",false);
-- 	setElementData(element,"wheel->startP",false);
-- 	destroyElement(getElementData(element, "luckyWheel.wheel"))
-- 	destroyElement(getElementData(element, "luckyWheel.arrow"))
-- 	destroyElement(getElementData(element, "luckyWheel.column"))
-- 	dbExec(sql, "DELETE FROM luckyWheels WHERE id= ?", getElementData(element, "wheel->id"))
-- 	destroyElement(element)
-- 	triggerClientEvent(player, "wheel->closePanel", player)
-- end
-- addEvent("wheel->delete", true)
-- addEventHandler("wheel->delete", getRootElement(), wheel_delete)

addEvent("coinNPC.buy",true);
addEventHandler("coinNPC.buy",root,function(player,oldValue,cost,give,sell)
	if sell then 
		if (getElementData(player,"kari->Coin") or 0) == oldValue then 
			local ado = give * 0.1;
			setElementData(player,"char >> money", getElementData(player,"char >> money") + math.floor(give-ado));
			setElementData(player,"kari->Coin", (getElementData(player,"kari->Coin") or 0) - cost);
			exports.fv_infobox:addNotification(player,"success","Sikeres Coin Eladás");
			exports.fv_logs:createLog("Casino", getElementData(player,"char >> name").." | eladott "..(getElementData(player,"kari->Coin") or 0) + math.floor(give-ado).." coint "..cost.."$ dollárért.", client);
			exports.fv_infobox:addNotification(player,"info","Coin adó levonva (10%)");
		end
	else 
		if getElementData(player,"char >> money") == oldValue then 
			local ado = give * 0.1;
			setElementData(player,"char >> money", getElementData(player,"char >> money") - cost);
			setElementData(player,"kari->Coin", (getElementData(player,"kari->Coin") or 0) + math.floor(give-ado));
			exports.fv_logs:createLog("Casino", getElementData(player,"char >> name").." | vásárolt "..(getElementData(player,"kari->Coin") or 0) + math.floor(give-ado).." coint "..cost.."$ dollárért.", client);
			exports.fv_infobox:addNotification(player,"success","Sikeres Coin Vásárlás");
			exports.fv_infobox:addNotification(player,"info","Coin adó levonva (10%)");
		end
	end
end);