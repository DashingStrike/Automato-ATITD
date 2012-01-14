--
-- 
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

per_click_delay = 10;

button_names = {
-- "Potash.png", "Begin.png", "Ignite.png", "StokeMax.png",
"ThisIs.png",
"Take.png",
"UnPin.png",
"ThistleAsc.png",
"Harvest.png",

"CUSTOM", "Last CUSTOM"};

up = nil;
right_click = nil;

function doit()
	askForWindow("Pin any number of windows, after selecting the window, you will be given a prompt of what kind of button to click on.");
	while 1 do
		local image_name = "ThisIs.png";

		-- Find buttons and click them!
		srReadScreen();
		xyWindowSize = srGetWindowSize();
		local buttons = findAllImages(image_name);
		
		if #buttons == 0 then
			statusScreen("Could not find specified buttons...");
			lsSleep(1500);
		else
			statusScreen("Clicking " .. #buttons .. "button(s)...");
			for i=#buttons, 1, -1 do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, right_click);
				lsSleep(per_click_delay);
			end
			statusScreen("Done clicking (" .. #buttons .. " clicks).");
			lsSleep(100);
		end

		image_name = "PlaneAPiece.png";

		-- Find buttons and click them!
		srReadScreen();
		xyWindowSize = srGetWindowSize();
		local buttons = findAllImages(image_name);
		
		if #buttons == 0 then
			statusScreen("Could not find specified buttons...");
			lsSleep(1500);
		else
			statusScreen("Clicking " .. #buttons .. "button(s)...");
			for i=#buttons, 1, -1 do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, right_click);
				lsSleep(per_click_delay);
			end
			statusScreen("Done clicking (" .. #buttons .. " clicks).");
			for j=1, 4 do
				lsSleep(1000);
				statusScreen("Waiting...");
			end;
		end

	end
end
