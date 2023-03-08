addEventHandler("onClientResourceStart", root, function()
    engineSetAsynchronousLoading ( true, true )
    setOcclusionsEnabled(false)

    for k,v in pairs(getElementsByType("object")) do 
        setObjectBreakable(v,false);
        if getElementModel(v) == 1370 then 
            destroyElement(v);
        end
    end
end)


removeWorldModel(5681,1000,1913.3563232422, -1777.7875976563, 14.915580749512) --Autómosó délin

removeWorldModel(1370,1000,-59.463508605957, -1568.5483398438, 2.6171875);
removeWorldModel(4174,10000,0,0,0);
removeWorldModel(4217,10000,0,0,0);
removeWorldModel(4214,10000,0,0,0);
removeWorldModel(4172,10000,0,0,0);
removeWorldModel(4231,10000,0,0,0);
removeWorldModel(4748,10000,0,0,0);