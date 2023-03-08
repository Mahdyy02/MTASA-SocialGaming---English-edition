addEventHandler("onClientResourceStart", resourceRoot, function()
setTimer(function()

        txd1 = engineLoadTXD ( "sd_lod.txd" )
        engineImportTXD ( txd1, 17751)
        dff1 = engineLoadDFF ( "sd_lod.dff" )
        engineReplaceModel ( dff1, 17751 )
        
        txd = engineLoadTXD ( "sd.txd" )
        engineImportTXD ( txd, 17551)
        dff = engineLoadDFF ( "sd.dff" )
        engineReplaceModel ( dff, 17551 )
end, 500, 1)
end)