addEventHandler("onResourceStart",getRootElement(),function(res)
	if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        sColor = exports.fv_engine:getServerColor("servercolor",true);
        white = "#FFFFFF";
	end
end);

addEvent("ticket.sendOther",true);
addEventHandler("ticket.sendOther",root,function(player,target,datas)
    if target == player then 
        outputChatBox(exports.fv_engine:getServerSyntax("Ticket","red").."You can't punish yourself.",player,255,255,255,true);
        return;
    end

    triggerClientEvent(target,"ticket.showClient",target,datas);
    setElementData(target,"ticket.value",datas[1]);
    setElementData(target,"char >> money",getElementData(target,"char >> money") - datas[1]); --Instant levonja

    if getElementData(player,"faction_54") then 
        exports.fv_dash:giveFactionMoney(2,datas[1]);
    elseif getElementData(player,"faction_53") then 
        exports.fv_dash:giveFactionMoney(17,datas[1]);
    end

    exports.fv_logs:createLog("Ticket",getElementData(player,"char >> name").. " megbüntette: "..getElementData(target,"char >> name").." játékost. Indok: "..datas[5]..". Összeg: "..formatMoney(datas[1]).." $.",player,target);
    exports.fv_admin:sendMessageToAdmin(player,sColor..getElementData(player,"char >> name")..white.. " megbüntette: "..sColor..getElementData(target,"char >> name")..white.." játékost. Indok: "..sColor..datas[5]..white..". Összeg: "..sColor..formatMoney(datas[1])..white.." $.",3);
end);   

addEvent("ticket.pay",true);
addEventHandler("ticket.pay",root,function(player,value)
    setElementData(player,"ticket.value",false);
    outputChatBox(exports.fv_engine:getServerSyntax("Ticket","servercolor").."You have successfully paid the fine!",player,255,255,255,true);
    outputChatBox(exports.fv_engine:getServerSyntax("Ticket","blue")..sColor..getElementData(player,"char >> name")..white.." You paid the fine!",value[7],255,255,255,true);
end);

--[[addEventHandler("onPlayerQuit",getRootElement(),function()
    if getElementData(source,"ticket.value") then 
        exports.fv_admin:sendMessageToAdmin(source,sColor..getElementData(source,"char >> name")..white.. " kilépett és nem fizette ki a ticketet! Összeg: "..sColor..formatMoney(datas[1])..white.." $.",3);
        exports.fv_logs:createLog("Ticket_Leave",getElementData(source,"char >> name").. " kilépett és nem fizette ki a ticketet!. Összeg: "..formatMoney(datas[1]).." $.",player);
    end
end);]]

