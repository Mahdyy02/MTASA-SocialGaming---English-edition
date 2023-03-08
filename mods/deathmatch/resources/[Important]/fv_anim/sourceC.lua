function Trigger ()
	triggerServerEvent("AnimationStop", localPlayer, localPlayer)
end
bindKey("space", "down", Trigger)