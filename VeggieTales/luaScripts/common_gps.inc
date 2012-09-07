function findCoords()
  lsPrintln("findCoords");
  local result = nil;
  local anchor = findText("2,");
  if(not anchor) then
    anchor = findText("3, ");
  end
  if(not anchor) then
    anchor = findText("Year");
  end
  if anchor then
    lsPrintln("anchor");
    local window = getWindowBorders(anchor[0], anchor[1]);
    local lines = findAllText(nil, window, NOPIN);
    for i=1,#lines do
      lsPrintln("LINE " .. i .. " : " .. table.concat(lines[i], ","));
    end
    local str = lines[#lines][2];
    lsPrintln("lines: " .. str);
    local a, b, x, y = string.find(str, ": ([0-9-]+)\, ([0-9-]+)");
    result = makePoint(tonumber(x), tonumber(y));
    if not result[0] or not result[1] then
      result = nil;
      lsPrintln("Failed to find coords");
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
  sleepWithStatus(500, "Walking...");
end


local ffc_coordsPos = nil;
local ffc_dash = -1;
local ffc_comma = -2;

function fastFindCoords()
	local pos;
	if(not ffc_coordsPos) then
		pos = srFindImage("Year.png",5000);
		if(not pos) then
			pos = findText("Year");
			if(not pos) then
				pos = findText("2, ");
				if(not pos) then
					pos = findText("3, ");
					if(not pos) then
						lsPrintln("fastFindCoords() : Can't find the clock");
						return nil;
					end
				end
			end
		end
		local window = getWindowBorders(pos[0], pos[1]);
		window.top = window.top + 13;
		window.y = window.y + 13;
		window.height = window.height - 13;
		window.bottom = window.y + window.height;
		pos = srFindImageInRange("colon.png", window.x, window.y, window.width, window.height,5000);
		if(not pos) then
			lsPrintln("fastFindCoords() : Can't find the colon on the second line of the clock");
			return nil;
		end
		window.width = window.width + window.x - pos[0] - 5;
		window.left = pos[0] + 5;
		window.x = pos[0] + 5;
		window.right = window.x + window.width;
		window.top = pos[1];
		window.y = window.top;
		window.height = window.bottom - window.top;
		ffc_coordsPos = window;
	end
	if(not ffc_coordsPos) then
		lsPrintln("fastFindCoords() : Can't find the coordinates");
		return nil;
	end
	
	local digits = ffc_readDigits(ffc_coordsPos);
	if(digits) then
		return ffc_parseDigits(digits);
	end
	return nil;
end

function ffc_parseDigits(digits)
	local x;
	local pos;
	x, pos = ffc_parseOneCoord(digits);
	local y;
	y, pos = ffc_parseOneCoord(digits,pos);
	if((not x) or (not y)) then
		if(not x) then
			lsPrintln("fastFindCoords() : x is nil");
		end
		if(not y) then
			lsPrintln("fastFindCoords() : y is nil");
		end
		return nil;
	end
	return makePoint(x,y);
end

function ffc_parseOneCoord(digits,pos)
	if(pos == nil) then
		pos = 1;
	end
	if(pos > #digits) then
		lsPrintln("ffc_parseOneCoord(): pos > #digits(" .. #digits .. ")");
		return nil, nil;
	end
	local negative = false;
	local val = 0;
	local i;
	for i=pos,#digits do
		if(digits[i][2] == ffc_comma) then
			if(negative) then
				val = val * -1;
			end
			return val, i+1;
		end
		if(digits[i][2] == ffc_dash) then
			negative = true;
		else
			val = val * 10 + digits[i][2];
		end
	end
	if(negative) then
		val = val * -1;
	end
	return val, #digits+1;
end

function ffc_readDigits(box)
	local digits = {};
	local i;
	for i=0,9 do
		local x = ffc_coordsPos.x;
		local pos = true;
		while((x < ffc_coordsPos.x + ffc_coordsPos.width - 6) and pos) do
			pos = srFindImageInRange(i .. ".png",x,ffc_coordsPos.y,ffc_coordsPos.width,ffc_coordsPos.height,5000);
			if(pos) then
				digits[#digits+1] = {pos[0],i};
				x = pos[0] + 7;
			end
		end
	end
	if(#digits < 2) then
		lsPrintln("ffc_readDigits() : Unable to read any digits");
		return nil;
	end
	local x = ffc_coordsPos.x;
	local pos = true;
	while(pos) do
		pos = srFindImageInRange("dash.png",x,ffc_coordsPos.y,ffc_coordsPos.width,ffc_coordsPos.height,5000);
		if(pos) then
			digits[#digits+1] = {pos[0],ffc_dash};
			x = x + 5;
		end
	end
	pos = srFindImageInRange("comma.png",ffc_coordsPos.x,ffc_coordsPos.y,ffc_coordsPos.width,ffc_coordsPos.height,5000);
	if(pos) then
		digits[#digits+1] = {pos[0],ffc_comma};
	end
	table.sort(digits, ffc_compareDigits);
	return digits;
end

function ffc_compareDigits(left,right)
	if(left[1] < right[1]) then
		return true;
	end
	return false;
end
