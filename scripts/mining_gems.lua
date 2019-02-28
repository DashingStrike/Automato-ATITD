-- mining_gems.lua v2.0.6 -- by Cegaiel
--
-- Works the sand mine, but requires a little thought and input from you ;)
-- You must click on all Quintuple colors FIRST, all Quadruple colors NEXT, all Triple colors NEXT, all Paired colors NEXT, then ALL Single colored stones LAST.
--
-- Credits to Tallow for his Simon macro, which was used as a template to build on.
-- Additional credits to Tallow for his assistance with stream lining code (embedded arrays and more efficient looping in function clickSequence() - v1.2) 
-- Thanks to Sabahl for the new 6 color (1 Pair) array, which is alternative method that breaks 6 nodes simultaneously. Supposedly better chance at a Huge Gem, when breaking more stones at same time.

-- Version has jumped from 1.3 to 2.0.  2.0 now reads main chat and no longer asks you to enter Node Delay. It should be able to run very fast and auto-adjust to lag.
-- It will pause after clicking each sequence until one of 3 things happens
-- 1: A popup occurs (popup's are bad on Sand Mines and shouldn't occur). This suggests you didn't set the stones correctly or chose wrong option on pulldown menu.
-- 2: The main chat's last line change (ie you got sand, gem or something)
-- 3: A 6 second pause has occured. Likely super lag or something wrong in macro happened (bug)

-- Version 2.0.1 Some regions give a faction bonus to Ore Yield ( this includes bonus to Sand, go figure ^_^ ).  ATITD Clock will tell when bonuses apply; ie 'Who Benefit From: Increased Ore Yield by 10%'.
-- This bonus causes two messages to appear simultaneously, in main chat, for every action that normally produces a message. 
-- 1st Message: 'Local support boosted your pull from ### to ###'. 2nd message (normal message): Your workload contained ### Sand or 'You got some coal and a Small Sapphire', etc.
-- 2.0.1 attempts to address this extra message which might result in unintended behavior. Sometimes when parsing last chat line, it catches the 'Local support boosted' message, causing it to break look prematurely.
-- Also reduced the 6s timer down to 5s (something went wrong or couldn't detect a new message (likely two messages back to back), break loop and continue).

dofile("common.inc");
dofile("settings.inc");


askText = "Sand Mining v2.0.6 by Cegaiel --\n\nMake sure chat is MINIMIZED and Main chat tab is visible!\n\nPress Shift over ATITD window.\n\nOptional: Pin the mine's Take... Gems... menu (\"All Gems\" will appear in pinned window).\n\nThis optionally pinned window will be refreshed every time the mine is worked. Also, if Huge Gem appears in any window, it will alert you with an applause sound.";

bonusRegion = false;
noMouseMove = false;
minPopSleepDelay = 150;  -- The minimum delay time used during findClosePopUp() function
muteSoundEffects = true;
autoWorkMine = false;
dropdown_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
dropdown_cur_value = 1;
dropdown_pattern_values = {"6 color (1 Pair) (*)", "5 color (2 Pair) (*)", "4 color (3 Pair) (*)", "5 color (Triple) (1)", "4 color (Triple+Pair) (3)", "4 color (Quadruple) (1)", "3 Color (Quad+Pair) (6)", "3 color (Quintuple) (2)", "7 Color (All Different) (*)"};

gui = {
[1] = "6 color (1 Pair) (*)",
[2] = "5 color (2 Pair) (*)",
[3] = "4 color (3 Pair) (*)",
[4] = "5 color (Triple) (1)",
[5] = "4 color (Triple+Pair) (3)",
[6] = "4 color (Quadruple) (1)",
[7] = "3 Color (Quad+Pair) (6)",
[8] = "3 color (Quintuple) (2)",
[9] = "7 Color (All Different) (*)"
};

dropdown_pattern_cur_value = 1;
lastLineFound = "";
lastLineFound2 = "";

allSets = {

{  --6 color (1 Pair)
{1,3,4},
{1,5,6,7},
{1,3,5},
{1,4,6,7},
{1,3,6},
{1,4,5,7},
{1,3,7},
{2,4,5,6},
{2,3,4},
{2,4,5},
{2,5,6},
{2,6,7},
{2,3,7},
{2,3,4,5,6,7}
},

{  --5 color (2 Pair)
{5,6,7},
{5,1,3},
{5,1,4},
{5,2,3},
{5,2,4},
{6,1,3},
{6,1,4},
{6,2,3},
{6,2,4},
{7,1,3},
{7,1,4},
{7,2,3},
{7,2,4},
{1,3,5,6,7},
{2,4,5,6,7}
},

{  --4 color (3 Pair)
{1,3,5},
{2,4,6,7},
{1,3,6},
{2,4,5,7},
{1,4,5},
{2,3,6,7},
{1,4,6},
{2,3,5,7},
{2,3,5},
{1,4,6,7},
{2,3,6},
{1,4,5,7},
{2,4,5},
{1,3,6,7},
{1,4,6}
},

{  --5 color (Triple)
{1,4,5},
{1,4,6},
{1,4,7},
{1,5,6},
{1,5,7},
{1,6,7},
{2,4,5},
{2,4,6},
{2,4,7},
{2,5,6},
{2,5,7},
{2,6,7},
{1,2,3},
{3,4,5,6,7}
},

{  --4 color (Triple + Pair)
{1,2,3},
{1,4,6},
{1,4,7},
{1,5,6},
{1,5,7},
{1,6,7},
{2,4,6},
{2,4,7},
{3,4,6},
{3,4,7},
{2,6,7},
{1,4,6,7}
},

{  --4 color (Quadruple)
{1,5,6},
{1,5,7},
{1,6,7},
{2,5,6},
{2,5,7},
{2,6,7},
{3,5,6},
{3,5,7},
{3,6,7},
{4,5,6,7},
{1,2,3},
{1,2,4},
{1,3,4},
{2,3,4},
{1,2,3,4}
},

{  --3 color (Quad + Pair)
{1,5,7},
{1,6,7},
{2,5,7},
{2,6,7},
{3,5,7},
{3,6,7},
{4,5,7}
},

{  --3 color (Quintuple)
{1,2,3},
{1,2,4},
{1,2,5},
{1,3,4},
{1,3,5},
{1,4,5},
{2,3,4},
{2,3,5},
{2,4,5},
{3,4,5},
{1,2,3,4,5}
},
 
{  -- 7 color (All different)
{1,2,3,4,5,6},
{1,2,3,4,5,7},
{1,2,3,4,6,7},
{1,2,3,5,6,7},
{1,2,4,5,6,7},
{1,3,4,5,6,7},
{2,3,4,5,6,7},
{1,2,3,4,5,6,7}
}

};

function doit()
  askForWindow(askText);
  promptDelays();
  getMineLoc();
  getPoints();
  clickSequence();
end

function getMineLoc()
  mineList = {};
  local was_shifted = lsShiftHeld();
    if (dropdown_cur_value == 1) then
      was_shifted = lsShiftHeld();
      key = "tap Shift";
    elseif (dropdown_cur_value == 2) then
      was_shifted = lsControlHeld();
      key = "tap Ctrl";
    elseif (dropdown_cur_value == 3) then
     was_shifted = lsAltHeld();
     key = "tap Alt";
   elseif (dropdown_cur_value == 4) then
     was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
     key = "click MWheel ";
   end
  local is_done = false;
  mx = 0;
  my = 0;
  z = 0;
  while not is_done do
    mx, my = srMousePos();
    local is_shifted = lsShiftHeld();
	if (dropdown_cur_value == 1) then
	  is_shifted = lsShiftHeld();
	elseif (dropdown_cur_value == 2) then
	  is_shifted = lsControlHeld();
	elseif (dropdown_cur_value == 3) then
	  is_shifted = lsAltHeld();
	elseif (dropdown_cur_value == 4) then
	  is_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
	end

    if is_shifted and not was_shifted then
      mineList[#mineList + 1] = {mx, my};
    end
    was_shifted = is_shifted;
    checkBreak();
    lsPrint(10, 10, z, 1.0, 1.0, 0x80ff80ff,
	    "Set Mine Location");
    local y = 50;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Lock ATITD screen (Alt+L) .");
    y = y + 20;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Suggest F5 view, zoomed about 75% out.");
    y = y + 40;
    lsPrint(5, y, z, 0.7, 0.7, 0x80ff80ff, "Hover and " .. key .. " over the MINE.");
    y = y + 40;
    lsPrint(5, y, 0, 0.6, 0.6, 0xffff80ff, "TIP (Optional):");
    y = y + 20;
    lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "For Maximum Performance (least lag) Uncheck:");
    y = y + 16;
    lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Options, Interface, Other: 'Use Flyaway Messages'");
    local start = math.max(1, #mineList - 20);
    local index = 0;
    for i=start,#mineList do
	mineX = mineList[i][1];
	mineY = mineList[i][2];
    end

  if #mineList >= 1 then
      is_done = 1;
  end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End script button";
    end
  lsDoFrame();
  lsSleep(50);
  end
end

function getPoints()
  clickList = {};
  local was_shifted = lsShiftHeld();
    if (dropdown_cur_value == 1) then
      was_shifted = lsShiftHeld();
      key = "tap Shift";
    elseif (dropdown_cur_value == 2) then
      was_shifted = lsControlHeld();
      key = "tap Ctrl";
    elseif (dropdown_cur_value == 3) then
      was_shifted = lsAltHeld();
      key = "tap Alt";
    elseif (dropdown_cur_value == 4) then
      was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
      key = "click MWheel ";
    end

  local is_done = false;
  local nx = 0;
  local ny = 0;
  local z = 0;
  while not is_done do
    nx, ny = srMousePos();
    local is_shifted = lsShiftHeld();
  	if (dropdown_cur_value == 1) then
  	  is_shifted = lsShiftHeld();
  	elseif (dropdown_cur_value == 2) then
  	  is_shifted = lsControlHeld();
  	elseif (dropdown_cur_value == 3) then
 	  is_shifted = lsAltHeld();
  	elseif (dropdown_cur_value == 4) then
  	  is_shifted = lsMouseIsDown(2);
  	end

    if is_shifted and not was_shifted and #clickList < 7 then
      clickList[#clickList + 1] = {nx, ny};
    end
    was_shifted = is_shifted;
    checkBreak();
    local y = 10;
    lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff,
            "Choose Pattern:");
    y = y + 35;
    lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
    dropdown_pattern_cur_value = lsDropdown("ArrangerDropDown2", 5, y, 0, 300, dropdown_pattern_cur_value, dropdown_pattern_values);
    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
    y = y + 20;
    lsPrint(5, y, z, 0.8, 0.8, 0xFFFFFFff,
	    "Set Node Locations (" .. #clickList .. "/7)");
    y = y + 75;
    lsSetCamera(0,0,lsScreenX*1.5,lsScreenY*1.5);
    autoWorkMine = readSetting("autoWorkMine",autoWorkMine);
    autoWorkMine = lsCheckBox(15, y, z, 0xffffffff, " Auto 'Work Mine'", autoWorkMine);
    writeSetting("autoWorkMine",autoWorkMine);
    y = y + 25;
    noMouseMove = lsCheckBox(15, y, z, 0xffffffff, " Dual Monitor (NoMouseMove) Mode", noMouseMove);
    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
    y = y - 20
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Hover and " .. key .. " each node, in this order:");
    y = y + 15;
    lsPrint(5, y, z, 0.5, 0.5, 0xf0f0f0ff, "Quintuples (5 same color), Quadruples (4 same color)");
    y = y + 15;
    lsPrint(5, y, z, 0.5, 0.5, 0xf0f0f0ff, "Triples (3 same color), Pairs (2 same color)");
    y = y + 15;
    lsPrint(5, y, z, 0.5, 0.5, 0xf0f0f0ff, "Single colored nodes (1 color)");
    y = y + 20;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Ingame Popup? Suggests you chose wrong pattern.");
    y = y + 15;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Or you need to adjust the delays (previous menu).");
    y = y + 15;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "(*) Denotes ALL stones should be broken!");
    y = y + 15;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "(#) Denotes # of stones NOT broken!");
    y = y + 25;

    local start = math.max(1, #clickList - 20);
    local index = 0;

    for i=start,#clickList do
      local xOff = (index % 4) * 70;
      local yOff = (index - index%4)/2 * 7;
      lsPrint(5 + xOff, y + yOff, z, 0.5, 0.5, 0xffffffff,
              i .. ": (" .. clickList[i][1] .. ", " .. clickList[i][2] .. ")");
      index = index + 1;
    end

  if #clickList >= 7 then
    if lsButtonText(10, lsScreenY - 30, z, 75, 0x80ff80ff, "Start") then
      is_done = 1;
    end
  end

  if #clickList == 0 then
    if lsButtonText(10, lsScreenY - 30, z, 110, 0xffff80ff, "Work Mine") then
      workMine();
	srSetMousePos(mineX, mineY);
    end
  end

  if #clickList > 0 then
    if lsButtonText(100, lsScreenY - 30, z, 75, 0xff8080ff, "Reset") then
	lsDoFrame();
	reset();
    end
  end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End script button";
    end
  lsDoFrame();
  lsSleep(100);
  end
end

function reset()
  getPoints();
  clickSequence();
end

function checkAbort()
  if lsShiftHeld() then
    sleepWithStatus(750, "Aborting ..."); 
    reset();
  end
end

function workMine()
	workMineButtonLoc = getMousePos(); 
	workMineButtonLocSet = true;
    if noMouseMove then
      srClickMouseNoMove(mineX, mineY);
      lsSleep(clickDelay);
      clickAllText("Work this Mine", 20, 2, 1); -- offsetX, offsetY, rightClick (1 = true)
    else
      srSetMousePos(mineX, mineY);
      lsSleep(clickDelay);
      --Send 'W' key over Mine to Work it (Get new nodes)
      srKeyEvent('W'); 
    end
	sleepWithStatus(1000, "Working mine (Fetching new nodes)");
	findClosePopUp(1);
end


function TakeGemWindowRefresh()
 ---- New Feature, Refresh Gem Take menu
 -- First check to see if All Gems (From mine's Take menu) is pinned up, if so refresh it.
  findAllGems = findText("All Gems");
	if findAllGems then 
		if not autoWorkMine then
	         sleepWithStatus(1000, "Refreshing pinned Gem menu ..."); -- Let pinned window catchup. If autowork mine, there is already a 1000 delay on workMine()
		end
	 safeClick(findAllGems[0],findAllGems[1]);
	end
--Now check to see if there is a Huge Gem and give a special alert.
	 lsSleep(500);
 findHugeGems = findText("Huge");
 if findHugeGems then
  lsPlaySound("applause.wav");
 sleepWithStatus(15000, "Congrats! You found a Huge Gem!\n\nYou should take it now!", 0x80ff80ff, 0.7, 0.7);
 end
end


function checkIfMain(chatText)
   for j = 1, #chatText do
      if string.find(chatText[j][2], "^%*%*", 0) then
         return true;
      end
   end
   return false;
end


function chatRead()
   srReadScreen();
   local chatText = getChatText();
   local onMain = checkIfMain(chatText);

   if not onMain then
      if not muteSoundEffects then
         lsPlaySound("timer.wav");
      end
   end

   -- Wait for Main chat screen and alert user if its not showing
   while not onMain do
   	checkBreak();
      srReadScreen();
      chatText = getChatText();
      onMain = checkIfMain(chatText);
      sleepWithStatus(100, "Looking for Main chat screen ...\n\nIf main chat is showing, then try clicking Work Mine to clear this screen");
   end

   -- Verify chat window is showing minimum 2 lines
   while #chatText < 2  do
   	checkBreak();
      srReadScreen();
      chatText = getChatText();
      sleepWithStatus(500, "Error: We must be able to read at least the last 2 lines of main chat!\n\nCurrently we only see " .. #chatText .. " lines ...\n\nYou can overcome this error by typing ANYTHING in main chat.", nil, 0.7, 0.7);
   end
   
   --Read last line of chat and strip the timer ie [01m]+space from it.
   lastLine = chatText[#chatText][2];
   lastLineParse = string.sub(lastLine,string.find(lastLine,"m]")+3,string.len(lastLine));
   --Read next to last line of chat and strip the timer ie [01m]+space from it.
   lastLine2 = chatText[#chatText-1][2];
   lastLineParse2 = string.sub(lastLine2,string.find(lastLine2,"m]")+3,string.len(lastLine2));

   if string.sub(lastLineParse, 1, 21) == "Local support boosted" or string.sub(lastLineParse2, 1, 21) == "Local support boosted" then
     bonusRegion = true;
   end

   if string.sub(lastLineParse, 1, 21) == "Local support boosted" then
     localSupportFound = true;
   else
     localSupportFound = false;
   end
end

function findClosePopUp(noRead)

   local skipRead = false;
   if noRead then
     skipRead = true;
   end

  chatRead();
  lastLineFound = lastLineParse;
  lastLineFound2 = lastLineParse2;
  startTime = lsGetTimer();

    while 1 do
	checkBreak();
	chatRead();
	OK = srFindImage("OK.png");

        if clickDelay < minPopSleepDelay then
            popSleepDelay = minPopSleepDelay;
        else
            popSleepDelay = clickDelay
        end

	  if OK then  
	    srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
            lsSleep(popSleepDelay);
	    break;
	  end

	  if (lastLineFound2 ~= lastLineParse2 and not bonusRegion) or (lastLineFound ~= lastLineParse and not localSupportFound) or (skipRead == true) or ( (lsGetTimer() - startTime) > 6000 ) or (worked-1 == #sets)  then
	    break;
	  end

    end
end


function clickSequence()
--  chatRead();
    if noMouseMove then
      sleepWithStatus(3000, "Starting... Now is your chance to move your mouse to second monitor!", nil, 0.7, 0.7);
    else
      sleepWithStatus(150, "Starting... Don\'t move mouse!");
    end

  local startMiningTime = lsGetTimer();
  worked = 1;
  sets = allSets[dropdown_pattern_cur_value];
  local pattern = "Unknown";

   for k, v in pairs(gui) do
     if k == dropdown_pattern_cur_value then
       pattern = v;
       break;
     end
   end


  for i = 1, #sets do
	local currentSet = sets[i];
	for j = 1, #currentSet do
		local currentIndex = currentSet[j];
		checkBreak();
		checkAbort();

	if noMouseMove then -- Check for dual monitor option - don't move mouse cursor over each node and send keyEvents. Instead do rightClick popup menus
                --srSetMousePos(0,180); -- Move mouse to near top right corner (below icons), once, to hopefully make node popup menus appear there.
                --lsSleep(100);

		if j == #currentSet then
                srClickMouseNoMove(clickList[currentIndex][1], clickList[currentIndex][2]);
                lsSleep(clickDelay);
                chatRead();
                lastLineFound = lastLineParse;
                lastLineFound2 = lastLineParse2;
                clickAllText("[S]", 20, 2, 1); -- offsetX, offsetY, rightClick (1 = true)
		else
                srClickMouseNoMove(clickList[currentIndex][1], clickList[currentIndex][2]);
                lsSleep(clickDelay);
                clickAllText("[A]", 20, 2, 1); -- offsetX, offsetY, rightClick (1 = true)
		end

	else -- noMouseMove

		srSetMousePos(clickList[currentIndex][1], clickList[currentIndex][2]);
		lsSleep(clickDelay);
		if j == #currentSet then
                	chatRead();
                	lastLineFound = lastLineParse;
                	lastLineFound2 = lastLineParse2;
			srKeyEvent('S');
		else
			srKeyEvent('A');
		end

	end -- noMouseMove
	end

  local y = 10;
  lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
  y = y +50
  lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "[" .. worked .. "/" .. #sets .. "]  " .. #currentSet .. " Nodes Worked: " .. table.concat(currentSet, ", "));
  y = y + 40;
  lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Pattern: " .. pattern);
  y = y + 40;
  lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Click Delay: " .. clickDelay .. " ms");
  y = y + 40;
  lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Hold Shift to Abort and Return to Menu.");
  y = y + 40;
  lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Don't touch mouse until finished!");
  if bonusRegion then
  y = y + 40;
  lsPrint(5, y, 0, 0.7, 0.7, 0x40ff40ff, "Bonus Region detected.");
  y = y + 16;
  lsPrint(5, y, 0, 0.7, 0.7, 0xff4040ff, "Read last line only. Ignore 2nd to last line.");
  end

  lsDoFrame();
  worked = worked + 1

  findClosePopUp();
  end
	if autoWorkMine then
	  workMine();
	elseif workMineButtonLocSet then
          srSetMousePos(workMineButtonLoc[0], workMineButtonLoc[1]); 
	end

  TakeGemWindowRefresh();
  reset();
end

function promptDelays()
  local is_done = false;
  local count = 1;
  while not is_done do
    checkBreak();
    local y = 10;
    lsPrint(12, y, 0, 0.8, 0.8, 0xffffffff,
            "Key or Mouse to Select Nodes:");
    y = y + 35;
    lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
	dropdown_cur_value = readSetting("dropdown_cur_value",dropdown_cur_value);
    dropdown_cur_value = lsDropdown("ArrangerDropDown", 15, y, 0, 320, dropdown_cur_value, dropdown_values);
	writeSetting("dropdown_cur_value",dropdown_cur_value);
    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
    y = y + 35;
    lsPrint(15, y, 0, 0.8, 0.8, 0xffffffff, "Click Delay (ms):");
    is_done, clickDelay = lsEditBox("delay", 155, y, 0, 50, 30, 1.0, 1.0,
                                     0x000000ff, 150);
     clickDelay = tonumber(clickDelay);
       if not clickDelay then
         is_done = false;
         lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
         clickDelay = 150;
       end
	y = y + 50;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Click Delay: Delay between most actions.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Decrease value to run faster (try increments of 50)");
	y = y + 30;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffff80ff, "Minimized chat-channels MUST be ON!");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffff80ff, "See: Options, Chat-Related, 'Minimize' section.");
	y = y + 28;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffff80ff, "Main chat tab MUST be showing and wide enough");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffff80ff, "so that word wrapping does NOT occur.");
	y = y + 28;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffff80ff, "Chat window MUST be minimized!");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffff80ff, "Main chat tab MUST be showing!");

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quitMessage);
    end
  lsDoFrame();
  lsSleep(50);
  end
  return count;
end