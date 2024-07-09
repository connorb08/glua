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
            id = "",
            arrest_number = ""
        }

        local arrested_players_list = {}
        for k,v in pairs(player.GetAll()) do
            if v:isArrested() then
                table.insert(arrested_players_list, v)
            end
        end
        
        local frame = vgui.Create("DFrame")
        frame:SetPos(100, 100)
        frame:SetSize(800, 500)
        frame:SetTitle("Arrest Form")
        frame:MakePopup()
    
        local arrested_players = vgui.Create( "DComboBox", frame )
        arrested_players:SetPos( 25, 50 )
        for k,v in pairs(arrested_players_list) do
            arrested_players:AddChoice(v:Name())
        end
        function arrested_players:OnSelect(index, value)
            arrest_log_data["name"] = value
            arrest_log_data["id"] = arrested_players_list[index]:SteamID64()
        end

        local arrested_players = vgui.Create( "DComboBox", frame )
        arrested_players:SetPos( 25, 100 )
        arrested_players:AddChoice("1st")
        arrested_players:AddChoice("2nd")
        arrested_players:AddChoice("3rd")
        arrested_players:AddChoice("4th")
        function arrested_players:OnSelect(index, value)
            arrest_log_data["arrest_number"] = value
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