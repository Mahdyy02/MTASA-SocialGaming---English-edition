local func = {};
local removeCache = {
	--[model] = {modelID,radius,x,y,z,interior};
	{5681, 1000, 1921.4844, -1778.9141, 18.5781, 0};
	{4220, 1000, 1370.6406, -1643.4453, 33.1797, 0};
	{4215, 1000, 1777.5547, -1775.0391, 36.7500, 0};
};

func.start = function()
	for k,v in ipairs(removeCache) do
		removeWorldModel(v[1],v[2],v[3],v[4],v[5],v[6])
	end
end
addEventHandler("onClientResourceStart",resourceRoot,func.start)