if CLIENT then

        surface.CreateFont( "Test", {
            font = "Roboto",
            extended = false,
            size = 25,
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
end
        -- Define the ESP circle color and radius
        local ESP_COLOR = Color(255, 0, 0) -- Red
        local ESP_RADIUS = 100

        -- Draw the ESP circle for each player
        hook.Add("HUDPaint", "DrawPlayerESP", function()
            for _, ply in ipairs(player.GetAll()) do
                if ply:Team() == TEAM_BODYGUARD then -- Only draw the ESP circle for bodyguards
                    local pos = ply:GetPos():ToScreen()
                    surface.SetDrawColor(ESP_COLOR)
                    surface.DrawCircle(pos.x, pos.y, ESP_RADIUS, ESP_COLOR)
                end
            end
        end)


        print("LOADED FILE")
