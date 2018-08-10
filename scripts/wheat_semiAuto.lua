-- wheat_semiAuto.lua v0.1 -- BETA -- by Cegaiel (but based off flax_stable.lua; additional credits of flax_stable.lua to Jimbly KasumiGhia, Tallow, SkyFeather)


-- Jugs: The purpose of asking how many you have, is so it can remind you or attempt to refill your jugs.
-- It will only refill jugs (if you are near water or have Rain Barrel pinned - upper right) when you are near running out.
-- When you are down to only enough jug to water ALL of your pinned windows one more time, it will attempt to refill jugs
-- If no water source is found, text will turn yellow and beep at you reminding you need to refill.
-- Once the counter shows you've used all of your jugs, the macro will no longer attempt to water and text turns red.
-- While text is red, you do not need to pause macro, just quickly to water source. Macro will refill jugs when it see water icon.
-- When macro refills jugs, it resets jug counter back to zero.  In case you paused macro and refilled manually, then you need to click Reset Jugs button.

-- Monitor: This basically behaves like wheat.lua . If you have any pinned windows, it will water and harvest them.

-- Plant: This will plant a grid of wheat, pin windows, then start Monitoring.
-- Note you are free to keep adding more grids of plants at anytime you wish. Even if you have existing grid and existing pinned windows.
-- Just walk to a free space and click plant.  Note: prior to planting a new grid, it will stash all of your windows first. This is intended.
-- The reason it needs to stash windows first, is so that it doesn't click on existing pinned windows while walking.  Once next grid is planted, windows will repin automatically.

-- Re-Pin: Equivalent of the Form Grid button in Windows Manager. Let's say some of your wheat has been harvested and you want the windows re-pinned in a new grid.

-- Any time the Plant buttons are pressed, it will automatically go to F8F8 zoom mode, then plant. This means you do NOT need to Lock your screen. Feel free to zoom in/out after plantings!



dofile("common.inc");

askText = singleLine([[
Will plant wheat in a grid and/or monitor existing windows (like wheat.lua).
Can plant multiple grids, even before your current grids are harvested.

  Make sure the plant wheat window is pinned and on the RIGHT side of
  the screen. Your Automato window should also be on the RIGHT side
  of the screen. You may need to
  F12 at low resolutions or hide your chat window (if it starts
  planting and fails to move downward, it probably clicked on your
  chat window). 
  Will plant a spiral grid heading North-East of current location.  
  'Plant all crops where you stand' must be ON.  
  'Right click pins/unpins a menu' must be ON.
]]);


-- Global parameters set by prompt box.

totalWaters = 0;
right_click = true; -- Do right clicks to help prevent the possibility of avatar running on a misclick. Right clicks works the same as left clicks!
click_delay = 60; -- Overide the default of 50 in common.inc libarary. Run faster, clicks get queued and still execute, even when executed during a lag spike.
jugs = 100;

grid_w = 3;
grid_h = 3;
--finish_up = 0;
--finish_up_message = "";
waterGap = true;

seedType = "Voodoo";
--harvest = "Harvest this";
thisIs = "This is";
imgUseable = "UseableBy.png";
waterImage = "waterw.png";
harvestImage = "Harvest.png";


-- Tweakable delay values
refresh_time = 60; -- Time to wait for windows to update
walk_time = 600; -- Reduce to 300 if you're fast.

-- Don't touch. These are set according to Jimbly's black magic.
--walk_px_y = 340;
--walk_px_x = 380;
walk_px_y = 380;
walk_px_x = 400;



xyCenter = {};
xyFlaxMenu = {};

-- The wheat bed window
window_w = 230;
window_h = 128;  


-------------------------------------------------------------------------------
-- initGlobals()
--
-- Set up black magic values used for trying to walk a standard grid.
-------------------------------------------------------------------------------

function initGlobals()
  -- Macro written with 1720 pixel wide window

  srReadScreen();
  xyWindowSize = srGetWindowSize();
  center = getCenterPos();

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
    lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, "Enter #Jugs and Grid Size:");

    -- lsEditBox needs a key to uniquely name this edit box
    --   let's just use the prompt!
    -- lsEditBox returns two different things (a state and a value)
    local y = 40;
    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Wheat Name:");
    is_done, seedType = lsEditBox("flaxname", 120, y, z, 100, 30, scale, scale,
                                   0x000000ff, seedType);
    y = y + 32
    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Jugs:");
    is_done, jugs = lsEditBox("passes", 120, y, z, 50, 30, scale, scale,
                                   0x000000ff, jugs);
    if not tonumber(jugs) then
      is_done = nil;
      lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      jugs = 100;
    end
    y = y + 32
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
    y = y + 55;
    if not config then
    lsPrintWrapped(5, y, z, lsScreenX - 10, 0.7, 0.7, 0xFFFFFFff, "Click 'Plant' button to Plant grid, pin windows and monitor. Note any leftover windows that died will be closed. Alive plant windows will NOT be closed.");
    y = y + 75;

      if ButtonText(10, lsScreenY - 60, z, 100, 0xFFFFFFff, "Plant", 0.8, 0.8) then
        is_done = 1;
      end
    end
    lsPrintWrapped(5, y, z, lsScreenX - 10, 0.7, 0.7, 0xFFFFFFff, "Click 'Monitor ' button to water/harvest existing pinned windows.");
    y = y + 36;
    if ButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Monitor", 0.8, 0.8) then
	lsDoFrame();
      is_done = 1;
	doMonitor = 1;
	config = nil;
	statusScreen("Initiating Monitor ...");
	break;
    end
    y = y + 10

    if is_done and (not grid_w) then
      error 'Cancelled';
    end
		
    if ButtonText(lsScreenX - 90, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script", 0.8, 0.8) then
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
  askForWindow(askText);
  startTime = lsGetTimer();

  promptFlaxNumbers();
  initGlobals();
  refreshWindows() -- Close any empty windows
  lsSleep(500);
  refreshWindows() -- Run a 2nd time in case old windows still had words on menu -- Previous refresh would make it up to date
  drawWater();

  if doMonitor then
    tendWheat();
  else
    closeStashedWindows()
    stashAllWindows(BOTTOM_RIGHT);
    lsSleep(1000);
    setCameraView(CARTOGRAPHER2CAM);
    lsSleep(500);
    plantAndPin();
    dragWindows();
    tendWheat();
  end
end

-------------------------------------------------------------------------------
-- plantAndPin()
--
-- Walk around in a spiral, planting flax seeds and grabbing windows.
-------------------------------------------------------------------------------

function plantAndPin()

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
      statusScreen("Planting " ..
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
    error_status = "No wheat bed was placed when planting.";
    result = nil;
  end
  return result;
end

-------------------------------------------------------------------------------
-- dragWindows()
--
-- Move flax windows into a grid on the screen.
-------------------------------------------------------------------------------

function dragWindows()
  statusScreen("Dragging Windows into Grid" .. "\n\nElapsed Time: " .. getElapsedTime(startTime));
  stashAllWindows(BOTTOM_LEFT);
  arrangeInGrid(false, waterGap, window_w, window_h);
end


function tendWheat()

  while 1 do

	  nojugs = nil;

	if (totalWaters >= tonumber(jugs)) and #tops > 0 then
		if not drawWater() then
	  statusScreen("CRITICAL!\n\nYou are out of water!\n\nMacro will no longer attempt to refresh windows or water plants!\n\nMonitoring windows for Water/Harvest\n\nWheat Plants Found: " .. #tops .. "\nWaterings since last Refill: "  .. totalWaters .. "/" .. jugs .. " jugs", 0xff8080ff, 0.7, 0.7)
		  lsPlaySound("error.wav");
		  lsSleep(750);
		  nojugs = 1;
		end

	elseif ((jugs - totalWaters) <= #tops) and #tops > 0 then
		if not drawWater() then
		  statusScreen("WARNING!\n\nYou are almost out of water and no nearby water source found!\n\nMonitoring windows for Water/Harvest\n\nWheat Plants Found: " .. #tops .. "\nWaterings since last Refill: "  .. totalWaters .. "/" .. jugs .. " jugs", 0xffff80ff , 0.7, 0.7)
		  lsPlaySound("beepping.wav");
		  lsSleep(750);
		end

	else
	  statusScreen("Monitoring windows for Water/Harvest\n\nWheat Plants Found: " .. #tops .. "\nWaterings since last Refill: "  .. totalWaters .. "/" .. jugs .. " jugs\n\nYou may add more plants/grids to existing ones, by clicking  'Plant New Grid' button. -- But you need to manually walk to a suitable location, first.", nil, 0.7, 0.7)
	end



	refreshWindows();


		  for i=#harvest,1,-1 do
			checkBreak();
			safeClick(harvest[i][0] + 5, harvest[i][1]);
			lsSleep(click_delay);
		  end

		if #harvest > 0 then
		  refreshWindows(); -- The purpose of two refreshes is that when a plant is ready to harvest, it also shows watering at same time. Just do quick refresh to prevent wasting a water on harvested plant.
		end


		  if not nojugs then
		    for i=#waters,1,-1 do
			  checkBreak();
			  safeClick(waters[i][0] + 5, waters[i][1] + 5);
			  lsSleep(click_delay);
			  totalWaters = totalWaters + 1;
		    end
		  end


	if ButtonText(10, lsScreenY - 30, z, 150, 0xFFFFFFff, "Plant New Grid", 0.8, 0.8) then
	  closeStashedWindows()
	  stashAllWindows(BOTTOM_RIGHT);
	  lsSleep(1000);
	  setCameraView(CARTOGRAPHER2CAM);
	  lsSleep(500);
	  plantAndPin();
	  dragWindows();
	end

	if ButtonText(10, lsScreenY - 60, z, 150, 0xFFFFFFff, "Re-Pin Grid (Optional)", 0.8, 0.8) then
	  lsDoFrame();
	  dragWindows();
	end

	if ButtonText(lsScreenX-155, lsScreenY - 30, z, 90, 0xFFFFFFff, "Config", 0.8, 0.8) then
	  config = 1;
	  promptFlaxNumbers();
	end

	if ButtonText(lsScreenX-155, lsScreenY - 60, z, 185, 0xFFFFFFff, "Reset Jugs and/or Refill", 0.8, 0.8) then
	  lsDoFrame();
	  if not drawWater() then
	    sleepWithStatus(1000, "No Water Found ...\n\nReseting Watering Counter !", nil, 0.7, 0.7);
	  end
	  totalWaters = 0;
	end

  end
  return quit_message;
end


function refreshWindows()
  srReadScreen();
  waters = findAllImages(waterImage);
  harvest = findAllImages(harvestImage);
  emptyWindow = findAllImages("WindowEmpty.png");
  OK = srFindImage("OK.png");
  if OK then
    srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
    lsSleep(100);
  end
  tops = findAllText(thisIs);
	for i=1,#tops do
      	  safeClick(tops[i][0], tops[i][1]);
	  --lsSleep(10);
       end
  	for i=#emptyWindow,1,-1 do
	  checkBreak();
	  safeClick(emptyWindow[i][0] + 5, emptyWindow[i][1], right_click);
	  lsSleep(click_delay);
  	end
  lsSleep(100);
end


function getCenterPos()
	xyWindowSize = srGetWindowSize()
	bottomRightX = xyWindowSize[0] - 20;
	bottomRightY = xyWindowSize[1] - 20;
	local ret = {};
	ret[0] = xyWindowSize[0] / 2;
	ret[1] = xyWindowSize[1] / 2;
	return ret;
end

--Same function in common_ui.inc, but I wanted to scale the End Script button...
function statusScreen(message, color, allow_break, scale)
  if not message then
    message = "";
  end
  if not color then
    color = 0xFFFFFFff;
  end
  if allow_break == nil then
    allow_break = true;
  end
  if not scale then
    scale = 0.8;
  end
  lsPrintWrapped(10, 80, 0, lsScreenX - 20, scale, scale, color, message);
  lsPrintWrapped(10, lsScreenY-100, 0, lsScreenX - 20, scale, scale, 0xffd0d0ff,
		 error_status);
  if ButtonText(lsScreenX - 70, lsScreenY - 30, z, 80,
		  0xFFFFFFff, "Quit", 0.8, 0.8) then
    error(quit_message);
  end
  if allow_break then
    lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,
	    "Hold Ctrl+Shift to end this script.");
    if allow_pause then
      lsPrint(10, 24, 0, 0.7, 0.7, 0xB0B0B0ff,
	      "Hold Alt+Shift to pause this script.");
    end
    checkBreak();
  end
  lsSleep(tick_delay);
  lsDoFrame();
end


--This function also resides in common_click.inc, but this is custom. Return result before click water source (so we can right click the ground to stop running)
-- If you don't have water, you're expecting to quickly run to a water source. We need to quickly stop when water icon is present so we don't get the 'You moved' popup

function drawWater()
  local result = false;
  srReadScreen();

  local rain = srFindImage("draw_water.png");
    local aqueduct = srFindImage("Aqueduct.png");
    if not aqueduct then
      aqueduct = srFindImage("Aqueduct2.png");
    end
    local water = srFindImage("iconWaterJugSmall.png", 1);
    local watersmall = srFindImage("iconWaterJugSmallIcon.png", 1);

  if rain or aqueduct or water or watersmall then
    srClickMouseNoMove(center[0]+20, center[1]+20, 1); -- Right click ground to stop running
    totalWaters = 0;
    lsSleep(100);
  end

  -- First, check for rain barrel
  --local rain = srFindImage("draw_water.png");
  if rain then
    sleepWithStatus(200, "Refilling water...");
    safeClick(rain[0], rain[1]);
    local max = waitForImage("crem-max.png", 3000, "Waiting for Max button");
    if max then
      safeClick(max[0]+5, max[1]+5);
      result = true;
    end
  end

  -- Second, check for aqueduct
  if not result then
--    local aqueduct = srFindImage("Aqueduct.png");
--    if not aqueduct then
--      aqueduct = srFindImage("Aqueduct2.png");
--    end
    if aqueduct then
    sleepWithStatus(200, "Refilling water...");
      safeClick(aqueduct[0], aqueduct[1]);
      sleepWithStatus(200, "Refreshing aqueduct...");
      srReadScreen();
      local fill = srFindImage("FillWithWater.png");
      if fill then
    safeClick(fill[0] + 5, fill[1]);
    result = true;
      end
    end
  end

  -- Last, check for nearby pond
  if not result then
    --local water = srFindImage("iconWaterJugSmall.png", 1);
    --local watersmall = srFindImage("iconWaterJugSmallIcon.png", 1);

    if (water or watersmall) then
    sleepWithStatus(200, "Refilling water...");
	if water then
        safeClick(water[0]+3, water[1]-5);
	else
        safeClick(watersmall[0]+3, watersmall[1]-5);
	end
      local max = waitForImage("crem-max.png", 500, "Waiting for Max button", nil, 3000);
      if max then
        safeClick(max[0]+5, max[1]+5);
        sleepWithStatus(3500, "Waiting for water pickup animation...");
        result = true;
      end
    end
  end
  return result;
end


function closeStashedWindows()
  closeAllWindows(xyWindowSize[0]-500, xyWindowSize[1]-200, xyWindowSize[0], xyWindowSize[1]); -- Look for any leftover windows (stashed) at bottom right.
  closeAllWindows(0, xyWindowSize[1]-200, xyWindowSize[0], xyWindowSize[1]); -- Look for any leftover windows (stashed) at bottom left.
end
