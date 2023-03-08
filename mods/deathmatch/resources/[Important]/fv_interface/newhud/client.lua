--SocialGaming 2019

local newhud = {};
newhud.circle = dxCreateTexture("newhud/circle.png","argb");

addEventHandler("onClientRender",root,function()
    if not getElementData(localPlayer,"loggedIn") or not getElementData(localPlayer,"togHUD") then return end;
    local circleSize = res(40);
    local lineAlpha = 100;
    newhud.bars = {
        {"hp",{red[1],red[2],red[3],lineAlpha},"",getElementHealth(localPlayer)};
        {"armor",{blue[1],blue[2],blue[3],lineAlpha},"",getPedArmor(localPlayer)};
        {"hunger",{orange[1],orange[2],orange[3],lineAlpha},"",getElementData(localPlayer,"char >> food")};
        {"drink",{blue[1],blue[2],blue[3],lineAlpha},"",getElementData(localPlayer,"char >> drink")};
        {"stamina",{200,200,200,lineAlpha},"",getStamina(),res(2.5)};
    };
    for k,v in pairs(newhud.bars) do 
        if isWidgetShowing("hud."..v[1]) then 
            local x,y,w,h = getWidgetDatas("hud."..v[1]);
            local lineW = w - circleSize;
            local lineY = y
            dxDrawRectangle(x+circleSize-res(10),lineY+circleSize/2-res(10),lineW,res(20),tocolor(60,60,60,250),true);
            local lineH = res(15);
            dxDrawRectangle(x+circleSize-res(10),lineY+circleSize/2-lineH/2,(lineW-res(2))*(v[4]/100),lineH,tocolor(unpack(v[2])),true);
            dxDrawImage(x,lineY,circleSize,circleSize,newhud.circle,0,0,0,tocolor(60,60,60,250),true);
            dxDrawText(v[3],x,lineY,x + circleSize + (v[5] or 0),lineY + circleSize + res(3),tocolor(200,200,200,200),1,exports.fv_engine:getFont("AwesomeFont",resFont(13)),"center","center",false,false,true);
        end
    end
end);