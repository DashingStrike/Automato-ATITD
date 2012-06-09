-- common_fix.inc
--
-- Wrappers around a few functions in the API to provide consistency.
--

-------------------------------------------------------------------------------
-- regionToBox(region)
--
-- Make a box out of a 'region' which is returned from one of:
-- srFindFirstTextRegion(), srFindNextTextRegion(), srFindChatRegion()
--
-- region -- 4-element 0-indexed array containing {x, y, width, height}
-------------------------------------------------------------------------------

function regionToBox(region)
  return makeBox(region[0], region[1], region[2], region[3]);
end

-------------------------------------------------------------------------------
-- boundsToBox(bounds)
--
-- Make a box out of a [l, t, r, b] which is returned from srGetWindowBorders()
--
-- bounds -- 4-element 0-indexed array containing {left, top, right, bottom}
-------------------------------------------------------------------------------

function boundsToBox(bounds)
  if not bounds then
    return nil;
  else
    return makeBox(bounds[0], bounds[1],
		   bounds[2] - bounds[0], bounds[3] - bounds[1]);
  end
end

-------------------------------------------------------------------------------
-- getMousePos()
--
-- Returns a point indicating the current mouse position.
-------------------------------------------------------------------------------
function getMousePos()
  local x, y = srMousePos();
  return makePoint(x, y);
end

-------------------------------------------------------------------------------
-- getWindowBorders(x, y)
--
-- Returns a box bounding the atitd window at a position
--
-- x, y -- position in the window to start searching
-------------------------------------------------------------------------------

function getWindowBorders(x, y)
  if not x or not y then
    error("Incorrect number of arguments to getWindowBorders()");
  end
  return boundsToBox(srGetWindowBorders(x, y));
end

-------------------------------------------------------------------------------
-- findFirstTextRegion()
--
-- Returns a box bounding the first text region found on the screen
-------------------------------------------------------------------------------

function findFirstTextRegion()
  return regionToBox(srFindFirstTextRegion());
end

-------------------------------------------------------------------------------
-- findNextTextRegion()
--
-- Returns a box bounding the next text region on the screen. Not re-entrant.
-------------------------------------------------------------------------------

function findNextTextRegion()
  return regionToBox(srFindNextTextRegion());
end

-------------------------------------------------------------------------------
-- findChatRegion()
--
-- Returns a box bounding the text region containing the chat interface.
-------------------------------------------------------------------------------

function findChatRegion()
  return regionToBox(srFindChatRegion());
end

-------------------------------------------------------------------------------
-- findInventoryRegion()
--
-- Returns a box bounding the text region containing the inventory/skills
-------------------------------------------------------------------------------

function findInventoryRegion()
  return regionToBox(srFindInventoryRegion());
end
