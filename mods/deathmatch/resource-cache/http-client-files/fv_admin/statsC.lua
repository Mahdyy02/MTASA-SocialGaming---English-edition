local element = false;
local statCache = {};

function renderStats()
    local font = exports.fv_engine:getFont("rage",10);
    dxDrawRectangle(sx/2-200,sy/2-225,400,335,tocolor(0,0,0,180));

    for k,v in pairs(statCache) do 
        dxDrawRectangle(sx/2-380/2,sy/2-250+(k*30),380,25,tocolor(100,100,100,130));
        dxDrawText(v,sx/2-380/2,sy/2-250+(k*30),sx/2-380/2+380,sy/2-250+(k*30)+25,tocolor(255,255,255),1,font,"center","center",false,false,false,true);
    end
end

addCommandHandler("stats",function(command,...)
    if getElementData(localPlayer,"admin >> level") > 2 then 
        if element then 
            removeEventHandler("onClientRender",root,renderStats);
            element = false;
            statCache = false;
        else 
            if not (...) then  
                outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Name/ID]",255,255,255,true);
                return;
            end
            local target = table.concat({...}," ");
            local targetPlayer = exports.fv_engine:findPlayer(localPlayer,target);
            if targetPlayer then 
                element = targetPlayer;
                statCache = {
                    "Character Name: "..sColor..getElementData(element,"char >> name"),
                    "AccountID: "..sColor..getElementData(element,"acc >> id"),
                    "Number of vehicles: "..sColor..getPlayerVehicleCount(element)..white.." / "..getElementData(element,"char >> vehSlot"),
                    "Number of interiors: "..sColor..getPlayerInteriorCount(element)..white.." / "..getElementData(element,"char >> intSlot"),
                    "Work: "..sColor..exports.fv_jobs:getJobName(getElementData(element,"char >> job")),
                    "Money: "..sColor..formatMoney(getElementData(element,"char >> money"))..white.." dt",
                    "Bank balance: "..sColor..formatMoney(getElementData(element,"char >> bankmoney"))..white.." dt",
                    "PremiumPont: "..sColor..getElementData(element,"char >> premiumPoints")..white.." PP",
                    "Admin name: "..sColor..getAdminName(element,true),
                    "Admin level: "..sColor..getElementData(element,"admin >> level"),
                    "Minutes played: "..sColor..getElementData(element,"char >> playedtime")..white.." minute",
                }
                removeEventHandler("onClientRender",root,renderStats);
                addEventHandler("onClientRender",root,renderStats);
            else 
                outputChatBox(exports.fv_engine:getServerSyntax("Admin","red").."No players found!",255,255,255,true);
                return;
            end
        end
    end
end,false,false);

function getPlayerVehicleCount(element)
    local counter = 0;
    for k,v in pairs(getElementsByType("vehicle")) do 
		if ( getElementData(v,"veh:id") ) then
			if ( getElementData(v,"veh:tulajdonos")) then
				if getElementData(v,"veh:id") > 0 and getElementData(v,"veh:tulajdonos") == getElementData(element,"acc >> id") then 
					counter = counter + 1;
				end
			end
		end
    end
    return counter;
end

function getPlayerInteriorCount(element)
    local counter = 0;
    for k,v in pairs(getElementsByType("marker")) do 
        if getElementData(v,"id") and not getElementData(v,"outElement") then 
            if getElementData(v,"owner") == getElementData(element,"acc >> id") then
                counter = counter + 1;
            end
        end
    end
    return counter;
end