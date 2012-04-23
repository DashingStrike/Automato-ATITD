-- common_find.inc
--
-- Utility functions for searching for information on screen.
--
-- DO NOT INCLUDE THIS FILE! Include common.inc instead
--

-------------------------------------------------------------------------------
-- findAllImages(image_name, tol)
--
-- Returns an array of all positions matching the image.
--
-- image_name -- path and filename used to fetch the image
-- tol (optional) -- tolerance value used for comparison
-------------------------------------------------------------------------------

function findAllImages(image_name, tol)
  local size = srGetWindowSize();
  return findAllImagesInRange(image_name, 0, 0, size[0], size[1], tol);
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
-- bounds (optional) -- bounds of window
-- tol (optional) -- tolerance value used for comparison
-------------------------------------------------------------------------------

function findImageInWindow(image_name, x, y, bounds, tol)
  if not image_name or not x or not y then
    error("Incorrect number of arguments for findImageInWindow()");
  end
  if not tol then
    tol = 5000;
  end
  if not bounds then
    bounds = srGetWindowBorders(x, y);
  end
  return srFindImageInRange(image_name, bounds[0], bounds[1],
			    bounds[2] - bounds[0], bounds[3] - bounds[1], tol);
end
