-- by Cegaiel - Easily dig up Limestone Blocks, automating the process of Tapping the Bore and Cracking the outline of multiple windows.
--
-- 
--

dofile("common.inc");

askText = singleLine([[
  Pyramid - Bore Hole Assistant by Cegaiel --
This macro assists in digging up limestone blocks. Pin up all 'Bore Hole' windows near you. The macro will always click 'Crack Outline' when it appears. Else it will keep clicking 'Tap Bore'. Windows will close automatically once the 'Crack Outline' has been clicked. Make sure no Bore windows overlap each other (Optionally, you can use Windows Manager on next screen, to assist). Make sure your skills window is visible. Macro DOES monitor if you're tired (Red stats). Press Shift over ATITD windows to continue.]])

wmText = "Tap Ctrl on Bore Holes to open and pin.\nTap Alt to open, pin and stash.";





function doit()
  askForWindow(askText);
  Main();
end



function Main()

  windowManager("Windows Manager", wmText, false, true);


	sleepWithStatus(500, "Searching for something to click...");


	while 1 do
		checkBreak();
		srReadScreen();
		crack = srFindImage("crack_outline.png");
		tap = srFindImage("tap_bore_rod.png");
		OK = srFindImage("ok.png");
		stats = srFindImage("AllStats-Black.png");
		unpin = srFindImage("unpin.png");


			if OK then
			srClickMouseNoMove(OK[0]+5,OK[1],1);
			sleepWithStatus(100, "Clicking OK button!");
			end

			if crack then
			srClickMouseNoMove(crack[0]+5,crack[1],1);
			sleepWithStatus(500, "Cracking the Outline!");


			--Close the window that cracked
			sleepWithStatus(100, "Closing Window!");
			srClickMouseNoMove(unpin[0]+5,unpin[1],1);
			end



	if stats then

			if tap then
			srClickMouseNoMove(tap[0]+5,tap[1],1);
			sleepWithStatus(500, "Tapping the Bore Rod!");
			else


			sleepWithStatus(1000, "Nothing to click!\nReseting macro...");
			--error("Nothing to click! Quitting...");
			Main();


			end


	else
	sleepWithStatus(500, "You're tired :(\n\nWaiting on Skills Timer (RED) ...");
	end


	end
end
