_setPedAnimation = setPedAnimation;
local setPedAnimation = function(p, a, b, c, d, e, f, g)
	if not getElementData(p,"cuffed") then 
		return _setPedAnimation(p, a, b, c, d, e, f, g);
	end
end


function bindAnimationStopKey()
	bindKey(source, "space", "down", stopAnimation)
end
addEvent("bindAnimationStopKey", false)
addEventHandler("bindAnimationStopKey", getRootElement(), bindAnimationStopKey)

function unbindAnimationStopKey()
	unbindKey(source, "space", "down", stopAnimation)
end
addEvent("unbindAnimationStopKey", false)
addEventHandler("unbindAnimationStopKey", getRootElement(), unbindAnimationStopKey)

function stopAnimation(thePlayer)
	if getElementData(thePlayer,"collapsed") then return end;
	if getElementData(thePlayer,"cuffed") then return end;
	if getElementData(thePlayer,"char >> taser") then return end;
	if isPedDead(thePlayer) then return end;
	if not getElementData(thePlayer, "loggedIn") then return end;
	if type(getElementData(thePlayer,"setPlayerAnimation")) == "table" then return end;
	local forcedanimation = getElementData(thePlayer, "animJob")
	
	if not (forcedanimation) then
		setPedAnimation(thePlayer)
		setElementData(thePlayer,"handsup",false);
		triggerEvent("unbindAnimationStopKey", thePlayer)
	end
end
addEvent("AnimationStop", true)
addEventHandler("AnimationStop", getRootElement(), stopAnimation)

function animationList(thePlayer)
	outputChatBox("/piss /wank /slapass /fixcar /handsup /hailtaxi /scratch /fu /carchat /tired", thePlayer, 202, 35, 35)
	outputChatBox("/strip 1-2 /lightup /drink /beg /mourn /cheer 1-3 /dance 1-3 /crack 1-2 ", thePlayer, 202, 35, 35)
	outputChatBox("/gsign 1-5 /puke /rap 1-3 /sit 1-3 /smoke 1-3 /smokelean /laugh /startrace /bat 1-3", thePlayer, 202, 35, 35)
	outputChatBox("/daps 1-2 /shove /bitchslap /shocked /dive /what /fall /fallfront /cpr /copaway", thePlayer, 202, 35, 35)
	outputChatBox("/copcome /copleft /copstop /wait /think /shake /idle /lay /cry /aim /drag /win 1-2", thePlayer, 202, 35, 35)
	outputChatBox("/stopchat /baseball /buydrog ", thePlayer, 202, 35, 35)
	outputChatBox("/stopanim or space to stop the animation!", thePlayer, 255, 255, 255)
end
addCommandHandler("animlist", animationList, false, false)
addCommandHandler("animhelp", animationList, false, false)
addCommandHandler("anims", animationList, false, false)
addCommandHandler("animations", animationList, false, false)

function resetAnimation(thePlayer)
	setPedAnimation(thePlayer)
end

-- /cover animtion -------------------------------------------------
function coverAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")

	if (logged) then
		setPedAnimation(thePlayer, "ped", "duck_cower", -1, false, false, false)
	end
end
addCommandHandler("cover", coverAnimation, false, false)

-- /cpr animtion -------------------------------------------------
function cprAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "medic", "cpr", 8000, false, true, false)
	end
end
addCommandHandler("cpr", cprAnimation, false, false)

-- /stopchat animtion -------------------------------------------------
function stopChatAnim(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "ped", "endchat_02", 8000, false, true, false)
	end
end
addCommandHandler("stopchat", stopChatAnim, false, false)

-- /baseball animtion -------------------------------------------------
function baseballLean(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "CRACK", "Bbalbat_Idle_02", 8000, false, true, false)
	end
end
addCommandHandler("baseball", baseballLean, false, false)

-- /buydrog animtion -------------------------------------------------
function buyDrog(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "DEALER", "DRUGS_BUY", 8000, false, true, false)
	end
end
addCommandHandler("buydrog", buyDrog, false, false)

-- cop away Animation -------------------------------------------------------------------------
function copawayAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "police", "coptraf_away", 1300, true, false, false)
	end
end
addCommandHandler("copaway", copawayAnimation, false, false)

-- Cop come animation
function copcomeAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "POLICE", "CopTraf_Come", -1, true, false, false)
	end
end
addCommandHandler("copcome", copcomeAnimation, false, false)

-- Cop Left Animation -------------------------------------------------------------------------
function copleftAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "POLICE", "CopTraf_Left", -1, true, false, false)
	end
end
addCommandHandler("copleft", copleftAnimation, false, false)

-- Cop Stop Animation -------------------------------------------------------------------------
function copstopAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "POLICE", "CopTraf_Stop", -1, true, false, false)
	end
end
addCommandHandler("copstop", copstopAnimation, false, false)

-- Wait Animation -------------------------------------------------------------------------
function pedWait(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "COP_AMBIENT", "Coplook_loop", -1, true, false, false)
	end
end
addCommandHandler ( "wait", pedWait, false, false )

-- Think Animation (/wait modifier) ---------------------------------------------------------------
function pedThink(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "COP_AMBIENT", "Coplook_think", -1, true, false, false)
	end
end
addCommandHandler ( "think", pedThink, false, false )

-- Shake Animation(/wait modifier) ---------------------------------------------------------------
function pedShake(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "COP_AMBIENT", "Coplook_shake", -1, true, false, false)
	end
end
addCommandHandler ( "shake", pedShake, false, false )

-- Lean Animation -------------------------------------------------------------------------
function pedLean(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "GANGS", "leanIDLE", -1, true, false, false)
	end
end
addCommandHandler ( "lean", pedLean, false, false )

-- /idle animtion -------------------------------------------------
function idleAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "DEALER", "DEALER_IDLE_01", -1, true, false, false)
	end
end
addCommandHandler("idle", idleAnimation, false, false)

-- Piss Animation -------------------------------------------------------------------------
function pedPiss(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "PAULNMAC", "Piss_loop", -1, true, false, false)
	end
end
addCommandHandler ( "piss", pedPiss, false, false )

-- Wank Animation -------------------------------------------------------------------------
function pedWank(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "PAULNMAC", "wank_loop", -1, true, false, false)
	end
end
addCommandHandler ( "wank", pedWank, false, false )

-- Slap Ass Animation -------------------------------------------------------------------------
function pedSlapAss(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "SWEET", "sweet_ass_slap", 2000, true, false, false)
	end
end
addCommandHandler ( "slapass", pedSlapAss, false, false )

-- fix car Animation -------------------------------------------------------------------------
function pedCarFix(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "CAR", "Fixn_Car_loop", -1, true, false, false)
	end
end
addCommandHandler ( "fixcar", pedCarFix, false, false )

-- Hands Up Animation -------------------------------------------------------------------------
function pedHandsup(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "ped", "handsup", -1, false, false, false)
		setElementData(thePlayer,"handsup",true);
	end
end
addCommandHandler ( "handsup", pedHandsup, false, false )

-- Hail Taxi -----------------------------------------------------------------------------------
function pedTaxiHail(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "MISC", "Hiker_Pose", -1, false, true, false)
	end
end
addCommandHandler ("hailtaxi", pedTaxiHail, false, false )

-- Scratch Balls Animation -------------------------------------------------------------------------
function pedScratch(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "MISC", "Scratchballs_01", -1, true, true, false)
	end
end
addCommandHandler ( "scratch", pedScratch, false, false )

-- F*** You Animation -------------------------------------------------------------------------
function pedFU(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "RIOT", "RIOT_FUKU", 800, false, true, false)
	end
end
addCommandHandler ( "fu", pedFU, false, false )

-- Strip Animation -------------------------------------------------------------------------
function pedStrip( thePlayer, cmd, arg )
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if arg == 2 then
			setPedAnimation( thePlayer, "STRIP", "STR_Loop_C", -1, false, true, false)
		else
			setPedAnimation( thePlayer, "STRIP", "strip_D", -1, false, true, false)
		end
	end
end
addCommandHandler ( "strip", pedStrip, false, false )

-- Light up Animation -------------------------------------------------------------------------
function pedLightup (thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "SMOKING", "M_smk_in", 4000, true, true, false)
	end
end
addCommandHandler ( "lightup", pedLightup, false, false )

-- Light up Animation -------------------------------------------------------------------------
function pedHeil (thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "ON_LOOKERS", "Pointup_in", 999999, false, true, false)
	end
end
addCommandHandler ( "heil", pedHeil, false, false )

-- Drink Animation -------------------------------------------------------------------------
function pedDrink( thePlayer )
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "BAR", "dnk_stndM_loop", 2300, false, false, false)
	end
end
addCommandHandler ( "drink", pedDrink, false, false )

-- Lay Animation -------------------------------------------------------------------------
function pedLay( thePlayer, cmd, arg )
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if arg == 2 then
			setPedAnimation( thePlayer, "BEACH", "sitnwait_Loop_W", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "BEACH", "Lay_Bac_Loop", -1, true, false, false)
		end
	end
end
addCommandHandler ( "lay", pedLay, false, false )

-- beg Animation -------------------------------------------------------------------------
function begAnimation( thePlayer )
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "SHOP", "SHP_Rob_React", 4000, true, false, false)
	end
end
addCommandHandler ( "beg", begAnimation, false, false )

-- Mourn Animation -------------------------------------------------------------------------
function pedMourn( thePlayer )
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "GRAVEYARD", "mrnM_loop", -1, true, false, false)
	end
end
addCommandHandler ( "mourn", pedMourn, false, false )

-- Cry Animation -------------------------------------------------------------------------
function pedCry( thePlayer )
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "GRAVEYARD", "mrnF_loop", -1, true, false, false)
	end
end
addCommandHandler ( "cry", pedCry, false, false )

-- Cheer Amination -------------------------------------------------------------------------
function pedCheer(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if arg == 2 then
			setPedAnimation( thePlayer, "OTB", "wtchrace_win", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation( thePlayer, "RIOT", "RIOT_shout", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "STRIP", "PUN_HOLLER", -1, true, false, false)
		end
	end
end
addCommandHandler ( "cheer", pedCheer, false, false )

-- Dance Animation -------------------------------------------------------------------------
function danceAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if arg == 2 then
			setPedAnimation( thePlayer, "DANCING", "DAN_Down_A", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation( thePlayer, "DANCING", "dnce_M_d", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "DANCING", "DAN_Right_A", -1, true, false, false)
		end
	end
end
addCommandHandler ( "dance", danceAnimation, false, false )

-- Crack Animation -------------------------------------------------------------------------
function crackAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if arg == 2 then
			setPedAnimation( thePlayer, "CRACK", "crckidle1", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation( thePlayer, "CRACK", "crckidle3", -1, true, false, false)
		elseif arg == 4 then
			setPedAnimation( thePlayer, "CRACK", "crckidle4", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "CRACK", "crckidle2", -1, true, false, false)
		end
	end
end
addCommandHandler ( "crack", crackAnimation, false, false )

-- /gsign animtion -------------------------------------------------
function gsignAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if arg == 2 then
			setPedAnimation(thePlayer, "GHANDS", "gsign2", 4000, true, false, false)
		elseif arg == 3 then
			setPedAnimation(thePlayer, "GHANDS", "gsign3", 4000, true, false, false)
		elseif arg == 4 then
			setPedAnimation(thePlayer, "GHANDS", "gsign4", 4000, true, false, false)
		elseif arg == 5 then
			setPedAnimation(thePlayer, "GHANDS", "gsign5", 4000, true, false, false)
		else
			setPedAnimation(thePlayer, "GHANDS", "gsign1", 4000, true, false, false)
		end
	end
end
addCommandHandler("gsign", gsignAnimation, false, false)

-- /puke animtion -------------------------------------------------
function pukeAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "FOOD", "EAT_Vomit_P", 8000, true, false, false)
	end
end
addCommandHandler("puke", pukeAnimation, false, false)

-- /rap animtion -------------------------------------------------
function rapAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if arg == 2 then
			setPedAnimation( thePlayer, "LOWRIDER", "RAP_B_Loop", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation( thePlayer, "LOWRIDER", "RAP_C_Loop", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "LOWRIDER", "RAP_A_Loop", -1, true, false, false)
		end
	end
end
addCommandHandler("rap", rapAnimation, false, false)

-- /aim animtion -------------------------------------------------
function aimAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "SHOP", "ROB_Loop_Threat", -1, false, true, false)
	end
end
addCommandHandler("aim", aimAnimation, false, false)

-- /sit animtion -------------------------------------------------
function sitAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if isPedInVehicle( thePlayer ) then
			if arg == 2 then
				setPedAnimation( thePlayer, "CAR", "Sit_relaxed" )
			else
				setPedAnimation( thePlayer, "CAR", "Tap_hand" )
			end
			source = thePlayer
			bindAnimationStopKey()
		else
			if arg == 2 then
				setPedAnimation( thePlayer, "FOOD", "FF_Sit_Look", -1, true, false, false)
			elseif arg == 3 then
				setPedAnimation( thePlayer, "Attractors", "Stepsit_loop", -1, true, false, false)
			elseif arg == 4 then
				setPedAnimation( thePlayer, "BEACH", "ParkSit_W_loop", 1, true, false, false)
			elseif arg == 5 then
				setPedAnimation( thePlayer, "BEACH", "ParkSit_M_loop", 1, true, false, false)
			else
				setPedAnimation( thePlayer, "ped", "SEAT_idle", -1, true, false, false)
			end
		end
	end
end
addCommandHandler("sit", sitAnimation, false, false)

-- /smoke animtion -------------------------------------------------
function smokeAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if arg == 2 then
			setPedAnimation( thePlayer, "SMOKING", "M_smkstnd_loop", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation( thePlayer, "LOWRIDER", "M_smkstnd_loop", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "GANGS", "smkcig_prtl", -1, true, false, false)
		end
	end
end
addCommandHandler("smoke", smokeAnimation, false, false)

-- /smokelean animtion -------------------------------------------------
function smokeleanAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "LOWRIDER", "M_smklean_loop", -1, true, false, false)
	end
end
addCommandHandler("smokelean", smokeleanAnimation, false, false)

-- /drag animtion -------------------------------------------------
function smokedragAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "SMOKING", "M_smk_drag", 4000, true, false, false)
	end
end
addCommandHandler("drag", smokedragAnimation, false, false)

-- /laugh animtion -------------------------------------------------
function laughAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "RAPPING", "Laugh_01", -1, true, false, false)
	end
end
addCommandHandler("laugh", laughAnimation, false, false)

-- /startrace animtion -------------------------------------------------
function startraceAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "CAR", "flag_drop", 4200, true, false, false)
	end
end
addCommandHandler("startrace", startraceAnimation, false, false)

-- /carchat animtion -------------------------------------------------
function carchatAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "CAR_CHAT", "car_talkm_loop", -1, true, false, false)
	end
end
addCommandHandler("carchat", carchatAnimation, false, false)

-- /tired animtion -------------------------------------------------
function tiredAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "FAT", "idle_tired", -1, true, false, false)
	end
end
addCommandHandler("tired", tiredAnimation, false, false)

-- /daps animtion -------------------------------------------------
function handshakeAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if arg == 2 then
			setPedAnimation( thePlayer, "GANGS", "hndshkca", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "GANGS", "hndshkfa", -1, true, false, false)
		end
	end
end
addCommandHandler("daps", handshakeAnimation, false, false)

-- /shove animtion -------------------------------------------------
function shoveAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "GANGS", "shake_carSH", -1, true, false, false)
	end
end
addCommandHandler("shove", shoveAnimation, false, false)

-- /bitchslap animtion -------------------------------------------------
function bitchslapAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "MISC", "bitchslap", -1, true, false, false)
	end
end
addCommandHandler("bitchslap", bitchslapAnimation, false, false)

-- /shocked animtion -------------------------------------------------
function shockedAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation(thePlayer, "ON_LOOKERS", "panic_loop", -1, true, false, false)
	end
end
addCommandHandler("shocked", shockedAnimation, false, false)

-- /dive animtion -------------------------------------------------
function diveAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) and not isPedInVehicle(thePlayer) then
		setPedAnimation(thePlayer, "ped", "EV_dive", -1, false, true, false)
	end
end
addCommandHandler("dive", diveAnimation, false, false)

-- /what Amination -------------------------------------------------------------------------
function whatAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) then
		setPedAnimation( thePlayer, "RIOT", "RIOT_ANGRY", -1, true, false, false)
	end
end
addCommandHandler ( "what", whatAnimation, false, false )

-- /fallfront Amination -------------------------------------------------------------------------
function fallfrontAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) and not isPedInVehicle(thePlayer) then
		if isPedInVehicle(thePlayer) then return end;
		setPedAnimation( thePlayer, "ped", "FLOOR_hit_f", -1, false, false, false)
	end
end
addCommandHandler ( "fallfront", fallfrontAnimation, false, false )

-- /fall Amination -------------------------------------------------------------------------
function fallAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedIn")
	
	if (logged) and not isPedInVehicle(thePlayer) then
		if isPedInVehicle(thePlayer) then return end;
		setPedAnimation( thePlayer, "ped", "FLOOR_hit", -1, false, false, false)
	end
end
addCommandHandler ( "fall", fallAnimation, false, false )

-- /bat animtion -------------------------------------------------
function batAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if arg == 2 then
			setPedAnimation( thePlayer, "CRACK", "Bbalbat_Idle_02", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation( thePlayer, "Baseball", "Bat_IDLE", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "CRACK", "Bbalbat_Idle_01", -1, true, false, false)
		end
	end
end
addCommandHandler("bat", batAnimation, false, false)

-- /win Amination -------------------------------------------------------------------------
function winAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")
	arg = tonumber(arg)
	
	if (logged) then
		if arg == 2 then
			setPedAnimation( thePlayer, "CASINO", "manwinb", 2000, false, false, false)
		else
			setPedAnimation( thePlayer, "CASINO", "manwind", 2000, false, false, false)
		end
	end
end
addCommandHandler ( "win", winAnimation, false, false )

-- /kickballs Amination -------------------------------------------------------------------------
function kickballsAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")
	if (logged) then
		setPedAnimation( thePlayer, "FIGHT_E", "FightKick_B", 1, false, false, false)
	end
end
addCommandHandler ( "kickballs", kickballsAnimation, false, false )

-- /grabbottle Amination -------------------------------------------------------------------------
function grabbAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedIn")

	if (logged) then
		setPedAnimation( thePlayer, "BAR", "Barserve_bottle", 2000, false, false, false)
	end
end
addCommandHandler ( "grabbottle", grabbAnimation, false, false )



--UTILS
addEventHandler("onElementDataChange",root,function(dataName,oldValue,newValue)
	if getElementType(source) == "player" then 
		if dataName == "setPlayerAnimation" then 
			if oldValue ~= newValue then 
				if type(newValue) == "table" then 
					setPedAnimation(source,newValue[1],newValue[2],-1,true,false,false,false);
					toggleAllControls(source,false,true,true);
				else 
					setPedAnimation(source,false);
					toggleAllControls(source,true);
				end
			end
		end
	end
end);