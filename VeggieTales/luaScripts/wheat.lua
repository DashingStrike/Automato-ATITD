-- This is a Clicker formater
-- **Does not take items**
-- ***********************
-- Times:
-- 1 Minute = 72*1000
-- 2 Minutes = 144*1000
-- 3 Minutes = 216*1000
-- 5 Minutes = 360*1000
-- 6 Minutes = 432*1000
-- 10 Minutes = 720*1000
-- 20 minutes = 1440*1000
-- ***********************





loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

local per_click_delay = 0;
local water_count = 0;

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

function clickAll(image_name)
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		statusScreen("Could not find specified buttons...");
		lsSleep(0);
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
	askForWindow("Pin Wheat Windows Up after you plant them then start the macro.You must by standing with water icon present and 50 water in jugs in inventory");

	srReadScreen();

	while 1 do
		
		Harvest = srFindImage("Harvest.png");
		Water = srFindImage("waterw.png");
		waterings = srFindImage("waterw.png", 1);
		empty_jugs = 0;



		if Harvest then

		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("Harvest.png", 1);
		lsSleep(200);
		-- refocus();




		elseif Water then

			
		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		empty_jugs = empty_jugs + #waterings;
		water_count = water_count + #waterings;
		

		clickAll("waterw.png", 1);
		lsSleep(200);
		-- refocus();


		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("Harvest.png", 1);
		lsSleep(200);
		-- refocus();

		elseif empty_jugs >= 40 then
		
		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("water.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("maxButton.png", 1);
		lsSleep(200);
		-- refocus();
		
		empty_jugs = 0;

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

		elseif not Water then

		sleepWithStatus(10*60*5, "Waiting for Wheat if you wish to plant more wheat press Alt+Shift");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

			end
		end
	end

