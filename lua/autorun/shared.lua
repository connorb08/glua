SPEED_BOOST_MULTIPLIER = 10
HEALTH_BOOST_MULTIPLIER = 10

player_credits = player_credits or {}
player_health_boost = player_health_boost or {}
player_speed_boost = player_speed_boost or {}

function player_credits.GetCredits(ply)
    return player_credits[ply:SteamID()] or 0
end

function player_credits.SetCredits(ply, amount)
    player_credits[ply:SteamID()] = amount
end

function player_credits.AddCredits(ply, amount)
    player_credits[ply:SteamID()] = (player_credits[ply:SteamID()] or 0) + amount
end

function player_credits.RemoveCredits(ply, amount)
    player_credits[ply:SteamID()] = (player_credits[ply:SteamID()] or 0) - amount
end

function player_health_boost.GetHealthBoost(ply)
    return player_health_boost[ply:SteamID()] or 0
end

function player_health_boost.SetHealthBoost(ply, amount)
    player_health_boost[ply:SteamID()] = amount
end

function player_health_boost.AddHealthBoost(ply, amount)
    player_health_boost[ply:SteamID()] = (player_health_boost[ply:SteamID()] or 0) + amount
end

function player_health_boost.RemoveHealthBoost(ply, amount)
    player_health_boost[ply:SteamID()] = (player_health_boost[ply:SteamID()] or 0) - amount
end

function player_speed_boost.GetSpeedBoost(ply)
    return player_speed_boost[ply:SteamID()] or 0
end

function player_speed_boost.SetSpeedBoost(ply, amount)
    player_speed_boost[ply:SteamID()] = amount
end

function player_speed_boost.AddSpeedBoost(ply, amount)
    player_speed_boost[ply:SteamID()] = (player_speed_boost[ply:SteamID()] or 0) + amount
end

function player_speed_boost.RemoveSpeedBoost(ply, amount)
    player_speed_boost[ply:SteamID()] = (player_speed_boost[ply:SteamID()] or 0) - amount
end

-- Hooks
local function Spawn( ply )
    -- Set Health
    ply:SetHealth( ply:GetMaxHealth() + (player_health_boost.GetHealthBoost(ply) * HEALTH_BOOST_MULTIPLIER) )
    -- Set Speed Boost
    ply:SetWalkSpeed( ply:GetWalkSpeed() + (player_speed_boost.GetSpeedBoost(ply) * SPEED_BOOST_MULTIPLIER) )
    ply:SetRunSpeed( ply:GetRunSpeed() + (player_speed_boost.GetSpeedBoost(ply) * SPEED_BOOST_MULTIPLIER) )
end
hook.Add( "PlayerSpawn", "set_player_skills", Spawn )

hook.Add( "PlayerButtonDown", "OpenMenu", function( ply, button )
	if button != KEY_F2 then return end

	if CLIENT and not IsFirstTimePredicted() then
		return
	end

    local frame = vgui.Create("DFrame") -- The name of the panel we don't have to parent it.
    frame:SetPos(100, 100) -- Set the position to 100x by 100y. 
    frame:SetSize(800, 500) -- Set the size to 300x by 200y.
    frame:SetTitle("Derma Frame") -- Set the title in the top left to "Derma Frame".
    frame:MakePopup() -- Makes your mouse be able to move around.

    local credits = vgui.Create( "DLabel", frame ) // Create the button and parent it to the frame
    credits:SetText( string.format("Credits: %d", 5) )					// Set the text on the button
    credits:SetPos( 25, 50 )
    credits:SetSize( 250, 30 )

    local health = vgui.Create( "DLabel", frame ) // Create the button and parent it to the frame
    health:SetText( string.format("health: %d", player_health_boost.GetHealthBoost(ply)) )					// Set the text on the button
    health:SetPos( 25, 75 )
    health:SetSize( 250, 30 )

    local buy_credits = vgui.Create( "DButton", frame ) // Create the button and parent it to the frame
    buy_credits:SetText( "Buy Credits" )					// Set the text on the button
    buy_credits:SetPos( 25, 100 )					// Set the position on the frame
    buy_credits:SetSize( 250, 30 )					// Set the size
    buy_credits.DoClick = function()				// A custom function run when clicked ( note the . instead of : )
        RunConsoleCommand( "say", "Hi" )			// Run the console command "say hi" when you click it ( command, args )
    end

    local increase_health = vgui.Create( "DButton", frame ) // Create the button and parent it to the frame
    increase_health:SetText( "Increase Health" )					// Set the text on the button
    increase_health:SetPos( 25, 150 )					// Set the position on the frame
    increase_health:SetSize( 250, 30 )					// Set the size
    increase_health.DoClick = function()				// A custom function run when clicked ( note the . instead of : )
        -- RunConsoleCommand( "say", "Hi" )			// Run the console command "say hi" when you click it ( command, args )
        player_health_boost.AddHealthBoost(ply, 1)
        print(player_health_boost)
    end

    local decrease_health = vgui.Create( "DButton", frame ) // Create the button and parent it to the frame
    decrease_health:SetText( "Decrease Health" )					// Set the text on the button
    decrease_health:SetPos( 25, 200 )					// Set the position on the frame
    decrease_health:SetSize( 250, 30 )					// Set the size
    decrease_health.DoClick = function()				// A custom function run when clicked ( note the . instead of : )
        RunConsoleCommand( "say", "Hi" )			// Run the console command "say hi" when you click it ( command, args )
    end

    local increase_speed = vgui.Create( "DButton", frame ) // Create the button and parent it to the frame
    increase_speed:SetText( "Increase Speed" )					// Set the text on the button
    increase_speed:SetPos( 25, 250 )					// Set the position on the frame
    increase_speed:SetSize( 250, 30 )					// Set the size
    increase_speed.DoClick = function()				// A custom function run when clicked ( note the . instead of : )
        RunConsoleCommand( "say", "Hi" )			// Run the console command "say hi" when you click it ( command, args )
    end

    local decrease_speed = vgui.Create( "DButton", frame ) // Create the button and parent it to the frame
    decrease_speed:SetText( "Decrease Speed" )					// Set the text on the button
    decrease_speed:SetPos( 25, 300 )					// Set the position on the frame
    decrease_speed:SetSize( 250, 30 )					// Set the size
    decrease_speed.DoClick = function()				// A custom function run when clicked ( note the . instead of : )
        RunConsoleCommand( "say", "Hi" )			// Run the console command "say hi" when you click it ( command, args )
    end


end)