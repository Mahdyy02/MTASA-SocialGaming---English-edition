white = "#FFFFFF";


--UTILS--
function tableCopy(t)
	if type(t) == "table" then
		local r = {}
		for k, v in pairs(t) do
			r[k] = tableCopy(v);
		end
		return r;
	else
		return t;
	end
end
