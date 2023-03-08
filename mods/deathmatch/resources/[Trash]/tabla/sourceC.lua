local shaders = {}
function applyShader(texture, img)
	this = #shaders + 1
	shaders[this] = {}
	shaders[this][1] = dxCreateShader ( "new.fx" )
	shaders[this][2] = dxCreateTexture ( img )
	if shaders[this][1] and shaders[this][2] then
		dxSetShaderValue ( shaders[this][1], "CUSTOMTEX0", shaders[this][2] )
		if shaders[this][1] then
			engineApplyShaderToWorldTexture ( shaders[this][1], texture )
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	applyShader("allsaints_law", "images/allsaints_law.png")
	applyShader("airport1_64", "images/airport1_64.png")
	applyShader("airport2_64", "images/airport2_64.png")
end)