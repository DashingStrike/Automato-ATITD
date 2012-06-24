

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();
loadfile("luaScripts/common.inc")();
loadfile("luaScripts/serialize.inc")();

routeFileName = "gatherRoutes.txt";
defaultRoutesFileName = "luaScripts\\defaultRoutes.inc";
routes = {};
routeNames = {};

Waypoint = 1;
Bonfire = 2;
Warehouse = 3;
WindriverPalm = 4;
UmbrellaPalm = 5;
ToweringPalm = 6;
TinyOilPalm = 7;
Tapacae = 8;
StoutPalm = 9;
SpindleTree = 10;
SpikedFishTree = 11;
RoyalPalm = 12;
RedMaple = 13;
RazorPalm = 14;
Ranyahn = 15;
PhoenixPalm = 16;
Passam = 17;
Orrorin = 18;
Oleaceae = 19;
OilPalm = 20;
MonkeyPalm = 21;
MiniPalmetto = 22;
MiniatureFernPalm = 23;
LocustPalm = 24;
Kaeshra = 25;
Hokkaido = 26;
Hawthorn = 27;
GiantCricklewood = 28;
FoldedBirch = 29;
FernPalm = 30;
FeatherTree = 31;
Elephantia = 32;
DeltaPalm = 33;
Cricklewood = 34;
CoconutPalm = 35;
Cinnar = 36;
Chicory = 37;
ChakkanutTree = 38;
CeruleanBlue = 39;
ButterleafTree = 40;
BroadLeafPalm = 41;
BrambleHedge = 42;
BrambleHedge = 43;
BottleTree = 44;
Bloodbark = 45;
Beetlenut = 46;
AshPalm = 47;
Anaxi = 48;

WaypointTypes = {};
WaypointTypes[Waypoint] = "Waypoint";
WaypointTypes[Bonfire] = "Bonfire";
WaypointTypes[Warehouse] = "Warehouse";
WaypointTypes[ToweringPalm] = "Towering Palm";
WaypointTypes[RoyalPalm] = "Royal Palm";
WaypointTypes[StoutPalm] = "Stout Palm";
WaypointTypes[FernPalm] = "Fern Palm";
WaypointTypes[BottleTree] = "Bottle Tree";
WaypointTypes[Hokkaido] = "Hokkaido";
WaypointTypes[Ranyahn] = "Ranyahn";
WaypointTypes[BrambleHedge] = "Bramble Hedge";
WaypointTypes[CeruleanBlue] = "Cerulean Blue";
WaypointTypes[Bloodbark] = "Bloodbark";
WaypointTypes[Beetlenut] = "Beetlenut";
WaypointTypes[DeltaPalm] = "Delta Palm";
WaypointTypes[OilPalm] = "Oil Palm";
WaypointTypes[TinyOilPalm] = "Tiny Oil Palm";
WaypointTypes[Chicory] = "Chicory";
WaypointTypes[SpikedFishTree] = "Spiked Fish Tree";
WaypointTypes[PhoenixPalm] = "Phoenix Palm";
WaypointTypes[RedMaple] = "Red Maple";
WaypointTypes[Elephantia] = "Elephantia";
WaypointTypes[Passam] = "Passam";
WaypointTypes[SpindleTree] = "Spindle Tree";
WaypointTypes[UmbrellaPalm] = "Umbrella Palm";
WaypointTypes[WindriverPalm] = "Windriver Palm";
WaypointTypes[Oleaceae] = "Oleaceae";
WaypointTypes[Cinnar] = "Cinnar";
WaypointTypes[FoldedBirch] = "Folded Birch";
WaypointTypes[RazorPalm] = "Razor Palm";
WaypointTypes[BroadLeafPalm] = "Broad Leaf Palm";
WaypointTypes[ButterleafTree] = "Butterleaf Tree";
WaypointTypes[Orrorin] = "Orrorin";
WaypointTypes[FeatherTree] = "Feather Tree";
WaypointTypes[AshPalm] = "Ash Palm";
WaypointTypes[Kaeshra] = "Kaeshra";
WaypointTypes[Tapacae] = "Tapacae";
WaypointTypes[CoconutPalm] = "Coconut Palm";
WaypointTypes[MonkeyPalm] = "Monkey Palm";
WaypointTypes[LocustPalm] = "Locust Palm";
WaypointTypes[ChakkanutTree] = "Chakkanut Tree";
WaypointTypes[Anaxi] = "Anaxi";
WaypointTypes[MiniPalmetto] = "Mini Palmetto";
WaypointTypes[MiniatureFernPalm] = "Miniature Fern Palm";
WaypointTypes[Hawthorn] = "Hawthorn";
WaypointTypes[BrambleHedge] = "BrambleHedge";
WaypointTypes[Cricklewood] = "Cricklewood";
WaypointTypes[GiantCricklewood] = "Giant Cricklewood";

WaypointColors = {};
WaypointColors[Bonfire] = 1329403647;
WaypointColors[Warehouse] = 959060991;
WaypointColors[ToweringPalm] = 2124039935;
WaypointColors[RoyalPalm] = 138019071;
WaypointColors[StoutPalm] = -1919065601;
WaypointColors[FernPalm] = -2070857985;
WaypointColors[BottleTree] = 983295;
WaypointColors[Hokkaido] = 676680447;
WaypointColors[Ranyahn] = 1731867647;
WaypointColors[BrambleHedge] = 1869507071;
WaypointColors[CeruleanBlue] = 1349224959;
WaypointColors[Bloodbark] = 1378758911;
WaypointColors[Beetlenut] = 924713471;
WaypointColors[DeltaPalm] = -1229005825;
WaypointColors[OilPalm] = 356385023;
WaypointColors[TinyOilPalm] = 2025007615;
WaypointColors[Chicory] = 1111971071;
WaypointColors[SpikedFishTree] = -974498817;
WaypointColors[PhoenixPalm] = -1533797889;
WaypointColors[RedMaple] = -1912602369;
WaypointColors[Elephantia] = 1146624511;
WaypointColors[Passam] = -1278889473;
WaypointColors[SpindleTree] = 1007026431;
WaypointColors[UmbrellaPalm] = 995229951;
WaypointColors[WindriverPalm] = 1179903;
WaypointColors[Oleaceae] = 857866751;
WaypointColors[Cinnar] = 807870463;
WaypointColors[FoldedBirch] = 1902663935;
WaypointColors[RazorPalm] = 671154431;
WaypointColors[BroadLeafPalm] = 1900884479;
WaypointColors[ButterleafTree] = -218765057;
WaypointColors[Orrorin] = -296088321;
WaypointColors[FeatherTree] = 321480447;
WaypointColors[AshPalm] = 620760319;
WaypointColors[Kaeshra] = -2096623105;
WaypointColors[Tapacae] = -1047501825;
WaypointColors[CoconutPalm] = -993551617;
WaypointColors[MonkeyPalm] = 1482119423;
WaypointColors[LocustPalm] = -2005639937;
WaypointColors[ChakkanutTree] = 1632002559;
WaypointColors[Anaxi] = 931172095;
WaypointColors[MiniPalmetto] = -1131076353;
WaypointColors[MiniatureFernPalm] = -926394113;
WaypointColors[Hawthorn] = 1212628735;
WaypointColors[BrambleHedge] = 909322239;
WaypointColors[Cricklewood] = 1478492415;
WaypointColors[GiantCricklewood] = 1293615359;

keyDelay = 30;

wood = false;
slate = false;
grass = false;
clay = false;
numJugs = 200;
emptyJugs = 0;
repeatForever = true;

gather_iterations = 0;
gather_randomNumber = 0;
unique = 0;


function doit()
	if(not promptOkay("WARNING! This macro requires your chats to be minimized and your \"Use arrow keys for movement\" option to be enabled.")) then
		return;
	end
	math.randomseed(lsGetTimer());
	gather_randomNumber = math.random();

	loadRoutes();
	queryRoute();
end

function updateUnique()
	gather_iterations = gather_iterations + 1;
	unique = gather_iterations .. "_" .. gather_randomNumber;
end

route = 0;

function queryRoute()
	local scale = 1.4;
	local z = 0;
	local done = false;
	local nada = nil;

	while not done do
		checkBreak();
		lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);
		local y = 10;
		lsPrint(5, y, z, 1, 1, 0xFFFFFFff, "Route:");
		y = y + 32;
		route = lsDropdown("routeToWalk" .. unique, 5, y, 0, 405, route, routeNames);
		y = y + 32;
		if lsButtonText(5, y, z, 80, 0xFFFFFFff, "New") then
			if(editRoute(#routeNames+1)) then
				route = #routeNames;
				updateUnique();
			end
		end
		if lsButtonText(93, y, z, 80, 0xFFFFFFff, "Edit") then
			editRoute(route);
		end
		if lsButtonText(181, y, z, 80, 0xFFFFFFff, "Delete") then
			if(promptOkay("Are you sure you want to delete route \"" .. routeNames[route]) .. "\"?") then
				if(deleteRoute(route)) then
					route = route - 1;
					if(route < 1) then
						route = 1;
					end
					updateUnique();
				end
			end
		end
		if lsButtonText(269, y, z, 142, 0xFFFFFFff, "Load defaults") then
			loadDefaults();
		end
		y = y + 64;
		wood = lsCheckBox(10, y, z, 0xFFFFFFff, "Gather wood", wood);
		y = y + 32;
		slate = lsCheckBox(10, y, z, 0xFFFFFFff, "Gather slate", slate);
		y = y + 32;
		grass = lsCheckBox(10, y, z, 0xFFFFFFff, "Gather grass", grass);
		y = y + 32;
		clay = lsCheckBox(10, y, z, 0xFFFFFFff, "Gather clay and flint", clay);
		y = y + 32;
		lsPrint(35, y+5, z, 1, 1, 0xFFFFFFff, "Number of jugs:");
		nada, numJugs = lsEditBox("jugCount", 
			200, y, z, 50, 30, scale, scale, 0x000000ff, numJugs);
		if (clay and (not tonumber(numJugs))) then
			lsPrint(35, y+32, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
		end
		y = y + 32;
		y = y + 32;
		repeatForever = lsCheckBox(10, y, z, 0xFFFFFFff, "Repeat forever", repeatForever);
		lsSetCamera(0,0,lsScreenX,lsScreenY);
		if lsButtonText(10, 320, z, 90, 0xFFFFFFff, "GO!") then
			if (clay and (not tonumber(numJugs))) then
				done = false;
			else
				followRoute(route);
			end
		end
		if lsButtonText(200, 320, z, 90, 0xFFFFFFff, "Exit") then
			done = true;
			return;
		end
		lsDoFrame();
		lsSleep(tick_delay);
	end
end

function deleteRoute(route)
	local temp = {};
	local i;
	local j;
	for i = 1, #routes do
		if(i < route) then
			j = i;
		else
			j = i - 1;
		end
		if(i ~= route) then
			temp[j] = {};
			temp[j][0] = routes[i][0];
			temp[j][1] = {};
			local k;
			for k = 1, #routes[i][1] do
				temp[j][1][k] = {};
				temp[j][1][k][1] = routes[i][1][k][1];
				temp[j][1][k][2] = routes[i][1][k][2];
				temp[j][1][k][3] = routes[i][1][k][3];
			end
		end
	end
	routes = {};
	for i = 1, #temp do
		routes[i] = {};
		routes[i][0] = temp[i][0];
		routes[i][1] = {};
		for j = 1, #temp[i][1] do
			routes[i][1][j] = {};
			routes[i][1][j][1] = temp[i][1][j][1];
			routes[i][1][j][2] = temp[i][1][j][2];
			routes[i][1][j][3] = temp[i][1][j][3];
		end
	end
	saveRoutes();
	return true;
end


function editRoute(route)
	local scale = 1.4;
	local z = 0;
	local done = nil;
	local nada = nil;
	
    lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);
--	lsScreenX = 500;
--	lsScreenY = 500;

	local thisRoute = {};
	if(route <= #routeNames) then
		thisRoute[0] = routes[route][0];
		thisRoute[1] = {};
		local i;
		for i = 1, #routes[route][1] do
			thisRoute[1][i] = {};
			thisRoute[1][i][1] = routes[route][1][i][1];
			thisRoute[1][i][2] = routes[route][1][i][2];
			thisRoute[1][i][3] = routes[route][1][i][3];
		end
	else
		thisRoute[0] = "";
		thisRoute[1] = {};
		thisRoute[1][1] = {};
		thisRoute[1][1][1] = 0;
		thisRoute[1][1][2] = 0;
		thisRoute[1][1][3] = 1;
	end
	
	updateUnique();
	while not done do
		checkBreak();
		local y = 10;
		lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);
		lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Route:");
		y = y + 32;
		done, thisRoute[0] = lsEditBox("routeName" .. unique, 
			5, y, z, 404, 30, scale, scale, 0x000000ff, thisRoute[0]);
		done = nil;
		y = y + 50;
		lsScrollAreaBegin("routeScrollArea" .. unique,
			5, y, z, 405, 330);
		y = y + 5;
		local i;
		local sy = 0;
		for i = 1, #thisRoute[1] do
			local x = 0;
			local coordw = 60;
			local waypointw = 195;
			local buttonw = 20;
			if lsButtonText(x, sy, z, buttonw, 0xFFFFFFff, "+") then
				thisRoute = insertWaypointAfter(i,thisRoute);
				updateUnique();
			end
			x = x + buttonw + 2;
			if lsButtonText(x, sy, z, buttonw, 0xFFFFFFff, "-") then
				thisRoute = deleteWaypoint(i, thisRoute);
				updateUnique();
			end
			x = x + buttonw + 2;
			if lsButtonText(x, sy, z, buttonw, 0xFFFFFFff, "G") then
				goto(i, thisRoute);
			end
			x = x + buttonw + 2;
			local t;
			if(#thisRoute[1] >= i) then
				t = thisRoute[1][i][1];
			end
			nada, t = lsEditBox("waypointX_" .. i .. "_" .. unique, 
				x, sy, z, coordw, 30, scale, scale, 0x000000ff, t);
			if(#thisRoute[1] >= i) then
				thisRoute[1][i][1] = t;
			end
			x = x + coordw + 2;
			if(#thisRoute[1] >= i) then
				t = thisRoute[1][i][2];
			end
			nada, t = lsEditBox("waypointY_" .. i .. "_" .. unique, 
				x, sy, z, coordw, 30, scale, scale, 0x000000ff, t);
			if(#thisRoute[1] >= i) then
				thisRoute[1][i][2] = t;
			end
			x = x + coordw + 2;
			if(#thisRoute[1] >= i) then
				t = thisRoute[1][i][3];
			end
			t = lsDropdown("waypointType_" .. i .. "_" .. unique, 
				x, sy, z, waypointw, t, WaypointTypes);
			if(#thisRoute[1] >= i) then
				thisRoute[1][i][3] = t;
			end
			x = x + waypointw*scale + 2;
			sy = sy + 32;
		end
		local height = math.max(#thisRoute[1],#WaypointTypes);
		lsScrollAreaEnd(32 * height);
		y = y + 362;
		done = nil;
		if lsButtonText(10, y, z, 90, 0xFFFFFFff, "Save") then
			if(routeText == "") then
				if(not PromptOkay("There's nothing to save.")) then
					done = false;
				end
			elseif(routeName == "") then
				if(not PromptOkay("Every route needs a name.")) then
					done = false;
				end
			else
				done = true;
				saveRoute(thisRoute,route);
				return true;
			end
		end
		if lsButtonText(190*scale, y, z, 90, 0xFFFFFFff, "Cancel") then
			routes = deserialize(routeFileName);
			done = true;
		end
		lsDoFrame();
		lsSleep(tick_delay);
	end
	return false;
end

function loadDefaults()
	if(not promptOkay("This will add all of the default routes to the end of your list of routes.")) then
		return;
	end
	d = {};
	d = deserialize(defaultRoutesFileName);
	local added = 0;
	local replaced = 0;
	local i;
	for i = 1, #d do
		local include = true;
		local replace = false;
		if(alreadyExists(d[i][0])) then
			if(promptOkay("Route \"" .. d[i][0] .. "\" already exists in your list.  Press Ok to replace yours with the default or Cancel to continue without loading this one.")) then
				replace = true;
			else
				include = false;
			end
		end
		if(include) then
			if(replace) then
				deleteNamedRoute(d[i][0]);
				replaced = replaced + 1;
			else
				added = added + 1;
			end
			local r = #routes + 1;
			routes[r] = {};
			routes[r][0] = d[i][0];
			routes[r][1] = {};
			local j
			for j = 1, #d[i][1] do
				routes[r][1][j] = {};
				routes[r][1][j][1] = d[i][1][j][1];
				routes[r][1][j][2] = d[i][1][j][2];
				routes[r][1][j][3] = d[i][1][j][3];
			end
		end
	end
	if(not promptOkay("Added " .. added .. " and replaced " .. replaced .. " routes.")) then
		error("Macro aborted by user");
	end
	if(added > 0 or replaced > 0) then
		saveRoutes();
	end
end

function alreadyExists(name)
	local i;
	for i = 1, #routes do
		if(name == routes[i][0]) then
			return true;
		end
	end
	return false;
end

function deleteNamedRoute(name)
	local temp = {};
	local i;
	local j = 1;
	for i = 1, #routes do
		if(name ~= routes[i][0]) then
			temp[j] = {};
			temp[j][0] = routes[i][0];
			temp[j][1] = {};
			local k;
			for k = 1, #routes[i][1] do
				temp[j][1][k] = {};
				temp[j][1][k][1] = routes[j][1][k][1];
				temp[j][1][k][2] = routes[j][1][k][2];
				temp[j][1][k][3] = routes[j][1][k][3];
			end
			j = j + 1;
		end
	end
	routes = {};
	for i = 1, #temp do
		routes[i] = {};
		routes[i][0] = temp[i][0];
		routes[i][1] = {};
		for j = 1, #temp[i][1] do
			routes[i][1][j] = {};
			routes[i][1][j][1] = temp[i][1][j][1];
			routes[i][1][j][2] = temp[i][1][j][2];
			routes[i][1][j][3] = temp[i][1][j][3];
		end
	end
end

function tableToText(route)
	local text = {};
	local i;
	for i = 1, #route do
		text[i] = route[i][1] .. ", " .. route[i][2] .. ", " .. WaypointTypes[route[i][3]] .. "\n";
	end
	return text;
end

function textToTable(routeText)
	local route={};
	local lines = string.match(routeText,"\n\n");
	statusScreen(#lines);
	lsSleep(3000);
	return route;
end

function insertWaypointAfter(where,thisRoute)
	local temp = {};
	local i;
	for i = 1, ((#thisRoute[1]) + 1) do
		temp[i] = {};
		if(i <= where) then
			temp[i][1] = thisRoute[1][i][1];
			temp[i][2] = thisRoute[1][i][2];
			temp[i][3] = thisRoute[1][i][3];
		elseif(i == where + 1) then
			temp[i][1] = 0;
			temp[i][2] = 0;
			temp[i][3] = 1;
		else
			temp[i][1] = thisRoute[1][i-1][1];
			temp[i][2] = thisRoute[1][i-1][2];
			temp[i][3] = thisRoute[1][i-1][3];
		end
	end
	thisRoute[1] = {};
	for i = 1, #temp do
		thisRoute[1][i] = {};
		thisRoute[1][i][1] = temp[i][1];
		thisRoute[1][i][2] = temp[i][2];
		thisRoute[1][i][3] = temp[i][3];
	end
	return thisRoute;
end


function deleteWaypoint(where,thisRoute)
	if(#thisRoute[1] == 1) then
		thisRoute[1][1][1] = 0;
		thisRoute[1][1][2] = 0;
		thisRoute[1][1][3] = 1;
		return thisRoute;
	end

	local temp = {};
	local i;
	for i = 1, #thisRoute[1] do
		if(i < where) then
			temp[i] = {};
			temp[i][1] = thisRoute[1][i][1];
			temp[i][2] = thisRoute[1][i][2];
			temp[i][3] = thisRoute[1][i][3];
		elseif(i > where) then
			temp[i-1] = {};
			temp[i-1][1] = thisRoute[1][i][1];
			temp[i-1][2] = thisRoute[1][i][2];
			temp[i-1][3] = thisRoute[1][i][3];
		end
	end
	thisRoute[1] = {};
	for i = 1, #temp do
		thisRoute[1][i] = {};
		thisRoute[1][i][1] = temp[i][1];
		thisRoute[1][i][2] = temp[i][2];
		thisRoute[1][i][3] = temp[i][3];
	end
	return thisRoute;
end

function saveRoute(thisRoute,route)
	local r = route;
	routes[r] = {};
	routes[r][0] = thisRoute[0];
	routes[r][1] = {};
	local i;
	for i = 1, #thisRoute[1] do
		routes[r][1][i] = {};
		routes[r][1][i][1] = thisRoute[1][i][1];
		routes[r][1][i][2] = thisRoute[1][i][2];
		routes[r][1][i][3] = thisRoute[1][i][3];
	end
	serialize(routes,routeFileName);
	loadRoutes();
end

function saveRoutes()
	serialize(routes,routeFileName);
	loadRoutes();
end

function loadRoutes()
	routes = {};
	routeNames = {};
	if(pcall(dofile,routeFileName)) then
		routes = deserialize(routeFileName);
	else
		if(pcall(dofile,defaultRoutesFileName)) then
			routes = deserialize(defaultRoutesFileName);
		else
			error("Cannot find any routes.  Please try updating the macros again.");
		end
	end
	local i;
	for k,v in pairs(routes) do
		routeNames[k] = routes[k][0];
	end
end

function goto(waypoint,thisRoute)
	lsDoFrame();
	lsDoFrame();
	askForWindow("Make sure your chats are minimized, then hover ATITD window and press Shift to continue.");
	local x = tonumber(thisRoute[1][waypoint][1]);
	local y = tonumber(thisRoute[1][waypoint][2]);
	moveTo(x, y, true)
end












function followRoute(route)
	if(wood) then
		local haveBonfire = false;
		local i;
		for i = 1, #routes[route][1] do
			if(routes[route][1][i][3] == Bonfire) then
				haveBonfire = true;
			end
		end
		if(not haveBonfire) then
			if(not promptOkay("This route does not include a bonfire.  If you add a bonfire's coords to this route, wood will be stashed there every time you reach those coordinates.")) then
				return;
			end
		end
	end
	if(slate or clay or grass) then
		local haveWarehouse = false;
		local i;
		for i = 1, #routes[route][1] do
			if(routes[route][1][i][3] == Warehouse) then
				haveWarehouse = true;
			end
		end
		if(not haveWarehouse) then
			if(not promptOkay("This route does not include a warehouse.  If you add a warehouse's coords to this route, resources will be stashed there every time you reach those coordinates.")) then
				return;
			end
		end
	else
		if(not wood) then
			if(not promptOkay("You have not specified any resources to gather.  Are you sure that's what you want?")) then
				return;
			end
		end
	end
	askForWindow("Make sure your chats are minimized, then hover ATITD window and press Shift to continue.");
	local curr = 1;
	local fails = 0;
	local direction = 1;
	local lastPos = {0,0};
	local r = routes[route][1];
	while (1) do
		checkBreak();
		srReadScreen();
		local pos;
		pos = findCoords();
		if (pos) then
			lastPos = pos;
		end
		statusScreen("Moving to " .. WaypointTypes[r[curr][3]] .. "\n(" .. r[curr][1] .. ", " .. r[curr][2] .. ")");
		moveTo(r[curr][1],r[curr][2]);
		if(r[curr][3] == Waypoint) then
			curr = curr + 1;
		else
			if(r[curr][3] == Bonfire) then
				if(clickWaypoint(r[curr][3])) then
					stashWood();
				end
			elseif(r[curr][3] == Wharehouse) then
				if(clickWaypoint(r[curr][3])) then
					stashAllButWood();
				end
			elseif(wood) then
				if(clickWaypoint(r[curr][3])) then
					lsSleep(250);
					srReadScreen();
					noWoodMenuPos = findText("no Wood");
					if(noWoodMenuPos) then
						safeClick(noWoodMenuPos[0]-7,noWoodMenuPos[1]);
						lsSleep(250);
					else
						utilityPos = findText("Utility");
						if(utilityPos) then
							safeClick(utilityPos[0]-7,utilityPos[1]);
							lsSleep(250);
						else
							sleepWithBreak(1000);
						end
					end
					srReadScreen();
				end
				fails = 0;
				curr = curr + 1;
				direction = 1;
			else
				fails = fails + 1;
				if(fails > 10) then
					curr = curr + 1;
					direction = 1;
				else
					if(fails == 1) then
						if(lastPos[0] < r[curr][1]) then
							if(lastPos[1] < r[curr][2]) then
								direction = 1;
							else
								direction = 2;
							end
						else
							if(lastPos[1] < r[curr][2]) then
								direction = 3;
							else
								direction = 4;
							end
						end
					else
						direction = direction + 1
						if(direction > 4) then
							direction = 1;
						end
					end
					if(direction == 1) then					
						moveTo(r[curr][1]-1,r[curr][2]-1);
						moveTo(r[curr][1]+1,r[curr][2]+1);
					elseif (direction == 2) then
						moveTo(r[curr][1]-1,r[curr][2]+1);
						moveTo(r[curr][1]+1,r[curr][2]-1);
					elseif (direction == 3) then
						moveTo(r[curr][1]+1,r[curr][2]-1);
						moveTo(r[curr][1]-1,r[curr][2]+1);
					else
						moveTo(r[curr][1]+1,r[curr][2]+1);
						moveTo(r[curr][1]-1,r[curr][2]-1);
					end
				end
			end
		end
		if(curr > #r) then
			curr = 1;
			if(not repeatForever) then
				return;
			end
		end
	end
end

function clickWaypoint(typeOfWaypoint)
	local xyWindowSize = srGetWindowSize();
	local mid = {};
	mid[0] = xyWindowSize[0] / 2;
	mid[1] = xyWindowSize[1] / 2;
	srSetMousePos(mid[0],mid[1]);
	local dx;
	local dy;
	local delta;
	local offset = {};
	statusScreen("Looking for " .. WaypointTypes[typeOfWaypoint]);
	srReadScreen();
	for delta = 1, 300, 2 do
		for dx = (delta * -1), delta do
			if(clickWaypointPixel(mid[0]+dx,mid[1]+delta,typeOfWaypoint)) then
				return true;
			end
			if(clickWaypointPixel(mid[0]+dx,mid[1]-delta,typeOfWaypoint)) then
				return true;
			end
		end
		for dy = (delta * -1), delta do
			if(clickWaypointPixel(mid[0]+delta,mid[1]+dy,typeOfWaypoint)) then
				return true;
			end
			if(clickWaypointPixel(mid[0]-delta,mid[1]-dy,typeOfWaypoint)) then
				return true;
			end
		end
	end
	return false;
end

function clickWaypointPixel(x, y, typeOfWaypoint)
	local pos = {};
	pos[0] = x;
	pos[1] = y;
	local offset = {};
	offset[0] = 0;
	offset[1] = 0;
	local color = srReadPixelFromBuffer(x, y);
	checkBreak();
-- 	if(pixelMatch(pos,offset,WaypointColors[typeOfWaypoint],10)) then
	local diff = compareColor(color,WaypointColors[typeOfWaypoint]);
	if(diff < 5) then
		safeClick(pos[0],pos[1]);
		statusScreen(WaypointTypes[typeOfWaypoint] .. " clicked");
		return true;
	end
	return false;
end

function moveTo(x, y, showStatus)
	local xn = tonumber(x);
	local yn = tonumber(y);
	if(not showStatus) then
		showStatus = false;
	end
	local direction = 1;
	local errorCount = 0;
	local notMoving = 0;
	local lastPos = {};
	lastPos[0] = 0;
	lastPos[1] = 0;
	while(1) do
		checkBreak();
		srReadScreen();
		overloaded = findText("Do you want to drop something?");
		if(overloaded) then
			fatalError("You are overloaded.");
		end
		checkSlate();
		checkClay();
		checkGrass();
		local pos;
		pos = findCoords();
		if (pos) then
			if(#pos < 1) then
				fatalError("#pos < 2 in moveTo() ... (" .. #pos .. ")");
			end
			if(pos[0] == lastPos[0] and pos[1] == lastPos[1]) then
				notMoving = notMoving + 1;
				if(notMoving > 20) then
					if(not promptOkay("You don't appear to be moving.  Are your chats minimized?  Is your \"Use arrow keys for movement\" option enabled?")) then
						error("Macro aborted by user");
					end
				end
			else
				notMoving = 0;
				lastPos = pos;
			end
			if(showStatus) then
				statusScreen("Moving from (" .. pos[0] .. ", " .. pos[1] .. ")\nTo (" .. xn .. ", " .. yn .. ")");
			end
			errorCount = 0;
			if((pos[0] == xn) and (pos[1] == yn)) then
				srReadScreen();
				return;
			end
			if(pos[0] < xn) then
				srRightArrow();
				lsSleep(keyDelay);
			elseif(pos[0] > xn) then
				srLeftArrow();
				lsSleep(keyDelay);
			end
			if(pos[1] < yn) then
				srUpArrow();
				lsSleep(keyDelay);
			elseif(pos[1] > yn) then
				srDownArrow();
				lsSleep(keyDelay);
			end
		else
			errorCount = errorCount + 1;
			statusScreen("Can't find position.  Make sure clockloc is shown. (" .. errorCount .. ")");
			lsSleep(1000);
			if(direction == 1) then
				srRightArrow();
			elseif (direction == 2) then
				srLeftArrow();
			elseif (direction == 3) then
				srUpArrow();
			else
				srDownArrow();
			end
			lsSleep(keyDelay);
			direction = direction + 1;
			if(direction > 4) then
				direction = 1;
			end
		end
	end
end

function checkSlate()
	if(not slate) then
		return;
	end
	local xyWindowSize = srGetWindowSize();
	local midX = xyWindowSize[0] / 2;
	local pos = srFindImageInRange("slate.png",0,0,midX,100,5000);
	if(pos) then
		safeClick(pos[0] + 3, pos[1] + 3);
		sleepWithBreak(750);
	end
end

function checkGrass()
	if(not grass) then
		return;
	end
	local xyWindowSize = srGetWindowSize();
	local midX = xyWindowSize[0] / 2;
	local pos = srFindImageInRange("grass.png",0,0,midX,100,5000);
	if(pos) then
		safeClick(pos[0] + 3, pos[1] + 3);
		sleepWithBreak(750);
	end
end

function checkClay()
	if(not clay) then
		return;
	end
	local xyWindowSize = srGetWindowSize();
	local midX = xyWindowSize[0] / 2;
	if((emptyJugs > (numJugs / 2)) or (emptyJugs > 50)) then
		local pos = srFindImageInRange("water.png",0,0,midX,100,5000);
		if(pos) then
			safeClick(pos[0] + 3, pos[1] + 3);
			lsSleep(150);
			srReadScreen();
			clickMax();
			emptyJugs = 0;
		end
	end
	if(emptyJugs == numJugs) then
		return
	end
	local xyWindowSize = srGetWindowSize();
	local midX = xyWindowSize[0] / 2;
	local pos = srFindImageInRange("clay.png",0,0,midX,100,5000);
	if(pos) then
		safeClick(pos[0] + 3, pos[1] + 3);
		emptyJugs = emptyJugs + 1;
	end
end

function clickColor(color)
	local xyWindowSize = srGetWindowSize();
	local mid = {};
	mid[0] = xyWindowSize[0] / 2;
	mid[1] = xyWindowSize[1] / 2;
	srSetMousePos(mid[0],mid[1]);
	local dx;
	local dy;
	local delta;
	local offset = {};
	statusScreen("Searching...");
	srReadScreen();
	for delta = 1, 300, 2 do
		for dx = (delta * -1), delta do
			if(clickColorPixel(mid[0]+dx,mid[1]+delta,color)) then
				return true;
			end
			if(clickColorPixel(mid[0]+dx,mid[1]-delta,color)) then
				return true;
			end
		end
		for dy = (delta * -1), delta do
			if(clickColorPixel(mid[0]+delta,mid[1]+dy,color)) then
				return true;
			end
			if(clickColorPixel(mid[0]-delta,mid[1]-dy,color)) then
				return true;
			end
		end
	end
	return false;
end

function clickColorPixel(x, y, color)
	local pos = {};
	pos[0] = x;
	pos[1] = y;
	local offset = {};
	offset[0] = 0;
	offset[1] = 0;
	local currColor = srReadPixelFromBuffer(x, y);
	checkBreak();
	if(math.floor(currColor/256) == math.floor(color/256)) then
		safeClick(pos[0],pos[1]);
		lsSleep(250);
		return true;
	end
	return false;
end

function clickMax()
	srReadScreen();
	local maxButton = srFindImage("maxButton.png",5000);
	if(maxButton) then
		srClickMouseNoMove(maxButton[0]+5,maxButton[1],0);
	else
		fatalError("Unable to find the Max button");
	end
	lsSleep(150);
	srReadScreen();
end

function stashWood()
	lsSleep(250);
	srReadScreen();
	addWoodPos = findText("Add some Wood");
	if(addWoodPos) then
		safeClick(addWoodPos[0] + 10, addWoodPos[1] + 5);
		lsSleep(250);
		srReadScreen();
		clickMax();
	else
		fatalError("Unable to find the Add some Wood menu item.");
	end
	statusScreen("Wood stashed");
end

function stashAllButWood()
	local needMax;
	local stashedSomething = true;
	while(stashedSomething) do
		stashedSomething = false;
		needMax = true;
		lsSleep(150);
		srReadScreen();
		local pos = findText("Stash...");
		if(not pos) then
			fatalError("Unable to find the Stash menu item.");
		end
		safeClick(pos[0] + 10, pos[1] + 5);
		lsSleep(150);
		srReadScreen();
		local pos = findText("Clay");
		if(pos) then
			safeClick(pos[0] + 10, pos[1] + 5);
			lsSleep(150);
			srReadScreen();
			stashedSomething = true;
		else
			pos = findText("Flint");
			if(pos) then
				safeClick(pos[0] + 10, pos[1] + 5);
				lsSleep(150);
				srReadScreen();
				stashedSomething = true;
			else
				pos = findText("Slate");
				if(pos) then
					safeClick(pos[0] + 10, pos[1] + 5);
					lsSleep(150);
					srReadScreen();
					stashedSomething = true;
				else
					pos = findText("Grass");
					if(pos) then
						safeClick(pos[0] + 10, pos[1] + 5);
						lsSleep(150);
						srReadScreen();
						stashedSomething = true;
					else
						pos = findText("Tadpoles");
						if(pos) then
							safeClick(pos[0] + 10, pos[1] + 5);
							lsSleep(150);
							srReadScreen();
							stashedSomething = true;
						else
							pos = findText("Insect...");
							if(pos) then
								safeClick(pos[0] + 10, pos[1] + 5);
								lsSleep(150);
								srReadScreen();
								pos = findText("Stash All Insect");
								if(pos) then
									safeClick(pos[0] + 10, pos[1] + 5);
									lsSleep(150);
									srReadScreen();
									stashedSomething = true;
									needMax = false;
								end
							end
						end
					end
				end
			end
		end
		if(stashedSomething) then
			if(needMax) then
				clickMax();
			end
			clickWaypoint(Wharehouse);
		else
			safeClick(10,200);
		end
	end
end



