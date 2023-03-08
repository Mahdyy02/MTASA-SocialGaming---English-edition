addEvent("onSireneditorSirenApply", true)



addEventHandler("onSireneditorSirenApply", getRootElement(), function(anzahl, typ, f1, f2, f3, f4, settings)
	local veh = getPedOccupiedVehicle(source)
	if not(veh) then return end
	removeVehicleSirens(veh)
	addVehicleSirens(veh, anzahl, typ, f1, f2, f3, f4)
	setVehicleSirensOn(veh, false)
	setVehicleSirensOn(veh, true)
	for index, t in pairs(settings) do
		setVehicleSirens(veh, index, t["x"], t["y"], t["z"], t["r"], t["g"], t["b"], t["a"], t["am"])
	end	
end)