if SERVER then 
	-- Constants
	SPEED_BOOST_MULTIPLIER = 10
	HEALTH_BOOST_MULTIPLIER = 10
	TOKEN_COST = 10

	-- Persistency functions
	function SaveData()
		local convertedCredits = util.TableToJSON(player_credits)
		file.Write("creditdata.json", convertedCredits)
		local convertedStats = util.TableToJSON(player_stat_boost)
		file.Write("statdata.json", convertedStats)
	end

	function ReadData()
		local creditJSONData = file.Read("creditdata.json") or "{}"
		player_credits = util.JSONToTable(creditJSONData)
		local statJSONData = file.Read("statdata.json") or "{}"
		player_stat_boost = util.JSONToTable(statJSONData)  
	end

	-- Storage objects
	player_credits = player_credits or {}
	player_stat_boost = player_stat_boost or {}
	ReadData()

	-- CRUD functions
	function GetCredits(ply)
		return player_credits[ply:SteamID()] or 0
	end

	function SetCredits(ply, amount)
		player_credits[ply:SteamID()] = amount
		SaveData()
	end

	function AddCredits(ply, amount)
		player_credits[ply:SteamID()] = (player_credits[ply:SteamID()] or 0) + amount
		SaveData()
	end

	function RemoveCredits(ply, amount)
		player_credits[ply:SteamID()] = (player_credits[ply:SteamID()] or 0) - amount
		SaveData()
	end

	function GetStatBoost(ply)
		return player_stat_boost[ply:SteamID()] or 0
	end

	function SetStatBoost(ply, amount)
		player_stat_boost[ply:SteamID()] = amount
		SaveData()
	end

	function AddStatBoost(ply, amount)
		player_stat_boost[ply:SteamID()] = (player_stat_boost[ply:SteamID()] or 0) + amount
		SaveData()
	end

	function RemoveStatBoost(ply, amount)
		player_stat_boost[ply:SteamID()] = (player_stat_boost[ply:SteamID()] or 0) - amount
		SaveData()
	end

	-- Server side hooks
	-- Spawn Hook
	hook.Add( "PlayerSpawn", "set_player_skills", function( ply )
		timer.Create( "SpawnDelay", 1, 1, function() 
			ply:SetHealth( (ply:GetMaxHealth() + (GetStatBoost(ply) * HEALTH_BOOST_MULTIPLIER)) )
			ply:SetWalkSpeed( (ply:GetWalkSpeed() + (GetStatBoost(ply) * SPEED_BOOST_MULTIPLIER)) )
			ply:SetRunSpeed( (ply:GetRunSpeed() + (GetStatBoost(ply) * SPEED_BOOST_MULTIPLIER)) )
		end )
		
	end) 

end

if CLIENT then

	local credits = credits or 0
	local stat_boost = stat_boost or 0

	-- Menu
	hook.Add( "PlayerButtonDown", "OpenMenu", function( ply, button )
		if button != KEY_F2 then return end

		if not IsFirstTimePredicted() then
			return
		end

		update_credits_and_stats()

		local frame = vgui.Create("DFrame") -- The name of the panel we don't have to parent it.
		frame:SetPos(100, 100) -- Set the position to 100x by 100y. 
		frame:SetSize(800, 500) -- Set the size to 300x by 200y.
		frame:SetTitle("Derma Frame") -- Set the title in the top left to "Derma Frame".
		frame:MakePopup() -- Makes your mouse be able to move around.

		local credit_label = vgui.Create( "DLabel", frame )
		credit_label:SetText( string.format("Credits: %d", credits) )
		credit_label:SetPos( 25, 50 )
		credit_label:SetSize( 250, 30 )

		local stat_label = vgui.Create( "DLabel", frame )
		stat_label:SetText( string.format("Stat Boost: %d", stat_boost) )
		stat_label:SetPos( 250, 50 )
		stat_label:SetSize( 250, 30 )

		local buy_credits = vgui.Create( "DButton", frame )
		buy_credits:SetText( "Buy Credits" )
		buy_credits:SetPos( 25, 100 )
		buy_credits:SetSize( 250, 30 )
		buy_credits.DoClick = function()
			RunConsoleCommand( "say", "Purchase tokens" )
			net.Start( "purchase_token" )
			net.SendToServer()
			update_credits_and_stats()
			credit_label:SetText( string.format("Credits: %d", credits) )
			stat_label:SetText( string.format("Stat Boost: %d", stat_boost) )
		end

		local increase_health = vgui.Create( "DButton", frame )
		increase_health:SetText( "Increase Health" )
		increase_health:SetPos( 25, 150 )
		increase_health:SetSize( 250, 30 )
		increase_health.DoClick = function()
			RunConsoleCommand( "say", "Purchase tokens" )
			net.Start( "increase_stats" )
			net.SendToServer()
			update_credits_and_stats()
			credit_label:SetText( string.format("Credits: %d", credits) )
			stat_label:SetText( string.format("Stat Boost: %d", stat_boost) )
		end

		local decrease_health = vgui.Create( "DButton", frame )
		decrease_health:SetText( "Decrease Health" )
		decrease_health:SetPos( 25, 200 )
		decrease_health:SetSize( 250, 30 )
		decrease_health.DoClick = function()
			RunConsoleCommand( "say", "Purchase tokens" )
			net.Start( "decrease_stats" )
			net.SendToServer()
			update_credits_and_stats()
			credit_label:SetText( string.format("Credits: %d", credits) )
			stat_label:SetText( string.format("Stat Boost: %d", stat_boost) )
		end

		local printCredits = vgui.Create( "DButton", frame )
		printCredits:SetText( "Print Credits" )					
		printCredits:SetPos( 25, 350 )					
		printCredits:SetSize( 250, 30 )					
		printCredits.DoClick = function()				
			print(credits)
		end

		local printStatBoost = vgui.Create( "DButton", frame )
		printStatBoost:SetText( "Print Stat Boost" )					
		printStatBoost:SetPos( 25, 400 )					
		printStatBoost:SetSize( 250, 30 )					
		printStatBoost.DoClick = function()				
			print(stat_boost)
		end

		timer.Create( "CreditDelay", 1, 1, function() 
			credit_label:SetText( string.format("Credits: %d", credits) )
			stat_label:SetText( string.format("Stat Boost: %d", stat_boost) )
		end )

	end)

	function update_credits_and_stats()
		net.Start("sv_update_credits")
		net.SendToServer()
		net.Start("sv_update_stats")
		net.SendToServer()
	end

	net.Receive( "update_credits", function( len, ply )
		local res = net.ReadInt(32)
		credits = res
	end )
	net.Receive( "update_stats", function( len, ply )
		local res = net.ReadInt(32)
		stat_boost = res
	end )
end

-- NETWORKING
if ( SERVER ) then

	util.AddNetworkString( "purchase_token" )
	util.AddNetworkString( "update_credits" )
	util.AddNetworkString( "update_stats" )
	util.AddNetworkString( "increase_stats" )
	util.AddNetworkString( "decrease_stats" )
	util.AddNetworkString( "sv_update_credits" )
	util.AddNetworkString( "sv_update_stats" )

	net.Receive( "purchase_token", function( len, ply )
		local money = ply:getDarkRPVar("money");
		if (money >= TOKEN_COST) then
			AddCredits(ply, 1)
			ply:addMoney(-TOKEN_COST)
		end
	end )

	net.Receive( "increase_stats", function( len, ply )
		local credits = GetCredits(ply)
		if (credits >= 1) then
			RemoveCredits(ply, 1)
			AddStatBoost(ply, 1)
		end
	end )

	net.Receive( "decrease_stats", function( len, ply )
		local stat_boost = GetStatBoost(ply)
		if (stat_boost >= 1) then
			RemoveStatBoost(ply, 1)
			AddCredits(ply, 1)
		end
	end )
	
	net.Receive( "sv_update_credits", function( len, ply )
		local credits = GetCredits(ply)
		net.Start("update_credits")
			net.WriteInt(credits, 32)
		net.Send(ply)
	end )

	net.Receive( "sv_update_stats", function( len, ply )
		local stat_boost = GetStatBoost(ply)
		net.Start("update_stats")
			net.WriteInt(stat_boost, 32)
		net.Send(ply)
	end )
	
end