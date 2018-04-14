-- flax_stable.lua v1.2 -- by Jimbly, tweaked by Cegaiel and
--   KasumiGhia, revised by Tallow.
--
-- Plant flax and harvest either flax or seeds.
--
-- Works Reliably: 2x2, 3x3, 4x4, 5x5
-- May Work (depends on your computer): 6x6, 7x7
--

dofile("common.inc");

askText = singleLine([[
  flax_stable v1.1 (by Jimbly, tweaked by Cegaiel and KasumiGhia,
  revised by Tallow. Updated for T7 by Skyfeather) --
  Plant flax and harvest either flax or seeds. --
  Make sure the plant flax window is pinned and on the RIGHT side of
  the screen. Your Automato window should also be on the RIGHT side
  of the screen. You may need to
  F12 at low resolutions or hide your chat window (if it starts
  planting and fails to move downward, it probably clicked on your
  chat window). 
  Will plant a spiral grid heading North-East of current  location.  
  'Plant all crops where you stand' must be ON.  
  'Right click pins/unpins a menu' must be ON.
]]);

-- Global parameters set by prompt box.
num_loops = 5;
grid_w = 5;
grid_h = 5;
is_plant = true;
seeds_per_pass = 5;
seeds_per_iter = 0;
finish_up = 0;
finish_up_message = "";


seedType = "Old";
harvest = "Harvest this";
weedAndWater = "Weed and Water";
weedThis = "Weed this";
harvestSeeds = "Harvest seeds";
thisIs = "This is";
utility = "Utility";
txtRipOut = "Rip out";
useable = "Useable";

imgUseable = "UseableBy.png";
imgThisIs = "ThisIs.png";
imgUtility = "Utility.png";
imgSeeds = "HarvestSeeds.png";

-- Tweakable delay values
refresh_time = 60; -- Time to wait for windows to update
walk_time = 600; -- Reduce to 300 if you're fast.

-- Don't touch. These are set according to Jimbly's black magic.
walk_px_y = 340;
walk_px_x = 380;

xyCenter = {};
xyFlaxMenu = {};

-- The flax bed window
local window_w = 0;  -- Just a declaration, changes based on method in promptFlaxNumbers()
window_h = 145;  

-- To allow 5x5 seeds on a 1920 width screen, we need to tweak the arrangeStashed function to only allow 50px for automato window
space_to_leave = 50; 

FLAX = 0;
ONIONS = 1;
plantType = FLAX;
CLICK_MIN_WEED = 15*1000;
CLICK_MIN_SEED = 27*1000;
numSeedsHarvested = 0;

-------------------------------------------------------------------------------
-- initGlobals()
--
-- Set up black magic values used for trying to walk a standard grid.
-------------------------------------------------------------------------------

function initGlobals()
  -- Macro written with 1720 pixel wide window

  srReadScreen();
  xyWindowSize = srGetWindowSize();

  local pixel_scale = xyWindowSize[0] / 1720;
  lsPrintln("pixel_scale " .. pixel_scale);

  walk_px_y = math.floor(walk_px_y * pixel_scale);
  walk_px_x = math.floor(walk_px_x * pixel_scale);

  local walk_x_drift = 14;
  local walk_y_drift = 18;
  if (lsScreenX < 1280) then 
    -- Have to click way off center in order to not move at high resolutions
    walk_x_drift = math.floor(walk_x_drift * pixel_scale);
    walk_y_drift = math.floor(walk_y_drift * pixel_scale);
  else
    -- Very little drift at these resolutions, clicking dead center barely moves
    walk_x_drift = 1;
    walk_y_drift = 1;
  end

  xyCenter[0] = xyWindowSize[0] / 2 - walk_x_drift;
  xyCenter[1] = xyWindowSize[1] / 2 + walk_y_drift;
  if plantType == FLAX then
    xyFlaxMenu[0] = xyCenter[0] - 43*pixel_scale;
    xyFlaxMenu[1] = xyCenter[1] + 0;
  else
    xyFlaxMenu[0] = xyCenter[0] - 20;
    xyFlaxMenu[1] = xyCenter[1] - 10;
  end
end

-------------------------------------------------------------------------------
-- checkWindowSize()
--
-- Set width and height of flax window based on whether they are guilded.
-------------------------------------------------------------------------------

window_check_done_once = false;
function checkWindowSize(x, y)
  if not window_check_done_once then
    srReadScreen();
    window_check_done_once = true;
     local pos = srFindImageInRange(imgUseable, x-5, y-50, 150, 100)
  end
end

-------------------------------------------------------------------------------
-- promptFlaxNumbers()
--
-- Gather user-settable parameters before beginning
-------------------------------------------------------------------------------

function promptFlaxNumbers()
  scale = 0.8;
	
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
    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Flax Name:");
    is_done, seedType = lsEditBox("flaxname", 120, y, z, 100, 30, scale, scale,
                                   0x000000ff, seedType);
    y = y + 32
    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Passes:");
    is_done, num_loops = lsEditBox("passes", 120, y, z, 50, 30, scale, scale,
                                   0x000000ff, num_loops);
    if not tonumber(num_loops) then
      is_done = nil;
      lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      num_loops = 1;
    end
    y = y + 32;
    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Grid size:");
    is_done, grid_w = lsEditBox("grid", 120, y, z, 50, 30, scale, scale,
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
      is_done, seeds_per_pass = lsEditBox("seedsper", 120, y, z, 50, 30,
                                          scale, scale, 0x000000ff, 4);
      seeds_per_pass = tonumber(seeds_per_pass);
      if seeds_per_pass then
        seeds_per_iter = seeds_per_pass * grid_w * grid_h;
      end
      if not seeds_per_pass then
        is_done = nil;
        lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        seeds_per_pass = 1;
      end
      y = y + 32;
    end
    is_plant = lsCheckBox(120, y+5, z+10, 0xFFFFFFff, "Grow Flax", is_plant);
    y = y + 36;
    if lsButtonText(10, y-32, z, 100, 0xFFFFFFff, "Start!") then
      is_done = 1;
    end
    y = y + 8;

    if is_plant then
      -- Will plant and harvest flax
      window_w = 285; 
      space_to_leave = false; 
      lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff, "Uncheck \"Grow Flax\" for SEEDS!");
      y = y + 24;
      lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
                     "This will plant and harvest a " .. grid_w .. "x" ..
                     grid_w .. " grid of " .. seedType .. " Flax " .. num_loops ..
                     " times, requiring " .. math.floor(grid_w * grid_w * num_loops) ..
                     " seeds, doing " .. math.floor(grid_w*grid_w*num_loops) ..
                     " flax harvests.\n\n" ..
                     "Put automato as far right as possible, you may need to " ..
                     " reduce my width (or minimize me!)");
    else
    lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0x00ff00ff, "Check \"Grow Flax\" for FLAX!");
    y = y + 24;

      -- Will make seeds
      
      -- Flax window will grow to 333 px before returning to 290.
      -- This window MUST be big enough otherwise rip out seeds will hang automato!
      -- As a result, we need to reduce space on the right to accomodate a 5x5 grid on widescreen monitors
      window_w = 333; 
      space_to_leave = 50;
      
      local seedTotal = grid_w * grid_h * num_loops * seeds_per_pass
      lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
                     "This will plant a " .. grid_w .. "x" .. grid_w ..
                     " grid of " .. seedType .. " Flax and harvest it " .. seeds_per_pass ..
                     " times, requiring " .. (grid_w * grid_w) ..
                     " seeds, and repeat this " .. num_loops ..
                     " times, yielding " .. math.floor(seedTotal) .. " seed harvests." ..
		     " Put automato as far right as possible, you may need to " ..
                     " reduce my width (or minimize me!)");
    end

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

-------------------------------------------------------------------------------
-- getPlantWindowPos()
-------------------------------------------------------------------------------

lastPlantPos = null;

function getPlantWindowPos()
  srReadScreen();
  local plantPos = findText(seedType);
  if plantPos then
    plantPos[0] = plantPos[0] + 20;
    plantPos[1] = plantPos[1] + 10;
  else
    plantPos = lastPlantPos;
    if plantPos then
      safeClick(plantPos[0], plantPos[1]);
      lsSleep(refresh_time);
    end
  end
  if not plantPos then
    error 'Could not find plant window';
  end
  lastPlantPos = plantPos;
  return plantPos;
end

-------------------------------------------------------------------------------
-- getToggle()
--
-- Returns 0 or 2 alternately. Used to slightly shift position of windows
-- while collecting them.
-------------------------------------------------------------------------------

toggleBit = 0;

function getToggle()
  if toggleBit == 0 then
    toggleBit = 2;
  else
    toggleBit = 0;
  end
  return toggleBit;
end

-------------------------------------------------------------------------------
-- doit()
-------------------------------------------------------------------------------

function doit()
  promptFlaxNumbers();
  askForWindow(askText);
  initGlobals();
  srReadScreen();
  local startPos = findCoords();
  if not startPos then
    error("ATITD clock not found. Verify entire clock and borders are visible. Try moving clock slightly.");
  end
  lsPrintln("Start pos:" .. startPos[0] .. ", " .. startPos[1]);

  setCameraView(CARTOGRAPHER2CAM);
  drawWater();
  startTime = lsGetTimer();

  for loop_count=1, num_loops do
    error_status = "";
    numSeedsHarvested = 0;
    clicks = {};
    local finalPos = plantAndPin(loop_count);
    dragWindows(loop_count);
    harvestAll(loop_count);
    walkHome(loop_count, startPos);
    drawWater();
	if finish_up == 1 then
	  break;
	end
  end
  lsPlaySound("Complete.wav");
  lsMessageBox("Elapsed Time:", getElapsedTime(startTime), 1);
end

-------------------------------------------------------------------------------
-- plantAndPin()
--
-- Walk around in a spiral, planting flax seeds and grabbing windows.
-------------------------------------------------------------------------------

function plantAndPin(loop_count)
  local xyPlantFlax = getPlantWindowPos();
		
  -- for spiral
  local dxi=1;
  local dt_max=grid_w;
  local dt=grid_w;
  local dx={1, 0, -1, 0};
  local dy={0, -1, 0, 1};
  local num_at_this_length = 3;
  local x_pos = 0;
  local y_pos = 0;
  local success = true;

  for y=1, grid_h do
    for x=1, grid_w do
      statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Planting " ..
                   x .. ", " .. y .. "\n\nElapsed Time: " .. getElapsedTime(startTime));
      success = plantHere(xyPlantFlax, y);
      if not success then
        break;
      end

      -- Move to next position
      if not ((x == grid_w) and (y == grid_h)) then
        lsPrintln('walking dx=' .. dx[dxi] .. ' dy=' .. dy[dxi]);
	lsSleep(40);
        x_pos = x_pos + dx[dxi];
        y_pos = y_pos + dy[dxi];
	local spot = getWaitSpot(xyFlaxMenu[0], xyFlaxMenu[1]);
        safeClick(xyCenter[0] + walk_px_x*dx[dxi],
                  xyCenter[1] + walk_px_y*dy[dxi], 0);
	
        spot = getWaitSpot(xyFlaxMenu[0], xyFlaxMenu[1]);
	if not waitForChange(spot, 1500) then
	  error_status = "Did not move on click.";
	  break;
	end
        lsSleep(walk_time);
        waitForStasis(spot, 1500);
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
        end
      else
        lsPrintln('skipping walking, on last leg');
      end
    end
    checkBreak();
    if not success then
      break;
    end
  end
  local finalPos = {};
  finalPos[0] = x_pos;
  finalPos[1] = y_pos;
  return finalPos;
end

-------------------------------------------------------------------------------
-- plantHere(xyPlantFlax)
--
-- Plant a single flax bed, get the window, pin it, then stash it.
-------------------------------------------------------------------------------

function plantHere(xyPlantFlax, y_pos)
  -- Plant
  lsPrintln('planting ' .. xyPlantFlax[0] .. ',' .. xyPlantFlax[1]);
  local bed = clickPlant(xyPlantFlax);
  if not bed then
    return false;
  end

  -- Bring up menu
  lsPrintln('menu ' .. bed[0] .. ',' .. bed[1]);
  if not openAndPin(bed[0], bed[1], 3500) then
    error_status = "No window came up after planting.";
    return false;
  end

--  if plantType == ONIONS then
--    lsPrintln("Onions");
--    lsSleep(200);
--    srReadScreen();
--    local waters = findAllImages("WaterThese.png");
--    for i = 1,#waters do
--      lsPrintln("Water");
--      safeClick(waters[i][0]+5, waters[i][1]+5);
--    end
--    sleepWithStatus(1000, "First Water");
--  end

  -- Check for window size
  checkWindowSize(bed[0], bed[1]);

  -- Move window into corner
  stashWindow(bed[0] + 5, bed[1], BOTTOM_RIGHT);

  return true;
end

function clickPlant(xyPlantFlax)
  local result = xyFlaxMenu;
  local spot = getWaitSpot(xyFlaxMenu[0], xyFlaxMenu[1]);
  safeClick(xyPlantFlax[0], xyPlantFlax[1], 0);

  local plantSuccess = waitForChange(spot, 1500);
  if not plantSuccess then
    error_status = "No flax bed was placed when planting.";
    result = nil;
  end
  return result;
end

-------------------------------------------------------------------------------
-- dragWindows(loop_count)
--
-- Move flax windows into a grid on the screen.
-------------------------------------------------------------------------------

function dragWindows(loop_count)
  statusScreen("(" .. loop_count .. "/" .. num_loops .. ")  " ..
               "Dragging Windows into Grid" .. "\n\nElapsed Time: " .. getElapsedTime(startTime));

  if plantType == ONIONS then
    arrangeStashed(nil, true, onion_window_w, onion_window_h, space_to_leave);
  else
    arrangeStashed(nil, true, window_w, window_h, space_to_leave);
  end

end

-------------------------------------------------------------------------------
-- harvestAll(loop_count)
--
-- Harvest all the flax or seeds and clean up the windows afterwards.
-------------------------------------------------------------------------------

function harvestAll(loop_count)
  local did_harvest = false;
  local harvestLeft = 0;
  local seedIndex = 1;
  local seedWave = 1;
  local lastTops = {};

  while not did_harvest do

    -- Monitor for Weed This/etc
    lsSleep(refresh_time);
    srReadScreen();
    local tops = findAllText(thisIs);
    for i=1,#tops do
      safeClick(tops[i][0], tops[i][1]);
    end

    if is_plant then
      harvestLeft = #tops;
    else
      harvestLeft = seeds_per_iter - numSeedsHarvested;
    end

  if finish_up == 0 and tonumber(loop_count) ~= tonumber(num_loops) then
	if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Finish up") then
	  finish_up = 1;
	  finish_up_message = "\n\nFinishing up..."
	end
  end

    statusScreen("(" .. loop_count .. "/" .. num_loops ..
                 ") Harvests Left: " .. harvestLeft .. "\n\nElapsed Time: " .. getElapsedTime(startTime) .. finish_up_message);

    lsSleep(refresh_time);
    srReadScreen();
    if is_plant then
      lsPrintln("Checking Weeds");
      lsPrintln("numTops: " .. #tops);
      local weeds = findAllText(weedThis);
      for i=#weeds, 1, -1 do
        lastClick = lastClickTime(weeds[i][0], weeds[i][1]);
        if lastClick == nil or lsGetTimer() - lastClick >= CLICK_MIN_WEED then
          clickText(weeds[i]);
          trackClick(weeds[i][0], weeds[i][1]);
        end
      end

      local waters = findAllText(weedAndWater);
      for i=#waters, 1, -1 do
        lastClick = lastClickTime(waters[i][0], waters[i][1]);
        if lastClick == nil or lsGetTimer() - lastClick >= CLICK_MIN_WEED then


          clickText(waters[i]);
          trackClick(waters[i][0], waters[i][1]);
        end
      end

      local harvests = findAllText(harvest);
      for i=#harvests, 1, -1 do
        lastClick = lastClickTime(harvests[i][0], harvests[i][1]);
        if lastClick == nil or lsGetTimer() - lastClick >= CLICK_MIN_WEED then
          clickText(harvests[i]);
          trackClick(harvests[i][0], harvests[i][1]);
        end
      end
      
      -- check for beds needing ripping out
      local hsr = findText(harvestSeeds, nil, REGION);
      if hsr then
        clickText(findText(utility, hsr));
        ripLoc = waitForText(txtRipOut, 1000);
        if ripLoc then
          clickText(ripLoc);
        end
      end
    else
      seedsList = findAllText(harvestSeeds);
      for i=#seedsList, 1, -1 do
        lastClick = lastClickTime(seedsList[i][0], seedsList[i][1]);
        if lastClick == nil or lsGetTimer() - lastClick >= CLICK_MIN_SEED then
          clickText(seedsList[i]);
          trackClick(seedsList[i][0], seedsList[i][1]);
          numSeedsHarvested = numSeedsHarvested + 1;
        end
      end
    end
    
    if numSeedsHarvested >= seeds_per_iter and not is_plant  then
      did_harvest = true;
    end

    if #tops <= 0 then
      lsPrintln("finished harvest");
      did_harvest = true;
    end
    checkBreak();
  end
  lsPrintln("ripping out all seeds");
  ripOutAllSeeds();
  -- Wait for last flax bed to disappear
  sleepWithStatus(1500, "(" .. loop_count .. "/" .. num_loops ..
		  ") ... Waiting for flax beds to disappear");
end

-------------------------------------------------------------------------------
-- walkHome(loop_count, finalPos)
--
-- Walk back to the origin (southwest corner) to start planting again.
-------------------------------------------------------------------------------

function walkHome(loop_count, finalPos)
  -- Close all empty windows
  closeEmptyAndErrorWindows();
  -- remove any screens with the too far away text
  statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Walking..." .. "\n\nElapsed Time: " .. getElapsedTime(startTime));

  walkTo(finalPos);

  -- Walk back
--  for x=1, finalPos[0] do
--    local spot = getWaitSpot(xyCenter[0] - walk_px_x, xyCenter[1]);
--    safeClick(xyCenter[0] - walk_px_x, xyCenter[1], 0);
--    lsSleep(walk_time);
--    waitForStasis(spot, 1000);
--  end
--  for x=1, -(finalPos[1]) do
--    local spot = getWaitSpot(xyCenter[0], xyCenter[1] + walk_px_y);
--    safeClick(xyCenter[0], xyCenter[1] + walk_px_y, 0);
--    lsSleep(walk_time);
--    waitForStasis(spot, 1000);
--  end
end

-------------------------------------------------------------------------------
-- ripOutAllSeeds
--
-- Use the Utility menu to rip out a flax bed that has gone to seed.
-- pos should be the screen position of the 'This Is' text on the window.
-------------------------------------------------------------------------------

function ripOutAllSeeds()
  statusScreen("Ripping Out" .. "\n\nElapsed Time: " .. getElapsedTime(startTime));
  srReadScreen();
  flaxRegions = findAllText("This is ", nil, REGION)
  for i = 1, #flaxRegions do
    local utloc = waitForText(utility, nil, nil, flaxRegions[i]);
    lsPrintln("Clicking Utility.. button at: " .. utloc[0] .. ", " .. utloc[1]);
    clickText(utloc);
    lsPrintln("Clicking rip out");
    clickText(waitForText(txtRipOut));
    lsSleep(refresh_time);
    lsPrintln("Unpinning region");
    unpinWindow(flaxRegions[i]);
    lsSleep(refresh_time);
    checkBreak();
  end
end

clicks = {};
function trackClick(x, y)
  local curTime = lsGetTimer();
  lsPrintln("Tracking click " .. x .. ", " .. y .. " at time " .. curTime);
  if clicks[x] == nil then
    clicks[x] = {};
  end
  clicks[x][y] = curTime;
end

function lastClickTime(x, y)
  if clicks[x] ~= nil then
    if clicks[x][y] ~= nil then
      lsPrintln("Click " .. x .. ", " .. y .. " found at time " .. clicks[x][y]);
    end
    return clicks[x][y];
  end
  lsPrintln("Click " .. x .. ", " .. y .. " not found. ");
  return nil;
end
