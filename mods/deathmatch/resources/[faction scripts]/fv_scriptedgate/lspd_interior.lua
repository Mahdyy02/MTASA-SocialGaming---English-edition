local pdgates = 
{
	{
		{ createObject(1557,1973.6999511719,-1383.5,996.20001220703,0,0,90), -90 }, -- CELLA 2
	},
	{
		{ createObject(1569,2001.9000244141,-1391.0999755859,996.20001220703,0,0,270), 90 }, -- BIZONYÍTÉK
	},
	{
		{ createObject(1569,2004, -1383.5,996.20001220703,0,0,0), -90 }, -- PORTA
	},
}

for _, group in ipairs(pdgates) do
	for _, gate in ipairs(group) do
		setElementInterior(gate[1], 0)
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
	if getElementDimension(thePlayer) == 16 and getElementInterior(thePlayer) == 0 and (getElementData(thePlayer,"faction_53") or getElementData(thePlayer, "admin >> duty")) then
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