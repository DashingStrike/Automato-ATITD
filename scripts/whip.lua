-- Optional other keys you can use, other than Shift - lsShiftHeld():
-- Replace lsShiftHeld() in doit() to use another key or mouseClick
-- lsAltHeld()
-- lsControlHeld()
-- lsMouseIsDown(int button)
-- 1 = Left, 2 = Middle, 3 = Right.


maxWhip = 6; -- How many times to click Whip in a row. Ideally, this may force to go a tad farther then a single whip


dofile("common.inc");

  askText = "Whip a Cow or Bull, a little easier.\n\nPin the cow/bull window anywhere, except the center (where the popup occurs when whipping).\n\nThis macro is very simple. It prevents you having to keep clicking on the menu, to refresh it, when it\'s 'too far away'. When you get near to the cow, the window refreshes so that the 'Whip' option appears.\n\nOnce you are standing where you want, Tap Shift to quickly send " .. maxWhip .. " whips." ;


function doit()
  askForWindow(askText);

  while 1 do
    checkBreak();
    srReadScreen();
    FindPin = srFindImage("UnPin.png");

    if FindPin then
      srClickMouseNoMove(FindPin[0]-5,FindPin[1]);
    end

    if lsShiftHeld() then
      whip();
    end

    sleepWithStatus(200,"Refreshing pinned windows\n\nTap Shift to Whip", nil, 0.7, 0.7);
  end
end


function whip()
  whip = 1;
  whipCount = 0;

  while whip and whipCount ~= maxWhip do
    checkBreak();
    srReadScreen();
    whip = findText("Whip")
    whipCount = whipCount + 1;
    clickText(whip);
    sleepWithStatus(100, "Cracking the Whip " .. maxWhip .. " times quickly ...", nil, 0.7, 0.7);
  end
end