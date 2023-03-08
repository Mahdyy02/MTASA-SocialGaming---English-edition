local sql = exports.fv_engine:getConnection(getThisResource());
local white = "#FFFFFF";
local shops = {};


function loadShop(id)
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        if #result > 0 then 
            for k,v in pairs(result) do 
                local pos = fromJSON(v.pos);
                if not pos or not pos[1] then 
                    dbExec(sql,"DELETE FROM boltok WHERE id=?",v.id);
                    outputDebugString("Shop: "..v.id.." loading failed! SQL data deleted!",0,200,0,0);
                    return;
                end
                local ped = createPed(v.skin,pos[1],pos[2],pos[3],pos[4]);
                setElementDimension(ped,pos[5]);
                setElementInterior(ped,pos[6]);
                setElementFrozen(ped,true);

                setElementData(ped,"shop.id",v.id);
                setElementData(ped,"shop.type",v.type);
                setElementData(ped,"ped >> name","");
                local gender = exports.fv_dx:getSkinGender(v.skin);
                exports.fv_dx:getRandomName(ped,gender);

                setElementData(ped,"ped >> type","Boltos");
                setElementData(ped,"ped.noDamage",true);

                shops[v.id] = ped;
            end
        end
    end,sql,"SELECT * FROM boltok WHERE id=?",id);
end

function loadAllShop()
    dbQuery(function(qh)
        local counter = 0;
        local result = dbPoll(qh,0);
        if #result > 0 then 
            for k,v in pairs(result) do 
                loadShop(v.id);
                counter = counter + 1;
            end
            outputDebugString("Shops: "..counter.." shop loaded!");
        end
    end,sql,"SELECT id FROM boltok");
end
addEventHandler("onResourceStart",resourceRoot,loadAllShop);


addEvent("shop.buy",true);
addEventHandler("shop.buy",root,function(player,item)
    if not getElementData(player,"network") then return end;
    if item[1] == 1 then 
        exports.fv_phone:newPhone(player,item[2]);
    else 
        local suc = exports.fv_inventory:givePlayerItem(player,item[1],1,1,100,0);
        if suc then 
            setElementData(player,"char >> money",getElementData(player,"char >> money")-item[2]);
            outputChatBox(exports.fv_engine:getServerSyntax("Shop","servercolor").."Successful purchase!",player,255,255,255,true);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Shop","red").."Unsuccessful purchase! There is no place in the inventory!",player,255,255,255,true);
        end
    end
end);

--Parancsok--
function makeShop(player,command,type,name)
    if getElementData(player,"admin >> level") > 10 then 
        if not type or not tonumber(type) or not name or tonumber(type) > #types or tonumber(type) < 0 then
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Type] [npc name]",player,255,255,255,true);
            for k,v in ipairs(types) do 
                outputChatBox(exports.fv_engine:getServerSyntax("Type","red")..k.." - "..v,player,255,255,255,true);
            end
            return
        end;
        local type = math.floor(tonumber(type));
        local x,y,z = getElementPosition(player);
        local _,_,rot = getElementRotation(player);
        local interior,dimension = getElementInterior(player),getElementDimension(player);
        local allSkin = getValidPedModels();
        local skin = allSkin[math.random(1,#allSkin)];
        dbQuery(function(qh)
            local result,_,id = dbPoll(qh,0);
            if id then 
                loadShop(id);
                local sColor = exports.fv_engine:getServerColor("servercolor",true);
                outputChatBox(exports.fv_engine:getServerSyntax("Shop","servercolor").."You have successfully unloaded a shop! ID: "..sColor..id..white..".",player,255,255,255,true);
                exports.fv_logs:createLog("MAKESHOP",exports.fv_admin:getAdminName(player).. " He set up a shop. ID: "..id.." , Type: "..types[type]..".",player);
                exports.fv_admin:sendMessageToAdmin(player,sColor..getElementData(player,"admin >> name")..white.." created a store ID: "..sColor..id..white..", Type: "..sColor..(types[type])..white..".",3);
            else 
                outputChatBox(exports.fv_engine:getServerSyntax("Shop","red").."Shop creation failed. MySQL error!",player,255,255,255,true);
            end
        end,sql,"INSERT INTO boltok SET skin=?, pos=?, type=?, name=?",skin,toJSON({x,y,z,rot,dimension,interior}),type,tostring(name));
    end
end
addCommandHandler("makeshop",makeShop,false,false);
addCommandHandler("addshop",makeShop,false,false);
addCommandHandler("createshop",makeShop,false,false);

function nearbyShops(player,command)
    if getElementData(player,"admin >> level") > 10 then 
        local px,py,pz = getElementPosition(player);
        local counter = 0;
        local sColor = exports.fv_engine:getServerColor("servercolor",true);
        outputChatBox(exports.fv_engine:getServerSyntax("Shop","servercolor").."Nearby stores: ",player,255,255,255,true);
        for k,v in pairs(getElementsByType("ped",resourceRoot,true)) do 
            if getElementData(v,"shop.type") or false then 
                local x,y,z = getElementPosition(v);
                local distance = getDistanceBetweenPoints3D(px,py,pz,x,y,z);
                if distance < 15 then 
                    outputChatBox("ID: "..sColor..(getElementData(v,"shop.id"))..white.." Type: "..sColor..(types[getElementData(v,"shop.type")])..white.." Distance: "..sColor..math.ceil(distance)..white.." m.",player,255,255,255,true);
                    counter = counter + 1;
                end
            end
        end
        if counter == 0 then 
            outputChatBox(exports.fv_engine:getServerSyntax("Shop","red").."There is no store near you!",player,255,255,255,true);
        end
    end
end
addCommandHandler("nearbyshops",nearbyShops,false,false);
addCommandHandler("nearbyshop",nearbyShops,false,false);

function deleteShop(player,command,id)
    if getElementData(player,"admin >> level") > 10 then 
        if not id or not tonumber(id) then outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [ID]",player,255,255,255,true) return end;
        local id = math.floor(tonumber(id));
        if shops[id] then 
            local ped = shops[id];
            if isElement(ped) then 
                destroyElement(ped);
            end
            dbExec(sql,"DELETE FROM boltok WHERE id=?",id);
            local sColor = exports.fv_engine:getServerColor("servercolor",true);
            outputChatBox(exports.fv_engine:getServerSyntax("Shop","servercolor").."You have successfully deleted a store. ID: "..sColor..id..white..".",player,255,255,255,true);
            exports.fv_logs:createLog("DELETESHOP",exports.fv_admin:getAdminName(player).. " He deleted a store. ID: "..id..".",player);
            exports.fv_admin:sendMessageToAdmin(player,sColor..getElementData(player,"admin >> name")..white.." deleted a store ID: "..sColor..id..white..".",3);
        else
            outputChatBox(exports.fv_engine:getServerSyntax("Shop","red").."There is no such shop!",player,255,255,255,true);
        end
    end
end
addCommandHandler("delshop",deleteShop,false,false);
addCommandHandler("deleteshop",deleteShop,false,false);
