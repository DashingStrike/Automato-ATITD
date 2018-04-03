-- Pottery_Wheel.lua v1.0 -- by Darkfyre. Credits to Cegaiel for the base code taken from apiary.lua, time_left code from wood.lua, and elements of the mining_ore.lua
--

-- assert(loadfile("luaScripts/common.inc"))(); --

dofile("common.inc");

askText = singleLine([[
  Pottery Wheel - Make Jugs v1.0 by Darkfyre --
  Marks pottery wheel locations and makes jugs.
  Make sure chat is minimized!
  Press Shift over ATITD window to continue.
]]);

askText = "Pottery Wheel - Make Jugs v1.0 by Darkfyre\n \nAllows you to quickly set all of your pottery wheel locations by tapping the selected key over each one.\n \nThen run and it will make jugs on all marked pottery wheels.\n \nMake sure CHAT IS MINIMIZED!\n \nPress Shift over ATITD window to continue.";

total_delay_time = 72000;
dropdown_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
dropdown_cur_value = 1;

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
  local mx = 0;
  local my = 0;
  local z = 0;
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
      clickList[#clickList + 1] = {mx, my};
    end
    was_shifted = is_shifted;
    checkBreak();
    lsPrint(10, 10, z, 0.7, 0.7, 0xFFFFFFff,
	    "Set Pottery Wheel Locations (" .. #clickList .. ")");
    local y = 60;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Select camera and zoom level");
    y = y + 20
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "that best fits the pottery wheels in screen.")
    y = y + 20
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Suggest: F8F8 view.")
    y = y + 20
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Lock ATITD screen with Alt+L")
    y = y + 40;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "MAKE SURE CHAT IS MINIMIZED!")
    y = y + 40;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "1) Set all pottery wheel locations:");
    y = y + 20;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Hover mouse, " .. key .. " over each")
    y = y + 20;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "pottery wheel.")
    y = y + 30;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "2) After setting all pottery wheel locations:")
    y = y + 20;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Click Start to begin checking pottery wheels.")

    if #clickList >= 1 then -- Only show start button if one or more pottery wheel was selected.
      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Start") then
        is_done = 1;
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


function doit()
  askForWindow(askText);
  promptDelays();
  getPoints();
  clickSequence();
end

function findClosePopUp()
  lsSleep(popDelay);
    while 1 do
      checkBreak();
      srReadScreen();
      OK = srFindImage("OK.png");
	  if OK then  
	    srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
	    lsSleep(clickDelay);
	  else
	    break;
	  end
    end
end





function checkCloseWindows()
-- Rare situations a click can cause a window to appear for a pottery wheel, blocking the view to other pottery wheels.
-- This is a safeguard to keep random windows that could appear, from remaining on screen and blocking the view of other pottery wheels from being selected.
	srReadScreen();
	local closeWindows = findAllImages("thisis.png");

	  if #closeWindows > 0 then
		for i=#closeWindows, 1, -1 do
		  -- 2 right clicks in a row to close window (1st click pins it, 2nd unpins it
		  srClickMouseNoMove(closeWindows[i][0]+5, closeWindows[i][1]+10, true);
		  lsSleep(100);
		  srClickMouseNoMove(closeWindows[i][0]+5, closeWindows[i][1]+10, true);
		end
		lsSleep(clickDelay);
	  end
end

function clickSequence()

	sleepWithStatus(500, "Starting... Don\'t move mouse!");
	startTime = lsGetTimer();
	for l=1, num_loops do  
    	for i=1,#clickList do
		checkBreak();
		srSetMousePos(clickList[i][1], clickList[i][2]);
		lsSleep(100); -- ~65+ delay needed before the mouse can actually move.
		MakeJugs(i);
		count = i;
    	end
    local time_left = total_delay_time - #clickList * wheelDelay;
	sleepWithStatus(time_left,"Pass " .. l .. " of " .. num_loops .. "\nWaiting for jugs to finish");
	end
	    
    for i=1,#clickList do
	checkBreak();
	srSetMousePos(clickList[i][1], clickList[i][2]);
	lsSleep(100); -- ~65+ delay needed before the mouse can actually move.
	TakeJugs(i);
	count = i;
	end
	
  lsPlaySound("Complete.wav");
  lsMessageBox("Elapsed Time:", getElapsedTime(startTime), 1);
end

function MakeJugs()
  checkBreak();
  findClosePopUp(); -- Screen clean up
  checkCloseWindows(); -- Screen clean up
  local OK = true;
  srKeyEvent('j'); -- Make Jug [J]
  sleepWithStatus(wheelDelay,"Starting Jugs");
  findClosePopUp(); -- Screen clean up
  checkCloseWindows(); -- Screen clean up
end

function TakeJugs()
  checkBreak();
  findClosePopUp(); -- Screen clean up
  checkCloseWindows(); -- Screen clean up
  local OK = true;
  srKeyEvent('t'); -- Take Everything [T]
  sleepWithStatus(wheelDelay,"Taking Jugs");
end

function promptDelays()
  local is_done = false;
  local count = 1;
  while not is_done do
	checkBreak();
	local y = 10;
	lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff,
            "Key or Mouse to Select Nodes:");
	y = y + 35;
	lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
	dropdown_cur_value = lsDropdown("ArrangerDropDown", 5, y, 0, 200, dropdown_cur_value, dropdown_values);
	lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
	y = y + 20;
      lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "Timer (ms):");
      is_done, total_delay_time = lsEditBox("total_delay_time", 170, y, 0, 80, 30, 1.0, 1.0, 0x000000ff, 72000);
      total_delay_time = tonumber(total_delay_time);
      if not total_delay_time then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        total_delay_time = 72000;
      end
	y = y + 40;
      lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "Wheel Delay (ms):");
      is_done, wheelDelay = lsEditBox("wheelDelay", 170, y, 0, 50, 30, 1.0, 1.0, 0x000000ff, 100);
      wheelDelay = tonumber(wheelDelay);
      if not wheelDelay then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        wheelDelay = 100;
      end
	y = y + 40;
      lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "Passes:");
      is_done, num_loops = lsEditBox("num_loops", 170, y, 0, 50, 30, 1.0, 1.0, 0x000000ff, 10);
      num_loops = tonumber(num_loops);
      if not num_loops then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        num_loops = 10;
      end      
	y = y + 40;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Timer: 72 seconds is default, but if server is");
	y = y + 15;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "lagging, 100+ seconds may be required.");

	y = y + 30;

      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Wheel Delay: Pause between starting each");
	y = y + 15;
	  lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "pottery wheel. Raise value to click slower.");

	y = y + 22;

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
