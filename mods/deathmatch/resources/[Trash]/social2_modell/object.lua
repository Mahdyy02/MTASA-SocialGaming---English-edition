

addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("texture.txd") -- txd neve
	engineImportTXD(txd, 5409)
	
	local dff = engineLoadDFF("deli.dff", 5409) -- dff neve
	engineReplaceModel(dff, 5409)
	
	local col = engineLoadCOL("deli.col") -- col neve
	engineReplaceCOL(col, 5409)
end
)

addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("trafi.txd") -- txd neve
	engineImportTXD(txd, 1337)
	
	local dff = engineLoadDFF("trafi.dff", 1337) -- dff neve
	engineReplaceModel(dff, 1337)
	
	local col = engineLoadCOL("trafi.col") -- col neve
	engineReplaceCOL(col, 1337)
end
)

addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("texture.txd") -- txd neve
	engineImportTXD(txd, 1339)
	
	local dff = engineLoadDFF("atm.dff", 1339) -- dff neve
	engineReplaceModel(dff, 1339)
	
	local col = engineLoadCOL("atm.col") -- col neve
	engineReplaceCOL(col, 1339)
end
)

addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("texture.txd") -- txd neve
	engineImportTXD(txd, 3980)
	
	local dff = engineLoadDFF("vh.dff", 3980) -- dff neve
	engineReplaceModel(dff, 3980)
	
	local col = engineLoadCOL("vh.col") -- col neve
	engineReplaceCOL(col, 3980)
end
)

addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("texture.txd") -- txd neve
	engineImportTXD(txd, 3446)
	
	local dff = engineLoadDFF("zebra.dff", 3446) -- dff neve
	engineReplaceModel(dff, 3446)
	
	local col = engineLoadCOL("zebra.col") -- col neve
	engineReplaceCOL(col, 3446)
end
)

addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("texture.txd") -- txd neve
	engineImportTXD(txd, 3445)
	
	local dff = engineLoadDFF("fr.dff", 3445) -- dff neve
	engineReplaceModel(dff, 3445)
	
	local col = engineLoadCOL("fr.col") -- col neve
	engineReplaceCOL(col, 3445)  
end
)

addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("texture.txd") -- txd neve
	engineImportTXD(txd, 6907)
	
	local dff = engineLoadDFF("tuning.dff", 6907) -- dff neve
	engineReplaceModel(dff, 6907)
	
	local col = engineLoadCOL("tuning.col") -- col neve
	engineReplaceCOL(col, 6907)
end
)

addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("texture.txd") -- txd neve
	engineImportTXD(txd, 6872)
	
	local dff = engineLoadDFF("plaza.dff", 6872) -- dff neve
	engineReplaceModel(dff, 6872)
	
	local col = engineLoadCOL("plaza.col") -- col neve
	engineReplaceCOL(col, 6872)  
end
)

addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("texture.txd") -- txd neve
	engineImportTXD(txd, 7507)
	
	local dff = engineLoadDFF("fix.dff", 7507) -- dff neve
	engineReplaceModel(dff, 7507)
	
	local col = engineLoadCOL("fix.col") -- col neve
	engineReplaceCOL(col, 7507)
end
)

addEventHandler("onClientResourceStart", resourceRoot,
function()
	
	local txd = engineLoadTXD("texture.txd") -- txd neve
	engineImportTXD(txd, 5489)
	
	local dff = engineLoadDFF("delialap.dff", 5489) -- dff neve
	engineReplaceModel(dff, 5489)
	
	local col = engineLoadCOL("delialap.col") -- col neve
	engineReplaceCOL(col, 5489)
end
)

addEventHandler("onClientResourceStart", root, function()
    engineSetAsynchronousLoading ( true, true )
    setOcclusionsEnabled(false)
end)
