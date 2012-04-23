-- common_window.inc
--
-- Common functions for handling windows: opening, arranging, unpinning
--
-- DO NOT INCLUDE THIS FILE! Include common.inc instead
--

TOP_LEFT = 0;
TOP_RIGHT = 1;
BOTTOM_LEFT = 2;
BOTTOM_RIGHT = 3;

-------------------------------------------------------------------------------
-- stashWindow(sourceX, sourceY, corner, bounds)
--
-- Drags a window from a given location to a corner of the screen.
--
-- sourceX, sourceY -- location of anchor point to drag window
-- corner -- destination corner (TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT,
--           or BOTTOM_RIGHT)
-- bounds (optional) -- bounds of window
-------------------------------------------------------------------------------

local stashBit = 0;

function stashWindow(sourceX, sourceY, corner, bounds)
  if not sourceX or not sourceY or not corner then
    error("Incorrect number of arguments for stashWindow()");
  end
  stashBit = (stashBit + 2) % 4;
  if not bounds then
    srReadScreen();
    bounds = srGetWindowBorders(sourceX, sourceY);
  end
  local size = {};
  size[0] = bounds[2] - bounds[0];
  size[1] = bounds[3] - bounds[1];
  local screen = srGetWindowSize();
  local dest = {};
  dest[0] = screen[0] - size[0] + (sourceX - bounds[0]) - 5;
  if corner == TOP_LEFT or corner == BOTTOM_LEFT then
    dest[0] = sourceX - bounds[0] + 5;
  end
  dest[1] = screen[1] - size[1] + (sourceY - bounds[1]) - stashBit - 5;
  if corner == TOP_LEFT or corner == TOP_RIGHT then
    dest[1] = sourceY - bounds[1] + stashBit + 5;
  end
  safeDrag(sourceX, sourceY, dest[0], dest[1]);
  srSetMousePos(sourceX, sourceY);
  lsSleep(click_delay);
  return dest;
end

-------------------------------------------------------------------------------
-- stashAllWindows(corner)
--
-- Move all windows not in the same quadrant as corner into the given
-- corner.  Use this twice on different corners to make sure that you
-- grab all windows.
--
-- corner -- Destination corner
-------------------------------------------------------------------------------

function stashAllWindows(corner)
  if not corner then
    error("Incorrect number of arguments for stashAllWindows()");
  end
  local top = (corner == TOP_LEFT or corner == TOP_RIGHT);
  local left = (corner == TOP_LEFT or corner == BOTTOM_LEFT);
  local screen = srGetWindowSize();
  local done = false;
  local stashes = {};
  srReadScreen();
  local anchors = findAllImages("ThisIs.png");
  while not done do
    done = true;
    for i=1,#anchors do
      if not wasStashed(anchors[i], stashes) then
	safeClick(anchors[i][0], anchors[i][1]);
	lsSleep(click_delay);
	local lastPos = stashWindow(anchors[i][0], anchors[i][1], corner);
	stashes[#stashes + 1] = lastPos;
	done = false;
      end
    end
    lsSleep(tick_delay);
    srReadScreen();
    anchors = findAllImages("ThisIs.png");
    statusScreen("Stashing Windows");
  end
end

function wasStashed(pos, stashes)
  local result = false;
  for i=1,#stashes do
    local diffX = math.abs(stashes[i][0] - pos[0]);
    local diffY = math.abs(stashes[i][1] - pos[1]);
    if diffX < 20 and diffY < 20 then
      result = true;
      break;
    end
  end
  return result;
end

-------------------------------------------------------------------------------
-- openAndPin(x, y, timeout)
--
-- Click at the given position to open a window, then pin that window.
--
-- x, y -- position to click
-- timeout -- time to wait before giving up
--
-- Returns true on success.
-------------------------------------------------------------------------------

function openAndPin(x, y, timeout)
  if not x or not y or not timeout then
    error("Incorrect number of arguments for openAndPin()");
  end
  local result = false;
  local spot = getWaitSpot(x+5, y);
  safeBegin();
  srClickMouse(x, y, 1);
  lsDoFrame();
  statusScreen("Clicking to open window");
  if waitForChange(spot, timeout) then
    statusScreen("Looking for anchor");
    local anchor = waitForImageInWindow("ThisIs.png", x+5, y, timeout);
    if anchor then
      success = true;
      if not findImageInWindow("UnPin.png", x+5, y) then
	safeClick(anchor[0], anchor[1], 1);
	statusScreen("Pinning window");
      end
    end
  end
  return success;
end

-------------------------------------------------------------------------------
-- arrangeInGrid(cascade)
--
-- Arrange all open windows into a grid on the screen. Stashes them first.
--
-- cascade (optional) -- arrange windows into a overlapping cascade
-------------------------------------------------------------------------------

function arrangeInGrid(cascade)
  stashAllWindows(BOTTOM_LEFT);
  stashAllWindows(BOTTOM_RIGHT);
  arrangeStashed(cascade);
end

-------------------------------------------------------------------------------
-- arrangeStashed(cascade)
--
-- Arrange all open windows into a grid on the screen. Assumes they
-- are pre-stashed.
--
-- cascade (optional) -- arrange windows into a overlapping cascade
-------------------------------------------------------------------------------

function arrangeStashed(cascade)
  local screen = srGetWindowSize();
  local bottomRightX = screen[0] - 20;
  local bottomRightY = screen[1] - 20;
  screen[0] = screen[0] - lsGetWindowSize()[0];
  local currentX = 0;
  local currentY = 0;
  if cascade then
    currentX = 10;
    currentY = 50;
  end
  local lastX = 0;
  local lastY = 0;
  local xMax = 0;
  local yMax = 0;
  srReadScreen();
  local window = findImageInWindow("ThisIs.png", bottomRightX, bottomRightY);
  while window and (window[0] > lastX or window[1] > lastY) do
    safeClick(window[0], window[1]);
    lsSleep(click_delay);
    srReadScreen();
    local bounds = srGetWindowBorders(window[0], window[1]);
    local width = bounds[2] - bounds[0];
    local height = bounds[3] - bounds[1];
    if cascade then
      if currentY + height >= screen[1] then
	currentX = currentX + xMax;
	currentY = 0;
	xMax = 0;
      end
      if currentX + width >= screen[0] then
	error("Cannot arrange these windows into a cascade.");
      end
    else
      if currentX + width >= screen[0] then
	currentX = 0;
	currentY = currentY + yMax;
	yMax = 0;
      end
      if currentY + height >= screen[1] then
	error("Cannot arrange these windows into a grid.");
      end
    end
    lastX = window[0] - bounds[0] + currentX;
    lastY = window[1] - bounds[1] + currentY;
    safeDrag(window[0], window[1], lastX, lastY);
    if cascade then
      currentX = currentX + 8;
      currentY = currentY + 24;
    else
      currentX = currentX + width;
    end
    xMax = math.max(xMax, width);
    yMax = math.max(yMax, height);
    lsSleep(tick_delay);
    srReadScreen();
    window = findImageInWindow("ThisIs.png", bottomRightX, bottomRightY);
    statusScreen("Arranging Windows");
  end
end

-------------------------------------------------------------------------------
-- closeAllWindows(x, y, width, height)
--
-- Close all open windows.
--
-- x, y (optional) -- origin of box to search
-- width, height (optional) -- size of box to search
-------------------------------------------------------------------------------

function closeAllWindows(x, y, width, height)
  if not x then
    x = 0;
  end
  if not y then
    y = 0;
  end
  if not width then
    width = srGetWindowSize()[0];
  end
  if not height then
    height = srGetWindowSize()[1];
  end
  srReadScreen();
  local images = findAllImagesInRange("ThisIs.png", x, y, width, height);
  while #images >= 1 do
    safeClick(images[#images][0], images[#images][1], 1);
    sleepWithStatus(200, "Closing Windows");
    srReadScreen();
    images = findAllImagesInRange("ThisIs.png", x, y, width, height);
  end

  srReadScreen();
  current = srFindImageInRange("UnPin.png", x, y, width, height);
  while #images >= 1 do
    safeClick(images[#images][0], images[#images][1], 1);
    sleepWithStatus(click_delay, "Closing Windows");
    srReadScreen();
    images = findAllImagesInRange("UnPin.png", x, y, width, height);
  end
end

-------------------------------------------------------------------------------
-- windowManager(title, message, overlap)
--
-- Run a window manager interface to let the user open, pin, arrange,
-- or clear windows.
--
-- title (optional) -- title of window
-- message (optional) -- extra instructions for the user
-- overlap (optional) -- cascade windows instead of putting them in a grid
-------------------------------------------------------------------------------

function windowManager(title, message, overlap)
  if not title then
    title = "Window Manager";
  end
  if not message then
    message = "Tap shift to open and pin a window."
  end
  local pauseFocus = false;
  local shift = false;
  local done = false;
  while not done do
    lsPrint(10, 10, 0, 1.0, 1.0, 0xFFFFFFff, title);
    if lsButtonText(30, 60, 0, 250, 0x80D080ff, "Arrange Windows") then
      lsDoFrame();
      if pauseFocus then
	askForWindow(focusMessage);
      end
      arrangeInGrid(overlap);
    end
    if lsButtonText(30, 90, 0, 250, 0x80D080ff, "Stash Windows") then
      lsDoFrame();
      if pauseFocus then
	askForWindow(focusMessage);
      end
      stashAllWindows(BOTTOM_RIGHT);
    end
    if lsButtonText(30, 120, 0, 250, 0x80D080ff, "Un-Pin Windows") then
      lsDoFrame();
      if pauseFocus then
	askForWindow(focusMessage);
      end
      closeAllWindows();
    end
    pauseFocus = lsCheckBox(30, 160, 10, 0xffffffff, "Pause for Focus",
			    pauseFocus);
    lsPrintWrapped(10, 200, 0, 250, 0.7, 0.7, 0xd0d0d0ff,
		   message);
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100,
		    0xffffffff, "End Script") then
      error(quitMessage);
    end
    while lsShiftHeld() do
      checkBreak();
      shift = true;
    end
    if shift then
      shift = false;
      local x = 0;
      local y = 0;
      x, y = srMousePos();
      openAndPin(x, y, 500);
    end
    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Done") then
        done = true;
    end
    checkBreak();
    lsDoFrame();
    lsSleep(tick_delay);
  end
  if pauseFocus then
    askForWindow(focusMessage);
  end
end

-------------------------------------------------------------------------------
-- unpinManager(title, message)
--
-- Interface to help the user clear away all windows when a macro completes.
--
-- title (optional)  -- title of window
-- message (optional) -- extra instructions for the user
-------------------------------------------------------------------------------

function unpinManager(title, message)
  if not title then
    title = "Unpin Manager";
  end
  if not message then
    message = "";
  end
  while lsShiftHeld() and lsControlHeld() do
    lsPrintWrapped(10, 60, 0, lsScreenX - 20, 1, 1, 0x808080ff,
		  "Please release Ctrl+Shift");
    lsSleep(tick_delay);
    lsDoFrame();
  end
  local pauseFocus = false;
  local done = false;
  while not done do
    lsPrint(10, 10, 0, 1.0, 1.0, 0xFFFFFFff, title);
    lsPrintWrapped(10, 60, 0, lsScreenX - 20, 0.7, 0.7,
		   0xd0d0d0ff, message);
    if lsButtonText(30, 160, 0, 250, 0x80D080ff, "Un-Pin Windows") then
      lsDoFrame();
      if pauseFocus then
	askForWindow(focusMessage);
      end
      closeAllWindows();
    end
    pauseFocus = lsCheckBox(30, 200, 10, 0xffffffff, "Pause for Focus",
			    pauseFocus);
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100,
		    0xffffffff, "Done") then
      done = true;
    end
    if lsShiftHeld() and lsControlHeld() then
      done = true;
    end
    lsDoFrame();
    lsSleep(tick_delay);
  end
end

-------------------------------------------------------------------------------
-- unpinOnExit(f)
--
-- Execute function f and present an unpin manager window when it
-- completes or if an error is thrown.
--
-- f -- function to execute with no arguments
-------------------------------------------------------------------------------

function unpinOnExit(f)
  if not f then
    error("Incorrect number of arguments for f");
  end
  local status, error = pcall(f);
  unpinManager("Complete", error);
end
