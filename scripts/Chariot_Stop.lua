--Chariot Stop v1.1 by Safa
--Thanks to Dreger for getCurrentRegion() function.
--This macro will travel to desired destination using shortest path when possible. It has to read your location from clock up top. (Use /clockloc command to open it if missing.) Do NOT walk while macro is running. Do NOT pin chariot windows. You can chat or minimize VT if you wish. Please re-open Chariot window after travel.
dofile("screen_reader_common.inc");
dofile("ui_utils.inc");
dofile("common.inc");

--Introduction
askForWindow("Chariot_Stop v1.1 (by Safa) This macro will travel to desired destination using shortest path when possible. It has to read your location from clock up top. (Use /clockloc command to open it if missing.) Do NOT walk while macro is running. Do NOT pin chariot windows. You can chat or minimize VT if you wish. Please re-open Chariot window after travel.") ;

--debugging
function spacer()
	lsPrintln(" ");
	lsPrintln(" ");
	lsPrintln(" ");
end

function clearconsole()
	for i =1,20 do
		lsPrintln(" ");
	end
end

clearconsole();
-- / debugging

function checkCS()
-- Loop if CS window not present.
srReadScreen();
cs = srFindImage("chariot/cs.png", 5000);
while not cs do
	srReadScreen();
	cs = srFindImage("chariot/cs.png", 5000);
	sleepWithStatus(4000, "Can't see Chariot Window!");
	lsPlaySound("AnvilHit.wav");
end
end

-- returns the text string for the current region from the clock window or nil if not found.
function getCurrentRegion()
	lsPrintln("Starting getCurrentRegion");
	srReadScreen();

	anchor = findText("Year");
	if(not anchor) then
		anchor = findText("ar 1");
	end
	if(not anchor) then
		anchor = findText("ar 2");
	end
	if(not anchor) then
		anchor = findText("ar 3");
	end
	if(not anchor) then
		anchor = findText("ar 4");
	end
	if(not anchor) then
		anchor = findText("ar 5");
	end
	if(not anchor) then
		anchor = findText("ar 6");
	end
	if(not anchor) then
		anchor = findText("ar 7");
	end
	if(not anchor) then
		anchor = findText("ar 8");
	end
	if(not anchor) then
		anchor = findText("ar 9");
	end

	if anchor then
		window = getWindowBorders(anchor[0], anchor[1]);
		lines = findAllText(nil, window, nil, NOPIN);
		regionCoords = table.concat(lines[2], ",");
		regionAndCoords = string.sub(regionCoords,string.find(regionCoords,",") + 1);
		region = string.sub(regionAndCoords, 0,  string.find(regionAndCoords,":") - 1);
		return region;
	end
	return nil;
end

-- All Regions
regions = {"Cat's Claw Ridge", "Cradle of Sun", "Desert of Nomads", "Desert of Shades", "Eastern Grounds", "Four Corners", "Lake of Reeds",  "Memphis", "Midland Valley", "Old Egypt", "River Plains", "Seven Lakes", "Sinai", "South Egypt", "Valley of Kings"};
-- Adjacents
toCCR = {"Old Egypt", "Valley of Kings", "X"};
toCOS = {"Seven Lakes", "X", "X"};
toDON = {"Lake of Reeds", "Old Egypt", "Sinai"};
toDOS = {"River Plains", "Valley of Kings", "X"};
toEG = {"South Egypt", "X", "X"};
toFC = {"Midland Valley","X","X"};
toLR = {"Desert of Nomads", "Sinai", "X"};
toM = {"South Egypt", "X", "X"};
toMV = {"Four Corners", "Old Egypt","River Plains"};
toOE = {"Cat's Claw Ridge", "Desert of Nomads", "Midland Valley"};
toRP = {"Desert of Shades","Midland Valley","Seven Lakes"};
to7L = {"Cradle of Sun", "River Plains", "South Egypt"};
toS = {"Desert of Nomads", "Lake of Reeds"};
toSE = {"Eastern Grounds", "Memphis", "Seven Lakes"};
toVOK = {"Cat's Claw Ridge", "Desert of Shades", "X"};


--Adjacent Distances
--CCR
function CCR()
	far1 = {"Valley of Kings", "Old Egypt"};
	far2 = {"Midland Valley", "Desert of Nomads"};
	far3 = {"Lake of Reeds", "Sinai", "River Plains", "Four Corners"};
	far4 = {"Seven Lakes"};
	far5 = {"South Egypt", "Cradle of Sun"};
	far6 = {"Memphis", "Eastern Grounds"};
end
--COS
function COS()
	far1 = {"Seven Lakes"};
	far2 = {"River Plains", "South Egypt"};
	far3 = {"Desert of Shades", "Midland Valley", "Memphis", "Eastern Grounds"};
	far4 = {"Four Corners", "Valley of Kings", "Old Egypt"};
	far5 = {"Cat's Claw Ridge", "Desert of Nomads"};
	far6 = {"Lake of Reeds", "Sinai"};
end
--DON
function DON()
	far1 = {"Lake of Reeds", "Sinai", "Old Egypt"};
	far2 = {"Cat's Claw Ridge", "Midland Valley"};
	far3 = {"Valley of Kings", "Four Corners", "River Plains"};
	far4 = {"Desert of Shades", "Seven Lakes"};
	far5 = {"Cradle of Sun", "South Egypt"};
	far6 = {"Memphis", "Eastern Grounds"};
end
--DOS
function DOS()
	far1 = {"Valley of Kings", "River Plains"};
	far2 = {"Cat's Claw Ridge", "Midland Valley", "Seven Lakes"};
	far3 = {"Old Egypt", "Four Corners", "Cradle of Sun", "South Egypt"};
	far4 = {"Desert of Nomads", "Memphis", "Eastern Grounds"};
	far5 = {"Lake of Reeds", "Sinai"};
end
--EG
function EG()
	far1 = {"South Egypt"};
	far2 = {"Memphis", "Seven Lakes"};
	far3 = {"Cradle of Sun", "River Plains"};
	far4 = {"Desert of Shades", "Midland Valley"};
	far5 = {"Valley of Kings", "Four Corners", "Old Egypt"};
	far6 = {"Cat's Claw Ridge", "Desert of Nomads"};
	far7 = {"Lake of Reeds", "Sinai"};
end
--FC
function FC()
	far1 = {"Midland Valley"};
	far2 = {"Old Egypt", "River Plains"};
	far3 = {"Cat's Claw Ridge", "Desert of Nomads", "Desert of Shades", "Seven Lakes"};
	far4 = {"Lake of Reeds", "Sinai", "Valley of Kings", "Cradle of Sun"};
	far5 = {"South Egypt"};
	far6 = {"Memphis", "Eastern Grounds"};
end
--LR
function LR()
	far1 = {"Desert of Nomads", "Sinai"};
	far2 = {"Old Egypt"};
	far3 = {"Cat's Claw Ridge", "Midland Valley"};
	far4 = {"Valley of Kings", "Four Corners", "River Plains"};
	far5 = {"Desert of Shades", "Seven Lakes"};
	far6 = {"Cradle of Sun", "South Egypt"};
	far7 = {"Memphis", "Eastern Grounds"};
end
--M
function M()
	far1 = {"South Egypt"};
	far2 = {"Eastern Grounds", "Seven Lakes"};
	far3 = {"Cradle of Sun", "River Plains",};
	far4 = {"Desert of Shades", "Midland Valley"};
	far5 = {"Valley of Kings", "Four Corners", "Old Egypt"};
	far6 = {"Cat's Claw Ridge", "Desert of Nomads"};
	far7 = {"Lake of Reeds", "Sinai"};
end
--MV
function MV()
	far1 = {"Old Egypt", "River Plains", "Four Corners"};
	far2 = {"Cat's Claw Ridge", "Desert of Nomads", "Desert of Shades", "Seven Lakes"};
	far3 = {"Valley of Kings", "Lake of Reeds", "Sinai", "Cradle of Sun", "South Egypt"};
	far4 = {"Memphis", "Eastern Grounds"};
end
--OE
function OE()
	far1 = {"Cat's Claw Ridge", "Desert of Nomads", "Midland Valley"};
	far2 = {"Valley of Kings", "Four Corners", "River Plains", "Lake of Reeds", "Sinai"};
	far3 = {"Desert of Shades", "Seven Lakes"};
	far4 = {"Cradle of Sun", "South Egypt"};
	far5 = {"Memphis", "Eastern Grounds"};
end
--RP
function RP()
	far1 = {"Midland Valley", "Desert of Shades", "Seven Lakes"};
	far2 = {"Four Corners", "Old Egypt", "Cradle of Sun"};
	far3 = {"Cat's Claw Ridge", "Desert of Nomads", "South Egypt"};
	far4 = {"Valley of Kings", "Lake of Reeds", "Sinai", "Memphis", "Eastern Grounds"};
end
--7L
function SevenL()
	far1 = {"River Plains", "Cradle of Sun", "South Egypt"};
	far2 = {"Memphis", "Eastern Grounds", "Midland Valley", "Desert of Shades"};
	far3 = {"Four Corners", "Valley of Kings", "Old Egypt"};
	far4 = {"Cat's Claw Ridge", "Desert of Nomads"};
	far5 = {"Lake of Reeds", "Sinai"};
end
--S
function S()
	far1 = {"Lake of Reeds", "Desert of Nomads"};
	far2 = {"Old Egypt"};
	far3 = {"Cat's Claw Ridge", "Midland Valley"};
	far4 = {"Valley of Kings", "Four Corners", "River Plains"};
	far5 = {"Desert of Shades", "Seven Lakes"};
	far6 = {"Cradle of Sun", "South Egypt"};
	far7 = {"Memphis", "Eastern Grounds"};
end
--SE
function SE()
	far1 = {"Memphis", "Eastern Grounds", "Seven Lakes"};
	far2 = {"Cradle of Sun", "River Plains"};
	far3 = {"Desert of Shades", "Midland Valley"};
	far4 = {"Valley of Kings", "Four Corners", "Old Egypt"};
	far5 = {"Cat's Claw Ridge", "Desert of Nomads"};
	far6 = {"Lake of Reeds", "Sinai"};
end
--VOK
function VOK()
	far1 = {"Cat's Claw Ridge", "Desert of Shades"};
	far2 = {"Old Egypt", "River Plains"};
	far3 = {"Desert of Nomads", "Midland Valley", "Seven Lakes"};
	far4 = {"Four Corners", "Cradle of Sun", "South Egypt"};
	far5 = {"Memphis", "Eastern Grounds"};
end

--WHEREAMI
whereami = getCurrentRegion();
adjacent = {};
firstTimeRunning = "Yes";

if not whereami then
	error "Couldn't region region. Please zoom in until night sky isn't visible."
end

--Get adjacent regions.
function getAdjacent()
	if whereami == "Cat's Claw Ridge" then
		adjacent = toCCR;
		elseif whereami == "Cradle of the Sun" then
			adjacent = toCOS;
			elseif whereami == "Desert of Nomads" then
				adjacent = toDON;
				elseif whereami == "Desert of Shades" then
					adjacent = toDOS;
					elseif whereami == "Eastern Grounds" then
						adjacent = toEG;
						elseif whereami == "Four Corners" then
							adjacent = toFC;
							elseif whereami == "Lake of Reeds" then
								adjacent = toLR;
								elseif whereami == "Memphis" then
									adjacent = toM;
									elseif whereami == "Midland Valley" then
										adjacent = toMV;
										elseif whereami == "Old Egypt" then
											adjacent = toOE;
											elseif whereami == "River Plains" then
												adjacent = toRP;
												elseif whereami == "Seven Lakes" then
													adjacent = to7L;
													elseif whereami == "Sinai" then
														adjacent = toS;
														elseif whereami == "South Egypt" then
															adjacent = toSE;
															elseif whereami == "Valley of the Kings" then
																adjacent = toVOK;
															end
															lsPrintln("Adjacent to " .. whereami .. "  :  " .. adjacent[1] .. " , " .. adjacent[2] .. "  , " .. adjacent[3]);
															spacer();
														end


--Needs destination to be not nil;
function pathfind()
	stack = {};
	local path_done = nil;
	while not path_done do	
		lsPrintln("Pathfinding...");
		lsPrintln("whereami:   " .. whereami .. "  destination:   " .. destination);


--Get adjacent regions.
getAdjacent();


if adjacent[1] == destination then
	stack[#stack + 1] = adjacent[1];
	path_done = 1;
	elseif adjacent[2] == destination then
		stack[#stack + 1] = adjacent[2];
		path_done = 1;
		elseif adjacent[3] == destination then
			stack[#stack + 1] = adjacent[3];
			path_done = 1;
		else
--Adjacents don't match destination.

--Start comparing adjacents & nearby adjacents for distance to destination.

if destination == "Cat's Claw Ridge" then
	CCR();
	elseif destination == "Cradle of Sun" then
		COS();
		elseif destination == "Desert of Nomads" then
			DON();
			elseif destination == "Desert of Shades" then
				DOS();
				elseif destination == "Eastern Grounds" then
					EG();
					elseif destination == "Four Corners" then
						FC();
						elseif destination == "Lake of Reeds" then
							LR();
							elseif destination == "Memphis" then
								M();
								elseif destination == "Midland Valley" then
									MV();
									elseif destination == "Old Egypt" then
										OE();
										elseif destination == "River Plains" then
											RP();
											elseif destination == "Seven Lakes" then
												SevenL();
												elseif destination == "Sinai" then
													S();
													elseif destination == "South Egypt" then
														SE();
														elseif destination == "Valley of Kings" then
															VOK();
														end

														stackChanged ="No";
--far1
for i=1, #far1 do
	if adjacent[1] == far1[i] then
		stack[#stack + 1] = far1[i]
		i = #far1
		stackChanged ="Yes";
		elseif adjacent[2] == far1[i] then
			stack[#stack + 1] = far1[i]
			i = #far1
			stackChanged ="Yes";
			elseif adjacent[3] == far1[i] then
				stack[#stack + 1] = far1[i]
				i = #far1
				stackChanged ="Yes";
			end
		end
--far2
if stackChanged == "No" then
	for i=1, #far2 do
		if adjacent[1] == far2[i] then
			stack[#stack + 1] = far2[i]
			i = #far2
			stackChanged ="Yes";
			elseif adjacent[2] == far2[i] then
				stack[#stack + 1] = far2[i]
				i = #far2
				stackChanged ="Yes";
				elseif adjacent[3] == far2[i] then
					stack[#stack + 1] = far2[i]
					i = #far2
					stackChanged ="Yes";
				end
			end		
		end
--far3
if stackChanged == "No" then
	for i=1, #far3 do
		if adjacent[1] == far3[i] then
			stack[#stack + 1] = far3[i]
			i = #far3
			stackChanged ="Yes";
			elseif adjacent[2] == far3[i] then
				stack[#stack + 1] = far3[i]
				i = #far3
				stackChanged ="Yes";
				elseif adjacent[3] == far3[i] then
					stack[#stack + 1] = far3[i]
					i = #far3
					stackChanged ="Yes";
				end
			end		
		end
--far4
if stackChanged == "No" then
	for i=1, #far4 do
		if adjacent[1] == far4[i] then
			stack[#stack + 1] = far4[i]
			i = #far4
			stackChanged ="Yes";
			elseif adjacent[2] == far4[i] then
				stack[#stack + 1] = far4[i]
				i = #far4
				stackChanged ="Yes";
				elseif adjacent[3] == far4[i] then
					stack[#stack + 1] = far4[i]
					i = #far4
					stackChanged ="Yes";
				end
			end		
		end
--far5
if stackChanged == "No" then
	for i=1, #far5 do
		if adjacent[1] == far5[i] then
			stack[#stack + 1] = far5[i]
			i = #far5
			stackChanged ="Yes";
			elseif adjacent[2] == far5[i] then
				stack[#stack + 1] = far5[i]
				i = #far5
				stackChanged ="Yes";
				elseif adjacent[3] == far5[i] then
					stack[#stack + 1] = far5[i]
					i = #far5
					stackChanged ="Yes";
				end
			end		
		end
--far6
if stackChanged == "No" then
	for i=1, #far6 do
		if adjacent[1] == far6[i] then
			stack[#stack + 1] = far6[i]
			i = #far6
			stackChanged ="Yes";
			elseif adjacent[2] == far6[i] then
				stack[#stack + 1] = far6[i]
				i = #far6
				stackChanged ="Yes";
				elseif adjacent[3] == far6[i] then
					stack[#stack + 1] = far6[i]
					i = #far6
					stackChanged ="Yes";
				end
			end		
		end
--far7
if stackChanged == "No" then
	for i=1, #far7 do
		if adjacent[1] == far7[i] then
			stack[#stack + 1] = far7[i]
			i = #far7
			stackChanged ="Yes";
			elseif adjacent[2] == far7[i] then
				stack[#stack + 1] = far7[i]
				i = #far7
				stackChanged ="Yes";
				elseif adjacent[3] == far7[i] then
					stack[#stack + 1] = far7[i]
					i = #far7
					stackChanged ="Yes";
				end
			end		
		end
		if stackChanged == "No" then
			error "Something went wrong!";	
		end

		whereami = stack[#stack];	

	end
	lsPrintln("endloop");
end
end



function doit()
	while 1 do

		getAdjacent();
		button_names = {adjacent[1], adjacent[2], adjacent[3]};
		if not stack then

-- Ask for which button
local image_name = nil;
local is_done = nil;	
while not is_done do
	local y = nil;
	local x = nil;
	local bsize = nil;
	x = 30;
	y = 30;
	if not destination then
		lsPrintWrapped(90, 10, 10, lsScreenX - 10, 0.6, 0.6, 0xFFFFFFff, "Choose a destination:");
	else
		lsPrintWrapped(45, 10, 10, lsScreenX - 10, 0.6, 0.6, 0x80ff80ff, "Destination selected as: ".. destination);
	end
	for i=1, #button_names do
		if button_names[i] == "X" then
--Do Nothing
else	
	if lsButtonText(x, y, 0, lsScreenX - 50, 0x80ff80ff, button_names[i]) then
		image_name = button_names[i];
		is_done = 1;
	end
end
y = y+30;
end


if lsButtonText(x, y, 0, lsScreenX - 50, 0xffff80ff, "Travel to...") then
	image_name = "Travel to...";
	is_done = 1;
end

if lsButtonText(lsScreenX - 220, lsScreenY - 30, z, 150, 0xFF0000ff, "Dismount") then
	error "Clicked End Script button";
end
lsDoFrame();
lsSleep(10);
end	

if image_name == button_names[1] then		
--Adjacent selected as destination
destination = button_names[1];
pathfind();

elseif image_name == button_names[2] then
--Adjacent selected as destination
destination = button_names[2];
pathfind();

elseif image_name == button_names[3] then
--Adjacent selected as destination
destination = button_names[3];
pathfind();

elseif image_name == "Travel to..." then
--"Travel to" pressed, ask which region to travel to.
local travel_to = nil;
local is_done = nil;	
while not is_done do
	local y = nil;
	local x = nil;
	local bsize = nil;
	x = 30;
	y = 0;
	for i=1, #regions do							
		if lsButtonText(x, y, 0, lsScreenX - 50, 0x80ff80ff, regions[i]) then
			destination = regions[i];
			is_done = 1;
		end
		y = y+30;
	end

	if lsButtonText(lsScreenX - 220, lsScreenY - 30, z, 150, 0xFF0000ff, "Dismount") then
		error "Clicked End Script button";
	end
	lsDoFrame();
	lsSleep(10);
end
pathfind();
end
end
--if not stack end
--Get ready for travel
if firstTimeRunning == "Yes" then
	lsPrintWrapped(0, 10, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Securing the saddle...");
	lsDoFrame();
	lsSleep(500);
	lsPrintWrapped(0, 10, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Securing the saddle...");
	lsPrintWrapped(0, 25, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Cleaning horseshoes...");
	lsDoFrame();
	lsSleep(500);
	lsPrintWrapped(0, 10, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Securing the saddle...");
	lsPrintWrapped(0, 25, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Cleaning horseshoes...");
	lsPrintWrapped(0, 40, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Brushing hair...");
	lsDoFrame();
	lsSleep(500);
	lsPrintWrapped(0, 10, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Securing the saddle...");
	lsPrintWrapped(0, 25, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Cleaning horseshoes...");
	lsPrintWrapped(0, 40, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Brushing hair...");
	lsPlaySound("snort.wav");
	lsPrintWrapped(0, 55, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Whispering ".. destination .." to horses...");
	lsDoFrame();
	lsSleep(500);
	lsPrintWrapped(0, 10, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Securing the saddle...");
	lsPrintWrapped(0, 25, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Cleaning horseshoes...");
	lsPrintWrapped(0, 40, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Brushing hair...");
	lsPrintWrapped(0, 55, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Whispering ".. destination .." to horses...");
	lsPrintWrapped(0, 70, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Clicking tongue...");
	lsDoFrame();
	lsSleep(1000);
	firstTimeRunning = "No";
end	


--Stash CS
checkCS();
safeDrag(cs[0], cs[1], 10, 10);
sleepWithStatus(1000, "Stashing chariot...");
whereami = getCurrentRegion();
getAdjacent();
--Select Destination
if stack[1] == adjacent[1] then
	safeClick(30, 85);

	elseif stack[1] == adjacent[2] then
		safeClick(30, 100);

		elseif stack[1] == adjacent[3] then
			safeClick(30, 120);

		else
			error "Stack[1] doesn't match adjacents."

		end

--Stash Region window to 290, 10

sleepWithStatus(1000, "Stashing destination...");
srReadScreen();
regionwindow = srFindImage("chariot/travelto.png", 5000);
safeDrag(regionwindow[0], regionwindow[1], 290, 10);


--function checkFREE()
-- Check for free travel.
srReadScreen();
FREE = srFindImage("chariot/travelfree.png", 5000);
regionwindow = srFindImage("chariot/travelto.png", 5000);
tt = srFindImage("chariot/tt.png", 5000);
useTT = nil;
while not FREE do
	if alwayswhip then
		safeClick(tt[0], tt[1], rightclick);
		useTT = 1;

		sleepWithStatus(1000, "Waiting for Yes promt...");
		srReadScreen();
		yes = srFindImage("chariot/yes.png", 5000);
		safeClick(yes[0], yes[1], rightclick);
		if #stack == 1 then
			sleepWithStatus(4000, "Travelling...");
		else
			lsPlaySound("gallop.wav");
			sleepWithStatus(4000, "Travelling...");
		end
		FREE = 1;
	else


		srReadScreen();
		FREE = srFindImage("chariot/travelfree.png", 5000);	
--Buttons
lsPrintWrapped(90, 10, 10, lsScreenX - 10, 0.6, 0.6, 0x80ff80ff, "Waiting for Free Travel");
if lsButtonText(30, 25, 0, lsScreenX - 50, 0x80ff80ff, "Whip horses once") then
	safeClick(tt[0], tt[1], rightclick);
	useTT = 1;

	sleepWithStatus(1000, "Waiting for Yes promt...");
	srReadScreen();
	yes = srFindImage("chariot/yes.png", 5000);
	safeClick(yes[0], yes[1], rightclick);
	if #stack == 1 then
		sleepWithStatus(4000, "Travelling...");
	else
		lsPlaySound("gallop.wav");
		sleepWithStatus(4000, "Travelling...");
	end
	FREE = 1;
end
if lsButtonText(30, 55, 0, lsScreenX - 50, 0x80ff80ff, "Whip horses every stop") then
	alwayswhip = 1;
end
if lsButtonText(30, 85, 0, lsScreenX - 50, 0xFF0000ff, "Dismount") then
	error "Clicked End Script button";
end

--Report
lsPrintWrapped(30, 110, 10, lsScreenX - 10, 0.6, 0.6, 0x80ff80ff, "Destination:   ".. destination);
lsPrintWrapped(30, 125, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, "Route:");
y = 125;
for i=1,#stack do
	y = y + 15;
	lsPrintWrapped(30, y, 10, lsScreenX - 10, 0.6, 0.6, 0xffff80ff, i.. " >> ".. stack[i]);
end


lsDoFrame();
lsSleep(100);

--If waiting for Free Travel, refresh region window.
if not useTT then
	if tt then
		safeClick(290, 10, rightclick);
	else
		error "Region window missing!"
	end
end
end
end
--end
if not useTT then
	srReadScreen();
	FREE = srFindImage("chariot/travelfree.png", 5000);
	if FREE then
		safeClick(FREE[0], FREE[1], rightclick);
		if #stack == 1 then
			sleepWithStatus(4000, "Travelling...");
		else
			lsPlaySound("gallop.wav");
			sleepWithStatus(4000, "Travelling...");
		end
	else
		error "Region window missing!";
	end
end
--Clear first item of the stack and move the rest to left.
for i=1, #stack do
	stack[i] = stack[i + 1];
end
--REACHED?	
if not stack[1] then
	lsPlaySound("horsewalk.wav");
	lsSleep(3000);
	lsPlaySound("longsnort.wav");
	error "You reach your destination and dismount your horse.";
end
end
end
