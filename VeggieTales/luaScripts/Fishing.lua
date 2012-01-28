loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();
loadfile("luaScripts/Fishing_Func.inc")();

--Variables Used By Program -- Dont Edit Unless you know.
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

--Custom Variables-- Edit To Change Fishing Casts, Skips, Updates.
TotalCasts=5; --Total Casts per lure, if a fish caught. If no fish then it skips.
SkipCommon = true; --Skips to next lure if fish caught is a common.
--AlmostCaughtAttempts = 0; --Adds additional attempts to the current lure if Unusual, Strange fish are seen
LureChangesToUpdateTimer = 3; --Total lures used before time is updated. Zero updates every new lure.


function SetupLureGroup()
	TLures = {};
	FirstLure="";
	LastLure = "";
	
	srReadScreen();
	FindPin = srFindImage("UnPin.png");
	if FindPin then
		
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
		error("didnt find pin");
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
		error("cant find lure");
	else
		slure = Lures[PlayersLures[CurrentLureIndex]];
		slure = string.sub(slure,string.find(slure,"_")+1,string.len(slure) - 4);
		--statusScreen("Using Lure " .. slure);
		return slure
	end
end

function UseLure()
	-- Uses lure according to CurrentLureIndex, which is used in PlayersLures which contains each lure the player has. 

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
	
	
	--Caught Something..  Find Fish Details
	Sfish = "";
				
	for i = 1, #CL_Fish do
	ChatFish = srFindImageInRange("Fishing/" .. CL_Fish[i],Coords[0] ,Coords[1],500,25);
	if ChatFish then
		Sfish = string.sub(CL_Fish[i],string.find(CL_Fish[i],"Fish_") + 5,string.len(CL_Fish[i]) - 4);
		break;
	end
					
	end
				
	if  string.len(Sfish) < 1 then
		error("unknown fish");
	end
				
	--Find Size
	for i = #CL_Number,1,-1 do
		ChatSize =  srFindImageInRange("fishing/" .. CL_Number[i],Coords[0],Coords[1],500,25);
		if ChatSize then
			SNum = string.sub(CL_Number[i],string.find(CL_Number[i],"_") + 1, string.len(CL_Number[i]) - 4);
			break;
		end
	end
	return(SNum .. "," .. Sfish);
	
end



function findchat(line)
	--Reads a chat line and returns a basic string for better processing
	
	--Possible fishing messages
	--	No Fish Bit.
	--		(No Fish Bit. You also lost your lure.)
	--	Caught A (SIZE) Deben (FISH)
	--	You almost caught a strange fish
	--	You almost caught an unusual fish
	--	You almost caught an odd fish
	--	Although you lost your lure  (Caught a fish)
	--	Using a (LURE) (TYPE) lure.
	--	You are carrying more than you can manage.
	--	You are carrying too much bulk.
	
	
	--Find the last line of chat
	lsSleep(100);
	srReadScreen();
	imgs = findAllImages("Fishing/chatlog_reddots.png");
	Coords = imgs[#imgs];
	
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
	--srSetMousePos(winsize[0]/2,winsize[1]/2);
	
	--Open Menu
	srKeyEvent(string.char(27));
	lsSleep(500);
	
	--Find Special
	srReadScreen();
	menu = srFindImage("Fishing/Menu_Special.png");
	
	if menu then
		srClickMouseNoMove(menu[0]+3,menu[1]+3);
		
		lsSleep(500);
		srReadScreen();
		
		menu = srFindImage("Fishing/Menu_WhatTime.png");
		if menu then
			srClickMouseNoMove(menu[0]+3,menu[1]+3);
			lsSleep(500);
		end
	end
	
	
	srReadScreen();
	imgs = findAllImages("Fishing/chatlog_reddots.png");
	Coords = imgs[#imgs];
	
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
	--Stats
	--CurrentLureIndex  out of  PlayersLures
	winsize = lsGetWindowSize();
	
	
	lsPrintWrapped(10, 0, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Lure Index: " .. CurrentLureIndex .. " out of " .. #PlayersLures .. "       " .. PlayersLures[CurrentLureIndex]);
	lsPrintWrapped(10, 25, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Time: " .. CurrentTime);
	
	lsPrintWrapped(10, 50, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Currently Caught Fish");

	if #gui_log_fish > 3 then
		table.remove(gui_log_fish,1);
	end
		for i = 1, #gui_log_fish,1 do
			lsPrintWrapped(10, 50 + (20*i), 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, gui_log_fish[i]);
		end

	
	lsPrintWrapped(10, winsize[1]-25, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "Session Total Caught: " .. "");
end

function doit()
	askForWindow("");
	--Gui_Main();
	
	PlayersLures = SetupLureGroup();
	CurrentTime = GetTime();
	lsSleep(1500);
	castcount = 0;
	--strangecounter = 0;
	
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
				CurrentLureIndex = 1;
			end
			
			--Update the time if ready, always update before new lure to keep chat proper
			if TotalLuresUsed == LureChangesToUpdateTimer then
				--Update Time
				CurrentTime = GetTime();
				TotalLuresUsed = 0;
			end
			
			--Since no casts been made at all, use a lure
			UseLure();
			lsSleep(2000);
			TotalLuresUsed = TotalLuresUsed + 1;
			
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
			castcount = castcount +1;
			
			--Read Chat
			ChatType = findchat();
			if ChatType == "nofishlostlure" then
				--Lost Lure, No fishbit
				castcount=0;
				WriteFishLog("[" .. CurrentLure .. "Lost Lure" .. "\n");
			elseif ChatType == "nofish" then
				--No fishbit
				castcount=0;
			elseif ChatType == "alreadyfishing" then
				castcount = castcount-1;
			elseif ChatType == "strange" then
				--Strange
				WriteFishLog("[" .. CurrentTime .. "][" .. CurrentLure .. "]" .. "Strange" .. "\n");
				
			--	if AlmostCaughtAttempts > 0 then
			--		strangecounter = strangecounter +1;
			--	end
				
			elseif ChatType == "unusual" then
				WriteFishLog("[" .. CurrentTime .. "][" .. CurrentLure .. "]" .. "Unusual" .. "\n");
				
			--	if AlmostCaughtAttempts > 0 then
			--		strangecounter = strangecounter +1;
			--	end
				
			elseif ChatType == "carry" then
				--chat lines are messed up now
				castcount=0;
				
			elseif ChatType == "caught" or ChatType == "caughtlostlure" then
				Fish = ChatReadFish();
				table.insert(gui_log_fish,Fish);
			--	table.insert(log_fish,Fish);
				CurrentLure = string.sub(PlayersLures[CurrentLureIndex],string.find(PlayersLures[CurrentLureIndex],"_")+1,string.len(PlayersLures[CurrentLureIndex])-4);
				if ChatType == "caughtlostlure" then
					WriteFishLog("[" .. CurrentTime .. "][" .. CurrentLure .. "]" .. Fish .. "Lost Lure" .. "\n");
					-- This Needs Check for new lure. This will cause a error if not.
				else
					WriteFishLog("[" .. CurrentTime .. "][" .. CurrentLure .. "]" .. Fish .. "\n");
				end
				
				gui_refresh();
				
				if SkipCommon == true then
					FishType = string.sub(Fish,string.find(Fish,",") + 1);
					if FishType == "Abdju" or FishType == "Chromis" or FishType == "Catfish" or FishType == "Carp" or FishType == "Perch" or FishType == "Phagrus" or FishType == "Tilapia" then
						--Skip it
						castcount=0;
					end
				end
				

			
			end
			
			gui_refresh();
		end
	end
end
	