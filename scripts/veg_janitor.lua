-- Vegetable Macro for Tale 7 by thejanitor.
--
-- Thanks to veggies.lua for the build button locations

dofile("common.inc")
dofile("settings.inc")


WARNING=[[
THIS IS A BETA MACRO YOU ARE USING AT YOUR OWN RISK
You must be in the fully zoomed in top down F8 F8 F8 view, Alt+L to lock the camere once there.
In User Options -> Interface Options -> Menu You must DISABLE: "Right-Click Pins/Unpins a Menu"
You Must ENABLE: "Right-Click opens a Menu as Pinned"
You Must ENABLE: "Use the chat area instead of popups for many messages"
In Options -> One-Click and Related -> You must DISABLE: "Plant all crops where you stand"
In Options -> Video -> You must set: Shadow Quality and Time of Day lighting to the lowest possible.
Do not move once the macro is running and you must be standing on a tile with water available to refill.
Do not stand directly on or within planting distance of actual animated water.
]]

DEBUG=false

-- How many times to search for a plant / try open a bed window before giving up.
SEARCH_RETRYS=10

-- How many pixels in a NxN grid to look for before
MATCH_GRID_SIZE=5

-- These are the times in seconds it waits before watering a plant for a given stage.
-- For example, plant A is planted at time 0. At time 2.8 seconds the macro queues up plant A to be watered, it then
-- sleeps 0.2 seconds until FIRST_STAGE_WAIT time has passed before watering that plant an moving on.

-- If you encounter problems where plants are dieing at various stages it is ethier because these values are too low
-- causing a plant to be watered 3+ times in a single stage before it grows. Or it is because they are too high and
-- a plant is not recieving its water in time before regressing a stage.
-- Finally if in the final harvest stage you get getting messages about running out of water then probably it is trying
-- to harvest before it is ready and trying to rewater a plants 3rd stage. Increase the harvest wait to hopefully fix this.

-- TODO: Scale these based on global (and ideally local) teppy time.
FIRST_STAGE_WAIT = 4
SECOND_STAGE_WAIT = 24
THIRD_STAGE_WAIT = 34
HARVEST_STAGE_WAIT = 52

STAGE_WAITS = { FIRST_STAGE_WAIT, SECOND_STAGE_WAIT, THIRD_STAGE_WAIT, HARVEST_STAGE_WAIT }

-- How long to wait for the characters animations to stop at the end of each planting run. If this is too low
-- then instead of clicking a newly placed plant the macro will hit your character. So if you see at the start of a new
-- cycle the character menu being opened by the macro increase this value.
END_OF_RUN_WAIT = 0

-- Controls the size of each search box. The larger this is the slower the search phase which can break everything.
SEARCH_BOX_SCALE = 1/10

MAX_PLANTS=12

RED = 0xFF2020ff
BLACK = 0x000000ff
WHITE = 0xFFFFFFff

LEEKS = "Horus' Grain"
SEED_NAMES = {
    "Tears of Sinai",
    "Green Leaf",
    "Bastet's Yielding",
    LEEKS,
    "Apep's Crop",
}
SEED_TYPES = {
    "Onions",
    "Carrots",
    "Cabbage",
    "Leeks",
    "Garlic",
}


-- Used to control the plant window placement and tiling.
WINDOW_HEIGHT=80
WINDOW_WIDTH=220
WINDOW_OFFSET_X=150
WINDOW_OFFSET_Y=150

function doit()
    while true do
        local config = makeReadOnly(getUserParams())
        askForWindowAndSetupGlobals(config)
        gatherVeggies(config)
    end
end

function askForWindowAndSetupGlobals(config)
    local min_jugs = config.num_waterings * config.num_plants * 3
    local min_seeds = config.num_plants + 8
    local one = 'You will need ' .. min_jugs .. ' jugs of water and at minimum ' .. min_seeds .. ' seeds \n'
    local two = '\n Press Shift over ATITD window to continue.'
    askForWindow(one .. two)
    setupGlobals()
end

function setupGlobals()
    NORTH   = Vector:new{0,-1}
    SOUTH   = Vector:new{0,1}
    WEST    = Vector:new{-1,0}
    EAST    = Vector:new{1,0}
    NORTH_WEST = NORTH + WEST
    NORTH_EAST = NORTH + EAST
    SOUTH_WEST = SOUTH + WEST
    SOUTH_EAST = SOUTH + EAST
    DOUBLE_SOUTH = SOUTH * 2
    DOUBLE_NORTH = NORTH * 2
    DOUBLE_WEST = WEST * 2
    DOUBLE_EAST = EAST * 2

    MOVE_BTNS = {}
    PLANT_LOCATIONS = {next=1}
    PlantLocation:new{direction_vector=NORTH, move_btn=Vector:new{59, 51}}
    PlantLocation:new{direction_vector=EAST ,move_btn=Vector:new{84, 74}}
    PlantLocation:new{direction_vector=SOUTH ,move_btn=Vector:new{60, 98}}
    PlantLocation:new{direction_vector=WEST ,move_btn=Vector:new{37, 75}}
    PlantLocation:new{direction_vector=NORTH, num_move_steps=2}
    PlantLocation:new{direction_vector=WEST, num_move_steps=2}
    PlantLocation:new{direction_vector=EAST, num_move_steps=2}
    PlantLocation:new{direction_vector=SOUTH, num_move_steps=2}
    PlantLocation:new{direction_vector=NORTH_EAST, move_btn=Vector:new{75, 62}}
    PlantLocation:new{direction_vector=NORTH_WEST, move_btn=Vector:new{45,60}}
    PlantLocation:new{direction_vector=SOUTH_EAST, move_btn=Vector:new{75, 91}}
    PlantLocation:new{direction_vector=SOUTH_WEST, move_btn=Vector:new{45, 87}}
    makeReadOnly(PLANT_LOCATIONS)

    local mid = getScreenMiddle()
    ANIMATION_BOX = makeBox(mid.x - 60, mid.y - 50, 105, 85)
    ARM_BOX = makeBox(mid.x - 90, mid.y - 20, 80, 25)
    BUILD_BTN = Vector:new{31, 135}
end

PlantLocation={}
function PlantLocation:new(o)
    if o.num_move_steps then
        o.move_btn = PLANT_LOCATIONS[o.direction_vector].move_btn
        o.direction_vector = o.direction_vector * o.num_move_steps
    else
        o.num_move_steps = 1
    end
    PLANT_LOCATIONS[o.direction_vector] = o
    PLANT_LOCATIONS[PLANT_LOCATIONS.next] = o
    PLANT_LOCATIONS.next = PLANT_LOCATIONS.next + 1
    o.box = makeSearchBox(o.direction_vector)
    return newObject(PlantLocation, o, true)
end

function PlantLocation:move()
    for step=1,self.num_move_steps do
        click(self.move_btn)
    end
end

function gatherVeggies(config)
    local plants = Plants:new{num_plants=config.num_plants }

    drawWater()
    for _=1,config.num_runs do
        local start = lsGetTimer()

        checkBreak()
        lsSleep(3000)

        plants:iterate(Plant.plant, config)
        for round=1,4 do
            plants:iterate(Plant.water, {stage_wait=STAGE_WAITS[round], num_waterings=config.num_waterings})
            checkBreak()
        end

        plants:iterate(Plant.close, config)

        lsSleep(click_delay)
        drawWater()
        lsSleep(click_delay*5)
        checkBreak()


        local stop = lsGetTimer() + END_OF_RUN_WAIT
        local total = math.floor((3600 / ((stop - start)/1000)) * config.num_plants * 3)
        lsPrintln("Running at " .. total .. " veg per hour. ")
        lsSleep(END_OF_RUN_WAIT)
    end
end

-- Simple container object which constructs N plants and allows iteration over them.
Plants={}
function Plants:new(o)
    for index=1,o.num_plants do
        local location = PLANT_LOCATIONS[index]
        self[index] = Plant:new{index=index, location=location}
    end
    return newObject(self,o,true)
end

function Plants:iterate(func, args)
    for index=1,self.num_plants do
        func(self[index], args)
    end
end

Plant = {}
function Plant:new(o)
    o.window_pos = indexToWindowPos(o.index)
    return newObject(self,o)
end

function Plant:plant(config)
    -- Take of a snapshot of the area in which we are guessing the plant will be placed before we actually create
    -- and place it.
    if not self.saved_plant_location then
        lsSleep(click_delay)
        self.beforePlantPixels = getBoxPixels(self.location.box)
    end

    clickPlantButton(config.seed_name)
    self.location:move()
    local spot = getWaitSpotAt(BUILD_BTN)
    click(BUILD_BTN)
    self.plant_time = lsGetTimer()
    waitForChange(spot, click_delay*5)
    lsSleep(click_delay)

    if not self.saved_plant_location then
        for _=1,SEARCH_RETRYS do
            if self:searchForPlant() then
                break
            end
            lsPrintln("Search retry for plant " .. self.index)
            lsSleep(tick_delay)
        end
        if not self.saved_plant_location then
            lsPrintln("Fail search for plant" .. self.index)
        end

    end

    self:openBedWindow(config.alternate_drag)
end

function Plant:searchForPlant()
    lsPrintln("Searching for plant " .. self.index)
    return findChangedRow(self.location.box, self.beforePlantPixels,
        function (location, pixels)
            self.saved_plant_location = location
            self.saved_plant_pixels = pixels
        end
    )
end

function Plant:openBedWindow(alternate_drag)
    if not self.saved_plant_location then
        lsPrintln("No Saved location for plant " .. self.index)
        return
    end

    -- Wierd hacky thing, move the mouse to where the window will be and then safeClick the plant which causes
    -- the window to open instantly at the desired location and not where we clicked the plant.
    -- TODO: problably do something different as this is the only thing that takes mouse control from the user.

    self.window_open = false
    local window_spot = getWaitSpotAt(self.window_pos + {5,5})
    for _=1, SEARCH_RETRYS do
        if waitForPixelsAt(self.saved_plant_location, self.location.box, self.saved_plant_pixels) then
            if alternate_drag then
                local open_spot = getWaitSpotAt(self.saved_plant_location + {5,5})
                click(self.saved_plant_location,true,true)
                if waitForChange(open_spot,click_delay*5) then
                    lsSleep(click_delay)
                    drag(self.saved_plant_location.x+5,self.saved_plant_location.y+5,self.window_pos.x,self.window_pos.y,click_delay*2)
                end
            else
                moveMouse(self.window_pos)
                click(self.saved_plant_location ,1)
            end

            self.window_open = waitForChange(window_spot, click_delay*5)
            if self.window_open then
                break
            end
        end
        lsPrintln("Bed window open retry for plant " .. self.index)
        lsSleep(click_delay)
    end

    if not self.window_open then
        lsPrintln("Bed window open fail for plant " .. self.index)
    end
end

function waitForPixelsAt(vector, box, pixels)
    local match_size = MATCH_GRID_SIZE
    local half_match_size = math.floor(match_size/2)
    local box_location_x = vector.x - half_match_size
    local box_location_y = vector.y - half_match_size
    local match_box = makeBox(box_location_x, box_location_y, match_size, match_size)
    local all_same = true
    iterateBoxPixels(match_box, function(x,y,pixel)
        local pixels_x = box_location_x + x - box.left
        local pixels_y = box_location_y + y - box.top
        local old_pixel = pixels[pixels_y][pixels_x]
        local diff = calculatePixelDiffs(old_pixel, pixel)
        local diff_ok = diff[1] < 10 and diff[2] < 10 and diff[3] < 10
        all_same = all_same and diff_ok
    end)
    return all_same
end


-- For a given plants index sleep until time_seconds has passed for that plant since it was planted.
function Plant:sleepUntil(time_seconds)
    local sleepTime = time_seconds*1000 - (lsGetTimer() - self.plant_time);
    if sleepTime > 0 then
        sleepWithStatus(sleepTime, "Sleeping for " .. sleepTime)
    end
end

function Plant:clickWindow(offset,right_click,show)
    if self.window_open then
        click(self.window_pos + offset,right_click,show)
    end
end

function Plant:water(args)
    if not self.window_open then
        lsPrintln("Trying to water plant " .. self.index .. " which has no window open")
        return
    end

    checkBreak()
    self:sleepUntil(args.stage_wait)

    local search_box = makeBox(self.window_pos.x,self.window_pos.y-40,40,40)
    srReadScreen()
    local this_loc = srFindImageInRange("This.png", search_box.left, search_box.top, search_box.width, search_box.height, 4800)
    if not this_loc then
        lsPrintln("Didn't find This text for plant " .. self.index)
        self.window_open = false
        return
    end
    this_loc = Vector:new{x=this_loc[0],y=this_loc[1]+10}

    click(this_loc)
    for _=1, args.num_waterings do
        click(this_loc+{0,25})
        click(this_loc)
        checkBreak()
    end
end

function Plant:close(config)
    local search_box = makeBox(self.window_pos.x+120,self.window_pos.y-50,80,80)
    srReadScreen()
    local unpin_loc = srFindImageInRange("blank.png", search_box.left, search_box.top, search_box.width, search_box.height, 4800)
    if not unpin_loc then
        lsPrintln("Didn't find upin image for plant " .. self.index)
        return
    end
    unpin_loc = Vector:new{x=unpin_loc[0],y=unpin_loc[1] }
    if not inside(unpin_loc+{25,10},search_box) then
        lsPrintln("Trying to unpin outside of the search box????")
    else
        click(unpin_loc+{25,10})
    end
end

-- Create a table of direction string -> box. Each box is where we will search the plant placed for that given direction
-- string.
-- Full of janky hardcoded values.
-- TODO: Make debuging this easier, figure out pixel scaling for different resolutions, get rid of magic numbers.
function makeSearchBox(direction)
    local xyWindowSize = srGetWindowSize()
    local search_size = math.floor(xyWindowSize[0] * SEARCH_BOX_SCALE)
    local mid = getScreenMiddle()
    local offset_mid = mid - {search_size / 3, search_size / 3 }

    local top_left = offset_mid + direction*40 - Vector:new{20,20 }

    local box = makeBox(top_left.x,top_left.y, search_size, search_size)
    box.direction = direction
    return box
end

function getScreenMiddle()
    local xyWindowSize = srGetWindowSize()
    return Vector:new{math.floor(xyWindowSize[0]/2), math.floor(xyWindowSize[1]/2)}
end

-- Tiling method from Cinganjehoi's original bash script. Tried out the automato common ones but they are slow
-- and broke sometimes? This is super simple and its not the end of the world if it breaks a little during a run.
function indexToWindowPos(index)
    local columns = getNumberWindowColumns()
    local x = WINDOW_WIDTH*((index-1) % columns) + WINDOW_OFFSET_X
    local y = WINDOW_HEIGHT*math.floor((index-1) / columns) + WINDOW_OFFSET_Y
    return Vector:new{x, y}
end

function getNumberWindowColumns()
    local xyWindowSize = srGetWindowSize()
    local width = xyWindowSize[0] * 0.6
    return math.floor(width / WINDOW_WIDTH);
end

function clickPlantButton(seed_name)
    local build_menu_opened = false
    while not build_menu_opened do
        local plantButton = findText(seed_name)
        if plantButton then
            local spot = getWaitSpotAt(Vector:new{5,5})
            clickText(plantButton, 1)
            build_menu_opened = waitForChange(spot,click_delay*5)
        else
            error("Text " .. seed_name .. " Not found.")
        end
        sleepWithStatus(tick_delay, "Retrying build menu open...")
    end
end

function getBoxPixels(box)
    local pixels = {}
    iterateBoxPixels(box,
        function(x,y,pixel)
            pixels[y][x] = pixel
        end,
        function(y)
            pixels[y] = {}
        end
    )
    return pixels
end

-- Finds a row of pixels which have changed in the current ReadScreen buffer compared to a given 2d array of pixels.
function findChangedRow(box, pixels, func)
    if DEBUG then
        debugShowBox(box)
    end

    local changed = {}
    local new_pixels = {}
    iterateBoxPixels(box,
        function(x,y,pixel)
            changed[y][x] = pixels[y][x] ~= pixel
            new_pixels[y][x] = pixel
        end,
        function(y)
            changed[y] = {}
            new_pixels[y] = {}
        end
    )

    local search_from_left = box.direction.x <= 0
    local search_from_top = box.direction.y < 0

    local y_start, y_end, y_inc = 0, math.floor(box.height/MATCH_GRID_SIZE)-1, 1
    if not search_from_top then
        y_start, y_end, y_inc = y_end, y_start, -1
    end
    local x_start, x_end, x_inc = 0, math.floor(box.width/MATCH_GRID_SIZE)-1, 1
    if not search_from_left then
        x_start, x_end, x_inc = x_end, x_start, -1
    end

    for y=y_start,y_end,y_inc do
        for x=x_start,x_end,x_inc do
            local all_changed = true
            for j=0,MATCH_GRID_SIZE-1 do
                for k=0,MATCH_GRID_SIZE-1 do
                    local changed_x = x*MATCH_GRID_SIZE+k
                    local changed_y = y*MATCH_GRID_SIZE+j
                    all_changed = all_changed and changed[changed_y][changed_x]
                end
            end
            if all_changed then
                local grid_centre_x = x*MATCH_GRID_SIZE + math.floor(MATCH_GRID_SIZE/2)
                local grid_centre_y = y*MATCH_GRID_SIZE + math.floor(MATCH_GRID_SIZE/2)
                func(Vector:new{box.left + grid_centre_x,box.top + grid_centre_y},new_pixels)
                return true
            end
        end
    end
    return false
end

function debugShowBox(box)
    srSetMousePos(box.left, box.top)
    sleepWithStatus(2000, "TOP LEFT")
    srSetMousePos(box.right, box.bottom)
    sleepWithStatus(2000, "BOT RIGHT")
end

function inside(vector,box)
    local x, y = vector.x, vector.y
    return (x >= box.left and x <= box.right) and (y >= box.top and y <= box.bottom)
end

function distanceCentre(vector)
    local mid = getScreenMiddle()
    local delta = vector - mid

    local dx = math.pow(delta.x,2)
    local dy = math.pow(delta.y,2)

    return math.sqrt(dx + dy)
end

function iterateBoxPixels(box, xy_func, y_func)
    srReadScreen()


    for y=0,box.height,1 do
        if y_func then y_func(y) end
        for x=0, box.width do
            local pixel = srReadPixelFromBuffer(box.left + x, box.top + y)
            if xy_func(x,y,pixel) then
                return
            end
        end
        checkBreak()
    end
end


-- Used to place gui elements sucessively.
current_y = 0
-- How far off the left hand side to place gui elements.
X_PADDING = 5

function getUserParams()
    local is_done = false
    local got_user_params = false
    local config = {alternate_drag=readSetting("alternate_drag")}
    local seed_index = readSetting("seed_index",1)
    local display_seed_names = {}
    for i=1,5 do
        display_seed_names[i] = SEED_NAMES[i] .. " (" .. SEED_TYPES[i] .. ")"
    end
    while not is_done do
        current_y = 10

        if not got_user_params then
            local max_plants       = MAX_PLANTS
            seed_index             = lsDropdown("seed_name", X_PADDING, current_y, 10, lsScreenX - 10, seed_index, display_seed_names)
            current_y = 50
            config.num_plants      = drawNumberEditBox("num_plants", "How many to plant per run? Max " .. max_plants, 13)
            config.num_runs        = drawNumberEditBox("num_runs", "How many runs? ", 20)
            config.click_delay     = drawNumberEditBox("click_delay", "What should the click delay be? ", 50)
            config.alternate_drag = lsCheckBox(X_PADDING, current_y, 10, WHITE, "Alternate (slow) dragging?", config.alternate_drag)
            got_user_params = true
            for k,v in pairs(config) do
                got_user_params = got_user_params and v
            end
            got_user_params = got_user_params and drawBottomButton(lsScreenX - 5, "Next step")
        else
            drawWrappedText(WARNING, RED, X_PADDING, current_y)

            is_done = drawBottomButton(lsScreenX - 5, "Start Script")
        end

        if drawBottomButton(110, "Exit Script") then
            error "Script exited by user"
        end

        lsDoFrame()
        lsSleep(10)
    end

    writeSetting("seed_index",seed_index)
    writeSetting("alternate_drag",config.alternate_drag)
    config.num_plants = limitMaxPlants(config.num_plants)
    config.seed_name = SEED_NAMES[seed_index]
    config.num_waterings = config.seed_name == LEEKS and 3 or 2
    click_delay = config.click_delay
    return config
end

function limitMaxPlants(user_supplied_max_num)
    return math.min(12, user_supplied_max_num)
end

function drawNumberEditBox(key, text, default)
    return drawEditBox(key, text, default, true)
end

function drawEditBox(key, text, default, validateNumber)
    drawTextUsingCurrent(text, WHITE)
    local width = validateNumber and 50 or 200
    local height = 30
    local done, result = lsEditBox(key, X_PADDING, current_y, 0, width, height, 1.0, 1.0, BLACK, default)
    if validateNumber then
        result = tonumber(result)
    elseif result == "" then
        result = false
    end
    if not result then
        local error = validateNumber and "Please enter a valid number!" or "Enter text!"
        drawText(error, RED, X_PADDING + width + 5, current_y + 5)
        result = false
    end
    current_y = current_y + 35
    return result
end

function drawTextUsingCurrent(text, colour)
    drawText(text, colour, X_PADDING, current_y)
    current_y = current_y + 20
end
function drawText(text, colour, x, y)
    lsPrint(x, y, 10, 0.7, 0.7, colour, text)
end

function drawWrappedText(text, colour, x, y)
    lsPrintWrapped(x, y, 10, lsScreenX-10, 0.6, 0.6, colour, text)
end

function drawBottomButton(xOffset, text)
    return lsButtonText(lsScreenX - xOffset, lsScreenY - 30, z, 100, WHITE, text)
end

-- Simple immutable vector class
Vector={}
function Vector:new(o)
    o.x = o.x or o[1]
    o.y = o.y or o[2]
    return newObject(self, o, true)
end

function Vector:__add(vector)
    local x,y = Vector.getXY(vector)
    return Vector:new{self.x + x, self.y + y}
end

function Vector:__sub(vector)
    local x,y = Vector.getXY(vector)
    return Vector:new{self.x - x, self.y - y}
end

function Vector:__div(divisor)
    return Vector:new{self.x / divisor, self.y / divisor}
end

function Vector:__mul(multiplicand)
    return Vector:new{self.x * multiplicand, self.y * multiplicand}
end

function Vector.getXY(vector)
    return vector.x or vector[1], vector.y or vector[2]
end

function Vector:length()
    return math.sqrt(self.x^2 + self.y^2)
end

function Vector:normalize()
    return self / self:length()
end

function Vector:__tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end



function click(vector, right_click, show_mouse)
    if show_mouse then
        srClickMouse(vector.x, vector.y, right_click)
    else
        safeClick(vector.x, vector.y, right_click)
    end
    lsSleep(click_delay)
end

function moveMouse(vector)
    srSetMousePos(vector.x, vector.y)
    lsSleep(click_delay)
end

function getWaitSpotAt(vector)
    return getWaitSpot(vector.x, vector.y)
end

-- Helper function used in an objects constructor to setup its metatable correctly allowing for basic inheritence.
function newObject(class, o, read_only)
    o = o or {}
    setmetatable(o, class)
    class.__index = class
    if read_only then
        makeReadOnly(o)
    end
    return o
end

function makeReadOnly(table)
    local mt = getmetatable(table)
    if not mt then
        mt = {}
        if not table then print(debug.traceback()) end
        setmetatable(table,mt)
    end
    mt.__newindex = function(t,k,v)
        error("Attempt to update a read-only table", 2)
    end
    return table
end
