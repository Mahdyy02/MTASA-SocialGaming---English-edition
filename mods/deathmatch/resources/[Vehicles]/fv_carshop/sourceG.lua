vehs = {
	-- kocsiid, név, sebesség, fogyasztás, kategória, ár($), ár(pp), limit
	--[[{491, "Dodge Challanger SRT", "232km/h", "14L", "Sport", 500000,3800,150},
	{535, "Ford Mustang GT 2015", "200km/h", "16L", "Sport", 450000,10000,30},
	{502, "Nissan GT-R R35 Egoist", "220km/h", "19L", "Sport", 700000,12000,45},
	{419, "Audi R8", "253km/h", "21L", "Sport", 1200000,12000,15},
	{555, "Mercedes AMG 2016", "230km/h", "21L", "Verseny", 900000,10000,33},
	{458, "Ford Focus RS", "198km/h", "14L", "Sport", 250000,7500,20},
	{516, "Mercedes Benz S500", "163km/h", "14L", "Sport", 500000,4500,45},
	{404, "Audi RS4", "195km/h", "20L", "Sport", 400000,7000,50},
	{467, "Mercedes Benz 300 SEL", "147km/h", "10L", "Elegáns", 200000,5000,45},
	{442, "Ford Mustang GT Fastback 390", "180km/h", "14L", "Sport", 180000,6000,20},
	{558, "Nissan 350z", "181km/h", "17L", "Sport", 300000,4000,100},
	{474, "1989 BMW M3 e30", "170km/h", "14L", "Sport", 120000,7000,50},
	{534, "1969 Dodge Charger R/T", "175km/h", "22L", "Sport", 350000,3000,30},
	{579, "Mercedes-Benz G500", "200km/h", "20L", "Sport", 800000,5000,35},
   	{540, "BMW M5 E60", "220km/h", "14L", "Sport", 545000,5000,150},
    {400, "Chevrolett Suburban Z11", "152km/h", "14L", "Sport", 40000,2000,200},
   	{496, "Dodge Ram 4X4", "170km/h", "17L", "Sport", 160000,2000,200},
  	{545, "Chrysler 1957", "160km/h", "14L", "Sport", 50000,1500,50},
  	{475, "Plymouth Hemi Cuda", "180km/h", "14L", "Sport", 250000,5000,50},
	{533, "Chrysler  Eldorado", "160km/h", "14L", "Old", 60000,1800,50},
	{412, "Audi Sport Quattro", "210km/h", "14L", "Sport", 80000,3000,70},
	{477, "Lamborghini Centenario", "300km/h", "14L", "Sport", 1500000,15000,50},
	{550, "Bmw 760Li", "340km/h", "14L", "Sport", 145000,4300,65},
	{585, "Mercedes C350", "340km/h", "14L", "Sport", 125000,4100,65},
	{602, "Saleen Raptor", "340km/h", "14L", "Sport", 500000,4300,50},
	{492, "Audi A6", "340km/h", "14L", "Sport", 80000,4000,47},
	{576, "Cougar Eliminator", "340km/h", "14L", "Sport", 78000,4000,200},
	{421, "Cadillac Escelade", "340km/h", "14L", "Sport", 55000,3300,200},
	{436, "Cadillac Eldorado", "340km/h", "14L", "Sport", 70000,3900,500},
	--{411, "Saleen S7", "340km/h", "14L", "Sport", 400000,6300,50},
	{505, "Hummer H2", "340km/h", "14L", "Sport", 250000,5300,10},
	{405, "Jaguar XF", "200km/h", "14L", "Sport", 200000,4000,100},
	{510, "Ridley Topsport", "50km/h", "14L", "Sport", 5000,200,1000},
	{509, "US City Bike", "60km/h", "14L", "Sport", 3500,150,1000},
	{439, "Cadillac Eldorado 2002", "180km/h", "14L", "Sport", 40000,1300,10000},
	{409, "Lincoln Town Car", "190km/h", "14L", "Sport", 1000000,8300,50},
	{542, "Ford Pinto", "150km/h", "14L", "Sport", 20000,600,1000},
	{445, "Mercedes-Benz E500", "200km/h", "14L", "Sport", 285000,5600,100},
	{527, "Bentley Continental", "242km/h", "14L", "Sport", 820000,7300,100},
	{562, "Nissan Skyline GT-R", "200km/h", "14L", "Sport", 350000,5300,80},
	{507, "Alfa Romeo Giulia Quadrifoglio", "190km/h", "14L", "Sport", 275000,4300,100},
	{541, "2017 Bugatti Chiron", "310km/h", "14L", "Sport", 2500000,9300,45},
	{506, "2017 Porsche Boxster S", "200km/h", "14L", "Sport", 650000,8900,20},
	{451, "Ferrari F40", "264km/h", "14L", "Sport", 1400000,10300,14},
	{415, "Toyota Supra US-Spec", "220km/h", "14L", "Sport", 350000,3300,40},
	{549, "RUF RT12S", "220km/h", "14L", "Sport", 750000,15000,20},
	{517, "McLaren P1", "270km/h", "14L", "Sport", 1800000,18000,20},
	{603, "Hennessey Venom", "340km/h", "14L", "Sport", 2200000,13000,15},
	{547, "Brabus Rocket 900", "270km/h", "14L", "Sport", 1800000,12000,40},
	{566, "Mercedes Benz AMG CLS63", "270km/h", "14L", "Sport", 2100000,12500,45},--]]


	-- New Dealership vehicles
	--yourcar, name, speed, consumption, category, price (dt), price (pp), stock

	{516, "Mercedes Benz S500", "163km/h", "14L", "Sport", 100000,4500,5},
	{551, "BMW i8", "150km/h", "20L", "Sport", 140000, 3000,5},
	{401, "Hyundai Sonata 2015", "150km/h", "10L", "Sport", 45000,12000,5},
	{546, "Citroen C4", "156m/h", "14L", "Sport", 40000,2000,5},
	{413, "Jeep", "165km/h", "14L", "Sport", 90000,1500,5},	
	{587, "Land Rover RLX", "190km/h", "14L", "Sport", 120000,3300,5},
	{410, "Peugeot 206", "130km/h", "14L", "Sport", 25000,500,5},
	{559, "Ferarri 458 italia", "245km/h", "14L", "Sport", 500000,10000,5},
	{522, "Honda Falcon", "140km/h", "14L", "Sport", 7000,1000,5},
	{586, "Honda BeAT", "150km/h", "14L", "Sport", 12000,1000,5},
	{468, "BF-400", "150km/h", "14L", "Sport", 28000,300,5},
	{481, "Mongoose Bmx", "50km/h", "14L", "Sport", 2000,100,30},
}

function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function getCost(model)
	local found = false;
	for k,v in pairs(vehs) do 
		if v[1] and v[1] == model then 
			found = v[6];
			break;
		end
	end
	if not found then 
		found = 1000;
	end
	return found;
end