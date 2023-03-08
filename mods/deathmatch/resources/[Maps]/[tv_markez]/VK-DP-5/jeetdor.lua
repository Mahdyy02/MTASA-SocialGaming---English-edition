function TreskMapperClient ()
txd = engineLoadTXD("jeetdor.txd") 
engineImportTXD(txd, 3095 )
end
addEventHandler( "onClientResourceStart", resourceRoot, TreskMapperClient )