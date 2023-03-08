

addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("hospital.txd") -- txd neve
	engineImportTXD(txd, 3932)
	
	local dff = engineLoadDFF("hospital.dff", 3932) -- dff neve
	engineReplaceModel(dff, 3932)
	
	local col = engineLoadCOL("hospital.col") -- col
	engineReplaceCOL(col, 3932)
	
	engineSetModelLODDistance(3932, 500)     
end
)