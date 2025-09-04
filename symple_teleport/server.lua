local QBCore = exports['qb-core']:GetCoreObject()

--- Checks if a player is a police officer and currently on duty.
-- @param source The player's server ID.
-- @return boolean True if the player is police and on duty, false otherwise.
local function IsPlayerPoliceOnDuty(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then
        return false
    end

    if not Player.PlayerData or not Player.PlayerData.job then
        return false
    end

    local job = Player.PlayerData.job
    return job.name == "police" and job.onduty == true
end

-- Event handler for when a player is joining the server.
-- It waits for a short period to ensure player data is loaded before checking job status.
AddEventHandler('playerJoining', function()
    local src = source -- Capture the source from the event for use in the thread

    Citizen.CreateThread(function()
        Citizen.Wait(5000) -- Wait for QBCore to potentially load player data

        -- It's possible the player disconnected during the wait
        local player = QBCore.Functions.GetPlayer(src)
        if not player then
            return
        end

        local onDuty = IsPlayerPoliceOnDuty(src)
        TriggerClientEvent('updatePoliceStatus', src, onDuty)
    end)
end)

-- Event handler for when a player's job is updated (e.g., going on/off duty, changing job).
RegisterNetEvent('QBCore:Server:OnJobUpdate', function(source, job)
    -- Ensure source and job data are valid before proceeding
    if not source or not job or not job.name or job.onduty == nil then
        return
    end

    local isPoliceOnDuty = job.name == "police" and job.onduty == true
    TriggerClientEvent('updatePoliceStatus', source, isPoliceOnDuty)
end)