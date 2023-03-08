addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if tostring(getResourceName(res)) == "fv_engine" or res == getThisResource() then 
        e = exports.fv_engine;
		font = e:getFont("rage",13);
        font2 = e:getFont("rage",10);
        font3 = e:getFont("Yantramanav-Regular", 15);
        font4 = e:getFont("rage", 10);
		bigIcons = e:getFont("AwesomeFont",28);
		sColor = {e:getServerColor("servercolor",false)};
		sColor2 = e:getServerColor("servercolor",true);
		red = {e:getServerColor("red",false)};
		red2 = e:getServerColor("red",true);
		blue = {e:getServerColor("blue",false)};
        orange = {e:getServerColor("orange",false)};
        white = "#FFFFFF";
	end
end)

sx,sy = guiGetScreenSize();
local zoom = math.min(1,sx / 1980);
res = function(value)
    return zoom * value;
end
resFont = function(value)
    return math.ceil(zoom * value);
end

local shader,screenSrc = false,false;
local widgets = {
    --[widget] = {x,y,w,h,show name, showing, sizable},
    ["hud"] = {sx-300,10,290,82,"HUD",false},
    ["fps"] = {sx-300,100,60,25,"FPS",false},
    ["ping"] = {sx-90,100,80,30,"Ping",false},
    ["radar"] = {5,sy-265,350,250,"Radar",true,true,200,600},
    ["speedo"] = {sx-345,sy-340,330,330,"Mileage",true},
    ["rpm"] = {sx-460,sy-150,140,140,"Speed",true},
    ["tempomat"] = {sx-215,sy-370,200,25,"Cruise control",false},
    ["vga"] = {sx-300,sy/2-42.5,290,85,"Video card",false},
    ["name"] = {sx/2-150,sy-95,300,30,"Name",false},
    ["actionbar"] = {sx/2-150,sy-60,290,50,"ActionBar",true},
    ["bone"] = {sx-res(355),res(70),50,80,"Bones",true},
    ["phone"] = {sx-255,sy/2-250,250,500,"Telephone",true},
    ["weapon"] = {sx-245,res(265),240,100,"Weapon",true},
    ["coin"] = {sx/2-100,sy/2+100,200,30,"Casino Coin",false},
    ["hud.hp"] = {sx-res(305),res(10),res(300),res(40),"Vitality",true,true,res(150),res(500),true},
    ["hud.armor"] = {sx-res(305),res(55),res(300),res(40),"Armor",true,true,res(150),res(500),true},
    ["hud.hunger"] = {sx-res(305),res(100),res(300),res(40),"Hunger",true,true,res(150),res(500),true},
    ["hud.drink"] = {sx-res(305),res(145),res(300),res(40),"Thirst",true,true,res(150),res(500),true},
    ["hud.stamina"] = {sx-res(305),res(190),res(300),res(40),"Energy",true,true,res(150),res(500),true},
    ["money"] = {sx-res(305),res(230),res(300),res(30),"Cash",true},
    ["clock"] = {sx-res(405),res(10),res(100),res(30),"Hours",true},
}
local cPos = {};
local isEditing = false;
local moved = false;
local offsetX,offsetY = 0,0;
local cursorX, cursorY = -1,-1;
local resize = false;
local resizeHover = false;

function getWidgetDatas(name)
    return unpack(cPos[name] or {});
end
function isWidgetShowing(name)
    if cPos[name] and cPos[name][6] then
    return cPos[name][6]
    end
    return false
end

function render()
    resizeHover = false;
    if isCursorShowing() then 
        cursorX, cursorY = getCursorPosition();
        cursorX, cursorY = cursorX * sx, cursorY * sy;
    else 
        isEditing = false;
        removeEventHandler("onClientRender",root,render);
        if shader then 
            destroyElement(shader);
        end
        shader = false;
        screenSrc = false;
        showChat(true);
        resize = false;
        resizeHover = false;
    end
    if screenSrc and shader then 
        dxUpdateScreenSource(screenSrc);
        dxDrawImage(0, 0, sx,sy, shader);
    end

    shadowedText("Edit Widgets",0,-90,sx,sy,tocolor(255,255,255),1,font3,"center","center");

    local deleteColor = tocolor(255,255,255);
    if exports.fv_engine:isInSlot(sx/2-60,sy/2-25,50,50) then 
        deleteColor = tocolor(red[1],red[2],red[3]);
        tooltip("Deletion")
    end
    shadowedText("",sx/2-60,sy/2-25,sx/2-60+50,sy/2-25+50,deleteColor,1,bigIcons,"center","center");

    local resetColor = tocolor(255,255,255);
    if exports.fv_engine:isInSlot(sx/2+10,sy/2-25,50,50) then 
        resetColor = tocolor(sColor[1],sColor[2],sColor[3]);
        tooltip("Basic situation");
    end
    shadowedText("",sx/2+10,sy/2-25,sx/2+10+50,sy/2-25+50,resetColor,1,bigIcons,"center","center");

    if resize then 
        local widget = cPos[resize[1]];
        if resize[2] == "width" then 
            local new = math.max(widget[8], math.min(widget[9], resize[4] + (cursorX -resize[3])));
            cPos[resize[1]][3] = new;
            setElementData(localPlayer,resize[1]..".w",new);
        elseif resize[2] == "height" then 
            local new = math.max(widget[8], math.min(widget[9], resize[4] + (cursorY -resize[3])));
            cPos[resize[1]][4] = new;
            setElementData(localPlayer,resize[1]..".h",new);
        end
    end

    for k,v in pairs(cPos) do 
        local x,y,w,h,name,showing,sizable,min,max = unpack(v);
        if showing then 
            if moved == k then 
                x,y = cursorX+offsetX,cursorY+offsetY;
                cPos[k] = {x,y,w,h,name,showing,sizable,min,max};
                setElementData(localPlayer,k..".x",x);
                setElementData(localPlayer,k..".y",y);
                setElementData(localPlayer,k..".w",w);
                setElementData(localPlayer,k..".h",h);
                setElementData(localPlayer,k..".name",name);
                setElementData(localPlayer,k..".showing",showing);
            end
            dxDrawRectangle(x,y,w,h,tocolor(sColor[1],sColor[2],sColor[3],100),true);

            if sizable and not resizeHover then 
                if exports.fv_engine:isInSlot(x+w-10,y,10,h) then 
                    shadowedText("",cursorX,cursorY,cursorX,cursorY,tocolor(255,255,255),1,exports.fv_engine:getFont("AwesomeFont",13),"center","center");
                    resizeHover = k;
                elseif exports.fv_engine:isInSlot(x,y+h-10,w,10) then 
                    if tostring(v[10]) == "nil" then 
                        shadowedText("",cursorX,cursorY,cursorX,cursorY,tocolor(255,255,255),1,exports.fv_engine:getFont("AwesomeFont",13),"center","center");
                        resizeHover = k;
                    end
                end
            end

            if h >= 20 or w >= 200 then 
                shadowedText(name,x,y,x+w,y+h,tocolor(255,255,255),1,font,"center","center",false,false,true,true);
            end
        end
    end

    if resizeHover then 
        setCursorAlpha(0);
    else 
        setCursorAlpha(255);
    end

    local unused,count = getUnusedWidgets();
    if count > 0 then 
        dxDrawRectangle(sx/2-150,10,300,25,tocolor(0,0,0,200));
        dxDrawRectangle(sx/2-152,10,2,25,tocolor(sColor[1],sColor[2],sColor[3]));
        dxDrawText("Inactive Widgets",sx/2-150,10,sx/2-150+300,10+25,tocolor(255,255,255),1,font,"center","center");

        dxDrawRectangle(sx/2-130,35,260,25+(count*30),tocolor(0,0,0,100));
        local a = 0;
        for k,v in pairs(unused) do 
            local x,y,w,h,name,showing = unpack(v);
            if not showing then 
                a = a + 1;
                local color = tocolor(0,0,0,100);
                local shadowed = false;
                if exports.fv_engine:isInSlot(sx/2-120,10+(a*30),240,25) then 
                    color = tocolor(sColor[1],sColor[2],sColor[3]);
                    shadowed = true;
                end
                dxDrawRectangle(sx/2-120,10+(a*30),240,25,color);
                if shadowed then 
                    exports.fv_engine:shadowedText(name,sx/2-120,10+(a*30),sx/2-120+240,10+(a*30)+25,tocolor(255,255,255),1,font2,"center","center");
                else 
                    dxDrawText(name,sx/2-120,10+(a*30),sx/2-120+240,10+(a*30)+25,tocolor(255,255,255),1,font2,"center","center");
                end
            end
        end
    end
end

addEventHandler("onClientClick",root,function(button,state,iksz,ipszilon)
	if isEditing then
        if button == "left" and state == "down" then
            if not moved and not resize then 
                for k,v in pairs(cPos) do 
                    local x,y,w,h,name,showing, sizable = unpack(v);
                    if showing then 
                        if (sizable and exports.fv_engine:isInSlot(x,y,w-10,h-10)) or (not sizable and exports.fv_engine:isInSlot(x,y,w,h)) then 
                            moved = k;
                            offsetX,offsetY = x-iksz,y-ipszilon;
                            break;
                        end
                    end
                end
                --Resize
                if resizeHover then 
                    local widget = cPos[resizeHover];
                    if exports.fv_engine:isInSlot(widget[1]+widget[3]-10,widget[2],10,widget[4]) then --Width Resize 
                        resize = {resizeHover,"width",iksz,widget[3]};
                    elseif exports.fv_engine:isInSlot(widget[1],widget[2]+widget[4]-10,widget[3],10) and  tostring(v[10]) == "nil" then
                        resize = {resizeHover,"height",ipszilon,widget[4]};
                    end
                end
                --------
                local unused,count = getUnusedWidgets();
                local a = 0;
                for k,v in pairs(unused) do 
                    a = a + 1;
                    if exports.fv_engine:isInSlot(sx/2-120,10+(a*30),240,25) then 
                        local x,y,w,h,name,showing = unpack(widgets[k]);
                        cPos[k][1] = x;
                        cPos[k][2] = y;
                        cPos[k][3] = w;
                        cPos[k][4] = h;
                        cPos[k][5] = name;
                        cPos[k][6] = true;
                        setElementData(localPlayer,k..".x",x);
                        setElementData(localPlayer,k..".y",y);
                        setElementData(localPlayer,k..".w",w);
                        setElementData(localPlayer,k..".h",h);
                        setElementData(localPlayer,k..".name",name);
                        setElementData(localPlayer,k..".showing",true);
                    end
                end
            end
        elseif button == "left" and state == "up" then 
            if moved then 
                if exports.fv_engine:isInSlot(sx/2+10,sy/2-25,50,50) then --Reset widget
                    cPos[moved][1] = widgets[moved][1];
                    cPos[moved][2] = widgets[moved][2];
                    cPos[moved][3] = widgets[moved][3];
                    cPos[moved][4] = widgets[moved][4];
                    cPos[moved][5] = widgets[moved][5];
                    setElementData(localPlayer,moved..".x",widgets[moved][1]);
                    setElementData(localPlayer,moved..".y",widgets[moved][2]);
                    setElementData(localPlayer,moved..".w",widgets[moved][3]);
                    setElementData(localPlayer,moved..".h",widgets[moved][4]);
                    setElementData(localPlayer,moved..".name",widgets[moved][5]);
                    setElementData(localPlayer,moved..".showing",true);
                end 
                if exports.fv_engine:isInSlot(sx/2-60,sy/2-25,50,50) then --Delete widget
                    if moved ~= "phone" then 
                        cPos[moved][6] = false;
                        setElementData(localPlayer,moved..".showing",false);
                    end
                end
                moved = false;
                offsetX,offsetY = 0,0;
            end
            if resize then 
                resize = false;
            end
        end
    end
end);

addEventHandler("onClientKey",root,function(button,state)
if not getElementData(localPlayer,"loggedIn") then return end;
if not isCursorShowing() then return end;
    if button == "lctrl" or button == "rctrl" and isCursorShowing() then 
        if state then 
            removeEventHandler("onClientRender",root,render);
            addEventHandler("onClientRender",root,render);
            isEditing = true;
            if shader then 
                destroyElement(shader);
            end
            screenSrc = dxCreateScreenSource(sx, sy);
            shader = dxCreateShader("blackWhiteBlur.fx");
            dxSetShaderValue(shader, "UVSize", sy, sy);
            dxSetShaderValue(shader, "screenSource", screenSrc);
            showChat(false);
        else 
            isEditing = false;
            removeEventHandler("onClientRender",root,render);
            if shader then 
                destroyElement(shader);
            end
            shader = false;
            showChat(true);
            moved = false;
            offsetX,offsetY = 0,0;
        end
    end
end);   


function saveWidgets()
	if fileExists("widgets.xml") then
		fileDelete("widgets.xml");
	end
	local xmlNode = xmlCreateFile("widgets.xml","root");
	for k,v in pairs(cPos) do 
		local w = xmlCreateChild(xmlNode,k);
		xmlNodeSetValue(xmlCreateChild(w,"x"),v[1]);
		xmlNodeSetValue(xmlCreateChild(w,"y"),v[2]);
		xmlNodeSetValue(xmlCreateChild(w,"w"),v[3]);
		xmlNodeSetValue(xmlCreateChild(w,"h"),v[4]);
		xmlNodeSetValue(xmlCreateChild(w,"show"),tostring(v[6]));
	end
	outputDebugString("widgets position saved!",0,100,100,100);
	xmlSaveFile(xmlNode);
end
addEventHandler("onClientResourceStop",resourceRoot,saveWidgets);

function loadWidgets()
	local xmlNode = false;
	if fileExists("widgets.xml") then 
		xmlNode = xmlLoadFile("widgets.xml");
		for k,v in pairs(widgets) do 
			cPos[k] = {};
			local w = xmlFindChild(xmlNode,tostring(k),0);
			if w then 
				local x = xmlNodeGetValue(xmlFindChild(w,"x",0));
				local y = xmlNodeGetValue(xmlFindChild(w,"y",0));
				local ww = xmlNodeGetValue(xmlFindChild(w,"w",0));
				local h = xmlNodeGetValue(xmlFindChild(w,"h",0));
				local show = xmlNodeGetValue(xmlFindChild(w,"show",0));
				if show == "true" then 
					show = true;
				else 
					show = false;
                end
				cPos[k][1] = tonumber(x) or widgets[k][1];
				cPos[k][2] = tonumber(y) or widgets[k][2];
				cPos[k][3] = tonumber(ww) or widgets[k][3];
				cPos[k][4] = tonumber(h) or widgets[k][4];
				cPos[k][5] = widgets[k][5];
				cPos[k][6] = show;
				cPos[k][7] = widgets[k][7];
				cPos[k][8] = widgets[k][8];
				cPos[k][9] = widgets[k][9];
				cPos[k][10] = widgets[k][10];
			else 
				cPos[k] = widgets[k];
			end
		end
		for k,v in pairs(cPos) do
			local x,y,w,h,nev,show = unpack(v)
			setElementData(localPlayer, k .. ".x", x);
			setElementData(localPlayer, k .. ".y", y);
			setElementData(localPlayer, k .. ".w", w);
			setElementData(localPlayer, k .. ".h", h);	
			setElementData(localPlayer, k .. ".showing", show);	
		end
		outputDebugString("widgets position loaded!",0,100,100,100);
        xmlUnloadFile(xmlNode);
    else
        cPos = {};
        for k,v in pairs(widgets) do 
            local x,y,w,h,nev,show = unpack(v);
            cPos[k] = {x,y,w,h,nev,show};
            setElementData(localPlayer, k .. ".x", x);
			setElementData(localPlayer, k .. ".y", y);
			setElementData(localPlayer, k .. ".w", w);
			setElementData(localPlayer, k .. ".h", h);	
			setElementData(localPlayer, k .. ".showing", show);	
        end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, loadWidgets);

addCommandHandler("resethud",function(command)
if not getElementData(localPlayer,"loggedIn") then return end;
	cPos = {};
	moved = false;
	for k,v in pairs(widgets) do 
		cPos[k] = widgets[k];
	end
	for k,v in pairs(cPos) do
		local x,y,w,h,nev,show = unpack(v)
		setElementData(localPlayer, k .. ".x", x);
		setElementData(localPlayer, k .. ".y", y);
		setElementData(localPlayer, k .. ".w", w);
		setElementData(localPlayer, k .. ".h", h);	
		setElementData(localPlayer, k .. ".showing", show);	
	end
	outputChatBox(exports.fv_engine:getServerSyntax("Interface","servercolor").."You have successfully reset the widgets.",255,255,255,true);
end);



--UTILS--
function getUnusedWidgets()
    local table = {};
    local count = 0;
    for k,v in pairs(cPos) do 
        local x,y,w,h,name,showing = unpack(v);
        if not showing then 
            table[k] = {x,y,w,h,name,showing};
            count = count + 1;
        end
    end
    return table,count;
end
function tooltip(text)
	local cx,cy = getCursorPosition();
	cx,cy = cx*sx,cy*sy;
	cx,cy = cx+10,cy+10;
	local width = dxGetTextWidth(text,1,font4)+10;
	dxDrawRectangle(cx-5,cy,width,20,tocolor(255,255,255,200),true);
	dxDrawText(text,cx-5,cy,(cx-5)+width,cy+20,tocolor(0,0,0),1,font4,"center","center",false,false,true,true);
end
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, true, true)
end
function formatMoney(value)
    return exports.fv_dx:formatMoney(value);
end