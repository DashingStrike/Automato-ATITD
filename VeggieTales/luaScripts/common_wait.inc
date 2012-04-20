-- common_wait.inc
--
-- Common functions used for waiting on events in the target window.
--
-- DO NOT INCLUDE THIS FILE! Include common.inc instead
--

-------------------------------------------------------------------------------
-- getWaitSpot(x, y)
--
-- Initialize position and pixel value for waitForChange() or waitForStasis()
-- x -- Position in pixels on x-axis
-- y -- Position in pixels on y-axis
--
-- returns a 3-tuple of x, y, and the current color at that spot.
-------------------------------------------------------------------------------

function getWaitSpot(x, y)
  if not x or not y then
    error("Incorrect number of arguments for getWaitSpot()");
  end
  return {x, y, srReadPixel(x, y)};
end

-------------------------------------------------------------------------------
-- waitForChange(spot, timeout)
--
-- Wait for pixel at spot to change subject to a timeout.
--
-- spot -- 3-tuple of x, y, and the original color at that location
-- timeout -- Time in milliseconds to wait before giving up
--
-- returns true on change and false on timeout.
-------------------------------------------------------------------------------

function waitForChange(spot, timeout)
  if not spot or not timeout then
    error("Incorrect number of arguments for waitForChange()");
  end
  if #spot ~= 3 then
    error 'waitForChange called without a valid spot\n';
  end

  local success = true;
  local timestart = lsGetTimer();
  local pixel = srReadPixel(spot[1], spot[2])
  while pixel == spot[3] do
    lsSleep(tick_delay);
    checkBreak();
    if timeout and (lsGetTimer() > timestart + timeout) then
      success = false;
      break;
    end
    pixel = srReadPixel(spot[1], spot[2]);
  end
  return success;
end

-------------------------------------------------------------------------------
-- waitForStasis(spot, timeout)
--
-- Wait for pixel at spot to stop changing color.
--
-- spot -- 3-tuple of x, y, and the original color at that location
-- timeout -- Time in milliseconds to wait before giving up
--
-- returns true on change and false on timeout.
-------------------------------------------------------------------------------

function waitForStasis(spot, timeout)
  if not spot or not timeout then
    error("Incorrect number of arguments for waitForStasis()");
  end

  if (#spot ~= 3) then
    error 'waitForStasis called without a valid spot\n';
  end

  local lastPixels = {0, 1, 2, 3, 4, 5, 6};
  local index = 1;
  local success = true;
  local timestart = lsGetTimer();
  while not isHomogenous(lastPixels) do
    checkBreak();
    if timeout and (lsGetTimer() > timestart + timeout) then
      success = false;
      break;
    end
    lsSleep(tick_delay);
    pixel = srReadPixel(setWaitSpot_x, setWaitSpot_y);
    lastPixels[index] = pixel;
    index = index + 1;
    if (index > #lastPixels) then
      index = 1;
    end
  end
  return success;
end

function isHomogenous(list)
  local result = true;
  for i=1,#list do
    if list[i] ~= list[1] then
      result = false;
    end
  end
  return result;
end

-------------------------------------------------------------------------------
-- waitForImage(file, timeout, message, tol)
--
-- Wait for a particular image to appear subject to a timeout in ms.
--
-- file -- filename of image to search for
-- timeout -- maximum time to wait in ms
-- message (optional) -- Status message to show while waiting
-- tol (optional) -- tolerance for comparison
--
-- returns image on success or none on failure
-------------------------------------------------------------------------------

function waitForImage(file, timeout, message, tol)
  local xyWindowSize = srGetWindowSize();
  if not file or not timeout then
    error("Incorrect number of arguments for waitForImage()");
  end
  return waitForImageInRange(file, 0, 0, xyWindowSize[0], xyWindowSize[1],
                             timeout, message, tol);
end

-------------------------------------------------------------------------------
-- waitForImageInRange(file, x, y, width, height, timeout, message, tol)
--
-- Wait for an image to appear within a box subject to a timeout in ms.
--
-- file -- image file to check against
-- x, y -- upper-left corner of range to search
-- width, height -- size of range to search
-- timeout -- how long to wait for image (ms)
-- message (optional) -- message to print while waiting
-- tol (optional) -- tolerance for comparison
-------------------------------------------------------------------------------

function waitForImageInRange(file, x, y, width, height, timeout, message, tol)
  if not file or not x or not y or not width or not height or not timeout then
    error("Incorrect number of arguments for waitForImageInRange()");
  end
  if not tol then
    tol = 5000;
  end
  local done = false;
  local image = nil;
  local timestart = lsGetTimer();
  while not done do
    if message then
      statusScreen(message);
    end
    lsSleep(tick_time);
    srReadScreen();
    image = srFindImageInRange(file, x, y, width, height, tol);
    done = (image ~= nil) ;
    if lsGetTimer() > timestart + timeout then
      done = true;
    end
  end
  return image;
end

-------------------------------------------------------------------------------
-- waitForImageInWindow(file, x, y, timeout, bounds)
--
-- Wait for an image to appear within the given atitd window.
--
-- file -- image file to check against
-- x, y -- coordinates inside the window
-- timeout (optional) -- how long to wait for image to appear, default: forever
-- bounds (optional) -- preset bounds to use instead of recalculating
-------------------------------------------------------------------------------

function waitForImageInWindow(file, x, y, timeout, bounds)
  if not file or not x or not y then
    error("Incorrect number of arguments for waitForImageInWindow");
  end
  if not bounds then
    bounds = srGetWindowBorders(x, y);
  end
  return waitForImageInRange(file, bounds[0], bounds[1],
			     bounds[2] - bounds[0], bounds[3] - bounds[1],
			     timeout);
end

-------------------------------------------------------------------------------
-- waitForImageWhileUpdating(file, x, y, delay)
--
-- Wait for an image to appear while periodically clicking to update
-- window. Waits forever if necessary.
--
-- file -- image file to check against
-- x, y -- position to click periodically while waiting
-- delay -- time to wait between clicks
-------------------------------------------------------------------------------

function waitForImageWhileUpdating(file, x, y, delay)
  if not file or not x or not y or not delay then
    error("Incorrect number of arguments for waitForImageWhileUpdating()");
  end
  local pos = nil;
  while pos == nil do
    safeClick(x, y);
    pos = waitForImage(file, delay);
  end
  return pos;
end
