function disableAllTypeOfSpeakingOnTheStart()
    for k, element in pairs(getElementsByType("player")) do
        setPedVoice(element, "PED_TYPE_DISABLED")
    end
    
    for k, element in pairs(getElementsByType("ped")) do
        setPedVoice(element, "PED_TYPE_DISABLED")
    end
end
addEventHandler("onClientResourceStart", resourceRoot, disableAllTypeOfSpeakingOnTheStart)

function disableAllTypeOfSpeakingOnStream()
    if getElementType(source) == "player" or getElementType(source) == "ped" then
        setPedVoice(source, "PED_TYPE_DISABLED")
    end
end
addEventHandler("onClientElementStreamIn", root, disableAllTypeOfSpeakingOnStream)