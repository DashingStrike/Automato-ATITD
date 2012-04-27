-- common.inc
--
-- Common utility functions useful for most macros
--

assert(loadfile("luaScripts/common_ui.inc"))();
assert(loadfile("luaScripts/common_wait.inc"))();
assert(loadfile("luaScripts/common_click.inc"))();
assert(loadfile("luaScripts/common_find.inc"))();
assert(loadfile("luaScripts/common_window.inc"))();

-------------------------------------------------------------------------------
-- makePoint(x, y)
--
-- Make a table representing a single point.
--
-- x, y -- Position which becomes result[0], result[1]
-------------------------------------------------------------------------------

function makePoint(x, y)
  if not x or not y then
    error("Incorrect number of arguments for makePoint()");
  end
  local result = {};
  result[0] = x;
  result[1] = y;
  return result;
end

-------------------------------------------------------------------------------
-- pixelCheck(anchor, offset, color, tolerance)
--
-- Checks to see whether the screen pixel at anchor+offset matches a
-- given color.
--
-- anchor -- Base location to check
-- offset -- Offset from base location
-- color -- Color to check against
-- tolerance -- 0 means exact match, >= 255 means any color
--
-- Returns true if the colors match within tolerance.
-------------------------------------------------------------------------------

function pixelMatch(anchor, offset, color, tolerance)
  local result = true;
  local screenColor = srReadPixel(anchor[0] + offset[0],
				  anchor[1] + offset[1]);
  local diffs = getPixelDiffs(color, math.floor(screenColor/256));
  for i=1,#diffs do
    if diffs[i] > tolerance then
      result = false;
      break;
    end
  end
  return result;
end

function getPixelDiffs(left, right)
  local result = {};
  for i=1,3 do
    result[i] = math.abs((left % 256) - (right % 256));
    left = math.floor(left / 256);
    right = math.floor(right / 256);
  end
  return result;
end
