AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("bodyguard_talkingto_npc")
util.AddNetworkString("bodyguard_request_npc")



function ENT:Initialize()

	self:SetModel("models/Combine_Soldier.mdl")
	self:SetMoveType( MOVETYPE_STEP )
	self:SetSolid( SOLID_BBOX )
	self:SetUseType( SIMPLE_USE )
    self:SetHullType( HULL_HUMAN )
    self:SetHullSizeNormal()
	self:SetUseType( SIMPLE_USE )
    self:DropToFloor()
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:AcceptInput(name, activator, caller)

	if name == "Use" and caller:IsPlayer() then
		net.Start("bodyguard_talkingto_npc")
			net.WriteEntity(caller)
		net.Send(caller)
	end
end

net.Receive("bodyguard_request_npc", function(len, ply)
    if IsValid(ply) and ply:IsPlayer() then
        local bodyguard = net.ReadString()
        print(ply:Name() .. " has requested a bodyguard '" .. bodyguard .. "' ")
		print(bodyguard,ply)
    end
end)


