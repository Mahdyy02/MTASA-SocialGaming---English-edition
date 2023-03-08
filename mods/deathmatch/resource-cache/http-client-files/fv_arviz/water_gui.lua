localPlayer = getLocalPlayer()
allow_negative = "false"
x,y = guiGetScreenSize()
WaterWin = {}

function isNumeric(a)
    return type(tonumber(a)) == "number"
end

WaterWin = guiCreateWindow(x/2 - 127,y/2 - 70,254,140,"Water Level",false)
EditCurrLevel = guiCreateEdit(105,35,136,23,"",false,WaterWin)
guiEditSetReadOnly(EditCurrLevel,true)
EditObjLevel = guiCreateEdit(105,67,135,22,"",false,WaterWin)
LblCurrentLevel = guiCreateLabel(10,38,87,22,"Current/Obecny - Level",false,WaterWin)
LblObjectiveLevel = guiCreateLabel(10,72,85,14,"Objective/Cel - Level",false,WaterWin)
guiLabelSetColor(LblObjectiveLevel,255,0,0)
BtnCancel = guiCreateButton(171,111,69,20,"Cancel/Anuluj",false,WaterWin)
BtnOk = guiCreateButton(95,111,69,20,"Set/Ustaw",false,WaterWin)

guiSetVisible ( WaterWin, false )

function showWindow(level, neg, highlevel)
	print("ads")
	guiSetText(EditCurrLevel, level)
	allow_negative = neg
	if (highlevel ~= nil) then
		if (isNumeric(highlevel)) then
			guiSetText(EditObjLevel, highlevel)
			changeWaterLevel()
		else
			showCursor(true)
			guiSetVisible(WaterWin, true)
		end
	else
		showCursor(true)
		guiSetVisible(WaterWin, true)
	end
end
addEvent("onShowWindow", true)
addEventHandler("onShowWindow", getRootElement(), showWindow)

function onClickBtn ( button, state )
	if (button == "left" and state == "up") then
		if (source == BtnCancel) then --if he clicked Cancel
			showCursor(false)
			guiSetVisible ( WaterWin, false )
		elseif (source == BtnOk) then --if he clicked Ok
			changeWaterLevel()
		end
	end
end
addEventHandler("onClientGUIClick", BtnOk, onClickBtn, false)
addEventHandler("onClientGUIClick", BtnCancel, onClickBtn, false)

function changeWaterLevel()
	if isNumeric(guiGetText(EditObjLevel)) then
		if ((allow_negative) == "false" and (tonumber(guiGetText(EditObjLevel)) < 0)) then
			guiEditSetCaretIndex ( EditObjLevel, 0 )
		else
			triggerServerEvent( "onWaterLevel", localPlayer, localPlayer, guiGetText(EditObjLevel) )
			showCursor(false)
			guiSetVisible ( WaterWin, false )
		end
	else
		guiEditSetCaretIndex ( EditObjLevel, 0 )
	end
	return true
end
bindKey("enter", "down", changeWaterLevel)