white = "#FFFFFF";

function payCommand(player,command,target,value)
    if getElementData(player,"loggedIn") and getElementData(player,"network") then 
        if not target or not value or not tonumber(value) or not math.floor(tonumber(value)) or tonumber(value) < 0 then 
            outputChatBox(exports.fv_engine:getServerSyntax("Use","red").."/"..command.." [Name/ID] [Amount]",player,255,255,255,true);
            return;
        end
        local value = math.floor(tonumber(value));
        local targetPlayer = exports.fv_engine:findPlayer(player,target);
        if targetPlayer then 
            if targetPlayer == player then 
                outputChatBox(exports.fv_engine:getServerSyntax("Pay","red").."You can't give yourself money!",player,255,255,255,true);
                return;
            end
            if not getElementData(targetPlayer,"network") then 
                return;
            end
            if value == 0 then 
                outputChatBox(exports.fv_engine:getServerSyntax("Pay","red").."The amount of money you entered is incorrect!",player,255,255,255,true);
                return;
            end
            if not getElementData(targetPlayer,"loggedIn") then 
                outputChatBox(exports.fv_engine:getServerSyntax("Pay","red").."Player is not logged in!",player,255,255,255,true);
                return;
            end
			
			if getElementData(player, "isPlayerPaying") then
				return outputChatBox(exports.fv_engine:getServerSyntax("Pay","red").."Wait 5 secondes to use this command again",player,255,255,255,true);
			end
			
            local x,y,z = getElementPosition(player);
            local tx,ty,tz = getElementPosition(targetPlayer);
            local distance = getDistanceBetweenPoints3D(x,y,z,tx,ty,tz);
            if distance < 3 then 
                if getElementData(player,"char >> money") < value then 
                    outputChatBox(exports.fv_engine:getServerSyntax("Pay","red").."You don't have enough money.",player,255,255,255,true);
                    return;
                end
                local blue = exports.fv_engine:getServerColor("blue",true);
                outputChatBox(exports.fv_engine:getServerSyntax("Pay","red").."Wait "..blue.."5 "..white.."seconds while you hand over the money!",player,255,255,255,true);
                setElementData ( player, "isPlayerPaying", true);
                local oMoney = getElementData(player,"char >> money");
                setTimer(function()
                    if isElement(player) and isElement(targetPlayer) and getElementData(player,"network") and getElementData(targetPlayer,"network") then 
                        if oMoney ~= getElementData(player,"char >> money") then 
                            return
                        end
                        local x,y,z = getElementPosition(player);
                        local tx,ty,tz = getElementPosition(targetPlayer);
                        local distance = getDistanceBetweenPoints3D(x,y,z,tx,ty,tz);
                        if distance > 3 then 
							setElementData ( player, "isPlayerPaying", false);
                            outputChatBox(exports.fv_engine:getServerSyntax("Pay","red").."Money transfer is interrupted because you are too far apart!",player,255,255,255,true);
                            return;
                        end

                        local ado = math.floor(value/50);
                        exports.fv_dash:giveFactionMoney(23,ado);
                        local real = value-ado;
                        setElementData(player,"char >> money",getElementData(player,"char >> money") - value);
                        setElementData(targetPlayer,"char >> money",getElementData(targetPlayer,"char >> money") + real);
                        local sColor = exports.fv_engine:getServerColor("servercolor",true);
                        local red = exports.fv_engine:getServerColor("red",true);
                        outputChatBox(exports.fv_engine:getServerSyntax("Pay","servercolor").."You have passed successfully "..sColor..formatMoney(real)..white.." dt to "..sColor..getElementData(targetPlayer,"char >> name")..red.."(Tax: "..ado.." dt)"..white..".",player,255,255,255,true);
                        outputChatBox(exports.fv_engine:getServerSyntax("Pay","servercolor")..sColor..getElementData(player,"char >> name")..white.." handed "..sColor..formatMoney(real)..white.." dt to you."..red.."(Tax: "..ado.." dt)"..white..".",targetPlayer,255,255,255,true);
                        exports.fv_logs:createLog("PAY",getElementData(player,"char >> name").." submitted " ..formatMoney(value).." dt to "..getElementData(targetPlayer,"char >> name"));
						setElementData ( player, "isPlayerPaying", false);
                    end
                end,1000*5,1);
            else 
                outputChatBox(exports.fv_engine:getServerSyntax("Pay","red").."Player is far from you.",player,255,255,255,true);
            end
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Pay","red").."Player not found!",player,255,255,255,true);
            return;
        end
    end
end
addCommandHandler("pay",payCommand,false,false);