function getPlayerLevel(player)
	local time = (getElementData(player,"char >> playedtime")/20) or 0;
	local level = 0
		if time < 5 then
			level = 1
		elseif time >= 5 and time < 10 then
			level = 2	
		elseif time >= 10 and time < 15 then
			level = 3		
		elseif time >= 15 and time < 20 then
			level = 4		
		elseif time >= 20 and time < 30 then
			level = 5		
		elseif time >= 30 and time < 40 then
			level = 6		
		elseif time >= 40 and time < 50 then
			level = 7		
		elseif time >= 50 and time < 60 then
			level = 8		
		elseif time >= 60 and time < 70 then
			level = 9		
		elseif time >= 70 and time < 90 then
			level = 10		
		elseif time >= 90 and time < 110 then
			level = 11	
		elseif time >= 110 and time < 120 then
			level = 12	
		elseif time >= 120 and time < 140 then
			level = 13	
		elseif time >= 140 and time < 160 then
			level = 14		
		elseif time >= 160 and time < 190 then
			level = 15	
		elseif time >= 190 and time < 220 then
			level = 16
		elseif time >= 220 and time < 250 then
			level = 17
		elseif time >= 250 and time < 280 then
			level = 18
		elseif time >= 280 and time < 310 then
			level = 19
		elseif time >= 310 and time < 350 then
			level = 20
		elseif time >= 350 and time < 390 then
			level = 21	
		elseif time >= 390 and time < 430 then
			level = 22
		elseif time >= 430 and time < 470 then
			level = 23	
		elseif time >= 470 and time < 500 then
			level = 24		
		elseif time >= 500 and time < 550 then
			level = 25	
		elseif time >= 550 and time < 600 then
			level = 26
		elseif time >= 600 and time < 650 then
			level = 27
		elseif time >= 650 and time < 700 then
			level = 28
		elseif time >= 700 and time < 750 then
			level = 29
		elseif time >= 750 and time < 800 then
			level = 30	
		elseif time >= 800 and time < 850 then
			level = 31		
		elseif time >= 850 and time < 900 then
			level = 32	
		elseif time >= 900 and time < 950 then
			level = 33	
		elseif time >= 950 and time < 1000 then
			level = 34
		elseif time >= 1000 and time < 1050 then
			level = 35
		elseif time >= 1050 and time < 1100 then
			level = 36
		elseif time >= 1100 and time < 1150 then
			level = 37
		elseif time >= 1150 and time < 1200 then
			level = 38
		elseif time >= 1200 and time < 1250 then
			level = 39			
		elseif time >= 1250 and time < 1250 then
			level = 40		
		elseif time >= 1250 and time < 1350 then
			level = 41				
		elseif time >= 1350 and time < 1400 then
			level = 42			
		elseif time >= 1400 and time < 1450 then
			level = 43
		elseif time >= 1450 and time < 1500 then
			level = 44
		elseif time >= 1500 and time < 1600 then
			level = 45
		elseif time >= 1600 and time < 1700 then
			level = 46
		elseif time >= 1700 and time < 1800 then
			level = 47
		elseif time >= 1800 and time < 1900 then
			level = 48	
		elseif time >= 1900 and time < 2000 then
			level = 49		
		elseif time >= 2000 and time < 2100 then
			level = 50		
		elseif time >= 2100 and time < 2200 then
			level = 51		
		elseif time >= 2200 and time < 2300 then
			level = 52		
		elseif time >= 2300 and time < 2400 then
			level = 53	
		elseif time >= 2400 and time < 2500 then
			level = 54
		elseif time >= 2500 and time < 2600 then
			level = 55
		elseif time >= 2600 and time < 2700 then
			level = 56
		elseif time >= 2700 and time < 2800 then
			level = 57
		elseif time >= 2800 and time < 2900 then
			level = 58	
		elseif time >= 2900 and time < 3000 then
			level = 59
		elseif time >= 3000 and time < 3100 then
			level = 60
		elseif time >= 3100 and time < 3200 then
			level = 61
		elseif time >= 3200 and time < 3300 then
			level = 62
		elseif time >= 3300 and time < 3400 then
			level = 63
		elseif time >= 3400 and time < 3500 then
			level = 64
		elseif time >= 3500 and time < 3600 then
			level = 65
		elseif time >= 3600 and time < 3700 then
			level = 66
		elseif time >= 3700 and time < 3800 then
			level = 67
		elseif time >= 3800 and time < 3900 then
			level = 68
		elseif time >= 3900 and time < 4000 then
			level = 69	
		elseif time >= 4000 and time < 4200 then
			level = 70	
		elseif time >= 4200 and time < 4400 then
			level = 71
		elseif time >= 4400 and time < 4600 then
			level = 72		
		elseif time >= 4600 and time < 4800 then
			level = 73	
		elseif time >= 4800 and time < 5000 then
			level = 74
		elseif time >= 5000 and time < 5500 then
			level = 75
		elseif time >= 5500 and time < 6000 then
			level = 76
		elseif time >= 6000 and time < 6500 then
			level = 77
		elseif time >= 6500 and time < 7000 then
			level = 78		
		elseif time >= 7000 and time < 7500 then
			level = 79	
		elseif time >= 7500 and time < 8500 then
			level = 80		
		elseif time >= 8500 and time < 9500 then
			level = 81		
		elseif time >= 9500 and time < 10500 then
			level = 82
		elseif time >= 10500 and time < 11500 then
			level = 83
		elseif time >= 11500 and time < 12500 then
			level = 84
		elseif time >= 12500 and time < 13500 then
			level = 85
		elseif time >= 13500 and time < 14500 then
			level = 86			
		elseif time >= 14500 and time < 15500 then
			level = 87					
		elseif time >= 15500 and time < 16500 then
			level = 88					
		elseif time >= 16500 and time < 17500 then
			level = 89	
		elseif time >= 17500 and time < 18500 then
			level = 90				
		elseif time >= 18500 and time < 19500 then
			level = 91			
		elseif time >= 19500 and time < 20500 then
			level = 92
		elseif time >= 20500 and time < 21500 then
			level = 93
		elseif time >= 21500 and time < 22500 then
			level = 94
		elseif time >= 22500 and time < 23500 then
			level = 95
		elseif time >= 23500 and time < 24500 then
			level = 96	
		elseif time >= 24500 and time < 25500 then
			level = 97			
		elseif time >= 25500 and time < 30000 then
			level = 98	
		elseif time >= 30000 then
			level = 99		
		end
	return level;
end