local overheatValue = {}
local overheatTick = {}
local overheatedWeapons = {}
local fireDisabled = false
local overheatIncreaseValues = {
	[22] = 7.5,
	[23] = 7.5,
	[24] = 20,
	[25] = 19,
	[26] = 25,
	[27] = 25,
	[28] = 3,
	[29] = 3,
	[30] = 4.5,
	[31] = 5.5,
	[32] = 3,
	[33] = 10,
	[34] = 10
}

local overheatDecreaseValues = {
	[22] = 0.0098039215686275,
	[23] = 0.011764705882353,
	[24] = 0.007843137254902,
	[25] = 0.0049019607843137,
	[26] = 0.0073529411764706,
	[27] = 0.007843137254902,
	[28] = 0.0088235294117647,
	[29] = 0.011764705882353,
	[30] = 0.0098039215686275,
	[31] = 0.0093137254901961,
	[32] = 0.0088235294117647,
	[33] = 0.0088235294117647,
	[34] = 0.0088235294117647
}

local weaponTextures = {};


addEventHandler("onClientResourceStart", getResourceRootElement(), function()
	for i=0, 46 do 
		if fileExists("weapons/"..i..".png") then 
			weaponTextures[i] = dxCreateTexture("weapons/"..i..".png","dxt3");
		end
	end
	toggleControl("fire",true);
	local currentWeaponDatabase = getElementData(localPlayer, "weaponusing") or false
	if currentWeaponDatabase then
		currentWeaponDatabaseID = currentWeaponDatabase
	end
end)

addEventHandler("onClientElementDataChange", localPlayer, function (dataName, oldValue)
	if getElementData(localPlayer,"skilling") then return end;
	if dataName == "weaponusing" then
		local dataValue = getElementData(localPlayer, dataName)
		
		if dataValue then
			currentWeaponDatabaseID = dataValue
			local weaponID = getPedWeapon(localPlayer);
			
			if not overheatIncreaseValues[weaponID] and fireDisabled then
				fireDisabled = false
				toggleControl("fire",true);
				toggleControl("vehicle_fire",true);
			end
		end
	end
end);

addEventHandler("onClientPreRender", getRootElement(),
	function (timeSlice)
		local weaponID = getPedWeapon(localPlayer);
		if getElementData(localPlayer,"skilling") then return end;
		-- if weaponID then
			for k, fireStartedTick in pairs(overheatTick) do
				if getTickCount() - fireStartedTick >= 250 then
					if weaponID and overheatDecreaseValues[weaponID] then
						if overheatValue[k] >= 75 then
							overheatValue[k] = overheatValue[k] - overheatDecreaseValues[weaponID] * 0.5 * timeSlice
						else
							overheatValue[k] = overheatValue[k] - overheatDecreaseValues[weaponID] * timeSlice
						end
					end

					if overheatedWeapons[k] and currentWeaponDatabaseID == k and not fireDisabled then
						fireDisabled = true
						toggleControl("fire",false);
						toggleControl("vehicle_fire",false);
					end
					
					if overheatValue[k] < 75 and currentWeaponDatabaseID == k and fireDisabled then
						fireDisabled = false
						overheatedWeapons[k] = false
						toggleControl("fire",true);
						toggleControl("vehicle_fire",true);
						exports.fv_dead:reloadBones();
					end
					
					if overheatValue[k] < 0 then
						overheatValue[k] = 0
						overheatTick[k] = nil
					end
				end
			end
		-- end
	end
)

addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(),
	function(weaponID)
		if getElementData(localPlayer,"skilling") then return end;
		if overheatIncreaseValues[weaponID] then
			if not overheatValue[currentWeaponDatabaseID] then
				overheatValue[currentWeaponDatabaseID] = 0
			end
			
			overheatValue[currentWeaponDatabaseID] = overheatValue[currentWeaponDatabaseID] + overheatIncreaseValues[weaponID] * 0.50
			
			if overheatValue[currentWeaponDatabaseID] >= 100 then
				overheatValue[currentWeaponDatabaseID] = 100
				
				if not fireDisabled then
					triggerServerEvent("hud.weaponOverheat", localPlayer, localPlayer, getElementsByType("player", getRootElement(), true), currentWeaponDatabaseID)
				
					fireDisabled = true
					toggleControl("fire",false);
					toggleControl("vehicle_fire",false);
					overheatedWeapons[currentWeaponDatabaseID] = true
					exports.fv_infobox:addNotification("warning","Your gun has overheated!");
				end
			end
			
			overheatTick[currentWeaponDatabaseID] = getTickCount()
		end
	end
)

addEvent("hud.weaponOverheatSound", true)
addEventHandler("hud.weaponOverheatSound", getRootElement(), function ()
	attachElements(playSound3D("files/overheat.mp3", getElementPosition(source)), source);
end);

addEventHandler("onClientRender",root,function()
	if not getElementData(localPlayer,"loggedIn") then return end;
	if not getElementData(localPlayer,"weapon.showing") then return end;
	if not getElementData(localPlayer,"togHUD") then return end;

	local x,y = getElementData(localPlayer,"weapon.x"),getElementData(localPlayer,"weapon.y");
	local playerWeapon = getPedWeapon(localPlayer);
	dxDrawImage(x,y,256,128,weaponTextures[playerWeapon]);

	if overheatIncreaseValues[playerWeapon] or playerWeapon == 41 then
		local value = overheatValue[currentWeaponDatabaseID] or 0;
		dxDrawRectangle(x+32,y+102,206,21,tocolor(0,0,0,180));
		local r,g,b = exports.fv_engine:getServerColor("servercolor",false);
		if value >= 40 and value < 75 then 
			r,g,b = exports.fv_engine:getServerColor("orange",false);
		elseif value >= 75 then 
			r,g,b = exports.fv_engine:getServerColor("red",false);
		end
		dxDrawRectangle(x+35,y+105,value*2,15,tocolor(r,g,b,180));

		local ammo, totalAmmo = getPedAmmoInClip(localPlayer),getPedTotalAmmo(localPlayer);
		dxDrawText(ammo.."|"..totalAmmo,x+32,y+102,x+32 + 200,y+102 + 21,tocolor(255,255,255),1,exports.fv_engine:getFont("rage",10),"right","center");
	end
end);

