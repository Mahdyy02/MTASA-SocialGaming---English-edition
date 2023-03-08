white = "#FFFFFF";

months = {};
months[0] = "January"
months[1] = "February"
months[2] = "March"
months[3] = "April"
months[4] = "May"
months[5] = "June"
months[6] = "July"
months[7] = "August"
months[8] = "September"
months[9] = "October"
months[10] = "November"
months[11] = "December"

function formatMoney(amount)
    amount = tonumber(amount);
    if not amount then 
        return "";
    end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end