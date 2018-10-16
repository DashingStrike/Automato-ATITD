-- simon.lua v1.1 -- by Tallow
-- simon.lua v1.12 -- Tweaked by Cegaiel - Add Pass Delay box, various GUI tweaks.
--   Added read/writeSettings routine to save configuration to file (Settings.simon.lua.txt)
--   Next button hidden until at least one point added. Displays in realtime, the coordinates clicked. Do Right clicks, so we don't accidentally run on a misclick.
--
-- Set up a list of points to click on request. Useful for paint or
-- ad-hoc macros.
--

dofile("common.inc");
dofile("settings.inc");

askText = "Simon v1.12\n\nv1.1 - by Tallow\nv1.12 - Tweaked by Cegaiel\n\nSets up a list of points and then clicks on them in sequence.\n\nCan optionally add a timer to wait between each pass (ie project takes a few minutes to complete).\n\nOr will watch Stats Timer (red/black) for clicking.";

clickList = {};
clickDelay = 150;
is_stats = true;
passDelay = 0;
refresh = true;

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

    if #clickList > 0 then -- Don't show Next button until at least one point is added
      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Next") then
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
    count = readSetting("count",count);
    is_done, count = lsEditBox("passes", 140, y, 0, 50, 30, scale, scale,
                               0x000000ff, count);
    count = tonumber(count);
    if not count then
      is_done = false;
      lsPrint(10, y+30, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      count = 1;
    end
    writeSetting("count",count);
    y = y + 45;
    refresh = readSetting("refresh",refresh);
    lsPrint(165, y+2, 0, 0.6, 0.6, 0xffffffff, "(after each pass)");
    refresh = CheckBox(10, y, 10, 0xffffffff, " Refresh Windows", refresh);
    writeSetting("refresh",refresh);
    y = y + 32;
    is_stats = readSetting("is_stats",is_stats);
    lsPrint(136, y+2, 0, 0.6, 0.6, 0xffffffff, "(I\'m Tired - Red/Black Stats)");
    is_stats = CheckBox(10, y, 10, 0xffffffff, " Wait for Stats", is_stats);
    writeSetting("is_stats",is_stats);
    y = y + 32;
    if not is_stats then
      lsPrint(5, y, 0, scale, scale, 0xffffffff, "Click Delay (ms):");
      clickDelay = readSetting("clickDelay",clickDelay);
      is_done, clickDelay = lsEditBox("delay", 140, y, 0, 50, 30, scale, scale,
                                      0x000000ff, clickDelay);
      clickDelay = tonumber(clickDelay);
      if not clickDelay then
        is_done = false;
        lsPrint(10, y+30, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        clickDelay = 150;
      end
      writeSetting("clickDelay",clickDelay);

    y = y + 48
    lsPrint(5, y, 0, scale, scale, 0xffffffff, "Pass Delay (s):");
    passDelay = readSetting("passDelay",passDelay);
    is_done, passDelay = lsEditBox("passDelay", 140, y, 0, 50, 30, scale, scale,
                               0x000000ff, passDelay);
    passDelay = tonumber(passDelay);
    if not passDelay then
      is_done = false;
      lsPrint(10, y+30, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      passDelay = 0;
    end
    lsPrint(200, y+6, 0, 0.6, 0.6, 0xffffffff, math.floor(passDelay*1000) .. " (ms)");
    writeSetting("passDelay",passDelay);
    y = y + 48;
    lsPrintWrapped(5, y, z, lsScreenX - 20, 0.65, 0.65, 0xFFFFFFff, "Pass Delay: How long to wait, after each click sequence, before moving onto the next pass.");
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
  clickedPoints = "";
  refreshWindows()

    for j=1,#clickList do
      checkBreak();
      safeClick(clickList[j][1], clickList[j][2]);
      clickedPoints = clickedPoints .. "Clicked " .. j .. "/" .. #clickList .. "  (" .. clickList[j][1] .. ", " .. clickList[j][2] .. ")\n";
      message = "Pass " .. i .. "/" .. count .. " -- ";
      message = message .. "Clicked " .. j .. "/" .. #clickList .. "\n\n"  .. clickedPoints;
      if is_stats then
	sleepWithStatus(150, message .. "\nWaiting between clicks", nil, 0.67, 0.67);
	  closePopUp(); -- Check for lag/premature click that might've caused a popup box (You're too tired, wait xx more seconds)
        waitForStats(message .. "Waiting For Stats");
      else
        sleepWithStatus(clickDelay, message .. "\nWaiting Click Delay", nil, 0.67, 0.67);
      end
    end
		--if passDelay > 0 and not is_stats and (i < count) then  --Uncomment so you don't have to wait the full passDelay countdown on last pass; script exits on last pass immediately .
		if passDelay > 0 and not is_stats then -- No need for passDelay timer if it's 0 or we're using Wait for Stats option
	        sleepWithStatus(math.floor(passDelay*1000), message .. "\nWaiting on Pass Delay: " .. passDelay .. "s  (" .. math.floor(passDelay*1000) .. " ms)" , nil, 0.67, 0.67);
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

function closePopUp()
  srReadScreen()
  local ok = srFindImage("OK.png")
  if ok then
    srClickMouseNoMove(ok[0]+5,ok[1],1);
  end
end

function refreshWindows()
  srReadScreen();
  pinWindows = findAllImages("UnPin.png");
	for i=1, #pinWindows do
	  checkBreak();
	  safeClick(pinWindows[i][0] - 7, pinWindows[i][1]);
	  lsSleep(100);
  	end
  lsSleep(1000);
end
