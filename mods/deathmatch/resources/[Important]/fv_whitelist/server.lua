local serials = {
    ["D7896CF67693A8014C5ADE794A90C294"] = true, --Akit nem törölsz ki de ezt már tudhatod!
    ["77FD9200372CB9E2D0B730CD4AEF7694"] = true, --Nevils Bástya
	["7562EC785C329A35DDE21EF265419B94"] = true, --JeffiX ---NE TÖRÖLD
    ["9EF68F43FD62E0EF0F822CAF7A8AFEA3"] = true, --Peti
    ["2CC9A72F6C5B96C9BABDCE4B2780F544"] = true, --Ibacs
}

addEventHandler("onPlayerJoin",getRootElement(),function()
    if not serials[getPlayerSerial(source)] then 
        local nick,ip = getPlayerName(source),getPlayerIP(source);
        outputServerLog(nick.." megpróbált csatlakozni a szerverre. IP: "..ip);
        outputDebugString(nick.." megpróbált csatlakozni a szerverre. IP: "..ip,0,200,0,0);
        kickPlayer(source,"WhiteList","Szerver jelenleg fejlesztés alatt áll!");
        cancelEvent();
    end
end);
addEventHandler("onResourceStart",resourceRoot,function()
    for k,v in pairs(getElementsByType("player")) do 
        if not serials[getPlayerSerial(v)] then 
            kickPlayer(v,"WhiteList","Tuning rendszer bekerül, türelem...");
        end
    end
end);