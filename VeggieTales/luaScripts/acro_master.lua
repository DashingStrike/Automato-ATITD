-- acrobat_master.lua v1.0 by Cegaiel
--
-- Immediately upon Starting:
-- Searches your acro menu for all of your acro buttons. It will not include acro move names on the list, that is not inside of a button.
-- Displays your available moves in a list with a checkbox beside each one. If checked, it will click the move while acroing. Unchecked, it will be skipped.
-- Set how many times you want to do each checked acro move.
--
-- While acroing:
-- Click Next button while acroing to skip the current move and go to next one. Idea if your partner is following this move or enough facets have been taught.
-- Click Menu button to stop acroing and go back to your list.
--
-- Note: If you learn a new move while acroing, you will need to Quit macro and restart, so it can find your new move button and include in the list.
-- Be aware that the acro timer finishes very quickly, while your acro animations, do not. If will queue up your animations.


assert(loadfile("luaScripts/common.inc"))();

askText = "Acrobat Master v1.0 by Cegaiel\n \nOpen acro window before continuing!\n \nYou can test without a partner by Self Click, Tests of Acrobat, Show Moves. You may move the acro window while its running. If you are acroing many people, you do not need to quit/restart macro between each person. Click Menu, when you are done acroing the current avatar, open new acro window (ask to acro). Make sure you drag the acro window so all the moves are showing. Your available moves will stay in memory. Press Shift over ATITD window to continue.";


moveImages = {
"Asianinfluence.png",
"Broadjump.png",
"Cartwheels.png",
"Catstretch.png",
"Clappingpushups.png",
"Crunches.png",
"Fronttuck.png",
"Handplant.png",
"Handstand.png",
"Invertedpushups.png",
"Jumpsplit.png",
"Jumpingjacks.png",
"Kickup.png",
"Legstretch.png",
"Lunge.png",
"Pinwheel.png",
"Pushups.png",
"Rearsquat.png",
"Roundoff.png",
"Runinplace.png",
"Sidebends.png",
"Somersault.png",
"Spinflip.png",
"Squats.png",
"Squatthrust.png",
"Toetouches.png",
"Widesquat.png",
"Windmill.png",
};


moveNames = {
"Asian Influence",
"Broad Jump",
"Cartwheels",
"Cat Stretch",
"Clapping Push-Ups",
"Crunches",
"Front Tuck",
"Handplant",
"Handstand",
"Inverted Pushups",
"Jump Split",
"Jumping Jacks",
"Kick-Up",
"Leg Stretch",
"Lunge",
"Pinwheel",
"Push-Ups",
"Rear Squat",
"Roundoff",
"Run in Place",
"Side Bends",
"Somersault",
"Spin Flip",
"Squats",
"Squat Thrust",
"Toe Touches",
"Wide Squat",
"Windmill",
};

moveShortNames = {
"AI",
"BJ",
"CW",
"CS",
"CPU",
"CR",
"FT",
"HP",
"HS",
"IPU",
"JS",
"JJ",
"KU",
"LS",
"LU",
"PW",
"PU",
"RS",
"RO",
"RIP",
"SB",
"SS",
"SF",
"SQ",
"ST",
"TT",
"WS",
"WM",
};

perMoves = 3;
startTime = 0;

function doit()
  askForWindow(askText);
  findMoves();
  checkAllBoxes();
  displayMoves();
end


function findMoves()
  foundMovesName = {};
  foundMovesImage = {};
  foundMovesShortName = {};
    for i=1,#moveNames do
      srReadScreen();
      local found = srFindImage("acro/" .. moveImages[i]);
	  if found then
	    foundMovesName[#foundMovesName + 1] = moveNames[i];
	    foundMovesImage[#foundMovesImage + 1] = moveImages[i];
	    foundMovesShortName[#foundMovesShortName + 1] = moveShortNames[i];
      statusScreen("Searching acro buttons...\n \n" .. moveNames[i]);
      lsSleep(100);
	  end
    end

  if #foundMovesName == 0 then
    error 'No acro moves found, aborted.';
  end
end


function doMoves()
  local currentMove = 0;
  local skip = false;
  startTime = lsGetTimer();


	for i=1,checkedBoxes do
	    currentMove = currentMove + 1;

		for j=1,perMoves do
	         if skip then
	           skip = false;
	           break;
               end

		  local GUI = "...\n \n[" .. currentMove .. "/" .. checkedBoxes .. "] " .. checkedMovesName[i] .. "\n[" .. j .. "/" .. perMoves .. "] Repeating\n \nNote: Avatar animation will not keep up with macro. This is OK, each move clicked will still be recognized by your partner.";

		  local acroTimer = true;
			while acroTimer do
			    if lsButtonText(10, lsScreenY - 30, z, 75, 0xffff80ff, "Menu") then
				--lsDoFrame();
				sleepWithStatus(1000, "Returning to Menu")
				displayMoves();
			    end
			    if lsButtonText(100, lsScreenY - 30, z, 75, 0xff8080ff, "Skip") then
				skip = true;
			    end

			  checkBreak();
			  srReadScreen();
			  acro = findAllImages("Acro.png");

			    if #acro == 2 then
				  statusScreen("Waiting on Acro timer" .. GUI);
			    else
				  acroTimer = false;
		     		  clickMove = srFindImage("acro/" .. checkedMovesImage[i]);

		    			if clickMove then
					  srClickMouseNoMove(clickMove[0], clickMove[1]-1);
					  --srSetMousePos(clickMove[0], clickMove[1]-1);
					  status = "Clicking Move";
					else
					  status = "BUTTON NOT FOUND!\nSkipping: " .. checkedMovesName[i];
					  skip = true;
		    			end
			    	  statusScreen(status .. GUI);
				  lsSleep(1500);
			   end --if #acro == 2

		       end --while acroTimer
		  end --for j
        end --for i
  sleepWithStatus(1000, "ALL DONE!\n \nReturning to Menu")
  displayMoves();
end


function processCheckedBoxes()
  checkedMovesName = {};
  checkedMovesImage = {};
  checkedMovesShortName = {};
  checkedBoxes = 0;
  lsDoFrame(); --Make screen blank to prevent a text fade from doMoves function
    for i=1,#foundMovesName do
	if foundMovesShortName[i] then
	  checkedMovesName[#checkedMovesName + 1] = foundMovesName[i];
	  checkedMovesImage[#checkedMovesImage + 1] = foundMovesImage[i];
	  checkedMovesShortName[#checkedMovesShortName + 1] = foundMovesShortName[i];
	  checkedBoxes = checkedBoxes + 1;
	end
    end

    if checkedBoxes == 0 then
	sleepWithStatus(2500, "No moves selected!\n \nAborting...");
    else
	doMoves();
    end
end

function checkAllBoxes()
  for i=1,#foundMovesName do
    foundMovesShortName[i] = true;
  end
end


function uncheckAllBoxes()
  for i=1,#foundMovesName do
    foundMovesShortName[i] = false;
  end
end


function displayMoves()
  local foo;
  local is_done = nil;
  local finishTime = lsGetTimer();
  local seconds = 0;
  local minutes = 0;

  if startTime ~= 0 then
    sessionTime = math.floor((finishTime - startTime)/1000);
    sessionTime = sessionTime - 1; -- subtract 1 second for the 1000ms sleepWithStatus delay that occurs before returning to menu.
	if sessionTime >= 60 then
	  minutes = math.floor(sessionTime/60);
	  seconds = math.floor(sessionTime - (minutes*60));
	else
	  minutes = 0;
	  seconds = sessionTime;
	end
  end
    
  if minutes == 0 and seconds == 0 then
    lastSession = "N/A"
  elseif minutes == 0 and seconds ~= 0 then
    lastSession = seconds .. " sec";
  else
    lastSession = minutes .. " min " .. seconds .. " sec";
  end


  while 1 do
    checkBreak()
    local y = 10;
    lsSetCamera(0,0,lsScreenX*1.5,lsScreenY*1.5);

    foo, perMoves = lsEditBox("Time per Move", 15, y, z, 30, 30, 0.7, 0.7,
                                   0x000000ff, perMoves);
      if not tonumber(perMoves) then
        is_done = nil;
	  lsPrint(60, y, 0, 0.9, 0.9, 0xFF2020ff, "MUST BE A NUMBER!");
	else
	  is_done = true;
        lsPrint(55, y, z, 0.9, 0.9, 0xf0f0f0ff, "Times to repeat each move: " .. #foundMovesName .. " found");
	end


    lsPrint(100, y+20, z, 0.8, 0.8, 0xf0f0f0ff, "Last Acro Session: " .. lastSession);


    y = y + 50;
    lsPrint(15, y, 0, 0.9, 0.9, 0x40ff40ff, "Check moves you want to perform:");
    y = y + 30;

      for i=1,#foundMovesName do
        local color = 0xB0B0B0ff;
          if foundMovesShortName[i] then
	      color = 0xffffffff;
	    end
          foundMovesShortName[i] = lsCheckBox(20, y, z, color, " " .. foundMovesName[i], foundMovesShortName[i]);
          y = y + 20;
	end

    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);

      if lsButtonText(lsScreenX - 110, lsScreenY - 120, z, 100, 0xFFFFFFff,
                    "Start") and is_done then
	    processCheckedBoxes();
      end

      if lsButtonText(lsScreenX - 110, lsScreenY - 90, z, 100, 0xFFFFFFff,
                    "Check") then
      checkAllBoxes();
      end

      if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff,
                    "Uncheck") then
      uncheckAllBoxes();
      end

      if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End Script") then
        error "Clicked End script button";
      end

    lsDoFrame();
    lsSleep(100);
  end
end