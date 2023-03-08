local sql = exports.fv_engine:getConnection(getThisResource());
--ALTER TABLE `characters` ADD `weaponSkill` VARCHAR(255) NOT NULL DEFAULT ' [ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]' AFTER `icjail`; 


addEvent("skill.takeWeapons",true);
addEventHandler("skill.takeWeapons",root,function(player)
    takeAllWeapons(player);
    setElementData(player,"skilling",false);
end);

addEvent("skill.giveWeapon",true);
addEventHandler("skill.giveWeapon",root,function(player,data)
    giveWeapon(player,data[2],99999,true);
    setElementData(player,"skilling",true);
end);

addEvent("skill.updateSkill",true);
addEventHandler("skill.updateSkill",root,function(player,id,value)
    setPedStat(player,weapons[id][3],value);
    local current_data = getElementData(player,"char.weaponSkills") or fromJSON("[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]");
    current_data[id] = value;
    setElementData(player,"char.weaponSkills",current_data);

    dbExec(sql,"UPDATE characters SET weaponSkill=? WHERE id=?",toJSON(current_data),getElementData(player,"acc >> id"));
end);


addEventHandler("onResourceStart",resourceRoot,function()
    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"loggedIn") then 
            loadPlayerSkills(v);
        end
    end
end);

addEventHandler("onElementDataChange",root,function(dataName)
    if getElementType(source) == "player" then 
        if dataName == "loggedIn" and getElementData(source,"loggedIn") then 
            loadPlayerSkills(source);
        end
    end
end);

function loadPlayerSkills(player)
    if getElementData(player,"acc >> id") > 0 then 
        dbQuery(function(qh)
            local res = dbPoll(qh,0);
            for k,v in pairs(res) do 
                local data = fromJSON(v.weaponSkill);
                if data then 
                    for id, value in pairs(data) do 
                        setPedStat(player,weapons[id][3],value);
                    end
                    setElementData(player,"char.weaponSkills",data);
                end
                outputDebugString("WEAPON SKILL -> "..getPlayerName(player).." skills loaded!",0,50,100,50);
            end
        end,sql,"SELECT id, weaponSkill FROM characters WHERE id=?",getElementData(player,"acc >> id"));
    end
end

addEvent("skill.setDim",true);
addEventHandler("skill.setDim",root,function(player,dim)
    setElementDimension(player,dim);
end);