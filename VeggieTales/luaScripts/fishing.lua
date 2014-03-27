-- Pin up your Lures menu 'Self Click, Skills, Fishing, Use Lure' (no other pinned up windows can exist)
-- Should have (Chat-Related): 'Chat and Inventory can be minimized' AND 'Minimized chat-channels are still visible'.
-- You must have Main Chat tab showing at all times and window is long/wide enough so no lines don't wrap.

-- Yes, this macro reads your MAIN chat screen, so make sure you read the above statement for it to work correctly.
-- Each line of text must not scroll/wrap to the next line. If it does, then drag your chat window wider so it doesn't wrap.
-- You want to make your chat very wide. Note: It is possible to see a LONG message like "Though you lost your lure, you did catch a 15 deben Orange Spongefish"
-- Another long message is "You didn't catch anything. You also lost your lure. Try different lures and locations"
-- At 1280x1024 your chat screen should reach at least to the mid point of your screen to avoid having a chat line wrap to next line, for a long message, like above.
-- Higher resolutions may not have to reach quite to the mid point.


-- ********** This macro writes to a log file (Fishlog.txt) for most actions, so you can review later! ******
-- ********** This also macro writes to a log file (Fishstats.txt) showing stats of your last fishing session, so you can review later! ******


--You can delete any of the log files if you wish. It will automatically create new ones if they dont exist.
--The fishlog.txt file gets appended everytime you fish, so the file can grow quite long over time.
--The fishstats.txt file gets overwritten everytime your gui program window updates, so it doesn't 'grow' over time.


-- Almost all issues can be corrected by slightly adjusting the main chat window size and restarting.
-- And also verify the lines aren't wrapping to the next line (if so, adjust chat screen to be wider until it is no longer wrapping down to next line).


	-- Note: These are currently refered to as Common Fish in the below 'SkipCommon' type of fishes (True or False), checkbox.

	--Abdju
	--Chromis
	--Catfish
	--Carp
	--Perch
	--Phagrus
	--Tilapia





assert(loadfile("luaScripts/common.inc"))();
assert(loadfile("luaScripts/Fishing_Func.inc"))();



-- These used to be hardcoded, but now only affects what checkboxes are checked/unchecked upon starting the macro up.

SkipCommon = false; --Skips to next lure if fish caught is a common (Choose True or False).
--AlmostCaughtAttempts = 0; --Adds additional attempts to the current lure if Unusual, Strange fish are seen;
-- Note: AlmostCaughtAttempts above was already commented out upon arriving to Talescripts.
-- It is also commented out during the script, so uncommenting above will NOT activate the feature. This might be a future project...

-- Additional reporting in the log file
-- Choose true or false.
	-- Note 'LogStrangeUnusual' and 'LogOdd' (below) overrides LogFails setting. ie if LogStrange true, then it would still log even if LogFails = False
	--If LogFails = false and LogStrangeUnusual or LogOdd = true, then failed catches those would still be included in the log file. 
LogFails = false;  	-- Do you want to add Failed Catches to log file? 'Failed to catch anything' or 'No fish bit'. Note the log will still add an entry if you lost lure.
LogStrangeUnusual = false; 	-- Do you want to add Strange and Unusual fish to the log file? Note the log will still add an entry if you lost lure.
LogOdd = false; 	-- Do you want to add Odd fish to the log file? Note the log will still add an entry if you lost lure.
muteSoundEffects = false;

function setOptions()
  local is_done = false;
  local count = 1;
  while not is_done do
	checkBreak();
	local y = 10;

    lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);  -- Shrink the text boxes and text down
      lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "Casts per Lure?");
      is_done, TotalCasts = lsEditBox("totalcasts", 160, y, 0, 40, 25, 1.0, 1.0, 0x000000ff, 4);
      TotalCasts = tonumber(TotalCasts);
      if not TotalCasts then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        TotalCasts = 4;
      end

	y = y + 40;
      lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "Cast Timer (ms):");
      is_done2, castWaitTimer = lsEditBox("castwaittimer", 160, y, 0, 65, 25, 1.0, 1.0, 0x000000ff, 15000);
      castWaitTimer = tonumber(castWaitTimer);
      if not castWaitTimer then
        is_done2 = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        castWaitTimer = 15000;
      end

      lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);  -- Restore text boxes and text back to normal
	y = y + 30;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Casts per Lure?  # Casts before switching lures.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Cast Timer: 15s (15000ms) is idea.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "  This is delay between each time you cast.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "  You can slightly lower time with +Focus food.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "  Increase if 'Already Fishing' messages occur.");

      lsSetCamera(0,0,lsScreenX*1.4,lsScreenY*1.4);  -- Shrink the check boxes and text down
	y = y + 85;

	muteSoundEffects = lsCheckBox(10, y, 10, 0xFFFFFFff, " Mute Sound Effects", muteSoundEffects);

	y = y + 25;
	SkipCommon = lsCheckBox(10, y, 10, 0xFFFFFFff, " Skip Common Fish", SkipCommon);
	y = y + 25;
	lsPrintWrapped(10, y, 0, lsScreenX + 82, 0.7, 0.7, 0xffff80ff, "If Common Fish Caught, immediately switch to next lure:");
	y = y + 18
	lsPrintWrapped(10, y, 0, lsScreenX + 80, 0.7, 0.7, 0xffffffff, "(Abdju, Chromis, Catfish, Carp, Perch, Phagrus, Tilapia)");
	y = y + 30;
	lsPrintWrapped(10, y, 0, lsScreenX + 80, 0.8, 0.8, 0x80ff80ff, "Log entries to FishLog.txt in VeggieTales folder.");
	y = y + 25;
	LogFails = lsCheckBox(10, y, 10, 0xFFFFFFff, " Log Failed Catches", LogFails);
	y = y + 25;
	LogStrangeUnusual = lsCheckBox(10, y, 10, 0xFFFFFFff, " Log Strange & Unusual Fish Seen ...", LogStrangeUnusual);
	y = y + 25;
	LogOdd = lsCheckBox(10, y, 10, 0xFFFFFFff, " Log Odd Fish Seen ...", LogOdd);
      lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);  -- Restore text boxes and text back to normal

		if setResume then
		buttonName = "Set/Resume";
		else
		buttonName = "Start";
		end

	    if lsButtonText(10, lsScreenY - 30, 0, 130, 0xFFFFFFff, buttonName) then
        is_done = 1;
	  setResume = false;
	    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quitMessage);
    end
  lsDoFrame();
  lsSleep(150);
  end
  return count;
end


function checkBreakSpecial()
    while setPause do
	checkBreak();
	lsSleep(150);
      statusScreen("Fishing macro paused ...\nClick Unpause to resume!", 0xffffffff, false);
		if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Unpause") or (lsAltHeld() and lsShiftHeld()) then
		setPause = false;
		gui_refresh();
		end
    end
end


function SetupLureGroup()
	TLures = {};
	FirstLure="";
	LastLure = "";

	lsDoFrame();
	statusScreen("Indexing Lures ...");
	checkBreak()	
	srReadScreen();
	FindPin = srFindImage("UnPin.png");
	if FindPin then
	--Click the pinup to refresh the lures window (in case a lure was lost earlier, it would still be showing on menu).
	srClickMouseNoMove(FindPin[0]+20,FindPin[1]+20);
	lsSleep(200);
	srReadScreen();
		-- Push Up arrow, just in case its current at bottom of list
		DownPin = srFindImageInRange("Fishing/Menu_DownArrow.png",FindPin[0]-10,FindPin[1],50,500);
		if DownPin then
			UpArrow = srFindImageInRange("Fishing/Menu_UpArrow.png",FindPin[0]-10,FindPin[1],50,50);
			if UpArrow then
				srClickMouseNoMove(UpArrow[0]+5,UpArrow[1]+5);
				lsSleep(200);
				srReadScreen();
			end
			
			
		--	srClickMouseNoMove(DownPin[0]+5,DownPin[1]+5);
			LastLure=FindLureName(DownPin[0]-150,DownPin[1]-10,150,25);
			--error(LastLure);
			FirstLure = FindLureName(FindPin[0]-150,FindPin[1]-10,150,25);
		--	error(FirstLure);
		else
			--No Arrows on lure menu?
			FirstLure=FindLureName(FindPin[0]-150,FindPin[1]-10,150,25);
			LastLure=nil;
		end
	else
		error("Didn\'t find Lures pinned window - Self Click->Skills, Fishing -> Use Lure, PIN THIS WINDOW!");
	end
	

	if  LastLure ~= nil then
		--We have last lure, and arrows showing
		ChangeLureMenu = LastLure;


		FirstLurLoc = srFindImage("fishing/" .. FirstLure);
		LastLurLoc = srFindImage("fishing/" .. LastLure);
		

		lureCounter = 0;
		for i = 1, #Lures,1 do
			test = srFindImageInRange(("fishing/" .. Lures[i]),FirstLurLoc[0]-5,FirstLurLoc[1]-5,175,500);
			if test then
				--Add Lure
				lureCounter = lureCounter + 1;
				statusScreen("Indexing Lures (" .. lureCounter .. ") ...");
				table.insert(TLures,Lures[i]);
				if Lures[i] == LastLure then
					--End of Menu, Use Down Arrow
					arrow=srFindImageInRange("Fishing/menu_downarrow.png",test[0],test[1]-5,175,50);
					if arrow then
						DownArrowLocs = arrow;
						srClickMouseNoMove(arrow[0]+5,arrow[1]+5);
						lsSleep(200);
						srReadScreen();
					else
						error("no arrow found");
					end
				end
				LastLureMenu = Lures[i];
			end
		end
		
		--Reset Lure Menu
		UpArrow = srFindImageInRange("Fishing/Menu_UpArrow.png",FindPin[0]-10,FindPin[1],50,50);
		if UpArrow then
			srClickMouseNoMove(UpArrow[0]+5,UpArrow[1]+5);
		end
		
	else
		--No arrows, just get lures
		lureCounter = 0;
		for i = 1, #Lures, 1 do
			test = srFindImage("Fishing/" .. Lures[i]);
			if test then
				lureCounter = lureCounter + 1;
				statusScreen("Indexing Lures (" .. lureCounter .. ") ...");
				table.insert(TLures,Lures[i]);
			end
		end
	end
	
	return TLures;
end


function FindLureName(x,y,w,h)

	for i = 1, #Lures, 1 do 
		Lure = srFindImageInRange("Fishing/" .. Lures[i], x,y,w,h);
		if Lure then
			return Lures[i]
		end
	end
end


function UseLure()

	CurrentLure = string.sub(PlayersLures[CurrentLureIndex],string.find(PlayersLures[CurrentLureIndex],"_")+1,string.len(PlayersLures[CurrentLureIndex])-4);
	QCurrentLure = string.sub(PlayersLures[QCurrentLureIndex],string.find(PlayersLures[QCurrentLureIndex],"_")+1,string.len(PlayersLures[QCurrentLureIndex])-4);

	checkBreak();
	-- Uses lure according to CurrentLureIndex, which is used in PlayersLures which contains each lure the player has. 
	lsDoFrame(); -- Blank the screen so next statusScreen messages isn't mixed/obscured with previous gui_refresh info on screen
	lsSleep(10);
		if LostLure == 0 then
		statusScreen("Switching Lures | " .. QCurrentLure);
		else
		sleepWithStatus(999,"Lost Lure! | " .. lastLostLure .. "\nSwitching Lures | " .. QCurrentLure);
		table.insert(lostlure_log, Time .. " | " .. lastLostLure .. " (" .. lastLostLureType .. ")");
		LostLure = 0;
		end

	if #TLures == 0 then
	error 'Can\'t find any lures on the pinned window. Did you run out of lures?'
	end


	srReadScreen();
	--Only the first 30 lures will show in window, 31+ needs the down arrow clicked to be viewed, else click the up arrow (if more than 30 lures).
	if QCurrentLureIndex > 30 then
		down = srFindImage("Fishing/Menu_DownArrow.png");
		srClickMouseNoMove(down[0]+5,down[1]+5);
		lsSleep(200);
	elseif #PlayersLures > 30 then
		up = srFindImage("Fishing/Menu_UpArrow.png");
		srClickMouseNoMove(up[0]+5,up[1]+5);
		lsSleep(200);
	end

	srReadScreen();
	lure = srFindImage("Fishing/" .. PlayersLures[QCurrentLureIndex]);
	if lure then
		if not muteSoundEffects then
		lsPlaySound("fishingreel.wav");
		end
		srClickMouseNoMove(lure[0]+3,lure[1]+3);
		lsSleep(200);
		srReadScreen();

		-- Find Lure Type
		for i = 1, #Lure_Types, 1 do
			test = srFindImage("Fishing/" .. Lure_Types[i]);
			if test then
			LureType = Lure_Types[i];
			LureType = string.sub(Lure_Types[i],string.find(Lure_Types[i],"Menu_")+5,string.len(Lure_Types[i])-4);
				--Click it!
				srClickMouseNoMove(test[0]+3,test[1]+3);
				--gui_refresh();
				break;
			end
		end


	end
end

function ChatReadFish()
	--Find the last line of chat
	--lsSleep(100);
	checkBreak();
	srReadScreen();
	imgs = findAllImages("fishing/chatlog_reddots.png");
	Coords = imgs[#imgs];

	if not Coords or #imgs == 0 then
		if not muteSoundEffects then
		lsPlaySound("timer.wav");
		end
	end

		-- Wait for Main chat screen and alert user if its not showing
		while not Coords or #imgs == 0 do
			checkBreak();
			srReadScreen();
			imgs = findAllImages("Fishing/chatlog_reddots.png");
			Coords = imgs[#imgs];
			sleepWithStatus(100, "Looking for Main chat screen ...");
		end

	
	--Caught Something..  Find Fish Details
	Sfish = "";
				
	for i = 1, #CL_Fish do
	ChatFish = srFindImageInRange("Fishing/" .. CL_Fish[i],Coords[0] ,Coords[1],500,25);
	if ChatFish then
		Sfish = string.sub(CL_Fish[i],string.find(CL_Fish[i],"Fish_") + 5,string.len(CL_Fish[i]) - 4);
		GrandTotalCaught = GrandTotalCaught + 1
		break;

	end
					
	end
				
	if  string.len(Sfish) < 1 then
	-- This fish name and fishname.png file likely needs to be added to Fishing_Func.inc, under the CL_Fish array and the .png added to /Images/Fishing folder
	--error("Unknown Fish! PLEASE, Take screenshot (Alt+C) of main chat tab, share with Talescripts team!");
	Sfish = "Error/Unknown"
	end
				
	--Find Size
	for i = #CL_Number,1,-1 do
		ChatSize =  srFindImageInRange("fishing/" .. CL_Number[i],Coords[0],Coords[1],500,25);
		if ChatSize then
			SNum = string.sub(CL_Number[i],string.find(CL_Number[i],"_") + 1, string.len(CL_Number[i]) - 4);
			break;
		end
	end
	GrandTotaldb = GrandTotaldb + SNum;
	return("[" .. CurrentLure .. " (" .. LureType .. ")] "  .. Sfish .. " (" .. SNum .. "db)");
	
end



function findchat(line)
	--Reads a chat line and returns a basic string for better processing
	
	-- Odd fish means your fly fishing skill is not high enough. Raise it with enormous amounts of fishing.
	-- Strange fish means you need a better rod to catch the rish. You may succeed on future attempts.
	-- Unusual fish means your speed skill was not high enough to catch this type of fish. If it is almost enough, you may catch them on future casts. 


	--Possible fishing messages
	--	Caught A (SIZE) Deben (FISH)
	--	You almost caught a strange fish
	--		(You almost caught a strange fish. You also lost your lure.)
	--	You almost caught an unusual fish
	--		(You almost caught an unusual fish. You also lost your lure.)
	--	You almost caught an odd fish
	--		(You almost caught an odd fish. You also lost your lure.)
	--	Although you lost your lure  (Caught a fish)
	--	Using a (LURE) (TYPE) lure.
	--	You are carrying more than you can manage.
	--	You are carrying too much bulk.
	--	You didn't catch anything.
	--		(You didn't catch anything. You also lost your lure.)
	--	No Fish Bit.
	--		(No Fish Bit. You also lost your lure.)

	
	--Find the last line of chat
	--lsSleep(100);
	checkBreak();
	srReadScreen();
	imgs = findAllImages("Fishing/chatlog_reddots.png");
	Coords = imgs[#imgs];

	if not Coords or #imgs == 0 then
		if not muteSoundEffects then
		lsPlaySound("timer.wav");
		end
	end
		-- Wait for Main chat screen and alert user if its not showing
		while not Coords or #imgs == 0 do
			checkBreak();
			srReadScreen();
			imgs = findAllImages("Fishing/chatlog_reddots.png");
			Coords = imgs[#imgs];
			sleepWithStatus(100, "Looking for Main chat screen ...");
		end

	gui_refresh();

	
	if line and line > 0 then
		Coords = imgs[(#imgs) - line];

		-- Wait for Main chat screen and alert user if its not showing
		--while not Coords or #imgs == 0 do
			--checkBreak();
			--srReadScreen();
			--imgs = findAllImages("Fishing/chatlog_reddots.png");
			--Coords = imgs[#imgs];
			--sleepWithStatus(100, "Looking for Main chat screen ...");
		--end

			--if not Coords then
			--error 'Main chat tab is not showing or the chat window needs to be adjusted!'
			--end

	end
	
	--Find What Happened

	ChatType = "";
	
	for i = 1, #Chat_Types -1,2 do
		test = srFindImageInRange("Fishing/" .. Chat_Types[i],Coords[0],Coords[1],500,30);		
		if test then
			--Found Chat
			ChatType = Chat_Types[i + 1];
			break;
		end
	end
	
	
	--Break down!
	if ChatType then
		--if ChatType == "lure" then
		--elseif ChatType == "nofishlostlure" then
		--elseif ChatType == "nofish" then
		--elseif ChatType == "strange" then
		--elseif ChatType == "unusual" then
		return ChatType;
	else
		error(ChatType);

	end
end


function findClockInfo()
  anchor = findText("Year");
  if(not anchor) then
    anchor = findText("ar 1");
  end
  if(not anchor) then

    anchor = findText("ar 2");
  end
  if(not anchor) then
    anchor = findText("ar 3");
  end
  if(not anchor) then
    anchor = findText("ar 4");
  end
  if(not anchor) then
    anchor = findText("ar 5");
  end
  if(not anchor) then
    anchor = findText("ar 6");
  end
  if(not anchor) then
    anchor = findText("ar 7");
  end
  if(not anchor) then
    anchor = findText("ar 8");
  end
  if(not anchor) then
    anchor = findText("ar 9");
  end


  if anchor then
    lsPrintln("Found Clock");
    window = getWindowBorders(anchor[0], anchor[1]);
    lines = findAllText(nil, window, NOPIN);
    for i=1,#lines do
      --lsPrintln("LINE " .. i .. " : " .. table.concat(lines[i], ","));

	theDateTime = table.concat(lines[1], ",") -- Line 1 on the clock
	theDateTime = string.sub(theDateTime,string.find(theDateTime,",") + 1);
	regionCoords = table.concat(lines[2], ",") -- Line 2 on the clock
	regionCoords = string.sub(regionCoords,string.find(regionCoords,",") + 1);
	Coordinates = string.sub(regionCoords,string.find(regionCoords,":") + 2);
	stripYear = string.sub(theDateTime,string.find(theDateTime,",") + 2);
	Time = string.sub(stripYear,string.find(stripYear,",") + 2);
	stripYear = "," .. stripYear
	Date = string.sub(stripYear,string.find(stripYear,",") + 1, string.len(stripYear) - string.len(Time) - 2);
      --lsPrintln(theDateTime .. "\nCoords: " .. Coordinates .. " (" .. string.len(Coordinates) .. ")\nTime: " .. Time .. " (" .. string.len(Time) .. ")\nDate: " .. Date .. " (" .. string.len(Date) .. ")");

    end
  end
end


function gui_refresh()
	checkBreak();
	checkBreakSpecial();

	if GrandTotalCasts == 0 or GrandTotalCasts == 1 then
	DateBegin = Date;
	TimeBegin = Time;
	end

	if GrandTotalCaught < 10 then
	last10 = GrandTotalCaught .. "/10";
	else
	last10 = 10;
	end


	--Stats (On Screen Display)
	--CurrentLureIndex  out of  PlayersLures
	winsize = lsGetWindowSize();

		if #PlayersLures == 0 then
		error 'Can\'t find any lures on the pinned window. Did you run out of lures?';
		elseif #PlayersLures == 1 then
		CurrentLureIndex = 1;
		QCurrentLureIndex = 1;

		elseif CurrentLureIndex > #PlayersLures then
		CurrentLureIndex = #PlayersLures;
		QCurrentLureIndex = 1;
		end



	CurrentLure = string.sub(PlayersLures[CurrentLureIndex],string.find(PlayersLures[CurrentLureIndex],"_")+1,string.len(PlayersLures[CurrentLureIndex])-4);
	QCurrentLure = string.sub(PlayersLures[QCurrentLureIndex],string.find(PlayersLures[QCurrentLureIndex],"_")+1,string.len(PlayersLures[QCurrentLureIndex])-4);

	lsPrintWrapped(10, 0, 0, lsScreenX - 20, 0.5, 0.5, 0xc0c0ffff, Date .. " | " .. Time .. " | " .. Coordinates);

	nextLureChange = TotalCasts + 1 - castcount
	nextLureChangeMessageColor = 0xc0ffffff;

	if nextLureChange <= 0 and LockLure then
	nextLureChangeMessageColor = 0xffff40ff;
	nextLureChangeMessage = "LOCKED! 0 casts remaining until Next Lure change!";
	elseif nextLureChange <= 0 and not LockLure then
	nextLureChangeMessageColor = 0xffff40ff;
	nextLureChangeMessage = "0 casts remaining until Next Lure change!";
	elseif LockLure then
	nextLureChangeMessageColor = 0xffff40ff;
	nextLureChangeMessage = "LOCKED! Lures will NOT change!";
	else
	nextLureChangeMessage = nextLureChange-1 .. " casts remaining until Next Lure change!";
	end

	lsPrintWrapped(10, 14, 0, lsScreenX - 20, 0.5, 0.5, 0xc0ffc0ff, "Current Lure: " .. CurrentLureIndex .. " of " .. #PlayersLures .. "   " .. CurrentLure .. " (" .. LureType .. ")");

	if skipLure or ((TotalCasts + 1 - castcount) <= 1 and not LockLure) then
	nextLureChangeMessageColor = 0xffffc0ff;
	nextLureChangeMessage = "0 casts remaining until Next Lure change!";
	end

	lsPrintWrapped(10, 26, 0, lsScreenX - 20, 0.5, 0.5, nextLureChangeMessageColor, nextLureChangeMessage);
	lsPrintWrapped(10, 41, 0, lsScreenX - 20, 0.5, 0.5, 0xfcad86ff, "Cast Timer: " .. castWait/1000);
      lsSetCamera(0,0,lsScreenX*1.6,lsScreenY*1.6);

    if lsButtonText(160, 62, 0, 20, 0xffffffff,
                    "-"	) then
	QCurrentLureIndex = QCurrentLureIndex - 1;
		if QCurrentLureIndex < 1 then

		QCurrentLureIndex = #PlayersLures;
		end

    end

    if lsButtonText(187, 62, 0, 20, 0xffffffff,
                    "+"	) then
	QCurrentLureIndex = QCurrentLureIndex + 1
		if QCurrentLureIndex > #PlayersLures then
		QCurrentLureIndex = 1;
		end
    end

      lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);

	lsPrintWrapped(137, 41, 0, lsScreenX - 20, 0.5, 0.5, 0xfFFFFFff, "Next Lure (" .. QCurrentLureIndex .. "):");

	if skipLure or ((TotalCasts + 1 - castcount) <= 1 and not LockLure) then
	lsPrintWrapped(209, 41, 0, lsScreenX - 20, 0.5, 0.5, 0xffffc0ff, QCurrentLure);
	else
	lsPrintWrapped(209, 41, 0, lsScreenX - 20, 0.5, 0.5, 0xc0ffffff, QCurrentLure);
	end

	lsPrintWrapped(10, 58, 0, lsScreenX - 20, 0.5, 0.5, 0xffffc0ff, "Last " .. last10 .. " Fish Caught:\n");
	--Reset this string before showing last10 or allcaught fish below. Else the entries will multiply exponetially with entries from previous loops/call to this function
	last10caught = "";
	allcaught = "";
	lostlures = "";

	if #gui_log_fish > 10 then
		table.remove(gui_log_fish,1);
	end
		for i = 1, #gui_log_fish,1 do
			lsPrintWrapped(10, 57 + (14*i), 0, lsScreenX - 18, 0.5, 0.5, 0xffffdfff, gui_log_fish[i]);
			--last10caught = last10caught .. gui_log_fish[i] .. "\n";
		end

		for i = 1, #gui_log_fish2,1 do
			allcaught = allcaught .. gui_log_fish2[i] .. "\n";
		end

		for i = 1, #lostlure_log,1 do
			lostlures = lostlures .. lostlure_log[i] .. "\n";
		end


	lsPrintWrapped(10, winsize[1]-133, 0, lsScreenX - 20, 0.5, 0.5, 0xffffffff, "Odd Fish Seen: " .. GrandTotalOdd);
	lsPrintWrapped(10, winsize[1]-121, 0, lsScreenX - 20, 0.5, 0.5, 0xffffffff, "Unusual Fish Seen: " .. GrandTotalUnusual);
	lsPrintWrapped(10, winsize[1]-109, 0, lsScreenX - 20, 0.5, 0.5, 0xffffffff, "Strange Fish Seen: " .. GrandTotalStrange);
	lsPrintWrapped(10, winsize[1]-97, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "-----------------------------");
	lsPrintWrapped(10, winsize[1]-85, 0, lsScreenX - 20, 0.5, 0.5, 0xc0ffc0ff, "Lures Switched: " .. GrandTotalLuresUsed-1);
		if lastLostLure ~= "" then
	lsPrintWrapped(10, winsize[1]-73, 0, lsScreenX - 20, 0.5, 0.5, 0xff8080ff, "Lures Lost: " .. GrandTotalLostLures .. "   -  Last: " .. lastLostLure .. " (" .. lastLostLureType .. ")");
		else
	lsPrintWrapped(10, winsize[1]-73, 0, lsScreenX - 20, 0.5, 0.5, 0xff8080ff, "Lures Lost: " .. GrandTotalLostLures);
		end

	lsPrintWrapped(10, winsize[1]-61, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "-----------------------------");
	lsPrintWrapped(10, winsize[1]-49, 0, lsScreenX - 20, 0.5, 0.5, 0xc0ffffff, "Completed Casts: " .. GrandTotalCasts);
	lsPrintWrapped(10, winsize[1]-37, 0, lsScreenX - 20, 0.5, 0.5, 0xff8080ff, "Failed Catches: " .. GrandTotalFailed);
	lsPrintWrapped(10, winsize[1]-25, 0, lsScreenX - 20, 0.5, 0.5, 0xffffc0ff, "Fish Caught: " .. GrandTotalCaught .. " (" .. GrandTotaldb .. "db)");

      lsSetCamera(0,0,lsScreenX*1.6,lsScreenY*1.6);

    if lsButtonText(lsScreenX + 40, lsScreenY - 10, 0, 130, 0xFFFFFFff,
                    "Options") then


	setResume = true;
	setOptions();
    end

	if not setPause then
    if lsButtonText(lsScreenX + 40, lsScreenY + 20, 0, 130, 0xFFFFFFff,
                    "Pause") then
	setPause = true;
    end
	end

    if lsButtonText(lsScreenX + 40, lsScreenY + 50, 0, 130, 0xFFFFFFff,
                    "End Script") then
      error(quitMessage);
    end

      lsSetCamera(0,0,lsScreenX*1.4,lsScreenY*1.4);

		--Test messages can go here...
		--lsPrintWrapped(280, winsize[1]+40, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, ChangeLureMenu);
		--lsPrintWrapped(280, winsize[1]+55, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, LastLureMenu);

	lsPrintWrapped(305, winsize[1]+70, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "(TOGGLE ON / OFF)");
      lsSetCamera(0,0,lsScreenX*1.6,lsScreenY*1.6);

	if skipLure or ((TotalCasts + 1 - castcount) <= 1 and not LockLure) then
	skipLureText = "Queued ...";
	skipLureTextColor = 0xffff40ff;
	else
	skipLureText = "Next Lure";
	skipLureTextColor = 0xFFFFFFff;
	end

    if lsButtonText(lsScreenX + 40, lsScreenY + 150, 0, 130, skipLureTextColor,
                    skipLureText	) then
		if skipLure then
	skipLure = false;
		else
	skipLure = true;
	LockLure = false;
		end
    end


	if LockLure then
	LockLureColor =  0xffff40ff;
	LockLureText =  "Unlock Lure!";
	else
	LockLureColor = 0xFFFFFFff;
	LockLureText = "Lock Lure";
	end


    if lsButtonText(lsScreenX + 40, lsScreenY + 180, 0, 130, LockLureColor,
                    LockLureText ) then

		if LockLure then
	LockLure =  false;
		else
	LockLure = true;
	skipLure = false;
		end

    end

	if #lostlure_log == 0 then
	lostlures = "*** No lures lost! ***";
	end

	if #gui_log_fish2 == 0 then
	allcaught = "*** No fish caught! ***";
	end

	WriteFishStats("Note this report is overwritten every time the macro runs. The stats are for last fishing session only!\nYou can safely delete this file, but it will be created the next time macro runs!\n\n\nStart Time: " .. DateBegin .. " @ " .. TimeBegin .. "\nEnd Time: " .. Date .. " @ " .. Time .. "\nLast Coordinates: " .. Coordinates .. "\n----------------------------------\nOdd Fish Seen: " .. GrandTotalOdd .. "\nUnusual Fish Seen: " .. GrandTotalUnusual .. "\nStrange Fish Seen: " .. GrandTotalStrange .. "\n----------------------------------\nLures Clicked: " .. GrandTotalLuresUsed .. "\nLures Lost: " .. GrandTotalLostLures .. " \n----------------------------------\nCasts: " .. GrandTotalCasts .. "\nFailed Catches: " .. GrandTotalFailed .. "\nFish Caught: " .. GrandTotalCaught .. " (" .. GrandTotaldb .. "db)\n----------------------------------\n\nAll lures lost this Session:\n\n" .. lostlures .. "\n\n\nAll fish caught this Session:\n\n".. allcaught);

	lsDoFrame();
	lsSleep(10);
end



function doit()

  askForWindow("Fishing v1.53 (by Tutmault, revised by KasumiGhia, revised by Cegaiel)\n\nMAIN chat tab MUST be showing and wide enough so that each line doesn't wrap.\n\nPin up Lures Menu (Self, Skills, Fishing, Use Lures). No other pinned menus can exist! History will be recorded in FishLog.txt and stats in FishStats.txt.\n\nSelf, Options, Interface Options (Menu:) \"Display available fishing lures in submenus\" MUST BE CHECKED! Egypt Clock /clockloc must be showing and unobstructed. Move clock window slightly if any problems.\n\nMost problems can be fixed by adjusting main chat window!");

----------------------------------------
--Variables Used By Program -- Don't Edit Unless you know what you're doing!
	CurrentLure = ""; --Don't Edit
	gui_log_fish = {}; --Don't Edit, holds log display
	gui_log_fish2 = {}; --Don't Edit, holds log display
	log_fish = {}; --Don't Edit, holds log display
	lostlure_log = {}; --Don't Edit, holds log display
	CurrentLureIndex = 1; -- 1 = First Lure Player Owns in alphabetical order
	QCurrentLureIndex = 1;
	ChangeLureMenu="";
	LastLureMenu="";
	DownArrowLocs=nil;
	PlayersLures={}; --Don't Edit, Holds Current Player Lures

	--strangecounter = 0;
	castcount = 0;
	GrandTotalCaught = 0;
	GrandTotalCasts = 0;
	GrandTotaldb = 0;
	GrandTotalStrange = 0;
	GrandTotalOdd = 0;
	GrandTotalUnusual = 0;
	GrandTotalLuresUsed = 0;
	GrandTotalLostLures = 0;
	GrandTotalFailed = 0;
	lastLostLure = "";	
	LostLure = 0;
	LureType = "";
	lastLostLureType = "";
	lockLure = false;
	setPause = false;
	skipLure = false;
	castWait = 15000;
	firstrun = 1;
----------------------------------------

      setOptions();
	PlayersLures = SetupLureGroup();  -- Fetch the list of lures from pinned lures window

	findClockInfo(); 
		while not Time do
		  checkBreak();
		  findClockInfo();
		  sleepWithStatus(250, "Can not find Clock!\n\nMove your clock slightly.\n\nMacro will resume once found ...\n\nIf you do not see a clock, type /clockloc in chat bar.");
		end

	while 1 do

		-- Loop, do nothing while Paused
		while setPause do
		checkBreak();
		lsSleep(150);
		end	
		
		checkBreak();
		srReadScreen();
		--cast = srFindImage("Fishing/Button_Fish.png");
		cast = srFindImage("fishicon.png");
		OK = srFindImage("OK.png");

		if not cast then
			if not muteSoundEffects then
			lsPlaySound("timer.wav");
			end
		end

		while not cast do
		checkBreak();
		srReadScreen();
		cast = srFindImage("fishicon.png");
		sleepWithStatus(100, "Looking for Fishing icon ...");
		end


			if castcount == 0 or OK or skipLure then
			--Update counters
			castcount = 1;

				if OK then
				-- We treat this as a lost lure if the OK box appears. This happens when you press fishing icon, but you equipped lure was lost (no lure equipped).
				-- This is just in case, the macro failed to read "Lost Lure" message in main chat. Otherwise, when a lure was detected in main chat, it would have changed lures.
				srClickMouseNoMove(OK[0]+5,OK[1]+3);  -- Close the popup OK button
				GrandTotalLostLures = GrandTotalLostLures + 1;
				--GrandTotalFailed = GrandTotalFailed + 1;
				lastLostLure = CurrentLure;
				lastLostLureType = LureType;
				LostLure = 1;
				end


			--Switch Lures
			  if #PlayersLures > 1 or (firstrun == 1 and #PlayersLures > 0) then --No need to switch Lures if we only have one, but we need to do it the very first time in case we have another lure equipped!
			UseLure();
			GrandTotalLuresUsed = GrandTotalLuresUsed + 1;
			  end

			skipLure = false;
			if #PlayersLures > 1 then
			LockLure = false;
			else
			LockLure = true;
			end

			lsSleep(500);		
			srReadScreen();
			--Look for an empty window - This means it clicked a lure no longer in inventory (lost), but still showing on the lures menu (before it got refreshed)
			FindUnPin = srFindImage("Fishing/Menu_MissingLure.png");
				if FindUnPin then
					srKeyEvent(string.char(27));  -- Send Esc Key to close the window
					sleepWithStatus(500,"No " .. QCurrentLure .. " lures found!\nRefreshing lure list ...")
					PlayersLures = SetupLureGroup();
						if QCurrentLureIndex  > #PlayersLures or QCurrentLureIndex == 1 then
							QCurrentLureIndex = 2;
							CurrentLureIndex = 1;
						else
							CurrentLureIndex = CurrentLureIndex + 1;
							QCurrentLureIndex = QCurrentLureIndex + 1;
						end

				UseLure();
				else
				CurrentLureIndex = QCurrentLureIndex;
				QCurrentLureIndex = QCurrentLureIndex + 1;
				end



			if QCurrentLureIndex  > #PlayersLures then
				--Last Lure, Prepare to go to first lure in list ...
				--PlayersLures = SetupLureGroup();
				QCurrentLureIndex = 1;
				CurrentLureIndex = #PlayersLures;
			end

			firstrun = 0;

			--update log
			gui_refresh();


		elseif castcount  > TotalCasts and not LockLure then
		--	if strangecounter > 0 and strangecounter < AlmostCaughtAttempts then
				--we don't reset yet!
		--	else
				--Reset
				castcount=0;
				strangecounter = 0;
		--	end
		else

			--Cast
			checkBreak();
			srClickMouseNoMove(cast[0]+3,cast[1]+3);
			castWait = castWaitTimer;

			--while findchat(castcount - 1) == "lure" do
			
			 while castWait > 0 do
				checkBreak();
				lsSleep(100);
				castWait = castWait - 100;
				gui_refresh();
			end

			castcount = castcount + 1;
			GrandTotalCasts = GrandTotalCasts + 1;	
			findClockInfo(); 


			--Read Chat
			ChatType = findchat();
			LastChatType = ChatType;
			lsSleep(200);
			CurrentLure = string.sub(PlayersLures[CurrentLureIndex],string.find(PlayersLures[CurrentLureIndex],"_")+1,string.len(PlayersLures[CurrentLureIndex])-4);

			if ChatType == "alreadyfishing" then
				castcount = castcount - 1;
				GrandTotalCasts = GrandTotalCasts - 1;	
					if not muteSoundEffects then
					lsPlaySound("cymbals.wav");
					end

			elseif ChatType == "nobitlostlure" then
				--No fish bit. You also lost your lure.
				GrandTotalLostLures = GrandTotalLostLures + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
				lastLostLure = CurrentLure;
				lastLostLureType = LureType;
				LostLure = 1;
					--Reset, skip to next lure
					castcount=0;
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. "No fish bit. You also lost your lure." .. 
"\n");				
					if not muteSoundEffects then
					lsPlaySound("cymbals.wav");
					end

			elseif ChatType == "nobit" then
				--No fishbit
				GrandTotalFailed = GrandTotalFailed + 1;
					if LogFails == true then
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. "No fish bit." .. "\n");
					end


			elseif ChatType == "nocatchlostlure" then
				--You didn't catch anything. You also lost your lure.
				GrandTotalLostLures = GrandTotalLostLures + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
				lastLostLure = CurrentLure;
				lastLostLureType = LureType;
				LostLure = 1;
					--Reset, skip to next lure
					castcount=0;
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. "You didn\'t catch anything. You also lost your lure." .. "\n");
					if not muteSoundEffects then
					lsPlaySound("cymbals.wav");
					end

			elseif ChatType == "nocatch" then
				--You didn't catch anything.
				GrandTotalFailed = GrandTotalFailed + 1;
					if LogFails == true then
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. "You didn\'t catch anything." .. "\n");
					end


			elseif ChatType == "strangelostlure" then

				-- Strange Fish and lost lure
				GrandTotalStrange = GrandTotalStrange + 1;
				GrandTotalLostLures = GrandTotalLostLures + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
				lastLostLure = CurrentLure;
				lastLostLureType = LureType;
				LostLure = 1;
					--Reset, skip to next lure
					castcount=0;
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. "You almost caught a STRANGE fish, but your rod was just too clumbsy. You also lost your lure." .. "\n");
						if not muteSoundEffects then
						lsPlaySound("cymbals.wav");
						end

			--	if AlmostCaughtAttempts > 0 then
			--		strangecounter = strangecounter +1;
			--	end



			elseif ChatType == "strange" then
				--Strange Fish
				GrandTotalStrange = GrandTotalStrange + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
					if LogStrangeUnusual == true then
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. "You almost caught a STRANGE fish, but your rod was just too clumbsy." .. "\n");
					end

			--	if AlmostCaughtAttempts > 0 then
			--		strangecounter = strangecounter +1;
			--	end
			

	
			elseif ChatType == "unusuallostlure" then
				--Unusual Fish
				GrandTotalUnusual = GrandTotalUnusual + 1;
				GrandTotalLostLures = GrandTotalLostLures + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
				lastLostLure = CurrentLure;
				lastLostLureType = LureType;
				LostLure = 1;
					--Reset, skip to next lure
					castcount=0;
					if not muteSoundEffects then
					lsPlaySound("cymbals.wav");
					end

					if LogStrangeUnusual == true then
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. "You almost caught an UNUSUAL fish, but you were not quick enough. You also lost your lure." .. "\n");
					end



			--	if AlmostCaughtAttempts > 0 then
			--		strangecounter = strangecounter +1;
			--	end



			elseif ChatType == "unusual" then
				-- Unusual Fish
				GrandTotalUnusual = GrandTotalUnusual + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
					if LogStrangeUnusual == true then
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. "You almost caught an UNUSUAL fish, but you were not quick enough." .. "\n");
					end

			--	if AlmostCaughtAttempts > 0 then
			--		strangecounter = strangecounter +1;
			--	end



			elseif ChatType == "oddlostlure" then
				-- Odd Fish and lost lure
				GrandTotalOdd = GrandTotalOdd + 1;
				GrandTotalLostLures = GrandTotalLostLures + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
				lastLostLure = CurrentLure;
				lastLostLureType = LureType;
				LostLure = 1;
					--Reset, skip to next lure
					castcount=0;
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. "You almost caught an ODD fish, but were too late recognizing the bite. You also lost your lure." .. "\n");



			elseif ChatType == "odd" then
				-- Odd Fish
				GrandTotalOdd = GrandTotalOdd + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
					if LogOdd == true then
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. "You almost caught an ODD fish, but were too late recognizing the bite." .. "\n");
					end



			elseif ChatType == "carry" then
				--chat lines are messed up now
				castcount=0;
				

			elseif ChatType == "caught" or ChatType == "caughtlostlure" then
				Fish = ChatReadFish();
				--Last 10 fish caught that displays on GUI
				addlog = Time .. " | " .. Sfish .. " (" .. SNum .. "db) | " .. CurrentLure
				table.insert(gui_log_fish, addlog);
				-- All fish caught that displays in fishstats.txt
				table.insert(gui_log_fish2, addlog);
					if not muteSoundEffects then
					lsPlaySound("trolley.wav");
					end

				if ChatType == "caughtlostlure" then
					GrandTotalLostLures = GrandTotalLostLures + 1;
					lastLostLure = CurrentLure;
					lastLostLureType = LureType;
					LostLure = 1;
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] " .. Fish .. " was caught. You also lost a lure.\n");
					--Reset, skip to next lure
					castcount=0;
					if not muteSoundEffects then
					lsPlaySound("cymbals.wav");
					end
							
				else
					WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] " .. Fish .. " was caught.\n");

				end
				
				--gui_refresh();
				
				if SkipCommon == true and LockLure == false then
					--FishType = string.sub(Fish,string.find(Fish,",") + 1);
					FishType = Sfish;
					if FishType == "Abdju" or FishType == "Chromis" or FishType == "Catfish" or FishType == "Carp" or FishType == "Perch" or FishType == "Phagrus" or FishType == "Tilapia" then
						--Skip it
						castcount=0;

					end
				end
			gui_refresh();
			end
			
		gui_refresh();
		end
	gui_refresh();
	end
end