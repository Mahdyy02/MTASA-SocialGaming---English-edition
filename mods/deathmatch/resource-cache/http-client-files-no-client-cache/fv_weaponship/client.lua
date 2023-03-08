e = exports.fv_engine;

local sx,sy = guiGetScreenSize();
local panel = 0;
local clicked = false;
local load = 0;
local nextButton = "up";

local fegyverek = {
	{14,1},	--AK
	{15,1},	--M4
	{16,1},	--Katana
	{19,1},	--Kés
	{21,1},	--Sörétes
	{22,1},	--Lefűrészelt cs
	{24,1},	--Colt
	{25,1},	--Sniper
	{26,1},	--Vadászpuska
	{27,1},	--MP5
	{28,1},	--UZI
	{30,1},	--TEC
	{31,2},	--9mm lőszer
	{32,2},	--Sörétes lőszer
	{33,2},	--Nagy kaliber lőszer
};

local infoPed = createPed(43,2505.099609375, -2640.1318359375, 13.86225605011,-90);
setElementData(infoPed,"ped >> name","Gregory Roberson");
setElementData(infoPed,"ped >> type","Hajó Kordinátor");
setElementData(infoPed,"ped.noDamage",true);
setElementFrozen(infoPed,true);

addEventHandler("onClientResourceStart",root,function(res)
	if res == getThisResource() or getResourceName(res) == "fv_engine" then 
		e = exports.fv_engine;
		icons = e:getFont("AwesomeFont",20);
		font = e:getFont("rage",15);
		font2 = e:getFont("rage",12);
		sColor = {e:getServerColor("servercolor",false)};
		red = {e:getServerColor("red",false)};
	end
	if res == getThisResource() then 
		tableRand(fegyverek);
	end
end);

function render()
	local x,y,z = getElementPosition(localPlayer);
	local ox,oy,oz = getElementPosition(clicked);
	local distance = getDistanceBetweenPoints3D(x,y,z,ox,oy,oz);
	if distance > 3 or not clicked or not isElement(clicked) then 
		closePanel();
		outputChatBox(e:getServerSyntax("Weapon ship","red").."Mivel eltávolodtál a doboztól, a kifosztás megszakadt.",255,255,255,true);
	end

if panel == 1 then 
	dxDrawRectangle(sx/2-150,sy/2-50,300,150,tocolor(0,0,0,180));
	dxDrawRectangle(sx/2-153,sy/2-50,3,150,tocolor(sColor[1],sColor[2],sColor[3],180));
	e:shadowedText("SocialGaming - Fegyverláda",0,sy/2-80,sx,0,tocolor(255,255,255),1,font,"center","top");
	dxDrawText("Kiszeretnéd fosztani a dobozt?",0,sy/2-40,sx,0,tocolor(255,255,255),1,font2,"center","top");

	local yesColor = tocolor(sColor[1],sColor[2],sColor[3],180);
	if e:isInSlot(sx/2-150/2,sy/2,150,30) then 
		yesColor = tocolor(sColor[1],sColor[2],sColor[3]);
	end
	dxDrawRectangle(sx/2-150/2,sy/2,150,30,yesColor);
	dxDrawText("Igen",sx/2-150/2,sy/2,sx/2-150/2+150,sy/2+30,tocolor(255,255,255),1,font,"center","center");

	local noColor = tocolor(red[1],red[2],red[3],180);
	if e:isInSlot(sx/2-150/2,sy/2+50,150,30) then 
		noColor = tocolor(red[1],red[2],red[3]);
	end
	dxDrawRectangle(sx/2-150/2,sy/2+50,150,30,noColor);
	dxDrawText("Nem",sx/2-150/2,sy/2+50,sx/2-150/2+150,sy/2+50+30,tocolor(255,255,255),1,font,"center","center");
end

if panel == 2 then 
	dxDrawRectangle(sx/2-155,sy-205,310,50,tocolor(0,0,0,180));
	dxDrawRectangle(sx/2-150,sy-200,load,40,tocolor(sColor[1],sColor[2],sColor[3],180));

	local szazalek = math.floor(load/3);
	dxDrawText(szazalek.."%",sx/2-150,sy-200,sx/2-150+300,sy-200+40,tocolor(0,0,0),1,font,"center","center");

	--UP
	local upColor = tocolor(255,255,255);
	if nextButton == "up" then 
		upColor = tocolor(sColor[1],sColor[2],sColor[3]);
	end
	e:shadowedText("",sx/2-20,sy-250,sx/2-20+40,sy-250+40,upColor,1,icons,"center","center");

	--Down
	local downColor = tocolor(255,255,255);
	if nextButton == "down" then 
		downColor = tocolor(sColor[1],sColor[2],sColor[3]);
	end
	e:shadowedText("",sx/2-20,sy-150,sx/2-20+40,sy-150+40,downColor,1,icons,"center","center");
end
end

addEventHandler("onClientClick",root,function(button,state,x,y,wx,wy,wz,clickedElement)
if not getElementData(localPlayer,"network") then return end;
	if state == "down" then 
		if clickedElement and clickedElement == infoPed then 
			local x,y,z = getElementPosition(localPlayer);
			local distance = getDistanceBetweenPoints3D(x,y,z,wx,wy,wz);			
			if distance < 3 then 
				if isFaction(localPlayer) then 
					triggerServerEvent("ship.getInfo",localPlayer,localPlayer);
				else 
					outputChatBox(e:getServerSyntax("Weapon ship","red").."Csak maffiás beszélgethet vele!",255,255,255,true);
				end
			end
		end

		if clickedElement and getElementData(clickedElement,"ship.box") then
			local x,y,z = getElementPosition(localPlayer);
			local distance = getDistanceBetweenPoints3D(x,y,z,wx,wy,wz);
			if distance < 2 then 
				if isFaction(localPlayer) then 
					if getElementData(clickedElement,"ship.state") then 
						if not (panel > 0) then 
							panel = 1;
							load = 0;
							nextButton = "up";
							removeEventHandler("onClientRender",root,render);
							addEventHandler("onClientRender",root,render);
							clicked = clickedElement;
						end 
					else 
						outputChatBox(e:getServerSyntax("Weapon ship","red").."Ezt a dobozt már kifosztották.",255,255,255,true);
					end
				else 
					outputChatBox(e:getServerSyntax("Weapon ship","red").."Csak maffiás nyithatja ki a dobozt.",255,255,255,true);
				end
			end
		end
	end
end);

addEventHandler("onClientKey",root,function(button,state)
if not getElementData(localPlayer,"network") then return end;
	if panel == 1 then 
		if e:isInSlot(sx/2-150/2,sy/2,150,30) then --Igen
			panel = 2;
			nextButton = "up";
			load = 0;
			setElementData(clicked,"ship.state",false);
		end
		if e:isInSlot(sx/2-150/2,sy/2+50,150,30) then --Nem
			closePanel();
		end
	end
	if panel == 2 then 
		if button == "arrow_u" then 
			if state then 
				if nextButton == "up" then 
					nextButton = "down";
					load = load + math.random(4,5);
					if load >= 300 then 
						openBox();
					end
				else 
					gameOver();
				end
			end
			cancelEvent();
		end
		if button == "arrow_d" then 
			if state then 
				if nextButton == "down" then 
					nextButton = "up";
					load = load + math.random(4,5);
					if load >= 300 then 
						openBox();
					end
				else 
					gameOver();
				end
			end
			cancelEvent();
		end
	end
end);

function closePanel()
	removeEventHandler("onClientRender",root,render);
	panel = 0;
	nextButton = "up";
	load = 0;

	if panel > 1 then 
		if isElement(clicked) then 
			setElementData(clicked,"ship.state",false);
			triggerServerEvent("ship.destroy",localPlayer,localPlayer,clicked);
		end
	end
	clicked = false;
end

function gameOver()
	triggerServerEvent("ship.destroy",localPlayer,localPlayer,clicked);
	outputChatBox(e:getServerSyntax("Weapon ship","red").."You messed up opening the chest.",255,255,255,true);
	closePanel();
end

function openBox()
	tableRand(fegyverek);
	triggerServerEvent("ship.giveItems",localPlayer,localPlayer,clicked,fegyverek);
	closePanel();
end