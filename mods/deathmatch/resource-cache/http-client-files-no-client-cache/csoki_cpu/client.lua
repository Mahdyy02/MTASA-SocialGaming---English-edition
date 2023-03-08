local sx,sy = guiGetScreenSize()
local resStat = false
local clientRows = {}, {}
local serverRows = {}, {}

local MED_CLIENT_CPU = 2 -- 5%
local MAX_CLIENT_CPU = 5 -- 5%

local MED_SERVER_CPU = 0.5 -- 5%
local MAX_SERVER_CPU = 1 -- 5%

addCommandHandler("stat", function()
	if getElementData(localPlayer,"admin >> level") < 10 then return end
	resStat = not resStat
	if resStat then
		outputChatBox("Szerver terhelés kimutatás bekapcsolva", 0, 255, 0, true)
		addEventHandler("onClientRender", root, resStatRender)
		triggerServerEvent("getServerStat", localPlayer)
	else
		outputChatBox("Szerver terhelés kimutatás kikapcsolva", 255, 0, 0, true)
		removeEventHandler("onClientRender", root, resStatRender)
		serverStats = nil
		serverColumns, serverRows = {}, {}
		triggerServerEvent("destroyServerStat", localPlayer)
	end
end)

function toFloor(num)
	return tonumber(string.sub(tostring(num), 0, -2)) or 0
end
local avgC, avgCM, avgS, avgSM = 0,0, 0,0

function toFloor(num)
	return tonumber(string.sub(tostring(num), 0, -2)) or 0
end

function coloring(value)
	local a = tocolor(255,255,255);
	if value <= 10 then 
		a = tocolor(255,255,255);
	elseif value > 10 and value <= 30 then 
		local r,g,b = exports.fv_engine:getServerColor("orange",false);
		a = tocolor(r,g,b);
	elseif value > 30 then 
		local r,g,b = exports.fv_engine:getServerColor("red",false);
		a = tocolor(r,g,b);
	end
	return a;
end

addEvent("receiveServerStat", true)
addEventHandler("receiveServerStat", root, 
    function(stat1,stat2)
        _, clientRows = getPerformanceStats("Lua timing")
        _, serverRows = stat1,stat2

        table.sort(clientRows, function(a, b)
            return toFloor(a[2]) > toFloor(b[2])
        end)

        table.sort(serverRows, function(a, b)
            return toFloor(a[2]) > toFloor(b[2])
        end)
        
        avgC = 0
        for k,v in pairs(clientRows) do
            avgC = avgC + toFloor(v[2])
        end
        avgCM = math.floor(avgC)
        avgC = math.floor(avgC / #clientRows)
        
        avgS = 0
        for k,v in pairs(serverRows) do
            avgS = avgS + toFloor(v[2])
        end
        avgSM = math.floor(avgS)
        avgS = math.floor(avgS / #serverRows)
    end
)

local font = "default-bold"

local disabledResources = {}
function resStatRender()
	local x = sx-300
	if #serverRows == 0 then
		x = sx-140
	end
	if #clientRows ~= 0 then
        local count = 0
        for i, row in ipairs(clientRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
                if usedCPU > 0.1 then
                    count = count + 1
                end
            end
        end
        
		local height = (15*count)+15
		local y = sy/2-height/2
        local r,g,b,a = 255,255,255,255
		if #serverRows == 0 then
			dxDrawText("Client: "..avgC.."%, "..avgCM.."%",sx-74,y-19,sx-74,y-19,tocolor(0,0,0,255),1, font,"center")
			dxDrawText("Client: "..avgC.."%, "..avgCM.."%",sx-75,y-20,sx-75,y-20,tocolor(r,g,b,a),1, font,"center")
		else
			dxDrawText("Client: "..avgC.."%, "..avgCM.."%",sx-234,y-19,sx-234,y-19,tocolor(0,0,0,255),1, font,"center")
			dxDrawText("Client: "..avgC.."%, "..avgCM.."%",sx-235,y-20,sx-235,y-20,tocolor(r,g,b,a),1, font,"center")
		end
		dxDrawRectangle(x-10,y,150,height,tocolor(0,0,0,150))
		y = y + 5
		for i, row in ipairs(clientRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
                if usedCPU > 0.1 then
                    local text = row[1]:sub(0,15)..": "..usedCPU.."%"
                    dxDrawText(text,x+1,y+1,150,15,tocolor(0,0,0,255),1,font)
                    dxDrawText(text,x,y,150,15,coloring(usedCPU),1,font)
                    y = y + 15
                end
			end
		end
	end
	
	if #serverRows ~= 0 then
        local count = 0
        for i, row in ipairs(serverRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
                if usedCPU > 0.01 then
                    count = count + 1
                end
            end
        end
        
		local x = sx-140
		local height = (15*count)
		local y = sy/2-height/2
        local r,g,b,a = 255,255,255,255
		dxDrawText("Server: "..avgS.."%, "..avgSM.."%",sx-74,y-19,sx-74,y-19,tocolor(0,0,0,255),1, font,"center")
		dxDrawText("Server: "..avgS.."%, "..avgSM.."%",sx-75,y-20,sx-75,y-20,tocolor(r,g,b,a),1, font,"center")
		dxDrawRectangle(x-10,y,150,height+15,tocolor(0,0,0,180))
		y = y + 5
		for i, row in ipairs(serverRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
                if usedCPU > 0.01 then
                    local text = row[1]:sub(0,15)..": "..usedCPU.."%"
                    dxDrawText(text,x+1,y+1,150,15,tocolor(0,0,0,255),1,font)
                    dxDrawText(text,x,y,150,15,coloring(usedCPU),1,font)
                    y = y + 15
                end
			end
		end
	end
end















--DEV TOOLS--
local devMode = false;
addCommandHandler("devmode",function()
	if getElementData(localPlayer,"admin >> level") < 8 then return end;
	devMode = not devMode;
	setDevelopmentMode(devMode);
	if devMode then 
		outputChatBox(exports.fv_engine:getServerSyntax("DevMode","green").."Debug mód bekapcsolva!",255,255,255,true);
	else 
		outputChatBox(exports.fv_engine:getServerSyntax("DevMode","red").."Debug mód kikapcsolva!",255,255,255,true);
	end
end)

local dummystate = false
addCommandHandler("showdummy", 
    function()
       if getElementData(localPlayer,"admin >> level") > 8 then
            dummystate = not dummystate
            if dummystate then
                local syntax = exports.fv_engine:getServerSyntax("Dummy","green")
                outputChatBox(syntax .. "Dummy listázás bekapcsolva!", 0, 255, 0, true)
                addEventHandler("onClientRender", root, showVehicleDummy, true, "low-5")
            else
                local syntax = exports.fv_engine:getServerSyntax("Dummy","red")    
                outputChatBox(syntax .. "Dummy listázás kikapcsolva!", 255, 0, 0, true)
                removeEventHandler("onClientRender", root, showVehicleDummy)
            end
       end
    end
)

function showVehicleDummy()
	local x,y,z = getElementPosition(localPlayer)
	for k, veh in ipairs(getElementsByType("vehicle", root, true)) do
		if isElementOnScreen(veh) then
			local xx,yy,yz = getElementPosition(veh)
			if getDistanceBetweenPoints3D(x,y,z,xx,yy,yz) < 10 then
				for v in pairs(getVehicleComponents(veh)) do
					local x,y,z = getVehicleComponentPosition(veh, v, "world")
					if x and y and z then 
						local wx,wy,wz = getScreenFromWorldPosition(x, y, z)
						if wx and wy then
							dxDrawText(v, wx -1, wy -1, wx -1, wy -1, tocolor(0,0,0), 1, "default-bold", "center", "center")
							dxDrawText(v, wx +1, wy -1, wx +1, wy -1, tocolor(0,0,0), 1, "default-bold", "center", "center")
							dxDrawText(v, wx -1, wy +1, wx -1, wy +1, tocolor(0,0,0), 1, "default-bold", "center", "center")
							dxDrawText(v, wx +1, wy +1, wx +1, wy +1, tocolor(0,0,0), 1, "default-bold", "center", "center")
							dxDrawText(v, wx, wy, wx, wy, tocolor(0,255,255), 1, "default-bold", "center", "center")
						end
					end
				end
			end
		end
	end
end

addCommandHandler ( "gvc",
    function ( )
        local theVehicle = getPedOccupiedVehicle ( localPlayer )
        if ( theVehicle ) then
            for k in pairs ( getVehicleComponents ( theVehicle ) ) do
                outputChatBox ( k )
            end
        end
    end
)
