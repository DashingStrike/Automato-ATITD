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
  if not image_name then
    error("Incorrect number of arguments for findAllImages()");
  end
  if not tol then
    tol = 5000;
  end
  local xyImageSize = srImageSize(image_name);
  local xyWindowSize = srGetWindowSize();
  local y = 0;
  local buttons = {};
  while 1 do
    local pos = srFindImageInRange(image_name, 0, y,
                                   xyWindowSize[0], xyWindowSize[1]-y, tol);
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
                               xyWindowSize[0]-x, xyImageSize[1], tol);
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
