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

-- Begin Kettle functions

function Unpin()
	
	askForWindow("Press Shift key to unpin/close all pinned windows. If you should get any errors, put ATITD window in focus first, before pressing Shift key.");
	
	srReadScreen();

	window_locs = findAllImages("This.png");

	clickAllRight("This.png", 1);
	lsSleep(200);
	
end

function FlowerFert()
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menus.\nRequires: " .. num_loops*3 .. " Rotten Fish, " .. num_loops*5 .. " Wood, and " .. num_loops*5 .. " Water in Jugs per kettle.");
	
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
		
		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();
	end
end

function GrainFert()
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menus.\nRequires: " .. num_loops*1 .. " Rotten Fish, " .. num_loops*1 .. " Dung, " .. num_loops*5 .. " Wood, and " .. num_loops*5 .. " Water in Jugs per kettle.");
	
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
		
		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();

	end
end

function Acid()
	
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menus.\nRequires: " .. num_loops*25 .. " Sulphurous Water, " .. num_loops*1 .. " Salt, " .. num_loops*28 .. " Wood will be needed per kettle.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus()

		clickAll("Kettle_Acid.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("Begin.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("Ignite.png", 1);
		lsSleep(200);
		-- refocus();
	
	for i=1, #window_locs do
		clickAll("maxButton.png", 1);
		lsSleep(1);
		-- refocus();
	end
		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*230, "[" .. i .. "/" .. num_loops .. "] Waiting for 24 water to stroke");
		
		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*280, "[" .. i .. "/" .. num_loops .. "] Waiting for 19 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*280, "[" .. i .. "/" .. num_loops .. "] Waiting for 14 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*275, "[" .. i .. "/" .. num_loops .. "] Waiting for 9 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*170, "[" .. i .. "/" .. num_loops .. "] Waiting for 6 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*340, "[" .. i .. "/" .. num_loops .. "] Waiting for Acid to finish");

		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();

	end

end

function Potash()
	
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menus.\nRequires: " .. num_loops*5 .. " Ash, " .. num_loops*28 .. " Wood, and " .. num_loops*25 .. " Water in Jugs per kettle.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus()

		clickAll("Kettle_Potash.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("Begin.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("Ignite.png", 1);
		lsSleep(200);
		-- refocus();
	
	for i=1, #window_locs do
		clickAll("maxButton.png", 1);
		lsSleep(1);
		-- refocus();
	end
		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*230, "[" .. i .. "/" .. num_loops .. "] Waiting for 24 water to stroke");
		
		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*280, "[" .. i .. "/" .. num_loops .. "] Waiting for 19 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*280, "[" .. i .. "/" .. num_loops .. "] Waiting for 14 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*275, "[" .. i .. "/" .. num_loops .. "] Waiting for 9 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*170, "[" .. i .. "/" .. num_loops .. "] Waiting for 6 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*340, "[" .. i .. "/" .. num_loops .. "] Waiting for Potash to finish");

		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();

	end

end

function Sulfur()
	
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menus.\nRequires: " .. num_loops*25 .. " Sulphurous Water, " .. num_loops*28 .. " Wood will be needed per kettle.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus()

		clickAll("Kettle_Sulfur.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("Begin.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("Ignite.png", 1);
		lsSleep(200);
		-- refocus();
	
	for i=1, #window_locs do
		clickAll("maxButton.png", 1);
		lsSleep(1);
		-- refocus();
	end
		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*230, "[" .. i .. "/" .. num_loops .. "] Waiting for 24 water to stroke");
		
		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*280, "[" .. i .. "/" .. num_loops .. "] Waiting for 19 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*280, "[" .. i .. "/" .. num_loops .. "] Waiting for 14 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*275, "[" .. i .. "/" .. num_loops .. "] Waiting for 9 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*170, "[" .. i .. "/" .. num_loops .. "] Waiting for 6 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*340, "[" .. i .. "/" .. num_loops .. "] Waiting for sulfur to finish");

		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();

	end

end

function Salt()
	
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menus.\nRequires: " .. num_loops*25 .. " Coconut Water, " .. num_loops*28 .. " Wood will be needed per kettle.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus()

		clickAll("Kettle_Salt.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("Begin.png", 1);
		lsSleep(200);
		-- refocus();

		clickAll("Ignite.png", 1);
		lsSleep(200);
		-- refocus();
	
	for i=1, #window_locs do
		clickAll("maxButton.png", 1);
		lsSleep(1);
		-- refocus();
	end
		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*230, "[" .. i .. "/" .. num_loops .. "] Waiting for 24 water to stroke");
		
		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*280, "[" .. i .. "/" .. num_loops .. "] Waiting for 19 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*280, "[" .. i .. "/" .. num_loops .. "] Waiting for 14 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*275, "[" .. i .. "/" .. num_loops .. "] Waiting for 9 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*170, "[" .. i .. "/" .. num_loops .. "] Waiting for 6 water to stroke");

		clickAll("StokeMax.png", 1);
		lsSleep(200);
		-- refocus();

		sleepWithStatus(10*60*340, "[" .. i .. "/" .. num_loops .. "] Waiting for Salt to finish");

		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();

	end

end

function WeedKiller()
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menus.\nRequires: " .. num_loops*1 .. " Toad Skin Mushroom, " .. num_loops*5 .. " Wood, and " .. num_loops*5 .. " Water in Jugs per kettle.");
	
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
		
		sleepWithStatus(80*1000, "[" .. i .. "/" .. num_loops .. "] Waiting for Weed Killer to finish");
		
		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();

	end
end

function Arsenic()
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menus.\nRequires: " .. num_loops*1 .. " Razors Edge Mushroom, " .. num_loops*1 .. " Scorpions Brood Mushroom, " .. num_loops*5 .. " Wood, and " .. num_loops*5 .. " Oil per kettle.");
	
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
		
		clickAll("Take.png", 1);
		lsSleep(200);
		-- refocus();

	end
end

function GebsTears()
	num_loops = promptNumber("How many passes ?", 10);
	askForWindow("Open and pin the Kettle menus.\nRequires: " .. num_loops*30 .. " Flower Bulbs, " .. num_loops*20 .. " Wood, and " .. num_loops*20 .. " Water in Jugs per kettle.");
	
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
		
		clickAll("Take.png", 1);
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
"Potash",
"Sulfur",
"Acid",
"Salt",
"Un-Pin Windows"
};

		
function doit()
	while 1 do
		local num_kettles = 1;
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
					y = 40;
					bsize = 250;
				elseif button_names[i] == "Weed Killer" then
					x = 30;
					y = 70;
					bsize = 250;
				elseif button_names[i] == "Arsenic" then
					x = 30;
					y = 100;
					bsize = 250;
				elseif button_names[i] == "Gebs Tears" then
					x = 30;
					y = 130;
					bsize = 250;
				elseif button_names[i] == "Sulfur" then
					x = 30;
					y = 160;
					bsize = 250;
				elseif button_names[i] == "Potash" then
					x = 30;
					y = 190;
					bsize = 250;
				elseif button_names[i] == "Acid" then
					x = 30;
					y = 220;
					bsize = 250;
				elseif button_names[i] == "Salt" then
					x = 30;
					y = 250;
					bsize = 250;
				elseif button_names[i] == "Un-Pin Windows" then
					x = 30;
					y = 280;
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
		elseif image_name == "Sulfur" then
			Sulfur();
		elseif image_name == "Potash" then
			Potash();
		elseif image_name == "Acid" then
			Acid();
		elseif image_name == "Salt" then
			Salt();
		elseif image_name == "Un-Pin Windows" then
			Unpin();
		end
	end

end
