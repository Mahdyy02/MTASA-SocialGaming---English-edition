local pdgates = 
{
	{
		{ createObject(3089,245.8,72.5,1003.9,0,0,0), 90 }, -- FOLYOSÓ BEJÁRAT
	},
	{
		{ createObject(3089,248.10001,75.3,1003.9,0,0,90), -90 }, -- ÖLTÖZŐ
	},
	{
		{ createObject(3089,248,85.8,1003.9,0,0,90), -90 }, -- CELLA1
	},
	{
		{ createObject(2930,259,91.5,1004,0,0,0), -90 }, -- CELLA 2
	},
	{
		{ createObject(1495,221.89999,77.2,1004,0,0,180), 90 }, -- BIZONYÍTÉK
	},
	{
		{ createObject(3089,250.60001,62.4,1003.9,0,0,90), -90 }, -- PORTA
	},
}

for _, group in ipairs(pdgates) do
	for _, gate in ipairs(group) do
		setElementInterior(gate[1], 6)
		setElementDimension(gate[1], 16)
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
	if getElementDimension(thePlayer) == 16 and getElementInterior(thePlayer) == 6 and (getElementData(thePlayer,"faction_53") or getElementData(thePlayer, "admin >> duty")) then
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