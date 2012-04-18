-- common_click.inc
--
-- Common utility functions for clicking or other mouse actions
--
-- DO NOT INCLUDE THIS FILE! Include common.inc instead
--

-- Time to wait between independent clicks
click_delay = 50;

-------------------------------------------------------------------------------
-- drag()
--
-- Drag the mouse from (sourceX, sourceY) to (destX, destY)
-------------------------------------------------------------------------------

function drag(sourceX, sourceY, destX, destY)
  if not sourceX or not sourceY or not destX or not destY then
    error("Incorrect number of arguments for drag()");
  end
  local spot = getWaitSpot(destX, destY);
  srSetMousePos(sourceX, sourceY);
  srMouseDown(sourceX, sourceY, 0);
  srSetMousePos(destX, destY);
  local result = waitForChange(spot, 500);
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
-- safeClick()
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
-- safeDrag()
-------------------------------------------------------------------------------

function safeDrag(sourceX, sourceY, destX, destY)
  if not sourceX or not sourceY or not destX or not destY then
    error("Incorrect number of arguments for safeDrag()");
  end
  safeBegin();
  return drag(sourceX, sourceY, destX, destY);
end

-------------------------------------------------------------------------------
-- clickAllImages(image_name, tol)
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
  if not offsetX then
    offsetX = 5;
  end
  if not offsetY then
    offsetY = 5;
  end

  srReadScreen();
  local buttons = findAllImages(image_name, tol);
  for i=1, #buttons  do
    statusScreen("Clicking " .. #buttons .. "button(s)...");
    safeClick(buttons[i][0]+offsetX, buttons[i][1]+offsetY, rightClick);
    lsSleep(click_delay);
  end
  statusScreen("Done clicking (" .. #buttons .. " clicks).");
  lsSleep(click_delay);
  return #buttons;
end
