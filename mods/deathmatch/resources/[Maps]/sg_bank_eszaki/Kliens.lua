if fileExists("Kliens.lua") then
	fileDelete("Kliens.lua")
end
if fileExists("Kliens.luac") then
	fileDelete("Kliens.luac")
end

addEventHandler("onClientResourceStart", root, function()
	engineSetAsynchronousLoading(true, true)
	setOcclusionsEnabled(false)
end)

local dir = "models"
function loadMod(f, m, isLod)
	local txdFile = dir.."/"..f..".txd"
	local dffFile = dir.."/"..f..".dff"
	local colFile = dir.."/"..f..".col"
	if fileExists(txdFile) then
		local txd = EngineTXD(txdFile)
		if txd then
			txd:import(m)
		end
	end
	if fileExists(dffFile) then
		local dff = EngineDFF(dffFile,m)
		if dff then
			dff:replace(m)
		end
	end
	if not isLod then
		if fileExists(colFile) then
			local col = EngineCOL(colFile)
			if col then
				col:replace(m)
			end
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Modellezések
	loadMod("bank", 4600) -- bank
	loadMod("eszaki", 5853) --  eszaki
end)