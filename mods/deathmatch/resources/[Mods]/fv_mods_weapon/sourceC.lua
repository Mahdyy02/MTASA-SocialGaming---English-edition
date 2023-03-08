addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()

	
	txd = engineLoadTXD ( "weapon/desert_eagle.txd" ) 
	engineImportTXD ( txd, 348) 
	dff = engineLoadDFF ( "weapon/desert_eagle.dff", 348) 
	engineReplaceModel ( dff, 348)
	
	txd = engineLoadTXD ( "weapon/ak47.txd" ) 
	engineImportTXD ( txd, 355) 
	dff = engineLoadDFF ( "weapon/ak47.dff", 355) 
	engineReplaceModel ( dff, 355)
	
	txd = engineLoadTXD ( "weapon/m4.txd" ) 
	engineImportTXD ( txd, 356) 
	dff = engineLoadDFF ( "weapon/m4.dff", 356) 
	engineReplaceModel ( dff, 356)
	
	txd = engineLoadTXD ( "weapon/colt45.txd" ) 
	engineImportTXD ( txd, 346) 
	dff = engineLoadDFF ( "weapon/colt45.dff", 346) 
	engineReplaceModel ( dff, 346)
	
	txd = engineLoadTXD ( "weapon/mp5lng.txd" ) 
	engineImportTXD ( txd, 353) 
	dff = engineLoadDFF ( "weapon/mp5lng.dff", 353) 
	engineReplaceModel ( dff, 353)

	txd = engineLoadTXD ( "weapon/tec9.txd" ) 
	engineImportTXD ( txd, 372) 
	dff = engineLoadDFF ( "weapon/tec9.dff", 372) 
	engineReplaceModel ( dff, 372)
	
	txd = engineLoadTXD ( "weapon/chromegun.txd" ) 
	engineImportTXD ( txd, 349) 
	dff = engineLoadDFF ( "weapon/chromegun.dff", 349) 
	engineReplaceModel ( dff, 349)
	
	txd = engineLoadTXD ( "weapon/bat.txd" ) 
	engineImportTXD ( txd, 336) 
	dff = engineLoadDFF ( "weapon/bat.dff", 336) 
	engineReplaceModel ( dff, 336)
	
	txd = engineLoadTXD ( "weapon/nitestick.txd" ) 
	engineImportTXD ( txd, 334) 
	dff = engineLoadDFF ( "weapon/nitestick.dff", 334) 
	engineReplaceModel ( dff, 334)
	
	txd = engineLoadTXD ( "weapon/knifecur.txd" ) 
	engineImportTXD ( txd, 335) 
	dff = engineLoadDFF ( "weapon/knifecur.dff", 335) 
	engineReplaceModel ( dff, 335)

	txd = engineLoadTXD ( "weapon/battleaxe.txd" ) 
	engineImportTXD ( txd, 321) 
	dff = engineLoadDFF ( "weapon/battleaxe.dff", 321) 
	engineReplaceModel ( dff, 321)

	txd = engineLoadTXD ( "weapon/nitestick.txd" ) 
	engineImportTXD ( txd, 334) 
	dff = engineLoadDFF ( "weapon/nitestick.dff", 334) 
	engineReplaceModel ( dff, 334)	

	txd = engineLoadTXD ( "weapon/gun_cane.txd" ) 
	engineImportTXD ( txd, 338) 
	dff = engineLoadDFF ( "weapon/gun_cane.dff", 338) 
	engineReplaceModel ( dff, 338)	

end)