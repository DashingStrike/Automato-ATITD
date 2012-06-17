assert(loadfile("luaScripts/common.inc"))();

function doit()
  askForWindow("Test to find text in regions (windows) such as Clock Window, Friends window and building windows. Press Shift over ATITD window.");
  while true do
    findStuff();
  end
end

function pointToLocation()
  while 1 do
    if lsMouseIsDown(1) then
	lsSleep(50);
	-- Don't move mouse until we let go of mouse button
    else
	lsSleep(100); -- wait a moment in case we moved mouse while clicking
	srSetMousePos(findBlah[0],findBlah[1]);
	break;
	end
  end
end

function findStuff()
  local scale = 0.7;
  local y = 20;
  local foo;
  local text = "";
  local result = "";
  local pos = getMousePos();

  checkBreak();
  srReadScreen();


  lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Search Text (case sensitive):");
  y = y + 30;
  foo, text = lsEditBox("text", 10, y, z, 200, 30, scale, scale,
                                   0x000000ff);
  y = y + 50;

  local startPos = findCoords();
  if startPos then
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "ATITD Clock Coordinates: " .. startPos[0] .. ", " .. startPos[1]);
  else
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "ATITD Clock Coordinates: Not Found");
  end

  y = y + 30;
  lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Current Mouse Position: " .. pos[0] .. ", " .. pos[1]);


  if text ~= "" then
    findBlah = findText(text);
  else
    findBlah = nil;
  end

  if findBlah and text ~= "" then
    foundX = findBlah[0];
    foundY = findBlah[1];
    result = " FOUND!";

    if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "Point") then
      pointToLocation();
    end

  elseif text ~= "" then
    result = " Not Found"
  end

  y = y + 30;

  if text ~= "" then

    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Searching for \"" .. text .. "\"");
    y = y + 30;
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Results: " .. result);

  end


  if findBlah then
    y = y + 30;
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Window Location: " .. foundX .. ", " .. foundY);
    y = y + 30;
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Click Point to move mouse to location.");
  end


    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end

  lsDoFrame();
  lsSleep(10);
end