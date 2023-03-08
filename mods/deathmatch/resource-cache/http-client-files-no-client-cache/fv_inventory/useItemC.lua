local lastUse = 0;
local gyogyszer = false;
local fix = false;
local fuel = false;
local unflip = false;
local heal = false;

isHunger, hungerItem, hungerState, lastHunger = false, -1, 100, 0;

local drogTimer = false;


-- New 
obje = {};

mask_devil_txt = engineLoadTXD ( "object/mask_devil.txd") 
engineImportTXD ( mask_devil_txt, 1512 )
mask_devil_dff = engineLoadDFF ( "object/mask_devil.dff", 0)
engineReplaceModel ( mask_devil_dff, 1512 )
engineSetModelLODDistance(1512, 2000)
    
mask_guyfawkes_txt = engineLoadTXD ( "object/mask_guyfawkes.txd") 
engineImportTXD ( mask_guyfawkes_txt, 1455 )
mask_guyfawkes_dff = engineLoadDFF ( "object/mask_guyfawkes.dff", 0)
engineReplaceModel ( mask_guyfawkes_dff, 1455 )
engineSetModelLODDistance(1455, 2000)
    
mask_darthvader_txt = engineLoadTXD ( "object/mask_darthvader.txd") 
engineImportTXD ( mask_darthvader_txt, 1484 )
mask_darthvader_dff = engineLoadDFF ( "object/mask_darthvader.dff", 0)
engineReplaceModel ( mask_darthvader_dff, 1484 )
engineSetModelLODDistance(1484, 2000)
    
mask_terrorist_txt = engineLoadTXD ( "object/bordobereli.txd") 
engineImportTXD ( mask_terrorist_txt, 1485 )
mask_terrorist_dff = engineLoadDFF ( "object/bordobereli.dff", 0)
engineReplaceModel ( mask_terrorist_dff, 1485 )
engineSetModelLODDistance(1485, 2000)
    
mask_gas_txt = engineLoadTXD ( "object/mask_gas.txd") 
engineImportTXD ( mask_gas_txt, 1487 )
mask_gas_dff = engineLoadDFF ( "object/mask_gas.dff", 0)
engineReplaceModel ( mask_gas_dff, 1487 )
engineSetModelLODDistance(1487, 2000)
    
hat_cowboy_txt = engineLoadTXD ( "object/hat_cowboy.txd") 
engineImportTXD ( hat_cowboy_txt, 1543 )
hat_cowboy_dff = engineLoadDFF ( "object/hat_cowboy.dff", 0)
engineReplaceModel ( hat_cowboy_dff, 1543 )
engineSetModelLODDistance(1543, 2000)
    
celikyelek_txt = engineLoadTXD ( "object/celikyelek.txd") 
engineImportTXD ( celikyelek_txt, 1922 )
celikyelek_dff = engineLoadDFF ( "object/celikyelek.dff", 0)
engineReplaceModel ( celikyelek_dff, 1922 )
engineSetModelLODDistance(1922, 2000)
    
celikyelek2_txt = engineLoadTXD ( "object/celikyelek2.txd") 
engineImportTXD ( celikyelek2_txt, 1923 )
celikyelek2_dff = engineLoadDFF ( "object/celikyelek2.dff", 0)
engineReplaceModel ( celikyelek2_dff, 1923 )
engineSetModelLODDistance(1923, 2000)
    
celikyelek3_txt = engineLoadTXD ( "object/celikyelek3.txd") 
engineImportTXD ( celikyelek3_txt, 1924 )
celikyelek3_dff = engineLoadDFF ( "object/celikyelek3.dff", 0)
engineReplaceModel ( celikyelek3_dff, 1924 )
engineSetModelLODDistance(1924, 2000)
    
mask_zombie_txt = engineLoadTXD ( "object/mask_zombie.txd") 
engineImportTXD ( mask_zombie_txt, 1544 )
mask_zombie_dff = engineLoadDFF ( "object/mask_zombie.dff", 0)
engineReplaceModel ( mask_zombie_dff, 1544 )
engineSetModelLODDistance(1544, 2000)
    
mask_vampire_txt = engineLoadTXD ( "object/mask_vampire.txd") 
engineImportTXD ( mask_vampire_txt, 1666 )
mask_vampire_dff = engineLoadDFF ( "object/mask_vampire.dff", 0)
engineReplaceModel ( mask_vampire_dff, 1666 )
engineSetModelLODDistance(1666, 2000)
    
mask_skull_txt = engineLoadTXD ( "object/mask_skull.txd") 
engineImportTXD ( mask_skull_txt, 1667 )
mask_skull_dff = engineLoadDFF ( "object/mask_skull.dff", 0)
engineReplaceModel ( mask_skull_dff, 1667 )
engineSetModelLODDistance(1667, 2000)
    
mask_raccoon_txt = engineLoadTXD ( "object/mask_raccoon.txd") 
engineImportTXD ( mask_raccoon_txt, 1668 )
mask_raccoon_dff = engineLoadDFF ( "object/mask_raccoon.dff", 0)
engineReplaceModel ( mask_raccoon_dff, 1668 )
engineSetModelLODDistance(1668, 2000)   
    
mask_owl_txt = engineLoadTXD ( "object/mask_owl.txd") 
engineImportTXD ( mask_owl_txt, 1950 )
mask_owl_dff = engineLoadDFF ( "object/mask_owl.dff", 0)
engineReplaceModel ( mask_owl_dff, 1950 )
engineSetModelLODDistance(1950, 2000)
    
mask_cat_txt = engineLoadTXD ( "object/mask_cat.txd") 
engineImportTXD ( mask_cat_txt, 1951 )
mask_cat_dff = engineLoadDFF ( "object/mask_cat.dff", 0)
engineReplaceModel ( mask_cat_dff, 1951 )
engineSetModelLODDistance(1951, 2000)       
    
mask_bag_txt = engineLoadTXD ( "object/mask_bag.txd") 
engineImportTXD ( mask_bag_txt, 1551 )
mask_bag_dff = engineLoadDFF ( "object/mask_bag.dff", 0)
engineReplaceModel ( mask_bag_dff, 1551 )
engineSetModelLODDistance(1551, 2000)   
    
mask_dog_txt = engineLoadTXD ( "object/mask_dog.txd") 
engineImportTXD ( mask_dog_txt, 1546 )
mask_dog_dff = engineLoadDFF ( "object/mask_dog.dff", 0)
engineReplaceModel ( mask_dog_dff, 1546 )
engineSetModelLODDistance(1546, 2000)   
    
mask_baby_txt = engineLoadTXD ( "object/mask_baby.txd") 
engineImportTXD ( mask_baby_txt, 1669 )
mask_baby_dff = engineLoadDFF ( "object/mask_baby.dff", 0)
engineReplaceModel ( mask_baby_dff, 1669 )
engineSetModelLODDistance(1669, 2000)   
    
mask_monster_txt = engineLoadTXD ( "object/mask_monster.txd") 
engineImportTXD ( mask_monster_txt, 2855 )
mask_monster_dff = engineLoadDFF ( "object/mask_monster.dff", 0)
engineReplaceModel ( mask_monster_dff, 2855 )
engineSetModelLODDistance(2855, 2000)   
    
hat_airborne_txt = engineLoadTXD ( "object/mask_alien.txd") 
engineImportTXD ( hat_airborne_txt, 1854 )
hat_airborne_dff = engineLoadDFF ( "object/mask_alien.dff", 0) 
engineReplaceModel ( hat_airborne_dff, 1854 )
engineSetModelLODDistance(1854, 2000)
    
admin_txt = engineLoadTXD ( "object/admin.txd") 
engineImportTXD ( admin_txt, 1855 )
admin_dff = engineLoadDFF ( "object/admin.dff", 0) 
engineReplaceModel ( admin_dff, 1855 )
engineSetModelLODDistance(1855, 2000)


function useItem(item,slot)
    if itemMoveTick+1000 > getTickCount() then return end;
    if lastUse+500 > getTickCount() then  outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."It is not possible to perform an item operation so quickly!",255,255,255,true) return end;
    lastUse = getTickCount();
    if (getElementData(localPlayer,"skilling")) then 
        return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You can't use it on a shooting range!",255,255,255,true);
    end
    if isCrafting() then 
        return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You cannot use objects while crafting!",255,255,255,true);
    end
    if getElementData(localPlayer,"collapsed") or isPedDead(localPlayer) then 
        return outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You can't use your items in Anim.",255,255,255,true);
    end

    local itemID, dbID, count, value, state, table = unpack(item);

    if etelek[itemID] and not isHunger then 
        isHunger = dbID;
        hungerItem = itemID;
        hungerState = 100;
        removeEventHandler("onClientRender",root,renderHunger);
        addEventHandler("onClientRender",root,renderHunger);
        setElementData(localPlayer,"itemUse.food","food");
        lastHunger = 0;
    end
    if italok[itemID] and not isHunger then 
        isHunger = dbID;
        hungerItem = itemID;
        hungerState = 100;
        removeEventHandler("onClientRender",root,renderHunger);
        addEventHandler("onClientRender",root,renderHunger);
        setElementData(localPlayer,"itemUse.food","drink");
        lastHunger = 0;
    end
    if itemID == 70 then 
        if isTimer(gyogyszer) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You can only take medicine every minute!",255,255,255,true);
            return;
        else 
            if getElementData(localPlayer,"collapsed") or isPedDead(localPlayer) then 
                outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You cannot use the medicine!",255,255,255,true);
                return;
            end
            if getElementHealth(localPlayer) < 100 then 
                gyogyszer = setTimer(function()
                    killTimer(gyogyszer);
                    gyogyszer = false;
                end,1000*60,1);
                if getElementHealth(localPlayer)+100 > 100 then 
                    setElementHealth(localPlayer,100);
                else 
                    setElementHealth(localPlayer,getElementHealth(localPlayer) + 50);
                end
                outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully taken the medicine.",255,255,255,true);
                triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"takes pair of eye medicine.");
                -- triggerServerEvent("item.takePlayerItem",localPlayer,localPlayer,itemID,1,dbID);
                takePlayerItem(itemID,1,dbID);
            else 
                outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You don't need medicine!",255,255,255,true);
                return;
            end
        end
    elseif itemID == 43 then --Füves cigi
        triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"smokes a grass cigarette.");
        if isTimer(drogTimer) then 
            killTimer(drogTimer);
        end
        local rand = math.random(1,2);
        exports.fv_plant:enableMar(1);
        local randArmor = math.random(20,30);
        drogTimer = setTimer(function()
            exports.fv_plant:disableMar();
            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."The effect of grass cigarettes has expired.",255,255,255,true);
        end,1000*60*rand,1);
        triggerServerEvent("item.setArmor",localPlayer,localPlayer,getPedArmor(localPlayer) + randArmor);
        -- triggerServerEvent("item.takePlayerItem",localPlayer,localPlayer,itemID,1,dbID);
        takePlayerItem(itemID,1,dbID);
    elseif itemID == 44 then --LSD
        if isTimer(drogTimer) then 
            killTimer(drogTimer);
        end
        local rand = math.random(1,2);
        exports.fv_plant:enableLSD(rand);
        local randArmor = math.random(20,30);
        setTimer(function()
            exports.fv_plant:disableLSD();
            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."The effect of LSD has expired.",255,255,255,true);
        end,1000*60*rand,1);
        triggerServerEvent("item.setArmor",localPlayer,localPlayer,getPedArmor(localPlayer) + randArmor);
        -- triggerServerEvent("item.takePlayerItem",localPlayer,localPlayer,itemID,1,dbID);
        takePlayerItem(itemID,1,dbID);
    elseif itemID == 45 then --Kokain
        if isTimer(drogTimer) then 
            killTimer(drogTimer);
        end
        local rand = math.random(1,2);
        exports.fv_plant:enableAmf(rand);
        local randArmor = math.random(20,30);
        setTimer(function()
            exports.fv_plant:disableAmf();
            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."The effects of cocaine have expired.",255,255,255,true);
        end,1000*60*rand,1);
        triggerServerEvent("item.setArmor",localPlayer,localPlayer,getPedArmor(localPlayer) + randArmor);
        -- triggerServerEvent("item.takePlayerItem",localPlayer,localPlayer,itemID,1,dbID);
        takePlayerItem(itemID,1,dbID);
    elseif itemID == 49 then 
        exports.fv_identity:showJogsi(value);
    elseif itemID == 91 then 
        if not isPedInVehicle(localPlayer) then outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You're not in a vehicle!",255,255,255,true) return end;
        if isTimer(fix) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You can only use a fixed card every minute!",255,255,255,true);
            return;
        else 
            triggerServerEvent("item.pps",localPlayer,localPlayer,"fix");
            -- triggerServerEvent("item.takePlayerItem",localPlayer,localPlayer,itemID,1,dbID);
            takePlayerItem(itemID,1,dbID);
            outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully repaired your vehicle.",255,255,255,true);
            fix = setTimer(function()
                killTimer(fix);
                fix = false;
            end,1000*60,1);
        end
    elseif itemID == 92 then 
        if not isPedInVehicle(localPlayer) then outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You're not in a vehicle!",255,255,255,true) return end;
        if isTimer(fuel) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You can only use a fuel card every minute!",255,255,255,true);
            return;
        else 
            triggerServerEvent("item.pps",localPlayer,localPlayer,"fuel");
            -- triggerServerEvent("item.takePlayerItem",localPlayer,localPlayer,itemID,1,dbID);
            takePlayerItem(itemID,1,dbID);
            outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully refueled your vehicle.",255,255,255,true);
            fuel = setTimer(function()
                killTimer(fuel);
                fuel = false;
            end,1000*60,1);
        end
    elseif itemID == 93 then 
        if not isPedInVehicle(localPlayer) then outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You're not in a vehicle!",255,255,255,true) return end;
        if isTimer(unflip) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You can only use an unflip card every minute!",255,255,255,true);
            return;
        else 
            triggerServerEvent("item.pps",localPlayer,localPlayer,"unflip");
            -- triggerServerEvent("item.takePlayerItem",localPlayer,localPlayer,itemID,1,dbID);
            takePlayerItem(itemID,1,dbID);
            outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully recovered your vehicle.",255,255,255,true);
            unflip = setTimer(function()
                killTimer(unflip);
                unflip = false;
            end,1000*60,1);
        end
    elseif itemID == 94 then 
        if isTimer(heal) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You can only use a heal card every minute!",255,255,255,true);
            return;
        else 
            triggerServerEvent("item.pps",localPlayer,localPlayer,"heal");
            -- triggerServerEvent("item.takePlayerItem",localPlayer,localPlayer,itemID,1,dbID);
            takePlayerItem(itemID,1,dbID);
            outputChatBox(exports.fv_engine:getServerSyntax("Item","servercolor").."You have successfully healed yourself.",255,255,255,true);
            heal = setTimer(function()
                killTimer(heal);
                heal = false;
            end,1000*60,1);
        end
    elseif itemID == 107 then
        triggerEvent("wlicense.show",localPlayer,table[2]);
    elseif itemID == 114 then --Cserép
        local interior, dimension = getElementInterior(localPlayer), getElementDimension(localPlayer);
        if interior > 0 and dimension > 0 then 
            triggerServerEvent("plant.add",localPlayer,localPlayer);
            -- triggerServerEvent("item.takePlayerItem",localPlayer,localPlayer,itemID,1,dbID);
            takePlayerItem(itemID,1,dbID);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."You can only store it indoors.",255,255,255,true);
        end		
    -- New

    local MaskUsed = false;
    elseif itemID == 128 then --Mask 128  
        if not MaskUsed then    
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears devil mask.");
            triggerServerEvent( "setmask", localPlayer, "devil");
            MaskUsed = not MaskUsed;
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end       
    elseif itemID == 129 then --Mask 129
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears vendetta mask.");
            triggerServerEvent( "setmask", localPlayer, "vendetta");
            MaskUsed = not MaskUsed;
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end              
    elseif itemID == 130 then --Mask 130
        if not MaskUsed then    
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears horse mask.");
            triggerServerEvent( "setmask", localPlayer, "horse");
            MaskUsed = not MaskUsed;       
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 131 then --Mask 131
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears darth mask.");
            triggerServerEvent( "setmask", localPlayer, "darth");
            MaskUsed = not MaskUsed;
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 132 then --Mask 132
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears gasmask mask.");
            triggerServerEvent( "setmask", localPlayer, "gasmask");
            MaskUsed = not MaskUsed;      
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 133 then --Mask 133
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears kovboy mask.");
            triggerServerEvent( "setmask", localPlayer, "kovboy");
            MaskUsed = not MaskUsed;
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 134 then --Mask 134
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears zombie mask.");
            triggerServerEvent( "setmask", localPlayer, "zombie");
            MaskUsed = not MaskUsed;
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 135 then --Mask 135
        if not MaskUsed then    
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears vampire mask.");
            triggerServerEvent( "setmask", localPlayer, "vampire");
            MaskUsed = not MaskUsed; 
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 136 then --Mask 136
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears skull mask.");
            triggerServerEvent( "setmask", localPlayer, "skull");
            MaskUsed = not MaskUsed;       
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 137 then --Mask 137
    if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears raccoon mask.");
            triggerServerEvent( "setmask", localPlayer, "raccoon");
            MaskUsed = not MaskUsed;
         else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 138 then --Mask 138
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears owl mask.");
            triggerServerEvent( "setmask", localPlayer, "owl"); 
            MaskUsed = not MaskUsed;    
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 139 then --Mask 139
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears cat mask.");
            triggerServerEvent( "setmask", localPlayer, "cat");
            MaskUsed = not MaskUsed;
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 140 then --Mask 140
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears a bag mask.");
            triggerServerEvent( "setmask", localPlayer, "bag");
            MaskUsed = not MaskUsed;
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 141 then --Mask 141
        if not MaskUsed then   
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears dog mask.");
            triggerServerEvent( "setmask", localPlayer, "dog");
            MaskUsed = not MaskUsed;
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 142 then --Mask 142
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears baby mask.");
            triggerServerEvent( "setmask", localPlayer, "baby");
            MaskUsed = not MaskUsed;        
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 143 then --Mask 143
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears monster mask.");
            triggerServerEvent( "setmask", localPlayer, "monster");
            MaskUsed = not MaskUsed;
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 144 then --Mask 144
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears tilki mask.");
            triggerServerEvent( "setmask", localPlayer, "tilki");
            MaskUsed = not MaskUsed;       
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end  
    elseif itemID == 145 then --Mask 145
        if not MaskUsed then
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"wears admin mask.");
            triggerServerEvent( "setmask", localPlayer, "admin");
            MaskUsed = not MaskUsed;
        else
            triggerServerEvent( "removemask", localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"removed his mask.");
            MaskUsed = not MaskUsed;
        end
--------------------------------------------------------------------------      	
    elseif itemID == 115 then --Kanna
        if getElementData(localPlayer,"waterCan") then 
            triggerServerEvent("plant.deleteCan",localPlayer,localPlayer);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"put down a watering can.");
        else 
            triggerServerEvent("plant.addCan",localPlayer,localPlayer,dbID);
            triggerServerEvent("sendLocalMeAction",localPlayer,localPlayer,"took out a watering can.");
        end
    end
    --Server Side Item Use
    triggerServerEvent("item.useItem",localPlayer,localPlayer,item,slot);
end

addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()),
    function()
        engineRestoreModel(1512)
        destroyElement(mask_devil_txt)
        destroyElement(mask_devil_dff)
        
        engineRestoreModel(1856)
        destroyElement(kevlar_txt)
        destroyElement(kevlar_dff)
        
        engineRestoreModel(1855)
        destroyElement(admin_txt)
        destroyElement(admin_dff)
        
        engineRestoreModel(1854)
        destroyElement(hat_airborne_txt)
        destroyElement(hat_airborne_dff)
        
        engineRestoreModel(2855)
        destroyElement(mask_monster_txt)
        destroyElement(mask_monster_dff)
        
        engineRestoreModel(1669)
        destroyElement(mask_baby_txt)
        destroyElement(mask_baby_dff)
        
        engineRestoreModel(1546)
        destroyElement(mask_dog_txt)
        destroyElement(mask_dog_dff)    
        
        engineRestoreModel(1551)
        destroyElement(mask_bag_txt)
        destroyElement(mask_bag_dff)    
        
        engineRestoreModel(1924)
        destroyElement(celikyelek3_txt)
        destroyElement(celikyelek3_dff) 
        
        engineRestoreModel(1923)
        destroyElement(celikyelek2_txt)
        destroyElement(celikyelek2_dff) 
        
        engineRestoreModel(1922)
        destroyElement(celikyelek_txt)
        destroyElement(celikyelek_dff)      
        
        engineRestoreModel(1951)
        destroyElement(mask_cat_txt)
        destroyElement(mask_cat_dff)    
        
        engineRestoreModel(1950)
        destroyElement(mask_owl_txt)
        destroyElement(mask_owl_dff)    
        
        engineRestoreModel(1668)
        destroyElement(mask_raccoon_txt)
        destroyElement(mask_raccoon_dff)        
        
        engineRestoreModel(1666)
        destroyElement(mask_vampire_txt)
        destroyElement(mask_vampire_dff)        
        
        engineRestoreModel(1667)
        destroyElement(mask_skull_txt)
        destroyElement(mask_skull_dff)      
        
        engineRestoreModel(1455)
        destroyElement(mask_guyfawkes_txt)
        destroyElement(mask_guyfawkes_dff)
        
        engineRestoreModel(1484)
        destroyElement(mask_darthvader_txt)
        destroyElement(mask_darthvader_dff)     
        
        engineRestoreModel(1485)
        destroyElement(mask_terrorist_txt)
        destroyElement(mask_terrorist_dff)
        
        engineRestoreModel(1487)
        destroyElement(mask_gas_txt)
        destroyElement(mask_gas_dff)        
        
        engineRestoreModel(1543)
        destroyElement(hat_cowboy_txt)
        destroyElement(hat_cowboy_dff)      
        
        engineRestoreModel(1544)
        destroyElement(mask_zombie_txt)
        destroyElement(mask_zombie_dff)
    end
)

function renderHunger()
    if not getElementData(localPlayer,"togHUD") then return end;
    if not getElementData(localPlayer,"actionbar.showing") then return end;
    local x,y = getElementData(localPlayer,"actionbar.x"),getElementData(localPlayer,"actionbar.y");
    x = x + 145;
    y = y - 65;
    dxDrawRectangle(x-55,y-10,110,50,tocolor(0,0,0,100));
    dxDrawImage(x-20,y-5,40,40,getItemImage(hungerItem));
    dxDrawImage(x-57,y-5,40,40,"icons/left.png");
    dxDrawImage(x+17,y-5,40,40,"icons/right.png");

    dxDrawRectangle(x-55,y+40,110,20,tocolor(0,0,0,150));
    dxDrawRectangle(x-50,y+45,hungerState,10,tocolor(sColor[1],sColor[2],sColor[3],150));
end

addEventHandler("onClientClick",root,function(button,state)
    if not getElementData(localPlayer,"togHUD") then return end;
    if not getElementData(localPlayer,"actionbar.showing") then return end;
    local x,y = getElementData(localPlayer,"actionbar.x"),getElementData(localPlayer,"actionbar.y");
    x = x + 145;
    y = y - 65;
    if isHunger then 
        if e:isInSlot(x-20,y-5,40,40) then 
            if button == "left" and state == "down" then 
                if lastHunger+2500 > getTickCount() then 
                    outputChatBox(e:getServerSyntax("Item","red").."It is not possible to perform an item operation so quickly!",255,255,255,true);
                    return;
                end
                if hungerState-10 <= 0 then 
                    triggerServerEvent("itemUse.foodDrop",localPlayer,localPlayer,isHunger,hungerItem);
                    isHunger, hungerItem, hungerState, lastHunger = false, -1, 100, 0;
                    removeEventHandler("onClientRender",root,renderHunger);
                else
                    if getElementData(localPlayer,"char >> "..getElementData(localPlayer,"itemUse.food")) >= 100 then 
                        outputChatBox(e:getServerSyntax("Item","red").."You don't need that!",255,255,255,true);
                        return;
                    end
                    local item = findByDBID(hungerItem,isHunger);
                    triggerServerEvent("itemUse.food",localPlayer,localPlayer,getElementData(localPlayer,"itemUse.food"),hungerItem,item);
                    hungerState = hungerState - 10;
                end
                lastHunger = getTickCount();
            end
            if button == "right" and state == "down" then 
                triggerServerEvent("itemUse.foodDrop",localPlayer,localPlayer,isHunger,hungerItem);
                isHunger, hungerItem, hungerState, lastHunger = false, -1, 100, 0;
                removeEventHandler("onClientRender",root,renderHunger);
            end
        end
    end
end);