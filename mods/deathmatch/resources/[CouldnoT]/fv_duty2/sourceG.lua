-- 1 Frakciónak max 13 csomag lehetséges!
-- 1 csomagban max 10 skin lehetséges!
-- 1 csomagban max 18 item lehetséges!

dutyPackages = {
    --[Frakció ID] 
    [53] = { 
        position = {1996.3635253906, -1368.8226318359, 997.18676757813, 0, 16}, -- X, Y, Z, INT, DIM
        [1] = {
            rank = 1,
            name = "Police Officer 1-3",
            armor = 100,
            skins = {132, 133, 134, 135, 136, 138, 139}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {20, 1, 1, 100}, -- Gumibot
                {17, 1, 1, 100}, -- Deagle
                {31, 70, 1, 100}, -- 9mm
                {29, 1, 1, 100}, -- Sokkoló
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
        [2] = {
            rank = 4,
            name = "Detective",
            armor = 100,
            skins = {46, 47, 48, 59, 51, 60, 7, 9, 10, 11}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {24, 1, 1, 100}, -- Deagle
                {31, 100, 1, 100}, -- 9mm
                {29, 1, 1, 100}, -- Sokkoló
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
        [3] = {
            rank = 7,
            name = "Sergeant",
            armor = 100,
            skins = {132, 133, 134, 135, 136, 138, 139}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {20, 1, 1, 100}, -- Gumibot
                {17, 1, 1, 100}, -- Deagle
                {31, 120, 1, 100}, -- 9mm
                {27, 1, 1, 100}, -- Mp5
                {31, 120, 1, 100}, -- 9mm
                {29, 1, 1, 100}, -- Sokkoló
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
        [4] = {
            rank = 9,
            name = "Lieutenant",
            armor = 100,
            skins = {132, 133, 134, 135, 136, 138, 139}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {20, 1, 1, 100}, -- Gumibot
                {17, 1, 1, 100}, -- Deagle
                {31, 120, 1, 100}, -- 9mm
                {15, 1, 1, 100}, -- M4
                {33, 120, 1, 100}, -- 7.76
                {29, 1, 1, 100}, -- Sokkoló
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
        [5] = {
            rank = 2,
            name = "SWAT",
            armor = 100,
            skins = {137, 140, 141}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {20, 1, 1, 100}, -- Gumibot
                {17, 1, 1, 100}, -- Deagle
                {31, 120, 1, 100}, -- 9mm
                {15, 1, 1, 100}, -- M4
                {33, 150, 1, 100}, -- 7.76
                {29, 1, 1, 100}, -- Sokkoló
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
        [6] = {
            rank = 2,
            name = "SWAT Shooter",
            armor = 100,
            skins = {137, 140, 141}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {20, 1, 1, 100}, -- Gumibot
                {24, 1, 1, 100}, -- Deagle
                {31, 120, 1, 100}, -- 9mm
                {25, 1, 1, 100}, -- Sniper
                {33, 50, 1, 100}, -- 7.76
                {29, 1, 1, 100}, -- Sokkoló
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
    },
    [54] = { 
        position = {264.54998779297, 109.46909332275, 1004.6171875, 10, 1755}, -- X, Y, Z, INT, DIM
        [1] = {
            rank = 1,
            name = "ATF Ügynök",
            armor = 100,
            skins = {142, 143, 144}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {17, 1, 1, 100}, -- Deagle
                {31, 70, 1, 100}, -- 9mm
                {29, 1, 1, 100}, -- Sokkoló
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
        [2] = {
            rank = 3,
            name = "ATF Készenléti Ügynök",
            armor = 100,
            skins = {142}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {17, 1, 1, 100}, -- Deagle
                {31, 120, 1, 100}, -- 9mm
                {27, 1, 1, 100}, -- Mp5
                {31, 80, 1, 100}, -- 9mm
                {29, 1, 1, 100}, -- Sokkoló
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
        [3] = {
            rank = 5,
            name = "ATF Bevetési Egység",
            armor = 100,
            skins = {137, 140, 141}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {17, 1, 1, 100}, -- Deagle
                {31, 120, 1, 100}, -- 9mm
                {27, 1, 1, 100}, -- Mp5
                {31, 240, 1, 100}, -- 9mm
                {15, 1, 1, 100}, -- M4
                {33, 240, 1, 100}, -- 7.76
                {29, 1, 1, 100}, -- Sokkoló
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
		[4] = {
            rank = 5,
            name = "ATF Mesterlövész",
            armor = 100,
            skins = {137, 140, 141}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {17, 1, 1, 100}, -- Deagle
                {31, 100, 1, 100}, -- 9mm
				{25	, 1, 1, 100}, -- Mesterlövész puska
                {33, 1, 1, 30}, -- 7.76
                {87, 1, 1, 100}, -- Bilincs
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
        [5] = {
            rank = 4,
            name = "ATF Fedett Ügynök",
            armor = 100,
            skins = {46, 47, 48, 59, 51, 60, 7, 9, 10, 11}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {24, 1, 1, 100}, -- Deagle
                {31, 100, 1, 100}, -- 9mm
                {29, 1, 1, 100}, -- Sokkoló
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {87, 1, 1, 100}, -- Bilincs
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
		
    },
    [56] = { 
        position = {1599.6295166016, -1266.2648925781, 17.625, 0, 0}, -- X, Y, Z, INT, DIM
        [1] = {
            rank = 1,
            name = "Szerelő",
            armor = 0,
            skins = {50, 305, 195}, -- Max 
            items = {
                --{ItemID, Mennyiség, Érték, Állapot},
                {71, 1, 1, 100}, -- Elsősegély
                {71, 1, 1, 100}, -- Elsősegély
            },
        },
    },
}