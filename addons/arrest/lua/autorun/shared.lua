if SERVER then

    util.AddNetworkString( "log_arrest" )
    net.Receive( "log_arrest", function( len, ply )
        local json_string = net.ReadString()
        print(json_string)
        file.Append( "arrest_data.txt", string.format("%s\n", json_string) )
	end )

end

if CLIENT then

    concommand.Add("af", function(ply)

        local arrest_log_data = {
            logger = ply:Name(),
            name = "",
            id = ""
        }
        
        local frame = vgui.Create("DFrame")
        frame:SetPos(100, 100)
        frame:SetSize(800, 500)
        frame:SetTitle("Arrest Form")
        frame:MakePopup()
    
        local arrested_players = vgui.Create( "DComboBox", frame )
        arrested_players:SetPos( 25, 50 )
        for k,v in pairs(player.GetAll()) do
            arrested_players:AddChoice(v:Name())
        end

        function arrested_players:OnSelect(index, value)
            arrest_log_data["name"] = value
            arrest_log_data["id"] = player.GetAll()[index]:SteamID64()
        end

        local submit_button = vgui.Create( "DButton", frame )
        submit_button:SetText( "Submit" )					
		submit_button:SetPos( 25, 150 )					
		submit_button:SetSize( 250, 30 )	
        submit_button.DoClick = function()
            net.Start("log_arrest")
                net.WriteString(util.TableToJSON(arrest_log_data))
            net.SendToServer()
        end
    
    end)

end