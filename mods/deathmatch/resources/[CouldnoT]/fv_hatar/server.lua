local sql = exports.fv_engine:getConnection(getThisResource());
local borders = {
    [1] = { 
        {67.367065429688, -1530.4129638672, 4.9983367919922},
        {67.367065429688, -1529.4129638672, 4.9983367919922},
        {67.367065429688, -1528.4129638672, 4.9983367919922},
        {67.367065429688, -1527.4129638672, 4.9983367919922},
        {67.367065429688, -1526.4129638672, 4.9983367919922},
        {67.367065429688, -1525.4129638672, 4.9983367919922},
        {67.367065429688, -1524.4129638672, 4.9983367919922},
    },
    [2] = {
        {35.9235496521, -1539.1051025391, 5.2463073730469},
        {35.9235496521, -1538.1051025391, 5.2463073730469},
        {35.9235496521, -1537.1051025391, 5.2463073730469},
        {35.9235496521, -1536.1051025391, 5.2463073730469},
        {35.9235496521, -1535.1051025391, 5.2463073730469},
        {35.9235496521, -1534.1051025391, 5.2463073730469},
        {35.9235496521, -1533.1051025391, 5.2463073730469},
    },
    [3] = {
        {22, -1341, 9.9819421768188},
        {22.5, -1341.6, 9.9819421768188},
        {23, -1342.2, 9.9819421768188},
        {23.5, -1342.8, 9.9819421768188},
        {24, -1343.4, 9.9819421768188},
        {24.5, -1344, 9.9819421768188},
        {25, -1344.6, 9.9819421768188},
        {25.5, -1345.2, 9.9819421768188},
    },
    [4] = {
        {-10.5, -1331, 11.055549621582},
        {-10, -1331.7, 11.055549621582},
        {-9.5, -1332.4, 11.055549621582},
        {-9, -1333.1, 11.055549621582},
        {-8.5, -1333.8, 11.055549621582},
        {-8, -1334.5, 11.055549621582},
        {-7.5, -1335.3, 11.055549621582},
    },
    [5] = {
        {-980, -415, 36.239421844482},
        {-981, -414.5, 36.239421844482},
        {-982, -414, 36.239421844482},
        {-983, -413.5, 36.239421844482},
        {-984, -413, 36.239421844482},
    },
    [6] = {
        {-953, -264, 36.638236999512},
        {-954, -263.8, 36.638236999512},
        {-955, -263.6, 36.638236999512},
        {-956, -263.4, 36.638236999512},
        {-957, -263.2, 36.638236999512},
        {-958, -263, 36.638236999512},
    },
    [7] = {
        {-90, -932, 19.551277160645},
        {-91, -931.5, 19.551277160645},
        {-92, -931, 19.551277160645},
        {-93, -930.5, 19.551277160645},
    },
    [8] = {
        {-75, -891, 15.748610496521},
        {-76, -890.5, 15.748610496521},
        {-77, -890, 15.748610496521},
        {-78, -889.5, 15.748610496521},
        {-79, -889, 15.748610496521},
        {-80, -888.5, 15.748610496521},
    },
};
local cols = {
    [1] = {70.528579711914, -1527.6199951172, 4.9981718063354},
    [2] = {32.85693359375, -1535.8826904297, 5.1982078552246},
    [3] = {21.175966262817, -1345.0543212891, 10.033903121948},
    [4] = {-7.0294194221497, -1331.6594238281, 11.085057258606},
    [5] = {-984.03839111328, -416.5419921875, 36.257377624512}, 
    [6] = {-954.50286865234, -260.2033996582, 36.828647613525},
    [7] = {-92.826957702637, -933.61572265625, 19.814346313477},
    [8] = {-75.812278747559, -887.03247070313, 15.565167427063},
}

function createBorders()
    for id, datas in pairs(borders) do 
        for _, value in pairs(datas) do 
            local x,y,z = unpack(value);
            local obj = createObject(1214,x,y,z-1);
            setElementFrozen(obj,true);
            setElementData(obj,"border.id",id);
        end
        local x,y,z = unpack(cols[id]);
        local col = createColSphere(x,y,z,2.5);
        setElementData(col,"border.id",id);
        setElementData(col,"border.state",true);
    end
end
addEventHandler("onResourceStart",resourceRoot,createBorders);

function changeBorderState(id,state,col)
    local objs = {};
    for k,v in pairs(getElementsByType("object",resourceRoot)) do 
        local objID = (getElementData(v,"border.id") or -1);
        if objID > 0 and objID == id then 
            table.insert(objs,v);
        end
    end
    for key,element in pairs(objs) do 
        local x,y,z = getElementPosition(element);
        if state then 
            moveObject(element,2000,x,y,z+1.4);
        else
            moveObject(element,2000,x,y,z-1.4);
        end
    end
    setTimer(setElementData,2000,1,col,"border.state",state);
end

addEvent("border.open",true);
addEventHandler("border.open",root,function(player,element)
    local id = getElementData(element,"border.id");
    local state = getElementData(element,"border.state");
    if state then 
        changeBorderState(id,false,element);
        setElementData(element,"border.state",false);
        setTimer(function()
            changeBorderState(id,true,element);    
        end,4000,1);
        setElementData(player,"isBorder",false);
        setElementData(player,"char >> money",getElementData(player,"char >> money") - 1500);

        --	exports.fv_dash:giveFactionMoney(2,150);

        local veh = getPedOccupiedVehicle(player);
        getVehicleDatas(veh);
    end
end);

addEventHandler("onVehicleStartExit",root,function(player)
    if getElementData(player,"isBorder") then 
        cancelEvent();
    end
end);

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
				if getElementData(v, "faction_53") or getElementData(v, "faction_5") then 
					outputChatBox(exports.fv_engine:getServerSyntax("Border","red").."A circling vehicle passed through #87d37c" .. zoneName .. "#ffffff", v, 255, 255, 255, true)
					outputChatBox(exports.fv_engine:getServerSyntax("Border","red").."Type: #87d37c" .. vehDatas[2], v, 255, 255, 255, true)
					outputChatBox(exports.fv_engine:getServerSyntax("Border","red").."License plate number: #87d37c" .. vehDatas[1], v, 255, 255, 255, true)
					outputChatBox(exports.fv_engine:getServerSyntax("Border","red").."Reason for circling: #87d37c" .. vehDatas[3], v, 255, 255, 255, true)
				end
			end
			attachBlipToPolice(getVehicleController(veh));
		end
	end,sql,"SELECT * FROM mdcWantedVehicles WHERE rendszam=?",getVehiclePlateText(veh));
end
function attachBlipToPolice(player)
	for i,v in ipairs(getElementsByType("player")) do
		if getElementData(v, "faction_53") or getElementData(v, "faction_5") then 
			triggerClientEvent(v, "getBlipFromWantedVehicle", v, player)
		end
	end
end