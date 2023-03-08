local sql = exports.fv_engine:getConnection(getThisResource());

addEvent("junk.destroy",true);
addEventHandler("junk.destroy",root,function(player,veh,money)
if getElementData(player,"network") then 
    local id = getElementData(veh,"veh:id");
    dbExec(sql,"DELETE FROM jarmuvek WHERE id=?",id);
    destroyElement(veh);
    setElementData(player,"char >> money",getElementData(player,"char >> money") + money);

    local sColor = exports.fv_engine:getServerColor("servercolor",true);
    local white = "#FFFFFF";
    exports.fv_logs:createLog("Destroy",getElementData(player,"char >> name").. " destroyed a vehicle. ID: "..id..white.." Amount of money: "..formatMoney(money).." dt.",player);
    exports.fv_admin:sendMessageToAdmin(player,sColor..getElementData(player,"admin >> name")..white.." crushed a vehicle. ID: "..sColor..id..white..". Amount of money: "..sColor..formatMoney(money)..white.." dt.",3);
end
end)

--UTILS--
function formatMoney(amount)
    amount = tonumber(amount);
    if not amount then 
        return "";
    end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end