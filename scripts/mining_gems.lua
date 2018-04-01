-- mining_sand.lua v2.0 -- by Cegaiel
--
-- Works the sand mine, but requires a little thought and input from you ;)
-- You must click on all Quintuple colors FIRST, all Quadruple colors NEXT, all Triple colors NEXT, all Paired colors NEXT, then ALL Single colored stones LAST.
--
-- Credits to Tallow for his Simon macro, which was used as a template to build on.
-- Additional credits to Tallow for his assistance with stream lining code (embedded arrays and more efficient looping in function clickSequence() - v1.2) 
-- Thanks to Sabahl for the new 6 color (1 Pair) array, which is alternative method that breaks 6 nodes simutaneously. Supposedly better chance at a Huge Gem.

--Version has jumped from 1.3 to 2.0.  2.0 now reads main chat and no longer asks you to enter Node Delay. It should be able to run very fast and auto-adjust to lag.
--It will pause after clicking each sequence until one of 3 things happens
--1: A popup occurs (popup's are bad on Sand Mines and shouldn't occur). This suggests you didn't set the stones correctly or chose wrong option on pulldown menu
--2: The main chat's last line change (ie you got sand, gem or something)
--3: A 6 second pause has occured. Likely super lag or something wrong in macro happened (bug)


dofile("common.inc");
dofile("settings.inc");


askText = "Sand Mining v2.0 by Cegaiel --\n\nMake sure chat is MINIMIZED and Main chat tab is visible!\n\nPress Shift over ATITD window.\n\nOptional: Pin the mine's Take... Gems... menu (\"All Gems\" will appear in pinned window).\n\nThis optionally pinned window will be refreshed every time the mine is worked. Also, if Huge Gem appears in any window, it will alert you with an applause sound.";


muteSoundEffects = true;
autoWorkMine = false;
dropdown_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
dropdown_cur_value = 1;
dropdown_pattern_values = {"6 color (1 Pair) (*)", "5 color (2 Pair) (*)", "4 color (3 Pair) (*)", "5 color (Triple) (1)", "4 color (Triple+Pair) (3)", "4 color (Quadruple) (1)", "3 Color (Quad + Pair) (6)", "3 color (Quintuple) (2)", "7 Color (All Different) (*)"};
dropdown_pattern_cur_value = 1;

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
    lsPrint(10, 10, z, 1.0, 1.0, 0xFFFFFFff,
	    "Set Mine Location");
    local y = 60;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Lock ATITD screen (Alt+L) .");
    y = y + 20;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Suggest F5 view, zoomed about 75% out.");
    y = y + 60;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Hover and " .. key .. " over the MINE.");
    y = y + 70;
    lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "TIP (Optional):");
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
      local xOff = (index % 3) * 100;
      local yOff = (index - index%3)/2 * 15;
      lsPrint(20 + xOff, y + yOff, z, 0.5, 0.5, 0xffffffff,
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
	local pos = getMousePos();	
      workMine();
	srSetMousePos(pos[0], pos[1]);
    end
  end

  if #clickList > 0 then
    if lsButtonText(100, lsScreenY - 30, z, 75, 0xff8080ff, "Reset") then
	reset();
    end
  end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End script button";
    end
  lsDoFrame();
  lsSleep(50);
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
      srSetMousePos(mineX, mineY);
      lsSleep(clickDelay);
      --Send 'W' key over Mine to Work it (Get new nodes)
      srKeyEvent('W'); 
      sleepWithStatus(1000, "Working mine (Fetching new nodes)");
	findClosePopUp();
end


function TakeGemWindowRefresh()
 ---- New Feature, Refresh Gem Take menu
 -- First check to see if All Gems (From mine's Take menu) is pinned up, if so refresh it.
 findAllGems = findText("All Gems");
	if findAllGems then 
	 safeClick(findAllGems[0],findAllGems[1]);
	end
--Now check to see if there is a Huge Gem and give a special alert.
	 lsSleep(1000);
 findHugeGems = findText("Huge");
 if findHugeGems then
  lsPlaySound("applause.wav");
 sleepWithStatus(15000, "Congrats! You found a huge gem... You should take it now! If you have a Huge Gem in inventory, then hide your inventory to stop this alert/applause.");
 end

end


function checkIfMain(chatText)
   for j = 1, #chatText do
      if string.find(chatText[j][2], "^%*%*", 0) then
         return true;
      end
	-- Below isn't needed unless we are going to use Chat_Types Array
      --for k, v in pairs(Chat_Types) do
         --if string.find(chatText[j][2], k, 0, true) then
            --return true;
         --end
      --end


   end
   return false;
end


function chatRead()
   local chatText = getChatText();
   lsSleep(100);
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
   
   lastLine = chatText[#chatText][2];
   --Read last line of chat and strip the timer ie [01m]+space from it.
   lastLineParse = string.sub(lastLine,string.find(lastLine,"m]")+3,string.len(lastLine));

end


function findClosePopUp()

  lastLineFound = lastLineParse;
  startTime = lsGetTimer();

    while 1 do
      checkBreak();
      srReadScreen();
	chatRead();
	lsSleep(100);
       OK = srFindImage("OK.png");

	  if (lastLineFound ~= lastLineParse) or ( (lsGetTimer() - startTime) > 6000) then
	    break;
	  end

	  if OK then  
	    srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
	    lsSleep(clickDelay);
	    break;
	  end
    end
end


function clickSequence()
  sleepWithStatus(150, "Starting...");
  chatRead();

  local startMiningTime = lsGetTimer();
  local worked = 1;

  local sets = allSets[dropdown_pattern_cur_value];
  for i = 1, #sets do
	local currentSet = sets[i];
	for j = 1, #currentSet do
		local currentIndex = currentSet[j];
		checkBreak();
		checkAbort();
		srSetMousePos(clickList[currentIndex][1], clickList[currentIndex][2]);
		lsSleep(clickDelay);
		if j == #currentSet then
			srKeyEvent('S');
		else
			srKeyEvent('A');
		end
	end

  local y = 10;
  lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
  y = y +50
  lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "[" .. worked .. "/" .. #sets .. "]  " .. #currentSet .. " Nodes Worked: " .. table.concat(currentSet, ", "));
  y = y + 40;
  lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Node Delay: " .. clickDelay .. " ms");
  y = y + 40;
  lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Hold Shift to Abort and Return to Menu.");
  y = y + 40;
  lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Don't touch mouse until finished!");
  lsDoFrame();
  worked = worked + 1
  findClosePopUp();
  end
	if autoWorkMine then
	workMine();
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
    lsPrint(15, y, 0, 0.8, 0.8, 0xffffffff, "Node Delay (ms):");
    is_done, clickDelay = lsEditBox("delay", 165, y, 0, 50, 30, 1.0, 1.0,
                                     0x000000ff, 150);
     clickDelay = tonumber(clickDelay);
       if not clickDelay then
         is_done = false;
         lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
         clickDelay = 200;
       end
	y = y + 60;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Node Delay: Delay between selecting each node.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Decrease value to run faster (try increments of 50)");
	y = y + 60;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffff80ff, "Minimized Chat Channels MUST BE VISIBLE!");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffff80ff, "Options, Chat-Related, Minimize");
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