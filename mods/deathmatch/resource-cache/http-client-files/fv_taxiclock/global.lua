models = {
    [420] = true,
    [438] = true,
}

function getVehicleSpeed(veh)
    if veh then
        local x, y, z = getElementVelocity (veh)
        return math.sqrt( x^2 + y^2 + z^2 ) * 187.5
    end
end
function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end
white = "#FFFFFF";