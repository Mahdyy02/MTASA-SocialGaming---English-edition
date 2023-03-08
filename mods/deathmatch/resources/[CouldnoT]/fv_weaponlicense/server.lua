local sql = exports.fv_engine:getConnection(getThisResource());

addEvent("wlicense.buy",true);
addEventHandler("wlicense.buy",root,function(player,price,type)
    --itemID, count, value, state, table, slot)

    local rt = getRealTime();
    local year = 1900+rt.year;
    local day = rt.monthday;
    local month = rt.month+1;
    if day < 10 then 
        day = "0"..day;
    end
    local endYear = year;
    local endMonth = month + 1;
    if endMonth > 12 then 
        endYear = endYear + 1;
        endMonth = 1;
    end
    if endMonth < 10 then 
        endMonth = "0"..endMonth;
    end
    if month < 10 then 
        month = "0"..month;
    end
    endYear = endYear .."."..endMonth.."."..day;


    local cardData = {
        getElementData(player,"char >> name"), 
        type,
        year.."."..month.."."..day..".",
        endYear,
    }
    if exports.fv_inventory:givePlayerItem(player,107,1,1,100,{0,cardData}) then 
        setElementData(player,"char >> money",getElementData(player,"char >> money") - price);
        outputChatBox(exports.fv_engine:getServerSyntax("WeaponLicense","servercolor").."You have successfully redeemed your license.",player,255,255,255,true);
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("WeaponLicense","red").."The subject does not fit you!",player,255,255,255,true);
    end
end);



addEvent("wShop.buy",true);
addEventHandler("wShop.buy",root,function(player,item)
    if exports.fv_inventory:givePlayerItem(player,item[3],1,1,100,0) then 
        setElementData(player,"char >> money",getElementData(player,"char >> money") - item[2]);
        outputChatBox(exports.fv_engine:getServerSyntax("WeaponShop","servercolor").."You have successfully purchased an item. ("..exports.fv_engine:getServerColor("blue",true)..item[1]..white..")",player,255,255,255,true);
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("WeaponShop","red").."The object does not fit you!",player,255,255,255,true);
    end
end);