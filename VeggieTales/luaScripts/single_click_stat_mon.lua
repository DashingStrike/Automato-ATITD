-- single_click_stat_mon.lua v1.1 -- Revised by Tallow
--
-- Repeatedly click a single location whenever stats are black.
--

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
  Stat Clicker v1.1 (Revised by Tallow) --
  Move mouse to a spot you want clicked and press shift.
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

  local clickCount = 0;
  local lastClickTime = lsGetTimer();
  while 1 do
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

    local message = ""
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
    message = message .. clickCount .. " clicks so far. " .. warning;

    sleepWithStatus(250, message, color);
  end
end
