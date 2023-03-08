local sql = exports.fv_engine:getConnection(getThisResource());
local elevators = {};

function loadElevator(id)
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        if #res > 0 then 
            for k,v in pairs(res) do 

                local r,g,b = exports.fv_engine:getServerColor("servercolor",false);

                local x,y,z,dimension,interior = unpack(fromJSON(v.enter));
                local enter = createMarker(x,y,z-1,"cylinder",0.8,r,g,b,100);
                setElementDimension(enter,dimension);
                setElementInterior(enter,interior);

                setElementData(enter,"elevator.id",v.id);
                setElementData(enter,"elevator.other",false);
                setElementData(enter,"elevator.enter",true);

                local exit = false;
                local a = fromJSON(v.exitgeci)
                if a and #a > 0 then 
                    local x,y,z,dimension,interior = unpack(a);
                    if x and y and z and dimension and interior then 
                        exit = createMarker(x,y,z-1,"cylinder",0.8,r,g,b,100);
                        setElementDimension(exit,dimension);
                        setElementInterior(exit,interior);
                        setElementData(exit,"elevator.id",v.id);

                        setElementData(enter,"elevator.other",exit);
                        setElementData(exit,"elevator.other",enter);
                    end
                end
                elevators[v.id] = {enter,exit};
            end
        end
    end,sql,"SELECT * FROM liftek WHERE id=?",id);
end

function loadAllElevator()
    dbQuery(function(qh)
        local res = dbPoll(qh,0);
        for k,v in pairs(res) do 
            loadElevator(v.id);
        end
    end,sql,"SELECT id FROM liftek");
end
addEventHandler("onResourceStart",resourceRoot,loadAllElevator);

addEvent("elevator.use",true);
addEventHandler("elevator.use",root,function(player,elevator)
    local id = (getElementData(elevator,"elevator.id") or 0);
    if id then 
        local other = getElementData(elevator,"elevator.other");
        if other and isElement(other) then 
            local x,y,z = getElementPosition(other);
            local dimension,interior = getElementDimension(other),getElementInterior(other);
            setElementPosition(player,x,y,z+1.5);
            setElementDimension(player,dimension);
            setElementInterior(player,interior);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Lift","red").."The elevator exit is not set.",player,255,255,255,true);
        end
    end
end);


function addElevator(player,command)
    if getElementData(player,"admin >> level") > 7 then 
        local x,y,z = getElementPosition(player);
        local dimension = getElementDimension(player);
        local interior = getElementInterior(player);
        dbQuery(function(qh)
            local res,_,id = dbPoll(qh,0);
            loadElevator(id);
            outputChatBox(exports.fv_engine:getServerSyntax("Lift","servercolor").."Successful elevator unloading. ID:"..exports.fv_engine:getServerColor("servercolor",true)..id..white..".",player,255,255,255,true);
            outputChatBox(exports.fv_engine:getServerSyntax("Lift","servercolor").."Set the exit! /"..exports.fv_engine:getServerColor("servercolor",true).."setliftexit"..white..".",player,255,255,255,true);
			exports['fv_logs']:createLog(cmd, getAdminName(player).." created an elevator! ("..id..")", player);
        end,sql,"INSERT INTO liftek SET enter=?",toJSON({x,y,z,dimension,interior}));
    end
end
addCommandHandler("addelevator",addElevator,false,false);
addCommandHandler("addlift",addElevator,false,false);

function setLiftExit(player,command,id)
    if getElementData(player,"admin >> level") > 7 then 
        if not id or not tonumber(id) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [id]",player,255,255,255,true);
            return;
        end
        local id = math.floor(tonumber(id));
        if elevators[id] then 
            if not elevators[id][2] then 
                local x,y,z = getElementPosition(player);
                local dimension = getElementDimension(player);
                local interior = getElementInterior(player);
                if isElement(elevators[id][2]) then 
                    setElementPosition(elevators[id][2],x,y,z-1);
                    setElementDimension(elevators[id][2],dimension); 
                    setElementInterior(elevators[id][2],interior); 
                else 
                    local r,g,b = exports.fv_engine:getServerColor("servercolor",false);
                    local exit = createMarker(x,y,z-1,"cylinder",0.8,r,g,b,200);
                    setElementData(exit,"elevator.id",id);
                    setElementData(exit,"elevator.other",elevators[id][1]);
                    setElementData(elevators[id][1],"elevator.other",exit);
                    setElementDimension(exit,dimension); 
                    setElementInterior(exit,interior); 
                end
                dbExec(sql,"UPDATE liftek SET exitgeci=? WHERE id=?",tostring(toJSON({x,y,z,dimension,interior})),id);
				exports['fv_logs']:createLog(cmd, getAdminName(player).." created an elevator exit! ("..id..")", player);
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Lift","red").."There is no such elevator.",player,255,255,255,true);
        end
    end
end
addCommandHandler("setliftexit",setLiftExit,false,false);

function nearbyElevators(player,command)
    if getElementData(player,"admin >> level") > 7 then
        local count = 0;
        local x,y,z = getElementPosition(player);
        local color = exports.fv_engine:getServerColor("servercolor",true);
        outputChatBox(exports.fv_engine:getServerSyntax("Lift","servercolor").."Lifts nearby.",player,255,255,255,true);
        for k,v in pairs(getElementsByType("marker",resourceRoot)) do 
            if getElementData(v,"elevator.id") and getElementData(v,"elevator.enter") then  
                local mx,my,mz = getElementPosition(v);
                local distance = getDistanceBetweenPoints3D(x,y,z,mx,my,mz);
                if distance < 20 then 
                    count = count + 1;
                    outputChatBox(" - ID: "..color..getElementData(v,"elevator.id")..white.." | Distance: "..color..math.floor(distance)..white..".",player,255,255,255,true);
                end
            end
        end
        if count == 0 then 
            outputChatBox(exports.fv_engine:getServerSyntax("Lift","red").."There is no elevator nearby!",player,255,255,255,true);
        end
    end
end
addCommandHandler("nearbyelevators",nearbyElevators,false,false);
addCommandHandler("nearbylift",nearbyElevators,false,false);

function delElevator(player,command,target)
    if getElementData(player,"admin >> level") > 7 then
        if not target or not tonumber(target) then 
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [id]",player,255,255,255,true);
            return;
        end
        local target = math.floor(tonumber(target));
        if elevators[target] then 
            local enter = elevators[target][1];
            local exit = elevators[target][2];
            if enter then 
                destroyElement(enter);
            end
            if exit then 
                destroyElement(exit);
            end
            dbExec(sql,"DELETE FROM liftek WHERE id=?",target);
            outputChatBox(exports.fv_engine:getServerSyntax("Lift","servercolor").."You have successfully canceled an elevator.",player,255,255,255,true);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Lift","red").."There is no such elevator!",player,255,255,255,true);
            return;
        end
    end
end
addCommandHandler("dellift",delElevator,false,false);
addCommandHandler("deletelift",delElevator,false,false);
addCommandHandler("deleteelevator",delElevator,false,false);