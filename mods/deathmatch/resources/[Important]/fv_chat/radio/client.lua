addEvent("radio.sound",true);
addEventHandler("radio.sound",root,function()
	playSoundFrontEnd(47);
	setTimer(playSoundFrontEnd, 700, 1, 48);
	setTimer(playSoundFrontEnd, 800, 1, 48);
end);