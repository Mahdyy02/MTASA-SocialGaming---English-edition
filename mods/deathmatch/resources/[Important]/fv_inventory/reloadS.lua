function forceReload(player)
	reloadPedWeapon (player)
	exports.fv_chat:sendLocalMeAction(player, "aaaa")
end
addCommandHandler("Reload weapon",forceReload)

function bindPlayerReloadKey(player)
	bindKey(player,"r","down","Reload weapon")
end

function bindReloadForAllPlayers()
	for k,v in ipairs(getElementsByType("player")) do
		bindPlayerReloadKey(v)
	end
end
--addEventHandler("onResourceStart",getResourceRootElement(),bindReloadForAllPlayers) -- Enable when issue 4532 is fixed

--Please remove the following when issue 4532 is fixt:

addEvent("onPlayerReload",true)
addEventHandler("onPlayerReload",getRootElement(),
	function()
		reloadPedWeapon (source)
	end
)