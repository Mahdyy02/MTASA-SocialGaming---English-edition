function McDona ()
McDonaTXD = engineLoadTXD ( "cj_burg_sign.txd" )
engineImportTXD ( McDonaTXD, 2430 )

end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), McDona )