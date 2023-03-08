removeWorldModel(1412,9999999,0,0,0);

local white = "#FFFFFF";
local apiKey = "AIzaSyD6Fut-I0Ypu92noRw5mk_bZmraQwBttXs";
local movieTimer = false;
local linkSave,allLength,timeLeft = false,false,false;

function startMovie(player,cmd,link)
    if getElementData(player,"admin >> level") > 10 then 
    if not link then 
        return outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..cmd.." [YT Video ID]",player,255,255,255,true);
    end
        local fetch = fetchRemote("https://www.googleapis.com/youtube/v3/videos?id="..link.."&key="..apiKey.."&fields=items(snippet(title),contentDetails(duration))&part=snippet,contentDetails",2,1000,function(data,err,url,player)
            local info = fromJSON(data);
            local title, length = false, false;
            for _,v in pairs(info.items) do
                title = v.snippet.title
                length = v.contentDetails.duration
            end
            local hr = length:match('PT(.-)H') or 0
            local min = length:match('H(.-)M') or length:match('PT(.-)M') or 0
            local sec = length:match('M(.-)S') or length:match('H(.-)S') or length:match('PT(.-)S') or 0

            if sec then length = sec end
            if min and sec then length = (min*60) +tonumber(sec) end
            if hr and min and sec then length = hr*60*60+min*60+sec end

            outputChatBox(exports.fv_engine:getServerSyntax("Cinema","servercolor").."The film started at "..exports.fv_engine:getServerColor("servercolor",true).."At Los Santos Airport"..white.." car in Cinema.",root,255,255,255,true);
            outputChatBox(exports.fv_engine:getServerSyntax("Cinema","servercolor").."Film: "..exports.fv_engine:getServerColor("servercolor",true)..title.."#FFFFFF.",root,255,255,255,true);
            outputChatBox(exports.fv_engine:getServerSyntax("Cinema","servercolor").."Movie Length: "..exports.fv_engine:getServerColor("servercolor",true)..hr..":"..min..":"..sec..white..".",root,255,255,255,true);

            -- outputChatBox(title.."  "..length.." -> "..hr..":"..min..":"..sec);

            timeLeft = length;
            allLength = length;
            linkSave = link;

            if isTimer(movieTimer) then 
                killTimer(movieTimer);
            end
            movieTimer = setTimer(function()
                timeLeft = timeLeft - 1;
                if timeLeft <= 0 then 
                    killTimer(movieTimer);
                    linkSave,allLength,timeLeft = false,false,false;
                    restartResource(getThisResource());
                end
            end,1000,0);
            triggerClientEvent(root,"movie.syncClients",root,linkSave,timeLeft,allLength);

        end,"",true,url,player);
    end
end
addCommandHandler("startMovie",startMovie,false,false);

addEventHandler("onPlayerJoin",root,function()
    triggerClientEvent(source,"movie.syncClients",source,linkSave,timeLeft,allLength);
end);

addEventHandler("onClientElementDataChange",root,function(dataName,oldValue,newValue)
    if getElementType(source) == "player" and dataName == "loggedIn" and newValue then 
        triggerClientEvent(source,"movie.syncClients",source,linkSave,timeLeft,allLength);
    end
end);

addCommandHandler("resetCinema",function(player)
    triggerClientEvent(player,"movie.syncClients",player,linkSave,timeLeft,allLength);
end);