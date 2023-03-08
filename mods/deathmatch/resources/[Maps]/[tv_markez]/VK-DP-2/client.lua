txd = engineLoadTXD ( "chaoverde.txd" )
engineImportTXD ( txd, 1905 )
col = engineLoadCOL ( "chaoverde.col" )
engineReplaceCOL ( col, 1905 )
dff = engineLoadDFF ( "chaoverde.dff", 0 )
engineReplaceModel ( dff, 1905 )
engineSetModelLODDistance(1905, 170)

-- Onde estiver ID, coloque o ID do objeto que você quer substituir.
-- Onde estiver NOME, você coloca o nome dos arquivos na pasta "Skins".
-- No engineSetModelLODDistance você coloca a ID do objeto, logo em seguida a distância que você quer que ele renderize, o máximo permitido pelo MTA é 170.