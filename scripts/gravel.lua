--gravel.lua
dofile("common.inc");

is_done = false; --Exit Loop?


askText = singleLine([[
  Hit SHIFT to begin. Pin inventory, press and hold ALT to drop stones. Hold middle click or S to smash.
  ]]);

function doit()
  askForWindow(askText);
  askForFocus();
  Run();
end


function Run()
--Loop
  xyWindowSize = srGetWindowSize();
  srReadScreen();

  while not is_done do
  checkBreak();

  if lsAltHeld() then
    srReadScreen();
    stone = findText("Stone");
    if stone then
      srClickMouseNoMove(stone[0] +10, stone[1], true);
      sleepWithStatus(25, "Dropping");
      srClickMouseNoMove(xyWindowSize[0]/2 + 55, xyWindowSize[1]/2 + 20, 1);
    else
       sleepWithStatus(25, "Nothing to drop.");
    end
  end

  if lsMouseIsDown(2) then
      srKeyEvent('s');
      lsSleep(25);
      srClickMouseNoMove(xyWindowSize[0], xyWindowSize[1] - xyWindowSize[1] + 10, 1);
  end

  if lsKeyDown("q") then
      is_done = 1;
  end
    lsDoFrame();
    lsSleep(25);
  end
end

