-- Function to trim quotes from a string
local function trimQuotes(str)
    return str:gsub('^"%s*(.-)%s*"$', '%1')  -- Remove leading and trailing quotes
end

-- Function to open a Derma panel with arrest records data
local function openArrestRecordsPanel(arrest_records)
    -- Create the main frame
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Arrest Records (Today)")
    frame:SetSize(600, 450)  -- Increased height for search bar
    frame:Center()
    frame:MakePopup()

    -- Create a search bar
    local searchBox = vgui.Create("DTextEntry", frame)
    searchBox:Dock(TOP)
    searchBox:SetPlaceholderText("Search by SteamID...")
    searchBox:DockMargin(5, 5, 5, 0)  -- Add margin for better appearance

    -- Create a DListView to show the records
    local listView = vgui.Create("DListView", frame)
    listView:Dock(FILL)
    listView:SetMultiSelect(false)

    -- Add columns (modify these based on your CSV structure)
    listView:AddColumn("Date")
    listView:AddColumn("Name")
    listView:AddColumn("Arrest Number")
    listView:AddColumn("Steam ID")
    listView:AddColumn("Crime")

    -- Function to populate the list view with data
    local function populateListView(filter)
        listView:Clear()  -- Clear previous entries

        -- Check if arrest_records is not empty
        if #arrest_records == 0 then
            listView:AddLine("No records found for today.")
            return
        end

        -- Populate the ListView with filtered data
        for i, record in ipairs(arrest_records) do
            if #record >= 8 then
                -- Trim quotes from each value
                local date = trimQuotes(record[1])
                local name = trimQuotes(record[4])
                local arrestNumber = trimQuotes(record[6])
                local steamID = trimQuotes(record[7])
                local crime = trimQuotes(record[8])

                -- Check if SteamID matches the filter (case-insensitive)
                if filter == "" or string.find(steamID:lower(), filter:lower()) then
                    listView:AddLine(date, name, arrestNumber, steamID, crime)
                end
            else
                print("Record has insufficient columns: ", table.concat(record, ", "))
            end
        end
    end

    -- Populate the list view initially
    populateListView("")

    -- Update the list view based on search input
    searchBox.OnChange = function(self)
        local filter = self:GetValue()  -- Get the current text in the search box
        populateListView(filter)  -- Populate the list view with filtered data
    end
end

-- Listen for the net message from the server
net.Receive("OpenArrestRecordsPanel", function()
    -- Read the arrest_records table sent by the server
    local arrest_records = net.ReadTable()

    -- Open the Derma panel with the received data
    openArrestRecordsPanel(arrest_records)
end)
