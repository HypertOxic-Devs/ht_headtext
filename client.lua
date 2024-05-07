local peds = {}

--- Draw text in 3d
---@param coords vector3 world coordinates to where you want to draw the text
---@param text string the text to display
---@param command table the command data
local function draw3dText(coords, text, command)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)

    -- Experimental math to scale the text down
    local scale = 200 / (GetGameplayCamFov() * dist)

    -- Format the text
    SetTextColour(command.color.r, command.color.g, command.color.b, command.color.a)
    SetTextScale(0.0, command.scale * scale)
    SetTextFont(command.font)
    SetTextDropshadow(0, 0, 0, 0, 0)
    SetTextDropShadow()
    SetTextCentre(true)

    -- Diplay the text
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

--= Display the text above the head of a ped
--- @param ped number the target ped
--- @param text string the text to display
--- @param command table the command data
local function displayText(ped, text, command)
    local playerPed = PlayerPedId()
    local los = HasEntityClearLosToE
    ntity(playerPed, ped, 17)

    if los then
        local exists = peds[ped] ~= nil

        peds[ped] = {
            time = GetGameTimer() + command.time,
            text = text
        }

        if not exists then
            local display = true

            while display do
                Wait(0)
                local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.0)
                draw3dText(pos, peds[ped].text, command)
                display = GetGameTimer() <= peds[ped].time
            end

            peds[ped] = nil
        end
    end
end

-- Register the event
RegisterNetEvent('ht_3dme:client:displayText', function(text, target, command)
    local player = GetPlayerFromServerId(target)
    if player ~= -1 or target == GetPlayerServerId(PlayerId()) then
        local ped = GetPlayerPed(player)
        displayText(ped, text, command)
    end
end)
