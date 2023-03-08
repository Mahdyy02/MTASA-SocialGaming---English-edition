local white = "#FFFFFF";
local sx,sy = guiGetScreenSize();
local panel = "login";
local bg = 1;
local bgs = {
    [1] = {
        ["start"] = {1879.5614013672,-1384.3238525391,18.47500038147,1880.1730957031,-1383.6594238281,18.045671463013},
        ["end"] = {1869.3542480469,-1369.6918945313,20.748100280762,1869.3521728516,-1368.7437744141,20.430334091187},
    },
    [2] = {
        ["start"] = {1709.1882324219,-1956.0589599609,16.702899932861,1708.2379150391,-1956.0626220703,16.391807556152},
        ["end"] = {1693.1247558594,-1927.2258300781,17.513599395752,1693.1058349609,-1926.3137207031,17.10418510437},
    }
}
local pPos = {
    [1] = {
        --skinid,x,y,z,rot,anim
        {0,1885.0447998047, -1371.0812988281, 13.569966316223,223,"dancing","dan_left_a"},
        {40,1887.4503173828, -1371.6748046875, 13.570111274719,78,"dancing","dan_loop_a"},
        {256,1886.6016845703, -1369.7010498047, 13.569628715515,0,"dancing","bd_clap"},
        {92,1889.9996337891, -1374.1151123047, 13.570707321167,134,"beach","sitnwait_loop_w"},
        {259,1891.1279296875, -1380.0042724609, 13.572145462036,75,"gangs","leanidle"},
    },
    [2] = {
        {0,1699.2810058594, -1937.7847900391, 13.564117431641,84},
        {40,1697.890625, -1937.8073730469, 13.553860664368,268},

        {50,1701.1260986328, -1950.0728759766, 14.1171875,186},
        {80, 1699.4487304688, -1950.0914306641, 14.1171875,186},

        {250, 1702.4349365234, -1940.7305908203, 13.562987327576,88,"gangs","leanidle"},

        {92,1668.1456298828, -1957.8814697266, 13.546875,355,"beach","sitnwait_loop_w"},
    }
}
local peds = {};
local vPos = {
    [1] = {
        {565,1892.4332275391, -1371.7772216797, 13.570136070251, 134},
        {527,1894.7976074219, -1380.4736328125, 13.5703125,80},
        {481,1886.1474609375, -1368.2061767578, 13.569263458252,88}, --BMX
    },
    [2] = {
        {565,1704.9750976563, -1940.7017822266, 13.569981575012,266},
    }
}
local vehs = {};
local oPos = {
    [1] = {
        {2231,1880.8092041016, -1370.0545654297, 13.569715499878-1,50},
        {2231,1874.3682861328, -1369.5866699219, 13.547034263611-1,-30}
    }
}
local objs = {};
local pedPos = {
    [1] = {1869.3376464844, -1363.0727539063, 19.140625,178},
    [2] = {1693.2448730469, -1919.9458007813, 13.545776367188,180},
}
local tick = 0;
local guis = {};
local guiTick = 0;
local clickTick = 0;
local x,y = 0,0;
local time = 200;
local close = false;
local ped = false;
local skins = {
    [1] = {7, 14, 15, 16, 17, 18, 19, 20, 23},
    [2] = {10, 11, 12, 13, 31, 55, 41, 92, 91}
}
local selected = 1;
local gender = 1;
local camMove = false;
local music = false;

local dataSave = false;

addEventHandler("onClientResourceStart",getRootElement(),function(res)
    if getResourceName(res) == "fv_engine" or getThisResource() == res then 
        font = exports.fv_engine:getFont("Yantramanav-Regular", 14);
        font2 = exports.fv_engine:getFont("rage", 11);
        font3 = exports.fv_engine:getFont("Yantramanav-Regular", 18);
        font4 = exports.fv_engine:getFont("rage", 12);
        font5 = exports.fv_engine:getFont("Yantramanav-Regular", 12);
        sColor = {exports.fv_engine:getServerColor("servercolor",false)};
        sColor2 = exports.fv_engine:getServerColor("servercolor",true);
        red = {exports.fv_engine:getServerColor("red",false)};
        red2 = exports.fv_engine:getServerColor("red",true);
        green = {exports.fv_engine:getServerColor("green",false)};
        orange = {exports.fv_engine:getServerColor("orange",false)};
        blue = {exports.fv_engine:getServerColor("blue",false)};
        icons = exports.fv_engine:getFont("AwesomeFont",11);
    end
    if getThisResource() == res then 
        setElementData(localPlayer,"loggedIn",false);

        setElementDimension(localPlayer,getElementData(localPlayer,"char >> id") or math.random(0,9999));
        showChat(false);
        showCursor(true);
        removeEventHandler("onClientRender",root,render);
        addEventHandler("onClientRender",root,render);
        panel = "login";
        setBG(0);
        setTimer(function()
            setBG(math.random(1,#bgs));
        end,1000,1);
        close = false;
        tick = getTickCount();

        manageGUI("destroy");
        manageGUI("login");        

        setElementData(localPlayer,"loggedIn",false);

        music = playSound("zenecske.mp3",true);

        loadLoginData();
    end
end);

function setBG(num)
    if num == 0 then 
        for k,v in pairs(peds) do 
            if isElement(v) then 
                destroyElement(v);
            end
        end
        for k,v in pairs(vehs) do 
            if isElement(v) then 
                destroyElement(v);
            end
        end
        for k,v in pairs(objs) do 
            if isElement(v) then 
                destroyElement(v);
            end
        end
        peds = {};
        vehs = {};
        objs = {};
        fadeCamera(false,0);
    else 
        bg = num;
        peds = {};
        vehs = {};
        objs = {};
        if pPos[bg] and #pPos[bg] > 0 then
            for k,v in pairs(pPos[bg]) do 
                local skinid,x,y,z,rot,anim1,anim2 = unpack(v);
                local ped = createPed(skinid,x,y,z,rot,true);
                setElementDimension(ped,getElementDimension(localPlayer));
                setPedAnimation(ped,anim1,anim2,-1,true,false,false,false);

                peds[#peds + 1] = ped;
            end
        end
        if vPos[bg] and #vPos[bg] > 0 then
            for k,v in pairs(vPos[bg]) do 
                local model,x,y,z,rot = unpack(v);
                local veh = createVehicle(model,x,y,z,0,0,rot,"LOGIN");
                setElementDimension(veh,getElementDimension(localPlayer));
                setTimer(function()
                    setElementFrozen(veh,true);
                end,300,1)
                vehs[#vehs + 1] = veh;
            end
        end
        if oPos[bg] and #oPos[bg] > 0 then
            for k,v in pairs(oPos[bg]) do  
                local model,x,y,z,rot = unpack(v);
                local obj = createObject(model,x,y,z,0,0,rot);
                setElementDimension(obj,getElementDimension(localPlayer));
                objs[#objs + 1] = obj;
            end
        end
        setTimer(function()
            fadeCamera(true,0.3);
        end,100,1);
        local pos = bgs[bg]["start"];
        setCameraMatrix(pos[1],pos[2],pos[3],pos[4],pos[5],pos[6]); 
        if panel == "charCreate" or panel == "charCheck" then 
            local pos2 = bgs[bg]["end"];
            smoothMoveCamera(pos[1],pos[2],pos[3],pos[4],pos[5],pos[6],pos2[1],pos2[2],pos2[3],pos2[4],pos2[5],pos2[6],3000);
        end
        if panel == "charCreate" then 
            if isElement(ped) then
                destroyElement(ped);
            end
            selected = math.random(1,#skins[gender])
            ped = createPed(skins[gender][selected],pedPos[bg][1],pedPos[bg][2],pedPos[bg][3],pedPos[bg][4]);
            setElementDimension(ped,getElementDimension(localPlayer));
            setPedAnimation(ped, "ON_LOOKERS", "wave_loop",-1,true,false,false,false);
        end
        if panel == "charCheck" then 
            manageGUI("destroy");
        end
    end
end

function manageGUI(state)
    if state == "destroy" then 
        for k,v in pairs(guis) do 
            if isElement(v) then 
                destroyElement(v);
            end
        end
    elseif state == "login" then
        guis[1] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[1],27);
        guis[2] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[2],27);
    elseif state == "register" then 
        guis[1] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[1],27);
        guis[2] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[2],27);
        guis[3] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[3],27);
        guis[4] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[4],27);
    elseif state == "charCreate" then 
        guis[1] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[1],40);
        guis[2] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[2],3);
        guis[3] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[3],3);
        guis[4] = guiCreateEdit(-1000,-1000,0,0,"",false);
        guiEditSetMaxLength(guis[4],3);
    end
end
function isGUI(element) 
    local found = false;
    for k,v in pairs(guis) do 
        if isElement(v) then 
            if element == v then  
                found = k;
                break;
            end
        end
    end
    return found;
end
addEventHandler("onClientGUIChanged",getResourceRootElement(getThisResource()),function(element)
    local a = isGUI(element);
    if a then 
        activeGUI = a;
    end
end);

function saveLoginData()
    if isElement(guis[1]) and isElement(guis[2]) then 
        local username = guiGetText(guis[1]);
        local pw = guiGetText(guis[2]);
        if username ~= "" or pw ~= "" then 
            if fileExists("login.save") then 
                fileDelete("login.save");
            end
            local file = fileCreate("login.save");
            fileWrite(file,toJSON({username,pw}));
            fileClose(file);
        end
    end
end

function loadLoginData()
    if fileExists("login.save") then 
        local file = fileOpen("login.save",true);
        local temp = fromJSON(fileRead(file,10000));
        if isElement(guis[1]) and isElement(guis[2]) then 
            guiSetText(guis[1],temp[1]);
            guiSetText(guis[2],temp[2]);
            dataSave = true;
        end
        fileClose(file);
    end
end
addEventHandler("onResourceStop",resourceRoot,function()
    if not dataSave then 
        if fileExists("login.save") then 
            fileDelete("login.save");
        end
    end
end);

function render()

    for k,v in pairs(bgs) do 
        local color = tocolor(0,0,0,200);
        if exports.fv_engine:isInSlot(-40+(k*55),sy-60,50,50) then 
            color = tocolor(sColor[1],sColor[2],sColor[3]);
        end
        dxDrawRectangle(-40+(k*55),sy-60,50,50,color);
        shadowedText(tostring(k),-40+(k*55),sy-60,-40+(k*55)+50,sy-60+50,tocolor(255,255,255),1,font,"center","center");
    end

    if panel == "login" then 
        if not close then
            x,y = interpolateBetween(-400,sy/2-200,0,10,sy/2-200,0,(getTickCount()-tick)/time,"Linear");
        else  
            x,y = interpolateBetween(10,sy/2-200,0,-400,sy/2-200,0,(getTickCount()-tick)/time,"Linear");
            if x == -400 then 
                manageGUI("destroy");
                manageGUI(close);
                tick = getTickCount();
                panel = close;
                close = false;
            end
        end
        dxDrawRectangle(x,y,300,400,tocolor(0,0,0,100));
        shadowedText(sColor2.."Welcome to the server"..white..", log in\nor if you are new to the server then\n"..sColor2.."register!",x,y+10,x+300,0,tocolor(255,255,255),1,font,"center","top",false,true,false,true);

        if getKeyState("mouse1") and guiTick+300 < getTickCount() then 
            if exports.fv_engine:isInSlot(x+10,y+150,280,25) then 
                guiBringToFront(guis[1]);
                activeGUI = 1;
            elseif exports.fv_engine:isInSlot(x+10,y+200,280,25) then 
                guiBringToFront(guis[2]);
                activeGUI = 2;
            elseif exports.fv_engine:isInSlot(x+10,y+240,25,25) then 
                dataSave = not dataSave;
                if dataSave then 
                    saveLoginData();
                else 
                    if fileExists("login.save") then 
                        fileDelete("login.save");
                    end
                end
                guiTick = getTickCount();
            end
        end

        dxDrawRectangle(x+10,y+150,280,25,tocolor(0,0,0,150));
        if exports.fv_engine:isInSlot(x+10,y+150,20,25) then 
            tooltip("User Name");
        end
        dxDrawText("",x+13,y+150,280,y+150+25,tocolor(255,255,255),1,icons,"left","center");
        if isElement(guis[1]) then
            dxDrawText(guiGetText(guis[1]),x+40,y+150,280,y+150+25,tocolor(255,255,255),1,font2,"left","center");
            if activeGUI == 1 then
                dxDrawText("|",x+40+dxGetTextWidth(guiGetText(guis[1]),1,font2),y+150,280,y+150+25,tocolor(255,255,255,200 * math.abs(getTickCount() % 1000 - 500) / 500),1,font2,"left","center");
            end
        end
        dxDrawRectangle(x+10,y+200,280,25,tocolor(0,0,0,150));
        if exports.fv_engine:isInSlot(x+10,y+200,20,25) then 
            tooltip("Password");
        end
        dxDrawText("",x+13,y+200,280,y+200+25,tocolor(255,255,255),1,icons,"left","center");
        if isElement(guis[2]) then 
            dxDrawText(toPassword(guiGetText(guis[2])),x+40,y+200,280,y+200+25,tocolor(255,255,255),1,font2,"left","center");
            if activeGUI == 2 then 
                dxDrawText("|",x+40+dxGetTextWidth(toPassword(guiGetText(guis[2])),1,font2),y+200,280,y+200+25,tocolor(255,255,255,200 * math.abs(getTickCount() % 1000 - 500) / 500),1,font2,"left","center");
            end
        end

        local logColor = tocolor(sColor[1],sColor[2],sColor[3],150);
        if exports.fv_engine:isInSlot(x+10,y+280,280,50) then 
            logColor = tocolor(sColor[1],sColor[2],sColor[3],255);
        end
        dxDrawRectangle(x+10,y+280,280,50,logColor);
        shadowedText("Login",x+10,y+280,x+10+280,y+280+50,tocolor(255,255,255),1,font3,"center","center");

        local regColor = tocolor(blue[1],blue[2],blue[3],150);
        if exports.fv_engine:isInSlot(x+10,y+340,280,50) then 
            regColor = tocolor(blue[1],blue[2],blue[3],255);
        end
        dxDrawRectangle(x+10,y+340,280,50,regColor);
        shadowedText("Sign up",x+10,y+340,x+10+280,y+340+50,tocolor(255,255,255),1,font3,"center","center");

        dxDrawRectangle(x+10,y+240,25,25,tocolor(0,0,0,150));
        if dataSave then 
            dxDrawText("",x+10,y+240,x+10+25,y+240+25,tocolor(sColor[1],sColor[2],sColor[3]),1,icons,"center","center");
        end
        shadowedText("Saving the data",x+40,y+240,0,y+240+25,tocolor(255,255,255),1,font2,"left","center");

    elseif panel == "register" then 

        if not close then 
            x,y = interpolateBetween(-400,sy/2-200,0,10,sy/2-200,0,(getTickCount()-tick)/time,"Linear");
        else
            x,y = interpolateBetween(10,sy/2-200,0,-400,sy/2-200,0,(getTickCount()-tick)/time,"Linear");
            if x == -400 then 
                manageGUI("destroy");
                manageGUI(close);
                tick = getTickCount();
                panel = close;
                close = false;
            end
        end
        dxDrawRectangle(x,y,300,400,tocolor(0,0,0,100));

        shadowedText(sColor2.."Sign up",x,y+10,x+300,0,tocolor(255,255,255),1,font,"center","top",false,true,false,true);

        if getKeyState("mouse1") and guiTick+300 < getTickCount() then 
            if exports.fv_engine:isInSlot(x+10,y+70,280,25) then 
                guiBringToFront(guis[1]);
                activeGUI = 1;
                guiTick = getTickCount();
            elseif exports.fv_engine:isInSlot(x+10,y+120,280,25) then 
                guiBringToFront(guis[2]);
                activeGUI = 2;
                guiTick = getTickCount();
            elseif exports.fv_engine:isInSlot(x+10,y+170,280,25) then 
                guiBringToFront(guis[3]);
                activeGUI = 3;
                guiTick = getTickCount();
            elseif exports.fv_engine:isInSlot(x+10,y+220,280,25) then 
                guiBringToFront(guis[4]);
                activeGUI = 4;
                guiTick = getTickCount();
            end
        end


        dxDrawRectangle(x+10,y+70,280,25,tocolor(0,0,0,150));
        if exports.fv_engine:isInSlot(x+10,y+70,20,25) then 
            tooltip("User Name");
        end
        dxDrawText("",x+13,y+70,280,y+70+25,tocolor(255,255,255),1,icons,"left","center");
        if isElement(guis[1]) then
            dxDrawText(guiGetText(guis[1]),x+40,y+70,280,y+70+25,tocolor(255,255,255),1,font2,"left","center");
            if activeGUI == 1 then
                dxDrawText("|",x+40+dxGetTextWidth(guiGetText(guis[1]),1,font2),y+70,280,y+70+25,tocolor(255,255,255,200 * math.abs(getTickCount() % 1000 - 500) / 500),1,font2,"left","center");
            end
        end

        dxDrawRectangle(x+10,y+120,280,25,tocolor(0,0,0,150));
        if exports.fv_engine:isInSlot(x+10,y+120,20,25) then 
            tooltip("Password");
        end
        dxDrawText("",x+13,y+120,280,y+120+25,tocolor(255,255,255),1,icons,"left","center");
        if isElement(guis[2]) then
            dxDrawText(toPassword(guiGetText(guis[2])),x+40,y+120,280,y+120+25,tocolor(255,255,255),1,font2,"left","center");
            if activeGUI == 2 then
                dxDrawText("|",x+40+dxGetTextWidth(toPassword(guiGetText(guis[2])),1,font2),y+120,280,y+120+25,tocolor(255,255,255,200 * math.abs(getTickCount() % 1000 - 500) / 500),1,font2,"left","center");
            end
        end

        dxDrawRectangle(x+10,y+170,280,25,tocolor(0,0,0,150));
        if exports.fv_engine:isInSlot(x+10,y+170,20,25) then 
            tooltip("Password again");
        end
        dxDrawText("",x+13,y+170,280,y+170+25,tocolor(255,255,255),1,icons,"left","center");
        if isElement(guis[3]) then
            dxDrawText(toPassword(guiGetText(guis[3])),x+40,y+170,280,y+170+25,tocolor(255,255,255),1,font2,"left","center");
            if activeGUI == 3 then
                dxDrawText("|",x+40+dxGetTextWidth(toPassword(guiGetText(guis[3])),1,font2),y+170,280,y+170+25,tocolor(255,255,255,200 * math.abs(getTickCount() % 1000 - 500) / 500),1,font2,"left","center");
            end
        end

        dxDrawRectangle(x+10,y+220,280,25,tocolor(0,0,0,150));
        if exports.fv_engine:isInSlot(x+10,y+220,20,25) then 
            tooltip("E-mail address");
        end
        dxDrawText("",x+13,y+220,280,y+220+25,tocolor(255,255,255),1,icons,"left","center");
        if isElement(guis[4]) then
            dxDrawText(guiGetText(guis[4]),x+40,y+220,280,y+220+25,tocolor(255,255,255),1,font2,"left","center");
            if activeGUI == 4 then
                dxDrawText("|",x+40+dxGetTextWidth(guiGetText(guis[4]),1,font2),y+220,280,y+220+25,tocolor(255,255,255,200 * math.abs(getTickCount() % 1000 - 500) / 500),1,font2,"left","center");
            end
        end

        local logColor = tocolor(sColor[1],sColor[2],sColor[3],150);
        if exports.fv_engine:isInSlot(x+10,y+280,280,50) then 
            logColor = tocolor(sColor[1],sColor[2],sColor[3],255);
        end
        dxDrawRectangle(x+10,y+280,280,50,logColor);
        shadowedText("Sign up",x+10,y+280,x+10+280,y+280+50,tocolor(255,255,255),1,font3,"center","center");

        local regColor = tocolor(blue[1],blue[2],blue[3],150);
        if exports.fv_engine:isInSlot(x+10,y+340,280,50) then 
            regColor = tocolor(blue[1],blue[2],blue[3],255);
        end
        dxDrawRectangle(x+10,y+340,280,50,regColor);
        shadowedText("Step back",x+10,y+340,x+10+280,y+340+50,tocolor(255,255,255),1,font3,"center","center");
    elseif panel == "charCreate" then 
        if not close then
            x,y = getScreenFromWorldPosition(getElementPosition(ped));
            if x and y then

                dxDrawRectangle(x-140,y-260,280,3,tocolor(sColor[1],sColor[2],sColor[3]));
                shadowedText("Character Making",x-140,y-285,x-140+280,0,tocolor(255,255,255),1,font,"center","top");

                dxDrawRectangle(x-140,y-250,30,30,tocolor(0,0,0,150));
                if gender == 1 then
                    dxDrawText("",x-140,y-250,x-140+30,y-250+30,tocolor(255,255,255),1,icons,"center","center");
                end
                shadowedText("Male",x-105,y-250,30,y-250+30,tocolor(255,255,255),1,font5,"left","center");

                dxDrawRectangle(x+85,y-250,30,30,tocolor(0,0,0,150));
                if gender == 2 then 
                    dxDrawText("",x+85,y-250,x+85+30,y-250+30,tocolor(255,255,255),1,icons,"center","center");
                end
                shadowedText("Female",x+120,y-250,30,y-250+30,tocolor(255,255,255),1,font5,"left","center");


                local headx,heady = getScreenFromWorldPosition(getPedBonePosition(ped,8));
                if tonumber(headx) and tonumber(heady) then 
                    dxDrawLine(x-140,y-200,headx,heady,tocolor(0,0,0),4,false);
                end
                dxDrawRectangle(x-140,y-200,280,25,tocolor(0,0,0,150));
                if exports.fv_engine:isInSlot(x-140,y-200,20,25) then 
                    tooltip("Character Name");
                end
                dxDrawText(guiGetText(guis[1]),x-140,y-200,x-140+280,y-200+25,tocolor(255,255,255),1,font2,"center","center");
                if activeGUI == 1 then 
                    dxDrawText("|",x-140+dxGetTextWidth(guiGetText(guis[1]),1,font2),y-200,x-140+280,y-200+25,tocolor(255,255,255,200 * math.abs(getTickCount() % 1000 - 500)/500),1,font2,"center","center");
                end
                dxDrawText("",x-135,y-200,380,y-200+25,tocolor(255,255,255),1,icons,"left","center");

                shadowedText("Skin choice",x-60,y+180,x+30+30,0,tocolor(255,255,255),1,font5,"center","top");

                local leftColor = tocolor(255,255,255);
                if exports.fv_engine:isInSlot(x-60,y+200,30,30) then
                    leftColor = tocolor(sColor[1],sColor[2],sColor[3]);
                end
                dxDrawRectangle(x-60,y+200,30,30,tocolor(0,0,0,150)); --Balra
                dxDrawText("",x-60,y+200,x-60+30,y+200+30,leftColor,1,icons,"center","center");

                local rightColor = tocolor(255,255,255);
                if exports.fv_engine:isInSlot(x+30,y+200,30,30) then 
                    rightColor = tocolor(sColor[1],sColor[2],sColor[3]);
                end
                dxDrawRectangle(x+30,y+200,30,30,tocolor(0,0,0,150)); --Jobbra
                dxDrawText("",x+30,y+200,x+30+30,y+200+30,rightColor,1,icons,"center","center");

                local pedx,pedy = getScreenFromWorldPosition(getPedBonePosition(ped,2));
                --local pedx1,pedy1 = getScreenFromWorldPosition(getPedBonePosition(ped,3));
                --dxDrawLine(x-103,y-40,pedx1,pedy1,tocolor(0,0,0),4,false);
                dxDrawLine(x-103,y+32.5,pedx,pedy,tocolor(0,0,0),4,false);
                dxDrawRectangle(x-200,y-50,100,25,tocolor(0,0,0,150));
                local magassag = guiGetText(guis[2]);
                if not tonumber(magassag) then guiSetText(guis[2],"") end;
                if tonumber(magassag) and tonumber(magassag) > 200 then guiSetText(guis[2],"") end;
                dxDrawText(guiGetText(guis[2]),x-175,y-50,100,y-50+30,tocolor(255,255,255),1,font2,"left","center");
                dxDrawText("cm",x-200,y-50,x-175+70,y-50+30,tocolor(255,255,255),1,font2,"right","center");
                if exports.fv_engine:isInSlot(x-200,y-50,20,25) then 
                    tooltip("Height (Max: 200cm)");
                end
                --dxDrawText("",x-197,y-50,100,y-50+25,tocolor(255,255,255),1,icons,"left","center");
                dxDrawImage(x-197,y-47,19,19,"height.png");

                dxDrawRectangle(x-200,y+20,100,25,tocolor(0,0,0,150));
                local suly = guiGetText(guis[3]); 
                if not tonumber(suly) then guiSetText(guis[3],"") end;
                if tonumber(suly) and tonumber(suly) > 180 then guiSetText(guis[3],"") end;
                dxDrawText(guiGetText(guis[3]),x-175,y+20,100,y+20+30,tocolor(255,255,255),1,font2,"left","center");
                dxDrawText("kg",x-200,y+20,x-175+70,y+20+30,tocolor(255,255,255),1,font2,"right","center");

                if exports.fv_engine:isInSlot(x-200,y+20,20,25) then 
                    tooltip("Body weight (Max: 180kg)");
                end
                dxDrawText("",x-197,y+20,100,y+20+25,tocolor(255,255,255),1,icons,"left","center");

                dxDrawRectangle(x-200,y+90,100,25,tocolor(0,0,0,150));
                local eletkor = guiGetText(guis[4]);
                if not tonumber(eletkor) then guiSetText(guis[4],"") end;
                if tonumber(eletkor) and tonumber(eletkor) > 60 then guiSetText(guis[4],"") end;
                dxDrawText(guiGetText(guis[4]),x-175,y+90,100,y+90+30,tocolor(255,255,255),1,font2,"left","center");
                dxDrawText("Age",x-200,y+90,x-175+70,y+90+30,tocolor(255,255,255),1,font2,"right","center");
                if exports.fv_engine:isInSlot(x-200,y+90,20,25) then 
                    tooltip("Age (Max: 60 years)");
                end
                dxDrawText("",x-197,y+90,100,y+90+25,tocolor(255,255,255),1,icons,"left","center");

                if getKeyState("mouse1") and guiTick+300 < getTickCount() then
                    if exports.fv_engine:isInSlot(x-140,y-200,280,25) then 
                        guiBringToFront(guis[1]);
                        activeGUI = 1;
                        guiTick = getTickCount();
                    elseif exports.fv_engine:isInSlot(x-200,y-50,100,25) then 
                        guiBringToFront(guis[2]);
                        activeGUI = 2;
                        guiTick = getTickCount();
                    elseif exports.fv_engine:isInSlot(x-200,y+20,100,25) then 
                        guiBringToFront(guis[3]);
                        activeGUI = 3;
                        guiTick = getTickCount();
                    elseif exports.fv_engine:isInSlot(x-200,y+90,100,25) then 
                        guiBringToFront(guis[4]);
                        activeGUI = 4;
                        guiTick = getTickCount();
                    end
                end

                local bColor = tocolor(sColor[1],sColor[2],sColor[3],150);
                if exports.fv_engine:isInSlot(x-100,y+240,200,70) then 
                    bColor = tocolor(sColor[1],sColor[2],sColor[3]);
                end
                dxDrawRectangle(x-100,y+240,200,70,bColor);
                shadowedText("Character Creation",x-100,y+240,x-100+200,y+240+70,tocolor(255,255,255),1,font,"center","center");
                dxDrawBorder(x-100,y+240,200,70,2,tocolor(0,0,0));
            end
        end
    --elseif panel == "charCheck" then 
        
    end

    --dxDrawText("A szerver zárolva lett amíg a problémákat megoldjuk!", 0, 0, sx, sy, tocolor(255, 0, 0, 255), 2.5, "default-bold", "center", "center");
end

addEventHandler("onClientClick",root,function(button,state)
    if button == "left" and state == "down" and not close then 
        if not getElementData(localPlayer,"loggedIn") then 
            for k,v in pairs(bgs) do 
                if exports.fv_engine:isInSlot(-40+(k*55),sy-60,50,50) and k ~= bg then 
                    if clickTick+1000 > getTickCount() then return end;
                    if camMove then return end;
                    setBG(0);
                    setBG(k)
                    clickTick = getTickCount();
                end
            end
        end
        if panel == "login" then 
            if exports.fv_engine:isInSlot(x+10,y+280,280,50) then --Login
                if clickTick+5000 > getTickCount() then 
                    exports.fv_infobox:addNotification("warning","Please wait 5 seconds before clicking")
                    return 
                end
                tick = getTickCount();
                clickTick = getTickCount();
                local name,pw = guiGetText(guis[1]),guiGetText(guis[2]);
                if name == "" or pw == "" then exports.fv_infobox:addNotification("warning","Fields are required!") return end;
                if dataSave then 
                    saveLoginData();
                end
                triggerServerEvent("acc.login",localPlayer,localPlayer,name,pw);

            end
            if exports.fv_engine:isInSlot(x+10,y+340,280,50) then --Register
                if clickTick+1500 > getTickCount() then return end;
                close = "register";
                tick = getTickCount();
                clickTick = getTickCount();
            end
        end
        if panel == "register" then  
            if exports.fv_engine:isInSlot(x+10,y+340,280,50) then --Back 
                if clickTick+1500 > getTickCount() then return end;
                close = "login";
                tick = getTickCount();
                clickTick = getTickCount();
            end
            if exports.fv_engine:isInSlot(x+10,y+280,280,50) then --Register
                if clickTick+5000 > getTickCount() then 
                    exports.fv_infobox:addNotification("warning","Please wait 5 seconds before clicking")
                    return 
                end
                clickTick = getTickCount();
                local name,pw,pw2,mail = guiGetText(guis[1]),guiGetText(guis[2]),guiGetText(guis[3]),guiGetText(guis[4]);
                if name == "" or pw == "" or pw2 == "" or mail == "" then exports.fv_infobox:addNotification("warning","Fields are required!") return end;
                if pw ~= pw2 then exports.fv_infobox:addNotification("warning","The two passwords are different!") return end;
                if not string.find(mail,"@") then exports.fv_infobox:addNotification("warning","Email address is invalid!") return end;
                triggerServerEvent("acc.register",localPlayer,localPlayer,name,pw,mail);
                print("Register trigger from " .. getPlayerName(localPlayer))
            end
        end
        if panel == "charCreate" then 
            if exports.fv_engine:isInSlot(x-140,y-250,30,30) then --Male
                if gender ~= 1 then 
                    gender = 1;
                    selected = math.random(1,#skins[gender]);
                    setElementModel(ped,skins[gender][selected]);
                end
            elseif exports.fv_engine:isInSlot(x+85,y-250,30,30) then --Females
                if gender ~= 2 then 
                    gender = 2;
                    selected = math.random(1,#skins[gender]);
                    setElementModel(ped,skins[gender][selected]);
                end
            end

            if exports.fv_engine:isInSlot(x-100,y+240,200,70) then --Create Character
                local name = guiGetText(guis[1]):gsub("_"," ");
                local height = guiGetText(guis[2]);
                local weight = guiGetText(guis[3]);
                local age = guiGetText(guis[4]);
                if name == "" or height == "" or weight == "" or age == "" then 
                    exports.fv_infobox:addNotification("warning","Fields are required!");
                    return;
                end
                if tonumber(height) < 140 or tonumber(weight) < 40 or tonumber(age) < 17 or string.len(name) < 10 then 
                    exports.fv_infobox:addNotification("warning","The data you entered is incorrect, please review the data and try again.");
                    return;
                end
                triggerServerEvent("acc.charCreate",localPlayer,localPlayer,name,height,weight,age,getElementModel(ped),gender);
            end

            --Skin választás--
            if exports.fv_engine:isInSlot(x-60,y+200,30,30) then 
                local s = selected;
                if s-1 <= 0 then 
                    selected = #skins[gender];
                else 
                    selected = selected - 1;
                end
                setElementModel(ped,skins[gender][selected]);
            end
            if exports.fv_engine:isInSlot(x+30,y+200,30,30) then 
                local s = selected;
                if s+1 > #skins[gender] then 
                    selected = 1
                else 
                    selected = selected + 1;
                end
                setElementModel(ped,skins[gender][selected]);
            end
            --Skin választás vége--
        end
    end
end);

addEvent("acc.return",true);
addEventHandler("acc.return",root,function(a)
    close = a;
    tick = getTickCount();
    clickTick = getTickCount();
    if a == "charCreate" then 
        startCharCreate();
    end
    if a == "charCheck" then 
        triggerServerEvent("acc.Spawn",localPlayer,localPlayer);

        showChat(false);
        showCursor(false);
        removeEventHandler("onClientRender",root,render);
        panel = "off";
        startSpawning();
        if isElement(music) then 
            destroyElement(music);
        end
        setBG(0);
        fadeCamera(true);
    end
end);

function startCharCreate()
    local pos = bgs[bg]["start"];
    local pos2 = bgs[bg]["end"];
    smoothMoveCamera(pos[1],pos[2],pos[3],pos[4],pos[5],pos[6],pos2[1],pos2[2],pos2[3],pos2[4],pos2[5],pos2[6],3000);

    if isElement(ped) then
        destroyElement(ped);
    end
    selected = math.random(1,#skins[gender]);
    ped = createPed(skins[gender][selected],pedPos[bg][1],pedPos[bg][2],pedPos[bg][3],pedPos[bg][4]);
    setElementDimension(ped,getElementDimension(localPlayer));
    setPedAnimation(ped, "ON_LOOKERS", "wave_loop",-1,true,false,false,false);
end

local load = 0;
function loadRender(dt)
    exports.fv_blur:createBlur();

    if getElementData(localPlayer,"togHUD") then 
        setElementData(localPlayer,"togHUD",false);
    end
    if load < 600 then 
        load = load + (dt*0.15);
    elseif load >= math.ceil(600) then 
        load = 600;
        local pos = fromJSON(getElementData(localPlayer,"char >> position"));
        if pos[5] > 0 then 
            pos[3] = pos[3] + 1;
        end
        setElementPosition(localPlayer,pos[1],pos[2],pos[3]);
        setElementInterior(localPlayer,pos[5]);
        setElementDimension(localPlayer,pos[4]);

        setElementFrozen(localPlayer,false);

        setElementData(localPlayer,"togHUD",true);

        removeEventHandler("onClientPreRender",root,loadRender);
    end

    local sizeX,sizeY = 771/7,1124/7;
    dxDrawImage(sx/2-sizeX/2,sy/2-sizeY/2-100,sizeX,sizeY,"icon.png",0,0,0,tocolor(255,255,255,200 * math.abs(getTickCount() % 1000 - 500) / 500),true);
    exports.fv_engine:shadowedText("Loading..",0,0,sx,sy+50,tocolor(255,255,255),1,font,"center","center",false,false,true,true);

    dxDrawRectangle(sx/2-305,sy-50,610,30,tocolor(0,0,0,180),true);
    dxDrawRectangle(sx/2-300,sy-45,load,20,tocolor(sColor[1],sColor[2],sColor[3]),true);
end
function startSpawning()
    load = 0;
    addEventHandler("onClientPreRender",root,loadRender);
	local x,y,z = getElementPosition(localPlayer);
	setCameraMatrix(x,y,z+50,x,y,z);
	playSound("boom.mp3",false);
    setTimer(function()
        local x,y,z = getElementPosition(localPlayer);
		setCameraMatrix(x,y,z+20,x,y,z);
        playSound("boom.mp3",false);
        setTimer(function()
            local x,y,z = getElementPosition(localPlayer);
            setCameraMatrix(x,y,z+10,x,y,z);
			playSound("boom.mp3",false);
                setTimer(function()
					showChat(true);
                    setCameraTarget(localPlayer);
				end,1000,1)
		end,1400,1)
	end,1400,1)
end


--UTILS--
addCommandHandler("getcampos",function(command)
	local x, y, z, lx, ly, lz = getCameraMatrix();
	outputChatBox(exports.fv_engine:getServerSyntax("CameraMatrix","servercolor").."  "..x..","..y..","..z..","..lx..","..ly..","..lz,255,255,255,true);
end)
function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end
function toPassword(password)
    if password then
        local length = utfLen(password)
        return string.rep("*", length)
    else 
        return "";
    end
end
function tooltip(text)
	local cx,cy = getCursorPosition();
	cx,cy = cx*sx,cy*sy;
	cx,cy = cx+10,cy+10;
	local width = dxGetTextWidth(text,1,font4)+10;
	dxDrawRectangle(cx-5,cy,width,18,tocolor(255,255,255,200),true);
	dxDrawText(text,cx-5,cy,(cx-5)+width,cy+20,tocolor(0,0,0),1,font4,"center","center",false,false,true,true);
end
function dxDrawBorder(x, y, w, h, radius, color) 
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

--Camera Move--
local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
        removeEventHandler("onClientPreRender",root,camRender)
        --setCameraTarget(localPlayer, localPlayer)
        camMove = false
	end
end
function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	end
end
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then return false end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
    addEventHandler("onClientPreRender",root,camRender, true, "low")
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"Linear")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"Linear")
	sm.moov = 1
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
    setTimer(destroyElement,time,1,sm.object2)
    camMove = true;
	return true
end

setTimer(
    function()
        if not getElementData(localPlayer, "afk") and getElementData(localPlayer,"loggedIn") then
            local oPlayTime = getElementData(localPlayer, "char >> playedtime")
            setElementData(localPlayer, "char >> playedtime", oPlayTime + 1)
        end
    end, 60 * 1000, 0
)
