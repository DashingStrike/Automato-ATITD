dofile("screen_reader_common.inc");
dofile("ui_utils.inc");
dofile("common.inc");

COLOR_NAMES = {};

INGREDIENT_NAMES = {
"Cabbage","Carrot","Clay","DeadTongue","ToadSkin","EarthLight","RedSand",
"Lead","Silver","Iron","Copper","Sulfur","potash","Lime","Saltpeter"};

BUTTON_INDEX = {
["Cabbage"]=1,["Carrot"]=2,["Clay"]=3,["DeadTongue"]=4,["ToadSkin"]=5,["EarthLight"]=6,["RedSand"]=7,
["Lead"]=8,["Silver"]=9,["Iron"]=10,["Copper"]=11,["Sulfur"]=12,["potash"]=13,["Lime"]=14,["Saltpeter"]=15};

RED = 0xFF2020ff;
BLACK = 0x000000ff;
WHITE = 0xFFFFFFff;

recipes = {};

function doit()
    recipes = loadRecipes("paint_recipes.txt");
    askForWindow("Open the paint window. Take any paint away so to start with 'Black'.");
    while 1 do
        checkBreak();
        local config = getUserParams();
        checkBreak();
        mixPaint(config);
    end
end

function mixPaint(config)
    srReadScreen();
    local paint_buttons = findAllImages("paint-button.png");
    if (#paint_buttons == 0) then
        error "No buttons found";
    end
    
    for i=1, config.paint_amount do
        checkBreak();
        for iidx=1, #recipes[config.color_index].ingredient do
            for aidx=1, recipes[config.color_index].amount[iidx] do
                checkBreak();
                local buttonNo = BUTTON_INDEX[recipes[config.color_index].ingredient[iidx]];
                srClickMouseNoMove(paint_buttons[buttonNo][0]+2,paint_buttons[buttonNo][1]+2, right_click);
                sleepWithStatus(click_delay, "Making paint " .. i .. " of " .. config.paint_amount);
            end
        end
        srReadScreen();
        lsSleep(100);
        clickAllText("Take the Paint");
        lsSleep(100);
    end
end

-- Used to place gui elements sucessively.
current_y = 0
-- How far off the left hand side to place gui elements.
X_PADDING = 5

function getUserParams()
    local is_done = false;
    local got_user_params = false;
    local config = {paint_amount=10};
    config.color_name = "";
    config.color_index = 1;
    while not is_done do
        current_y = 10;
        
        if not got_user_params then
            lsScrollAreaBegin("scroll_area", X_PADDING, current_y, X_PADDING, lsScreenX - X_PADDING, 70);
            config.color_index         = lsDropdown("color_name", X_PADDING, current_y, X_PADDING, lsScreenX - X_PADDING, config.color_index, COLOR_NAMES);
            lsScrollAreaEnd(#COLOR_NAMES * 25);
            config.color_name = COLOR_NAMES[config.color_index];
            current_y = 80;
            config.paint_amount      = drawNumberEditBox("paint_amount", "Mix how much paint?", 10);
            got_user_params = true;
            for k,v in pairs(config) do
                got_user_params = got_user_params and v;
            end
            if config.paint_amount then
                drawWrappedText("This will mix " .. config.paint_amount .. " debens of " ..
                         config.color_name .. " paint, with a total cost of:", 0xD0D0D0ff, X_PADDING, current_y);
                current_y = current_y + 30;
                for i=1, #recipes[config.color_index].ingredient do
                    drawWrappedText(math.ceil(recipes[config.color_index].amount[i] * config.paint_amount / 10) .. " " ..
                             recipes[config.color_index].ingredient[i], 0xD0D0D0ff, X_PADDING, current_y);
                    current_y = current_y + 15;
                end
            end
            got_user_params = got_user_params and drawBottomButton(lsScreenX - 5, "Start Script");
            is_done = got_user_params;
        end
        
        if drawBottomButton(110, "Exit Script") then
            error "Script exited by user";
        end
        
        lsDoFrame();
        lsSleep(10);
    end
    
    click_delay = 10;
    return config;
end

function drawNumberEditBox(key, text, default)
    return drawEditBox(key, text, default, true);
end

function drawEditBox(key, text, default, validateNumber)
    drawTextUsingCurrent(text, WHITE);
    local width = validateNumber and 50 or 200;
    local height = 30;
    local done, result = lsEditBox(key, X_PADDING, current_y, 0, width, height, 1.0, 1.0, BLACK, default);
    if validateNumber then
        result = tonumber(result);
    elseif result == "" then
        result = false;
    end
    if not result then
        local error = validateNumber and "Please enter a valid number!" or "Enter text!";
        drawText(error, RED, X_PADDING + width + 5, current_y + 5);
        result = false;
    end
    current_y = current_y + 35;
    return result;
end

function drawTextUsingCurrent(text, colour)
    drawText(text, colour, X_PADDING, current_y);
    current_y = current_y + 20;
end
function drawText(text, colour, x, y)
    lsPrint(x, y, X_PADDING, 0.7, 0.7, colour, text);
end

function drawWrappedText(text, colour, x, y)
    lsPrintWrapped(x, y, X_PADDING, lsScreenX-X_PADDING, 0.6, 0.6, colour, text);
end

function drawBottomButton(xOffset, text)
    return lsButtonText(lsScreenX - xOffset, lsScreenY - 30, z, 100, WHITE, text);
end

function setLine(tree, line, lineNo)
    local sections = csplit(line, ":");
    if #sections ~= 2 then
        error("Cannot parse line: " .. line);
    end
    COLOR_NAMES[lineNo] = sections[1]:match( "^%s*(.-)%s*$" );
    sections = csplit(sections[2], "-");
    if #sections ~= 2 then
        error("Cannot parse line: " .. line);
    end
    local tags = csplit(sections[1]:match( "^%s*(.-)%s*$" ), " ");
    local index = 1;
    tree[lineNo] = {ingredient={},amount={}};
    for i=1, #tags do
        if i % 2 == 1 then
            tree[lineNo].ingredient[index] = tags[i];
        else
            tree[lineNo].amount[index] = tonumber(tags[i]);
        end
        index = index + ((i + 1) % 2);
    end
end

function loadRecipes(filename)
    local result = {};
    local file = io.open(filename, "a+");
    io.close(file);
    local lineNo = 1;
    for line in io.lines(filename) do
        setLine(result, line, lineNo);
        lineNo = lineNo + 1;
    end
    return result;
end