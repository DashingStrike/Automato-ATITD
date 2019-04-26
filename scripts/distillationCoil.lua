--
-- 
--
dofile("common.inc");

per_click_delay = 20;
min_quality = 3500;
autoUnload = true;

up = nil;
right_click = nil;

-- optional message
function askForWindowAndPixel(message)
	-- Wait for release if it's already held
	while lsShiftHeld() do end;
	-- Display message until shift is held
	while not lsShiftHeld() do
		lsPrintWrapped(0, 0, 1, lsScreenX, 0.7, 0.7, 0xFFFFFFff,
			"Mouse over the relevant pixel and press Shift.");
		if message then
			lsPrintWrapped(0, 40, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
				message);
		end
		lsSetCaptureWindow();
		mouse_x, mouse_y = srMousePos();
		lsPrintWrapped(0, 40, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
			mouse_x .. ", " .. mouse_y);
		lsDoFrame();
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Exit") then
			error "Canceled";
		end
	end
	lsSetCaptureWindow();
	-- Wait for shift to be released
	while lsShiftHeld() do end;
	xyWindowSize = srGetWindowSize();
end

function clickAll(image_name, up)
	if nil then
		lsPrintln("Would click '".. image_name .. "'");
		return; -- not clicking buttons for debugging
	end
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		statusScreen("Could not find " .. image_name, nil, 0.7, 0.7);
	else
		statusScreen("Clicking " .. #buttons .. "button(s)...", nil, 0.7, 0.7);
		if up then
			for i=#buttons, 1, -1  do
				srClickMouseNoMove(buttons[i][0]+2, buttons[i][1]+2);
				lsSleep(per_click_delay);
			end
		else
			for i=1, #buttons  do
				srClickMouseNoMove(buttons[i][0]+2, buttons[i][1]+2);
				lsSleep(per_click_delay);
			end
		end
		statusScreen("Done clicking (" .. #buttons .. " clicks).", nil, 0.7, 0.7);
		lsSleep(150);
	end
end

recipe = "aaaawwwwannnwwawwannnwwawwannnwwawwannnwwawwannnwwawwannnwwwwannnwwawwannnwwawwannnwwawwannnwwawwaaaaaaaaaaaannnwwwnnnwwwwnnnwwwndndndndndndndndndndndndndndndndndndndndndndndndndndndndndndnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpnpndndndndndndndndndndndndndndndndn";



recipeLen = 204; -- 204 is without non glory hole keys w,d,q,p,i
keyDelay = 150;
function doit()
	local num_rounds;
	local keystrokes;
	num_rounds = 1; -- promptNumber("How many coils?", 1);
	askForWindowAndPixel("\n\nPin up the 'Start Making' menu.\n\nMake sure your chat is minimized!\nMinimized chat-channels are still visible (Options, Chat-related, CHECKED)\n\nMain Chat must be showing, as the macro reads the Quality in chat.\n\nClick in ATITD, HOVER your mouse OVER the glory hole, THEN press Shift key.\n\nEnsure your heater control is set to Pinpoint.");
	config();
	clickAll("WindowEmpty.png"); -- Refresh any empty windows
	lsSleep(100);
	srReadScreen();
	coil = srFindImage("DistillationCoil.png")
	if not coil then
	  error('No match on screen for DistillationCoil.png\nDo you have Start Making menu pinned?');
	end
	sleepWithStatus(5000, "Preparing to start macro!\n\nDon\'t touch mouse, EVER, while running!\n\nAre you sure chat is minimized?\n\nNow is your chance to Abort if not...", nil, 0.7, 0.7);

	for i = 1, num_rounds do
		abort = nil;
		quality = 0;
		keystrokes = 0;
		status = "";
		checkBreak();
		clickAll("WindowEmpty.png"); -- Refresh any empty windows
		clickAll("Ok.png"); -- Close any previous popups
		clickAll("DistillationCoil.png", true);
		lsSleep(60);
		srSetMousePos(mouse_x, mouse_y);
		lsSleep(60);
		srKeyEvent("q");
		lsSleep(75);

		for j = 1, string.len(recipe) do
			--recipe time
	            local currKey = string.sub(recipe, j, j);
	            srSetMousePos(mouse_x, mouse_y);
	            if currKey == "w" then
	                lsSleep(998);
	                srKeyEvent("q");
	                --status = status .. "q";
	            elseif currKey == "d" then
	                lsSleep(249);
	                srKeyEvent("q");
	                --status = status .. "q";
	            elseif currKey == "p" then
	                lsSleep(125);
	                srKeyEvent("q");
	                --status = status .. "q";
	            elseif currKey == "i" then
	                lsSleep(75);
	            else
	                srKeyEvent(currKey);
	                status = status .. currKey;
	                keystrokes = keystrokes + 1;
	                if currKey ~= "a" then
	                    srKeyEvent("q");
	                	--status = status .. "q";
	                end
	            end

	            chatRead();

	            if lsShiftHeld() or abort then
	              if autoUnload then
	                unLoad();
	              end
	            break;
	            end

	            statusScreen("[" .. keystrokes .. "/" .. recipeLen .. "] Keystrokes remaining\n\nPlease be patient; Don\'t touch mouse!\n\nSending keystrokes to the glory hole...\n\nNote: You can don\'t have to wait until macro is finished. If you see a good quality appear in main chat, then hold Shift Key to Unload and exit early!\n\n" .. status .. "\n\nQuality: " .. quality, nil, 0.7, 0.7);

		end


		while not autoUnload do
		  checkBreak();
		  sleepWithStatus(100,"Distillation Coil is done, however you need to manually [U]nload it.\n\nHold Shift key to Unload\n\nThis gives you an opportunity to keep checking quality or furthur fine tuning.", nil, 0.7, 0.7);
		  if lsShiftHeld() then
		    unLoad();
		    break;
		  end
		end


	--		lsSleep(400);
	--		srKeyEvent("u");
	--	clickAll("Blank.png");
	--	lsSleep(keyDelay);
	--	clickAll("Ok.png");
	end
end


function chatRead()
    srReadScreen();
    local chatText = getChatText();
   --Read last line of chat and strip the timer ie [01m]+space from it.
   lastLine = chatText[#chatText][2];
   lastLineParse = string.sub(lastLine,string.find(lastLine,"m]")+3,string.len(lastLine));
   if string.match(lastLineParse, "Quality") then
     quality = string.match(lastLineParse, "(%d+)");
     quality = tonumber(quality);
      if quality >= min_quality then
         abort = 1;
      end
   end
end


function config()
    local is_done = false;
    local count = 1;
    while not is_done do
        checkBreak();
        local y = 10;
        autoUnload = CheckBox(15, y, z, 0xffffffff, " Auto 'Unload' coil", autoUnload, 0.7, 0.7);

        y = y + 35;

        lsPrintWrapped(10, y, 0, lsScreenX - 20, 0.65, 0.65, 0xFFFFFFff,
            "If macro detects quality = or > " .. min_quality .. " then it will abort early and stop at this quality.\n\nIf Auto Unload is checked, then it will also Unload the item.\n\nIf unchecked, then you will need to Hold Shift (or [U]nload hotkey) to Unload -- If you\'re trying to manually increase quality.");

        y = y + 140;
        lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Min Quality:");
        is_done, min_quality = lsEditBox("min_quality", 95, y-3, 0, 80, 0, 0.9, 0.9,
                                     0x000000ff, min_quality);
        min_quality = tonumber(min_quality);
        if not min_quality then
          is_done = false;
          lsPrint(10, y+25, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
          min_quality = 3500;
        end
        y = y + 40;
        lsPrint(10, y, 0, 0.67, 0.67, 0xffff80ff, "Glory Hole position Locked: " .. mouse_x ..", " .. mouse_y);
        y = y + 30;
        lsPrintWrapped(10, y, 0, lsScreenX - 20, 0.65, 0.65, 0xffff80ff, "This is where mouse was pointing when you pressed Shift, on PREVIOUS screen. If you did not hover Glory Hole, when you pressed Shift, then End Script, try again!");

        if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff,
            "Start") then
            is_done = 1;
        end
        if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
            "End script") then
            error('End Script button clicked');
        end
        lsDoFrame();
        lsSleep(10);
    end
end

function unLoad();
  srSetMousePos(mouse_x, mouse_y);
  lsSleep(60);
  srKeyEvent("u");
  lsSleep(100);

  srReadScreen();
  OK = srFindImage("OK.png"); 
    if(OK) then
      srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
      lsSleep(100);
    end
end
