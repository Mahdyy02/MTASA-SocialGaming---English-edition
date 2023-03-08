local kepS = {guiGetScreenSize()}
local kepK = {400,500}
local kepP = {kepS[1]/2-kepK[1]/2,kepS[2]/2-kepK[2]/2}
local screen = {}
local elolvan = false
local forgatni = 0

local Hatter = -kepK[1]
local r = {0,0,0}--fekete
local H = {157, 126, 88}--hover

local coloredText = "#ffffff"

local parancsok = {}

addEvent("receiveAdminCommands", true)
addEventHandler("receiveAdminCommands", getRootElement(),
	function(array)
		for k, v in pairs(array) do
			if not acmds[k] then
				addAdminCommand(k, v[1], v[2], v[3])
			end
		end
	end)

addCommandHandler("ah",function()
	if getElementData(localPlayer,"admin >> level") < 1 then return end
		if elolvan then
			elolvan = false
			Hatter = -500
			showChat(true)
			parancsok = {}
		else
			triggerServerEvent("requestAdminCommands", localPlayer)
			elolvan = true
			for k, v in pairs(acmds) do
				table.insert(parancsok, {k, v[2], v[1]})
			end
			showChat(true)
		end
end)

function AhFelrjzol()
	if not elolvan then return end
	if getElementData(localPlayer,"acc >> loggedIn") then
	--exports["fv_blur"]:createBlur()
		Hatter = Hatter + 100
		if Hatter > kepP[2] then
			Hatter = kepP[2]
		end											
		screen = {kepP[1],Hatter}
	
		
		--dxDrawImage(screen[1],screen[2],kepK[1],kepK[2], ":sg_login/files/logo.png",0,0,0,tocolor(255,255,255,255/4) )
		dxDrawRectangle(screen[1],screen[2],kepK[1],kepK[2],tocolor(r[1],r[2],r[3],255/2))
		dxDrawRectangle(screen[1],screen[2],kepK[1],50,tocolor(r[1],r[2],r[3],255/3))
		dxDrawRectangle(screen[1],screen[2],kepK[1],1,tocolor(r[1],r[2],r[3],255/2))
		dxDrawRectangle(screen[1],screen[2],1,kepK[2],tocolor(r[1],r[2],r[3],255/2))
		dxDrawRectangle(screen[1]+400,screen[2],1,kepK[2],tocolor(r[1],r[2],r[3],255/2))
		dxDrawRectangle(screen[1]+200,screen[2]+50,1,kepK[2]-50,tocolor(r[1],r[2],r[3],255/1.5))
		--dxDrawText("Social #A98B65Gaming",kepernyom[1]/2-Meretek[1]/2+105,Hatter+10,Meretek[1],50,tocolor(255,255,255,255),2,"default-bold","left","top",false, false, false, true)
		dxDrawText("The #CA2323Devils",screen[1]+105,screen[2]+10,kepK[1],kepK[2],tocolor(255,255,255,255),2,"default-bold","left","top",false, false, false, true)
	
		dxDrawText("Commands ", screen[1]+70,screen[2]+70,kepK[1],kepK[2], tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, true)
		dxDrawText("Description", screen[1]+280,screen[2]+70,kepK[1],kepK[2], tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, true)
	--	dxDrawRectangle(kepernyom[1]/2-Meretek[1]/2,Hatter+80,Meretek[1],1,tocolor(r[1],r[2],r[3],255/3))
		--dxDrawRectangle(kepernyom[1]/2-1/2,Hatter+50,1,Meretek[2]-50,tocolor(r[1],r[2],r[3],255/3))
		local elem = 0
			for i, parancs in ipairs( parancsok ) do
				if (i > forgatni and elem < 12) then
					elem = elem + 1
					if parancs[3] == tonumber(getElementData(localPlayer,"admin >> level") or 0) or parancs[3] <= tonumber(getElementData(localPlayer,"admin >> level") or 0) then
						coloredText = "#CA2323"
						dxDrawRectangle(screen[1],screen[2]+65 + elem * 30,kepK[1],25,tocolor(r[1],r[2],r[3],255/4))
						dxDrawText(coloredText.."/"..tostring(parancs[1],parancs[2]),screen[1]+40,screen[2]+70 + elem * 30,kepK[1],kepK[2], tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, true)
						dxDrawText(coloredText..tostring(parancs[2]),screen[1]+235,screen[2]+70 + elem * 30,kepK[1],kepK[2], tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, true)
						--dxDrawRectangle(screen[1],screen[2]+65 + elem * 30,kepK[1],25,tocolor(r[1],r[2],r[3],255/3))

					else	
						coloredText = "#ffffff"
						dxDrawRectangle(screen[1],screen[2]+65 + elem * 30,kepK[1],25,tocolor(r[1],r[2],r[3],255/4))
						dxDrawText(coloredText.."/"..tostring(parancs[1],parancs[2]),screen[1]+40,screen[2]+70 + elem * 30,kepK[1],kepK[2], tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, true)
						dxDrawText(coloredText..tostring(parancs[2]),screen[1]+235,screen[2]+70 + elem * 30,kepK[1],kepK[2], tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, true)
					end	
				end
			end
	end
end
addEventHandler("onClientRender",getRootElement(),AhFelrjzol)

addEventHandler("onClientKey", getRootElement(), function(g, v)
	if not elolvan or not v then return end
	if g == "mouse_wheel_down" then
		forgatni = forgatni + 1
		if forgatni > #parancsok - 12 then
			forgatni = #parancsok - 12
		end	
	elseif g == "mouse_wheel_up" then
		forgatni = forgatni - 1
		if forgatni < 1 then
			forgatni = 0
		end	
	end
end)

function dobozbaVan(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end



