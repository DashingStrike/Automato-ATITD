-- treated boards  v1.0 by Dunagain
-- helper for finding the k-values, can be used as a basis for a fully automated k-values finder

posTank = {};
posFlexibility = {} ;
posCuttability = {} ;
posFlammability = {} ;
posWaterResist = {} ;
posInsectTox = {} ;
posHumanTox = {} ;
posDarkness  = {} ;
posGlossiness = {} ;

flexibility = 0;
cuttability = 0;
flammability = 0;
waterResist = 0;
insectTox = 0;
humanTox = 0;
darkness = 0;
glossiness = 0;

trace = "" ;

blueColors = { 	0X010130FF, 0x0706FDFF, 0x0707FEFF, 
				0x0706FEFF, 0x0606FDFF, 0x0605D4FF, 
				0x0505D4FF, 0x0605D5FF, 0x040382FF, 
				0x030382FF, 0x040383FF, 0x807FFEFF, 
				0x7FFFFEFF, 0X2F2EFDFF, 0X2E2EFDFF, 
				0xD0D0FFFF, 0x7F7FFEFF } ;

treatedWater = {} ;

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
  Treated Boards v1.0 by Dunagain --
  Helps you making treated boards with a wood treatment tank
]]);

function isRigid()
	return flexibility < 8 ;
end

function isPliable()
	return flexibility > 57 ;
end

function isHard()
	return cuttability < 8 ;
end

function isSoft()
	return cuttability > 57 ;
end

function isFireproof()
	return flammability < 8  ;
end

function isVolatile()
	return flammability > 57 ;
end

function isRotproof()
	return waterResist > 57 ;
end

function isTermiteProne()
	return insectTox < 8 ;
end

function isTermiteResistant()
	return insectTox > 57 ;
end

function isNonToxic()
	return humanTox < 8 ;
end

function isWhite()
	return darkness < 8 ;
end

function isBlonde()
	return (darkness > 7) and (darkness < 22) ;
end

function isBlack()
	return darkness > 57 ;
end

function isGlossy()
	return glossiness > 57 ;
end

function attributes()
	local result = "";
	if isRigid() then result = result .. "Rigid " end;
	if isPliable() then result = result .. "Pliable " end;
	if isHard() then result = result .. "Hard " end;
	if isSoft() then result = result .. "Soft " end;
	if isFireproof() then result = result .. "Fireproof " end;
	if isVolatile() then result = result .. "Volatile " end;
	if isRotproof() then result = result .. "Rotproof " end;
	if isTermiteProne() then result = result .. "Termite-Prone " end;
	if isTermiteResistant() then result = result .. "Termite-Resistant " end;
	if isNonToxic() then result = result .. "Non-Toxic " end;
	if isWhite() then result = result .. "White " end;
	if isBlonde() then result = result .. "Blonde " end;
	if isBlack() then result = result .. "Black " end;
	if isGlossy() then result = result .. "Glossy" end;
	return result;
end


function matchPixel(pixel)
local match = false;
	for k,v in pairs(blueColors)
	do
		local d = v - pixel ;
		if (d % 4294967296 ==  0)
		then
			match = true  ;
		end
	end
	return match;
end

function calcParam(xpos, ypos)
local result = 0;
	local pixel = srReadPixelFromBuffer(xpos, ypos) ;

	while (matchPixel(pixel) == true)
	do
		result = result + 1 ;
		xpos = xpos + 1;
		pixel = srReadPixelFromBuffer(xpos, ypos) ;		
	end
	return result - 3 ;
end

function calcFlexibility()
	return calcParam(posFlexibility[1], posFlexibility[2]);
end

function calcCuttability()
	return calcParam(posCuttability[1], posCuttability[2]);
end

function calcFlammability()
	return calcParam(posFlammability[1], posFlammability[2]);
end

function calcWaterResist()
	return calcParam(posWaterResist[1], posWaterResist[2]);
end

function calcInsectTox()
	return calcParam(posInsectTox[1], posInsectTox[2]);
end

function calcHumanTox()
	return calcParam(posHumanTox[1], posHumanTox[2]);
end

function calcDarkness()
	return calcParam(posDarkness[1], posDarkness[2]);
end

function calcGlossiness()
	return calcParam(posGlossiness[1], posGlossiness[2]);
end

function calcPos()
    srReadScreen();
	posTank = findImage("ThisIs.png");
	posFlexibility = { posTank[0] + 109 , posTank[1] + 190  } ;
	posCuttability = { posTank[0] + 109 , posTank[1] + 206  } ;
	posFlammability = { posTank[0] + 109 , posTank[1] + 222  } ;
	posWaterResist = { posTank[0] + 109 , posTank[1] + 238  } ;
	posInsectTox = { posTank[0] + 109 , posTank[1] + 254  } ;
	posHumanTox = { posTank[0] + 109 , posTank[1] + 270  } ;
	posDarkness  = { posTank[0] + 109 , posTank[1] + 286  } ;
	posGlossiness = { posTank[0] + 109 , posTank[1] + 302  } ;
end

function doit()
	local done = false
	
	local finished = false;
	local num_seconds
	local estimation = 0
	local start_time = lsGetTimer();
	
	askForWindow("Pin your Wood Treatment Tank window. Pin the Treat... window so it won't interfer with the reading of values. Then press shift to start the K-Values lookup.") ;
	calcPos() ;
	
	
	while not finished
	do
		local startFlexibility = calcFlexibility() ;
		local startCuttability = calcCuttability() ;
		local startFlammability = calcFlammability() ;
		local startWaterResist = calcWaterResist();
		local startInsectTox = calcInsectTox();
		local startHumanTox = calcHumanTox();
		local startDarkness = calcDarkness();
		local startGlossiness = calcGlossiness();
		
		local suggestFlex = false;
		local suggestCut = false;
		local suggestFlam = false;
		local suggestWater = false;
		local suggestInsect = false;
		local suggestHuman = false;
		local suggestDark = false;
		local suggestGloss = false;
		
		local suggest = "From this position, I suggest that you try to:\n ";
		local suggestion = "" ;
		
		if (startFlexibility < 6) then
			suggestion = suggestion .. "\nRaise Flexibility with Ash to 69 or with Saltpeter to 61" ;
		else 
			if (startFlexibility > 60) then
				suggestion = suggestion .. "\nLower Flexibility with Lime (to -3) or Lead (to 5)" ;
			end
		end
		if (startCuttability < 6) then
			suggestion = suggestion .. "\nRaise Cuttability with Saltpeter to 69 or with Potash to 61" ;
		else 
			if (startCuttability > 60) then
				suggestion = suggestion .. "\nLower Cuttability with Sulfur (to -3) or Lead (to 5)" ;
			end
		end
		if (startFlammability < 6) then
			suggestion = suggestion .. "\nRaise Flammability with Petroleum to 69 or with Sulfur to 61" ;
		else 
			if (startFlammability > 60) then
				suggestion = suggestion .. "\nLower Flammability with Ash (to -3) or Lime (to 5)" ;
			end
		end
		if (startWaterResist < 6) then
			suggestion = suggestion .. "\nRaise Water Resist with Beeswax to 69 or with Petroleum to 61" ;
		else 
			if (startWaterResist > 60) then
				suggestion = suggestion .. "\nLower Water Resist with Water (to -3) or Potash (to 5)" ;
			end
		end
		if (startInsectTox < 6) then
			suggestion = suggestion .. "\nRaise InsectTox with Lead to 69 or with Petroleum to 61" ;
		else 
			if (startInsectTox > 60) then
				suggestion = suggestion .. "\nLower InsectTox with Water (to -3) or Lime (to 5)" ;
			end
		end
		if (startHumanTox < 6) then
			suggestion = suggestion .. "\nRaise HumanTox with Sulfur to 69 or with Lead to 61" ;
		else 
			if (startHumanTox > 60) then
				suggestion = suggestion .. "\nLower HumanTox with Water (to -3) or Saltpeter (to 5)" ;
			end
		end
		if (startDarkness < 6) then
			suggestion = suggestion .. "\nRaise Darkness with Lead to 69 or with Petroleum to 61" ;
		else 
			if (startDarkness > 60) then
				suggestion = suggestion .. "\nLower Darkness with Lime (to -3) or Potash (to 5)" ;
			end
		end
		if (startGlossiness < 6) then
			suggestion = suggestion .. "\nRaise Glossiness with Beeswax to 69 or with Oil to 61" ;
		else 
			if (startGlossiness > 60) then
				suggestion = suggestion .. "\nLower Glossiness with Ash (to -3) or Potash (to 5)" ;
			end
		end

		
		done = false;
		while not done
		do
			lsPrintWrapped(10, 15, 5, lsScreenX-15, 0.8, 0.8, 0xFFFFFFFF,
				"Press start before treating the boards! (Read the Wood Treatment Guide on wiki, the part about the K-Values, if you don't know what to do)\n" .. suggest .. suggestion) ;
			checkBreak();
			lsDoFrame();
			lsSleep(25);
			if lsButtonText(lsScreenX - 110, lsScreenY - 60, 0, 100, 0xFFFFFFff, "Start") then
				done = true;
			end		
		end
		done = false
		start_time = lsGetTimer();

		
		while not done	
		do
			calcPos() ;
			flexibility = calcFlexibility() ;
			cuttability = calcCuttability() ;
			flammability = calcFlammability() ;
			waterResist = calcWaterResist();
			insectTox = calcInsectTox();
			humanTox = calcHumanTox();
			darkness = calcDarkness();
			glossiness = calcGlossiness();
			
			lsPrintWrapped(10, 45, 5, lsScreenX-15, 1, 1, 0xFFFFFFFF,
				"Flexibility: " .. tostring(flexibility) .. "\n" ..
				"Cuttability: " .. tostring(cuttability) .. "\n" ..
				"Flammability: " .. tostring(flammability)  .. "\n" ..
				"Water Resist: " .. tostring(waterResist)  .. "\n" ..
				"Insect Toxicity: " .. tostring(insectTox)  .. "\n" ..
				"Human Toxicity: " .. tostring(humanTox) .. "\n" ..
				"Darkness: " .. tostring(darkness) .. "\n" ..
				"Glossiness: " .. tostring(glossiness) .. "\n" ..
			 attributes() .. "\n" .. trace) ;
			checkBreak();
			lsDoFrame();
			lsSleep(25);
			if lsButtonText(lsScreenX - 110, lsScreenY - 60, 0, 100, 0xFFFFFFff, "Stop") then
				done = true;
			end		
		end
		estimation = math.floor((lsGetTimer() - start_time) / 1000);
		num_seconds = promptNumber("How many seconds? [" .. estimation .. "]" , estimation);
		done = false
		local kvalue = "" ;
		local endFlexibility = calcFlexibility() ;
		local endCuttability = calcCuttability() ;
		local endFlammability = calcFlammability() ;
		local endWaterResist = calcWaterResist();
		local endInsectTox = calcInsectTox();
		local endHumanTox = calcHumanTox();
		local endDarkness = calcDarkness();
		local endGlossiness = calcGlossiness();
		while not done
		do
			

			lsPrintWrapped(10, 25, 5, lsScreenX-15, 1, 1, 0xFFFFFFFF,
				"Select the property that you have been watching:" 
			 ) ;
			if lsButtonText(10, lsScreenY - 270, 0, 200, 0xFFFFFFff, "Flexibility") then
				kvalue = "Formula: (" .. math.abs(endFlexibility - startFlexibility) .. "*" .. math.abs(endFlexibility - startFlexibility) .. ") / " .. num_seconds .. ".0 / 2.0" .. "\nValue: " .. tostring(((endFlexibility - startFlexibility)*(endFlexibility - startFlexibility)/num_seconds)/2.0 )
				done = true;
			end		
			if lsButtonText(10, lsScreenY - 240, 0, 200, 0xFFFFFFff, "Cuttability") then
				kvalue = "Formula: (" .. math.abs(endCuttability - startCuttability) .. "*" .. math.abs(endCuttability - startCuttability) .. ") / " .. num_seconds .. ".0 / 2.0" .. "\nValue: " .. tostring(((endCuttability - startCuttability)*(endCuttability - startCuttability)/num_seconds)/2.0 )
				done = true;
			end		
			if lsButtonText(10, lsScreenY - 210, 0, 200, 0xFFFFFFff, "Flammability") then
				kvalue = "Formula: (" .. math.abs(endFlammability - startFlammability) .. "*" .. math.abs(endFlammability - startFlammability) .. ") / " .. num_seconds .. ".0 / 2.0" .. "\nValue: " .. tostring(((endFlammability - startFlammability)*(endFlammability - startFlammability)/num_seconds)/2.0 )
				done = true;
			end		
			if lsButtonText(10, lsScreenY - 180, 0, 200, 0xFFFFFFff, "Water Resist") then
				kvalue = "Formula: ("..  math.abs(endWaterResist - startWaterResist) .. "*" .. math.abs(endWaterResist - startWaterResist) .. ") / " .. num_seconds .. ".0 / 2.0" .. "\nValue: " .. tostring(((endWaterResist - startWaterResist)*(endWaterResist - startWaterResist)/num_seconds)/2.0 )
				done = true;
			end		
			if lsButtonText(10, lsScreenY - 150, 0, 200, 0xFFFFFFff, "Insect Toxicity") then
				kvalue = "Formula: (" .. math.abs(endInsectTox - startInsectTox) .. "*" .. math.abs(endInsectTox - startInsectTox) .. ") / " .. num_seconds .. ".0 / 2.0" .. "\nValue: " .. tostring(((endInsectTox - startInsectTox)*(endInsectTox - startInsectTox)/num_seconds)/2.0 )
				done = true;
			end		
			if lsButtonText(10, lsScreenY - 120, 0, 200, 0xFFFFFFff, "Human Toxicity") then
				kvalue = "Formula: (" .. math.abs(endHumanTox - startHumanTox) .. "*" .. math.abs(endHumanTox - startHumanTox) .. ") / " .. num_seconds .. ".0 / 2.0" .. "\nValue: " .. tostring(((endHumanTox - startHumanTox)*(endHumanTox - startHumanTox)/num_seconds)/2.0 )
				done = true;
			end		
			if lsButtonText(10, lsScreenY - 90, 0, 200, 0xFFFFFFff, "Darkness") then
				kvalue = "Formula: (" .. math.abs(endDarkness - startDarkness) .. "*" .. math.abs(endDarkness - startDarkness) .. ") / " .. num_seconds .. ".0 / 2.0" .. "\nValue: " .. tostring(((endDarkness - startDarkness)*(endDarkness - startDarkness)/num_seconds)/2.0 )
				done = true;
			end		
			if lsButtonText(10, lsScreenY - 60, 0, 200, 0xFFFFFFff, "Glossiness") then
				kvalue = "Formula: (" .. math.abs(endGlossiness - startGlossiness) .. "*" .. math.abs(endGlossiness - startGlossiness) .. ") / " .. num_seconds .. ".0 / 2.0" .. "\nValue: " .. tostring(((endGlossiness - startGlossiness)*(endGlossiness - startGlossiness)/num_seconds)/2.0 )
				done = true;
			end		
			checkBreak();
			lsDoFrame();
			lsSleep(25);
		end
		done = false
		while not done
		do
			lsPrintWrapped(10, 25, 5, lsScreenX-15, 0.8, 0.8, 0xFFFFFFFF,
				kvalue
			 ) ;
			if lsButtonText(lsScreenX - 110, lsScreenY - 60, 0, 100, 0xFFFFFFff, "Again") then
				done = true;
			end		
			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				finished = true;
				done = true;
			end
			checkBreak();
			lsDoFrame();
			lsSleep(25);
		end
	end

end
