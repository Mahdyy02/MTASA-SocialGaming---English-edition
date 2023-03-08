function onGuiHandbrakeStateChange(state, veh)
	if state == true then
		setElementFrozen(veh, true)
		setElementData(veh, "kezifek", true)
	else
		setElementFrozen(veh, false)
		setElementData(veh, "kezifek", false)
	end
end
addEvent("onGuiHandbrakeStateChange", true)
addEventHandler("onGuiHandbrakeStateChange", getRootElement(), onGuiHandbrakeStateChange)