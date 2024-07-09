if SERVER then

    util.AddNetworkString("AdminTickets")
    util.AddNetworkString("TakeAdminTicket")

    local admin_tickets = {}
    hook.Add( "PlayerSay", "CreateAdminTicket", function( ply, text )
        if ( string.StartWith( string.lower( text ), "#" ) ) then
            local ticket = string.sub( text, 2 )
            table.insert(admin_tickets, {
                ticket = ticket,
                player = ply:Name(),
                steamid = ply:SteamID64()
            })
            ply:ChatPrint("Ticket created!")
            for k, v in pairs(player.GetAll()) do
                if v:IsAdmin() then
                    v:SendLua(string.format("notification.AddLegacy('New ticket from %s - %s', NOTIFY_GENERIC, 5)", ply:Name(), ticket))
                end
            end
            return ""
        end
    end )

    concommand.Add("admin_tickets", function(ply)
        if not ply:IsAdmin() then 
            ply:ChatPrint("You are not an admin!")
            return 
        end
        net.Start("AdminTickets")
        net.WriteTable(admin_tickets)
        net.Send(ply)
    end)

    net.Receive("TakeAdminTicket", function(len, ply)
        if not ply:IsAdmin() then return end
        local ticket_number = net.ReadInt(32)
        for k, v in pairs(admin_tickets) do
            if k == ticket_number then
                table.remove(admin_tickets, k)
                ply:ChatPrint("Ticket taken!")
                file.Append( "admin_tickets.csv", string.format("%s,%s,%s\n", v.ticket, ply:Name(), ply:SteamID64()) )
                return
            end
        end
    end)

end

if CLIENT then
    
    net.Receive("AdminTickets", function()

        local tickets = net.ReadTable()
    
        local frame = vgui.Create("DFrame")
        frame:SetSize(500, 500)
        frame:Center()
        frame:SetTitle("Admin Tickets")
        frame:MakePopup()

        local list = vgui.Create("DListView", frame)
        list:Dock(FILL)
        list:AddColumn("Ticket")
        list:AddColumn("Player")
        list:AddColumn("SteamID")

        for k, v in pairs(tickets) do
            list:AddLine(v.ticket, v.player, v.steamid)
        end

        function list:DoDoubleClick( lineID, line )
            net.Start("TakeAdminTicket")
            net.WriteInt(lineID, 32)
            net.SendToServer()
            frame:Close()
        end
        
    end)

end
