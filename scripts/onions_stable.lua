dofile("Flax_stable.lua");

askText = singleLine([[
  onions_stable v1.0 (by Tallow and Cegaiel) --
  Plant onions and harvest them. --
  Make sure the plant onions window and barrel/aqueduct is pinned and
  on the RIGHT side of the screen. Select the skills tab. Your
  Automato window should also be on the RIGHT side of the
  screen. You must be in F8F8 cam zoomed in.  You may need to F12 at
  low resolutions or hide your chat window (if it starts planting and
  fails to move downward, it probably clicked on your chat
  window). Will plant grid NE of current location.  'Plant all crops
  where you stand' must be ON.  'Right click pins/unpins a menu' must
  be ON.
]]);


plantType = ONIONS;

grid_w = 4;
grid_h = 4;

-- Plant more densely than flax
walk_px_y = 140;
walk_px_x = 170;

-- Override flax default, allow a few ms more in case lag messed the
-- walk. Less forgiving, by lag, on tight grids from onions vs flax.
walk_time = 500;

-- This is clicking each window very slow. So it doesn't do a double
-- or triple watering animation on same plant (caused by clicking too
-- fast) Too many double or triple watering animations will steal some
-- of the time. Just as long as it clicks all windows before you can
-- walk from first to last plant is fine.
click_water_delay = 1400;

refresh_time = 200;
click_delay = 150;

seedImage = "Onion Seeds";
waterImage = "WaterThese.png";
harvestImage = "HarvestThese.png";
leafImage = "OnionLeaf.png";

yLeafRadius = 43;
xLeafRadius = 38;

function harvestAll(loop_count)
  local timing = 24000;
  local harvest_timing = 15000;

  if grid_w == 1 then
    -- 1x1 grid
    timing = 19000;
    harvest_timing = 0;
    
  elseif grid_w == 2 then
    -- 2x2 grid
    timing = 15000;
    harvest_timing = 1000;

  elseif grid_w == 3 then
    -- 3x3 grid
    timing = 9000;
    harvest_timing = 6000;

  else
    -- 4x4 grid 
    timing = 0;
    harvest_timing = 10000;
  end
  local globalStr = "[" .. loop_count .. "/" .. num_loops .. "] Passes" .. "\n";

  for pass=1,4 do
    local passStr = "[" .. 5-pass .. "] Growths until Harvest\n"
    srReadScreen();
    local waters = findAllImages(waterImage);
    for i=#waters,1,-1 do
      safeClick(waters[i][0] + 5, waters[i][1] + 5);
      sleepWithStatus(click_water_delay, globalStr .. passStr ..
		      "[" .. i .. "] Watering plants...");
    end
    sleepWithStatus(timing + click_water_delay*(grid_w*grid_w - #waters),
		    globalStr .. passStr .. "Waiting for next growth");
  end
  local anchors = findAllImages(waterImage);
  local current = #anchors;
  local range = getWindowBorders(anchors[current][0], anchors[current][1]);
  while current > 0 do
    local updates = findAllImages("ThisIs.png", range);
    clickAllPoints(updates);
    srReadScreen();
    local harvests = findAllImages(harvestImage, range);
    for i=1,#harvests do
      safeClick(harvests[i][0], harvests[i][1]);
      lsSleep(click_delay);
      safeClick(harvests[i][0], harvests[i][1] - 15, 1);
      statusScreen("[" .. i .. "] Harvesting plants...");
      lsSleep(click_delay);
      current = current - 1;
      if current > 0 then
	range = getWindowBorders(anchors[current][0], anchors[current][1]);
      end
    end
    lsSleep(10);
    checkBreak();
  end
  sleepWithStatus(harvest_timing,
		  globalStr .. "Waiting for harvest to finish.");
  getPlantWindowPos();
end

function clickPlant(plantButton)
  local tol = 1000;
  srReadScreen();
  local searchRegion = makeBox(xyFlaxMenu[0] - xLeafRadius,
			       xyFlaxMenu[1] - yLeafRadius,
			       xLeafRadius*2 + 1, yLeafRadius*2 + 1);
  local before = srFindImageInRange(leafImage, searchRegion.x, searchRegion.y,
				    searchRegion.width, searchRegion.height,
				    tol);
  if before then
    error_status = "Found onion leaf before planting.";
    return nil;
  end

  safeClick(plantButton[0], plantButton[1], 0);
  lsSleep(click_delay);

  local bed = waitForImage(leafImage, 3500, "Waiting for onion leaf",
			   searchRegion, tol);
--  local startTime = lsGetTimer();
--  while not bed and lsGetTimer() - startTime < 3500 do
--    bed = searchForGreen(xyFlaxMenu);
--    statusScreen("Waiting for onion leaves to appear");
--  end
  if not bed then
    error_status = "Could not find onion leaf after planting.";
  else
    bed[0] = bed[0] + 2;
    bed[1] = bed[1] + 2;
  end
  return bed;
end

function searchForGreen(centerBad)
  local tests = {makePoint(0, 0), makePoint(0, 1), makePoint(0, -1),
		 makePoint(1, 0), makePoint(-1, 0), makePoint(-1, -1),
		 makePoint(-1, 1), makePoint(1, -1), makePoint(1, 1)};
  local center = makePoint(srGetWindowSize()[0]/2,
			   srGetWindowSize()[1]/2);
--  local green = 0x4b7420;
--  local green = 0x557614;
  local green = 0x6c8516;
  local result = nil
  local closestMax = 65000;
  srReadScreen();

--70
  local diffTable = {};

  for y=-yLeafRadius-1, yLeafRadius+1 do
    diffTable[y] = {};
    for x=-xLeafRadius-1, xLeafRadius+1 do
      diffTable[y][x] = pixelDiffs(center[0] + x, center[1] + y, green);
    end
  end

  for y=-yLeafRadius,yLeafRadius do
    for x=-xLeafRadius,xLeafRadius do
      local passed = true;
      local vals;
      local current = 0;
      for i=1,#tests do
	vals = diffTable[y + tests[i][1]][x + tests[i][0]];
--pixelDiffs(center[0] + x + tests[i][0],
--			  center[1] + y + tests[i][1], green);
	current = vals[1]*vals[1] + vals[3]*vals[3]
	  + vals[2]*vals[2];
	if current > 1000 then
	  passed = false;
	  break;
	end
      end
      if passed then
--	if current < closestMax then
--	  lsPrintln("New winner: " .. current .. "(" .. table.concat(vals, ", ") .. ")" .. "(" .. x .. ", " .. y .. ")");
	  closestMax = current;
	result = makePoint(center[0] + x, center[1] + y);
      end
    end
  end
  return result;
end

-------------------------------------------------------------------------------
-- promptFlaxNumbers()
--
-- Gather user-settable parameters before beginning
-------------------------------------------------------------------------------

function promptFlaxNumbers()
  scale = 1.0;
	
  local z = 0;
  local is_done = nil;
  local value = nil;
  -- Edit box and text display
  while not is_done do
    -- Make sure we don't lock up with no easy way to escape!
    checkBreak();

    lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, "Choose passes and grid size");

    -- lsEditBox needs a key to uniquely name this edit box
    --   let's just use the prompt!
    -- lsEditBox returns two different things (a state and a value)
    local y = 40;

    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Passes:");
    is_done, num_loops = lsEditBox("passesO", 110, y, z, 50, 30, scale, scale,
                                   0x000000ff, num_loops);
    if not tonumber(num_loops) then
      is_done = nil;
      lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      num_loops = 1;
    end
    y = y + 32;

    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Grid size:");
    is_done, grid_w = lsEditBox("gridO", 110, y, z, 50, 30, scale, scale,
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

    lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
		   "This will plant and harvest a " .. grid_w .. "x" ..
		     grid_w .. " grid of Onions " .. num_loops ..
                     " times, yielding " .. (grid_w*grid_w*num_loops) ..
                     " onion harvests.");

    if is_done and (not num_loops or not grid_w) then
      error 'Canceled';
    end
		
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(tick_delay);
  end
end
