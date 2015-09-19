dofile("common.inc");

Button = {};
Button[0] = makePoint(45, 60); --NW
Button[1] = makePoint(75, 62); --NE
Button[2] = makePoint(45, 87); --SW
Button[3] = makePoint(75, 91); --SE
Button[4] = makePoint(59, 51); --N
Button[5] = makePoint(60, 98); --S
Button[6] = makePoint(84, 74); --E
Button[7] = makePoint(37, 75); --W
BuildButton = makePoint(31, 135);


function doit()
	count = promptNumber("How many plots (1-8)?", "6");
  askForWindow("Be in F8F8, zoomed in. Must have 'build all crops at feet' turned OFF! Probibly want to have chat minimized as well. Have a veggie plant menu pinned. Mouse over the plant menu and press Shift to start.");
  srReadScreen();
  local pos = getMousePos();
  lsSleep(click_delay);
  for i = 0, count-1 do
    safeClick(pos[0], pos[1]);
    lsSleep(click_delay);
    safeClick(Button[i][0], Button[i][1]);
    lsSleep(click_delay);
    safeClick(Button[i][0], Button[i][1]);
    lsSleep(click_delay);
    safeClick(BuildButton[0], BuildButton[1]);
    lsSleep(click_delay);
  end
end