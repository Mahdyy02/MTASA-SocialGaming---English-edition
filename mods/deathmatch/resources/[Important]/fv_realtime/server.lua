exports.fv_admin:addAdminCommand("settime", 8, "Change server time")
addCommandHandler("st",
	function (player, command, hour, minute)
		print("as")
		if getElementData(player, "admin >> level") >= 8 then
			if not hour then
				outputChatBox(exports.fv_engine:getServerSyntax("Use","red") .. "/" .. command .. " [hours (* = real time)] [minutes]", player, 0, 0, 0, true)
			else
				hour = tonumber(hour) or 12
				minute = tonumber(minute) or 0

				if hour < 0 or hour > 23 then
					outputChatBox(exports.fv_engine:getServerSyntax("Time","red") .. "The clock cannot be less than #ff46460 #fffffand cannot be more than #ff464623 #ffffff.", player, 0, 0, 0, true)
					return
				end

				if minute < 0 and minute > 59 then
					outputChatBox(exports.fv_engine:getServerSyntax("Time","red").. "Minute cannot be less than #ff46460 #fffffand cannot be more than #ff464659 #ffffff.", player, 0, 0, 0, true)
					return
				end

				setTime(hour, minute)
				outputChatBox(exports.fv_engine:getServerSyntax("Time","red") .. "Time successfully reset! #ffa600(" .. string.format("%.2i:%.2i", hour, minute) .. ")", player, 0, 0, 0, true)
			end
		end
	end
)