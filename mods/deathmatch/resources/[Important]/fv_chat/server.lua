white = "#FFFFFF"
function playerChat(message, messageType)
    cancelEvent()
    if messageType == 0 then 
        triggerClientEvent(source, "onClientMessage", source, source, message, messageType)
    end
end
addEventHandler("onPlayerChat", root, playerChat)

function createMessage(element, message, mtype)
    triggerClientEvent(element, "createMessage", element, element, message, mtype)
end

addEvent("giveMessageToClient", true)
addEventHandler("giveMessageToClient", root, 
    function(element, e, text, r,g,b, whisper, ooc, asd, type)
        if not whisper then whisper = false end
        if not ooc then ooc = false end
        if isElement(e) then 
            if ooc and getElementData(element,"admin >> duty") then 
                triggerClientEvent(e, "chat -- receive", e, e, exports.fv_admin:getAdminColor(element, level)..text, r,g,b, whisper, ooc)
            else
                triggerClientEvent(e, "chat -- receive", e, e, text, r,g,b, whisper, ooc)
            end
            
            if ooc then
                outputServerLog("[OOC] " .. text)
            else
                outputServerLog(text)
                --if type == "me" or type == "do" then return end
                --triggerClientEvent(e, "addBubble", e, sElement, text, r,g,b)
            end
        end
    end
)

local cache = {}
local notCheck = {
    ["lright"] = true,
    ["lleft"] = true,
};
function blockFlood(command)
	if not cache[source] then
        cache[source] = {}
        cache[source]["num"] = 1
        local source = source
        if not isTimer(cache[source]["timer"]) then
            cache[source]["timer"] = setTimer(
                function()
                    if cache[source]["num"] - 1 >= 1 then
                        cache[source]["num"] = cache[source]["num"] - 1 
                    else
                        cache[source]["num"] = 0
                        killTimer(cache[source]["timer"])
                    end
                end, 500, 0
            )
        end
	else
        local source = source
            if not notCheck[command] then 
            cache[source]["num"] = cache[source]["num"] + 1
            if cache[source]["num"] >= 5 and cache[source]["num"] <= 10 then
                cancelEvent()
                local syntax = exports['fv_engine']:getServerSyntax(false, "error")
                outputChatBox(syntax .. "Only 5 commands can be used in 1 second!", source, 255,255,255,true)
            elseif cache[source]["num"] >= 10 then
                cancelEvent()
                exports.fv_infobox:addNotification(root,"kick","System kicked "..getElementData(source,"char >> name").." player.","Reason: Flood.");
                kickPlayer(source, "Rendszer", "You have used too many commands in 1 second! (Flood detected, indicated!)")
            end
            if not isTimer(cache[source]["timer"]) then
                cache[source]["timer"] = setTimer(
                    function()
                        if cache[source]["num"] - 1 >= 1 then
                            cache[source]["num"] = cache[source]["num"] - 1 
                        else
                            cache[source]["num"] = 0
                            killTimer(cache[source]["timer"])
                        end
                    end, 500, 0
                )
            end
        end
	end
end
addEventHandler("onPlayerCommand", root, blockFlood)

addEventHandler("onElementDataChange", root,
    function(dName)
        if dName == "animation" then
            local forceAnim = false
            local forceAnimation = getElementData(source, "forceAnimation") or {"", ""}
            if forceAnimation[1] ~= "" or forceAnimation[2] ~= "" then
                forceAnim = true
            end
            if forceAnim then
                return
            end
            local value = getElementData(source, dName)
            if getElementData(source,"collapsed") then return end;
            if getElementData(source,"cuffed") then return end;
            if getElementData(source,"char >> taser") then return end;
            if value[2] == "shout_01" then
                --setPedAnimation(source, value[1], value[2], 1000,false,false,false,false)
            else
                setPedAnimation(source, value[1], value[2], 3000,false,false,false,false)
            end
        end
    end
)

function sendLocalMeAction(thePlayer, message)
    local x,y,z = getElementPosition(thePlayer)
    for k,v in pairs(getElementsByType("player")) do
        if getElementInterior(v) == getElementInterior(thePlayer) and getElementDimension(v) == getElementDimension(thePlayer) then
            local x1, y1, z1 = getElementPosition(v)
            local distance = math.floor(getDistanceBetweenPoints3D(x, y, z, x1, y1, z1))
            local veh2 = getPedOccupiedVehicle(v)
            if distance <= 8 then
                local r,g,b = 194, 162, 218
                local name = exports['fv_admin']:getAdminName(thePlayer)
                outputChatBox( " ***"..name.." "..message,v, r,g,b,true)
            end
        end
    end
end
addEvent("sendLocalMeAction", true)
addEventHandler("sendLocalMeAction", getRootElement(), sendLocalMeAction)