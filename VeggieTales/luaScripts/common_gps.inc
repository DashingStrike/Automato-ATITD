function findCoords()
  lsPrintln("findCoords");
  local result = nil;
  local anchor = findText("2,");
  if anchor then
    lsPrintln("anchor");
    local window = getWindowBorders(anchor[0], anchor[1]);
    local lines = findAllText(nil, window, NOPIN);
    if #lines == 2 then
      local str = lines[2][2];
      lsPrintln("lines: " .. str);
      local a, b, x, y = string.find(str, ": ([0-9-]+)\, ([0-9-]+)");
      result = makePoint(tonumber(x), tonumber(y));
    end
  end
  return result;
end

function walkTo(dest)
  local coords = findCoords();
  while coords[0] ~= dest[0] or coords[1] ~= dest[1] do
    while coords[0] < dest[0] do
      stepTo(makePoint(1, 0));
      coords = findCoords();
      checkBreak();
    end
    while coords[0] > dest[0] do
      stepTo(makePoint(-1, 0));
      coords = findCoords();
      checkBreak();
    end
    while coords[1] < dest[1] do
      stepTo(makePoint(0, -1));
      coords = findCoords();
      checkBreak();
    end
    while coords[1] > dest[1] do
      stepTo(makePoint(0, 1));
      coords = findCoords();
      checkBreak();
    end
  end
  return coords;
end

local gpsInit = false;
local gpsCenter;
local gpsStep;

function initStep()
  if not gpsInit then
    srReadScreen();
    gpsInit = true;
    -- Macro written with 1720 pixel wide window

    xyWindowSize = srGetWindowSize();

    local pixel_scale = xyWindowSize[0] / 1720;
    lsPrintln("pixel_scale " .. pixel_scale);

    gpsStep = makePoint(340*pixel_scale, 380*pixel_scale);

    local walk_x_drift = 14;
    local walk_y_drift = 18;
    if (lsScreenX < 1280) then 
      -- Have to click way off center in order to not move at high resolutions
      walk_x_drift = math.floor(walk_x_drift * pixel_scale);
      walk_y_drift = math.floor(walk_y_drift * pixel_scale);
    else
      -- Very little drift at these resolutions, clicking dead center
      -- barely moves
      walk_x_drift = 1;
      walk_y_drift = 1;
    end

    gpsCenter = makePoint(xyWindowSize[0] / 2 - walk_x_drift,
			  xyWindowSize[1] / 2 + walk_y_drift);
  end
end

function stepTo(dir)
  initStep();
  safeClick(gpsCenter[0] + dir[0] * gpsStep[0],
	    gpsCenter[1] + dir[1] * gpsStep[1]);
  sleepWithStatus(500, "Walking");
end
