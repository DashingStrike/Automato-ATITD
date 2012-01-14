-- Open and Pin kettle windows
-- 
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

-- Begin Kettle functions

function Unpin()
	
	srReadScreen();

	window_locs = findAllImages("This.png");

	clickAll("This.png", 1);
	lsSleep(200);
	
	clickAll("Unpin.png", 1);
	lsSleep(200);
end


function FlowerFert()
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menu.\nRequires: " .. num_loops*3 .. " Rotten Fish, " .. num_loops*5 .. " Wood, and " .. num_loops*5 .. " Water in Jugs per kettle.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Kettle_Flower_Fert.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Kettle_Begin.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(40*1000, "[" .. i .. "/" .. num_loops .. "] Waiting for Flower Fertilizer to finish");
		
		clickAll("Kettle_Take.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("tash.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Flower_Fertilizer.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("maxButton.png", 1);
		lsSleep(200);
		-- refocus();

	end
end

function GrainFert()
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menu.\nRequires: " .. num_loops*1 .. " Rotten Fish, " .. num_loops*1 .. " Dung, " .. num_loops*5 .. " Wood, and " .. num_loops*5 .. " Water in Jugs per kettle.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Kettle_Grain_Fert.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Kettle_Begin.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(40*1000, "[" .. i .. "/" .. num_loops .. "] Waiting for Grain Fertilizer to finish");
		
		clickAll("Kettle_Take.png", 1);
		lsSleep(200);
		-- refocus();

	end
end

function WeedKiller()
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menu.\nRequires: " .. num_loops*1 .. " Toad Skin Mushroom, " .. num_loops*5 .. " Wood, and " .. num_loops*5 .. " Water in Jugs per kettle.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Kettle_Weed_Killer.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Kettle_Begin.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(40*1000, "[" .. i .. "/" .. num_loops .. "] Waiting for Weed Killer to finish");
		
		clickAll("Kettle_Take.png", 1);
		lsSleep(200);
		-- refocus();

	end
end

function Arsenic()
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menu.\nRequires: " .. num_loops*1 .. " Razors Edge Mushroom, " .. num_loops*1 .. " Scorpions Brood Mushroom, " .. num_loops*5 .. " Wood, and " .. num_loops*5 .. " Oil per kettle.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Kettle_Arsenic.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Kettle_Begin.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(40*1000, "[" .. i .. "/" .. num_loops .. "] Waiting for Arsenic to finish");
		
		clickAll("Kettle_Take.png", 1);
		lsSleep(200);
		-- refocus();

	end
end

function GebsTears()
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menu.\nRequires: " .. num_loops*30 .. " Flower Bulbs, " .. num_loops*20 .. " Wood, and " .. num_loops*20 .. " Water in Jugs per kettle.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Kettle_Gebs_Tears.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Kettle_Begin.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(40*1000, "[" .. i .. "/" .. num_loops .. "] Waiting for Gebs Tears to finish");
		
		clickAll("Kettle_Take.png", 1);
		lsSleep(200);
		-- refocus();

	end
end

button_names = {
"Flower Fert",
"Grain Fert",
"Weed Killer",
"Arsenic",
"Gebs Tears",
"Un-Pin Windows"
};

		
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
				if button_names[i] == "Flower Fert" then
					x = 30;
					y = 10;
					bsize = 250;
				elseif button_names[i] == "Grain Fert" then
					x = 30;
					y = 50;
					bsize = 250;
				elseif button_names[i] == "Weed Killer" then
					x = 30;
					y = 90;
					bsize = 250;
				elseif button_names[i] == "Arsenic" then
					x = 30;
					y = 130;
					bsize = 250;
				elseif button_names[i] == "Gebs Tears" then
					x = 30;
					y = 170;
					bsize = 250;
				elseif button_names[i] == "Un-Pin Windows" then
					x = 30;
					y = 210;
					bsize = 250;
				end
				if lsButtonText(x, y, 0, bsize, 0x80D080ff, button_names[i]) then
					image_name = button_names[i];
					is_done = 1;
				end
			end

			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Flower Fert" then
			FlowerFert();
		elseif image_name == "Grain Fert" then
			GrainFert();
		elseif image_name == "Weed Killer" then
			WeedKiller();
		elseif image_name == "Arsenic" then
			Arsenic();
		elseif image_name == "Gebs Tears" then
			GebsTears();
		elseif image_name == "Un-Pin Windows" then
			Unpin();
		end
	end
end
