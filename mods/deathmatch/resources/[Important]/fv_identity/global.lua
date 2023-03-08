white = "#FFFFFF"

function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end
function randomString(length)
	local res = "";
	for i = 1, length do
		res = res .. string.char(math.random(97, 122));
	end
	return res:upper();
end
function getGender(id)
	if id == 1 then 
		return "Male";
	elseif id == 2 then 
		return "Female";
	end
end
function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end