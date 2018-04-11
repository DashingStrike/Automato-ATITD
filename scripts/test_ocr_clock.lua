dofile("common.inc");


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
		  findClockInfo();
		  sleepWithStatus(1000, "Can not find Clock!\n\nMake sure your clock and all 4 clock borders are visible.\n\nStart moving your clock around until macro resumes...");
		end
      statusScreenSmall("Mouse Pos: " .. pos[0] .. ", " .. pos[1] .. "\n\nYear: " .. year .. "\nDate: " .. Date .. "\nTime: " .. Time .. "\nRegion: " .. regionName .. "\nCoords: " 
	  .. Coordinates .. "\nFaction: " .. faction .. "\n\nElapsed Egypt Mins: " .. minsElapsedGUI .. "\nLast Secs per Egypt Minute: " .. elapsedTimeSeconds .. "\nAvg Secs per Egypt Minute: " .. elapsedTimeAvg .. "\nEstimated Last Duck Time: " 
	  .. duckTimeSeconds .. "\nEstimated Duck Time Avg: " .. duckTimeAvg);
      lsSleep(10);


		if faction == "Hyksos"  then
		  lsButtonImg(170, 110, 1, 0.20, 0xFFFFFFff, "factions/hyksos.png");
		elseif faction == "Kush" then
		  lsButtonImg(170, 110, 1, 0.17, 0xFFFFFFff, "factions/kush.png");
		elseif faction == "Meshwesh" then
		  lsButtonImg(170, 110, 1, 0.20, 0xFFFFFFff, "factions/hyksos.png");
		end
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
	faction = table.concat(lines[3], ",") -- Line 3 on the clock
	faction = string.sub(faction, 14);
    end
  end
end


function statusScreenSmall(message, color, allow_break)
  if not message then
    message = "";
  end
  if not color then
    color = 0xFFFFFFff;
  end
  if allow_break == nil then
    allow_break = true;
  end
  lsSetCamera(0,0,lsScreenX*1.1,lsScreenY*1.1);
  lsPrintWrapped(10, 80, 0, lsScreenX - 20, 0.8, 0.8, color, message);
  lsPrintWrapped(10, lsScreenY-100, 0, lsScreenX - 20, 0.8, 0.8, 0xffd0d0ff,
		 error_status);
  lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,
		  0xFFFFFFff, "End script") then
    error(quit_message);
  end
  if allow_break then
    lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,
	    "Hold Ctrl+Shift to end this script.");
    if allow_pause then
      lsPrint(10, 24, 0, 0.7, 0.7, 0xB0B0B0ff,
	      "Hold Alt+Shift to pause this script.");
    end
    checkBreak();
  end
  lsSleep(tick_delay);
  lsDoFrame();
end
