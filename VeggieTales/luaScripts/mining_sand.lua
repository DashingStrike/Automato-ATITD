-- mining_sand.lua v0.9 -- by Cegaiel
-- Credits to Tallow for his Simon macro, which was used as a template to build on.
-- Works the sand mine, but requires a little thought and input from you ;)
--
-- You must click on all Quintuple colors FIRST, all Quadruple colors NEXT, all Triple colors NEXT, all Paired colors NEXT, then ALL Single colored stones LAST.
--

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
  Sand Mining v0.9 (by Cegaiel) --
  Make sure chat is MINIMIZED! Press Shift over ATITD window.
]]);


dropdown_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
dropdown_cur_value = 1;
dropdown_pattern_values = {"6 color (1 Pair) (*)", "5 color (2 Pair) (*)", "4 color (3 Pair) (*)", "5 color (Triple) (1)", "4 color (Triple+Pair) (3)", "4 color (Quadruple) (1)", "3 Color (Quad + Pair) (6)", "3 color (Quintuple) (2)", "7 Color (All Different) (*)"};
dropdown_pattern_cur_value = 1;


function doit()
  askForWindow(askText);
  promptDelays();
  getPoints();
  getPattern();
  clickSequence();
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
    y = y + 25;
    lsPrint(5, y, z, 0.8, 0.8, 0xFFFFFFff,
	    "Set Node Locations (" .. #clickList .. "/7)");
    y = y + 30;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Hover and " .. key .. " each node, in this order:");
    y = y + 15;
    lsPrint(5, y, z, 0.5, 0.5, 0xf0f0f0ff, "Quintuples (5 same color), Quadruples (4 same color)");
    y = y + 15;
    lsPrint(5, y, z, 0.5, 0.5, 0xf0f0f0ff, "Triples (3 same color), Pairs (2 same color)");
    y = y + 15;
    lsPrint(5, y, z, 0.5, 0.5, 0xf0f0f0ff, "Single colored nodes (1 color)");
    y = y + 15;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Make sure chat is MINIMIZED!");
    y = y + 25;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Ingame Popup? Suggests you chose wrong pattern.");
    y = y + 15;
    lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Or you need to increase the delays (previous menu).");
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
    if lsButtonText(10, lsScreenY - 30, z, 100, 0x80ff80ff, "Start") then
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



function getPattern()
  set1 = {};
  set2 = {};
  set3 = {};
  set4 = {};
  set5 = {};
  set6 = {};
  set7 = {};
  set8 = {};
  set9 = {};
  set10 = {};
  set11 = {};
  set12 = {};
  set13 = {};
  set14 = {};
  set15 = {};


  if dropdown_pattern_cur_value == 1 then
  --6 color (1 Pair)

  sets = 14;
  set1 = {1,3,4,7};
  set2 = {1,5,6};
  set3 = {1,4,5,6};
  set4 = {1,3,7};
  set5 = {1,5,6,7};
  set6 = {1,3,4};
  set7 = {1,3,6,7};
  set8 = {2,4,5};
  set9 = {2,5,6};
  set10 = {2,3,4,7};
  set11 = {2,4,7};
  set12 = {2,3,6,5};
  set13 = {2,3,6};
  set14 = {2,4,5,7};

  elseif dropdown_pattern_cur_value == 2 then
  --5 color (2 Pair)

  sets = 15;
  set1 = {5,6,7};
  set2 = {5,1,3};
  set3 = {5,1,4};
  set4 = {5,2,3};
  set5 = {5,2,4};
  set6 = {6,1,3};
  set7 = {6,1,4};
  set8 = {6,2,3};
  set9 = {6,2,4};
  set10 = {7,1,3};
  set11 = {7,1,4};
  set12 = {7,2,3};
  set13 = {7,2,4};
  set14 = {1,3,5,6,7};
  set15 = {2,4,5,6,7};

  elseif dropdown_pattern_cur_value == 3 then
  --4 color (3 Pair)

  sets = 15;
  set1 = {1,3,5};
  set2 = {2,4,6,7};
  set3 = {1,3,6};
  set4 = {2,4,5,7};
  set5 = {1,4,5};
  set6 = {2,3,6,7};
  set7 = {1,4,6};
  set8 = {2,3,5,7};
  set9 = {2,3,5};
  set10 = {1,4,6,7};
  set11 = {2,3,6};
  set12 = {1,4,5,7};
  set13 = {2,4,5};
  set14 = {1,3,6,7};
  set15 = {1,4,6};

  elseif dropdown_pattern_cur_value == 4 then
  --5 color (Triple)

  sets = 14;
  set1 = {1,4,5};
  set2 = {1,4,6};
  set3 = {1,4,7};
  set4 = {1,5,6};
  set5 = {1,5,7};
  set6 = {1,6,7};
  set7 = {2,4,5};
  set8 = {2,4,6};
  set9 = {2,4,7};
  set10 = {2,5,6};
  set11 = {2,5,7};
  set12 = {2,6,7};
  set13 = {1,2,3};
  set14 = {3,4,5,6,7};

  elseif dropdown_pattern_cur_value == 5 then
  --4 color (Triple + Pair)

  sets = 12;
  set1 = {1,2,3};
  set2 = {1,4,6};
  set3 = {1,4,7};
  set4 = {1,5,6};
  set5 = {1,5,7};
  set6 = {1,6,7};
  set7 = {2,4,6};
  set8 = {2,4,7};
  set9 = {3,4,6};
  set10 = {3,4,7};
  set11 = {2,6,7};
  set12 = {1,4,6,7};


  elseif dropdown_pattern_cur_value == 6 then
  --4 color (Quadruple)

  sets = 15;
  set1 = {1,5,6};
  set2 = {1,5,7};
  set3 = {1,6,7};
  set4 = {2,5,6};
  set5 = {2,5,7};
  set6 = {2,6,7};
  set7 = {3,5,6};
  set8 = {3,5,7};
  set9 = {3,6,7};
  set10 = {4,5,6,7};
  set11 = {1,2,3};
  set12 = {1,2,4};
  set13 = {1,3,4};
  set14 = {2,3,4};
  set15 = {1,2,3,4};

  elseif dropdown_pattern_cur_value == 7 then
  --3 color (Quad + Pair)

  sets = 7;
  set1 = {1,5,7};
  set2 = {1,6,7};
  set3 = {2,5,7};
  set4 = {2,6,7};
  set5 = {3,5,7};
  set6 = {3,6,7};
  set7 = {4,5,7};

  elseif dropdown_pattern_cur_value == 8 then
  --3 color (Quintuple)

  sets = 11;
  set1 = {1,2,3};
  set2 = {1,2,4};
  set3 = {1,2,5};
  set4 = {1,3,4};
  set5 = {1,3,5};
  set6 = {1,4,5};
  set7 = {2,3,4};
  set8 = {2,3,5};
  set9 = {2,4,5};
  set10 = {3,4,5};
  set11 = {1,2,3,4,5};
 
  elseif dropdown_pattern_cur_value == 9 then
  -- 7 color (All different)

  sets = 8;
  set1 = {1,2,3,4,5,6};
  set2 = {1,2,3,4,5,7};
  set3 = {1,2,3,4,6,7};
  set4 = {1,2,3,5,6,7};
  set5 = {1,2,4,5,6,7};
  set6 = {1,3,4,5,6,7};
  set7 = {2,3,4,5,6,7};
  set8 = {1,2,3,4,5,6,7};
  end

end


function clickSequence()
  statusScreenPause("DON\'T MOVE MOUSE !!!");
  lsSleep(750);

  local worked = 1;

  for i = 1, #set1 do
	checkBreak();
	srSetMousePos(clickList[set1[i]][1], clickList[set1[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
  end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set1 .. " Nodes Worked: " .. table.concat(set1, ", "));
	worked = worked + 1
      findClosePopUp();


  for i = 1, #set2 do
	checkBreak();
	srSetMousePos(clickList[set2[i]][1], clickList[set2[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
  end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set2 .. " Nodes Worked: " .. table.concat(set2, ", "));
	worked = worked + 1
      findClosePopUp();


  for i = 1, #set3 do
	checkBreak();
	srSetMousePos(clickList[set3[i]][1], clickList[set3[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
  end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set3 .. " Nodes Worked: " .. table.concat(set3, ", "));
	worked = worked + 1
      findClosePopUp();


  if #set4 > 0 then
	for i = 1, #set4 do
	checkBreak();
	srSetMousePos(clickList[set4[i]][1], clickList[set4[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set4 .. " Nodes Worked: " .. table.concat(set4, ", "));
	worked = worked + 1
      findClosePopUp();
  end

  if #set5 > 0 then
	for i = 1, #set5 do
	checkBreak();
	srSetMousePos(clickList[set5[i]][1], clickList[set5[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set5 .. " Nodes Worked: " .. table.concat(set5, ", "));
	worked = worked + 1
      findClosePopUp();
  end


  if #set6 > 0 then
	for i = 1, #set6 do
	checkBreak();
	srSetMousePos(clickList[set6[i]][1], clickList[set6[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set6 .. " Nodes Worked: " .. table.concat(set6, ", "));
	worked = worked + 1
	findClosePopUp();
  end


  if #set7 > 0 then
	for i = 1, #set7 do
	checkBreak();
	srSetMousePos(clickList[set7[i]][1], clickList[set7[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set7 .. " Nodes Worked: " .. table.concat(set7, ", "));
	worked = worked + 1
	findClosePopUp();
  end


  if #set8 > 0 then
	for i = 1, #set8 do
	checkBreak();
	srSetMousePos(clickList[set8[i]][1], clickList[set8[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set8 .. " Nodes Worked: " .. table.concat(set8, ", "));
	worked = worked + 1
	findClosePopUp();
  end


  if #set9 > 0 then
	for i = 1, #set9 do
	checkBreak();
	srSetMousePos(clickList[set9[i]][1], clickList[set9[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set9 .. " Nodes Worked: " .. table.concat(set9, ", "));
	worked = worked + 1
	findClosePopUp();
  end


  if #set10 > 0 then
	for i = 1, #set10 do
	checkBreak();
	srSetMousePos(clickList[set10[i]][1], clickList[set10[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set10 .. " Nodes Worked: " .. table.concat(set10, ", "));
	worked = worked + 1
	findClosePopUp();
  end


  if #set11 > 0 then
	for i = 1, #set11 do
	checkBreak();
	srSetMousePos(clickList[set11[i]][1], clickList[set11[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set11 .. " Nodes Worked: " .. table.concat(set11, ", "));
	worked = worked + 1
	findClosePopUp();
  end


  if #set12 > 0 then
	for i = 1, #set12 do
	srSetMousePos(clickList[set12[i]][1], clickList[set12[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set12 .. " Nodes Worked: " .. table.concat(set12, ", "));
	worked = worked + 1
	findClosePopUp();
  end


  if #set13 > 0 then
	for i = 1, #set13 do
	checkBreak();
	srSetMousePos(clickList[set13[i]][1], clickList[set13[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set13 .. " Nodes Worked: " .. table.concat(set13, ", "));
	worked = worked + 1
	findClosePopUp();
  end


  if #set14 > 0 then
	for i = 1, #set14 do
	checkBreak();
	srSetMousePos(clickList[set14[i]][1], clickList[set14[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set14 .. " Nodes Worked: " .. table.concat(set14, ", "));
	worked = worked + 1
	findClosePopUp();
  end


  if #set15 > 0 then
	for i = 1, #set15 do
	checkBreak();
	srSetMousePos(clickList[set15[i]][1], clickList[set15[i]][2]);
	lsSleep(clickDelay);
	srKeyEvent('A');
	end
	statusScreenPause("[" .. worked .. "/" .. sets .. "] " .. #set15 .. " Nodes Worked: " .. table.concat(set15, ", "));
	worked = worked + 1
	findClosePopUp();
  end


  --Restart
  getPoints();
  getPattern();
  clickSequence();
end

function findClosePopUp()
	srKeyEvent('S'); 
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
    dropdown_cur_value = lsDropdown("ArrangerDropDown", 15, y, 0, 320, dropdown_cur_value, dropdown_values);
    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);

    y = y + 25;
    lsPrint(12, y, 0, 0.8, 0.8, 0xffffffff,
            "Set Delays:");
	y = y + 35;

      lsPrint(15, y, 0, 0.8, 0.8, 0xffffffff, "Node Delay (ms):");
      is_done, clickDelay = lsEditBox("delay", 165, y, 0, 50, 30, 1.0, 1.0,
                                     0x000000ff, 150);
      clickDelay = tonumber(clickDelay);
      if not clickDelay then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        clickDelay = 150;
      end
	y = y + 50;
      lsPrint(15, y, 0, 0.8, 0.8, 0xffffffff, "Popup Delay (ms):");
      is_done, popDelay = lsEditBox("delay2", 165, y, 0, 50, 30, 1.0, 1.0,
                                      0x000000ff, 500);
      popDelay = tonumber(popDelay);
      if not popDelay then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        popDelay = 500;
      end

	y = y + 55;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Node Delay: Delay before selecting next node.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Decrease value to run faster (try increments of 25)");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Popup Delay: After Finalizing, delay to find Popup.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Change Popup Delay as last resort to fine tune.");

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quitMessage);
    end

    lsSleep(10);
    lsDoFrame();
  end
  return count;
end