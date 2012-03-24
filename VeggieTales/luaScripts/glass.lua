loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

window_w = 285;
window_h = 415;
temp_width = 75;
tol = 6500;

-- It will make the first in the list if available, otherwise the next, etc
-- This will let you make, e.g. Rods on your Soda Glass and Sheet Glass on your normal, by putting
--   sheet glass before rods (on soda it'll fail to find sheet)
item_priority = {"GlassMakeJar.png", "GlassMakeRod.png", "GlassMakePipe.png", "GlassMakeSheet.png", "GlassMakeWine.png", "GlassMakeBlade.png", "GlassMakeFineRod.png", "GlassMakeFinePipe.png"};

-- max temperature in which we will contine heating it, wait until it gets below this before adding
max_add_temp = 2300;
-- minimum temperature in which we will start a new project, otherwise will reheat
min_new_temp = 1750;

tick_time = 3000;

function ocrNumber(x, y)
	-- find first number
	local digit=nil;
	local offset=0;
	while (not digit) and (offset < 10) do
		for i=0, 9 do
			local pos = srFindImageInRange(i .. ".png", x, y, 6, 9, tol);
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
		x = x + 7;
		for i=0, 9 do
			local pos = srFindImageInRange(i .. ".png", x, y, 6, 9, tol);
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
	

	state.status = (state.status .. "  Temp:" .. temp);

	nothing_cooking = srFindImageInRange("GlassNothingCooking.png", window_pos[0]-5, window_pos[1], window_w, window_h, tol);

	if (stop_cooking or out_of_glass) and nothing_cooking then
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
	
	if nothing_cooking then
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
					srClickMouseNoMove(window_pos[0], window_pos[1]);
				end
			else
				state.status = state.status .. " (temp out of range)";
			end
		end
	else
		-- Something cooking, leave it be
		state.status = state.status .. " InUse";
	end
	
	state.last_nothing_cooking = nothing_cooking;
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
	
	askForWindow("Pin your benches, put the cursor over the ATITD window, press Shift.  Then add charcoal until the benches are hot enough, melt your materials, an as it cools back down into useable temperature ranges, the macro will take over.  Please pause the macro when you need to use your mouse.");
	
	srReadScreen();
	
	local glass_windows = findAllImages("ThisIs.png");
	
	if #glass_windows == 0 then
		error 'Did not find any open windows';
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
			if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Finish up") then
				stop_cooking = 1;
			end
			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			
			allowReorder(10, 100+15*#glass_windows);
			
			checkBreak();
			lsDoFrame();
			lsSleep(25);
		end
		
		checkBreak();
		-- error 'done';
	end
end