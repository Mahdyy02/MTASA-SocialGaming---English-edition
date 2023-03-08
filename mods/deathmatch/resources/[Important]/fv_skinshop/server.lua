local sql = exports["fv_engine"]:getConnection(getThisResource());

addEvent("onSkinBuy", true)
addEventHandler("onSkinBuy", getRootElement(), function(p,skin,cost)
	local save = dbExec(sql, "UPDATE characters SET skinid = ? WHERE ID = ?", skin, getElementData(p, "acc >> id"))
	if save then
		setElementModel(p,skin)
		outputChatBox(exports.fv_engine:getServerSyntax("Skinshop","servercolor").."Successful dress shopping!",p,255,255,255,true);
		setElementData(p,"char >> money",getElementData(p,"char >> money")-cost)
	end
end);