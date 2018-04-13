dofile("common.inc");
	

--Check to see if player has new T8 clock displaying
function findNewClock(size)
  local result = nil;
    if not size then
      size = "Small";
    end
  srReadScreen();
  result = srFindImage("clockT8_" .. size .. ".png",5000);
  return result;
end


--Check to see if player has Legacy clock displaying, but wrong interface size
function findLegacyClock(size)
  local result = nil;
    if not size then
      size = "Small";
    end
  srReadScreen();
  result = srFindImage("clockLegacy_" .. size .. ".png",5000);
  return result;
end


function doit()

askForWindow("Parses the game clock and extracts the info.\nInfo updates in realtime while running!\nPress Shift over ATITD to continue.");

elapsedTime = 0;
startTime = 0;
lastTime = 0;
Time = 0;
minsElapsed = -1;
elapsedTimeSeconds = 0;
elapsedTimeTotal = 0;
elapsedTimeAvg = 0;
duckTime = 0;
duckTimeSeconds = 0;
duckTimeAvg = 0;
minsElapsedGUI = "Waiting change";
message = "";
message2 = "";

clockSize = {
"Tiny",
"Small",
"Medium",
"Large",
"Huge",
};


	findClockInfo();

	while 1 do
	checkBreak();
      local pos = getMousePos();
      lastTime = Time;

	findClockInfo();

  if lastTime ~= Time then
    minsElapsed = minsElapsed + 1;

	if minsElapsed == -1 then
	  minsElapsedGUI = "Waiting for 1st change";
	elseif minsElapsed == 0 then
	  minsElapsedGUI = "Starting Timer";
	else
	  minsElapsedGUI = minsElapsed;
	end

	if minsElapsed == 0 then
	  startTime = lsGetTimer();
	elseif minsElapsed >= 1 then
	  elapsedTime = lsGetTimer() - startTime
	  elapsedTimeSeconds = math.floor(elapsedTime/100)/10;
	  elapsedTimeTotal = elapsedTimeTotal + elapsedTime;
	  elapsedTimeAvg = elapsedTimeTotal / minsElapsed;
	  duckTime = elapsedTime * 3;
	  duckTimeSeconds = math.floor(duckTime/100)/10;
	  duckTimeAvg = (elapsedTimeTotal * 3) / minsElapsed;
	  elapsedTimeAvg = math.floor(elapsedTimeAvg/100)/10;
	  duckTimeAvg = math.floor(duckTimeAvg/100)/10;
	  startTime = lsGetTimer();
	end
  end

		while not Time do
		  checkBreak();
		  message = "";
		  message1 = "";
		  message1b = "";
		  message2 = "";
		  message2b = "";
		  findClockInfo();

			for i=1,#clockSize do  --Find T8 Clock
			  checkBreak();
			  findClock = findNewClock(clockSize[i]);
			    if findClock then
				message1 = "It appears you have the new (T8) clock showing! However, this macro requires the legacy clock.\n\nIn fact, all macros in Automato requires the legacy clock.\n\nUnder Options, Interface-Options, Actions: Use Legacy Interface";
				message1b = "\n\nYou are using \"" .. clockSize[i] .. "\" Interface";
				break;
			    end
			end


				  if not findClock then
			for i=1,#clockSize do
			  checkBreak();
			  findClock2 = findLegacyClock(clockSize[i]);
			    if findClock2 then
	 		      message2 = "Found Legacy Clock, but wrong interface size.\n\nAll macros in Automato requires the \"Small\" interface size.\n\nCheck Options, Interface-Options, Interface Size: Interface is \"Small\".";
			      message2b = "\n\nYou are using \"" .. clockSize[i] .. "\" Interface";
			      break;
			    end
			end
				  end

			    if  message1 == "" and message2 == "" then
			      message2 = "Can not find Clock!\n\nIf you have no clock displaying, type /clockinfo in game.\n\nMake sure your clock and all 4 clock borders are visible.\n\nTry moving your clock until macro resumes...";
			    end


		  sleepWithStatus(200, message1 .. message1b .. message2 .. message2b, nil, 0.7);
		end -- while not Time do

      statusScreen("Mouse Pos: " .. pos[0] .. ", " .. pos[1] .. "\n\nYear: " .. year .. "\nDate: " .. Date .. "\nTime: " .. Time .. "\nRegion: " .. regionName .. "\nCoords: " 
	  .. Coordinates .. "\nFaction: " .. faction .. "\n\nElapsed Egypt Mins: " .. minsElapsedGUI .. "\nLast Secs per Egypt Minute: " .. elapsedTimeSeconds .. "\nAvg Secs per Egypt Minute: " .. elapsedTimeAvg .. "\nEstimated Last Duck Time: " 
	  .. duckTimeSeconds .. "\nEstimated Duck Time Avg: " .. duckTimeAvg, nil, nil, 0.7);

		if faction == "Hyksos" or faction == " Hyksos" then
		  lsButtonImg(170, 110, 1, 0.20, 0xFFFFFFff, "factions/hyksos.png");
		elseif faction == "Kush" or faction == " Kush" then
		  lsButtonImg(170, 110, 1, 0.17, 0xFFFFFFff, "factions/kush.png");
		elseif faction == "Meshwesh" or faction == " Meshwesh" then
		  lsButtonImg(170, 110, 1, 0.20, 0xFFFFFFff, "factions/hyksos.png");
		end
	lsSleep(200);
	end
end


function findClockInfo()
Time = nil;
	srReadScreen();
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
    lsPrintln("Found Anchor");
    window = getWindowBorders(anchor[0], anchor[1]);
    lines = findAllText(nil, window, nil, NOPIN);
    for i=1,#lines do
      lsPrintln("LINE " .. i .. " : " .. table.concat(lines[i], ","));
	theDateTime = table.concat(lines[1], ",") -- Line 1 on the clock
	theDateTime = string.sub(theDateTime,string.find(theDateTime,",") + 1);

	year = string.sub(theDateTime, string.find(theDateTime,"Year (%d)"));
	year = string.match(year,"(%d)");

	stripYear = string.sub(theDateTime,string.find(theDateTime,",") + 2);
	Time = string.sub(stripYear,string.find(stripYear,",") + 2);
	stripYear = "," .. stripYear
	Date = string.sub(stripYear,string.find(stripYear,",") + 1, string.len(stripYear) - string.len(Time) - 2);

	regionInfo = table.concat(lines[2], ",") -- Line 2 on the clock
	regionInfo = string.sub(regionInfo,string.find(regionInfo,",")+1);
	Coordinates = string.sub(regionInfo,string.find(regionInfo,":") + 2);
	regionName = string.sub(regionInfo, 1,( string.len(regionInfo) - string.len(Coordinates) -2));
	faction = table.concat(lines[3]) -- Line 3 on the clock
	faction = string.sub(faction, 13);
    end
  end
end
