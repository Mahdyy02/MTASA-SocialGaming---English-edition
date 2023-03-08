local properties = {
	"mass",
	"turnMass",
	"dragCoeff",
	"centerOfMass",
	"percentSubmerged",
	"tractionMultiplier",
	"tractionLoss",
	"tractionBias",
	"numberOfGears",
	"maxVelocity",
	"engineAcceleration",
	"engineInertia",
	"driveType",
	"engineType",
	"brakeDeceleration",
	"brakeBias",
	"ABS",
	"steeringLock",
	"suspensionForceLevel",
	"suspensionDamping",
	"suspensionHighSpeedDamping",
	"suspensionUpperLimit",
	"suspensionLowerLimit",
	"suspensionFrontRearBias",
	"suspensionAntiDiveMultiplier",
	"seatOffsetDistance",
	"collisionDamageMultiplier",
	"monetary",
	"modelFlags",
	"handlingFlags",
	"headLight",
	"tailLight",
	"animGroup"
}

local vehicleModelIdentifier = {
	[400] = "LANDSTAL",
	[401] = "BRAVURA",
	[402] = "BUFFALO",
	[403] = "LINERUN",
	[404] = "PEREN",
	[405] = "SENTINEL",
	[406] = "DUMPER",
	[407] = "FIRETRUK",
	[408] = "TRASH",
	[409] = "STRETCH",
	[410] = "MANANA",
	[411] = "INFERNUS",
	[412] = "VOODOO",
	[413] = "PONY",
	[414] = "MULE",
	[415] = "CHEETAH",
	[416] = "AMBULAN",
	[417] = "LEVIATHN",
	[418] = "MOONBEAM",
	[419] = "ESPERANT",
	[420] = "TAXI",
	[421] = "WASHING",
	[422] = "BOBCAT",
	[423] = "MRWHOOP",
	[424] = "BFINJECT",
	[425] = "HUNTER",
	[426] = "PREMIER",
	[427] = "ENFORCER",
	[428] = "SECURICA",
	[429] = "BANSHEE",
	[430] = "PREDATOR",
	[431] = "BUS",
	[432] = "RHINO",
	[433] = "BARRACKS",
	[434] = "HOTKNIFE",
	[435] = "ARTICT1",
	[436] = "PREVION",
	[437] = "COACH",
	[438] = "CABBIE",
	[439] = "STALLION",
	[440] = "RUMPO",
	[441] = "RCBANDIT",
	[442] = "ROMERO",
	[443] = "PACKER",
	[444] = "MONSTER",
	[445] = "ADMIRAL",
	[446] = "SQUALO",
	[447] = "SEASPAR",
	[448] = "MOPED",
	[449] = "TRAM",
	[450] = "ARTICT2",
	[451] = "TURISMO",
	[452] = "SPEEDER",
	[453] = "REEFER",
	[454] = "TROPIC",
	[455] = "FLATBED",
	[456] = "YANKEE",
	[457] = "GOLFCART",
	[458] = "SOLAIR",
	[459] = "TOPFUN",
	[460] = "SEAPLANE",
	[461] = "BIKE",
	[462] = "MOPED",
	[463] = "FREEWAY",
	[464] = "RCBARON",
	[465] = "RCRAIDER",
	[466] = "GLENDALE",
	[467] = "OCEANIC",
	[468] = "DIRTBIKE",
	[469] = "SPARROW",
	[470] = "PATRIOT",
	[471] = "QUADBIKE",
	[472] = "COASTGRD",
	[473] = "DINGHY",
	[474] = "HERMES",
	[475] = "SABRE",
	[476] = "RUSTLER",
	[477] = "ZR350",
	[478] = "WALTON",
	[479] = "REGINA",
	[480] = "COMET",
	[481] = "BMX",
	[482] = "BURRITO",
	[483] = "CAMPER",
	[484] = "MARQUIS",
	[485] = "BAGGAGE",
	[486] = "DOZER",
	[487] = "MAVERICK",
	[488] = "COASTMAV",
	[489] = "RANCHER",
	[490] = "FBIRANCH",
	[491] = "VIRGO",
	[492] = "GREENWOO",
	[493] = "CUPBOAT",
	[494] = "HOTRING",
	[495] = "SANDKING",
	[496] = "BLISTAC",
	[497] = "POLMAV",
	[498] = "BOXVILLE",
	[499] = "BENSON",
	[500] = "MESA",
	[501] = "RCGOBLIN",
	[502] = "HOTRING",
	[503] = "HOTRING",
	[504] = "BLOODRA",
	[505] = "RANCHER",
	[506] = "SUPERGT",
	[507] = "ELEGANT",
	[508] = "JOURNEY",
	[509] = "CHOPPERB",
	[510] = "MTB",
	[511] = "BEAGLE",
	[512] = "CROPDUST",
	[513] = "STUNT",
	[514] = "PETROL",
	[515] = "RDTRAIN",
	[516] = "NEBULA",
	[517] = "MAJESTIC",
	[518] = "BUCCANEE",
	[519] = "SHAMAL",
	[520] = "HYDRA",
	[521] = "FCR900",
	[522] = "NRG500",
	[523] = "HPV1000",
	[524] = "CEMENT",
	[525] = "TOWTRUCK",
	[526] = "FORTUNE",
	[527] = "CADRONA",
	[528] = "FBITRUCK",
	[529] = "WILLARD",
	[530] = "FORKLIFT",
	[531] = "TRACTOR",
	[532] = "COMBINE",
	[533] = "FELTZER",
	[534] = "REMINGTN",
	[535] = "SLAMVAN",
	[536] = "BLADE",
	[537] = "FREIGHT",
	[538] = "STREAK",
	[539] = "VORTEX",
	[540] = "VINCENT",
	[541] = "BULLET",
	[542] = "CLOVER",
	[543] = "SADLER",
	[544] = "FIRETRUK",
	[545] = "HUSTLER",
	[546] = "INTRUDER",
	[547] = "PRIMO",
	[548] = "CARGOBOB",
	[549] = "TAMPA",
	[550] = "SUNRISE",
	[551] = "MERIT",
	[552] = "UTILITY",
	[553] = "NEVADA",
	[554] = "YOSEMITE",
	[555] = "WINDSOR",
	[556] = "MTRUCK_A",
	[557] = "MTRUCK_B",
	[558] = "URANUS",
	[559] = "JESTER",
	[560] = "SULTAN",
	[561] = "STRATUM",
	[562] = "ELEGY",
	[563] = "RAINDANC",
	[564] = "RCTIGER",
	[565] = "FLASH",
	[566] = "TAHOMA",
	[567] = "SAVANNA",
	[568] = "BANDITO",
	[569] = "FREIFLAT",
	[570] = "CSTREAK",
	[571] = "KART",
	[572] = "MOWER",
	[573] = "DUNE",
	[574] = "SWEEPER",
	[575] = "BROADWAY",
	[576] = "TORNADO",
	[577] = "AT400",
	[578] = "DFT30",
	[579] = "HUNTLEY",
	[580] = "STAFFORD",
	[581] = "BF400",
	[582] = "NEWSVAN",
	[583] = "TUG",
	[584] = "PETROTR",
	[585] = "EMPEROR",
	[586] = "WAYFARER",
	[587] = "EUROS",
	[588] = "HOTDOG",
	[589] = "CLUB",
	[590] = "FREIFLAT",
	[591] = "ARTICT3",
	[592] = "ANDROM",
	[593] = "DODO",
	[594] = "RCCAM",
	[595] = "LAUNCH",
	[596] = "POLICE_LA",
	[597] = "POLICE_SF",
	[598] = "POLICE_VG",
	[599] = "POLRANGER",
	[600] = "PICADOR",
	[601] = "SWATVAN",
	[602] = "ALPHA",
	[603] = "PHOENIX",
	[604] = "GLENDALE",
	[605] = "SADLER",
	[606] = "BAGBOXA",
	[607] = "BAGBOXB",
	[608] = "STAIRS",
	[609] = "BOXBURG",
	[610] = "FARM_TR1",
	[611] = "UTIL_TR1"
}

local vehicleIdentifierModels = {}

for k, v in pairs(vehicleModelIdentifier) do
	vehicleIdentifierModels[v] = k
end

customHandling = {}
customFlags = {}

local textHandling = {
	"LANDSTAL 1600 2500 1.8 0 0.15 -0.3 75 0.9 0.9 0.497 5 120 12 50 4 d 50 0.6 true 35 2.4 0.08 0 0.28 -0.1 0.5 0.25 0.27 0.23 25000 20 500002 0 1 0",
"BRAVURA  1300 2200 1.7 0 0.3 0 70 0.65 0.8 0.52 5 120 6 10 f p 8 0.8 false 30 1.3 0.08 0 0.31 -0.15 0.57 0 0.26 0.5 9000 1 1 0 0 0",
"PEREN    1200 3000 2.5 0 0.1 0 70 0.7 0.9 0.48 5 1820 14.1 20 4 p 4 0.8 false 30 1.4 0.1 0 0.37 -0.17 0.5 0 0.2 0.6 10000 20 0 1 1 0",
"SENTINEL 1600 4000 2.2 0 0 -0.2 75 0.65 0.75 0.5 5 980 15.3 10 4 p 10 0.5 false 27 1 0.08 0 0.3 -0.2 0.5 0.3 0.2 0.56 35000 0 400000 0 1 0",
"FIRETRUK 6500 36670.801 3 0 0 0 90 0.55 0.8 0.5 5 1280 18.8 10 r d 10 0.45 false 27 1.2 0.08 0 0.47 -0.17 0.5 0 0.2 0.26 15000 4098 0 0 1 2",
"STRETCH 2200 10000 1.8 0 0 0 75 0.6 0.8 0.5 5 135 8.9 25 4 e 10 0.4 false 30 1.1 0.07 0 0.35 -0.2 0.5 0 0.72 0.72 40000 282000 10400001 1 1 0",
"MANANA 1000 1400 2.8 0 0.2 0 70 0.8 0.8 0.5 3 98 7.2 15 f p 8 0.8 false 30 1.2 0.1 5 0.31 -0.15 0.5 0.2 0.26 0.5 9000 0 0 0 0 0",
"INFERNUS 1400 2725.3 1.5 0 0 -0.25 70 0.7 0.8 0.5 5 4600 18.4 10 4 p 11 0.51 false 30 1.2 0.19 0 0.25 -0.1 0.5 0.4 0.37 0.72 95000 40002004 C00000 1 1 1",
"VOODOO 1800 4411.5 2 0 -0.1 -0.2 70 0.95 0.8 0.45 5 3900 14.2 5 r p 6.5 0.5 false 25 1 0.08 0 0.2 -0.25 0.5 0.6 0.26 0.41 30000 0 2410008 1 1 0",
"PONY 2600 8666.7 3 0 0 -0.25 80 0.55 0.9 0.5 5 165 6.1 25 r d 6 0.8 false 30 2.6 0.07 0 0.35 -0.15 0.25 0 0.2 0.5 20000 4001 1 0 3 13",
"CHEETAH 1200 3000 2 0 -0.2 -0.2 70 0.8 0.9 0.5 5 7800 18.2 10 r p 11.1 0.48 false 35 0.8 0.2 0 0.1 -0.15 0.5 0.6 0.4 0.54 105000 C0002004 200000 0 0 1",
"MOONBEAM 2000 5848.3 2.8 0 0.2 -0.1 85 0.6 0.8 0.5 5 330 8.1 15 r d 5.5 0.6 false 30 1.4 0.1 0 0.35 -0.15 0.55 0 0.2 0.75 16000 20 0 1 3 0",
"ESPERANT 1800 4350 2 0 0 0 70 0.55 0.88 0.52 5 2200 19.2 5 4 p 5 1 false 30 1 0.05 1 0.35 -0.18 0.5 0 0.36 0.54 19000 40000000 10000000 0 3 0",
"TAXI 1450 4056.4 2.2 0 0.3 -0.25 75 0.8 0.75 0.45 5 700 11.2 10 f p 9.1 0.6 false 35 1.4 0.1 0 0.25 -0.15 0.54 0 0.2 0.51 20000 0 200000 0 1 0",
"WASHING 1850 5000 2.2 0 0 -0.1 75 0.75 0.65 0.52 5 700 11 10 r p 7.5 0.65 false 30 1 0.2 0 0.27 -0.2 0.5 0.35 0.24 0.6 18000 0 10400000 1 1 0",
"AMBULAN 2600 10202.8 2.5 0 0 -0.1 90 0.75 0.8 0.47 5 1280 13.9 10 4 d 7 0.55 false 35 1 0.07 0 0.4 -0.2 0.5 0 0.58 0.33 10000 4001 4 0 1 13",
"ENFORCER 4000 17333.301 1.8 0 0.1 0 85 0.55 0.8 0.48 5 1900 12.5 20 r d 5.4 0.45 false 27 1.4 0.1 0 0.4 -0.25 0.5 0 0.32 0.16 40000 4011 0 0 1 13",
"BANSHEE 1400 3000 2 0 0 -0.2 70 0.75 0.89 0.5 4 400 26 30 4 p 8 0.52 false 50 1.6 0.1 5 0.3 -0.15 0.5 0 0.49 0.49 45000 2004 200000 1 1 1",
"PREVION 1400 3000 2 0 0.3 -0.1 70 0.7 0.8 0.45 4 400 8.4 7 4 p 8 0.65 false 35 1.1 0.08 2 0.31 -0.18 0.55 0.3 0.21 0.5 9000 0 0 0 0 0",
"STALLION 1600 3921.3 2 0 0 -0.15 70 0.8 0.75 0.55 4 550 11.3 5 r p 8.17 0.52 false 35 1.2 0.1 0 0.3 -0.2 0.5 0 0.3 0.64 19000 2800 4 1 1 0",
"ADMIRAL 1650 3851.4 2 0 0 -0.05 75 0.65 0.9 0.51 5 550 12.1 8 f p 8.5 0.52 false 30 1 0.15 0 0.27 -0.19 0.5 0.55 0.2 0.56 35000 0 400000 0 1 0",
"TURISMO 1400 3000 2 0 -0.3 -0.2 70 0.75 0.85 0.45 5 1500 21 10 4 p 11 0.51 false 30 1.2 0.13 0 0.15 -0.2 0.5 0.4 0.17 0.72 95000 40002004 C00001 1 1 1",
"SOLAIR 2000 5500 2 0 0 0 75 0.75 0.8 0.52 4 580 11.7 10 r p 5 0.6 false 30 1.2 0.1 0 0.27 -0.17 0.5 0.2 0.24 0.48 18000 20 0 1 1 0",
"GLENDALE 1600 4000 2.5 0 0 0.05 75 0.6 0.84 0.52 5 1480 13.9 17 4 p 6.2 0.55 false 30 0.8 0.07 0 0.35 -0.22 0.5 0.5 0.23 0.4 20000 0 10800002 1 1 0",
"OCEANIC 1900 4529.9 2 0 0 0 75 0.67 0.75 0.52 5 240 6.8 5 r p 5 0.55 false 30 1 0.1 0 0.35 -0.17 0.5 0.5 0.23 0.45 20000 0 10800000 2 1 0",
"HERMES 1950 4712.5 2 0 0.3 0 70 0.7 0.75 0.51 5 700 8.5 15 f p 3.5 0.6 false 28 1 0.05 0 0.35 -0.2 0.58 0 0.25 0.42 19000 40002000 1 1 3 0",
"SABRE 1700 4000 2 0 0.1 0 70 0.7 0.8 0.53 4 160 9.6 10 r p 8 0.52 false 35 1.3 0.08 5 0.3 -0.2 0.5 0.25 0.25 0.52 19000 0 10000006 1 1 0",
"ZR350 1400 2979.7 2 0 0.2 -0.1 70 0.8 0.8 0.51 5 1500 20.1 15 4 p 11.1 0.52 false 30 1.2 0.1 0 0.31 -0.15 0.5 0.3 0.24 0.6 45000 0 C00000 1 1 0",
"FBIRANCH 3500 11156.2 2.2 0 0 -0.2 80 0.8 0.8 0.52 5 590 18 4.9 4 p 8.5 0.5 false 30 0.7 0.15 0 0.34 -0.2 0.5 0.5 0.44 0.3 40000 4020 500000 0 1 0",
"RANCHER 2500 7604.2 2.5 0 0 -0.35 80 0.7 0.85 0.54 5 200 8.6 5 4 e 7 0.45 false 35 0.8 0.08 0 0.45 -0.25 0.45 0 0.35 0.35 40000 4020 100004 0 1 0",
"VIRGO 1700 3435.4 2 0 0 -0.1 70 0.7 0.86 0.5 4 940 16 15 4 p 7 0.5 false 32 0.8 0.1 0 0.31 -0.15 0.5 0.5 0.26 0.85 9000 40000000 10000000 0 0 0",
"GREENWOO 1600 4000 2.5 0 0 0 70 0.7 0.8 0.52 4 340 8.6 20 r p 5.4 0.6 false 30 1.1 0.12 5 0.32 -0.2 0.5 0 0.22 0.54 19000 0 10000001 0 3 0",
"HOTRING 1600 4500 1.4 0 0.2 -0.4 70 0.85 0.8 0.48 5 220 23.5 5 4 e 10 0.52 false 30 1.5 0.1 10 0.29 -0.16 0.6 0 0.56 0.56 45000 40002004 C00000 1 1 0",
"SUPERGT 1400 2800 2 0 -0.2 -0.24 70 0.75 0.86 0.48 5 240 11.9 5 r p 8 0.52 false 30 1 0.2 0 0.25 -0.1 0.5 0.3 0.4 0.54 105000 40002004 200000 0 0 1",
"ELEGANT 2200 5000 1.8 0 0.1 -0.1 75 0.7 0.8 0.46 5 170 8.3 10 r p 6 0.55 false 30 1 0.1 0 0.35 -0.15 0.5 0.3 0.2 0.3 35000 40000000 10400000 0 1 0",
"NEBULA 1400 4000 2 0 0.3 -0.1 75 0.65 0.8 0.5 5 170 8.01 10 f p 8 0.55 false 30 1.4 0.1 0 0.27 -0.1 0.58 0.3 0.2 0.56 35000 0 400000 0 1 0",
"MAJESTIC 1400 3267.8 2.2 0 0.1 -0.1 75 0.75 0.8 0.52 5 1520 22.4 10 4 p 7 0.55 false 30 1.3 0.13 0 0.27 -0.15 0.5 0.3 0.2 0.56 35000 400000 10400000 0 1 0",
"BUCCANEE 1700 4500 2.2 0 0.3 0 70 0.6 0.86 0.54 4 2000 23.6 90 4 d 5 0.52 false 50 0.8 0.08 0 0.2 -0.2 0.54 0.4 0.3 0.52 19000 40400004 4 1 1 1",
"TOWTRUCK 3500 12000 2.5 0 0.3 -0.25 80 0.85 0.7 0.46 5 200 10.4 30 r d 6 0.8 false 45 1.6 0.07 0 0.35 -0.15 0.25 0 0.2 0.5 20000 240001 1140000 0 3 13",
"FORTUNE 1700 4166.4 2 0 0 -0.2 70 0.7 0.84 0.53 4 2200 20.8 10 4 p 8.17 0.52 false 35 1.2 0.15 0 0.3 -0.1 0.5 0.25 0.3 0.52 19000 40000000 4 1 1 0",
"CADRONA 1200 2000 2.2 0 0.15 -0.1 70 0.7 0.86 0.5 4 2300 19.2 5 4 p 8 0.6 false 30 1.4 0.12 0 0.3 -0.08 0.5 0 0.26 0.5 9000 40000000 2 0 0 0",
"FELTZER 1600 4500 2.5 0 0 -0.15 75 0.65 0.9 0.5 5 250 11.1 25 r p 7 0.52 false 30 1.1 0.09 0 0.3 -0.1 0.5 0.3 0.25 0.6 35000 40002800 0 1 1 19",
"REMINGTN 1800 4000 2 0 -0.4 -0.2 70 0.75 0.8 0.56 5 180 9.3 5 r p 6.5 0.5 false 30 0.5 0.1 0 0 -0.2 0.4 0.6 0.21 0.41 30000 40002004 2410000 1 1 1",
"SLAMVAN 1950 4712.5 4 0 0.1 0 70 0.65 0.9 0.5 5 1300 24 11 4 p 10 0.5 false 28 1.6 0.12 0 0.35 -0.14 0.5 0.3 0.36 0.42 19000 40002000 2010000 1 3 0",
"VINCENT 1800 3000 2 0 0.3 0 70 0.7 0.8 0.5 4 540 14.6 10 4 p 5.4 0.6 false 30 1 0.09 0 0.32 -0.16 0.56 0 0.26 0.54 19000 0 2 0 3 0",
"BULLET 1200 2500 1.8 0 -0.15 -0.2 70 0.75 0.9 0.48 5 2300 25.8 10 4 p 8 0.58 false 30 1 0.13 5 0.25 -0.1 0.45 0.3 0.15 0.54 105000 C0002004 200000 0 0 1",
"CLOVER 1600 3000 2.2 0 0 0 70 0.65 0.8 0.52 4 105 9.1 10 r p 8 0.5 false 35 1 0.1 0 0.3 -0.1 0.5 0.25 0.25 0.52 19000 40280000 10000004 1 1 0",
"POLRANGER 2500 5500 3 0 0 -0.2 85 0.65 0.85 0.55 5 5800 14.6 15 4 d 6.2 0.6 false 35 0.7 0.06 1 0.3 -0.25 0.5 0.25 0.27 0.23 25000 284020 300000 0 1 0",
"HUSTLER 1700 4000 2.5 0 0 -0.05 75 0.75 0.75 0.52 5 140 7.5 10 r p 8 0.5 false 30 0.45 0.1 0 0.1 -0.15 0.5 0.5 0.18 0.45 20000 0 800000 2 1 0",
"INTRUDER 1800 4350 2 0 0 0 70 0.7 0.8 0.49 5 280 7.3 25 r p 5.4 0.6 false 30 1 0.09 0 0.32 -0.15 0.54 0 0.26 0.54 19000 0 2 0 3 0",
"PRIMO 1600 3300 2.2 0 0 0 70 0.7 0.8 0.54 4 160 16 7 4 e 5.4 0.6 false 30 1.1 0.14 0 0.32 -0.14 0.5 0 0.54 0.54 19000 0 0 0 3 0",
"TAMPA 1700 4166.4 2.5 0 0.15 0 70 0.6 0.85 0.52 4 290 17.2 10 4 e 8.17 0.52 false 35 0.7 0.08 3 0.3 -0.16 0.5 0 0.52 0.52 19000 40000004 4 1 1 1",
"SUNRISE 1600 3550 2 0 0.3 0 70 0.7 0.8 0.52 5 240 7.3 5 f p 5.4 0.6 false 30 1 0.09 0 0.3 -0.12 0.55 0 0.26 0.54 19000 40000000 1 0 3 0",
"MERIT 1800 4500 2.2 0 0.2 -0.1 75 0.65 0.8 0.49 5 165 8.6 10 r p 9 0.55 false 30 1.1 0.15 0 0.27 -0.08 0.54 0.3 0.2 0.56 35000 40000000 400001 0 1 0",
"WINDSOR 1500 3500 3 0 0.05 -0.2 75 0.55 0.85 0.5 5 3200 23 10 4 p 8 0.45 false 30 0.65 0.07 0 0.15 -0.1 0.5 0.3 0.25 0.6 35000 40282804 0 1 1 1",
"URANUS 1400 2998.3 2 0 0.1 -0.3 75 0.8 0.85 0.47 5 620 9.8 5 4 p 8 0.45 false 30 1.3 0.15 0 0.28 -0.1 0.5 0.3 0.25 0.6 35000 C0002800 4000001 1 1 0",
"JESTER 1500 3600 2.2 0 0 -0.05 75 0.85 0.8 0.5 5 2470 17.2 10 4 p 10 0.45 false 30 1.1 0.1 0 0.28 -0.15 0.5 0.3 0.25 0.6 35000 C0002804 4000000 1 1 1",
"SULTAN 1400 3400 2.4 0 0.1 -0.1 75 0.8 0.8 0.5 5 200 11.2 5 4 p 10 0.5 false 30 1.2 0.15 0 0.28 -0.2 0.5 0.3 0.25 0.6 35000 2800 4000002 1 1 0",
"STRATUM 1800 4500 2.1 0 0.1 -0.1 75 0.6 0.85 0.5 5 3000 14.1 10 r p 7 0.5 false 30 1 0.15 0 0.28 -0.16 0.5 0.3 0.25 0.6 35000 2800 4000000 1 1 0",
"ELEGY 1500 3500 2.2 0 0.3 -0.15 75 0.65 0.9 0.5 5 1800 11.6 5 r p 8 0.5 false 35 1 0.2 0 0.28 -0.1 0.5 0.3 0.25 0.6 35000 40002804 4000001 1 1 1",
"FLASH 1400 2998.3 2.2 0 0.2 -0.1 75 0.75 0.9 0.5 5 62000 33.2 12 4 p 8 0.55 false 30 1.4 0.15 0 0.28 -0.1 0.5 0.3 0.25 0.6 35000 2804 4000001 1 1 1",
"TAHOMA 1800 4000 2.3 0 -0.3 0 75 0.75 0.85 0.52 5 1000 15.1 10 4 p 7 0.5 false 35 1 0.08 0 0.28 -0.2 0.45 0.3 0.25 0.6 35000 0 12010000 1 1 0",
--"POLICE_LA 1600 4500 2 0 0.3 -0.1 75 0.75 0.85 0.5 5 2200 19.1 10 r p 10 0.53 false 35 1 0.12 0 0.28 -0.12 0.55 0 0.2 0.24 25000 40000000 10200008 0 1 0",
"POLICE_LA 1600 4500 2 0 0.3 -0.1 75 0.75 0.85 0.5 5 2200 19.1 10 4 p 10 0.53 false 35 1 0.12 0 0.28 -0.12 0.55 0 0.2 0.24 25000 40000000 10200008 0 1 0",
"POLICE_SF 1600 4500 2 0 0.3 -0.1 75 0.75 0.85 0.5 5 2200 19.1 10 4 p 10 0.53 false 35 1 0.12 0 0.28 -0.12 0.55 0 0.2 0.24 25000 40000000 10200008 0 1 0",
"POLICE_VG 1600 4500 2 0 0.3 -0.1 75 0.75 0.85 0.52 5 4900 23.9 10 4 p 10 0.53 false 35 0.9 0.08 0 0.28 -0.17 0.55 0 0.2 0.24 25000 40000000 10200008 0 1 0",
"POLRANGER 2500 5500 3 0 0 -0.2 85 0.65 0.85 0.55 5 5800 12.1 15 4 d 6.2 0.6 false 35 0.7 0.06 1 0.3 -0.25 0.5 0.25 0.27 0.23 25000 284020 300000 0 1 0",
"ALPHA 1500 3400 2 0 0.1 -0.2 85 0.7 0.8 0.5 5 4300 19.3 5 4 p 7 0.55 false 30 1.2 0.12 0 0.3 -0.15 0.5 0.4 0.25 0.5 35000 40002800 200000 1 1 0",
"PHOENIX 1500 4000 2.2 0 0.3 -0.15 85 0.7 0.9 0.52 5 4800 40.1 5 4 p 6 0.55 false 30 0.8 0.08 0 0.28 -0.24 0.59 0.4 0.25 0.5 35000 2800 200000 1 1 0",


}

local textFlag = {
	--[597] = "WHEEL_R_WIDE2,WHEEL_F_WIDE2; ;AXLE_F_NOTILT,AXLE_R_NOTILT; "
}

for k, v in pairs(textFlag) do
	local sections = split(v, ";")

	customFlags[k] = {
		["addHandling"] = {},
		["removeHandling"] = {},
		["addModel"] = {},
		["removeModel"] = {}
	}

	for i = 1, 4 do
		local section = sections[i]

		if section and utf8.len(section) > 1 then
			for k2, v2 in pairs(split(section, ",")) do
				if utf8.len(v2) > 1 then
					if i == 1 then
						customFlags[k]["addHandling"][v2] = true
					elseif i == 2 then
						customFlags[k]["removeHandling"][v2] = true
					elseif i == 3 then
						customFlags[k]["addModel"][v2] = true
					elseif i == 4 then
						customFlags[k]["removeModel"][v2] = true
					end
				end
			end
		end
	end
end

for k, v in pairs(textHandling) do
	local values = split(v, " ")
	local i = 0
	local model = vehicleIdentifierModels[values[1]]

	if tonumber(model) then
		customHandling[model] = {}

		for k2, v2 in ipairs(values) do
			if k2 ~= 1 then
				if k2 == 5 then
					customHandling[model]["centerOfMass"] = {v2}
				elseif k2 > 5 and k2 <= 7 then
					table.insert(customHandling[model]["centerOfMass"], v2)

					if k2 == 7 then
						i = i + 1
					end
				elseif k2 == 16 then
					i = i + 1

					if v2 == "r" then
						customHandling[model][properties[i]] = "rwd"
					elseif v2 == "f" then
						customHandling[model][properties[i]] = "fwd"
					else
						customHandling[model][properties[i]] = "awd"
					end
				elseif k2 == 17 then
					i = i + 1

					if v2 == "p" then
						customHandling[model][properties[i]] = "petrol"
					elseif v2 == "d" then
						customHandling[model][properties[i]] = "diesel"
					else
						customHandling[model][properties[i]] = "electric"
					end
				else
					i = i + 1
					customHandling[model][properties[i]] = v2
				end
			end
		end
	end
end

handlingFlags = {
	_1G_BOOST = 0x1,
	_2G_BOOST = 0x2,
	NPC_ANTI_ROLL = 0x4,
	NPC_NEUTRAL_HANDL = 0x8,
	NO_HANDBRAKE = 0x10,
	STEER_REARWHEELS = 0x20,
	HB_REARWHEEL_STEER = 0x40,
	ALT_STEER_OPT = 0x80,
	WHEEL_F_NORMAL = 0x000,
	WHEEL_F_NARROW2 = 0x100,
	WHEEL_F_NARROW = 0x200,
	WHEEL_F_WIDE = 0x400,
	WHEEL_F_WIDE2 = 0x800,
	WHEEL_R_NORMAL = 0x0000,
	WHEEL_R_NARROW2 = 0x1000,
	WHEEL_R_NARROW = 0x2000,
	WHEEL_R_WIDE = 0x4000,
	WHEEL_R_WIDE2 = 0x8000,
	HYDRAULIC_GEOM = 0x10000,
	HYDRAULIC_INST = 0x20000,
	HYDRAULIC_NONE = 0x40000,
	NOS_INST = 0x80000,
	OFFROAD_ABILITY = 0x100000,
	OFFROAD_ABILITY2 = 0x200000,
	HALOGEN_LIGHTS = 0x400000,
	PROC_REARWHEEL_1ST = 0x800000,
	USE_MAXSP_LIMIT = 0x1000000,
	LOW_RIDER = 0x2000000,
	STREET_RACER = 0x4000000,
	SWINGING_CHASSIS = 0x10000000
}

modelFlags = {
	IS_VAN = 0x1,
	IS_BUS = 0x2,
	IS_LOW = 0x4,
	IS_BIG = 0x8,
	REVERSE_BONNET = 0x10,
	HANGING_BOOT = 0x20,
	TALIGATE_BOOT = 0x40,
	NOSWING_BOOT = 0x80,
	NO_DOORS = 0x100,
	TANDEM_SEATS = 0x200,
	SIT_IN_BOAT = 0x400,
	CONVERTIBLE = 0x800,
	NO_EXHAUST = 0x1000,
	DBL_EXHAUST = 0x2000,
	NO1FPS_LOOK_BEHIND = 0x4000,
	FORCE_DOOR_CHECK = 0x8000,
	AXLE_F_NOTILT = 0x10000,
	AXLE_F_SOLID = 0x20000,
	AXLE_F_MCPHERSON = 0x40000,
	AXLE_F_REVERSE = 0x80000,
	AXLE_R_NOTILT = 0x100000,
	AXLE_R_SOLID = 0x200000,
	AXLE_R_MCPHERSON = 0x400000,
	AXLE_R_REVERSE = 0x800000,
	IS_BIKE = 0x1000000,
	IS_HELI = 0x2000000,
	IS_PLANE = 0x4000000,
	IS_BOAT = 0x8000000,
	BOUNCE_PANELS = 0x10000000,
	DOUBLE_RWHEELS = 0x20000000,
	FORCE_GROUND_CLEARANCE = 0x40000000,
	IS_HATCHBACK = 0x80000000
}

function isFlagSet(val, flag)
	return (bitAnd(val, flag) == flag)
end

function getVehicleHandlingFlags(vehicle)
	local bytes = getVehicleHandling(vehicle)["handlingFlags"]
	local flags = {}
	
	for k, v in pairs(handlingFlags) do
		if isFlagSet(bytes, v) then
			flags[k] = true
		end
	end
	
	return flags, bytes
end

function getVehicleModelFlags(vehicle)
	local bytes = getVehicleHandling(vehicle)["modelFlags"]
	local flags = {}
	
	for k, v in pairs(modelFlags) do
		if isFlagSet(bytes, v) then
			flags[k] = true
		end
	end
	
	return flags, bytes
end

function setVehicleHandlingFlag(vehicle, flag, add)
	local flags, currentbyte = getVehicleHandlingFlags(vehicle)
	local newbyte = currentbyte

	for k in pairs(flags) do
		if string.find(k, flag) then
			newbyte = newbyte - handlingFlags[k]
		end
	end
	
	if add then
		newbyte = newbyte + handlingFlags[flag]
	end

	if newbyte ~= currentbyte then
		setVehicleHandling(vehicle, "handlingFlags", newbyte)
	end
end

function setVehicleModelFlag(vehicle, flag, add)
	local flags, currentbyte = getVehicleModelFlags(vehicle)
	local newbyte = currentbyte

	for k in pairs(flags) do
		if string.find(k, flag) then
			newbyte = newbyte - modelFlags[k]
		end
	end
	
	if add then
		newbyte = newbyte + modelFlags[flag]
	end

	if newbyte ~= currentbyte then
		setVehicleHandling(vehicle, "modelFlags", newbyte)
	end
end

function applyCustomHandling(vehicle)
	if isElement(vehicle) then
		local model = getElementModel(vehicle)

		if customHandling[model] then
			for property, value in pairs(customHandling[model]) do
				if value == "true" then
					setVehicleHandling(vehicle, property, true)
				elseif value == "false" then
					setVehicleHandling(vehicle, property, false)
				elseif property == "modelFlags" or property == "handlingFlags" then
					setVehicleHandling(vehicle, property, tonumber("0x" .. value))
				else
					setVehicleHandling(vehicle, property, value)
				end
			end
		end

		if customFlags[model] then
			if customFlags[model]["removeHandling"] then
				for flag in pairs(customFlags[model]["removeHandling"]) do
					setVehicleHandlingFlag(vehicle, flag, false)
				end
			end

			if customFlags[model]["addHandling"] then
				for flag in pairs(customFlags[model]["addHandling"]) do
					setVehicleHandlingFlag(vehicle, flag, true)
				end
			end

			if customFlags[model]["removeModel"] then
				for flag in pairs(customFlags[model]["removeModel"]) do
					setVehicleModelFlag(vehicle, flag, false)
				end
			end

			if customFlags[model]["addModel"] then
				for flag in pairs(customFlags[model]["addModel"]) do
					setVehicleModelFlag(vehicle, flag, true)
				end
			end
		end
	end
end