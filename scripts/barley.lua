 -- barley.lua v2.0 -- by Cegaiel (but based off flax_stable.lua; credits of flax_stable.lua to Jimbly KasumiGhia, Tallow, SkyFeather)
--

dofile("common.inc");

askText = "Barley v2.0 by Cegaiel (many credits included in script comments)\n\nThis macro is not fancy It simply converts 1 of you barley into 2.\n\n'Right click pins/unpins a menu' must be ON.\n\n'Plant all crops where you stand' must be ON.\n\n'Right click pins/unpins a menu' must be ON.\n\nPin Barley Plant window in TOP-RIGHT. Automato: Slighty in TOP-RIGHT.";


-- Global parameters set by prompt box.
num_loops = 5;
grid_w = 5;
grid_h = 5;
is_plant = true;
seeds_per_pass = 5;
seeds_per_iter = 0;
finish_up = 0;
finish_up_message = "";


seedType = "Barley";
useable = "Useable";

imgUseable = "UseableBy.png";
imgThisIs = "ThisIs.png";
imgUtility = "Utility.png";

-- Tweakable delay values
refresh_time = 60; -- Time to wait for windows to update
walk_time = 600; -- Reduce to 300 if you're fast.

-- Don't touch. These are set according to Jimbly's black magic.
walk_px_y = 340;
walk_px_x = 380;

xyCenter = {};
xyFlaxMenu = {};

-- The barley bed window
local window_w = 258;  -- Just a declaration, changes based on method in promptFlaxNumbers()
window_h = 218;  



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
    xyFlaxMenu[0] = xyCenter[0] - 20;
    xyFlaxMenu[1] = xyCenter[1] - 10;
end

-------------------------------------------------------------------------------
-- checkWindowSize()
--
-- Set width and height of barley window based on whether they are guilded.
-------------------------------------------------------------------------------

window_check_done_once = false;
function checkWindowSize(x, y)
  if not window_check_done_once then
    srReadScreen();
    window_check_done_once = true;
     local pos = srFindImageInRange(imgUseable, x-5, y-50, 150, 100);
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
    y = y + 30;

    if is_plant then
      -- Will plant and harvest flax
      --window_w = 285; 

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end


      lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
                     "This will plant and harvest a " .. grid_w .. "x" ..
                     grid_w .. " grid of " .. seedType .. "  " .. num_loops ..
                     " times.\n\nRequires (" .. math.floor(grid_w * grid_w * num_loops) .. ") Barley\nRequires (" .. math.floor(grid_w * grid_w * num_loops*6) .. ") Water"  );
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
waterings = 0;
  size = srGetWindowSize();

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
    waters = 0;
    quit = false;
    error_status = "";
    clicks = {};
    local finalPos = plantAndPin(loop_count);
    dragWindows(loop_count);
    waterBarley();
    lsSleep(500);
    barleyWaterBar = true;
    waters = 1;

  while 1 do
    checkBreak();
    lsSleep(100);
    findWaterBar();

	if not barleyWaterBar then
	  waters = waters + 1;
		if waters < 4 then
	  waterBarley();
	  	  sleepWithStatus(1000, "Watering Barley...",nil, 0.7, 0.7);
		end
      end


  if waters == 4 then
    break;
  end

  sleepWithStatus(150, "Watching Top Left Window:\n\nWaiting for Water Bar to drop: " .. waters .. "/4",nil, 0.7, 0.7);
  end

  harvestAll();

  sleepWithStatus(3000, "Preparing to close windows");
  srReadScreen();


  clickAllText("This is"); -- Right click to close all windows in range

    walkHome(loop_count, startPos);
    drawWater();
	if finish_up == 1 or quit then
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
  if not openAndPin(bed[0]-100, bed[1], 3500) then
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
    error_status = "No barley bed was placed when planting.";
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
    arrangeStashed(nil, false, window_w, window_h);
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
end





function waterBarley()
  srReadScreen();
  barleyWaterImage = findAllImages("barleyWater.png");
    if #barleyWaterImage == 0 then
      error("Could not find 'Water:' text in barley pinned menu (Top Left corner only)");
    else
		for i=#barleyWaterImage, 1, -1  do
			checkBreak();
			safeClick(barleyWaterImage[i][0]+192, barleyWaterImage[i][1]+3);
			lsSleep(10);
			safeClick(barleyWaterImage[i][0]+192, barleyWaterImage[i][1]+3);
		end
    end
end


function findWaterBar()
  srReadScreen();
  barleyWaterBar = srFindImageInRange("barleyWaterFull.png", 0, 0, window_w, window_h);

  if barleyWaterBar then
    safeClick(barleyWaterBar[0], barleyWaterBar[1]);
    lsSleep(10);
    safeClick(barleyWaterBar[0], barleyWaterBar[1]);
  end
end



function harvestAll()
  harvest = findAllImages("BarleyHarvest.png");

    if #harvest == 0 then
       error("No harvet images found");
    else

	for i=#harvest, 1, -1  do
	  sleepWithStatus(100, "Harvesting " .. #harvest);
	  safeClick(harvest[i][0]+5, harvest[i][1]+5);
	end
    end
end


function closeAllWindows(x, y, width, height)
  if not x then
    x = 0;
  end
  if not y then
    y = 0;
  end
  if not width then
    width = srGetWindowSize()[0];
  end
  if not height then
    height = srGetWindowSize()[1];
  end

  local closeImages = {"ThisIs.png", "Ok.png", "UnPin.png"};
  local closeRight = {1, 1, nil};
  local found = true;

  while found do
    found = false;
    for i=1,#closeImages do

      local image = closeImages[i];
      local right = closeRight[i];
      srReadScreen();
      local images = findAllImagesInRange(image, x, y, width, height);
      while #images >= 1 do
	done = true;
	safeClick(images[#images][0], images[#images][1], right);
	sleepWithStatus(click_delay, "Closing Windows");
	srReadScreen();
	images = findAllImagesInRange(image, x, y, width, height);
      end
    end
  end
end



function clickAllText(textToFind)
	local allTextReferences = findAllText(textToFind);
	
	for buttons=1, #allTextReferences do
		srClickMouseNoMove(allTextReferences[buttons][0]+20, allTextReferences[buttons][1]+5, 1);
	end
end




function closeAllWindows2()
srReadScreen();
 UnPin = srFindImageInRange(0,0, size[0]-350, size[1]);

    if #UnPin > 1 then
		for i=#UnPin, 1, -1  do
			checkBreak();
			safeClick(UnPin[i][0], UnPin[i][1], 1);
		end
    end
end