local textures = {
    "white256",
};

addEventHandler("onClientResourceStart", getResourceRootElement(), function()
    for k, textureName in pairs(textures) do
        local shader = dxCreateShader("shader.fx");
        local texture = dxCreateTexture("files/"..textureName..".png","dxt5");
        dxSetShaderValue(shader, "Tex0", texture)
        engineApplyShaderToWorldTexture(shader, textureName);
    end

    removeWorldModel(1896,9999,0,0,0);
    removeWorldModel(1897,9999,0,0,0);
    removeWorldModel(1895,9999,0,0,0);
    removeWorldModel(1898,9999,0,0,0);
end);

