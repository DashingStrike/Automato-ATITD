--
-- TODO:
--   detect change in menu options as a change too!

-- Replaces these with =nil or =1 to debug better
do_click_refresh = 1;
do_click_refresh_when_end_red = 1;
prompt_before_working = nil;

dofile("common.inc");

xyWindowSize = srGetWindowSize();
delay_time = 250;
lag_wait_after_click = 1500;

directions1 = {"Eastern", "Northern", "Southern", "Western"};
directions2 = {"Down", "Left", "Right", "Up"};
tolerance = 6000;
span_w = 12; -- Number of pixels to scan looking for span changing
span_h = 9;
log_lines = {};
num_log_lines = 8;
function log(msg)
	lsPrintln(msg);
	if #log_lines == num_log_lines then
		for i=1,num_log_lines-1 do
			log_lines[i] = log_lines[i+1];
		end
		log_lines[num_log_lines] = msg;
	else
		log_lines[#log_lines+1] = msg;
	end
end

function doit()
	for i=1, 20 do
		log("...");
	end
	local num_workers=0;
	while ((not num_workers) or (num_workers < 2) or (num_workers > 5)) do
		num_workers = promptNumber("How many Workers (2-4)?", 4);
	end
	local my_index = 0;
	while ((not my_index) or (my_index < 1) or (my_index > num_workers)) do
		my_index = promptNumber("Which Worker # are you (1-" .. num_workers .. ")?", 1);
	end
	if promptOkay("Do you want an OK Prompt to appear (similar to this) when it\'s your turn?\n\nClicking No will have macro click for you, but lag might possibly cause premature clicking (if red endurance is lagging behind).\n\nClicking Yes will prompt you to click OK each time it\'s your turn, but lag proof.", nil, 0.7, 1, nil, 50) then
	  prompt_before_working = 1;
	  promptText = "Click after Prompt";
	  else
	  promptText = "Click without Prompt";
	end

	askForWindow("Quarrier #" .. my_index .. ", make sure the Skills window (END) is visible and quarry window is pinned.\n\nClicking Mode: " .. promptText);
	local end_red;
	-- Initialize span
	local span_pixels = {};
	for x=1, span_w do
		span_pixels[x] = {};
		for y=1, span_h do
			span_pixels[x][y] = 0;
		end
	end
	-- Initialize last directions
	local last_directions = {};
	for i=1, num_workers do
		last_directions[i] = {};
		last_directions[i][1] = -1;
		last_directions[i][2] = -1;
	end
	
	
	-- Refresh quarry window
	srReadScreen();
	local quarry = srFindImage("Quarry-ThisIsAStoneQuarry.png", 6000);
	if not quarry then
		quarry = srFindImage("Quarry-ThisIsAStoneQuarry2.png", 6000);
	end
	if not quarry then
		error "Could not find quarry window";
	end
	if do_click_refresh then
		srClickMouseNoMove(quarry[0], quarry[1], 0);
	end
	local different = nil;
	
	while 1 do
		lsSleep(delay_time);
		srReadScreen();
		-- Find Quarry window
		local quarry = srFindImage("Quarry-ThisIsAStoneQuarry.png", 6000);
		if not quarry then
			quarry = srFindImage("Quarry-ThisIsAStoneQuarry2.png", 6000);
		end
		if not quarry then
			error "Could not find quarry window";
		end
		
		-- Check END
		end_red = srFindImage("Endurance-Red.png");
		-- Look for num_workers rows of Work This text
		local x0 = quarry[0] - 5;
		local y0 = quarry[1];
		local positions = {};
		local directions = {{}, {}, {}, {}};
		for index=1, num_workers do
			pos = srFindImageInRange("Quarry-WorkTheQuarry.png", x0, y0, 250, 200, tolerance);
			if not pos then
				error ("Could not find 'Work The Quarry' #" .. index);
			end
			-- lsPrintln(" found at " .. pos[0] .. "," .. pos[1]);
			positions[index] = pos;
			-- Find the directional text
			local my_direction1 = nil;
			for direction=1,4 do
				if srFindImageInRange("Quarry-" .. directions1[direction] .. ".png", pos[0], pos[1], 250, 10, tolerance) then
					my_direction1 = direction;
				end
			end
			if not my_direction1 then
				error ("Could not find direction1 for index #" .. index);
			end
			local my_direction2 = nil;
			for direction=1,4 do
				if srFindImageInRange("Quarry-" .. directions2[direction] .. ".png", pos[0], pos[1], 250, 10, tolerance) then
					my_direction2 = direction;
				end
			end
			if not my_direction2 then
				error ("Could not find direction2 for index #" .. index);
			end
			directions[index][1] = my_direction1;
			directions[index][2] = my_direction2;
			
			y0 = pos[1] + 10; -- Don't find the same one!
		end
		
		-- Compare against last time
		for i=1,num_workers do
			if not ((last_directions[i][1] == directions[i][1]) and (last_directions[i][2] == directions[i][2])) then
				different = 1;
			end
			last_directions[i][1] = directions[i][1];
			last_directions[i][2] = directions[i][2];
		end
		
		-- Sort
		sorted = {1, 2, 3, 4};
		for i=1,num_workers do
			for j=i+1,num_workers do
				if ((directions[sorted[i]][1] > directions[sorted[j]][1]) or
						((directions[sorted[i]][1] == directions[sorted[j]][1]) and (directions[sorted[i]][2] > directions[sorted[j]][2]))) then
					sorted[i], sorted[j] = sorted[j], sorted[i];
				end
			end
		end
		
		-- Check to see if span indicator has changed!
		has_been_raised = srFindImageInRange("Quarry-HasBeenRaisedBy.png", quarry[0], quarry[1], 500, 100, tolerance);
		if not has_been_raised then
			error "Could not find text 'has been raised by'";
		end
		span_x = has_been_raised[0] + 125;
		span_y = has_been_raised[1];
		for x=1, span_w do
			for y=1, span_h do
				newvalue = srReadPixelFromBuffer(span_x + x, span_y + y);
				if not (newvalue == span_pixels[x][y]) then
					different = 1;
				end
				span_pixels[x][y] = newvalue;
			end
		end

		-- Display status and debug info		
		lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
		lsPrint(10, 20, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
		if end_red then
			lsPrint(10, 60, 0, 1, 1, 0xFF8080ff, "Waiting (END red)...");
		elseif different then
			lsPrint(10, 60, 0, 1, 1, 0x20FF20ff, "Quarrying...");
		else
			lsPrint(10, 60, 0, 1, 1, 0xFFFFFFff, "Waiting for change...");
		end
		for index=1, num_workers do
			color = 0xFFFFFFff;
			if index == my_index then
				color = 0xDFFFDFff;
			end
			lsPrint(10, 80 + 15*index, 0, 0.7, 0.7, color, "#" .. index .. " - #" .. sorted[index] .. " " .. positions[sorted[index]][0] .. "," .. positions[sorted[index]][1] .. " = " .. directions1[directions[sorted[index]][1]] .. "-" .. directions2[directions[sorted[index]][2]]);
		end
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
		-- display span pixels
		for x=1, span_w do
			for y=1, span_h do
				local size = 5;
				lsDisplaySystemSprite(1, 10+x*size, 160+y*size, 1, size, size, span_pixels[x][y]);
			end
		end			
		-- display log
		if #log_lines then
			for i=1, #log_lines do
				lsPrint(10, 160+span_h*5+1 + 15*i, 1, 0.7, 0.7, 0x808080ff, log_lines[i]);
			end
		end
		checkBreak("button_pause");
		lsDoFrame();
		
		if end_red then
			-- Do nothing
			-- Refresh quarry window
			if do_click_refresh and do_click_refresh_when_end_red then
				srClickMouseNoMove(quarry[0], quarry[1], 0);
			end
		elseif different then
			index = sorted[my_index];
			log("Quarrying - " .. directions1[directions[index][1]] .. "-" .. directions2[directions[index][2]]);
			-- Click my button!
			if prompt_before_working then
				if promptOkay("Click OK to click on " .. positions[index][0] .. "," .. positions[index][1] .. " = " .. directions1[directions[index][1]] .. "-" .. directions2[directions[index][2]], nil, 0.7, nil, 1) then
					srClickMouseNoMove(positions[index][0]+5, positions[index][1]+1, 0);
				end
			else
				-- just click
				srClickMouseNoMove(positions[index][0]+5, positions[index][1]+1, 0);
				lsSleep(lag_wait_after_click);

			end
			different = nil;
			-- Refresh the window
			if do_click_refresh then
				lsSleep(delay_time);
				srClickMouseNoMove(quarry[0], quarry[1], 0);
			end
		else
			-- Refresh quarry window
			if do_click_refresh then
				srClickMouseNoMove(quarry[0], quarry[1], 0);
			end
		end
	end
end
