--shit addon #6

include("shared.lua")

surface.CreateFont( "bg_font", {
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

	draw.SimpleText( "Guard Worker", "bg_font", 163, 75, Color(255,255,255), 1, 1 )

cam.End3D2D()

end

net.Receive("bodyguard_talkingto_npc", function()

	local pl = net.ReadEntity()
	
	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( 0, 0 )
	Frame:SetSize( 550, 250 )
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


end)


