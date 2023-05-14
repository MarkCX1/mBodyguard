BODYGUARD = BODYGUARD or {}

BODYGUARD.Config = BODYGUARD.Config or {}

BODYGUARD.Config.Job = {

    name = "Bodyguard",
    color = Color(255, 140, 0, 255),
    model = "models/player/barney.mdl",
    description = [[You are a professional poopy bodyguard.]],
    weapons = {"weapon_pistol", "weapon_stunstick"},
    command = "bodyguard",
    max = 200,
    salary = 50,
    admin = 0,
    vote = false,
    category = "Citizens",

}

BODYGUARD.Config.Waypoint = {
    --message = "Guard: ", -- set to "" to disable
    drawcolor = Color(0,0,222,255), -- set to 0,0,0,0 to disable (WILL HIDE NAME TOO)
    icondrawcolor = Color(255,255,255,255),
    waypointdraw = 1000, -- Distance in 'm' you want it to stop drawing at.
    --namefont = "GuardSystem.Big", -- (Big,Medium,Small) all available fonts.
    distfont = "GuardSystem.Small" -- (Big,Medium,Small) all available fonts.
}

print("Loaded bodyguard_config.lua")
