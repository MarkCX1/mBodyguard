if not BODYGUARD.Config.Job then
    error("BODYGUARD.Config not found?")
end

TEAM_BODYGUARD = DarkRP.createJob(BODYGUARD.Config.Job.name, BODYGUARD.Config.Job)

print("loaded sh_bodyguard.lua")
