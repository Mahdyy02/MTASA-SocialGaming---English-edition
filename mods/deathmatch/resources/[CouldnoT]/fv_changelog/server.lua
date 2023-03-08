local sql = exports.fv_engine:getConnection(getThisResource());
local white = "#FFFFFF";
local changelog = {};

Async:setPriority("high");

function loadChanges()
    changelog = {};
    dbQuery(function(qh)
        local result = dbPoll(qh,0);
        outputDebugString("Changelog loaded!",0,100,100,0);
        changelog = result;
    end,sql,"SELECT * FROM changelog ORDER BY id DESC");
end

addEvent("changelog.get",true);
addEventHandler("changelog.get",root,function(player)
    triggerClientEvent(player,"changelog.return",player,changelog);
end);

function addChangeLog(player,command,script,...)
    if getElementData(player,"admin >> level") > 10 then 
        if not script or not ... then 
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [script] [description]",player,255,255,255,true);
            return;
        end
        local change = table.concat({...}," ");
        local sql = dbExec(sql,"INSERT INTO changelog SET script=?, leiras=?, developer=?, datum=NOW()",tostring(script),tostring(change),tostring(exports.fv_admin:getAdminName(player,true)));
        if sql then 
            loadChanges();
            outputChatBox(exports.fv_engine:getServerSyntax("Changelog","servercolor").."Successful log addition!",player,255,255,255,true);
            outputChatBox(exports.fv_engine:getServerSyntax("Changelog","servercolor").."New changelog added "..exports.fv_engine:getServerColor("servercolor",true)..exports.fv_admin:getAdminName(player,true)..white.." by. view: "..exports.fv_engine:getServerColor("servercolor",true).."F2"..white..".",root,255,255,255,true);
        end
    end
end
addCommandHandler("addchangelog",addChangeLog,false,false);

setGameType("TN:RP v1.0");

loadChanges();