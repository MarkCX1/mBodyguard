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

print("Loaded bodyguard_config.lua")
