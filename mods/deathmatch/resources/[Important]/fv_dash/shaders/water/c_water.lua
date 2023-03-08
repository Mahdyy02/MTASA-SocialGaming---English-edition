local waterShader,tec = false;
function startWaterRefract()
	if getVersion ().sortable < "1.1.0" then
		return
	end
	waterShader, tec = dxCreateShader ( "shaders/water/water.fx" )

	if not waterShader then
		return
	else
		local textureVol = dxCreateTexture ( "shaders/water/images/smallnoise3d.dds" );
		local textureCube = dxCreateTexture ( "shaders/water/images/cube_env256.dds" );
		dxSetShaderValue ( waterShader, "sRandomTexture", textureVol );
		dxSetShaderValue ( waterShader, "sReflectionTexture", textureCube );

		engineApplyShaderToWorldTexture (waterShader, "waterclear256");
		
		timer = setTimer(
		function()
			if isElement(waterShader) then
				local r,g,b,a = getWaterColor();
				dxSetShaderValue ( waterShader, "sWaterColor", r/255, g/255, b/255, a/255 );
			end
		end,100,0 );
	end
end

function stopWaterRefract()
	if isElement(waterShader) then
		destroyElement(waterShader);
		waterShader,tec = false,false;
	end
end