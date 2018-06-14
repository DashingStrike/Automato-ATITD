-- crematory.lua v1.2 by Tallow
--
-- Runs one or more crematories. Automatically discovers button
-- configuration on its own and loads/unloads materials.
--

dofile("common.inc");

askText = singleLine([[
  Crematory v1.2 (by Tallow) --
  Automatically runs one or more crematories.
]]);

wmText = "Tap Ctrl on Crematories to open and pin.\nTap Alt to open, pin and stash.";

OPP = 0;
SAME_UP = 1;
SAME_DOWN = 2;

tolerance = 6500;
tickTime = 500;
maxWait = 1000;
longWait = 500;
shortWait = 30;

colOffsets = {
  {15, 22}, --{35-40-3, 204-182}
  {51, 22}, --{71-40-3, 204-182}
  {87, 22}, --{107-40-3, 204-182}
  {123, 22},--{143-40-3, 204-182}
  {159, 22},--{179-40-3, 204-182}
  {195, 22},--{215-40-3, 204-182}
  {231, 22} --{251-40-3, 204-182}
};

colWidth = 36-35+6;
colHeight = 323-204;
colMiddle = 57;

buttonOffsets = {
  {32, 151}, --{49-40, 333-182}
  {72, 151}, --{89-40, 333-182}
  {112, 151},--{129-40, 333-182}
  {152, 151},--{169-40, 333-182}
  {192, 151} --{209-40, 333-182}
};

buttonWidth = 78-49;
buttonHeight = 354-333;
buttonClick = 10;

limestoneOffset = 0;
leeksOffset = 16;
flaxOffset = 32;
papyrusOffset = 48;
woodOffset = 64;

load_flax = true;
load_papyrus = true;
load_leeks = true;
load_limestone = true;

currentPass = 1;
passCount = 5;

windows = nil;

-------------------------------------------------------------------------------
-- doit
-------------------------------------------------------------------------------

function doit()
  askForWindow(askText);
  windowManager("Crematory Setup", wmText);
  unpinOnExit(runCrematories);
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function runCrematories()
  promptLoad();
  askForFocus();
  for i=1,passCount do
    currentPass = i;
    local iter = 0;
    srReadScreen();
    while closeEmptyAndErrorWindows() ~= 0 and iter < 10 do
      lsSleep(100);
      checkBreak();
      srReadScreen();
      iter = iter + 1;
    end
    takeAll();
    loadAll();
    start();
    local is_done = false;
    while not is_done do
      tick();
      is_done = checkDone();
    end
    sleepWithStatus(longWait*3, updateMessage("Waiting to take"));
  end
  takeAll();
  lsPlaySound("Complete.wav");
end

-------------------------------------------------------------------------------
-- addWindow
-------------------------------------------------------------------------------

function addWindow(vPos)
  local newWindow = {
    origin = {vPos[0], vPos[1]},
    ups = {nil, nil, nil, nil, nil},
    downs = {nil, nil, nil, nil, nil},
    dirs = {OPP, OPP, OPP, OPP, OPP},
    double = {false, false, false, false, false, false, false},
    probe = 0,
    lastPos = nil;
    lastDiff = nil;
    buttonState = {true, true, true, true, true},
    sameCount = 0,
    done = false
  };
  local vFire = srFindImageInRange("crem-fire.png", newWindow.origin[1] - 31,
                                   newWindow.origin[2] - 175, 238, 175,
                                   tolerance);
  if vFire then
    newWindow.fire = {vFire[0], vFire[1]};
  else
    error "No fire button. Do you have Advanced Chemistry?"
  end
  windows[#windows + 1] = newWindow;
end

-------------------------------------------------------------------------------
-- resetWindow
-------------------------------------------------------------------------------

function resetWindow(current)
  local vLime = srFindImageInRange("crem-lime.png", current.origin[1] - 20,
                                   current.origin[2] - 20, 100, 100,
                                   tolerance);
  if (not vLime) then
     error "Could not find origin again.";
  end
  if ((vLime[0] ~= current.origin[1]) or
      (vLime[1] ~= current.origin[2])) then
     current.origin[1] = vLime[0];
     current.origin[2] = vLime[1];
  end
  local vFire = srFindImageInRange("crem-fire.png", current.origin[1] - 31,
                                   current.origin[2] - 175, 238, 175,
                                   tolerance);
  if vFire then
    current.fire = {vFire[0], vFire[1]};
  end
  if current.probe < 6 then
    current.probe = 0;
    current.ups = {nil, nil, nil, nil, nil};
    current.downs = {nil, nil, nil, nil, nil};
    current.dirs = {OPP, OPP, OPP, OPP, OPP};
    current.double = {false, false, false, false, false, false, false};
  end
  current.lastPos = nil;
  current.lastDiff = nil;
  current.buttonState = {true, true, true, true, true};
  current.sameCount = 0;
  current.done = false;
end

-------------------------------------------------------------------------------
-- start
-------------------------------------------------------------------------------

function start()
  sleepWithStatus(longWait, updateMessage("Waiting to begin"));
  srReadScreen();
  if windows then
    for i=1,#windows do
      resetWindow(windows[i]);
    end
  else
    windows = {};
    local posList = findAllImages("crem-lime.png");
    if #posList == 0 then
      error "No crematories found";
    end
    for i=1,#posList do
      addWindow(posList[i]);
    end
  end
  for i=1,#windows do
    if windows[i].fire then
      safeClick(windows[i].fire[1] + 5, windows[i].fire[2] + 5);
      lsSleep(shortWait);
    end
  end
  sleepWithStatus(longWait, updateMessage("Finding my Chi"));
  srReadScreen();
    for i=1,#windows do
         windows[i].origin[2] = windows[i].origin[2] - 7;
    end
  for i=1,#windows do
    windows[i].lastPos = findPoints(windows[i]);
    if not windows[i].lastPos then
      windows[i].done = true;
    end
  end
end

-------------------------------------------------------------------------------
-- tick
-------------------------------------------------------------------------------

function tick()
  sleepWithStatus(tickTime, updateMessage("Tending Crematory"));
  srReadScreen();
  for i=1,#windows do
    tickWindow(windows[i]);
  end
  checkBreak();
end

-------------------------------------------------------------------------------
-- tickWindow
-------------------------------------------------------------------------------

function tickWindow(current)
  if not current.done then
    local points = findPoints(current);
    if points then
      probeNext(current, points);
      if current.probe > 5 then
        toggleButtons(current, points, current.buttonState);
      end
    else
      current.done = true;
    end
  end
end

-------------------------------------------------------------------------------
-- checkDone
-------------------------------------------------------------------------------

function checkDone()
   local allFound = true;
   cremWins = findAllText("This is a Crematory", nil, REGION);
   for i = 1, #cremWins do
      safeClick(cremWins[i].x + 5, cremWins[i].y + 5);
   end
   for i = 1, #cremWins do
      if not findText("Fire the Crematory", cremWins[i]) then
         allFound = false;
      end
   end
   return allFound;
end

-------------------------------------------------------------------------------
-- findPoints
-------------------------------------------------------------------------------

function findPoints(current)
  local result = {};
  for i=1,7 do
    local offset = {current.origin[1] + colOffsets[i][1],
                    current.origin[2] + colOffsets[i][2]};
    local point = srFindImageInRange("crem-point.png", offset[1],
                                     offset[2] - 5,
                                     colWidth, colHeight + 10, tolerance);
    if point then
      result[i] = point[1] - colOffsets[i][2] - current.origin[2] - colMiddle;
    else
      result = nil;
      break;
    end
  end
  return result;
end

-------------------------------------------------------------------------------
-- findDiffs
-------------------------------------------------------------------------------

function findDiffs(current, points)
  local result = {};
  local all_zero = true;
  for i=1,7 do
    result[i] = points[i] - current.lastPos[i];
    if result[i] ~= 0 then
      all_zero = false;
    end
  end
  if all_zero then
    result = nil;
  end
  return result;
end

-------------------------------------------------------------------------------
-- probeNext
-------------------------------------------------------------------------------

function probeNext(current, points)
  local diffs = findDiffs(current, points);
  checkSame(current, diffs);
  if diffs and current.probe < 6 then
    if current.probe > 0 then
      for i=1,7 do
        if current.lastDiffs[i] < 0 and diffs[i] > 0 then
          if current.ups[current.probe] then
            current.downs[current.probe] = i;
            current.dirs[current.probe] = SAME_UP;
          else
            current.ups[current.probe] = i;
          end
        elseif current.lastDiffs[i] > 0 and diffs[i] < 0 then
          if current.downs[current.probe] then
            current.ups[current.probe] = i;
            current.dirs[current.probe] = SAME_DOWN;
          else
            current.downs[current.probe] = i;
          end
        end
      end
      if current.ups[current.probe] and current.downs[current.probe] then
        current.double[current.ups[current.probe]] = true;
        current.double[current.downs[current.probe]] = true;
      end
    end
    current.lastPos = points;
    current.lastDiffs = diffs;
    current.probe = current.probe + 1;
    if current.probe <= 5 then
      local newProbe = not current.buttonState[current.probe];
      local clickX = current.origin[1] + buttonOffsets[current.probe][1] +
    buttonClick;
      local clickY = current.origin[2] + buttonOffsets[current.probe][2] +
    buttonClick;

      current.buttonState[current.probe] = newProbe;
      safeClick(clickX, clickY);
    end
  end
end

-------------------------------------------------------------------------------
-- checkSame
-------------------------------------------------------------------------------

function checkSame(current, diffs)
  if diffs then
    local all_same = true;
    for i=1,#diffs do
      if diffs[i] ~= 0 then
        all_same = false;
      end
    end
    if all_same then
      current.sameCount = current.sameCount + 1;
    else
      current.sameCount = 0;
    end
    if current.sameCount > 10 then
      current.done = true;
    end
  end
end

-------------------------------------------------------------------------------
-- toggleButtons
-------------------------------------------------------------------------------

function toggleButtons(current, points, buttonState)
  local balance = getBalance(points, current.double);
  for i=1,5 do
    local up = getPointValue(points, current.double, current.ups[i],
                             balance);
    local down = getPointValue(points, current.double, current.downs[i],
                               balance);
    local goalState = ((up >= 0 and down <= 0) or
                       (up >= 0 and down >= 0 and up > down) or
                       (up <= 0 and down <= 0 and up > down));
    if current.dirs[i] == SAME_UP then
      goalState = ((up >= 0 and down >= 0) or
                   (up >= 0 and down <= 0 and up >= -down) or
                   (up <= 0 and down >= 0 and -up <= down));
    elseif current.dirs[i] == SAME_DOWN then
      goalState = ((up <= 0 and down <= 0) or
                   (up >= 0 and down <= 0 and up <= -down) or
                   (up <= 0 and down >= 0 and -up >= down));
    end
    local goalStateStr = "false";
    if goalState then
      goalStateStr = "true";
    end
    local buttonStr = "false";
    if buttonState[i] then
      buttonStr = "true";
    end
    if (goalState and not buttonState[i]) or
       (not goalState and buttonState[i]) then
      safeClick(current.origin[1] + buttonOffsets[i][1] + buttonClick,
        current.origin[2] + buttonOffsets[i][2] + buttonClick);
      buttonState[i] = goalState;
    end
  end
end

-------------------------------------------------------------------------------
-- getBalance
-------------------------------------------------------------------------------

function getBalance(points, double)
  local above = 0;
  local below = 0;
  for i=1,#points do
    if points[i] > 0 and double[i] then
      below = below + 1;
    elseif points[i] < 0 and double[i] then
      above = above + 1;
    end
  end

  local result = 0;
  if above >= 3 then
    result = -5;
  elseif below >= 3 then
    result = 5;
  end
  return result;
end

-------------------------------------------------------------------------------
-- getPointValue
-------------------------------------------------------------------------------

function getPointValue(points, double, index, balance)
  local result = 0;
  if index then
    result = points[index];
    if not double[index] then
      result = result + balance;
    end
  end
  return result;
end

-------------------------------------------------------------------------------
-- takeAll
-------------------------------------------------------------------------------

function takeAll()
  srReadScreen();
  local wins = findAllText("This is a Crematory", nil, REGION);
  for i, win in ipairs(wins) do
    local t = findText("Take...", win);
    if t then
      clickText(findText("Take...", win));
      t = waitForText("Everything");
      clickText(t);
      waitForNoText("Everything");
      safeClick(wins[i].x + 25, wins[i].y + 5);
    end
  end
end

-------------------------------------------------------------------------------
-- promptLoad
-------------------------------------------------------------------------------

function promptLoad()
  scale = 1.0;
  local z = 0;
  local is_done = nil;
  while not is_done do
    checkBreak("disallow pause");
    lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, "Configure");
    local y = 60;

    lsPrint(5, y, z, scale, scale, 0xffffffff, "Passes:");
    is_done, passCount = lsEditBox("passes", 110, y, z, 50, 30, scale, scale,
                                   0x000000ff, 5);
    if not tonumber(passCount) then
      is_done = false;
      lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      passCount = 1;
    end
    y = y + 48;

    load_flax = lsCheckBox(15, y, z+10, 0xffffffff, "Dried Flax",
                           load_flax);
    y = y + 32;

    load_papyrus = lsCheckBox(15, y, z+10, 0xffffffff, "Dried Papyrus",
                              load_papyrus);
    y = y + 32;

    load_leeks = lsCheckBox(15, y, z+10, 0xffffffff, "Leeks",
                            load_leeks);
    y = y + 32;

    load_limestone = lsCheckBox(15, y, z+10, 0xffffffff, "Limestone",
                                load_limestone);
    y = y + 32;

    lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xd0d0d0ff,
                   "Make sure each crematory is pinned and empty.");

    if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Begin") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end
    lsDoFrame();
    lsSleep(shortWait);
  end
end

-------------------------------------------------------------------------------
-- loadAll
-------------------------------------------------------------------------------

function loadAll()
   cremWins = findAllText("This is a Crematory", nil, REGION);
   lsPrintln("loading");
   loads = {};
   if load_flax then
      table.insert(loads, "Flax");
   end
   if load_papyrus then
      table.insert(loads, "Papyrus");
   end
   if load_limestone then
      table.insert(loads, "Limestone");
   end
   if load_leeks then
      table.insert(loads, "Leeks");
   end
   table.insert(loads, "Wood");
   for i=1, #cremWins do
      cremWin = cremWins[i]
      for i, v in ipairs(loads) do
         clickText(findText("Load the Crematory...", cremWin));
         local t = waitForText("Wood", 250, nil, nil, REGION);
         t = waitForText(v, 250, nil, t);
         clickText(t);
         t = waitForText("Load how much", 250, nil, nil, REGION);
         safeClick(t.x + t.width/2, t.bottom - 50);
         --waitForNoText("Load how much");
         waitForNoText("Load how much", 250);
      end
         --sleepWithStatus(10000,"About to start!\n\nFinal chance to abort/verify crematory is loaded correctly?!", nil, 0.7, 0.7);
   end
end

-------------------------------------------------------------------------------
-- updateMessage
-------------------------------------------------------------------------------

function updateMessage(message)
  local result = "Pass " .. currentPass .. " / " .. passCount .. "\n";
  result = result .. message .. "\n\n";
  if message == "Tending Crematory" then
    for i=1,#windows do
      local status = "Buttons: ";
      for j=1,5 do
    if windows[i].dirs[j] == OPP then
      status = status .. getDir("+", windows[i].ups[j]) ..
        getDir("-", windows[i].downs[j]);
    elseif windows[i].dirs[j] == SAME_UP then
      status = status .. getDir("+", windows[i].ups[j]) ..
        getDir("+", windows[i].downs[j]);
    else
      status = status .. getDir("-", windows[i].ups[j]) ..
        getDir("-", windows[i].downs[j]);
    end
    if j ~= 5 then
      status = status .. ", ";
    else
      status = status .. "\n";
    end
      end
      result = result .. "\n" .. status;
    end
  end
  return result;
end

function getDir(sign, number)
  local result = "";
  if number then
    result = sign .. number
  end
  return result;
end
