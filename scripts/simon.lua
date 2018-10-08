-- simon.lua v1.1 -- by Tallow
--
-- Set up a list of points to click on request. Useful for paint or
-- ad-hoc macros.
--

dofile("common.inc");

askText = singleLine([[
  Simon v1.1 (by Tallow) --
  Sets up a list of points and then click on them in sequence.
]]);

clickList = {};
clickDelay = 150;
is_stats = true;
passDelay = 0;

function getPoints()
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
	    "Adding Points (" .. #clickList .. ")");
    local y = 60;
    lsPrintWrapped(5, y, z, lsScreenX - 20, 0.7, 0.7, 0xFFFFFFff, "Hover mouse over a point (to click) and Tap Shift to add point.");
    y = y + 50;
    local start = math.max(1, #clickList - 20);
    local index = 0;
    for i=start,#clickList do
      local xOff = (index % 3) * 100;
      local yOff = (index - index%3)/2 * 15;
      lsPrint(20 + xOff, y + yOff, z, 0.5, 0.5, 0xffffffff,
              "(" .. clickList[i][1] .. ", " .. clickList[i][2] .. ")");
      index = index + 1;
    end

    if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end
    lsDoFrame();
    lsSleep(10);
  end
end

function promptRun()
  local is_done = false;
  local count = 1;
  local scale = 0.8;
  while not is_done do
    checkBreak();
    lsPrint(10, 10, 0, scale, scale, 0xffffffff,
            "Configure Sequence");
    local y = 60;
    lsPrint(5, y, 0, scale, scale, 0xffffffff, "Passes:");
    is_done, count = lsEditBox("passes", 140, y, 0, 50, 30, scale, scale,
                               0x000000ff, 1);
    count = tonumber(count);
    if not count then
      is_done = false;
      lsPrint(10, y+30, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      count = 1;
    end
    y = y + 48
    lsPrint(5, y, 0, scale, scale, 0xffffffff, "Pass Delay (ms):");
    is_done, passDelay = lsEditBox("passDelay", 140, y, 0, 100, 30, scale, scale,
                               0x000000ff, passDelay);
    passDelay = tonumber(passDelay);
    if not passDelay then
      is_done = false;
      lsPrint(10, y+30, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      passDelay = 0;
    end
    y = y + 48;
    lsPrintWrapped(5, y, z, lsScreenX - 20, 0.65, 0.65, 0xFFFFFFff, "Pass Delay: How long to wait, after each click sequence, before moving onto the next pass.");
    y = y + 55;
    is_stats = CheckBox(10, y, 10, 0xffffffff, " Wait for Stats", is_stats);
    y = y + 32;
    if not is_stats then
      lsPrint(5, y, 0, scale, scale, 0xffffffff, "Click Delay (ms):");
      is_done, clickDelay = lsEditBox("delay", 140, y, 0, 50, 30, scale, scale,
                                      0x000000ff, 100);
      clickDelay = tonumber(clickDelay);
      if not clickDelay then
        is_done = false;
        lsPrint(10, y+30, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        clickDelay = 150;
      end
    end

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Begin") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quit_message);
    end

    lsSleep(50);
    lsDoFrame();
  end
  return count;
end

function clickSequence(count)
  message = "";
  for i=1,count do
    for j=1,#clickList do
      checkBreak();
      safeClick(clickList[j][1], clickList[j][2]);


      message = "Pass " .. i .. "/" .. count .. " -- ";
      message = message .. "Clicked " .. j .. "/" .. #clickList .. "\n";
      if is_stats then
	sleepWithStatus(500, message .. "Waiting between clicks");
        waitForStats(message .. "Waiting For Stats");
      else
        sleepWithStatus(clickDelay, message .. "Waiting Click Delay");
      end
    end
		if passDelay > 0 and i < count then
	        sleepWithStatus(passDelay, message .. "Waiting on Pass Delay");
		end
  end
  lsPlaySound("Complete.wav");
end

function doit()
  askForWindow(askText);
  getPoints();

  local is_done = false;
  while not is_done do
    local count = promptRun();
    if count > 0 then
      askForFocus();
      clickSequence(count);
    else
      is_done = true;
    end
  end
end

function waitForStats(message)
  local stats = findStats();
  while not stats do
    sleepWithStatus(500, message, 0xff3333ff);
    stats = findStats();
  end
end

function findStats()
  srReadScreen();
  local stats = srFindImage("AllStats-Black.png");
  if not stats then
    stats = srFindImage("AllStats-Black2.png");
  end
  if not stats then
    stats = srFindImage("AllStats-Black3.png");
  end
  return stats;
end
