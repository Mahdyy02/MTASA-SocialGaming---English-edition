txd = engineLoadTXD ( "porta.txd" )
engineImportTXD ( txd, 1502 )
col = engineLoadCOL ( "porta.col" )
engineReplaceCOL ( col, 1502 )
dff = engineLoadDFF ( "porta.dff", 0 )
engineReplaceModel ( dff, 1502 )
engineSetModelLODDistance(1502, 170)

-- Onde estiver ID, coloque o ID do objeto que você quer substituir.
-- Onde estiver NOME, você coloca o nome dos arquivos na pasta "Skins".
-- No engineSetModelLODDistance você coloca a ID do objeto, logo em seguida a distância que você quer que ele renderize, o máximo permitido pelo MTA é 170.