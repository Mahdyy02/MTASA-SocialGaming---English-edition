txd = engineLoadTXD ( "hospital.txd" )
engineImportTXD ( txd, 5708 )
col = engineLoadCOL ( "hospital.col" )
engineReplaceCOL ( col, 5708 )
dff = engineLoadDFF ( "hospital.dff", 0 )
engineReplaceModel ( dff, 5708 )


txd = engineLoadTXD ( "quarto1.txd" )
engineImportTXD ( txd, 2349 )
col = engineLoadCOL ( "quarto1.col" )
engineReplaceCOL ( col, 2349 )
dff = engineLoadDFF ( "quarto1.dff", 0 )
engineReplaceModel ( dff, 2349 )


engineSetModelLODDistance(5708,2349,1857,4861, 900000000000000000000000000000000000000000000000000000000000000000000000000)








-- Onde estiver ID, coloque o ID do objeto que você quer substituir.
-- Onde estiver NOME, você coloca o nome dos arquivos na pasta "Skins".
-- No engineSetModelLODDistance você coloca a ID do objeto, logo em seguida a distância que você quer que ele renderize, o máximo permitido pelo MTA é 170.