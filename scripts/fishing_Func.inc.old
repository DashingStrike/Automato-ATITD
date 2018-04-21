-- Author: Tutmault
-- Include Library
-- Contains Lures, Fish, and other images related to chat/fishing.
--
-- Update these if adding new pictures to "Automato/games/ATITD/images/fishing/"
-- Lures: Lure Picture (Use Lure Menu)
-- Chat_Types: Unique message picture to identify chat line
--CL_Fish: Picture of Fish Name from Main Chat
--CL_Number: Picture of Size from Main Chat (db caught)
--CL_Time: Picture of Time from Main Chat using Special->What Time is it?

-- TIP: Should there ever be new fish to add at a later time, you do not actually have to catch the fish (blue chat in main chat) for screenshot
-- Instead post what you want to a Microphone board, the chat will show up as blue in main chat screen ;)
-- Take a screenshot of that, instead of waiting to catch it manually.

-- It is important that you note this... The order that the array appears, is the order it searches for a match.
-- The first entry will always match before the last entry in the array. So the order listed can be its own "if .. then .." statement.


Lures = {
"Lure_AshCentipede.png",
"Lure_BatMite.png",
"Lure_BlisterBeetle.png",
"Lure_Bloodworm.png",
"Lure_Bristleworm.png",
"Lure_CamelWeevel.png",
"Lure_ClaySlug.png",
"Lure_Clearwing.png",
"Lure_CornMaggot.png",
"Lure_CorkscrewAsp.png",
"Lure_DesertMillipede.png",
"Lure_DewFly.png",
"Lure_FeatherMidge.png",
"Lure_Footworm.png",
"Lure_FruitMaggot.png",
"Lure_Glassworm.png",
"Lure_GoldenAsp.png",
"Lure_GrassSlug.png",
"Lure_HairySlug.png",
"Lure_Honeyfly.png",
"Lure_HornedHookworm.png",
"Lure_Leafhopper.png",
"Lure_LeafSnapper.png",
"Lure_MudAsp.png",
"Lure_Needleworm.png",
"Lure_NightWing.png",
"Lure_Nippleworm.png",
"Lure_OrchidHopper.png",
"Lure_OysterMite.png",
"Lure_PickelSlug.png",
"Lure_QueenMaggot.png",
"Lure_RaspberryMoth.png",
"Lure_RedCricket.png",
"Lure_RingedWasp.png",
"Lure_RoseMite.png",
"Lure_RoseSwallowTail.png",
"Lure_RubyHornborrer.png",
"Lure_SaltMite.png",
"Lure_SandMite.png",
"Lure_SkinLicker.png",
"Lure_SlimeMoth.png",
"Lure_SnowberryButterfly.png",
"Lure_Spittlebug.png",
"Lure_Stonefly.png",
"Lure_ToadSawfly.png",
"Lure_WhiteMealybug.png",
"Lure_WhiteSawfly.png",
"Lure_Woodmoth.png",
"Lure_WollyAphid.png",
};

--Picture/ID

-- Do not change the current order of Chat_Types or else there may be consequences. Add to the end of the list. 
-- Other arrays on this page most likely doesn't matter on the order. The lost lure images needs to be higher above similiar images
-- Example, "oddlostlure" must be listed above the "odd" entry. If not, then "oddlostlure" won't ever get triggered, because it will find a match to the "odd" image first.

Chat_Types = {
["Using a"] = "lure",
["also lost your lure"] = "oddlostlure",
["odd fish"] = "odd",

["clumbsy. You also lost your lure"] = "strangelostlure",
["You almost caught a strange"] = "strange",
["enough. You also lost your lure"] = "unusuallostlure",
["unusual fish"] = "unusual",
["No fish bit. You also lost your lure"] = "nobitlostlure",
["You didn't catch anything. You also lost your lure"] = "nocatchlostlure",
["Though you lost your lure"] = "caughtlostlure",
["Caught a"] = "caught",
["You are carrying"] = "carry",
["You are already fishing"] = "alreadyfishing",
["You didn't catch"] = "nocatch",
["No fish bit."] = "nobit",
};

-- Don't change order, we want the best towards the top, worst at the bottom. We want to select the best lure first.
Lure_Types = {
"Lure_Menu_Fresh.png",
"Lure_Menu_Glazed.png",
"Lure_Menu_Preserved.png",
"Lure_Menu_Hardened.png",
"Lure_Menu_Mummified.png",
"Lure_Menu_Petrified.png",
"Lure_Menu_Glassified.png",
};


function WriteFishLog(Text)
	FileFish = io.open("fishlog.txt","a+");
	FileFish:write(Text);
	FileFish:close();
	
end


function WriteFishStats(Text)
	FileFish = io.open("fishstats.txt","w+");
	FileFish:write(Text);
	FileFish:close();
	
end
