-- Moderator monitor
-- Alerts a moderator when a post is pending approval

assert(loadfile("luaScripts/common.inc"))();


askText = singleLine([[
This macro simply looks for the Post button for Microphone moderators. It will make a sound to inform you a post has been made. Idea if you have call boards partially hidden. Just make sure the [P]ost button is visible! You can also minimize VT while its running. Press Shift over ATITD window to continue.
]])


delay = 30; -- Seconds
delay = delay*1000;


function doit()
  askForWindow(askText);



	while 1 do
		checkBreak();
		srReadScreen();
		POST = srFindImage("Find_Mic.png");
		if POST then
		lsPlaySound("trolley.wav");
		end

		sleepWithStatus(delay,"Upon startup and everytime the timer reaches 0, macro will look for [P]ost button and make a sound if it exists.");

	end

end
