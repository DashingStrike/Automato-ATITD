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
  clickAllPoints(buttons);
  return #buttons;
end

function clickAllText(text, offsetX, offsetY, rightClick)
  if not text then
    error("Incorrect number of arguments for clickAllText()");
  end

  srReadScreen();
  local buttons = findAllText(text);
  clickAllPoints(buttons);
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
    local max = waitForImage("crem-max.png", 500, "Waiting for Max button");
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
