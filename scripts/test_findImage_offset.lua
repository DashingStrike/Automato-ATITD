dofile("common.inc");

askText = "Enter a .png name and optional offset values. Mouse will point to location. Useful to finding where a macro is clicking.\n\nTo test ocr findText locations, use test_ocr_text.lua\n\nPress Shift (while hovering ATITD) to continue.";

xOffset = 0;
yOffset = 0;
scale = 0.7;

function doit()
  askForWindow(askText);
  mainMenu();
end


function mainMenu()
 while 1 do
  local y = 10;
  checkBreak();
  srReadScreen();
  lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Enter valid .png name:");
  y = y + 20;
  is_done, image = lsEditBox("image", 10, y, z, 200, 25, scale, scale, 0x000000ff);

  y = y + 50;
  lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "X offset:    +/-");
  lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);  -- Shrink the text boxes and text down
  is_done, xOffset = lsEditBox("xoffset", 130 , y+25, z, 50, 30, scale, scale, 0x000000ff, xOffset);
        xOffset = tonumber(xOffset);
        if not xOffset then
            is_done = false;
            lsPrint(200, y+30, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
            xOffset = 0;
        end
  lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);  -- Shrink the text boxes and text down
  y = y + 40;
  lsPrint(5, y-10, z, scale, scale, 0xFFFFFFff, "Y offset:    +/-");
  lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);  -- Shrink the text boxes and text down
  is_done, yOffset = lsEditBox("yoffset", 130, y+25, z, 50, 30, scale, scale, 0x000000ff, yOffset);
        yOffset = tonumber(yOffset);
        if not yOffset then
            is_done = false;
            lsPrint(200, y+30, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
            yOffset = 0;
        end
  lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);  -- Shrink the text boxes and text down
  y = y + 30;
    if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Next") then
	lsDoFrame();
      findPNG();
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
      error "Clicked End Script button";
    end
  lsDoFrame();
  lsSleep(100);
 end
end

function findPNG()
  while 1 do
    checkBreak();
    srReadScreen();

  if image ~= "" then
    findBlah = srFindImage(image);
  end

  if not findBlah then
    result = image .. " NOT Found";
      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Go Back") then
	  lsDoFrame();
        mainMenu();
      end
  else
    result = image .. " FOUND\n\nClick Point button to put mouse on image";
      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Point") then
        pointToLocation();
      end
  end

  statusScreen(result, nil, 0.7, 0.7);
  lsSleep(100);
  end
end


function pointToLocation()
  local y = 20;
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
		srSetMousePos(findBlah[0]+xOffset,findBlah[1]+yOffset);
		sleepWithStatus(6000, "Pointing to image: " .. image .. "\n\nX Offset: " 
		.. xOffset .. "\nY Offset: " .. yOffset .. "\n\nMouse Location (no offset):\n" .. math.floor(findBlah[0]) .. ", " .. math.floor(findBlah[1]) .. "\n\nMouse Location (after offsets):\n" .. math.floor(findBlah[0]+xOffset) .. ", " .. 
		math.floor(findBlah[1]+yOffset), nil, 0.7, 0.7);
      end
    end
end


local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;

function sleepWithStatus(delay_time, message, color, scale)
  if not color then
    color = 0xffffffff;
  end
  if not delay_time then
    error("Incorrect number of arguments for sleepWithStatus()");
  end
  if not scale then
    scale = 0.8;
  end
  local start_time = lsGetTimer();
  while delay_time > (lsGetTimer() - start_time) do
    local frame = math.floor(waitFrame/5) % #waitChars + 1;
    time_left = delay_time - (lsGetTimer() - start_time);
    local waitMessage = "Waiting ";
    if delay_time >= 1000 then
      waitMessage = waitMessage .. time_left .. " ms ";
    end
    lsPrintWrapped(10, 50, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
		   waitMessage .. waitChars[frame]);
    statusScreen(message, color, nil, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;

    if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Go Back") then
      mainMenu();
    end
  end
end
