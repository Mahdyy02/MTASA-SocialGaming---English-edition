local mysql = exports.fv_engine:getConnection(getThisResource());

addEvent("ppshop.buy",true);
addEventHandler("ppshop.buy",root,function(player,itemdata,money)
if getElementData(player,"network") then 
    if not money then 
        local itemAdd = exports.fv_inventory:givePlayerItem(player,itemdata[1],itemdata[2],100,100,0);
        if itemAdd then 
            dbExec(mysql,"UPDATE characters SET premiumPoints=? WHERE id=?",getElementData(player,"char >> premiumPoints")-itemdata[3],getElementData(player,"acc >> id"));

            setElementData(player,"char >> premiumPoints",getElementData(player,"char >> premiumPoints") - itemdata[3]);
            exports.fv_infobox:addNotification(player,"info","Successful purchase!");                         
        else 
            exports.fv_infobox:addNotification(player,"error","There is no space in your inventory!");                        
        end
    else 
        dbExec(mysql,"UPDATE characters SET premiumPoints=? WHERE id=?",getElementData(player,"char >> premiumPoints")-itemdata[3],getElementData(player,"acc >> id"));
        setElementData(player,"char >> premiumPoints",getElementData(player,"char >> premiumPoints") - itemdata[3]);
        setElementData(player,"char >> money",getElementData(player,"char >> money") + itemdata[1]);
        exports.fv_infobox:addNotification(player,"info","Successful purchase!");       
    end
end
end);

