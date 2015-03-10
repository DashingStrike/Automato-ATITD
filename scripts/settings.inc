
dofile("serialize.inc");

settingsFileName = "";
settingsInitialized = false;
settings = {};

function readSetting(name,default)
	initialize();
	if(settings[name] == nil) then
		return default;
	end
	return settings[name];
end

function writeSetting(name,value)
	initialize();
	if(value == nil) then
		value = false;
	end
	settings[name] = value;
	if(readSetting("saveSettings",true)) then
		serialize(settings,settingsFileName);
	else
		local s = {};
		s["saveSettings"] = false;
		serialize(s,settingsFileName);
	end
end

-- initialize() never needs to be called directly, scripts should just use readSetting() and writeSetting()
function initialize()
	if(settingsInitialized) then
		return;
	end
	settingsInitialized = true;
	settingsFileName = "Settings." .. lsScriptName() .. ".txt";
	local success;
	success, settings = deserialize(settingsFileName);
	if(not success) then
		settings = {};
	end
end



