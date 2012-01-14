--
-- 
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

xyWindowSize = srGetWindowSize();
imgPump1 = "Pump1.png";
imgEndRed = "Endurance-Red.png";
delay_time = 500;

function doit()
	askForWindow("Make sure the Skills window is visible.");
	local end_red;
	while 1 do
		lsSleep(delay_time);
		if end_red then
			statusScreen("Waiting to pump... (Endurace is RED)");
		else
			statusScreen("Pumping... (make sure Skills window is visible)");
		end
		srReadScreen();
		end_red = srFindImage(imgEndRed, 5000);
		if not end_red then
			local dig = srFindImage(imgPump1, 5000);
			if dig then
				srClickMouseNoMove(dig[0]+5, dig[1], 0);
			else
				error "Could not find Pump button";
			end
		end
	end
end
