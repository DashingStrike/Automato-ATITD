-- boards.lua v1.1 -- Revised by Tallow
--
-- Run a set of sawmills to generate boards.
--

dofile("common.inc");

askText = singleLine([[
  Board Maker v1.2 (Revised by Tallow, revised by tripps) --
  Automatically planes boards from any number of Wood Plane or
  Carpentry Shop windows. Make sure the VT window is in the TOP-RIGHT
  corner of the screen.
]]);

wmText = "Tap control on Wood Planes or Carpentry Benches to open and pin.";

--Amount of time to pause after clicking the plane woods button (ms)
pause_time = 3000; 

function doit()
  askForWindow(askText);
  windowManager("Board Setup", wmText);
  askForFocus();
  unpinOnExit(planeBoards);
end

function planeBoards()
	local click_delay = 200;
  while 1 do
    -- Click pin ups to refresh the window
    clickAllImages("ThisIs.png");
    sleepWithStatus(500, "Refreshing");
	
	srReadScreen();
	local msg = "";
	local clickCount = 0;
	local ThisIsList = findAllImages("ThisIs.png");
	local i;
	for i=1,#ThisIsList do
		local x = ThisIsList[i][0];
		local y = ThisIsList[i][1];
		local width = 100;
		local height = 250;
		local util = srFindImageInRange("utility.png", x, y, width, height, 5000);
		if(util) then
			height = util[1] - y;
			local p = srFindImageInRange("PlaneAPiece.png", x, y, width, height);
			if(p) then
				safeClick(p[0]+4,p[1]+4);
				clickCount = clickCount + 1;
				srReadScreen();
			else
				p = srFindImageInRange("upgrade.png", x, y, width, height, 5000);
				if(p) then
					safeClick(p[0]+4,p[1]+4);
					lsSleep(click_delay);
					srReadScreen();
					p = srFindImage("installACarpentryBlade.png", 5000);
					if(p) then
						safeClick(p[0]+4,p[1]+4);
						lsSleep(click_delay);
						srReadScreen();
						p = srFindImage("quality.png", 5000);
						if(p) then
							safeClick(p[0]+4,p[1]+4);
							lsSleep(click_delay);
							srReadScreen();
						else
							local j;
							for j=1,3 do
								lsPlaySound("Clank.wav");
								lsSleep(100);
							end
							msg = "Out of carp blades";
						end
					end
				end
			end
		end
	end
	if(msg == "") then
		msg = "Clicked " .. clickCount .. " windows";
	end
    sleepWithStatus(pause_time, msg);
  end
  return quit_message;
end
