local safeDoors = {}
local bankTimer = nil

addEventHandler("onResourceStart", resourceRoot, function()
    safeDoors[1] = createObject(2634, 1465.5418017578, -1003.3511962891, 14.8, 0, 0, 267 - 180)
    safeDoors[2] = createObject(2963, 1445.5886962891, -1001.7799682617, 14.230352401733, 0, 0, -1)
    safeDoors[3] = createObject(980, 1443.4004, -1002.4452, 23.042103, 0, 0, 90)
end)

local safeStart = {1481.3408203125, -1001.9315185547 + 0.6, 14.118314743042 - 0.55}
local safes = {}

addEventHandler("onResourceStart", resourceRoot, function()
    for i = 1, 21 do
        local safeX = safeStart[1]
        local safeY = safeStart[2] - 0.86 * (i - 1)
        local safeZ = safeStart[3] 

        if 7 < i then
            safeZ = safeZ + 0.93
            safeY = safeStart[2] - 0.86 * (i - 7 - 1)
        end

        if 14 < i then
            safeZ = safeZ + (0.93)
            safeY = safeStart[2] - 0.86 * (i - 14 - 1)
        end

        safes[i] = createObject(2332, safeX, safeY, safeZ, 0, 0, 270)
        setElementData(safes[i], "banksafe.id", i)
        setElementData(safes[i], "banksafe.robbed", false)
    end
end)

addCommandHandler("strain", function(player)
    if not bankTimer then
        local pX, pY, pZ = getElementPosition(player)
        local oX, oY, oZ = getElementPosition(safeDoors[2])
        if getDistanceBetweenPoints3D(pX, pY, pZ, oX, oY, oZ) <= 2 then
            if exports.fv_inventory:hasItem(player, 122, 1) then
                if getFactionMembers(53) > 9 then
                    setPedAnimation(player, "BOMBER", "BOM_Plant_Loop", -1, true, false, false)
                    sendFactionMessage(53, "The outer door of the bank safe has signaled!")
                    sendFactionMessage(54, "The outer door of the bank safe has signaled!")
                    triggerClientEvent(getElementsByType("player"), "triggerBankSound", player, "alarm2", {1444.7547607422, -1003.7462768555, 26.7421875})
                    setTimer(function() 
                        moveObject(safeDoors[2], 30000, oX, oY + 1.5, oZ)
                        
                        setPedAnimation(player)
                        bankTimer = setTimer(resetBankRob, 1000 * 60 * 60, 1)
                    end, 15000, 1)
                else
                    outputChatBox(exports.fv_engine:getServerSyntax("Bank","red") .. "Not enough cops!" ,player,255,255,255,true); 
                end
            else
                outputChatBox(exports.fv_engine:getServerSyntax("Bank","red") .. "You don't have a crowbar!" ,player,255,255,255,true); 
            end
        end
    end
end)

addCommandHandler("blast", function(player)
    if not bankTimer then
        return
    end

    local pX, pY, pZ = getElementPosition(player)
    local oX, oY, oZ = getElementPosition(safeDoors[1])
    if getDistanceBetweenPoints3D(pX, pY, pZ, oX, oY, oZ) <= 2 then
        if exports.fv_inventory:hasItem(player, 123, 1) then
            setPedAnimation(player, "BOMBER", "BOM_Plant_Loop", -1, true, false, false)
            exports.fv_inventory:takePlayerItem(player, 123, 1)

            setTimer(function()
                setPedAnimation(player)
            end, 3000, 1)

            setTimer(function()
                moveObject(safeDoors[1], 500, oX + 3, oY, oZ - 1.7, 90, 40, 0)
                createExplosion(oX, oY, oZ, 0)
                triggerClientEvent(getElementsByType("player"), "triggerBankSound", player, "alarm1", {1444.7547607422, -1003.7462768555, 26.7421875})
                sendFactionMessage(53, "The bank's internal security sensors detected an explosion.")
                sendFactionMessage(54, "The bank's internal security sensors detected an explosion.")
            end, 13000, 1)
        else
            outputChatBox(exports.fv_engine:getServerSyntax("Bank","red") .. "You don't have a C4!", player,255,255,255,true); 
        end
    end
end)

-- ** Util

function sendFactionMessage(fid, msg)
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"faction_"..fid) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Bank","red") .. msg ,v,255,255,255,true); 
        end
    end
end

function getFactionMembers(faction)
    local counter = 0
    for k, v in pairs(getElementsByType("player")) do
        if getElementData(v,"faction_"..faction) then 
            counter = counter + 1
        end
    end

    return counter
end

function resetBankRob()
    restartResource(getThisResource())
end

