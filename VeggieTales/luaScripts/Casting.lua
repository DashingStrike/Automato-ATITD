-- Open, Add Charcoal, Fire, Pin, and arrange your casting box windows
-- **Does not take items**
-- ***********************
--Below times are exact teppy minutes + 3 seconds *1000 (ms)
-- Times:
-- 1 Minute = 69000
-- 2 Minutes = 138000
-- 3 Minutes = 207000
-- 4 Minutes = 276000
-- 5 Minutes = 345000
-- 6 Minutes = 414000
-- 10 Minutes = 690000 
-- 15 Minutes = 1035000
-- 20 minutes = 1380000
-- 25 minutes = 1725000
-- 30 minutes = 2070000
-- ***********************



loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();
loadfile("luaScripts/Casting.inc")();
-- loadfile("luaScripts/Forge_Bars.lua")();

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

function clickAll(image_name)
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
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #button_names do
				if button_names[i] == "Heavy Lead Bowl" then
					x = 30;
					y = 10;
					bsize = 130;
				elseif button_names[i] == "Monkey Wrench" then
					x = 30;
					y = 40;
					bsize = 130;
				elseif button_names[i] == "Silver Bowl" then
					x = 30;
					y = 70;
					bsize = 130;
				elseif button_names[i] == "Iron Cookpot" then
					x = 30;
					y = 100;
					bsize = 130;
				elseif button_names[i] == "Anvil Bed" then
					x = 30;
					y = 130;
					bsize = 130;
				elseif button_names[i] == "Fuel" then
					x = 30;
					y = 170;
					bsize = 130;
				elseif button_names[i] == "Gearwork" then
					x = 30;
					y = 200;
					bsize = 130;
				elseif button_names[i] == "Hardware" then
					x = 30;
					y = 230;
					bsize = 130;
				elseif button_names[i] == "Tools" then
					x = 30;
					y = 260;
					bsize = 130;
				end
				if lsButtonText(x, y, 0, 250, 0xe5d3a2ff, button_names[i]) then
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
		
		if image_name == "Heavy Lead Bowl" then
			heavyleadbowl();
		elseif image_name == "Monkey Wrench" then
			monkeywrench();
		elseif image_name == "Silver Bowl" then
			silverbowl();
		elseif image_name == "Iron Cookpot" then
			ironcookpot();
		elseif image_name == "Anvil Bed" then
			anvilbed();
		elseif image_name == "Fuel" then
			fuel();
		elseif image_name == "Gearwork" then
			gearwork();
		elseif image_name == "Hardware" then
			hardware();
		elseif image_name == "Tools" then
			tools();
		end
	end
end
