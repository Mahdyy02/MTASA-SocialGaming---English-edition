addEvent("cam.setPos",true);
addEventHandler("cam.setPos",root,function(player,int,dim)
    setElementInterior(player,int);
    setElementDimension(player,dim);
end);