-- single_click_stat_mon.lua v1.1 -- Revised by Tallow
--
-- Repeatedly click a single location whenever stats are black.
--
--March 28, 2018: Added ability to enter # of clicks, Elapsed Timer ~Cegaiel


dofile("common.inc");

askText = singleLine([[
  Stat Clicker v1.1 (Revised by Tallow) --
  This macro will watch your skills window and only click when you are not tired.
  Move mouse to a spot you want clicked and press shift to repeat clicks when not tired.
]]);

smallWarning = singleLine([[
  Your font size appears to be smaller than the default, many macros
  here will not work correctly.
]]);

largeWarning = singleLine([[
  Your font size appears to be larger than the default, many macros
  here will not work correctly.
]]);



function doit()

  local mousePos = askForWindow(askText);
  askQty();

  local startTime = lsGetTimer();
  local clickCount = 0;
  local lastClickTime = lsGetTimer();

  while 1 do
      if clickQty > 0 and (clickQty == clickCount) then
	  lsPlaySound("Complete.wav");
        lsMessageBox(clickCount .. " clicks executed in ", elapsedTime, 1);
        break;
      end

    elapsedTime = getElapsedTime(startTime)
    srReadScreen();
    local warning = "";
    local stats = srFindImage("AllStats-Black.png");
    if not stats then
      stats = srFindImage("AllStats-Black2.png");
      if stats then
	warning = largeWarning;
      end
    end
    if not stats then
      stats = srFindImage("AllStats-Black3.png");
      if stats then
	warning = smallWarning;
      end
    end

    local message = "Time Elapsed: " .. getElapsedTime(startTime) .. "\n\n"
    local color = 0xffffffff;
    if not stats then
      message = message .. "Waiting (stats not black or not visible).\n\n";
      if lsGetTimer() - lastClickTime > 60000 then
	color = 0xff3333ff;
      end
    else
      lastClickTime = lsGetTimer();
      safeClick(mousePos[0], mousePos[1]);
      clickCount = clickCount + 1;
      message = message .. "Clicking. ";
    end

    if clickQty > 0 then
    message = message .. clickCount .. "/" .. clickQty .. " clicks so far.\n\n" .. warning;
    else
    message = message .. clickCount .. " clicks so far.\n\n" .. warning;
    end
    sleepWithStatus(250, message, color);
    closePopUp();
  end
end



function askQty()
  local is_done = false;
  local count = 1;
  while not is_done do
	checkBreak();
      local y = 10;
      lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "How many clicks?");
	y = y + 22;
      is_done, clickQty = lsEditBox("clickQty", 5, y, 0, 50, 30, 1.0, 1.0, 0x000000ff, 0);
      clickQty = tonumber(clickQty);
      if not clickQty then
        is_done = false;
        lsPrint(5, y+32, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        clickQty = 0;
      end
	y = y + 50;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Enter 0 to repeat clicks until manually stopped");
	y = y + 22;
    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quitMessage);
    end
  lsDoFrame();
  lsSleep(50);
  end
  return count;
end

function closePopUp()
  srReadScreen()
  local ok = srFindImage("OK.png")
  if ok then
    srClickMouseNoMove(ok[0]+5,ok[1],1);
  end
end