include("shared.lua")

surface.CreateFont( "NpcFont", {
	font = "Roboto", 
	extended = false,
	size = 50,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "NpcFont1", {
	font = "Roboto", 
	extended = false,
	size = 24,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "NpcFont3", {
	font = "Roboto", 
	extended = false,
	size = 26,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


function ENT:Draw()

if( self:GetPos():Distance( LocalPlayer():GetPos() ) > 1500 ) then return end

self:DrawModel()

if( self:GetPos():Distance( LocalPlayer():GetPos() ) > 500 ) then return end
	
local ang = self:GetAngles()

ang:RotateAroundAxis( self:GetAngles():Right(),270 )
ang:RotateAroundAxis( self:GetAngles():Forward(),90 )

local pos = self:GetPos() + ang:Right() * -85 + ang:Up() * 0 + ang:Forward() * -16

cam.Start3D2D(pos,ang,0.1)

	draw.RoundedBox( 0, 10, 43, 300,75, Color(30,30,30,255) )

	draw.SimpleText( "Parcel Worker", "NpcFont", 163, 75, Color(255,255,255), 1, 1 )

cam.End3D2D()

end


net.Receive("parcel_work_menu", function()

	local pl = net.ReadEntity()
	
	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( 0, 0 )
	Frame:SetSize( 550, 250 )
	Frame:SetTitle( "Parcel NPC" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:ShowCloseButton( false )
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

	local Button2 = vgui.Create( "DButton", Panel )
	Button2:SetText( "" )
	Button2:Dock(BOTTOM)
	Button2:DockMargin(5,0,5,5)
	Button2:SetTextColor( Color( 255, 255, 255 ) )
	Button2:SetSize( 125, 50 )
	Button2.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 34, 32, 250 ) ) 
		
		if Button2:IsHovered() then
			surface.SetDrawColor(40,40,40,250)
			surface.DrawRect(0,0,w,h)
			draw.SimpleText("DECLINE","NpcFont3",w/2,h/2,Color(190,33,33),1,1)
		else
			draw.SimpleText("DECLINE","NpcFont1",w/2,h/2,Color(255,255,255),1,1)
		end
		surface.SetDrawColor(50,50,50)
		surface.DrawOutlinedRect(0,0,w,h)
	end

	Button2.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")
		timer.Simple(0.4, function()
			NPCText:SetText("See you later!")
		end)
		timer.Simple(0.9, function()
			Frame:Close()
		end)
	end
	
	local Button = vgui.Create( "DButton", Panel )
	Button:SetText( "" )
	Button:Dock(BOTTOM)
	Button:DockMargin(5,1,5,5)
	Button:SetTextColor( Color( 255, 255, 255 ) )
	Button:SetSize( 125, 50 )
	Button.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 34, 32, 250 ) ) 
		draw.SimpleText("ACCEPT","NpcFont1",w/2,h/2,Color(255,255,255),1,1)
		surface.SetDrawColor(50,50,50)
		surface.DrawOutlinedRect(0,0,w,h)
		
		if Button:IsHovered() then
			surface.SetDrawColor(40,40,40,250)
			surface.DrawRect(0,0,w,h)
			draw.SimpleText("ACCEPT","NpcFont3",w/2,h/2,Color(33,190,33),1,1)
		else
			draw.SimpleText("ACCEPT","NpcFont1",w/2,h/2,Color(255,255,255),1,1)
		end
	end

	Button.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")
		timer.Simple(0.4, function()
			NPCText:SetText("Great! I appreciate it man!")
			net.Start("parcel_start_job")
				net.WriteEntity(pl)
			net.SendToServer()
		end)
		timer.Simple(0.9, function()
			Frame:Close()
		end)
	end
	
	local ModelPanel = vgui.Create("SpawnIcon", Panel)
	ModelPanel:SetSize(100,100)
	ModelPanel:Dock(LEFT)
	ModelPanel:DockMargin(5,5,5,5)
	ModelPanel:SetModel("models/odessa.mdl")
	
	NPCText = vgui.Create("DLabel", Panel)
	NPCText:Dock(FILL)
	NPCText:DockMargin(5,5,5,5)
	NPCText:SetFont("DermaDefaultBold")
	NPCText:SetText("Hey I got a delivery job for you, think you can handle it?")
	NPCText:SetTextColor(Color(255,255,255))
	
	local CloseBTN = vgui.Create("DButton", Frame)
	CloseBTN:SetSize(16,16)
	CloseBTN:SetText("X")
	CloseBTN:SetPos(525, 5)
	CloseBTN.DoClick = function()
		Frame:Close()
		surface.PlaySound("ui/buttonclick.wav")
	end
	CloseBTN.Paint = function(s,w,h)
		if CloseBTN:IsHovered() then
			surface.SetDrawColor(192,32,32)
			surface.DrawRect(0,0,w,h)
		end
		CloseBTN:SetTextColor(Color(255,255,255))
	end
end)
