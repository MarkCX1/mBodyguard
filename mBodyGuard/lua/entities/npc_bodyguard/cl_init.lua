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

local nextDistCheck = CurTime() + 1

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

local function spawnBotLoop()
    -- Code to spawn a bot goes here
    print("Bot spawned!")
    timer.Simple(10, spawnBotLoop) -- Spawn a new bot after 10 seconds
end

-- Bind the loop to the F5 key
hook.Add("PlayerBindPress", "SpawnBotLoopBind", function(ply, bind, pressed)
    if bind == "f5" and pressed then
        spawnBotLoop()
        return true -- Return true to prevent the bind from doing its default action
    end
end)


net.Receive("bodyguard_talkingto_npc", function()

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

		local selectedGuard -- Declare selectedGuard 

		local guardinfo = vgui.Create("DButton", hirepanel)
		guardinfo:Dock(FILL)
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

		local selectedGuard
		local hiredGuards = {} -- table to store the names of hired bodyguards


		-- function to add a hired bodyguard to the table
		local function addHiredGuard(name)
			hiredGuards[name] = true
		end

		-- function to check if a bodyguard is hired
		local function isHired(name)
			return hiredGuards[name] ~= nil
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

		hook.Add("PostDrawOpaqueRenderables", "DrawPlayerESP", function()
			local ESP_COLOR = Color(0, 22, 255) -- Blue
			local ESP_MATERIAL = Material("sprites/light_glow02_add_noz")
			local DISTANCE_THRESHOLD = 9999 -- The distance at which the text stops growing
			local DISTANCE_UNIT = "m" -- The unit to use for distance

			for _, ply in ipairs(player.GetAll()) do
				if ply:Team() == TEAM_BODYGUARD and isHired(ply:GetName()) then -- Only draw the ESP for hired bodyguards
					local pos = ply:GetPos()

					-- Offset the position to draw the dot above the player's head
					pos = pos + Vector(0, 0, 80)

					-- Calculate the distance between the local player and the bodyguard player
					local distance = math.Clamp(LocalPlayer():GetPos():Distance(ply:GetPos()), 0, DISTANCE_THRESHOLD)

					-- Set the scale of the text based on the distance
					local scale = distance / 1000 + 0.5 -- Scale from 0.5 to 1.0

					-- Draw the text with the distance in meters
					local text = "Guard\n" .. math.Round(distance) .. " " .. DISTANCE_UNIT
					local textpos = pos + Vector(0, 0, 10) -- Offset the text above the guard
					local textcolor = ESP_COLOR
					local textfont = "DermaLarge"

					cam.Start3D2D(textpos, Angle(0, EyeAngles().y - 90, 90), scale)
						render.SetBlend(50)
						draw.SimpleTextOutlined(text, textfont, 0, 0, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
						render.SetBlend(255)
					cam.End3D2D()

					-- Draw the glowing sprite with the same scale
					render.SetMaterial(ESP_MATERIAL)
					render.DrawSprite(pos, 100 * scale, 100 * scale, ESP_COLOR)
				end
			end
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


	end



	
end)


