-- Author: Tutmault
-- Include Library
-- Contains Lures, Fish, and other arrays related to chat/fishing.
--
-- Update these if adding new fish
-- Lures: Lure Name (Use Lure Menu)
-- Chat_Types: Unique messages to perform a specific routine

-- The {Lures} list should be in alphabetical order for proper operation

Lures = {
"Ash Centipede",
"Bat Mite",
"Blister Beetle",
"Bloodworm",
"Bristleworm",
"Camel Weevel",
"Clay Slug",
"Clearwing",
"Corn Maggot",
"Corkscrew Asp",
"Desert Millipede",
"Dew Fly",
"Feather Midge",
"Footworm",
"Fruit Maggot",
"Glass Worm",
"Golden Asp",
"Grass Slug",
"Hairy Slug",
"Honey Fly",
"Horned Hookworm",
"Leafhopper",
"Leaf Snapper",
"Mud Asp",
"Needleworm",
"Nightwing",
"Nippleworm",
"Orchid Hopper",
"Oyster Mite",
"Pickel Slug",
"Queen Maggot",
"Raspberry Moth",
"Red Cricket",
"Ringed Wasp",
"Rose Mite",
"Rose Swallowtail",
"Ruby Hornborrer",
"Salt Mite",
"Sand Mite",
"Skinlicker",
"Slime Moth",
"Snowberry Butterfly",
"Spittlebug",
"Stone Fly",
"Toad Sawfly",
"White Mealybug",
"White Sawfly",
"Woodmoth",
"Woolly Aphid",
};


Chat_Types = {
["deben"] = "caught",
["You are carrying"] = "overweight",
["You have achieved"] = "achievement",
["You are already fishing"] = "alreadyfishing",
["Using a"] = "lure",
["odd fish"] = "odd",
["strange fish"] = "strange",
["unusual fish"] = "unusual",
["lost your lure"] = "lostlure",
};


Isis_List = {
["boat is damaged"] = "isis1",
["rare artifact"] = "isis2",
["fragment shines"] = "isis3",
["uneasy feeling"] = "isis4",
};


Ignore_List = {
["You are already fishing"] = "alreadyfishing",
["is ready"] = "forgecb",
["fillet a fish"] = "fillet",
["move"] = "move",
};


-- Don't change order, we want the best towards the top, worst at the bottom. We want to select the best lure first.
Lure_Types = {
"Glassified",
"Petrified",
"Mummified",
"Hardened",
"Preserved",
"Glazed",
"Fresh",
};


function WriteFishLog(Text)
	FileFish = io.open("FishLog.txt","a+");
	FileFish:write(Text);
	FileFish:close();
end


function WriteFishStats(Text)
	FileFish = io.open("FishStats.txt","w+");
	FileFish:write(Text);
	FileFish:close();
end
