sx,sy = guiGetScreenSize()
white = "#FFFFFF";
local serverName = exports["fv_engine"]:getServerData("name")
local serverWeb = exports["fv_engine"]:getServerData("web")
local sr, sg, sb = exports["fv_engine"]:getServerColor("servercolor")
local rr, rg, rb = exports["fv_engine"]:getServerColor("red")
local rage = exports['fv_engine']:getFont("rage", 16)
local hexColor = exports['fv_engine']:getServerColor("servercolor", true)
sColor = exports['fv_engine']:getServerColor("servercolor", true)

acmds = {}
devSerials = {
    [""]=true,
}
addEventHandler("onClientResourceStart", getResourceRootElement(),
	function()
		local cache = getElementData(localPlayer, "adminCommandsCache")

		if cache then
			for k, v in pairs(cache) do
				if not acmds[k] then
					addAdminCommand(k, v[1], v[2], v[3])
				end
			end

			setElementData(localPlayer, "adminCommandsCache", false)
		end
	end)

addEventHandler("onClientResourceStop", getRootElement(),
	function(stoppedResource)
		if stoppedResource == getThisResource() then
			local array = {}
			local count = 0

			for k, v in pairs(acmds) do
				if v[3] ~= "fv_admin" then
					array[k] = v
					count = count + 1
				end
			end
			
			if count > 0 then
				setElementData(localPlayer, "adminCommandsCache", array, false)
			end
		else
			local resname = getResourceName(stoppedResource)

			for k, v in pairs(acmds) do
				if v[3] == resname then
					acmds[k] = nil
				end
			end
		end
	end)

function addAdminCommand(command, level, description, forceResourceName)
	if not acmds[command] then
		local resourceName = forceResourceName or "fv_admin"

		if not forceResourceName and sourceResource then
			resourceName = getResourceName(sourceResource)
		end

		acmds[command] = {level, description, resourceName}
	end
end

addEventHandler("onClientResourceStart", root, function(resource)
    if getResourceName(resource) == "fv_engine" then
        serverName = exports["fv_engine"]:getServerData("name")
        serverWeb = exports["fv_engine"]:getServerData("web")
        sr, sg, sb = exports["fv_engine"]:getServerColor("servercolor")
        rr, rg, rb = exports["fv_engine"]:getServerColor("red")
        rage = exports['fv_engine']:getFont("rage", 15)
        hexColor = exports['fv_engine']:getServerColor("servercolor", true)
        sColor = exports['fv_engine']:getServerColor("servercolor", true)
    end
    if getThisResource() == resource then 
        getElementData(localPlayer,"reconPlayer",false);
        setElementData(localPlayer,"valaszShow", true);
        setElementData(localPlayer,"reconPlayer", false);
        setElementData(localPlayer,"pmEnabled",true);
        setElementData(localPlayer,"togAdminChat",true);
    end
end);

function setAdminLevel(cmd, target, level)
    --if devSerials[getPlayerSerial(serial)] then 
        if not level or not target then
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").. "/"..cmd.." [player] [level]", sr,sg,sb,true)
            return
        elseif tonumber(level) == nil then
            outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."The level must be a number!", sr,sg,sb,true)
            return
        elseif getElementData(localPlayer,"admin >> level") == 8 and tonumber(level) > 1 then
            outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").. "You just idg. you can add an admin assistant (level 1)!", sr,sg,sb,true)
            return
        elseif getElementData(localPlayer,"admin >> level") == 9 and tonumber(level) > 9 then
            outputChatBox( exports.fv_engine:getServerSyntax("Admin","red").."You can add a maximum of SuperAdmin (level 9)!", sr,sg,sb,true)
            return
        end
            level = tonumber(math.floor(level))
            local target = exports['fv_engine']:findPlayer(localPlayer, target)
            local oValue = getElementData(target, "admin >> level")
            local newLevel = level + 2
            if target then
                if getElementData(target, "loggedIn") then
                    if getElementData(localPlayer,"admin >> level") < getElementData(target,"admin >> level") then outputChatBox( "[".. serverName .. "] #ffffffYou cannot set a higher admin level!", sr,sg,sb,true) return end
                    if getElementData(localPlayer,"admin >> level") == 8 and getElementData(target, "admin >> level") > 1 then outputChatBox( "[".. serverName .. "] #ffffffYou can't take your rank!", sr,sg,sb,true) return end
                    
                    local hexColor = exports['fv_engine']:getServerColor("servercolor", true)
                    local aName1 = getAdminName(localPlayer, true)
                    local aName2 = getAdminName(target, true)
                    local newLevel = newLevel - 2
                    if newLevel < 0 then newLevel = 0 end
                    exports['fv_engine']:sendMessageToAdmin(localPlayer,hexColor.."[".. serverName .. "] "..hexColor..aName1..white.." changed "..hexColor..aName2..white.." administrator level. "..hexColor.."("..(aTitles[oValue] or "Unknown").." => "..(aTitles[newLevel] or "Unknown")..")", 0)
                    exports['fv_logs']:createLog("fv_admin",aName1.." changed " ..aName2.. " administrator level "..(aTitles[oValue] or "Unknown").." > "..(aTitles[newLevel] or "Unknown"),localPlayer,targetPlayer )
                    --setElementData(target,"admin >> level", newLevel)
                    triggerServerEvent("ac.elementData",target,target,"admin >> level",newLevel);
                else
                    outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").. "The player is not logged in!", sr,sg,sb,true)
                end
            end
    end
--end
addCommandHandler("setalevel", setAdminLevel)
addAdminCommand("setalevel", 8, "Admin broadcast", "fv_admin")



function setAdminNick(cmd, target, nick)
    if not hasPermission(localPlayer, "setanick") then noAdmin(cmd) return end
    if not nick or not target then outputChatBox( "[".. serverName .. "] #ffffff/"..cmd.." [player] [name]", sr,sg,sb,true) return end
    
    local target = exports['fv_engine']:findPlayer(localPlayer, target)
    if target then
    	if getElementData(target, "loggedIn") then
			if getElementData(localPlayer,"admin >> level") < getElementData(target,"admin >> level") then  outputChatBox( "[".. serverName .. "] #ffffffYou can't name a bigger admin!", sr,sg,sb,true) return end

			local aName1 = getAdminName(localPlayer, true)
			local aName2 = getAdminName(target, true)
			local hexColor = exports['fv_engine']:getServerColor("servercolor", true)

			exports['fv_engine']:sendMessageToAdmin(localPlayer,hexColor.."[".. serverName .. "] "..hexColor..aName1..white.." changed "..hexColor..aName2..white.." administrator name. "..hexColor.."("..nick..")", 0)
			-- setElementData(target, "admin >> name", nick)
            triggerServerEvent("ac.elementData",target,target,"admin >> name",nick);
        else
        	outputChatBox( "[".. serverName .. "] #ffffffThe player is not logged in!", sr,sg,sb,true)
    	end
    end
end
addCommandHandler("setanick", setAdminNick)
addAdminCommand("setanick", 9, "Admin nick statement", "fv_admin")

addCommandHandler("getpos", function(cmd)
    if not hasPermission(localPlayer, "getpos") then noAdmin(cmd) return end
        local x,y,z = getElementPosition(localPlayer)
        local dim, int = getElementDimension(localPlayer), getElementInterior(localPlayer)
        local a, a, rot = getElementRotation(localPlayer)
        setClipboard(x .. ", " .. y .. ", " .. z)
        local syntax = exports['fv_engine']:getServerSyntax()
        local green = exports['fv_engine']:getServerColor("servercolor", true)
        outputChatBox(syntax .. "XYZ" .. ": ".. green .. x .. white ..", " .. green .. y .. white .. ", " .. green .. z,255,255,255,true)
        outputChatBox(syntax .. "Interior" .. ": ".. green .. int,255,255,255,true)
        outputChatBox(syntax .. "Dimension" .. ": ".. green .. dim,255,255,255,true)
        outputChatBox(syntax .. "Rotation" .. ": ".. green .. rot,255,255,255,true)
end);
addAdminCommand("getpos", 8, "Retrieve position", "fv_admin")

addEventHandler("onClientResourceStart", resourceRoot,function()
    if getElementData(localPlayer, "admin >> duty") then
        adminTimer = setTimer(
            function()
                 if not getElementData(localPlayer, "afk") then
                    local oAdminTime = getElementData(localPlayer, "admin >> time") or 0;
                    setElementData(localPlayer, "admin >> time", oAdminTime + 1)
                end
            end, 60 * 1000, 0)
        end
end);

local ztTimer = nil

addEventHandler("onClientElementDataChange", root,
    function(dName)
        if source == localPlayer then
            if dName == "admin >> duty" then
                local value = getElementData(source, dName)
                if value then
                    adminTimer = setTimer(
                        function()
                            if not getElementData(localPlayer, "afk") then
                                local oAdminTime = getElementData(localPlayer, "admin >> time") or 0
                                setElementData(localPlayer, "admin >> time", oAdminTime + 1)
                            end
                        end, 60 * 1000, 0
                    )
                else
                    if isTimer(adminTimer) then
                        killTimer(adminTimer)
                    end
                end
            end
        end
        if dName == "admin >> duty" then
            local value = getElementData(source, dName)
            local adminlevel = getElementData(source, "admin >> level") or 0
            if adminlevel > 2 then
                if value then
                    --Belépés
                    local id = getElementData(source, "char >> id") or 0
                    exports['fv_infobox']:addNotification("admindutyon", getAdminName(source, true) .. " has entered the admin service! /pm "..id)
                    if isTimer(ztTimer) then
                        killTimer(ztTimer )
                    end
                else
                    --Kilépés
                    exports['fv_infobox']:addNotification("admindutyoff", getAdminName(source, true) .. " has left the admin service!")
                    if getAdminInDuty() < 3 then
                        exports['fv_infobox']:addNotification("info", "Zero tolerance is in force!")
                    end
                end
            end
        end
    end
)

local lastAlertTick = getTickCount()

addEventHandler("onClientRender", root, function()
    if getAdminInDuty() < 1 then
        if lastAlertTick + 60000 * 5 < getTickCount() then
            if getAdminInDuty() < 1 then
                exports['fv_infobox']:addNotification("info", "Zero tolerance is in force!")
                lastAlertTick = getTickCount()
            end
        end
    end
end)

function getAdminInDuty()
    local c = 0
    for k,v in pairs(getElementsByType("player")) do
        if getElementData(v,"admin >> duty") then
            c = c + 1
        end
    end

    return c
end


addCommandHandler("fly", function(cmd)
if not hasPermission(localPlayer, "fly") then noAdmin(cmd) return end
    toggleFly();
end)
addAdminCommand("fly", 3, "Flight", "fv_admin")

local flyingState = false
local keys = {}
keys.up = "up"
keys.down = "up"
keys.f = "up"
keys.b = "up"
keys.l = "up"
keys.r = "up"
keys.a = "up"
keys.s = "up"
keys.m = "up"

function toggleFly()
    flyingState = not flyingState   
    if flyingState then
        addEventHandler("onClientRender",getRootElement(),flyingRender, true, "low-5")
        bindKey("lshift","both",keyH)
        bindKey("rshift","both",keyH)
        bindKey("lctrl","both",keyH)
        bindKey("rctrl","both",keyH)
        
        bindKey("forwards","both",keyH)
        bindKey("backwards","both",keyH)
        bindKey("left","both",keyH)
        bindKey("right","both",keyH)
        
        bindKey("lalt","both",keyH)
        bindKey("space","both",keyH)
        bindKey("ralt","both",keyH)
        bindKey("mouse1","both",keyH)
        setElementCollisionsEnabled(getLocalPlayer(),false)
        setElementData(localPlayer, "keysDenied", true)
        --setElementData(localPlayer, "fly", true)
        triggerServerEvent("ac.elementData",localPlayer,localPlayer,"fly",true);
    else
        removeEventHandler("onClientRender",getRootElement(),flyingRender)
        unbindKey("mouse1","both",keyH)
        unbindKey("lshift","both",keyH)
        unbindKey("rshift","both",keyH)
        unbindKey("lctrl","both",keyH)
        unbindKey("rctrl","both",keyH)
        
        unbindKey("forwards","both",keyH)
        unbindKey("backwards","both",keyH)
        unbindKey("left","both",keyH)
        unbindKey("right","both",keyH)
        
        unbindKey("space","both",keyH)
        
        keys.up = "up"
        keys.down = "up"
        keys.f = "up"
        keys.b = "up"
        keys.l = "up"
        keys.r = "up"
        keys.a = "up"
        keys.s = "up"
        setElementCollisionsEnabled(getLocalPlayer(),true)
        setElementData(localPlayer, "keysDenied", false)
        --setElementData(localPlayer, "fly", false)
        triggerServerEvent("ac.elementData",localPlayer,localPlayer,"fly",false);
    end
end

function flyingRender()
    local x,y,z = getElementPosition(getLocalPlayer())
    local speed = 10
    if keys.a=="down" then
        speed = 3
    elseif keys.s=="down" then
        speed = 50
    elseif keys.m=="down" then
        speed = 300
    end
    
    if keys.f=="down" then
        local a = rotFromCam(0)
        setElementRotation(getLocalPlayer(),0,0,a)
        local ox,oy = dirMove(a)
        x = x + ox * 0.1 * speed
        y = y + oy * 0.1 * speed
    elseif keys.b=="down" then
        local a = rotFromCam(180)
        setElementRotation(getLocalPlayer(),0,0,a)
        local ox,oy = dirMove(a)
        x = x + ox * 0.1 * speed
        y = y + oy * 0.1 * speed
    end
    
    if keys.l=="down" then
        local a = rotFromCam(-90)
        setElementRotation(getLocalPlayer(),0,0,a)
        local ox,oy = dirMove(a)
        x = x + ox * 0.1 * speed
        y = y + oy * 0.1 * speed
    elseif keys.r=="down" then
        local a = rotFromCam(90)
        setElementRotation(getLocalPlayer(),0,0,a)
        local ox,oy = dirMove(a)
        x = x + ox * 0.1 * speed
        y = y + oy * 0.1 * speed
    end
    
    if keys.up=="down" then
        z = z + 0.1*speed
    elseif keys.down=="down" then
        z = z - 0.1*speed
    end
    
    setElementPosition(getLocalPlayer(),x,y,z)
end

function keyH(key,state)
    if key=="lshift" or key=="rshift" then
        keys.s = state
    end 
    if key=="lctrl" or key=="rctrl" then
        keys.down = state
    end 
    if key=="forwards" then
        keys.f = state
    end 
    if key=="backwards" then
        keys.b = state
    end 
    if key=="left" then
        keys.l = state
    end 
    if key=="right" then
        keys.r = state
    end 
    if key=="lalt" or key=="ralt" then
        keys.a = state
    end 
    if key=="space" then
        keys.up = state
    end 
    if key=="mouse1" then
        keys.m = state
    end 
end

function rotFromCam(rzOffset)
    local cx,cy,_,fx,fy = getCameraMatrix(getLocalPlayer())
    local deltaY,deltaX = fy-cy,fx-cx
    local rotZ = math.deg(math.atan((deltaY)/(deltaX)))
    if deltaY >= 0 and deltaX <= 0 then
        rotZ = rotZ+180
    elseif deltaY <= 0 and deltaX <= 0 then
        rotZ = rotZ+180
    end
    return -rotZ+90 + rzOffset
end

function dirMove(a)
    local x = math.sin(math.rad(a))
    local y = math.cos(math.rad(a))
    return x,y
end

addEventHandler("onClientElementDataChange", localPlayer,
    function(dName)
        if dName == "keysDenied" and flyingState then
            local value = getElementData(source, dName)
            if not value then
                setElementData(source, dName, true)
            end
        elseif dName == "admin >> duty" and flyingState then
            if getElementData(localPlayer,"admin >> level") == 13 then return end
            local value = getElementData(source, dName)
            if not value then
                toggleFly()
            end
        end
    end
)

-- // Hallhatatlanság (God)
addEventHandler("onClientPlayerDamage", root,
    function()
        local adminduty = getAdminDuty(source)
        local adminlevel = getElementData(source, "admin >> level")
        if adminduty and adminlevel >= 3 then
            cancelEvent()
        end
    end
)

addEventHandler("onClientPlayerStealthKill", localPlayer,
    function(target)
        local adminduty = getAdminDuty(target)
        local adminlevel = getElementData(target, "admin >> level")
        if adminduty and adminlevel >= 3 then
            cancelEvent()
        end
    end
)

function noAdmin(cmd)
    return outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."You can't use the command or you're not in adminduty!",255,255,255,true)
end

function updateRecon()
	if (getElementData(localPlayer, "loggedIn")) then
		local targetPlayer = getElementData(localPlayer, "reconPlayer");
		if (targetPlayer) then
			local targetInt = getElementInterior(targetPlayer);
			local targetDim = getElementDimension(targetPlayer);
			local selfInt = getElementInterior(localPlayer);
			local selfDim = getElementDimension(localPlayer);
			
			if (targetInt ~= selfInt or targetDim ~= selfDim) then
				setCameraInterior(targetInt);
				triggerServerEvent("admin:serverUpdateSpectator", resourceRoot);
			end
		end
	end
end

addEvent("admin:toggleReconUpdate", resourceRoot,
	function(state)
		if (state) then
			addEventHandler("onClientRender", root, updateRecon);
		else
			removeEventHandler("onClientRender", root, updateRecon);
		end
	end
);

--[[
setTimer(function()
if getElementData(localPlayer,"loggedIn") then 
    local target = getElementData(localPlayer,"reconPlayer");
    if target then 
        local targetDim, targetInt = getElementDimension(target),getElementInterior(target);
        if getElementDimension(localPlayer) ~= targetDim then 
            setElementDimension(localPlayer,targetDim);
        end
        if getElementInterior(localPlayer) ~= targetInt then 
            setElementInterior(localPlayer,targetInt);
        end
    end
end
end,1000,0);
--]]