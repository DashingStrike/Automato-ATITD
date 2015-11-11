-- mod_assist.lua by Safa
--
-- Do various modding tasks using Automato UI or Keyboard Shortcuts. Get notified when new posts are present.
-- Uses pbslog.txt to save modding history.

dofile("common.inc");

askText = singleLine([[
  mod_assist by Safa. Do various modding tasks using Automato UI or Keyboard Shortcuts. 
  Get notified when new posts are present. This macro WON'T autopost any messages. 
  Every post must be approved by the operator! Click the gear icon for more settings. 
  Hit SHIFT to begin.
]]);

--Done Modding
is_done = false;
--Automato Window Size
automato = lsGetWindowSize();
--Used by Timer to determine a second is passed.
frame = 0;
notifyOnce = 0;
lessTriggerHappy = 500;
animation_beep = 3000;
animation_readScreen = 0;
animation_postSent = 0;
--Timer
 h=0;
 m=0;
 s=0;
--Number of posts approved/posted.
p_yes=0;
p_saved =0;
--Keybind Buttons
buttons = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", 
"a", 
"b", 
"c", 
"d", 
"e", 
"f", 
"g", 
"h", 
"i", 
"j", 
"k", 
"l", 
"m", 
"n", 
"o", 
"p", 
"q", 
"r", 
"s", 
"t", 
"u", 
"v", 
"w", 
"x", 
"y", 
"z", 
"CAPSLOCK", 
"F1", 
"F2", 
"F3", 
"F4", 
"F5", 
"F6", 
"F7", 
"F8", 
"F9", 
"F10", 
"F11", 
"F12", 
"PRINTSCREEN", 
"SCROLLLOCK", 
"PAUSE", 
"INSERT", 
"HOME", 
"PAGEUP", 
"DELETE", 
"END", 
"PAGEDOWN", 
"RIGHT", 
"LEFT", 
"DOWN", 
"UP", 
"AUDIONEXT", 
"AUDIOPREV", 
"AUDIOSTOP", 
"AUDIOPLAY", 
"AUDIOMUTE", 
"LCTRL", 
"LSHIFT", 
"LALT", 
"LGUI", 
"RCTRL", 
"RSHIFT", 
"RALT" 
};
--Settings
ui_size = "Default";
logsession = "On";
keyboard_shortcuts = "On";
post_button = "LALT";
save_button = "LCTRL";
sounds = "Loop";
success_sound = "On";
scribble_sound = "On";
--State.  0:Waiting for Posts  1: Post Pending  2: Settings 3: Post Sent
State=0;

function doit()
  askForWindow(askText);
  findClockInfo();
  askForFocus();
  lsPlaySound("start.wav");
  startModding();
end

function notify()
if sounds == "Loop" then
  if animation_beep > 3000 then
	lsPlaySound("beepping.wav");
	animation_beep = 0;
  else
	animation_beep = animation_beep + 100;
  end
elseif sounds == "On" then
  if notifyOnce == 0 then
	lsPlaySound("beepping.wav");
	notifyOnce = 1;
  end
end
end

function exitButton()
--Return to Automato Scripts List if "End Script" is pressed.
  if lsButtonText(0 - 20, lsScreenY - 30, z, 200, 0x000000FF, "Log & Exit") then
    if logsession == "On" then
    LogSession();
	end
	is_done = 1;
  end
end

function exitButtonSmall()
--Return to Automato Scripts List if "End Script" is pressed.
  if lsButtonText(0, 60, z, lsScreenX, 0x000000FF, "Log & Exit") then
	if logsession == "On" then
    LogSession();
	end
	is_done = 1;
  end
end

function PBSLog(Text)
	FileFish = io.open("pbslog.txt","a+");
	FileFish:write(Text);
	FileFish:close();
end

function LogSession()
  if logTime == "Off" then
    timeStarted = "       Unknown       ";
	timeStopped = "       Unknown       ";
  else
    --Time Macro Stopped. (for pbslog.txt)
    findClockInfo();
    timeStopped = "[" .. Date .. ", " .. Time .. "] ";
  end


--Log information about this modding session.
  if p_yes < 10 then
    PBSLog("  " .. "    (" .. h .. "h" ..  m .. "m".. s .. "s)                 " .. "-00" .. p_yes .. "-            " .. timeStarted .. "   " .. timeStopped .. "\n");
  elseif p_yes < 100 then
	PBSLog("  " .. "    (" .. h .. "h" ..  m .. "m".. s .. "s)                 " .. "-0" .. p_yes .. "-            " .. timeStarted .. "   " .. timeStopped .. "\n");
  else
	PBSLog("  " .. "    (" .. h .. "h" ..  m .. "m".. s .. "s)                 " .. "-" .. p_yes .. "-            " .. timeStarted .. "   " .. timeStopped .. "\n");
  end
end

function findClockInfo()
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
    lsPrintln("Found Clock");
    window = getWindowBorders(anchor[0], anchor[1]);
    lines = findAllText(nil, window, NOPIN);
    for i=1,#lines do
      --lsPrintln("LINE " .. i .. " : " .. table.concat(lines[i], ","));

	theDateTime = table.concat(lines[1], ",") -- Line 1 on the clock
	theDateTime = string.sub(theDateTime,string.find(theDateTime,",") + 1);
	stripYear = string.sub(theDateTime,string.find(theDateTime,",") + 2);
	Time = string.sub(stripYear,string.find(stripYear,",") + 2);
	stripYear = "," .. stripYear
	Date = string.sub(stripYear,string.find(stripYear,",") + 1, string.len(stripYear) - string.len(Time) - 2);
      --lsPrintln(theDateTime .. "\nCoords: " .. Coordinates .. " (" .. string.len(Coordinates) .. ")\nTime: " .. Time .. " (" .. string.len(Time) .. ")\nDate: " .. Date .. " (" .. string.len(Date) .. ")");

    end
  end
end

function updateTimer()
  if frame > 1000 then
	frame = 0;
	s = s + 1;
	 if s == 60 then
	   s = 0;
	   m = m + 1;
	 end
	 if m == 60 then
	  m = 0;
	  s = 0;
	  h = h + 1;
	 end
  end
end

function playScribble()
 if scribble_sound == "On" then
   lsPlaySound("scribble.wav");
 end
end

function playSuccess()
 if success_sound == "On" then
   lsPlaySound("successful.wav");
 end
end

function waitForPosts()
  if ui_size == "Default" then -- UI Size Default
--Show time passed below microphone.
	updateTimer();
	if lsButtonImg(200, 50, 8, 0.10, 0xFFFFFFff, "pbs/settings.png") then
	  State = 2;
    end
	if p_saved == 1 then
	  lsPrint(85, 10, 2, 0.6, 0.6, 0x55AAAAFF, "Holding saved post(s).");
	end
	lsPrint(90, 25, 2, 0.7, 0.7, 0xFFFFFFFF, "Waiting for posts");
	if p_yes < 10 then
    lsPrint(55, 130, 2, 2.0, 2.0, 0xFFFFFFff, "00" .. p_yes);
    elseif p_yes < 100 then
	lsPrint(55, 130, 2, 2.0, 2.0, 0xFFFFFFFF, "0" .. p_yes);
    else
	lsPrint(55, 130, 2, 2.0, 2.0, 0xFFFFFFFF, p_yes);
    end
	lsPrint(120, 220, 2, 0.7, 0.7, 0xFFFFFFFF, "(" .. h .. "h" ..  m .. "m".. s .. "s)");
	lsButtonImg(50, 50, 1, 0.40, 0xFFFFFFff, "pbs/microphone.png");
	exitButton();
  else -- UI Size Toolbar
    updateTimer();
	if lsButtonImg(240, 5, 5, 0.10, 0xFFFFFFff, "pbs/settings.png") then
	  State = 2;
    end
	if p_saved == 1 then
	  lsPrint(85, 10, 2, 0.6, 0.6, 0x55AAAAFF, "Holding saved post(s).");
	end
	lsPrint(140, 15, 2, 0.5, 0.5, 0xFFFFFFFF, "Waiting for posts");
	lsPrint(65, 7, 2, 2.0, 2.0, 0xFFFFFFFF, p_yes);
	lsPrint(150, 30, 2, 0.7, 0.7, 0xFFFFFFFF, "(" .. h .. "h" ..  m .. "m".. s .. "s)");
	lsButtonImg(5, 5, 1, 0.10, 0xFFFFFFff, "pbs/microphone.png");
	exitButtonSmall();
  end
end

function postButton()
  if keyboard_shortcuts == "On" then
	if post_button == "LALT" then
	  if lsAltHeld() then
		  if lessTriggerHappy > 500 then
			srClickMouseNoMove(POST[0] + 25, POST[1] + 5, 1);
		    playScribble();
		    p_yes = p_yes + 1;
		    State =3;
		    animation_postSent = 0;
			lessTriggerHappy = 0;
		  else
			lessTriggerHappy = lessTriggerHappy + 100;
		  end    
	    end
	else
	  if lsKeyDown(post_button) then
		  if lessTriggerHappy > 500 then
			srClickMouseNoMove(POST[0] + 25, POST[1] + 5, 1);
		    playScribble();
		    p_yes = p_yes + 1;
		    State =3;
		    animation_postSent = 0;
			lessTriggerHappy = 0;
		  else
			lessTriggerHappy = lessTriggerHappy + 100;
		  end    
	    end
	end

  end
end

function saveButton()
  if keyboard_shortcuts == "On" then
    if save_button == "LCTRL" then
       if lsControlHeld() then
		safeDrag(POST[0] - 10, POST[1] - 40, 25, 25, 1);
		safeDrag(740, 80, atitd[0] - 40, 80, 1);
	   end
	else
	  if lsKeyDown(save_button) then
		safeDrag(POST[0] - 10, POST[1] - 40, 25, 25, 1);
		safeDrag(740, 80, atitd[0] - 40, 80, 1);
	  end
	end
  end
end

function postPending()
updateTimer();
    if not POST then
	 State =3;
	 notifyOnce = 0;
	 animation_postSent = 0;
	else
	  if ui_size == "Default" then --UI Size Default
	    notify();
	    postButton();
		saveButton();
		
			lsPrint(100, 25, 2, 0.7, 0.7, 0xFFFFFFFF, "Post(s) Pending");
			lsPrint(143, 125, 2, 2.0, 2.0, 0x55AAAAFF, p_yes);
			lsPrint(120, 220, 2, 0.7, 0.7, 0xFFFFFFFF, "(" .. h .. "h" ..  m .. "m".. s .. "s)");
			--Expand Post Window
			if lsButtonImg(200, 50, 3, 0.15, 0xFFFFFFff, "pbs/expand.png") then
			  safeDrag(POST[0] - 10, POST[1] - 40, 25, 25, 1);
			  safeDrag(740, 80, atitd[0] - 40, 80, 1);
			end
			--Save Post
			if lsButtonImg(220, 120, 3, 0.15, 0xFFFFFFff, "pbs/save.png") then
			  srClickMouseNoMove(POST[0] + 10, POST[1] + 5, 1);
			  lsPlaySound("saved.wav");
			  p_saved = 1;
			end	
			--Send Post
			if lsButtonImg(50, 50, 1, 0.40, 0xFFFFFFff, "pbs/message.png") then
			  srClickMouseNoMove(POST[0] + 25, POST[1] + 5, 1);
			  playScribble();
			  p_yes = p_yes + 1;
			  State =3;
			  animation_postSent = 0;
			  playSuccess();
			end
			exitButton();
		else --UI Size Toolbar
		notify();		
		postButton();
		saveButton();
		
			lsPrint(165, 15, 2, 0.5, 0.5, 0xFFFFFFFF, "Post(s) Pending");
			lsPrint(260, 20, 2, 1.0, 1.0, 0xFFFFFFFF, p_yes);
			lsPrint(170, 30, 2, 0.7, 0.7, 0xFFFFFFFF, "(" .. h .. "h" ..  m .. "m".. s .. "s)");
			--Expand Post Window
			if lsButtonImg(105, 5, 5, 0.10, 0xFFFFFFff, "pbs/expand.png") then
			  safeDrag(POST[0] - 10, POST[1] - 40, 25, 25, 1);
			  safeDrag(740, 80, atitd[0] - 40, 80, 1);
			end
			--Save Post
			if lsButtonImg(55, 5, 5, 0.10, 0xFFFFFFff, "pbs/save.png") then
			  srClickMouseNoMove(POST[0] + 10, POST[1] + 5, 1);
			  lsPlaySound("saved.wav");
			  p_saved = 1;
			end	
			--Send Post
			if lsButtonImg(5, 5, 1, 0.10, 0xFFFFFFff, "pbs/message.png") then
			  srClickMouseNoMove(POST[0] + 25, POST[1] + 5, 1);
			  playScribble();
			  p_yes = p_yes + 1;
			  State =3;
			  animation_postSent = 0;
			end
			exitButtonSmall();
		end
	end
	
end

function postSent()
  if ui_size == "Default" then --UI Size Default
    updateTimer();
    --Go to state 0 when 0.5 second passes.
    if animation_postSent > 500 then
	  State = 0;
	  notifyOnce = 0;
	  lessTriggerHappy = 0;
    else
	  if notifyOnce == 0 then
	    playSuccess();
		notifyOnce = 1;
	  end
	  lsPrint(110, 25, 2, 0.9, 0.9, 0xFFFFFFFF, "All Done!");
	  lsButtonImg(45, 49, 1, 0.85, 0xFFFFFFff, "pbs/yes.png");
	  exitButton();
	  POST = nil;
	  animation_postSent = animation_postSent + 100; 
    end
  else --UI Size Toolbar
	updateTimer();
    --Go to state 0 when 0.5 second passes.
    if animation_postSent > 500 then
	  State = 0;
	  notifyOnce = 0;
    else
	  if notifyOnce == 0 then
	    playSuccess();
		notifyOnce = 1;
	  end
	  lsPrint(65, 7, 2, 2.0, 2.0, 0xFFFFFFFF, "All Done!");
	  lsButtonImg(5, 5, 1, 0.20, 0xFFFFFFff, "pbs/yes.png");
	  exitButtonSmall();
	  POST = nil;
	  animation_postSent = animation_postSent + 100; 
    end
  end
end

function settingsMenu()
    updateTimer();
	settings_y = 0;
	lsDisplaySystemSprite(1, 0, 0, 0, automato[0], automato[1], 0xFFFFFFFF);
	
	lsPrint(60, settings_y + 10, 1, 0.7, 0.7, 0x000000FF, "Small User Interface");
	if ui_size == "Default" then 
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/off.png") then
	    ui_size = "Toolbar";
	  end
	else
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/on.png") then
	    ui_size = "Default";
	  end
	end
	
	settings_y = settings_y + 25;
	lsPrint(60, settings_y + 10, 1, 0.7, 0.7, 0x000000FF, "Log Modding Session (pbslog.txt)");
	if logsession == "Off" then 
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/off.png") then
	    logsession = "On";
	  end
	else
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/on.png") then
	    logsession = "Off";
	  end
	end
	
	settings_y = settings_y + 25;
	
	if sounds == "Loop" then 
	  lsPrint(60, settings_y + 10, 1, 0.7, 0.7, 0x000000FF, "Notify until all posts are sent");
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/mid.png") then
	    sounds = "On";
	  end
	elseif sounds == "On" then
	  lsPrint(60, settings_y + 10, 1, 0.7, 0.7, 0x000000FF, "Notify once for every post");
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/on.png") then
	    sounds = "Off";
	  end
	else
	  lsPrint(60, settings_y + 10, 1, 0.7, 0.7, 0x000000FF, "No Notification");
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/off.png") then
	    sounds = "Loop";
	  end
	end
	
	settings_y = settings_y + 25;
	lsPrint(60, settings_y + 10, 1, 0.7, 0.7, 0x000000FF, "Success/All Sent Sound");
	if success_sound == "Off" then 
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/off.png") then
	    success_sound = "On";
	  end
	else
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/on.png") then
	    success_sound = "Off";
	  end
	end
	
	settings_y = settings_y + 25;
	lsPrint(60, settings_y + 10, 1, 0.7, 0.7, 0x000000FF, "Scribble/Posting Sound");
	if scribble_sound == "Off" then 
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/off.png") then
	    scribble_sound = "On";
	  end
	else
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/on.png") then
	    scribble_sound = "Off";
	  end
	end
	
	settings_y = settings_y + 25;
	lsPrint(60, settings_y + 10, 1, 0.7, 0.7, 0x000000FF, "Enable Keyboard Shortcuts");
	if keyboard_shortcuts == "Off" then 
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/off.png") then
	    keyboard_shortcuts = "On";
	  end
	else
	  if lsButtonImg(20, settings_y, 1, 0.30, 0xFFFFFFff, "pbs/on.png") then
	    keyboard_shortcuts = "Off";
	  end
	end
	
	
	settings_y = settings_y + 50;
	lsDisplaySystemSprite(1, 0, settings_y - 10, 1, automato[0], 1, 0x000000FF);
	lsPrint(15, settings_y - 5, 1, 0.5, 0.5, 0x000000FF, "Automato must be in focus to use custom keybindings!");
	lsPrint(70, settings_y + 5, 1, 0.7, 0.7, 0x000000FF, "Change Key Bindings");
	
	settings_y = settings_y + 25;
	if lsButtonImg(45, settings_y + 5, 2, 0.06, 0xFFFFFFff, "pbs/message.png") then
	  bind = "post";
	end
	
	if bind == "post" then
	  lsPrint(90, settings_y, 2, 2.0, 2.0, 0xFFFFFFff, post_button);
	  lsDisplaySystemSprite(1, 0, settings_y, 1, automato[0], 40, 0x000000FF); --Black
	  postKeyList();
	else
	  lsPrint(90, settings_y, 2, 2.0, 2.0, 0x000000FF, post_button);
	end
	
	settings_y = settings_y + 35;
	if lsButtonImg(45, settings_y + 5, 2, 0.06, 0xFFFFFFff, "pbs/save.png") then
	  bind = "save";
	end
	
	if bind == "save" then
	  lsPrint(90, settings_y, 1, 2.0, 2.0, 0xFFFFFFff, save_button);
	  lsDisplaySystemSprite(1, 0, settings_y, 1, automato[0], 40, 0x000000FF); --Black
	  saveKeyList();
	else
	  lsPrint(90, settings_y, 1, 2.0, 2.0, 0x000000FF, save_button);
    end	
	settings_y = settings_y + 35;
	

	
	if lsButtonText(0 - 20, lsScreenY - 30, 1, 200, 0x000000FF, "Save") then
	  if post_button == save_button then
	    error "Keyboard shortcuts for post button and save button cannot be the same!";
	  else
	    State=0;
	  end
    end
	
end

function postKeyList()
  for i =1,#buttons do
    if lsKeyDown(buttons[i]) then
      post_button = buttons[i];
	end
  end
end

function saveKeyList()
  for i =1,#buttons do
    if lsKeyDown(buttons[i]) then
      save_button = buttons[i];
	end
  end
end


function startModding()
  if not Time then
    logTime = "Off";
  else
    --Time Macro Started. (for pbslog.txt)
    timeStarted = "[" .. Date .. ", " .. Time .. "]";
  end
  
  srReadScreen();
  atitd = srGetWindowSize();
  
  while not is_done do
	--Wait X seconds then read screen.
	if animation_readScreen > 1000 then
	  srReadScreen();
	  POST = srFindImage("pbs/S_P.png");
	  O_P = srFindImage("pbs/O_P.png");
	  animation_readScreen = 0;
	else
	  animation_readScreen = animation_readScreen + 100;
	end
	
	if POST then
	  if State ~= 2 then
	    State = 1;
	  end
	end
	
	if O_P then
	p_saved = 1;
	else
	p_saved = 0;
	end
	
	--Determine Active Menu
	if State == 0 then
	  waitForPosts();
	elseif State == 1 then
	  postPending();
	elseif State == 2 then
	  settingsMenu();
	elseif State == 3 then
	  postSent();
	end

    if lsKeyDown("q") then
      is_done = 1;
	end	
	frame = frame + 100;
    lsDoFrame();
    lsSleep(100);
  end
end

