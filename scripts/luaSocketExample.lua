
-- Requires Automato version 1.78!

-- This script shows very simple and basic web access using the new LuaSocket version 3.0-rc1 module compiled into Automato for us by Jimbly.
-- It also shows how you can add additional modules and use them in Automato.  You will need to open the console to see any output at all.
-- There is a lot more you can do with LuaSockets than just a simple http request. Visit http://w3.impa.br/~diego/software/luasocket/ to learn
-- more about this very handy module.

local http = require("socket.http"); -- load http functions.

-- If you...
-- goto http://dkolf.de/src/dkjson-lua.fsl/home/ and get the dkjson.lua script
-- and put it in the new Automato\luaLibs\ folder that contains the new socket.lua file.
-- ... and uncomment the next line...  
-- local json = require("dkjson"); -- If you put the dkjson.lua script in the right location, you'll now have access to this module.
-- ... you can then uncomment the commented lines in doit() to see json decoding (one of the easier methods of encoding, transfering, and decoding data).


-- Many many many thanks to Jimb for adding the LuaSocket module! This opens a lot of possibilities for us, like being able to harvest mushrooms
-- and automatically update the mushroom databases online with the location, date, time, and count of mushroom spawns without having to switch to
-- a browser to do so, or having to take notes to manually enter these values later.
-- If I get a chance, I plan to do such a script and others using the features of LuaSocket.  Until then I wanted to at least show my appreciation
-- to Jimb and help everyone else to get started using this new feature.
-- Catch ya in ATiTD!
-- ~ Dreger ~


function doit()
    
    lsPrintln(socket._VERSION); -- LuaSocket 3.0-rc1
    
    local res = http.request("http://jt-development.com/luaSocketExample.php"); -- http://jt-development.com/luaSocketExample.php will output JSON encoded data
    
    lsPrintln(res); -- print to console what we got.
    
    -- local values = json.decode(res); -- convert json encoded data to lua data.
    -- lsPrintln(values['bugs']); -- null
    -- lsPrintln(values['instruments'][1]); -- violin
    -- lsPrintln(values['animals'][2]); -- cat
    
    res = http.request("http://jt-development.com/luaSocketExample.php?test=ohBuggar!"); -- adding "?test=something" to this script will tell the script to return a simple json encoded test="something" string.
    lsPrintln(res); -- { "test":"ohBuggar!" }
    
    -- values = json.decode(res); -- convert json encoded data to lua data.
    -- lsPrintln(values['test']); -- ohBuggar!
    
end


-- This is the luaSocketExample.php script on my server:

-- <?PHP
-- if (!isset($_REQUEST['test']))
--         print('{ "bugs":null, "instruments":["violin","trombone","theremin"], "animals":["dog","cat","aardvark"] }');
-- else
--         print('{ "test":"' . $_REQUEST['test'] . '" }');
-- ?>


