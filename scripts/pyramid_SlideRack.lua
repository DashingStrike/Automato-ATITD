-- by Cegaiel - Easily dig up Limestone Blocks, automating the process of Digging around the block and sliding a rolling rack on multiple windows.
--
-- 
--

dofile("common.inc");

askText = singleLine([[
  Pyramid - Slide Rolling Rack Assistant by Cegaiel --
This macro assists in digging around the limestone blocks. Pin up all 'Tooth Limestone Block Excavation' windows near you. The macro will always click 'Slide a rolling rack under the block' when it appears. Else it will keep clicking 'Dig around this block'. Windows will close automatically once the 'Slide a rolling rack' has been clicked. Make sure no windows overlap each other (Optionally, you can use Windows Manager on next screen, to assist). Make sure your skills window is visible. Macro DOES monitor if you're tired (Red stats). Press Shift over ATITD windows to continue.]])

wmText = "Tap Ctrl on Limestone Blocks to open/pin.";





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
		crack = srFindImage("slideRollingRack.png");
		tap = srFindImage("DigAround.png");
		OK = srFindImage("ok.png");
		stats = srFindImage("AllStats-Black.png");
		unpin = srFindImage("unpin.png");


			if OK then
			srClickMouseNoMove(OK[0]+5,OK[1],1);
			sleepWithStatus(100, "Clicking OK button!");
			end

			if crack then
			srClickMouseNoMove(crack[0]+5,crack[1],1);
			sleepWithStatus(500, "Sliding roller under block!");


			--Close the window that cracked
			sleepWithStatus(100, "Closing Window!");
			srClickMouseNoMove(unpin[0]+5,unpin[1],1);
			end



	if stats then

			if tap then
			srClickMouseNoMove(tap[0]+5,tap[1],1);
			sleepWithStatus(500, "Digging around the block!");
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
