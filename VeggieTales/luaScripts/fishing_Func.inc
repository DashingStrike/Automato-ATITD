-- Author: Tutmault
-- Include Library
-- Contains Lures, Fish, and other images related to chat/fishing.
--
-- Update these if adding new pictures to "veggietales/fishing/"
-- Lures: Lure Picture (Use Lure Menu)
-- Chat_Types: Unique message picture to identify chat line
--CL_Fish: Picture of Fish Name from Main Chat
--CL_Number: Picture of Size from Main Chat (db caught)
--CL_Time: Picture of Time from Main Chat using Special->What Time is it?

-- TIP: Should there ever be new fish to add at a later time, you do not actually have to catch the fish (blue chat in main chat) for screenshot
-- Instead post what you want to a Microphone board, the chat will show up as blue in main chat screen ;)
-- Take a screenshot of that, instead of waiting to catch it manually.

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
"ChatLog_UsingALure.png","lure",
"Chatlog_AlmostCaughtOddLostLure.png","oddlostlure",
"Chatlog_AlmostCaughtOdd.png","odd",

"Chatlog_AlmostCaughtStrangeLostLure.png","strangelostlure",
"Chatlog_AlmostCaughtStrange.png","strange",
"Chatlog_AlmostCaughtUnusualLostLure.png","unusuallostlure",
"Chatlog_AlmostCaughtUnusual.png","unusual",
"Chatlog_NoBitLostLure.png","nobitlostlure",
"Chatlog_NoCatchLostLure.png","nocatchlostlure",
"Chatlog_ThoughYouLost.png","caughtlostlure",
"ChatLog_CaughtA.png","caught",
"Chatlog_CarryMuch.png","carry",
"Chatlog_CarryBulk.png","carry",
"Chatlog_AlreadyFishing.png","alreadyfishing",
"ChatLog_FailedToCatch.png","nocatch",
"ChatLog_NoFishBit.png","nobit",
};

CL_Fish = {
"Chatlog_Fish_AmurPike.png",
"Chatlog_Fish_Abdju.png",
"ChatLog_Fish_Ayu.png",
"Chatlog_Fish_BayLobster.png",
"Chatlog_Fish_BottlenoseSquid.png",
"Chatlog_Fish_Camelfish.png",
"Chatlog_Fish_Carp.png",
"Chatlog_Fish_Catfish.png",
"Chatlog_Fish_CherryBonefish.png",
"Chatlog_Fish_Chromis.png",
"Chatlog_Fish_FlyingFish.png",
"Chatlog_Fish_GiantCrayfish.png",
"Chatlog_Fish_GreatKnucklefish.png",
"Chatlog_Fish_HornedPigfish.png",
"Chatlog_Fish_HylianLoach.png",
"Chatlog_Fish_IvoryKnifeFish.png",
"Chatlog_Fish_Kingfish.png",
"Chatlog_Fish_LimaChub.png",
"Chatlog_Fish_Malapterurus.png",
"Chatlog_Fish_MedusaFish.png",
"Chatlog_Fish_Moonfish.png",
"ChatLog_Fish_NileMackerel.png",
"ChatLog_Fish_OctecsLongfin.png",
"Chatlog_Fish_Octopus.png",
"Chatlog_Fish_OrangeSpongefish.png",
"Chatlog_Fish_Otterfish.png",
"Chatlog_Fish_PancakeLoach.png",
"Chatlog_Fish_Perch.png",
"Chatlog_Fish_Phagrus.png",
"Chatlog_Fish_QueenLionFish.png",
"Chatlog_Fish_RainbowCod.png",
"Chatlog_Fish_Razorfin.png",
"Chatlog_Fish_ReticulatedToothFish.png",
"Chatlog_Fish_RibbonFish.png",
"Chatlog_Fish_RiverCrab.png",
"Chatlog_Fish_Serpentfish.png",
"Chatlog_Fish_SeaUrchin.png",
"Chatlog_Fish_ShelomitsPuffer.png",
"Chatlog_Fish_SingingLamprey.png",
"Chatlog_Fish_SpinyDogfish.png",
"Chatlog_Fish_SpoonFish.png",
"Chatlog_Fish_SpottedSeaCucumber.png",
"Chatlog_Fish_StripedBatfin.png",
"Chatlog_Fish_TigerFish.png",
"Chatlog_Fish_Tilapia.png",
"Chatlog_Fish_Tilefish.png",
"Chatlog_Fish_WhiteOniontail.png",
"Chatlog_Fish_YellowfinSnapper.png",
};

--Don't change order
--Size of fish (db)
CL_Number = {
"ChatLog_1.png",
"ChatLog_2.png",
"ChatLog_3.png",
"ChatLog_4.png",
"ChatLog_5.png",
"ChatLog_6.png",
"ChatLog_7.png",
"ChatLog_8.png",
"ChatLog_9.png",
"ChatLog_10.png",
"ChatLog_11.png",
"ChatLog_12.png",
"ChatLog_13.png",
"ChatLog_14.png",
"ChatLog_15.png",
"ChatLog_16.png",
"ChatLog_17.png",
"ChatLog_18.png",
"ChatLog_19.png",
"ChatLog_20.png",
"ChatLog_21.png",
"ChatLog_22.png",
"ChatLog_23.png",
"ChatLog_24.png",
"ChatLog_25.png",
"ChatLog_26.png",
"ChatLog_27.png",
"ChatLog_28.png",
"ChatLog_29.png",
"ChatLog_30.png",
"ChatLog_31.png",
"ChatLog_32.png",
"ChatLog_33.png",
"ChatLog_34.png",
"ChatLog_35.png",
"ChatLog_36.png",
"ChatLog_37.png",
"ChatLog_38.png",
"ChatLog_39.png",
"ChatLog_40.png",
"ChatLog_41.png",
"ChatLog_42.png",
"ChatLog_43.png",
"ChatLog_44.png",
"ChatLog_45.png",
"ChatLog_46.png",
"ChatLog_47.png",
"ChatLog_48.png",
};

--Don't change order.
--What time?
CL_Time = {
"Chatlog_Time_1.png",
"Chatlog_time_2.png",
"Chatlog_Time_3.png",
"Chatlog_Time_4.png",
"Chatlog_Time_5.png",
"Chatlog_Time_6.png",
"Chatlog_Time_7.png",
"Chatlog_Time_8.png",
"Chatlog_Time_9.png",
"Chatlog_Time_10.png",
"Chatlog_Time_11.png",
"Chatlog_Time_12.png",
};


-- Don't change order, we want the best towards the top, worst at the bottom. We want to select the best lure first.
Lure_Types = {
"Lure_Menu_Petrified.png",
"Lure_Menu_Mummified.png",
"Lure_Menu_Hardened.png",
"Lure_Menu_Preserved.png",
"Lure_Menu_Glazed.png",
"Lure_Menu_Fresh.png",
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
