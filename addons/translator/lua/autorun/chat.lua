if CLIENT then end

-- CONFIG
local translationReplacementMessage = "[UNKNOWN LANGUAGE]"

local overrideCommands = {
    "/comms",
    "/advert",
    "/y",
    "/w"
}

local ignoreCommands = {
    "/ooc",
    "//",
    ".//",
    "/me",
    "/it",
    "/roll",
    "@"
}

alien_players = alien_players or {}

local function isAlien(ply)
    return table.HasValue(alien_players, ply)
end

local function sendTranslatedMessage(ply, message)
    for _, v in ipairs(player.GetAll()) do
        if v:HasWeapon( "synergy_datapad" ) then
            local message = string.format("[Translated Message] %s: %s", ply:Nick(), message)
            v:ChatPrint(message)
        end
    end
end

hook.Add("PlayerSay", "SynergyAddAlientPlayer", function(ply, text)
    if ply:IsAdmin() then
        local words = {}
        for word in string.gmatch(text, "%S+") do
            table.insert(words, word)
        end
        if words[1] ~= "/alien" then return end
        print("alien called")
        local targetSteamId = string.sub(text, 8)
        local alienPlayer = player.GetBySteamID(targetSteamId)
        if not IsValid(alienPlayer) then
            ply:ChatPrint("Invalid player.")
            return ""
        end
        table.insert(alien_players, alienPlayer)
        ply:ChatPrint("Added " .. alienPlayer:Nick() .. " to the alien list.")
        return ""
    else
        ply:ChatPrint("You are not an admin.")
    end
end)

hook.Add("PlayerSay", "SynergyTranslatePlayerMessage", function(ply, text)

    if not isAlien(ply) then return end

    local words = {}
    for word in string.gmatch(text, "%S+") do
        table.insert(words, word)
    end

    -- Ignore certain commands
    if table.HasValue(ignoreCommands, words[1]) then
        return
    end

    -- Override certain commands
    if table.HasValue(overrideCommands, words[1]) then
        local message = ""
        message = string.format("%s %s", words[1], translationReplacementMessage)
        local originalTranslatedMessage = table.concat(words, " ", 2)
        print(originalTranslatedMessage)
        sendTranslatedMessage(ply, originalTranslatedMessage)
        return message
    end

    -- Translate the message
    sendTranslatedMessage(ply, text)
    return translationReplacementMessage

end)