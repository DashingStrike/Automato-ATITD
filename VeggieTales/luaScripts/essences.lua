--
--
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

per_click_delay = 10;

essences = {
--Name						, Rock, Wood, Worm, Grn, Veg, Min, Fish, Grey,
"HerbAnansi.png"			, 0   ,  0  ,  0  , 2  , 8  ,  0 ,  0  ,  0  ,
"HerbBanto.png"				, 0   ,  0  ,  0  , 0  , 0  ,  8 ,  2  ,  0  ,
"HerbBeeBalm.png"			, 0   ,  0  ,  10 , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbBlackPepperPlant.png"  , 0   ,  0  ,  2  , 1  , 7  ,  0 ,  0  ,  0  ,
"HerbBluebottleClover.png"  , 0   ,  0  ,  8  , 2  , 0  ,  0 ,  0  ,  0  ,
"HerbBuckler-Leaf.png"      , 0   ,  0  ,  0  , 0  , 6  ,  4 ,  0  ,  0  ,
"HerbCardamom.png"			, 0   ,  0  ,  8  , 2  , 0  ,  0 ,  0  ,  0  ,
--"HerbChatinabrae.png"       , 0   ,  0  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
--Name						, Rock, Wood, Worm, Grn, Veg, Min, Fish, Grey,
"HerbChives.png"			, 0   ,  0  ,  5  , 0  , 5  ,  0 ,  0  ,  0  ,
"HerbCinnamon.png"			, 0   ,  0  ,  0  , 7  , 3  ,  0 ,  0  ,  0  ,
"HerbCommonBasil.png"       , 0   ,  0  ,  2  , 0  , 8  ,  0 ,  0  ,  0  ,
"HerbCommonRosemary.png"    , 0   ,  0  ,  5  , 0  , 0  ,  5 ,  0  ,  0  ,
"HerbCommonSage.png"		, 0   ,  0  ,  0  , 0  , 3  ,  7 ,  0  ,  0  ,
"HerbCovage.png"			, 0   ,  0  ,  0  , 0  , 6  ,  4 ,  0  ,  0  ,
"HerbCrampbark.png"			, 0   ,  0  ,  0  , 0  , 1  ,  1 ,  0  ,  8  ,
"HerbCrimsonLettuce.png"    , 0   ,  0  ,  7  , 3  , 0  ,  0 ,  0  ,  0  ,
"HerbDaggerleaf.png"		, 0   ,  0  ,  2  , 7  , 1  ,  0 ,  0  ,  0  ,
"HerbDalchini.png"			, 2   ,  8  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbDarkOchoa.png"			, 0   ,  4  ,  6  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbDiscorea.png"			, 0   ,  0  ,  0  , 8  , 2  ,  0 ,  0  ,  0  ,
"HerbDrapeauD'or.png"       , 0   ,  0  ,  0  , 0  , 0  ,  1 ,  0  ,  9  ,
"HerbDwarfHogweed.png"      , 0   ,  0  ,  0  , 0  , 0  ,  0 ,  10 ,  0  ,
"HerbDwarfWildLettuce.png"  , 0   ,  0  ,  0  , 8  , 2  ,  0 ,  0  ,  0  ,
"HerbFleabane.png"			, 0   ,  0  ,  0  , 0  , 0  ,  10 ,  0  ,  0,
"HerbFoolsAgar.png"			, 3   ,  7  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
--"HerbGingerRoot.png"		, 0   ,  0  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbGlechoma.png"			, 0   ,  0  ,  0  , 0  , 0  ,  3 ,  7  ,  0  ,
"HerbHarebell.png"			, 7   ,  3  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbHazlewort.png"			, 0   ,  1  ,  0  , 0  , 9  ,  0 ,  0  ,  0  ,
"HerbHouseleek.png"			, 0   ,  0  ,  0  , 0  , 0  ,  7 ,  3  ,  0  ,
"HerbHyssop.png"			, 0   ,  0  ,  2  , 1  , 7  ,  0 ,  0  ,  0  ,
"HerbIndigoDamia.png"       , 0   ,  9  ,  1  , 0  , 0  ,  0 ,  0  ,  0  ,
--"HerbJaggedDewcup.png"      , 0   ,  0  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbLemondrop.png"			, 0   ,  0  ,  0  , 0  , 4  ,  6 ,  0  ,  0  ,
"HerbLythrum.png"			, 0   ,  6  ,  4  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbMariae.png"			, 0   ,  0  ,  0  , 0  , 2  ,  8 ,  0  ,  0  ,
"HerbMeadowsweet.png"       , 0   ,  0  ,  0  , 0  , 0  ,  2 ,  0  ,  8  ,
"HerbMindanao.png"			, 0   ,  0  ,  4  , 0  , 6  ,  0 ,  0  ,  0  ,
"HerbMorpha.png"			, 1   ,  9  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbMotherwort.png"		, 0   ,  0  ,  0  , 0  , 1  ,  1 ,  0  ,  8  ,
"HerbMountainMint.png"      , 0   ,  0  ,  0  , 0  , 0  ,  10,  0  ,  0  ,
"HerbMyristica.png"			, 0   ,  0  ,  0  , 0  , 10 ,  0 ,  0  ,  0  ,
"HerbOpalHarebell.png"      , 0   ,  0  ,  0  , 0  , 0  ,  0 ,  0  ,  10  ,
--"HerbOrangeNiali.png"       , 0   ,  0  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbPaleDhamasa.png"       , 0   ,  0  ,  0  , 0  , 0  ,  0 ,  10 ,  0  ,
--"HerbPanoe.png"				, 0   ,  0  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbPrisniparni.png"       , 0   ,  0  ,  4  , 6  , 0  ,  0 ,  0  ,  0  ,
"HerbPurpleTintiri.png"     , 0   ,  0  ,  5  , 0  , 5  ,  0 ,  0  ,  0  ,
"HerbSatsatchi.png"			, 0   ,  0  ,  3  , 7  , 0  ,  0 ,  0  ,  0  ,
"HerbShrubbyBasil.png"		, 0   ,  0  ,  0  , 0  , 0  ,  5 ,  5  ,  0  ,
"HerbShrubSage.png"			, 0   ,  0  ,  0  , 5  , 5  ,  0 ,  0  ,  0  ,
"HerbShyama.png"			, 0   ,  0  ,  9  , 1  , 0  ,  0 ,  0  ,  0  ,
"HerbSilvertongueDamia.png" , 0   ,  0  ,  1  , 3  , 6  ,  0 ,  0  ,  0  ,
"HerbSorrel.png"			, 0   ,  0  ,  0  , 4  , 6  ,  0 ,  0  ,  0  ,
--"HerbSpinach.png"			, 0   ,  0  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbSticklerHedge.png"		, 0   ,  5  ,  0  , 0  , 5  ,  0 ,  0  ,  0  ,
--Name						, Rock, Wood, Worm, Grn, Veg, Min, Fish, Grey,
"HerbStrawberryTea.png"     , 0   ,  0  ,  0  , 0  , 7  ,  3 ,  0  ,  0  ,
--"HerbSweetflower.png"       , 0   ,  0  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbSweetgrass.png"		, 8   ,  2  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbThyme.png"				, 0   ,  0  ,  0  , 0  , 0  ,  0 ,  0  ,  10 ,
"HerbTinyClover.png"		, 0   ,  10 ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
--"HerbTrueTarragon.png"      , 0   ,  0  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"HerbTsangto.png"			, 0   ,  0  ,  8  , 2  , 0  ,  0 ,  0  ,  0  ,
"HerbVerdantSquill.png"     , 0   ,  0  ,  0  , 0  , 0  ,  2 ,  8  ,  0  ,
"HerbWildLettuce.png"       , 0   ,  0  ,  7  , 0  , 3  ,  0 ,  0  ,  0  ,
"HerbXanosi.png"			, 0   ,  0  ,  5  , 1  , 0  ,  4 ,  0  ,  0  ,
"HerbYigori.png"			, 0   ,  0  ,  0  , 8  , 0  ,  2 ,  0  ,  0  ,
"MiscMarbleDust.png"		, 0   ,  0  ,  6  , 4  , 0  ,  0 ,  0  ,  0  ,
"GemAmethyst.png"			, 0   ,  0  ,  0  , 5  , 5  ,  0 ,  0  ,  0  ,
"PearlAqua.png"				, 0   ,  5  ,  0  , 0  , 3  ,  2 ,  0  ,  0  ,
"PearlBeige.png"			, 0   ,  0  ,  4  , 6  , 0  ,  0 ,  0  ,  0  ,
"PearlBlack.png"			, 0   ,  0  ,  0  , 0  , 0  ,  5 ,  5  ,  0  ,
"GemCitrine.png"			, 0   ,  0  ,  0  , 0  , 0  ,  3 ,  7  ,  0  ,
"PearlCoral.png"			, 0   ,  0  ,  0  , 0  , 0  ,  2 ,  8  ,  0  ,
"GemDiamond.png"			, 0   ,  5  ,  0  , 0  , 3  ,  2 ,  0  ,  0  ,
"GemEmerald.png"			, 0   ,  0  ,  0  , 0  , 5  ,  5 ,  0  ,  0  ,
"GemGarnet.png"				, 0   ,  0  ,  6  , 4  , 0  ,  0 ,  0  ,  0  ,
"GemJade.png"				, 0   ,  0  ,  0  , 8  , 0  ,  2 ,  0  ,  0  ,
"GemLapis.png"				, 0   ,  0  ,  5  , 5  , 0  ,  0 ,  0  ,  0  ,
"GemOpal.png"				, 0   ,  0  ,  0  , 5  , 5  ,  0 ,  0  ,  0  ,
"PearlPink.png"				, 0   ,  0  ,  2  , 8  , 0  ,  0 ,  0  ,  0  ,
"GemQuartz.png"				, 0   ,  0  ,  0  , 1  , 7  ,  2 ,  0  ,  0  ,
"GemRuby.png"				, 0   ,  0  ,  0  , 1  , 0  ,  0 ,  0  ,  9  ,
"GemSapphire.png"			, 0   ,  0  ,  0  , 7  , 3  ,  0 ,  0  ,  0  ,
"PearlSmoke.png"			, 0   ,  0  ,  0  , 0  , 0  ,  7 ,  3  ,  0  ,
"GemSunstone.png"			, 0   ,  0  ,  0  , 1  , 8  ,  1 ,  0  ,  0  ,
"GemTopaz.png"				, 0   ,  0  ,  0  , 0  , 0  ,  9 ,  1  ,  0  ,
"GemTurquoise.png"			, 4   ,  6  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"PearlWhite.png"			, 0   ,  0  ,  0  , 0  , 0  ,  5 ,  5  ,  0  ,
"SaltsAluminum.png"			, 0   ,  6  ,  4  , 0  , 0  ,  0 ,  0  ,  0  ,
"SaltsAntimony.png"			, 0   ,  0  ,  0  , 0  , 0  ,  9 ,  1  ,  0  ,
"SaltsCopper.png"			, 0   ,  0  ,  0  , 0  , 1  ,  9 ,  0  ,  0  ,
"SaltsGold.png"				, 0   ,  0  ,  9  , 1  , 0  ,  0 ,  0  ,  0  ,
"SaltsIron.png"				, 9   ,  1  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"SaltsLead.png"				, 0   ,  1  ,  0  , 0  , 9  ,  0 ,  0  ,  0  ,
"SaltsLithium.png"			, 0   ,  0  ,  1  , 3  , 6  ,  0 ,  0  ,  0  ,
"SaltsMagnesium.png"		, 0   ,  5  ,  5  , 0  , 0  ,  0 ,  0  ,  0  ,
"SaltsPlatinum.png"			, 0   ,  0  ,  0  , 0  , 0  ,  1 ,  9  ,  0  ,
"SaltsSilver.png"			, 8   ,  2  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"SaltsStrontium.png"		, 0   ,  0  ,  0  , 8  , 2  ,  0 ,  0  ,  0  ,
"SaltsTin.png"				, 0   ,  0  ,  0  , 0  , 1  ,  2 ,  0  ,  7  ,
"SaltsTitanium.png"			, 0   ,  0  ,  0  , 2  , 8  ,  0 ,  0  ,  0  ,
"SaltsTungsten.png"			, 0   ,  4  ,  6  , 0  , 0  ,  0 ,  0  ,  0  ,
"SaltsZinc.png"				, 0   ,  0  ,  0  , 2  , 8  ,  0 ,  0  ,  0  ,
"ResinAnaxi.png"			, 0   ,  8  ,  2  , 0  , 0  ,  0 ,  0  ,  0  ,
"ResinArconis.png"			, 0   ,  0  ,  8  , 2  , 0  ,  0 ,  0  ,  0  ,
"ResinAshPalm.png"			, 0   ,  1  ,  9  , 0  , 0  ,  0 ,  0  ,  0  ,
"ResinBeetlenut.png"		, 0   ,  0  ,  7  , 3  , 0  ,  0 ,  0  ,  0  ,
"ResinBloodBark.png"		, 0   ,  0  ,  0  , 0  , 6  ,  4 ,  0  ,  0  ,
"ResinBottleTree.png"		, 0   ,  1  ,  1  , 0  , 0  ,  8 ,  0  ,  0  ,
"ResinBrambleHedge.png"     , 0   ,  5  ,  0  , 0  , 3  ,  2 ,  0  ,  0  ,
"ResinBroadleafPalm.png"    , 0   ,  0  ,  0  , 0  , 1  ,  0 ,  0  ,  9  ,
"ResinButterleafTree.png"   , 0   ,  0  ,  0  , 0  , 1  ,  0 ,  0  ,  9  ,
"ResinCeruleanBlue.png"     , 0   ,  0  ,  0  , 0  , 2  ,  8 ,  0  ,  0  ,
"ResinChakkanutTree.png"    , 0   ,  1  ,  9  , 0  , 0  ,  0 ,  0  ,  0  ,
"ResinChicory.png"			, 0   ,  0  ,  0  , 0  , 9  ,  1 ,  0  ,  0  ,
"ResinCinnar.png"			, 0   ,  0  ,  2  , 1  , 7  ,  0 ,  0  ,  0  ,
"ResinCoconutPalm.png"      , 0   ,  4  ,  6  , 0  , 0  ,  0 ,  0  ,  0  ,
"ResinCricklewood.png"      , 0   ,  0  ,  2  , 8  , 0  ,  0 ,  0  ,  0  ,
"ResinDeltaPalm.png"		, 0   ,  1  ,  0  , 0  , 5  ,  4 ,  0  ,  0  ,
"ResinElephantia.png"       , 0   ,  0  ,  5  , 5  , 0  ,  0 ,  0  ,  0  ,
"ResinFeatherTree.png"      , 0   ,  0  ,  2  , 0  , 8  ,  0 ,  0  ,  0  ,
"ResinFernPalm.png"			, 0   ,  0  ,  0  , 0  , 1  ,  1 ,  0  ,  8  ,
"ResinFoldedBirch.png"      , 0   ,  8  ,  2  , 0  , 0  ,  0 ,  0  ,  0  ,
"ResinGiantCricklewood.png" , 0   ,  1  ,  9  , 0  , 0  ,  0 ,  0  ,  0  ,
"ResinHawthorn.png"			, 0   ,  0  ,  0  , 0  , 0  ,  0 ,  10 ,  0  ,
"ResinHokkaido.png"			, 0   ,  0  ,  0  , 0  , 1  ,  9 ,  0  ,  0  ,
"ResinKaeshra.png"			, 0   ,  0  ,  0  , 0  , 7  ,  3 ,  0  ,  0  ,
"ResinLocustPalm.png"       , 0   ,  1  ,  0  , 0  , 9  ,  0 ,  0  ,  0  ,
"ResinMiniatureFernPalm.png", 0   ,  6  ,  4  , 0  , 0  ,  0 ,  0  ,  0  ,
"ResinMiniPalmetto.png"     , 0   ,  0  ,  0  , 6  , 0  ,  4 ,  0  ,  0  ,
"ResinMonkeyPalm.png"       , 0   ,  0  ,  1  , 9  , 0  ,  0 ,  0  ,  0  ,
"ResinOilPalm.png"			, 0   ,  0  ,  1  , 3  , 6  ,  0 ,  0  ,  0  ,
"ResinOleaceae.png"			, 0   ,  0  ,  0  , 0  , 6  ,  4 ,  0  ,  0  ,
"ResinOrrorin.png"			, 0   ,  0  ,  2  , 1  , 7  ,  0 ,  0  ,  0  ,
"ResinPassam.png"			, 0   ,  0  ,  0  , 0  , 0  ,  0 ,  10 ,  0  ,
"ResinPhoenixPalm.png"      , 0   ,  0  ,  2  , 8  , 0  ,  0 ,  0  ,  0  ,
"ResinPratyekaTree.png"     , 0   ,  0  ,  0  , 0  , 0  ,  9 ,  1  ,  0  ,
"ResinRanyahn.png"			, 0   ,  0  ,  0  , 0  , 0  ,  7 ,  3  ,  0  ,
"ResinRazorPalm.png"		, 0   ,  0  ,  0  , 5  , 5  ,  0 ,  0  ,  0  ,
"ResinRedMaple.png"			, 0   ,  0  ,  0  , 5  , 0  ,  5 ,  0  ,  0  ,
"ResinRoyalPalm.png"		, 0   ,  0  ,  0  , 0  , 10 ,  0 ,  0  ,  0  ,
"ResinSavaka.png"			, 0   ,  1  ,  9  , 0  , 0  ,  0 ,  0  ,  0  ,
"ResinSpikedFishtree.png"   , 0   ,  0  ,  0  , 0  , 9  ,  1 ,  0  ,  0  ,
"ResinSpindleTree.png"      , 0   ,  2  ,  0  , 0  , 7  ,  1 ,  0  ,  0  ,
"ResinStoutPalm.png"		, 0   ,  1  ,  1  , 0  , 0  ,  8 ,  0  ,  0  ,
"ResinTapacaeMiralis.png"   , 0   ,  0  ,  0  , 0  , 0  ,  0 ,  0  ,  10 ,
"ResinTinyOilPalm.png"      , 0   ,  10 ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
--Name						, Rock, Wood, Worm, Grn, Veg, Min, Fish, Grey,
"ResinToweringPalm.png"     , 9   ,  1  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"ResinTrilobellia.png"      , 3   ,  7  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"ResinUmbrellaPalm.png"     , 9   ,  1  ,  0  , 0  , 0  ,  0 ,  0  ,  0  ,
"ResinWindriverPalm.png"    , 0   ,  0  ,  7  , 3  , 0  ,  0 ,  0  ,  0  ,
};

last = 0;

spirits = {
"placeholder", "RockSpirits.png", "WoodSpirits.png", "WormSpirits.png", "GrainSpirits.png", "VegetableSpirits.png",
"MineralSpirits.png", "FishSpirits.png", "GreySpirits.png"};

function clickAll(image_name, up)
	if nil then
		lsPrintln("Would click '".. image_name .. "'");
		return; -- not clicking buttons for debugging
	end
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		statusScreen("Could not find specified buttons...");
		lsSleep(1500);
	else
		statusScreen("Clicking " .. #buttons .. "button(s)...");
		if up then
			for i=#buttons, 1, -1  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3);
				lsSleep(per_click_delay);
			end
		else
			for i=1, #buttons  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3);
				lsSleep(per_click_delay);
			end
		end
		statusScreen("Done clicking (" .. #buttons .. " clicks).");
		lsSleep(50);
	end
end

function clickOnce(image_name)
	-- Find buttons and click them!
	srReadScreen();
--	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages("Chem/" .. image_name);
		
	if #buttons == 0 then
		statusScreen("Searching for " .. image_name);
		return false;
	else
		statusScreen("Clicking " .. #buttons .. "button(s)...");
		srClickMouseNoMove(buttons[1][0]+5, buttons[1][1]+3);
		statusScreen("Done clicking.");
		lsSleep(500);
		return true;
	end
end

function clickOnceReq(image_name)
	local numErr = 0;
	while (numErr < 5 and not clickOnce(image_name)) == true do
		numErr = numErr+1;
		lsSleep(1000);
	end
	if (numErr == 15) then
		error ("Could not find Chem/" .. image_name);
	end
end


function runEssence()
	--find first essence and click
	clickAll("Chem/ChemLab.png");
	lsSleep(50);
	if clickOnce("Manufacture.png") == false then
		return false;
	end
	lsSleep(50);
	if clickOnce("EssentialDistillation.png") == false then
		return false;
	end
	lsSleep(50);
	clickOnceReq("PlaceEssence.png");
	local found = false;
	local index = 0;
	--Search 5 times for Find the essence to be loaded
	for i = 0, 5, 1 do
		lsSleep(50);
		if found then
			break
		end 
		for j = 0, (#essences/9) - 1, 1 do
			local cur = (last+j)%(#essences/9)
			found = clickOnce(essences[(9*cur)+1]);
			if found then
				index = cur;
				last = cur;
				break
			end
		end
	end
	if not found then
		error "Could not find Essence";
	end
	lsSleep(50);
	clickOnceReq("Ok.png");
	
	--add the alcohols
	
	local test = "";
	
	for i = 1, 8, 1 do
		local cur = essences[9*index + i+1];
		if cur ~= 0 then
			lsSleep(250);
			clickOnceReq("Manufacture.png");
			clickOnceReq("AlcoholLamp.png");
			clickOnceReq("FillAlch.png");
			clickOnceReq(spirits[i+1]);
			lsSleep(50);
			srKeyEvent(cur .. "\n");
			lsSleep(50);
		end
		test = test .. cur;
	end
	
	--alcohol added, now start the distillation
	clickOnceReq("Manufacture.png");
	clickOnceReq("EssentialDistillation.png");
	clickOnceReq("StartEssential.png");
	
	return true;
end
	
	--Search through all essences
function doit()
	askForWindow("Script Author: Skyfeather\n\nPin any number of Chemistry Labs, ensure you have at least one of the following spirits: "..
	              "Fish, Grain, Grey, Mineral, Rock, Vegetable, Wood, Worm, and stash all inventory except Essential material & spirits. ".. 
			"Keyboard entry is not recommended while macro is loading spirits.");
	while (1) do
		if runEssence() then
			lsSleep(100);
		else
			lsSleep(500);
		end
	end
end