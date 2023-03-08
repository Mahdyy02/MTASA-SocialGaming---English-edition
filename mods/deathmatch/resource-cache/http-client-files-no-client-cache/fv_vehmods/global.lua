vehNames = {
    --[id] = "név",

    --Tuningolható kocsik (EZEKET NE CSERÉLD!)
    [562] = "Nissan Skyline GT-R",
    [558] = "Nissan 350z",
    [560] = "Subaru Impreza",  
    
    -----------------------------------------
	[418] = "Volkswagen Caravelle 2018",
	[535] = "Ford Mustang GT 2015",
	[586] = "Honda BeAT",
	[516] = "Mercedes Benz S500",
	[419] = "Audi R8",
	[458] = "Ford Focus RS",
	[467] = "Mercedes Benz 300 SEL",
	[401] = "Hyundai Sonata 2015",
	[404] = "Audi RS4",
	[442] = "Ford Mustang GT Fastback 390",
	[551] = "BMW i8",
    [540] = "BMW M5 E60",
    [400] = "Chevrolett Suburban Z11",
    ------------------------------------------
    [496] = "Dodge Ram 4X4 ",
    [545] = "Chrysler 1957",
    [475] = "Plymouth Hemi Cuda",
    [546] = "Citroen C4",
    [559] = "Ferarri 458 italia",
    [533] = "Chrysler  Eldorado",
    [413] = "Jeep",
    [412] = "Audi Sport Quattro",
    [477] = "Lamborghini Centenario",
    [585] = "Mercedes-Benz C350",
    [550] = "Bmw 760Li",   
    [602] = "Saleen Raptor",
    [492] = "Audi A6 3.0 ",
    [487] = "Buckingham",
                    [576] = "Cougar Eliminator",
                    [421] = "Cadillac Escelade",
                    [436] = "Cadillac Eldorado",
                    [491] = "Dodge Charger SRT8",
                    [411] = "Saleen S7",       
                    [505] = "Hummer H2",
                    [587] = "Land Rover RLX",
                    [405] = "Jaguar XF",   
                    [481] = "Mongoose Bmx",
                    [510] = "Ridley Topsport.",
                    [509] = "US City Bike",                    
                    [522] = "Honda Falcon",
                    [468] = "BF-400",
                    [439] = "Cadillac Eldorado 2002",
                    [409] = "Lincoln Town Car",  
                    [410] = "Peugeot 206",    
                    [542] = "Ford Pinto",      
                    [445] = "Mercedes-Benz E500",
                    [507] = "Alfa Romeo Giulia ",  
                    [527] = "Bentley Continental SS 17",      
                    [541] = "2017 Bugatti Chiron",
                    [506] = "2017 Porsche Boxster S",
                    [451] = "Ferrari F40",                      
                    [415] = "Toyota Supra US-Spec",      
                    [555] = "2016 Mercedes AMG",    
                    [429] = "Ferrari LaFerrari 2014",  -- PP KOCSI
					[549] = "RUF RT12S",  
					[517] = "McLaren P1",  
					[603] = "Hennessey Venom",  
					
					
					
					
					[474] = "1989 BMW M3 e30",   -- ÚJ KOCSI
					[534] = "1969 Dodge Charger R/T",   -- ÚJ KOCSI
					[579] = "Mercedes-Benz G500",   -- ÚJ KOCSI
					
					
					
					[502] = "Nissan GT-R R35 Egoist",   -- ÚJ KOCSI

                    ---- Faction vehicles--- 
					[427] = "Lenco Bearcat",
                    [416] = "Ambulance",
                    [596] = "Ford Crown Victoria",
                    [598] = "Police Enforcer",
                    [597] = "Police Skoda",
                    [599] = "BMW Motor",
                    [497] = "Police Heli",                   
                    [525] = "Chevrolet Silverado Towtruck",
                    [420] = "Taxi",
                    [438] = "Cabbie",                
                    [490] = "Police casual",                   
                    [528] = "Police 4x4",		
                    [523] = "Police Motor",		
                    [588] = "McDonalds delivery",
                    [407] = "Pierce Arrow XT Fireman",	
                    [544] = "Pierce Arrow XT Létrás Fireman",	

					---PP KOCSIK!--
					[466] = "Mercedes-Benz GLE450 AMG", --Srác					
					[554] = "Ferrari 488 Pista", --Srác
					[605] = "Lamborghini Veneno", --Nexy((Zipoo))-- ODA ADVA! 
					[589] = "Chevrolet Camaro ZL1",--Nexy((Boxos))-- ODA ADVA!
					[580] = "Audi RS7 Sportback", --Kevin autója!--
					[547] = "Brabus Rocket 900",--Nxy((Borislaw))-- ODA ADVA! 
					[526] = "Lamborghini Aventador Liberty Walk Performance",  --
					[565] = "McLaren Senna 2019",
					[566] = "Mercedes Benz AMG CLS63",
					[518] = "Lykan Hypersport 2015",
					[503] = "Pagani Huayra Roadster  ",						
					[600] = "2019 Bugatti Divo  ",						
					[494] = "Porsche 911 GT3 RS '19  ",						
					[402] = "La Ferrari   ",			-- BOXOS			
					[561] = "BMW M5 F90   ",		-- BOXOS				
}

function getVehicleRealName(veh)	
    local found = false;
    local model = false;
    if isElement(veh) then 
        model = getElementModel(veh);
    else 
        model = tonumber(veh);
    end
	if vehNames[model] then
		found = vehNames[model];
	else	
		found = getVehicleNameFromModel(model);
	end
	return found;
end
