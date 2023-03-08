local alarms = {}

addEvent("triggerBankSound", true)
addEventHandler("triggerBankSound", root, function(sound, position)
    if sound and position then
        alarms[sound] = playSound3D(sound .. ".mp3", position[1], position[2], position[3], true)
        setSoundVolume(alarms[sound], 2)
        setSoundMinDistance(alarms[sound], 0)
        setSoundMaxDistance(alarms[sound], 300)
    elseif sound then
        if isElement(alarms[sound]) then
            destroyElement(alarms[sound])
            alarms[sound] = nil
        end
    end
end)


local fonts = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
    

    if isElement(fonts.Roboto21) then
        destroyElement(fonts.Roboto21)
        fonts.Roboto21 = nil
    end
    fonts.Roboto21 = dxCreateFont(":fv_job_hotdog/files/Roboto-Regular.ttf", respc(21))

    if isElement(fonts.Roboto11) then
        destroyElement(fonts.Roboto11)
        fonts.Roboto11 = nil
    end
    fonts.Roboto11 = dxCreateFont(":fv_job_hotdog/files/Roboto-Regular.ttf", respc(11))

    if isElement(fonts.Roboto14) then
        destroyElement(fonts.Roboto14)
        fonts.Roboto14 = nil
    end
    fonts.Roboto14 = dxCreateFont(":fv_job_hotdog/files/Roboto-Regular.ttf", respc(14))
end)

local responsiveMultipler = exports.fv_hud:getResponsiveMultipler()

function respc(v)
    return math.ceil(v * responsiveMultipler)
end

function resp(v)
    return v * responsiveMultipler
end


local clickedSafe = nil
local screenX, screenY = guiGetScreenSize()
local keys = {"A", "S", "D", "E", "F", "G", "H", "J", "Q", "W", "E", "R", "T", "Z", "U"}
local currentKey = nil
local minigame = false
local keyCounter = 0
local done = false

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
        if not minigame and keyCounter == 0 then
            if button == "left" and state == "down" then
                if clickedElement and getElementModel(clickedElement) == 2332 then
                    if getElementData(clickedElement, "banksafe.id") then
                        local pX, pY, pZ = getElementPosition(localPlayer)
                        local oX, oY, oZ = getElementPosition(clickedElement)
                        if getDistanceBetweenPoints3D(pX, pY, pZ, oX, oY, oZ) <= 2 then
                            if getElementData(clickedElement, "banksafe.robbed") then
                                outputChatBox(exports.fv_engine:getServerSyntax("Bank","red").."This safe has been looted",255,255,255,true);
                            else
                                showMinigame(clickedElement)
                            end
                        end
                    end
                end
            end
        end
end)

function showMinigame(safe)
    showChat(false)
    setControl(false)
    currentKey = math.random(1, #keys)
    minigame = true
    setElementData(safe, "banksafe.robbed", true)
    addEventHandler("onClientRender", root, renderMinigame)
    addEventHandler("onClientKey", root, keyMinigame)
end

function keyMinigame(key, pressed)
    if key == string.lower(keys[currentKey]) and pressed then
        if keyCounter == 30 then
            removeEventHandler("onClientRender", root, renderMinigame)
            keyCounter = 0
            minigame = false
            exports.fv_engine:giveMoney(localPlayer, math.random(5000, 7000))
            removeEventHandler("onClientKey", root, keyMinigame)
            setControl(true)
            showChat(true)
            return
        end

        currentKey = math.random(1, #keys)
        keyCounter = keyCounter + 1

        print(keyCounter)
    end
end

function renderMinigame()
    dxDrawText("Press [" .. keys[currentKey] .. "] key", 0, 0, screenX, screenY, tocolor(255, 255, 255), 1, fonts.Roboto14, "center", "center")
end

function setControl(state)
    toggleControl("accelerate",state);
    toggleControl("brake",state);
    toggleControl("enter_exit",state);
    toggleControl("sprint",state);
    toggleControl("jump",state);
    toggleControl("crouch",state);
    toggleControl("fire",state);
    toggleControl("enter_passenger",state);
    if state then 
        exports.fv_dead:reloadBones();
    end
end
