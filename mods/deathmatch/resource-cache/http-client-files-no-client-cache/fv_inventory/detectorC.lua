local cols = {
    --x,y,z,size, x,y,z (ide dob vissza),
    {1419.1638183594, -1675.4705810547, 13.70937538147, 1.5, "Town hall"},
    {1477.2573242188, -1766.3538818359, 13.8046875, 2, "Mall"},
    {1927.8941650391, -1773.0484619141, 13.50156211853, 2, "South gas station"},
    {999.80499267578, -920.05755615234, 42.2109375, 2, "North gas station"},
    {1462.1895751953, -1009.8286132813, 26.838701248169, 2, "Bank"},
    {-77.091575622559, -1178.6381835938, 2.1859374046326, 2, "Flint County Gas station"},
    {-1679.5191650391, 418.44326782227, 7.2859373092651, 2, "Easter Basin Gas station"},
    {-1602.1589355469, -2709.3029785156, 48.5859375, 2, "Whetstone Gas station"},
}

addEventHandler("onClientResourceStart",resourceRoot,function()
    for k, v in pairs(cols) do 
        local col = createColSphere(v[1],v[2],v[3],v[4]);
        addEventHandler("onClientColShapeHit",col,function(hitElement,dim)
            if hitElement == localPlayer then 
                for j,l in pairs(fegyverek) do 
                    if not l[3] then 
                        if hasItem(j) then 
                            triggerServerEvent("detector.alert",localPlayer,localPlayer,v[5],getItemName(j));
                            break;
                        end
                    end
                end
            end
        end);
    end
end);   