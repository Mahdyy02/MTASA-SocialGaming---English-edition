local sx,sy = guiGetScreenSize()
local qte = {}
qte.balance = {}
qte.balance.state = false
qte.balance.difficulty = 1
qte.balance.rot = 0
qte.balance.keyType = nil
qte.balance.dir = nil
qte.balance.a = 0
qte.balance.accMult = 1
qte.balance.progressGui={}
qte.balance.progressTime = 0
qte.balance.beginTick = 0
qte.balance.tick = 0
qte.balance.timer = nil

local imgData = {}
imgData.w = 512
imgData.h = 512
imgData.x = sx/2-imgData.w/2
imgData.y = sy/2-imgData.h/2

function setBalanceQTEState(state,difficulty)
	if state and difficulty then
		qte.balance.beginTick = getTickCount()
		setElementFrozen(localPlayer,true)
		qte.balance.progressTime = 6
		qte.balance.state = true
		qte.balance.difficulty = difficulty
		qte.balance.a = 0
		qte.balance.accMult = 1
		qte.balance.dir = nil
		qte.balance.keyType = nil
		local rand = math.random(0,1)
		local startAcc = (qte.balance.difficulty==1 and 0.1 or 0.2)
		qte.balance.rot = (rand==0 and -10 or 10)
		qte.balance.a = (rand==0 and -startAcc or startAcc)
		toggleControl("left",false)
		toggleControl("right",false)
		bindKey("a","both",balanceQTEMoveHandler)
		bindKey("arrow_l","both",balanceQTEMoveHandler)
		bindKey("d","both",balanceQTEMoveHandler)
		bindKey("arrow_r","both",balanceQTEMoveHandler)
		createProgressBar(qte.balance.progressTime);
	else
		toggleControl("left",true)
		toggleControl("right",true)
		unbindKey("a","both",balanceQTEMoveHandler)
		unbindKey("arrow_l","both",balanceQTEMoveHandler)
		unbindKey("d","both",balanceQTEMoveHandler)
		unbindKey("arrow_r","both",balanceQTEMoveHandler)
		qte.balance.state = false
		setElementFrozen(localPlayer,false)
		if isElement(kapasSound) then 
			destroyElement(kapasSound);
		end
	end
end

function balanceQTEMoveHandler(key,state)
	if state=="down" then
		if not qte.balance.dir then
			if key=="a" or key=="arrow_l" then
				qte.balance.keyType = key
				qte.balance.dir = -0.3*(qte.balance.accMult)
			elseif key=="d" or key=="arrow_r" then
				qte.balance.keyType = key
				qte.balance.dir = 0.3*(qte.balance.accMult)
			end
			qte.balance.accMult = qte.balance.accMult + 0.1
		end
	elseif state=="up" then
		if qte.balance.dir and qte.balance.keyType==key then
			qte.balance.dir = nil
			qte.balance.keyType = nil
		end
	end
end

function balanceQTEFail()
	setBalanceQTEState(false)
	if qte.balance.timer then
		if isTimer(qte.balance.timer) then
			killTimer(qte.balance.timer)
		end
		qte.balance.timer = nil
	end	
	outputChatBox(e:getServerSyntax("Fishing","red").."I'm sorry the fish swam away.",255,255,255,true);
	triggerServerEvent("fishing.fail",localPlayer,localPlayer);
end

addEventHandler("onClientRender",getRootElement(),function()
	if qte.balance.state then
		dxDrawImage(imgData.x,imgData.y,imgData.w,imgData.h,"files/arch.png")
		dxDrawImage(imgData.x,imgData.y+20,imgData.w,imgData.h,"files/pointer.png",qte.balance.rot)
		if getTickCount()-qte.balance.beginTick>1000 then
			if math.abs(qte.balance.rot) < 45 then
				if qte.balance.dir then
					qte.balance.a = qte.balance.a + qte.balance.dir*(qte.balance.difficulty==1 and 0.6 or 1)
				end
				qte.balance.a = qte.balance.a + qte.balance.rot/(800-200*qte.balance.accMult)
				qte.balance.rot = qte.balance.rot + qte.balance.a
				
				if qte.balance.rot==0 then
					local rand = math.random(0,1)
					qte.balance.rot = (rand==0 and -1 or 1)
				end
			else
				balanceQTEFail()
			end
		end
		--Loading Bar
		local progress = (getTickCount()-qte.balance.tick)/qte.balance.progressTime
		local loader = interpolateBetween(0,0,0,300,0,0,progress,"Linear")

		local barX, barY = sx/2,imgData.y+130;
		dxDrawRectangle(barX-155,barY+15,310,40,tocolor(0,0,0,180));
		dxDrawRectangle(barX-150,barY+20,loader,30,tocolor(sColor[1],sColor[2],sColor[3],180));
		if loader/3 > 5 then 
			e:shadowedText(math.floor(loader/3).."%",barX-150,barY+20,barX-150+loader,barY+20+30,tocolor(255,255,255),1,e:getFont("rage",13),"right","center");
		end
		e:shadowedText("Use",barX-155,barY-20,barX-155+310,0,tocolor(255,255,255),1,e:getFont("rage",12),"center");
	end
end)

function createProgressBar(progressTime)
	qte.balance.progressTime = progressTime*1000

	qte.balance.tick = getTickCount()
	qte.balance.timer = setTimer(function()
		setBalanceQTEState(false)
		triggerServerEvent("fishing.success",localPlayer,localPlayer);
	end,progressTime*1000,1)
end



-- setBalanceQTEState(true,10);
