-- original run and gather slate  v1.0 by Dunagain
-- updated by KarateSnoopy

dofile("common.inc");
dofile("constants.inc");

numSlates = 0

local isMoveU = false;
local isMoveD = false;
local isMoveL = false;
local isMoveR = false;

function clearMoveKeys()
    if( isMoveD ) then 
        srKeyUp(VK_DOWN);
        isMoveD = false;
    end
    
    if( isMoveU ) then 
        srKeyUp(VK_UP);
        isMoveU = false;
    end

    if( isMoveL ) then 
        srKeyUp(VK_LEFT);
        isMoveL = false;
    end

    if( isMoveR ) then 
        srKeyUp(VK_RIGHT);
        isMoveR = false;
    end        
end

function moveU()
    clearMoveKeys();
    srKeyDown(VK_UP);
    isMoveU = true;
end 

function moveD()
    clearMoveKeys();
    srKeyDown(VK_DOWN);
    isMoveD = true;
end 

function moveL()
    clearMoveKeys();
    srKeyDown(VK_LEFT);
    isMoveL = true;
end 

function moveR()
    clearMoveKeys();
    srKeyDown(VK_RIGHT);
    isMoveR = true;
end 

local action = 0;
function doAction()
    action = action + 1;
    local runDist = 10;
    if ( action == 1 ) then
        moveL();
    elseif ( action == 1+runDist ) then
        moveU();
    elseif ( action == 1+runDist+1 ) then
        moveR();
    elseif ( action == 1+runDist+1+runDist ) then
        moveD();
        action = 0;
    end
end

function doit()
    local done = false
    local count = 0;

    askForWindow("Whenever possible, your avatar will collect a slate. You avatar will run left and right looking for slate. You may need to manually move a little when an area is cleared out") ;

    while not done  
    do
        srReadScreen();
        local pos = srFindImage("slate.png");
        if (pos) then
            safeClick(pos[0] + 3, pos[1] + 3);
            sleepWithStatus(3000, "Found slate.  So far found: " .. tostring(numSlates)) ;
            numSlates = numSlates + 1;
        else
            sleepWithStatus(5, "Looking for slate.  So far found: " .. tostring(numSlates)) ;
        end
        
        count = count + 1;        
        if( count > 3 ) then
            doAction();
            count = 0;
        end
    end
end
