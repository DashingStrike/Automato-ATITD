-- apiary.lua v1.0 -- by Cegaiel. Credits to Tallow for bits of code taken from simon.lua
--
-- Checks and Takes everything, from all of your apiaries.
-- It sends the 'C' (Check) key over each one, waits for the OK box to disappear, then sends the 'T' to take. 
-- Make sure chat is minimized!
--

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
  Apiary Checker v1.0 by Cegaiel --
  Checks and Takes everything from all of your apiaries.
  Make sure chat is minimized!
  Press Shift over ATITD window to continue.
]]);

function doit()
  askForWindow(askText);
  getPoints();
  clickSequence();
  error 'Done, checked all apiaries!';
end

function clickSequence()
  sleepWithStatus(200, "Starting... Don\'t move mouse!");
    for i=1,#clickList do
	checkBreak();
	srSetMousePos(clickList[i][1], clickList[i][2]);
	lsSleep(100); -- ~65+ delay needed before the mouse can actually move.
	checkHives(i);
    end
end

function checkHives(apiary)
  checkBreak();
  local OK = true;
  srKeyEvent('c'); --Check [C]
  sleepWithStatus(500, "[" .. apiary .. "/" .. #clickList .."] Checking...");

    while OK do
	--Wait, loop forever if OK box is present. Only when OK box is not present, then continue and Take
	checkBreak();
	srReadScreen();
	OK = srFindImage("OK.png"); -- If OK box present, then OK = true. If OK box not present, then OK = false
	lsSleep(50);
    end

  srKeyEvent('t');  -- Take [T]
  sleepWithStatus(150, "[" .. apiary .. "/" .. #clickList .."] Taking...");
end

function getPoints()
clickList = {};
  local was_shifted = lsShiftHeld();
  local is_done = false;
  local mx = 0;
  local my = 0;
  local z = 0;
  while not is_done do
    mx, my = srMousePos();
    local is_shifted = lsShiftHeld();
    if is_shifted and not was_shifted then
      clickList[#clickList + 1] = {mx, my};
    end
    was_shifted = is_shifted;
    checkBreak();
    lsPrint(10, 10, z, 1.0, 1.0, 0xFFFFFFff,
	    "Set Apiary Locations (" .. #clickList .. ")");
    local y = 60;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Select camera and zoom level");
    y = y + 20
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "that best fits apiaries in screen.")
    y = y + 20
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Suggest: F5 zoomed out or F8F8.")
    y = y + 20
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Lock ATITD screen with Alt+L")
    y = y + 40;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "MAKE SURE CHAT IS MINIMIZED!")
    y = y + 40;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "1) Set all apiary locations:");
    y = y + 20;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Hover mouse, Tap Shift over each apiary.")
    y = y + 30;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "2) After setting all apiariy locations:")
    y = y + 20;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Click Start to begin checking apiaries.")

    if #clickList >= 1 then -- Only show start button if one or more apiaries was selected.
      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Start") then
        is_done = 1;
      end
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(10);
  end
end