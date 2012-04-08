--
-- 
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

per_click_delay = 10;

--pause time is how long it waits after clicking on 'Plane a piece of wood' button (1000 ms = 1 second)
pause_time = 2500; 

right_click = nil;

function doit()
	askForWindow("Pin any number of Wood Plane or Carpentry Bench windows. Press Shift to continue.");
	while 1 do
		local image_name = "ThisIs.png";

		-- Click pin ups to refresh the window
		srReadScreen();
		xyWindowSize = srGetWindowSize();
		local buttons = findAllImages(image_name);
		
		if #buttons == 0 then

			error 'Could not find any pinned windows.'

		else
			statusScreen("Refreshing (" .. #buttons .. " windows)");
			for i=#buttons, 1, -1 do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, right_click);
				lsSleep(per_click_delay);
			end

		end


			lsSleep(200);



		image_name = "PlaneAPiece.png";

		-- Find buttons and click them!
		srReadScreen();
		xyWindowSize = srGetWindowSize();
		local buttons2 = findAllImages(image_name);
		
		if #buttons2 == 0 then
			statusScreen("Refreshing (" .. #buttons .. " windows)\n\nWaiting for buttons...");

		else

			for i=#buttons2, 1, -1 do
				srClickMouseNoMove(buttons2[i][0]+5, buttons2[i][1]+3, right_click);
				lsSleep(per_click_delay);
			end


			statusScreen("Done clicking (" .. #buttons2 .. " windows)\n\nPausing...");
				lsSleep(pause_time);


		end

	end
end
