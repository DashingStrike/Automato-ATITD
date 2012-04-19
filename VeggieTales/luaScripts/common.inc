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
  local result = {};
  result[0] = x;
  result[1] = y;
  return result;
end
