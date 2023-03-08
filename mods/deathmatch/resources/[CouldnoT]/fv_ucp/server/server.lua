function getAllPlayer()
	local all = 0
	for i,p in pairs(getElementsByType("player")) do
		all = i
	end
	return all
end