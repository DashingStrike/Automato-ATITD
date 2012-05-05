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


-- "Main chat tab is not showing" and other errors can usually be overcome by adjusting the main chat window size and restarting, assuming main chat is showing.
-- And also verify the lines aren't wrapping.


-- The very first thing this macro does is to Self Click, Special, What Time is it? option. This will then display the time in main chat window.
-- The macro then parses time displayed, in main chat tab, so it can use it while the macro runs (Log files and on screen display).
-- Thats what the mysterious Self Click is doing, its not a bug, it is suppose to do that and thats why, to fetch the time.


	-- Note: These are currently refered to as Common Fish in the below 'SkipCommon' type of fishes (True or False), in the 'Custom Variables' section.

	--Abdju
	--Chromis
	--Catfish
	--Carp
	--Perch
	--Phagrus
	--Tilapia



--CUSTOM VARIABLES -- EDIT HERE To Change Fishing Casts, Skips, Updates.

TotalCasts=3; --Total Casts per lure, if a fish caught. If no fish then it skips.
SkipCommon = false; --Skips to next lure if fish caught is a common (Choose True or False).
LureChangesToUpdateTimer = 7; --Total lures used before time is updated. Zero updates every new lure.

--AlmostCaughtAttempts = 0; --Adds additional attempts to the current lure if Unusual, Strange fish are seen;
-- Note: AlmostCaughtAttempts above was already commented out upon arriving to Talescripts.
-- It is also commented out during the script, so uncommenting above will NOT activate the feature.



-- Additional reporting in the log file
-- Choose True or False.
	-- Note 'LogStrangeUnusual' and 'LogOdd' (below) overrides LogFails setting. ie if LogStrange true, then it would still log even if LogFails = False
	--If LogFails = false and LogStrangeUnusual or LogOdd = true, then failed catches those would still be included in the log file. 


LogFails = true;  	-- Do you want to add Failed Catches to log file? 'Failed to catch anything' or 'No fish bit'. Note the log will still add an entry if you lost lure.
LogStrangeUnusual = true; 	-- Do you want to add Strange and Unusual fish to the log file? Note the log will still add an entry if you lost lure.
LogOdd = true; 	-- Do you want to add Odd fish to the log file? Note the log will still add an entry if you lost lure.


-- END CUSTOM VARIABLES



loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();
loadfile("luaScripts/Fishing_Func.inc")();



function SetupLureGroup()

	TLures = {};
	FirstLure="";
	LastLure = "";



	
	srReadScreen();
	FindPin = srFindImage("UnPin.png");
	if FindPin then
		

	--Click the pinup to refresh the lures window

	srClickMouseNoMove(FindPin[0]+5,FindPin[1]+30);
	lsSleep(500);


	srReadScreen();


		DownPin = srFindImageInRange("Fishing/Menu_DownArrow.png",FindPin[0]-10,FindPin[1],50,500);
		if DownPin then
			--Just Incase
			UpArrow = srFindImageInRange("Fishing/Menu_UpArrow.png",FindPin[0]-10,FindPin[1],50,50);
			if UpArrow then
				srClickMouseNoMove(UpArrow[0]+5,UpArrow[1]+5);
				lsSleep(1000);
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
		


		for i = 1, #Lures,1 do
			test = srFindImageInRange(("fishing/" .. Lures[i]),FirstLurLoc[0]-5,FirstLurLoc[1]-5,175,500);

			if test then
				--Add Lure
				table.insert(TLures,Lures[i]);
				if Lures[i] == LastLure then
					--End of Menu, Use Down Arrow
					arrow=srFindImageInRange("Fishing/menu_downarrow.png",test[0],test[1]-5,175,50);
					if arrow then
						DownArrowLocs = arrow;
						srClickMouseNoMove(arrow[0]+5,arrow[1]+5);
						lsSleep(1000);
						srReadScreen();
						lsSleep(1000);
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
		for i = 1, #Lures, 1 do
			test = srFindImage("Fishing/" .. Lures[i]);
			if test then
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

function GetLure()

	srReadScreen();
	
	if CurrentLureIndex == LastLureIndex then
		-- Use Down Menu
		srClickMouseNoMove(DownArrowLocs[0]-5,DownArrowLocs[1]-5);
		srReadScreen();
	end

	lure = srFindImage("Fishing/" .. PlayersLures[CurrentLureIndex]);
	if not lure then
		--Failed to find lure
		error("Can\'t find a lure!");
	else
		slure = Lures[PlayersLures[CurrentLureIndex]];
		slure = string.sub(slure,string.find(slure,"_")+1,string.len(slure) - 4);
		--statusScreen("Using Lure " .. slure);
		return slure
	end
end

function UseLure()
	-- Uses lure according to CurrentLureIndex, which is used in PlayersLures which contains each lure the player has. 


	if #TLures == 0 then
	error 'Can\'t find any lures on the pinned window. Did you run out of lures?'
	end


	srReadScreen();
	lure = srFindImage("Fishing/" .. PlayersLures[CurrentLureIndex]);

	if lure then
		srClickMouseNoMove(lure[0]+3,lure[1]+3);
		lsSleep(500);
		srReadScreen();
		-- Find Lure Type
		for i = 1, #Lure_Types, 1 do
			test = srFindImage("Fishing/" .. Lure_Types[i]);
			if test then
				--Click it!
				srClickMouseNoMove(test[0]+3,test[1]+3);
				gui_refresh();
				break;
			end
		end

	end
	
	if PlayersLures[CurrentLureIndex] == ChangeLureMenu then
		down = srFindImage("Fishing/Menu_DownArrow.png");
		srClickMouseNoMove(down[0]+5,down[1]+5);
		lsSleep(1000);
	elseif PlayersLures[CurrentLureIndex] == LastLureMenu  then
		up = srFindImage("Fishing/Menu_UpArrow.png");
		srClickMouseNoMove(up[0]+5,up[1]+5);
		CurrentLureIndex=1;
		lsSleep(1000);
	end
	

end

function ChatReadFish()
	--Find the last line of chat
	lsSleep(100);
	srReadScreen();
	imgs = findAllImages("fishing/chatlog_reddots.png");
	Coords = imgs[#imgs];
	
		-- Look for the ** red dots in main chat to see if they exist.	
		if #imgs == 0 then
		error 'Main chat tab is not showing or the chat window needs to be adjusted!'
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
	error("Unknown Fish! PLEASE, Take screenshot (Alt+C) of main chat tab, share with Talescripts team!");
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
	return(Sfish .. " (" .. SNum .. "db)");
	
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
	lsSleep(100);
	srReadScreen();
	imgs = findAllImages("Fishing/chatlog_reddots.png");
	Coords = imgs[#imgs];

		-- Look for the ** red dots in main chat to see if they exist.	
		if #imgs == 0 then
		error 'Main chat tab is not showing or the chat window needs to be adjusted!'
		end

	
	if line and line > 0 then
		Coords = imgs[(#imgs) - line];
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



function GetTime()
	--Reads time stamp using special->what time menu
	winsize = srGetWindowSize();
	
	--Open Menu, Press the Esc key to open the Self Click menu

	-- Move mouse to center of screen before Sending the Esc key, to get the Self Click menu. We dont want it self clicking near the edge of screen causing an error.
	srSetMousePos(winsize[0]/2,winsize[1]/2);
	lsSleep(100);  -- This delay is critical for any srSetMousePos. Without it, the mouse will not have time to actually move!

	srKeyEvent(string.char(27));  -- Send Esc Key
	lsSleep(500);
	
	--Find Special Menu
	srReadScreen();
	menu = srFindImage("Fishing/Menu_Special.png");
	
	if menu then
		--Click it!
		srClickMouseNoMove(menu[0]+3,menu[1]+3);
		
		lsSleep(500);
		srReadScreen();

		-- Look for the What Time Is It? option in menu
		menu = srFindImage("Fishing/Menu_WhatTime.png");
		if menu then
			--Click it!
			srClickMouseNoMove(menu[0]+3,menu[1]+3);
			lsSleep(500);
		end
	end



	
	srReadScreen();
	imgs = findAllImages("Fishing/chatlog_reddots.png");
	Coords = imgs[#imgs];

		-- Look for the ** red dots in main chat to see if they exist.	
		if #imgs == 0 then
		error 'Main chat tab is not showing or the chat window needs to be adjusted!'
		end

	
	for i = #CL_Time, 1, -1 do
		Stime = srFindImageInRange("Fishing/" .. CL_Time[i],Coords[0],Coords[1],400,25);
		if Stime then
			Hour = string.sub(CL_Time[i],string.find(CL_Time[i],"ime_")+4,string.len(CL_Time[i])-4);
			
			AM = srFindImageInRange("Fishing/Chatlog_Time_AM.png",Coords[0],Coords[1],400,25);
			if AM then
				CurrentTime=(Hour .. "AM");
				return (Hour .. "AM");
			else
				PM = srFindImageInRange("Fishing/chatlog_time_PM.png",Coords[0],Coords[1],400,25);
				if PM then
					CurrentTime=(Hour .. "PM");
					return (Hour .. "PM");
				end
			end

		end
	end
end

function gui_refresh()
	lsDoFrame();


	if GrandTotalCaught < 10 then
	last10 = GrandTotalCaught .. "/10";
	else
	last10 = 10;
	end


	--Stats (On Screen Display)
	--CurrentLureIndex  out of  PlayersLures
	winsize = lsGetWindowSize();
	
	
	lsPrintWrapped(10, 0, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Lure Index: " .. CurrentLureIndex .. " out of " .. #PlayersLures .. "       " .. PlayersLures[CurrentLureIndex]);


	lsPrintWrapped(10, 20, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Time: " .. CurrentTime);

	lsPrintWrapped(10, 40, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Last [" .. last10 .. "] Fish Caught:");

	--Reset this string before showing last 10 fish below. Else the entries will multiply with entries from previous loops/call to this function
	last10caught = "";

	if #gui_log_fish > 10 then
		table.remove(gui_log_fish,1);
	end
		for i = 1, #gui_log_fish,1 do
			lsPrintWrapped(10, 50 + (12*i), 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, gui_log_fish[i]);
			last10caught = last10caught .. gui_log_fish[i] .. "\n";
		end


	lsPrintWrapped(10, winsize[1]-133, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Odd Fish Seen: " .. GrandTotalOdd);
	lsPrintWrapped(10, winsize[1]-121, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Unusual Fish Seen: " .. GrandTotalUnusual);
	lsPrintWrapped(10, winsize[1]-109, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Strange Fish Seen: " .. GrandTotalStrange);

	lsPrintWrapped(10, winsize[1]-97, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "-----------------------------");

	lsPrintWrapped(10, winsize[1]-85, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Lures Clicked: " .. GrandTotalLuresUsed);
	lsPrintWrapped(10, winsize[1]-73, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Lures Lost: " .. GrandTotalLostLures);

	lsPrintWrapped(10, winsize[1]-61, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "-----------------------------");

	lsPrintWrapped(10, winsize[1]-49, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Total Casts: " .. GrandTotalCasts);
	lsPrintWrapped(10, winsize[1]-37, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Failed Catches: " .. GrandTotalFailed);
	lsPrintWrapped(10, winsize[1]-25, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Fish Caught: " .. GrandTotalCaught .. " (" .. GrandTotaldb .. "db)");


	-- Write stats to log file. Everytime the GUI screen is updated, so is the log file.

	WriteFishStats("Last Session Hour: " .. CurrentTime .. "\n\nOdd Fish Seen: " .. GrandTotalOdd .. "\nUnusual Fish Seen: " .. GrandTotalUnusual .. "\nStrange Fish Seen: " .. GrandTotalStrange .. "\n---------------------\nLures Clicked: " .. GrandTotalLuresUsed .. "\nLures Lost: " .. GrandTotalLostLures .. " \n---------------------\nTotal Casts: " .. GrandTotalCasts .. "\nFailed Catches: " .. GrandTotalFailed .. "\nFish Caught: " .. GrandTotalCaught .. " (" .. GrandTotaldb .. "db)\n---------------------\n\nLast 10 Fish Caught:\n\n".. last10caught);




end





function doit()
	askForWindow("MAIN chat tab MUST be showing and wide enough so that each lines doesn't wrap. Pin up Lures Menu (Self, Skills, Fishing, Use Lures). No other pinned menus can exist. More detailed instructions are included inside the script as comments at top. There are options you can set in the script such as how many casts per lure, what gets written to the log file and more! History will be recorded in FishLog.txt and stats in FishStats.txt. Most errors can be fixed by slightly adjusting/moving your chat screen! Press Shift to continue.");

	--Gui_Main();


--Variables Used By Program -- Don't Edit Unless you know what you're doing!
	CurrentLure = ""; --Don't Edit
	gui_log_fish = {}; --Don't Edit, holds log display
	log_fish = {};
	CurrentLureIndex=0; -- 1 = First Lure Player Owns in alphabetical order
	ChangeLureMenu="";
	LastLureMenu="";
	DownArrowLocs=nil;
	PlayersLures={}; --Don't Edit, Holds Current Player Lures
	CurrentTime=""; --Don't Edit, Holds Time Check Value
	TotalLuresUsed = 0;
	castcount = 0;
	--strangecounter = 0;


--These variables were later added for displaying additional info on the screen.
-- Used for the extra reporting/statistics, on screen.
-- Dont Edit Unless you know what you're doing!

	GrandTotalCaught = 0;
	GrandTotalCasts = 0;
	GrandTotaldb = 0;
	GrandTotalStrange = 0;
	GrandTotalOdd = 0;
	GrandTotalUnusual = 0;
	GrandTotalLuresUsed = 0;
	GrandTotalLostLures = 0;
	GrandTotalFailed = 0;

	
	PlayersLures = SetupLureGroup();
	CurrentTime = GetTime();
	lsSleep(1500);


	--Write an entry into log file to show this is a new session
	WriteFishLog("[New Session]\n");

	
	while 1 do
		
		checkBreak();
		srReadScreen();
		
		
		--cast = srFindImage("Fishing/Button_Fish.png");
		cast = srFindImage("fishicon.png");
		if not cast then
			error("cannot find fishing button");
		end
		
		if castcount == 0 then
			--Update counters
			castcount = 1;
			CurrentLureIndex = CurrentLureIndex +1;


			if CurrentLureIndex > #PlayersLures then
				--Refresh the Lure window, and reindex it, in case some were lost.
				PlayersLures = SetupLureGroup();
				CurrentLureIndex = 1;
			end


			
			--Update the time if ready, always update before new lure to keep chat/log proper
			if TotalLuresUsed == LureChangesToUpdateTimer then
				--Update Time

				CurrentTime = GetTime();
				TotalLuresUsed = 0;
			end
			
			--Since no casts been made at all, use a lure
			UseLure();
			lsSleep(2000);
			TotalLuresUsed = TotalLuresUsed + 1;
			GrandTotalLuresUsed = GrandTotalLuresUsed + 1;
			
			--update log
			gui_refresh();
			
		elseif castcount  > TotalCasts then
		--	if strangecounter > 0 and strangecounter < AlmostCaughtAttempts then
				--we don't reset yet!
		--	else
				--Reset
				castcount=0;
				strangecounter = 0;
		--	end
		else
			--Cast
			srClickMouseNoMove(cast[0]+3,cast[1]+3);
			lsSleep(1000);
			checkBreak();



			while findchat(castcount - 1) == "lure" do
				lsSleep(1000);
				checkBreak();
			end


			castcount = castcount + 1;
			GrandTotalCasts = GrandTotalCasts + 1;	





			--Read Chat
			ChatType = findchat();

			lsSleep(200);

			CurrentLure = string.sub(PlayersLures[CurrentLureIndex],string.find(PlayersLures[CurrentLureIndex],"_")+1,string.len(PlayersLures[CurrentLureIndex])-4);


			if ChatType == "nobitlostlure" then
				--No fish bit. You also lost your lure.
				GrandTotalLostLures = GrandTotalLostLures + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
					--Reset, skip to next lure
					castcount=0;
					WriteFishLog("[" .. CurrentTime .. "]\t[" .. CurrentLure .. "]\t" .. "No fish bit. You also lost your lure." .. "\n");


			elseif ChatType == "nobit" then
				--No fishbit
				GrandTotalFailed = GrandTotalFailed + 1;
					if LogFails == true then
					WriteFishLog("[" .. CurrentTime .. "]\t[" .. CurrentLure .. "]\t" .. "No fish bit." .. "\n");
					end


			elseif ChatType == "nocatchlostlure" then
				--You didn't catch anything. You also lost your lure.
				GrandTotalLostLures = GrandTotalLostLures + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
					--Reset, skip to next lure
					castcount=0;
					WriteFishLog("[" .. CurrentTime .. "]\t[" .. CurrentLure .. "]\t" .. "You didn\'t catch anything. You also lost your lure." .. "\n");


			elseif ChatType == "nocatch" then
				--You didn't catch anything.
				GrandTotalFailed = GrandTotalFailed + 1;
					if LogFails == true then
					WriteFishLog("[" .. CurrentTime .. "]\t[" .. CurrentLure .. "]\t" .. "You didn\'t catch anything." .. "\n");
					end


			elseif ChatType == "alreadyfishing" then
				--castcount = castcount-1;
				lsSleep(15000); -- Long pause to wait for fishing queue to stop. Somehow it pushed the Fish button twice and now you will cast 2 times in a row. 
					WriteFishLog("[" .. CurrentTime .. "]\t[" .. CurrentLure .. "]\t" .. "You are already fishing!" .. "\n");



			elseif ChatType == "strange" then
				--Strange Fish
				GrandTotalStrange = GrandTotalStrange + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
					if LogStrangeUnusual == true then
					WriteFishLog("[" .. CurrentTime .. "]\t[" .. CurrentLure .. "]\t" .. "You almost caught a STRANGE fish, but your rod was to clumsy." .. "\n");
					end

			--	if AlmostCaughtAttempts > 0 then
			--		strangecounter = strangecounter +1;
			--	end
			
	
			elseif ChatType == "unusual" then
				-- Unusual Fish
				GrandTotalUnusual = GrandTotalUnusual + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
					if LogStrangeUnusual == true then
					WriteFishLog("[" .. CurrentTime .. "]\t[" .. CurrentLure .. "]\t" .. "You almost caught an UNUSUAL fish, but you were not quick enough." .. "\n");
					end

			--	if AlmostCaughtAttempts > 0 then
			--		strangecounter = strangecounter +1;
			--	end



			elseif ChatType == "odd" then
				-- Odd Fish
				GrandTotalOdd = GrandTotalOdd + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
					if LogOdd == true then
					WriteFishLog("[" .. CurrentTime .. "]\t[" .. CurrentLure .. "]\t" .. "You almost caught an ODD fish, but were too late recognizing the bite." .. "\n");
					end


			elseif ChatType == "oddlostlure" then
				-- Odd Fish and lost lure
				GrandTotalLostLures = GrandTotalLostLures + 1;
				GrandTotalFailed = GrandTotalFailed + 1;
					--Reset, skip to next lure
					castcount=0;
					WriteFishLog("[" .. CurrentTime .. "]\t[" .. CurrentLure .. "]\t" .. "You almost caught an ODD fish, but were too late recognizing the bite. You also lost your lure." .. "\n");





-- Need to add "strangelostlure" and "unusuallostlure"  here. But can't do it until I can get a screenshot of losing a lure on those two fish.
-- strange would be an image like this [clumsy. You also lost your lure]
-- unusual would be an image like [enough. You also lost your lure]
-- Those need to also be added to Fishing_Func.inc , in the Chat_Types {array}				
				


			elseif ChatType == "carry" then
				--chat lines are messed up now
				castcount=0;
				

			elseif ChatType == "caught" or ChatType == "caughtlostlure" then
				Fish = ChatReadFish();

				table.insert(gui_log_fish,Fish);


				if ChatType == "caughtlostlure" then
					GrandTotalLostLures = GrandTotalLostLures + 1;
					WriteFishLog("[" .. CurrentTime .. "]\t[" .. CurrentLure .. "]\t" .. "Though you lost your lure, you did catch a " .. Fish .. "\n");
					-- This Needs Check for new lure. This will cause a error if not.
					--Reset, skip to next lure
					castcount=0;

							
				else
					WriteFishLog("[" .. CurrentTime .. "]\t[" .. CurrentLure .. "]\t" .. "Caught a " .. Fish .. "\n");

				end
				
				--gui_refresh();
				
				if SkipCommon == true then
					FishType = string.sub(Fish,string.find(Fish,",") + 1);
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
	