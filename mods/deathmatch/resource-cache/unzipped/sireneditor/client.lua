local Guivar = 0
local gMe = getLocalPlayer()

local Fenster = {}
local TabPanel = {}
local Tab = {}
local Knopf = {}
local Checkbox = {}
local Label = {}
local Edit = {}
local Scrollbar = {}
local Memo

local setting = {}
local sirenSettings = {}
setting["anzahlsirenen"] = 1
setting["sirenentype"] = 2
setting["360flag"] = false
setting["checklosflag"] = true
setting["randomizer"] = true
setting["silent"] = false
setting["usingsiren"] = 1

sirenSettings[1] = {}

sirenSettings[1]["x"] = 0
sirenSettings[1]["y"] = 0
sirenSettings[1]["z"] = 0
sirenSettings[1]["r"] = 0
sirenSettings[1]["g"] = 0
sirenSettings[1]["b"] = 0
sirenSettings[1]["a"] = 200
sirenSettings[1]["am"] = 200

local function refreshPosition(sirenpoint, x, y, z)
	sirenSettings[sirenpoint]["x"] = x
	sirenSettings[sirenpoint]["y"] = y
	sirenSettings[sirenpoint]["z"] = z
end

local function refreshColor(sirenpoint, r, g, b, a, am)
	sirenSettings[sirenpoint]["r"] = r
	sirenSettings[sirenpoint]["g"] = g
	sirenSettings[sirenpoint]["b"] = b
	sirenSettings[sirenpoint]["a"] = a
	sirenSettings[sirenpoint]["am"] = am
end


local function preCreate()
	outputDebugString("PreCreate sireneditor-guielements")
	local sWidth, sHeight = guiGetScreenSize()
 
    local Width,Height = 475,290
    local X = (sWidth/2) - (Width/2)
    local Y = (sHeight/2) - (Height/2)
	
	Fenster[1] = guiCreateWindow(X, 0, Width, Height,"Siren Editor by Noneatme",false)
	local sx, sy = guiGetScreenSize()
	Fenster[2] = guiCreateWindow(1200/1920*sx,114/1080*sy,307,176,"Output",false)
	Memo = guiCreateMemo(9,23,291,145,"",false,Fenster[2])
	guiMemoSetReadOnly(Memo, true)
	guiSetVisible(Fenster[2], false)
	
	
	Label[1] = guiCreateLabel(14,22,109,16,"Global Settings:",false,Fenster[1])
	guiSetFont(Label[1],"default-bold-small")
	Label[2] = guiCreateLabel(11,26,135,15,"___________________",false,Fenster[1])
	guiLabelSetColor(Label[2],0, 255, 0)
	guiSetFont(Label[2],"default-bold-small")
	Label[3] = guiCreateLabel(12,49,138,15,"Number of Sirens:(1-10)",false,Fenster[1])
	guiSetFont(Label[3],"default-bold-small")
	Edit[1] = guiCreateEdit(156,45,35,24,setting["anzahlsirenen"],false,Fenster[1])
	Label[4] = guiCreateLabel(11,79,138,15,"Siren type: (1-?)",false,Fenster[1])
	guiSetFont(Label[4],"default-bold-small")
	Edit[2] = guiCreateEdit(156,75,35,24,setting["sirenentype"],false,Fenster[1])
	Label[5] = guiCreateLabel(10,99,458,16,"______________________________________________________________________________",false,Fenster[1])
	Checkbox[1] = guiCreateCheckBox(226,49,99,20,"360 Flag",false,false,Fenster[1])
	guiSetFont(Checkbox[1],"default-bold-small")
	Checkbox[2] = guiCreateCheckBox(226,73,99,20,"checkLosFlag",false,false,Fenster[1])
	guiSetFont(Checkbox[2],"default-bold-small")
	Checkbox[3] = guiCreateCheckBox(327,50,99,20,"Randomizer",false,false,Fenster[1])
	guiSetFont(Checkbox[3],"default-bold-small")
	Checkbox[4] = guiCreateCheckBox(327,74,99,20,"SilentFlag",false,false,Fenster[1])
	guiSetFont(Checkbox[4],"default-bold-small")
	
	-- CHECKBOX --
	guiCheckBoxSetSelected(Checkbox[1],setting["360flag"])
	guiCheckBoxSetSelected(Checkbox[2],setting["checklosflag"])
	guiCheckBoxSetSelected(Checkbox[3],setting["randomizer"])
	guiCheckBoxSetSelected(Checkbox[4],setting["silent"])
	
	TabPanel[1] = guiCreateTabPanel(9,148,456,129,false,Fenster[1])
	Tab[1] = guiCreateTab("Position",TabPanel[1])	
	Tab[2] = guiCreateTab("Color",TabPanel[1])
	
	Scrollbar[1] = guiCreateScrollBar(24,17,216,24,true,false,Tab[1])
	Scrollbar[2] = guiCreateScrollBar(24,40,216,24,true,false,Tab[1])
	Scrollbar[3] = guiCreateScrollBar(23,64,216,24,true,false,Tab[1])
	Label[6] = guiCreateLabel(243,18,141,67,"X, Y, Z\n0, 0, 0",false,Tab[1])
	guiLabelSetVerticalAlign(Label[6],"center")
	guiLabelSetHorizontalAlign(Label[6],"center",false)
	guiSetFont(Label[6],"default-bold-small")
	
	

	
	Scrollbar[4] = guiCreateScrollBar(11,7,168,23,true,false,Tab[2])
	Scrollbar[5] = guiCreateScrollBar(11,37,168,23,true,false,Tab[2])
	Scrollbar[6] = guiCreateScrollBar(11,70,168,23,true,false,Tab[2])
	
	Label[7] = guiCreateLabel(186,12,100,77,"R, G, B\n0, 0, 0",false,Tab[2])
	guiLabelSetVerticalAlign(Label[7],"center")
	guiLabelSetHorizontalAlign(Label[7],"center",false)
	guiSetFont(Label[7],"default-bold-small")
	
	
	Scrollbar[7] = guiCreateScrollBar(310,2,22,102,false,false,Tab[2])
	Scrollbar[8] = guiCreateScrollBar(334,3,22,102,false,false,Tab[2])
	
	Label[8] = guiCreateLabel(362,33,85,36,"Alpha: 0\nMinimum: 0",false,Tab[2])
	guiLabelSetHorizontalAlign(Label[8],"center",false)
	guiSetFont(Label[8],"default-bold-small")
	Tab[3] = guiCreateTab("Credits",TabPanel[1])
	Label[9] = guiCreateLabel(6,4,447,95,"This GUI-Siren Editor was made by Noneatme.\nDieser Sirenen-Editor wurde von Noneatme erstellt.\n\nThanks to the MTA developer for the awesome siren-functions!\n\nIf you have any question, you can PM me via www.forum.mta-sa.de",false,Tab[3])
	guiSetFont(Label[9],"default-bold-small")
	Label[10] = guiCreateLabel(11,118,102,12,"Using siren Point: ",false,Fenster[1])
	guiSetFont(Label[10],"default-bold-small")
	Knopf[1] = guiCreateButton(118,117,65,22,"<--",false,Fenster[1])
	Label[11] = guiCreateLabel(191,120,34,21,setting["usingsiren"],false,Fenster[1])
	guiSetFont(Label[11],"default-bold-small")
	Knopf[2] = guiCreateButton(212,116,65,22,"-->",false,Fenster[1])
	Knopf[3] = guiCreateButton(285,116,87,23,"Apply",false,Fenster[1])
	Knopf[4] = guiCreateButton(376,116,87,23,"View code",false,Fenster[1])

	-- FUNCTIONS --
	local function applySettingsToRightSirenPoint(s)
		if not(sirenSettings[s]) then
			sirenSettings[s] = {}
			sirenSettings[s]["x"] = 0
			sirenSettings[s]["y"] = 0
			sirenSettings[s]["z"] = 0
			sirenSettings[s]["r"] = 0
			sirenSettings[s]["g"] = 0
			sirenSettings[s]["b"] = 0
			sirenSettings[s]["a"] = 200
			sirenSettings[s]["am"] = 200
		end
		guiSetText(Label[6], "X, Y, Z\n"..sirenSettings[s]["x"]..", "..sirenSettings[s]["y"]..", "..sirenSettings[s]["z"])
		guiSetText(Label[7], "R, G, B\n"..sirenSettings[s]["r"]..", "..sirenSettings[s]["g"]..", "..sirenSettings[s]["b"])
		guiSetText(Label[8], "Alpha: "..sirenSettings[s]["a"].."\nMinimum: "..sirenSettings[s]["am"])
		guiLabelSetColor(Label[7], sirenSettings[s]["r"], sirenSettings[s]["g"], sirenSettings[s]["b"], sirenSettings[s]["a"])
		
		guiScrollBarSetScrollPosition(Scrollbar[1], (sirenSettings[s]["x"]+5)*100/10)
		guiScrollBarSetScrollPosition(Scrollbar[2], (sirenSettings[s]["y"]+5)*100/10)
		guiScrollBarSetScrollPosition(Scrollbar[3], (sirenSettings[s]["z"]+5)*100/10)
		
		guiScrollBarSetScrollPosition(Scrollbar[4], sirenSettings[s]["r"]/2.55)
		guiScrollBarSetScrollPosition(Scrollbar[5], sirenSettings[s]["g"]/2.55)
		guiScrollBarSetScrollPosition(Scrollbar[6], sirenSettings[s]["b"]/2.55)
		guiScrollBarSetScrollPosition(Scrollbar[7], sirenSettings[s]["a"]/2.55)
		guiScrollBarSetScrollPosition(Scrollbar[8], sirenSettings[s]["am"]/2.55)
	end
	-- EVENT HANDLERS --
	-- ROLL EVENT ODER WIE MAN DAS NENNT :D --
	-- POSITION --
	addEventHandler("onClientGUIScroll", Scrollbar[1], function()
		local pos = guiScrollBarGetScrollPosition(source)
		pos = (pos/100*10)-5
		pos = math.round( pos, 2, "round" )
		sirenSettings[setting["usingsiren"]]["x"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIScroll", Scrollbar[2], function()
		local pos = guiScrollBarGetScrollPosition(source)
		pos = (pos/100*10)-5
		pos = math.round( pos, 2, "round" )
		sirenSettings[setting["usingsiren"]]["y"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIScroll", Scrollbar[3], function()
		local pos = guiScrollBarGetScrollPosition(source)
		pos = (pos/100*10)-5
		pos = math.round( pos, 2, "round" )
		sirenSettings[setting["usingsiren"]]["z"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	-- COLOR 
	addEventHandler("onClientGUIScroll", Scrollbar[4], function()
		local pos = math.round( guiScrollBarGetScrollPosition(source)*2.55, 1, "round" )
		sirenSettings[setting["usingsiren"]]["r"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIScroll", Scrollbar[5], function()
		local pos = math.round( guiScrollBarGetScrollPosition(source)*2.55, 1, "round" )
		sirenSettings[setting["usingsiren"]]["g"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIScroll", Scrollbar[6], function()
		local pos = math.round( guiScrollBarGetScrollPosition(source)*2.55, 1, "round" )
		sirenSettings[setting["usingsiren"]]["b"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIScroll", Scrollbar[7], function()
		local pos = math.round( guiScrollBarGetScrollPosition(source)*2.55, 1, "round" )
		sirenSettings[setting["usingsiren"]]["a"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	addEventHandler("onClientGUIScroll", Scrollbar[8], function()
		local pos = math.round( guiScrollBarGetScrollPosition(source)*2.55, 1, "round" )
		sirenSettings[setting["usingsiren"]]["am"] = pos
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end)
	-- CHANGE EVENT --
	addEventHandler("onClientGUIChanged", Edit[1], function()
		local anzahl = tonumber(guiGetText(source))
		if not(anzahl) or (anzahl < 1) or (anzahl > 6) then 
			outputChatBox("Falsche Eingabe! Es duerfen maximal 6 Sirenen sein, und minimal 1.", 255, 0, 0)
			return
		end
		setting["anzahlsirenen"] = anzahl
		for i = 1, anzahl, 1 do
			if not(sirenSettings[i]) then
				sirenSettings[i] = {}
				sirenSettings[i]["x"] = 0
				sirenSettings[i]["y"] = 0
				sirenSettings[i]["z"] = 0
				sirenSettings[i]["r"] = 0
				sirenSettings[i]["g"] = 0
				sirenSettings[i]["b"] = 0
				sirenSettings[i]["a"] = 200
				sirenSettings[i]["am"] = 200
			end
		end
	end)
	
	addEventHandler("onClientGUIChanged", Edit[2], function()
		local anzahl = tonumber(guiGetText(source))
		if not(anzahl) or (anzahl < 1) or (anzahl > 6) then 
			outputChatBox("Falsche Eingabe! Minimal 1 und Maximal 6.", 255, 0, 0)
			return
		end
		setting["sirenentyp"] = anzahl
	end)
	-- CLICK EVENTS --
	-- APPLY --
	addEventHandler("onClientGUIClick", Knopf[3], function()
		triggerServerEvent("onSireneditorSirenApply", gMe, setting["anzahlsirenen"], setting["sirenentype"], setting["360flag"], setting["checklosflag"], setting["randomizer"], setting["silent"], sirenSettings)
	end, false)
	-- VIEW CODE --
	addEventHandler("onClientGUIClick", Knopf[4], function()
		if(guiGetVisible(Fenster[2]) == true) then
			guiSetVisible(Fenster[2], false)
			guiSetText(source, "View code")
		else
			guiSetVisible(Fenster[2], true)
			guiSetText(source, "Hide code")
			local text = ""
			text = text.."removeVehicleSirens(veh)\n"
			
			text = text.."addVehicleSirens(veh, "..setting["anzahlsirenen"]..", "..setting["sirenentype"]..", "..tostring(setting["360flag"])..", "..tostring(setting["checklosflag"])..", "..tostring(setting["randomizer"])..", "..tostring(setting["silent"])..")\n"
			
			for i = 1, setting["anzahlsirenen"], 1 do
				if(sirenSettings[i]) then
					text = text.."setVehicleSirens(veh, "..i..", "..sirenSettings[i]["x"]..", "..sirenSettings[i]["y"]..", "..sirenSettings[i]["z"]..", "..sirenSettings[i]["r"]..", "..sirenSettings[i]["g"]..", "..sirenSettings[i]["b"]..", "..sirenSettings[i]["a"]..", "..sirenSettings[i]["am"]..")\n"
				end
			end
			guiSetText(Memo, text)
		end
	end, false)
	-- CHECKBOXES --
	addEventHandler("onClientGUIClick", Checkbox[1], function()
		setting["360flag"] = guiCheckBoxGetSelected(source)
	end, false)
	addEventHandler("onClientGUIClick", Checkbox[2], function()
		setting["checklosflag"] = guiCheckBoxGetSelected(source)
	end, false)
	addEventHandler("onClientGUIClick", Checkbox[3], function()
		setting["randomizer"] = guiCheckBoxGetSelected(source)
	end, false)
	addEventHandler("onClientGUIClick", Checkbox[4], function()
		setting["silent"] = guiCheckBoxGetSelected(source)
	end, false)

	-- BACK 
	addEventHandler("onClientGUIClick", Knopf[1], function()
		if(setting["usingsiren"] < 2) then return end
		setting["usingsiren"] = setting["usingsiren"]-1
		guiSetText(Label[11], setting["usingsiren"])
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end, false)
	addEventHandler("onClientGUIClick", Knopf[2], function()
		if(setting["usingsiren"] > 10) then return end
		if(setting["usingsiren"] > setting["anzahlsirenen"]-1) then return end
		setting["usingsiren"] = setting["usingsiren"]+1
		guiSetText(Label[11], setting["usingsiren"])
		applySettingsToRightSirenPoint(setting["usingsiren"])
	end, false)
	
	guiSetVisible(Fenster[1], false)
end
preCreate()

addCommandHandler("sireneditor", function()
	if(guiGetVisible(Fenster[1]) == true) then
		guiSetVisible(Fenster[1], false)
		guiSetVisible(Fenster[2], false)
		showCursor(false)
	else
		if(isPedInVehicle(gMe) == false) then
			outputChatBox("Du musst in einem Fahrzeug sein/You must sit in a vehicle!", 255, 0, 0)
			return
		end
		guiSetVisible(Fenster[1], true)
		if(guiGetText(Knopf[4]) == "Hide code") then
			guiSetVisible(Fenster[2], true)
		end
		showCursor(true)
		guiSetInputMode("no_binds_when_editing")
	end
end)


function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end