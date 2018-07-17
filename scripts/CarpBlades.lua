-- Note that anvils need to have been rotated 180 degrees from the default rotation when built, so the sharp edge of the carp blade is to the left.
-- See https://i.gyazo.com/3c47adac6983e9c608c2c907138c5240.png
-- The anvil in red is an anvil built with no rotation.
-- The anvil in green was rotated 180 degrees.
-- Stand around where the avatar is standing in image for 1920x1080.
-- You might want to move slightly left/right/up/down to get better quality. Even a step can make a difference.
-- Higher resolutions, such as 1440x900, you might need to stand a bit closer to the anvil.

dofile("screen_reader_common.inc");
dofile("ui_utils.inc");
dofile("settings.inc");
dofile("common.inc");

foundBladePos = {};
offset = {};

function doit()

    askForWindow("Make sure your chats are minimized. If the brown, from chat tabs, are midway or higher (from midpoint of anvil) while gathering offsets; mouse might get confused and start hovering tabs.\n\nNote that anvils need to have been rotated 180 degrees from the default rotation when built, so the sharp edge of the carp blade is to the left.\n\nSee comments in .lua for link to screenshot.\n\nHover ATITD window and press Shift to continue.");

    --promptOkay(prompt_string, color, scale, yes_no, no_cancel, offsetY)
    promptOkay("Make sure you are in the F8F8 view, zoomed all the way in.\n\nNo worries, the macro will force F8F8 mode when you click 'Start' button, later.\n\nPin anvil menu where it does not overlap the anvil.", nil, 0.7, nil, true, 35);
    promptOkay("Stand to the left of the anvil without any part of your body overlapping the anvil.\n\nYou may need to reposition your avatar slightly until you get a good quality blade.\n\nPractice makes perfect, experiment!", nil, 0.7, nil, true, 35);

    local x = 10;
    local y = 10;
    local z = 0;
    local scale = 0.7;
    click_delay = 150;
    per_click_delay = click_delay;
    howMany = 1;
    pauseTake = true;
    firstRun = true;
    useCopper = true; -- Make copper blades. You can use Iron with checkbox in options()
    showMousePos = true; -- Show where mouse is clicking when making blades. It will always move while gathering offsets on resin wedge, regardless


    while 1 do
    checkBreak();
    options();
      if firstRun then
        setCameraView(CARTOGRAPHER2CAM);
        lsSleep(300);
        checkAnvil();
        findAnvil();
      end
    main();
    end
end

function main()
    local x = 10;
    local y = 10;
    local z = 0;
    local scale = 0.7;

    for numMade=1, howMany do
        if pauseTake then
          bladeAccepted = nil;
        else
          bladeAccepted = 1;
        end
        message = "";
        message = "[" .. numMade .. "/" .. howMany .. "] Making blade(s)";

        if (numMade == howMany) then
          message = message .. "\n\nYay, last one !";
        else
          message = message .. "\n\n" .. (howMany - numMade) .. " blade(s) remaining";
        end

        if pauseTake and not (numMade == howMany) then
          message = message .. "\n\n" .. "Pause ON -- will pause after this blade";
        end

        checkBreak();
        loadAnvil(metal);
        statusScreen(message, nil, scale, scale);
        makeBlade();
        checkBlade();

        if not pauseTake then
          takeBlade()
        end

	  while not bladeAccepted do
        checkBreak();
        lsPrintWrapped(x, y, 0, lsScreenX - 20, scale, scale, 0xFFFFFFff, "Check main chat for quality, is it OK?\n\n\nClick 'Take' to complete the project and continue\n\nYou can turn off the pause by unchecking box below; Remaining blades will finish uninterupted, after you 'Take'.");

        pauseTake = CheckBox(x, y+180, z, 0xffffffff, " Pause after each blade to verify quality", pauseTake, 0.65, 0.65);

        showMousePos = readSetting("showMousePos",showMousePos);
        showMousePos = CheckBox(x, y+195, z, 0xffffffff, " Show Mouse Movement while making blades", showMousePos, 0.65, 0.65);
        writeSetting("showMousePos",showMousePos);

        if lsButtonText(x, lsScreenY - 30, z, 100, 0x80ff80ff,
                    "Take") then
          bladeAccepted = 1;
          takeBlade();
          break;
        end

        if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xff8080ff,
                    "Scrap") then
          scrap = 1; -- Reset the loop. If you scrapped it, then no point on making the remaining blades.
          scrapBlade();
          break;
        end

        if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
          error "Clicked End script button";
        end

        firstRun = nil;
        lsDoFrame();
        lsSleep(10);
        end -- end while

    if scrap or finish_up then
      if scrap then
        sleepWithStatus(1000, "Project scrapped, resetting macro ...", nil, scale, scale);
      else
        sleepWithStatus(1000, "Finishing up, resetting macro ...", nil, scale, scale);
      end
      firstRun = 1; -- If scrapped it, then you're likely going to reposition your avatar for better quality, do checkAnvil & findAnvil again.
      scrap = nil;
      finish_up = nil;
      break;
    end

    lsDoFrame();
    lsSleep(10);
    end -- end for
    lsPlaySound("beepping.wav");
end

function options()
  local is_done = false;
  local x = 10;
  local y = 10;
  local z = 0;
  local scale = 0.65;
  while not is_done do
    checkBreak();

    lsPrint(x, y+7, z, 0.7, 0.7, 0xffffffff, "How many blades?");
    is_done, howMany = lsEditBox("howMany", 150, y, 0, 50, 30, 1.0, 1.0,
                                     0x000000ff, howMany);
     howMany = tonumber(howMany);
       if not howMany then
         is_done = false;
         lsPrint(x, y+33, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
         howMany = 1;
       end

     useCopper = readSetting("useCopper",useCopper);
     if useCopper then
       useCopper = CheckBox(x, y+50, z, 0xffffffff, " Make Copper Blades (Uncheck for Iron)", useCopper, 0.65, 0.65);
       metal = "Copper";
     else
       useCopper = CheckBox(x, y+50, z, 0xffffffff, " Make Iron Blades (Check for Copper)", useCopper, 0.65, 0.65);
       metal = "Iron"
     end
     writeSetting("useCopper",useCopper);

     showMousePos = readSetting("showMousePos",showMousePos);
     showMousePos = CheckBox(x, y+65, z, 0xffffffff, " Show Mouse Movement while making blades", showMousePos, 0.65, 0.65);
     writeSetting("showMousePos",showMousePos);

     pauseTake = CheckBox(x, y+80, z, 0xffffffff, " Pause after each blade to verify quality", pauseTake, 0.65, 0.65);

     if pauseTake then
       lsPrintWrapped(x, y+105, 0, lsScreenX - 20, scale, scale, 0xFFFFFFff, "Note: You can uncheck the pause, later.\nYou should use this option until you get your first good quality blade.");
     end

     if firstRun then
       lsPrintWrapped(x, y+160, 0, lsScreenX - 20, scale, scale, 0xffff80FF, "This is your first run or you recently Scrapped a project.\n\nWe will now temporarily load a resin wedge (requires 7 copper) to gather offsets of your anvil. It will NOT complete the project and your copper will be returned !\n\nAfter the resin wedge is scrapped, macro will make " .. metal .. " blades.");
     end

     if lsButtonText(x, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "Start") then
       is_done = 1;
     end

     if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
       error "Clicked End script button";
     end

     lsDoFrame();
     lsSleep(10);
  end
     sleepWithStatus(1500, "Engaging Warp Drive, Cap\'n ...\n\nHands off mouse!", nil, 0.8, 0.8);
end

function mouseHome()
--    This is annoying. Not sure if it has a necessary purpose, so commenting out for now. Seems to work fine without it.  ~Cegaiel - July 16, 2018
--    srSetMousePos(0,0);
end

function checkAnvil()
    mouseHome();
    srReadScreen();
    local pos = findText("This is [a-z]+ Anvil", nil, REGEX);
    if(not pos) then
        fatalError("Unable to find the anvil menu, in checkAnvil().");
    end

    local pos = findText("Complete Project");
    if(pos) then
        fatalError("The anvil already has a project loaded.  Clear the anvil and try again.");
    end
end

function findAnvil()
    mouseHome();
    srReadScreen();
    local pos = findText("Load Anvil...");
    if(not pos) then
        fatalError("Unable to find the Load Anvil menu item.");
    end
    clickText(pos);
    
    srReadScreen();
    pos = findText("Copper...");
    if(not pos) then
        fatalError("Unable to find the Copper menu item.");
    end
    clickText(pos);
    
    srReadScreen();
    pos = findText("Resin Wedge");
    if(not pos) then
        fatalError("Unable to find the Resin Wedge menu item.");
    end
    clickText(pos);

    findResinWedgeRightTop();
    
    srReadScreen();
    local pos = findText("This is [a-z]+ Anvil", nil, REGEX);
    if(not pos) then
        fatalError("Unable to find the anvil menu, in findAnvil().");
    end
    clickText(pos);
    
    srReadScreen();
    local pos = findText("Discard Project");
    if(not pos) then
        fatalError("Unable to find the Discard Project menu item.");
    end
    clickText(pos);
    
    srReadScreen();
    local pos = findText("Really scrap");
    if(not pos) then
        fatalError("Unable to find the scrap confirmation dialog.");
    end
    pos[0] = pos[0] + 10;
    local pos2 = waitForImage("Yes3.png", 500);
    if(not pos2) then
        pos2 = waitForImage("Yes4.png", 500);
    end
    if(not pos2) then
        srSetMousePos(foundBladePos[0], foundBladePos[1]);
        fatalError("Unable to find the Yes button.");
    end
    clickText(pos2);
    
    srReadScreen();
    local pos = findText("This is [a-z]+ Anvil", nil, REGEX);
    if(not pos) then
        fatalError("Unable to find the anvil menu, in findAnvil().");
    end
    clickText(pos);
end

function findResinWedgeRightTop()
    mouseHome();
    srReadScreen();
    local xyWindowSize = srGetWindowSize();
    local mid = {};
    mid[0] = xyWindowSize[0] / 2;
    mid[1] = xyWindowSize[1] / 2;

    local bestX = mid[0];
    local bestY = mid[1] - 400;

    local count = 220;
    local step = 64;
    local currX = bestX;
    local currY = bestY;
    local x;
    local maxHue = 0;
    for x = mid[0], mid[0] + 600, step do
        checkBreak();
        local y;
        for y = mid[1] - 400, mid[1], step do
            count = count - 1;
            local rgb = parseColor(srReadPixel(x,y));
            if(math.min(rgb[0]-rgb[2],rgb[1]-rgb[2]) >= 44) then
                if(x > bestX or (x == bestX and y < bestY)) then
                    bestX = x;
                    bestY = y;
                    srSetMousePos(x,y);
                    lsSleep(100);
                end
            end
            statusScreen("Finding reference point... " .. count);
        end
    end
    
    step = 32;
    while(step >= 1) do
        checkBreak();
        local currX = bestX;
        local currY = bestY;
        local x;
        local maxHue = 0;
        for x = currX - (step * 2), currX + (step * 2), step do
            checkBreak();
            local y;
            for y = currY - (step * 2), currY + (step * 2), step do
                count = count - 1;
                local rgb = parseColor(srReadPixel(x,y));
                if(math.min(rgb[0]-rgb[2],rgb[1]-rgb[2]) >= 40) then
                    if(x > bestX or (x == bestX and y < bestY)) then
                        bestX = x;
                        bestY = y;
                        srSetMousePos(x,y);
                    end
                end
                statusScreen("Finding reference point... " .. count);
            end
        end
        step = step / 2;
    end
    foundBladePos[0] = bestX;
    foundBladePos[1] = bestY;
    srSetMousePos(bestX, bestY);
--    lsClipboardSet(bestX .. ", " .. bestY);
--    fatalError(bestX .. ", " .. bestY);
    mouseHome();
end

function loadAnvil(metal)
    mouseHome();
    srReadScreen();
    local pos = findText("Load Anvil...");
    if(not pos) then
        fatalError("Unable to find the Load Anvil menu item.");
    end
    clickText(pos);
    lsSleep(50);
    
    srReadScreen();
    pos = findText(metal .. "...");
    if(not pos) then
        fatalError("Unable to find the " .. metal .. " menu item.");
    end
    clickText(pos);
    lsSleep(50);
    
    srReadScreen();
    pos = findText("Carpentry Blade");
    if(not pos) then
        fatalError("Unable to find the Carpentry Blade menu item.");
    end
    clickText(pos);
    lsSleep(250);

    srReadScreen();
    local pos = findText("This is [a-z]+ Anvil", nil, REGEX);
    if(not pos) then
        fatalError("Unable to find the anvil menu, in loadAnvil().");
    end
    clickText(pos);
end

function setShapingMallet()
    mouseHome();
    srReadScreen();
    local pos = findText("Tools...");
    if(not pos) then
        fatalError("Unable to find the Tools menu item.");
    end
    clickText(pos);
    lsSleep(50);
    
    srReadScreen();
    pos = findText("Shaping Mallet");
    if(not pos) then
        fatalError("Unable to find the Shaping Mallet menu item.");
    end
    clickText(pos);
end

function setChisel()
    mouseHome();
    srReadScreen();
    local pos = findText("Tools...");
    if(not pos) then
        fatalError("Unable to find the Tools menu item.");
    end
    clickText(pos);
    lsSleep(50);
    
    srReadScreen();
    pos = findText("Wide Chisel");
    if(not pos) then
        fatalError("Unable to find the Wide Chisel menu item.");
    end
    clickText(pos);
end

function setBallPeen()
    mouseHome();
    srReadScreen();
    local pos = findText("Tools...");
    if(not pos) then
        fatalError("Unable to find the Tools menu item.");
    end
    clickText(pos);
    lsSleep(50);
    
    srReadScreen();
    pos = findText("Ball Peen");
    if(not pos) then
        fatalError("Unable to find the Ball Peen menu item.");
    end
    clickText(pos);
end

function setForce(force)
    mouseHome();
    srReadScreen();
    local pos = findText("Tools...");
    if(not pos) then
        fatalError("Unable to find the Tools menu item.");
    end
    clickText(pos);
    lsSleep(50);
    
    srReadScreen();
    pos = findText("Force Level");
    if(not pos) then
        fatalError("Unable to find the Force Level menu item.");
    end
    clickText(pos);
    lsSleep(50);

    srReadScreen();
    pos = findText("[" .. force .. "]");
    if(not pos) then
        fatalError("Unable to find the Force Level menu item.");
    end
    clickText(pos);
end    

function makeBlade()
    mouseHome();
    checkBreak();
    srReadScreen();
    click_delay = 200;
    
    -- Get screen info
    xyWindowSize = srGetWindowSize()
    centerX = xyWindowSize[0] / 2;
    centerY = xyWindowSize[1] / 2;
    screenX = xyWindowSize[0];
    screenY = xyWindowSize[1];


    -- The original carp blade macro seems to have been written in 1920x1080 and using hard coded coordinates
    -- Other resolutions would not be able to use this
    -- Attempt to adjust scaling by pixels for other resolutions, based on hard coded coordinates
    --pixel scale to adjust to other resolutions. ie 1440x900 would be 0.75

    psX = xyWindowSize[0] / 1920;
    psY = xyWindowSize[1] / (1080-53); -- Automato reports ATITD in window mode is 1920x1027
    psY = psX; -- pixel scale for X should also work for Y. psY is there, just in case you need to try to adjust some weird resolution

    --local recordedBladePos = { 1261, 408 };
    local recordedBladePos = { 1261*psX, 408*psY };

    offset[0] = foundBladePos[0] - recordedBladePos[1];
    offset[1] = foundBladePos[1] - recordedBladePos[2];
    
    setShapingMallet();
    setForce(8);
  
    clickXY(1046*psX, 435*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1046*psX, 479*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1046*psX, 523*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1046*psX, 567*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1046*psX, 611*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1046*psX, 655*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1046*psX, 699*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1046*psX, 745*psY, offset[0], offset[1], 1);
    checkBreak();

    setChisel();
    setForce(9);

    clickXY(1046*psX, 435*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1046*psX, 745*psY, offset[0], offset[1], 1);
    checkBreak();

    clickXY(1046*psX, 538*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1046*psX, 642*psY, offset[0], offset[1], 1);
    checkBreak();

    setForce(4);
    
    clickXY(1145*psX, 534*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1145*psX, 590*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1145*psX, 652*psY, offset[0], offset[1], 1);
    checkBreak();

    setBallPeen();
    setForce(9);
    
    clickXY(1164*psX, 462*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1162*psX, 722*psY, offset[0], offset[1], 1);
    checkBreak();
    
    clickXY(1258*psX, 463*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1261*psX, 721*psY, offset[0], offset[1], 1);
    checkBreak();

    clickXY(1236*psX, 463*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1239*psX, 730*psY, offset[0], offset[1], 1);
    checkBreak();

    clickXY(1237*psX, 490*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1236*psX, 700*psY, offset[0], offset[1], 1);
    checkBreak();
    
    clickXY(1250*psX, 490*psY, offset[0], offset[1], 1);
    checkBreak();
    clickXY(1255*psX, 700*psY, offset[0], offset[1], 1);
    checkBreak();
end

function checkBlade()
    mouseHome();
    srReadScreen();
    local pos = findText("Tools...");
    if(not pos) then
        fatalError("Unable to find the Tools menu item.");
    end
    clickText(pos);
    lsSleep(50);
    
    srReadScreen();
    pos = findText("Quality Check");
    if(not pos) then
        fatalError("Unable to find the Quality Check menu item.");
    end
    clickText(pos);
end

function takeBlade()
    mouseHome();
    srReadScreen();
    local pos = findText("Complete Project");
    if(not pos) then
        fatalError("Unable to find the Complete Project menu item.");
    end
    clickText(pos);
    lsSleep(50);
    
    srReadScreen();
    pos = findText("Ready to Unload");
    if(not pos) then
        fatalError("Unable to find the Ready to Unload confirmation dialog.");
    end
    pos[0] = pos[0] + 10;
    local pos2 = waitForImage("Yes3.png", 500);
    if(not pos2) then
        pos2 = waitForImage("Yes4.png", 500);
    end
    if(not pos2) then
        fatalError("Unable to find the Yes button.");
    end
    clickText(pos2);

    srReadScreen();
    pos = waitForImage("ok.png", 1000);
    if(pos) then
        clickText(pos);
    end

    srReadScreen();
    local pos = findText("This is [a-z]+ Anvil", nil, REGEX);
    if(not pos) then
        fatalError("Unable to find the anvil menu, in findAnvil().");
    end
    clickText(pos);
end

function scrapBlade()
    mouseHome();
    srReadScreen();

    local pos = findText("This is [a-z]+ Anvil", nil, REGEX);
    if(not pos) then
        fatalError("Unable to find the anvil menu, in findAnvil().");
    end
    clickText(pos);
    
    srReadScreen();
    local pos = findText("Discard Project");
    if(not pos) then
        fatalError("Unable to find the Discard Project menu item.");
    end
    clickText(pos);
    
    srReadScreen();
    local pos = findText("Really scrap");
    if(not pos) then
        fatalError("Unable to find the scrap confirmation dialog.");
    end
    pos[0] = pos[0] + 10;
    local pos2 = waitForImage("Yes3.png", 500);
    if(not pos2) then
        pos2 = waitForImage("Yes4.png", 500);
    end
    if(not pos2) then
        srSetMousePos(foundBladePos[0], foundBladePos[1]);
        fatalError("Unable to find the Yes button.");
    end
    clickText(pos2);
    
    srReadScreen();
    local pos = findText("This is [a-z]+ Anvil", nil, REGEX);
    if(not pos) then
        fatalError("Unable to find the anvil menu, in findAnvil().");
    end
    clickText(pos);
end


-------------------------------------------------------------------------------

-- The below function are the same from common_click.inc, but slightly customized to optionally show mouse movements

-------------------------------------------------------------------------------
-- clickXY(x, y, offsetX, offsetY, rightClick)
--
-- Click one point with an offset
--
-- x, y -- Point to click
-- offsetX, offsetY (optional) -- distance from each point to click (default 5)
-- rightClick (optional) -- make each click a right click (default false)
-------------------------------------------------------------------------------

function clickXY(x, y, offsetX, offsetY, rightClick)
  local scale = 0.7;
  if not x then
    error("Incorrect number of arguments for clickPoint()");
  end
  if not y then
    error("Incorrect number of arguments for clickPoint()");
  end
  if not offsetX then
    offsetX = 5;
  end
  if not offsetY then
    offsetY = 5;
  end
  statusScreen(message, nil, scale, scale); -- I don't know why, but if I don't add this sleep message, mouse movement stops half way through, hmm.. Duplicate from main() ~Cegaiel
  if showMousePos then
    srSetMousePos(x+offsetX, y+offsetY);
  end
  clickPoint(makePoint(x,y),offsetX,offsetY,rightClick);
 
  if not pauseTake and not (numMade == howMany) and not finish_up then
    if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff,
                    "Finish Up") then
      message = message .. "\n\nFinishing up ...";
      finish_up = 1;
    end
  end
end
