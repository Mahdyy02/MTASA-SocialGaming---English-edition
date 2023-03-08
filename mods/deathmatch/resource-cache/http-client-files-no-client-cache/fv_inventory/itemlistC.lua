----- [ Itemlista ] -----

local itemListShow = false;
local gui_itemList = false;
local iL_sz, iL_m = 350, 500
local iL_x, iL_y = sx/2 - iL_sz/2, sy/2 - iL_m/2
local itemKivalasztva = 1;
local itemListItemek = {};
local itemListHonnan = 0;

addCommandHandler ( "itemlist", function ( )
    if getElementData(localPlayer,"admin >> level") > 7 then 
        if getElementData ( localPlayer, "loggedIn") then
            if ( itemListShow ) then
                closeItemList();
            else
                showItemList();
            end
        end
    end
end)

function showItemList ( )
	itemListShow = true;
	gui_itemList = guiCreateEdit ( iL_x + 10, iL_y + 5, 100, 20, "", false )
	guiSetAlpha(gui_itemList,0);
	addEventHandler ( "onClientRender", root, drawItemList );
end

function closeItemList ()
	if (gui_itemList) then
		destroyElement ( gui_itemList )
		gui_itemList = false;
	end
	itemListShow = false;
	removeEventHandler ( "onClientRender", root, drawItemList );
end

addEventHandler ("onClientClick", root, function ( button, state )
	if (itemListShow) then
		if (button =="left" and state =="up") then
			for i = 1, 10 do
				if (itemListItemek[i+itemListHonnan]) then
					if (e:isInSlot ( iL_x + 10, iL_y + (i*35), iL_sz - 20, 30)) then
						if itemKivalasztva == (i+itemListHonnan) then
							local id = itemListItemek[i+itemListHonnan][#itemListItemek[i+itemListHonnan]]
							-- if getElementData(localPlayer,"admin >> level") == 8 then --FőAdmin
							-- 	if social_itemlista[id][5] ~= 3 then 
							-- 		outputChatBox (exports.fv_engine:getServerSyntax("Item","red").. "Csak kulcs!", player,255,255,255,true );
							-- 		return;
							-- 	end
							-- end
							triggerServerEvent ( "itemlist.giveItem", localPlayer, localPlayer, id, 1, 0, 100, 0);
						else
							itemKivalasztva = i + itemListHonnan;
						end
					end

				end
			end
			
			if e:isInSlot ( iL_x + iL_sz - 20, iL_y, 20, 30) then
				closeItemList();
			end
		end
	end
end)


addEventHandler ("onClientKey", root ,function (button, pressed)
	if (itemListShow) then
		if (pressed) then
			if (button  == "mouse_wheel_down") then
				if ( #itemListItemek > 10 ) then
					itemListHonnan = itemListHonnan + 1;
					if (itemListHonnan > (#itemListItemek - 10)) then
						itemListHonnan = #itemListItemek - 10;
					end
				end
			end
			
			if (button == "mouse_wheel_up" ) then
				if itemListHonnan > 0 then
					itemListHonnan = itemListHonnan - 1;
				end
			end
		end
	end
end)


function drawItemList()
	if (itemListShow ) then
	
		dxDrawRectangle ( iL_x, iL_y, iL_sz, iL_m, tocolor (szurke, szurke, szurke, 255) )
		dxDrawRectangle ( iL_x, iL_y, iL_sz, 30, tocolor ( 0,0,0, 160 ) )
		dxDrawRectangle ( iL_x + 10, iL_y + 5, 100, 20, tocolor ( 60,60,60,255 ))
		dxDrawText ( guiGetText(gui_itemList),iL_x + 15, iL_y + 15, iL_x + 15, iL_y + 15, tocolor ( 255,255,255,255 ), 1, e:getFont("rage",12), "left", "center" );
		if not(e:isInSlot ( iL_x + iL_sz - 20, iL_y, 20, 30)) then		
			dxDrawText ( "X", iL_x + iL_sz - 2, iL_y + 15, iL_x + iL_sz - 2, iL_y + 15, tocolor ( 255,255,255,255 ), 1, e:getFont("rage",15), "right", "center" )
		else
			dxDrawText ( "X", iL_x + iL_sz - 2, iL_y + 15, iL_x + iL_sz - 2, iL_y + 15, tocolor ( 255,48,48,255 ), 1, e:getFont("rage",15), "right", "center" )		
		end
		
		
		if (( guiGetText(gui_itemList) ~= "Search") and (guiGetText(gui_itemList) ~= "")) then
			itemListItemek = {};
			for i , k in pairs ( social_itemlista ) do
				if (string.find (string.lower(social_itemlista[i][1]), string.lower(guiGetText(gui_itemList))) ~= nil) then
					itemListItemek[#itemListItemek+1] = social_itemlista[i]
				local szam = #social_itemlista[i]
				itemListItemek[#itemListItemek][szam+1] = i;
				end
			end
		else
			itemListItemek = {};
			for i, k in pairs( social_itemlista) do
				itemListItemek[#itemListItemek+1] = social_itemlista[i]
				local szam = #social_itemlista[i]
				itemListItemek[#itemListItemek][szam+1] = i;
			end
		end
		
		if (itemListHonnan + 10 > #itemListItemek) then
			itemListHonnan = 0;
		end
		
		
		
		for i = 1, 10 do
				if (itemKivalasztva == (i + itemListHonnan) ) then
					if (itemListItemek[i+itemListHonnan]) then
						dxDrawRectangle ( iL_x + 10, iL_y + (i*35), iL_sz - 20, 30, tocolor ( sColor[1],sColor[2],sColor[3],255 ) ) 
					else
						itemKivalasztva = 1;
						dxDrawRectangle ( iL_x + 10, iL_y + (i*35), iL_sz - 20, 30, tocolor ( 20,20,20,255 ) ) 
					end
				else
					dxDrawRectangle ( iL_x + 10, iL_y + (i*35), iL_sz - 20, 30, tocolor ( 20,20,20,255 ) ) 
				end
			
			if (#itemListItemek > 0) then
				if itemListItemek[i+itemListHonnan] then
					dxDrawText ( itemListItemek[i+itemListHonnan][1], iL_x + 15, iL_y + (i*35) + 15,iL_x + 15, iL_y + (i*35) + 15,tocolor ( 255,255,255,255), 1, e:getFont("rage",13), "left", "center", false, false, false, true );
				end
			end
		end
		
		
		if (itemListItemek[itemKivalasztva]) then
			
			dxDrawImage ( iL_x + iL_sz/2 - itemSize/2, iL_y + (iL_m - 100), itemSize, itemSize, getItemImage(itemListItemek[itemKivalasztva][#itemListItemek[itemKivalasztva]]) )
			dxDrawText ( "Name: ".. sColor2 .. itemListItemek[itemKivalasztva][1] , iL_x + 5, iL_y + iL_m - 50,iL_x + 5, iL_y + iL_m - 50,tocolor(255,255,255,255),1,e:getFont("rage",13),"left","center",false,false,false,true  )
			dxDrawText ( "ID: ".. sColor2 ..itemListItemek[itemKivalasztva][#itemListItemek[itemKivalasztva]] , iL_x + iL_sz, iL_y + iL_m - 50,iL_x + iL_sz, iL_y + iL_m - 50,tocolor(255,255,255,255),1,e:getFont("rage",13),"right","center",false,false,false,true)
			if ( itemListItemek[itemKivalasztva][2] ) then
				dxDrawText ( "Wear out" , iL_x + 5, iL_y + iL_m - 30,iL_x + 5, iL_y + iL_m - 30,tocolor(255,255,255,255),1,e:getFont("rage",13),"left","center"  )
			else
				dxDrawText ( "It will not wear out" , iL_x + 5, iL_y + iL_m - 30,iL_x + 5, iL_y + iL_m - 30,tocolor(255,255,255,255),1,e:getFont("rage",13),"left","center"  )
			end
			
			if (itemListItemek[itemKivalasztva][3]) then
				dxDrawText ( "stackable" , iL_x + 5, iL_y + iL_m - 10,iL_x + 5, iL_y + iL_m - 10,tocolor(255,255,255,255),1,e:getFont("rage",13),"left","center"  )
			else
				dxDrawText ( "Cannot be stacked" , iL_x + 5, iL_y + iL_m - 10,iL_x + 5, iL_y + iL_m - 10,tocolor(255,255,255,255),1,e:getFont("rage",13),"left","center"  )
			end
			
			dxDrawText ("Weight: ".. sColor2..itemListItemek[itemKivalasztva][4] .. "kg", iL_x + iL_sz, iL_y + iL_m - 30,iL_x +  iL_sz, iL_y + iL_m - 30,tocolor(255,255,255,255),1,e:getFont("rage",13),"right","center",false,false,false,true )
			dxDrawText ("Category: ".. sColor2..getItemType(itemListItemek[itemKivalasztva][#itemListItemek[itemKivalasztva]]), iL_x  + iL_sz, iL_y + iL_m - 10,iL_x  + iL_sz, iL_y + iL_m - 10,tocolor(255,255,255,255),1,e:getFont("rage",13),"right","center",false,false,false,true )
		end
	end
end