-- cc-assist.lua v1.2 -- by Makazi, revised by Tallow, updated by Manon on 5 jan 2018.
--
-- Provides a control interface for running many charcoal hearths or
-- ovens simultaneously.
--

dofile("common.inc");

askText = singleLine([[
  CC Assist v1.2 (by Makazi, revised by Tallow, updated by Manon on 5 jan 2018) --
  Provides a control interface for running many charcoal hearths or
  ovens simultaneously. Make sure the VT window is in the TOP-RIGHT
  corner of the screen.
]]);

wmText = "Tap Ctrl on Charcoal Hearths or Ovens\nto open and pin. Tap Alt to open, pin\nand stash.";

click_delay = 0;

buttons = {
  {
    name = "Begin",
    buttonPos = makePoint(10, 110),
    buttonSize = 270,
    image = "cc_Begin.png",
    offset = makePoint(25, 10)
  },
  {
    name = "Wood",
    buttonPos = makePoint(10, 166),
    buttonSize = 130,
    image = "cc_Wood.png",
    offset = makePoint(20-4, 30-2)
  },
  {
    name = "Water",
    buttonPos = makePoint(150, 166),
    buttonSize = 130,
    image = "cc_Water.png",
    offset = makePoint(20-10, 30-10)
  },
  {
    name = "Closed",
    buttonPos = makePoint(10, 215),
    buttonSize = 80,
    image = "cc_Vent.png",
    offset = makePoint(20-9, 30-2)
  },
  {
    name = "Open",
    buttonPos = makePoint(105, 215),
    buttonSize = 80,
    image = "cc_Vent.png",
    offset = makePoint(40-9, 30-2)
  },
  {
    name = "Full",
    buttonPos = makePoint(200, 215),
    buttonSize = 80,
    image = "cc_Vent.png",
    offset = makePoint(65-9, 30-2)
  }
};

function doit()
  askForWindow(askText);
	--function windowManager(title, message, allowCascade, allowWaterGap, varWidth, varHeight, sizeRight, offsetWidth, offsetHeight)
  windowManager("Charcoal Setup", wmText, nil, nil, nil, nil, nil, nil, 16);  --add 16 extra pixels to window height because window expands with 'Take...' menu after first batch is created
  unpinOnExit(ccMenu);
end

function ccMenu()
  while 1 do
    for i=1, #buttons do
      if showButton(buttons[i]) then
	runCommand(buttons[i]);
      end
    end
    statusScreen("CC Control Center", 0x00d000ff);
  end
end

function showButton(button)
  return lsButtonText(button.buttonPos[0], button.buttonPos[1],
		      0, button.buttonSize, 0xFFFFFFff, button.name)
end

function runCommand(button)
  clickAllImages(button.image, button.offset[0], button.offset[1]);
end

