local mar = false
function enableMar(power)
	if mar then
		disableMar()
	end
	local txt = " "
	setGameSpeed(0.9)
	if power==1 then
		showDrunkEffect(true,1,false,200)
		txt = "stoned."
	elseif power==2 then
		showDrunkEffect(true,2,false,500)
		txt = "stoned."
	elseif power==3 then
		showDrunkEffect(true,2,false,600)
		txt = "stoned."
	elseif power==4 then
		showDrunkEffect(true,3,false,700)
		txt = "stoned."
	end
	mar = txt
end

function disableMar()
	showDrunkEffect(false)
	setGameSpeed(1)
end

------------------------------------------------
------------------------------------------------
------------------------------------------------
------------------------------------------------

local objects = {1337,1327,1371,1299,1264,1235,1224,1221,1220,1335,1330,1371,1331,1558,2670,2677,2671,1371,2672,2673,2676,1369,1370,1371,1440}
local sounds = {"lsd1.wav","lsd2.mp3","lsd3.mp3","lsd4.mp3","lsd5.mp3"}
local playersOriginalSkins = {}
local fadeTable = {}
local fadeTime = 1000
local stayTime = 20000
local lsdTimer = nil

function enableLSD(power)
	if lsdTimer then disableLSD() end
	local hPower = 5
	if not power then
		power=1
	end
	if power==2 then
		showDrunkEffect (true,2,false,false)
		hPower = 10
	elseif power==3 then
		hPower = 20
		showDrunkEffect (true,2,true,false)
	elseif power==4 then
		hPower = 30
		showDrunkEffect (true,4,true,false)
	end
	
	lsdTimer = setTimer(function()
		if percentChance(hPower/2) then
			createProp(power)
		end		
	end,100,0)
	
	lsdTimer2 = setTimer(function()
		if percentChance(10) then
			setSkyGradient(math.random(0,255),math.random(0,255),math.random(0,255),math.random(0,255),math.random(0,255),math.random(0,255))
		end
		
		if percentChance(20) then
			changePlayersSkin()
		end
	end,1000,0)
	
	if percentChance(power*2) then
		setRainLevel(10)
	end
end

function disableLSD()
	showDrunkEffect(false)
	for i,v in pairs(fadeTable) do 
		destroyElement(i)
		fadeTable[i] = nil
	end
	if lsdTimer then 
		killTimer(lsdTimer) 
		lsdTimer = nil
	end
	if lsdTimer2 then 
		killTimer(lsdTimer2) 
		lsdTimer2 = nil
	end
	resetRainLevel()
	resetSkyGradient()
	setGameSpeed(1)
	for i,v in pairs(playersOriginalSkins) do
		setElementModel (i,v)
	end
	playersOriginalSkins = {}
end

function changePlayersSkin()
	local players = getElementsByType ("player",getRootElement(),true)
	for k,v in ipairs(players) do
		if v ~= getLocalPlayer () then
			local randomModel = math.random (15,280)
			if playersOriginalSkins[v] == nil then
				local cModel = getElementModel (v)
				playersOriginalSkins[v] = cModel
			end
			setElementModel (v,randomModel)
		end
	end
end

function createProp(power)
	local soundPower = 0
	if power==3 then
		soundPower = 3
	elseif power==4 then
		soundPower = 6
	end
	local x,y,z = getElementPosition(getLocalPlayer())
	local range = 20
	x=x+math.random(-range,range)
	y=y+math.random(-range,range)
	local id = objects[math.random(1,#objects)]
	local obj = createObject(id,x,y,z,0,0,math.random(0,360)) 
	local groundZ = getGroundPosition(x,y,z)
	local _,_,z0 = getElementBoundingBox(obj)
	setElementPosition(obj,x,y,groundZ-z0)
	setElementCollisionsEnabled(obj,false)
	setElementAlpha(obj,0)
	if percentChance(soundPower) then
		local s = math.random (1,#sounds)
		local sound = playSound3D ("sounds/" .. sounds[s],x,y,z)
	end
	fadeIn(obj)
	setTimer(function(obj)
		if isElement(obj) then
			fadeOut(obj)
			setTimer(function(obj)
				if isElement(obj) then
					fadeTable[obj] = nil
					destroyElement(obj)
				end
			end,fadeTime,1,obj)
		end
	end,stayTime,1,obj)
end

function fadeIn(obj)
	if isElement(obj) then
		fadeTable[obj] = {}
		fadeTable[obj][1] = getTickCount()
		fadeTable[obj][2] = "in"
	end
end

function fadeOut(obj)
	if isElement(obj) then
		fadeTable[obj] = {}
		fadeTable[obj][1] = getTickCount()
		fadeTable[obj][2] = "out"
	end
end

addEventHandler("onClientRender",getRootElement(),function()
	local cTick = getTickCount ()
	for i,v in pairs(fadeTable) do 
		if v[2]=="in" then
			local progress = (cTick -v[1])/fadeTime
			local alpha = interpolateBetween(0,0,0,255,0,0,progress,"Linear")
			setElementAlpha(i,alpha)
		--[[	if alpha>=255 then
				fadeTable[i] = nil
			end ]]
		elseif v[2]=="out" then
			local progress = (getTickCount()-v[1])/fadeTime
			local alpha = interpolateBetween(255,0,0,0,0,0,progress,"Linear")
			setElementAlpha(i,alpha)
		--[[	if alpha<=0 thens
				fadeTable[i] = nil
			end ]]
		end
	end
end)

function percentChance(percent)
	if math.random(0,100)<percent then
		return true
	else
		return false
	end
end

-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------

local amf = false
local heart = nil
function enableAmf(power)
	if amf then
		disableAmf()
	end
	enablePixelShad(true,power)
	local txt = " "
	heart = playSound("sounds/heart.mp3",true)
	if power==1 then
		txt = " ."
		setGameSpeed(1.05)
		setSoundVolume(heart,0.4)
	elseif power==2 then
		txt = ""
		setGameSpeed(1.075)
		setSoundVolume(heart,0.6)
	elseif power==3 then
		txt = "."
		setGameSpeed(1.1)
		setSoundVolume(heart,0.8)
	elseif power==4 then
		txt = "."
		setGameSpeed(1.12)
		setSoundVolume(heart,1)
	end
	amf = txt
end

function disableAmf()
	setGameSpeed(1)
	showDrunkEffect(false)
	enablePixelShad(false)
	if isElement(heart) then
		stopSound(heart)
		heart = nil
	end
end

local w, h = guiGetScreenSize( );
local sharpen = false;

addEventHandler("onClientPreRender",getRootElement(),function()
	if sharpen then
		dxUpdateScreenSource( screenSrc );
		dxDrawImage( 0, 0, w, h, screenShader );
	end
end)

function enablePixelShad(enable,power)
	if enable then
		screenShader = dxCreateShader( "sharpen.fx" );
		screenSrc = dxCreateScreenSource( w, h );
		if screenShader and screenSrc then
			dxSetShaderValue( screenShader, "PixelShadTexture", screenSrc );
			dxSetShaderValue( screenShader, "gPower", power );
			sharpen = true
		end
	else
		if screenShader and screenSrc then
			destroyElement( screenShader );
			destroyElement( screenSrc );
			screenShader, screenSrc = nil, nil;
			sharpen = false
		end
	end
end

addEventHandler("onClientPlayerWasted",getLocalPlayer(),function()
    disableLSD();
    disableMar();
    disableAmf();
end)