local renderTarget = dxCreateRenderTarget(sx,sy,true);
local edgeShader = dxCreateShader("fx/post_edge.fx");
local edgeCache = {};
dxSetShaderValue(edgeShader, "sTex0", renderTarget);
dxSetShaderValue(edgeShader, "sRes", sx, sy);

function addElementEdge(element,color)
    if not color then color = {255,255,255} end;
    if not color[4] then color[4] = 255 end;  
    if edgeCache[element] then 
        destroyElement(edgeCache[element]);
        edgeCache[element] = nil;
    end
    local elementType = getElementType(element);
    if elementType == "player" then 
        elementType = "ped";
    end

    local pedShader = dxCreateShader("fx/ped_wall_mrt.fx", 1, 0, true, elementType);
    dxSetShaderValue(pedShader, "secondRT", renderTarget);
    dxSetShaderValue(pedShader, "sColorizePed", {color[1]/255,color[2]/255,color[3]/255,color[4]/255});
    engineApplyShaderToWorldTexture(pedShader, "*" , element);
    engineRemoveShaderFromWorldTexture(pedShader,"muzzle_texture*", element);

    edgeCache[element] = pedShader;
end

function destroyElementEdge(element)
    if edgeCache[element] then 
        destroyElement(edgeCache[element]);
        edgeCache[element] = nil;
    end
end

setTimer(function()
    for element,shader in pairs(edgeCache) do 
        if not element or not isElement(element) then 
            destroyElementEdge(element);
        end
    end
end,1000,0);

-- addEventHandler("onClientPreRender", root, function()
--     dxSetRenderTarget(renderTarget, true);
--     dxSetRenderTarget();
-- end,true,"high");


-- addEventHandler("onClientHUDRender",root,function()
--     if #edgeCache > 0 then
--         dxDrawImage( 0, 0, sx, sy, edgeShader);
--     end
-- end);

addEventHandler( "onClientPreRender", root,function()
    dxSetRenderTarget( renderTarget, true )
    dxSetRenderTarget()
end, true, "high" );

addEventHandler( "onClientHUDRender", root, function()
    dxDrawImage( 0, 0, sx, sy, edgeShader );
end);