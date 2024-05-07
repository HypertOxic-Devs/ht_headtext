local Config = require 'config'

local function string_split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

local function getCommand(commandName)
    for i = 1, #Config do
        local command = Config[i]
        if command.name == commandName then
            return command
        end
    end
    return {}
end

local function onCommand(source, args, raw)
    local src = source
    local command = getCommand(string_split(raw, " ")[1])
    local text = "* " .. command.prefix .. " " .. table.concat(args, " ") .. " *"
    local nearbyPlayers = lib.getNearbyPlayers(GetEntityCoords(GetPlayerPed(src)), command.dist, true)

    for i = 1, #nearbyPlayers do
        local nearbyPlayer = nearbyPlayers[i]
        TriggerClientEvent('ht_3dme:client:displayText', nearbyPlayer.id, text, src, command)
    end
end

local function init()
    for i = 1, #Config do
        local command = Config[i]

        lib.addCommand(command.name, {
            help = command.description,
        }, onCommand)
    end
end

AddEventHandler('onResourceStart', init)
