sx,sy = guiGetScreenSize();
local color = {124, 197, 118}
local edits = {};
local lastChange = 0;
local numbers = {
    ["0"] = true,
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = true,
    ["6"] = true,
    ["7"] = true,
    ["8"] = true,
    ["9"] = true,
};
local zoom = math.min(1,sx / 1980);
res = function(value)
    return zoom * value;
end
resFont = function(value)
    return math.ceil(zoom * value);
end

function dxCreateEdit(name,text,defaultText,x,y,w,h,type,maxLength)
    if not maxLength then maxLength = 999999999999 end;
    if not type then type = 1 end;
    local id = #edits + 1;
    local fontsize = h/2.5
    edits[id] = {name,text,defaultText,x,y,w,h,exports.fv_engine:getFont("rage",fontsize),false,0,0,100,getTickCount(),type,maxLength};
    outputDebugString("dxEditbox created. ID: "..id.." | Name: "..name,0,0,100,100);
    return id;
end

function renderEdits()
    for k,v in pairs(edits) do 
        local name,text,defaultText,x,y,w,h,font,active,tick,w2,backState,tickBack,type = unpack(v);
        dxDrawRectangle(x,y,w,h,tocolor(0,0,0,150),true); --All BG
        local textWidth = dxGetTextWidth(text, 1, font, false) or 0;
        if active then 
            edits[k][11] = interpolateBetween(0, 0, 0, w/2, 0, 0, (getTickCount()-tick)/400, "Linear"); --Bottom line Open
            dxDrawRectangle(x+w/2,y+h,-w2,2,tocolor(color[1],color[2],color[3],150),true);
            dxDrawRectangle(x+w/2,y+h,w2,2,tocolor(color[1],color[2],color[3],150),true);

            local carretAlpha = interpolateBetween(50, 0, 0, 255, 0, 0, (getTickCount()-tick)/1000, "SineCurve");
            local carretSize = dxGetFontHeight(1, font)*2.4;
            local carretPosX = textWidth > (w-10) and x + w - 10 or x + textWidth + 5
            dxDrawRectangle(carretPosX + 2, y + (carretSize / 2),2, h - carretSize, tocolor(200,200,200, carretAlpha), true);

            if lastChange < getTickCount() then 
                if getKeyState("backspace") then
                    backState = backState - 1;
                else
                    backState = 100;
                end
                if getKeyState("backspace") and (getTickCount() - tickBack) > backState then
                    edits[k][2] = string.sub(text, 1, #text - 1);
                    edits[k][13] = getTickCount();
                end
            end
        else 
            if w2 > 0 then --Bottom line Close
                edits[k][11] = interpolateBetween(edits[k][11], 0, 0, 0, 0, 0, (getTickCount()-tick)/400, "Linear");
                dxDrawRectangle(x+w/2,y+h,-w2,2,tocolor(color[1],color[2],color[3],150),true);
                dxDrawRectangle(x+w/2,y+h,w2,2,tocolor(color[1],color[2],color[3],150),true);
            end
        end

        if string.len(text) == 0 or textWidth == 0 then 
            dxDrawText(defaultText,x+5,y,w,y+h,tocolor(255,255,255,120),1,font,"left","center",false,false,true);
        else 
            if type == 2 then 
                text = string.rep("*", #text)
            end
            if w > textWidth then 
                dxDrawText(text,x+5,y,w,y+h,tocolor(255,255,255),1,font,"left","center",false,false,true);
            else 
                dxDrawText(text,x+5,y,x+w-5,y+h,tocolor(255,255,255),1,font,"right","center",true,false,true);
            end
        end
    end
end
addEventHandler("onClientPreRender",root,renderEdits,true,"high");

setTimer(function()
    if #edits > 0 then 
        local guiState = 0;
        for k,v in pairs(edits) do 
            local name,text,defaultText,x,y,w,h,font,active,tick,w2,backState,tickBack,type = unpack(v);
            if active then 
                guiState = guiState + 1;
            end
        end
        if (guiState > 0) then 
            setElementData(localPlayer,"guiActive",true);
        else 
            setElementData(localPlayer,"guiActive",false); 
        end
    else 
        setElementData(localPlayer,"guiActive",false); 
    end
end,200,0);

addEventHandler("onClientKey",root,function(button,state)
    if button == "mouse1" and state and isCursorShowing() then --Select Editbox
        for k,v in pairs(edits) do 
            local name,text,defaultText,x,y,w,h,font,active,tick = unpack(v);
            if not active then 
                if exports.fv_engine:isInSlot(x,y,w,h) then 
                    edits[k][9] = true;
                    edits[k][10] = getTickCount();
                end
            else 
                edits[k][9] = false;
                edits[k][10] = getTickCount();
            end
        end
    end
    
    if button == "tab" and state and isCursorShowing() then 
        if dxGetActiveEdit() then 
            local nextGUI = dxGetActiveEdit()+1;
            if edits[nextGUI] then 
                local current = dxGetActiveEdit();
                edits[current][9] = false;
                edits[current][10] = getTickCount();

                edits[nextGUI][9] = true;
                edits[nextGUI][10] = getTickCount();
            else
                local current = dxGetActiveEdit();
                edits[current][9] = false;
                edits[current][10] = getTickCount();

                edits[1][9] = true;
                edits[1][10] = getTickCount();
            end
        end
        cancelEvent();
    end

    for k,v in pairs(edits) do --Disable Keys
        local name,text,defaultText,x,y,w,h,font,active,tick,w2 = unpack(v);
        if active then
            cancelEvent();
        end
    end
end);

addEventHandler("onClientCharacter", root, function(key) --Typing
    if isCursorShowing() then 
        for k,v in pairs(edits) do
            local name,text,defaultText,x,y,w,h,font,active,tick,w2,backState,tickBack,type,maxLength = unpack(v);
            if active and v[13] < getTickCount() then
                if string.len(edits[k][2])+1 <= maxLength then 
                    if type == 3 then
                        if numbers[key] then  
                            edits[k][2] = edits[k][2] .. key;
                        end
                    else 
                        edits[k][2] = edits[k][2] .. key;
                    end
                    lastChange = getTickCount();
                end
            end
        end
    end
end);


--EXPORTED FUNCTIONS--
function dxGetActiveEdit()
    local a = false;
    for k,v in pairs(edits) do 
        local name,text,defaultText,x,y,w,h,font,active,tick,w2 = unpack(v);
        if active then 
            a = k;
            break;
        end
    end
    return a;
end

function dxDestroyEdit(id)
    if tonumber(id) then 
        if not edits[id] then error("Not valid editbox") return false end;
        table.remove(edits,id)
        outputDebugString("dxEditbox Destroyed. ID: "..id,0,0,100,100);
        return true;
    else 
        local edit = dxGetEdit(id);
        if not edits[edit] then error("Not valid editbox") return false end;
        table.remove(edits,edit);
        outputDebugString("dxEditbox Destroyed. ID: "..edit,0,0,100,100);
        return true;
    end
end

function dxEditSetText(id,text)
    if tonumber(id) then 
        if not edits[id] then error("Not valid editbox") return false end;
        edits[id][2] = text;
        return true;
    else 
        local edit = dxGetEdit(id);
        if not edits[edit] then error("Not valid editbox") return false end;
        edits[edit][2] = text;
        return true;
    end
end

function dxGetEdit(name)
    local found = false;
    for k,v in pairs(edits) do 
        if v[1] == name then 
            found = k;
            break;
        end
    end
    return found;
end

function dxGetEditText(id)
    if tonumber(id) then 
        if not edits[id] then error("Not valid editbox") return false end;
        local text = edits[id][2];
        if text == "" then 
            text = edits[id][3];
        end
        return text;
    else 
        local edit = dxGetEdit(id);
        if not edits[edit] then error("Not valid editbox") return false end;
        local text = edits[edit][2];
        if text == "" then 
            text = edits[edit][3];
        end
        return text;
    end
end

function dxSetEditPosition(id,x,y)
    if tonumber(id) then 
        if not edits[id] then error("Not valid editbox") return false end;
        edits[id][4] = x;
        edits[id][5] = y;
        return true;
    else
        local edit = dxGetEdit(id);
        if not edits[edit] then error("Not valid editbox") return false end;
        edits[edit][4] = x;
        edits[edit][5] = y;
        return true;
    end
end
----------------------

--Buttons--
function DrawButton(text,x,y,w,h,color,fontSize)
    local r,g,b,a = unpack(color);
    local hoverColor = tocolor(r,g,b,a-40);
    if exports.fv_engine:isInSlot(x,y,w,h) then 
        hoverColor = tocolor(r,g,b,a+10);
    end
	dxDrawRectangle(x,y,w,h,hoverColor);
    dxDrawBorder(x,y,w,h,resFont(2),tocolor(r,g,b));
    dxDrawText(text,x,y,x + w,y + h,tocolor(255,255,255),1,exports.fv_engine:getFont("rage",fontSize or h/2.4),"center","center");
end

-------UTILS-------
function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end