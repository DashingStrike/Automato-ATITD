-- Open windows with window_opener.lua
-- Arrange them with winder_arranger.lua in rock saw mode
-- Run this
-- Profit!

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

local expected_windows = 40; -- Just to double check you don't have any extra windows open that it'll try to click on
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

function clickAll(image_name, up)
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
	askForWindow("Open, pin, and arrange rock saws with window_opener/window_arranger first.");

	srReadScreen();	

	while true do
		window_locs = findAllImages("This.png");
		if not (#window_locs == expected_windows) then
			error ("Did not find expected number of windows (found " .. #window_locs .. " expected " .. expected_windows .. ")");
		end

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		
		refocus();
		
		clickAll("MakeACutStone.png", 1);
		lsSleep(200);
		
		refocus();
		
		sleepWithStatus(210*1000, "Waiting for stones to finish");

	end

end