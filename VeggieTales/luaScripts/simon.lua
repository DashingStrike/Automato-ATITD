-- Simon by Tallow
-- Set up a list of points to click on request. Idea use would be pinning up a menu, like paints for example.
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

clickList = {};
clickDelay = 150;

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

    checkBreak("disallow pause");
    lsPrint(10, 10, z, 1.0, 1.0, 0xFFFFFFff, "Adding Points");
    local y = 60;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Tap shift to add a point.");
    y = y + 30;
    for i=1,#clickList do
      local index = i - 1;
      local xOff = (index % 3) * 100;
      local yOff = (index - index%3)/2 * 15;
      lsPrint(20 + xOff, y + yOff, z, 0.5, 0.5, 0xffffffff,
              "(" .. clickList[i][1] .. ", " .. clickList[i][2] .. ")");
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
  while not is_done do
    checkBreak("disallow pause");
    lsPrint(10, 10, 0, 1.0, 1.0, 0xffffffff,
            "Configure Sequence");
    local y = 60;
    lsPrint(5, y, 0, 1.0, 1.0, 0xffffffff, "Passes:");
    is_done, count = lsEditBox("passes", 120, y, 0, 50, 30, 1.0, 1.0,
                               0x000000ff, 1);
    count = tonumber(count);
    if not count then
      is_done = false;
      lsPrint(10, y+18, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      count = 1;
    end

    y = y + 48;
    lsPrint(5, y, 0, 1.0, 1.0, 0xffffffff, "Delay (ms):");
    is_done, clickDelay = lsEditBox("delay", 120, y, 0, 50, 30, 1.0, 1.0,
                                    0x000000ff, 100);
    clickDelay = tonumber(clickDelay);
    if not clickDelay then
      is_done = false;
      lsPrint(10, y+18, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      clickDelay = 100;
    end

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Begin") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end

    lsSleep(50);
    lsDoFrame();
  end
  return count;
end

function clickAll(count)
  for i=1,count do
    for j=1,#clickList do
      checkBreak("disallow pause");
      srClickMouseNoMove(clickList[j][1], clickList[j][2]);
      lsPrint(10, 10, 0, 1.0, 1.0, 0xffffffff,
              "Pass " .. i .. "/" .. count);
      lsPrint(10, 40, 0, 1.0, 1.0, 0xffffffff,
              "Clicked " .. j .. "/" .. #clickList);
      lsSleep(clickDelay);
      lsDoFrame();
    end
  end
end

function doit()
  askForWindow("You will be asked to set up a sequence of points using the mouse and shift. Then you will be able to click that sequence on request. One example of usage is pinning up a menu and it will click the menu in a desired pattern. Press SHIFT to continue.");
  getPoints();

  local is_done = false;
  while not is_done do
    local count = promptRun();
    if count > 0 then
      clickAll(count);
    else
      is_done = true;
    end
  end
end
