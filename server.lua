local dutyTimers = {}

RegisterCommand("clockin", function(source)
    if not IsPlayerAceAllowed(source, "command.clockin") then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'You are not allowed to use /clockin.',
            duration = 5000
        })
        return
    end

    local name = GetPlayerName(source)
    local discordId = GetDiscordId(source)

    if not discordId then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Discord ID not found. Please reconnect with Discord.',
            duration = 5000
        })
        return
    end

    dutyTimers[source] = os.time()
    sendToDiscord(name, "in", discordId)

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = 'You have clocked in.',
        duration = 5000
    })
end)

RegisterCommand("clockout", function(source)
    if not IsPlayerAceAllowed(source, "command.clockout") then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'You are not allowed to use /clockout.',
            duration = 5000
        })
        return
    end

    local name = GetPlayerName(source)
    local discordId = GetDiscordId(source)

    if not discordId then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Discord ID not found. Please reconnect with Discord.',
            duration = 5000
        })
        return
    end

    local startTime = dutyTimers[source]
    local durationText = "Unknown"

    if startTime then
        local seconds = os.time() - startTime
        durationText = FormatDuration(seconds)
        dutyTimers[source] = nil  -- Clear timer after use
    end

    sendToDiscord(name, "out", discordId, durationText)

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = 'You have clocked out.',
        duration = 5000
    })
end)

function sendToDiscord(name, action, discordId, duration)
    local actionText = (action == "in") and "CLOCKED IN" or "CLOCKED OUT"
    local embedColor = (action == "in") and 3066993 or 15158332
    local unixTime = os.time()

    local description = "**<@" .. discordId .. ">** has " .. actionText .. "."

    if action == "out" then
        description = description ..
            "\n\n**Clock-Out Time:** <t:" .. unixTime .. ":F>" ..
            (duration and ("\n**Time on Duty:** " .. duration) or "")
    end

    local embed = {
        {
            ["color"] = embedColor,
            ["title"] = "**Staff " .. actionText .. "**",
            ["description"] = description,
            ["footer"] = {
                ["text"] = Config.FooterText,
            },
            ["thumbnail"] = {
                ["url"] = Config.EmbedImage,
            },
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({
        username = Config.WebhookName,
        avatar_url = Config.WebhookAvatar,
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

function GetDiscordId(src)
    local identifiers = GetPlayerIdentifiers(src)
    for _, id in pairs(identifiers) do
        if string.sub(id, 1, 8) == "discord:" then
            return string.sub(id, 9)
        end
    end
    return nil
end

function FormatDuration(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60

    local output = ""
    if hours > 0 then output = output .. hours .. "h " end
    if mins > 0 then output = output .. mins .. "m " end
    output = output .. secs .. "s"
    return output
end
