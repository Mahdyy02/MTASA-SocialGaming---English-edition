
local connection = exports['fv_engine']:getConnection(getThisResource());

function createLog(system, content,player,target)
    if system and content then
        if not player then 
            player = "ISMERETLEN";
        else 
            player = exports.fv_admin:getAdminName(player,true);
        end
        if not target then 
            target = "";
        else 
            if isElement(target) then
                target = getElementData(target,"char >> name") or getPlayerName(target);
            end
        end
        dbExec(connection, "INSERT INTO logs SET system = ?, content = ?, admin = ?, target = ?, date = NOW()", tostring(system), tostring(content), tostring(player), tostring(target));
        --outputDebugString("Log -> ".. system .." Tartalom: ".. content, 0, 255, 153, 153);
    end
end
addEvent("createLog", true)
addEventHandler("createLog", root, createLog)

-- function deleteLog(dbid)
--     if dbid then
--         local qh = dbExec(connection, "DELETE * FROM logs WHERE dbid = ?", dbid)
--         if qh then
--             outputDebugString("   Log: Sikeres törlés: Rendszer: ".. system .." Tartalom: ".. content, 0, 255, 153, 153)
--         end
--     end
-- end
-- addEvent("deleteLog", true)
-- addEventHandler("deleteLog", root, deleteLog)

-- addEvent("logs.getAll",true);
-- addEventHandler("logs.getAll",root,function(player)
--     dbQuery(function(qh)
--         local res = dbPoll(qh,0);
--         local datas = {};
--         for k,v in pairs(res) do 
--             datas[v.system] = {};
--         end
--         for k,v in pairs(res) do 
--             datas[tostring(v.system)][#datas[tostring(v.system)] + 1] = {tostring(v.content),tostring(v.date)};
--         end
--         triggerClientEvent(player,"logs.return",player,datas);
--     end,connection,"SELECT * FROM logs ORDER BY date DESC"); --Dátum szerint rendezve
-- end);

-- local tableAccents = {}
-- tableAccents["à"] = "a"
-- tableAccents["á"] = "a"
-- tableAccents["â"] = "a"
-- tableAccents["ã"] = "a"
-- tableAccents["ä"] = "a"
-- tableAccents["ç"] = "c"
-- tableAccents["è"] = "e"
-- tableAccents["é"] = "e"
-- tableAccents["ê"] = "e"
-- tableAccents["ë"] = "e"
-- tableAccents["ì"] = "i"
-- tableAccents["í"] = "i"
-- tableAccents["î"] = "i"
-- tableAccents["ï"] = "i"
-- tableAccents["ñ"] = "n"
-- tableAccents["ò"] = "o"
-- tableAccents["ó"] = "o"
-- tableAccents["ô"] = "o"
-- tableAccents["õ"] = "o"
-- tableAccents["ö"] = "o"
-- tableAccents["ù"] = "u"
-- tableAccents["ú"] = "u"
-- tableAccents["û"] = "u"
-- tableAccents["ü"] = "u"
-- tableAccents["ý"] = "y"
-- tableAccents["ÿ"] = "y"
-- tableAccents["À"] = "A"
-- tableAccents["Á"] = "A"
-- tableAccents["Â"] = "A"
-- tableAccents["Ã"] = "A"
-- tableAccents["Ä"] = "A"
-- tableAccents["Ç"] = "C"
-- tableAccents["È"] = "E"
-- tableAccents["É"] = "E"
-- tableAccents["Ê"] = "E"
-- tableAccents["Ë"] = "E"
-- tableAccents["Ì"] = "I"
-- tableAccents["Í"] = "I"
-- tableAccents["Î"] = "I"
-- tableAccents["Ï"] = "I"
-- tableAccents["Ñ"] = "N"
-- tableAccents["Ò"] = "O"
-- tableAccents["Ó"] = "O"
-- tableAccents["Ô"] = "O"
-- tableAccents["Õ"] = "O"
-- tableAccents["Ö"] = "O"
-- tableAccents["Ù"] = "U"
-- tableAccents["Ú"] = "U"
-- tableAccents["Û"] = "U"
-- tableAccents["Ü"] = "U"
-- tableAccents["Ý"] = "Y"

-- function createLog(system,message,player,target)
--     local r = getRealTime()
--     local date = ("%04d-%02d-%02d %02d:%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour,r.minute);
-- 	local filename = "/log_files/".. tostring(system) ..".log";
--     filename = filename:gsub("[%z\1-\127\194-\244][\128-\191]*", tableAccents);
--     if not player then 
--         player = "ISMERETLEN";
--     else 
--         player = exports.fv_admin:getAdminName(player,true);
--     end
--     if not target then 
--         target = "";
--     else 
--         if isElement(target) then
--             target = getElementData(target,"char >> name") or getPlayerName(target);
--         end
--     end
    

-- 	local file = createFileIfNotExists(filename);
-- 	local size = fileGetSize(file);
-- 	fileSetPos(file, size);
-- 	fileWrite(file, "[" .. date .. "] " .. message .. " (PLAYER:"..player..") (TARGET:"..target..") \r\n");
-- 	fileFlush(file);
--     fileClose(file);
--     outputDebugString("   Log: ".. system .." Tartalom: ".. message, 0, 255, 153, 153);
--     collectgarbage();
-- end

-- function createFileIfNotExists(filename)
--     if not fileExists(filename) then 
--         local file = fileCreate(filename);
--         return file;
--     else 
--         local file = fileOpen(filename);
--         return file;
--     end
-- end
