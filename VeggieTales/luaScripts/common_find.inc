-- common_find.inc
--
-- Utility functions for searching for information on screen.
--
-- DO NOT INCLUDE THIS FILE! Include common.inc instead
--

-- List of colors which mark the edge of a window.
WINDOW_COLORS = {0x72502EFF, 0x714f2eff, 0x6f4e2dff, 0x785431ff};

-------------------------------------------------------------------------------
-- findAllImages(image_name, range, tol)
--
-- Returns an array of all positions matching the image.
--
-- image_name -- path and filename used to fetch the image
-- range (optional) -- box to search in (defaults to screen)
-- tol (optional) -- tolerance value used for comparison
-------------------------------------------------------------------------------

function findAllImages(image_name, range, tol)
  if not image_name then
    error("Incorrect number of arguments for findAllImages()");
  end
  if not range then
    local size = srGetWindowSize();
    range = makeBox(0, 0, size[0], size[1]);
  end
  return findAllImagesInRange(image_name, range.x, range.y,
			      range.width, range.height, tol);
end

-------------------------------------------------------------------------------
-- findAllImagesInRange(image_name, startX, startY, width, height, tol)
--
-- Returns an array of all positions matching the image.
--
-- image_name -- path and filename used to fetch the image
-- startX, startY -- origin of search region
-- width, height -- size of search region
-- tol (optional) -- tolerance value used for comparison
-------------------------------------------------------------------------------

function findAllImagesInRange(image_name, startX, startY, width, height, tol)
  if not image_name or not startX or not startY or not width or not height then
    error("Incorrect number of arguments for findAllImages()");
  end
  if not tol then
    tol = 5000;
  end
  local endX = startX + width;
  local endY = startY + height;
  local xyImageSize = srImageSize(image_name);
  local y = startY;
  local buttons = {};
  while 1 do
    local pos = srFindImageInRange(image_name, startX, y, width, endY-y, tol);
    if not pos then
      break;
    end
    buttons[#buttons+1] = pos;
    local newy = pos[1] + 1;
    y = pos[1];
    -- Look for other ones on the exact same line
    while 1 do
      local x = pos[0]+1;
      pos = srFindImageInRange(image_name, x, y,
                               endX - x, math.min(xyImageSize[1], endY - y),
			       tol);
      if not pos then
        break;
      end
      buttons[#buttons+1] = pos;
    end
    y = newy;
    end
  return buttons;
end

-------------------------------------------------------------------------------
-- findImageInWindow(image_name, x, y, tol)
--
-- Returns a position matching an image bounded by an atitd window or
-- nil if there is no match.
--
-- image_name -- path and filename used to fetch image
-- x, y -- any location within the window
-- tol (optional) -- tolerance value used for comparison
-------------------------------------------------------------------------------

function findImageInWindow(image_name, x, y, tol)
  if not image_name or not x or not y then
    error("Incorrect number of arguments for findImageInWindow()");
  end
  if not tol then
    tol = 5000;
  end
  local result = nil;
  local range = getWindowBorders(x, y);
  if range then
    result = srFindImageInRange(image_name, range.x, range.y,
				range.width, range.height, tol);
  end
  return result;
end

-- If set, only a line of text matching the text exactly will
-- suffice. If unset, any line containing the text will be returned.
EXACT = 1;
-- If set, this window does not contain a pin in the corner.
NOPIN = 2;
-- If set, returns the window containing the text rather than the parse.
REGION = 4;
EXACT_NOPIN = 3;
EXACT_REGION = 5;
NOPIN_REGION = 6;
EXACT_NOPIN_REGION = 7;

function findText(text, window, flag)
  local parses = findAllText(text, window, flag);
  local result = nil;
  if #parses >= 1 then
    result = parses[1];
  end
  return result;
end

function findAllText(text, window, flag)
  local exact = flag and (flag % 2 == 1);
  local nopin = flag and (math.floor(flag/2) % 2 == 1);
  local region = flag and (math.floor(flag/4) % 2 == 1);

  local results = {};
  local windowList = {window};
  if not window then
    windowList = findAllWindows();
  end

  for i=1,#windowList do
    local current = makeBox(windowList[i].x + 4, windowList[i].y + 3,
			    windowList[i].width - 8, windowList[i].height - 6);
    if not nopin then
      current = makeBox(current.x, current.y,
			current.width - 30, current.height);
    end
    local parses = parseWindow(current);
    for j=1,#parses do
      if not text
	or (exact and parses[j][2] == text)
	or (not exact and string.find(parses[j][2], text, 1, true))
      then
	if region then
	  table.insert(results, windowList[i]);
	  break;
	else
	  table.insert(results, parses[j]);
	end
      end
    end
  end
  return results;
end

function findAllWindows()
  local windows = {};
  local current = srFindFirstTextRegion();
  while current do
    breakupRegion(regionToBox(current), windows);
    current = srFindNextTextRegion(current[0] + 1, current[1]);
  end
  return windows;
end

function breakupRegion(region, windows)
  local current = getWindowBorders(region.x + 5, region.y + 5);
  table.insert(windows, current);
  if region.width - current.width > 10 then
    breakupRegion(makeBox(region.x + current.width + 8, region.y,
			  region.width - current.width - 8, region.height),
		  windows);
  end
  if region.height - current.height > 4 then
    breakupRegion(makeBox(region.x, region.y + current.height + 2,
			  current.width + 8, region.height - current.heigh - 2),
		  windows);
  end
end

-------------------------------------------------------------------------------
-- parseWindow(window)
--
-- Strips a window, then returns an array of all the parses in that window.
--
-- window -- box demarking the in-game window to parse
-------------------------------------------------------------------------------

function parseWindow(window)
  local result = {};
  srStripRegion(window.x, window.y, window.width, window.height);
  local table = srParseTextRegion(window.x, window.y,
				  window.width, window.height);
  if table then
    local count = math.floor((#table + 1) / 3);
    for i = 1, count do
      result[i] = {};
      result[i][0] = table[(i-1)*3];
      result[i][1] = table[(i-1)*3+1];
      result[i][2] = table[(i-1)*3+2];
    end
  end
  return result;
end

-------------------------------------------------------------------------------
-- pixelMatch(anchor, offset, color, tolerance)
--
-- Checks to see whether the screen pixel at anchor+offset matches a
-- given color.
--
-- anchor -- Base location to check
-- offset -- Offset from base location
-- color -- Color to check against
-- tolerance -- 0 means exact match, >= 255 means any color (default 0)
--
-- Returns true if the colors match within tolerance.
-------------------------------------------------------------------------------

function pixelMatch(anchor, offset, color, tolerance)
  if not anchor or not offset or not color then
    error("Incorrect number of arguments for pixelMatch()");
  end
  return pixelMatchList(anchor, offset, {color}, tolerance);
end

-------------------------------------------------------------------------------
-- pixelMatchList(anchor, offset, colors, tolerance)
--
-- Checks to see whether the screen pixel at anchor+offset matches a
-- given color.
--
-- anchor -- Base location to check
-- offset -- Offset from base location
-- colors -- Colors to check against, returns true if any of them are matched.
-- tolerance -- 0 means exact match, >= 255 means any color (default 0)
--
-- Returns true if the colors match within tolerance.
-------------------------------------------------------------------------------

function pixelMatchList(anchor, offset, colors, tolerance)
  if not anchor or not offset or not colors then
    error("Incorrect number of arguments for pixelMatchList()");
  end
  if not tolerance then
    tolerance = 0;
  end
  local result = false;
  local screenColor = srReadPixel(anchor[0] + offset[0],
				  anchor[1] + offset[1]);
  for i=1,#colors do
    local currentMatch = true;
    local diffs = calculatePixelDiffs(colors[i], math.floor(screenColor/256));
    for j=1,#diffs do
      if diffs[j] > tolerance then
	currentMatch = false;
	break;
      end
    end
    if currentMatch then
      result = true;
      break;
    end
  end
  return result;
end

function pixelDiffs(x, y, color)
  local screenColor = srReadPixelFromBuffer(x, y);
  return calculatePixelDiffs(color, math.floor(screenColor/256));
end

function calculatePixelDiffs(left, right)
  local result = {};
  for i=1,3 do
    result[4-i] = math.abs((left % 256) - (right % 256));
    left = math.floor(left / 256);
    right = math.floor(right / 256);
  end
  return result;
end

-------------------------------------------------------------------------------
-- ocrNumber(startX, startY, characterSet)
--
-- Looks for a string of digits of a given character set and returns
-- them as a number.
--
-- startX, startY -- position to start looking
-- characterSet (optional) -- constant defining images and sizes:
--                            NORMAL_SET (default), BOLD_SET, SMALL_SET
-------------------------------------------------------------------------------

NORMAL_SET = 0;
BOLD_SET = 1;
SMALL_SET = 2;

function ocrNumber(startX, startY, characterSet)
  if not startX or not startY then
    error("Incorrect number of arguments for ocrNumber()");
  end
  local prefix, sizeX, sizeY = getCharacterSet(characterSet);

  -- find first digit
  local x = startX;
  local y = startY;
  local digit=nil;
  local offset=0;
  while (not digit) and (offset < 10) do
    digit = findDigit(x, y, sizeX, sizeY, prefix);
    if not digit then
      x = x+1;
      offset = offset + 1;
    end
  end
  -- find remaining digits
  local result = 0;
  while digit do
    result = result * 10 + digit;
    x = x + sizeX + 1;
    digit = findDigit(x, y, sizeX, sizeY, prefix);
  end
  return result;
end

function findDigit(x, y, sizeX, sizeY, prefix)
  local result = nil;
  for i=0, 9 do
    if srFindImageInRange(prefix .. i .. ".png", x, y,
			  sizeX, sizeY, tol)
    then
      result = i;
      break;
    end
  end
  return result;
end

function getCharacterSet(characterSet)
  local prefix = "ocr/";
  local sizeX = 6;
  local sizeY = 9;
  if characterSet and characterSet == BOLD_SET then
    prefix = "ocr/bold_";
    sizeX = 7;
    sizeY = 9;
  elseif characterSet and characterSet == SMALL_SET then
    prefix = "ocr/small_";
    sizeX = 5;
    sizeY = 8;
  end
  return prefix, sizeX, sizeY;
end
