assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
  Menu Helper v1.0 by Tallow -- Brings up building menu(s) and finds/clicks user inputed text on each menu. 

-- Instructions: Click Add button then input text you want to find, in building menus.
Repeat if there are multiple/embedded menus per building.
Hover each building and tap Ctrl key.
It will right click the building, bring up menu(s), search for text, click it. Tap Ctrl over each building to repeat.

Press Shift over ATITD window to continue!
]]);


function doit()
  askForWindow(askText);
  local menuList = {};
  while true do
    checkBreak();
    local foo = nil;

    local y = 140;
    for i=1,#menuList do
      foo, menuList[i] = lsEditBox("menu" .. i, 10, y, 0, 250, 30, 1.0, 1.0,
				   0x000000ff, menuList[i]);
      y = y + 40;
    end

    if lsButtonText(10, lsGetWindowSize()[1] - 30, 0, 100, 0xffffffff, "Add") then
      table.insert(menuList, "");
    end

    statusScreen("Click Add button...\nEnter text to click on each menu\nTap Ctrl over building to execute");
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

