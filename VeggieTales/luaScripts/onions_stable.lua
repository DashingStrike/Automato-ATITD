assert(loadfile("luaScripts/Flax_stable.lua"))();
plantType = ONIONS;

seedImage = "OnionSeeds.png";
waterImage = "WaterThese.png";
harvestImage = "HarvestThese.png";

walk_px_y = 170;
walk_px_x = 190;

function harvestAll(loop_count)
  for i=1,4 do
    srReadScreen();
    local waters = findAllImages(waterImage);
    for i=#waters,1,-1 do
      safeClick(waters[i][0] + 5, waters[i][1] + 5);
      lsSleep(click_delay);
    end
    sleepWithStatus(20000, "(" .. loop_count .. "/" .. num_loops
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
      lsSleep(click_delay);
    end
    local waters = findAllImages(waterImage);
    done = (#waters == 0);
    lsSleep(10);
    checkBreak();
  end
  sleepWithStatus(15000, "Harvesting");
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
  for y=-70,70 do
    for x=-70,70 do
      local passed = true;
      local vals;
      local current = 0;
      for i=1,#tests do
	vals = pixelDiffs(center[0] + x + tests[i][0],
			  center[1] + y + tests[i][1], green);
	current = vals[1]*vals[1] + vals[3]*vals[3]
	  + vals[2]*vals[2];
	if current > 250 then
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
