-- Author: Tutmault
-- Include Library
-- Contains Lures, Fish, and other images related to chat/fishing.
--
-- Update these if adding new pictures to "veggietales/fishing/"
-- Lures: Lure Picture (Use Lure Menu)
-- Chat_Types: Unique message picture to identify chat line
--CL_Fish: Picture of Fish Name from Main Chat
--CL_Number: Picture of Size from Main Chat
--CL_Time: Picture of Time from Main Chat using Special->What Time is it?

Lures = {
"Lure_AshCentipede.png",
"Lure_BatMite.png",
"Lure_BlisterBeetle.png",
--Bloodworm
"Lure_Bristleworm.png",
"Lure_CamelWeevel.png",
"Lure_ClaySlug.png",
--Clearwing
--Corn Maggot
"Lure_CorkscrewAsp.png",
"Lure_DesertMillipede.png",
--Dewfly
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
--Nightwing
"Lure_Nippleworm.png",
"Lure_OrchidHopper.png",
"Lure_OysterMite.png",
"Lure_PickelSlug.png",
"Lure_QueenMaggot.png",
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
Chat_Types = {
"ChatLog_UsingALure.png","lure",
"ChatLog_NoFishBit.png","nofish",
"Chatlog_AlmostCaughtStrange.png","strange",
"Chatlog_AlmostCaughtUnusual.png","unusual",
"Chatlog_NoBitLostLure.png","nofishlostlure",
"ChatLog_CaughtA.png","caught",
"Chatlog_CarryMuch.png","carry",
"Chatlog_CarryBulk.png","carry",
"Chatlog_AlreadyFishing.png","alreadyfishing",
"Chat_ThoughYouLost.png","caughtlostlure",
};

CL_Fish = {
"Chatlog_Fish_Abdju.png",
"ChatLog_Fish_Ayu.png",
"Chatlog_Fish_BayLobster.png",
"Chatlog_Fish_Camelfish.png",
"Chatlog_Fish_Carp.png",
"Chatlog_Fish_Catfish.png",
"Chatlog_Fish_Chromis.png",
"Chatlog_Fish_FlyingFish.png",
"Chatlog_Fish_HornedPigfish.png",
"Chatlog_Fish_LimaChub.png",
"Chatlog_Fish_Malapterurus.png",
"ChatLog_Fish_NileMackerel.png",
"ChatLog_Fish_OctecsLongfin.png",
"Chatlog_Fish_Octopus.png",
"Chatlog_Fish_OrangeSpongefish.png",
"Chatlog_Fish_Otterfish.png",
"Chatlog_Fish_PancakeLoach.png",
"Chatlog_Fish_Perch.png",
"Chatlog_Fish_Phagrus.png",
"Chatlog_Fish_RainbowCod.png",
"Chatlog_Fish_SeaUrchin.png",
"Chatlog_Fish_ShelomitsPuffer.png",
"Chatlog_Fish_SingingLamprey.png",
"Chatlog_Fish_StripedBatfin.png",
"Chatlog_Fish_Tilapia.png",
"Chatlog_Fish_Tilefish.png",
};

--Size of fish
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
--47
"ChatLog_48.png",
};

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

Lure_Types = {
"Lure_Menu_Fresh.png",
"Lure_Menu_Glazed.png",
"Lure_Menu_Preserved.png",
};


function WriteFishLog(Text)
	FileFish = io.open("fishing/fishlog.txt","a+");
	FileFish:write(Text);
	FileFish:close();
	
end
