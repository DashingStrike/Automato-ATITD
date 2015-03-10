dofile("common.inc");

windowIndex = 1;

function doit()
  askForWindow("Test to display regions such as Clock Window, Friends window and building windows. Press Shift over ATITD window.");
  while true do
    findStuff();
  end
end


function findStuff()
  srReadScreen();
  local regions = findAllTextRegions();
  if regions and windowIndex > #regions then
    windowIndex = 1;
  end
  if regions and #regions > 0 then
    local current = regions[windowIndex];
    lsButtonText(0, 0, 0, current[2]+10, 0xff0000ff, "");
    srStripRegion(current[0], current[1], current[2], current[3]);
    srMakeImage("current-region", current[0], current[1],
		current[2], current[3]);
    srShowImageDebug("current-region", 5, 5, 1, 1.0);
  end
  lsSleep(100);
  checkBreak();
  lsDoFrame();

  if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100,
		  0xFFFFFFff, "Rotate") then
    windowIndex = windowIndex + 1;
  end
  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,
		  0xFFFFFFff, "End Script") then
    error(quitMessage);
  end


--test = findText("Take");

--if test then
--lsPrintln("found");
--else
--lsPrintln("NOT found");
--end


end