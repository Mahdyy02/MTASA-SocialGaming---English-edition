local tips = {
    [1] = {"Have you seen a buggy, a foul, or have a question? #CA2323/admins #ffffff and #CA2323 /pm [id] #ffffff you can always ask online admins."},
	[2] = {"You can hire a job at the Town Hall Or Driving licence (F11 Job Center Icon)"},
	[3] = {"Players playing on the server are required to abide by the rules, the server rules can be viewed by pressing F3. Failure to do so will result in failure to comply with the rules!"},
	[4] = {"Discord Server : #CA2323https://discord.gg/CFhtPV "},
	[5] = {"You can also turn on your own nametaged with #CA2323/togname"},
	[6] = {"Don't know where your car is? Open the dashboard then go to the fortune and right click on your car and select it! "},
    [7] = {"Don't like how widgets get placed? With m + CTRL you can set where you want to place the widget"},
};
local last = 0

function createTip()
    local rand = math.random(1,#tips);
    while (last==rand) do 
        createTip();
        return;
    end
    last = rand;
    outputChatBox(exports.fv_engine:getServerSyntax("Tipp","servercolor")..tips[rand][1],255,255,255,true);
end

setTimer(function()
    createTip();
end,1000*60*30,0)
createTip();

removeWorldModel(5374,9999,0,0,0);