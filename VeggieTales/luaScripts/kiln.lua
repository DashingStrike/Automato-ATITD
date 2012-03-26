loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

local per_click_delay = 0;

function setWaitSpot(x0, y0)
	setWaitSpot_x = x0;
	setWaitSpot_y = y0;
	setWaitSpot_px = srReadPixel(x0, y0);
end

button_names = {
"Jugs",
"Clay Bricks",
"Firebricks",
"Clay Morters",
"Un-Pin Windows"
};

function waitForChange()
	local c=0;
	while srReadPixel(setWaitSpot_x, setWaitSpot_y) == setWaitSpot_px do
		lsSleep(1);
		c = c+1;
		if (lsShiftHeld() and lsControlHeld()) then
			error 'broke out of loop from Shift+Ctrl';
		end
	end
	-- lsPrintln('Waited ' .. c .. 'ms for pixel to change.');
end

function clickAll(image_name)
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		error 'Could not find \'Kiln\' windows.'
		--statusScreen("Could not find specified buttons...");
		--lsSleep(1500);
	else
		statusScreen("Clicking " .. #buttons .. "button(s)...");
		if up then
			for i=#buttons, 1, -1  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3);
				lsSleep(per_click_delay);
			end
		else
			for i=1, #buttons  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3);
				lsSleep(per_click_delay);
			end
		end
		statusScreen("Done clicking (" .. #buttons .. " clicks).");
		lsSleep(100);
	end
end

function clickAllRight(image_name)
	-- Find windows and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		statusScreen("Could not find any pinned up windows...");
		lsSleep(1500);
	else
		statusScreen("Clicking " .. #buttons .. "windows(s)...");
		if up then
			for i=#buttons, 1, -1  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, true);
				lsSleep(per_click_delay);
			end
		else
			for i=1, #buttons  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, true);
				lsSleep(per_click_delay);
			end
		end
		statusScreen("Done clicking (" .. #buttons .. " windows).");
		lsSleep(100);
	end
end

function refocus()
	statusScreen("Refocusing...");
	for i=2, #window_locs do
		setWaitSpot(window_locs[i][0], window_locs[i][1]);
		srClickMouseNoMove(window_locs[i][0] + 321, window_locs[i][1] + 74);
		waitForChange();
	end
end


function Unpin()

	askForWindow("Press Shift key to unpin/close all pinned windows. If you should get any errors, put ATITD window in focus first, before pressing Shift key.");
	
	srReadScreen();

	window_locs = findAllImages("This.png");

	clickAllRight("This.png", 1);
	lsSleep(200);
end


function Clay_Morter()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Pin all Kiln windows up.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

	-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

		--Checks to see if kiln is about to crumble
			local Brokenkiln = srFindImage("crumble.png");
	        	if Brokenkiln then
			error 'Your kiln is about to break time to replace it';
				end


		clickAll("wet_clay_morters.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("wood.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("fire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(10*60*230, "[" .. i .. "/" .. num_loops .. "] Waiting for Kilns to finish");

		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Everything.png", 1);
		lsSleep(200);
		-- refocus();
		
		-- refresh windows, one last time so we know for sure the machine is empty (Take menu disappears)
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();


	end
end

function Jugs()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Pin all Kiln windows up.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

	-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

		--Checks to see if kiln is about to crumble
			local Brokenkiln = srFindImage("crumble.png");
	        	if Brokenkiln then
			error 'Your kiln is about to break time to replace it';
				end


		clickAll("wet_jugs.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("wood.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("fire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(10*60*230, "[" .. i .. "/" .. num_loops .. "] Waiting for Kilns to finish");

		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Everything.png", 1);
		lsSleep(200);
		-- refocus();
		
		-- refresh windows, one last time so we know for sure the machine is empty (Take menu disappears)
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();


	end
end

function Clay_Bricks()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Pin all Kiln windows up.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

	-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

		--Checks to see if kiln is about to crumble
			local Brokenkiln = srFindImage("crumble.png");
	        	if Brokenkiln then
			error 'Your kiln is about to break time to replace it';
				end


		clickAll("wet_clay_bricks.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("wood.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("fire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(10*60*230, "[" .. i .. "/" .. num_loops .. "] Waiting for Kilns to finish");

		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Everything.png", 1);
		lsSleep(200);
		-- refocus();
		
		-- refresh windows, one last time so we know for sure the machine is empty (Take menu disappears)
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();


	end
end

function Firebricks()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Pin all Kiln windows up.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

	-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

		--Checks to see if kiln is about to crumble
			local Brokenkiln = srFindImage("crumble.png");
	        	if Brokenkiln then
			error 'Your kiln is about to break time to replace it';
				end


		clickAll("wet_firebricks.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("wood.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("fire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(10*60*230, "[" .. i .. "/" .. num_loops .. "] Waiting for Kilns to finish");

		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Everything.png", 1);
		lsSleep(200);
		-- refocus();
		
		-- refresh windows, one last time so we know for sure the machine is empty (Take menu disappears)
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();


	end
end

function doit()
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #button_names do
				if button_names[i] == "Jugs" then
					x = 30;
					y = 10;
					bsize = 200;
				elseif button_names[i] == "Clay Bricks" then
					x = 30;
					y = 40;
					bsize = 200;
				elseif button_names[i] == "Firebricks" then
					x = 30;
					y = 70;
					bsize = 200;
				elseif button_names[i] == "Clay Morters" then
					x = 30;
					y = 100;
					bsize = 200;
				elseif button_names[i] == "Un-Pin Windows" then
					x = 30;
					y = 160;
					bsize = 200;

				end
				if lsButtonText(x, y, 4, 250, 0xe5d3a2ff, button_names[i]) then
					image_name = button_names[i];
					is_done = 1;
				end
			end

			if lsButtonText(lsScreenX - 220, lsScreenY - 30, z, 150, 0xFF0000ff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Jugs" then
			Jugs();
		elseif image_name == "Clay Bricks" then
			Clay_Bricks();
		elseif image_name == "Firebricks" then
			Firebricks();
		elseif image_name == "Clay Morters" then
			Clay_Morter()
		elseif image_name == "Un-Pin Windows" then
			Unpin();
		end
	end
end
