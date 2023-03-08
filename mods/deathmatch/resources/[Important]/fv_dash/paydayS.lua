function givePayDay(player)
    if not getElementData(player,"network") then return end;
    local bankMoney = getElementData(player,"char >> bankmoney");
    local bankKamat = math.floor(bankMoney * 0.01);
    local bankKezeles = math.floor(bankMoney * 0.003);
    local all = bankKamat;

    local jarmuAdo = 0;
    for k,v in pairs(getElementsByType("vehicle")) do 
        if getElementData(v,"veh:faction") == 0 then
            if getElementData(v,"veh:tulajdonos") == getElementData(player,"acc >> id") then 
                jarmuAdo = jarmuAdo + 1;
            end
        end
    end
    jarmuAdo = jarmuAdo * 50;

    local green = exports.fv_engine:getServerColor("servercolor",true);
    local blue = exports.fv_engine:getServerColor("blue",true);
    local red = exports.fv_engine:getServerColor("red",true);


    outputChatBox(blue..">>>>> PAYMENT <<<<<",player,255,255,255,true);

    outputChatBox(green.."~"..white.." Vehicle tax: "..red..formatMoney(jarmuAdo)..white.." dt.",player,255,255,255,true);
    exports.fv_dash:giveFactionMoney(23,jarmuAdo);
    setElementData(player,"char >> money",getElementData(player,"char >> money") - jarmuAdo);

    outputChatBox(green.."~"..white.." Bank interest: "..green..formatMoney(bankKamat)..white.." dt.",player,255,255,255,true);
    outputChatBox(green.."~"..white.." Bank handling fee: "..red..formatMoney(bankKezeles)..white.." dt.",player,255,255,255,true);

    for k,v in pairs(factions) do 
        if getElementData(player,"faction_"..k) then
            if v[2] > 2 then 
                local rank = getElementData(player,"faction_"..k.."_rank");
                if rank > 0 then 
                    local payment = v[4][rank][2];
                    if payment and tonumber(payment) and tonumber(v[3]) and tonumber(v[3]) > tonumber(payment) then 
                        outputChatBox(blue.."- "..green..v[1].. " Payment: "..green..formatMoney(payment)..white.." dt.",player,255,255,255,true);
                        all = all + payment;
                        setElementData(player,"char >> money",getElementData(player,"char >> money") + payment);
                        if factions[k][3] then 
                            factions[k][3] = factions[k][3] - payment;
                            dbExec(sql,"UPDATE factions SET vallet=? WHERE id=?",factions[k][3],k);
                        end
                    else 
                        outputChatBox(blue.."- "..red..v[1]..white.. " Payment: "..green.."0"..white.." dt. (There is no money in the faction account or your rank is incorrect.)",player,255,255,255,true);
                    end
                end
            end
        end
    end

    setElementData(player,"char >> bankmoney",getElementData(player,"char >> bankmoney") + bankKamat);
    setElementData(player,"char >> bankmoney",getElementData(player,"char >> bankmoney") - bankKezeles);
    
    outputChatBox("Altogether: "..green..formatMoney(all)..white.." dt.",player,255,255,255,true);
end
addEvent("payday.give",true);
addEventHandler("payday.give",root,givePayDay);