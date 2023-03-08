local attackTargetState = falselocal attackStartTick = 0local drunkDurationTick = 0local drunkDuration = 0local fadeTime = 3000local sx,sy = guiGetScreenSize ()local offsetX = sx*0.08local offsetY = sy*0.08local offsetSpeed = 0.7local minX,maxX,minY,maxY = sx/2-offsetX,sx/2,sy/2-offsetY,sy/2local screenSource = nillocal players = 0local fadeCount = 5local fades = {}local frameTick = 0local drunkEffectDelay = falselocal minimized = falsefunction showDrunkEffect (state,count,randomColor,delay,duration)	if state == true then		local cTick = getTickCount()		if attackTargetState == false then			attackStartTick = cTick			frameTick = attackStartTick			attackTargetState = true			screenSource = dxCreateScreenSource (sx,sy)			faceCount = count			if count == nil then				count = 5			end			fadeCount = count			for k=1,fadeCount do				fades[k] = {}				fades[k]["x"] = sx/2				fades[k]["y"] = sy/2				fades[k]["directionX"] = math.random (-offsetX*offsetSpeed,offsetX*offsetSpeed)				fades[k]["directionY"] = math.random (-offsetY*offsetSpeed,offsetY*offsetSpeed)				if randomColor then										local minValue = 160					local maxValue = 255					if k == 1 then						fades[k]["r"] = math.random(minValue,maxValue)						fades[k]["g"] = math.random(minValue,maxValue)						fades[k]["b"] = math.random(minValue,maxValue)					else						local col = math.random(1,3)						if col == 1 then							fades[k]["r"] = math.random(minValue,maxValue)							fades[k]["g"] = 0							fades[k]["b"] = 0						elseif col == 2 then							fades[k]["r"] = 0							fades[k]["g"] = math.random(minValue,maxValue)							fades[k]["b"] = 0						elseif col == 3 then							fades[k]["r"] = 0							fades[k]["g"] = 0							fades[k]["b"] = math.random(minValue,maxValue)						end					end				else					fades[k]["r"] = 255					fades[k]["g"] = 255					fades[k]["b"] = 255				end			end			minimized = false			addEventHandler ("onClientHUDRender",getRootElement(),renderFadeCamera)		else			attackStartTick = cTick-fadeTime			if count and count > fadeCount then				fadeCount = count				for k=1,fadeCount do					fades[k] = {}					fades[k]["x"] = sx/2					fades[k]["y"] = sy/2					fades[k]["directionX"] = math.random (-offsetX*offsetSpeed,offsetX*offsetSpeed)					fades[k]["directionY"] = math.random (-offsetY*offsetSpeed,offsetY*offsetSpeed)					if randomColor then						local minValue = 160						local maxValue = 255						if k == 1 then							fades[k]["r"] = math.random(minValue,maxValue)							fades[k]["g"] = math.random(minValue,maxValue)							fades[k]["b"] = math.random(minValue,maxValue)						else							local col = math.random(1,3)							if col == 1 then								fades[k]["r"] = math.random(minValue,maxValue)								fades[k]["g"] = 0								fades[k]["b"] = 0							elseif col == 2 then								fades[k]["r"] = 0								fades[k]["g"] = math.random(minValue,maxValue)								fades[k]["b"] = 0							elseif col == 3 then								fades[k]["r"] = 0								fades[k]["g"] = 0								fades[k]["b"] = math.random(minValue,maxValue)							end						end					else						fades[k]["r"] = 255						fades[k]["g"] = 255						fades[k]["b"] = 255					end				end			end		end		if delay then			if type(delay) == "number" then				if isMoveDelayEffectToggled () then					setMoveDelayTiming (delay)					drunkEffectDelay = true				else					enableMoveDelay (true,delay)					drunkEffectDelay = true				end			else				if isMoveDelayEffectToggled () == false then					enableMoveDelay (true)					drunkEffectDelay = true				end			end		end		if duration == nil or duration < 0 then			duration = 2		end		local duration = duration*60000--minuty>sekundy		if drunkDurationTick == 0 then			drunkDurationTick = cTick		end		if duration > drunkDuration then			drunkDuration = duration		end	elseif state == false then		if drunkEffectDelay then			enableMoveDelay (false)			drunkEffectDelay = false		end		removeEventHandler ("onClientHUDRender",getRootElement(),renderFadeCamera)		attackTargetState = false		attackStartTick = 0		fades = {}		fadeCount = 5		screenSource = nil	endendaddEventHandler( "onClientMinimize", root,	function ()		minimized = true	end)addEventHandler("onClientRestore",root,	function ()		minimized = false	end)function renderFadeCamera () 	local cTick = getTickCount ()	local frameDelay = cTick - frameTick	frameTick = cTick	local frameMultiplier = frameDelay/1000	--outputChatBox ("frame multi: " .. frameMultiplier)	local delay = cTick - attackStartTick	if delay <= (drunkDuration+fadeTime) then		local alpha = 255		if delay <= fadeTime then -- pokazywanie			local progress = delay / fadeTime			alpha = interpolateBetween (				0,0,0,				255,0,0,				progress,"Linear"			)		elseif delay > drunkDuration then -- hide			local delay = delay - drunkDuration			local progress = delay / fadeTime			alpha = interpolateBetween (				255,0,0,				0,0,0,				progress,"Linear"			)		end		if minimized == false then			dxUpdateScreenSource (screenSource)			for k=1,fadeCount do				local cx,cy = fades[k]["x"],fades[k]["y"]				local nx,ny = cx+(fades[k]["directionX"]*frameMultiplier),cy+(fades[k]["directionY"]*frameMultiplier)				if nx <= minX then					fades[k]["directionX"] = math.random (0,offsetX*offsetSpeed)					nx = cx+(fades[k]["directionX"]*frameMultiplier)				elseif nx >= maxX then					fades[k]["directionX"] = math.random (-offsetX*offsetSpeed,0)					nx = cx+(fades[k]["directionX"]*frameMultiplier)				end				if ny <= minY then					fades[k]["directionY"] = math.random (0,offsetY*offsetSpeed)					ny = cy+(fades[k]["directionY"]*frameMultiplier)				elseif ny >= maxY then					fades[k]["directionY"] = math.random (-offsetY*offsetSpeed,0)					ny = cy+(fades[k]["directionY"]*frameMultiplier)				end				fades[k]["x"],fades[k]["y"] = nx,ny				local renderX,renderY = nx-sx/2,ny-sy/2				if k == 1 then					dxDrawImage (renderX,renderY,sx+offsetX,sy+offsetY,screenSource,0,0,0,tocolor(fades[k]["r"],fades[k]["g"],fades[k]["b"],alpha))				else					dxDrawImage (renderX,renderY,sx+offsetX,sy+offsetY,screenSource,0,0,0,tocolor(fades[k]["r"],fades[k]["g"],fades[k]["b"],alpha*0.3))				end			end		end	else		--[[attackTargetState = false		removeEventHandler ("onClientHUDRender",getRootElement(),renderFadeCamera)		screenSource = nil]]		showDrunkEffect (false)	endendlocal moveDelayState = falselocal moveDelay = 200local controlList = {"forwards","backwards","left","right","crouch","jump","vehicle_left","vehicle_right","handbrake","accelerate","brake_reverse"}function isMoveDelayEffectToggled ()	return moveDelayStateendfunction setMoveDelayTiming (timing)	moveDelay = timingendfunction enableMoveDelay (state,timing)	if moveDelayState ~= state then		if state == true then			if timing then				moveDelay = timing			else				moveDelay = 200			end			--toggleControl ("forwards",false)			--bindKey ("forwards","both",moveDelayFunction)			for k,v in ipairs(controlList) do				toggleControl (v,false)				bindKey (v,"both",moveDelayFunction)			end			moveDelayState = true		elseif state == false then			for k,v in ipairs(controlList) do				toggleControl (v,true)				unbindKey (v,"both",moveDelayFunction)			end			moveDelayState = false		end	endendfunction moveDelayFunction ( key, keyState )	--outputChatBox ("key: " .. tostring(key) .. ", state: " .. tostring(keyState))	if keyState == "down" then		local cState = getPedControlState (key)		--outputChatBox ("cState: " .. tostring(cState))		if cState == false then			setPedControlState (key,false)		end		setTimer (setPedControlState,moveDelay,1,key,true)	elseif keyState == "up" then		setTimer (setPedControlState,moveDelay,1,key,false)	endendaddEventHandler("onDrunkDis",getLocalPlayer(),function()	showDrunkEffect (false)end)