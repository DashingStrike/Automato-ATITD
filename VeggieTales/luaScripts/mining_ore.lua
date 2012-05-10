-- mining_ore.lua v1.0 -- by Cegaiel
-- Credits to Tallow for his Simon macro, which was used as a template.
-- 
-- Brute force method, you manually click/set every stones' location and it will work every possible 3 node/stone combinations
--

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
  Ore Mining v1.0 (by Cegaiel) --
  Brute Force method. Will try every possible 3 node/stone combination.
  Make sure chat is MINIMIZED! Press Shift over ATITD window.
]]);


clickList = {};


function doit()
  askForWindow(askText);
  promptDelays();
  getPoints();
  clickSequence();
end


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
      nodeError = 0;
      clickList[#clickList + 1] = {mx, my};
    end
    was_shifted = is_shifted;

    checkBreak();
    lsPrint(10, 10, z, 1.0, 1.0, 0xFFFFFFff,
	    "Nodes Selected (" .. #clickList .. ")");
    local y = 60;

    if nodeError == 1 then
    clickList = {};
    lsPrint(5, y, z, 0.7, 0.7, 0xff4040ff, "Not enough nodes! Minimum is 7.");
    y = y + 30
    end

    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Hover and Tap shift over each node.");
    y = y + 30;
    local start = math.max(1, #clickList - 20);
    local index = 0;
    for i=start,#clickList do
      local xOff = (index % 3) * 100;
      local yOff = (index - index%3)/2 * 15;
      lsPrint(20 + xOff, y + yOff, z, 0.5, 0.5, 0xffffffff,
              "(" .. clickList[i][1] .. ", " .. clickList[i][2] .. ")");
      index = index + 1;
    end

    if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Begin") then

	if #clickList < 7 then
	nodeError = 1
	else
	nodeError = 0;
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


function fetchTotalCombos()
  totalCombos = 0;
	for i=1,#clickList do
		for j=i+1,#clickList do
			for k=j+1,#clickList do
			totalCombos = totalCombos + 1;
			end
		end
	end
  statusScreenPause("[1/" .. totalCombos .. "] Nodes Worked:");
end


function clickSequence()
  fetchTotalCombos();
  local worked = 1;
	for i=1,#clickList do
		for j=i+1,#clickList do
			for k=j+1,#clickList do
	-- 1st Node
	checkBreak();
	srSetMousePos(clickList[i][1], clickList[i][2]);
	lsSleep(clickDelay);
	srKeyEvent('A'); 
	lsSleep(clickDelay);


		-- 2nd Node
		checkBreak();
		srSetMousePos(clickList[j][1], clickList[j][2]);
		lsSleep(clickDelay);
		srKeyEvent('A'); 
		lsSleep(clickDelay);


			-- 3rd Node
			checkBreak();
			srSetMousePos(clickList[k][1], clickList[k][2]);
			lsSleep(clickDelay);
			srKeyEvent('S'); 
			lsSleep(clickDelay);
		       statusScreenPause("[" .. worked .. "/" .. totalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k);
			PopUp();
			worked = worked + 1
	end

		end

			end

  clickList = {};
  getPoints();
  clickSequence();
 end

function PopUp()
  lsSleep(popDelay);
	while 1 do
	srReadScreen();
	OK = srFindImage("OK.png");
		if OK then
		srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
		--lsSleep(clickDelay)
		PopUp();
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
    lsPrint(10, 10, 0, 1.0, 1.0, 0xffffffff,
            "Set Delays:");
    local y = 60;
      lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "Click Delay (ms):");
      is_done, clickDelay = lsEditBox("delay", 160, y, 0, 50, 30, 1.0, 1.0,
                                      0x000000ff, 150);

      clickDelay = tonumber(clickDelay);
      if not clickDelay then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        clickDelay = 150;
      end

	y = y + 50;

      lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "Popup Delay (ms):");
      is_done, popDelay = lsEditBox("delay2", 160, y, 0, 50, 30, 1.0, 1.0,
                                      0x000000ff, 300);

      popDelay = tonumber(popDelay);
      if not popDelay then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        popDelay = 300;
      end


	y = y + 80
      lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Click Delay: Hover/Select each node.");
	y = y + 18
      lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff, "Popup Delay: Wait for Popup to close.");



    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quitMessage);
    end

    lsSleep(50);
    lsDoFrame();
  end
  return count;
end