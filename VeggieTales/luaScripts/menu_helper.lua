assert(loadfile("luaScripts/common.inc"))();

function doit()
  askForWindow("Menu Helper v1.0 by Tallow");
  local menuList = {};
  while true do
    local foo = nil;

    local y = 100;
    for i=1,#menuList do
      foo, menuList[i] = lsEditBox("menu" .. i, 10, y, 0, 250, 30, 1.0, 1.0,
				   0x000000ff, menuList[i]);
      y = y + 50;
    end

    if lsButtonText(10, lsGetWindowSize()[1] - 40, 0, 100, 0xffffffff, "Add") then
      table.insert(menuList, "");
    end

    statusScreen("Enter menu options to select");
    if lsControlHeld() then
      while lsControlHeld() do
	checkBreak();
      end
      local pos = getMousePos();
      safeClick(pos[0], pos[1]);
      for i=1,#menuList do
	if menuList[i] ~= "" then
	  pos = waitForText(menuList[i], 5000, "Waiting for " .. menuList[i]);
	  safeClick(pos[0] + 10, pos[1] + 5);
	end
      end
    end
  end
end
