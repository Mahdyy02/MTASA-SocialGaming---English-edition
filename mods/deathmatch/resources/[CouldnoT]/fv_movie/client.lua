local txd = engineLoadTXD("screen.txd");
engineImportTXD(txd,8889);
local dff = engineLoadDFF("screen.dff");
engineReplaceModel(dff,8889);
local col = engineLoadCOL("screen.col");
engineReplaceCOL(col,8889);

local sx,sy = guiGetScreenSize();
local browser = createBrowser(1920,1080,false,false);
local x,y,z = 1920.1146240234, -2245.4033203125, 22;
local obj = createObject(8889,x,y,z);
local screenShader = dxCreateShader("screen.fx");
addEventHandler("onClientBrowserCreated",browser,function()
	engineApplyShaderToWorldTexture(screenShader,"screen",obj);
	loadBrowserURL(browser,"");
end);

addEventHandler("onClientRender",root,function()
	local playerX, playerY, playerZ = getElementPosition(localPlayer);
	local objX, objY, objZ = getElementPosition(obj);
	local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, objX, objY, objZ);
	local volume = distance/100;
	if distance > 150 then 
		volume = volume * 2;
	end
	if volume > 1 then 
		volume = 1;
	end
	setBrowserVolume(browser,1 - volume);
end);

addEvent("movie.syncClients",true);
addEventHandler("movie.syncClients",localPlayer,function(link,timeLeft,allLength)
	local startTime = (allLength-timeLeft);
	startTime = "&start="..startTime;
	loadBrowserURL(browser,"https://www.youtube.com/embed/"..link.."?controls=0&autoplay=1"..startTime);
	dxSetShaderValue(screenShader,"gTexture",browser);
end);

removeWorldModel(3625,99999,0,0,0);
removeWorldModel(3664,99999,0,0,0);
removeWorldModel(1290,99999,0,0,0);