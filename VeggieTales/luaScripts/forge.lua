-- Open, Add Charcoal, Fire, Pin, and arrange your forge windows
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
loadfile("luaScripts/Forge.inc")();
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
				if button_names[i] == "Knife Blade" then
					x = 30;
					y = 10;
					bsize = 130;
				elseif button_names[i] == "Shovel Blade" then
					x = 30;
					y = 40;
					bsize = 130;
				elseif button_names[i] == "Nails" then
					x = 30;
					y = 70;
					bsize = 130;
				elseif button_names[i] == "Copper Pipe" then
					x = 30;
					y = 100;
					bsize = 130;
				elseif button_names[i] == "Lead Pipe" then
					x = 30;
					y = 130;
					bsize = 130;
				elseif button_names[i] == "Bars" then
					x = 30;
					y = 170;
					bsize = 130;
				elseif button_names[i] == "Sheeting" then
					x = 30;
					y = 200;
					bsize = 130;
				elseif button_names[i] == "Straps" then
					x = 30;
					y = 230;
					bsize = 130;
				elseif button_names[i] == "Tools" then
					x = 30;
					y = 260;
					bsize = 130;
				elseif button_names[i] == "Wire" then
					x = 30;
					y = 290;
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
		
		if image_name == "Knife Blade" then
			KnifeBlade();
		elseif image_name == "Shovel Blade" then
			ShovelBlade();
		elseif image_name == "Nails" then
			Nails();
		elseif image_name == "Copper Pipe" then
			CopperPipe();
		elseif image_name == "Lead Pipe" then
			LeadPipe();
		elseif image_name == "Bars" then
			Bars();
		elseif image_name == "Sheeting" then
			Sheeting();
		elseif image_name == "Straps" then
			Straps();
		elseif image_name == "Tools" then
			Tools();
		elseif image_name == "Wire" then
			Wire();
		end
	end
end
