-- Major Revision Feb 5, 2012


imgOnionBed = "ThisIsAnOnionBed.png";
imgOnionSeeds = "OnionSeeds.png";
imgWaterThese = "WaterThese.png";
imgHarvestThese = "HarvestThese.png";
imgWaterJugs = "IconWaterJugs.png";

loadfile("luaScripts/flax_common.inc")();
loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

walk_px_x = 112;
walk_px_y = 112;
walk_time = 250;
--screen_refresh_time = 300; -- screen_refresh is also defined in flax_common.inc. The default of 150 seems to work well as a safe approach. Commented out this override.
water_time = 1200;
harvest_time = 1100;
fill_water_time = 4000;
pass_growth_time = 24000;

-- the onion window
window_w = 191;
window_h = 84;
refresh_down_y_offs = 0;

search_size = 15;
search_size2 = 10;
search_dx = {0, -search_size, search_size, -search_size, search_size, -search_size, search_size, 0, 0, -search_size2, search_size2, -search_size2, search_size2, -search_size2, search_size2, 0, 0};
search_dy = {0, -search_size, search_size, search_size, -search_size, 0, 0, -search_size, search_size, -search_size2, search_size2, search_size2, -search_size2, 0, 0, -search_size2, search_size2};


function fillWater(required)
    --if water_needed then
	if (aqueduct_mode) then
		aque = srFindImage("Aqueduct.png", 5000);
		if not aque then
			error 'Could not find aqueduct window.';
		end
		srClickMouseNoMove(aque[0], aque[1]);
		lsSleep(150);
		srReadScreen();
		fill = srFindImage("FillWithWater.png", 5000);
		if ((not fill) and required) then
			error 'Could not find Fill With Water on acqueduct menu';
		end
		if fill then
			srClickMouseNoMove(fill[0]+5, fill[1]);
		end
	else
		srReadScreen();
		xyFillWater = srFindImage(imgWaterJugs);
		if not xyFillWater then
			error 'Moved too far for fill jugs with water icon.';
		else
			-- Use it
			srClickMouseNoMove(xyFillWater[0], xyFillWater[1]);
			lsSleep(screen_refresh_time);
			srClickMouseNoMove(xyCenter[0] + 10, xyCenter[1] + 20);
			lsSleep(fill_water_time);
		end;
	end
    --end;
    num_waters = 0;
end

function storeonions()
	-- store all the onions in a Sheep pen if available
	fillit = srFindImage("Fillthefeed.png");
	if fillit then
		srClickMouseNoMove(fillit[0]+10, fillit[1]+4);
		lsSleep(screen_refresh_time);
		srClickMouseNoMove(xyCenter[0] + 10, xyCenter[1] + 20);
		lsSleep(screen_refresh_time);
	end;
end

function doit()
	num_jugs = promptNumber("How many jugs?", 64);
	grid_w = promptNumber("How many plants across?", 4);
	grid_h = promptNumber("How many rows of plants?", 4);
	num_loops = promptNumber("How many " .. grid_w .. "x" .. grid_h .. " passes?", 5);

	askForWindow("Make sure the plant Onions window is pinned and you are in F8F8 cam zoomed in.  Will plant SE of this location.\n \n'Plant all crops where you stand' must be ON.  'Right click pins/unpins a menu' must be ON.  'Right click opens Menu as Pinned' must be OFF.\n \nYour " .. grid_w .. "x" .. grid_h .. " grid will work best with a minimum of " .. grid_w * grid_h * 4 .. " jugs. Using less will cause it to gather water during a critical time, while watering onions. " .. grid_w * grid_h * 4 * num_loops .. " water jugs will allow you to do " .. num_loops .. " passes away from a water source.");
	



	initGlobals();
	num_waters = 0;
	water_needed = 1;
	
	if num_jugs >= (grid_w*grid_h*4*num_loops) then
		water_needed = false;
	end;

	if (grid_w*grid_h) > 9 then
		refocus_click_time = 125; -- run faster if many plants   
		screen_refresh_time = 100;
	end
	if (grid_w*grid_h) > 16 then
		refocus_click_time = 75; -- run faster if many plants
	end


	srReadScreen();
	xyCenter = getCenterPos();
	
	-- Find plant onions window
	local xyPlantOnions = srFindImage(imgOnionSeeds);
	if not xyPlantOnions then
		error 'Could not find plant window';
	end
	xyPlantOnions[0] = xyPlantOnions[0] + 5;




	-- Find aqudeuct or fill water button
	-- If we can fill jugs, then do it. But if they are all full, then dont give an error if water_needed is false.





	aque = srFindImage("Aqueduct.png", 5000);
	if not aque then
		aqueduct_mode = nil;
		xyFillWater = srFindImage(imgWaterJugs);

		if not xyFillWater and water_needed then
			error 'Could not find Aqueduct window OR fill jugs with water icon, you may need to empty 1 jug.';
		elseif xyFillWater then
			-- Use it
			fillWater(nil);
		end;
	else
		aqueduct_mode = 1;

			if xyFillWater then
			fillWater(nil);
			end

	end






	for loop_count=1, num_loops do


		checkBreak();

		-- If we have enough jugs to do an entire pass to harvest, and
		-- we don't have enough filled jugs to do so then
		-- refill before planting to minimize time used during the cycle.
		if (((num_jugs - num_waters) < (grid_w*grid_h*4)) and
			(num_jugs >= (grid_w*grid_h*4)) and 
			(num_waters > 1)) then
				fillWater(1);
		end;	




		-- Plant and pin
		for y=1, grid_h do
			for x=1, grid_w do

				lsPrintln('doing ' .. x .. ',' .. y);
	
				statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Planting " .. x .. ", " .. y);
	


	-- Reverify plant window and the 'Onion Seeds' is still showing. Else you probably drifted off the sand or ran out of seeds.

	local xyPlantOnions = srFindImage(imgOnionSeeds);
	if not xyPlantOnions then
		error 'Could not find plant window. You probably ran out of seeds or drifted off of the sand.';
	end


				-- Plant

				srClickMouseNoMove(xyPlantOnions[0], xyPlantOnions[1], 0);
				-- lsSleep(delay_time);
				
				-- Move to new location
				if x == grid_w then
					walk_dy = walk_px_y;
					walk_dx = 0;
				else
					walk_dy = 0;
					if y % 2 == 1 then
						walk_dx = walk_px_x;
					else
						walk_dx = -walk_px_x;
					end
				end
				lsPrintln("Moving cntr:" .. xyCenter[0] .. " " .. xyCenter[1] .. " d=" .. walk_dx .. " " .. walk_dy);
				srClickMouseNoMove(xyCenter[0] + walk_dx, xyCenter[1] + walk_dy);
				lsSleep(walk_time);
				
				-- Search for menu
				xyImagePos = nil;
			
				search_idx = 1;
				while not xyImagePos and search_idx <= #search_dx do
					click_x = xyCenter[0] - walk_dx + math.floor(search_dx[search_idx] * pixel_scale);
					click_y = xyCenter[1] - walk_dy + math.floor(search_dy[search_idx] * pixel_scale);
					lsPrintln(' clicking ' .. click_x .. ',' .. click_y);
					srClickMouse(click_x, click_y, 1); -- Right click!
					lsSleep(screen_refresh_time);
					checkBreak();
					srReadScreen();
					xyImagePos = srFindImageInRange(imgOnionBed, click_x - walk_px_x*2, click_y - 42 - walk_px_y*2, window_w+walk_px_x*4, window_h+walk_px_y*4);
					if xyImagePos then
						-- found it
						click_x = xyImagePos[0] - 6;
						click_y = xyImagePos[1] + 25;
					else
						-- No menu came up, try elsewhere?
						search_idx = search_idx+1;
					end
				end
				
				if not xyImagePos then
					error ' Failed to bring up onion bed window';
				end
				
				-- Pin
				srClickMouseNoMove(click_x+5, click_y, 1);
				lsSleep(screen_refresh_time);
				
				-- Move window
				local pp = pinnedPos(x, y);
				drag(click_x, click_y, pp[0], pp[1], 0);
				-- lsSleep(delay_time);
				
				checkBreak();
			end
		end
		
		srSetMousePos(200, 200);

		statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Refocusing windows...");
		
		-- Bring windows to front
		for y=grid_h, 1, -1 do
			for x=grid_w, 1, -1 do 
				local rp = refreshPosUp(x, y);
				srClickMouseNoMove(rp[0], rp[1], 0);
				lsSleep(refocus_click_time);
			end
		end
		lsSleep(refocus_click_time); -- Wait for last window to bring to the foreground before clicking again

		-- Water everything and then harvestable
		do_harvest = nil;
		water_pass_count=0;
		passes_before_harvest = 4;
		while 1 do
			water_pass_count = water_pass_count+1;
			start_time = lsGetTimer();
			for y=1, grid_h do
				for x=1, grid_w do 
					if do_harvest then
						statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Harvesting " .. x .. ", " .. y);
					else
						statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Watering " .. x .. ", " .. y .. " water pass " .. water_pass_count);
					end
					local pp = pinnedPos(x, y);
					local rp = refreshPosDown(x, y);
					while 1 do
						srClickMouseNoMove(rp[0], rp[1], 0);
						lsSleep(screen_refresh_time);
						srReadScreen();
						if not do_harvest then
							local water = srFindImageInRange(imgWaterThese, pp[0], pp[1] - 25, window_w, window_h);
							if water then
								srClickMouseNoMove(water[0] + 5, water[1], 0);
								lsSleep(water_time);
								num_waters = num_waters + 1;
								if num_waters > num_jugs then
									fillWater(1);
								end
								break;
							end
						end
						local harvest = srFindImageInRange(imgHarvestThese, pp[0], pp[1] - 25, window_w, window_h);
						if harvest then
							if do_harvest then
								-- do the harvest
								srClickMouseNoMove(harvest[0] + 5, harvest[1], 0);
								-- dismiss window
								srClickMouseNoMove(rp[0], rp[1], 1);
								lsSleep(harvest_time);
							end
							-- lsPrintln('Ready for harvest, come back later!');
							break;
						end
						lsSleep(10);
						checkBreak();
						-- try again anyway!  error ' Expected Onion window to have either harvest or water!';
					end
				end
			end
			
			if do_harvest then
				break;
			end

			-- Bring windows to front
			for y=grid_h, 1, -1 do
				for x=grid_w, 1, -1 do 
					local rp = refreshPosUp(x, y);
					srClickMouseNoMove(rp[0], rp[1], 0);
					lsSleep(refocus_click_time);
				end
			end
			lsSleep(refocus_click_time); -- Wait for last window to bring to the foreground before clicking again


		
			if water_pass_count == passes_before_harvest then
				do_harvest = 1;
			else
				-- Otherwise, wait until 24 seconds has elapsed, and water again
				local time_left = pass_growth_time - (lsGetTimer() - start_time);
				statusScreen("Waiting " .. time_left .. "ms before starting next pass...");
				if (time_left > fill_water_time) and (num_waters > 0) and (water_needed) then
					fillWater(1);
				end
				while pass_growth_time - (lsGetTimer() - start_time) > 0 do
					time_left = pass_growth_time - (lsGetTimer() - start_time);
					statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Waiting " .. time_left .. "ms before starting next water pass...");
					lsSleep(100);
					checkBreak();
				end
			end
		end

	  --Click the plant window, to refresh seeds, in case you used your last seed. Prevents fails (can't find onion seed) on 2nd or higher passes.
	  srClickMouseNoMove(xyPlantOnions[0], xyPlantOnions[1]+15, 0);
		
		lsSleep(2000); -- wait for harvested plants to disappear
		if (grid_w*grid_h) > 15 then
			lsSleep(1000); -- If many harvests it can take longer to get to the last one
		end



		-- Move back a bit
		if grid_h == 1 then
			srClickMouseNoMove(xyCenter[0] - math.floor(walk_px_x*(grid_w - 1.5)), xyCenter[1]);
		elseif grid_w == 1 then
			srClickMouseNoMove(xyCenter[0], xyCenter[1] - math.floor(walk_px_y*(grid_h - 1.5)));
		else
			if grid_h % 2 == 1 then
				-- odd number of rows, ends up near bottom right, so move left and up
				srClickMouseNoMove(xyCenter[0] - math.floor(walk_px_x*(grid_w - 1.5)), xyCenter[1] - math.floor(walk_px_y*(grid_h - 1.5)));
			else
				-- even number of rows, ends up near bottom left, so move mostly up
				srClickMouseNoMove(xyCenter[0] - math.floor(walk_px_x*1)  , xyCenter[1] - math.floor(walk_px_y*(grid_h - 1.5)));
			end
		end
		lsSleep(2000); -- wait to move back

		storeonions();
	end
	
	lsPlaySound("Complete.wav");
end
