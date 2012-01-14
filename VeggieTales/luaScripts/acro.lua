--
-- 
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

function doit()
	askForWindow();
	
	local num_clicks = 0;
	
	while 1 do
		lsSleep(250);
		srReadScreen();
		
		acro = findAllImages("Acro.png");
		
		if #acro == 2 then
			statusScreen("Acro timer visible");
		else
			if #acro == 0 then
				statusScreen("No acro windows");
			else
				buttons = findAllImages("AcroButton1.png");
				buttons2 = findAllImages("AcroButton2.png");
				for i=1, #buttons2 do
					buttons[#buttons+1] = buttons2[i];
				end
				if #buttons==0 then
					statusScreen("No moves visible");
				else
					index = math.random(#buttons);
					lsSleep(2000);
					srClickMouseNoMove(buttons[index][0]+10, buttons[index][1]+5);
					statusScreen("click " .. index);
					lsSleep(1000);
				end
			end
		end
	end
end
