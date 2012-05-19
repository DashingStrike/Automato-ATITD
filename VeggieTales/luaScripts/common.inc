-- common.inc
--
-- Common utility functions useful for most macros
--

-- Time to wait between iterations when polling for state change.
tick_delay = 10;

-- Time to wait between independent clicks
click_delay = 50;

-- Whether to allow the user to pause the macro
allow_pause = true;

-- Standard message to print when the user aborts the macro.
quit_message = "Macro aborted by user";


-------------------------------------------------------------------------------
-- singleLine(message)
--
-- Useful for embedding long text messages in code.
--
-- Converts a multi-line text blob into a single line. Whitespace at
-- the beginning and end is removed. Any newline followed by
-- whitespace is replaced by a single space.
--
-- message -- Blob of text to convert
-------------------------------------------------------------------------------

function singleLine(message)
  if not message then
    error("Incorrect number of arguments for singleLine()");
  end
  local str = string.gsub(message, "^%s+", "");
  str = string.gsub(message, "%s+$", "");
  return string.gsub(str, "\n%s*", " ");
end

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
-- makeBox(x, y, width, height)
--
-- Make a table representing a box which bounds a rectangular region.
--
-- x, y -- Position of upper-left corner of the box
-- width, height -- Size of box
-------------------------------------------------------------------------------

function makeBox(x, y, width, height)
  if not x or not y or not width or not height then
    error("Incorrect number of arguments for makeBox()");
  end
  return
    {
      x = x,
      y = y,
      width = width,
      height = height,
      left = x,
      top = y,
      right = x + width,
      bottom = y + height
    };
end

-------------------------------------------------------------------------------
-- csplit(str, sep)
--
-- Splits str into an array using sep as a single character seperator.
-- From: http://lua-users.org/wiki/SplitJoin
--
-- str -- string to be separated
-- sep -- single character
-------------------------------------------------------------------------------

function csplit(str,sep)
  local ret={}
  local n=1
  for w in str:gmatch("([^"..sep.."]*)") do
    ret[n]=ret[n] or w -- only set once (so the blank after a string is ignored)
    if w=="" then n=n+1 end -- step forwards on a blank but not a string
  end
  return ret
end

assert(loadfile("luaScripts/common_fix.inc"))();
assert(loadfile("luaScripts/common_ui.inc"))();
assert(loadfile("luaScripts/common_wait.inc"))();
assert(loadfile("luaScripts/common_click.inc"))();
assert(loadfile("luaScripts/common_find.inc"))();
assert(loadfile("luaScripts/common_window.inc"))();
assert(loadfile("luaScripts/common_text.inc"))();
assert(loadfile("luaScripts/common_gps.inc"))();
