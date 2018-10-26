-- Ashen's improved Toxin Kitchen macro
-- Make All The Toxins
-- TODO: Support making EoG Serum with alternative ingredients
-- TODO: Support multiple kitchens

dofile("common.inc");

-- Names of products to list in menu
AUTOMENU = {
	"Eye of God Serum",
	"Nut's Essence",
	"Milky Solvent",
	"Clear Solvent",
	"Glass Solvent",
	"Crystal Solvent",
	"Diamond Solvent",
	"Minu's Solvent",
	"Osiris' Solvent",
	"Renenutet's Solvent",
};

-- Names of products as listed in toxin kitchen
PRODUCTS = {
	"Eye of God Serum",
	"Nut's Essence",
	"Revelation Solvent (Milky)",
	"Revelation Solvent (Clear)",
	"Revelation Solvent (Glass)",
	"Revelation Solvent (Crystal)",
	"Revelation Solvent (Diamond)",
	"Revelation Solvent (Minu's)",
	"Revelation Solvent (Osiris')",
	"Revelation Solvent (Renenutet's)",
};

DONTCARE = -1;

-- Always add water when volume is <= this value
MINVOLUME = 3.0;

-- Temperature ranges required for each product at each stage
STAGETEMP = {
	-- Eye of God Serum
	{ { 625, 775 }, { DONTCARE, DONTCARE }, { 190, 385 } },
	-- Nut's Essence
	{ { 600, 800 }, { DONTCARE, DONTCARE }, { 200, 400 } },
	-- Milky
	{ { 360, 400 }, { DONTCARE, DONTCARE }, { 650, 800 } },
	-- Clear
	{ { 360, 400 }, { DONTCARE, DONTCARE }, { 650, 800 } },
	-- Glass
	{ { 360, 400 }, { DONTCARE, DONTCARE }, { 650, 800 } },
	-- Crystal
	{ { 360, 400 }, { DONTCARE, DONTCARE }, { 650, 800 } },
	-- Diamond
	{ { 360, 400 }, { DONTCARE, DONTCARE }, { 650, 800 } },
	-- Minu
	{ { 380, 400 }, { 0, 100 }, { 750, 800 } },
	-- Osiris
	{ { 580, 600 }, { 500, 700 }, { 770, 800 } },
	-- Renenutet
	{ { 490, 500 }, { 100, 200 }, { 750, 800 } },
};

-- Temperature ranges in which to bother testing acidity with cabbage juice
-- during each stage for each product
CABBAGETEMP = {
	-- Eye of God Serum
	{ { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE } },
	-- Nut's Essence
	{ { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE } },
	-- Milky
	{ { DONTCARE, DONTCARE }, { 0, 200 }, { DONTCARE, DONTCARE } },
	-- Clear
	{ { DONTCARE, DONTCARE }, { 0, 200 }, { DONTCARE, DONTCARE } },
	-- Glass
	{ { DONTCARE, DONTCARE }, { 0, 200 }, { DONTCARE, DONTCARE } },
	-- Crystal
	{ { DONTCARE, DONTCARE }, { 0, 200 }, { DONTCARE, DONTCARE } },
	-- Diamond
	{ { DONTCARE, DONTCARE }, { 0, 200 }, { DONTCARE, DONTCARE } },
	-- Minu
	{ { DONTCARE, DONTCARE }, { 0, 250 }, { DONTCARE, DONTCARE } },
	-- Osiris
	{ { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE } },
	-- Renenutet
	{ { DONTCARE, DONTCARE }, { 0, 350 }, { DONTCARE, DONTCARE } },
};

-- Required acidity range for each stage for product
STAGEACID = {
	-- Eye of God Serum
	{ { DONTCARE, DONTCARE }, { 3.1, 3.6 }, { DONTCARE, DONTCARE } },
	-- Nut's Essence
	{ { DONTCARE, DONTCARE }, { 3.40, 3.80 }, { DONTCARE, DONTCARE } },
	-- Milky
	{ { 3.0, 3.4 }, { 1.2, 1.5 }, { DONTCARE, DONTCARE } },
	-- Clear
	{ { 3.0, 3.4 }, { 1.2, 1.5 }, { DONTCARE, DONTCARE } },
	-- Glass
	{ { 3.0, 3.4 }, { 1.2, 1.5 }, { DONTCARE, DONTCARE } },
	-- Crystal
	{ { 3.0, 3.4 }, { 1.2, 1.5 }, { DONTCARE, DONTCARE } },
	-- Diamond
	{ { 3.0, 3.4 }, { 1.2, 1.5 }, { DONTCARE, DONTCARE } },
	-- Minu
	{ { 4.0, 4.5 }, { 1.2, 1.5 }, { 2.0, 5.0 } },
	-- Osiris
	{ { 5.0, 5.4 }, { 1.2, 1.5 }, { 3.0, 4.0 } },
	-- Renenutet
	{ { 2.2, 2.4 }, { 1.1, 1.3 }, { 4.9, 5.0 } },
};

-- Initial sap to add upon stage change for each stage for each product
STAGESAP = {
	-- Eye of God Serum
	{ 0, 2, 0 },
	-- Nut's Essence
	{ 0, 2, 0 },
	-- Milky
	{ 0, 2, 0 },
	-- Clear
	{ 0, 2, 0 },
	-- Glass
	{ 0, 2, 0 },
	-- Crystal
	{ 0, 2, 0 },
	-- Diamond
	{ 2, 0, 0 },
	-- Minu
	{ 3, 0, 0 },
	-- Osiris
	{ 4, 0, 0 },
	-- Renenutet
	{ 3, 0, 2 },
};

-- Ingredient requirements for calculating totals. Rough estimates for water/cc/sap/juice.
INGREDIENTS = {
	-- ingredients, water, cc, sap, juice
	-- Eye of God Serum
	{ {{ 2, "Nature's Jug" }, { 1, "Arsenic"}}, 10, 15, 10, 15 },
	-- Nut's Essence
	{ {{ 3, "Hairy Tooth" }}, 10, 15, 10, 15 },
	-- Milky
	{ {{ 3, "Sand Spore" }}, 10, 15, 10, 15 },
	-- Clear
	{ {{ 3, "Slave's Bread" }}, 10, 15, 10, 15 },
	-- Glass
	{ {{ 3, "Razor's Edge" }}, 10, 15, 10, 15 },
	-- Crystal
	{ {{ 6, "Peasant Foot" }}, 10, 15, 10, 15 },
	-- Diamond
	{ {{ 3, "Scorpion's Brood" }, { 3, "Heaven's Torrent" }, { 3, "Heart of Ash"}}, 25, 25, 25, 25 },
	-- Minu
	{ {{ 4, "Salt Water Fungus" }, { 4, "Razor's Edge" }, { 4, "Falcon's Bait"}}, 25, 25, 25, 25 },
	-- Osiris
	{ {{ 5, "Beehive" }, { 5, "Eye of Osiris" }, { 5, "Dueling Serpents"}}, 25, 25, 25, 25 },
	-- Renenutet
	{ {{ 6, "Spiderling" }, { 6, "Sand Spore" }, { 6, "Sun Star"}}, 25, 25, 25, 25 },
};

-- What to add at each stage of each recipe
STAGEADD = {
	-- Eye of God Serum
	{ "Nature", "Arsenic", "Nature" },
	-- Nut's Essence
	{ "Hairy", "Hairy", "Hairy" },
	-- Milky
	{ "Sand", "Sand", "Sand" },
	-- Clear
	{ "Slave", "Slave", "Slave" },
	-- Glass
	{ "Razor", "Razor", "Razor" },
	-- Crystal
	{ "Peasant", "Peasant", "Peasant" },
	-- Diamond
	{ "Scorpion", "Heaven", "Heart" },
	-- Minu
	{ "Salt", "Razor", "Falcon" },
	-- Osiris
	{ "Beehive", "Eye", "Dueling" },
	-- Renenutet
	{ "Spider", "Sand", "Sun" },
};


window_pos = nil;

per_click_delay = 20;
tick_time = 1000;
readDelay = 110;
window_w = 260;
window_h = 256;
tol = 8000;

cooking = false;
stop_cooking = false;

tempchanged = false;
volchanged = false;
statechanged = false;
curstage = 0;
curtemp = 0;
curacidity = 0.0;
curvolume = 0.0;
curprecip = 0.0;

cabbageqty	= 0;
waterqty	= 0;
cactusqty	= 0;
ccqty		= 0;

qtyrequested = 1;

function shImage(imageName, window_pos)
	local win = srGetWindowBorders(window_pos[0]+(window_w/2), window_pos[1]+(window_h/2));
	return srFindImageInRange(imageName, win[0], win[1], win[2]-win[0], win[3]-win[1], tol);
end

function findWinText(text, window_pos, flag)
	if (window_pos) then
		local win = getWindowBorders(window_pos[0]+(window_w/2), window_pos[1]+(window_h/2));
		return findText(text, win, flag);
	end
end

function resetstate()
	cooking = false;
	statechanged = false;
	curstage = 0;
	curtemp = 0;
	curacidity = 0.0;
	curvolume = 0.0;
	curprecip = 0.0;
end

function resetqty()
	cabbageqty = 0;
	waterqty = 0;
	cactusqty = 0;
	ccqty = 0;
end

function clearOk()
	srReadScreen();
	local image = srFindImage("Ok.png", tol);
	if image then
		srClickMouseNoMove(image[0] + 10, image[1] + 10, false);
		lsSleep(per_click_delay + readDelay);
		image = srFindImage("Ok.png", tol);
	end
end

function updateStatus(window_pos)
	local newstage = curstage;
	local newtemp = curtemp;
	local newvolume = curvolume;
	local newacidity = curacidity;
	local newprecip = curprecip;

	srReadScreen();

	--search for which stage we're in
	image = shImage("toxinKitchen/ToxinStage.png", window_pos);
	if image then
		newstage = ocrNumber(image[0] + 32, image[1]);
	end

	--check volume
	image = shImage("toxinKitchen/ToxinVolume.png", window_pos);
	if image then
		newvolume = ocrNumber(image[0] + 43, image[1]);
	end

	--check temp
	image = shImage("toxinKitchen/ToxinTemperature.png", window_pos);
	if image then
		newtemp = ocrNumber(image[0] + 70, image[1]);
	end

	--check acidity
	image = shImage("toxinKitchen/ToxinAcidity.png", window_pos);
	if image then
		newacidity = ocrNumber(image[0] + 41, image[1]);
	end

	--precipitate
	image = shImage("toxinKitchen/ToxinPrecipitate.png", window_pos);
	if image then
		newprecip = ocrNumber(image[0] + 59, image[1]);
	end

	if (newtemp ~= curtemp) then
		tempchanged = true;
	end

	if (newvolume ~= curvolume) then
		volchanged = true;
	end

	if ((newstage ~= curstage) or (newvolume ~= curvolume) or (newtemp ~= curtemp) or (newacidity ~= curacidity)) then
		curstage = newstage;
		curtemp = newtemp;
		curvolume = newvolume;
		curacidity = newacidity;
		statechanged = true;
	end

	curprecip = newprecip;
end

-- Display status and sleep
function displayStatus(tid, passno)
	local start_time = lsGetTimer();

	while tick_time - (lsGetTimer() - start_time) > 0 do
		time_left = tick_time - (lsGetTimer() - start_time);

		local y = 10;
		local x = 10;

		lsPrint(x, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
		lsPrint(x, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
		y = y + 40;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Making " .. AUTOMENU[tid] .. " " .. passno .. "/" .. qtyrequested);
		y = y + 40;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Stage:");
		lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, curstage);
		y = y + 12;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Temperature:");
		lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, curtemp);
		y = y + 12;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Volume:");
		lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, curvolume);
		y = y + 12;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Acidity:");
		lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, curacidity);
		y = y + 12;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Precipitate:");
		lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, curprecip);
		y = y + 12;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Waiting:");
		lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, time_left);
		y = y + 40;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "CC Used:");
		lsPrint(x+120, y, 0, 0.7, 0.7, 0xB0B0B0ff, ccqty);
		y = y + 12;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Cactus Used:");
		lsPrint(x+120, y, 0, 0.7, 0.7, 0xB0B0B0ff, cactusqty);
		y = y + 12;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Cabbage Used:");
		lsPrint(x+120, y, 0, 0.7, 0.7, 0xB0B0B0ff, cabbageqty);
		y = y + 12;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Water Used:");
		lsPrint(x+120, y, 0, 0.7, 0.7, 0xB0B0B0ff, waterqty);
		y = y + 12;

		c = 0xFFFFFFff;
		if (stop_cooking) then
			c = 0x00FF00ff;
		end
		if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, c, "Finish up") then
			stop_cooking = true;
		end
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end

		lsDoFrame();
		lsSleep(25);
		checkBreak();
	end
end

function checkAddWater(window_pos)
	if (curvolume < MINVOLUME) then
		srReadScreen();
		image = shImage("toxinKitchen/DiluteWater.png", window_pos);
		srClickMouseNoMove(image[0] + 10, image[1] + 2, false);
		lsSleep(per_click_delay);
		waterqty = waterqty + 1;
	end
end

function addCharcoal(window_pos)
	srReadScreen();
	image = shImage("toxinKitchen/HeatCharcoal.png", window_pos);
	srClickMouseNoMove(image[0] + 10, image[1] + 2, false);
	lsSleep(per_click_delay);
	ccqty = ccqty + 1;
end

function addSap(qty, window_pos)
	srReadScreen();
	image = shImage("toxinKitchen/CatalyzeSap.png", window_pos);
	if (image) then
		for i = 1, qty, 1 do
			srClickMouseNoMove(image[0] + 10, image[1] + 2, false);
			lsSleep(per_click_delay);
			cactusqty = cactusqty + 1;
		end
	end
end

function addCabbage(window_pos)
	srReadScreen();
	image = shImage("toxinKitchen/CheckAcidity.png", window_pos);
	srClickMouseNoMove(image[0] + 10, image[1] + 2, false);
	lsSleep(per_click_delay);
	cabbageqty = cabbageqty + 1;
end

function checkTakeProduct(tid, window_pos)
	if (curstage == 4) then
		srReadScreen();
		clickloc = findWinText("Take the " .. PRODUCTS[tid], window_pos);

		if (clickloc) then
			srClickMouseNoMove(clickloc[0] + 10, clickloc[1] + 2, false);
			lsSleep(per_click_delay);
			return true;
		end
	end

	return false;
end

function addIngredient(tid, window_pos)
	if ((curstage >= 1) and (curstage <= 3)) then
		ingredients = STAGEADD[tid];
		addtext = "Ingredient: " .. ingredients[curstage];

		srReadScreen();
		clickloc = findWinText(addtext, window_pos);

		if not clickloc then
			error("Could not find '" .. addtext .. "'");
		end

		srClickMouseNoMove(clickloc[0] + 10, clickloc[1] + 2, false);
		lsSleep(per_click_delay);
	end
end

function doTick(tid, window_pos)
	local acidok = false;
	local tempok = false;
	local docabbage = false;
	local cabbageok = false;

	if (not statechanged) then
		return;
	end

	if ((curstage < 0) or (curstage > 4)) then
		return;
	end

	if (checkTakeProduct(tid, window_pos)) then
		resetstate();
		return;
	end

	checkAddWater(window_pos);

	if (curstage == 4) then
		return;
	end

	initsap = STAGESAP[tid][curstage];
	acidrange = STAGEACID[tid][curstage];
	temprange = STAGETEMP[tid][curstage];
	cabbagerange = CABBAGETEMP[tid][curstage];

	-- Check current acidity vs. required, if it matters for this stage
	if (((acidrange[1] == DONTCARE) or (curacidity >= acidrange[1])) and
		((acidrange[2] == DONTCARE) or (curacidity <= acidrange[2]))) then
		acidok = true;
	end

	-- Check current temperature vs. required, if it matters for this stage
	if (((temprange[1] == DONTCARE) or (curtemp >= temprange[1])) and
		((temprange[2] == DONTCARE) or (curtemp <= temprange[2]))) then
		tempok = true;
	else
		if ((temprange[1] ~= DONTCARE) and (curtemp < temprange[1])) then
			addCharcoal(window_pos);
		end
	end

	-- Check current temperature vs. range where we should be checking acidity.
	-- This is mainly to avoid wasting cabbage while waiting for a large drop
	-- that coincides with an allowed large temperature drop.
	if (((cabbagerange[1] == DONTCARE) or (curtemp >= cabbagerange[1])) and
		((cabbagerange[2] == DONTCARE) or (curtemp <= cabbagerange[2])) and
		((acidrange[1] ~= DONTCARE) or (acidrange[2] ~= DONTCARE))) then
		cabbageok = true;
	end

	if ((acidrange[1] ~= DONTCARE) and (curacidity < acidrange[1])) then
		addSap(1, window_pos);
		docabbage = true;
	elseif ((acidrange[2] ~= DONTCARE) and (tempchanged or volchanged)) then
		docabbage = true;
	end

	if (docabbage and cabbageok) then
		addCabbage(window_pos);
	end

	-- Add ingredient if both acidity and temperature are in range
	if (acidok and tempok) then
		addIngredient(tid, window_pos);
	end

	statechanged = false;
	tempchanged = false;
	volchanged = false;
end

function waitForCon()
	local ready = false;

	while not ready do
		--Search for black con timer
		srReadScreen();
		local image1 = srFindImage ("Constitution-Black.png", tol);
		local image2 = srFindImage ("Constitution-DarkRed.png", 2000);

		if not (image1 or image2) then
			local x = 10;
			local y = 6;

			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
			y = y + 12;
			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
			y = y + 40;
			lsPrint(x, y, 0, 0.7, 0.7, 0xFF0000ff, "CON Not Ready");

			if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Finish up") then
				stop_cooking = true;
				ready = true;
			end
			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				stop_cooking = true;
				ready = true;
			end

			lsDoFrame();
			lsSleep(tick_delay);
			checkBreak();
		else
			ready = true;
		end
	end
end

function makeToxin(tid)
	local passno;

	resetqty();

	for passno=1,qtyrequested do
		waitForCon();
		if (stop_cooking) then
			return;
		end

		srReadScreen();
		window_pos = findText("This is [a-z]+ Toxin Kitchen", nil, REGEX);

		if (not window_pos) then
			error "Did not find any Toxin Kitchen window";
		end

		srReadScreen();
		clickloc = findWinText("Start a batch of " .. PRODUCTS[tid], window_pos);

		if not clickloc then
			error("Could not find '" .. PRODUCTS[tid] .. "'");
		end

		clickText(clickloc);
		lsSleep(per_click_delay);

		cooking = true;

		while cooking do
			clearOk();

			displayStatus(tid, passno);

			srReadScreen();
			window_pos = findText("This is [a-z]+ Toxin Kitchen", nil, REGEX);

			if (window_pos) then
				srClickMouseNoMove(window_pos[0] + 10, window_pos[1] + 2, false);
				lsSleep(readDelay);

				updateStatus(window_pos);
				doTick(tid, window_pos);
			end

			checkBreak();
		end
	end
end

function getQuantity(tid)
	local quantities = INGREDIENTS[tid];
	local ingredients = quantities[1];
	local water = quantities[2];
	local cc = quantities[3];
	local sap = quantities[4];
	local juice = quantities[5];

	while true do
		local y = 10;
		local x = 10;

		lsPrint(x, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
		lsPrint(x, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
		y = y + 40;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "How many " .. AUTOMENU[tid] .. "?");
		y = y + 30;

		local done, qty = lsEditBox("toxinQty", x, y, 0, 50, 30, 1.0, 1.0, 0x000000ff, qtyrequested);
		y = y + 40;

		qty = tonumber(qty);

		if (qty and (qty > 0)) then
			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, qty .. " " .. AUTOMENU[tid] .. " Requires:");
			y = y + 24;

			for i=1,#ingredients do
				item = ingredients[i];
				lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, (qty * item[1]) .. " " .. item[2]);
				y = y + 12;
			end

			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "~" .. (qty * water) .. " Water in Jugs");
			y = y + 12;

			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "~" .. (qty * cc) .. " Charcoal");
			y = y + 12;

			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "~" .. (qty * sap) .. " Cactus Sap");
			y = y + 12;

			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "~" .. (qty * juice) .. " Cabbage Juice");
			y = y + 12;
		else
			lsPrint(x, y, 0, 0.7, 0.7, 0xFF0000ff, "Please enter a valid number > 0!");
		end

		if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Back") then
			return 0;
		end

		if (qty and (qty > 0)) then
			c = 0x80D080ff;
		else
			c = 0xFFFFFFff;
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, c, "Begin") then
			if (qty and (qty > 0)) then
				qtyrequested = qty;
				return qty;
			end
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End Script") then
			stop_cooking = true;
			return 0;
		end

		lsDoFrame();
		lsSleep(25);
		checkBreak();
	end
end

function displayMenu()
	-- Ask for which button
	local selected = nil;
	while not selected do
		local y = 6;
		local x = 30;

		for i=1, #AUTOMENU do
			if lsButtonText(x, y, 0, 250, 0x80D080ff, AUTOMENU[i]) then
				selected = i;
			end
			y = y + 30;
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			selected = nil;
			stop_cooking = true;
			break;
		end

		lsDoFrame();
		lsSleep(25);
		checkBreak();
	end

	if not stop_cooking then
		if selected then
			qtyrequested = getQuantity(selected);
		end

		if (qtyrequested > 0) then
			makeToxin(selected);
		end
	end
end

function doit()
	askForWindow("Pin Toxin Kitchen window and press SHIFT over the ATITD window.");

	srReadScreen();
	window_pos = findText("This is [a-z]+ Toxin Kitchen", nil, REGEX);
	
	if window_pos == nil then
		error "Did not find any Toxin Kitchen window";
	end

	srClickMouseNoMove(window_pos[0] + 10, window_pos[1] + 2, false);
	lsSleep(readDelay);

	while not stop_cooking do
		displayMenu();
		checkBreak();
	end
end
