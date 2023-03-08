local sx, sy = guiGetScreenSize()
local white = "#FFFFFF"
local panelAdatok = {sx, sy, 400, 100}
local intion = false

addEventHandler("onClientResourceStart",getRootElement(),function(res)
	if tostring(getResourceName(res)) == "fv_engine" or res == getThisResource() then 
		sColor = exports.fv_engine:getServerColor("servercolor",true);
		font = exports.fv_engine:getFont("Yantramanav-Regular", 15);
        fontm = exports.fv_engine:getFont("rage", 12);
	end
end);

function renderInterior(name, ownerName, tipus, cost,owner, id, state)
	if state then
		if ( getElementInterior(localPlayer) == 0 ) then
			tableForHouse = nil
			tableForHouse = {name, ownerName, tipus, cost, state, owner, id}
			removeEventHandler("onClientRender", getRootElement(), renderInteriorPanel)
			addEventHandler("onClientRender", getRootElement(), renderInteriorPanel)
		end
	end
end
addEvent("renderInterior", true)
addEventHandler("renderInterior", getRootElement(), renderInterior)

function renderInteriorPanel()
	if type(tableForHouse) == "table" then
		if tableForHouse and #tableForHouse > 0 then
			if state == "up" then 
		        ax,ay = interpolateBetween(sx/2-50,sy+100,0,sx/2-50,sy-150,0,(getTickCount()-tick)/1000,"OutBack");
		    elseif state == "down" then 
		       ax,ay = interpolateBetween(sx/2-50,sy-150,0,sx/2-50,sy+100,0,(getTickCount()-tick)/500,"OutBack");
		        if ay == (sy+100) then 
					show = false;
					tableForHouse = nil;
					removeEventHandler("onClientRender",root,renderInteriorPanel);
					return;
				end
		    end
		    dxDrawRectangle(ax-panelAdatok[3]/2,ay, panelAdatok[3], panelAdatok[4], tocolor(0, 0, 0, 180))	-- háttér
		   -- dxDrawRectangle(ax-panelAdatok[3]/2, ay , 2, panelAdatok[4], tocolor(0, 0, 0, 255))	-- csík

		    			--panelkeret
			dxDrawRectangle(ax-panelAdatok[3]/2, ay , panelAdatok[3], 1, tocolor(135, 211, 124,255)) -- felső
			dxDrawRectangle(ax-panelAdatok[3]/2, ay  + panelAdatok[4], panelAdatok[3], 1, tocolor(135, 211, 124, 255)) -- alsó
			dxDrawRectangle(ax-panelAdatok[3]/2, ay , 1, panelAdatok[4], tocolor(135, 211, 124, 255))	-- bal
			dxDrawRectangle(ax+panelAdatok[3]/2 , ay  , 1, panelAdatok[4], tocolor(135, 211, 124, 255))	-- jobb
			------------
			local kepnev, w, h, x, y = getTypeForImage(tableForHouse[3])
		
			
			------infok
			if tableForHouse[6] > 0 then
				dxDrawText("[" .. tableForHouse[7] .. "] "..tableForHouse[1],ax-panelAdatok[3]/2 + 151, ay + 21, panelAdatok[3], panelAdatok[4], tocolor( 0, 0, 0, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név
				dxDrawText("[" .. tableForHouse[7] .. "] "..sColor..tableForHouse[1],ax-panelAdatok[3]/2 + 150, ay + 20, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név
			
				dxDrawText("Press E to enter!",ax-panelAdatok[3]/2 + 151, ay + 41, panelAdatok[3], panelAdatok[4], tocolor( 0, 0, 0, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név
				dxDrawText("Press "..sColor.."E"..white.. " to enter!",ax-panelAdatok[3]/2 + 150, ay + 40, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név
				
				dxDrawText("Owner: "..tableForHouse[2],ax-panelAdatok[3]/2 + 151, ay + 61, panelAdatok[3], panelAdatok[4], tocolor( 0, 0, 0, 255 ), 1,fontm,  "left", "top", false, false, false, true)-- név
				dxDrawText("Owner: "..sColor..tableForHouse[2],ax-panelAdatok[3]/2 + 150, ay + 60, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm,  "left", "top", false, false, false, true)-- név
			
			elseif tableForHouse[6] <= 0 and tableForHouse[3] ~= 3 then
				if ( getElementInterior(localPlayer) == 0 ) then
					dxDrawText("[" .. tableForHouse[7] .. "] "..sColor..tableForHouse[1],ax-panelAdatok[3]/2 + 150, ay + 20, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név
					dxDrawText("Property price: "..sColor..formatMoney(tonumber(tableForHouse[4]))..white.." dt",ax-panelAdatok[3]/2 + 150, ay + 40, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név
					dxDrawText("Press "..sColor.."E"..white.." letter to view the house!",ax-panelAdatok[3]/2 + 150, ay + 60, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név		
					--dxDrawText("Nyomj "..sColor.."E"..white.." betűt a megvételhez!",xPos + 100, panelAdatok[2] - 90 + 20, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név		
				else
					dxDrawText("[" .. tableForHouse[7] .. "] "..sColor..tableForHouse[1],ax-panelAdatok[3]/2 + 150, ay + 20, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név
					dxDrawText("Property price: "..sColor..formatMoney(tonumber(tableForHouse[4]))..white.." dt",ax-panelAdatok[3]/2 + 150, ay + 40, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név
					--dxDrawText("Nyomj "..sColor.."E"..white.." betűt a ház megnézéséhez!",xPos + 100, panelAdatok[2] - 90 + 20, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név		
					dxDrawText("Press "..sColor.."E"..white.." to buy!",ax-panelAdatok[3]/2 + 150, ay + 60, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név			
				end
			elseif tableForHouse[3] == 3 then
				local ja = "Municipality"
				dxDrawText("[" .. tableForHouse[7] .. "] "..sColor..tableForHouse[1],ax-panelAdatok[3]/2 + 150, ay + 20, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név
				dxDrawText("Press "..sColor.."E"..white.." to enter!",ax-panelAdatok[3]/2 + 150, ay + 40, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm, "left", "top", false, false, false, true)-- név
				dxDrawText("Owner: "..sColor..ja,ax-panelAdatok[3]/2 + 150, ay + 60, panelAdatok[3], panelAdatok[4], tocolor( 255, 255, 255, 255 ), 1,fontm,  "left", "top", false, false, false, true)-- név
			end
			-----	

			dxDrawImage(ax-panelAdatok[3]/2 + 20, ay + 20, 64, 64, kepnev,0,0,0,tocolor(135, 211, 124,255)) -- kép
			
		end
	end
end


function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function getTypeForImage(id)
	if (id == 1) then
		return "files/1.png",64, 64, 20, 0
	elseif (id == 2) then
		return "files/2.png",512, 256, -20, 68	
	elseif (id == 3) then
		return "files/3.png",512, 256, -10, 68
	elseif (id == 4) then
		return "files/4.png", 512, 256, -18, 72	
	end
end

function hasInteriorSlotCount()
	local h = 0
	for k, v in ipairs (getElementsByType("pickup")) do
		if getElementData(v, "owner") == getElementData(localPlayer, "acc >> id") then
			h = h + 1
		end
	end
	return h
end

function hasInteriorSlot()
	if hasInteriorSlotCount() + 1 <= getElementData(localPlayer,"char >> intSlot") then
		return true
	else
		return false
	end
end

function buy_house()

	if intion then
		if getElementData(localPlayer, "char >> money") >= pickupCost then	
			--setElementData(localPlayer, "char >> money", getElementData(localPlayer, "char >> money") - pickupCost)
			triggerServerEvent("ac.elementData",localPlayer,localPlayer,"char >> money",getElementData(localPlayer, "char >> money") - pickupCost);
			triggerServerEvent("updateInteriorOwner", localPlayer, pickupID, localPlayer, interiorType)
			setElementData(pickup, "owner", getElementData(localPlayer, "acc >> id"))
			triggerServerEvent("interior.giveKey",localPlayer,localPlayer,getElementData(pickup,"id"));
			outputChatBox(exports.fv_engine:getServerSyntax("Interior","servercolor").."The property is now owned by you!", 0,255,0,true)
			oldPickup = pickup
			pickup = nil
			pickupID = nil
			interiorType = nil
			pickupCost = nil
			unbindKey("e", "down", buy_house)

			return
		else
			outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."You don't have enough money!", 255,0,0,true)
			return
		end
	end
end

function keyBind()
	if pickup then
		if isElement(pickup) then

			  pickupID = tonumber(getElementData(pickup, "id")) or 0
			 local pickupType = tostring(getElementData(pickup, "typePick")) or nil
			  interiorType = tonumber(getElementData(pickup, "type")) or 0
			 local pickupLocked = tonumber(getElementData(pickup, "locked")) or 0
			  pickupOwner = tonumber(getElementData(pickup, "owner")) or 0
			  pickupCost = tonumber(getElementData(pickup, "cost")) or 0
			if pickupType and pickupType == "outside" then
				if interiorType ~= 3 and pickupOwner <= 0 then
					if hasInteriorSlot() then
						if ( getElementInterior(localPlayer) == 0 ) then

						--[[	if getElementData(localPlayer, "char >> money") >= pickupCost then	
								--setElementData(localPlayer, "char >> money", getElementData(localPlayer, "char >> money") - pickupCost)
								triggerServerEvent("ac.elementData",localPlayer,localPlayer,"char >> money",getElementData(localPlayer, "char >> money") - pickupCost);
								triggerServerEvent("updateInteriorOwner", localPlayer, pickupID, localPlayer, interiorType)
								setElementData(pickup, "owner", getElementData(localPlayer, "acc >> id"))
								triggerServerEvent("interior.giveKey",localPlayer,localPlayer,getElementData(pickup,"id"));
								outputChatBox(exports.fv_engine:getServerSyntax("Interior","servercolor").."Az ingatlan mostantól a te tulajdonodban van!", 0,255,0,true)
								oldPickup = pickup
								pickup = nil
								return
							else
								outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Nincs elég pénzed!", 255,0,0,true)
								return
							end]]
						--else
							intion = true
							local insX = tonumber(getElementData(pickup, "intx")) or 0
							local insY = tonumber(getElementData(pickup, "inty")) or 0
							local insZ = tonumber(getElementData(pickup, "intz")) or 0
							local insDim = tonumber(getElementData(pickup, "id")) or 0
							local insInt = tonumber(getElementData(pickup, "interior")) or 0
			
							setPedCanBeKnockedOffBike(localPlayer, false)
							setTimer(function()
								setPedCanBeKnockedOffBike(localPlayer, true)
							end, 3000, 1)						
							triggerServerEvent("changeInterior", localPlayer, localPlayer, insX, insY, insZ, insInt, insDim)
							unbindKey("e", "down", keyBind)	
							bindKey("e", "down", buy_house)
					
						end
					else
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."You have no more house slots!", 255,0,0,true)
						return
					end
					if isPedInVehicle(localPlayer) then
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."This is not a garage.", 255,0,0,true)
						return
					end
				elseif pickupOwner > 0 and not isPedInVehicle(localPlayer) then				
					if pickupLocked == 1 then
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Door closed.", 255,0,0,true)
						return
					end
					if isPedInVehicle(localPlayer) then
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."This is not a garage.", 255,0,0,true)
						return
					end				
					
					local insX = tonumber(getElementData(pickup, "intx")) or 0
					local insY = tonumber(getElementData(pickup, "inty")) or 0
					local insZ = tonumber(getElementData(pickup, "intz")) or 0
					local insDim = tonumber(getElementData(pickup, "id")) or 0
					local insInt = tonumber(getElementData(pickup, "interior")) or 0
	
					setPedCanBeKnockedOffBike(localPlayer, false)
					setTimer(function()
						setPedCanBeKnockedOffBike(localPlayer, true)
					end, 3000, 1)						
					triggerServerEvent("changeInterior", localPlayer, localPlayer, insX, insY, insZ, insInt, insDim)	
				elseif (interiorType == 3) and not isPedInVehicle(localPlayer) then
					if isPedInVehicle(localPlayer) then
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."This is not a garage.", 255,0,0,true)
						return
					end
					
					local insX = tonumber(getElementData(pickup, "intx")) or 0
					local insY = tonumber(getElementData(pickup, "inty")) or 0
					local insZ = tonumber(getElementData(pickup, "intz")) or 0
					local insDim = tonumber(getElementData(pickup, "id")) or 0
					local insInt = tonumber(getElementData(pickup, "interior")) or 0
	
					setPedCanBeKnockedOffBike(localPlayer, false)
					setTimer(function()
						setPedCanBeKnockedOffBike(localPlayer, true)
					end, 3000, 1)						
					triggerServerEvent("changeInterior", localPlayer, localPlayer, insX, insY, insZ, insInt, insDim)
					
				elseif (interiorType == 4) and isPedInVehicle(localPlayer) then
					if pickupLocked == 1 then
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Door closed.", 255,0,0,true)
						return
					end
					local insX = tonumber(getElementData(pickup, "intx")) or 0
					local insY = tonumber(getElementData(pickup, "inty")) or 0
					local insZ = tonumber(getElementData(pickup, "intz")) or 0
					local insDim = tonumber(getElementData(pickup, "id")) or 0
					local insInt = tonumber(getElementData(pickup, "interior")) or 0
					setPedCanBeKnockedOffBike(localPlayer, false)
					setTimer(function()
						setPedCanBeKnockedOffBike(localPlayer, true)
					end, 3000, 1)						
					triggerServerEvent("changeVehInterior", localPlayer, localPlayer, getPedOccupiedVehicle(localPlayer), insX, insY, insZ, insInt, insDim)				
				end
			elseif pickupType and pickupType == "inSide" then
				if not isPedInVehicle(localPlayer) then
					if isPedInVehicle(localPlayer) then
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."This is not a garage.", 255,0,0,true)
						return
					end
					if pickupLocked == 1 then
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Door closed.", 255,0,0,true)
						return
					end
					intion = false
					local intX = tonumber(getElementData(pickup, "x")) or 0
					local intY = tonumber(getElementData(pickup, "y")) or 0
					local intZ = tonumber(getElementData(pickup, "z")) or 0
					setPedCanBeKnockedOffBike(localPlayer, false)
					setTimer(function()
						setPedCanBeKnockedOffBike(localPlayer, true)
					end, 3000, 1)					
					triggerServerEvent("changeInterior", localPlayer, localPlayer, intX, intY, intZ, 0, 0)	
					
				elseif (interiorType == 4) and isPedInVehicle(localPlayer) then
					local intX = tonumber(getElementData(pickup, "x")) or 0
					local intY = tonumber(getElementData(pickup, "y")) or 0
					local intZ = tonumber(getElementData(pickup, "z")) or 0
					
					setPedCanBeKnockedOffBike(localPlayer, false)
					setTimer(function()
						setPedCanBeKnockedOffBike(localPlayer, true)
					end, 3000, 1)						
					triggerServerEvent("changeVehInterior", localPlayer, localPlayer, getPedOccupiedVehicle(localPlayer), intX, intY, intZ, 0, 0)				
				end	
				
			end
		end
	end
end

function lockInt()
	if isElement(pickup) then
		local pickupID = tonumber(getElementData(pickup, "id")) or 0
		local typeThis = tostring(getElementData(pickup, "typePick")) or nil
		local pickupType = tostring(getElementData(pickup, "type")) or nil
		local pickupLocked = tonumber(getElementData(pickup, "locked")) or 0
		local element = nil
		if typeThis == "inSide" then
			element = "outElement"
		else
			element = "insElement"
		end
		if pickupID then
			if getElementData(localPlayer, "admin >> level") >= 7 or exports.fv_inventory:hasItem(41, pickupID) then
				local theElement = getElementData(pickup, element)
				if theElement then
					if pickupLocked == 0 then
						setElementData(pickup, "locked", 1)
						setElementData(theElement, "locked", 1)
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","servercolor").."Door closed.", 255,255,0,true)
						return
					else
						setElementData(pickup, "locked", 0)
						setElementData(theElement, "locked", 0)
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Door open.", 0,255,0,true)
						return
					end
				else
					--outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Hiba! 'Unknown element', jelentsd egy fejlesztőnek vagy adminnak.",255,255,255,true)
				end
			else
				outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."You have no key.", 255,0,0,true)
			end
		end
	end
end


function clientPickupHit(thePlayer, matchingDimension)
	if thePlayer == localPlayer then
		 tick = getTickCount();
		 state = "up";
		 for i,v in ipairs(getElementsByType("player")) do
            setElementCollidableWith(thePlayer, v, false)
        end
		local mx,my,mz = getElementPosition(source);
		local px,py,pz = getElementPosition(thePlayer);
		if getDistanceBetweenPoints3D(mx,my,mz,px,py,pz) < 2 and getElementDimension(source) == getElementDimension(thePlayer) then
			pickup = nil
			unbindKey("e", "down", buy_house)	
			bindKey("e", "down", keyBind)
			bindKey("k", "down", lockInt)
			setElementData(thePlayer, "int:Pickup", source)
			pickup = source
		end
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, clientPickupHit)

addEventHandler("onClientMarkerLeave", resourceRoot, function(thePlayer, matchingDimension)
	if thePlayer == localPlayer then
		 tick = getTickCount();
		 state = "down";
		  for i,v in ipairs(getElementsByType("player")) do
            setElementCollidableWith(thePlayer, v, true)
        end
		if  not intion then
				pickup = nil
				unbindKey("e", "down", keyBind)	
				setElementData(thePlayer, "int:Pickup", nil)	
				unbindKey("k", "down", lockInt)	
		else	
			--unbindKey("e", "down", keyBind)	
			setElementData(thePlayer, "int:Pickup", nil)	
			unbindKey("k", "down", lockInt)	

		end
		

	end
end)

addEventHandler("onClientMarkerHit",getRootElement(),function(hitElement)
	if not getElementData(source,"id") then return end;
	if hitElement ~= localPlayer then return end;
	local mx,my,mz = getElementPosition(source);
	local px,py,pz = getElementPosition(localPlayer);
	if getDistanceBetweenPoints3D(mx,my,mz,px,py,pz) < 2 and getElementDimension(source) == getElementDimension(localPlayer) then 
		triggerServerEvent("int > hitMarker",localPlayer,localPlayer,source);
	end
end);
addEventHandler("onClientMarkerLeave",getRootElement(),function(hitElement)
	if not getElementData(source,"id") then return end;
	if hitElement ~= localPlayer then return end;
	triggerServerEvent("int > leaveMarker",localPlayer,localPlayer,source);
end);

--MARKER IMAGE--

local house = dxCreateTexture("files/1.png", "dxt5")
local biznisz = dxCreateTexture("files/2.png", "dxt5")
local onkori = dxCreateTexture("files/3.png", "dxt5")
local garage = dxCreateTexture("files/4.png", "dxt5")
local elevatorTexture = dxCreateTexture("files/elevator.png", "dxt5")
-- local anim_type = "foward"
local distance = 30
local animTime = 0

addEventHandler("onClientPreRender", root, 
	function()
		for i, v in ipairs(getElementsByType("marker",resourceRoot,true)) do
			if (getElementData(v, "id") or getElementData(v,"elevator.id")) and getElementDimension(localPlayer) == getElementDimension(v) and getElementInterior(localPlayer) == getElementInterior(v) then
				local x, y, z = getElementPosition(v)
				local x2, y2, z2 = getElementPosition(localPlayer)
				local r, g, b, a = getMarkerColor(v)
				local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
				if (distanceBetweenPoints < distance) then
					--local size = getMarkerSize(v)
					-- if anim_type == "back" then
					-- 	local progress = (getTickCount() - animTime) / 1000
					-- 	position = math.floor(interpolateBetween(0, 0, 0, 300, 0, 0, progress, "Linear"))
					-- 	if(progress > 1) then
					-- 		anim_type = "foward"
					-- 		animTime = getTickCount()
					-- 	end
					-- else
					-- 	local progress = (getTickCount() - animTime) / 1000
					-- 	position = math.floor(interpolateBetween(300, 0, 0, 0, 0, 0, progress, "Linear"))
					-- 	if(progress > 1) then
					-- 		anim_type = "back"
					-- 		animTime = getTickCount()
					-- 	end
					-- end
					local progress = (getTickCount() - animTime) / 4000;
					position = math.floor(interpolateBetween(0, 0, 0, 300, 0, 0, progress, "CosineCurve"))

					if getElementData(v,"id") then 
						if getElementData(v,"type") == 1 then
							dxDrawMaterialLine3D(x, y, z+1+(position/1000), x, y, z+0.5+(position/1000), house, 0.5, tocolor(r, g, b, 200))
						elseif getElementData(v,"type") == 2 then 
							dxDrawMaterialLine3D(x, y, z+1+(position/1000), x, y, z+0.5+(position/1000), biznisz, 0.5, tocolor(r, g, b, 200))
						elseif getElementData(v,"type") == 3 then
							dxDrawMaterialLine3D(x, y, z+1+(position/1000), x, y, z+0.5+(position/1000), onkori, 0.5, tocolor(r, g, b, 200))
						elseif getElementData(v,"type") == 4 then
							dxDrawMaterialLine3D(x, y, z+1+(position/1000), x, y, z+0.5+(position/1000), garage, 0.5, tocolor(r, g, b, 200))
						end
					elseif getElementData(v,"elevator.id") then 
						dxDrawMaterialLine3D(x, y, z+0.2+1+(position/1000), x, y, z+0.2+0.5+(position/1000), elevatorTexture, 0.5, tocolor(r, g, b, 200))
					end
				end
			end
		end
	end
)


--INTERIOR ELADÁS--
addEventHandler("onClientResourceStart",resourceRoot,function()
	setElementData(localPlayer,"sellSource",false);
	setElementData(localPlayer,"sellValue",false);
	local timer = getElementData(localPlayer,"sellTimer");
	if isTimer(timer) then 
		killTimer(timer);
	end
	setElementData(localPlayer,"sellTimer",false);
	setElementData(localPlayer,"sellMarker",false);
end);
function sellHouse(cmd,target,value)
	if isElement(pickup) then 
		if not target or not value or not tonumber(value) then 
			outputChatBox(exports.fv_engine:getServerSyntax("Használat","red").."/"..cmd.." [Player Name/ID] [Amount]",255,255,255,true);
			return;
		end
		if isTimer(getElementData(localPlayer,"sellTimer")) then 
			outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."A sale is in progress!",255,255,255,true);
			return;
		end
		local value = math.floor(tonumber(value));
		if getElementData(pickup,"type") == 1 or getElementData(pickup,"type") == 4 then 
			if getElementData(pickup,"owner") == getElementData(localPlayer,"acc >> id") then 
				local targetPlayer = exports.fv_engine:findPlayer(localPlayer,target);
				if targetPlayer then 
					if targetPlayer == localPlayer then 
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."You can't sell it to yourself!",255,255,255,true);
						return;
					end
					local px,py,pz = getElementPosition(localPlayer);
					local ox,oy,oz = getElementPosition(targetPlayer);
					local distance = getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz);
					if distance < 10 then 
						setElementData(localPlayer,"sellTimer",
							setTimer(function()
								triggerServerEvent("sellhouse.timeLeft",localPlayer,localPlayer,targetPlayer);
							end,1000*60*2,1)
						);
						triggerServerEvent("sellHouse.sendOther",localPlayer,targetPlayer,value);
						setElementData(localPlayer,"sellMarker",pickup);
					else 
						outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Player is far from you!",255,255,255,true);
						return;
					end
				else 
					outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Player not found!",255,255,255,true);
					return;
				end
			else 
				outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."The interior is not yours!",255,255,255,true);
				return;
			end
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."Only houses and garages can be sold!",255,255,255,true);
			return;
		end
	else 
		outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."You are not a marker!",255,255,255,true);
		return;
	end
end
addCommandHandler("sellhouse",sellHouse,false,false);

addCommandHandler("accepttrade",function(cmd)
	local sSource = getElementData(localPlayer,"sellSource")
	if sSource and isElement(sSource) then 
		local value = getElementData(localPlayer,"sellValue");
		if getElementData(localPlayer,"char >> money") >= value then 
			triggerServerEvent("sellHouse.accept",localPlayer,localPlayer,sSource,value);
		else 
			outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."You don't have enough money!",255,255,255,true);
			return;
		end
	else 
		outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."No sales in progress!",255,255,255,true);
		return;
	end
end,false,false);

addCommandHandler("rejecttrade",function(cmd)
	local sSource = getElementData(localPlayer,"sellSource")
	if sSource and isElement(sSource) then 
		triggerServerEvent("sellHouse.deny",localPlayer,localPlayer,sSource,value);
	else 
		outputChatBox(exports.fv_engine:getServerSyntax("Interior","red").."No sales in progress!",255,255,255,true);
		return;
	end
end,false,false);