--
-- 
--

dofile("screen_reader_common.inc");
dofile("ui_utils.inc");

per_click_delay = 10;

button_names = {
-- "Acid.png", "Potash.png", "Begin.png", "Ignite.png", "StokeMax.png",
"ThisIs.png",
"Take.png",
"UnPin.png",
"This.png",
"Harvest.png",

"CUSTOM", "Last CUSTOM"};

up = nil;
right_click = nil;
second_prompt = nil;

function doit()
	askForWindow("Pin any number of windows, after selecting the window, you will be given a prompt of what kind of button to click on.");
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;
		while not is_done do
			local y = 10;
			for i=1, #button_names do
				if lsButtonImg(10+4, y+4, 1, 1, 0xFFFFFFff, button_names[i]) then
					image_name = button_names[i];
					is_done = 1;
				end
				if lsButtonText(10, y, 0, 250, 0xFFFFFFff, button_names[i]) then
					image_name = button_names[i];
					is_done = 1;
				end
				y = y + 26;
			end
			if second_prompt then
				if lsButtonText(5, lsScreenY - 86, z, 150, 0xFFFFFFff, "Quick: NO") then
					second_prompt = nil;
				end
			else
				if lsButtonText(5, lsScreenY - 86, z, 150, 0xFFFFFFff, "Quick: YES") then
					second_prompt = 1;
				end
			end
			if right_click then
				if lsButtonText(5, lsScreenY - 58, z, 150, 0xFFFFFFff, "Click: RIGHT") then
					right_click = nil;
				end
			else
				if lsButtonText(5, lsScreenY - 58, z, 150, 0xFFFFFFff, "Click: LEFT") then
					right_click = 1;
				end
			end
			if up then
				if lsButtonText(5, lsScreenY - 30, z, 150, 0xFFFFFFff, "Order: UP") then
					up = nil;
				end
			else
				if lsButtonText(5, lsScreenY - 30, z, 150, 0xFFFFFFff, "Order: DOWN") then
					up = 1;
				end
			end

			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end
		
		if image_name == "CUSTOM" then
			while 1 do
				mx, my = srMousePos();
				srReadScreen();
				srMakeImage("CUSTOM", mx, my, 16, 8);
				srShowImageDebug("CUSTOM", 5, 200);
				statusScreen("Place mouse over relevent text (16x8 pixels used to the LOWER RIGHT of mouse) and press Shift.");
				if (lsShiftHeld()) then
					break;
				end
				lsSleep(10);
			end
		end
		
		if image_name == "Last CUSTOM" then
			image_name = "CUSTOM";
		end
		

		if second_prompt then
			askForWindow("Press Shift to continue. If you get any \'not found\' errors, then click ATITD window and put it in focus first.");
		end

		-- Find buttons and click them!
		srReadScreen();
		xyWindowSize = srGetWindowSize();
		local buttons = findAllImages(image_name);
		
		if #buttons == 0 then
			statusScreen("Could not find specified buttons...");
			lsSleep(1500);
		else
			statusScreen("Clicking " .. #buttons .. "button(s)...");
			if up then
				for i=#buttons, 1, -1 do
					srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, right_click);
					lsSleep(per_click_delay);
				end
			else
				for i=1, #buttons do
					srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, right_click);
					lsSleep(per_click_delay);
				end
			end
			statusScreen("Done clicking (" .. #buttons .. " clicks).");
			lsSleep(500);
		end
	end
end
