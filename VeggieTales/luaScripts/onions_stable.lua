assert(loadfile("luaScripts/Flax_stable.lua"))();
plantType = ONIONS;

--walk_px_y = 170;
--walk_px_x = 190;

walk_px_y = 140;  --Override flax default
walk_px_x = 170; --Override flax default

walk_time = 500; --Override flax default, allow a few ms more in case lag messed the walk. Less forgiving, by lag, on tight grids from onions vs flax.


 -- This is clicking each window very slow. So it dont do a double or triple watering animation on same plant (caused by clicking to fast)
-- Too many double or triple watering animations will steal some of the time. Just as long as it clicks all windows before you can walk from first to last plant is fine.

click_water_delay = 1400;


refresh_time = 200; --Override flax_stable default
click_delay = 150;


-- timing = 24000; --default
-- harvest_timing = 15000; --default



seedImage = "OnionSeeds.png";
waterImage = "WaterThese.png";
harvestImage = "HarvestThese.png";

function harvestAll(loop_count)

if grid_w < 4 then
set = "Small";
timing = 3000;
harvest_timing = 13000;
else
set = "Large";
timing = 0;
harvest_timing = 14000;
end


  for i=1,4 do
    srReadScreen();
    local waters = findAllImages(waterImage);
    for i=#waters,1,-1 do
--      safeClick(waters[i][0] + 5, waters[i][1] + 5);
      srClickMouse(waters[i][0] + 5, waters[i][1] + 5);
      statusScreen("[" .. i .. "] Watering plants...");
      lsSleep(click_water_delay);
    end

    sleepWithStatus(timing, "(" .. loop_count .. "/" .. num_loops
		    .. ") Waiting for growth");
  end
  local done = false;
  while not done do
    srReadScreen();
    clickAllImages("ThisIs.png");
    local harvests = findAllImages(harvestImage);
    for i=1,#harvests do
      safeClick(harvests[i][0], harvests[i][1]);
      lsSleep(click_delay);
      safeClick(harvests[i][0], harvests[i][1] - 15, 1);
      statusScreen("[" .. i .. "] Harvesting plants...");
      lsSleep(click_delay);
    end
    local waters = findAllImages(waterImage);
    done = (#waters == 0);
    lsSleep(10);
    checkBreak();
  end
--  sleepWithStatus(15000, "Harvesting");
    sleepWithStatus(harvest_timing, "Harvesting");


--Refresh plant window in case we used our last seed and plant window is now displaying a blank screen.
--srSetMousePos(plantX-7, plantY);
--lsSleep(100);
safeClick(plantX-7, plantY);


end

function searchForGreen(centerBad)
  local tests = {makePoint(0, 0), makePoint(0, 1), makePoint(0, -1),
		 makePoint(1, 0), makePoint(-1, 0), makePoint(-1, -1),
		 makePoint(-1, 1), makePoint(1, -1), makePoint(1, 1)};
  local center = makePoint(srGetWindowSize()[0]/2,
			   srGetWindowSize()[1]/2);
  lsPrintln("checkForGreen");
checkBreak();
--  local green = 0x4b7420;
--  local green = 0x557614;
  local green = 0x6c8516;
  local result = nil
  local closestMax = 65000;
  srReadScreen();

--70

  for y=-40,40 do
    for x=-35,35 do
      local passed = true;
      local vals;
      local current = 0;
      for i=1,#tests do
	vals = pixelDiffs(center[0] + x + tests[i][0],
			  center[1] + y + tests[i][1], green);
	current = vals[1]*vals[1] + vals[3]*vals[3]
	  + vals[2]*vals[2];
	if current > 1000 then
	  passed = false;
	  break;
	end
      end
      if passed then
--	if current < closestMax then
	  lsPrintln("New winner: " .. current .. "(" .. table.concat(vals, ", ") .. ")" .. "(" .. x .. ", " .. y .. ")");
	  closestMax = current;
	result = makePoint(center[0] + x, center[1] + y);
      end
    end
  end
  return result;
end

FooNothingBlah = [[
function promptFlaxNumbers()
  askForWindow("");
  initGlobals();
  walkTo(makePoint(1116, 7134));
  while true do
--    local mousePos = getMousePos();
--    local status = "Mouse: " .. mousePos[0] .. ", " .. mousePos[1] .. "\n";
--    status = status .. "xyFlaxMenu: " .. xyFlaxMenu[0] .. ", "
--      .. xyFlaxMenu[1] .. "\n";
--    status = status .. "xyCenter: " .. xyCenter[0] .. ", " .. xyCenter[1] .. "\n";
    local coords = findCoords();
    local status = "Coords: " .. coords[0] .. ", " .. coords[1] .. "\n";
    statusScreen(status);
    lsSleep(100);
  end
end
       ]];
