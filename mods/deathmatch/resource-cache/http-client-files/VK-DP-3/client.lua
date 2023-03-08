﻿txd = engineLoadTXD ( "casa.txd" )
engineImportTXD ( txd, 1855 )
col = engineLoadCOL ( "casa.col" )
engineReplaceCOL ( col, 1855 )
dff = engineLoadDFF ( "casa.dff" )
engineReplaceModel ( dff, 1855 )

txd = engineLoadTXD ( "casa2.txd" )
engineImportTXD ( txd, 1860 )

txd = engineLoadTXD ( "casa1.txd" )
engineImportTXD ( txd, 1860 )
col = engineLoadCOL ( "casa1.col" )
engineReplaceCOL ( col, 1860 )
dff = engineLoadDFF ( "casa1.dff" )
engineReplaceModel ( dff, 1860 )

txd = engineLoadTXD ( "Delegacia/1.txd" )
engineImportTXD ( txd, 1861 )
col = engineLoadCOL ( "Delegacia/1.col" )
engineReplaceCOL ( col, 1861 )
dff = engineLoadDFF ( "Delegacia/1.dff" )
engineReplaceModel ( dff, 1861 )

txd = engineLoadTXD ( "Delegacia/2.txd" )
engineImportTXD ( txd, 1862 )
col = engineLoadCOL ( "Delegacia/2.col" )
engineReplaceCOL ( col, 1862 )
dff = engineLoadDFF ( "Delegacia/2.dff" )

col = engineLoadCOL ( "Delegacia/3.col" )
engineReplaceCOL ( col, 1863 )
dff = engineLoadDFF ( "Delegacia/3.dff" )
engineReplaceModel ( dff, 1863 )
txd = engineLoadTXD ( "Delegacia/3.txd" )
engineImportTXD ( txd, 1863 )

col = engineLoadCOL ( "Delegacia/4.col" )
engineReplaceCOL ( col, 1865 )
dff = engineLoadDFF ( "Delegacia/4.dff" )

engineReplaceModel ( dff, 1865 )
txd = engineLoadTXD ( "Delegacia/5.txd" )
engineImportTXD ( txd, 1507 )
col = engineLoadCOL ( "Delegacia/5.col" )
engineReplaceCOL ( col, 1507 )
dff = engineLoadDFF ( "Delegacia/5.dff" )
engineReplaceModel ( dff, 1507 )

engineSetModelLODDistance(1855, 1507, 1865, 1863, 1862, 1861, 1860,  99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999)
