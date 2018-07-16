-- Optional other keys you can use, other than Shift - lsShiftHeld():
-- Replace lsShiftHeld() in doit() to use another key or mouseClick
-- lsAltHeld()
-- lsControlHeld()
-- lsMouseIsDown(int button)
-- 1 = Left, 2 = Middle, 3 = Right.

dofile("common.inc");

  maxWhip = 6; -- How many times to click Whip in a row. Ideally, this may force to go a tad farther then a single whip

  askText = "Whip a Cow or Bull, a little easier.\n\nPin the cow/bull window anywhere, except the center (where the popup occurs when whipping).\n\nThis macro is very simple. It prevents you having to keep clicking on the menu, to refresh it, when it\'s 'too far away'. When you get near to the cow, the window refreshes so that the 'Whip' option appears.\n\nOnce you are standing where you want, Tap Shift to quickly send " .. maxWhip .. " whips." ;



function doit()
  askForWindow(askText);

  while 1 do
    local message = "";
    local whip;
    local color = nil;
    checkBreak();
    srReadScreen();
    FindPin = srFindImage("UnPin.png");
    whip = findText("Whip")

    if FindPin and not whip then
      srClickMouseNoMove(FindPin[0]-5,FindPin[1]);
      message = message .. "Waiting for \"Whip\" to appear ...\n\nGet closer to the animal!\n\nRefreshing pinned windows"
      color = 0xffffc0FF;
    elseif not FindPin then
      message = message .. "No pinned windows found!\n\nClick and pin your animal."
      color = 0xffc0c0FF;
    elseif FindPin and whip then
      message = message .. "Whip found!\n\nTap Shift when ready to Whip"
      color = 0xc0ffc0FF;
    end

    if lsShiftHeld() and whip then
      whipIt();
    end
    statusScreen(message, color, 0.7, 0.7);
    lsSleep(200);
  end

end


function whipIt()
  local whip = 1;
  local whipCount = 0;

  while whip and whipCount ~= maxWhip do
    checkBreak();
    srReadScreen();
    whip = findText("Whip")
    whipCount = whipCount + 1;
    clickText(whip);
    statusScreen("Cracking the Whip " .. maxWhip .. " times quickly ...", nil, 0.7, 0.7);
    lsSleep(150);
  end

end