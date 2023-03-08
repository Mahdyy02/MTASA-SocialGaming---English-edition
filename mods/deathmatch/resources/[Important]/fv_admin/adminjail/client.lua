local jailData = {};

addEventHandler("onClientResourceStart",resourceRoot,function()
    if getElementData(localPlayer,"loggedIn") then 
        local newValue = getElementData(localPlayer,"char >> adminJail");
        if newValue and newValue[1] == 1 then 
            jailData = {
                reason = newValue[3],
                admin = newValue[2],
                time = tostring(newValue[4]),
                alltime = tostring(newValue[5]),
            };
            removeEventHandler("onClientRender",root,renderAdminJail);
            addEventHandler("onClientRender",root,renderAdminJail);
            triggerServerEvent("adminjail.start",localPlayer,localPlayer,newValue);
        end
    end
end);

addEventHandler("onClientElementDataChange",localPlayer,function(dataName,oldValue,newValue)
    if dataName == "char >> adminJail" then 
        if getElementData(localPlayer,"loggedIn") then 
            local newValue = getElementData(localPlayer,dataName);
            if newValue and newValue[1] == 1 then 
                jailData = {
                    reason = newValue[3],
                    admin = newValue[2],
                    time = tostring(newValue[4]),
                    alltime = tostring(newValue[5]),
                };
                removeEventHandler("onClientRender",root,renderAdminJail);
                addEventHandler("onClientRender",root,renderAdminJail);
            elseif not newValue then
                jailData = {};
                removeEventHandler("onClientRender",root,renderAdminJail);
            end
        end
    end
    --[[if dataName == "loggedIn" then 
        if newValue then 
            local x = getElementData(localPlayer,"char >> adminJail");
            if x and x[1] == 1 then 
                jailData = {
                    reason = x[3],
                    admin = x[2],
                    time = tostring(x[4]),
                    alltime = tostring(x[5]),
                };
                removeEventHandler("onClientRender",root,renderAdminJail);
                addEventHandler("onClientRender",root,renderAdminJail);
                outputDebugString("loggedIn: true  DATA: "..toJSON(x));
                triggerServerEvent("adminjail.start",localPlayer,localPlayer,x);
            end
        end
    end]]
end);

function renderAdminJail()
    local font = exports.fv_engine:getFont("rage",15);
    local sColor = exports.fv_engine:getServerColor("servercolor",true);
    shadowedText("ADMINJAIL\ncause: "..sColor..jailData.reason..white.."\nTime: "..sColor..jailData.alltime..white.." perc\nHremaining time: "..sColor..jailData.time..white.." perc\nAdmin: "..sColor..jailData.admin..white..".",0,0,sx,sy,tocolor(255,255,255),1,font,"center","top",false,false,false,true);
end

--UTILS--
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end