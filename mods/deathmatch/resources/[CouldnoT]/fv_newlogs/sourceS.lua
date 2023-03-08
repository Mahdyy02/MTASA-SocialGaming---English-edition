addEventHandler("onConsole", root, function(text)
    if getElementType(source) == "player" then
        local params = split(text, 32)
        local command = params[1]

        local fullString = table.concat(params, " ")
        outputChatBox("Your command: /" .. fullString, source)
    end
end)
