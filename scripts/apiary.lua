-- apiary.lua v1.12 -- by Cegaiel. Credits to Tallow for bits of code taken from simon.lua
--
-- Checks and Takes everything, from all of your apiaries.
-- It sends the 'C' (Check) key over each one, waits for the OK box to disappear, then sends the 'T' to take. 
-- Make sure chat is minimized!
--

dofile("common.inc");


askText = "Apiary Checker v1.12 by Cegaiel\n \nAllows you to quickly set all of your apiary locations by tapping Shift over each one.\n \nThen run and it will Check, wait for OK box, then Take everything from all of your apiaries.\n \nMake sure CHAT IS MINIMIZED!\n \nPress Shift over ATITD window to continue.";

clickList = {};
numRan = 0;

function doit()
  askForWindow(askText);
  getPoints();
  clickSequence();
end

function clickSequence()
  sleepWithStatus(500, "Starting... Don\'t move mouse!", nil, 0.7, 0.7);
    for i=1,#clickList do
	checkBreak();
	srSetMousePos(clickList[i][1], clickList[i][2]);
	lsSleep(100); -- ~65+ delay needed before the mouse can actually move.
	checkHives(i,clickList[i][1],clickList[i][2]);
	count = i;
    end

  numRan = numRan + 1;
  lsPlaySound("Complete.wav");
  getPoints();
end

function checkHives(apiary,x,y)
  checkBreak();
  local OK = true;
  srKeyEvent('c'); --Check [C]
  sleepWithStatus(500, x .. ", " .. y .. "\n\n[" .. apiary .. "/" .. #clickList .."] Checking Apiary ...", nil, 0.7, 0.7);

    while OK do
	--Wait, loop forever if OK box is present. Only when OK box is not present, then continue and Take
	checkBreak();
	srReadScreen();
	OK = srFindImage("OK.png"); -- If OK box present, then OK = true. If OK box not present, then OK = false
      sleepWithStatus(50, x .. ", " .. y .. "\n\n[" .. apiary .. "/" .. #clickList .."] Waiting for OK", nil, 0.7, 0.7);
    end

  srKeyEvent('t');  -- Take [T]
  sleepWithStatus(150, x .. ", " .. y .. "\n\n[" .. apiary .. "/" .. #clickList .."] Taking Apiary ...", nil, 0.7, 0.7);
end

function getPoints()
--clickList = {};
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
    lsPrint(10, 10, z, 0.8, 0.8, 0xFFFFFFff,
	    "Set Apiary Locations (" .. #clickList .. ")");
    local y = 45;
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
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "2) After setting all apiary locations:")
    y = y + 20;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Click Start/Repeat to begin checking apiaries.")

    if #clickList >= 1 and numRan == 0 then -- Only show start button if one or more apiaries was selected.
      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Start") then
        is_done = 1;
        clickSequence();
      end
end

    if #clickList >= 1 then
      if lsButtonText(10, lsScreenY - 60, z, 100, 0xFFFFFFff, "Reset Locations") then
        is_done = false;
	  clickList = {};
	  numRan = 0;
      end
    end


    if #clickList >= 1 and numRan > 0 then -- Only show start button if one or more apiaries was selected.
      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Repeat Last") then
        clickSequence();
      end
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(50);
  end
end