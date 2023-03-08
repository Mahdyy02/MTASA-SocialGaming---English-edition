local sql = exports.fv_engine:getConnection(getThisResource());

function onTrafiHit(thePlayer, Penz)
	setElementData(thePlayer,"char >> money",getElementData(thePlayer, "char >> money") - tonumber(Penz))
	exports.fv_dash:giveFactionMoney(53,math.floor(Penz / 2))
	exports.fv_dash:giveFactionMoney(54,math.floor(Penz / 2))
	getVehicleDatas(getPedOccupiedVehicle(thePlayer))
end
addEvent("onTrafiHit", true)
addEventHandler("onTrafiHit", getRootElement(), onTrafiHit)

function getVehicleDatas(veh)
	dbQuery(function(qh)
		local res = dbPoll(qh,0);
		if #res > 0 then 
			local vehDatas = {};
			for k,v in pairs(res) do 
				vehDatas[1] = v.rendszam;
				vehDatas[2] = exports.fv_vehmods:getVehicleRealName(veh);
				vehDatas[3] = v.indok;
			end
			local x, y, z = getElementPosition(veh);
			local zoneName = getZoneName(x, y, z)
			for i,v in ipairs(getElementsByType("player")) do
				if getElementData(v, "faction_53") or getElementData(v, "faction_54") then 
					outputChatBox(exports.fv_engine:getServerSyntax("Traffipax","red").."A circling vehicle passed through #87d37c" .. zoneName .. "#ffffff-nél lehelyezett traffipax előtt.", v, 255, 255, 255, true)
					outputChatBox(exports.fv_engine:getServerSyntax("Traffipax","red").."Type: #87d37c" .. vehDatas[2], v, 255, 255, 255, true)
					outputChatBox(exports.fv_engine:getServerSyntax("Traffipax","red").."License plate number: #87d37c" .. vehDatas[1], v, 255, 255, 255, true)
					outputChatBox(exports.fv_engine:getServerSyntax("Traffipax","red").."Reason for circling: #87d37c" .. vehDatas[3], v, 255, 255, 255, true)
				end
			end
			attachBlipToPolice(getVehicleController(veh));
		end
	end,sql,"SELECT * FROM mdcwantedvehicles WHERE rendszam=?",getVehiclePlateText(veh));
end

function attachBlipToPolice(player)
	for i,v in ipairs(getElementsByType("player")) do
		if getElementData(v, "faction_54") or getElementData(v, "faction_53") then 
			triggerClientEvent(v, "getBlipFromWantedVehicle", v, player)
		end
	end
end

