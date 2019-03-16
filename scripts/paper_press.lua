-- Open windows with window_opener.lua
-- Arrange them with winder_arranger.lua in paper press mode
-- Run this
-- Profit!

dofile("screen_reader_common.inc");
dofile("ui_utils.inc");

local per_click_delay = 0;

function setWaitSpot(x0, y0)
	setWaitSpot_x = x0;
	setWaitSpot_y = y0;
	setWaitSpot_px = srReadPixel(x0, y0);
end

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

function clickAll(image_name, up, image_name2)
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 and image_name2 then
		buttons = findAllImages(image_name2);
	end
	
	if #buttons == 0 then
		error 'Could not find \'Paper Press\' windows.'
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

function refocus()
	statusScreen("Refocusing...");
	for i=2, #window_locs do
		setWaitSpot(window_locs[i][0], window_locs[i][1]);
		srClickMouseNoMove(window_locs[i][0] + 321, window_locs[i][1] + 74);
		waitForChange();
	end
end

function doit()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Open and pin your paper presses. The machines need to be completely empty (including presses can not have linen already lined). If you have many use window_opener and window_arranger to open and arrange the menus.");

	srReadScreen();	

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("PaperLine2.png", 1, "PaperLine.png");
		lsSleep(200);
		-- refocus();

		clickAll("PaperMake.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for 1st batch of paper to finish", nil, 0.7, 0.7);

		clickAll("PaperMake.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for 2nd batch of paper to finish", nil, 0.7, 0.7);

		clickAll("PaperRemove.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("PaperTake.png", 1);
		lsSleep(200);

		clickAll("Everything.png", 1);
		lsSleep(200);
		
	end

end