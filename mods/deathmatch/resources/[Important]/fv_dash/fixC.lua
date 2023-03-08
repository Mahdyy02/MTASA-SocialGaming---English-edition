setAmbientSoundEnabled( "general", false )
setAmbientSoundEnabled( "gunfire", false )

--PED alatti árnyék törlés + Kocsi alatti árnyék törlés.
local texture = dxCreateTexture(1, 1);
local shader = dxCreateShader("shader.fx");
addEventHandler("onClientResourceStart",resourceRoot,function()
	engineApplyShaderToWorldTexture(shader, "shad_ped");
	engineApplyShaderToWorldTexture(shader, "shad_car");
	dxSetShaderValue(shader, "reTexture", texture);
end);

addEventHandler("onClientResourceStop", resourceRoot,
function ()
	engineRemoveShaderFromWorldTexture(shader, "shad_ped");
	engineRemoveShaderFromWorldTexture(shader, "shad_car");
end);
