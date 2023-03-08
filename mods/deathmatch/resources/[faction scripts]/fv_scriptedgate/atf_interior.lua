local pdgates = 
{
	{
		{ createObject(3089,239.5,116.1,1003.5477294922,0,0,90), 90 },
		{ createObject(3089,239.5,119.0,1003.5477294922,0,0,270), -90 }
	},
	{
		{ createObject(3089,253.2,107.6,1003.5477294922,0,0,90), -90 },
		{ createObject(3089,253.2,110.5,1003.5477294922,0,0,270), 90 }
	},
	{
		{ createObject(3089,239.62,123.6,1003.5477294922,0,0,90), -90 },
		{ createObject(3089,239.62,126.5,1003.5477294922,0,0,270), 90 }
	},
	{
		{ createObject(3089,253.2,123.84042358398,1003.5477294922,0,0,90), -90 },
		{ createObject(3089,253.2,126.75514221191,1003.5477294922,0,0,270), 90 }
	},
	{
		{ createObject(3089,229.7,119.5,1010.5477294922,0,0,0), 90 },
		{ createObject(3089,232.6,119.5,1010.5477294922,0,0,180), -90 }
	},
	{
		{ createObject(3089,232.9,110.55,1010.5477294922,0,0,270), 90 },
		{ createObject(3089,232.9,107.65,1010.5477294922,0,0,90), -90 }
	},
	{
		{ createObject(3089,222.1875,119.51522064209,1010.5477294922,0,0,0), 90 }
	},
	{
		{ createObject(3089,275.77990722656,121.38358306885,1004.9461669922,0,0,90), -90 }
	},
	{
		{ createObject(3089,275.79528808594,115.92472839355,1004.9461669922,0,0,90), -90 },
		{ createObject(3089,275.80328369141,118.91221618652,1004.9461669922,0,0,270), 90 }
	},
	{
		{ createObject(3089,267.43103027344,115.82251739502,1004.9461669922,0,0,180), -90 },
		{ createObject(3089,264.44378662109,115.8176574707,1004.9461669922), 90 }
	},
	{
		{ createObject(3089,267.32672119141,112.51244354248,1004.9461669922,0,0,180), 90 },
		{ createObject(3089,264.34057617188,112.52392578125,1004.9461669922), -90 }
	},
	{
		{ createObject(1495,220.10001, 118.4, 998), -90 }
	},
	{
		{ createObject(2930, 220, 122.1, 1000.6), -90}
	},
	{
		{ createObject(2930,218.5,116.5,1000.6, 0, 0, 270), -1.5, true }
	},
	{
		{ createObject(1495, 213.60001,124.9,998), 90 }
	}
}

for _, group in ipairs(pdgates) do
	for _, gate in ipairs(group) do
		setElementInterior(gate[1], 10)
		setElementDimension(gate[1], 1755)
	end
end

local function resetBusy( shortestID )
	pdgates[ shortestID ].busy = nil
end

local function closeDoor( shortestID )
	group = pdgates[ shortestID ]
	for _, gate in ipairs(group) do
		local nx, ny, nz = getElementPosition( gate[1] )
		moveObject( gate[1], 1000, nx + ( gate[3] and -gate[2] or 0 ), ny, nz, 0, 0, gate[3] and 0 or -gate[2] )
	end
	group.busy = true
	group.timer = nil
	setTimer( resetBusy, 1000, 1, shortestID )
end

local function openDoor(thePlayer)
	if getElementDimension(thePlayer) == 1755 and getElementInterior(thePlayer) == 10 and (getElementData(thePlayer,"faction_54") or getElementData(thePlayer, "admin >> duty")) then
		local shortest, shortestID, dist = nil, nil, 5
		local px, py, pz = getElementPosition(thePlayer)
		
		for id, group in pairs(pdgates) do
			for _, gate in ipairs(group) do
				local d = getDistanceBetweenPoints3D(px,py,pz,getElementPosition(gate[1]))
				if d < dist then
					shortest = group
					shortestID = id
					dist = d
				end
			end
		end
		
		if shortest then
			if shortest.busy then
				return
			elseif shortest.timer then
				killTimer( shortest.timer )
				shortest.timer = nil
				outputChatBox( "The door is already open!", thePlayer, 0, 255, 0 )
			else
				for _, gate in ipairs(shortest) do
					local nx, ny, nz = getElementPosition( gate[1] )
					moveObject( gate[1], 1000, nx + ( gate[3] and gate[2] or 0 ), ny, nz, 0, 0, gate[3] and 0 or gate[2] )
				end
				outputChatBox( "You opened the door!", thePlayer, 0, 255, 0 )
			end
			shortest.timer = setTimer( closeDoor, 5000, 1, shortestID )
		end
	end
end
addCommandHandler( "gate", openDoor)