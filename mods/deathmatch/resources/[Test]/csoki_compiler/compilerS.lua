local resources = {}
local lastResource = 0
local rovid = "#7cc576[SocialGaming]:#FFFFFF"
function compileResource(res)
	local xmlPatch = ":"..res.."/meta.xml"
	local xmlFile = xmlLoadFile(xmlPatch)
	if xmlFile then
		outputDebugString("RESOURCE: "..res,0,55,167,220)
		local index = 0
		local scriptNode = xmlFindChild(xmlFile,'script',index)
		if scriptNode then
			repeat
			local scriptPath = xmlNodeGetAttribute(scriptNode,'src') or false
			local scriptType = xmlNodeGetAttribute(scriptNode,'type') or "server"
			local serverEncypt = xmlNodeGetAttribute(scriptNode,'encypt') or "null"
			if scriptPath and ((scriptType:lower() == "client" or scriptType:lower() == "shared") or serverEncypt:lower() == "true") then
				if string.find(scriptPath:lower(), "luac") then
					outputDebugString("PROTECTION: Fájl "..scriptPath.." már levédett!",3,220,20,20)
				else
					local FROM=":"..res.."/"..scriptPath
					local TO= ":"..res.."/"..scriptPath.."c"
					fetchRemote("http://luac.mtasa.com/?compile=1&debug=0&obfuscate=1", function(data) fileSave(TO,data) end, fileLoad(FROM), true)
					xmlNodeSetAttribute(scriptNode,'src',scriptPath..'c')
					if serverEncypt:lower() == "true" then
						if fileExists(FROM) then
							outputDebugString("PROTECTION: ".. FROM.." törölve. (encypt = true)",3,0,255,0)
							fileDelete(FROM)
						end
					end
					outputDebugString("PROTECTION: ".. TO.." Levédve és elmentve",3,0,255,0)
				end
			end
			index = index + 1
			scriptNode = xmlFindChild(xmlFile,'script',index)
			until not scriptNode
		end
		xmlSaveFile(xmlFile)
		xmlUnloadFile(xmlFile)
	else
		outputDebugString("PROTECTION: Nem olvasható: meta.xml",3,220,20,20)
		return false
	end
end

function decryptString( cmd, theString, theKey )
    if ( theString ) and ( theKey ) then
        local decodedString = teaDecode( theString, theKey ) -- Decode the string with the key
        print( "The decoded string is: " .. tostring( decodedString ) )
    else
        print( "Syntax: /" .. cmd .. " [string] [key]" )
    end
end
addCommandHandler( "teadecrypt", decryptString )

function uncompileResource(res)
	local xmlPatch = ":"..res.."/meta.xml"
	local xmlFile = xmlLoadFile(xmlPatch)
	if xmlFile then
		outputDebugString("RESOURCE: "..res,0,55,167,220)
		local index = 0
		local scriptNode = xmlFindChild(xmlFile,'script',index)
		if scriptNode then
			repeat
			local scriptPath = xmlNodeGetAttribute(scriptNode,'src') or false
			local scriptType = xmlNodeGetAttribute(scriptNode,'type') or "server"
			if scriptPath and scriptType:lower() == "client" then
				if string.find(scriptPath:lower(), "luac") then
					fileDelete(":"..res.."/"..scriptPath)
					xmlNodeSetAttribute(scriptNode,'src',scriptPath:gsub("luac","lua"))
					outputDebugString("PROTECTION: "..res.."/"..scriptPath .." no longer protected!",0,255,0,0)
				else
					outputDebugString("PROTECTION: File "..scriptPath.." no longer protected!",3,220,20,20)
				end
			end
			index = index + 1
			scriptNode = xmlFindChild(xmlFile,'script',index)
			until not scriptNode
		end
		xmlSaveFile(xmlFile)
		xmlUnloadFile(xmlFile)
	else
		outputDebugString("PROTECTION: Not readable: meta.xml",3,220,20,20)
		return false
	end
end

addCommandHandler("compileall", function(player,cmd,res)
	if getElementData(player,"admin >> level") >= 8 then
		resources = getResources()
		lastResource = 0
		compileNextResource()
	end
end)

function unCompileNext()
	if lastResource < #resources then
		lastResource = lastResource + 1
		uncompileResource(getResourceName(resources[lastResource]))
		setTimer(unCompileNext, 1000, 1)
	end
end

function compileNextResource()
	if lastResource < #resources then
		lastResource = lastResource + 1
		compileResource(getResourceName(resources[lastResource]))
		setTimer(compileNextResource, 1000, 1)
	end
end

addCommandHandler("compile", function(player,cmd,res)
	--if getElementData(player,"admin >> level") >= 8 then
		local resource = getResourceFromName(res)
		if resource then
			outputChatBox(rovid.." #FFFFFFResource levédése folyamatban ...", player, 0, 255, 0, true)
			compileResource(res)
			outputChatBox(rovid.." #FFFFFFResource levédve!", player, 0, 255, 0, true)
		else
			outputChatBox(rovid.." #FFFFFFNem található ilyen resource!", player, 255, 0, 0, true)
		end
	--end
end)

addCommandHandler("uncompile", function(player,cmd,res)
	--if getElementData(player,"admin >> level") >= 8 then
		local resource = getResourceFromName(res)
		if resource then
			outputChatBox(rovid.." #FFFFFFResource levédés levétel folyamatban ...", player, 0, 255, 0, true)
			uncompileResource(res)
			outputChatBox(rovid.." #FFFFFFResource levédés levéve!", player, 0, 255, 0, true)
		else
			outputChatBox(rovid.." #FFFFFFNem található ilyen resource!", player, 255, 0, 0, true)
			print("No such resource found")
		end
	--end
end)

function fileLoad(path)
    local File = fileOpen(path, true)
    if File then
        local data = fileRead(File, 500000000)
        fileClose(File)
        return data
    end
end
 
function fileSave(path, data)
    local File = fileCreate(path)
    if File then
        fileWrite(File, data)
        fileClose(File)
    end
end