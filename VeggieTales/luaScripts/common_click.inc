-- common_click.inc
--
-- Common utility functions for clicking or other mouse actions
--
-- DO NOT INCLUDE THIS FILE! Include common.inc instead
--

-------------------------------------------------------------------------------
-- drag(sourceX, sourceY, destX, destY, timeout)
--
-- Drag the mouse from (sourceX, sourceY) to (destX, destY)
-------------------------------------------------------------------------------

function drag(sourceX, sourceY, destX, destY)
  if not sourceX or not sourceY or not destX or not destY then
    error("Incorrect number of arguments for drag()");
  end
  if not timeout then
    timeout = 500;
  end
  local spot = getWaitSpot(destX, destY);
  srSetMousePos(sourceX, sourceY);
  srMouseDown(sourceX, sourceY, 0);
  srSetMousePos(destX, destY);
  local result = waitForChange(spot, timeout);
  srMouseUp(destX, destY, 0);
  return result;
end

-------------------------------------------------------------------------------
-- safeBegin()
--
-- Call this just before a click or a drag to make sure the user isn't
-- moving the mouse or clicking it. Reduces the chances of interference.
-------------------------------------------------------------------------------

function safeBegin()
  local oldX = 0;
  local oldY = 0;
  oldX, oldY = srMousePos();
  local at_rest = false;
  local loopCount = 0;
  while not at_rest do
    lsSleep(tick_time);
    local currentX = 0;
    local currentY = 0;
    currentX, currentY = srMousePos();
    at_rest = (currentX == oldX and currentY == oldY);
    oldX = currentX;
    oldY = currentY;
    loopCount = loopCount + 1;
    if loopCount > 200 then
      error("Error: The mouse keeps moving");
    end
  end
  srMouseUp(oldX, oldY);
end

-------------------------------------------------------------------------------
-- safeClick(x, y, rightClick)
--
-- Click the mouse without moving it.
-------------------------------------------------------------------------------

function safeClick(x, y, rightClick)
  if not x or not y then
    error("Incorrect number of arguments for safeClick()");
  end
  safeBegin();
  srClickMouseNoMove(x, y, rightClick);
end

-------------------------------------------------------------------------------
-- safeDrag(sourceX, sourceY, destX, destY, timeout)
-------------------------------------------------------------------------------

function safeDrag(sourceX, sourceY, destX, destY)
  if not sourceX or not sourceY or not destX or not destY then
    error("Incorrect number of arguments for safeDrag()");
  end
  safeBegin();
  return drag(sourceX, sourceY, destX, destY, timeout);
end

-------------------------------------------------------------------------------
-- clickPoint(point, offsetX, offsetY, rightClick)
--
-- Click one point with an offset
--
-- offsetX, offsetY (optional) -- distance from each point to click (default 5)
-- rightClick (optional) -- make each click a right click (default false)
-------------------------------------------------------------------------------

function clickPoint(point, offsetX, offsetY, rightClick)
  if not point then
    error("Incorrect number of arguments for clickPoint()");
  end
  if not offsetX then
    offsetX = 5;
  end
  if not offsetY then
    offsetY = 5;
  end

  safeClick(point[0]+offsetX, point[1]+offsetY, rightClick);
  lsSleep(click_delay);
end

-------------------------------------------------------------------------------
-- clickXY(x, y, offsetX, offsetY, rightClick)
--
-- Click one point with an offset
--
-- x, y -- Point to click
-- offsetX, offsetY (optional) -- distance from each point to click (default 5)
-- rightClick (optional) -- make each click a right click (default false)
-------------------------------------------------------------------------------

function clickXY(x, y, offsetX, offsetY, rightClick)
  if not x then
    error("Incorrect number of arguments for clickPoint()");
  end
  if not y then
    error("Incorrect number of arguments for clickPoint()");
  end
  if not offsetX then
    offsetX = 5;
  end
  if not offsetY then
    offsetY = 5;
  end
  clickPoint(makePoint(x,y),offsetX,offsetY,rightClick);
end

-------------------------------------------------------------------------------
-- clickAllPoints(points, offsetX, offsetY, rightClick)
--
-- Click all points in a list.
--
-- offsetX, offsetY (optional) -- distance from each point to click (default 5)
-- rightClick (optional) -- make each click a right click (default false)
-------------------------------------------------------------------------------

function clickAllPoints(points, offsetX, offsetY, rightClick)
  if not points then
    error("Incorrect number of arguments for clickAllPoints()");
  end
  if not offsetX then
    offsetX = 5;
  end
  if not offsetY then
    offsetY = 5;
  end

  for i=1, #points  do
    if click_delay > 0 and #points > 1 then
      statusScreen("Clicking " .. #points .. " button(s)...");
    end
    safeClick(points[i][0]+offsetX, points[i][1]+offsetY, rightClick);
    lsSleep(click_delay);
  end
  if click_delay > 0 and #points > 1 then
    statusScreen("Done clicking (" .. #points .. " clicks).");
  end
  lsSleep(click_delay);
end

-------------------------------------------------------------------------------
-- clickAllImages(image_name, offsetX, offsetY, rightClick, tol)
--
-- Find all positions matching a given image and click them.
--
-- image_name -- path and filename used to fetch the image
-- offsetX, offsetY (optional) -- distance from found position to
--                                click (default 5)
-- rightClick (optional) -- click the right mouse button (default false)
-- tol (optional) -- tolerance value used for comparison
--
-- returns the number of buttons clicked
-------------------------------------------------------------------------------

function clickAllImages(image_name, offsetX, offsetY, rightClick, tol)
  if not image_name then
    error("Incorrect number of arguments for clickAllImages()");
  end

  srReadScreen();
  local buttons = findAllImages(image_name, nil, tol);
  clickAllPoints(buttons, offsetX, offsetY, rightClick);
  return #buttons;
end

function clickAllText(text, offsetX, offsetY, rightClick)
  if not text then
    error("Incorrect number of arguments for clickAllText()");
  end

  if not offsetX then
    offsetX = 10;
  end

  srReadScreen();
  local buttons = findAllText(text);
  clickAllPoints(buttons, offsetX, offsetY, rightClick);
  return #buttons;
end

-------------------------------------------------------------------------------
-- drawWater()
--
-- Attempts to draw water from an aqueduct, rain barrel, or pond.
--
-- Returns true on success
-------------------------------------------------------------------------------

function drawWater()
  local result = false;
  sleepWithStatus(200, "Refilling water...");
  srReadScreen();

  -- First, check for rain barrel
  local rain = srFindImage("draw_water.png");
  if rain then
    safeClick(rain[0], rain[1]);
    local max = waitForImage("crem-max.png", 3000, "Waiting for Max button");
    if max then
      safeClick(max[0]+5, max[1]+5);
      result = true;
    end
  end

  -- Second, check for aqueduct
  if not result then
    local aqueduct = srFindImage("Aqueduct.png");
    if not aqueduct then
      aqueduct = srFindImage("Aqueduct2.png");
    end
    if aqueduct then
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
    local water = srFindImage("iconWaterJugSmall.png", 1);
    if water then
      safeClick(water[0]+3, water[1]-5);
      local max = waitForImage("crem-max.png", 500, "Waiting for Max button");
      if max then
	safeClick(max[0]+5, max[1]+5);
        sleepWithStatus(3500, "Waiting for water pickup animation...");
	result = true;
      end
    end
  end
  return result;
end

------------------------------------------------------------------------------
-- clickText(parse)
--
-- convenient wrapper to click on text 20, 7 pixels in from where the top
-- left of the parse object
-- parse - parse object which we're clicking
--
-- always returns nil
------------------------------------------------------------------------------

function clickText(parse)
	srClickMouseNoMove(parse[0] + 20, parse[1] + 7);
	lsSleep(per_click_delay);
end

-------------------------------------------------------------------------------
-- stash()
--
-- Attempts to stash an item in a storage container.  If a storage container's 
-- menu is pinned that will be used, otherwise a feeble attempt will be made to 
-- find a chest, warehouse, or tent by color
--
-- types - An array of strings to search for in the stash menu
-- x, y (optional) - The location on the screen of a known storage container
-- 
--
-- Returns true on success
-------------------------------------------------------------------------------

warehouse_color = -1769769985;
chest_color = 2036219647;
tent_color = 1399546879;

function stash(types, x, y)
	if(types == nil or #types < 1) then
		return false;
	end
	srReadScreen();
	local leaveMenuPinned = false;
	local pos;
	if((not x == nil) and (not y == nil)) then
		pos = pinStorageMenu(x,y);
	end
	if(not pos) then
		pos = findText("Stash");
		if(pos) then
			leaveMenuPinned = true;
		end
	end
	if(not pos) then
		pos = findAndPinContainer();
	end
	if(not pos) then
		lsPrintln("Unable to find the storage container or its menu");
		return false;
	end

	local stashPos = findText("Stash");
	if(not stashPos) then
		lsPrintln("stash() could not find the Stash menu");
		if(not leaveMenuPinned) then
			unpinStorageMenu();
		end
		return false;
	end
	stashPos[0] = stashPos[0] + 15;
	stashPos[1] = stashPos[1] + 3;
	local stashMenuOnScreen = false;
	local i;
	for i=1,#types do
		checkBreak();
		if(not stashMenuOnScreen) then
			safeClick(stashPos[0],stashPos[1]);
			lsSleep(click_delay*3);
			srReadScreen();
			stashMenuOnScreen = true;
		end
		local pos = findText(types[i]);
		if(pos) then
			safeClick(pos[0]+15,pos[1]+3);
			stashMenuOnScreen = false;
			lsSleep(click_delay*3);
			srReadScreen();
			local pos = findText("Stash All");
			if(pos) then
				safeClick(pos[0]+15,pos[1]+3);
			else
				if(not clickMax()) then
					lsSleep(500);
					srReadScreen();
					clickMax();
				end
			end
			lsPrintln(types[i] .. " stashed");
			lsSleep(click_delay*3);
			srReadScreen();
		end
	end
	if(stashMenuOnScreen) then
		safeClick(stashPos[0]-30,stashPos[1]);
	end
	if(leaveMenuPinned) then
		-- Click the menu to update the numbers in the title so that
		-- anyone viewing the screen can see how much space is left
		-- in the storage container
		pos = findText("full");
		if(pos) then
			safeClick(pos[0]+15,pos[1]+3);
		end
	else
		unpinStorageMenu();
	end
	return true;
end

function pinStorageMenu(x,y)
	centerMouse();
	safeClick(x,y,false);
	lsSleep(click_delay*3);
	srReadScreen();
	local pos = findText("Stash");
	if(pos) then
		local pos2 = findText("full");
		if(pos2) then
			safeClick(pos2[0],pos2[1],true);
			return pos;
		end
	end
	return nil;
end

function unpinStorageMenu()
	local pos = findText("full");
	if(pos) then
		safeClick(pos[0]+15,pos[1]+3,true);
	end
end

function findAndPinContainer()
	centerMouse();
	local xyWindowSize = srGetWindowSize();
	local mid = {};
	mid[0] = xyWindowSize[0] / 2;
	mid[1] = xyWindowSize[1] / 2;
	local storagePos = nil;
	local maxDelta = math.max(xyWindowSize[0] / 2, xyWindowSize[1] / 2);
	local delta;
	for delta = 1, maxDelta, 2 do
		checkBreak();
		local dx;
		for dx = (delta * -1), delta, 2 do
			if(mid[0]+dx >= 0 and mid[0]+dx < xyWindowSize[0] and mid[1] > delta) then
				if(checkStoragePixel(mid[0]+dx,mid[1]+delta)) then
					local pos = pinStorageMenu(mid[0]+dx,mid[1]+delta);
					if(pos) then
						return pos;
					end
				end
				if(checkStoragePixel(mid[0]+dx,mid[1]-delta)) then
					local pos = pinStorageMenu(mid[0]+dx,mid[1]-delta);
					if(pos) then
						return pos;
					end
				end
			end
		end
		local dy;
		for dy = (delta * -1), delta, 3 do
			if(mid[1]+dy >= 0 and mid[1]+dy < xyWindowSize[1] and mid[0] > delta) then
				if(checkStoragePixel(mid[0]+delta,mid[1]+dy)) then
					local pos = pinStorageMenu(mid[0]+delta,mid[1]+dy);
					if(pos) then
						return pos;
					end
				end
				if(checkStoragePixel(mid[0]-delta,mid[1]+dy)) then
					local pos = pinStorageMenu(mid[0]+delta,mid[1]+dy);
					if(pos) then
						return pos;
					end
				end
			end
		end
	end
	lsPrintln("Unable to find the storage container");
	return false;
end

function checkStoragePixel(x, y)
	if(pixelBlockCheck(x, y, tent_color, 10, 8, 2)) then
		return true;
	end
	if(pixelBlockCheck(x, y, warehouse_color, 10, 8, 2)) then
		return true;
	end
	if(pixelBlockCheck(x, y, chest_color, 10, 8, 2)) then
		return true;
	end
end



-------------------------------------------------------------------------------
-- clickMax()
--
-- Clicks the Max button
-------------------------------------------------------------------------------

function clickMax()
	local count;
	for count=0, 10 do
		local pos = srFindImage("crem-max.png", 5000);
		if pos then
			safeClick(pos[0]+5, pos[1]+5);
			return true;
		end
		lsSleep(click_delay);
		srReadScreen();
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

