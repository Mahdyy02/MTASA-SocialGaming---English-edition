local timers = {};
local ignoreList = {
    ["w"]= true,
    ["s"]= true,
    ["a"]= true,
    ["d"]= true,
    ["mouse_wheel_up"]= true,
    ["mouse_wheel_down"]= true
}
addEventHandler("onClientKey", root, function(button, state)
	if state and not ignoreList[button] then
		if isTimer(timers[button]) then cancelEvent() return end;
		timers[button] = setTimer(function()end,550,1);
	end
end);