-- glass.lua  modified by Silden 17-AUG-2017


dofile("common.inc"); -- To allow the findAllText function
dofile("screen_reader_common.inc");
dofile("ui_utils.inc");

-- Initial variables
window_w = 320;
window_h = 415;
temp_width = 95;
tol = 6500;
menuButtonSelected = 0;

-- It will make the first in the list if available, otherwise the next, etc
-- This will let you make, e.g. Rods on your Soda Glass and Sheet Glass on your normal, by putting
--   sheet glass before rods (on soda it'll fail to find sheet)
item_priority = {"GlassMakeSheet.png", "GlassMakeRod.png", "GlassMakeWine.png", 
                 "GlassMakePipe.png", "GlassMakeJar.png","GlassMakeTorch.png",
                 "GlassMakeBlade.png", "GlassMakeFineRod.png", "GlassMakeFinePipe.png"};
-- max temperature in which we will contine heating it, wait until it gets below this before adding
max_add_temp = 2300;
-- minimum temperature in which we will start a new project, otherwise will reheat
min_new_temp = 1750;

tick_time = 3000;

function ocrNumber(x, y)
	-- Finds the number at the given coordinate. 
	-- Glass numbers are now bigger than other numbers, so a different set of number files are needed 
	-- (glass0.png to glass9.png)
	
	local numberImageWidth = 7;
	local numberImageHeight = 11
	
	-- Find the first number
	local digit=nil; -- digit found
	local offset=0;
	while (not digit) and (offset < 10) do
		for i=0, 9 do
			-- loop through each number 0 to 9 and see if it exists at the location x, y
			local pos = srFindImageInRange("glass" .. i .. ".png", x, y, numberImageWidth, numberImageHeight, tol);
			if pos then
				digit=i;
				break;
			end
		end
		if not digit then
			x = x+1;
			offset = offset + 1;
		end
	end
	if (offset > 0) then
		lsPrintln("Perf warning: OCR non-0 offset of " .. offset);
	end
	local ret = digit;
	while 1 do
		digit = nil;
		x = x + numberImageWidth + 1;
		for i=0, 9 do
			local pos = srFindImageInRange("glass" .. i .. ".png", x, y, numberImageWidth, numberImageHeight, tol);
			if pos then
				digit=i;
				break;
			end
		end
		if digit then
			ret = ret * 10 + digit;
		else
			break;
		end
	end
	return ret;
end

function addCC(window_pos, state)
	if state.just_added then
		return;
	end
	-- lsPrintln(window_pos[0] .. " " .. window_pos[1] .. " " .. window_w .. " " .. window_h);
	local pos = srFindImageInRange("GlassAdd2Charcoal.png", window_pos[0], window_pos[1], window_w, window_h, tol);
	
	state.just_added = 1;
	srClickMouseNoMove(pos[0]+5, pos[1]+2);
	state.status = state.status .. " Added 2 CC";
end

function glassTick(window_pos, state)
	state.status = "";
	local pos;
	local out_of_glass = nil;
	if state.want_spike then
		state.timer = state.timer - (tick_time / 1000);
	end
	
	pos = srFindImageInRange("GlassTimeToStop.png", window_pos[0], window_pos[1], window_w, window_h, tol);
	if pos then
		out_of_glass = 1;
	end
	pos = srFindImageInRange("GlassTemperature.png", window_pos[0], window_pos[1], window_w, window_h, tol);
	if not pos then
		state.status = state.status .. " No temperature found, ignoring";
		return state.status;
	end
	

	local temp = ocrNumber(pos[0] + temp_width, pos[1]);
	if temp == null then
		-- If we don't get a valid number at the end of the Temperature Label, then complain loudly
		error("Did not find a valid temperature at " .. pos[0] .. " (+" .. temp_width .. "), " .. pos[1]);
	end

	state.status = (state.status .. "  Temp:" .. temp);

	cooking = srFindImageInRange("GlassCooking.png", window_pos[0], window_pos[1], window_w, window_h, tol);
	
	if (stop_cooking or out_of_glass) and not cooking then
		return nil;
	end
	
	-- Monitor temperature
	local last_frame_just_added = state.just_added;
	if state.last_temp then
		local fell = temp < state.last_temp;
		local rose = temp > state.last_temp;
		if fell then
			state.status = state.status .. " (fell)";
			state.spiking = nil;
		end
		if rose then
			state.status = state.status .. " (rose)";
		end
		--  if just fell, and under max threshold, add 1 CC
		if fell and (temp < max_add_temp) then
			state.status = state.status .. " Fell,Adding";
			addCC(window_pos, state);
		end
			
		--  if just fell, and is under 1600+threshold, add one
		--    item, add another and wait for spike or fall
		if fell and (temp < min_new_temp) then
			-- addCC(window_pos, state); -- done above
			state.timer = 72;
			state.want_spike = 1;
			state.status = state.status .. " WaitingToSpike";
		end
		
		--if it's time to add for spike, add
		if state.want_spike and state.timer <= 0 then
			state.want_spike = nil;
			state.spiking = 1;
			state.timer = 0;
			addCC(window_pos, state);
		end
	end

	if state.want_spike then
		state.status = state.status .. " (wait to spike: " .. state.timer .. ")";
	end

	if state.spiking then
		state.status = state.status .. " (spiking)";
	end
	
	state.last_temp = temp;
	if last_frame_just_added then
		state.just_added = nil;
	end

	-- Monitor what we're making
	
	if not cooking then
		state.status = state.status .. " NothingCooking";
		if not stop_cooking then
			if temp > 1600 and temp < 2400 then
				local made_one=nil;
				for item_index=1, #item_priority do
					pos = srFindImageInRange(item_priority[item_index], window_pos[0], window_pos[1], window_w, window_h, tol);
					if pos then
						state.status = state.status .. " Making:" .. item_priority[item_index];
						srClickMouseNoMove(pos[0]+5, pos[1]+2);
						made_one = 1;
						break;
					end
				end
				if not made_one then
					state.status = state.status .. " NothingToMake";
					-- refresh window
					srClickMouseNoMove(window_pos[0]-10, window_pos[1]+window_h/2);
				end
			else
				state.status = state.status .. " (temp out of range)";
			end
		end
	else
		-- Something cooking, leave it be
		state.status = state.status .. " InUse";
	end
	
	state.last_nothing_cooking = not cooking;
	lsPrintln(state.status);
	return state.status; -- keep going and return status
end

function allowReorder(x, y)
	local z = 0
	local scale=0.7;
	local dy = 26;
	lsPrint(x, y, z, scale, scale, 0xFFFFFFff, "Click an item to raise priority");
	y=y+20;
	x=x+5;
	

	
	local item_index;
	for item_index=1, #item_priority do
		if lsButtonText(x, y, z, 100, 0xFFFFFFff, string.sub(string.sub(item_priority[item_index], 10), 1, -5)) then
			if item_index > 1 then
				local temp = item_priority[item_index-1];
				item_priority[item_index-1] = item_priority[item_index];
				item_priority[item_index] = temp;
			end	
		end
		-- debug code for checking image matching
		if false then
			local list = findAllImages(item_priority[item_index], tol);
			lsPrint(x+110, y, z, scale, scale, 0xFFFFFFff, #list);
		end
		y=y+dy;
	end
end

function testReorder()
	while 1 do
		lsSleep(100);
		allowReorder(10, 10);
		checkBreak();
		lsDoFrame();
	end
end

function doit()

	-- testReorder();
	
	askForWindow("To make glass, pin open Glazier's Bench then press Shift over the ATiTD window. Add charcoal (press the +2cc button for 5 temperature ticks, 6 for Jewel Glass), then wait for the glaziers to reach a temperature of 3200 (4400 for jewel). At this point, melt materials either manually or click M to show Melt Material windows, then smelt your materials (S=Soda, N=Normal, J=Jewel). Once you have melted the materials, the macro will take over.  Pause the macro when you need to use your mouse. If all lines don't say COOL DOWN on the macro before you add materials, you will need to pause the macro whilst any of the benches are between 1600 and 2400 otherwise you risk losing glass. Self Click, Options, Interface Options, Notifications: \"Use the chat area instead of popups\" MUST be CHECKED!");
	
	srReadScreen();
	
	local glass_windows = findAllImages("ThisIs.png");
	
	if #glass_windows == 0 then
		error 'Could not find any \'Glazier\'s Bench\' windows.';
	end
	
	local glass_state = {};
	for window_index=1, #glass_windows do
		glass_state[window_index] = {};
	end
	
	local last_ret = {};
	
	while 1 do
	
		-- Tick

		srReadScreen();
		
		local glass_windows2 = findAllImages("ThisIs.png");
		local should_continue=nil;
		if #glass_windows == #glass_windows2 then
			for window_index=1, #glass_windows do
				local r = glassTick(glass_windows[window_index], glass_state[window_index]);
				last_ret[window_index] = r;
				if r then
					should_continue = 1;
				end
			end
		end

		-- Display status and sleep

		local start_time = lsGetTimer();
		while tick_time - (lsGetTimer() - start_time) > 0 do
			time_left = tick_time - (lsGetTimer() - start_time);

			lsPrint(10, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
			lsPrint(10, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
			lsPrint(10, 30, 0, 0.7, 0.7, 0xFFFFFFff, "Waiting " .. time_left .. "ms...");
			
			if not (#glass_windows == #glass_windows2) then
				lsPrintWrapped(10, 45, 5, lsScreenX-15, 1, 1, 0xFF7070ff, "Expected " .. #glass_windows .. " windows, found " .. #glass_windows2 .. ", not ticking.");		
			elseif not should_continue then
				lsPrint(10, 45, 5, 1.5, 1.5, 0x70FF70ff, "All benches done.");
			end
			
			for window_index=1, #glass_windows do
				if last_ret[window_index] then
					should_continue = 1;
					lsPrint(10, 80 + 15*window_index, 0, 0.7, 0.7, 0xFFFFFFff, "#" .. window_index .. " - " .. last_ret[window_index]);
				else
					lsPrint(10, 80 + 15*window_index, 0, 0.7, 0.7, 0xFFFFFFff, "#" .. window_index .. " - COOL DOWN");
				end
			end
			
			-- New buttons to help add charcoal and melt materials
			if lsButtonText(lsScreenX - 90, lsScreenY - 115, z, 60, 0x00FFFFff, "+2cc") then
				menuButtonSelected = 1;
			end
			
			if lsButtonText(lsScreenX - 110, lsScreenY - 90, z, 22, 0xFFFF00ff, "M") then
				menuButtonSelected = 2;
			end

			if lsButtonText(lsScreenX - 85, lsScreenY - 90, z, 25, 0xFF00FFff, "S") then
				menuButtonSelected = 3;
			end

			if lsButtonText(lsScreenX - 60, lsScreenY - 90, z, 25, 0xFF00FFff, "N") then
				menuButtonSelected = 4;
			end

			if lsButtonText(lsScreenX - 35, lsScreenY - 90, z, 25, 0xFF00FFff, "J") then
				menuButtonSelected = 5;
			end

			
			

			if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Finish up") then
				stop_cooking = 1;
			end
			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			
			allowReorder(10, 100+15*#glass_windows);
			
			checkBreak();
			checkButtons();
			lsDoFrame();
			lsSleep(25);
		end
		
		checkBreak();
		-- error 'done';
	end

end

function checkButtons()
	if (menuButtonSelected == 1) then
		-- User has clicked the +2 cc button, so click all Add 2 Charcoal buttons on the screen
		clickAllText("Add 2 Charcoal");
	end
	
	if (menuButtonSelected == 2) then
		-- User has clicked the M button, so click all Melt Materials buttons
		clickAllText("Melt Materials...");
	end
	
	if (menuButtonSelected == 3) then
		-- User has clicked the S button, so click all Into Soda Glass buttons on the screen
		clickAllText("Into Soda Glass");
	end
	
	if (menuButtonSelected == 4) then
		-- User has clicked the N button, so click all Into Normal Glass buttons on the screen
		clickAllText("Into Normal Glass");
	end
	
	if (menuButtonSelected == 5) then
		-- User has clicked the J button, so click all Into Jewel Glass buttons on the screen
		clickAllText("Into Jewel Glass");
	end
	
	menuButtonSelected= 0;
end

function clickAllText(textToFind)
	local allTextReferences = findAllText(textToFind);
	
	for buttons=1, #allTextReferences do
		srClickMouseNoMove(allTextReferences[buttons][0]+20, allTextReferences[buttons][1]+5);
	end
end
