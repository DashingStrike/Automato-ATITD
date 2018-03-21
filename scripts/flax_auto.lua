-- flax_auto.lua v1.2 -- by Jimbly, tweaked by Cegaiel and
--   KasumiGhia, revised by Tallow, revised by Tripps
--
-- Plant and harvest seeds then plant and harvest flax, repeat
-- Draws water when needed, optionally rots flax, optionally 
-- stores products
--
-- Works Reliably: 2x2, 3x3, 4x4, 5x5
-- May Work (depends on your computer): 6x6, 7x7
--

dofile("ui_utils.inc");
dofile("common.inc");
dofile("settings.inc");
dofile("constants.inc");
dofile("screen_reader_common.inc");

askText = singleLine([[
  flax_auto v1.0 (by Jimbly, tweaked by Cegaiel and KasumiGhia,
  revised by Tallow, revised by Tripps) --
  Make sure the plant flax window is pinned and on the RIGHT side of
  the screen. Your Automato window should also be on the RIGHT side
  of the screen. You may need to F12 at low resolutions or hide your 
  chat window (if it starts planting and fails to move, it probably 
  clicked on your chat window). Will plant grid NE of current 
  location.  Will turn on 'Plant all crops where you stand' and 'Right 
  click pins/unpins a menu'. Will turn off 'Enable Hotkeys on flax'.
]]);

-- Global parameters set by prompt box.
num_loops = 5;
grid_w = 5;
grid_h = 5;
grid_direction = 1;
grid_directions = { "Northeast", "Northwest", "Southeast", "Southwest" };
grid_deltas = 
{
  { {1, 0, -1, 0}, {0, -1, 0, 1} },
  { {-1, 0, 1, 0}, {0, -1, 0, 1} },
  { {1, 0, -1, 0}, {0, 1, 0, -1} },
  { {-1, 0, 1, 0}, {0, 1, 0, -1} }
};
  
min_seeds = 0;
is_plant = true;
seeds_per_pass = 4;
seeds_per_harvest = 1;
rot_flax = false;
water_needed = false;
water_location = {};
water_location[0] = 0;
water_location[1] = 0;
store_flax = false;
storage_location = {};
storage_location[0] = 0;
storage_location[1] = 0;

-- How many seeds are left
seeds_in_pocket = 26;

imgFlax1 = "Flax:";
imgHarvest = "HarvestThisFlax.png";
imgWeedAndWater = "WeedAndWater.png";
imgWeed = "WeedThisFlaxBed.png";
imgSeeds = "HarvestSeeds.png";
imgUseable = "UseableBy.png";
imgThisIs = "ThisIs.png";
imgUtility = "Utility.png";
imgRipOut = "RipOut.png";
imgUnpin = "UnPin.png";
imgTheSeeds = "TheSeeds.png";
imgOK = "ok.png";
imgTearDownThis = "TearDownThis.png";
imgTearDown = "TearDown.png";
imgPlantWhereChecked = "PlantAllCropsWhereYouStandChecked.png";
imgPlantWhereUnchecked = "PlantAllCropsWhereYouStandUnchecked.png";
imgHotkeysOnFlax = "EnableHotkeysOnFlax.png";
imgOptionsX = "OptionsX.png";
imgRightClickPins = "RightClickPins.png";
imgSmallX = "smallX.png";

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

harvest_seeds_time = 1300;

FLAX = 0;
ONIONS = 1;
plantType = FLAX;

--warehouse_color = -1769769985;
--chest_color = 2036219647;
--tent_color = 1399546879;

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
-- checkForEnd()
--
-- Similar to checkBreak, but also looks for a clean exit.
-------------------------------------------------------------------------------

local ending = false;

function checkForEnd()
  if ((lsAltHeld() and lsControlHeld()) and not ending) then
    ending = true;
    setStatus("");
    cleanup();
    error "broke out with Alt+Ctrl";
  end
  if (lsShiftHeld() and lsControlHeld()) then
    if lsMessageBox("Break", "Are you sure you want to exit?", MB_YES + MB_NO) == MB_YES then
      error "broke out with Shift+Ctrl";
    end
  end
  if lsAltHeld() and lsShiftHeld() then
    -- Pause
    while lsAltHeld() or lsShiftHeld() do
      statusScreen("Please release Alt+Shift", 0x808080ff, false);
    end
    local done = false;
    while not done do
      local unpaused = lsButtonText(lsScreenX - 110, lsScreenY - 60,
                    z, 100, 0xFFFFFFff, "Unpause");
      statusScreen("Hold Alt+Shift to resume", 0xFFFFFFff, false);
      done = (unpaused or (lsAltHeld() and lsShiftHeld()));
    end
    while lsAltHeld() or lsShiftHeld() do
      statusScreen("Please release Alt+Shift", 0x808080ff, false);
    end
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
  scale = 1.1;
    
  local z = 0;
  local is_done = nil;
  local value = nil;
  -- Edit box and text display
  while not is_done do
    -- Make sure we don't lock up with no easy way to escape!
    checkBreak();

    local y = 5;

    lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);

    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Passes:");
    num_loops = readSetting("num_loops",num_loops);
    is_done, num_loops = lsEditBox("passes", 110, y, z, 50, 30, scale, scale,
                                   0x000000ff, num_loops);
    if not tonumber(num_loops) then
      is_done = nil;
      lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      num_loops = 1;
    end
    writeSetting("num_loops",num_loops);
    y = y + 32;

    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Grid size:");
    grid_w = readSetting("grid_w",grid_w);
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
    writeSetting("grid_w",grid_w);
    y = y + 32;
	
    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Plant to the:");
	grid_direction = readSetting("grid_direction",grid_direction);
	grid_direction = lsDropdown("grid_direction", 145, y, 0, 145, grid_direction, grid_directions);
	writeSetting("grid_direction",grid_direction);
    y = y + 32;

    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Seed harvests per bed:");
    seeds_per_pass = readSetting("seeds_per_pass",seeds_per_pass);
    is_done, seeds_per_pass = lsEditBox("seedsper", 250, y, z, 50, 30,
                                          scale, scale, 0x000000ff, seeds_per_pass);
    seeds_per_pass = tonumber(seeds_per_pass);
    if not seeds_per_pass then
      is_done = nil;
      lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      seeds_per_pass = 1;
    end
    writeSetting("seeds_per_pass",seeds_per_pass);
    y = y + 32;

    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Seeds per harvest:");
    seeds_per_harvest = readSetting("seeds_per_harvest",seeds_per_harvest);
    is_done, seeds_per_harvest = lsEditBox("seedsperharvest", 250, y, z, 50, 30,
                                          scale, scale, 0x000000ff, seeds_per_harvest);
    seeds_per_harvest = tonumber(seeds_per_harvest);
    if not seeds_per_harvest then
      is_done = nil;
      lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      seeds_per_harvest = 1;
    end
    writeSetting("seeds_per_harvest",seeds_per_harvest);
    y = y + 32;

    rot_flax = readSetting("rot_flax",rot_flax);
    rot_flax = lsCheckBox(10, y, z+10, 0xFFFFFFff, "Rot Flax", rot_flax);
    writeSetting("rot_flax",rot_flax);
    y = y + 32;

    water_needed = readSetting("water_needed",water_needed);
    water_needed = lsCheckBox(10, y, z+10, 0xFFFFFFff, "Flax requires water", water_needed);
    writeSetting("water_needed",water_needed);
    y = y + 32;
    
    if rot_flax or water_needed then
      lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Water coords:");
      water_location[0] = readSetting("water_locationX",water_location[0]);
      is_done, water_location[0] = lsEditBox("water_locationX", 165, y, z, 55, 30,
                                            scale, scale, 0x000000ff, water_location[0]);
      water_location[0] = tonumber(water_location[0]);
      if not water_location[0] then
        is_done = nil;
        lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        water_location[0] = 1;
      end
      writeSetting("water_locationX",water_location[0]);
      
      water_location[1] = readSetting("water_locationY",water_location[1]);
      is_done, water_location[1] = lsEditBox("water_locationY", 222, y, z, 55, 30,
                                            scale, scale, 0x000000ff, water_location[1]);
      water_location[1] = tonumber(water_location[1]);
      if not water_location[1] then
        is_done = nil;
        lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        water_location[1] = 1;
      end
      writeSetting("water_locationY",water_location[1]);
      y = y + 32;
    end

    store_flax = readSetting("store_flax",store_flax);
    store_flax = lsCheckBox(10, y, z+10, 0xFFFFFFff, "Store Flax", store_flax);
    writeSetting("store_flax",store_flax);
    y = y + 32;
    
    if store_flax then
      lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Storage coords:");
      storage_location[0] = readSetting("storage_locationX",storage_location[0]);
      is_done, storage_location[0] = lsEditBox("storage_locationX", 185, y, z, 55, 30,
                                            scale, scale, 0x000000ff, storage_location[0]);
      storage_location[0] = tonumber(storage_location[0]);
      if not storage_location[0] then
        is_done = nil;
        lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        storage_location[0] = 1;
      end
      writeSetting("storage_locationX",storage_location[0]);
    
      storage_location[1] = readSetting("storage_locationY",storage_location[1]);
      is_done, storage_location[1] = lsEditBox("storage_locationY", 242, y, z, 55, 30,
                                            scale, scale, 0x000000ff, storage_location[1]);
      storage_location[1] = tonumber(storage_location[1]);
      if not storage_location[1] then
        is_done = nil;
        lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        storage_location[1] = 1;
      end
      writeSetting("storage_locationY",storage_location[1]);
      y = y + 32 + 5;
    end

    if lsButtonText(10, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff, "OK") then
      is_done = 1;
    end

    if lsButtonText((lsScreenX - 100) * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end

    if is_done and (not num_loops or not grid_w) then
      error 'Canceled';
    end
        
    lsDoFrame();
    lsSleep(tick_delay);
  end

  min_seeds = grid_w*grid_h+1;
end

------------------------------------------------------------------------------
-- promptSeeds()
-------------------------------------------------------------------------------

function promptSeeds()
  scale = 1.1;
    
  local z = 0;
  local is_done = nil;
  local value = nil;
  -- Edit box and text display
  while not is_done do
    -- Make sure we don't lock up with no easy way to escape!
    checkBreak();

    local y = 5;

    lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);

    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "How many seeds are you");
    y = y + 32;
    lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "starting with (minimum " .. min_seeds .. ")?");
    y = y + 32;
    seeds_in_pocket = readSetting("seeds_in_pocket",seeds_in_pocket);
    is_done, seeds_in_pocket = lsEditBox("seeds_in_pocket", 110, y, z, 50, 30, scale, scale,
                                   0x000000ff, seeds_in_pocket);
    seeds_in_pocket = tonumber(seeds_in_pocket);
    if not seeds_in_pocket then
      is_done = nil;
      lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      seeds_in_pocket = min_seeds;
    elseif seeds_in_pocket < min_seeds then
      is_done = nil;
      lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE AT LEAST " .. min_seeds);
      seeds_in_pocket = min_seeds;
    end
    writeSetting("seeds_in_pocket",seeds_in_pocket);
    y = y + 32;
	
	y = y + 32;
	lsPrintWrapped(5, y, z, lsScreenX - 10, scale, scale, 0xD0D0D0ff, 
	  "This macro will grow seeds as needed.  Any extra seeds beyond the " ..
	  min_seeds .. " minimum will be used before growing more seeds.");
	y = y + 128;

    if lsButtonText(10, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff, "OK") then
      is_done = 1;
    end

    if lsButtonText((lsScreenX - 100) * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(tick_delay);
  end
end

------------------------------------------------------------------------------
-- getPlantWindowPos()
-------------------------------------------------------------------------------

lastPlantPos = null;
seedImage = imgFlax1;

function getPlantWindowPos()
  srReadScreen();
  local plantPos = findText(seedImage);
  if plantPos then
    plantPos[0] = plantPos[0] + 10;
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
-- setStatus(msg)
--
-- Use this to set the current status so that the instructions remain on the 
-- screen.
-------------------------------------------------------------------------------

function setStatus(message)
  if not message then
    message = "";
  end
  local color = 0xFFFFFFff;
  local allow_break = true;
  lsPrintWrapped(10, 80, 0, lsScreenX - 20, 0.8, 0.8, color, message);
  lsPrintWrapped(10, lsScreenY-100, 0, lsScreenX - 20, 0.8, 0.8, 0xffd0d0ff,
         error_status);
  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,
          0xFFFFFFff, "End script") then
    error(quit_message);
  end
  if allow_break then
    lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,
        "Hold Ctrl+Alt to cleanup and end.");
    lsPrint(10, 24, 0, 0.7, 0.7, 0xB0B0B0ff,
        "Hold Ctrl+Shift to end this script.");
    if allow_pause then
      lsPrint(10, 38, 0, 0.7, 0.7, 0xB0B0B0ff,
          "Hold Alt+Shift to pause this script.");
    end
    checkForEnd();
  end
  lsSleep(tick_delay);
  lsDoFrame();
end

-------------------------------------------------------------------------------
-- doit()
-------------------------------------------------------------------------------

function doit()
  promptFlaxNumbers();
  promptSeeds();
  if water_needed then
    if not promptOkay("Make sure you have enough water in jugs to grow " .. 
      (grid_w*grid_h) .. " flax beds and make sure the plant menu is pinned.") then
	  error("User pressed cancel.");
	end
  else
    if not promptOkay("Make sure the plant menu is pinned.") then
	  error("User pressed cancel.");
	end
  end
  askForWindow(askText);
  initGlobals();
  local startPos = findCoords();
  if not startPos then
    error("ATITD clock not found. Verify entire clock and borders are visible. Try moving clock slightly.");
  end
  local tops = findAllImages(imgThisIs);
  if #tops > 0 then
    error("Only the Plant menu should be pinned.");
  end

  getPlantWindowPos();
  prepareOptions();
  prepareCamera();
  
  drawWater();
  local beds_per_loop = grid_w*grid_h;
  for loop_count=1, num_loops do
    is_plant = (seeds_in_pocket >= min_seeds + beds_per_loop);
	local planting = "false";
	if is_plant then
	  planting = "true";
	end
	lsPrintln("is_plant == (" .. seeds_in_pocket .. " >= " .. min_seeds .. " + " .. beds_per_loop .. ") == " .. planting);
    error_status = "";
    local finalPos = plantAndPin(loop_count);
    dragWindows(loop_count);
    harvestAll(loop_count);
    closeAllFlaxWindows();
    setStatus("(" .. loop_count .. "/" .. num_loops .. ") Walking...");
    if is_plant and (water_needed or rot_flax) then
      lsPrintln("doit(): Walking to the water at (" .. water_location[0] .. ", " .. water_location[1] .. ")");
      walk(water_location,false);
      if water_needed then
        drawWater();
        lsSleep(150);
        clickMax(); -- Sometimes drawWater() misses the max button
      end
      if rot_flax then
        rotFlax();
      end
      setStatus("(" .. loop_count .. "/" .. num_loops .. ") Walking...");
    end
    if is_plant and store_flax then -- This should be done after rotting flax
      lsPrintln("doit(): Walking to the storage location at (" .. storage_location[0] .. ", " .. storage_location[1] .. ")");
      walk(storage_location,true);
      storeFlax();
      setStatus("(" .. loop_count .. "/" .. num_loops .. ") Walking...");
    end
    lsPrintln("doit(): Walking to the starting location at (" .. startPos[0] .. ", " .. startPos[1] .. ")");
    walk(startPos,false);
    is_plant = true;
  end
  lsPlaySound("Complete.wav");
end

-------------------------------------------------------------------------------
-- cleanup()
--
-- Tears out any remaining beds and unpins menus.
-------------------------------------------------------------------------------

function cleanup()
  local tops = findAllImages(imgThisIs);
  if #tops > 0 then
    for i=1,#tops do
      ripOut(tops[i]);
    end
  end
end

-------------------------------------------------------------------------------
-- rotFlax()
--
-- Rots flax in water.  Requires you to be standing near water already.
-------------------------------------------------------------------------------

function rotFlax()
  centerMouse();
  local escape = "\27";
  local pos = nil;
  while(not pos) do
	lsSleep(refresh_time);
	srKeyEvent(escape);
	lsSleep(refresh_time);
	srReadScreen();
	pos = findText("Skills...");
  end
  clickText(pos);
  lsSleep(refresh_time);
  srReadScreen();
  local pos = findText("Rot flax");
  if pos then
    clickText(pos);
	lsSleep(refresh_time);
	srReadScreen();
    if not clickMax() then
      fatalError("Unable to find the Max button.");
    end
  end
end

-------------------------------------------------------------------------------
-- storeFlax()
--
-- Stores flax in a storage container such as a wharehouse, chest, or tent.
-- Requires you to be standing next to the storage container.
-- storeFlax() checks frist for a pinned menu otherwise it clicks the nearest 
-- pixel of the proper color. Given the large coordinate size in Egypt, 
-- positioning is not very accurate.  You should only have one storage 
-- container near where you are standing.
-------------------------------------------------------------------------------

function storeFlax()
  setStatus("Storing flax");
  local types = { "Flax (", "Rotten Flax", "Insect..." };
  stash(types);
  setStatus("");
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
--  local dx={1, 0, -1, 0};
--  local dy={0, -1, 0, 1};
  local i;
  local dx = {};
  local dy = {};
  for i=1, 4 do
	dx[i] = grid_deltas[grid_direction][1][i];
    dy[i] = grid_deltas[grid_direction][2][i];
  end
  local num_at_this_length = 3;
  local x_pos = 0;
  local y_pos = 0;
  local success = true;

  for y=1, grid_h do
    for x=1, grid_w do
      setStatus("(" .. loop_count .. "/" .. num_loops .. ") Planting " ..
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
    checkForEnd();
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
    seeds_in_pocket = 0;
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
  lsSleep(click_delay);

  local plantSuccess = waitForChange(spot, 1500);
  if not plantSuccess then
    error_status = "No flax bed was placed when planting.";
    result = nil;
  end
  seeds_in_pocket = seeds_in_pocket - 1;

  return result;
end

-------------------------------------------------------------------------------
-- dragWindows(loop_count)
--
-- Move flax windows into a grid on the screen.
-------------------------------------------------------------------------------

function dragWindows(loop_count)
  setStatus("(" .. loop_count .. "/" .. num_loops .. ")  " ..
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
  local tops = findAllImages(imgThisIs);
  local max = #tops;
  while not did_harvest do
    -- Monitor for Weed This/etc
    lsSleep(refresh_time);
    srReadScreen();
    tops = findAllImages(imgThisIs);
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

    setStatus("(" .. loop_count .. "/" .. num_loops ..
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
      local oks = srFindImage(imgOK,5000);
      while oks do
        safeClick(oks[0],oks[1]);
        lsSleep(100);
        oks = srFindImage(imgOK);
      end
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
          local harvested = false;
          local lastClick = 0;
          while not harvested do
            if seedPos and lsGetTimer() > lastClick + 1500 then
              safeClick(seedPos[0] + 5, seedPos[1]);
              lastClick = lsGetTimer();
              lsSleep(100);
            end
              safeClick(tops[#tops - seedIndex + 1][0],
                     tops[#tops - seedIndex + 1][1]);
            lsSleep(100);
            srReadScreen();
            seedPos = srFindImageInRange(imgTheSeeds,
                     tops[#tops - seedIndex + 1][0],
                     tops[#tops - seedIndex + 1][1],
                     160, 100);
            if seedPos then
              harvested = true;
            else
              seedPos = srFindImageInRange(imgSeeds,
                       tops[#tops - seedIndex + 1][0],
                       tops[#tops - seedIndex + 1][1],
                       160, 100);
            end
            checkForEnd();
          end
          seedIndex = seedIndex + 1;
          seeds_in_pocket = seeds_in_pocket + seeds_per_harvest;
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
    checkForEnd();
  end
  -- Wait for last flax bed to disappear
  sleepWithStatus(2500, "(" .. loop_count .. "/" .. num_loops ..
          ") ... Waiting for flax beds to disappear");
end

-------------------------------------------------------------------------------
-- walkHome(loop_count, finalPos)
--
-- Walk back to the origin (southwest corner) to start planting again.
-------------------------------------------------------------------------------

function walkHome(loop_count, finalPos)
  closeAllFlaxWindows();
  setStatus("(" .. loop_count .. "/" .. num_loops .. ") Walking...");
  walk(finalPos,false);

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
  setStatus("Ripping Out");
  lsSleep(refresh_time);
  srReadScreen();
  local util_menu = srFindImageInRange(imgUtility, pos[0] - 10, pos[1] - 50,
                                       180, 200, 5000);
  if util_menu then
    safeClick(util_menu[0] + 5, util_menu[1], 0);
    local rip_out = waitForImage(imgRipOut, refresh_time);
    if rip_out then
      safeClick(rip_out[0] + 5, rip_out[1], 0);
      lsSleep(refresh_time);
      safeClick(pos[0], pos[1], 1); -- unpin
      lsSleep(refresh_time);
    else
      rip_out = srFindImage(imgTearDownThis);
      if rip_out then
        safeClick(rip_out[0] + 5, rip_out[1], 0);
        lsSleep(refresh_time);
        srReadScreen();
        rip_out = nil;
        while not rip_out do
          checkBreak();
          rip_out = srFindImage(imgTearDown);
          if rip_out then
            safeClick(rip_out[0], rip_out[1]);
          end
          lsSleep(refresh_time);
          srReadScreen();
        end
      end
      safeClick(pos[0],pos[1],true);
      lsSleep(refresh_time);
      srReadScreen();
    end
  end
end

-------------------------------------------------------------------------------
-- walk(dest,abortOnError)
--
-- Walk to dest while checking for menus caused by clicking on objects.
-- Returns true if you have arrived at dest.
-- If walking around brings up a menu, the menu will be dismissed.
-- If abortOnError is true and walking around brings up a menu, 
-- the function will return.  If abortOnError is false, the function will
-- attempt to move around a little randomly to get around whatever is in the
-- way.
-------------------------------------------------------------------------------

function walk(dest,abortOnError)
  centerMouse();
  srReadScreen();
  local coords = findCoords();
  local startPos = coords;
  local failures = 0;
  while coords[0] ~= dest[0] or coords[1] ~= dest[1] do
    centerMouse();
    local dx = 0;
    local dy = 0;
    if coords[0] < dest[0] then
      dx = 1;
    elseif coords[0] > dest[0] then
      dx = -1;
    end
    if coords[1] < dest[1] then
      dy = -1;
    elseif coords[1] > dest[1] then
      dy = 1;
    end
    lsPrintln("Walking from (" .. coords[0] .. "," .. coords[1] .. ") to (" .. dest[0] .. "," ..dest[1] .. ") stepping to (" .. dx .. "," .. dy .. ")");
    stepTo(makePoint(dx, dy));
	srReadScreen();
    coords = findCoords();
    checkForEnd();
    if checkForMenu() then
	  if(coords[0] == dest[0] and coords[1] == dest[1]) then
	    return true;
	  end
      if abortOnError then
        return false;
      end
      failures = failures + 1;
      if failures > 50 then
        return false;
      end
	  lsPrintln("Hit a menu, moving randomly");
      stepTo(makePoint(math.random(-1,1),math.random(-1,1)));
	  srReadScreen();
    else
      failures = 0;
    end
  end
  return true;
end

function walkOld(dest,abortOnError)
  centerMouse();
  local coords = findCoords();
  local startPos = coords;
  local failures = 0;
  srReadScreen();
  while coords[0] ~= dest[0] or coords[1] ~= dest[1] do
    while coords[0] < dest[0] do
      centerMouse();
      stepTo(makePoint(1, 0));
      coords = findCoords();
      checkForEnd();
      if checkForMenu() then
        if abortOnError then
          return false;
        end
        failures = failures + 1;
        if failures > 50 then
            return false;
        end
        stepTo(makePoint(math.random(-1,0),math.random(-1,1)));
      else
        failures = 0;
      end
    end
    while coords[0] > dest[0] do
      centerMouse();
      stepTo(makePoint(-1, 0));
      coords = findCoords();
      checkForEnd();
      if checkForMenu() then
        if abortOnError then
          return false;
        end
        failures = failures + 1;
        if failures > 50 then
            return false;
        end
        stepTo(makePoint(math.random(0,1),math.random(-1,1)));
      else
        failures = 0;
      end
    end
    while coords[1] < dest[1] do
      centerMouse();
      stepTo(makePoint(0, -1));
      coords = findCoords();
      checkForEnd();
      if checkForMenu() then
        if abortOnError then
          return false;
        end
        failures = failures + 1;
        if failures > 50 then
            return false;
        end
        stepTo(makePoint(math.random(-1,1),math.random(0,1)));
      else
        failures = 0;
      end
    end
    while coords[1] > dest[1] do
      centerMouse();
      stepTo(makePoint(0, 1));
      coords = findCoords();
      checkForEnd();
      if checkForMenu() then
        if abortOnError then
          return false;
        end
        failures = failures + 1;
        if failures > 50 then
            return false;
        end
        stepTo(makePoint(math.random(-1,1),math.random(-1,0)));
      else
        failures = 0;
      end
    end
  end
  return true;
end

function checkForMenu()
  srReadScreen();
  pos = srFindImage("unpinnedPin.png", 5000);
  if pos then
    safeClick(pos[0]-5,pos[1]);
    lsPrintln("checkForMenu(): Found a menu...returning true");
    return true;
  end
  return false;
end

-------------------------------------------------------------------------------
-- pixelBlockCheck(x, y, color, rgbTol, hueTol, size)
--
-- Checks for a block of pixels centered on (x, y), within radius size
-- matching color within the tolerances rgbTol and hueTol
-------------------------------------------------------------------------------

function pixelBlockCheck(x, y, color, rgbTol, hueTol, size)
    local startX = x - size;
    local startY = y - size;
    local endX = x + size;
    local endY = y + size;
    local i;
    for i = startX, endX do
        local j;
        for j = startY, endY do
            local currColor = srReadPixelFromBuffer(x, y);
            if(not compareColorEx(color,currColor,rgbTol,hueTol)) then
                return false;
            end
        end
    end
    return true;
end

-------------------------------------------------------------------------------
-- clickMax()
--
-- Waits for and then click the Max button
-------------------------------------------------------------------------------

function clickMax()
  local pos = srFindImage("crem-max.png", 1000);
  if pos then
    safeClick(pos[0]+5, pos[1]+5);
    return true;
  end
  return false;
end

-------------------------------------------------------------------------------
-- centerMouse()
--
-- Moves the mouse to the center of the screen
-------------------------------------------------------------------------------

function centerMouse()
  local xyWindowSize = srGetWindowSize();
  local mid = {};
  mid[0] = xyWindowSize[0] / 2;
  mid[1] = xyWindowSize[1] / 2;
  srSetMousePos(mid[0],mid[1]);
end

function prepareCamera()
	statusScreen("Configuring camera");
    characterMenu();
    local pos = findText("Options...");
    if(pos) then
        offsetClick(pos,8);
	  lsSleep(100);
        pos = findText("Camera");
        if(pos) then
            offsetClick(pos,8);
	      lsSleep(100);
            pos = findText("Cartographer's Cam");
            if(pos) then
                offsetClick(pos,8);
		   lsSleep(100);
                pos = srFindImage("ok-faint.png");
                if(pos) then
                    offsetClick(pos);
                else
                    error("Unable to find the Ok button.");
                end
            else
                error("Unable to find the Cartographer's Cam item.");
            end
        else
            error("Unable to find the Camera menu item.");
        end
    else
        error("Unable to find the Options menu item.");
    end
	lsSleep(150);
    srReadScreen();
    pos = findText("Year");
    if(pos) then
		offsetClick(pos);
	else
--        error("Unable to find the clock.");
    end
    srSetMousePos(100,-20);
    sleepWithStatus(10000,"Zooming in");
    statusScreen("");
end

function prepareOptions()
	statusScreen("Checking and setting avatar options");
  
    characterMenu();
    local pos = findText("Options...");
    if(pos) then
        offsetClick(pos,8);
	  lsSleep(100);
        pos = findText("One-Click");
        if(pos) then
            offsetClick(pos,8);
	      lsSleep(100);
            pos = srFindImage(imgPlantWhereChecked,5000);
            if(not pos) then
                pos = srFindImage(imgPlantWhereUnchecked,5000);
                if(pos) then
                    offsetClick(pos,4);
                end
            end
            pos = srFindImage(imgHotkeysOnFlax,5000);
            if(pos) then
                offsetClick(pos,4);
	  	   lsSleep(100);
            end
            pos = srFindImage(imgOptionsX,5000);
            if(pos) then
                srClickMouse(pos[0]+24,pos[1]+9); -- close options window
                lsSleep(500);
                srReadScreen();
            end
        end
    end
    characterMenu();
    local pos = findText("Options...");
    if(pos) then
        offsetClick(pos,8);
        pos = findText("Interface Options");
        if(pos) then
            offsetClick(pos,8);
            pos = srFindImage(imgRightClickPins,5000);
            if(pos) then
                offsetClick(pos,4);
            end
        end
        pos = srFindImage(imgSmallX,5000);
        if(pos) then
            offsetClick(pos,4);
        end
    end
	statusScreen("");
end

function offsetClick(pos,offset)
    if(offset == nil) then
        offset = 4;
    end
    srClickMouse(pos[0]+offset,pos[1]+offset);
    lsSleep(150);
    srReadScreen();
end

function characterMenu()
	centerMouse();
    lsSleep(150);
    local escape = "\27";
    srKeyEvent(escape);
    lsSleep(150);
    srReadScreen();
end

-------------------------------------------------------------------------------
-- closeAllFlaxWindows()
--
-- Close all open flax windows and many others, but not the plant window.
--
-------------------------------------------------------------------------------

function closeAllFlaxWindows()
  x = 0;
  y = 0;
  width = srGetWindowSize()[0];
  height = srGetWindowSize()[1];

  local closeImages = {"ThisIs.png", "Ok.png"};
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
	    sleepWithStatus(200, "Closing Windows");
	    srReadScreen();
	    images = findAllImagesInRange(image, x, y, width, height);
      end
    end
  end
  safeClick(width/2-45,height/2-45);
end


