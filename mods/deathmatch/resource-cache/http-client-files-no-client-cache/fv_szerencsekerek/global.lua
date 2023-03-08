white = "#FFFFFF";

wheelValues = {
	20,
	5,
	1,
	10,
	2,
	40
};

coinTypes = {
	5,
	10,
	100,
	500,
	1000,
	2000,
	5000
};

wheelOffsets = {
	{0,0,0.95,1},--1 
	{0.12,0,0.95,2},-- 
	{-0.12,0,0.95,40},
	{-0.23,0,0.93,2},
	{-0.35,0,0.90,10},
	{-0.43,0,0.85,1},
	{-0.53,0,0.80,2},
	{-0.61,0,0.73,1},
	{-0.69,0,0.65,5},
	{-0.75,0,0.57,1},
	{-0.82,0,0.48,2},
	{-0.86,0,0.38,10},
	{-0.90,0,0.27,1},
	{-0.92,0,0.16,2},
	{-0.92,0,0.05,1},
	{-0.92,0,-0.05,5},
	{-0.92,0,-0.16,2},
	{-0.90,0,-0.27,1},
	{-0.85,0,-0.37,20},
	{-0.80,0,-0.47,1},
	{-0.75,0,-0.57,2},
	{-0.69,0,-0.65,5},
	{-0.60,0,-0.72,10},
	{-0.51,0,-0.79,1},
	{-0.42,0,-0.84,2},
	{-0.32,0,-0.88,1},
	{-0.21,0,-0.90,5},
	{-0.10,0,-0.92,1},
	{-0.0,0,-0.92,2},
	{0.11,0,-0.92,1},
	{0.21,0,-0.90,40},
	{0.32,0,-0.87,2},
	{0.42,0,-0.83,1},
	{0.52,0,-0.78,2},
	{0.60,0,-0.72,1},
	{0.68,0,-0.64,2},
	{0.75,0,-0.56,5},
	{0.80,0,-0.46,1},
	{0.85,0,-0.37,2},
	{0.90,0,-0.27,1},
	{0.93,0,-0.17,5},
	{0.94,0,-0.06,1},
	{0.94,0,0.06,20},
	{0.93,0,0.17,1},
	{0.90,0,0.27,10},
	{0.86,0,0.37,1},
	{0.81,0,0.47,2},
	{0.75,0,0.56,1},
	{0.67,0,0.65,5},
	{0.60,0,0.72,1},
	{0.51,0,0.78,2},
	{0.42,0,0.84,1},
	{0.33,0,0.89,5},
	{0.23,0,0.93,1},
};

function checkUse(element)
	local state = false;
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v,"useWheel") == element then 
			state = true;
			break;
		end
	end
	return state;
end

--UTILS--
function getPositionFromElementAtOffset(element,x,y,z)
	if not x or not y or not z then return false end

	local ox,oy,oz = getElementPosition(element)
	local matrix = getElementMatrix(element)

	if not matrix then return ox+x, oy+y, oz+z end

	local offX = x * matrix[1][1] + y * matrix[2][1] + z * matrix[3][1] + matrix[4][1]
	local offY = x * matrix[1][2] + y * matrix[2][2] + z * matrix[3][2] + matrix[4][2]
	local offZ = x * matrix[1][3] + y * matrix[2][3] + z * matrix[3][3] + matrix[4][3]

	return offX, offY, offZ
end

