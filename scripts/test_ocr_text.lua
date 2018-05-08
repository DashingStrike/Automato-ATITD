dofile("common.inc");

xOffset = 0;
yOffset = 0;
pointingSpeed = 2000; --ms

function doit()
  askForWindow("Test to find text in regions (windows) such building windows.\n\nPress Shift (while hovering ATITD) to continue.");

  while true do
    findStuff();
  end
end

function pointToLocation()
	window = 1;
 while 1 do
    if lsMouseIsDown(1) then
	lsSleep(50);
	-- Don't move mouse until we let go of mouse button
    else
	lsSleep(100); -- wait a moment in case we moved mouse while clicking
	if not tonumber(xOffset) then
	  xOffset = 0;
	end
	if not tonumber(yOffset) then
	  yOffset = 0;
	end


	for i=#findBlah, 1, -1 do
		srSetMousePos(findBlah[i][0]+xOffset,findBlah[i][1]+yOffset);
		sleepWithStatus(pointingSpeed, "Pointing to Window " .. window .. "/" .. #findBlah .. "\n\nX Offset: " 
		.. xOffset .. "\nY Offset: " .. yOffset .. "\n\nMouse Location: " .. findBlah[i][0]+xOffset .. ", " .. 
		findBlah[i][1]+yOffset, nil, 0.7, 0.7);
		window = window + 1;
	end

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
  y = y + 20;
  foo, text = lsEditBox("text", 10, y, z, 200, 25, scale, scale, 0x000000ff);

  y = y + 50;
  lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "X offset:    +/-");
  lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);  -- Shrink the text boxes and text down
  is_done, xOffset = lsEditBox("xoffset", 130 , y+25, z, 50, 30, scale, scale, 0x000000ff, xOffset);
  lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);  -- Shrink the text boxes and text down
  y = y + 40;
  lsPrint(5, y-10, z, scale, scale, 0xFFFFFFff, "Y offset:    +/-");
  lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);  -- Shrink the text boxes and text down

  is_done, yOffset = lsEditBox("yoffset", 130, y+25, z, 50, 30, scale, scale, 0x000000ff, yOffset);
  lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);  -- Shrink the text boxes and text down
  y = y + 30;

  local startPos = findCoords();
  if startPos then
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "ATITD Clock Coordinates: " .. startPos[0] .. ", " .. startPos[1]);
  else
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "ATITD Clock Coordinates: Not Found");
  end
  y = y + 20;
  lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Current Mouse Position: " .. pos[0] .. ", " .. pos[1]);


  if text ~= "" then
    findBlah = findAllText(text);
    findCount = #findBlah;
  else
    findCount = 0;
  end


  if findCount == 0 then
    result = " Not Found";
  else
    result = " FOUND (" .. findCount .. ") Windows";
    lsPrint(10, y+80, z, scale, scale, 0xFFFFFFff, "Click Point to move mouse to location(s).");

    if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Point") then
      pointToLocation();
    end
  end

  y = y + 30;

  if text ~= "" then
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Searching for \"" .. text .. "\"");
    y = y + 20;
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Results: " .. result);
  end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
      error "Clicked End Script button";
    end

  lsDoFrame();
  lsSleep(10);
end