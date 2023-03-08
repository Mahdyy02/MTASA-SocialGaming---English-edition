local poses = {
    {568.16693115234, -1762.9549560547, 5.8156147003174, 142},
    {286.58135986328, -1236.9387207031, 74.845634460449, 62},
    {-381.00366210938, -1044.6055908203, 58.971954345703, 190},
    {-603.32086181641, -1071.7176513672, 23.485504150391, 266},
    {-2097.2443847656, -490.24533081055, 35.53125, 225},
    {-2445.8039550781, -56.841865539551, 34.265625, 82},
    {-2705.912109375, 376.10992431641, 4.9684338569641, 96},
    {-2502.9619140625, 2366.3051757813, 4.9799952507019, 100},
    {1368.2032470703, 250.69502258301, 19.566932678223, 68},
    {1553.0330810547, 14.097003936768, 24.147323608398, 321},
    {2550.4064941406, -9.6261806488037, 26.918849945068, 92},
    {2218.7849121094, -1178.8675537109, 29.79708671569, 0},
    {1927.3782958984, -1779.3449707031, 13.48593711853, 38},
    {2771.5166015625, -2382.1586914063, 13.6328125, 51},
    {1906.83984375, -1773.599609375, 13.546875, 89},
    {2023.3785400391, -1774.4803466797, 13.55327796936, 165},
    {2429.8278808594, -2465.5947265625, 13.631258010864, 136},
    {2480.6564941406, -1718.5734863281, 13.545684814453, 338},
    {2388.181640625, -1281.6861572266, 25.129104614258, 93},
    {2285.1896972656, -1102.7095947266, 37.9765625, 171},
    {2090.8278808594, -973.01318359375, 51.91397857666, 186},
    {1733.4354248047, -1036.0372314453, 23.990545272827, 192},
    {1286.6145019531, -1292.5191650391, 13.538110733032, 82},
    {547.09790039063, -1293.3072509766, 17.248237609863, 356},
    {409.22134399414, -1232.2274169922, 51.5078125, 156},
    {-85.986663818359, -1399.1365966797, 3.0635657310486, 312},
    {-67.563415527344, -1168.375, 1.9142160415649, 245},
    {-1679.4140625, 438.04690551758, 7.1796875, 288},
    {-1592.6409912109, 746.70831298828, 7.1946678161621, 160},
    {167.31294250488, -180.0541229248, 1.578125, 266},
    {360.10104370117, -104.1661605835, 1.2817840576172, 359},
    {1367.2928466797, 248.42036437988, 19.566932678223, 52},
    {2272.6489257813, 182.35090637207, 26.424573898315, 281},
    {-562.07165527344, -1485.31640625, 9.3092250823975, 10},
    {-419.5993347168, -1974.0472412109, 25.652177810669, 10},
    {-230.53785705566, -2438.0844726563, 42.393550872803, 10},
    {-100.13763427734, -2706.9562988281, 75.491561889648, 10},
    {24.318962097168, -2647.3703613281, 40.46768951416, 50},
    {-51.465751647949, -2488.9360351563, 36.594692230225, 20},
    {-281.66235351563, -2175.970703125, 28.658536911011, 60},
    {-631.98156738281, -1924.8587646484, 19.158626556396, 66},
    {-894.46697998047, -2037.0335693359, 144.84071350098, 185},
    {-2229.5390625, -1743.7310791016, 480.875, 25},
    {-2063.4870605469, -755.38177490234, 32.171875, 36},
    {-2065.3913574219, -856.94415283203, 32.171875, 270},
}
local lastPos = math.random(1,#poses);
local rabbit = false;

addEventHandler("onResourceStart",resourceRoot,function()
    local x,y,z,rot = unpack(poses[lastPos]);
    rabbit = createPed(199,x,y,z,rot);
    setElementData(rabbit,"ped >> type", "Event");
    setElementData(rabbit,"ped >> name","Húsvéti nyúl");
    setElementFrozen(rabbit,true);
    setElementData(rabbit,"ped.noDamage",true);
    setElementData(rabbit,"rabbit",true);
    setElementData(rabbit,"used",false);
end);

function newPosition()
    local rand = math.random(1,#poses);
    while (rand == lastPos) do 
        rand = math.random(1,#poses);
    end
    lastPos = rand;
    local x,y,z,rot = unpack(poses[rand]);
    setElementPosition(rabbit,x,y,z);
    setElementRotation(rabbit,0,0,rot);
    setElementData(rabbit,"used",false);
end

addEvent("easter.giveItem",true);
addEventHandler("easter.giveItem",root,function(player)
    if getElementData(player,"network") then 
        if exports.fv_inventory:givePlayerItem(player,95,1,100,0) then 
            triggerEvent("easter.newPosition",player,player);
        else 
            outputChatBox(exports.fv_engine:getServerSyntax("Item","red").."Nem fért a tojás az inventorydba!",player,255,255,255,true);
            return;
        end
    end
end);

addEvent("easter.newPosition",true);
addEventHandler("easter.newPosition",root,function(player)
    newPosition();
end);

function getRabbitPos()
    return getElementPosition(rabbit);
end

--outputChatBox(exports.fv_engine:getServerSyntax("Húsvét","orange").."A húsvéti nyúl tartózkodási helye jelenleg: "..exports.fv_engine:getServerColor("servercolor",true)..getZoneName(getElementPosition(rabbit)),root,255,255,255,true);


addCommandHandler("gotonyul",function(player)
    if getPlayerSerial(player) == "D7896CF67693A8014C5ADE794A90C294" then 
        setElementPosition(player,getElementPosition(rabbit));
    end
end);


setTimer(function()
    if not isElement(getElementData(rabbit,"used")) then 
        setElementData(rabbit,"used",false);
    end
end,1000,0);

addEventHandler("onPlayerQuit",root,function()
    if getElementData(rabbit,"used") or false == source then 
        setElementData(rabbit,"used",false);
    end
end);