include("shared.lua")

surface.CreateFont("GuardSystem.Big", {
    font = "BudgetLabel",
	additive = false,
	outline = false,
    size = 50, 
    weight = 1000
})
surface.CreateFont("GuardSystem.Medium", {
    font = "BudgetLabel",
	additive = false,
	outline = false,
    size = 25, 
    weight = 1000
})
surface.CreateFont("GuardSystem.Small", {
    font = "BudgetLabel",
	additive = false,
	outline = false,
    size = 15, 
    weight = 1000
})

local nextDistCheck = CurTime() + 2


function ENT:Draw()
    self:DrawModel()

    self.withinDist = self.withinDist or false 

    if nextDistCheck < CurTime() then
        nextDistCheck = CurTime() + 1
        if LocalPlayer():GetPos():Distance(self:GetPos()) < 350 then
            self.withinDist = true 
        else 
            self.withinDist = false
        end
    end
    if self.withinDist then
        local ang = self:GetAngles()
        ang:RotateAroundAxis(self:GetAngles():Right(), 90)
        ang:RotateAroundAxis(self:GetAngles():Forward(), 90)

        local z = math.sin(CurTime() * 4) * 15

        cam.Start3D2D(self:GetPos() + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
            surface.SetDrawColor(18, 18, 18, 200)
            surface.SetFont("GuardSystem.Big")
            local text = "Guard Worker"
            local color = Color(0,128,255)
            local tW, tH  = surface.GetTextSize(text) + 20
            surface.DrawRect(-tW / 2 + 15, -800 -z, tW, 50)
				draw.SimpleTextOutlined(text, "GuardSystem.Big", 15, -800 + 25 - z, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)

        cam.End3D2D()
    end
end

net.Receive("bodyguard_talkingto_npc", function()

	local selectedGuard
	local hiredGuards = {} -- table to store the names of hired bodyguards


	-- ADD BODYGUARD TO TABLE
	local function addHiredGuard(name)
		hiredGuards[name] = true
	end

	-- CHECK IF BODYGUARD IS HIRED
	local function isHired(name)
		return hiredGuards[name] ~= nil
	end


    local pl = net.ReadEntity()
    
    local Frame = vgui.Create( "DFrame" )
    Frame:SetPos( ScrW()/2 - Frame:GetWide()/2, 50 )
    Frame:SetSize( 550, 500 )
    Frame:SetTitle( "Guard NPC" )
    Frame:SetVisible( true )
    Frame:SetDraggable( true )
    Frame:ShowCloseButton( true )
    Frame:MakePopup()
    Frame:Center()
    Frame:SetBackgroundBlur( true )
    Frame.Paint = function( self, w, h ) 
        draw.RoundedBox( 4, 4, 4, w-8, h-8, Color( 0, 0, 0, 250 ) ) 
    end
    
    Panel = vgui.Create("DPanel", Frame)
    Panel:Dock(FILL)
    Panel:DockMargin(5,5,5,5)
    Panel.Paint = function(s,w,h)
        surface.SetDrawColor(50,50,50,250)
        surface.DrawRect(0,0,w,h)
    end

    local DScrollPanel = vgui.Create("DScrollPanel", Panel)
    DScrollPanel:Dock(FILL)
	

	for k, v in pairs(player.GetAll()) do
		if v:Team() != TEAM_BODYGUARD then
			print("No guards found!")
			continue
		end
		print("Found guards!")

		local hirepanel = vgui.Create("DPanel", DScrollPanel)
		hirepanel:Dock(TOP)
		hirepanel:SetTall(90)
		hirepanel.Paint = function(self, w, h)
			surface.SetDrawColor(25, 25, 25, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		local MdlPanel = vgui.Create("DPanel", hirepanel) -- Creating MDL First to be furthest on left
		MdlPanel:Dock(LEFT)
		MdlPanel:SetWide(100)
		MdlPanel.Paint = function(self, w, h)
			surface.SetDrawColor(40, 40, 40, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		local hireinfo = vgui.Create("DButton", MdlPanel) -- Set mdlPanel as the parent
		hireinfo:Dock(BOTTOM) -- Dock to the top of the mdlPanel
		hireinfo:SetMouseInputEnabled(false)
		hireinfo:SetText("")
		hireinfo:SetTall(20)
		local text = v:GetName()
		hireinfo.Paint = function(self, w, h)
			surface.SetDrawColor(25, 25, 25, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawOutlinedRect(0, 0, w, h)
			surface.SetFont("GuardSystem.Small")
			local tw, th = surface.GetTextSize(text)
			surface.SetTextColor(255, 255, 255, 255)
			surface.SetTextPos(w / 2 - tw / 2, h / 2 - th / 2)
			surface.DrawText(text)
		end

		local selectedGuard -- Declaring selectedGuard 

		local guardinfo = vgui.Create("DButton", hirepanel)
		guardinfo:Dock(FILL)
		guardinfo:SetMouseInputEnabled(false)
		guardinfo:SetText("")
		guardinfo:SetTall(20)

		local text = v:GetName() .. " - Health: " .. v:Health()
		guardinfo.Paint = function(self, w, h)
			surface.SetDrawColor(25, 25, 25, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawOutlinedRect(0, 0, w, h)
			surface.SetFont("GuardSystem.Small")
			local tw, th = surface.GetTextSize(text)
			surface.SetTextColor(255, 255, 255, 255)
			surface.SetTextPos(w / 2 - tw / 2, h / 2 - th / 2)
			surface.DrawText(text)
		end

		local hirebuy = vgui.Create("DButton", hirepanel)
		hirebuy:Dock(RIGHT)
		hirebuy:SetText("")
		hirebuy:SetTall(25)
		hirebuy:SetWide(100)

		local text = "BUY"
		hirebuy.Paint = function(self, w, h)
			surface.SetDrawColor(25, 25, 25, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawOutlinedRect(0, 0, w, h)
			surface.SetFont("GuardSystem.Small")
			local tw, th = surface.GetTextSize(text)
			surface.SetTextColor(255, 255, 255, 255)
			surface.SetTextPos(w / 2 - tw / 2, h / 2 - th / 2)
			surface.DrawText(text)
		end

		hirebuy.DoClick = function()
			selectedGuard = v:GetName() -- Set selectedGuard to the guard
			if not selectedGuard then return end 
			print("Buying guard: " .. selectedGuard)
			net.Start("bodyguard_request_npc")
			net.WriteString(selectedGuard) -- send the selectedGuard to the server
			net.SendToServer()
			addHiredGuard(selectedGuard) -- add the hired bodyguard to the table
			
			Frame:Close()
		end

		-- callback function for the net message that informs the client when a bodyguard has been hired
		net.Receive("bodyguard_hired", function()
			local name = net.ReadString()
			
			addHiredGuard(name)
		end)

		hirebuy.Paint = function(self, w, h)
			surface.SetDrawColor(135, 206, 250, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawOutlinedRect(0, 0, w, h)
			surface.SetFont("GuardSystem.Big")
			local tw, th = surface.GetTextSize(text)
			surface.SetTextColor(255, 255, 255, 255)
			surface.SetTextPos(w / 2 - tw / 2, h / 2 - th / 2)
			surface.DrawText(text)
		end

		local icon = vgui.Create("DModelPanel", MdlPanel)
		icon:Dock(FILL)
		icon:SetMouseInputEnabled(false)
		icon:SetModel(BODYGUARD.Config.Job.model)

		function icon:LayoutEntity(ent)
			if not IsValid(ent) then
				if icon:GetParent() then icon:GetParent():Remove() end
				return
			end

			local eyepos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"))

			icon:SetLookAt(eyepos)
			icon:SetCamPos(eyepos + Vector(15, 0, -2))
		end


		hook.Add("PostDrawOpaqueRenderables", "DrawPlayerESP", function()
			for _, ply in ipairs(player.GetAll()) do
				if ply:Team() == TEAM_BODYGUARD and isHired(ply:GetName()) then -- Only draw the ESP for hired bodyguards
					local pos = ply:GetPos()

					-- chest area
					pos = pos + Vector(0, 0, 50)

					-- Draw icon with the distance in meters above the player's head
					local distance = math.Round(LocalPlayer():GetPos():Distance(ply:GetPos()))
					local distanceText = distance .. "m"
					local distanceScale = math.Clamp(distance / 1000, 0.2, 10)

					if distance >= BODYGUARD.Config.Waypoint.waypointdraw then
						cam.Start3D2D(pos + Vector(0, 0, 20), Angle(0, EyeAngles().y - 90, 90), distanceScale)
						cam.IgnoreZ(true)
						draw.SimpleText(distanceText, BODYGUARD.Config.Waypoint.distfont, 0, -20, BODYGUARD.Config.Waypoint.drawcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						surface.SetMaterial(Material("icon16/flag_blue.png"))
						surface.SetDrawColor(BODYGUARD.Config.Waypoint.icondrawcolor)
						surface.DrawTexturedRect(-16, -4, 32, 32)
						cam.IgnoreZ(false)
						cam.End3D2D()
					end

					-- white dot
					render.SetMaterial(Material("sprites/light_glow02_add_noz"))
					render.DrawSprite(pos, 100, 100, BODYGUARD.Config.Waypoint.drawcolor)
				end
			end
		end)



		
	
	end
end)


