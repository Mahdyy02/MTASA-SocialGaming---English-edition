local safeState = false;

function nearbysafe()
    if not ( tonumber ( getElementData ( localPlayer, "admin >> level") or 0) > 8 ) then return end
    safeState = not safeState;
    if safeState then 
        removeEventHandler("onClientRender",root,nearbysafeRender);
        addEventHandler("onClientRender",root,nearbysafeRender);
        outputChatBox(e:getServerSyntax("Item","servercolor").."Close safe display on!",255,255,255,true);
    else 
        removeEventHandler("onClientRender",root,nearbysafeRender);
        outputChatBox(e:getServerSyntax("Item","red").."Close safe display turned off!",255,255,255,true);
    end
end
addCommandHandler("nearbysafe",nearbysafe,false,false);

function nearbysafeRender()
    if not ( tonumber ( getElementData ( localPlayer, "admin >> level") or 0) > 8 ) then 
        removeEventHandler("onClientRender",root,nearbysafeRender);
        safeState = false;
    end
    local pPos = Vector3(getElementPosition(localPlayer));
    for k,v in pairs(getElementsByType("object",resourceRoot)) do 
        if getElementData(v,"safe.id") or 0 > 0 then 
            local oPos = Vector3(getElementPosition(v));
            if getDistanceBetweenPoints3D(pPos.x,pPos.y,pPos.z, oPos.x, oPos.y, oPos.z) < 10 then 
                local x,y = getScreenFromWorldPosition(oPos.x,oPos.y,oPos.z);
                if x and y then 
                    shadowedText("ID: "..sColor2..(getElementData(v,"safe.id") or 0),x,y,x,y,tocolor(255,255,255),1,e:getFont("rage",15),"center","top");
                end
            end
        end
    end
end