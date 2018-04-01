-- Acrobat Master v1.1 by Cegaiel
--
-- Immediately upon Starting:
-- Searches your acro menu for all of your acro buttons. It will not include acro move names on the list, that is not inside of a button.
-- Displays your available moves in a list with a checkbox beside each one. If checked, it will click the move while acroing. Unchecked, it will be skipped.
-- Set how many times you want to do each checked acro move.
--
-- While acroing:
-- Click Next button while acroing to skip the current move and go to next one. Idea if your partner is following this move or enough facets have been taught.
-- Click Menu button to stop acroing and go back to your list.
-- Go back to Menu, click Refresh when you have a new partner, to refresh the buttons
--

dofile("common.inc");

askText = "Acrobat Master v1.1 by Cegaiel\n \nWait until you have Acrobat window open, from a partner, (won\'t work with Self Click, Acrobat, Show Moves) before you start macro! It will memorize your moves for future partners (even if you close acro window). You can move acro window while its running. You do not need to quit/restart macro between each partner. Click \"Menu\" button, when you are done acroing the current player. Optionally, click \"Refresh\" button when your next partner\'s acro window is open. This will prevent the same moves you both know from appearing in checklist. Make sure you resize the acro window so all the buttons are showing. Press Shift over ATITD window to continue.";


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

-- TODO: this should only find buttons north of the break
function findMoves()
  lsDoFrame();
  statusScreen("Scanning acro buttons...");
  foundMovesName = {};
  foundMovesImage = {};
  foundMovesShortName = {};
    for i=1,#moveNames do
	checkBreak();
      srReadScreen();
      local found = srFindImage("acro/" .. moveImages[i]);
	  if found then
	    foundMovesName[#foundMovesName + 1] = moveNames[i];
	    foundMovesImage[#foundMovesImage + 1] = moveImages[i];
	    foundMovesShortName[#foundMovesShortName + 1] = moveShortNames[i];
      statusScreen("Scanning acro buttons...\n \nFound: " .. moveNames[i]);
      lsSleep(25);
	  end
    end

  if #foundMovesName == 0 then
    error 'No acro moves found, aborted.';
  end
end

function doMoves()
	local skip = false;
	
	-- if someone knows better how to better implement a basic finite state machine in lua, be my guest.
	-- only one of these should ever be true at a time
	local doAcroClick = true;
	local waitForAcroStart = false;
	local waitForAcroEnd = false;
	
	
	local badLagMessageTimer = 5000;
	
	-- total timeout waiting for acro start time will be acroStartIttr * acroStartTimeout ms
	local acroStartTries = 0;
	local acroStartIttr = 15; 		-- increase total timeout here first
	local acroStartTimeout = 1000; 	-- be careful extending this value.
	
	-- total timeout waiting for acro start time will be acroEndIttr * acroEndTimeout ms
	local acroEndTries = 0;
	local acroEndIttr = 20; 		-- increase total timeout here first
	local acroEndTimeout = 1000; 	-- be careful extending this value.

	for currentMove=1,checkedBoxes do
   	    checkBreak();
	
		for currentClick=1,perMoves do
			checkBreak();
					
	        if skip then
	           skip = false;
	           break;
            end					
					
			doAcro = true;
			
			-- reset state for safety's sake
			-- only one of these should ever be true at a time
			doAcroClick = true;
			waitForAcroStart = false;
			waitForAcroEnd = false;
			acroStartTries = 0;
			acroEndTries = 0;
			
			while doAcro do
				checkBreak();
				
				local GUI = "...\n \n[" .. currentMove .. "/" .. checkedBoxes .. "] " .. checkedMovesName[currentMove] .. "\n[" .. currentClick .. "/" .. perMoves .. "] Clicked\n \nNote: Avatar animation will not keep up with macro. This is OK, each move clicked will still be recognized by your partner.\n\nClick Skip to advance to next move on list (ie partner follows the move).";
			
				if lsButtonText(10, lsScreenY - 30, z, 75, 0xffff80ff, "Menu") then
					sleepWithStatus(1000, "Returning to Menu")
					displayMoves();
					break;
				end
				
				if lsButtonText(100, lsScreenY - 30, z, 75, 0xff8080ff, "Skip") then
					skip = true;
					break;
				end
			
				-- handle do click state
				if doAcroClick then
		     		clickMove = srFindImage("acro/" .. checkedMovesImage[currentMove]);
					
					if clickMove then
						srReadScreen();
						srClickMouseNoMove(clickMove[0], clickMove[1]-1);
						status = checkedMovesName[currentMove] .. " clicked";
						statusScreen(status .. GUI);
						
						-- change state to acro start
						-- only one of these should ever be true at a time
						doAcroClick = false;
						waitForAcroStart = true;
						waitForAcroEnd = false;
					else
						status = "BUTTON NOT FOUND!\nSkipping: " .. checkedMovesName[currentMove];
						statusScreen(status .. GUI);
						skip = true;
					end
					lsSleep(1000); -- timer here to make sure the status message can be seen before moving on to acro timer
				end
				
				-- handle acro start state
				if waitForAcroStart then
					statusScreen("WAITING FOR ACRO TIMER TO START " .. acroStartTries .. "/" .. acroStartIttr .. GUI);
					
					img = waitForImage("acro.png", acroStartTimeout);
					
					if img ~= nil then
						-- change state to acro end
						-- only one of these should ever be true at a time
						doAcroClick = false;
						waitForAcroStart = false;
						waitForAcroEnd = true;
					else
						acroStartTries = acroStartTries + 1
					end
					
					if acroStartTries == acroStartIttr then
						acroStartTries = acroStartTries - 5;
						statusScreen("The lag is pretty bad... are you sure you want to be acroing?  Trying 5 more times...");
						lsSleep(badLagMessageTimer);
					end
				end
				
				-- handle acro end state
				if waitForAcroEnd then
					statusScreen("WAITING FOR ACRO TIMER TO END " .. acroEndTries .. "/" .. acroEndIttr .. GUI);
					
					img = waitForNoImage("acro.png", acroEndTimeout);
					
					if img == nil then
						-- change state to do click
						-- only one of these should ever be true at a time
						doAcroClick = true;
						waitForAcroStart = false;
						waitForAcroEnd = false;
						
						break;
					else
						acroEndTries = acroEndTries + 1
					end
					
					if acroEndTries == acroEndIttr then
						acroEndTries = acroEndTries - 5;
						statusScreen("The lag is pretty bad... are you sure you want to be acroing?  Trying 5 more times...");
						lsSleep(badLagMessageTimer);
					end
					
				end
				
				lsDoFrame();
			end
			
		end -- currentClick
	
	end -- currentMove

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
  lsDoFrame();
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

    lsSetCamera(0,0,lsScreenX*1.2,lsScreenY*1.2);

      if lsButtonText(lsScreenX - 50, lsScreenY - 80, z, 100, 0xFFFFFFff,
                    "Start") and is_done then
	    processCheckedBoxes();
      end


      if lsButtonText(lsScreenX - 50, lsScreenY - 50, z, 100, 0xFFFFFFff,
                    "Refresh") and is_done then
	    findMoves();
	    checkAllBoxes();
      end

      if lsButtonText(lsScreenX - 50, lsScreenY - 20, z, 100, 0xFFFFFFff,
                    "Check") and is_done then
      checkAllBoxes();
      end

      if lsButtonText(lsScreenX - 50, lsScreenY + 10, z, 100, 0xFFFFFFff,
                    "Uncheck") and is_done then
      uncheckAllBoxes();
      end

      if lsButtonText(lsScreenX - 50, lsScreenY + 40, z, 100, 0xFFFFFFff,
                    "End Script") then
        error "Clicked End script button";
      end

    lsDoFrame();
    lsSleep(50);
  end
end