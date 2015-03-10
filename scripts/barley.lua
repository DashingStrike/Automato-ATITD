
-- Edit these first 2 to adjust how much is planted in a pass
-- May need to adjust walk_time in Barley_common.inc if you move too slowly to keep up
-- grids tested: 2x2, 3x3, 5x5, 6x6 (probably need 3+ dex and 600ms walk time)
grid_w = 5;
grid_h = 5;
watered = {};
loop_count = 0;
skip_water = 0;

dofile("Flax_common.inc");
dofile("screen_reader_common.inc");
dofile("ui_utils.inc");


function promptBarleyNumbers(is_plant)
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
		lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Passes:");
		is_done, num_loops = lsEditBox("passes",
			100, y, z, 50, 30, scale, scale,
			0x000000ff, 1);
		if not tonumber(num_loops) then
			is_done = nil;
			lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
			num_loops = 1;
		end
		y = y + 32;

		lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Grid size:");
		is_done, grid_w = lsEditBox("grid",
			100, y, z, 50, 30, scale, scale,
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

		if lsButtonText(170, y-32, z, 100, 0xFFFFFFff, "OK") then
			is_done = 1;
		end

		if is_plant then
			lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, "This will plant and harvest a " .. grid_w .. "x" .. grid_w .. " grid of Barley " .. num_loops .. " times, requiring " .. (grid_w * grid_w) .. " raw barley and ".. (grid_w * grid_w * num_loops * 4) .. "water in jugs, doing " .. (grid_w*grid_w*num_loops) .. " harvests.");
		else
			lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, "This will plant a " .. grid_w .. "x" .. grid_w .. " grid of Flax " .. num_loops .. " times, requiring " .. (grid_w * grid_w) .. " seeds, yielding " .. (grid_w * grid_w * num_loops) .. " seeds.");
		end
		y = y + 50;
		skip_water = lsCheckBox(10, y, z, 0xFFFFFFff, "Skip Rain Barrel", skip_water);

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


function doit()

  promptBarleyNumbers(1);
  askForWindow("Make sure the plant barley window is pinned and you are in F8F8 cam zoomed in.  You may need to F12 at low resolutions or hide your chat window (if it starts planting and fails to move downward, it probably clicked on your chat window).  Will plant grid NE of current location.  'Plant all crops where you stand' must be ON.  'Right click pins/unpins a menu' must be ON.");
  lsSleep(1000);
  delay_time = 2000;
  local x = 1;
  local y = 1;
  initGlobals();
  -- Find the plant barley button
  srReadScreen();

  local imgBarley = "barley.png";
  local xyPlantBarley = srFindImage(imgBarley);
  if not xyPlantBarley then
    error 'Could not find plant window';
  end
  xyPlantBarley[0] = xyPlantBarley[0] + 5;
  
  -- Find the Rain Barrel
  if not skip_water then
	local imgDrawWater = "draw_water.png";
	local xyDrawWater = srFindImage(imgDrawWater);
	if not xyDrawWater then
		error 'Could not find rain barrel';
	end 
	xyDrawWater[0] = xyDrawWater[0] + 5;
  end

 

  for loop_count=1, num_loops do
    local start_time = lsGetTimer();
    harvested = 0;
    -- Init watered array to 0
    for y=grid_h, 1, -1 do
      for x=grid_w, 1, -1 do 
        watered[x+((y-1)*grid_w)] = 1;
      end
    end	
	  -- Local variables
    local xyCenter = getCenterPos();
    local xyBarleyMenu = {};
    xyBarleyMenu[0] = xyCenter[0] - 43;
    xyBarleyMenu[1] = xyCenter[1] + 0;
    local dxi=1;
    local dt_max=grid_w;
    local dt=grid_w;
    local dx={1, 0, -1, 0};
    local dy={0, -1, 0, 1};
    local num_at_this_length = 3;
    local x_pos = 0;
    local y_pos = 0;
    for y=1, grid_h do
      for x=1, grid_w do
        lsPrintln('doing ' .. x .. ',' .. y .. ' of ' .. grid_w .. ',' .. grid_h);
        statusScreen("Planting " .. x .. ", " .. y);
        
        -- Plant
        lsPrintln('planting ' .. xyPlantBarley[0] .. ',' .. xyPlantBarley[1]);
        setWaitSpot(xyBarleyMenu[0], xyBarleyMenu[1]);
        srClickMouseNoMove(xyPlantBarley[0], xyPlantBarley[1], 0);
        srSetMousePos(xyBarleyMenu[0], xyBarleyMenu[1]);
        waitForChange();
        
        -- Bring up menu
        lsPrintln('menu ' .. xyBarleyMenu[0] .. ',' .. xyBarleyMenu[1]);
        setWaitSpot(xyBarleyMenu[0]+5, xyBarleyMenu[1]);
        srClickMouse(xyBarleyMenu[0], xyBarleyMenu[1], 0);
        waitForChange();

        -- Check for window size
        window_w = 214;
        window_h = 218;

        -- Pin
        lsPrintln('pin ' .. (xyBarleyMenu[0]+5) .. ',' .. xyBarleyMenu[1]);
        srClickMouseNoMove(xyBarleyMenu[0]+5, xyBarleyMenu[1]+0, 1);

        -- Move window
        local pp = pinnedPos(x, y);
        lsPrintln('move ' .. (xyBarleyMenu[0]+5) .. ',' .. xyBarleyMenu[1] .. ' to ' .. pp[0] .. ',' .. pp[1]);
        drag(xyBarleyMenu[0] + 5, xyBarleyMenu[1], pp[0], pp[1], 0);
		
        -- Add 2 water now
        srReadScreen();
        local barleyAddButton = srFindImageInRange("BarleyAdd.png", pp[0], pp[1], 200, 100);
        local barleyWater = srFindImageInRange("barleyWater.png", pp[0], pp[1] - 50, 220, 150);
        if not barleyAddButton or not barleyWater then
          -- bugfix maybe for lag.
          lsSleep(100);
          srReadScreen();
          barleyAddButton = srFindImageInRange("BarleyAdd.png", pp[0], pp[1], 200, 100);
          barleyWater = srFindImageInRange("barleyWater.png", pp[0], pp[1] - 50, 220, 150);
        end

        srClickMouseNoMove(barleyAddButton[0]+8, barleyWater[1]);
        srClickMouseNoMove(barleyAddButton[0]+8, barleyWater[1]);
        watered[x+((y-1)*grid_w)] = watered[x+((y-1)*grid_w)] + 2;

        -- move to next position
        if not ((x == grid_w) and (y == grid_h)) then
          lsPrintln('walking dx=' .. dx[dxi] .. ' dy=' .. dy[dxi]);
          x_pos = x_pos + dx[dxi];
          y_pos = y_pos + dy[dxi];
          srClickMouseNoMove(xyCenter[0] + walk_px_x*dx[dxi], xyCenter[1] + walk_px_y*dy[dxi], 0);
          lsSleep(walk_time);
          dt = dt - 1;
          if dt == 1 then
            dxi = dxi + 1;
            num_at_this_length = num_at_this_length - 1;
            if num_at_this_length == 0 then
              dt_max = dt_max - 1;
              num_at_this_length = 2;
            end
            if dxi == 5 then
              dxi = 1;
            end
            dt = dt_max;
          else
            lsPrintln('skipping walking, on last leg');
          end
        end
        checkBreak();
      end
    end
  
    statusScreen("Refocusing windows...");
    -- Bring windows to front
    for y=grid_h, 1, -1 do
      for x=grid_w, 1, -1 do 
        local rp = refreshPosUp(x, y);
        srClickMouseNoMove(rp[0], rp[1], 0);
        lsSleep(refocus_click_time);
      end
    end
    lsSleep(refocus_time); -- Wait for last window to bring to the foreground before clicking again
  
    -- Barley has been planted, pinned and refocused	
 
    while 1 do
      for y=1, grid_h do
        for x=1, grid_w do 
          local pp = pinnedPos(x, y);
          local rp = refreshPosDown(x, y);
          srClickMouse(rp[0],rp[1]);
          lsSleep(200);
          srReadScreen();
          local leftBar = srFindImageInRange("barleyBarLeft.png", pp[0], pp[1] - 50, 120, 100);
          if leftBar then
            leftBar[0] = leftBar[0] + 4;
          end
          local rightBar = srFindImageInRange("barleyBarRight.png", pp[0], pp[1] - 50, 220, 200);
          if rightBar then
            rightBar[0] = rightBar[0] + 1;
          end
          if not rightBar then
            error 'Could not find rightbar';
          end
          local barleyWater = srFindImageInRange("barleyWater.png", pp[0], pp[1] - 50, 220, 150);
          if not barleyWater then error 'Could not find water button.'; end
          local barleyAddButton = srFindImageInRange("BarleyAdd.png", pp[0], pp[1], 200, 100);
          if not barleyAddButton then error 'Could not find add button. Ended at batch '; end

          while 1 do
            if leftBar then
              waterBlue = 0;
              if rightBar then
                if barleyWater then
                  srReadScreen();
                  for i=leftBar[0],rightBar[0] do
                    pxval = srReadPixelFromBuffer(i, barleyWater[1]);
                    b = (math.floor(pxval/256) % 256);
                    if b > 220 then
                      waterBlue = waterBlue + 1;
                    end
                  end
                  waterBlue = (waterBlue/(rightBar[0]-leftBar[0])*100);
                end
              end
            end
            checkBreak();
			
            if watered[x+((y-1)*grid_w)] < 5 then
              statusScreen("Watering " .. x .. "," .. y .. "step " .. watered[x+((y-1)*grid_w)] .. ".");
              if waterBlue < 90 then
                if watered[x+((y-1)*grid_w)] == 0 then
                end
                srClickMouseNoMove(barleyAddButton[0]+8, barleyWater[1]);
                watered[x+((y-1)*grid_w)] = watered[x+((y-1)*grid_w)] + 1;
                lsSleep(100);
                break;
              end
            else
              statusScreen("Harvesting " .. x .. "," .. y .. ".");
              if waterBlue < 90 then
                srClickMouseNoMove(pp[0]+90, pp[1]+90);
                lsSleep(100);
                srClickMouseNoMove(pp[0]+180, pp[1]-25);
                if watered[x+((y-1)*grid_w)] == 5 then
                  harvested = 1;
                end
                break;
              end
            end
          end
        end
      end

      if harvested == 0 then
        statusScreen("Refocusing windows...");
        -- Bring windows to front
        for y=grid_h, 1, -1 do
          for x=grid_w, 1, -1 do 
            local rp = refreshPosUp(x, y);
            srClickMouseNoMove(rp[0], rp[1], 0);
            lsSleep(refocus_click_time);
          end
        end
        lsSleep(refocus_time); -- Wait for last window to bring to the foreground before clicking again
      else
        for x=1, x_pos do
          srClickMouseNoMove(xyCenter[0] + walk_px_x*-1, xyCenter[1], 0);
          lsSleep(walk_time);
        end
        for x=1, -y_pos do
          srClickMouseNoMove(xyCenter[0], xyCenter[1] + walk_px_y, 0);
          lsSleep(walk_time);
        end
        break;
      end
    end
    local end_time = lsGetTimer();
    statusScreen("Time taken: " .. (end_time-start_time)/1000);
    -- move X and Y every 4 batches, but skip the Y move every 20th batch
    if loop_count % 4 == 0 and loop_count % 5 == 0 then
      doCorrectiveMove('x')
    elseif loop_count % 4 == 0 then
      doCorrectiveMove('xy')
    end 
    --doStashWH(num_loops*grid_w*grid_w);
    --doRefillWater(4*numloops*grid_w*grid_w);
    doStashWH(grid_w*grid_w);
	if not skip_water then
		doRefillWater(4*grid_w*grid_w);
	end
    debug('end of batch #' .. loop_count)
  end
end

function doCorrectiveMove(move)
  statusScreen("Moving to correct for drift");
  local xyCenter = getCenterPos();
  if move == 'xy' or move == 'x' then
    srClickMouseNoMove(xyCenter[0] + walk_px_x*-1, xyCenter[1], 0);
    lsSleep(walk_time);
  end
  if move == 'xy' or move == 'y' then
    srClickMouseNoMove(xyCenter[0], xyCenter[1] + walk_px_y, 0);
    lsSleep(walk_time);
  end
end

function doStashWH(qty)
  local wh = srFindImage("stash.png");
  if wh then
    srClickMouseNoMove(wh[0]+9,wh[1]+9)
    debug('found stash, clicked it');
    lsSleep(250);

    srReadScreen();
    local insects = srFindImage("stashInsectEllipsis.png");

    local stashes = srFindImage("stashBarley.png");
    if not stashes then
      error "no barley to stash"
    end
    srClickMouseNoMove(stashes[0],stashes[1]);

    lsSleep(250);
    -- stash exactly the right amount by number so we don't lose our seed barley
    srKeyEvent(qty);
    srKeyEvent('\n');

    if insects then
      srClickMouseNoMove(wh[0]+9,wh[1]+9)
      lsSleep(250);
      srReadScreen();

      local insects = srFindImage("stashInsectEllipsis.png");
      if insects then
        srClickMouseNoMove(insects[0],insects[1]);
        lsSleep(250);

        srReadScreen();
        insects = srFindImage("stashAllTheInsects.png");
        if not insects then
          error "found insects but couldn't stash them";
        end
        srClickMouseNoMove(insects[0],insects[1]);
      end
    end
  end
end

function doRefillWater(qty)
  debug("in refill")
  local rb = srFindImage("draw_water.png");
  if rb then
    srClickMouseNoMove(rb[0]+5,rb[1]+5)
    lsSleep(250);
    srKeyEvent(qty);
    srKeyEvent('\n');
  end

end


function debug(msg)
  if 0 then
    statusScreen(msg);
    lsSleep(1000);
  end 
end

