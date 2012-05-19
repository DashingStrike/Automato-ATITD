-- boards.lua v1.1 -- Revised by Tallow
--
-- Run a set of sawmills to generate boards.
--

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
  Board Maker v1.1 (Revised by Tallow) --
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
  while 1 do
    -- Click pin ups to refresh the window
    clickAllImages("ThisIs.png");
    sleepWithStatus(200, "Refreshing");

    image_name = "PlaneAPiece.png";
    
    -- Find buttons and click them!
    local clickCount = clickAllImages("PlaneAPiece.png");
    sleepWithStatus(pause_time, "Clicked " .. clickCount .. " windows");
  end
  return quit_message;
end
