con_name_def = "Írd be a személy nevét"
con_name_t = ""
con_num_def = "Írd be a személy telefonszámát"
con_num_t = ""


function text_render(state)
	if state then
			con_name = guiCreateEdit(x, y, 55, 60, "", true)
			guiSetAlpha(con_name, 0)
			guiEditSetMaxLength(con_name, 27)	
			--guiSetProperty(con_name, "ValidationString", "^[0-9]*$")	

			con_num = guiCreateEdit(x, y, 55, 60, "", true)
			guiSetAlpha(con_num, 0)
			guiEditSetMaxLength(con_num, 27)	
			guiSetProperty(con_num, "ValidationString", "^[0-9]*$")			
	else
		if isElement(con_name) then
			destroyElement(con_name)
		end	

		if isElement(con_num) then
			destroyElement(con_num)
		end	
	end	
end


function textguitrans()
	if sz_using then
			sz_time = sz_time + 1
			if sz_time >= 100 then
				sz_time = 0
			elseif sz_time <= 50 then
				sz_text = '|'
			else
				sz_text = ''
			end
	end

	if sz_using2 then
			sz_time2 = sz_time2 + 1
			if sz_time2 >= 100 then
				sz_time2 = 0
			elseif sz_time2 <= 50 then
				sz_text2 = '|'
			else
				sz_text2 = ''
			end
	end
end	
