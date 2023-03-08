local kut = {}

addEventHandler("onResourceStart",getResourceRootElement(),function()
	for index,a in ipairs(kutak) do
		kut[index] = createObject(1676,a[1],a[2],a[3]+0.3,0,0,a[4])
		kut[index]:setData("refill:object",1)
	end
end);


function generateFuelPrice()
	local rand = math.random(10,50);
	setTimer(function() 
		triggerClientEvent(root,"sendFuelPrice",root,rand);
	end,200,1);
	for k,v in pairs(getElementsByType("player")) do 
		if getElementData(v,"loggedIn") then 
			outputChatBox(exports.fv_engine:getServerSyntax("Refill","orange").."Fuel price changed. New price: "..exports.fv_engine:getServerColor("servercolor",true)..rand.."#FFFFFF dt",v,255,255,255,true);
		end
	end
end
setTimer(generateFuelPrice,1000*60*30,0);
addEventHandler("onResourceStart",getResourceRootElement(),generateFuelPrice);


function playerAnimationToServer (localPlayer, animName, animtoName)
	setPedAnimation(localPlayer, animName, animtoName, -1, true, false, false, false)
end
addEvent("playerAnimationToServer", true)
addEventHandler("playerAnimationToServer", getRootElement(), playerAnimationToServer)