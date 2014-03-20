assert(loadfile("luaScripts/common.inc"))();


function doit()

askForWindow("Parses the game clock and extracts the info.\nInfo updates in realtime while running!\nPress Shift over ATITD to continue.");

	while 1 do
	Time = nil;
	checkBreak();
	srReadScreen();
	findClockInfo();
		while not Time do
		  checkBreak();
		  findClockInfo();
		  sleepWithStatus(750, "Can not find Clock!\n\nMake sure your clock and all 4 clock borders are visible.\n\nStart moving your clock around until macro resumes...");
		end
      statusScreen(regionCoords .. "\nCoords: " .. Coordinates .. "\nTime: " .. Time .. "\nDate: " .. Date);
      lsSleep(150);
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
    lsPrintln("Found Anchor");
    window = getWindowBorders(anchor[0], anchor[1]);
    lines = findAllText(nil, window, NOPIN);
    for i=1,#lines do
      lsPrintln("LINE " .. i .. " : " .. table.concat(lines[i], ","));
	theDateTime = table.concat(lines[1], ",") -- Line 1 on the clock
	theDateTime = string.sub(theDateTime,string.find(theDateTime,",") + 1);
	regionCoords = table.concat(lines[2], ",") -- Line 2 on the clock
	regionCoords = string.sub(regionCoords,string.find(regionCoords,",") + 1);
	Coordinates = string.sub(regionCoords,string.find(regionCoords,":") + 2);
	stripYear = string.sub(theDateTime,string.find(theDateTime,",") + 2);
	Time = string.sub(stripYear,string.find(stripYear,",") + 2);
	stripYear = "," .. stripYear
	Date = string.sub(stripYear,string.find(stripYear,",") + 1, string.len(stripYear) - string.len(Time) - 2);
    end
  end
end