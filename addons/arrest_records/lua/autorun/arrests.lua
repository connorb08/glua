local arrest_records = arrest_records or {}

local sheet_id = "1vwNk5mgzFhTBA1wDsBV4lOXZ21__Wn0rfBj3epNM56A"
local gid = "1803919369"
local url1 = string.format("https://docs.google.com/spreadsheets/d/%s/gviz/tq?tqx=out:csv&gid=%s", sheet_id, gid)

-- Function to parse CSV data and filter records from the past day
local function parseCSV(body)
    local records = {}
    local one_day_ago = os.time() - (24 * 60 * 60) -- Current time minus one day in seconds

    for line in string.gmatch(body, "([^\n]*)\n?") do
        local row = {}
        for value in string.gmatch(line, '([^,]+)') do
            table.insert(row, value)
        end

        if #row > 0 then
            -- Assume the date is in the first column (row[1])
            local date_str = row[1] -- Get the date string
            local month, day, year, hour, minute, second = date_str:match("(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)")
            
            if month and day and year then
                -- Create a timestamp for the date
                local record_date = os.time({
                    year = tonumber(year),
                    month = tonumber(month),
                    day = tonumber(day),
                    hour = tonumber(hour),
                    min = tonumber(minute),
                    sec = tonumber(second)
                })

                -- Only include records from the past day
                if record_date >= one_day_ago then
                    table.insert(records, row)
                end
            end
        end
    end
    return records
end

-- Function to handle the CSV data
local function handleCSV(body, length, headers, code)
    if code == 200 then
        -- Parse the CSV data and load it into arrest_records
        arrest_records = parseCSV(body)
        print("Filtered CSV data loaded into arrest_records table")
        -- Optionally save CSV data to a file for reference
        -- file.Write("google_sheet.csv", body)
    else
        print("Failed to fetch the CSV data. HTTP code: " .. code)
    end
end

-- Function to handle errors
local function handleError(error)
    print("Error occurred while fetching CSV data: " .. error)
end

-- Function to fetch the CSV data from the Google Sheet
local function fetchCSVData()
    http.Fetch(url1, handleCSV, handleError)
end

-- Hook to listen for chat commands
hook.Add("PlayerSay", "HandleArrestRecordsCommand", function(ply, text)
    if string.lower(text) == "/arrests" then
        -- Send arrest records data to the client
        fetchCSVData()
        net.Start("OpenArrestRecordsPanel")
        net.WriteTable(arrest_records)  -- Send the filtered table
        net.Send(ply)
        return "" -- Prevent the message from being sent in chat
    end
end)

-- Make sure to initialize the net message
util.AddNetworkString("OpenArrestRecordsPanel")
