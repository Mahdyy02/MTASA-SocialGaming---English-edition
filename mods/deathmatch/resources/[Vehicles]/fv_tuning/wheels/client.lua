function loadWheelModel(name,id)
    local txd = engineLoadTXD("wheels/wheel.txd");
    engineImportTXD(txd, id) 
    local dff = engineLoadDFF("wheels/"..name..".dff", id);
    engineReplaceModel(dff, id);
end
addEventHandler("onClientResourceStart",resourceRoot,function()
    loadWheelModel("wheel_gn1",1025);
    loadWheelModel("wheel_gn2",1073);
    loadWheelModel("wheel_gn3",1074);
    loadWheelModel("wheel_gn4",1075);
    loadWheelModel("wheel_gn5",1076);

    loadWheelModel("wheel_lr1",1077);
    loadWheelModel("wheel_lr2",1078);
    loadWheelModel("wheel_lr3",1079);
    loadWheelModel("wheel_lr4",1077);
    loadWheelModel("wheel_lr5",1081);

    loadWheelModel("wheel_or1",1082);

    loadWheelModel("wheel_sr1",1083);
    loadWheelModel("wheel_sr2",1084);
    loadWheelModel("wheel_sr3",1085);
    loadWheelModel("wheel_sr4",1096);
    loadWheelModel("wheel_sr5",1097);
    loadWheelModel("wheel_sr6",1098);
end);