addEventHandler("onClientPlayerDamage", getRootElement(),
	function(attacker, weapon, bodypart)
		local health = getElementHealth(source)
		
		if health <= 20 then
			local posX, posY, posZ = getElementPosition(source)
			fxAddBlood(posX, posY, posZ, 0, 0, 0, 1000, 1.0)
		end
		
		-- Reális vérzés
		if attacker and weapon ~= 17 then
			if bodypart == 3 then -- test
				local posX, posY, posZ = getPedBonePosition(source, 3)
				fxAddBlood(posX, posY, posZ, 0, 0, 0, 500, 1.0)
			elseif bodypart == 4 then -- segg
				local posX, posY, posZ = getPedBonePosition(source, 1)
				fxAddBlood(posX, posY, posZ, 0, 0, 0, 500, 1.0)
			elseif bodypart == 5 then -- bal kez
				local posX, posY, posZ = getPedBonePosition(source, 32)
				fxAddBlood(posX, posY, posZ, 0, 0, 0, 500, 1.0)
			elseif bodypart == 6 then -- jobb kez
				local posX, posY, posZ = getPedBonePosition(source, 22)
				fxAddBlood(posX, posY, posZ, 0, 0, 0, 500, 1.0)
			elseif bodypart == 7 then -- bal lab
				local posX, posY, posZ = getPedBonePosition(source, 42)
				fxAddBlood(posX, posY, posZ, 0, 0, 0, 500, 1.0)
			elseif bodypart == 8 then -- jobb lab
				local posX, posY, posZ = getPedBonePosition(source, 52)
				fxAddBlood(posX, posY, posZ, 0, 0, 0, 500, 1.0)
			elseif bodypart == 9 then -- fej
				local posX, posY, posZ = getPedBonePosition(source, 6)
				fxAddBlood(posX, posY, posZ, 0, 0, 0, 500, 1.0)
			end
		end
	end
)