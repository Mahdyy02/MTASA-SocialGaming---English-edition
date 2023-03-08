--Textures--
local afk = dxCreateTexture("icons/afk.png","dxt5");
local pm = dxCreateTexture("icons/pm.png","dxt5");
local duty = dxCreateTexture("icons/duty.png","dxt5");
local cuff = dxCreateTexture("icons/cuff.png","dxt5");
local taser = dxCreateTexture("icons/taser.png","dxt5");
local collapsed = dxCreateTexture("icons/collapsed.png","dxt5");
------------
local screen = {guiGetScreenSize()};
local rel = screen[1]/1920;
local togname = true;
local playerCache = {};
local pedCache = {};
local rot = 0;
local nevek = false;
local showNames = true;
local alien = nil

addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        white = "#FFFFFF";
        red = exports.fv_engine:getServerColor("red",true);
        sColor = exports.fv_engine:getServerColor("servercolor",true);
        orange = exports.fv_engine:getServerColor("orange",true);
        font = exports.fv_engine:getFont("rage",15);
        alien = dxCreateFont("alien.ttf",12)    
    end
    if res == getThisResource() then 
        setElementData(localPlayer,"pednames.show",true);
        for k,v in pairs(getElementsByType("player",_,true)) do 
            if isElementStreamedIn(v) then 
                local x = (getElementData(v,"item.show") or false);
                local array = {};
                if x then 
                    array = {getTickCount(),x[2],x[3],x[4]};
                end            
                playerCache[v] = {
                    id = getElementData(v,"char >> id"),
                    afk = getElementData(v,"afk"),
                    afktime = getElementData(v,"afk.time"),
                    typing = getElementData(v,"typing"),
                    jelveny = getElementData(v,"char >> jelveny"),
                    itemShow = array,
                };
            end
        end
        for k,v in pairs(getElementsByType("ped")) do 
            if isElementStreamedIn(v) then 
                if not (getElementData(v,"ped >> noName") or false) then 
                    pedCache[v] = {
                        name = getElementData(v,"ped >> name") or "Névtelen",
                        type = getElementData(v,"ped >> type") or "Típustalan",
                    }
                end
            end
        end
    end
end);
addEventHandler("onClientElementDataChange",getRootElement(),function(data,old,new)
    if getElementType(source) == "player" then 
        if playerCache[source] then 
            if data == "char >> id" then 
                playerCache[source].id = new;
            end
            if data == "afk" then 
                playerCache[source].afk = new;
            end
            if data == "afk.time" then 
                playerCache[source].afktime = new;
            end
            if data == "typing" then 
                playerCache[source].typing = new;
            end
            if data == "item.show" then 
                local x = getElementData(source,data);
                if not x then 
                    playerCache[source].itemShow = {};
                else 
                    playerCache[source].itemShow = {getTickCount(),x[2],x[3],x[4]}
                end
            end
            if data == "char >> jelveny" then 
                playerCache[source].jelveny = new;
            end
            if data == "char >> taser" then 
                playerCache[source].taser = new;
            end
        end
    end
    if getElementType(source) == "ped" then 
        if pedCache[source] then 
            if data == "ped >> noName" then 
                pedCache[source].noName = new;
            end
            if data == "ped >> name" then 
                pedCache[source].name = new;
            end
            if data == "ped >> type" then 
                pedCache[source].type = new;
            end
        end
    end
end);
addEventHandler("onClientElementStreamIn",getRootElement(),function()
    if getElementType(source) == "player" then 
        if not playerCache[source] then 
            local x = (getElementData(source,"item.show") or false);
            local array = {};
            if x then 
                array = {getTickCount(),x[2],x[3],x[4]};
            end  
            playerCache[source] = {
                id = getElementData(source,"char >> id"),
                afk = getElementData(source,"afk"),
                afktime = getElementData(source,"afk.time"),
                typing = getElementData(source,"typing"),
                itemShow = array,
                jelveny = getElementData(source,"char >> jelveny"),
                taser = getElementData(source,"char >> taser")
            };
        end
    end
    if getElementType(source) == "ped" then 
        if not pedCache[source] then 
            if not (getElementData(source,"ped >> noName") or false) then 
                pedCache[source] = {
                    name = getElementData(source,"ped >> name") or "Névtelen",
                    type = getElementData(source,"ped >> type") or "Típustalan",
                }
            end
        end
    end
end);
addEventHandler("onClientElementStreamOut",getRootElement(),function()
    if getElementType(source) == "player" then 
        if playerCache[source] then 
            playerCache[source] = nil;
        end
    end
    if getElementType(source) == "ped" then 
        if pedCache[source] then 
            pedCache[source] = nil;
        end
    end
end);
addEventHandler("onClientPlayerQuit",getRootElement(),function()
    if getElementType(source) == "player" then 
        if playerCache[source] then 
            playerCache[source] = nil;
        end
    end
end);

addEventHandler("onClientRender",root,function()
    if not showNames then return end;
    local x,y,z = getElementPosition(localPlayer);
    rot = rot + 1;
    for v,k in pairs(playerCache) do
        if v and isElement(v) then 
            if isElementOnScreen(v) then 
                setPlayerNametagShowing(v,false);
                local px,py,pz = getPedBonePosition(v,8);
                local draw = true;
                if localPlayer == v then 
                    if togname then 
                        draw = false;
                    end
                end
                if not nevek then 
                    if (not processLineOfSight(x, y, z, px, py, pz, true, false, false, true, false, true)) and draw and not getElementData(v,"char >> invisible") then 
                        local pdistance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
                        if pdistance < 30 then 
                            local progress = pdistance/30
                            local scale = interpolateBetween(1, 0, 0, 0.2, 0, 0, progress, "OutQuad")
                            scale = scale*rel
                            local sx,sy = getScreenFromWorldPosition(px, py, pz+0.3, 0.06);

                            if sx and sy then 
                                local rang = exports['fv_admin']:getAdminTitle(v)
                                local ghex = getAdminColor(v);
                                local name = "";
                                if getElementData(v, "char >> ufo") then
                                    name = "UFO"
                                elseif not exports['fv_admin']:getAdminDuty(v) then
                                    ghex = getAdminColor(v,0)
                                    rang = "Játékos"
                                    --name = "("..ghex..(k.id)..white..") "..exports['fv_admin']:getAdminName(v);
                                    name = "("..ghex..(k.id)..white..") ";
                                else 
                                    name = "("..ghex..(k.id)..white..") "..exports['fv_admin']:getAdminName(v).." ["..ghex..rang..white.."]";
                                end
                                if k.afk then 
                                    --name = red..SecondsToClock(k.afktime)
                                    name = red..SecondsToClock(k.afktime)..white.."\n"..name
                                end
                                if k.jelveny then 
                                    name = name .."\n"..orange.."("..k.jelveny..")";    
                                end

                                local currentFont = font
                                
                                --if getElementData(v, "char >> ufo") then
                                --    shadowedText("vb",sx-100,sy,sx+100,sy,tocolor(255,255,255),1*scale,alien,"center","center",false,false,false,true);
                                --else
                                    if isPedDead(v) or getElementData(v,"char >> death") then 
                                        shadowedTextDead(name:gsub("#%x%x%x%x%x%x",""),sx-100,sy,sx+100,sy,tocolor(100,100,100),1*scale,currentFont,"center","center",false,false,false,false);
                                    else                           
                                        shadowedText(name,sx-100,sy,sx+100,sy,tocolor(255,255,255),1*scale,currentFont,"center","center",false,false,false,true);
                                    end
                                --end


                                if k.afk and not k.typing then 
                                    dxDrawImage(sx-(64*scale),sy-(80*scale),128*scale,64*scale,afk);
                                end
                                if k.typing and not k.afk then 
                                    dxDrawImage(sx-(24*scale),sy-(80*scale),48*scale,48*scale,pm);
                                end
                                if not k.typing and not k.afk and getElementData(v,"cuffed") then 
                                    dxDrawImage(sx-(50*scale),sy-(100*scale),100*scale,100*scale,cuff);
                                end
                                if not k.typing and not k.afk and not getElementData(v,"cuffed") and k.taser then 
                                    dxDrawImage(sx-(50*scale),sy-(60*scale),50*scale,50*scale,taser);
                                end
                                if not k.typing and not k.afk and not getElementData(v,"cuffed") and not k.taser and getElementData(v,"collapsed") then 
                                    dxDrawImage(sx-(50*scale),sy-(60*scale),50*scale,50*scale,collapsed);
                                end
                                if not k.typing and not k.afk and #(k.itemShow) == 0 and rang ~= "Játékos" and (exports['fv_admin']:getAdminDuty(v) and getElementData(v,"admin >> level") > 2) and not getElementData(v,"cuffed") then 
                                    dxDrawImage(sx-(50*scale),sy-(130*scale),100*scale,100*scale,duty,rot);
                                end
                            end
                            if k.itemShow and #(k.itemShow) > 0 then 
                                local data = k.itemShow
                                local itemTick = data[1]
                                local itemName = data[2]
                                local itemCount = data[3]
                                local itemID = data[4]
                                if itemTick and itemCount and itemName and sx and sy then
            
                                    local left1 = sx - 20
                                    local top1 = sy - 70
                                    local width1 = 40
                                    local height1 = 40
            
                                    local img = exports.fv_inventory:getItemImage(itemID)
                                    local progress1 = (getTickCount() - itemTick) / 1000
            
                                    local y, _, _ = interpolateBetween(
                                        top1, 0, 0,
                                        top1-30, 0, 0,
                                    progress1, "OutBounce")
            
                                    dxDrawRectangle(left1 - 1, y - 1, width1 + 2, height1 + 2, tocolor(0, 0, 0, 100))
                                    dxDrawImage(left1, y, width1, height1, img);
                                    shadowedText(tostring(itemCount),left1, y, left1+width1+3,y+height1+5, tocolor(255,255,255),1,exports['fv_engine']:getFont("Yantramanav-Regular", 15),"right","bottom");
                                    shadowedText(itemName, left1, y + 31, left1 + width1, y + 40 + height1, tocolor(255,255,255), 1, exports['fv_engine']:getFont("Yantramanav-Regular", 15), "center", "center");
                                end
                            end
                        end
                    end 
                else
                    if not getElementData(v, "char >> ufo") then
                        local pdistance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
                        if pdistance < 180 then 
                            --local _,_,hz = getPedBonePosition(v,8);
                            local sx,sy = getScreenFromWorldPosition(px, py, pz+0.3, 0.06);

                            if sx and sy and draw then 
                                local progress = pdistance/30
                                --local scale = interpolateBetween(1, 0, 0, 0.2, 0, 0, progress, "OutQuad")
                                --scale = scale*(screen[1]+1280)/(1280*1.9)
                                scale = 0.8*rel

                                local rang = exports['fv_admin']:getAdminTitle(v)
                                local ghex = getAdminColor(v);
                                if not exports['fv_admin']:getAdminDuty(v) then
                                    ghex = getAdminColor(v,0)
                                    rang = "Játékos"
                                    name = "("..ghex..(k.id)..white..") "..exports['fv_admin']:getAdminName(v)
                                else 
                                    name = "("..ghex..(k.id)..white..") "..exports['fv_admin']:getAdminName(v).." ["..ghex..rang..white.."]"
                                end
                                if k.afk then 
                                    name = red..SecondsToClock(k.afktime)..white.."\n"..name
                                 	--name = red..SecondsToClock(k.afktime)
                                end
                                shadowedTextNevek(name:gsub("#%x%x%x%x%x%x",""),sx-100,sy,sx+100,sy,tocolor(255,255,255),1.25*scale,font,"center","center",false,false,false,true);
                                
                                dxDrawRectangle(sx-(110/2)*scale,sy+(30*scale),110*scale,30*scale,tocolor(0,0,0,170));
                                dxDrawRectangle(sx-(95/2)*scale,sy+(35*scale),getElementHealth(v)*scale,20*scale,tocolor(255,0,0,170));

                                dxDrawRectangle(sx-(110/2)*scale,sy+(70*scale),110*scale,30*scale,tocolor(0,0,0,170));
                                dxDrawRectangle(sx-(95/2)*scale,sy+(75*scale),getPedArmor(v)*scale,20*scale,tocolor(0,0,255,170));
                            end
                        end
                    end
                end
            end
        else 
            playerCache[v] = nil;
        end
    end
    if getElementData(localPlayer,"pednames.show") then 
        for v,k in pairs(pedCache) do 
            if isElement(v) then 
                if isElementOnScreen(v) then 
                    --local px,py,pz = getElementPosition(v);
                    local px,py,pz = getPedBonePosition(v,8);
                    if not processLineOfSight(x, y, z, px, py, pz, true, false, false, true, false, true) then 
                        local pdistance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
                        if pdistance < 30 then 
                            --local _,_,hz = getPedBonePosition(v,8);
                            local sx,sy = getScreenFromWorldPosition(px, py, pz+0.3, 0.06);
                            if sx and sy then 
                                local progress = pdistance/30
                                local scale = interpolateBetween(1, 0, 0, 0.2, 0, 0, progress, "Linear")
                                scale = scale*rel
                                local name = "("..sColor.."NPC"..white..") "..k.name.." ["..sColor..k.type..white.."]"
                                shadowedText(name,sx-100,sy,sx+100,sy,tocolor(255,255,255),1*scale,font,"center","center",false,false,false,true);
                            end
                        end
                    end
                end
            else 
                pedCache[v] = nil;
            end
        end
    end
end,true,"low-9999");



--Parancsok--
function togname()
    if togname then
        togname = false;
        outputChatBox(exports.fv_engine:getServerSyntax("Nametag","servercolor").."Your nametag is on!",255,255,255,true);
    else
        togname = true;
        outputChatBox(exports.fv_engine:getServerSyntax("Nametag","red").."Your nametag is off!",255,255,255,true);
    end
end
 addCommandHandler("togname",togname)

addCommandHandler("atognames",function(cmd)
    if getElementData(localPlayer,"admin >> level") > 2 and getElementData(localPlayer,"admin >> duty") or getElementData(localPlayer, "admin >> level") >11 then 
        nevek = not nevek;
        if nevek then 
            outputChatBox(exports.fv_engine:getServerSyntax("Nametag","servercolor").."Names on!",255,255,255,true);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Nametag","red").."Names off!",255,255,255,true);
        end
    end
end);
addEventHandler("onClientElementDataChange",localPlayer,function(dataName,oldValue,newValue)
    if dataName == "admin >> duty" then 
        if not newValue then 
            nevek = false;
        end
    end
end);

function showNamesCommand(cmd)
    showNames = not showNames;
    if showNames == false then 
        outputChatBox(exports.fv_engine:getServerSyntax("Nametag","servercolor").."Nametag display off!",255,255,255,true);
    else 
        outputChatBox(exports.fv_engine:getServerSyntax("Nametag","red").."Nametag display is on!",255,255,255,true);
    end
end
addCommandHandler("shownames",showNamesCommand);
