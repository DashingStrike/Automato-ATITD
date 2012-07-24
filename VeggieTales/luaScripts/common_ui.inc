-- common_ui.inc
--
-- Commmon utility functions for interacting with the user
--
-- DO NOT INCLUDE THIS FILE! Include common.inc instead
--

focusMessage = singleLine([[
  Switch focus back to client window if necessary, then press shift
]]);

-------------------------------------------------------------------------------
-- checkBreak()
--
-- Stop the macro if the user is pressing both shift and control.
-------------------------------------------------------------------------------

function checkBreak(cleanupCallback)
  if lsShiftHeld() and lsControlHeld() then
    if(cleanupCallback) then
      lsPrintln("calling cleanup call back");
      pcall(cleanupCallback);
      lsPrintln("cleanup call back returned");
    else
      lsPrintln("cleanupCallback == " .. type(cleanupCallback));
    end
    srKeyUp(-1);
    error(quit_message);
  end
  if allow_pause and lsAltHeld() and lsShiftHeld() then
    -- Pause
    while lsAltHeld() or lsShiftHeld() do
      statusScreen("Please release Alt+Shift", 0x808080ff, false);
    end
    local done = false;
    while not done do
      local unpaused = lsButtonText(lsScreenX - 110, lsScreenY - 60,
				    z, 100, 0xFFFFFFff, "Unpause");
      statusScreen("Hold Alt+Shift to resume", 0xFFFFFFff, false);
      done = (unpaused or (lsAltHeld() and lsShiftHeld()));
    end
    while lsAltHeld() or lsShiftHeld() do
      statusScreen("Please release Alt+Shift", 0x808080ff, false);
    end
  end
end

-------------------------------------------------------------------------------
-- askForWindow(message)
--
-- Tell the user to put the target window in focus and wait. Necessary
-- at the beginning of nearly every macro.
--
-- message (optional) -- Additional instructions to print for the user
--
-- Returns the position of the mouse when shift is pressed.
-------------------------------------------------------------------------------

function askForWindow(message)
  if not message then
    message = "";
  end
  local basicText = singleLine([[
      Mouse over the ATITD window and press Shift.  For best results,
      either put the ATITD window in focus first (click the ATITD
      window), or set Options | Interface Options | Priority to High
      Priority Mode.
  ]]);

  -- Wait for release if it's already held
  while lsShiftHeld() do
    checkBreak();
  end

  -- Display message until shift is held
  while not lsShiftHeld() do
    lsPrintWrapped(0, 0, 1, lsScreenX, 0.7, 0.7, 0xFFFFFFff, basicText);
    lsPrintWrapped(0, 85, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff, message);
    lsDoFrame();
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100,
                    0xFFFFFFff, "Exit") then
      error(quit_message);
    end
    lsSleep(tick_delay);
    checkBreak();
  end
  lsSetCaptureWindow();
  local mouseX, mouseY = srMousePos();

  -- Wait for shift to be released
  while lsShiftHeld() do
    checkBreak();
  end
  return makePoint(mouseX, mouseY);
end

function askForFocus()
  if pauseForFocus then
    -- Wait for release if it's already held
    while lsShiftHeld() do
      checkBreak();
    end

    -- Display message until shift is held
    while not lsShiftHeld() do
      lsPrintWrapped(0, 0, 1, lsScreenX, 0.7, 0.7, 0xFFFFFFff, focusMessage);
      lsDoFrame();
      if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100,
                      0xFFFFFFff, "Exit") then
        error(quit_message);
      end
      lsSleep(tick_delay);
      checkBreak();
    end

    -- Wait for shift to be released
    while lsShiftHeld() do
      checkBreak();
    end
  end
end

-------------------------------------------------------------------------------
-- statusScreen(message, color, allow_break)
--
-- Print status message and a cancel button.
--
-- message (optional) -- status to show user
-- color (optional) -- color of message (defaults to white)
-- allow_break (optional) -- allow the user to break/pause (defaults to true)
-------------------------------------------------------------------------------
function statusScreenPause(message, color, allow_break)
  statusScreen(message, color, allow_break);
end

function statusScreen(message, color, allow_break)
  if not message then
    message = "";
  end
  if not color then
    color = 0xFFFFFFff;
  end
  if allow_break == nil then
    allow_break = true;
  end
  lsPrintWrapped(10, 80, 0, lsScreenX - 20, 0.8, 0.8, color, message);
  lsPrintWrapped(10, lsScreenY-100, 0, lsScreenX - 20, 0.8, 0.8, 0xffd0d0ff,
		 error_status);
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

-------------------------------------------------------------------------------
-- sleepWithStatus(delay_time, message, can_pause)
--
-- Waits at least delay_time before returning. Show the message and
-- allow the user to cancel the macro while waiting.
--
-- delay_time -- minimum amount of time to wait
-- message (optional) -- status to show user
-- color (optional) -- color of status message
-------------------------------------------------------------------------------

function sleepWithStatusPause(delay_time, message, color)
  sleepWithStatus(delay_time, message, color);
end

local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;

function sleepWithStatus(delay_time, message, color)
  if not color then
    color = 0xffffffff;
  end
  if not delay_time then
    error("Incorrect number of arguments for sleepWithStatus()");
  end
  local start_time = lsGetTimer();
  while delay_time > (lsGetTimer() - start_time) do
    local frame = math.floor(waitFrame/5) % #waitChars + 1;
    time_left = delay_time - (lsGetTimer() - start_time);
    local waitMessage = "Waiting ";
    if delay_time >= 1000 then
      waitMessage = waitMessage .. time_left .. " ms ";
    end
    lsPrintWrapped(10, 50, 0, lsScreenX - 20, 1, 1, 0xd0d0d0ff,
		   waitMessage .. waitChars[frame]);
    statusScreen(message, color);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;
  end
end

-------------------------------------------------------------------------------
-- sleepWithBreak(delay_time)
--
-- Waits at least delay_time before returning.
-- Allow the user to cancel the macro while waiting.
--
-- delay_time -- minimum amount of time to wait
-------------------------------------------------------------------------------

function sleepWithBreak(delay_time, message, color)
  if not delay_time then
    error("Incorrect number of arguments for sleepWithBreak()");
  end
  local start_time = lsGetTimer();
  while delay_time > (lsGetTimer() - start_time) do
	checkBreak();
    lsSleep(tick_delay);
  end
end

-------------------------------------------------------------------------------
-- promptNumber(prompt_string, default_value, scale)
--
-- Ask the user for a number and return the result.
--
-- prompt_string -- string telling the user what kind of number to enter
-- default_value (optional) -- initial value to put in field (default 0)
-- scale (optional) -- Scaling factor for display
-------------------------------------------------------------------------------

function promptNumber(prompt_string, default_value, scale)
  if not prompt_string then
    error("Incorrect number of arguments for promptNumber()");
  end
  if not default_value then
    default_value = 0;
  end
  if not scale then
    scale = 1.0;
  end
  local z = 0;
  local is_done = nil;
  local value = nil;
  -- Edit box and text display
  while not is_done do
    checkBreak();
    
    lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, prompt_string);
    
    -- lsEditBox needs a key to uniquely name this edit box
    --   let's just use the prompt!
    -- lsEditBox returns two different things (a state and a value)
    is_done, value = lsEditBox(prompt_string,
			       10, 40, z, 100, 30, scale, scale,
			       0x000000ff, default_value);
    
    if lsButtonText(120, 40, z, 100, 0xFFFFFFff, "OK") then
      is_done = 1;
    end
    
    if is_done and not value then
      error(quit_message);
    end
    
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,
		    0xFFFFFFff, "End script") then
      error(quit_message);
    end
    
    if not tonumber(value) then
      is_done = nil;
      lsPrint(10, 80, z, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
    end
    
    lsDoFrame();
    lsSleep(tick_delay);
  end
  
  return tonumber(value);
end

-------------------------------------------------------------------------------
-- promptOkay(prompt_string)
--
-- Give the user an ok/cancel dialog box.
--
-- prompt_string -- string giving the user a message
-------------------------------------------------------------------------------

function promptOkay(prompt_string, color)
  if not prompt_string then
    error("Incorrect number of arguments for promptOkay()");
  end
  if not color then
	color = 0xFFFFFFff;
  end
  local z = 0;
  local is_done = nil;
  local ret = nil;
  local scale = 0.7;
  -- Edit box and text display
  while not is_done do
    checkBreak();
    
    lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,
	    "Hold Ctrl+Shift to end this script.");
    lsPrint(10, 35, 0, 0.7, 0.7, 0xB0B0B0ff,
	    "Hold Alt+Shift to choose Okay.");
    lsPrintWrapped(10, 60, 0, lsScreenX - 20, 1, 1, color, prompt_string);
    
    if lsButtonText(120, 200, z, 100, 0xFFFFFFff, "OK") or
      (lsAltHeld() and lsShiftHeld()) then
      is_done = 1;
      ret = 1;
    end
    
    if lsButtonText(120, 230, z, 100, 0xFFFFFFff, "Cancel") then
      is_done = 1;
      ret = nil;
    end
    
    lsDoFrame();
    lsSleep(tick_delay);
  end
	
  while lsAltHeld() or lsShiftHeld() do
    statusScreen("Please release Alt+Shift", 0x808080ff);
  end
	
  return ret;
end
