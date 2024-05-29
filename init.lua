SPEED_BOOST_MULTIPLIER = 10
HEALTH_BOOST_MULTIPLIER = 10

player_credits = player_credits or {}
player_health_boost = player_health_boost or {}
player_speed_bost = player_speed_bost or {}

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

function player_speed_bost.GetSpeedBoost(ply)
    return player_speed_bost[ply:SteamID()] or 0
end

function player_speed_bost.SetSpeedBoost(ply, amount)
    player_speed_bost[ply:SteamID()] = amount
end

function player_speed_bost.AddSpeedBoost(ply, amount)
    player_speed_bost[ply:SteamID()] = (player_speed_bost[ply:SteamID()] or 0) + amount
end

function player_speed_bost.RemoveSpeedBoost(ply, amount)
    player_speed_bost[ply:SteamID()] = (player_speed_bost[ply:SteamID()] or 0) - amount
end

-- VGUI
local PANEL = {}
PANEL.ColorIdle = Color(255, 0, 0)
PANEL.ColorHovered = Color(0, 255, 0)
function PANEL:Paint(w, h)
    local color = self.ColorIdle
    if self:IsHovered() then
        color = self.ColorHovered
    end
    surface.SetDrawColor(color)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("SkillsPanel", PANEL, "DButton")

-- Hooks
local function Spawn( ply )
    -- Set Health
    ply:SetHealth( ply:GetMaxHealth() + (player_health_boost.GetHealthBoost(ply) * HEALTH_BOOST_MULTIPLIER) )
    -- Set Speed Boost
    ply:SetWalkSpeed( ply:GetWalkSpeed() + (player_speed_bost.GetSpeedBoost(ply) * SPEED_BOOST_MULTIPLIER) )
    ply:SetRunSpeed( ply:GetRunSpeed() + (player_speed_bost.GetSpeedBoost(ply) * SPEED_BOOST_MULTIPLIER) )
end
hook.Add( "PlayerSpawn", "set_player_skills", Spawn )

hook.Add( "PlayerButtonDown", "OpenMenu", function( ply, button )
	if button != KEY_F2 then return end

	if CLIENT and not IsFirstTimePredicted() then
		return
	end

	print( ply:Nick() )
    vgui.Create("SkillsPanel")

end)