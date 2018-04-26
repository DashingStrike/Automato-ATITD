-- Duck Timer v1.0 by Cegaiel
-- This macro watches the /clockloc (Egypt Clock) for accurate timing of elapsed duck Minutes (game minutes). 
-- Regardless of how much server lag is currently occuring, it will be accurate.
-- This timer would be idea to incorporate into other macros. Good example would be the 10m in game timer to eat grilled veggies.
-- Grilled veggies is 10m game timer, not 10m real time. If server lag is low or higher than normal, the 10m timer can vary substantially. 
-- Watching the egypt game clock provides the most accurate timing possible (I think?)

dofile("common.inc");

askText = "Duck Timer macro is based on 'watching' the in-game Egypt clock.\n\n3 Egypt minutes = 1 Game minute (Duck minutes).\n\nNote: test_ocr_clock.lua also gathers statistics on game time.\n\nPress Shift while hovering ATITD window.";

minsElapsed = 0;
duckMins = 0;
timerStarted = false;

function doit()
	askForWindow(askText);

  timerMins = promptNumber("How many Duck Minutes are we timing?", 10, 0.7, 0.7);
  expireTimer = timerMins * 3;
  findClockInfo()

  while 1 do
	checkBreak();
	lastTime = Time;
	findClockInfo();

		while not Time do
		  checkBreak();
		  findClockInfo();
		  sleepWithStatus(100, "Can not find Clock!\n\nMove your clock slightly.\n\nMacro will resume once found ...\n\nIf you do not see a clock, type /clockloc in chat bar.", 0xffc0c0ff, 0.7, 0.7);
		end


	if lastTime ~= Time then
    	  minsElapsed = minsElapsed + 1;
		if minsElapsed == 1 and not timerStarted then
		  timerStarted = true;
		  minsElapsed = 0; -- reset to 0 (We probably started macro where next egypt minute is about to occur, reset to 0 for more accuracy)
		  startTime = lsGetTimer();
		  startingEgyptTime = Time;
		else
	  	  expireTimer = expireTimer - 1;
	  	  duckMins = minsElapsed / 3;
		end
	end

	if minsElapsed == (timerMins * 3) then
	  break;
	end


		if timerStarted then
  statusScreen("Starting Egypt Time: " .. startingEgyptTime .. "\nCurrent Egypt Time: " .. Time .. "\n\nEgypt Mins Elapsed: " .. minsElapsed .. "\nEgypt Mins Remaining: " .. expireTimer .. "\nDuck Mins Elapsed: " .. round(duckMins, 2) .. " of " .. timerMins .. "\n\nReal Time Elapsed: " .. getElapsedTime(startTime), nil, 0.7, 0.7);
		lsSleep(100);
		else
  sleepWithStatus(100,"Current Egypt Time: " .. Time .. "\n\nWaiting on next Egypt Minute change to begin timer (for better accuracy) ...", nil, 0.7, 0.7);
		end



  end
	  --Loop was broken with break;, we're done!
	  lsPlaySound("Complete.wav");
	  lsMessageBox("Elapsed Time:", getElapsedTime(startTime), 1);
end


function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
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
	faction = string.sub(faction,string.find(faction,":") + 2);

	benefit = findText("Who benefit from");
	  if benefit then
	    bonus = table.concat(lines[4], ",") -- Line 4 on the clock
	    bonus = string.sub(bonus,string.find(bonus,":") + 2);
	  else
	    bonus = "";
	  end

    end
  end
end

