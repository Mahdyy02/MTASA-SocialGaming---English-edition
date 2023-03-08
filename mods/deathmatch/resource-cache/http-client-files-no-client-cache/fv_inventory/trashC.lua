local trashState = false;

function nearbyTrash()
    if not ( tonumber ( getElementData ( localPlayer, "admin >> level") or 0) > 8 ) then return end
    trashState = not trashState;
    if trashState then 
        removeEventHandler("onClientRender",root,nearbyTrashRender);
        addEventHandler("onClientRender",root,nearbyTrashRender);
        outputChatBox(e:getServerSyntax("Item","servercolor").."Close trash display on!",255,255,255,true);
    else 
        removeEventHandler("onClientRender",root,nearbyTrashRender);
        outputChatBox(e:getServerSyntax("Item","red").."Trash display is off!",255,255,255,true);
    end
end
addCommandHandler("nearbybin",nearbyTrash,false,false);

function nearbyTrashRender()
    if not ( tonumber ( getElementData ( localPlayer, "admin >> level") or 0) > 8 ) then 
        removeEventHandler("onClientRender",root,nearbyTrashRender);
        trashState = false;
    end
    local pPos = Vector3(getElementPosition(localPlayer));
    for k,v in pairs(getElementsByType("object",resourceRoot)) do 
        if getElementData(v,"trash.id") or 0 > 0 then 
            local oPos = Vector3(getElementPosition(v));
            if getDistanceBetweenPoints3D(pPos.x,pPos.y,pPos.z, oPos.x, oPos.y, oPos.z) < 10 then 
                local x,y = getScreenFromWorldPosition(oPos.x,oPos.y,oPos.z+1);
                if x and y then 
                    shadowedText("ID: "..sColor2..(getElementData(v,"trash.id") or 0),x,y,x,y,tocolor(255,255,255),1,e:getFont("rage",15),"center","top");
                end
            end
        end
    end
end