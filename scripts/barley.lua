-- barley.lua v2.1.3 -- by Cegaiel (but based off flax_stable.lua; credits of flax_stable.lua to Jimbly KasumiGhia, Tallow, SkyFeather)
--
-- Use Fertilizer will use 4 fertilizer per plant.  The yield will vary from 2-10. The numbers just depends on how many weeds occur before harvesting. 
-- If you are 'lucky' enough to not get any weeds on a plant, you will get the full 10. But with weeds, you will get 2-5 on average, usually 3-5.
-- Once the final tick occurs, you will see some plants that change from 'Barley: Growing' to 'Barley: Harvest'. Those are the ones you get 10 barley from.
-- If they still say 'Barley: Growing' then that means you got a weed. At this point, there is no point on continuing and harvest them all.
-- No this macro is not written to use Weed Killer.  This is pretty much gamble. Either you will get the full 10 (no weeds) or you will get less. But 98% of the time you will get more than 2, for sure.
--
-- Use Water Only will use 4 waters per plant and harvest. You will get a guaranteed 2 barley per plant, regardless if weeds occur or not.

dofile("common.inc");
dofile("settings.inc");

askText = "Barley v2.1.3 by Cegaiel (many credits included in script comments)\n\nTwo methods available: Use Fertilizer or Water Only. See comments for more info.\n\n'Right click pins/unpins a menu' must be ON.\n\n'Plant all crops where you stand' must be ON.\n\n'Right click pins/unpins a menu' must be ON.\n\nPin Barley Plant window in TOP-RIGHT. Automato: Slighty in TOP-RIGHT.";


-- Global parameters set by prompt box.
num_loops = 1;
grid_w = 4;
grid_h = 4;
is_plant = true;
seeds_per_pass = 5;
seeds_per_iter = 0;
finish_up = 0;
finish_up_message = "";
use_fert = true;
waterGap = true;

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
--window_h = 233; -- for Guilded plants
window_h = 218


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
  xyFlaxMenu[0] = xyCenter[0] - 43*pixel_scale;
  xyFlaxMenu[1] = xyCenter[1] + 0;
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
    num_loops = readSetting("num_loops",num_loops);
    is_done, num_loops = lsEditBox("passes", 120, y, z, 50, 30, scale, scale,
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
    is_done, grid_w = lsEditBox("grid", 120, y, z, 50, 30, scale, scale,
                                0x000000ff, grid_w);
    if not tonumber(grid_w) then
      is_done = nil;
      lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      grid_w = 1;
      grid_h = 1;
    end
    writeSetting("grid_w",grid_w);
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

    if is_plant then
      -- Will plant and harvest flax
      --window_w = 285; 

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end

    y = y + 55;
      lsSetCamera(0,0,lsScreenX*1.5,lsScreenY*1.5);
      use_fert = readSetting("use_fert",use_fert);
	if use_fert then
    	  use_fert = lsCheckBox(10, y+10, z, 0xff8080ff, " Use Fertilizer (Uncheck for Water Only)", use_fert);
	else
    	  use_fert = lsCheckBox(10, y+10, z, 0x8080ffff, " Use Water Only (Check for Fertilizer)", use_fert);
	end
      writeSetting("use_fert",use_fert);
      waterGap = readSetting("waterGap",waterGap);
    	  waterGap = lsCheckBox(10, y+40, z, 0xffffffff, " Leave Water Gap (Pin windows lower)", waterGap);
      writeSetting("waterGap",waterGap);
    	  lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);

	if use_fert then
        lsPrintWrapped(10, y+10, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
                     "Plant/Harvest a " .. grid_w .. "x" ..
                     grid_w .. " grid of " .. seedType .. " " .. num_loops ..
                     " times\n\nRequires:\n(" .. math.floor(grid_w * grid_w * num_loops) .. ") Barley\n(" .. math.floor(grid_w * grid_w * num_loops*totalWater) .. ") Water\n(" .. math.floor(grid_w * grid_w * num_loops*totalFertilizer) .. ") Fertilizer\n\nYields: 2-10 per plant (10 = no weeds)\n+10 x each Worship test passed");
	else
        lsPrintWrapped(10, y+10, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
                     "Plant/Harvest a " .. grid_w .. "x" ..
                     grid_w .. " grid of " .. seedType .. " " .. num_loops ..
                     " times\n\nRequires:\n(" .. math.floor(grid_w * grid_w * num_loops) .. ") Barley\n(" .. math.floor(grid_w * grid_w * num_loops*4) .. ") Water\n\nYields: 2 per plant\n+10 x each Worship test passed");

	end
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
    error 'Could not find \'Barley\' on plant window';
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

  size = srGetWindowSize();
  totalWater = 7;
  totalFertilizer = 4;

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

  if not use_fert then
    totalWater = 4;
    totalFertilizer = 0;
  end





  for loop_count=1, num_loops do
    ticks = -1;
    fertilizerUsed = 0;
    waterUsed = 0;
    quit = false;
    error_status = "";
    clicks = {};
    local finalPos = plantAndPin(loop_count);
    dragWindows(loop_count);
    statusScreen("Adding 2 Water/Fertilizer ...",nil, 0.7, 0.7);
    waterBarley(); -- Do initial 2 water
    fertilizeBarley(); -- Do initial 2 fertilizer
    lsSleep(100);
    barleyWaterBar = true;
    firstWater = 1;


  while 1 do
    checkBreak();
    findWaterBar();

	if not barleyWaterBar then
	  ticks = ticks + 1;
		if ticks+2 <= totalWater then
	  	  waterBarley();
		end

		if ticks+2 <= totalFertilizer then
	  	  fertilizeBarley();
		end
			if (ticks < totalWater - 1) and ticks ~= 0 then
		  	  sleepWithStatus(1000, "Tended Barley...",nil, 0.7, 0.7);
			end
      end


	if ticks == totalWater - 1 then
	    break;
	end

	if finish_up == 0 then
		if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Finish up") then
	  	  finish_up = 1;
	  	  finish_up_message = "\n\nFinishing up ..."
		end
	else
		if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0x80ff80ff, "Undo") then
	  	  finish_up = 0;
	  	  finish_up_message = ""
		end
	end

  statusScreen("Watching top-left window for tick ...\n\nTicks since planting: " .. ticks .. "/" .. totalWater - 1 .. "\n\n[" .. waterUsed .. "/" .. totalWater*goodPlantings .. "]  Jugs of Water Used "  .. "\n[" .. fertilizerUsed .. "/" .. totalFertilizer*goodPlantings .. "]  Fertilizer Used\n\n[" .. loop_count .. "/" .. num_loops .. "]  Current Pass\n\nElapsed Time: " .. getElapsedTime(startTime) .. finish_up_message,nil, 0.7, 0.7);

  lsSleep(100);
  end -- while

  sleepWithStatus(1000, "PLANT READY FOR HARVEST!\n\nTicks since planting: " .. ticks .. "/" .. totalWater - 1 .. "\n\n[" .. waterUsed .. "/" .. totalWater*goodPlantings .. "]  Jugs of Water Used "  .. "\n[" .. fertilizerUsed .. "/" .. totalFertilizer*goodPlantings .. "] Fertilizer Used\n\n[" .. loop_count .. "/" .. num_loops .. "]  Current Pass\n\nElapsed Time: " .. getElapsedTime(startTime) .. finish_up_message,nil, 0.7, 0.7);

  harvestAll();

  sleepWithStatus(7000, "Harvested " .. #harvest .. " plants!\n\nWaiting for windows to catch up!\n\nPreparing to close windows ...\n\nElapsed Time: " .. getElapsedTime(startTime) .. finish_up_message,nil, 0.7, 0.7);
  srReadScreen();
  clickAllText("This is"); -- Right click to close all windows in range
  lsSleep(1000);

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
  goodPlantings = 0;

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

   goodPlantings = goodPlantings + 1; 

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
    arrangeStashed(nil, waterGap, window_w, window_h);
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
			waterUsed = waterUsed + 1;
			--lsSleep(10);
				if firstWater == 0 then
				  safeClick(barleyWaterImage[i][0]+192, barleyWaterImage[i][1]+3);
				  waterUsed = waterUsed + 1;
				end
		end
    end
end


function fertilizeBarley()
  srReadScreen();
  barleyWaterImage = findAllImages("barleyWater.png");
    if #barleyWaterImage == 0 then
      error("Could not find 'Water:' text in barley pinned menu (Top Left corner only)");
    elseif use_fert then
		for i=#barleyWaterImage, 1, -1  do
			checkBreak();
			safeClick(barleyWaterImage[i][0]+192, barleyWaterImage[i][1]+23);
			fertilizerUsed = fertilizerUsed + 1;
			--lsSleep(10);
				if firstWater == 0 then
				  safeClick(barleyWaterImage[i][0]+192, barleyWaterImage[i][1]+23);
				  fertilizerUsed = fertilizerUsed + 1;
				end
		end
    end
end


function findWaterBar()
  srReadScreen();
  barleyWaterBar = srFindImageInRange("barleyWaterFull.png", 0, 0, window_w, window_h);
  if barleyWaterBar then
    safeClick(barleyWaterBar[0], barleyWaterBar[1]);
    --lsSleep(10);
    safeClick(barleyWaterBar[0], barleyWaterBar[1]);
  end
end



function harvestAll()
  harvest = findAllImages("BarleyHarvest.png");
    if #harvest == 0 then
       error("No harvet images found");
    else
	for i=#harvest, 1, -1  do
	  safeClick(harvest[i][0]+5, harvest[i][1]+5);
	  lsSleep(100);
	end
    end
end


function clickAllText(textToFind)
	local allTextReferences = findAllText(textToFind);
	for buttons=1, #allTextReferences do
		srClickMouseNoMove(allTextReferences[buttons][0]+20, allTextReferences[buttons][1]+5, 1);
		lsSleep(10)
	end
end
