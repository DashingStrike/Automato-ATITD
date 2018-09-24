-- Pin up your Lures menu 'Self Click, Skills, Fishing, Use Lure' (no other pinned up windows can exist)
-- In Interface Options ensure 'Interface is Small'
-- Should have (Chat-Related): 'Chat and Inventory can be minimized' AND 'Minimized chat-channels are still visible' AND 'Console Messages are Indented'
-- You must have Main Chat tab showing at all times and window is long/wide enough so no lines don't wrap.

-- Yes, this macro reads your MAIN chat screen, so make sure you read the above statement for it to work correctly.
-- Each line of text must not scroll/wrap to the next line. If it does, then drag your chat window wider so it doesn't wrap.
-- You want to make your chat very wide. Note: It is possible to see a LONG message like "Though you lost your lure, you did catch a 15 deben Orange Spongefish"
-- Another long message is "You didn't catch anything. You also lost your lure. Try different lures and locations"
-- At 1280x1024 your chat screen should reach at least to the mid point of your screen to avoid having a chat line wrap to next line, for a long message, like above.
-- Higher resolutions may not have to reach quite to the mid point.
-- You should ensure that your chat has timestamps


-- ********** This macro writes to a log file (Fishlog.txt) for most actions, so you can review later! ******
-- ********** This also macro writes to a log file (Fishstats.txt) showing stats of your last fishing session, so you can review later! ******


--You can delete any of the log files if you wish. It will automatically create new ones if they dont exist.
--The fishlog.txt file gets APPENDED everytime you fish, so the file can grow quite long over time.
--The fishstats.txt file gets OVERWRITTEN everytime your gui program window updates, so it doesn't 'grow' over time.


-- Almost all issues can be corrected by slightly adjusting the main chat window size and restarting.
-- And also verify the lines aren't wrapping to the next line (if so, adjust chat screen to be wider until it is no longer wrapping down to next line).


-- Note: These are currently refered to as Common Fish in the below 'SkipCommon' type of fishes (True or False), checkbox.

--Abdju
--Chromis
--Catfish
--Carp
--Perch
--Phagrus
--Tilapia


dofile("common.inc");
dofile("Fishing_Func.inc");
dofile("settings.inc");


SNum = 0;
Sfish = "";
muteSoundEffects = false;
TotalCasts = 5;

-- Additional reporting in the log file
-- Choose true or false.
-- Note 'LogStrangeUnusual' and 'LogOdd' (below) overrides LogFails setting. ie if LogStrange true, then it would still log even if LogFails = False
--If LogFails = false and LogStrangeUnusual or LogOdd = true, then failed catches those would still be included in the log file.
SkipCommon = false; --Skips to next lure if fish caught is a common (Choose True or False).
LogFails = false;  	-- Do you want to add Failed Catches to log file? 'Failed to catch anything' or 'No fish bit'. Note the log will still add an entry if you lost lure.
LogStrangeUnusual = false; 	-- Do you want to add Strange and Unusual fish to the log file? Note the log will still add an entry if you lost lure.
LogOdd = false; 	-- Do you want to add Odd fish to the log file? Note the log will still add an entry if you lost lure.


function setOptions()

    local is_done = false;
    local count = 1;
    while not is_done do
        lsDoFrame();
        checkBreak();
        local y = 10;

        lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);  -- Shrink the text boxes and text down
        lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff, "Casts per Lure?");
        TotalCasts = readSetting("TotalCasts",TotalCasts);
        is_done, TotalCasts = lsEditBox("totalcasts", 140, y, 0, 40, 25, 1.0, 1.0, 0x000000ff, TotalCasts);
        TotalCasts = tonumber(TotalCasts);
        if not TotalCasts then
            is_done = false;
            lsPrint(190, y+2, 10, 0.7, 0.7, 0xFF2020ff, "<- MUST BE A NUMBER");
            TotalCasts = 5;
        end
        writeSetting("TotalCasts",TotalCasts);
        lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);  -- Restore text boxes and text back to normal
        y = y + 25;
        lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Casts per Lure?  # Casts before switching lures.");
        y = y + 25;
        lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "  Self Click, Options, Chat-Related:");
        y = y + 16;
        lsPrint(5, y, 0, 0.6, 0.6, 0xffff80ff, "Minimized chat-channels are still visible: CHECKED");
        y = y + 16;
        lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "  Self Click, Options, Interface Options:");
        y = y + 16;
        lsPrint(5, y, 0, 0.6, 0.6, 0xffff80ff, "Display fishing lures in sub-menus: CHECKED");
        y = y + 16;
        lsPrint(5, y, 0, 0.6, 0.6, 0xc0c0ffff, "Main chat MUST be wide enough so no lines wrap!");

        lsSetCamera(0,0,lsScreenX*1.4,lsScreenY*1.4);  -- Shrink the check boxes and text down
        y = y + 80;

        muteSoundEffects = readSetting("muteSoundEffects",muteSoundEffects);
        muteSoundEffects = lsCheckBox(10, y, 10, 0xFFFFFFff, " Mute Sound Effects", muteSoundEffects);
        writeSetting("muteSoundEffects",muteSoundEffects);

        y = y + 25;
        SkipCommon = readSetting("SkipCommon",SkipCommon);
        SkipCommon = lsCheckBox(10, y, 10, 0xFFFFFFff, " Skip Common Fish", SkipCommon);
        writeSetting("SkipCommon",SkipCommon);
        y = y + 30;
        lsPrintWrapped(10, y, 0, lsScreenX + 82, 0.7, 0.7, 0xffff80ff, "If Common Fish Caught, immediately switch to next lure:");
        y = y + 18
        lsPrintWrapped(10, y, 0, lsScreenX + 80, 0.7, 0.7, 0xffffffff, "(Abdju, Chromis, Catfish, Carp, Perch, Phagrus, Tilapia)");
        y = y + 40;
        lsPrintWrapped(10, y, 0, lsScreenX + 80, 0.8, 0.8, 0x80ff80ff, "Log entries recorded to FishLog.txt in Automato/games/ATITD folder.");
        y = y + 45;
        LogFails = readSetting("LogFails",LogFails);
        LogFails = lsCheckBox(10, y, 10, 0xFFFFFFff, " Log Failed Catches (Log Everything)", LogFails);
        writeSetting("LogFails",LogFails);

        if LogFails then
            LogStrangeUnusual = false;
            LogOdd = false;
        else
            y = y + 25;
            LogStrangeUnusual = readSetting("LogStrangeUnusual",LogStrangeUnusual);
            LogStrangeUnusual = lsCheckBox(10, y, 10, 0xFFFFFFff, " Log Strange & Unusual Fish Seen ...", LogStrangeUnusual);
            writeSetting("LogStrangeUnusual",LogStrangeUnusual);
            y = y + 25;
            LogOdd = readSetting("LogOdd",LogOdd);
            LogOdd = lsCheckBox(10, y, 10, 0xFFFFFFff, " Log Odd Fish Seen ...", LogOdd);
            writeSetting("LogOdd",LogOdd);
            lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);  -- Restore text boxes and text back to normal

            y = y + 25;
            lsPrintWrapped(10, y, 0, lsScreenX + 82, 0.7, 0.7, 0xffff80ff, "If Common Fish Caught, immediately switch to next lure:");
        end
        lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);  -- Restore text boxes and text back to normal

        if setResume then
            buttonName = "Set/Resume";
        else
            buttonName = "Start";
        end

        if lsButtonText(10, lsScreenY - 30, 0, 130, 0xFFFFFFff, buttonName) then
            is_done = 1;
            setResume = false;
        end
        if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
            "End script") then
            error(quitMessage);
        end
        lsSleep(10);
    end
    return count;
end


function SetupLureGroup()
    TLures = {};
    FirstLure="";
    LastLure = "";

    lsDoFrame();
    statusScreen("Indexing Lures ...",nil, 0.7, 0.7);
    checkBreak()
    srReadScreen();

    FindPin = srFindImage("UnPin.png");
    if FindPin then

        --Click the pinup to refresh the lures window (in case a lure was lost earlier, it would still be showing on menu).
        --srClickMouseNoMove(FindPin[0]-8,FindPin[1]);
        -- clickAllImages(image_name, offsetX, offsetY, rightClick, tol)
        clickAllImages("UnPin.png",-8,0);
        lsSleep(100);
        srReadScreen();
        -- Push Up arrow, just in case its current at bottom of list
        --DownPin = srFindImageInRange("Fishing/Menu_DownArrow.png",FindPin[0]-10,FindPin[1],50,500);
        DownPin = srFindImage("Fishing/Menu_DownArrow.png");
        if DownPin then
            --UpArrow = srFindImageInRange("Fishing/Menu_UpArrow.png",FindPin[0]-10,FindPin[1],50,50);
            UpArrow = srFindImage("Fishing/Menu_UpArrow.png");
            if UpArrow then
                srClickMouseNoMove(UpArrow[0]+5,UpArrow[1]+5);
                lsSleep(200);
                srReadScreen();
                FirstLure = FindLureNameFirst();
                LastLure=FindLureNameLast();
            end

        else
            --No Arrows on lure menu?
            FirstLure = FindLureNameFirst();
            LastLure=nil;
        end

        if not muteSoundEffects then
            lsPlaySound("moneycounter.wav");
        end


    else
        error("Didn\'t find Lures pinned window - Self Click->Skills, Fishing -> Use Lure, PIN THIS WINDOW!");
    end


    if  LastLure ~= nil then
        --We have last lure, and arrows showing
        ChangeLureMenu = LastLure;

        FirstLurLoc = findText(FirstLure);
        LastLurLoc = findText(LastLure);

        lureCounter = 0;
        for i = 1, #Lures,1 do
            test = findText(Lures[i]);
            if test then
                --Add Lure
                lureCounter = lureCounter + 1;
                statusScreen("Indexing Lures [" .. lureCounter .. "]\n" .. Lures[i],nil, 0.7, 0.7);
                lsSleep(50);
                table.insert(TLures,Lures[i]);
                if Lures[i] == LastLure then
                    --End of Menu, Use Down Arrow
                    arrow=srFindImageInRange("Fishing/menu_downarrow.png",test[0],test[1]-5,175,50);
                    if arrow then
                        DownArrowLocs = arrow;
                        srClickMouseNoMove(arrow[0]+5,arrow[1]+5);
                        lsSleep(200);
                        srReadScreen();
                    --else
                        --error("no arrow found");
                    end
                end
                LastLureMenu = Lures[i];
            end
        end

        --Reset Lure Menu
        --UpArrow = srFindImageInRange("Fishing/Menu_UpArrow.png",FindPin[0]-10,FindPin[1],50,50);
        UpArrow = srFindImage("Fishing/Menu_UpArrow.png");
        if UpArrow then
            srClickMouseNoMove(UpArrow[0]+5,UpArrow[1]+5);
            lsSleep(200);
        end

    else
        --No arrows, just get lures
        lureCounter = 0;
        for i = 1, #Lures, 1 do
            test = findText(Lures[i]);
            if test then
                lureCounter = lureCounter + 1;
                statusScreen("Indexing Lures [" .. lureCounter .. "]\n" .. Lures[i],nil, 0.7, 0.7);
                lsSleep(50);
                table.insert(TLures,Lures[i]);
            end
        end
    end
    lsSleep(100);
    return TLures;
end


function FindLureNameFirst()
    for i = 1, #Lures, 1 do -- start from first line
        Lure = findText(Lures[i]);
        if Lure then
            return Lures[i]
        end
    end
end

function FindLureNameLast()
    for i = #Lures, 1, -1 do -- start from last line
        Lure = findText(Lures[i]);
        if Lure then
            return Lures[i]
        end
    end
end

function UseLure()
    checkBreak();
    if #TLures == 0 then
        if not muteSoundEffects then
            lsPlaySound("fail.wav");
        end
        error 'Can\'t find any lures on the pinned window. Did you run out of lures?'
    end

    CurrentLure = PlayersLures[CurrentLureIndex];

    if #TLures == 1 then
        QCurrentLure = CurrentLure;
        QCurrentLureIndex = CurrentLureIndex;
    elseif LostLure == 1 and not lastCast then
    --Do Nothing, continue...
    else
        QCurrentLure = PlayersLures[QCurrentLureIndex];
    end

    -- Uses lure according to CurrentLureIndex, which is used in PlayersLures which contains each lure the player has.
    lsDoFrame(); -- Blank the screen so next statusScreen messages isn't mixed/obscured with previous gui_refresh info on screen
    lsSleep(10);
    if LostLure == 1 and not lastCast then
        statusScreen("Lost Lure! | " .. lastLostLure .. "\nUsing same lure again!", nil, 0.7, 0.7);
        table.insert(lostlure_log, Time .. " | " .. lastLostLure .. " (" .. lastLostLureType .. ")");
        lsSleep(1000);
    elseif LostLure == 1 then
        statusScreen("Lost Lure! | " .. lastLostLure .. "\nSwitching Lures | " .. QCurrentLure, nil, 0.7, 0.7);
        table.insert(lostlure_log, Time .. " | " .. lastLostLure .. " (" .. lastLostLureType .. ")");
        lsSleep(1000);
    else
        statusScreen("Switching Lures | " .. QCurrentLure, nil, 0.7, 0.7);
        lsSleep(750);
    end

    srReadScreen();
    --Only the first 30 lures will show in window, 31+ needs the down arrow clicked to be viewed, else click the up arrow (if more than 30 lures).
    if QCurrentLureIndex > 30 then
        down = srFindImage("Fishing/Menu_DownArrow.png");
        srClickMouseNoMove(down[0]+5,down[1]+5);
        lsSleep(200);
    elseif #PlayersLures > 30 then
        up = srFindImage("Fishing/Menu_UpArrow.png");
        srClickMouseNoMove(up[0]+5,up[1]+5);
        lsSleep(200);
    end

    srReadScreen();

    if LostLure == 1 and not lastCast then
        lure = findText(PlayersLures[CurrentLureIndex]);
    else
        lure = findText(PlayersLures[QCurrentLureIndex]);
    end

    LostLure = 0;

    if lure then
        srClickMouseNoMove(lure[0]+12,lure[1]+5);
        lsSleep(200);
        srReadScreen();

        -- Find Lure Type
        for i = 1, #Lure_Types, 1 do
            test = findText(Lure_Types[i]);
            if test then
                LureType = Lure_Types[i];
                if not muteSoundEffects then
                    lsPlaySound("high_rise.wav");
                end
                --Click it!
                srClickMouseNoMove(test[0]+12,test[1]+5);
                break;
            end
        end
    end
end

function checkIfMain(chatText)
    for j = 1, #chatText do
        if string.find(chatText[j][2], "^%*%*", 0) then
            return true;
        end
        for k, v in pairs(Chat_Types) do
            if string.find(chatText[j][2], k, 0, true) then
                return true;
            end
        end
    end
    return false;
end

function ChatReadFish(value)
    --Find the last line of chat
    local chatText = getChatText();
    if value then
      numCaught, fishType = string.match(lastLine2, "(%d+) deben ([^.]+)%."); -- Read next to last line of main chat
    else
      numCaught, fishType = string.match(lastLine, "(%d+) deben ([^.]+)%."); -- Read last line of main chat
    end
    if fishType then
        GrandTotalCaught = GrandTotalCaught + 1
        Sfish = string.gsub(fishType, "%W", "");
        SNum = numCaught
        GrandTotaldb = GrandTotaldb + SNum
    end
    return("[" .. CurrentLure .. " (" .. LureType .. ")] "  .. Sfish .. " (" .. SNum .. "db)");
end

function findchat()
    --Find the last line of chat
    checkBreak();
    srReadScreen();
    chatText = getChatText();

    local onMain = checkIfMain(chatText);
    if not onMain then
        if not muteSoundEffects then
            lsPlaySound("timer.wav");
        end
    end

    -- Wait for Main chat screen and alert user if its not showing
    while not onMain do
        checkBreak();
        srReadScreen();
        chatText = getChatText();
        onMain = checkIfMain(chatText);
        sleepWithStatus(500, "Looking for Main chat screen...\n\nMake sure main chat tab is showing and that the window is sized, wide enough, so that no lines wrap to next line.\n\nAlso if you main chat tab is minimized, you need to check Options, Interface Option, Minimized chat-channels are still visible.", nil, 0.7, 0.7);
    end

    while #chatText < 2 do
        checkBreak();
        srReadScreen();
        chatText = getChatText();
        sleepWithStatus(500, "Error: We must be able to read at least the last 2 lines of chat!\n\nCurrently we only see " .. #chatText .. " lines ...\n\nYou can also type something in main chat or manually fish, once or twice, to bypass this error!", nil, 0.7, 0.7);
    end



    --Read last line in chat
    lastLine = chatText[#chatText][2];
    lastLineParse = string.sub(lastLine,string.find(lastLine,"m]")+3,string.len(lastLine));

    --Read next to last line in chat
    lastLine2 = chatText[#chatText-1][2];
    lastLineParse2 = string.sub(lastLine2,string.find(lastLine2,"m]")+3,string.len(lastLine2));

    gui_refresh();
end


function findClockInfo()
    srReadScreen();
    clockWin = findText("Year", nil, REGION, NOPIN);

    if clockWin then
        lines = findAllText(nil, clockWin, nil, NOPIN);
        for i=1,#lines do
            lsPrintln("LINE " .. i .. " : " .. table.concat(lines[i], ","));

            theDateTime = table.concat(lines[1], ",") -- Line 1 on the clock
            theDateTime = string.sub(theDateTime,string.find(theDateTime,",") + 1);
            regionCoords = table.concat(lines[2], ",") -- Line 2 on the clock
            regionCoords = string.sub(regionCoords,string.find(regionCoords,",") + 1);
            Coordinates = string.sub(regionCoords,string.find(regionCoords,":") + 2);
            stripYear = string.sub(theDateTime,string.find(theDateTime,",") + 2);
            Time = string.sub(stripYear,string.find(stripYear,",") + 2);
            stripYear = "," .. stripYear
            Date = string.sub(stripYear,string.find(stripYear,",") + 1, string.len(stripYear) - string.len(Time) - 2);
        --lsPrintln(theDateTime .. "\nCoords: " .. Coordinates .. " (" .. string.len(Coordinates) .. ")\nTime: " .. Time .. " (" .. string.len(Time) .. ")\nDate: " .. Date .. " (" .. string.len(Date) .. ")");

        end
    end
end


function gui_refresh()
    checkBreak();

    if GrandTotalCasts == 0 or GrandTotalCasts == 1 then
        DateBegin = Date;
        TimeBegin = Time;
    end

    if GrandTotalCaught < 10 then
        last10 = GrandTotalCaught .. "/10";
    elseif GrandTotalCaught > 10 then
        last10 = "10/" .. GrandTotalCaught
    else
        last10 = 10;
    end


    --Stats (On Screen Display)
    --CurrentLureIndex  out of  PlayersLures
    winsize = lsGetWindowSize();

    if #PlayersLures == 0 then
        if not muteSoundEffects then
            lsPlaySound("fail.wav");
        end
        error 'Can\'t find any lures on the pinned window. Did you run out of lures?';
    elseif #PlayersLures == 1 then
        CurrentLureIndex = 1;
        QCurrentLureIndex = 1;

    elseif CurrentLureIndex > #PlayersLures then
        CurrentLureIndex = #PlayersLures;
        QCurrentLureIndex = 1;
    end

    local y = 2;
    CurrentLure = PlayersLures[CurrentLureIndex];
    QCurrentLure = PlayersLures[QCurrentLureIndex];
    lsPrintWrapped(10, y, 0, lsScreenX - 20, 0.5, 0.5, 0xc0c0ffff, Date .. " | " .. Time .. " | " .. Coordinates);
    nextLureChange = TotalCasts + 1 - castcount
    nextLureChangeMessageColor = 0xc0ffffff;

    if nextLureChange-1 <= 0 and LockLure then
        nextLureChangeMessageColor = 0xffff40ff;
        nextLureChangeMessage = "< LURE LOCKED! >  Unlock when ready to change Lure!";
    elseif nextLureChange-1 <= 0 and not LockLure then
        nextLureChangeMessageColor = 0xffff40ff;
        nextLureChangeMessage = "0 casts remaining ... Lure will change after this cast!";
    elseif LockLure then
        nextLureChangeMessageColor = 0xffff40ff;
        nextLureChangeMessage = "< LURE LOCKED! >  " .. nextLureChange-1 .. " casts remaining ...";
    else
        nextLureChangeMessage = nextLureChange-1 .. " casts remaining until Next Lure change!";
    end

    y = y + 12;
    lsPrintWrapped(10, y, 0, lsScreenX - 20, 0.5, 0.5, 0xc0ffc0ff, "Current Lure: " .. CurrentLureIndex .. " of " .. #PlayersLures .. "   " .. CurrentLure .. " (" .. LureType .. ")");
    y = y + 12;
    lsPrintWrapped(10, y, 0, lsScreenX - 20, 0.5, 0.5, nextLureChangeMessageColor, nextLureChangeMessage);
    y = y + 14;
    lsPrintWrapped(10, y, 0, lsScreenX - 20, 0.5, 0.5, 0xfcad86ff, "Cast Timer: " .. round(castWait/1000, 1) .. " s");
    y = y + 12;
    lsPrintWrapped(10, y, 0, lsScreenX - 20, 0.5, 0.5, 0xfbc3abff, "Last Timer: " .. round(lastCastWait/1000, 1) .. " s");
    lsSetCamera(0,0,lsScreenX*1.6,lsScreenY*1.6);

    if lsButtonText(160, y+20, 0, 20, 0xffffffff,
        "-"	) then
        QCurrentLureIndex = QCurrentLureIndex - 1;
        if QCurrentLureIndex < 1 then
            QCurrentLureIndex = #PlayersLures;
        end
    end

    if lsButtonText(187, y+20, 0, 20, 0xffffffff,
        "+"	) then
        QCurrentLureIndex = QCurrentLureIndex + 1
        if QCurrentLureIndex > #PlayersLures then
            QCurrentLureIndex = 1;
        end
    end

    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);

    lsPrintWrapped(137, y-5, 0, lsScreenX - 20, 0.5, 0.5, 0xfFFFFFff, "Next Lure (" .. QCurrentLureIndex .. "):");

    if skipLure or ((TotalCasts + 1 - castcount) <= 1 and not LockLure) then
        lsPrintWrapped(209, y-5, 0, lsScreenX - 20, 0.5, 0.5, 0xffffc0ff, QCurrentLure);
    else
        lsPrintWrapped(209, y-5, 0, lsScreenX - 20, 0.5, 0.5, 0xc0ffffff, QCurrentLure);
    end
    y = y + 13;
    lsPrintWrapped(10, y, 0, lsScreenX - 20, 0.5, 0.5, 0xffffc0ff, "Last " .. last10 .. " Fish Caught:\n");

    --Reset this string before showing last10 or allcaught fish below. Else the entries will multiply exponetially with entries from previous loops/call to this function
    last10caught = "";
    allcaught = "";
    lostlures = "";

    if #gui_log_fish > 10 then
        table.remove(gui_log_fish,11);
    end
    for i = 1, #gui_log_fish,1 do
        lsPrintWrapped(10, y + (14*i), 0, lsScreenX - 18, 0.5, 0.5, 0xffffdfff, gui_log_fish[i]);
    end

    for i = 1, #gui_log_fish2,1 do
        allcaught = allcaught .. gui_log_fish2[i] .. "\n";
    end

    for i = 1, #lostlure_log,1 do
        lostlures = lostlures .. lostlure_log[i] .. "\n";
    end


    lsPrintWrapped(10, winsize[1]-130, 0, lsScreenX - 20, 0.5, 0.5, 0xffffffff, "Odd Fish Seen: " .. GrandTotalOdd);
    lsPrintWrapped(10, winsize[1]-118, 0, lsScreenX - 20, 0.5, 0.5, 0xffffffff, "Unusual Fish Seen: " .. GrandTotalUnusual);
    lsPrintWrapped(10, winsize[1]-106, 0, lsScreenX - 20, 0.5, 0.5, 0xffffffff, "Strange Fish Seen: " .. GrandTotalStrange);
    lsPrintWrapped(10, winsize[1]-94, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "-----------------------------");
    lsPrintWrapped(10, winsize[1]-82, 0, lsScreenX - 20, 0.5, 0.5, 0xc0ffc0ff, "Lures Switched: " .. GrandTotalLuresUsed-1);
    if lastLostLure ~= "" then
        lsPrintWrapped(10, winsize[1]-70, 0, lsScreenX - 20, 0.5, 0.5, 0xff8080ff, "Lures Lost: " .. GrandTotalLostLures .. "   -  Last: " .. lastLostLure .. " (" .. lastLostLureType .. ")");
    else
        lsPrintWrapped(10, winsize[1]-70, 0, lsScreenX - 20, 0.5, 0.5, 0xff8080ff, "Lures Lost: " .. GrandTotalLostLures);
    end
    lsPrintWrapped(10, winsize[1]-58, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff, "-----------------------------");
    lsPrintWrapped(10, winsize[1]-46, 0, lsScreenX - 20, 0.5, 0.5, 0xc0ffffff, "Completed Casts: " .. GrandTotalCasts);
    lsPrintWrapped(10, winsize[1]-34, 0, lsScreenX - 20, 0.5, 0.5, 0xff8080ff, "Failed Catches: " .. GrandTotalFailed);
    lsPrintWrapped(10, winsize[1]-22, 0, lsScreenX - 20, 0.5, 0.5, 0xffffc0ff, "Fish Caught: " .. GrandTotalCaught .. " (" .. math.floor(GrandTotaldb) .. "db)");
    lsSetCamera(0,0,lsScreenX*1.6,lsScreenY*1.6);

    if lsButtonText(lsScreenX + 40, lsScreenY + 20, 0, 130, 0xFFFFFFff,
        "Options") then
        lsDoFrame();
        setResume = true;
        setOptions();
    end

    if lsButtonText(lsScreenX + 40, lsScreenY + 50, 0, 130, 0xFFFFFFff,
        "End Script") then
        error(quitMessage);
    end

    if skipLure or ((TotalCasts + 1 - castcount) <= 1 and not LockLure) then
        skipLureText = "Next Lure";
        skipLureTextColor = 0xffff40ff;
    else
        lastCast = false;
        skipLureText = "Next Lure";
        skipLureTextColor = 0xFFFFFFff;
    end

    if skipLure or ((TotalCasts + 1 - castcount) <= 0 and not LockLure) then
        lastCast = true;
    else
        lastCast = false;
    end

    if not finishUp then
        if lsButtonText(lsScreenX + 40, lsScreenY + 120, 0, 130, 0xFFFFFFff,
            "Finish Up") then
            finishUp = true;
        end
    else
        if lsButtonText(lsScreenX + 40, lsScreenY + 120, 0, 130, 0xff8080ff,
            "Cancel ...") then
            finishUp = false;
        end
    end

    if lsButtonText(lsScreenX + 40, lsScreenY + 150, 0, 130, skipLureTextColor,
        skipLureText	) then
        if skipLure then
            skipLure = false;
        else
            skipLure = true;
            LockLure = false;
        end
    end


    if LockLure then
        LockLureColor =  0xffff40ff;
        LockLureText =  "Cancel Lock!";
    else
        LockLureColor = 0xFFFFFFff;
        LockLureText = "Lock Lure";
    end


    if lsButtonText(lsScreenX + 40, lsScreenY + 180, 0, 130, LockLureColor,
        LockLureText ) then

        if LockLure then
            LockLure =  false;
        else
            LockLure = true;
            skipLure = false;
        end
    end

    if #lostlure_log == 0 then
        lostlures = "*** No lures lost! ***";
    end

    if #gui_log_fish2 == 0 then
        allcaught = "*** No fish caught! ***";
    end

    WriteFishStats("Note this report is overwritten every time the macro runs. The stats are for last fishing session only!\nYou can safely delete this file, but it will be created the next time macro runs!\n\n\nStart Time: " .. DateBegin .. " @ " .. TimeBegin .. "\nEnd Time: " .. Date .. " @ " .. Time .. "\nLast Coordinates: " .. Coordinates .. "\n----------------------------------\nOdd Fish Seen: " .. GrandTotalOdd .. "\nUnusual Fish Seen: " .. GrandTotalUnusual .. "\nStrange Fish Seen: " .. GrandTotalStrange .. "\n----------------------------------\nLures Clicked: " .. GrandTotalLuresUsed .. "\nLures Lost: " .. GrandTotalLostLures .. " \n----------------------------------\nCasts: " .. GrandTotalCasts .. "\nFailed Catches: " .. GrandTotalFailed .. "\nFish Caught: " .. GrandTotalCaught .. " (" .. math.floor(GrandTotaldb) .. "db)\n----------------------------------\n\nAll lures lost this Session:\n\n" .. lostlures .. "\n\n\nAll fish caught this Session:\n\n".. allcaught);

    lsDoFrame();
    lsSleep(10);
end



function doit()

    askForWindow("Fishing v2.0.7 (by Tutmault, revised by KasumiGhia, Cegaiel, and Skyfeather)\n\nMAIN chat tab MUST be showing and wide enough so that each line doesn't wrap.\n\nRequired: Pin Lures Menu (Self, Skills, Fishing, Use Lures). History will be recorded in FishLog.txt and stats in FishStats.txt.\n\nOptional: Pin Fillet Menu (Self, Skills, Fishing, Fillet). 'All Fish' will be clicked after each caught fish (empty windows are refreshed).\n\nSelf, Options, Interface Options (Menu:) \"Display available fishing lures in submenus\" MUST BE CHECKED! Egypt Clock /clockloc must be showing and unobstructed. Move clock window slightly if any problems.\n\nMost problems can be fixed by adjusting main chat window! Ensure that your chat displays timestamps");

    ----------------------------------------
    --Variables Used By Program -- Don't Edit Unless you know what you're doing!
    CurrentLure = ""; --Don't Edit
    gui_log_fish = {}; --Don't Edit, holds log display
    gui_log_fish2 = {}; --Don't Edit, holds log display
    log_fish = {}; --Don't Edit, holds log display
    lostlure_log = {}; --Don't Edit, holds log display
    CurrentLureIndex = 1; -- 1 = First Lure Player Owns in alphabetical order
    QCurrentLureIndex = 1;
    ChangeLureMenu="";
    LastLureMenu="";
    DownArrowLocs=nil;
    PlayersLures={}; --Don't Edit, Holds Current Player Lures

    castcount = 0;
    GrandTotalCaught = 0;
    GrandTotalCasts = 0;
    GrandTotaldb = 0;
    GrandTotalStrange = 0;
    GrandTotalOdd = 0;
    GrandTotalUnusual = 0;
    GrandTotalLuresUsed = 0;
    GrandTotalLostLures = 0;
    GrandTotalFailed = 0;
    lastLostLure = "";
    LostLure = 0;
    LureType = "";
    lastLostLureType = "";
    lockLure = false;
    skipLure = false;
    lastCastWait = 0;
    castWait = 0;
    ----------------------------------------

    setOptions();
    PlayersLures = SetupLureGroup();  -- Fetch the list of lures from pinned lures window
    lsSleep(1000); -- Just a delay to let the sound effect finishing playing, not needed...

    findClockInfo();
    while not Time do
        checkBreak();
        findClockInfo();
        sleepWithStatus(1000, "Can not find Clock!\n\nMove your clock slightly.\n\nMacro will resume once found ...\n\nIf you do not see a clock, type /clockloc in chat bar.");
    end

    while 1 do

        checkBreak();
        srReadScreen();
        cast = srFindImage("fishicon.png");
        OK = srFindImage("OK.png");
        if ignoreOK then
          OK = nil;  -- We got a popup box while examining isis ship pieces recently, prevent potential reindexing lures (No lure found, refreshing.. Below)
        end
        lsSleep(100)

        if not cast then
            if not muteSoundEffects then
                lsPlaySound("timer.wav");
            end
        end

        while not cast do
            checkBreak();
            srReadScreen();
            cast = srFindImage("fishicon.png");
            sleepWithStatus(500, "Can\'t find Fishing icon ...");
        end


        if castcount == 0 or OK or skipLure then
            castcount = 1;
            skipLure = false;

            if #PlayersLures > 1 then
                LockLure = false;
            else
                LockLure = true;
            end


            if #PlayersLures > 1 and not OK then
                UseLure(); --Switch Lures
                GrandTotalLuresUsed = GrandTotalLuresUsed + 1;
            end


            if OK then
                srClickMouseNoMove(OK[0]+5,OK[1]+3);  -- Close the popup OK button
                sleepWithStatus(1500,"No " .. QCurrentLure .. " lure found!\nRefreshing lure list ...", nil, 0.7, 0.7)
                PlayersLures = SetupLureGroup();
                if QCurrentLureIndex  > #PlayersLures or QCurrentLureIndex == 1 then
                    QCurrentLureIndex = 2;
                    CurrentLureIndex = 1;

                end
                UseLure(); --Switch Lures
            else
                CurrentLureIndex = QCurrentLureIndex;
                QCurrentLureIndex = QCurrentLureIndex + 1;
            end


            if QCurrentLureIndex  > #PlayersLures and not OK then
                --Last Lure, Prepare to go to first lure in list ...
                QCurrentLureIndex = 1;
                CurrentLureIndex = #PlayersLures;
            end

            --update log
            gui_refresh();


        elseif LostLure == 1 then
            UseLure(); -- Equip Same Lure again


        elseif castcount  > TotalCasts and not LockLure then
            --Reset
            castcount=0;

        else

            --Cast
            checkBreak();
            castWait = 0;
            findchat();
            lastLineFound = lastLineParse; -- Record last line before casting
            lastLineFound2 = lastLineParse2; -- Record next to last line before casting
            srClickMouseNoMove(cast[0]+3,cast[1]+3);
            startTime = lsGetTimer();
            ignoreOK = nil;


            while 1 do
                findchat();
                OK = srFindImage("OK.png");
                writeLastTwoLines = nil;
                noWriteLog = nil;
                overweight = nil;
                skipOkOnce = nil; -- Helps prevent premature break, from OK box while checking Isis ship debris
                lsSleep(100);
                checkBreak();
                castWait = (lsGetTimer() - startTime);
                gui_refresh();

                if not muteSoundEffects and castWait/1000 > 2.5 and castWait/1000 < 2.7 then
                    lsPlaySound("fishingreel.wav");
                end

                for k, v in pairs(Isis_List) do
                  if string.find(lastLine, k, 0, true) then
                        -- If we get a message in chat from examining test of isis ship pieces, then ignore message and ignore popup box
                        -- This causes a short OK popup "Examining Relic", but then closes by itself. We don't want to confuse this for a popup from missing lure; ignore
                        lastLineFound = lastLineParse; -- Re-Record last line (with new message)
                        lastLineFound2 = lastLineParse2; -- Re-Record next to last line (with new message)
                        ignoreOK = 1;
                        noWriteLog = 1;
                  end
                end

                if OK then
                  skipOkOnce = 1; -- Prevents a premature break below from OK box while Examining Isis ship pieces, until next loop. Give a chance for ignoreOK to get recognized
                end

                for k, v in pairs(Ignore_List) do
                  if string.find(lastLine, k, 0, true) or not string.find(lastLine, "^%*%*", 0) then
                        -- If we get a message defined in Ignore_List (already fishing, item is from a forge, or no ** (player is speaking in main chat), then ignore
                        lastLineFound = lastLineParse; -- Re-Record last line (with new message)
                        lastLineFound2 = lastLineParse2; -- Re-Record next to last line (with new message)
                        noWriteLog = 1;
                  end
                end


                if (lastLineFound2 ~= lastLineParse2 or lastLineFound ~= lastLineParse) or (OK and not ignoreOK and not skipOkOnce) or ( (lsGetTimer() - startTime) > 20000 ) then
                    lastCastWait = castWait;
                    break;
                end
            end -- end while 1 do

            castcount = castcount + 1;
            GrandTotalCasts = GrandTotalCasts + 1;
            findClockInfo();


            --Parse Chat
            CurrentLure = PlayersLures[CurrentLureIndex];
            caughtFish = false;
            oddFound = false;
            strangeUnusualFound = false;



            for k, v in pairs(Chat_Types) do
                if string.find(lastLine, k, 0, true) then
                    if v == "overweight" then
                        if string.match(lastLine2, "(%d+) deben ([^.]+)%.") then
                          caughtFish = true;  -- This will force it to parse the next to last line, instead of last line for any caught fish
                        end
                    end

                    if v == "achievement" then
                        -- If last message was 'You have achieved: Caught a blah blah', then caughtFish = true, parse the next to last line for fish caught
                        --  Also set bool to record both lines in log
                        writeLastTwoLines = 1;
                        caughtFish = true;  -- This will force it to parse the next to last line, instead of last line for any caught fish
                    end

                    if v == "alreadyfishing" or (OK and not ignoreOK) then
                        castcount = castcount - 1;
                        GrandTotalCasts = GrandTotalCasts - 1;
                    end

                    if v == "lostlure" then
                        if not muteSoundEffects then
                            lsPlaySound("boing.wav");
                        end
                        lastLostLure = CurrentLure;
                        lastLostLureType = LureType;
                        GrandTotalLostLures = GrandTotalLostLures + 1;
                        LostLure = 1;
                    --Reset, skip to next lure
                    --castcount=0;
                    end

                    if v == "odd" then
                        GrandTotalOdd = GrandTotalOdd + 1;
                        if LogOdd then
                            oddFound = true;
                        end
                    end

                    if v == "strange" then
                        GrandTotalStrange = GrandTotalStrange + 1;
                        if LogStrangeUnusual then
                            strangeUnusualFound = true;
                        end
                    end

                    if v == "unusual" then
                        GrandTotalUnusual = GrandTotalUnusual + 1;
                        if LogStrangeUnusual then
                            strangeUnusualFound = true;
                        end
                    end

                    if v == "caught" or caughtFish then

                        if v == "caught" then
                          caughtFish = true;
                          Fish = ChatReadFish(); -- Parse last line of main chat
                        else
                          Fish = ChatReadFish(1); -- Parse next to last line of main chat

                            if not fishType then
                              caughtFish = nil;
                            else
                              overweight=1;
                            end

                        end

                        if caughtFish then
                        --Last 10 fish caught that displays on GUI
                        addlog = Time .. " | " .. Sfish .. " (" .. SNum .. "db) | " .. CurrentLure
                        table.insert(gui_log_fish, 1, addlog);
                        -- All fish caught that displays in fishstats.txt
                        table.insert(gui_log_fish2, addlog);
                        FishType = Sfish;
                        if SkipCommon == true and LockLure == false then
                            --FishType = string.sub(Fish,string.find(Fish,",") + 1);

                            if FishType == "Abdju" or FishType == "Chromis" or FishType == "Catfish" or FishType == "Carp" or FishType == "Perch" or FishType == "Phagrus" or FishType == "Tilapia" then
                                --Skip it
                                castcount=0;

                            end
                        end
                        --if not muteSoundEffects then
                        --if FishType == "Abdju" or FishType == "Chromis" or FishType == "Catfish" or FishType == "Carp" or FishType == "Perch" or FishType == "Phagrus" or FishType == "Tilapia" then
                        --lsPlaySound("cheer.wav");
                        --else
                        --lsPlaySound("applause.wav");
                        --end
                        --end

                        filletFish();  -- Search for "All Fish" pinned up. If so, fillet.
                        end
                    end


                    --Add more if v == "something" then statements here if needed

                end
                gui_refresh();
            end

            if not caughtFish then
                GrandTotalFailed = GrandTotalFailed + 1;
            end

            if v == "lure" or v == "alreadyfishing" or noWriteLog or not string.find(lastLine, "^%*%*", 0) then
            -- Do nothing
            elseif overweight then
                WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. lastLineParse2 .. "\n");
            elseif writeLastTwoLines then
                WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. lastLineParse2 .. "\n");
                WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. lastLineParse .. "\n");
            elseif LogFails or caughtFish or oddFound or strangeUnusualFound then
                WriteFishLog("[" .. Date .. ", " .. Time .. "] [" .. Coordinates .. "] [" .. CurrentLure .. " (" .. LureType .. ")] " .. lastLineParse .. "\n");
            end

            gui_refresh();
        end
        if finishUp then
            lsPlaySound("Complete.wav");
            error("Finished up, per your request!");
        end
        gui_refresh();
    end
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end


function filletFish()
  -- Pin your Skills, Fishing, Fillet menu, and we will fillet fish every catch (so they don't go rotten). You need to have at least 1 whole fish in inventory for this menu to appear!
  srReadScreen();
  emptyWindow = srFindImage("WindowEmpty.png");
  fillet = findText("All Fish");

  if emptyWindow then
    --refresh any empty windows; just in case a previous fillet All Fish caused window to become empty
    clickAllImages("WindowEmpty.png", 5, 5, nil, nil);
    lsSleep(150);
  end

  if fillet then
    clickAllText("All Fish");
  end
end
