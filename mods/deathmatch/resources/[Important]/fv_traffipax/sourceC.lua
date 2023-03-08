
local traffiPos = {--X, Y, Z, Rot[1,2,3], speedLimit, colshape elheleyzekédes X, Y
	{1489.5397949219, -1739.6917724609, 13.546875,0, 0, 60, 90},--Pláza -- KÉSZ
	{1179.5311279297, -1288.6806640625, 13.546875,0, 0, 50, 90},--Pláza *---*-/*-/*-/-*/-*-/-/ KÉSZ
	{1953.6499023438, -1746.2998046875, 13.546875,0, 0, -35, 50},--Déli -- KÉSZ
	{1948.9748535156, -1964.7048339844, 13.571845054626,0, 0, -30, 50},--Déli -- KÉSZ
	{1834.4946289063, -1584.5932617188, 13.593346595764,0, 0, 120, 70},--Déli -9**-*-*- ÉÁSZ
	{848.57220458984, -1384.6876220703, 13.565443992615,0, 0, -50, 90},--Déli *-asd-*asd*-/- LSÁZ
	{376.51455688477, -1709.6223144531, 7.5239658355713,0, 0, 0, 90},--Déli -- KÉSZ
	{-152.59230041504, -1458.4781494141, 4.6592445373535,0, 0, 70, 90},--Déli a-sd-as-d *-ÓŐ FŐRPFO
	{-1594.8677978516, -787.85375976563, 48.891277313232,0, 0, -50, 70},--Déli -a*sd-a*d*-as//d* ÉSŰZ
	{693.205078125, -1177.4434814453, 15.357568740845,0, 0, 200, 70},--Déli BOTI BUTZII
	{2631.6752929688, -1162.9365234375, 53.38752746582,0, 0, 150, 70},--Déli 
	{1599.3005371094, -1599.8524169922, 13.612354278564,0, 0, 30, 30},--Déli
	{2848.6193847656, -1728.3917236328, 11.046875, 0, 0, 120, 120},
	{2878.2497558594, -1134.5720214844, 10.882762908936, 0, 0, 120, 120},--Déli
	{2739.6652832031, -2161.0844726563, 11.1015625, 0, 0, 120, 120},--Déli
	{2884.8403320313, -592.32873535156, 11.190640449524, 0, 0, 120, 120},--Déli
	{2734.7141113281, -192.13192749023, 30.70824432373, 0, 0, 120, 120},--Déli


	{2332.3029785156, -2231.0485839844, 13.546875, 0, 0, 120, 120},--Déli
	{1616.6014404297, -2677.1730957031, 6.0462951660156, 0, 0, 120, 120},--Déli
	{1154.5487060547, -2408.0812988281, 10.92218208313, 0, 0, 120, 120},--Déli
	{1043.7419433594, -2065.1870117188, 13.1484375, 0, 0, 120, 120},--Déli
	{887.53704833984, -1778.0474853516, 13.690247535706, 0, 0, 70, 70},--Déli
	{534.15393066406, -1253.5180664063, 16.616146087646, 0, 0, 70, 70},--Déli
	{633.16967773438, -1400.5439453125, 11.336797714233, 0, 0, 70, 70},--Déli
	{1200.5982666016, -1400.4561767578, 11.271476745605, 0, 0, 70, 70},--Déli
	{1350.2313232422, -1323.6209716797, 13.625, 0, 0, 70, 70},--Déli

	{1304.6043701172, -1634.4104003906, 13.539079666138, 0, 0, 70, 70},--Déli
	{1305.1798095703, -1838.29296875, 13.546875, 0, 0, 70, 70},--Déli
	{1577.9627685547, -1309.2633056641, 17.455184936523, 0, 0, 70, 70},--Déli
	{1344.2303466797, -1141.8419189453, 21.667797088623, 0, 0, 70, 70},--Déli
	{1018.9806518555, -1155.1274414063, 23.826309204102, 0, 0, 70, 70},--Déli

	{790.57800292969, -1144.0552978516, 23.828125, 0, 0, 70, 70},--Déli
	{1010.7416992188, -962.78405761719, 39.757766723633, 0, 0, 70, 70},--Déli
	{1371.4470214844, -939.46063232422, 32.1875, 0, 0, 70, 70},--Déli
	{2181.34375, -1114.0466308594, 25.061136245728, 0, 0, 70, 70},--Déli
	{2281.4145507813, -1298.2470703125, 23.999649047852, 0, 0, 70, 70},--Déli
	{2317.7407226563, -1295.1008300781, 24.105802536011, 0, 0, 70, 70},--Déli

	{336.880859375, -1579.8713378906, 23.931041717529, 0, 0, 70, 70},--Déli
	{2473.5473632813, -1498.220703125, 24, 0, 0, 70, 70},--Déli
	{2425.5766601563, -1626.4566650391, 27.493598937988, 0, 0, 70, 70},--Déli
	{2320.8994140625, -1741.8463134766, 13.546875, 0, 0, 70, 70},--Déli
	{2212.01953125, -1886.0462646484, 13.546875, 0, 0, 70, 70},--Déli
	{2407.3725585938, -1980.6927490234, 13.546875, 0, 0, 70, 70},--Déli

	{2285.2985839844, -2091.7580566406, 13.539070129395, 0, 0, 70, 70},--Déli
	{2437.3283691406, -2242.3581542969, 25.234375, 0, 0, 70, 70},--Déli
	{1814.2497558594, -2158.8542480469, 13.546875, 0, 0, 70, 70},--Déli
	{1556.7956542969, -2109.6669921875, 33.75793838501, 0, 0, 70, 70},--Déli
	{1638.2592773438, -1886.6872558594, 25.206369400024, 0, 0, 120, 120},--Déli
	{1622.2811279297, -1247.3254394531, 48.213493347168, 0, 0, 120, 120},--Déli

	{1705.8386230469, -682.87658691406, 45.178367614746, 0, 0, 70, 70},--Déli
	{1665.0997314453, -105.6584854126, 35.407150268555, 0, 0, 70, 70},--Déli
	{1796.1762695313, 266.36227416992, 20.194246292114, 0, 0, 70, 70},--Déli
	{2183.53515625, 318.51895141602, 32.958564758301, 0, 0, 70, 70},--Déli
	{2707.6318359375, 265.73107910156, 37.182144165039, 0, 0, 120, 120},--Déli
	{2732.7954101563, 292.21478271484, 20.265625, 0, 0, 120, 120},--Déli

}

factions = {52, 53, 54, 55} -- Ezeket nem kapja le a trafi
white = "#FFFFFF";
local Traffis = {}
local colShape = {}

local trafiBlip = {}
local blipState = false

addCommandHandler("traffipaxok", function()
	if getElementData(localPlayer, "admin >> level") > 12 then
		blipState = not blipState
		if blipState then
			trafiBlip = {}
			for k, v in pairs(traffiPos) do
				trafiBlip[k] = createBlip(v[1],v[2],v[3], 1)
				setElementData(trafiBlip[k], "blip >> name", "Traffipax " .. k)
			end
		else
			for k, v in pairs(traffiPos) do
				destroyElement(trafiBlip[k])
				trafiBlip[k] = nil
			end
			trafiBlip = {}
		end
	end
end)
 
function createTraffi ()
	for i,v in ipairs (traffiPos) do
		Traffis[i] = createObject(1337, v[1],v[2],v[3]-1.04,v[4], v[5], v[6])
		colShape[i] = createColCuboid(v[1]-15, v[2]-15, v[3]-1.5, 30, 30, 3)
		setElementData(colShape[i], "colshape.ID", i)
	end
 end
 addEventHandler ( "onClientResourceStart", resourceRoot, createTraffi)

addEventHandler("onClientColShapeHit",getRootElement(), function (colShapePlayer)
	if colShapePlayer ~= localPlayer then return end
	if not isPedInVehicle(localPlayer) then return end
	if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
		local colshapeID = getElementData(source, "colshape.ID") or 0
		if colshapeID > 0 then 
			if getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Automobile" or getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Bike" then
				for k, v in pairs(factions) do
					if (getElementData(getPedOccupiedVehicle(localPlayer), "veh:faction") == v) then
						return;
					end
				end
				local vehicle = getPedOccupiedVehicle(localPlayer)
				local occupants = getVehicleOccupants(vehicle) or {}
				local ticket = calculateTicket(exports.fv_vehicle:getVehicleSpeed(vehicle) - traffiPos[colshapeID][7])
				local serverColor = exports.fv_engine:getServerColor("servercolor",true);
				local speed = exports.fv_vehicle:getVehicleSpeed(vehicle) - traffiPos[colshapeID][7]
				for seat, occupant in pairs(occupants) do 
					if speed > 0 and seat==0 then 
						outputChatBox(exports.fv_engine:getServerSyntax("Traffipax","red").."You have exceeded speed limit, speed limit: "..serverColor..traffiPos[colshapeID][7].."#ffffff km/h!",255,255,255,true)
						outputChatBox(exports.fv_engine:getServerSyntax("Traffipax","red").."Extent of exceedance: "..serverColor..math.ceil(speed)..white.." km/h. #ffffffFine: "..serverColor..formatMoney(math.ceil(ticket)) ..white.. " dt",255,255,255,true)
					end

					if exports.fv_vehicle:getVehicleSpeed(vehicle) > tonumber(traffiPos[colshapeID][7]*1.4) or not getElementData(occupant, "veh:ov") then 
						if not getElementData(occupant, "veh:ov") and getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Automobile" then 
							if ticket > 0 then 
								ticket = ticket + 500
							else
								ticket = 500
							end
							outputChatBox(exports.fv_engine:getServerSyntax("Traffipax","red").."Someone's seat belt wasn't fastened!",255,255,255,true)
							outputChatBox(exports.fv_engine:getServerSyntax("Traffipax","red").."Fine: " ..serverColor.. formatMoney(500) ..white.. " dt.",255,255,255,true)
						end
					end
				end
				if ticket > 0 then 
					fadeCamera(false, 0.5,255,255,255)
						
					playSound("files/shutter.mp3")
					outputDebugString(ticket)
					setTimer (function () 
						fadeCamera(true, 0.5)
					end,400,1)
					triggerServerEvent("onTrafiHit",localPlayer,localPlayer,math.ceil(ticket));
				end
			end
		end
	end
end)

function calculateTicket(a)
	local mul = 10
	if getElementData(localPlayer, "char >> money") > 3000000 or getElementData(localPlayer, "char >> bankmoney") > 5000000 then
		if math.ceil(a) > 100 then
			mul = 160
		else
			mul = 110
		end
	elseif getElementData(localPlayer, "char >> money") < 0 or getElementData(localPlayer, "char >> bankmoney") < 0 then
		if math.ceil(a) > 100 then
			mul = 10
		else
			mul = 7
		end
	else 
		if math.ceil(a) > 100 then
			mul = 20
		else
			mul = 15
		end
	end

	return math.ceil(a*mul*3)
end

function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

addEvent("getBlipFromWantedVehicle", true)
addEventHandler("getBlipFromWantedVehicle", root, function(player)
	local veh = getPedOccupiedVehicle(player)
	local blip = createBlipAttachedTo(veh, 1)
	setElementData(blip, "blip >> name", "Körözött jármű")
    setElementData(blip, "blip >> maxVisible",true);
	setTimer(function()
		destroyElement(blip)
	end, 10000, 1)
end)