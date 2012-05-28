-- flax_stable.lua v1.2 -- by Jimbly, tweaked by Cegaiel and
--   KasumiGhia, revised by Tallow.
--
-- Plant flax and harvest either flax or seeds.
--
-- Works Reliably: 2x2, 3x3, 4x4, 5x5
-- May Work (depends on your computer): 6x6, 7x7
--

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
  flax_stable v1.1 (by Jimbly, tweaked by Cegaiel and KasumiGhia,
  revised by Tallow) --
  Plant flax and harvest either flax or seeds. --
  Make sure the plant flax window is pinned and on the RIGHT side of
  the screen. Your VeggieTales window should also be on the RIGHT side
  of the screen. You must be in F8F8 cam zoomed in.  You may need to
  F12 at low resolutions or hide your chat window (if it starts
  planting and fails to move downward, it probably clicked on your
  chat window). Will plant grid NE of current location.  'Plant all
  crops where you stand' must be ON.  'Right click pins/unpins a menu'
  must be ON. Enable Hotkeys on flax must be OFF.
]]);

-- Global parameters set by prompt box.
grid_w = 5;
grid_h = 5;
is_plant = true;
seeds_per_pass = 5;

loadfile("luaScripts/ui_utils.inc")();

imgFlax1 = "FlaxGeneric.png";
imgHarvest = "HarvestThisFlax.png";
imgWeedAndWater = "WeedAndWater.png";
imgWeed = "WeedThisFlaxBed.png";
imgSeeds = "HarvestSeeds.png";
imgUseable = "UseableBy.png";
imgThisIs = "ThisIs.png";
imgUtility = "Utility.png";
imgRipOut = "RipOut.png";
imgUnpin = "UnPin.png";

-- Tweakable delay values
refresh_time = 300; -- Time to wait for windows to update
walk_time = 300;

-- Don't touch. These are set according to Jimbly's black magic.
walk_px_y = 340;
walk_px_x = 380;

xyCenter = {};
xyFlaxMenu = {};

-- The flax bed window
window_w = 174;
window_h = 100;

FLAX = 0;
ONIONS = 1;
plantType = FLAX;

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
    if pos then
      window_w = 166;
      window_h = 116;
    end
  end
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
    checkBreak("disallow pause");

    lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, "Choose passes and grid size");

    -- lsEditBox needs a key to uniquely name this edit box
    --   let's just use the prompt!
    -- lsEditBox returns two different things (a state and a value)
    local y = 40;

    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Passes:");
    is_done, num_loops = lsEditBox("passes", 110, y, z, 50, 30, scale, scale,
                                   0x000000ff, 5);
    if not tonumber(num_loops) then
      is_done = nil;
      lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      num_loops = 1;
    end
    y = y + 32;

    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Grid size:");
    is_done, grid_w = lsEditBox("grid", 110, y, z, 50, 30, scale, scale,
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
      is_done, seeds_per_pass = lsEditBox("seedsper", 110, y, z, 50, 30,
                                          scale, scale, 0x000000ff, 4);
      seeds_per_pass = tonumber(seeds_per_pass);
      if not seeds_per_pass then
        is_done = nil;
        lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        seeds_per_pass = 1;
      end
      y = y + 32;
    end

    is_plant = lsCheckBox(10, y, z+10, 0xFFFFFFff, "Grow Flax", is_plant);
    y = y + 32;

    if lsButtonText(170, y-32, z, 100, 0xFFFFFFff, "OK") then
      is_done = 1;
    end

    if is_plant then
      lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
                     "This will plant and harvest a " .. grid_w .. "x" ..
                     grid_w .. " grid of Flax " .. num_loops ..
                     " times, requiring " .. (grid_w * grid_w * num_loops) ..
                     " seeds, doing " .. (grid_w*grid_w*num_loops) ..
                     " flax harvests.");
    else
      local seedTotal = grid_w * grid_h * num_loops * seeds_per_pass
      lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
                     "This will plant a " .. grid_w .. "x" .. grid_w ..
                     " grid of Flax and harvest it " .. seeds_per_pass ..
                     " times, requiring " .. (grid_w * grid_w) ..
                     " seeds, and repeat this " .. num_loops ..
                     " times, yielding " .. seedTotal .. " seed harvests.");
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
seedImage = imgFlax1;

function getPlantWindowPos()
  srReadScreen();
  local plantPos = srFindImage(seedImage);
  if plantPos then
    plantPos[0] = plantPos[0] + 5;
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
  local startPos = findCoords();
  if not startPos then
    error("Could not find clockloc window");
  end

  drawWater();

  for loop_count=1, num_loops do
    local finalPos = plantAndPin(loop_count);
    dragWindows(loop_count);
    harvestAll(loop_count);
--    walkHome(loop_count, finalPos);
    walkHome(loop_count, startPos);
    drawWater();
  end
  lsPlaySound("Complete.wav");
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
                   x .. ", " .. y);
      success = plantHere(xyPlantFlax, y);
      if not success then
        break;
      end

      -- Move to next position
      if not ((x == grid_w) and (y == grid_h)) then
        lsPrintln('walking dx=' .. dx[dxi] .. ' dy=' .. dy[dxi]);
        x_pos = x_pos + dx[dxi];
        y_pos = y_pos + dy[dxi];
        safeClick(xyCenter[0] + walk_px_x*dx[dxi],
                  xyCenter[1] + walk_px_y*dy[dxi], 0);
        local spot = getWaitSpot(xyFlaxMenu[0], xyFlaxMenu[1]);
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
  local bed = xyFlaxMenu;
  local spot = getWaitSpot(xyFlaxMenu[0], xyFlaxMenu[1]);
  safeClick(xyPlantFlax[0], xyPlantFlax[1], 0);
  lsSleep(click_delay);


  if plantType == ONIONS then
--    waitForChange(spot, 500);



--define a global (prob not idea) to pass to onions_stable to refresh plant window, in case we used last seed and onions does not appear anymore
plantX = xyPlantFlax[0];
plantY = xyPlantFlax[1];


    bed = nil;
    while not bed do
      bed = searchForGreen(xyFlaxMenu);
    end
    if not bed then
      error "Could not find green. Abort this run.";
      return false;
    end
  else
    local plantSuccess = waitForChange(spot, 1500);
    if not plantSuccess then
      error "No plant was placed. Abort this run.";
      return false;
    end
  end

  -- Bring up menu
  lsPrintln('menu ' .. bed[0] .. ',' .. bed[1]);
  if not openAndPin(bed[0], bed[1], 3500) then
    error "No window came up. Abort this run.";
    return false;
  end


  -- Check for window size
  checkWindowSize(bed[0], bed[1]);

  -- Move window into corner
  stashWindow(bed[0] + 5, bed[1], BOTTOM_RIGHT);
  return true;
end

-------------------------------------------------------------------------------
-- dragWindows(loop_count)
--
-- Move flax windows into a grid on the screen.
-------------------------------------------------------------------------------

function dragWindows(loop_count)
  statusScreen("(" .. loop_count .. "/" .. num_loops .. ")  " ..
               "Dragging Windows into Grid");
  arrangeStashed();
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
    local tops = findAllImages(imgThisIs);
    for i=1,#tops do
      safeClick(tops[i][0], tops[i][1]);
      lsSleep(click_delay);
    end

    if is_plant then
      harvestLeft = #tops;
    else
      harvestLeft = (#tops - seedIndex) + 1 +
                    (#tops * (seeds_per_pass - seedWave));
    end

    statusScreen("(" .. loop_count .. "/" .. num_loops ..
                 ") Harvests Left: " .. harvestLeft);

    lsSleep(refresh_time);
    srReadScreen();
    if is_plant then
      local weeds = findAllImages(imgWeed);
      for i=1,#weeds do
        safeClick(weeds[i][0], weeds[i][1]);
      end

      local waters = findAllImages(imgWeedAndWater);
      for i=1,#waters do
        safeClick(waters[i][0], waters[i][1]);
      end

      local harvests = findAllImages(imgHarvest);
      for i=1,#harvests do
        safeClick(harvests[i][0], harvests[i][1]);
        lsSleep(refresh_time);
        safeClick(harvests[i][0], harvests[i][1] - 15, 1);
      end

      local seeds = findAllImages(imgSeeds);
      for i=1,#seeds do
        local seedTop = srFindImageInRange(imgThisIs,
                                        seeds[i][0] - 10, seeds[i][1]-window_h,
                                        window_w, window_h, 5000);
        if seedTop then
          ripOut(seedTop);
        end
      end
    else
      srReadScreen();
      local tops = findAllImages(imgThisIs);
      if #tops > 0 then
        if seedIndex > #tops then
          seedIndex = 1;
          seedWave = seedWave + 1;
        end
        local seedPos = srFindImageInRange(imgSeeds,
					   tops[#tops - seedIndex + 1][0],
					   tops[#tops - seedIndex + 1][1],
					   160, 100);
        if seedPos and seedWave <= seeds_per_pass then
          safeClick(seedPos[0] + 5, seedPos[1]);
          lsSleep(harvest_seeds_time);
          seedIndex = seedIndex + 1;
        end
      end
      if seedWave > seeds_per_pass then
        local seeds = findAllImages(imgThisIs);
        for i=1,#seeds do
          ripOut(seeds[i]);
        end
      end
    end

    if #tops <= 0 then
      did_harvest = true;
    end
    checkBreak();
  end
end

-------------------------------------------------------------------------------
-- walkHome(loop_count, finalPos)
--
-- Walk back to the origin (southwest corner) to start planting again.
-------------------------------------------------------------------------------

function walkHome(loop_count, finalPos)
  -- Wait for last flax bed to disappear
  statusScreen("(" .. loop_count .. "/" .. num_loops ..
               ") Waiting for flax beds to disappear...");
  lsSleep(2500);
  closeAllWindows(0, 0, srGetWindowSize()[0] - lsGetWindowSize()[0],
		  srGetWindowSize()[1]);
  statusScreen("(" .. loop_count .. "/" .. num_loops .. ") Walking...");

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
-- ripOut(pos)
--
-- Use the Utility menu to rip out a flax bed that has gone to seed.
-- pos should be the screen position of the 'This Is' text on the window.
-------------------------------------------------------------------------------

function ripOut(pos)
  statusScreen("Ripping Out");
  lsSleep(refresh_time);
  srReadScreen();
  local util_menu = srFindImageInRange(imgUtility, pos[0] - 10, pos[1] - 50,
                                       180, 200, 5000);
  if util_menu then
    safeClick(util_menu[0] + 5, util_menu[1], 0);
    local rip_out = waitForImage(imgRipOut, 1000);
    if rip_out then
      safeClick(rip_out[0] + 5, rip_out[1], 0);
      lsSleep(refresh_time);
      safeClick(pos[0], pos[1], 1); -- unpin
      lsSleep(refresh_time);
    end
  end
end
