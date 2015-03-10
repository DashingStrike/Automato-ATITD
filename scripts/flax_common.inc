
-- Also using these for other planting automation

xyWindowSize = srGetWindowSize();
imgFlax1 = "FlaxGeneric.png";
imgHarvest = "HarvestThisFlax.png";
imgWeedAndWater = "WeedAndWater.png";
imgWeed = "WeedThisFlaxBed.png";
imgSeeds = "HarvestSeeds.png";
imgHarvestThese = "HarvestThese.png";
imgWeedThese = "WeedThese.png";






walk_px_y = 340;
walk_px_x = 380;
walk_y_drift = 18;
walk_x_drift = 14;
walk_time = 570;

refocus_time = 150; -- Time to Wait for last window to bring to the foreground before clicking again
refocus_click_time = 150; --How fast it 'shuffles' the pin up windows
screen_refresh_time = 150; --How often it refreshes (clicks) the current pinup for change (ie Weed, Water, Rip plant options)




delay_time = 100; --This value doesn't seem to be used anywhere. It is commented in every flax and onion script. Is it hardcoded in veggietales.exe? hmm... ^_^




function initGlobals()
	pixel_scale = xyWindowSize[0] / 1720; -- Macro written with 1720 pixel wide window
	lsPrintln("pixel_scale " .. pixel_scale);

	walk_px_y = math.floor(walk_px_y * pixel_scale);
	walk_px_x = math.floor(walk_px_x * pixel_scale);
	if (lsScreenX < 1280) then
		-- Have to click way off center in order to not move at high resoltuions
		walk_y_drift = math.floor(walk_y_drift * pixel_scale);
		walk_x_drift = math.floor(walk_x_drift * pixel_scale);
	else
		-- Very little drift at these resolutions, clicking dead center barely moves
		walk_y_drift = 1;
		walk_x_drift = 1;
	end
end

-- The flax bed window
-- T4, guilded?: window_w = 166;
-- T4, guilded?: window_h = 116;
window_w = 174;
window_h = 100;
refresh_down_y_offs = 4;
refresh_up_y_offs = 0;

-- adjust if "plant all guild owned" option is enabled
window_check_done_once = false;
function checkWindowSize(x, y)
	if not window_check_done_once then
		srReadScreen();
		window_check_done_once = true;
		local pos = srFindImageInRange("UseableBy.png", x-5, y-50, 150, 100)
		if pos then
			window_w = 166;
			window_h = 116;
		end
	end
end

-- position to drag window to
function pinnedPos(x, y)
	local ret = {};
	ret[0] = xyWindowSize[0] - 25*(x-1) - (window_w - 5);
	ret[1] = (y-1)*14 + (window_h/2) + 2;
	lsPrintln("pinnedPos(" .. x .. "," .. y .. ")=" .. ret[0] .. "," .. ret[1]);
	return ret;
end

function refreshPosUp(x, y)
	local ret = pinnedPos(x, y);
	ret[0] = ret[0] + (window_w - 15);
	ret[1] = ret[1] - (window_h/2 - 4); -- - (window_h - 66) + refresh_up_y_offs; -- 50 for flax;
	lsPrintln("refreshPosUp(" .. x .. "," .. y .. ")=" .. ret[0] .. "," .. ret[1]);
	return ret;
end

function refreshPosDown(x, y)
	local ret = pinnedPos(x, y);
	ret[0] = ret[0] - 2;
	ret[1] = ret[1] + (window_h / 2) - refresh_down_y_offs;
	lsPrintln("refreshPosDown(" .. x .. "," .. y .. ")=" .. ret[0] .. "," .. ret[1]);
	return ret;
end

function getCenterPos()
	local ret = {};
	ret[0] = xyWindowSize[0] / 2 - walk_x_drift;
	ret[1] = xyWindowSize[1] / 2 + walk_y_drift;
	return ret;
end

function setWaitSpot(x0, y0)
	setWaitSpot_x = x0;
	setWaitSpot_y = y0;
	setWaitSpot_px = srReadPixel(x0, y0);
end

function waitForChange(timeout)
	if not timeout then
		timeout = 10000000;
	end
	local c=0;
	local timestart = lsGetTimer();
	while srReadPixel(setWaitSpot_x, setWaitSpot_y) == setWaitSpot_px do
		lsSleep(1);
		c = c+1;
		if (lsShiftHeld() and lsControlHeld()) then
			error 'broke out of loop from Shift+Ctrl';
		end
		if lsGetTimer() > timestart + timeout then
			lsPrintln('Timed out waiting.');
		end
	end
	lsPrintln('Waited ' .. c .. 'ms for pixel to change.');
end

function drag(x0, y0, x1, y1)
	srSetMousePos(x0, y0);
	setWaitSpot(x1, y1);
	srMouseDown(x0, y0, 0);
	-- lsSleep(15);
	srSetMousePos(x1, y1);
	-- lsSleep(50);
	waitForChange();
	srMouseUp(x0, y0, 0);
	-- lsSleep(50);
end

function promptFlaxNumbers(is_plant)
	scale = 1.0;
	
	local z = 0;
	local is_done = nil;
	local value = nil;
	-- Edit box and text display
	while not is_done do
		-- Put these everywhere to make sure we don't lock up with no easy way to escape!
		checkBreak("disallow pause");
		
		lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, "Choose passes and grid size");
		
		-- lsEditBox needs a key to uniquely name this edit box
		--   let's just use the prompt!
		-- lsEditBox returns two different things (a state and a value)
		local y = 40;
		if is_plant or rip_out_when_done then
			lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Passes:");
			is_done, num_loops = lsEditBox("passes",
				110, y, z, 50, 30, scale, scale,
				0x000000ff, 5);
			if not tonumber(num_loops) then
				is_done = nil;
				lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
				num_loops = 1;
			end
		else
			lsPrint(5, y, z, scale, scale, 0x808080ff, "Passes: 1");
			num_loops = 1;
		end
		y = y + 32;

		lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Grid size:");
		is_done, grid_w = lsEditBox("grid",
			110, y, z, 50, 30, scale, scale,
			0x000000ff, grid_w);
		if not tonumber(grid_w) then
			is_done = nil;
			lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
			grid_w = 1;
			grid_h = 1;
		end
		grid_w = tonumber(grid_w);
		grid_h = grid_w;
		y = y + 32;

		if not is_plant then
			lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Seeds per:");
			is_done, seeds_per_pass = lsEditBox("seedsper",
				110, y, z, 50, 30, scale, scale,
				0x000000ff, 4);
			if not tonumber(seeds_per_pass) then
				is_done = nil;
				lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
				seeds_per_pass = 1;
			end
			y = y + 32;
		end

		fast_refocus = lsCheckBox(10, y, z+10, 0xFFFFFFff, "Fast refocus", fast_refocus);
		y = y + 32;

		if lsButtonText(170, y-32, z, 100, 0xFFFFFFff, "OK") then
			is_done = 1;
		end

		if is_plant then
			lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, "This will plant and harvest a " .. grid_w .. "x" .. grid_w .. " grid of Flax " .. num_loops .. " times, requiring " .. (grid_w * grid_w * num_loops) .. " seeds, doing " .. (grid_w*grid_w*num_loops) .. " flax harvests.");
		else
			rip_out_when_done = lsCheckBox(10, y, z+10, 0xFFFFFFff, "Rip out when done", rip_out_when_done);
			y = y + 25;
			lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, "This will plant a " .. grid_w .. "x" .. grid_w .. " grid of Flax and harvest it " .. seeds_per_pass .. " times, requiring " .. (grid_w * grid_w * num_loops) .. " seeds, and repeat this " .. num_loops .. " times, yielding " .. (grid_w * grid_w * num_loops * seeds_per_pass) .. " seeds.");
		end

		if fast_refocus then
			lsPrintWrapped(10, y+80, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, "Fast Refocus uses the original refocusing method which may work more reliably on computers with very stuttery framerates.  Otherwise, a simpler refocusing method is used which is reported to work better on most systems.");
		end

		if is_done and (not num_loops or not grid_w) then
			error 'Canceled';
		end
		
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
	
		
		lsDoFrame();
		lsSleep(10); -- Sleep just so we don't eat up all the CPU for no reason
	end
end

function refocusWindows()
	if fast_refocus then
		local first = true;
		for y=grid_h, 1, -1 do
			local first_on_line = true;
			for x=grid_w, 1, -1 do 
				if not first then
					local rp = refreshPosUp(x, y);
					if first_on_line then
						local waitpos = refreshPosUp(x, y);
						setWaitSpot(waitpos[0]+6, waitpos[1]+20);
						--srSetMousePos(waitpos[0]+6, waitpos[1]+20);
					else
						local waitpos = pinnedPos(x, y);
						setWaitSpot(waitpos[0]-4, waitpos[1]);
					end
					srClickMouseNoMove(rp[0], rp[1], 0);
					waitForChange();
				end
				first = false;
				first_on_line = false;
			end
		end
	else
		for y=grid_h, 1, -1 do
			for x=grid_w, 1, -1 do 
				local rp = refreshPosUp(x, y);
				srClickMouseNoMove(rp[0], rp[1], 0);
				lsSleep(refocus_click_time);
			end
		end
	end
	lsSleep(refocus_time); -- Wait for last window to bring to the foreground before clicking again
end
